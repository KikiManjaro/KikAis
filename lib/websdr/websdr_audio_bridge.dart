// ignore_for_file: dead_code
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import '../sdr/dsp/ais_demodulator.dart';

// G711 a-law decode table (ITU) — 256 → 16-bit linear
final _alawTable = List<int>.generate(256, (a) {
  var t = a ^ 0x55;
  final sign = t & 0x80;
  final exp = (t >> 4) & 0x07;
  var mant = t & 0x0F;
  var sample = mant << 4;
  if (exp != 0) {
    sample = (sample + 0x108) << (exp - 1);
  } else {
    sample <<= 1;
  }
  return sign != 0 ? sample : -sample;
});

Float64List _alawDecode(Uint8List alaw) {
  final out = Float64List(alaw.length);
  for (var i = 0; i < alaw.length; i++) {
    out[i] = _alawTable[alaw[i]].toDouble();
  }
  return out;
}

Float64List _resample(Float64List src, int srcRate, int dstRate) {
  if (srcRate == dstRate) return src;
  final ratio = dstRate / srcRate;
  final dstLen = (src.length * ratio).floor();
  final dst = Float64List(dstLen);
  for (var i = 0; i < dstLen; i++) {
    final pos = i / ratio;
    final lo = pos.floor();
    final hi = (lo + 1).clamp(0, src.length - 1);
    final frac = pos - lo;
    dst[i] = src[lo] * (1 - frac) + src[hi] * frac;
  }
  return dst;
}

int _u8(double v) => ((v + 1) * 127.5).clamp(0, 255).round();

class WebsdrAudioBridge {
  static const int kAisFreq = 161975000;
  Isolate? _iso;
  SendPort? _control;
  StreamSubscription<dynamic>? _sub;
  ReceivePort? _reply;

  void Function(String nmea)? onSentence;
  void Function(String msg)? onLog;
  void Function(Object err)? onError;

  Future<void> connect(String host, int port) async {
    _reply = ReceivePort();
    _iso = await Isolate.spawn(_entry, _reply!.sendPort);
    final completer = Completer<SendPort>();
    _sub = _reply!.listen((msg) {
      if (msg is SendPort && !completer.isCompleted) {
        completer.complete(msg);
      } else if (msg is String) {
        if (msg.startsWith('log:')) {
          onLog?.call(msg.substring(4));
        } else if (msg.startsWith('err:')) {
          onError?.call(msg.substring(4));
        } else {
          onSentence?.call(msg);
        }
      } else if (msg is List && msg.isNotEmpty && msg[0] == 'error') {
        onError?.call(msg[1].toString());
      }
    });
    _control = await completer.future.timeout(const Duration(seconds: 5));
    _control!.send(['start', host, port, kAisFreq]);
  }

  Future<void> disconnect() async {
    try {
      _control?.send(['stop']);
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 100));
    await _sub?.cancel();
    _reply?.close();
    _iso?.kill(priority: Isolate.immediate);
    _iso = null;
  }

  void dispose() {
    unawaited(disconnect());
  }
}

void _entry(SendPort reply) {
  final cmdPort = ReceivePort();
  reply.send(cmdPort.sendPort);
  bool running = false;

  cmdPort.listen((msg) async {
    if (msg is List && msg[0] == 'start') {
      if (running) return;
      running = true;
      final host = msg[1] as String;
      final port = msg[2] as int;
      final freq = msg[3] as int;
      final demod = AisDemodulator();
      // WebSDR NFM 12k a-law mono: GET /~~stream?v=11&f=Hz&band=2&mode=nfm
      final path = '/~~stream?v=11&f=$freq&band=2&mode=nfm';
      final url = Uri.parse('http://$host:$port$path');
      reply.send('log:WebSDR audio $url');
      Socket? sock;
      late Stream<Uint8List> resp;
      try {
        sock = await Socket.connect(host, port, timeout: const Duration(seconds: 5));
        // WebSDR classic only speaks HTTP/1.0, rejects HttpClient 1.1 chunked
        sock.write('GET $path HTTP/1.0\r\nHost: $host\r\nUser-Agent: KikAis/1.0\r\nConnection: close\r\n\r\n');
        await sock.flush();
        // Skip HTTP headers until \r\n\r\n
        var headerDone = false;
        var headerBuf = <int>[];
        final ctrl = StreamController<Uint8List>();
        sock.listen((chunk) {
          if (!headerDone) {
            headerBuf.addAll(chunk);
            final s = String.fromCharCodes(headerBuf);
            final idx = s.indexOf('\r\n\r\n');
            if (idx != -1) {
              headerDone = true;
              final hdr = s.substring(0, idx);
              if (!hdr.contains('200')) {
                ctrl.addError(HttpException('WebSDR HTTP $hdr'));
                ctrl.close();
                return;
              }
              final bodyStart = idx + 4;
              final body = Uint8List.fromList(headerBuf.sublist(bodyStart));
              if (body.isNotEmpty) ctrl.add(body);
            }
          } else {
            ctrl.add(chunk);
          }
        }, onError: ctrl.addError, onDone: ctrl.close);
        resp = ctrl.stream;
      } catch (e) {
        reply.send('err:WebSDR HTTP $e $host:$port — classic WebSDR non joignable');
        running = false;
        return;
      }
        // Stream a-law bytes → demod blocks
        const srcRate = 12000;
        const dstRate = 64000;
        const mixHz = 0.0; // already NFM centred
        const block64 = 24000;
        var ph = 0.0;
        var nco = 0.0;
        final mixStep = 2 * math.pi * mixHz / dstRate;
        final phaseStep = 2 * math.pi / 16;
        await for (final chunk in resp) {
          if (!running) {
            break;
          }
          final alaw = chunk;
          var pcm = _alawDecode(alaw);
          // prepend pending tail from resampler? simplified: per-chunk resample
          final resampled = _resample(pcm, srcRate, dstRate);
          // DC + gain normalisation per block (like ais_replay.dart:176-191)
          var sum = 0.0;
          for (var i = 0; i < resampled.length; i++) {
            sum += resampled[i];
          }
          final mean = resampled.isEmpty ? 0 : sum / resampled.length;
          var peak = 1.0;
          for (var i = 0; i < resampled.length; i++) {
            resampled[i] -= mean;
            final a = resampled[i].abs();
            if (a > peak) peak = a;
          }
          final gain = math.pi / 2 / (peak == 0 ? 1 : peak);
          for (var off = 0; off < resampled.length; off += block64) {
            if (!running) {
              break;
            }
            final end = (off + block64).clamp(0, resampled.length);
            if (end - off < 64) break;
            final cu8 = Uint8List((end - off) * 32)..fillRange(0, (end - off) * 32, 128);
            var k = 0;
            for (var n = off; n < end; n++) {
              ph += gain * resampled[n] + mixStep;
              nco += phaseStep;
              if (nco > 2 * math.pi) nco -= 2 * math.pi;
              if (nco < -2 * math.pi) nco += 2 * math.pi;
              cu8[k] = _u8(math.cos(ph));
              cu8[k + 1] = _u8(math.sin(ph));
              k += 32;
            }
            final sentences = demod.process(cu8);
            for (final s in sentences) {
              reply.send(s);
            }
          }
        }
      } else if (msg is List && msg[0] == 'stop') {
      running = false;
    }
  });
}
