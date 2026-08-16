import 'dart:math' as math;
import 'dart:typed_data';

import 'fir.dart';

/// Decimated baseband rate used across the AIS DSP chain.
const int kAisOutputRate = 64000;

/// Input IQ rate used when sampling the RTL-SDR dongle.
const int kAisInputRate = 1024000;

/// The AIS channel frequencies, as offsets from the tuned center (162 MHz).
const double kAisChannel1Offset = -25000;
const double kAisChannel2Offset = 25000;

/// Down-converts one AIS channel to complex baseband and decimates it from
/// [kAisInputRate] to [kAisOutputRate] (×16).
///
/// Each channel is mixed to DC with a numerically controlled oscillator then
/// filtered through a decimating FIR so the adjacent AIS channel (25 kHz away,
/// 50 kHz in baseband) is strongly attenuated before aliasing.
class AisChannel {
  final double offsetHz;
  final DecimatingFir _firI;
  final DecimatingFir _firQ;
  double _phase = 0;
  final double _phaseStep;

  AisChannel._(this.offsetHz, {required int numTaps})
      :         _firI = DecimatingFir.lowPass(
          inputRate: kAisInputRate,
          outputRate: kAisOutputRate,
          // Passband up to ~12 kHz (the AIS GMSK spans ±8 kHz). The RTL-SDR
          // DC spike lands at ±25 kHz after mixing, so it and the adjacent
          // channel (at +50 kHz) must fall in the stopband. 256 taps put the
          // stopband edge around 25 kHz.
          cutoffHz: 12000,
          numTaps: numTaps,
        ),
        _firQ = DecimatingFir.lowPass(
          inputRate: kAisInputRate,
          outputRate: kAisOutputRate,
          cutoffHz: 12000,
          numTaps: numTaps,
        ),
        _phaseStep = 2 * math.pi * offsetHz / kAisInputRate;

  factory AisChannel({double offsetHz = kAisChannel1Offset, int numTaps = 256}) =>
      AisChannel._(offsetHz, numTaps: numTaps);

  Uint8List _pending = Uint8List(0);

  void reset() {
    _firI.reset();
    _firQ.reset();
    _phase = 0;
    _pending = Uint8List(0);
  }

  /// Converts one block of raw IQ (interleaved unsigned bytes) into complex
  /// baseband I/Q at [kAisOutputRate]. Blocks of any length are accepted; a
  /// partial decimation block is buffered and prepended to the next call.
  (Float64List, Float64List) process(Uint8List iq) {
    final combined = Uint8List(_pending.length + iq.length);
    combined.setRange(0, _pending.length, _pending);
    combined.setRange(_pending.length, combined.length, iq);
    final usable = combined.length ~/ 2;
    final full = usable ~/ 16 * 16;
    final n = full;
    final mi = Float64List(n);
    final mq = Float64List(n);
    for (var k = 0; k < n; k++) {
      final i = (combined[k * 2] - 127.5) / 127.5;
      final q = (combined[k * 2 + 1] - 127.5) / 127.5;
      _phase += _phaseStep;
      if (_phase > math.pi * 2) _phase -= math.pi * 2;
      final c = math.cos(_phase);
      final s = math.sin(_phase);
      // Mix by e^{-jθ}: brings a signal at +offsetHz down to baseband and one
      // at -offsetHz up to baseband, so both AIS channels land on DC.
      mi[k] = i * c + q * s;
      mq[k] = q * c - i * s;
    }
    // Keep the leftover (partial decimation block) for the next call.
    final leftover = combined.length - full * 2;
    if (leftover > 0) {
      _pending = Uint8List.fromList(combined.sublist(full * 2));
    } else {
      _pending = Uint8List(0);
    }
    return (_firI.process(mi), _firQ.process(mq));
  }
}


