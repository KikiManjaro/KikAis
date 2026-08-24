import 'dart:convert';
import 'dart:io';

import 'websdr_server.dart';

/// A single connection history entry.
class WebsdrHistoryEntry {
  final String serverId;
  final String name;
  final String host;
  final int port;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationSeconds;

  const WebsdrHistoryEntry({
    required this.serverId,
    required this.name,
    required this.host,
    required this.port,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
  });

  int? get duration {
    if (durationSeconds != null) return durationSeconds;
    if (endTime != null) return endTime!.difference(startTime).inSeconds;
    return null;
  }

  String get durationLabel {
    final d = duration;
    if (d == null) return '—';
    if (d < 60) return '${d}s';
    if (d < 3600) return '${d ~/ 60}m ${d % 60}s';
    return '${d ~/ 3600}h ${(d % 3600) ~/ 60}m';
  }

  Map<String, dynamic> toJson() => {
        'serverId': serverId,
        'name': name,
        'host': host,
        'port': port,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'durationSeconds': durationSeconds ?? duration,
      };

  factory WebsdrHistoryEntry.fromJson(Map<String, dynamic> json) {
    return WebsdrHistoryEntry(
      serverId: json['serverId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      host: json['host'] as String? ?? '',
      port: json['port'] as int? ?? 8073,
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ??
          DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'] as String)
          : null,
      durationSeconds: json['durationSeconds'] as int?,
    );
  }

  factory WebsdrHistoryEntry.starting(WebSdrServer server) {
    return WebsdrHistoryEntry(
      serverId: server.id,
      name: server.name,
      host: server.host,
      port: server.port,
      startTime: DateTime.now(),
    );
  }

  WebsdrHistoryEntry ended() {
    final now = DateTime.now();
    return WebsdrHistoryEntry(
      serverId: serverId,
      name: name,
      host: host,
      port: port,
      startTime: startTime,
      endTime: now,
      durationSeconds: now.difference(startTime).inSeconds,
    );
  }
}

/// Persists up to [maxEntries] connection history records to a local JSON file.
///
/// Storage: `~/.kikais/websdr_history.json` (fallback to
/// `Directory.current/.kikais/websdr_history.json`).
class WebsdrHistory {
  static const int maxEntries = 50;

  List<WebsdrHistoryEntry> _entries = [];
  WebsdrHistoryEntry? _active;
  String? _filePathOverride;

  List<WebsdrHistoryEntry> get entries => List.unmodifiable(_entries);
  WebsdrHistoryEntry? get active => _active;

  /// Most recent first.
  List<WebsdrHistoryEntry> get recent => List.unmodifiable(_entries);

  /// Entries for a specific server.
  List<WebsdrHistoryEntry> forServer(String serverId) =>
      _entries.where((e) => e.serverId == serverId).toList();

  set filePathOverride(String? v) => _filePathOverride = v;

  String get _filePath {
    if (_filePathOverride != null) return _filePathOverride!;
    final home = _resolveHome();
    return '$home/.kikais/websdr_history.json';
  }

  static String _resolveHome() {
    final env = Platform.environment;
    final home = env['HOME'] ?? env['USERPROFILE'];
    if (home != null && home.isNotEmpty) return home;
    return Directory.current.path;
  }

  /// Start tracking a new connection. Auto-ends any previously active one.
  Future<void> startConnection(WebSdrServer server) async {
    if (_active != null) {
      await endConnection();
    }
    _active = WebsdrHistoryEntry.starting(server);
  }

  /// End the active connection, persist it, and trim to [maxEntries].
  Future<void> endConnection() async {
    final a = _active;
    if (a == null) return;
    final ended = a.ended();
    _active = null;
    _entries.insert(0, ended);
    if (_entries.length > maxEntries) {
      _entries = _entries.sublist(0, maxEntries);
    }
    await save();
  }

  /// Record a completed entry directly (e.g. for tests).
  Future<void> addEntry(WebsdrHistoryEntry entry) async {
    _entries.insert(0, entry);
    if (_entries.length > maxEntries) {
      _entries = _entries.sublist(0, maxEntries);
    }
    await save();
  }

  Future<void> clear() async {
    _entries.clear();
    _active = null;
    await save();
  }

  Future<void> load() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      _entries = [];
      return;
    }
    try {
      final text = await file.readAsString();
      if (text.trim().isEmpty) {
        _entries = [];
        return;
      }
      final decoded = json.decode(text);
      if (decoded is! List) {
        _entries = [];
        return;
      }
      _entries = decoded
          .whereType<Map<String, dynamic>>()
          .map((m) {
            try {
              return WebsdrHistoryEntry.fromJson(m);
            } catch (_) {
              return null;
            }
          })
          .whereType<WebsdrHistoryEntry>()
          .toList();
      if (_entries.length > maxEntries) {
        _entries = _entries.sublist(0, maxEntries);
      }
    } catch (_) {
      _entries = [];
    }
  }

  Future<void> save() async {
    final file = File(_filePath);
    try {
      await file.parent.create(recursive: true);
      final encoded = json.encode(_entries.map((e) => e.toJson()).toList());
      await file.writeAsString(encoded);
    } catch (_) {}
  }

  void loadSync() {
    final file = File(_filePath);
    if (!file.existsSync()) {
      _entries = [];
      return;
    }
    try {
      final text = file.readAsStringSync();
      if (text.trim().isEmpty) {
        _entries = [];
        return;
      }
      final decoded = json.decode(text);
      if (decoded is! List) {
        _entries = [];
        return;
      }
      _entries = decoded
          .whereType<Map>()
          .map((m) {
            try {
              return WebsdrHistoryEntry.fromJson(
                  Map<String, dynamic>.from(m));
            } catch (_) {
              return null;
            }
          })
          .whereType<WebsdrHistoryEntry>()
          .toList();
      if (_entries.length > maxEntries) {
        _entries = _entries.sublist(0, maxEntries);
      }
    } catch (_) {
      _entries = [];
    }
  }
}
