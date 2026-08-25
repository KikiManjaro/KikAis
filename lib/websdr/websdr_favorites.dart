import 'dart:convert';
import 'dart:io';

import 'websdr_server.dart';

/// Persists favorite WebSDR servers to a local JSON file.
///
/// Storage path: `~/.kikais/websdr_favorites.json` with fallback to
/// `Directory.current/.kikais/websdr_favorites.json` when HOME is unavailable.
/// Keeps insertion order for display.
class WebsdrFavorites {
  List<WebSdrServer> _favorites = [];
  String? _filePathOverride;

  List<WebSdrServer> get favorites => List.unmodifiable(_favorites);

  /// Optional override for tests.
  // ignore: avoid_setters_without_getters
  set filePathOverride(String? v) => _filePathOverride = v;

  bool isFavorite(String id) => _favorites.any((s) => s.id == id);

  bool isFavoriteServer(WebSdrServer s) => isFavorite(s.id);

  /// Toggle favorite state. Persists to disk.
  Future<void> toggle(WebSdrServer server) async {
    if (isFavorite(server.id)) {
      await remove(server.id);
    } else {
      await add(server);
    }
  }

  Future<void> add(WebSdrServer server) async {
    if (isFavorite(server.id)) return;
    _favorites.add(server);
    await save();
  }

  Future<void> remove(String id) async {
    final before = _favorites.length;
    _favorites.removeWhere((s) => s.id == id);
    if (_favorites.length != before) await save();
  }

  Future<void> clear() async {
    _favorites.clear();
    await save();
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  String get _filePath {
    if (_filePathOverride != null) return _filePathOverride!;
    final home = _resolveHome();
    return '$home/.kikais/websdr_favorites.json';
  }

  static String _resolveHome() {
    final env = Platform.environment;
    final home = env['HOME'] ?? env['USERPROFILE'];
    if (home != null && home.isNotEmpty) return home;
    return Directory.current.path;
  }

  Future<void> load() async {
    final file = File(_filePath);
    if (!await file.exists()) {
      _favorites = [];
      return;
    }
    try {
      final text = await file.readAsString();
      if (text.trim().isEmpty) {
        _favorites = [];
        return;
      }
      final decoded = json.decode(text);
      if (decoded is! List) {
        _favorites = [];
        return;
      }
      _favorites = decoded
          .whereType<Map<String, dynamic>>()
          .map((m) {
            try {
              return WebSdrServer.fromJson(m);
            } catch (_) {
              return null;
            }
          })
          .whereType<WebSdrServer>()
          .toList();
    } catch (_) {
      _favorites = [];
    }
  }

  Future<void> save() async {
    final file = File(_filePath);
    try {
      await file.parent.create(recursive: true);
      final encoded = json.encode(_favorites.map((s) => s.toJson()).toList());
      await file.writeAsString(encoded);
    } catch (_) {
      // best-effort persistence
    }
  }

  /// Synchronous load for startup when async is inconvenient.
  void loadSync() {
    final file = File(_filePath);
    if (!file.existsSync()) {
      _favorites = [];
      return;
    }
    try {
      final text = file.readAsStringSync();
      if (text.trim().isEmpty) {
        _favorites = [];
        return;
      }
      final decoded = json.decode(text);
      if (decoded is! List) {
        _favorites = [];
        return;
      }
      _favorites = decoded
          .whereType<Map>()
          .map((m) {
            try {
              return WebSdrServer.fromJson(Map<String, dynamic>.from(m));
            } catch (_) {
              return null;
            }
          })
          .whereType<WebSdrServer>()
          .toList();
    } catch (_) {
      _favorites = [];
    }
  }
}
