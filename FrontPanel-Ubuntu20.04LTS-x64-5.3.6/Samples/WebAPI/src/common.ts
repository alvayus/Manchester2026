import * as frontpanelWs from '@opalkelly/frontpanel-ws';
import 'bootstrap';
import $ from 'jquery';
export { frontpanelWs };

interface IConstructorOptions {
    useBitfile?: boolean;
}

interface IBindClickButtonOptions {
    disabledWhileHandling?: boolean;
}

export class FrontPanelSampleAppBase extends frontpanelWs.FrontPanelWebAppBase {
    private _useBitfile: boolean;

    constructor(options?: IConstructorOptions) {
        super();

        this._useBitfile = !!options?.useBitfile;

        $(window).on('error', (evt: any) => {
            this.log('Run-time error: ' + JSON.stringify(evt));
            return false;
        });

        $('#modalConnect').modal('show');
        if (this._useBitfile) {
            $('#containerBitfile').hide();
        }

        // GUI event handlers.
        this.bindClickButton(
            '#buttonConnect',
            async () => {
                const server = $('#inputServer').val() as string;
                const username = $('#inputUsername').val() as string;
                const password = $('#inputPassword').val() as string;

                await this.connectAndLogin(server, username, password);

                this.log(`Opened connection to "${server}"`);

                // The server loop.
                this.repeatWhile(
                    () => {
                        return this.isConnected;
                    },
                    async () => {
                        await this.processServerNotifications();
                    },
                    100
                );
            },
            { disabledWhileHandling: true }
        );

        if (this._useBitfile) {
            this.bindClickButton(
                '#buttonConfigure',
                async () => {
                    if (this.devices.length === 0) {
                        throw new Error('No devices available');
                    }

                    const file = $('#inputBitfile').prop('files')[0];
                    const device = this.devices[0];

                    this.log(`Opening the first device "${device}"...`);

                    await this.configure(this.devices[0], file);

                    $('#containerBitfile').hide();
                    $('#containerCounters').show();
                },
                { disabledWhileHandling: true }
            );
        }

        this.bindClickButton('#buttonStatus', async () => {
            if (this.isConnected) {
                await this.disconnect();
                this.log('Closed connection');
            } else {
                $('#modalConnect').modal('show');
            }
        });
    }

    public bindClickButton(
        name: string,
        onclick: () => Promise<void>,
        options?: IBindClickButtonOptions
    ): void {
        const disabledWhileHandling = options && options.disabledWhileHandling;
        const button = $(name);
        button.click(async () => {
            if (disabledWhileHandling) {
                button.addClass('disabled');
            }

            await this.callAndCheckErrors(onclick);

            if (disabledWhileHandling) {
                button.removeClass('disabled');
            }
            return false;
        });
    }

    public bindPushButton(
        name: string,
        ondown: () => Promise<void>,
        onup: () => Promise<void>
    ): void {
        $(name)
            .mousedown(async () => {
                await this.callAndCheckErrors(ondown);
                return false;
            })
            .mouseup(async () => {
                await this.callAndCheckErrors(onup);
                return false;
            });
    }

    public bindCheckbox(
        name: string,
        oncheck: (checked: boolean) => Promise<void>
    ): void {
        const checkbox = $(name);
        checkbox.click(async () => {
            const checked = checkbox.is(':checked');
            await this.callAndCheckErrors(async () => {
                oncheck(checked);
            });
            return false;
        });
    }

    public log(text: string): void {
        $('#logWindow')
            .append(document.createTextNode(text))
            .append(document.createElement('br'));
    }

    protected _processError(e: any): void {
        this.log(e);

        // Disconnect on any error.
        this.disconnect();
    }

    protected async _updateConnectionStatus(): Promise<void> {
        if (this.isConnected) {
            $('#modalConnect').modal('hide');
            if (this._useBitfile) {
                $('#containerBitfile').show();
            }
        } else {
            $('#modalConnect').modal('show');
            if (this._useBitfile) {
                $('#containerBitfile').hide();
            }
            $('#containerCounters').hide();
        }
        $('#connectionStatus').text(
            this.isConnected ? `Connected to ${this.server}` : 'Disconnected'
        );
        $('#buttonStatus').text(this.isConnected ? 'Disconnect' : 'Connect');
    }
}
