from tkinter import filedialog

import AERzip
from matplotlib import pyplot as plt
import numpy as np
from pyNAVIS import *

# First, select the file to be loaded
spikes_file_path = filedialog.askopenfilename(title="Select a compressed aedat file", filetypes=[("Compressed aedat files", "*.aedat")])

# Load the spikes from the selected file
settings = MainSettings(num_channels=64, mono_stereo=1, on_off_both=1, address_size=4, ts_tick=0.01, bin_size=10000)
spikes_file = Loaders.loadAEDAT(spikes_file_path, settings=settings)
Functions.order_SpikesFile(spikes_file, None)

# Plot the sonogram using pyNavis
try:
    Plots.sonogram(spikes_file, settings, start_at_zero=False)
    plt.show()
except Exception as e:
    print(f"Error displaying the figure: {e}")

# Save and load a compressed file to verify the integrity of the saved compressed file
compressed_spikes_path = filedialog.asksaveasfilename(title="Save compressed aedat file", defaultextension=".aedat", filetypes=[("Compressed aedat files", "*.aedat")])
AERzip.saveCompressedFile(spikes_file.addresses, spikes_file.timestamps, compressed_spikes_path, overwrite=True)
loaded_addresses, loaded_timestamps = AERzip.loadCompressedFile(compressed_spikes_path)
loaded_timestamps = loaded_timestamps + spikes_file.min_ts
loaded_spikes_file = SpikesFile(loaded_addresses, loaded_timestamps)
Functions.order_SpikesFile(loaded_spikes_file, None)

# Verify every address and timestamp in the loaded file matches the original
error = False
if not np.array_equal(loaded_spikes_file.addresses, spikes_file.addresses):
    print("Addresses do not match between the original and loaded files.")
    error = True
if not np.array_equal(loaded_spikes_file.timestamps, spikes_file.timestamps):
    print("Timestamps do not match between the original and loaded files.")
    error = True
if not error:
    print("Verification complete. The loaded compressed file matches the original.")
else:
    print("Verification failed. There are discrepancies between the original and loaded files.")
    diff = np.where(loaded_spikes_file.addresses != spikes_file.addresses)[0]
    print(len(loaded_spikes_file.addresses), len(spikes_file.addresses), 
          len(loaded_spikes_file.timestamps), len(spikes_file.timestamps), 
          len(diff), type(loaded_spikes_file.addresses[0]), type(spikes_file.addresses[0]),
          type(loaded_spikes_file.timestamps[0]), type(spikes_file.timestamps[0]))

# Plot the sonogram using pyNavis
try:
    Plots.sonogram(loaded_spikes_file, settings, start_at_zero=False)
    plt.show()
except Exception as e:
    print(f"Error displaying the figure: {e}")