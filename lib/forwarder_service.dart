import 'dart:async';
import 'dart:io';

enum ForwardProtocol { udp, tcp }

typedef LogCallback = void Function(String message, String? starter);

class ForwarderService {
  String targetHost = "127.0.0.1";
  int targetPort = 3000;
  ForwardProtocol protocol = ForwardProtocol.udp;
  final LogCallback onLog;

  ForwarderService({required this.onLog});

  final Map<String, _FeedConnection> _feeds = {};
  RawDatagramSocket? _udpSocket;
  Socket? _tcpSocket;

  // ----------------------
  // Public API
  // ----------------------

  void setProtocol(ForwardProtocol p) {
    protocol = p;
  }

  Future<void> start() async {
    onLog("Forwarder starting with protocol: $protocol", null);
    if (protocol == ForwardProtocol.udp) {
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      onLog("UDP socket bound to ${_udpSocket!.address.address}:${_udpSocket!.port}", null);
    } else if (protocol == ForwardProtocol.tcp) {
      _tcpSocket = await Socket.connect(targetHost, targetPort);
      onLog("TCP socket connected to $targetHost:$targetPort", null);
    }

    for (var feed in _feeds.values) {
      await feed.connect(_handleData);
    }
  }

  Future<void> stop() async {
    onLog("Stopping forwarder...", null);
    for (var feed in _feeds.values) {
      await feed.disconnect();
    }
    _feeds.clear();

    _udpSocket?.close();
    _udpSocket = null;

    _tcpSocket?.destroy();
    _tcpSocket = null;

    onLog("Forwarder stopped.", null);
  }

  Future<void> addFeed(String name, String flag, String host, int port) async {
    if (_feeds.containsKey(name)) return;
    var feed = _FeedConnection(name,flag, host, port);
    _feeds[name] = feed;
    if (_udpSocket != null || _tcpSocket != null) {
      await feed.connect(_handleData);
    }
    onLog("Feed added: $name ($host:$port)", null);
  }

  Future<void> removeFeed(String name) async {
    var feed = _feeds.remove(name);
    if (feed != null) {
      await feed.disconnect();
      onLog("Feed removed: $name", null);
    }
  }

  // ----------------------
  // Internal
  // ----------------------

  void _handleData(String feedName, String flag, String line) {
    // Keep only the part starting with '!'
    final index = line.indexOf('!');
    if (index == -1) return; // ignore lines without '!'
    final cleanLine = line.substring(index);

    // Forward the line
    if (protocol == ForwardProtocol.udp && _udpSocket != null) {
      _udpSocket!.send(
        cleanLine.codeUnits,
        InternetAddress(targetHost),
        targetPort,
      );
    } else if (protocol == ForwardProtocol.tcp && _tcpSocket != null) {
      _tcpSocket!.write(cleanLine + "\n");
    }

    onLog("$cleanLine", flag);
  }

}

// ----------------------
// Helper class for each feed
// ----------------------
class _FeedConnection {
  final String name;
  final String flag;
  final String host;
  final int port;

  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;

  _FeedConnection(this.name, this.flag, this.host, this.port);

  Future<void> connect(void Function(String feedName, String flag, String line) onData) async {
    _socket = await Socket.connect(host, port);
    _subscription = _socket!.listen((data) {
      final chunk = String.fromCharCodes(data);
      chunk.split('\n').forEach((line) {
        if (line.trim().isNotEmpty) {
          onData(name, flag,  line.trim());
        }
      });
    }, onError: (e) {
      onData(name, flag, "Error: $e");
    }, onDone: () {
      onData(name, flag, "Feed disconnected");
    });
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _socket?.destroy();
    _socket = null;
    _subscription = null;
  }
}