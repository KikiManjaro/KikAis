import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'forwarder_service.dart';

/// Lists the serial ports available on the system.
///
/// The native libserialport library is only bundled into the app when the
/// desktop platforms build the plugin, so under `flutter test` (and on
/// machines without any serial device) this returns an empty list instead of
/// crashing.
List<String> availableSerialPorts() {
  try {
    return SerialPort.availablePorts;
  } catch (_) {
    return const [];
  }
}

/// Abstraction over a serial port so the player can be driven by a simulated
/// device in unit tests instead of real hardware.
abstract class SerialDevice {
  /// Opens [address] (e.g. `COM3` or `/dev/ttyUSB0`) in read mode and
  /// configures it (8N1) at [baudRate]. Throws on failure.
  Future<void> open(String address, int baudRate);

  /// Stream of raw bytes received on the port.
  Stream<List<int>> get data;

  Future<void> close();
  void dispose();
}

/// Production [SerialDevice] backed by libserialport (via flutter_libserialport).
class LibserialportDevice implements SerialDevice {
  SerialPort? _port;
  SerialPortReader? _reader;
  Stream<List<int>>? _data;

  @override
  Stream<List<int>> get data =>
      _data ?? const Stream<List<int>>.empty();

  @override
  Future<void> open(String address, int baudRate) async {
    final port = SerialPort(address);
    if (!port.open(mode: SerialPortMode.read)) {
      throw SerialPort.lastError ??
          Exception('Failed to open serial port $address');
    }
    port.config = SerialPortConfig()
      ..baudRate = baudRate
      ..bits = 8
      ..parity = SerialPortParity.none
      ..stopBits = 1
      ..setFlowControl(SerialPortFlowControl.none);
    final reader = SerialPortReader(port);
    _port = port;
    _reader = reader;
    _data = reader.stream;
  }

  @override
  Future<void> close() async {
    _reader?.close();
    _reader = null;
    _data = null;
    final port = _port;
    _port = null;
    if (port == null) return;
    if (port.isOpen) {
      port.close();
    }
    port.dispose();
  }

  @override
  void dispose() {
    close();
  }
}

/// Reads raw NMEA sentences from a serial port (e.g. an AIS receiver or GPS),
/// buffering the byte stream and splitting it on line boundaries, mimicking a
/// live feed. Lines are pushed through an [onSentence] callback (wired by the
/// page to the forwarding / decoding pipeline), like [FileFeedPlayer].
class SerialFeedPlayer extends ChangeNotifier {
  final String address;
  final int baudRate;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;

  final StringBuffer _buffer = StringBuffer();
  SerialDevice? _device;
  StreamSubscription<List<int>>? _subscription;

  SerialFeedPlayer({
    required this.address,
    this.baudRate = 38400,
    SerialDevice? device,
  }) : _device = device;

  /// Opens the serial port and starts reading. On failure the [error] is set
  /// (surfaced as a red feed status) and nothing is emitted.
  Future<void> connect() async {
    error = null;
    try {
      final device = _device ??= LibserialportDevice();
      await device.open(address, baudRate);
      isRunning = true;
      _subscription = device.data.listen(
        _onData,
        onError: (Object e) {
          if (isRunning) {
            error = '$e';
            isRunning = false;
            notifyListeners();
          }
        },
        onDone: () {
          if (isRunning) {
            error = 'Serial port closed';
            isRunning = false;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      error = '$e';
      isRunning = false;
    }
    notifyListeners();
  }

  void _onData(List<int> bytes) {
    _buffer.write(String.fromCharCodes(bytes));
    final lines = _buffer.toString().split('\n');
    _buffer.clear();
    _buffer.write(lines.removeLast());
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      emittedCount++;
      lastEmitAt = DateTime.now();
      notifyListeners();
      unawaited(onSentence?.call(trimmed));
    }
  }

  Future<void> disconnect() async {
    isRunning = false;
    await _subscription?.cancel();
    _subscription = null;
    await _device?.close();
    _buffer.clear();
    notifyListeners();
  }

  /// Status reported to the reception page, reusing the network feeds' dot
  /// semantics (green while receiving, red on errors).
  FeedStatus get status {
    if (error != null) {
      return const FeedStatus().copyWith(connected: false, error: error);
    }
    if (!isRunning) return const FeedStatus();
    return FeedStatus(
      connected: true,
      messageCount: emittedCount,
      lastMessageAt: lastEmitAt,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _device?.dispose();
    super.dispose();
  }
}
