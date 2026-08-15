import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/tools_data/binary_inspect.dart';

void main() {
  test('bare payload is inspected', () {
    final info = inspectBinary('16:>1`0');
    expect(info, isNotNull);
    expect(info!.sentence, isNull);
    expect(info.payload, '16:>1`0');
    expect(info.binary, '000001000110001010001110000001101000000000');
    expect(info.sixBitValues, [1, 6, 10, 14, 1, 40, 0]);
    expect(info.hex, '04628E06800'); // 42 bits -> 11 hex digits
  });

  test('full sentence payload is extracted', () {
    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final info = inspectBinary(sentence);
    expect(info, isNotNull);
    final parsed = NmeaSentence.tryParse(sentence)!;
    expect(info!.sentence, isNotNull);
    expect(info.payload, parsed.payload);
    expect(info.sixBitValues.length, parsed.payload.length);
  });

  test('hex bytes group into 8-bit chunks', () {
    final info = inspectBinary('16:>1`0')!;
    expect(info.hexBytes.split(' ').length, 6);
    expect(info.hexBytes, '04 62 8E 06 80 00');
    expect(
      info.binaryGrouped,
      '00000100 01100010 10001110 00000110 10000000 00000000',
    );
  });

  test('rejects empty or malformed input', () {
    expect(inspectBinary(''), isNull);
    expect(inspectBinary('   '), isNull);
    expect(inspectBinary('!not a sentence'), isNull);
  });
}
