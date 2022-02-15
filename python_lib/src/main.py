import ok.ok as ok
import okaertool as okt
from pyNAVIS import *

# 64 Channels,  Stereo, 16 bits address, recorded using jAER
NUM_CHANNELS = 64
BIN_SIZE = 20000
SETTINGS = MainSettings(num_channels=NUM_CHANNELS, mono_stereo=1, on_off_both=1, address_size=2, ts_tick=1,
                        bin_size=BIN_SIZE)


device = ok.okCFrontPanel()
# device.OpenBySerial("")
device_count = device.GetDeviceCount()
for idx in range(device_count):
    print(f"Device[{idx}] Model: {device.GetDeviceListModel(idx)}")

BIT_FILE = '/home/arios/Projects/okaertool/okt_top.bit'
ok = okt.Okaertool(bit_file=BIT_FILE)
ok.init()
ok.select_inputs(inputs=['Port_A'])
spikes = ok.monitor(buffer_length=(1*1024*1024))

Plots.spikegram(spikes[0], settings=SETTINGS)
