import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/documentation_content.dart';
import 'package:kik_ais/documentation_widgets.dart';

import 'l10n_test_utils.dart';

Widget _wrap(Widget child) =>
    withLocalizations(Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  test('kVesselTypesFull exposes the full 0-99 table', () {
    final rows = kVesselTypesFull();
    expect(rows.length, 100);
    final names = rows.map((e) => e.$2).join('\n');
    expect(names, contains('Cargo'));
    expect(names, contains('Tanker'));
    expect(names, contains('Fishing'));
  });

  testWidgets('six-bit encoder shows the 6-bit code of a character', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const SixBitEncoder()));
    await tester.enterText(find.byType(TextField), 'A');
    await tester.pump();
    expect(find.text('000001'), findsOneWidget); // 'A' = value 1
  });

  testWidgets('checksum calculator computes the NMEA XOR', (tester) async {
    await tester.pumpWidget(_wrap(const ChecksumCalculator()));
    // The default body matches the canonical gpsd example whose checksum is 5C.
    expect(find.text('*5C'), findsOneWidget);
  });

  testWidgets('coordinate encoder converts lat/lon to raw integers', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const CoordinateEncoder()));
    expect(find.textContaining('29034000'), findsOneWidget); // 48.39 * 600000
    expect(find.textContaining('-2694000'), findsOneWidget); // -4.49 * 600000
  });

  testWidgets('bit layout viewer switches message layouts', (tester) async {
    await tester.pumpWidget(_wrap(const BitLayoutViewer()));

    expect(find.text('MMSI'), findsWidgets); // type 1 layout

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Type 5 — Static & voyage').last);
    await tester.pumpAndSettle();

    expect(find.text('Ship type'), findsWidgets);
    expect(find.text('IMO'), findsWidgets);
  });

  testWidgets('ship type browser filters the table', (tester) async {
    await tester.pumpWidget(_wrap(const ShipTypeBrowser()));

    await tester.enterText(find.byType(TextField), 'tanker');
    await tester.pump();
    expect(find.textContaining('Tanker'), findsWidgets);

    await tester.enterText(find.byType(TextField), 'sailing');
    await tester.pump();
    expect(find.text('Sailing'), findsWidgets);
    expect(find.textContaining('Tanker'), findsNothing);
  });

  testWidgets('glossary search filters terms', (tester) async {
    await tester.pumpWidget(_wrap(const GlossarySearch()));

    expect(find.text('SOTDMA'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'rate of turn');
    await tester.pump();
    expect(find.text('ROT'), findsOneWidget);
    expect(find.text('SOTDMA'), findsNothing);
  });

  testWidgets('class comparison table renders both columns', (tester) async {
    await tester.pumpWidget(_wrap(const ClassComparisonTable()));
    expect(find.text('Class A'), findsOneWidget);
    expect(find.text('Class B'), findsOneWidget);
    expect(find.textContaining('SOTDMA'), findsWidgets);
  });

  testWidgets('distress device cards render', (tester) async {
    await tester.pumpWidget(_wrap(const DistressDeviceCards()));
    expect(find.text('AIS-SART'), findsOneWidget);
    expect(find.text('MOB'), findsOneWidget);
  });

  testWidgets('gotchas list renders expandable cards', (tester) async {
    await tester.pumpWidget(_wrap(const GotchasList()));
    expect(find.text('Wrong payload lengths'), findsOneWidget);
  });

  testWidgets('cheat sheet renders the key references', (tester) async {
    await tester.pumpWidget(_wrap(const CheatSheet()));
    expect(find.textContaining('161.975'), findsWidgets);
    expect(find.textContaining('AIS-SART'), findsWidgets);
  });
}
