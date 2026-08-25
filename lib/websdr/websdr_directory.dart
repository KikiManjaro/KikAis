import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'websdr_server.dart';

/// Fetches and caches the list of available WebSDR servers.
class WebSdrDirectory {
  /// Live KiwiSDR receiver list (auto-generated from kiwisdr.com/public/ by
  /// the rx.skywavelinux.com Dyatlov map, refreshed continuously).
  static const _kiwisdrComUrl = 'https://rx.skywavelinux.com/kiwisdr_com.js';

  /// Manually curated multi-brand receiver list (WebSDR / OpenWebRX /
  /// KiwiSDR / UberSDR...), GPLv3+, from the same Dyatlov map maker.
  static const _staticRxUrl = 'https://rx.skywavelinux.com/static_rx.js';

  static const _refreshInterval = Duration(minutes: 30);

  List<WebSdrServer> _servers = [];
  DateTime? _lastFetch;
  bool _loading = false;
  String? _error;

  List<WebSdrServer> get servers => _servers;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isStale => _lastFetch == null || DateTime.now().difference(_lastFetch!) > _refreshInterval;

  Future<List<WebSdrServer>> fetch({bool force = false}) async {
    if (!force && !isStale && _servers.isNotEmpty) return _servers;
    if (_loading) return _servers;

    _loading = true;
    _error = null;

    try {
      final results = await Future.wait([_fetchKiwisdrCom(), _fetchStaticRx()]);
      final remote = results.expand((list) => list).toList();
      final curated = _fetchCuratedList();
      // Merge curated first (so they win on conflicts) and deduplicate by
      // host:port — the same receiver can appear in both remote lists.
      final merged = <WebSdrServer>[];
      final seen = <String>{};
      void add(WebSdrServer s) {
        if (!seen.add('${s.host}:${s.port}')) return;
        merged.add(s);
      }

      for (final s in curated) {
        add(s);
      }
      for (final s in remote) {
        add(s);
      }
      // AIS-capable receivers first, then alphabetical.
      merged.sort((a, b) {
        final ai = a.coversAis ? 0 : 1;
        final bi = b.coversAis ? 0 : 1;
        if (ai != bi) return ai - bi;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      _servers = merged;
      _lastFetch = DateTime.now();
    } catch (e) {
      _error = '$e';
    } finally {
      _loading = false;
    }
    return _servers;
  }

  Future<List<WebSdrServer>> _fetchKiwisdrCom() => _fetchRemote(
        _kiwisdrComUrl,
        (_) => WebSdrType.kiwiSdr,
      );

  Future<List<WebSdrServer>> _fetchStaticRx() =>
      _fetchRemote(_staticRxUrl, _staticRxType);

  /// Maps a static_rx.js entry to a [WebSdrType] based on its software /
  /// hardware description. Unknown brands fall back to [WebSdrType.custom].
  static WebSdrType _staticRxType(Map<String, dynamic> e) {
    final sw = '${e['sw_version'] ?? ''} ${e['sdr_hw'] ?? ''}';
    if (sw.contains('Kiwi')) return WebSdrType.kiwiSdr;
    if (sw.contains('WebSDR') || sw.contains('Web SDR')) {
      return WebSdrType.webSdr;
    }
    return WebSdrType.custom;
  }

  Future<List<WebSdrServer>> _fetchRemote(
    String url,
    WebSdrType Function(Map<String, dynamic>) typeOf,
  ) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return [];
      return parseJsReceiverList(response.body)
          .map((e) => serverFromJsEntry(e, typeOf(e)))
          .whereType<WebSdrServer>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Lenient parser for the JS receiver lists published by
  /// rx.skywavelinux.com (`var name = [ {...}, ... ];`). Entries carry
  /// trailing commas which strict JSON rejects, so they are stripped before
  /// decoding. Returns raw entry maps; invalid content is skipped.
  static List<Map<String, dynamic>> parseJsReceiverList(String body) {
    final start = body.indexOf('[');
    final end = body.lastIndexOf(']');
    if (start < 0 || end <= start) return const [];
    final slice = body.substring(start, end + 1);
    final cleaned = slice.replaceAllMapped(
      RegExp(r',\s*([}\]])'),
      (m) => m.group(1)!,
    );
    try {
      final decoded = json.decode(cleaned);
      if (decoded is! List) return const [];
      return decoded.whereType<Map>().cast<Map<String, dynamic>>().toList();
    } catch (_) {
      return const [];
    }
  }

  /// Builds a [WebSdrServer] from one remote list entry. Returns null when
  /// the entry has no usable URL.
  static WebSdrServer? serverFromJsEntry(
    Map<String, dynamic> e,
    WebSdrType type,
  ) {
    final urlText = '${e['url'] ?? ''}'.trim();
    final uri = Uri.tryParse(urlText);
    if (uri == null || uri.host.isEmpty) return null;
    // Uri.port falls back to the scheme default (e.g. 80 for http) when the
    // URL carries no explicit port, so detect its presence instead.
    final port = uri.hasPort ? uri.port : 8073;

    double? lat;
    double? lon;
    final gm = RegExp(r'\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)')
        .firstMatch('${e['gps'] ?? ''}');
    if (gm != null) {
      lat = double.tryParse(gm.group(1)!);
      lon = double.tryParse(gm.group(2)!);
    }

    final id = '${e['id'] ?? ''}'.trim();
    final hostPort = '${uri.host}:$port';
    final maxUsersRaw = int.tryParse('${e['users_max'] ?? ''}'.trim());
    return WebSdrServer(
      id: id.isNotEmpty ? id : hostPort,
      name: ('${e['name'] ?? ''}'.trim().isNotEmpty)
          ? '${e['name']}'.trim()
          : uri.host,
      host: uri.host,
      port: port,
      type: type,
      lat: lat,
      lon: lon,
      country: '${e['loc'] ?? ''}'.trim().isNotEmpty
          ? '${e['loc']}'.trim()
          : null,
      bands: ['${e['bands'] ?? ''}'.trim()],
      users: int.tryParse('${e['users'] ?? ''}'.trim()) ?? 0,
      maxUsers: maxUsersRaw ?? 0,
      online: '${e['status'] ?? ''}'.trim() != 'inactive' &&
          '${e['offline'] ?? ''}'.trim() != 'yes',
      url: urlText,
      notes: '${e['sw_version'] ?? ''}'.trim().isNotEmpty
          ? '${e['sw_version']}'.trim()
          : null,
      hardware: '${e['sdr_hw'] ?? ''}'.trim().isNotEmpty
          ? '${e['sdr_hw']}'.trim()
          : null,
    );
  }

  /// Verified classic WebSDR servers (real DNS). Kept tiny — remote lists
  /// (rx.skywavelinux) provide the 500+ live Kiwi, the curated just guarantees
  /// a fallback when offline. Previous fake hostnames (f5len/dj8fd…) NXDOMAIN.
  List<WebSdrServer> _fetchCuratedList() {
    return const [
      WebSdrServer(
        id: 'websdr-twente',
        name: 'University of Twente WebSDR',
        host: 'websdr.ewi.utwente.nl',
        port: 8901,
        type: WebSdrType.webSdr,
        lat: 52.2390,
        lon: 6.8530,
        country: 'Netherlands',
        countryCode: 'NL',
        bands: ['VHF'],
        maxUsers: 16,
        url: 'http://websdr.ewi.utwente.nl:8901',
        notes: 'Verified classic WebSDR Twente',
        hardware: 'Wideband',
      ),
      WebSdrServer(
        id: 'websdr-suws',
        name: 'SUWS WebSDR — Southampton UK',
        host: 'suws.southampton.ac.uk',
        port: 54321,
        type: WebSdrType.webSdr,
        lat: 50.9350,
        lon: -1.3960,
        country: 'United Kingdom',
        countryCode: 'GB',
        bands: ['VHF'],
        maxUsers: 8,
        url: 'http://suws.southampton.ac.uk:54321',
        notes: 'Verified classic WebSDR SUWS',
        hardware: 'RTL-SDR',
      ),
      WebSdrServer(
        id: 'websdr-oe9xvi',
        name: 'OE9XVI WebSDR — Austria',
        host: 'websdr.oe9xvi.at',
        port: 8901,
        type: WebSdrType.webSdr,
        lat: 47.3000,
        lon: 9.7000,
        country: 'Austria',
        countryCode: 'AT',
        bands: ['VHF'],
        maxUsers: 8,
        url: 'http://websdr.oe9xvi.at:8901',
        notes: 'Verified classic WebSDR OE9XVI',
        hardware: 'RTL-SDR',
      ),
    ];
  }

  List<WebSdrServer> filter({
    String? query,
    String? countryCode,
    bool? onlineOnly,
    bool? availableOnly,
    bool? aisOnly,
  }) {
    return _servers.where((s) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!s.name.toLowerCase().contains(q) && !(s.country?.toLowerCase().contains(q) ?? false) && !s.host.toLowerCase().contains(q)) return false;
      }
      if (countryCode != null && s.countryCode != countryCode) return false;
      if (onlineOnly == true && !s.online) return false;
      if (availableOnly == true && !s.available) return false;
      if (aisOnly == true && !s.coversAis) return false;
      return true;
    }).toList();
  }

  List<String> get countries {
    final codes = _servers.where((s) => s.countryCode != null).map((s) => s.countryCode!).toSet().toList()..sort();
    return codes;
  }
}
