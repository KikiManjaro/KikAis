import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/documentation_page.dart';

import 'l10n_test_utils.dart';

Widget _app(DocumentationPage page) => withLocalizations(page);

Future<void> _pump(WidgetTester tester, DocumentationPage page) async {
  await tester.pumpWidget(_app(page));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the searchable chapter table of contents',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    expect(find.text('Overview'), findsWidgets);
    expect(find.text('History & regulation'), findsWidgets);
    expect(find.text('The 27 messages'), findsWidgets);
    expect(find.text('Sources'), findsWidgets);
    expect(find.text('Radio & TDMA'), findsWidgets);
    expect(find.text('Classes & equipment'), findsWidgets);
    expect(find.text('Ship types'), findsWidgets);
    expect(find.text('Field notes'), findsWidgets);
    expect(find.text('Glossary'), findsWidgets);
    expect(find.text('Cheat sheet'), findsWidgets);
  });

  testWidgets('chapter search matches keywords', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    await tester.enterText(
      find.widgetWithText(TextField, 'Search chapters'),
      'sotdma',
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Radio & TDMA'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Classes & equipment'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Overview'), findsNothing);
  });

  testWidgets('cheat sheet chapter renders the reference', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    await tester.tap(find.widgetWithText(ListTile, 'Cheat sheet'));
    await tester.pumpAndSettle();

    expect(find.textContaining('161.975'), findsWidgets);
  });

  testWidgets('chapter navigation switches the content', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    await tester.tap(
      find.widgetWithText(ListTile, 'History & regulation'),
    );
    await tester.pumpAndSettle();

    expect(find.text('A Swedish invention'), findsOneWidget);
  });

  testWidgets('message catalog expands a type and shows its decoded sample',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(
      onOpenTab: (_) {},
      onOpenInDecoder: (_) {},
    ));

    await tester.tap(find.widgetWithText(ListTile, 'The 27 messages'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Type 1 — Position Report Class A'));
    await tester.tap(find.text('Type 1 — Position Report Class A'));
    await tester.pumpAndSettle();

    expect(find.textContaining('!AIVDM'), findsWidgets);
    await tester.ensureVisible(find.text('Open in Decoder'));
    expect(find.text('Open in Decoder'), findsOneWidget);
  });

  testWidgets('open in decoder forwards the sample sentence', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    String? sent;
    await _pump(
      tester,
      DocumentationPage(
        onOpenTab: (_) {},
        onOpenInDecoder: (s) => sent = s,
      ),
    );

    await tester.tap(find.widgetWithText(ListTile, 'The 27 messages'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Type 1 — Position Report Class A'));
    await tester.tap(find.text('Type 1 — Position Report Class A'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open in Decoder'));
    await tester.tap(find.text('Open in Decoder'));
    await tester.pumpAndSettle();

    expect(sent, isNotNull);
    expect(sent, startsWith('!AIVDM'));
  });

  testWidgets('sentence inspector breaks a sentence into fields',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    await tester.tap(find.widgetWithText(ListTile, 'NMEA & AIVDM'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Inspect'));
    await tester.tap(find.text('Inspect'));
    await tester.pumpAndSettle();

    expect(find.text('Talker'), findsWidgets);
    expect(find.text('Payload'), findsWidgets);
    expect(find.text('Checksum'), findsWidgets);
  });

  testWidgets('MMSI lookup reports country and class', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, DocumentationPage(onOpenTab: (_) {}));

    await tester.tap(find.widgetWithText(ListTile, 'MMSI & identity'));
    await tester.pumpAndSettle();

    final field = find.widgetWithText(TextField, 'MMSI (9 digits)');
    await tester.ensureVisible(field);
    await tester.enterText(field, '227123456');
    await tester.ensureVisible(find.text('Look up'));
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();

    expect(find.textContaining('France'), findsWidgets);
  });

  testWidgets('AIS in KikAis chapter triggers tab navigation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    int? opened;
    await _pump(tester, DocumentationPage(onOpenTab: (i) => opened = i));

    await tester.tap(find.widgetWithText(ListTile, 'AIS in KikAis'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open').first);
    await tester.tap(find.text('Open').first);
    await tester.pumpAndSettle();

    expect(opened, isNotNull);
  });
}
