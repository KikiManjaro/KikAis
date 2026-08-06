import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/boat.dart';
import 'package:kik_ais/bubble_boat.dart';

void main() {
  Boat boatWithFrames() {
    final boat = Boat(mmsi: '226545000');
    boat.addFrame(
      BoatFrame(
        raw: '!AIVDM,1,1,,B,15NpfN@P00GJq?bE`FepT@3n00Sa,0*6C',
        feed: 'US',
        time: DateTime(2026, 8, 7, 12, 4, 33),
        type: 1,
      ),
    );
    boat.addFrame(
      BoatFrame(
        raw: '!AIVDM,2,1,1,B,55NpfN@P00GJq?bE`FepT@3n00Sa,0*6D',
        feed: 'Kikistream.io',
        time: DateTime(2026, 8, 7, 12, 4, 35),
        type: 5,
      ),
    );
    return boat;
  }

  Future<void> pump(WidgetTester tester, Boat boat) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 340,
            height: 600,
            child: BoatInfoBubble(boat: boat),
          ),
        ),
      ),
    );
  }

  testWidgets('frame log lists frames with copy buttons', (tester) async {
    await pump(tester, boatWithFrames());

    expect(find.text('Frames (2)'), findsOneWidget);
    expect(find.textContaining('!AIVDM,1,1'), findsOneWidget);
    expect(find.textContaining('!AIVDM,2,1'), findsOneWidget);
    expect(find.text('US'), findsOneWidget);
    expect(find.byTooltip('Copy all frames'), findsOneWidget);
    // 2 rows + 1 copy-all.
    expect(find.byIcon(Icons.copy), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('copy button shows a toast', (tester) async {
    await pump(tester, boatWithFrames());

    await tester.tap(find.byIcon(Icons.copy).first);
    await tester.pump();

    expect(find.text('Copied'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();
    expect(find.text('Copied'), findsNothing);
  });

  testWidgets('frame log collapses and shows an empty state', (tester) async {
    final boat = Boat(mmsi: '226545000');
    await pump(tester, boat);

    expect(find.text('Frames (0)'), findsOneWidget);
    expect(find.text('No frames yet'), findsOneWidget);

    // Collapse hides the list.
    await tester.tap(find.text('Frames (0)'));
    await tester.pump();
    expect(find.text('No frames yet'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
