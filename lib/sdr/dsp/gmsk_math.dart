import 'dart:math' as math;

/// GMSK math shared by the demodulator and the synthetic modulator used in
/// tests: the Gaussian frequency pulse and the CPM phase model for AIS
/// (GMSK, h = 0.5, BT = 0.4, 9600 baud).
///
/// All angles are expressed in "units of bit period T" (T = 1); a real time
/// offset is obtained by dividing the sample index by the samples-per-bit
/// ratio [samplesPerBit].
class GmskMath {
  /// Bit period in samples at the decimated rate (64000 / 9600).
  static const double samplesPerBit = 64000 / 9600;

  /// Gaussian filter 3 dB bandwidth-time product used by AIS.
  static const double bt = 0.4;

  /// Standard deviation of the Gaussian filter in bit periods.
  static final double _sigma = math.sqrt(math.ln2) / (math.pi * bt) * _t;

  static const double _t = 1.0;

  GmskMath._();

  /// Gauss error function (Abramowitz & Stegun 7.1.26, max error ~1.5e-7).
  static double erf(double x) {
    final sign = x < 0 ? -1.0 : 1.0;
    final ax = x.abs();
    final t = 1.0 / (1.0 + 0.3275911 * ax);
    final y =
        1.0 -
        (((((1.061405429 * t - 1.453152027) * t) + 1.421413741) * t -
                        0.284496736) *
                    t +
                0.254829592) *
            t *
            math.exp(-ax * ax);
    return sign * y;
  }

  /// Standard normal CDF.
  static double normalCdf(double x) => 0.5 * (1.0 + erf(x / math.sqrt2));

  /// The GMSK frequency pulse p̃(τ), normalized so that Σ_k p̃(τ − k) = 1.
  /// p̃ is the Gaussian filter convolved with a unit-width rectangle centered
  /// on the origin, so p̃(τ) = Φ(τ + 1/2) − Φ(τ − 1/2), where Φ is the normal
  /// CDF with standard deviation [_sigma].
  static double frequencyPulse(double tau) =>
      normalCdf((tau + 0.5) / _sigma) - normalCdf((tau - 0.5) / _sigma);

  /// The GMSK phase pulse G(τ) = ∫₋∞^τ p̃(u) du (0 at −∞, 1 at +∞).
  static double phasePulse(double tau) {
    final a = tau + 0.5;
    final b = tau - 0.5;
    return a * normalCdf(a / _sigma) -
        b * normalCdf(b / _sigma) +
        _sigma * _phi(a / _sigma) -
        _sigma * _phi(b / _sigma);
  }

  static double _phi(double x) => math.exp(-x * x / 2) / math.sqrt(2 * math.pi);

  /// Instantaneous frequency (rad/sample at the decimated rate) of a GMSK
  /// symbol stream [symbols] (values ±1) evaluated at sample time [tSamples].
  /// The first symbol spans [0, T); this is the discriminator reference for a
  /// known preamble.
  static double instantaneousFrequency(List<int> symbols, double tSamples) {
    final tau = tSamples / samplesPerBit;
    var f = 0.0;
    final first = (tau - 2).floor();
    final last = (tau + 2).ceil();
    for (var k = first; k <= last; k++) {
      if (k < 0 || k >= symbols.length) continue;
      f += symbols[k] * frequencyPulse(tau - k);
    }
    return math.pi / 2 * f;
  }
}
