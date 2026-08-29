import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:kik_ais/sdr/dsp/ais_demodulator.dart';

/// Replays real-world AIS recordings through the production [AisDemodulator]
/// and reports what decoded.
///
/// Three input flavours are supported:
///   * --audio FILE        raw unsigned-8-bit FM audio (48 kHz, the
///                         post-discriminator output that gnuais/AISDecoder
///                         consume) — optionally --stereo
///   * --wav FILE          an 8-bit PCM WAV with the same FM audio
///   * --cu8 FILE          raw interleaved unsigned-8-bit I/Q at 1.024 MHz
///                         (the dongle format; e.g. a capture saved by
///                         `sdr_probe.dart --save`)
///
/// Audio is converted back into the complex baseband that the demodulator
/// expects by synthesising an FM signal whose instantaneous frequency is the
/// audio itself (phi = 2*pi*int(a)), placed at the AIS channel offset, then
/// fed through the unmodified production DSP chain.
///
/// Examples:
///   dart run tool/ais_replay.dart --audio helsinki.raw --rate 48000
///   dart run tool/ais_replay.dart --audio helsinki.raw --stereo --seconds 30
///   dart run tool/ais_replay.dart --wav long-beach.wav
///   dart run tool/ais_replay.dart --cu8 capture.raw --seconds 10
const int kDecimatedRate = 64000;
const int kInputRate = 1024000;
const double kDefaultMixHz = 25000;

void main(List<String> args) {
  final audioPath = _arg(args, '--audio');
  final wavPath = _arg(args, '--wav');
  final cu8Path = _arg(args, '--cu8');
  final rate = int.tryParse(_arg(args, '--rate') ?? '48000') ?? 48000;
  final stereo = args.contains('--stereo');
  final mixHz =
      double.tryParse(_arg(args, '--mix-hz') ?? '$kDefaultMixHz') ??
      kDefaultMixHz;
  final maxSeconds = int.tryParse(_arg(args, '--seconds') ?? '0') ?? 0;
  final verbose = args.contains('--verbose');
  final printSentences = args.contains('--print');

  if (audioPath == null && wavPath == null && cu8Path == null) {
    stdout.writeln(
      'Usage: dart run tool/ais_replay.dart '
      '(--audio FILE|--wav FILE|--cu8 FILE) [--rate HZ] [--stereo] '
      '[--mix-hz HZ] [--seconds N] [--verbose]',
    );
    exitCode = 1;
    return;
  }

  if (audioPath != null) {
    final bytes = _readFile(audioPath);
    stdout.writeln(
      'Audio: $audioPath (${bytes.length} bytes, '
      '${bytes.length / rate} s at $rate Hz, '
      '${stereo ? 'stereo' : 'mono'} stream(s))',
    );
    final streams = <Float64List>[];
    if (stereo) {
      final n = bytes.length ~/ 2;
      final a = Float64List(n);
      final b = Float64List(n);
      for (var i = 0; i < n; i++) {
        a[i] = bytes[i * 2] - 128.0;
        b[i] = bytes[i * 2 + 1] - 128.0;
      }
      streams.add(a);
      streams.add(b);
    } else {
      streams.add(
        Float64List.fromList(
          List<double>.generate(
            bytes.length,
            (i) => (bytes[i] - 128).toDouble(),
          ),
        ),
      );
    }
    for (var s = 0; s < streams.length; s++) {
      final label = streams.length > 1 ? 'stream $s' : 'mono';
      final out = replayAudio(
        streams[s],
        rate: rate,
        mixHz: mixHz,
        maxSeconds: maxSeconds,
        verbose: verbose,
      );
      if (printSentences) {
        for (final sentence in out) {
          stdout.writeln(sentence);
        }
      }
      stdout.writeln('== $label: ${_summarize(out, label)}');
    }
    return;
  }

  if (wavPath != null) {
    final bytes = _readFile(wavPath);
    final wav = _parseWav(bytes);
    stdout.writeln(
      'WAV: $wavPath (${wav.sampleRate} Hz, '
      '${wav.channels} ch, ${wav.bits} bit, '
      '${wav.dataLen / wav.sampleRate} s)',
    );
    if (wav.bits != 8) {
      stderr.writeln('Only 8-bit PCM WAV is supported.');
      exitCode = 1;
      return;
    }
    final samples = Float64List.fromList(
      List<double>.generate(
        wav.dataLen,
        (i) => (bytes[wav.dataOffset + i] - 128).toDouble(),
      ),
    );
    if (wav.channels == 2) {
      final n = samples.length ~/ 2;
      for (var ch = 0; ch < 2; ch++) {
        final s = Float64List(n);
        for (var i = 0; i < n; i++) {
          s[i] = samples[i * 2 + ch];
        }
        final out = replayAudio(
          s,
          rate: wav.sampleRate,
          mixHz: mixHz,
          maxSeconds: maxSeconds,
          verbose: verbose,
        );
        stdout.writeln('== channel $ch: ${_summarize(out, 'ch$ch')}');
      }
    } else {
      final out = replayAudio(
        samples,
        rate: wav.sampleRate,
        mixHz: mixHz,
        maxSeconds: maxSeconds,
        verbose: verbose,
      );
      stdout.writeln('== mono: ${_summarize(out, 'mono')}');
    }
    return;
  }

  if (cu8Path != null) {
    final bytes = _readFile(cu8Path);
    stdout.writeln(
      'CU8 IQ: $cu8Path (${bytes.length} bytes, '
      '${bytes.length / (kInputRate * 2)} s at 1.024 MHz)',
    );
    final demod = AisDemodulator();
    final sentences = <String>[];
    var fed = 0;
    const block = 1 << 19; // 512 KiB of IQ
    while (fed < bytes.length) {
      final end = math.min(fed + block, bytes.length);
      sentences.addAll(demod.process(Uint8List.sublistView(bytes, fed, end)));
      fed = end;
    }
    stdout.writeln('== replay: ${_summarize(sentences, 'replay')}');
  }
}

String? _arg(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i < 0 || i + 1 >= args.length) return null;
  return args[i + 1];
}

Uint8List _readFile(String path) {
  final f = File(path);
  if (!f.existsSync()) {
    stderr.writeln('File not found: $path');
    exit(1);
  }
  return f.readAsBytesSync();
}

/// Runs one real audio stream (post-FM-discriminator, [rate] Hz) through the
/// production demodulator by reconstructing the FM-equivalent complex signal.
List<String> replayAudio(
  Float64List audio, {
  required int rate,
  required double mixHz,
  required int maxSeconds,
  required bool verbose,
}) {
  var samples = audio;
  if (maxSeconds > 0) {
    final keep = math.min(samples.length, rate * maxSeconds);
    samples = Float64List.sublistView(samples, 0, keep);
  }

  // Normalise: remove DC, scale to the reference peak (pi/2 rad/sample).
  var mean = 0.0;
  for (final v in samples) {
    mean += v;
  }
  mean /= samples.length;
  var peak = 0.0;
  for (final v in samples) {
    final a = (v - mean).abs();
    if (a > peak) peak = a;
  }
  if (peak < 1e-9) {
    if (verbose) stdout.writeln('  (silence — nothing to decode)');
    return [];
  }
  final gain = math.pi / 2 / peak;

  // Resample to the decimated rate (linear; the downstream 12 kHz channel
  // filter removes interpolation images).
  final resampled = resample(samples, rate, kDecimatedRate);

  final demod = AisDemodulator();
  final sentences = <String>[];
  final mixStep = 2 * math.pi * mixHz / kDecimatedRate;
  final phaseStep = 2 * math.pi / 16; // 16 stuffed input samples per 64k
  final block64 = 24000; // 0.375 s of 64 kHz audio per demod call
  var ph = 0.0;
  var nco = 0.0;

  for (var off = 0; off < resampled.length; off += block64) {
    final end = math.min(off + block64, resampled.length);
    // 16 input samples x 2 bytes per decimated sample. The 15 interleaved
    // input samples are silence (128/128 = zero amplitude); only the first
    // sample of each group carries the 64 kHz value.
    final cu8 = Uint8List((end - off) * 32)
      ..fillRange(0, (end - off) * 32, 128);
    var k = 0;
    for (var n = off; n < end; n++) {
      // Phase advance per decimated sample = audio value + carrier offset.
      ph += gain * resampled[n] + mixStep;
      nco += phaseStep;
      if (nco > 2 * math.pi) nco -= 2 * math.pi;
      final i = math.cos(ph);
      final q = math.sin(ph);
      cu8[k] = _u8(i);
      cu8[k + 1] = _u8(q);
      k += 32;
    }
    sentences.addAll(demod.process(cu8));
  }
  if (verbose) {
    stdout.writeln(
      '  fed ${resampled.length} decimated samples '
      '(${resampled.length / kDecimatedRate} s)',
    );
  }
  return sentences;
}

/// Linear-interpolation resampler.
Float64List resample(Float64List x, int inRate, int outRate) {
  final outLen = (x.length * outRate / inRate).round();
  final out = Float64List(outLen);
  final ratio = inRate / outRate;
  for (var i = 0; i < outLen; i++) {
    final t = i * ratio;
    final k = t.floor();
    final frac = t - k;
    final a = x[k];
    final b = k + 1 < x.length ? x[k + 1] : a;
    out[i] = a * (1 - frac) + b * frac;
  }
  return out;
}

int _u8(double v) => ((v + 1) * 127.5).round().clamp(0, 255);

({int sampleRate, int channels, int bits, int dataOffset, int dataLen})
_parseWav(Uint8List b) {
  int u32(int o) =>
      b[o] | (b[o + 1] << 8) | (b[o + 2] << 16) | (b[o + 3] << 24);
  int u16(int o) => b[o] | (b[o + 1] << 8);
  var off = 12; // past "RIFF"<size>"WAVE"
  var dataOffset = -1;
  var dataLen = 0;
  while (off + 8 <= b.length) {
    final id = String.fromCharCodes(b.sublist(off, off + 4));
    final size = u32(off + 4);
    if (id == 'fmt ') {
      // fmt chunk: format(2) channels(2) rate(4) byterate(4) align(2) bits(2)
      // handled below.
    } else if (id == 'data') {
      dataOffset = off + 8;
      dataLen = math.min(size, b.length - dataOffset);
      break;
    }
    off += 8 + size + (size & 1);
  }
  return (
    sampleRate: u32(24),
    channels: u16(22),
    bits: u16(34),
    dataOffset: dataOffset,
    dataLen: dataLen,
  );
}

String _summarize(List<String> sentences, String label) {
  if (sentences.isEmpty) return '$label: 0 sentences';
  final types = <int, int>{};
  final mmsis = <int>{};
  for (final s in sentences) {
    final payload = _payloadOf(s);
    if (payload == null) continue;
    final bits = payloadToBits(payload);
    final type = bits.length >= 6 ? _bitsToInt(bits, 0, 6) : -1;
    types[type] = (types[type] ?? 0) + 1;
    if (_typeHasMmsi(type)) {
      mmsis.add(_bitsToInt(bits, 8, 30));
    }
  }
  final sorted = types.keys.toList()..sort();
  final typeStr = sorted.map((t) => 'T$t=${types[t]}').join(', ');
  return '$label: ${sentences.length} sentence(s), '
      '${mmsis.length} unique MMSI(s), types: $typeStr';
}

bool _typeHasMmsi(int type) =>
    const {1, 2, 3, 4, 5, 9, 11, 14, 18, 19, 20, 21, 24, 27}.contains(type);

int _bitsToInt(List<int> bits, int start, int count) {
  var v = 0;
  for (var i = 0; i < count && start + i < bits.length; i++) {
    v = (v << 1) | bits[start + i];
  }
  return v;
}

String? _payloadOf(String sentence) {
  // e.g. !AIVDM,1,1,,A,<payload>,0*XX
  final parts = sentence.split(',');
  if (parts.length < 6) return null;
  return parts[5];
}

/// Converts an AIVDM payload (6-bit chars) back to message bits.
List<int> payloadToBits(String payload) {
  final bits = <int>[];
  for (final c in payload.codeUnits) {
    var v = c - 48;
    if (v > 39) v -= 8;
    for (var i = 5; i >= 0; i--) {
      bits.add((v >> i) & 1);
    }
  }
  return bits;
}
