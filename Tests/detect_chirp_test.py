import os
from tkinter import Tk, filedialog

import matplotlib.pyplot as plt
import numpy as np
import soundfile as sf
from scipy.signal import correlate


def cross_correlate(recorded_signal, chirp_signal, mode="full", plot=False):
    # FFT-based correlation is usually much faster for long signals.
    correlation = correlate(recorded_signal, chirp_signal, mode=mode, method="fft")

    # Find the index of the maximum correlation value.
    max_corr_index = np.argmax(correlation)

    # Calculate the start index of the chirp in the recorded signal.
    chirp_start_index = max_corr_index - len(chirp_signal) + 1

    if plot:
        plt.plot(correlation)
        plt.show()

    return chirp_start_index


def find_chirp_start_index(recording_file_path, chirp_file_path, plot=False):
    # Load the recorded signal
    recorded_signal, recorded_sample_rate = sf.read(recording_file_path)
    chirp_signal, chirp_sample_rate = sf.read(chirp_file_path)

    recorded_signal = np.asarray(recorded_signal)
    if recorded_signal.ndim == 1:
        recorded_signal = recorded_signal[:, np.newaxis]

    chirp_signal = np.asarray(chirp_signal)
    if chirp_signal.ndim > 1:
        chirp_signal = chirp_signal[:, 0]

    chirp_signal = chirp_signal * np.max(np.abs(recorded_signal))

    starts = []
    for i in range(recorded_signal.shape[1]):
        starts.append(cross_correlate(recorded_signal[:, i], chirp_signal))

    mean_start = int(np.mean(starts))
    fig, ax = plt.subplots(3)
    ax[0].plot(recorded_signal[:, 0])
    ax[1].plot(chirp_signal)
    ax[1].set_xlim(0, recorded_signal.shape[0])
    ax[1].plot(recorded_signal[mean_start:, 0], color="r")

    if plot:
        plt.show()

    return mean_start, mean_start / recorded_sample_rate


def select_wav_file():
    root = Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title="Select a WAV file", filetypes=[("WAV files", "*.wav")])
    root.destroy()
    return file_path


if __name__ == "__main__":
    # Selecting wav file
    recording_file_path = select_wav_file()
    chirp_file_path = select_wav_file()
    if recording_file_path and chirp_file_path:
        # Find the start index of the first chirp in the recording
        print(f"Recording file: {recording_file_path}")
        print(f"Chirp file: {chirp_file_path}")

        chirp_start_index, chirp_start_time = find_chirp_start_index(recording_file_path, chirp_file_path, plot=False)

        print(f"The first chirp starts at index: {chirp_start_index}")
        print(f"This corresponds to time: {chirp_start_time} seconds")