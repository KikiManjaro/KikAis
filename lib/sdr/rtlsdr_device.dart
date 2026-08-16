import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'rtlsdr_ffi.dart';

/// A single RTL-SDR dongle detected on the system.
class RtlSdrDeviceInfo {
  final int index;
  final String name;
  final String manufacturer;
  final String product;
  final String serial;

  const RtlSdrDeviceInfo({
    required this.index,
    required this.name,
    required this.manufacturer,
    required this.product,
    required this.serial,
  });

  /// A human-friendly label, e.g. "Generic RTL2832U (R820T)".
  String get label {
    if (name.isNotEmpty) return name;
    if (manufacturer.isNotEmpty) return '$manufacturer $product'.trim();
    return 'RTL-SDR #$index';
  }

  @override
  String toString() => '$label (index $index)';
}

/// Enumerates the RTL-SDR dongles present. Returns an empty list when the
/// native library (or the driver) is unavailable, so the UI can show a helpful
/// "driver missing" message instead of crashing.
List<RtlSdrDeviceInfo> listRtlSdrDevices() {
  final bindings = RtlsdrBindings.tryLoad();
  if (bindings == null) return const [];
  try {
    final count = bindings.deviceCount;
    return List<RtlSdrDeviceInfo>.generate(count, (i) {
      final (m, p, s) = bindings.deviceUsbStrings(i);
      return RtlSdrDeviceInfo(
        index: i,
        name: bindings.deviceName(i),
        manufacturer: m,
        product: p,
        serial: s,
      );
    });
  } catch (_) {
    return const [];
  }
}

/// Abstraction over an RTL-SDR dongle, so the DSP worker can be driven by a
/// simulated source in unit tests instead of real hardware (same pattern as
/// [SerialDevice] in `serial_feed_player.dart`).
abstract class RtlSdrDevice {
  /// Opens the dongle at [deviceIndex] and configures it for AIS reception:
  /// 162 MHz center, [sampleRate] Hz, tuner gain [gainDb] (or auto when null),
  /// digital AGC enabled. Throws on failure.
  Future<void> openAndConfigure(
    int deviceIndex, {
    int sampleRate = 1024000,
    int? gainDb,
    bool autoGain = true,
    bool agc = true,
  });

  /// Reads up to [length] raw IQ bytes into the returned buffer, or null when
  /// the device is closed or an error occurs.
  Future<Uint8List?> readChunk(int length);

  Future<void> close();
}

/// Production [RtlSdrDevice] backed by librtlsdr (via [RtlsdrBindings]).
class RtlsdrFfiDevice implements RtlSdrDevice {
  RtlsdrBindings? _bindings;
  Pointer<Void>? _dev;

  /// The librtlsdr error message for [rc], or a generic one.
  static String errorFor(int rc) => switch (rc) {
        -1 => 'Generic error',
        -2 => 'Invalid argument',
        -3 => 'Device not found',
        -4 => 'Busy',
        -5 => 'USB error',
        _ => 'error $rc',
      };

  @override
  Future<void> openAndConfigure(
    int deviceIndex, {
    int sampleRate = 1024000,
    int? gainDb,
    bool autoGain = true,
    bool agc = true,
  }) async {
    final bindings = RtlsdrBindings.tryLoad();
    if (bindings == null) {
      throw StateError(
        'RTL-SDR library not found. Install the RTL-SDR Blog drivers or '
        'librtlsdr on your system.',
      );
    }
    final dev = bindings.open(deviceIndex);
    _bindings = bindings;
    _dev = dev;

    void check(int rc, String what) {
      if (rc < 0) {
        bindings.close(dev);
        _dev = null;
        throw StateError('$what failed (${errorFor(rc)})');
      }
    }

    check(bindings.setCenterFreq(dev, 162000000), 'Tuning to 162 MHz');
    check(bindings.setSampleRate(dev, sampleRate), 'Setting sample rate');
    // Narrow IF bandwidth: both AIS channels are within ±25 kHz of the centre
    // and a ~250 kHz filter keeps out-of-band noise down (AIS-catcher
    // recommends ~192 kHz for RTL-SDRs).
    check(bindings.setTunerBandwidth(dev, 250000), 'Setting bandwidth');
    check(bindings.setTunerGainMode(dev, autoGain ? 0 : 1),
        'Setting tuner gain mode');
    if (!autoGain && gainDb != null) {
      check(bindings.setTunerGain(dev, gainDb), 'Setting tuner gain');
    }
    check(bindings.setAgcMode(dev, agc ? 1 : 0), 'Setting AGC');
    check(bindings.resetBuffer(dev), 'Resetting buffer');
  }

  @override
  Future<Uint8List?> readChunk(int length) async {
    final dev = _dev;
    final bindings = _bindings;
    if (dev == null || bindings == null) return null;
    final buf = calloc<Uint8>(length);
    try {
      final n = bindings.readSync(dev, buf, length);
      if (n < 0) return null;
      if (n == 0) return Uint8List(0);
      final bytes = Uint8List(n);
      for (var i = 0; i < n; i++) {
        bytes[i] = buf[i];
      }
      return bytes;
    } finally {
      calloc.free(buf);
    }
  }

  @override
  Future<void> close() async {
    final dev = _dev;
    _dev = null;
    if (dev != null && _bindings != null) {
      _bindings!.close(dev);
    }
    _bindings = null;
  }
}
