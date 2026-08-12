import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/file_feed_player.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('kikais_feed_test');
  });

  tearDown(() {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  Future<String> writeLines(List<String> lines) async {
    final file = File('${tempDir.path}/feed.txt');
    await file.writeAsString('${lines.join('\n')}\n');
    return file.path;
  }

  test('loads non-empty lines and emits them at the interval', () async {
    final path = await writeLines(['!A', '', '!B', '!C']);
    final player = FileFeedPlayer(path: path, intervalMs: 50, loop: false);
    await player.load();
    expect(player.isLoaded, isTrue);
    expect(player.totalFrames, 3);

    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();
    expect(player.isRunning, isTrue);

    // The first frame is emitted immediately, the following ones at the
    // configured interval.
    await Future<void>.delayed(const Duration(milliseconds: 70));
    expect(emitted, ['!A', '!B']);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(emitted, ['!A', '!B', '!C']);
    // loop=false: stops after the last line.
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(emitted, ['!A', '!B', '!C']);
    expect(player.isRunning, isFalse);
    player.dispose();
  });

  test('loops back to the start when loop is enabled', () async {
    final path = await writeLines(['!A', '!B']);
    final player = FileFeedPlayer(path: path, intervalMs: 50, loop: true);
    await player.load();
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();
    await Future<void>.delayed(const Duration(milliseconds: 260));
    expect(emitted, ['!A', '!B', '!A', '!B', '!A', '!B']);
    expect(player.isRunning, isTrue);
    player.dispose();
  });

  test('stop cancels emission', () async {
    final path = await writeLines(['!A', '!B']);
    final player = FileFeedPlayer(path: path, intervalMs: 50, loop: true);
    await player.load();
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final count = emitted.length;
    player.stop();
    expect(player.isRunning, isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(emitted.length, count);
    player.dispose();
  });

  test('does not start when the file cannot be read', () async {
    final player = FileFeedPlayer(
      path: '${tempDir.path}/missing.txt',
      intervalMs: 50,
    );
    await player.load();
    expect(player.error, isNotNull);
    expect(player.isLoaded, isFalse);
    expect(player.totalFrames, 0);
    expect(player.status.error, isNotNull);
    player.start();
    expect(player.isRunning, isFalse);
    player.dispose();
  });

  test('reports a running status while emitting', () async {
    final path = await writeLines(['!A']);
    final player = FileFeedPlayer(path: path, intervalMs: 50, loop: true);
    await player.load();
    expect(player.status.connected, isFalse);
    player.start();
    await Future<void>.delayed(const Duration(milliseconds: 70));
    expect(player.status.connected, isTrue);
    expect(player.status.messageCount, greaterThan(0));
    expect(player.status.lastMessageAt, isNotNull);
    player.dispose();
  });

  test('replays following tag-block timestamps', () async {
    final lines = [
      r'\s:SIM,t:0\!A',
      r'\s:SIM,t:50\!B',
      r'\s:SIM,t:150\!C',
    ];
    final path = await writeLines(lines);
    final player = FileFeedPlayer(
      path: path,
      useTimestamps: true,
      intervalMs: 1000,
      loop: false,
    );
    await player.load();
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();

    await Future<void>.delayed(const Duration(milliseconds: 70));
    expect(emitted, [lines[0], lines[1]]);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(emitted, lines);
    player.dispose();
  });

  test('replays following a leading timestamp prefix', () async {
    final lines = [
      '2024-01-01 00:00:00.000 !A',
      '2024-01-01 00:00:00.100 !B',
      '2024-01-01 00:00:00.250 !C',
    ];
    final path = await writeLines(lines);
    final player = FileFeedPlayer(
      path: path,
      useTimestamps: true,
      intervalMs: 1000,
      loop: false,
    );
    await player.load();
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();

    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(emitted, [lines[0]]);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(emitted, [lines[0], lines[1]]);
    await Future<void>.delayed(const Duration(milliseconds: 140));
    expect(emitted, lines);
    player.dispose();
  });

  test('speed factor divides the recorded deltas', () async {
    final lines = [
      r'\s:SIM,t:0\!A',
      r'\s:SIM,t:200\!B',
      r'\s:SIM,t:400\!C',
    ];
    final path = await writeLines(lines);
    final player = FileFeedPlayer(
      path: path,
      useTimestamps: true,
      speed: 2,
      intervalMs: 1000,
      loop: false,
    );
    await player.load();
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();

    // With speed ×2 the 200 ms gaps become ~100 ms.
    await Future<void>.delayed(const Duration(milliseconds: 130));
    expect(emitted, [lines[0], lines[1]]);
    await Future<void>.delayed(const Duration(milliseconds: 130));
    expect(emitted, lines);
    player.dispose();
  });

  test('falls back to the interval when no timestamps are present', () async {
    final path = await writeLines(['!A', '!B', '!C']);
    final player = FileFeedPlayer(
      path: path,
      useTimestamps: true,
      intervalMs: 40,
      loop: false,
    );
    await player.load();
    expect(player.deltasMs, [40, 40, 40]);
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    player.start();
    await Future<void>.delayed(const Duration(milliseconds: 55));
    expect(emitted, ['!A', '!B']);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(emitted, ['!A', '!B', '!C']);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(emitted, ['!A', '!B', '!C']);
    player.dispose();
  });

  test('timestampMsOf parses tag blocks and prefixes (diagnostic)', () async {
    final path = await writeLines([
      '2024-01-01 00:00:00.000 !A',
      '2024-01-01 00:00:00.100 !B',
    ]);
    final player = FileFeedPlayer(
      path: path,
      useTimestamps: true,
      intervalMs: 1000,
    );
    await player.load();
    // Deltas are the gap to the next line: 100, then the restart gap.
    expect(player.deltasMs, [100, 1000]);
    player.dispose();
  });
}
