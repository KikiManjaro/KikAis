import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:kik_ais/sdr/dsp/ais_demodulator.dart';
import 'package:kik_ais/sdr/rtlsdr_device.dart';

/// Hardware / DSP probe for the RTL-SDR AIS receiver.
///
/// Usage (the bundled rtlsdr.dll must be findable, e.g. on PATH or in the
/// build Release folder):
///
///   dart run tool/sdr_probe.dart --list
///   dart run tool/sdr_probe.dart --seconds 5
///   dart run tool/sdr_probe.dart --gain 36 --seconds 5 --save capture.raw
///   dart run tool/sdr_probe.dart --replay capture.raw
///
/// `--replay` decodes a raw unsigned 8-bit I/Q file recorded at 1.024 MHz
/// (CU8, the same format `rtl_sdr` produces) through the in-app demodulator —
/// a way to validate real AIS decoding without a live signal.
Future<void> main(List<String> args) async {
  final seconds = _arg(args, '--seconds') ?? '5';
  final duration = int.tryParse(seconds) ?? 5;
  final gainStr = _arg(args, '--gain');
  final gain = gainStr == null ? null : int.tryParse(gainStr);
  final savePath = _arg(args, '--save');
  final deviceIndex = int.tryParse(_arg(args, '--device') ?? '0') ?? 0;
  final replayPath = _arg(args, '--replay');

  if (args.contains('--list')) {
    final devices = listRtlSdrDevices();
    if (devices.isEmpty) {
      stdout.writeln('No RTL-SDR device found.');
      stdout.writeln(
          'Check the USB driver (Zadig / WinUSB) and that rtlsdr.dll is on PATH.');
    } else {
      for (final d in devices) {
        stdout.writeln(
            '#${d.index}: ${d.label} (${d.manufacturer} / ${d.product} / ${d.serial})');
      }
    }
    return;
  }

  if (replayPath != null) {
    await replay(replayPath);
    return;
  }

  await probe(
    deviceIndex: deviceIndex,
    seconds: duration,
    gainDb: gain,
    savePath: savePath,
  );
}

String? _arg(List<String> args, String name) {
  final i = args.indexOf(name);
  if (i < 0 || i + 1 >= args.length) return null;
  return args[i + 1];
}

Future<void> replay(String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('File not found: $path');
    exitCode = 1;
    return;
  }
  final bytes = await file.readAsBytes();
  stdout.writeln('Replaying ${bytes.length} bytes (${bytes.length ~/ 204800} s '
      'at 1.024 MHz) through the demodulator...');
  final demod = AisDemodulator();
  var count = 0;
  final chunk = 65536;
  for (var i = 0; i < bytes.length; i += chunk) {
    final end = math.min(i + chunk, bytes.length);
    for (final sentence in demod.process(bytes.sublist(i, end))) {
      count++;
      stdout.writeln(sentence);
    }
  }
  stdout.writeln('Decoded $count AIS sentence(s).');
}

Future<void> probe({
  required int deviceIndex,
  required int seconds,
  int? gainDb,
  String? savePath,
}) async {
  final devices = listRtlSdrDevices();
  stdout.writeln('Devices: $devices');
  if (devices.isEmpty) {
    stdout.writeln('No RTL-SDR device found — aborting.');
    exitCode = 1;
    return;
  }

  final device = RtlsdrFfiDevice();
  stdout.writeln('Opening device #$deviceIndex...');
  try {
    await device.openAndConfigure(
      deviceIndex,
      gainDb: gainDb,
      autoGain: gainDb == null,
    );
  } catch (e) {
    stderr.writeln('Failed to open device: $e');
    exitCode = 1;
    return;
  }
  stdout.writeln('Opened. Streaming $seconds s at 1.024 MHz...');

  final demod = AisDemodulator();
  var bytesRead = 0;
  var sentences = 0;
  final out = savePath == null ? null : BytesBuilder();

  final chunk = 65536;
  final stopAt = DateTime.now().add(Duration(seconds: seconds));
  while (DateTime.now().isBefore(stopAt)) {
    final data = await device.readChunk(chunk);
    if (data == null) {
      stdout.writeln('Read error (dongle unplugged?).');
      break;
    }
    if (data.isEmpty) continue;
    bytesRead += data.length;
    out?.add(data);
    for (final s in demod.process(data)) {
      sentences++;
      stdout.writeln(s);
    }
  }

  await device.close();
  stdout.writeln('Streamed $bytesRead bytes '
      '(${(bytesRead / 2048000).toStringAsFixed(2)} s of IQ).');
  stdout.writeln('Decoded $sentences AIS sentence(s).');
  if (out != null) {
    File(savePath!).writeAsBytesSync(out.takeBytes());
    stdout.writeln('Saved IQ to $savePath');
  }
}
