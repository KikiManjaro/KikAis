import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boat_animation.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/reception_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('simulation feed emits frames when started with the forwarder',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final boat = BoatAnimationController();
    final running = ValueNotifier(false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: boatManager),
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider.value(value: stats),
        ],
        child: MaterialApp(
          home: ReceptionPage(boat, running: running),
        ),
      ),
    );
    await tester.pump();

    // The Simulation feed is listed among the feeds, disabled by default.
    expect(
      find.widgetWithText(CheckboxListTile, 'Simulation'),
      findsOneWidget,
    );

    // Nothing runs while the forwarder is stopped.
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(boatManager.boats, isEmpty);

    // Enable the simulation feed and start the forwarder.
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Simulation'));
    await tester.pump();
    await tester.tap(find.text('Start'));
    await tester.pump();

    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pump(const Duration(milliseconds: 50));

    // Frames were decoded into the boat manager and logged as Simulation.
    expect(boatManager.boats, isNotEmpty);
    expect(find.textContaining('[Simulation]'), findsWidgets);
    expect(find.textContaining('frames emitted'), findsNothing);

    // Disabling the feed stops the simulation: no new frames arrive.
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Simulation'));
    await tester.pump();
    final before = boatManager.boats.length;
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(boatManager.boats.length, before);
    expect(tester.takeException(), isNull);

    boatManager.dispose();
    stats.dispose();
    boat.dispose();
    running.dispose();
  });
}
