from tkinter import filedialog

import AERzip
import matplotlib.pyplot as plt
import numpy as np


def plot_sonogram(addresses, timestamps, sonogram_plot_path=None):
    new_timestamps = timestamps / 10**8  # Convert timestamps to seconds

    # ---- time normalization ----
    t_min = np.min(new_timestamps)
    t = new_timestamps - t_min

    # ---- fixed resolution (important for performance stability) ----
    n_bins = 500
    max_timestamp = np.max(new_timestamps)
    duration = max_timestamp - t_min
    bin_size = duration / n_bins if duration > 0 else 1.0
    inv_bin = 1.0 / bin_size

    # ---- binning (vectorized) ----
    bin_idx = np.minimum((t * inv_bin).astype(np.int32), n_bins - 1)
    bin_start_times = t_min + np.arange(n_bins) * bin_size

    # ---- number of channels ----
    n_addr = int(np.max(addresses)) + 1

    # ---- FASTEST PATH: bincount flattening ----
    flat_idx = addresses * n_bins + bin_idx
    sonogram = np.bincount(
        flat_idx,
        minlength=n_addr * n_bins
    ).reshape(n_addr, n_bins)

    # ---- plot ----
    fig, ax = plt.subplots()

    im = ax.imshow(
        sonogram,
        aspect="auto",
        origin="lower",
        cmap="hot",
        extent=[
            bin_start_times[0],
            bin_start_times[-1] + bin_size,
            0,
            n_addr - 1]
    )

    ax.set_xlabel("Time (s)")
    ax.set_ylabel("Address")
    ax.set_title("Spectogram")

    plt.colorbar(im, ax=ax)
    plt.tight_layout()
    if sonogram_plot_path:
        fig.savefig(sonogram_plot_path)


# Select the compressed aedat file to be plotted
compressed_file_path = filedialog.askopenfilename(
    title="Select a compressed aedat file",
    filetypes=[("Compressed aedat files", "*.aedat")],
)
if not compressed_file_path:
    raise SystemExit("No file selected.")

# Load the compressed file and plot its sonogram
addresses, timestamps = AERzip.loadCompressedFile(compressed_file_path)
plot_sonogram(np.asarray(addresses), np.asarray(timestamps))
plt.show()
