import 'dart:math' as math;
import 'dart:typed_data';

import 'channelizer.dart';
import 'discriminator.dart';
import 'gmsk_math.dart';
import 'hdlc.dart';
import 'nmea_builder.dart';
import 'viterbi.dart';

/// Number of known leading symbols (preamble 0x55 ×3 + HDLC flag 0x7E).
const int kKnownSymbols = 32;

/// Maximum number of data symbols decoded after the flag (covers 2-slot
/// messages). Anything longer simply yields no sentence.
const int kMaxDataSymbols = 600;

const double _kDetectThreshold = 0.5;

/// Sampling offset (in 64 kHz samples) between the detected preamble start and
/// the symbol boundaries, compensating the FIR group delay and the
/// discriminator's half-sample centering. Calibrated against the synthetic
/// GMSK reference (re-verify if the channelizer filter changes).
const double kSampleOffset = 5.0;

/// Demodulates the raw IQ stream of an RTL-SDR dongle into NMEA AIVDM
/// sentences, one per valid AIS frame, across both VHF AIS channels.
///
/// The input is the interleaved unsigned 8-bit I/Q format delivered by
/// librtlsdr. A background isolate is expected to own an instance and forward
/// the sentences back to the main isolate.
class AisDemodulator {
  final AisChannel _ch1 = AisChannel(offsetHz: kAisChannel1Offset);
  final AisChannel _ch2 = AisChannel(offsetHz: kAisChannel2Offset);
  final FmDiscriminator _d1 = FmDiscriminator();
  final FmDiscriminator _d2 = FmDiscriminator();
  final _BurstProcessor _p1 = _BurstProcessor('A');
  final _BurstProcessor _p2 = _BurstProcessor('B');

  bool useChannel1 = true;
  bool useChannel2 = true;

  /// Feeds a block of raw IQ bytes and returns any sentences decoded from it.
  List<String> process(Uint8List iq) {
    final out = <String>[];
    if (useChannel1) {
      final (i, q) = _ch1.process(iq);
      out.addAll(_p1.push(_d1.process(i, q)));
    }
    if (useChannel2) {
      final (i, q) = _ch2.process(iq);
      out.addAll(_p2.push(_d2.process(i, q)));
    }
    return out;
  }
}

/// The NRZI symbol stream `b_{-1}, b_0, ..., b_{31}` of the AIS training
/// sequence: initial reference symbol + 24 preamble bits (0x55) + the HDLC
/// flag (0x7E). Shared by the reference waveform, the Viterbi forcing and the
/// scale fit.
List<int> _trainingSymbols() {
  final data = <int>[];
  for (var i = 0; i < 3; i++) {
    data.addAll(const [0, 1, 0, 1, 0, 1, 0, 1]); // 0x55
  }
  data.addAll(const [0, 1, 1, 1, 1, 1, 1, 0]); // 0x7E
  var sym = 1;
  return [1, ...data.map((b) {
    if (b == 0) sym = -sym;
    return sym;
  })];
}

/// Detects and decodes bursts in the discriminator stream of one channel.
class _BurstProcessor {
  final String channel;
  final List<int> _training = _trainingSymbols();
  final GmskViterbi _viterbi = GmskViterbi();

  final int _refLen;
  final Float64List _ref;
  double _refEnergy = 0;

  final List<double> _buf = [];
  double _dc = 0;
  int _scanFrom = 0;
  _BurstProcessor(this.channel)
      : _refLen = (kKnownSymbols * GmskMath.samplesPerBit).ceil(),
        _ref = Float64List((kKnownSymbols * GmskMath.samplesPerBit).ceil()) {
    for (var t = 0; t < _refLen; t++) {
      _ref[t] = GmskMath.instantaneousFrequency(_training, t.toDouble());
    }
    var e = 0.0;
    for (var i = 0; i < _ref.length; i++) {
      e += _ref[i] * _ref[i];
    }
    _refEnergy = e;
  }

  List<String> push(Float64List f) {
    for (final v in f) {
      // DC blocker: removes any constant frequency offset (tuner error).
      final y = v - _dc;
      _dc += 0.0005 * (v - _dc);
      _buf.add(y);
    }

    final sentences = <String>[];
    var from = _scanFrom;
    while (from <= _buf.length - _refLen) {
      final p = _findBurst(from);
      if (p < 0) {
        // No burst in the available window: remember how far we scanned so the
        // next block only re-scans the newly arrived samples (keeps the
        // idle-path cost linear instead of quadratic).
        from = _buf.length - _refLen;
        break;
      }
      final (decoded, end) = _decodeBurst(p);
      if (end == null) break; // need more data, wait for the next block
      if (decoded != null) {
        sentences.add(decoded);
      }
      from = end;
      if (from > _buf.length - _refLen) break;
    }
    _scanFrom = from;

    // Prevent unbounded growth when no burst is received.
    if (_buf.length > 131072) {
      final drop = _buf.length - 131072;
      _buf.removeRange(0, drop);
      _scanFrom = math.max(0, _scanFrom - drop);
      _scanFrom = math.max(_scanFrom, _buf.length - _refLen);
    }
    return sentences;
  }

  /// Sliding normalized cross-correlation of the discriminator against the
  /// training-sequence reference. Returns the sample index where the preamble
  /// starts, or -1.
  int _findBurst(int from) {
    var best = -1;
    var bestRho = _kDetectThreshold;
    final limit = _buf.length - _refLen;
    for (var n = from; n <= limit; n++) {
      var c = 0.0;
      var energy = 0.0;
      for (var i = 0; i < _refLen; i++) {
        final v = _buf[n + i];
        c += v * _ref[i];
        energy += v * v;
      }
      if (energy <= 0) continue;
      final rho = c.abs() / math.sqrt(energy * _refEnergy);
      if (rho > bestRho) {
        bestRho = rho;
        best = n;
      }
    }
    return best;
  }

  /// Linear interpolation of the discriminator buffer at a fractional index.
  double _interp(double t) {
    final i = t.floor();
    if (i < 0) return _buf[0];
    if (i >= _buf.length - 1) return _buf[_buf.length - 1];
    final frac = t - i;
    return _buf[i] * (1 - frac) + _buf[i + 1] * frac;
  }

  /// Decodes the burst whose preamble starts at sample [p]. Returns the NMEA
  /// sentence (or null when no valid frame) and the buffer index just past the
  /// decoded window — or a null end when the buffer does not yet hold enough
  /// of the burst to decide.
  (String?, int?) _decodeBurst(int p) {
    final maxSamples = kKnownSymbols + kMaxDataSymbols;
    final avail = ((_buf.length - p) / GmskMath.samplesPerBit) - 1;
    final toDecode = avail.floor() < maxSamples ? avail.floor() : maxSamples;
    // Not even the known region plus a few data bits yet.
    if (toDecode < kKnownSymbols + 32) return (null, null);

    final samples = <double>[];
    for (var n = 0; n < toDecode; n++) {
      // Symbol boundary after symbol n−1 (τ = n), compensated for the FIR
      // group delay and discriminator centering.
      samples.add(_interp(p + n * GmskMath.samplesPerBit + kSampleOffset));
    }
    // Remove any residual DC bias over a stable window (the preamble, flag and
    // start of the data — never the fade-out / idle tail).
    final meanWindow = math.min(128, samples.length);
    var sum = 0.0;
    for (var i = 0; i < meanWindow; i++) {
      sum += samples[i];
    }
    final mean = sum / meanWindow;
    for (var i = 0; i < samples.length; i++) {
      samples[i] -= mean;
    }

    // Fit the discriminator amplitude over the known region. Sample n at τ = n
    // constrains (b_{n-1}, b_n, b_{n+1}) = (training[n..n+2]).
    const kDev = GmskViterbi.kDev;
    final wp = GmskMath.frequencyPulse(1.0);
    final wc = GmskMath.frequencyPulse(0.0);
    final wn = GmskMath.frequencyPulse(-1.0);
    var num = 0.0;
    var den = 0.0;
    // Skip the burst-leading transient (samples 0..4).
    for (var n = 5; n <= 29; n++) {
      final e = kDev *
          (wp * _training[n] + wc * _training[n + 1] + wn * _training[n + 2]);
      num += samples[n] * e;
      den += e * e;
    }
    if (den <= 0) return (null, p + 1);
    var scale = num / den;
    final dir = scale.sign;
    scale = scale.abs();
    if (scale < 1e-9) return (null, p + 1);
    if (dir < 0) {
      for (var i = 0; i < samples.length; i++) {
        samples[i] = -samples[i];
      }
    }

    final symbols = _viterbi.decode(
      samples,
      scale: scale,
      forced: _training,
    );
    final (payload, consumed) = AisFrameDecoder.decode(symbols);
    if (payload != null) {
      final sentence = bitsToAivdm(payload, channel: channel);
      final end = p + (consumed + 2) * GmskMath.samplesPerBit.round() + 8;
      return (sentence, end);
    }
    // Not enough data to have decoded the full frame yet.
    if (toDecode < maxSamples) return (null, null);
    return (null, p + 1);
  }
}
