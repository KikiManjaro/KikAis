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
    child: MaterialApp(
      home: SimulationPage(simGetter: () => sim),
    ),
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

    // The simulation is started from the Reception feed, not from this page.
    expect(find.byType(Switch), findsNothing);
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
