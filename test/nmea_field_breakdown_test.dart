import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/nmea_field_breakdown.dart';

import 'l10n_test_utils.dart';

const _sample = '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

Widget _wrap(Brightness brightness) => withLocalizations(
  Scaffold(
    body: SingleChildScrollView(child: NmeaFieldBreakdown(sentence: _sample)),
  ),
  theme: ThemeData(brightness: brightness),
);

void main() {
  testWidgets('renders the field chips of a sentence', (tester) async {
    await tester.pumpWidget(_wrap(Brightness.dark));

    expect(find.text('Talker'), findsOneWidget);
    expect(find.text('Fragments'), findsOneWidget);
    expect(find.text('Payload'), findsOneWidget);
    expect(find.text('Fill bits'), findsOneWidget);
    expect(find.text('Checksum'), findsOneWidget);
  });

  testWidgets('labels are dark enough on the light theme', (tester) async {
    await tester.pumpWidget(_wrap(Brightness.light));

    final label = tester.widget<Text>(find.text('Message ID'));
    final luminance = label.style!.color!.computeLuminance();
    expect(luminance, lessThan(0.5));
  });

  testWidgets('labels are light enough on the dark theme', (tester) async {
    await tester.pumpWidget(_wrap(Brightness.dark));

    final label = tester.widget<Text>(find.text('Message ID'));
    final luminance = label.style!.color!.computeLuminance();
    expect(luminance, greaterThan(0.5));
  });
}
