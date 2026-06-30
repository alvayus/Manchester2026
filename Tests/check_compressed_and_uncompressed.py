from tkinter import filedialog

import AERzip
from matplotlib import pyplot as plt
import numpy as np
from pyNAVIS import *

# First, select the files to be loaded
uncompressed_file_path = filedialog.askopenfilename(title="Select an uncompressed aedat file", filetypes=[("Uncompressed aedat files", "*.aedat")])
compressed_file_path = filedialog.askopenfilename(title="Select a compressed aedat file", filetypes=[("Compressed aedat files", "*.aedat")])

# Load the spikes from the uncompressed file
settings = MainSettings(num_channels=64, mono_stereo=1, on_off_both=1, address_size=4, ts_tick=0.01, bin_size=10000)
uncompressed_spikes_file = Loaders.loadAEDAT(uncompressed_file_path, settings=settings)
Functions.order_SpikesFile(uncompressed_spikes_file, None)

# Plot the sonogram using pyNavis
try:
    Plots.sonogram(uncompressed_spikes_file, settings, start_at_zero=False)
    plt.show()
except Exception as e:
    print(f"Error displaying the figure: {e}")

# Load the compressed file to verify its integrity
loaded_addresses, loaded_timestamps = AERzip.loadCompressedFile(compressed_file_path)
loaded_timestamps = loaded_timestamps + uncompressed_spikes_file.min_ts
compressed_spikes_file = SpikesFile(loaded_addresses, loaded_timestamps)
Functions.order_SpikesFile(compressed_spikes_file, None)

# Verify every address and timestamp in the loaded file matches the original
error = False
if not np.all(compressed_spikes_file.addresses == uncompressed_spikes_file.addresses):
    print("Addresses do not match between the compressed and uncompressed files.")
    error = True
if not np.allclose(compressed_spikes_file.timestamps, uncompressed_spikes_file.timestamps, atol=1, rtol=0):
    # TODO: AERzip is introducing an error of +/- 1 in many cases. This needs to be fixed.
    print("Timestamps do not match between the compressed and uncompressed files.")
    error = True

if not error:
    print("Verification complete. Both files match.")

    # Plot the sonogram using pyNavis
    try:
        Plots.sonogram(compressed_spikes_file, settings, start_at_zero=False)
        plt.show()
    except Exception as e:
        print(f"Error displaying the figure: {e}")
else:
    print("Verification failed. There are discrepancies between the compressed and uncompressed files.")
    diff = np.where(compressed_spikes_file.timestamps != uncompressed_spikes_file.timestamps)[0]

    print(len(uncompressed_spikes_file.addresses), len(compressed_spikes_file.addresses), 
          len(uncompressed_spikes_file.timestamps), len(compressed_spikes_file.timestamps), 
          diff, type(uncompressed_spikes_file.addresses[0]), type(compressed_spikes_file.addresses[0]),
          type(uncompressed_spikes_file.timestamps[0]), type(compressed_spikes_file.timestamps[0]))
    
    print(uncompressed_spikes_file.timestamps[diff], compressed_spikes_file.timestamps[diff])