import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/ais_message_details.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/decoder_page.dart';
import 'package:kik_ais/l10n/generated/app_localizations_en.dart';
import 'package:provider/provider.dart';

import 'l10n_test_utils.dart';

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
  test('describeMessage lists the fields of a decoded position report',
      () {
    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final message = AisNmeaDecoder(validateChecksum: true).decode(sentence);

    expect(message, isNotNull);
    final fields = describeMessage(message!, AppLocalizationsEn());
    final labels = fields.map((f) => f.$1).toList();

    expect(fields.first.$1, 'Message type');
    expect(fields.first.$2, contains('T1'));
    expect(labels, contains('MMSI'));
    expect(labels, contains('Latitude'));
    expect(labels, contains('Longitude'));
    expect(labels, contains('SOG (kn)'));
    expect(labels, contains('COG (°)'));
  });

  testWidgets('decoder page decodes a pasted sentence and shows the details',
      (tester) async {
    final settings = AppSettings();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: withLocalizations(const DecoderPage()),
      ),
    );

    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );

    await tester.enterText(find.byType(TextField), sentence);
    await tester.tap(find.widgetWithText(FilledButton, 'Decode'));
    await tester.pump();

    expect(find.text('Decoded'), findsOneWidget);
    expect(find.textContaining('T1'), findsOneWidget);
    expect(find.text('MMSI'), findsOneWidget);
    expect(find.text('226545000'), findsWidgets);
    // The frame is also shown broken down into coloured field chips.
    expect(find.text('Talker'), findsOneWidget);
    expect(find.text('Payload'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('decoder page groups multi-part fragments into one block',
      (tester) async {
    final settings = AppSettings();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: settings,
        child: withLocalizations(const DecoderPage()),
      ),
    );

    final single = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final full = NmeaSentence.tryParse(
      encodePositionReport(
        mmsi: 227000000,
        latitude: 49.0,
        longitude: -1.5,
        sog: 8.0,
        cog: 120.0,
        heading: 45.0,
      ),
    )!
        .binaryPayload;
    final part1 = _fragment(full.substring(0, 144), 0, 2, 3);
    final part2 = _fragment(full.substring(144), 1, 2, 3);

    await tester.enterText(find.byType(TextField), '$single\n$part1\n$part2');
    await tester.tap(find.widgetWithText(FilledButton, 'Decode'));
    await tester.pump();

    // One block for the single sentence, one grouped block for the two parts.
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.text('Decoded'), findsOneWidget);
    expect(find.text('Decoded (2 sentences)'), findsOneWidget);
    expect(find.textContaining('Waiting for more fragments'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.textContaining(part1),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.textContaining(part2),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
