import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/swipper.dart';
import 'package:kik_ais/update_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kik_ais/l10n/generated/app_localizations.dart';

/// Lightweight wrapper that provides all providers required by [SwipperUi]
/// without running the heavy `main()` initialization (BoatManager isolate,
/// PackageInfo, auto-updater, file I/O, …).
///
/// Mirrors the patterns used in `test/reception_sim_test.dart`,
/// `test/map_page_test.dart` and `test/simulation_page_test.dart`.
Widget _testApp({
  required BoatManager boatManager,
  required AppSettings settings,
  required MessageStats stats,
  required UpdateNotifier updateNotifier,
  String version = 'test',
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: boatManager),
      ChangeNotifierProvider.value(value: settings),
      ChangeNotifierProvider.value(value: stats),
      ChangeNotifierProvider.value(value: updateNotifier),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: SwipperUi(version: version),
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('all 8 pages render without errors', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    final updateNotifier = UpdateNotifier();

    await tester.pumpWidget(
      _testApp(
        boatManager: boatManager,
        settings: settings,
        stats: stats,
        updateNotifier: updateNotifier,
      ),
    );
    await tester.pumpAndSettle();

    // Sanity: NavigationBar with 8 destinations must be present.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(8));
    expect(find.byType(IndexedStack), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Page order (index): 0=Reception, 1=Send, 2=Map, 3=Editor,
    // 4=Tools, 5=Stats, 6=Simulation, 7=Documentation
    const pageLabels = [
      'Reception',
      'Send',
      'Map',
      'Editor',
      'Tools',
      'Stats',
      'Simulation',
      'Documentation',
    ];

    for (var i = 0; i < 8; i++) {
      // Navigate by tapping the NavigationDestination at index i.
      // This mirrors the NavigationBar click approach used by
      // scripts/take_screenshots.sh (center_x = (i+0.5)*(width/8)).
      final destinations = find.byType(NavigationDestination);
      expect(destinations, findsNWidgets(8),
          reason: 'NavigationBar must still have 8 destinations on page $i');

      await tester.tap(destinations.at(i));
      await tester.pumpAndSettle();

      // Verify the page rendered: IndexedStack still present and no
      // widget exception was thrown during the transition.
      expect(find.byType(IndexedStack), findsOneWidget,
          reason: 'IndexedStack missing after navigating to ${pageLabels[i]}');
      expect(find.byType(NavigationBar), findsOneWidget,
          reason: 'NavigationBar missing after navigating to ${pageLabels[i]}');
      expect(tester.takeException(), isNull,
          reason: 'Exception while rendering ${pageLabels[i]} (index $i)');

      // Optional: verify the selected index matches the tapped destination.
      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, i,
          reason: 'NavigationBar selectedIndex should be $i after tapping ${pageLabels[i]}');
    }

    // Clean up
    boatManager.dispose();
    stats.dispose();
    updateNotifier.dispose();
  });
}
