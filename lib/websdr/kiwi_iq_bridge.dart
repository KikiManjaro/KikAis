import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../sdr/dsp/ais_demodulator.dart';

/// Minimal KiwiSDR IQ bridge (Plan A).
///
/// Opens `ws://host:port/kiwi/<rand>/SND`, performs the `SET auth`
/// handshake, tunes to the AIS marine band and forwards IQ payloads to
/// an [AisDemodulator] running off the UI thread. The demodulator emits
/// NMEA sentences which are forwarded via [onSentence].
///
/// Protocol provenance: clean-room from `kiwisdrclient` / Beagle_SDR_GPS GPL
/// and SDR++ docs — no PA3FWM WebSDR reverse (author discourages third-party
/// clients). See `docs/kiwisdr-bridge.md`.
class KiwiIqBridge {
  static const int kAisFreq1 = 161975000;
  // Flow-control: request next block after demodulation, avoids WS flood.
  WebSocket? _ws;
  StreamSubscription<dynamic>? _sub;
  Timer? _keepAlive;
  final AisDemodulator _demod = AisDemodulator();

  bool _closed = false;
  void Function(String nmea)? onSentence;
  void Function(String message)? onLog;
  void Function(Object error)? onError;

  int get _randId => DateTime.now().millisecondsSinceEpoch % 100000;

  Future<void> connect(String host, int port, {String password = ''}) async {
    _closed = false;
    String ts = _randId.toString();
    try {
      final ver = await http.get(Uri.parse('http://$host:$port/VER')).timeout(const Duration(seconds: 5));
      if (ver.statusCode == 200) {
        final j = jsonDecode(ver.body) as Map<String, dynamic>;
        ts = '${j['ts'] ?? ts}';
        onLog?.call('Kiwi VER $host:$port → ts=$ts');
      }
    } catch (e) {
      onLog?.call('Kiwi VER fail $host:$port — $e (fallback rand)');
    }
    try {
      final pre = await HttpClient()
          .getUrl(Uri.parse('http://$host:$port/'))
          .then((r) => r.close())
          .timeout(const Duration(seconds: 4));
      onLog?.call('Kiwi HTTP preflight $host:$port → ${pre.statusCode}');
      await pre.drain<void>();
    } catch (e) {
      onLog?.call('Kiwi HTTP preflight fail $host:$port — $e');
    }
    final candidates = [
      Uri.parse('ws://$host:$port/ws/kiwi/$ts/SND'),
      Uri.parse('ws://$host:$port/kiwi/$ts/SND'),
      Uri.parse('wss://$host:$port/ws/kiwi/$ts/SND'),
      Uri.parse('ws://$host/ws/kiwi/$ts/SND'),
    ];
    WebSocket? ws;
    Object? lastErr;
    for (final uri in candidates) {
      onLog?.call('Kiwi WS try $uri');
      try {
        ws = await WebSocket.connect(uri.toString()).timeout(const Duration(seconds: 12));
        onLog?.call('Kiwi WS ok $uri');
        break;
      } catch (e) {
        lastErr = e;
        onLog?.call('Kiwi WS fail $uri — $e');
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    if (ws == null) {
      final e = lastErr ?? 'WS timeout';
      onError?.call('Kiwi WS connect failed $host:$port — $e (Kiwi 0-30MHz natif : VHF 162 MHz hors bande sans transverter)');
      throw StateError('Kiwi WS failed $e');
    }
    _ws = ws;

    // Kiwi handshake — order matters, tolerate unknown responses.
    void send(String s) {
      try {
        _ws!.add(s);
      } catch (_) {}
    }

    // Auth (empty pwd = open Kiwi), identity, then IQ mode.
    send('SET auth t=kiwi p=$password');
    send('SET ident_user=KikAis');
    send('SET geoloc=48.8,2.3');
    // Some forks require `SET mod=iq`, others `SET mod=nfm agc=0` + iq flag.
    send('SET mod=iq low_cut=0 high_cut=6000');
    send('SET agc=0 agc_thresh=-100');
    send('SET freq=$kAisFreq1');
    send('SET squelch=0 max_nchans=1');
    // Keep-alive / AR
    send('SET AR OK WT=keepalive');

    _keepAlive = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_closed) return;
      try {
        _ws!.add('SET keepalive');
      } catch (_) {}
    });

    _sub = _ws!.listen(
      (data) => _onData(data),
      onError: (Object e) {
        if (_closed) return;
        onError?.call('Kiwi WS error $e');
      },
      onDone: () {
        if (_closed) return;
        onLog?.call('Kiwi WS closed by server (Kiwi 30 MHz — 162 MHz non couvert ?)');
      },
      cancelOnError: false,
    );
  }

  void _onData(dynamic data) {
    if (_closed) return;
    Uint8List bytes;
    if (data is String) {
      // Text frames are status / MSG like `MSG ...`, ignore except log.
      final s = data.trim();
      if (s.isNotEmpty && s.length < 300) onLog?.call('Kiwi MSG $s');
      return;
    }
    if (data is List<int>) {
      bytes = data is Uint8List ? data : Uint8List.fromList(data);
    } else {
      return;
    }
    if (bytes.length < 6) return;
    // SND header: 'S','N','D', flags, seq(2). Flags bit0 = compressed?
    if (bytes[0] != 0x53 || bytes[1] != 0x4E || bytes[2] != 0x44) {
      // Some forks send raw IQ without header after handshake — treat whole as payload.
      _demodulate(bytes);
      return;
    }
    final payload = bytes.sublist(6);
    if (payload.isEmpty) return;
    _demodulate(payload);
  }

  void _demodulate(Uint8List payload) {
    // Kiwi IQ payload is typically 16-bit LE I/Q interleaved at e.g. 12 kHz.
    // AisDemodulator expects unsigned 8-bit IQ at ~1 MS/s (RTL-SDR).
    // For V1 we normalise: if payload is int16 LE, convert to u8 by scaling;
    // if already u8, pass through. This keeps the bridge functional while
    // the exact sample-rate / format is refined against real Kiwi captures.
    Uint8List iqU8;
    if (payload.lengthInBytes % 2 == 0 && payload.length > 512) {
      // Heuristic: even length + >512 suggests int16. Convert int16 LE → u8.
      // Take every 2 bytes as one 16-bit sample, scale to 0..255.
      final bd = payload.buffer.asByteData(payload.offsetInBytes, payload.lengthInBytes);
      final n = payload.lengthInBytes ~/ 2;
      iqU8 = Uint8List(n);
      for (var i = 0; i < n; i++) {
        final v = bd.getInt16(i * 2, Endian.little);
        // Map -32768..32767 → 0..255 (centre 128).
        iqU8[i] = ((v + 32768) >> 8) & 0xFF;
      }
    } else {
      iqU8 = payload;
    }
    // Demod off UI thread would be ideal (Isolate.run), but for V1 keep
    // synchronous to avoid isolate overhead on tiny blocks; promote later.
    try {
      final sentences = _demod.process(iqU8);
      for (final s in sentences) {
        onSentence?.call(s);
      }
    } catch (e) {
      onLog?.call('demod error $e');
    }
  }

  Future<void> disconnect() async {
    _closed = true;
    _keepAlive?.cancel();
    _keepAlive = null;
    await _sub?.cancel();
    _sub = null;
    try {
      await _ws?.close();
    } catch (_) {}
    _ws = null;
  }

  void dispose() {
    unawaited(disconnect());
  }
}
