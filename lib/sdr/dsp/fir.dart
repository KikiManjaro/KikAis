import 'dart:math' as math;
import 'dart:typed_data';

/// A stateful, decimating FIR low-pass filter built from a windowed-sinc
/// (Hamming window). It processes a block of real samples at the input rate
/// and produces a shorter block at `inputRate / decimation`.
///
/// The filter is causal (convolution uses samples up to the output time), so
/// it introduces a group delay of `(numTaps - 1) / 2` input samples. The FIR
/// keeps its own history across [process] calls so a continuous IQ stream can
/// be chopped into arbitrary blocks.
class DecimatingFir {
  final int decimation;
  final Float64List _taps;
  final Float64List _history;
  final int _numTaps;

  DecimatingFir({required List<double> taps, required this.decimation})
    : assert(taps.isNotEmpty),
      _taps = Float64List.fromList(taps),
      _numTaps = taps.length,
      _history = Float64List(taps.length - 1);

  /// Builds a Hamming-windowed sinc low-pass.
  factory DecimatingFir.lowPass({
    required int inputRate,
    required int outputRate,
    required double cutoffHz,
    required int numTaps,
  }) {
    final taps = List<double>.generate(numTaps, (n) {
      final i = n - (numTaps - 1) / 2.0;
      final sinc = i == 0
          ? 2 * cutoffHz / inputRate
          : math.sin(2 * math.pi * cutoffHz * i / inputRate) / (math.pi * i);
      final window = 0.54 - 0.46 * math.cos(2 * math.pi * n / (numTaps - 1));
      return sinc * window;
    });
    // Normalize so the DC gain is 1.
    final sum = taps.fold<double>(0, (a, b) => a + b);
    return DecimatingFir(
      taps: taps.map((t) => t / sum).toList(),
      decimation: inputRate ~/ outputRate,
    );
  }

  void reset() {
    _history.fillRange(0, _history.length, 0);
  }

  /// Runs the filter over [input], returning the decimated output. The output
  /// sample `o` is the causal filtered value at input time
  /// `(o + 1) * decimation - 1`.
  Float64List process(Float64List input) {
    final outLen = input.length ~/ decimation;
    final out = Float64List(outLen);
    for (var o = 0; o < outLen; o++) {
      final pos = (o + 1) * decimation - 1;
      var acc = 0.0;
      for (var t = 0; t < _numTaps; t++) {
        final idx = pos - t;
        double v;
        if (idx >= 0) {
          v = input[idx];
        } else if (idx >= -_history.length) {
          v = _history[_history.length + idx];
        } else {
          v = 0.0;
        }
        acc += v * _taps[t];
      }
      out[o] = acc;
    }
    // Keep the last (numTaps - 1) samples as history for the next block.
    final keep = math.min(_history.length, input.length);
    if (keep == input.length) {
      _history.setRange(0, keep, input);
    } else {
      _history.setRange(0, _history.length - keep, _history.sublist(keep));
      _history.setRange(
        _history.length - keep,
        _history.length,
        input.sublist(input.length - keep),
      );
    }
    return out;
  }
}
