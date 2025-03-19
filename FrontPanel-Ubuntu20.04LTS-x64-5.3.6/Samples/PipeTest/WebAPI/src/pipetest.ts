import {
    FrontPanelSampleAppBase,
    frontpanelWs
} from '@opalkelly/frontpanel-samples-common';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.css';
import $ from 'jquery';

// Define pattern names.
const OK_PATTERN_COUNT = 0;
const OK_PATTERN_LFSR = 1;
const OK_PATTERN_WALKING1 = 2;
const OK_PATTERN_WALKING0 = 3;
const OK_PATTERN_HAMMER = 4;
const OK_PATTERN_NEIGHBOR = 5;
const OK_PATTERN_FIXED = 6;

interface IState {
    pattern: number;
    segmentSize: number;
    throttleIn: number;
    throttleOut: number;
    fixedPattern: number;
    check: boolean;
    injectError: boolean;
    transferSize: number;
    blockSize: number;
    isUSB3: boolean;
    pipeWidth: number;
}

function formatSpeed(bps: number): string {
    const i = Math.floor(Math.log(bps) / Math.log(1000));
    const units = ['Bps', 'kBps', 'MBps', 'GBps', 'TBps'];
    return (bps / Math.pow(1000, i)).toFixed(1) + ' ' + units[i];
}

// Sets the reset state of the pattern generator based on the
// selected pattern.
function patternReset(state: IState): number[] {
    if (state.pattern === OK_PATTERN_COUNT) {
        return [0x00000001, 0x00000001];
    } else if (state.pattern === OK_PATTERN_FIXED) {
        return [state.fixedPattern, state.fixedPattern];
    }
    return [0x00000000, 0x00000000];
}

// Computes the next word in the data pattern based on the
// selected pattern.
function patternNext(wordH: number, wordL: number, state: IState) {
    let nextWordH = wordH;
    let nextWordL = wordL;

    if (state.pattern === OK_PATTERN_COUNT) {
        nextWordH = wordH + 1;
        nextWordL = wordL + 1;
    }

    return [nextWordH, nextWordL];
}

// Generates a buffer of data following the selected data pattern
// and word width.
function generateData(byteCount: number, state: IState) {
    const valid = new Uint8Array(byteCount);
    let [wordH, wordL] = patternReset(state);

    if (64 === state.pipeWidth) {
        for (let i = 0; i < byteCount / 8; i++) {
            valid[i * 8 + 0] = (wordL >> 0) & 0xff;
            valid[i * 8 + 1] = (wordL >> 8) & 0xff;
            valid[i * 8 + 2] = (wordL >> 16) & 0xff;
            valid[i * 8 + 3] = (wordL >> 24) & 0xff;
            valid[i * 8 + 4] = (wordH >> 0) & 0xff;
            valid[i * 8 + 5] = (wordH >> 8) & 0xff;
            valid[i * 8 + 6] = (wordH >> 16) & 0xff;
            valid[i * 8 + 7] = (wordH >> 24) & 0xff;
            [wordH, wordL] = patternNext(wordH, wordL, state);
        }
    } else if (32 === state.pipeWidth) {
        for (let i = 0; i < byteCount / 4; i++) {
            valid[i * 4 + 0] = (wordL >> 0) & 0xff;
            valid[i * 4 + 1] = (wordL >> 8) & 0xff;
            valid[i * 4 + 2] = (wordL >> 16) & 0xff;
            valid[i * 4 + 3] = (wordL >> 24) & 0xff;
            [wordH, wordL] = patternNext(wordH, wordL, state);
        }
    } else if (16 === state.pipeWidth) {
        for (let i = 0; i < byteCount / 2; i++) {
            valid[i * 2 + 0] = (wordL >> 0) & 0xff;
            valid[i * 2 + 1] = (wordL >> 8) & 0xff;
            [wordH, wordL] = patternNext(wordH, wordL, state);
        }
    } else if (8 === state.pipeWidth) {
        for (let i = 0; i < byteCount; i++) {
            valid[i] = wordL & 0xff;
            [wordH, wordL] = patternNext(wordH, wordL, state);
        }
    }

    // Inject errors (optional).
    if (state.injectError) {
        valid[7] = ~valid[7];
    }

    return valid;
}

function checkData(buffer: Uint8Array, valid: Uint8Array): number {
    return buffer.reduce((count, val, i) => {
        return val === valid[i] ? count : count + 1;
    }, 0);
}

async function transfer(
    app: FrontPanelSampleAppBase,
    isWrite: boolean,
    state: IState
) {
    await app.fp.updateWireOuts();
    if (
        (app.fp.getWireOutValue(0x3e) & 0x1) !== 0x1 &&
        state.pattern === OK_PATTERN_FIXED
    ) {
        app.log(
            'Fixed pattern is not supported by this bitstream. Switching to Count.'
        );
        state.pattern = OK_PATTERN_COUNT;
    }

    // Only COUNT and LFSR are supported on non-USB3 devices.
    if (
        !state.isUSB3 &&
        (state.pattern === OK_PATTERN_WALKING0 ||
            state.pattern === OK_PATTERN_WALKING1 ||
            state.pattern === OK_PATTERN_HAMMER ||
            state.pattern === OK_PATTERN_NEIGHBOR)
    ) {
        app.log('Unsupported pattern for device type. Switching to Count.');
        state.pattern = OK_PATTERN_COUNT;
    }

    const reset = async (isSetThrottle: boolean) => {
        let settingsReset1;
        let settingsReset0;
        if (state.isUSB3) {
            // PATTERN | SET_THROTTLE   | RESET=1.
            settingsReset1 =
                (state.pattern << 2) | ((isSetThrottle ? 1 : 0) << 1) | 1;
            // PATTERN | SET_THROTTLE=0 | RESET=0.
            settingsReset0 = (state.pattern << 2) | (0 << 1) | 0;
            // Apply fixed pattern.
            app.fp.setWireInValue(0x03, state.fixedPattern);
        } else {
            const LFSR = state.pattern === OK_PATTERN_LFSR ? 1 : 0;
            // SET_THROTTLE   | MODE=LFSR | RESET=1
            settingsReset1 =
                ((isSetThrottle ? 1 : 0) << 5) | (LFSR << 4) | (1 << 2);
            // SET_THROTTLE=0 | MODE=LFSR | RESET=0
            settingsReset0 = (0 << 5) | (LFSR << 4) | (0 << 2);
        }
        if (isSetThrottle) {
            // Pipe In throttle.
            app.fp.setWireInValue(0x02, state.throttleIn);
            // Pipe Out throttle.
            app.fp.setWireInValue(0x01, state.throttleOut);
        }
        app.fp.setWireInValue(0x00, settingsReset1);
        await app.fp.updateWireIns();
        app.fp.setWireInValue(0x00, settingsReset0);
        await app.fp.updateWireIns();
    };

    const generatedData = generateData(state.segmentSize, state);

    await reset(true);

    let totalTime = 0;
    let remaining = state.transferSize;
    while (remaining > 0) {
        const segmentSize = Math.min(state.segmentSize, remaining);
        remaining = remaining - segmentSize;

        await reset(false);
        const valid = generatedData.subarray(0, segmentSize);

        const tStart = performance.now();
        let buffer: Uint8Array | null = null;
        if (isWrite) {
            if (0 === state.blockSize) {
                await app.fp.writeToPipeIn(0x80, valid);
            } else {
                await app.fp.writeToBlockPipeIn(0x80, state.blockSize, valid);
            }
        } else {
            if (0 === state.blockSize) {
                buffer = await app.fp.readFromPipeOut(0xa0, segmentSize);
            } else {
                buffer = await app.fp.readFromBlockPipeOut(
                    0xa0,
                    state.blockSize,
                    segmentSize
                );
            }
        }
        totalTime += performance.now() - tStart;

        if (state.check) {
            if (buffer !== null) {
                const errorsCount = checkData(buffer, valid);
                $('#inputReadErrors').val(errorsCount);
            } else {
                await app.fp.updateWireOuts();
                const errorsCount = app.fp.getWireOutValue(0x21);
                $('#inputWriteErrors').val(errorsCount);
            }
        }
    }
    return totalTime;
}

$(window).on('load', async () => {
    const state: Required<IState> = {
        pattern: OK_PATTERN_COUNT,
        segmentSize: 4 * 1024 * 1024,
        throttleIn: 0xffffffff,
        throttleOut: 0xffffffff,
        fixedPattern: 0,
        check: true,
        injectError: false,
        transferSize: 0xffffffff,
        blockSize: 0,
        isUSB3: false,
        pipeWidth: 8
    };

    const app = new FrontPanelSampleAppBase({ useBitfile: true });
    app.onDisconnect = async () => {
        $('#containerPipeTest').hide();
    };
    app.onConfigure = async () => {
        const info = await app.fp.getDeviceInfo();
        state.isUSB3 =
            info.deviceInterface ===
            frontpanelWs.DeviceInterface.INTERFACE_USB3;
        state.pipeWidth = info.pipeWidth;

        $('#containerPipeTest').show();
    };

    $('#containerPipeTest').hide();

    app.bindClickButton(
        '#buttonReadFromPipeOut',
        async () => {
            $('#inputReadErrors').text('0');
            $('#inputReadSpeed').val('...');
            state.injectError = $('#errorInjection').val() === '1';
            state.throttleOut = parseInt(
                '0x' + $('#inputThrottleOut').val(),
                16
            );
            state.transferSize = parseInt(
                '0x' + $('#inputReadLength').val(),
                16
            );

            app.log('Reading...');
            const ms = await transfer(app, false, state);
            app.log('Done.');
            $('#inputReadSpeed').val(
                formatSpeed((1000 * state.transferSize) / ms)
            );
        },
        { disabledWhileHandling: true }
    );
    app.bindClickButton(
        '#buttonWriteToPipeIn',
        async () => {
            $('#inputWriteErrors').val('0');
            $('#inputWriteSpeed').val('...');
            state.injectError = $('#errorInjection').val() === '1';
            state.throttleIn = parseInt('0x' + $('#inputThrottleIn').val(), 16);
            state.transferSize = parseInt(
                '0x' + $('#inputWriteLength').val(),
                16
            );

            app.log('Writing...');
            const ms = await transfer(app, true, state);
            app.log('Done.');
            $('#inputWriteSpeed').val(
                formatSpeed((1000 * state.transferSize) / ms)
            );
        },
        { disabledWhileHandling: true }
    );
});
