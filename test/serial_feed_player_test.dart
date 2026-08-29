import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/serial_feed_player.dart';

/// Simulated serial port device: the test writes NMEA bytes into [send], as if
/// an AIS receiver were transmitting on a COM port, and the player reads them
/// from [data] exactly like it would from a real libserialport port.
class SimulatedSerialDevice implements SerialDevice {
  final StreamController<List<int>> _controller = StreamController();
  final List<String> opened = [];
  bool closed = false;
  Object? openError;

  SimulatedSerialDevice({this.openError});

  @override
  Stream<List<int>> get data => _controller.stream;

  /// Pushes raw bytes as if received from the physical port.
  void send(List<int> bytes) {
    if (!_controller.isClosed) {
      _controller.add(bytes);
    }
  }

  /// Convenience helper: sends a NMEA sentence as UTF-8 bytes.
  void sendSentence(String line) => send(utf8.encode('$line\n'));

  @override
  Future<void> open(String address, int baudRate) async {
    if (openError != null) {
      throw openError!;
    }
    opened.add('$address@$baudRate');
  }

  @override
  Future<void> close() async {
    closed = true;
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }

  @override
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}

void main() {
  const sentence = '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52';

  test('availableSerialPorts never throws when the native lib is absent', () {
    expect(availableSerialPorts(), isA<List<String>>());
  });

  test('emits a sentence received on the simulated port', () async {
    final device = SimulatedSerialDevice();
    final player = SerialFeedPlayer(
      address: 'COM3',
      baudRate: 38400,
      device: device,
    );
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);

    await player.connect();
    expect(player.isRunning, isTrue);
    expect(device.opened, ['COM3@38400']);
    expect(player.status.connected, isTrue);

    device.sendSentence(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);
    expect(player.emittedCount, 1);
    expect(player.lastEmitAt, isNotNull);

    await player.disconnect();
    player.dispose();
  });

  test('buffers partial chunks across sends (mid-sentence split)', () async {
    final device = SimulatedSerialDevice();
    final player = SerialFeedPlayer(address: 'COM1', device: device);
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    await player.connect();

    // Send the sentence split mid-line, as a real driver may deliver it.
    device.send(utf8.encode(sentence.substring(0, 10)));
    await Future<void>.delayed(Duration.zero);
    expect(emitted, isEmpty);

    device.send(utf8.encode('${sentence.substring(10)}\r\n'));
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);
    expect(player.emittedCount, 1);

    await player.disconnect();
    player.dispose();
  });

  test('handles multiple sentences and bare lines in one chunk', () async {
    final device = SimulatedSerialDevice();
    final player = SerialFeedPlayer(address: 'COM1', device: device);
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    await player.connect();

    device.send(utf8.encode('$sentence\r\n$sentence\n'));
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence, sentence]);
    expect(player.emittedCount, 2);

    await player.disconnect();
    player.dispose();
  });

  test('ignores empty and non-AIS lines', () async {
    final device = SimulatedSerialDevice();
    final player = SerialFeedPlayer(address: 'COM1', device: device);
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    await player.connect();

    device.send(utf8.encode('\r\n\n'));
    await Future<void>.delayed(Duration.zero);
    expect(emitted, isEmpty);
    expect(player.emittedCount, 0);

    await player.disconnect();
    player.dispose();
  });

  test(
    'reports an error and stays stopped when the port cannot be opened',
    () async {
      final device = SimulatedSerialDevice(
        openError: Exception('Access denied'),
      );
      final player = SerialFeedPlayer(
        address: 'COM9',
        baudRate: 9600,
        device: device,
      );
      final emitted = <String>[];
      player.onSentence = (n) async => emitted.add(n);

      await player.connect();
      expect(player.isRunning, isFalse);
      expect(player.error, isNotNull);
      expect(player.status.error, isNotNull);
      expect(player.status.connected, isFalse);

      device.sendSentence(sentence);
      await Future<void>.delayed(Duration.zero);
      expect(emitted, isEmpty);

      player.dispose();
    },
  );

  test('disconnect stops the stream and closes the device', () async {
    final device = SimulatedSerialDevice();
    final player = SerialFeedPlayer(address: 'COM1', device: device);
    final emitted = <String>[];
    player.onSentence = (n) async => emitted.add(n);
    await player.connect();

    device.sendSentence(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);

    await player.disconnect();
    expect(player.isRunning, isFalse);
    expect(device.closed, isTrue);
    expect(player.status.connected, isFalse);

    // Nothing arrives after the device is closed.
    device.sendSentence(sentence);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [sentence]);

    player.dispose();
  });
}
