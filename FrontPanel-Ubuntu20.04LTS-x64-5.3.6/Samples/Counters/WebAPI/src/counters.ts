import { FrontPanelSampleAppBase } from '@opalkelly/frontpanel-samples-common';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.css';
import $ from 'jquery';

function logTriggerEvent(text: string): void {
    $('#triggerEventsWindow')
        .append(document.createTextNode(text))
        .append(document.createElement('br'));
}

function formatHex(val: number): string {
    // Format like '%02x'
    return ('0' + val.toString(16)).substr(-2);
}

$(window).on('load', async () => {
    const app = new FrontPanelSampleAppBase({ useBitfile: true });
    app.onDisconnect = async () => {
        $('#containerCounters').hide();
    };
    app.onConfigure = async () => {
        $('#containerCounters').show();

        // The device loop.
        app.repeatWhile(
            () => {
                return !!app.configuredDevice;
            },
            async () => {
                await app.fp.updateAllOuts();

                $('#counter1').text(formatHex(app.fp.getWireOutValue(0x20)));
                $('#counter2').text(formatHex(app.fp.getWireOutValue(0x21)));

                if (app.fp.isTriggered(0x60, 1 << 0)) {
                    logTriggerEvent('Triggered: Counter 1 == 0x00');
                }
                if (app.fp.isTriggered(0x60, 1 << 1)) {
                    logTriggerEvent('Triggered: Counter 1 == 0x80');
                }
                if (app.fp.isTriggered(0x61, 1 << 0)) {
                    logTriggerEvent('Triggered: Counter 2 == 0x00');
                }
            },
            100
        );
    };

    $('#containerCounters').hide();

    // Counter 1.
    app.bindPushButton(
        '#buttonReset1',
        async () => {
            app.fp.setWireInValue(0x00, 0xffffffff, 1 << 0);
            await app.fp.updateWireIns();
        },
        async () => {
            app.fp.setWireInValue(0x00, 0x00000000, 1 << 0);
            await app.fp.updateWireIns();
        }
    );
    app.bindPushButton(
        '#buttonDisable1',
        async () => {
            app.fp.setWireInValue(0x00, 0xffffffff, 1 << 1);
            await app.fp.updateWireIns();
        },
        async () => {
            app.fp.setWireInValue(0x00, 0x00000000, 1 << 1);
            await app.fp.updateWireIns();
        }
    );

    // Counter 2.
    app.bindCheckbox('#checkboxAutocount2', async (checked: boolean) => {
        const value = checked ? 0xffffffff : 0x00000000;
        app.fp.setWireInValue(0x00, value, 1 << 2);
        await app.fp.updateWireIns();
    });
    app.bindClickButton('#buttonReset2', async () => {
        await app.fp.activateTriggerIn(0x40, 0);
    });
    app.bindClickButton('#buttonUp2', async () => {
        await app.fp.activateTriggerIn(0x40, 1);
    });
    app.bindClickButton('#buttonDown2', async () => {
        await app.fp.activateTriggerIn(0x40, 2);
    });
});
