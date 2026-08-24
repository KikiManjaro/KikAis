import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'websdr_server.dart';

/// Fetches and caches the list of available WebSDR servers.
class WebSdrDirectory {
  static const _kiwiSdrApiUrl = 'http://kiwisdr.com/compiled/kiwisdr.all.json';
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
      final results = await Future.wait([_fetchKiwiSdr()]);
      _servers = results.expand((list) => list).toList();
      _lastFetch = DateTime.now();
    } catch (e) {
      _error = '$e';
    } finally {
      _loading = false;
    }
    return _servers;
  }

  Future<List<WebSdrServer>> _fetchKiwiSdr() async {
    try {
      final response = await http.get(Uri.parse(_kiwiSdrApiUrl)).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return [];
      final data = json.decode(response.body);
      if (data is! List) return [];
      return data.map((e) {
        try { return WebSdrServer.fromKiwiSdrJson(e as Map<String, dynamic>); }
        catch (_) { return null; }
      }).whereType<WebSdrServer>().toList();
    } catch (_) {
      return [];
    }
  }

  List<WebSdrServer> filter({String? query, String? countryCode, bool? onlineOnly, bool? availableOnly}) {
    return _servers.where((s) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!s.name.toLowerCase().contains(q) && !(s.country?.toLowerCase().contains(q) ?? false) && !s.host.toLowerCase().contains(q)) return false;
      }
      if (countryCode != null && s.countryCode != countryCode) return false;
      if (onlineOnly == true && !s.online) return false;
      if (availableOnly == true && !s.available) return false;
      return true;
    }).toList();
  }

  List<String> get countries {
    final codes = _servers.where((s) => s.countryCode != null).map((s) => s.countryCode!).toSet().toList()..sort();
    return codes;
  }
}
