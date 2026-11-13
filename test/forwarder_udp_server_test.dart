import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/target_config.dart';

/// A UDP "server" target must listen on its configured port, remember the
/// applications that talk to it, and push the forwarded frames to them. The
/// previous implementation silently behaved like a client and sent everything
/// to an unused host:port pair.
const String _frame = '!AIVDM,1,1,,A,15Muq?0P00PD;88MD5MTDww@2D0l,0*5C';

Future<int> _freeUdpPort() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  socket.close();
  return port;
}

Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
  String? reason,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail(reason ?? 'condition not met within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

List<String> _collect(RawDatagramSocket socket) {
  final received = <String>[];
  socket.listen((event) {
    if (event != RawSocketEvent.read) return;
    final datagram = socket.receive();
    if (datagram != null) {
      received.add(String.fromCharCodes(datagram.data));
    }
  });
  return received;
}

void main() {
  test('udp listener answers the peers that talked to it', () async {
    final logs = <String>[];
    final service = ForwarderService(onLog: (m, _, _) => logs.add(m));
    final port = await _freeUdpPort();

    service.setTargets([
      TargetConfig(
        id: 't1',
        name: 'UDP out',
        protocol: ForwardProtocol.udpServer,
        host: '0.0.0.0',
        port: port,
      ),
    ]);
    await service.start();
    expect(logs.any((l) => l.contains('UDP listening on port $port')), isTrue);

    final client = await RawDatagramSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final received = _collect(client);

    // The application announces itself; from then on it receives the frames.
    client.send('hello'.codeUnits, InternetAddress.loopbackIPv4, port);
    await _waitFor(
      () => logs.any((l) => l.contains('UDP peer')),
      reason: 'peer was never registered',
    );

    await service.sendRaw(_frame);
    await _waitFor(
      () => received.isNotEmpty,
      reason: 'no frame reached the peer',
    );
    expect(received.last, _frame);

    await service.stop();
    client.close();
  });

  test('udp client still sends to the configured remote endpoint', () async {
    final receiver = await RawDatagramSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final received = _collect(receiver);

    final service = ForwarderService(onLog: (m, _, _) {});
    service.setTargets([
      TargetConfig(
        id: 't2',
        name: 'UDP in',
        protocol: ForwardProtocol.udpClient,
        host: '127.0.0.1',
        port: receiver.port,
      ),
    ]);
    await service.start();

    await service.sendRaw(_frame);
    await _waitFor(() => received.isNotEmpty, reason: 'client sent nothing');
    expect(received.last, _frame);

    await service.stop();
    receiver.close();
  });

  test('a listen port already taken is reported, not swallowed', () async {
    final port = await _freeUdpPort();
    final blocker = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      port,
      reuseAddress: false,
    );
    final logs = <String>[];
    final service = ForwarderService(onLog: (m, _, _) => logs.add(m));

    service.setTargets([
      TargetConfig(
        id: 't3',
        name: 'Busy',
        protocol: ForwardProtocol.udpServer,
        host: '0.0.0.0',
        port: port,
      ),
    ]);
    await service.start();

    expect(
      logs.any((l) => l.contains('Failed to connect target Busy')),
      isTrue,
    );

    await service.stop();
    blocker.close();
  });
}
