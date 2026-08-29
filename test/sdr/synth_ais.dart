import 'dart:math' as math;
import 'dart:typed_data';

import 'package:kik_ais/sdr/dsp/gmsk_math.dart';
import 'package:kik_ais/sdr/dsp/hdlc.dart';

/// Synthetic AIS transmitter used to generate raw IQ test vectors without any
/// hardware: a valid frame (preamble + flag + bit-stuffed message + flag) is
/// NRZI-encoded and GMSK-modulated exactly as the demodulator expects it.
///
/// The IQ stream is emitted at [kAisInputRate] in the unsigned 8-bit
/// interleaved format produced by librtlsdr.

const int kSynthSampleRate = 1024000;

/// Converts an AIVDM payload (6-bit chars) back to message bits.
List<int> payloadToBits(String payload, {int fill = 0}) {
  final bits = <int>[];
  for (final c in payload.codeUnits) {
    var v = c - 48;
    if (v > 39) v -= 8;
    for (var i = 5; i >= 0; i--) {
      bits.add((v >> i) & 1);
    }
  }
  // Keep only the real message bits (strip pad bits).
  if (fill > 0) {
    bits.removeRange(bits.length - fill, bits.length);
  }
  return bits;
}

/// CRC-16/CCITT of [bits] complemented (the value AIS appends).
int crc16Ais(List<int> bits) => AisFrameDecoder.crc16Ccitt(bits) ^ 0xFFFF;

/// Inserts a 0 after every run of five 1s (HDLC bit stuffing).
List<int> bitStuff(List<int> bits) {
  final out = <int>[];
  var ones = 0;
  for (final b in bits) {
    out.add(b);
    if (b == 1) {
      ones++;
      if (ones == 5) {
        out.add(0);
        ones = 0;
      }
    } else {
      ones = 0;
    }
  }
  return out;
}

/// Builds the full on-air bit stream: 24-bit preamble (0x55 ×3), opening
/// flag, stuffed [messageBits] (payload + CRC), closing flag.
List<int> buildFrameBits(List<int> messageBits) {
  final preamble = [
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    1,
  ];
  const flag = [0, 1, 1, 1, 1, 1, 1, 0];
  return [...preamble, ...flag, ...bitStuff(messageBits), ...flag];
}

/// NRZI-encodes [bits] (0 -> transition, 1 -> no transition) into ±1 symbols,
/// starting from the +1 reference symbol that precedes the first bit.
List<int> nrziEncode(List<int> bits) {
  var sym = 1;
  return [
    sym,
    ...bits.map((b) {
      if (b == 0) sym = -sym;
      return sym;
    }),
  ];
}

/// GMSK-modulates [symbols] (starting with the reference symbol) at
/// [kSynthSampleRate], placing the carrier at [carrierHz] relative to the
/// dongle center (channel A = −25 kHz, channel B = +25 kHz). Returns
/// interleaved unsigned 8-bit I/Q.
Uint8List gmskModulate(
  List<int> symbols, {
  required double carrierHz,
  double amplitude = 0.8,
  double snrDb = 100,
  double freqOffsetHz = 0,
}) {
  final spb = kSynthSampleRate / 9600.0;
  final n = (symbols.length * spb).round();
  final iq = Uint8List(n * 2);

  final signalPower = amplitude * amplitude / 2;
  final noisePower = signalPower / math.pow(10, snrDb / 10).toDouble();
  final noise = math.sqrt(noisePower);
  final rnd = math.Random(12345);

  // GMSK phase: φ(τ) = π/2 · Σ_k b_k · G(τ − k). The pulse is fully settled
  // at |τ − k| ≥ 3, so completed symbols are accumulated once (in unit phase,
  // scaled by π/2 at the end) and the partial contributions of the transition
  // window are added per sample. This keeps the phase continuous (no per-bit
  // sawtooth glitches).
  var accPhase = 0.0;
  var lastCompleteK = -4;
  for (var s = 0; s < n; s++) {
    final tau = s / spb;
    final floorK = tau.floor();
    while (lastCompleteK + 1 <= floorK - 3) {
      lastCompleteK++;
      if (lastCompleteK >= 0 && lastCompleteK < symbols.length) {
        accPhase += symbols[lastCompleteK];
      }
    }
    var phase = accPhase;
    for (var k = lastCompleteK + 1; k <= lastCompleteK + 6; k++) {
      if (k < 0 || k >= symbols.length) continue;
      phase += symbols[k] * GmskMath.phasePulse(tau - k);
    }
    final total =
        phase * math.pi / 2 +
        2 * math.pi * (carrierHz + freqOffsetHz) * s / kSynthSampleRate;
    final i = amplitude * math.cos(total) + noise * _gauss(rnd);
    final q = amplitude * math.sin(total) + noise * _gauss(rnd);
    iq[s * 2] = ((i + 1) * 127.5).round().clamp(0, 255);
    iq[s * 2 + 1] = ((q + 1) * 127.5).round().clamp(0, 255);
  }
  return iq;
}

double _gauss(math.Random rnd) {
  var sum = 0.0;
  for (var i = 0; i < 6; i++) {
    sum += rnd.nextDouble();
  }
  return (sum - 3) / math.sqrt(6 / 12);
}

/// Convenience: encodes [messageBits] into a full IQ burst on [carrierHz],
/// followed by a short silent tail (like the idle gap between real AIS slots)
/// so a streaming demodulator can finish decoding the frame.
Uint8List makeAisBurst(
  List<int> messageBits, {
  required double carrierHz,
  double snrDb = 100,
  double freqOffsetHz = 0,
  int tailBits = 80,
}) {
  final crc = crc16Ais(messageBits);
  final dataBits = [
    ...messageBits,
    for (var i = 15; i >= 0; i--) (crc >> i) & 1,
  ];
  // Trailing idle flags (like a real transmitter between slots) give the
  // streaming demodulator margin so the closing flag is decoded cleanly.
  const idle = [0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0];
  final iq = gmskModulate(
    nrziEncode([...buildFrameBits(dataBits), ...idle]),
    carrierHz: carrierHz,
    snrDb: snrDb,
    freqOffsetHz: freqOffsetHz,
  );
  // Silent tail: zero amplitude IQ (the closing flag is the last real symbol,
  // so the tail must not overlap the frame).
  final tail = Uint8List(tailBits * (kSynthSampleRate ~/ 9600) * 2);
  tail.fillRange(0, tail.length, 128);
  return Uint8List.fromList([...iq, ...tail]);
}
