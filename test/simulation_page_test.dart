import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/sim_fleet.dart';
import 'package:kik_ais/simulation_page.dart';
import 'package:kik_ais/simulator_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_test_utils.dart';

Widget _app(
  SimulatorService sim,
  AppSettings settings,
  BoatManager boatManager,
) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: boatManager),
      ChangeNotifierProvider.value(value: settings),
    ],
    child: withLocalizations(SimulationPage(simGetter: () => sim)),
  );
}

void main() {
  testWidgets('configuration-only page: no run switch, banner and fleet shown',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    // The simulation is started from the Reception feed, not from this page:
    // the sim never runs and no run switch is shown (only config toggles).
    expect(sim.isRunning, isFalse);
    expect(find.text('Realistic names'), findsOneWidget);
    expect(find.textContaining('forwarder is running'), findsOneWidget);

    // The generated fleet is shown with its role icons.
    expect(find.text('SIM-1'), findsOneWidget);
    expect(find.textContaining('boats'), findsWidgets);
    expect(find.byIcon(Icons.directions_boat), findsWidgets);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('apply fleet updates the generated fleet and persists the config',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    expect(find.textContaining('10 boats'), findsOneWidget);

    // Increase the vessel count and apply.
    await tester.enterText(
      find.widgetWithText(TextField, 'Vessels'),
      '15',
    );
    await tester.ensureVisible(find.text('Apply fleet'));
    await tester.tap(find.text('Apply fleet'));
    await tester.pump();

    expect(find.textContaining('15 boats'), findsOneWidget);
    expect(sim.config.boatCount, 15);
    expect(settings.simConfig.boatCount, 15);
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('realistic names toggle changes the generated fleet',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    await tester.ensureVisible(find.text('Realistic names'));
    await tester.tap(find.text('Realistic names'));
    await tester.pump();

    await tester.ensureVisible(find.text('Apply fleet'));
    await tester.tap(find.text('Apply fleet'));
    await tester.pump();

    expect(sim.config.realisticNames, isTrue);
    expect(settings.simConfig.realisticNames, isTrue);
    expect(find.text('SIM-1'), findsNothing);
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('MMSI search field customises the fleet prefix', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    await tester.ensureVisible(
      find.widgetWithText(TextField, 'MMSI country / MID'),
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'MMSI country / MID'),
      '205',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Belgium (205)'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Apply fleet'));
    await tester.tap(find.text('Apply fleet'));
    await tester.pump();

    expect(sim.config.mmsiMid, 205);
    expect(settings.simConfig.mmsiMid, 205);
    expect(find.textContaining('2050000'), findsWidgets);
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('location preset search fills the coordinates', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    await tester.ensureVisible(
      find.widgetWithText(TextField, 'Location preset'),
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Location preset'),
      'Brest',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Brest —').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Apply fleet'));
    await tester.tap(find.text('Apply fleet'));
    await tester.pump();

    expect(sim.config.centerLat, closeTo(48.39, 0.00001));
    expect(sim.config.centerLon, closeTo(-4.49, 0.00001));
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('a very large fleet renders without building every row',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(
      config: SimFleetConfig(boatCount: 10000, seed: 1),
    );

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    // The count reflects the whole fleet...
    expect(find.textContaining('10000 boats'), findsOneWidget);
    // ...but only the visible rows are actually built (virtualized list), so
    // a tiny number of vessel icons exists instead of one per boat.
    final built = tester
        .widgetList(find.byIcon(Icons.directions_boat))
        .length;
    expect(built, lessThan(100));
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });
}
