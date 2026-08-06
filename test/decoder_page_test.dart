import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/ais_message_details.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/decoder_page.dart';
import 'package:provider/provider.dart';

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
    final fields = describeMessage(message!);
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
        child: const MaterialApp(home: DecoderPage()),
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
    expect(tester.takeException(), isNull);
  });
}
