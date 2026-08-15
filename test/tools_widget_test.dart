import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/tools/binary_inspector_tool.dart';
import 'package:kik_ais/tools/checksum_tool.dart';
import 'package:kik_ais/tools/eta_calculator_tool.dart';
import 'package:kik_ais/tools/mmsi_lookup_tool.dart';
import 'package:kik_ais/tools/radio_range_tool.dart';
import 'package:kik_ais/tools/speed_converter_tool.dart';
import 'package:kik_ais/tools/text_to_binary_tool.dart';

import 'l10n_test_utils.dart';

Future<void> _pump(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(withLocalizations(Scaffold(body: widget)));
}

void main() {
  testWidgets('checksum tool validates and repairs a sentence',
      (tester) async {
    await _pump(tester, const ChecksumTool());
    final good = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final bad = good.replaceFirst(RegExp(r'\*..$'), '*00');

    await tester.enterText(find.byType(TextField), bad);
    await tester.pump();
    expect(find.text('Checksum mismatch'), findsOneWidget);

    await tester.tap(find.text('Fix checksum'));
    await tester.pump();
    expect(find.text('Checksum valid'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mmsi lookup shows MID, country and station type',
      (tester) async {
    await _pump(tester, const MmsiLookupTool());
    await tester.enterText(find.byType(TextField), '226545000');
    await tester.pump();
    expect(find.text('Valid MMSI'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(find.text('Coast station'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('speed converter converts 10 kn to km/h', (tester) async {
    await _pump(tester, const SpeedConverterTool());
    await tester.enterText(find.byType(TextField), '10');
    await tester.pump();
    expect(find.text('18.52'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('text to binary shows bytes and armored payload',
      (tester) async {
    await _pump(tester, const TextToBinaryTool());
    await tester.enterText(find.byType(TextField), 'HEL');
    await tester.pump();
    expect(find.textContaining('32,83,0'), findsOneWidget);
    expect(find.textContaining('20 53 00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('eta calculator computes type-5 fields', (tester) async {
    await _pump(tester, const EtaCalculatorTool());
    expect(tester.takeException(), isNull,
        reason: 'overflow on initial build');
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '60');
    await tester.pump();
    expect(tester.takeException(), isNull,
        reason: 'overflow after distance');
    await tester.enterText(fields.at(1), '15');
    await tester.pump();
    expect(tester.takeException(), isNull,
        reason: 'overflow after speed');
    expect(find.text('AIS type-5 ETA fields'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Minute'), findsOneWidget);
  });

  testWidgets('radio range computes the horizon', (tester) async {
    await _pump(tester, const RadioRangeTool());
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '9');
    await tester.enterText(fields.at(1), '0');
    await tester.pump();
    expect(find.text('6.7 nm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('binary inspector shows hex of a payload', (tester) async {
    await _pump(tester, const BinaryInspectorTool());
    await tester.enterText(find.byType(TextField), '16:>1`0');
    await tester.pump();
    expect(find.text('04628E06800'), findsOneWidget);
    expect(find.text('04 62 8E 06 80 00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
