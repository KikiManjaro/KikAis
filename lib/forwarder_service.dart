import 'dart:async';
import 'dart:io';

enum ForwardProtocol { udpServer, tcpClient, udpClient, tcpServer }

typedef LogCallback =
    void Function(String message, String? starter, String? name);
typedef DataCallback =
    Future<void> Function(String feedName, String flag, String line);

class ForwarderService {
  String targetHost = "127.0.0.1";
  int targetPort = 3000;
  ForwardProtocol protocol = ForwardProtocol.udpServer;
  final LogCallback onLog;

  ForwarderService({required this.onLog});

  final Map<String, _FeedConnection> _feeds = {};
  RawDatagramSocket? _udpSocket;
  Socket? _tcpSocket;

  ServerSocket? _tcpServer;
  final List<Socket> _tcpClients = [];
  RawDatagramSocket? _udpClientSocket;

  bool _stopping = false;

  void setProtocol(ForwardProtocol p) {
    protocol = p;
  }

  Future<void> start() async {
    _stopping = false;
    try {
      if (protocol == ForwardProtocol.tcpServer) {
        await startTcpServer(targetPort);
      } else if (protocol == ForwardProtocol.tcpClient) {
        _tcpSocket = await Socket.connect(targetHost, targetPort);
      } else if (protocol == ForwardProtocol.udpClient) {
        await startUdpClient();
      } else if (protocol == ForwardProtocol.udpServer) {
        _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      }
    } catch (e) {
      onLog("Error starting protocol $protocol: $e", null, null);
    }

    for (var feed in _feeds.values) {
      unawaited(_connectFeed(feed));
    }
  }

  Future<void> _connectFeed(_FeedConnection feed) async {
    while (!_stopping) {
      try {
        await feed.connect(_handleData);
        onLog("Feed ${feed.name} connected.", null, null);
        break;
      } catch (e) {
        if (_stopping) break;
        onLog(
          "Failed to connect feed ${feed.name}: $e. Retrying in 5s...",
          null,
          null,
        );
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> startTcpServer(int port) async {
    _tcpServer = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    onLog(
      "TCP Server listening on ${_tcpServer!.address.address}:$port",
      null,
      null,
    );

    _tcpServer!.listen((clientSocket) {
      _tcpClients.add(clientSocket);
      onLog(
        "TCP client connected: "
        "${clientSocket.remoteAddress.address}:${clientSocket.remotePort}",
        null,
        null,
      );

      clientSocket.listen(
        (data) {
          final message = String.fromCharCodes(data).trim();
          if (message.isNotEmpty) _handleData("tcp-client", "TCP", message);
        },
        onDone: () {
          _tcpClients.remove(clientSocket);
          onLog("TCP client disconnected", null, null);
        },
        onError: (e) => onLog("TCP client error: $e", null, null),
      );
    });
  }

  Future<void> startUdpClient() async {
    _udpClientSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    onLog("UDP client ready, sending to $targetHost:$targetPort", null, null);
  }

  void sendUdpMessage(String message) {
    _udpClientSocket?.send(
      message.codeUnits,
      InternetAddress(targetHost),
      targetPort,
    );
  }

  Future<void> stop() async {
    _stopping = true;
    onLog("Stopping forwarder...", null, null);
    for (var feed in _feeds.values) {
      await feed.disconnect();
    }
    _feeds.clear();

    for (final client in _tcpClients) {
      client.destroy();
    }
    _tcpClients.clear();

    _udpSocket?.close();
    _udpSocket = null;

    _tcpSocket?.destroy();
    _tcpSocket = null;

    _tcpServer?.close();
    _tcpServer = null;

    _udpClientSocket?.close();
    _udpClientSocket = null;

    onLog("Forwarder stopped.", null, null);
  }

  Future<void> addFeed(
    String name,
    String flag,
    String host,
    int port, {
    String? header,
  }) async {
    if (_feeds.containsKey(name)) return;

    var feed = _FeedConnection(name, flag, host, port, header);
    _feeds[name] = feed;

    if (_udpSocket != null ||
        _tcpSocket != null ||
        _tcpServer != null ||
        _udpClientSocket != null) {
      unawaited(_connectFeed(feed));
    }

    onLog("Feed added: $name ($host:$port)", null, null);
  }

  Future<void> removeFeed(String name) async {
    var feed = _feeds.remove(name);
    if (feed != null) {
      await feed.disconnect();
      onLog("Feed removed: $name", null, null);
    }
  }

  Future<void> _handleData(String feedName, String flag, String line) async {
    final index = line.indexOf('!');
    if (index == -1) return;

    final cleanLine = line.substring(index);

    try {
      switch (protocol) {
        case ForwardProtocol.udpServer:
          _udpSocket?.send(
            cleanLine.codeUnits,
            InternetAddress(targetHost),
            targetPort,
          );
          break;
        case ForwardProtocol.tcpClient:
          _tcpSocket?.write("$cleanLine\n");
          await _tcpSocket?.flush();
          break;
        case ForwardProtocol.udpClient:
          sendUdpMessage(cleanLine);
          break;
        case ForwardProtocol.tcpServer:
          for (var client in List<Socket>.of(_tcpClients)) {
            client.write("$cleanLine\n");
            await client.flush();
          }
          break;
      }
    } catch (e) {
      onLog("Forwarding error: $e", null, null);
    }

    onLog(cleanLine, flag, feedName);
  }
}

class _FeedConnection {
  final String name;
  final String flag;
  final String host;
  final int port;
  final String? header;

  final StringBuffer _buffer = StringBuffer();
  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;
  bool _disposed = false;

  _FeedConnection(this.name, this.flag, this.host, this.port, this.header);

  Future<void> connect(DataCallback onData) async {
    _socket = await Socket.connect(host, port);
    if (_disposed) {
      _socket?.destroy();
      _socket = null;
      return;
    }
    if (header != null) {
      _socket!.write(header!);
    }
    _subscription = _socket!.listen(
      (data) {
        _buffer.write(String.fromCharCodes(data));
        final lines = _buffer.toString().split('\n');
        _buffer.clear();
        _buffer.write(lines.removeLast());
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty) {
            onData(name, flag, trimmed);
          }
        }
      },
      onError: (e) {
        onData(name, flag, "Error: $e");
      },
      onDone: () {
        onData(name, flag, "Feed disconnected");
      },
    );
  }

  Future<void> disconnect() async {
    _disposed = true;
    await _subscription?.cancel();
    _socket?.destroy();
    _socket = null;
    _subscription = null;
    _buffer.clear();
  }
}
