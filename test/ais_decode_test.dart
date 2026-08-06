import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/encoder/ais_payload_encoder.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/ais/src/messages/static_data/static_data_report.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';
import 'package:kik_ais/ais/src/nmea/nmea_sentence.dart';

String _checksum(String body) {
  int xor = 0;
  for (final c in body.codeUnits) {
    xor ^= c;
  }
  return xor.toRadixString(16).padLeft(2, '0').toUpperCase();
}

String _fragment(String binary, int index, int total, int seq) {
  final payload = encodeBinaryToAis(binary);
  final fill = index == total - 1 ? (6 - (binary.length % 6)) % 6 : 0;
  final body = 'AIVDM,$total,${index + 1},$seq,B,$payload,$fill';
  return '!$body*${_checksum(body)}';
}

void main() {
  group('NmeaSentence', () {
    test('parses fields and validates a correct checksum', () {
      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );
      final s = NmeaSentence.tryParse(sentence);
      expect(s, isNotNull);
      expect(s!.fragmentCount, 1);
      expect(s.fragmentNumber, 1);
      expect(s.channel, 'A');
      expect(s.isChecksumValid, isTrue);
    });

    test('detects a bad checksum', () {
      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );
      final bad = sentence.replaceRange(sentence.length - 2, sentence.length, '00');
      final s = NmeaSentence.tryParse(bad);
      expect(s, isNotNull);
      expect(s!.isChecksumValid, isFalse);
    });

    test('rejects non-NMEA input', () {
      expect(NmeaSentence.tryParse('not a sentence'), isNull);
      expect(NmeaSentence.tryParse(''), isNull);
    });
  });

  group('Encoder round-trip', () {
    test('type 1 position decodes to the same values', () {
      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );
      final decoder = AisNmeaDecoder();
      final msg = decoder.decode(sentence);
      expect(msg, isA<PositionMessage>());
      final p = msg as PositionMessage;
      expect(p.mmsi, 226545000);
      expect(p.latitude, closeTo(48.85, 0.00001));
      expect(p.longitude, closeTo(1.05, 0.00001));
      expect(p.speedOverGround, closeTo(12.0, 0.01));
      expect(p.courseOverGround, closeTo(250.0, 0.01));
      expect(p.heading, closeTo(90.0, 0.01));
    });

    test('type 24 part A decodes the vessel name', () {
      final sentence = encodeStaticDataReportPartA(
        mmsi: 123456789,
        name: 'KIKAIS',
      );
      final msg = AisNmeaDecoder().decode(sentence);
      expect(msg, isA<StaticDataReportA>());
      final r = msg as StaticDataReportA;
      expect(r.partNumber, 0);
      expect(r.vesselName.trim(), 'KIKAIS');
    });

    test('type 24 part B decodes type, call sign and dimensions', () {
      final sentence = encodeStaticDataReportPartB(
        mmsi: 123456789,
        shipType: 70,
        callSign: 'FLO21',
        dimensionBow: 10,
        dimensionStern: 20,
        dimensionPort: 5,
        dimensionStarboard: 5,
      );
      final msg = AisNmeaDecoder().decode(sentence);
      expect(msg, isA<StaticDataReportB>());
      final r = msg as StaticDataReportB;
      expect(r.partNumber, 1);
      expect(r.vesselTypeInt, 70);
      expect(r.callSign.trim(), 'FLO21');
      expect(r.dimensionBow, 10);
      expect(r.dimensionStern, 20);
      expect(r.dimensionPort, 5);
      expect(r.dimensionStarboard, 5);
    });
  });

  group('FragmentAssembler', () {
    test('reassembles a message split over two sentences', () {
      final full = NmeaSentence.tryParse(
        encodePositionReport(
          mmsi: 226545000,
          latitude: 48.85,
          longitude: 1.05,
          sog: 12.0,
          cog: 250.0,
          heading: 90.0,
        ),
      )!
          .binaryPayload;

      final part1 = _fragment(full.substring(0, 144), 0, 2, 3);
      final part2 = _fragment(full.substring(144), 1, 2, 3);

      final decoder = AisNmeaDecoder();
      expect(decoder.decode(part1), isNull); // waiting for fragment 2
      final msg = decoder.decode(part2);
      expect(msg, isA<PositionMessage>());
      final p = msg as PositionMessage;
      expect(p.latitude, closeTo(48.85, 0.00001));
      expect(p.longitude, closeTo(1.05, 0.00001));
    });

    test('reassembled message exposes all raw sentences in order', () {
      final full = NmeaSentence.tryParse(
        encodePositionReport(
          mmsi: 226545000,
          latitude: 48.85,
          longitude: 1.05,
          sog: 12.0,
          cog: 250.0,
          heading: 90.0,
        ),
      )!
          .binaryPayload;
      final part1 = _fragment(full.substring(0, 144), 0, 2, 3);
      final part2 = _fragment(full.substring(144), 1, 2, 3);

      final decoder = AisNmeaDecoder();
      expect(decoder.decode(part1), isNull);
      expect(decoder.lastRawSentences, isEmpty);

      final msg = decoder.decode(part2);
      expect(msg, isA<PositionMessage>());
      expect(decoder.lastRawSentences, hasLength(2));
      expect(decoder.lastRawSentences[0], part1);
      expect(decoder.lastRawSentences[1], part2);
    });
  });

  group('FragmentAssembler drops mismatched fragments', () {
    String twoPartBinary() {
      final full = NmeaSentence.tryParse(
        encodePositionReport(
          mmsi: 226545000,
          latitude: 48.85,
          longitude: 1.05,
          sog: 12.0,
          cog: 250.0,
          heading: 90.0,
        ),
      )!
          .binaryPayload;
      return full;
    }

    test('drops a fragment whose total does not match the pending message', () {
      final full = twoPartBinary();
      final decoder = AisNmeaDecoder();
      expect(decoder.decode(_fragment(full.substring(0, 144), 0, 2, 3)),
          isNull);
      // Same key, different total -> different message -> dropped.
      expect(decoder.decode(_fragment(full.substring(0, 100), 0, 3, 3)),
          isNull);
      expect(decoder.droppedFragments, 1);
      expect(decoder.fragmentsSeen, 2);
      // The pending message can still complete.
      final msg = decoder.decode(_fragment(full.substring(144), 1, 2, 3));
      expect(msg, isA<PositionMessage>());
      expect(decoder.multiPartCompleted, 1);
    });

    test('drops a conflicting fragment with the same index but a different '
        'payload', () {
      final full = twoPartBinary();
      final decoder = AisNmeaDecoder();
      expect(decoder.decode(_fragment(full.substring(0, 144), 0, 2, 3)),
          isNull);
      // Same key, same index, different bits -> different message -> dropped.
      final conflicting = full.substring(0, 144).replaceRange(0, 6, '111111');
      expect(decoder.decode(_fragment(conflicting, 0, 2, 3)), isNull);
      expect(decoder.droppedFragments, 1);
      final msg = decoder.decode(_fragment(full.substring(144), 1, 2, 3));
      expect(msg, isA<PositionMessage>());
    });

    test('keeps an identical retransmission and still completes', () {
      final full = twoPartBinary();
      final decoder = AisNmeaDecoder();
      final part1 = _fragment(full.substring(0, 144), 0, 2, 3);
      expect(decoder.decode(part1), isNull);
      expect(decoder.decode(part1), isNull); // retransmission, not a drop
      expect(decoder.droppedFragments, 0);
      expect(decoder.fragmentsSeen, 2);
      final msg = decoder.decode(_fragment(full.substring(144), 1, 2, 3));
      expect(msg, isA<PositionMessage>());
      expect(decoder.multiPartCompleted, 1);
    });

    test('drops an out-of-range fragment number', () {
      final decoder = AisNmeaDecoder();
      // index 2 -> fragment number 3 > total 2.
      expect(decoder.decode(_fragment('0' * 48, 2, 2, 3)), isNull);
      expect(decoder.droppedFragments, 1);
    });

    test('never merges interleaved messages sharing the same key', () {
      final full = twoPartBinary();
      final decoder = AisNmeaDecoder();
      // Message A (seq 3) fragment 0.
      expect(decoder.decode(_fragment(full.substring(0, 144), 0, 2, 3)),
          isNull);
      // Message B reuses seq 3 with a conflicting fragment 0 -> dropped.
      final b0 = full.substring(0, 144).replaceRange(0, 6, '111111');
      expect(decoder.decode(_fragment(b0, 0, 2, 3)), isNull);
      expect(decoder.droppedFragments, 1);
      // Message A still assembles cleanly from its own fragments.
      final msg = decoder.decode(_fragment(full.substring(144), 1, 2, 3));
      expect(msg, isA<PositionMessage>());
      expect((msg as PositionMessage).mmsi, 226545000);
      expect(decoder.multiPartCompleted, 1);
    });

    test('reset clears counters and the fragment buffer', () {
      final full = twoPartBinary();
      final decoder = AisNmeaDecoder();
      decoder.decode(_fragment(full.substring(0, 144), 0, 2, 3));
      expect(decoder.fragmentsSeen, 1);
      expect(decoder.pendingFragments, 1);
      decoder.reset();
      expect(decoder.fragmentsSeen, 0);
      expect(decoder.multiPartCompleted, 0);
      expect(decoder.droppedFragments, 0);
      expect(decoder.pendingFragments, 0);
      expect(decoder.invalidChecksums, 0);
      expect(decoder.parseErrors, 0);
    });
  });

  group('Checksum option', () {
    test('invalid sentences are dropped when validation is on', () {
      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );
      final bad = sentence.replaceRange(sentence.length - 2, sentence.length, '00');

      final strict = AisNmeaDecoder(validateChecksum: true);
      expect(strict.decode(bad), isNull);
      expect(strict.invalidChecksums, 1);

      final lenient = AisNmeaDecoder(validateChecksum: false);
      expect(lenient.decode(bad), isNotNull);
    });
  });
}
