import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/ais_editor_specs.dart';
import 'package:kik_ais/asm_registry.dart';

void main() {
  test('asmFormatFor matches the DAC/FID for binary types', () {
    final fmt = asmFormatFor(8, {'dac': 1, 'fid': 11});
    expect(fmt, isNotNull);
    expect(asmShortKey(fmt!), contains('001/11'));
    expect(fmt.hasLayout, isTrue);

    expect(asmFormatFor(8, {'dac': 999, 'fid': 1}), isNull);
    expect(asmFormatFor(8, {'dac': null, 'fid': 1}), isNull);
    // Non-binary types never match.
    expect(asmFormatFor(1, {'dac': 1, 'fid': 11}), isNull);
  });

  test('ASMs are only offered for the message types they support', () {
    // 001/11 (meteo) is a type-8 broadcast only.
    expect(asmFormatFor(8, {'dac': 1, 'fid': 11}), isNotNull);
    expect(asmFormatFor(6, {'dac': 1, 'fid': 11}), isNull);
    expect(asmFormatFor(25, {'appDac': 1, 'appFid': 11}), isNull);
    // 001/01 (application acknowledgement) is type 6 only.
    expect(asmFormatFor(8, {'dac': 1, 'fid': 1}), isNull);
    expect(asmFormatFor(6, {'dac': 1, 'fid': 1}), isNotNull);
  });

  test('encodeMessage packs ASM sub-fields into type 8 data', () {
    final asm = asmFor(1, 11)!;
    final values = <String, dynamic>{
      'mmsi': 226545000,
      'dac': 1,
      'fid': 11,
      'data': '',
      'asm.day': 15,
      'asm.hour': 12,
      'asm.wspeed': 123,
      'asm.wdir': 225,
    };
    final sentence = encodeMessage(8, values);
    final msg = AisNmeaDecoder().decode(sentence);
    expect(msg, isA<BinaryBroadcastMessage>());
    final expected = packAsmData(asm, values);
    final data = (msg as BinaryBroadcastMessage).data;
    expect(data.sublist(0, expected.length), expected);
  });

  test('raw Data bytes are used when dataSource is raw', () {
    final sentence = encodeMessage(
      8,
      {
        'mmsi': 226545000,
        'dac': 1,
        'fid': 11,
        'data': [1, 2, 3],
        'asm.avgWindSpeed': 99,
      },
      dataSource: EditorDataSource.raw,
    );
    final msg = AisNmeaDecoder().decode(sentence);
    final data = (msg as BinaryBroadcastMessage).data;
    expect(data.sublist(0, 3), [1, 2, 3]);
  });

  test('dataSource asm packs the ASM even when raw bytes are present', () {
    final asm = asmFor(1, 11)!;
    final values = <String, dynamic>{
      'mmsi': 226545000,
      'dac': 1,
      'fid': 11,
      'data': [9, 9, 9],
      'asm.day': 15,
      'asm.hour': 12,
    };
    final sentence = encodeMessage(
      8,
      values,
      dataSource: EditorDataSource.asm,
    );
    final msg = AisNmeaDecoder().decode(sentence);
    final expected = packAsmData(asm, values);
    final data = (msg as BinaryBroadcastMessage).data;
    expect(data.sublist(0, expected.length), expected);
    expect(data[0], isNot(9));
  });

  test('unknown ASM falls back to raw bytes regardless of source', () {
    final sentence = encodeMessage(
      8,
      {'mmsi': 226545000, 'dac': 366, 'fid': 1, 'data': [7, 8, 9]},
      dataSource: EditorDataSource.asm,
    );
    final msg = AisNmeaDecoder().decode(sentence);
    expect((msg as BinaryBroadcastMessage).data.sublist(0, 3), [7, 8, 9]);
  });
}
