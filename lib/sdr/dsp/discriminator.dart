import 'dart:math' as math;
import 'dart:typed_data';

/// FM discriminator: instantaneous frequency as the phase advance between
/// adjacent complex samples, `atan2(Im(b[n]·conj(b[n-1])), Re(...))`.
///
/// For the constant-envelope GMSK signal of AIS this yields the baseband
/// instantaneous frequency in radians per sample, which is what the symbol
/// recovery operates on.
class FmDiscriminator {
  double _prevI = 0;
  double _prevQ = 0;

  void reset() {
    _prevI = 0;
    _prevQ = 0;
  }

  /// Returns one frequency estimate per complex sample of [i], [q].
  Float64List process(Float64List i, Float64List q) {
    final n = math.min(i.length, q.length);
    final out = Float64List(n);
    for (var k = 0; k < n; k++) {
      final a = _prevI;
      final b = _prevQ;
      final c = i[k];
      final d = q[k];
      out[k] = math.atan2(d * a - b * c, a * c + b * d);
      _prevI = c;
      _prevQ = d;
    }
    return out;
  }
}
