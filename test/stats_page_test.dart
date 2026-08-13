import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/stats_page.dart';
import 'package:provider/provider.dart';

import 'l10n_test_utils.dart';

void main() {
  testWidgets('stats page feed filter narrows the dashboard', (tester) async {
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();

    stats.recordReceived('US');
    stats.recordReceived('US');
    stats.recordReceived('NO');
    stats.recordDecoded(1, feed: 'US');
    stats.recordDecoded(5, feed: 'NO');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: boatManager),
          ChangeNotifierProvider.value(value: stats),
          ChangeNotifierProvider.value(value: settings),
        ],
        child: withLocalizations(const StatsPage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1100));

    // All feeds: 3 received.
    expect(find.text('3'), findsWidgets);
    expect(find.text('All feeds'), findsOneWidget);

    // Switch to the US feed.
    await tester.tap(find.text('All feeds'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('US').last);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Feed: US'), findsOneWidget);
    expect(find.text('US'), findsWidgets);
    expect(tester.takeException(), isNull);

    boatManager.dispose();
    stats.dispose();
  });

  testWidgets('stats page shows a reconciled accounting', (tester) async {
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();

    stats.recordReceived('US');
    stats.recordReceived('US');
    stats.recordReceived('NO');
    stats.recordDecoded(1, feed: 'US');

    boatManager.invalidChecksumCount = 1;
    boatManager.parseErrorCount = 1;
    boatManager.fragmentsSeen = 1;
    boatManager.multiPartCompleted = 1;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: boatManager),
          ChangeNotifierProvider.value(value: stats),
          ChangeNotifierProvider.value(value: settings),
        ],
        child: withLocalizations(const StatsPage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1100));

    // Received 3 = 1 decoded + 1 invalid + 1 parse error.
    expect(find.text('Accounting'), findsOneWidget);
    expect(find.text('Received 3 = 3'), findsOneWidget);
    expect(find.text('Received and decoded reconcile.'), findsOneWidget);

    boatManager.dispose();
    stats.dispose();
  });
}
