import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boat_animation.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/feed_def.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/reception_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory tempDir;
  late String logPath;

  const sentences = [
    '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52',
    '!AIVDM,1,1,,A,13UuUj0P2GQcS?hE`uKj8gwL2@KF,0*72',
    '!AIVDM,1,1,,A,15RTgt0PAso;90TKcjM8h6g208CQ,0*4A',
  ];

  setUpAll(() async {
    tempDir = Directory.systemTemp.createTempSync('kikais_recv_feed');
    final file = File('${tempDir.path}/log.txt');
    await file.writeAsString('${sentences.join('\n')}\n');
    logPath = file.path;
  });

  tearDownAll(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  Future<({BoatManager boatManager, MessageStats stats, BoatAnimationController boat, ValueNotifier<bool> running})> pumpReception(
    WidgetTester tester, {
    List<FeedDef> customFeeds = const [],
    Map<String, bool> enabled = const {},
  }) async {
    // Enlarge the viewport so every feed tile is built (the feeds card
    // switches to a lazy ListView when the tiles overflow).
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    settings.customFeeds = List.of(customFeeds);
    settings.feedEnabled.addAll(enabled);
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
    return (
      boatManager: boatManager,
      stats: stats,
      boat: boat,
      running: running,
    );
  }

  /// Disposes the objects created by [pumpReception] so their periodic timers
  /// (sampler, purge, status) are cancelled before the test framework checks
  /// for pending timers.
  void disposeTest({
    required BoatManager boatManager,
    required MessageStats stats,
    required BoatAnimationController boat,
    required ValueNotifier<bool> running,
  }) {
    boatManager.dispose();
    stats.dispose();
    boat.dispose();
    running.dispose();
  }

  /// Starts the forwarder and lets the file feed replay on real time. The tap
  /// happens inside [WidgetTester.runAsync] so the whole start sequence (real
  /// file IO, then the periodic replay timer) runs on the real event loop.
  Future<void> startWithRealReplay(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.tap(find.text('Start'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pump();
  }

  FeedDef fileFeed({bool loop = true, int intervalMs = 50}) => FeedDef(
        key: 'Log',
        displayName: 'Log',
        type: FeedType.file,
        path: logPath,
        intervalMs: intervalMs,
        loop: loop,
      );

  testWidgets('file feed tile is listed and replays frames when started',
      (tester) async {
    final ctx =
        await pumpReception(tester, customFeeds: [fileFeed()], enabled: {'Log': true});
    final boatManager = ctx.boatManager;

    // The file feed is listed among the feeds.
    expect(find.widgetWithText(CheckboxListTile, 'Log'), findsOneWidget);

    // Nothing runs while the forwarder is stopped.
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(boatManager.boats, isEmpty);

    // Start the forwarder; the file is read then replayed.
    await startWithRealReplay(tester);

    // Frames were decoded into the boat manager and logged with the feed name.
    expect(boatManager.boats, isNotEmpty);
    expect(find.textContaining('[Log]'), findsWidgets);

    // Stopping the forwarder stops the replay.
    await tester.tap(find.text('Stop'));
    await tester.pump();
    // Log lines are flushed in a batched timer; let it settle before counting.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    final before = find.textContaining('[Log]').evaluate().length;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    expect(find.textContaining('[Log]').evaluate().length, before);
    expect(tester.takeException(), isNull);
    disposeTest(
      boatManager: ctx.boatManager,
      stats: ctx.stats,
      boat: ctx.boat,
      running: ctx.running,
    );
  });

  testWidgets('file feed stops when disabled', (tester) async {
    final ctx = await pumpReception(
      tester,
      customFeeds: [fileFeed(loop: true)],
      enabled: {'Log': true},
    );
    final boatManager = ctx.boatManager;

    await startWithRealReplay(tester);
    expect(boatManager.boats, isNotEmpty);

    // Disabling the feed stops the replay: no new frames are logged.
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Log'));
    await tester.pump();
    // Log lines are flushed in a batched timer; let it settle before counting.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    final before = find.textContaining('[Log]').evaluate().length;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    expect(find.textContaining('[Log]').evaluate().length, before);
    expect(tester.takeException(), isNull);
    disposeTest(
      boatManager: ctx.boatManager,
      stats: ctx.stats,
      boat: ctx.boat,
      running: ctx.running,
    );
  });

  testWidgets('add source dialog offers file fields after switching type',
      (tester) async {
    final ctx = await pumpReception(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Default type is network: host/port/header fields are visible.
    expect(find.widgetWithText(TextField, 'Host'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Port'), findsOneWidget);

    // Switch to file: file, interval and loop fields appear instead.
    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'File'), findsOneWidget);
    expect(
      find.widgetWithText(TextField, 'Interval between frames (ms)'),
      findsOneWidget,
    );
    expect(find.text('Loop (replay from the start)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Host'), findsNothing);

    // Fill the fields and add the source.
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'My log');
    await tester.enterText(
      find.widgetWithText(TextField, 'File'),
      logPath,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Interval between frames (ms)'),
      '250',
    );
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(CheckboxListTile, 'My log'), findsOneWidget);
    expect(tester.takeException(), isNull);
    disposeTest(
      boatManager: ctx.boatManager,
      stats: ctx.stats,
      boat: ctx.boat,
      running: ctx.running,
    );
  });

  testWidgets('add source dialog offers serial fields after switching type',
      (tester) async {
    final ctx = await pumpReception(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Default type is network: host/port/header fields are visible.
    expect(find.widgetWithText(TextField, 'Host'), findsOneWidget);

    // Switch to serial: serial port and baud rate fields appear instead.
    await tester.tap(find.text('Serial'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Serial port'), findsOneWidget);
    expect(find.text('Baud rate'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Host'), findsNothing);

    // Fill the fields and add the source.
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'My GPS');
    await tester.enterText(
      find.widgetWithText(TextField, 'Serial port'),
      'COM7',
    );
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(CheckboxListTile, 'My GPS'), findsOneWidget);
    expect(tester.takeException(), isNull);
    disposeTest(
      boatManager: ctx.boatManager,
      stats: ctx.stats,
      boat: ctx.boat,
      running: ctx.running,
    );
  });
}
