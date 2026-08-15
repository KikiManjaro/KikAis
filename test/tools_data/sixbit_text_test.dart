import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/ais/src/utils/convert_char_to_bin.dart';
import 'package:kik_ais/tools_data/sixbit_text.dart';

void main() {
  test('encodes text into the AIS 6-bit data alphabet', () {
    final values = encodeTextSixBit('HEL');
    // 'H' = 8, 'E' = 5, 'L' = 12 in the aisDataChars alphabet.
    expect(values, [8, 5, 12]);
  });

  test('text is uppercased and unknown chars become a space', () {
    final values = encodeTextSixBit('é');
    expect(values, [32]);
    expect(encodeTextSixBit('abc'), encodeTextSixBit('ABC'));
  });

  test('sixBitValuesToBinary pads to 6 bits per value', () {
    expect(sixBitValuesToBinary([1, 2]), '000001000010');
  });

  test('binaryToHex pads to a nibble boundary', () {
    expect(binaryToHex('0100'), '4');
    expect(binaryToHex('01000001'), '41');
    // 6 bits -> 8 bits padded -> '0E'? '000110' padded to '00011000' = 0x18.
    expect(binaryToHex('000110'), '18');
  });

  test('binaryToBytes groups 8 bits with trailing zero padding', () {
    expect(binaryToBytes('01001000'), [72]);
    // 4 bits -> one zero-padded byte.
    expect(binaryToBytes('0100'), [64]);
  });

  test('editor list and hex pair formats', () {
    final bytes = binaryToBytes(sixBitValuesToBinary(encodeTextSixBit('HEL')));
    expect(bytes, [32, 83, 0]); // 6-bit groups packed into bytes
    expect(bytesToEditorList(bytes), '32,83,0');
    expect(bytesToHexPairs(bytes), '20 53 00');
  });

  test('armored payload round-trips through the decoder', () {
    // Build a type 8 broadcast whose data bytes are the 6-bit text of 'HEL'.
    final bytes = binaryToBytes(sixBitValuesToBinary(encodeTextSixBit('HEL')));
    final sentence = encodeBinaryBroadcast(
      mmsi: 226545000,
      dac: 1,
      fid: 11,
      data: bytes,
    );
    final message = AisNmeaDecoder().decode(sentence);
    expect(message, isA<BinaryBroadcastMessage>());
    final data = (message as BinaryBroadcastMessage).data;
    // The decoder pads the frame to 1008 bits; the data starts with our bytes.
    expect(data.sublist(0, 3), bytes);
  });

  test('toAisPayload armors binary into 6-bit payload chars', () {
    final payload = toAisPayload(sixBitValuesToBinary(encodeTextSixBit('HEL')));
    // Every armored char is in the payload alphabet and decodes to the values.
    final decoded = payload.split('').map(aisCharToValue).toList();
    expect(decoded, [8, 5, 12]);
  });
}
