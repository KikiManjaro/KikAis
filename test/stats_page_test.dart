import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/stats_page.dart';
import 'package:provider/provider.dart';

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
        child: const MaterialApp(home: StatsPage()),
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
}
