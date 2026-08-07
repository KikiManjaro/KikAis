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

  testWidgets('apply fleet updates the generated fleet and persists it',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final sim = SimulatorService(config: settings.simConfig);

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    expect(find.text('SIM-10'), findsOneWidget); // 10 boats by default

    // Increase the vessel count and apply.
    await tester.enterText(
      find.widgetWithText(TextField, 'Vessels'),
      '15',
    );
    await tester.ensureVisible(find.text('Apply fleet'));
    await tester.tap(find.text('Apply fleet'));
    await tester.pump();

    expect(find.text('SIM-15'), findsOneWidget);
    expect(sim.config.boatCount, 15);
    expect(settings.simConfig.boatCount, 15);
    expect(settings.simFleet, hasLength(15));
    expect(tester.takeException(), isNull);

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('restores the persisted fleet on startup', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();

    // A fleet that was saved before a restart (with a renamed vessel).
    final fleet = SimFleet();
    fleet.generate(
      SimFleetConfig(seed: 3, boatCount: 20, messageTypes: {1, 5, 4, 21}),
    );
    fleet.boats.first.name = 'KEEPER';
    settings.simFleet = fleet.boats.toList();
    final sim = SimulatorService(
      config: settings.simConfig,
      initialFleet: settings.simFleet,
    );

    await tester.pumpWidget(_app(sim, settings, boatManager));
    await tester.pump();

    // The restored fleet (24 = 20 vessels + base + 3 AtoN) is shown. Each
    // vessel row carries a role icon; the "Live fleet" header adds one more.
    expect(find.text('KEEPER'), findsOneWidget);
    expect(find.text('SIM BASE'), findsOneWidget);
    expect(find.byIcon(Icons.directions_boat), findsNWidgets(21));
    expect(find.byIcon(Icons.radio), findsOneWidget);
    expect(find.byIcon(Icons.anchor), findsNWidgets(3));

    sim.dispose();
    boatManager.dispose();
    stats.dispose();
  });
}
