import 'dart:async';

import 'package:http/http.dart' as http;

import 'forwarder_service.dart';

/// Connects to an AIS-catcher SSE (Server-Sent Events) endpoint and streams
/// NMEA sentences to the forwarder pipeline.
///
/// SSE format from AIS-catcher dashboards:
/// ```
/// data: !AIVDM,1,1,,A,133m@ogP00PDvcSO5N`00000000P,0*76
/// ```
///
/// Each `data:` line contains a raw NMEA 0183 sentence.
class SseFeedPlayer {
  final String name;
  final String flag;
  final String url;
  final String? token;

  final ValueNotifier<FeedStatus> statusNotifier =
      ValueNotifier(const FeedStatus(connecting: true));
  Completer<void> _closedCompleter = Completer<void>();
  bool _disposed = false;

  FeedStatus get status => statusNotifier.value;
  Future<void> get closed => _closedCompleter.future;
  bool get isDisposed => _disposed;

  http.Client? _client;
  StreamSubscription<String>? _subscription;

  SseFeedPlayer(this.name, this.flag, this.url, {this.token});

  Future<void> connect(DataCallback onData) async {
    _closedCompleter = Completer<void>();
    _setStatus(const FeedStatus(connecting: true));

    try {
      final headers = <String, String>{
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
      };
      if (token != null && token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      _client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      headers.forEach((k, v) => request.headers[k] = v);

      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        _setStatus(
          status.copyWith(
            connecting: false,
            error: 'HTTP ${response.statusCode}',
          ),
        );
        _completeClosed();
        return;
      }

      _setStatus(const FeedStatus(connected: true));

      // Parse SSE stream: lines starting with "data:" contain NMEA sentences
      final stream = response.stream
          .transform(const SystemEncoding().decoder)
          .transform(const LineSplitter());

      String? eventType;

      _subscription = stream.listen(
        (line) {
          if (_disposed) return;

          // Parse SSE fields
          if (line.startsWith('event:')) {
            eventType = line.substring(6).trim();
            return;
          }
          if (line.startsWith('retry:')) {
            // Retry interval hint — we handle reconnection ourselves
            return;
          }
          if (line.startsWith('data:') && (eventType == null || eventType == 'nmea')) {
            final payload = line.substring(5).trim();
            if (payload.isNotEmpty) {
              onData(name, flag, payload);
              _setStatus(
                status.copyWith(
                  connected: true,
                  messageCount: status.messageCount + 1,
                  lastMessageAt: DateTime.now(),
                ),
              );
            }
            eventType = null;
            return;
          }
          // Empty line = end of event (SSE spec)
          if (line.isEmpty) {
            eventType = null;
          }
        },
        onError: (e) {
          if (_disposed) return;
          _setStatus(
            status.copyWith(connected: false, error: '$e'),
          );
          _completeClosed();
          onData(name, flag, 'Error: $e');
        },
        onDone: () {
          if (_disposed) return;
          _setStatus(
            status.copyWith(connected: false, error: 'SSE stream ended'),
          );
          _completeClosed();
          onData(name, flag, 'SSE stream ended');
        },
      );
    } catch (e) {
      _setStatus(
        status.copyWith(connecting: false, error: '$e'),
      );
      rethrow;
    }
  }

  void _setStatus(FeedStatus next) {
    statusNotifier.value = next;
  }

  void _completeClosed() {
    if (!_closedCompleter.isCompleted) {
      _closedCompleter.complete();
    }
  }

  Future<void> disconnect() async {
    _disposed = true;
    await _subscription?.cancel();
    _subscription = null;
    _client?.close();
    _client = null;
    _completeClosed();
  }
}
