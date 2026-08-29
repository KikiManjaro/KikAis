import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _kPrefsKey = 'ais_catcher_exe_path';
const _kGitHubApi =
    'https://api.github.com/repos/jvde-github/AIS-catcher/releases/latest';
const _kGitHubReleases = 'https://github.com/jvde-github/AIS-catcher/releases';

/// Manages an ais-catcher.exe process that reads from an RTL-SDR dongle and
/// outputs NMEA sentences over UDP. The process is spawned with the correct
/// flags for the Blog V4 and the DLLs from [resources/rtlsdr/windows/].
class AisCatcherProcess {
  /// Path to the ais-catcher executable. When null, the process cannot be
  /// started and the RTL-SDR feed type is unavailable.
  static String? exePath;

  /// Resolves the path to the RTL-SDR DLL directory (next to the app).
  static String get _rtlsdrDllDir =>
      '${Directory.current.path}\\resources\\rtlsdr\\windows';

  /// Looks for ais-catcher.exe in a handful of well-known locations and
  /// caches the result in [exePath]. Returns the resolved path or null.
  static String? findExecutable() {
    if (exePath != null && File(exePath!).existsSync()) return exePath;

    final candidates = [
      '${Directory.current.path}\\tools\\ais-catcher\\ais-catcher.exe',
      '${Directory.current.path}\\build\\windows\\x64\\runner\\Release\\ais-catcher.exe',
    ];

    for (final path in candidates) {
      if (File(path).existsSync()) {
        exePath = path;
        return path;
      }
    }

    // Fallback: search PATH.
    final which = Platform.isWindows ? 'where' : 'which';
    try {
      final result = Process.runSync(which, ['ais-catcher.exe']);
      if (result.exitCode == 0) {
        final first = (result.stdout as String)
            .split(RegExp(r'\r?\n'))
            .firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
        if (first.isNotEmpty && File(first).existsSync()) {
          exePath = first;
          return first;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Saves a user-chosen path to [exePath] and persists it in
  /// SharedPreferences. Returns true if the file exists at that path.
  static Future<bool> setCustomPath(String path) async {
    if (!File(path).existsSync()) return false;
    exePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, path);
    return true;
  }

  /// Loads a previously cached custom path from SharedPreferences.
  static Future<void> loadCachedPath() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_kPrefsKey);
    if (cached != null && File(cached).existsSync()) {
      exePath = cached;
    }
  }

  /// Clears the cached custom path from SharedPreferences.
  static Future<void> clearCachedPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPrefsKey);
    exePath = null;
  }

  /// Ensures ais-catcher.exe is available. First checks [findExecutable],
  /// then tries the cached custom path, then downloads from GitHub.
  ///
  /// [onProgress] is called with a value in 0.0..1.0 during download.
  /// Returns the resolved path, or null if the user cancelled / download failed.
  static Future<String?> ensureAvailable({
    void Function(double progress, String speed)? onProgress,
  }) async {
    // 1. Already available?
    final found = findExecutable();
    if (found != null) return found;

    // 2. Try cached custom path.
    await loadCachedPath();
    final cached = findExecutable();
    if (cached != null) return cached;

    // 3. Download from GitHub.
    return _downloadLatest(onProgress: onProgress);
  }

  /// Downloads the latest ais-catcher release from GitHub, extracts it,
  /// copies RTL-SDR DLLs next to the binary, and returns the exe path.
  static Future<String?> _downloadLatest({
    void Function(double progress, String speed)? onProgress,
  }) async {
    final destDir = Directory('${Directory.current.path}\\tools\\ais-catcher');
    if (!destDir.existsSync()) destDir.createSync(recursive: true);

    try {
      onProgress?.call(0, 'Checking releases...');

      // Fetch latest release metadata.
      final apiResponse = await http.get(Uri.parse(_kGitHubApi));
      if (apiResponse.statusCode != 200) {
        throw StateError(
          'GitHub API returned ${apiResponse.statusCode}. '
          'Download AIS-catcher manually from $_kGitHubReleases',
        );
      }
      final release = jsonDecode(apiResponse.body) as Map<String, dynamic>;
      final tag = release['tag_name'] as String? ?? 'unknown';

      // Find the Windows x64 zip asset.
      final assets = release['assets'] as List<dynamic>? ?? [];
      Map<String, dynamic>? zipAsset;
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.toLowerCase().contains('x64') &&
            name.toLowerCase().endsWith('.zip') &&
            !name.toLowerCase().contains('sdrplay')) {
          zipAsset = asset as Map<String, dynamic>;
          break;
        }
      }
      if (zipAsset == null) {
        throw StateError(
          'No Windows x64 zip found in AIS-catcher $tag release. '
          'Download manually from $_kGitHubReleases',
        );
      }

      final downloadUrl = zipAsset['browser_download_url'] as String;
      final totalBytes = zipAsset['size'] as int? ?? 0;

      onProgress?.call(0, 'Downloading AIS-catcher $tag...');

      // Download the zip with progress tracking.
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await http.Client().send(request);
      if (response.statusCode != 200) {
        throw StateError('Download failed: HTTP ${response.statusCode}');
      }

      final bytes = <int>[];
      int received = 0;
      final sw = Stopwatch()..start();
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        received += chunk.length;
        if (totalBytes > 0) {
          final progress = received / totalBytes;
          final elapsed = sw.elapsedMilliseconds / 1000;
          final speed = elapsed > 0
              ? '${(received / 1024 / elapsed).toStringAsFixed(0)} Ko/s'
              : '';
          onProgress?.call(progress, speed);
        }
      }
      sw.stop();

      onProgress?.call(1, 'Extracting...');

      // Decode and extract the zip.
      final archive = ZipDecoder().decodeBytes(Uint8List.fromList(bytes));
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          // Flatten: skip leading directory component if present.
          final parts = filename.split('/');
          final flatName = parts.length > 1
              ? parts.sublist(1).join('/')
              : filename;
          if (flatName.isEmpty) continue;
          final outFile = File('${destDir.path}\\$flatName');
          outFile.parent.createSync(recursive: true);
          outFile.writeAsBytesSync(file.content as List<int>);
        }
      }

      // Verify the exe exists.
      final exePath = '${destDir.path}\\ais-catcher.exe';
      if (!File(exePath).existsSync()) {
        throw StateError(
          'ais-catcher.exe not found after extraction. '
          'Download manually from $_kGitHubReleases',
        );
      }

      // Copy RTL-SDR DLLs next to the exe for Blog V4 compatibility.
      await _copyRtlsdrDlls(destDir.path);

      AisCatcherProcess.exePath = exePath;
      return exePath;
    } catch (e) {
      // Clean up partial download.
      if (destDir.existsSync()) {
        try {
          destDir.deleteSync(recursive: true);
        } catch (_) {}
      }
      rethrow;
    }
  }

  /// Copies the RTL-SDR DLLs (rtlsdr.dll, pthreadVC2.dll, msvcr100.dll) from
  /// [resources/rtlsdr/windows] to [targetDir] so ais-catcher can talk to the
  /// Blog V4 dongle.
  static Future<void> _copyRtlsdrDlls(String targetDir) async {
    const dllNames = ['rtlsdr.dll', 'pthreadVC2.dll', 'msvcr100.dll'];
    final srcDir = _rtlsdrDllDir;
    for (final dll in dllNames) {
      final src = File('$srcDir\\$dll');
      final dst = File('$targetDir\\$dll');
      if (src.existsSync()) {
        await src.copy(dst.path);
      }
    }
  }

  Process? _process;
  final int _udpPort;
  final StreamController<String> _sentences =
      StreamController<String>.broadcast();
  StreamSubscription<dynamic>? _stdoutSub;
  StreamSubscription<dynamic>? _stderrSub;

  AisCatcherProcess({required int udpPort}) : _udpPort = udpPort;

  Stream<String> get sentences => _sentences.stream;
  bool get isRunning => _process != null;

  /// Spawns ais-catcher with RTL-SDR input and UDP output.
  ///
  /// [deviceIndex] — dongle index (passed as `-d:<index>`).
  /// [autoGain] — when true, passes `-g L` (automatic gain); otherwise
  ///   `-g <gainDb*10>` (gain in tenths of dB, matching rtlsdr_set_tuner_gain).
  /// [gainDb] — manual gain in dB (ignored when [autoGain] is true).
  /// [sampleRate] — sample rate in Hz (default 1024000).
  /// [useChannel1], [useChannel2] — which AIS channels to decode.
  Future<void> start({
    int deviceIndex = 0,
    bool autoGain = true,
    int? gainDb,
    int sampleRate = 1024000,
    bool useChannel1 = true,
    bool useChannel2 = true,
  }) async {
    if (_process != null) return;

    final exe = findExecutable();
    if (exe == null) {
      throw StateError(
        'ais-catcher.exe not found. Install it from '
        '$_kGitHubReleases',
      );
    }

    final channel = useChannel1 && useChannel2
        ? 'AB'
        : (useChannel1 ? 'A' : 'B');
    final gainArg = autoGain
        ? const ['-gr', 'tuner', 'AUTO', 'rtlagc', 'ON']
        : ['-gr', 'tuner', '${gainDb ?? 30}', 'rtlagc', 'ON'];

    final args = [
      '-d:$deviceIndex',
      '-s', '$sampleRate',
      ...gainArg,
      '-c', channel,
      '-X', 'off', // disable community data sharing
      '-u', '127.0.0.1', '$_udpPort', // NMEA sentences to UDP
      '-q', // quiet output
    ];

    _process = await Process.start(exe, args);

    _stdoutSub = _process!.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .listen((line) {
          final trimmed = line.trim();
          if (trimmed.startsWith('!AIVDM') || trimmed.startsWith('!AIVDO')) {
            _sentences.add(trimmed);
          }
        });

    _stderrSub = _process!.stderr
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .listen((line) {
          final lower = line.toLowerCase();
          if (lower.contains('error') ||
              lower.contains('failed') ||
              lower.contains('fatal') ||
              lower.contains('cannot') ||
              lower.contains('unable')) {
            _sentences.addError(StateError(line.trim()));
          }
        });

    _process!.exitCode.then((code) {
      if (code != 0 && _sentences.hasListener) {
        _sentences.addError(StateError('ais-catcher exited with code $code'));
      }
      _cleanup();
    });
  }

  /// Stops the ais-catcher process gracefully.
  Future<void> stop() async {
    final proc = _process;
    if (proc == null) return;
    try {
      proc.kill(ProcessSignal.sigterm);
      await proc.exitCode.timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          proc.kill(ProcessSignal.sigkill);
          return -1;
        },
      );
    } catch (_) {
      proc.kill(ProcessSignal.sigkill);
    }
    _cleanup();
  }

  void _cleanup() {
    _stdoutSub?.cancel();
    _stderrSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _process = null;
  }

  void dispose() {
    stop();
    _sentences.close();
  }
}
