import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/sdr/rtlsdr_feed_player.dart';

/// Simulated sentence source: the test pushes decoded sentences as if the DSP
/// isolate were producing them from a real dongle.
class FakeRtlSdrSource implements RtlSdrSentenceSource {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  bool started = false;
  bool stopped = false;
  Object? startError;

  FakeRtlSdrSource({this.startError});

  @override
  Stream<String> get sentences => _controller.stream;

  @override
  Future<void> start() async {
    if (startError != null) throw startError!;
    started = true;
  }

  @override
  Future<void> stop() async {
    stopped = true;
  }

  @override
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  void emit(String sentence) {
    if (!_controller.isClosed) {
      _controller.add(sentence);
    }
  }

  void fail(Object error) {
    if (!_controller.isClosed) {
      _controller.addError(error);
    }
  }
}

/// Captures the lifecycle log messages emitted by the player.
List<LogMessage> captureStatus(RtlSdrFeedPlayer player) {
  final statuses = <LogMessage>[];
  player.onStatus = statuses.add;
  return statuses;
}

void main() {
  const sentence = '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52';
  const config = RtlSdrFeedConfig();

  test('connect starts the source and emits decoded sentences', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final emitted = <String>[];
    player.onSentence = (s) async => emitted.add(s);

    await player.connect();
    expect(player.isRunning, isTrue);
    expect(source.started, isTrue);
    expect(player.status.connected, isTrue);

    source.emit(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);
    expect(player.emittedCount, 1);
    expect(player.lastEmitAt, isNotNull);

    await player.disconnect();
    player.dispose();
  });

  test('logs opening, connected and disconnected lifecycle messages', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final statuses = captureStatus(player);

    await player.connect();
    await player.disconnect();

    expect(statuses.map((m) => m.key).toList(),
        ['rtlSdrOpening', 'rtlSdrConnected', 'rtlSdrDisconnected']);
    expect(statuses[0].args['device'], '#0');
    final connected = statuses[1];
    expect(connected.args['freq'], '162.000 MHz');
    expect(connected.args['rate'], '1.024 MHz');
    expect(connected.args['gain'], 'auto');
    expect(connected.args['channels'], 'A + B');
    expect(connected.fallback,
        'RTL-SDR #0 connected (162.000 MHz, 1.024 MHz sample rate, '
        'auto gain, channels A + B).');

    player.dispose();
  });

  test('reports an error and stays stopped when the source fails', () async {
    final source = FakeRtlSdrSource(startError: Exception('Device busy'));
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final emitted = <String>[];
    player.onSentence = (s) async => emitted.add(s);

    await player.connect();
    expect(player.isRunning, isFalse);
    expect(player.error, isNotNull);
    expect(player.status.error, isNotNull);
    expect(player.status.connected, isFalse);

    player.dispose();
  });

  test('logs the failure when the source cannot start', () async {
    final source = FakeRtlSdrSource(startError: Exception('Device busy'));
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final statuses = captureStatus(player);

    await player.connect();

    expect(statuses.map((m) => m.key).toList(),
        ['rtlSdrOpening', 'rtlSdrError']);
    expect(statuses.last.args['error'], contains('Device busy'));

    player.dispose();
  });

  test('a source error while running stops the feed', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final emitted = <String>[];
    player.onSentence = (s) async => emitted.add(s);
    await player.connect();

    source.emit(sentence);
    source.fail(StateError('USB unplugged'));
    await Future<void>.delayed(Duration.zero);
    expect(player.isRunning, isFalse);
    expect(player.error, contains('USB unplugged'));
    expect(player.status.connected, isFalse);

    player.dispose();
  });

  test('logs the runtime error when the stream fails', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final statuses = captureStatus(player);
    await player.connect();

    source.fail(StateError('USB unplugged'));
    await Future<void>.delayed(Duration.zero);

    expect(statuses.map((m) => m.key).toList(),
        ['rtlSdrOpening', 'rtlSdrConnected', 'rtlSdrError']);
    expect(statuses.last.args['error'], contains('USB unplugged'));

    player.dispose();
  });

  test('logs the stream-closed message on done', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final statuses = captureStatus(player);
    await player.connect();

    source.dispose(); // closes the stream -> onDone fires
    await Future<void>.delayed(Duration.zero);

    expect(statuses.map((m) => m.key).toList(),
        ['rtlSdrOpening', 'rtlSdrConnected', 'rtlSdrStreamClosed']);
    expect(player.status.connected, isFalse);

    player.dispose();
  });

  test('disconnect stops the source and no more sentences arrive', () async {
    final source = FakeRtlSdrSource();
    final player = RtlSdrFeedPlayer(config: config, source: source);
    final emitted = <String>[];
    player.onSentence = (s) async => emitted.add(s);
    await player.connect();

    source.emit(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);

    await player.disconnect();
    expect(player.isRunning, isFalse);
    expect(source.stopped, isTrue);

    source.emit(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);

    player.dispose();
  });
}
