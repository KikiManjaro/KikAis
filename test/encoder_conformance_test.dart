import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/encoder/ais_payload_encoder.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';
import 'package:kik_ais/ais/src/utils/convert_char_to_bin.dart';

/// Wire-format conformance of every encoder: what a real AIS receiver
/// enforces (NMEA 0183 length, fragmenting, fill bits, payload alphabet) and
/// the bit length each message type is allowed to use.
///
/// These rules are deliberately independent from the project decoder, which
/// accepts over-long sentences and mirrors the encoder's own field layouts.
void main() {
  group('NMEA framing', () {
    test('every type fits 82 characters per sentence', () {
      for (final entry in _allSentences().entries) {
        for (final line in entry.value.split('\n')) {
          expect(
            line.length,
            lessThanOrEqualTo(82),
            reason: 'type ${entry.key}: $line',
          );
        }
      }
    });

    test('every type fragments at 62 payload characters', () {
      for (final entry in _allSentences().entries) {
        final lines = entry.value.split('\n');
        final payloads = lines.map(_payload).toList();
        for (final payload in payloads) {
          expect(
            payload.length,
            lessThanOrEqualTo(62),
            reason: 'type ${entry.key}: payload too long',
          );
        }
        expect(
          lines.length,
          (payloads.fold<int>(0, (s, p) => s + p.length) / 62).ceil(),
          reason: 'type ${entry.key}: wrong fragment count',
        );
      }
    });

    test('multi-fragment messages carry a sequential id', () {
      for (final entry in _allSentences().entries) {
        final lines = entry.value.split('\n');
        if (lines.length < 2) continue;
        final ids = lines.map((l) => l.split(',')[3]).toSet();
        expect(ids.length, 1, reason: 'type ${entry.key}: inconsistent seq id');
        expect(
          ids.single,
          isNotEmpty,
          reason: 'type ${entry.key}: empty seq id',
        );
      }
    });

    test('checksums and fill bits are valid on every fragment', () {
      for (final entry in _allSentences().entries) {
        final lines = entry.value.split('\n');
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          final body = line.substring(1, line.lastIndexOf('*'));
          expect(
            line.substring(line.lastIndexOf('*') + 1),
            computeNmeaChecksum(body),
            reason: 'type ${entry.key}: bad checksum',
          );
          final fill = int.parse(line.split(',').last.split('*').first);
          if (i < lines.length - 1) {
            expect(
              fill,
              0,
              reason: 'type ${entry.key}: fill on non-final part',
            );
          } else {
            expect(fill, inInclusiveRange(0, 5));
            if (fill > 0) {
              final last = aisCharToValue(_payload(line).split('').last);
              expect(
                last & ((1 << fill) - 1),
                0,
                reason: 'type ${entry.key}: non-zero fill bits',
              );
            }
          }
        }
      }
    });
  });

  group('payload length', () {
    test('variable-length types stop at the end of their data', () {
      _expectBits(
        encodeBinaryAddressed(
          mmsi: 226545000,
          destinationMmsi: 227000000,
          data: const [1, 2, 3, 4],
        ),
        120,
      );
      _expectBits(
        encodeBinaryBroadcast(mmsi: 226545000, data: const [9, 8, 7]),
        80,
      );
      _expectBits(
        encodeAddressedSafety(
          mmsi: 226545000,
          destinationMmsi: 227000000,
          text: 'HELLO',
        ),
        72 + 5 * 6,
      );
      _expectBits(
        encodeSafetyBroadcast(mmsi: 226545000, text: 'WARNING'),
        40 + 7 * 6,
      );
      _expectBits(
        encodeDgnssBroadcast(
          mmsi: 226545000,
          latitude: 47.5,
          longitude: -3.2,
          data: const [1, 2, 3],
        ),
        80 + 24,
      );
      _expectBits(
        encodeSingleSlotBinary(mmsi: 226545000, data: const [1, 2, 3, 4]),
        40 + 32,
      );
      _expectBits(
        encodeMultipleSlotBinary(mmsi: 226545000, data: const [1, 2, 3, 4]),
        40 + 32 + 20,
      );
      // Type 14 text field is 968 bits wide, i.e. 161 characters plus a
      // 2-bit spare: a longer text is truncated instead of overflowing.
      _expectBits(
        encodeSafetyBroadcast(mmsi: 226545000, text: 'A' * 200),
        40 + 161 * 6,
      );
    });

    test('type 23 keeps the ship type on 8 bits', () {
      final binary = _binary(
        encodeGroupAssignment(
          mmsi: 226000000,
          neLatitude: 47.5,
          neLongitude: -3,
          swLatitude: 46.5,
          swLongitude: -4,
          stationType: 2,
          shipType: 70,
          quietTime: 5,
        ),
      );
      expect(binary.substring(110, 114), '0010', reason: 'station type');
      expect(binary.substring(114, 122), _bits(70, 8), reason: 'ship type');
      expect(binary.substring(122, 144), _bits(0, 22), reason: 'spare');
      expect(binary.substring(150, 154), _bits(5, 4), reason: 'quiet time');
    });

    test('type 26 ends with the radio status', () {
      final binary = _binary(
        encodeMultipleSlotBinary(mmsi: 226545000, data: const [1, 2, 3, 4]),
      );
      expect(binary.substring(binary.length - 20), _bits(0, 20));
      expect(binary.length, 40 + 32 + 20);
    });
  });

  group('decoder round-trip', () {
    test('every multi-fragment message reassembles in the project decoder', () {
      for (final entry in _allSentences().entries) {
        final decoder = AisNmeaDecoder();
        dynamic decoded;
        for (final line in entry.value.split('\n')) {
          decoded = decoder.decode(line) ?? decoded;
        }
        expect(decoded, isNotNull, reason: 'type ${entry.key} did not decode');
        expect(decoded.messageType, entry.key);
      }
    });
  });
}

/// Every message type the editor can produce, one representative message each.
Map<int, String> _allSentences() => {
  1: encodePositionReport(
    mmsi: 226545000,
    latitude: 48.85,
    longitude: -4.5,
    sog: 12.3,
    cog: 87.6,
    heading: 88,
  ),
  4: encodeBaseStationReport(
    mmsi: 226000000,
    year: 2026,
    month: 8,
    day: 6,
    hour: 12,
    minute: 30,
    second: 15,
    latitude: 47.5,
    longitude: -3.2,
  ),
  5: encodeStaticAndVoyage(
    mmsi: 226545000,
    name: 'KIKAIS',
    callSign: 'FLO21',
    destination: 'BREST',
  ),
  6: encodeBinaryAddressed(
    mmsi: 226545000,
    destinationMmsi: 227000000,
    data: List<int>.filled(115, 1),
  ),
  7: encodeBinaryAcknowledge(
    mmsi: 226545000,
    destinationMmsis: const [227000000, 227000001, 227000002, 227000003],
    sequenceNumbers: const [1, 2, 3, 0],
  ),
  8: encodeBinaryBroadcast(mmsi: 226545000, data: List<int>.filled(115, 1)),
  9: encodeSarAircraftPosition(
    mmsi: 111234567,
    latitude: 48.5,
    longitude: -4.5,
    cog: 200,
    sog: 120,
    altitude: 500,
  ),
  10: encodeUtcDateInquiry(mmsi: 226545000, destinationMmsi: 227000000),
  11: encodeUtcDateResponse(
    mmsi: 226000000,
    year: 2026,
    month: 8,
    day: 6,
    hour: 12,
    minute: 30,
    second: 15,
    latitude: 47.5,
    longitude: -3.2,
  ),
  12: encodeAddressedSafety(
    mmsi: 226545000,
    destinationMmsi: 227000000,
    text: 'A' * 156,
  ),
  13: encodeSafetyAck(
    mmsi: 226545000,
    destinationMmsis: const [227000000, 227000001, 227000002, 227000003],
    sequenceNumbers: const [1, 2, 3, 0],
  ),
  14: encodeSafetyBroadcast(mmsi: 226545000, text: 'A' * 161),
  15: encodeInterrogation(
    mmsi: 226545000,
    mmsi1: 227000000,
    type1_1: 5,
    offset1_1: 100,
    mmsi2: 227000001,
    type2_1: 5,
    offset2_1: 200,
  ),
  16: encodeAssignmentMode(
    mmsi: 226545000,
    mmsi1: 227000000,
    offset1: 10,
    increment1: 3,
    mmsi2: 227000001,
    offset2: 20,
    increment2: 4,
  ),
  17: encodeDgnssBroadcast(
    mmsi: 226545000,
    latitude: 47.5,
    longitude: -3.2,
    data: List<int>.filled(92, 1),
  ),
  18: encodeClassBPosition(
    mmsi: 226545000,
    latitude: 45.5,
    longitude: -1.5,
    sog: 6.5,
    cog: 90,
    heading: 92,
  ),
  19: encodeClassBExtended(
    mmsi: 226545000,
    latitude: 44,
    longitude: -2,
    sog: 3,
    cog: 180,
    heading: 185,
    name: 'CLASSB',
    vesselType: 52,
  ),
  20: encodeDataLinkManagement(
    mmsi: 226545000,
    offset1: 10,
    number1: 2,
    timeout1: 3,
    increment1: 20,
  ),
  21: encodeAidToNavigation(
    mmsi: 992262000,
    name: 'BUOY1',
    aidType: 1,
    latitude: 46.5,
    longitude: -3.5,
    nameExtension: 'EXTENSION',
  ),
  22: encodeChannelManagement(
    mmsi: 226000000,
    channelA: 2087,
    channelB: 2088,
    txrxMode: 0,
    neLatitude: 47.5,
    neLongitude: -3,
    swLatitude: 46.5,
    swLongitude: -4,
  ),
  23: encodeGroupAssignment(
    mmsi: 226000000,
    neLatitude: 47.5,
    neLongitude: -3,
    swLatitude: 46.5,
    swLongitude: -4,
    shipType: 70,
  ),
  24: encodeStaticDataReportPartB(
    mmsi: 226545000,
    shipType: 70,
    callSign: 'FLO21',
  ),
  25: encodeSingleSlotBinary(
    mmsi: 226545000,
    data: List<int>.filled(16, 1),
    destinationMmsi: 227000000,
  ),
  26: encodeMultipleSlotBinary(
    mmsi: 226545000,
    data: List<int>.filled(125, 1),
    destinationMmsi: 227000000,
  ),
  27: encodeLongRangeBroadcast(
    mmsi: 226545000,
    latitude: 41.5,
    longitude: 8.5,
    sog: 3.4,
    cog: 12.3,
  ),
};

String _payload(String line) => line.split(',')[5];

String _binary(String sentence) {
  final lines = sentence.split('\n');
  final payload = lines.map(_payload).join();
  final fill = int.parse(lines.last.split(',').last.split('*').first);
  final bits = payload.split('').map(convertCharToBinary).join();
  return fill == 0 ? bits : bits.substring(0, bits.length - fill);
}

String _bits(int value, int width) =>
    value.toRadixString(2).padLeft(width, '0');

void _expectBits(String sentence, int expected) {
  expect(_binary(sentence).length, expected, reason: sentence);
}
