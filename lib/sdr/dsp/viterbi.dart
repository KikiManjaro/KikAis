import 'dart:math' as math;
import 'dart:typed_data';

import 'channelizer.dart';
import 'gmsk_math.dart';

/// MLSE (Viterbi) decoder for the AIS GMSK signal.
///
/// The discriminator is sampled once per bit, at the symbol boundaries
/// (τ = n, i.e. the end of symbol n−1). At that instant the GMSK frequency
/// pulse (BT = 0.4, corrected with the Gaussian filter's standard deviation)
/// gives
///
///   s_n = kDev · [ p̃(1)·b_{n-1} + p̃(0)·b_n + p̃(-1)·b_{n+1} ]
///
/// (the p̃(2)·b_{n-2} term is negligible and dropped). The dominant symbol is
/// therefore b_n; each sample depends on 3 consecutive symbols → a 4-state
/// trellis whose state is (b_{n-1}, b_n) and whose branch chooses b_{n+1}. The
/// leading preamble and HDLC flag symbols are known, so the trellis is forced
/// through them, which also fixes the absolute polarity.
class GmskViterbi {
  /// (π/2 · 9600 / 64000): phase advance in rad/sample for a full ±1 symbol.
  static const double kDev = math.pi / 2 * (9600 / kAisOutputRate);

  final double _wPrev;
  final double _wCur;
  final double _wNext;

  GmskViterbi()
    : _wPrev = GmskMath.frequencyPulse(1.0),
      _wCur = GmskMath.frequencyPulse(0.0),
      _wNext = GmskMath.frequencyPulse(-1.0);

  int _stateOf(int a, int b) => (a > 0 ? 2 : 0) | (b > 0 ? 1 : 0);
  int _prevOf(int s) => (s & 2) != 0 ? 1 : -1;
  int _curOf(int s) => (s & 1) != 0 ? 1 : -1;

  double _expected(int state, int next, double scale) =>
      kDev *
      scale *
      (_wPrev * _prevOf(state) + _wCur * _curOf(state) + _wNext * next);

  /// Decodes [samples] (one per symbol boundary, τ = n) into a symbol stream.
  ///
  /// [forced] is the known symbol sequence `b_{-1}, b_0, ..., b_{K-1}` (the
  /// initial NRZI reference followed by the preamble and flag) and [scale] is
  /// the fitted discriminator amplitude. Returns `b_{-1}, b_0, ...`.
  List<int> decode(
    List<double> samples, {
    required double scale,
    required List<int> forced,
  }) {
    const double negInf = -1e18;
    final kKnown = forced.length - 1;
    final n = samples.length;

    final metrics = Float64List((n + 1) * 4)..fillRange(0, (n + 1) * 4, negInf);
    final trace = List.generate(n, (_) => List<int>.filled(4, -1));

    // Initial state (b_{-1}, b_0).
    final init = _stateOf(forced[0], forced[1]);
    metrics[init] = 0;

    for (var i = 0; i < n; i++) {
      final row = i * 4;
      final nextRow = (i + 1) * 4;
      // Branch at step i chooses b_{i+1} = forced[i + 2] when known.
      final forcedNext = i + 2 <= kKnown ? forced[i + 2] : null;
      final sVal = samples[i];
      for (var s = 0; s < 4; s++) {
        final pm = metrics[row + s];
        if (pm < -1e17) continue;
        for (var next = -1; next <= 1; next += 2) {
          if (forcedNext != null && next != forcedNext) continue;
          final e = _expected(s, next, scale);
          final m = pm - (sVal - e) * (sVal - e);
          final ns = _stateOf(_curOf(s), next);
          if (m > metrics[nextRow + ns]) {
            metrics[nextRow + ns] = m;
            trace[i][ns] = s;
          }
        }
      }
    }

    // Trace back from the best final state (b_{n-1}, b_n).
    var best = 0;
    for (var s = 1; s < 4; s++) {
      if (metrics[n * 4 + s] > metrics[n * 4 + best]) best = s;
    }
    // State at row i is (b_{i-1}, b_i); b_i = prevOf(state at row i+1).
    final b = List<int>.filled(n, 0);
    for (var i = n - 1; i >= 0; i--) {
      b[i] = best < 0 ? 0 : _prevOf(best);
      best = trace[i][best];
    }
    return [forced[0], ...b];
  }
}
