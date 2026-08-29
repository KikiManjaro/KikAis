import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Native signature of the librtlsdr functions used by the app. The library
/// (rtlsdr.dll on Windows, librtlsdr.so.0 on Linux) is loaded dynamically and
/// bundled with the app, exactly like the "RTL-SDR Blog" drivers used by the
/// whole RTL-SDR ecosystem.
typedef _Uint32Native = Uint32 Function();
typedef _SetUint32Native = Int32 Function(Pointer<Void> dev, Uint32 value);
typedef _SetIntNative = Int32 Function(Pointer<Void> dev, Int32 value);
typedef _ResetBufferNative = Int32 Function(Pointer<Void> dev);
typedef _OpenNative = Int32 Function(Pointer<Pointer<Void>> dev, Uint32 index);
typedef _CloseNative = Int32 Function(Pointer<Void> dev);
typedef _GetNameNative = Pointer<Char> Function(Uint32 index);
typedef _GetUsbStringsNative =
    Int32 Function(
      Uint32 index,
      Pointer<Char> m,
      Pointer<Char> p,
      Pointer<Char> s,
    );
typedef _GetGainsNative =
    Int32 Function(Pointer<Void> dev, Pointer<Int32> gains);
typedef _ReadSyncNative =
    Int32 Function(
      Pointer<Void> dev,
      Pointer<Uint8> buf,
      Int32 len,
      Pointer<Int32> nRead,
    );

/// Low-level typed access to librtlsdr.
class RtlsdrBindings {
  final DynamicLibrary _lib;
  RtlsdrBindings._(this._lib) {
    _getDeviceCount = _lib.lookupFunction<_Uint32Native, int Function()>(
      'rtlsdr_get_device_count',
    );
    _getDeviceName = _lib
        .lookupFunction<_GetNameNative, Pointer<Char> Function(int)>(
          'rtlsdr_get_device_name',
        );
    _getDeviceUsbStrings = _lib
        .lookupFunction<
          _GetUsbStringsNative,
          int Function(int, Pointer<Char>, Pointer<Char>, Pointer<Char>)
        >('rtlsdr_get_device_usb_strings');
    _open = _lib
        .lookupFunction<_OpenNative, int Function(Pointer<Pointer<Void>>, int)>(
          'rtlsdr_open',
        );
    _close = _lib.lookupFunction<_CloseNative, int Function(Pointer<Void>)>(
      'rtlsdr_close',
    );
    _setCenterFreq = _lib
        .lookupFunction<_SetUint32Native, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_center_freq',
        );
    _setSampleRate = _lib
        .lookupFunction<_SetUint32Native, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_sample_rate',
        );
    _setTunerGainMode = _lib
        .lookupFunction<_SetIntNative, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_tuner_gain_mode',
        );
    _setTunerGain = _lib
        .lookupFunction<_SetIntNative, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_tuner_gain',
        );
    _getTunerGains = _lib
        .lookupFunction<
          _GetGainsNative,
          int Function(Pointer<Void>, Pointer<Int32>)
        >('rtlsdr_get_tuner_gains');
    _setAgcMode = _lib
        .lookupFunction<_SetIntNative, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_agc_mode',
        );
    _setTunerBandwidth = _lib
        .lookupFunction<_SetUint32Native, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_tuner_bandwidth',
        );
    _setFreqCorrection = _lib
        .lookupFunction<_SetIntNative, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_freq_correction',
        );
    _setDirectSampling = _lib
        .lookupFunction<_SetIntNative, int Function(Pointer<Void>, int)>(
          'rtlsdr_set_direct_sampling',
        );
    _resetBuffer = _lib
        .lookupFunction<_ResetBufferNative, int Function(Pointer<Void>)>(
          'rtlsdr_reset_buffer',
        );
    _readSync = _lib
        .lookupFunction<
          _ReadSyncNative,
          int Function(Pointer<Void>, Pointer<Uint8>, int, Pointer<Int32>)
        >('rtlsdr_read_sync');
  }

  /// Loads the librtlsdr shared library, returning null when it is not
  /// available (e.g. under `flutter test` or on a machine without the drivers).
  static RtlsdrBindings? tryLoad() {
    try {
      if (Platform.isWindows) {
        return RtlsdrBindings._(DynamicLibrary.open('rtlsdr.dll'));
      }
      if (Platform.isLinux) {
        try {
          return RtlsdrBindings._(DynamicLibrary.open('librtlsdr.so.0'));
        } on ArgumentError {
          return RtlsdrBindings._(DynamicLibrary.open('librtlsdr.so'));
        }
      }
    } catch (_) {
      // The native library is not installed — the UI will show an empty
      // device list and a helpful error.
    }
    return null;
  }

  late final int Function() _getDeviceCount;
  late final Pointer<Char> Function(int) _getDeviceName;
  late final int Function(int, Pointer<Char>, Pointer<Char>, Pointer<Char>)
  _getDeviceUsbStrings;
  late final int Function(Pointer<Pointer<Void>>, int) _open;
  late final int Function(Pointer<Void>) _close;
  late final int Function(Pointer<Void>, int) _setCenterFreq;
  late final int Function(Pointer<Void>, int) _setSampleRate;
  late final int Function(Pointer<Void>, int) _setTunerGainMode;
  late final int Function(Pointer<Void>, int) _setTunerGain;
  late final int Function(Pointer<Void>, Pointer<Int32>) _getTunerGains;
  late final int Function(Pointer<Void>, int) _setAgcMode;
  late final int Function(Pointer<Void>, int) _setTunerBandwidth;
  late final int Function(Pointer<Void>, int) _setFreqCorrection;
  late final int Function(Pointer<Void>, int) _setDirectSampling;
  late final int Function(Pointer<Void>) _resetBuffer;
  late final int Function(Pointer<Void>, Pointer<Uint8>, int, Pointer<Int32>)
  _readSync;

  int get deviceCount => _getDeviceCount();

  /// Returns the device name at [index] (may be empty for unreadable dongles).
  String deviceName(int index) {
    final ptr = _getDeviceName(index);
    if (ptr == nullptr) return '';
    return ptr.cast<Utf8>().toDartString();
  }

  /// Fills the manufacturer / product / serial strings of device [index].
  (String, String, String) deviceUsbStrings(int index) {
    // 256 bytes per buffer, matching the size the librtlsdr implementations
    // write (128 was overrun on real dongles -> heap corruption).
    final m = calloc<Char>(256);
    final p = calloc<Char>(256);
    final s = calloc<Char>(256);
    try {
      _getDeviceUsbStrings(index, m, p, s);
      return (
        m.cast<Utf8>().toDartString(),
        p.cast<Utf8>().toDartString(),
        s.cast<Utf8>().toDartString(),
      );
    } finally {
      calloc.free(m);
      calloc.free(p);
      calloc.free(s);
    }
  }

  /// Opens device [index], returning its opaque handle or throwing.
  Pointer<Void> open(int index) {
    final handle = calloc<Pointer<Void>>();
    try {
      final rc = _open(handle, index);
      if (rc < 0) {
        throw StateError('rtlsdr_open($index) failed: $rc');
      }
      return handle.value;
    } finally {
      calloc.free(handle);
    }
  }

  int close(Pointer<Void> dev) => _close(dev);
  int setCenterFreq(Pointer<Void> dev, int freq) => _setCenterFreq(dev, freq);
  int setSampleRate(Pointer<Void> dev, int rate) => _setSampleRate(dev, rate);
  int setTunerGainMode(Pointer<Void> dev, int manual) =>
      _setTunerGainMode(dev, manual);
  int setTunerGain(Pointer<Void> dev, int gain) => _setTunerGain(dev, gain);
  int setAgcMode(Pointer<Void> dev, int on) => _setAgcMode(dev, on);
  int setTunerBandwidth(Pointer<Void> dev, int bw) =>
      _setTunerBandwidth(dev, bw);
  int setFreqCorrection(Pointer<Void> dev, int ppm) =>
      _setFreqCorrection(dev, ppm);
  int setDirectSampling(Pointer<Void> dev, int on) =>
      _setDirectSampling(dev, on);
  int resetBuffer(Pointer<Void> dev) => _resetBuffer(dev);

  /// The tuner gains available on [dev] (0 when auto).
  List<int> tunerGains(Pointer<Void> dev) {
    final n = _getTunerGains(dev, nullptr);
    if (n <= 0) return const [];
    final gains = calloc<Int32>(n);
    try {
      _getTunerGains(dev, gains);
      return List<int>.generate(n, (i) => gains[i]);
    } finally {
      calloc.free(gains);
    }
  }

  /// Reads up to [len] IQ bytes into [buf]. Returns the number read, or -1 on
  /// error.
  int readSync(Pointer<Void> dev, Pointer<Uint8> buf, int len) {
    final n = calloc<Int32>();
    try {
      final rc = _readSync(dev, buf, len, n);
      return rc < 0 ? rc : n.value;
    } finally {
      calloc.free(n);
    }
  }
}
