import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/asm_registry.dart';

void main() {
  test('catalog covers all message types and keeps duplicates', () {
    expect(kAsmFormats.length, 148);
    expect(kAsmFormats.where((a) => a.types.contains(6)).length, 57);
    expect(kAsmFormats.where((a) => a.types.contains(8)).length, 56);
    expect(kAsmFormats.where((a) => a.types.contains(25)).length, 6);
    expect(kAsmFormats.where((a) => a.types.contains(26)).length, 30);

    // 001/16 exists three times: 2× "Number of persons on board"
    // (IMO236 + IMO289, type 6) and "VTS targets" (type 8).
    final dup = kAsmFormats.where((a) => a.dac == 1 && a.fid == 16);
    expect(dup.length, 3);
    expect(dup.map(asmKey).toSet().length, 3); // all keys distinct
  });

  test('every catalog entry has a unique key', () {
    final keys = kAsmFormats.map(asmKey).toList();
    expect(keys.toSet().length, keys.length);
  });

  test('asmFor finds known formats and rejects unknown', () {
    final imo = asmFor(1, 11);
    expect(imo, isNotNull);
    expect(asmShortKey(imo!), contains('001/11'));
    expect(imo.hasLayout, isTrue);
    expect(asmFor(999, 1), isNull);
    expect(asmFor(1, 99), isNull);
  });

  test('asmForMessage only matches ASMs valid for the message type', () {
    // 001/11 meteo is a type-8 broadcast.
    expect(asmForMessage(8, 1, 11), isNotNull);
    expect(asmForMessage(6, 1, 11), isNull);
    expect(asmForMessage(25, 1, 11), isNull);
    // 001/02 IAI interrogation is type 6 only.
    expect(asmForMessage(6, 1, 2), isNotNull);
    expect(asmForMessage(8, 1, 2), isNull);
    // 001/16 is ambiguous for type 6 (two persons entries) -> null;
    // but unique for type 8 (VTS targets).
    expect(asmForMessage(6, 1, 16), isNull);
    expect(asmForMessage(8, 1, 16), isNotNull);
    expect(asmForMessage(8, 999, 1), isNull);
  });

  test('validFor reports the declared message types', () {
    expect(asmFor(1, 11)!.validFor(8), isTrue);
    expect(asmFor(1, 11)!.validFor(6), isFalse);
    expect(asmFor(1, 2)!.validFor(6), isTrue);
    expect(asmFor(1, 2)!.validFor(8), isFalse);
  });

  test('deprecated entries carry their deprecation note', () {
    final oldMeteo = asmFor(1, 11)!;
    expect(oldMeteo.state, AsmState.deprecated);
    expect(oldMeteo.isDeprecated, isTrue);
    expect(oldMeteo.deprecatedSince, contains('01/01/2013'));
    expect(oldMeteo.notToBeUsedAfter, '01/01/2013');

    final newMeteo = asmFor(1, 31)!;
    expect(newMeteo.state, AsmState.inForce);
    expect(newMeteo.isDeprecated, isFalse);
    expect(newMeteo.hasLayout, isTrue);
  });

  test('layout-less entries fall back to empty bytes', () {
    final waypoints = asmFor(1, 17)!; // Ship waypoints (no transcribed layout)
    expect(waypoints.hasLayout, isFalse);
    expect(packAsmData(waypoints, const {}), isEmpty);
  });

  test('packed data round-trips through the type 8 decoder', () {
    final asm = asmFor(1, 11)!;
    final values = <String, dynamic>{
      'asm.lon': 630000,
      'asm.lat': 2900000,
      'asm.day': 15,
      'asm.hour': 12,
      'asm.minute': 30,
      'asm.wspeed': 123,
      'asm.airtemp': 175,
      'asm.watertemp': -20,
    };
    final bytes = packAsmData(asm, values);
    final sentence = encodeBinaryBroadcast(
      mmsi: 226545000,
      dac: 1,
      fid: 11,
      data: bytes,
    );
    final message = AisNmeaDecoder().decode(sentence);
    expect(message, isA<BinaryBroadcastMessage>());
    final data = (message as BinaryBroadcastMessage).data;
    expect(data.sublist(0, bytes.length), bytes);
  });

  test('documented fixed-length ASMs sum to their declared length', () {
    const cases = {
      (8, 1, 11): 352, // IMO236 meteo
      (8, 1, 13): 472, // fairway closed
      (8, 1, 15): 72, // extended static IMO236
      (8, 1, 19): 360, // marine traffic signal
      (8, 1, 21): 360, // weather observation
      (8, 1, 24): 360, // extended static IMO289
      (8, 200, 10): 168, // inland static
      (8, 200, 23): 256, // EMMA
      (6, 200, 21): 248, // ETA
      (6, 200, 22): 232, // RTA
      (6, 200, 55): 168, // inland persons
      (6, 235, 10): 136, // AtoN monitoring
    };
    for (final e in cases.entries) {
      final (type, dac, fid) = e.key;
      final asm = kAsmFormats.firstWhere(
        (a) => a.dac == dac && a.fid == fid && a.validFor(type),
      );
      expect(asm.hasLayout, isTrue, reason: asm.name);
      final sum = asm.fields.fold<int>(0, (a, f) => a + f.bits);
      expect(sum, e.value, reason: '${asm.name} (bits)');
    }
  });

  test('the catalog ships layouts for the documented gpsd ASMs', () {
    final withLayout = kAsmFormats.where((a) => a.hasLayout).length;
    expect(withLayout, greaterThanOrEqualTo(25));
  });

  test('free-text ASM packs variable-width 6-bit ASCII and round-trips', () {
    final asm = asmFor(1, 0)!; // Text using 6-bit ASCII
    expect(asm.hasLayout, isTrue);
    final base = <String, dynamic>{'asm.text': 'HELLO'};
    // 68-bit header + 5 chars * 6 bits = 98 bits -> 13 bytes
    final hello = packAsmData(asm, base);
    expect(hello.length, 13);
    expect(hello.sublist(8), [2, 5, 48, 195, 192]); // 'HELLO' encoded
    // 68-bit header + 2 chars * 6 bits = 80 bits -> 10 bytes
    final hi = packAsmData(asm, {'asm.text': 'HI'});
    expect(hi.length, 10);

    final sentence = encodeBinaryAddressed(
      mmsi: 226545000,
      destinationMmsi: 227000000,
      dac: 1,
      fid: 0,
      data: hello,
    );
    final msg = AisNmeaDecoder().decode(sentence);
    expect(msg, isA<BinaryAddressedMessage>());
    final data = (msg as BinaryAddressedMessage).data;
    expect(data.sublist(0, hello.length), hello);
  });

  test('signed fields use two\'s complement', () {
    final asm = asmFor(1, 11)!;
    // IMO236 layout: type/repeat/mmsi/spare/dac/fid = 56 bits, then a 25-bit
    // signed Longitude. -1 in two's complement is all ones.
    final bytes = packAsmData(asm, {'asm.lon': -1});
    expect(bytes.length, greaterThan(10));
    expect(bytes[10], 0xFF); // longitude (25-bit -1) starts at bit 80
  });
}
