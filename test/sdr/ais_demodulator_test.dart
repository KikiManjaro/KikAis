import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/sdr/dsp/ais_demodulator.dart';
import 'package:kik_ais/sdr/dsp/channelizer.dart';
import 'package:kik_ais/sdr/dsp/hdlc.dart';

import 'synth_ais.dart';

void main() {
  const knownPayload = '13lLUr02j01br3REUdh`eW3608Dn';
  final messageBits = payloadToBits(knownPayload);

  void feedAll(
    AisDemodulator demod,
    Uint8List iq,
    List<String> out, {
    int chunk = 4096,
  }) {
    for (var i = 0; i < iq.length; i += chunk) {
      final end = (i + chunk) > iq.length ? iq.length : (i + chunk);
      out.addAll(demod.process(iq.sublist(i, end)));
    }
  }

  String? payloadOf(String sentence) {
    final m = RegExp(
      r'^!AIVDM,1,1,\d?,([AB]),([^,]*),(\d)\*(?:[0-9A-F]{2})$',
    ).firstMatch(sentence);
    return m?.group(2);
  }

  test('CRC-16/CCITT reference vector', () {
    // '123456789' -> CRC-16/CCITT-FALSE = 0x29B1.
    final bits = <int>[];
    for (final c in '123456789'.codeUnits) {
      for (var i = 7; i >= 0; i--) {
        bits.add((c >> i) & 1);
      }
    }
    expect(AisFrameDecoder.crc16Ccitt(bits), 0x29B1);
  });

  test('decodes a clean burst on channel A (AIS1, 161.975 MHz)', () {
    final iq = makeAisBurst(messageBits, carrierHz: kAisChannel1Offset);
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iq, sentences);

    expect(sentences, isNotEmpty);
    final payload = payloadOf(sentences.first);
    expect(payload, knownPayload);
  });

  test('decodes a clean burst on channel B (AIS2, 162.025 MHz)', () {
    final iq = makeAisBurst(messageBits, carrierHz: kAisChannel2Offset);
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iq, sentences);

    expect(sentences, isNotEmpty);
    final sentence = sentences.first;
    expect(sentence, contains(',B,'));
    expect(payloadOf(sentence), knownPayload);
  });

  test('decodes through AWGN and a small frequency offset', () {
    final iq = makeAisBurst(
      messageBits,
      carrierHz: kAisChannel1Offset,
      snrDb: 14,
      freqOffsetHz: 200,
    );
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iq, sentences);

    expect(sentences, isNotEmpty);
    expect(payloadOf(sentences.first), knownPayload);
  });

  test('decodes one burst per channel when both are present', () {
    final iqA = makeAisBurst(messageBits, carrierHz: kAisChannel1Offset);
    final iqB = makeAisBurst(messageBits, carrierHz: kAisChannel2Offset);
    final demod = AisDemodulator();
    final sentences = <String>[];
    // Interleave both channels: the two bursts overlap in time.
    final len = iqA.length < iqB.length ? iqA.length : iqB.length;
    final mixed = Uint8List(len);
    for (var i = 0; i < len; i++) {
      mixed[i] = ((iqA[i] + iqB[i]) ~/ 2).clamp(0, 255);
    }
    feedAll(demod, mixed, sentences);

    expect(sentences.length, 2);
    for (final s in sentences) {
      expect(payloadOf(s), knownPayload);
    }
  });

  test('is stateless enough to survive odd chunk boundaries', () {
    final iq = makeAisBurst(messageBits, carrierHz: kAisChannel1Offset);
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iq, sentences, chunk: 3333);

    expect(sentences, isNotEmpty);
    expect(payloadOf(sentences.first), knownPayload);
  });

  test('produces nothing on noise-only input', () {
    final rnd = math.Random(7);
    final iq = Uint8List(200000);
    for (var i = 0; i < iq.length; i++) {
      iq[i] = rnd.nextInt(256);
    }
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iq, sentences);
    expect(sentences, isEmpty);
  });

  test('rejects the RTL-SDR DC spike at the band centre', () {
    // The RTL-SDR has a DC offset at the centre of the tuned band (0 Hz).
    // After mixing a channel it lands at ±25 kHz; the channel filter must
    // reject it or the discriminator is corrupted.
    final iq = makeAisBurst(messageBits, carrierHz: kAisChannel1Offset);
    final dc = 18; // ~14% of full scale, a strong DC spike.
    final iqDc = Uint8List(iq.length);
    for (var i = 0; i < iq.length; i++) {
      iqDc[i] = (iq[i] + dc).clamp(0, 255);
    }
    final demod = AisDemodulator();
    final sentences = <String>[];
    feedAll(demod, iqDc, sentences);

    expect(sentences, isNotEmpty);
    expect(payloadOf(sentences.first), knownPayload);
  });
}
