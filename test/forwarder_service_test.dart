import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';

void main() {
  test('coalesces high-frequency feed status updates', () async {
    final service = ForwarderService(onLog: (_, _, _) {});
    var notifications = 0;
    service.feedStatuses.addListener(() => notifications++);

    for (var i = 1; i <= 100; i++) {
      service.setFeedStatus(
        'burst',
        FeedStatus(connected: true, messageCount: i),
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 150));

    expect(notifications, lessThan(10));
    expect(service.feedStatuses.value['burst']?.messageCount, 100);
  });

  test('handles a 2000-frame burst in three target queues', () async {
    final counts = [0, 0, 0];
    final queues = [
      for (var i = 0; i < 3; i++)
        TargetSendQueue(writer: (_) async => counts[i]++),
    ];
    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 2000; i++) {
      for (final queue in queues) {
        queue.enqueue('frame$i');
      }
    }
    await Future.wait(queues.map((queue) => queue.idle));
    stopwatch.stop();

    expect(counts, [2000, 2000, 2000]);
    debugPrint(
      '2000-frame x3 target burst: ${stopwatch.elapsedMilliseconds}ms',
    );
  });

  test('send queue keeps order and drops the oldest pending lines', () async {
    final writes = <String>[];
    final release = Completer<void>();
    final queue = TargetSendQueue(
      maxPending: 2,
      writer: (line) async {
        writes.add(line);
        if (line == 'one') await release.future;
      },
    );

    queue.enqueue('one');
    queue.enqueue('two');
    queue.enqueue('three');
    queue.enqueue('four');
    release.complete();
    await queue.idle;

    expect(writes, ['one', 'three', 'four']);
    expect(queue.dropped, 1);
  });

  test('reconnects after the remote socket closes', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final connections = <Socket>[];
    final accepted = StreamController<Socket>.broadcast();
    final serverSubscription = server.listen((socket) {
      connections.add(socket);
      accepted.add(socket);
    });
    final service = ForwarderService(
      onLog: (_, _, _) {},
      reconnectDelay: const Duration(milliseconds: 10),
    );

    await service.addFeed(
      'test',
      '',
      InternetAddress.loopbackIPv4.address,
      server.port,
    );
    await service.start();
    await accepted.stream.first.timeout(const Duration(seconds: 1));

    connections.first.destroy();
    await accepted.stream.first.timeout(const Duration(seconds: 1));

    expect(connections, hasLength(2));
    await service.stop();
    await accepted.close();
    await serverSubscription.cancel();
    await server.close();
    for (final socket in connections) {
      socket.destroy();
    }
  });

  test(
    'does not wait forever when a feed is removed during reconnect delay',
    () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final service = ForwarderService(
        onLog: (_, _, _) {},
        reconnectDelay: const Duration(seconds: 1),
      );
      await service.addFeed(
        'test',
        '',
        InternetAddress.loopbackIPv4.address,
        server.port,
      );
      await service.start();
      await service.removeFeed('test');

      await service.stop().timeout(const Duration(seconds: 1));
      await server.close();
    },
  );
}
