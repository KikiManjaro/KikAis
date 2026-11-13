import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/messages/binary/multiple_slot_binary_message.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';
import 'package:kik_ais/ais/src/utils/get_int.dart';

/// Type 26 is the only variable-length message that ends with a fixed 20-bit
/// radio status. Its decoder used to derive the end of the data from
/// `payload.trimRight().length`, i.e. a count of armored *characters* used as a
/// *bit* offset, minus every trailing '0' character. Short payloads therefore
/// decoded with empty data and a radio status read from the header.
void main() {
  final decoder = AisNmeaDecoder();

  MultipleSlotBinaryMessage decode(String sentence) {
    final message = decoder.decode(sentence);
    expect(message, isA<MultipleSlotBinaryMessage>());
    return message as MultipleSlotBinaryMessage;
  }

  group('round-trip', () {
    test('addressed payload keeps its data and an empty radio status', () {
      final sentence = encodeMultipleSlotBinary(
        mmsi: 226545000,
        data: const [1, 2, 3, 4],
        destinationMmsi: 227000000,
        applicationId: (1, 31),
      );
      final message = decode(sentence);
      expect(message.destinationMmsi, 227000000);
      expect(message.dac, 1);
      expect(message.fid, 31);
      expect(message.data, [1, 2, 3, 4]);
      expect(message.radioStatus, 0);
    });

    test('broadcast payload without address keeps its data', () {
      final sentence = encodeMultipleSlotBinary(
        mmsi: 226545000,
        data: const [9, 8, 7],
      );
      final message = decode(sentence);
      expect(message.data, [9, 8, 7]);
      expect(message.radioStatus, 0);
    });

    test('data ending with zero bits is not truncated', () {
      final sentence = encodeMultipleSlotBinary(
        mmsi: 226545000,
        data: const [1, 2, 0, 0, 0, 0],
        destinationMmsi: 227000000,
      );
      final message = decode(sentence);
      expect(message.data, [1, 2, 0, 0, 0, 0]);
      expect(message.radioStatus, 0);
    });

    test('maximum payload keeps every byte', () {
      final data = List<int>.generate(119, (i) => (i * 7) & 0xFF);
      final sentence = encodeMultipleSlotBinary(
        mmsi: 226545000,
        data: data,
        destinationMmsi: 227000000,
        applicationId: (1, 31),
      );
      final message = decode(sentence);
      expect(message.data.length, 119);
      expect(message.data, data);
      expect(message.radioStatus, 0);
    });
  });

  group('real-world sentence', () {
    // gpsd sample: 48 armored characters, no fill bits.
    const sentence =
        '!AIVDM,1,1,,A,J1@@0IK70PGgT740000000000@000?D0ih1e00006JlPC9C3,0*6B';

    test('radio status is read from the last 20 bits of the payload', () {
      final message = decode(sentence);
      final payload = sentence.split(',')[5];
      final totalBits = payload.length * 6;
      expect(
        message.radioStatus,
        getUintDirect(payload, totalBits - 20, totalBits),
      );
    });

    test('data is not reduced to a handful of bytes', () {
      final message = decode(sentence);
      expect(message.data.length, greaterThan(10));
    });
  });
}
