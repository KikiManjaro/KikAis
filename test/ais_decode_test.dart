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
