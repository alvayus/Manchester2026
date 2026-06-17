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


def find_chirp_end(recording_file_path, chirp_file_path, plot=False):
    if not os.path.exists(chirp_file_path):
        raise FileNotFoundError(f"Default chirp template not found at: {chirp_file_path}")

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
    chirp_end_index = mean_start + len(chirp_signal)

    if plot:
        fig, ax = plt.subplots(3)
        ax[0].plot(recorded_signal[:, 0])
        ax[1].plot(chirp_signal)
        ax[1].set_xlim(0, recorded_signal.shape[0])
        ax[1].plot(recorded_signal[mean_start:, 0], color="r")
        ax[0].axvline(mean_start, color="green", linestyle="--", label="Detected chirp start")
        ax[0].axvline(chirp_end_index, color="red", linestyle="--", label="Detected chirp end")
        ax[0].legend()
        plt.show()

    return chirp_end_index, chirp_end_index / recorded_sample_rate


def find_interesting_audio_end(
    recording_file_path,
    start_index=0,
    plot=False,
):
    """
    Detect where interesting audio ends and residual noise remains.

    Algorithm:
    1) Split into ~25 ms frames.
    2) Compute frame RMS.
    3) Smooth RMS with a ~200 ms moving average.
    4) Estimate noise floor from final 1 second.
    5) Use threshold = noise_floor * 3.
    6) Scan backwards for last frame above threshold.
    7) Add ~250 ms safety margin.
    """
    signal, sample_rate = sf.read(recording_file_path)
    signal = np.asarray(signal)

    frame_ms = 25.0
    smoothing_ms = 200.0
    tail_seconds = 1.0
    threshold_multiplier = 3.0
    safety_margin_ms = 250.0

    if signal.ndim == 1:
        mono = signal.astype(np.float64)
    else:
        # Use the channel with the highest global RMS for robust detection.
        channel_rms = np.sqrt(np.mean(signal.astype(np.float64) ** 2, axis=0) + 1e-12)
        mono = signal[:, int(np.argmax(channel_rms))].astype(np.float64)

    n_samples = len(mono)
    if n_samples == 0:
        return 0, 0.0

    frame_length = max(1, int(round((frame_ms / 1000.0) * sample_rate)))
    smoothing_frames = max(1, int(round(smoothing_ms / frame_ms)))
    tail_frames = max(1, int(round((tail_seconds * sample_rate) / frame_length)))
    safety_margin_samples = int(round((safety_margin_ms / 1000.0) * sample_rate))

    n_frames = int(np.ceil(n_samples / frame_length))
    rms = np.empty(n_frames, dtype=np.float64)
    for i in range(n_frames):
        start = i * frame_length
        stop = min(n_samples, start + frame_length)
        frame = mono[start:stop]
        rms[i] = np.sqrt(np.mean(frame**2) + 1e-12)

    if smoothing_frames == 1:
        smoothed_rms = rms
    else:
        kernel = np.ones(smoothing_frames, dtype=np.float64) / smoothing_frames
        smoothed_rms = np.convolve(rms, kernel, mode="same")

    tail = smoothed_rms[-tail_frames:]
    noise_floor = float(np.mean(tail))
    threshold = noise_floor * threshold_multiplier

    start_index = int(np.clip(start_index, 0, n_samples - 1))
    start_frame = max(0, start_index // frame_length)

    last_active_frame = None
    for frame_idx in range(n_frames - 1, start_frame - 1, -1):
        if smoothed_rms[frame_idx] > threshold:
            last_active_frame = frame_idx
            break

    if last_active_frame is None:
        end_sample = start_index
    else:
        frame_end = min(n_samples, (last_active_frame + 1) * frame_length)
        end_sample = min(n_samples, frame_end + safety_margin_samples)

    # Return as sample index in [0, n_samples - 1] for compatibility.
    end_index = int(np.clip(end_sample - 1, 0, n_samples - 1))

    if plot:
        time_axis = (np.arange(n_frames) * frame_length) / sample_rate
        plt.figure()
        plt.plot(time_axis, rms, alpha=0.35, label="Frame RMS")
        plt.plot(time_axis, smoothed_rms, label="Smoothed RMS (~200 ms)")
        plt.axhline(threshold, color="orange", linestyle="--", label="Threshold (3x noise floor)")
        plt.axvline(start_index / sample_rate, color="green", linestyle="--", label="Detected start")
        plt.axvline(end_index / sample_rate, color="red", linestyle="--", label="Detected end")
        plt.xlabel("Time (s)")
        plt.ylabel("RMS")
        plt.legend()
        plt.tight_layout()
        plt.show()

    return end_index, end_index / sample_rate


def select_wav_file():
    root = Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title="Select a WAV file", filetypes=[("WAV files", "*.wav")])
    root.destroy()
    return file_path


if __name__ == "__main__":
    # User selects recording and chirp template WAV files.
    recording_file_path = select_wav_file()
    chirp_file_path = select_wav_file()
    if recording_file_path and chirp_file_path:
        print(f"Recording file: {recording_file_path}")
        print(f"Chirp file: {chirp_file_path}")

        chirp_end_index = 0
        chirp_end_time = 0.0
        try:
            chirp_end_index, chirp_end_time = find_chirp_end(
                recording_file_path,
                chirp_file_path,
                plot=False,
            )
        except Exception as exc:
            print(f"Could not detect chirp end time from chirp template: {exc}")

        audio_end_index, audio_end_time = find_interesting_audio_end(
            recording_file_path,
            start_index=chirp_end_index,
            plot=True,
        )

        print(f"Interesting audio processing should start at index: {chirp_end_index}")
        print(f"This corresponds to time: {chirp_end_time} seconds")
        print(f"Interesting audio likely ends at index: {audio_end_index}")
        print(f"This corresponds to time: {audio_end_time} seconds")