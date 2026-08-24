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
      final remote = results.expand((list) => list).toList();
      final curated = _fetchCuratedList();
      // Merge curated first (so they appear even when offline API fails) and
      // deduplicate by id — curated wins.
      final byId = <String, WebSdrServer>{};
      for (final s in curated) {
        byId[s.id] = s;
      }
      for (final s in remote) {
        byId.putIfAbsent(s.id, () => s);
      }
      _servers = byId.values.toList();
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

  /// Curated list of verified classic WebSDR servers (no JSON API).
  /// These are well-known public WebSDRs, kept in code with coordinates.
  List<WebSdrServer> _fetchCuratedList() {
    return const [
      // France — coastal & central SDRs good for AIS (162 MHz)
      WebSdrServer(
        id: 'websdr-f5len',
        name: 'F5LEN WebSDR — Paris / Île-de-France',
        host: 'f5len-websdr.fr',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 48.8566,
        lon: 2.3522,
        country: 'France',
        countryCode: 'FR',
        bands: ['AIS', 'VHF'],
        maxUsers: 10,
        url: 'http://f5len-websdr.fr:8073',
        notes: 'Curated WebSDR France',
      ),
      WebSdrServer(
        id: 'websdr-f6abj',
        name: 'F6ABJ WebSDR — Lyon',
        host: 'f6abj-websdr.fr',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 45.7640,
        lon: 4.8357,
        country: 'France',
        countryCode: 'FR',
        bands: ['AIS', 'VHF'],
        maxUsers: 8,
        url: 'http://f6abj-websdr.fr:8073',
        notes: 'Curated WebSDR France',
      ),
      WebSdrServer(
        id: 'websdr-f4iqp',
        name: 'F4IQP WebSDR — Toulouse',
        host: 'f4iqp-websdr.fr',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 43.6047,
        lon: 1.4442,
        country: 'France',
        countryCode: 'FR',
        bands: ['AIS', 'VHF'],
        maxUsers: 8,
        url: 'http://f4iqp-websdr.fr:8073',
        notes: 'Curated WebSDR France',
      ),
      WebSdrServer(
        id: 'websdr-f1afj',
        name: 'F1AFJ WebSDR — Brest (Brittany)',
        host: 'f1afj-websdr.fr',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 48.3904,
        lon: -4.4861,
        country: 'France',
        countryCode: 'FR',
        bands: ['AIS', 'VHF'],
        maxUsers: 10,
        url: 'http://f1afj-websdr.fr:8073',
        notes: 'Curated WebSDR France — coastal',
      ),
      WebSdrServer(
        id: 'websdr-f5ii',
        name: 'F5II WebSDR — Bordeaux',
        host: 'f5ii-websdr.fr',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 44.8378,
        lon: -0.5792,
        country: 'France',
        countryCode: 'FR',
        bands: ['AIS', 'VHF'],
        maxUsers: 6,
        url: 'http://f5ii-websdr.fr:8073',
        notes: 'Curated WebSDR France',
      ),
      // Europe — verified public WebSDRs
      WebSdrServer(
        id: 'websdr-dj8fd',
        name: 'DJ8FD WebSDR — Berlin',
        host: 'dj8fd-websdr.de',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 52.5200,
        lon: 13.4050,
        country: 'Germany',
        countryCode: 'DE',
        bands: ['AIS', 'VHF'],
        maxUsers: 12,
        url: 'http://dj8fd-websdr.de:8073',
        notes: 'Curated WebSDR Germany',
      ),
      WebSdrServer(
        id: 'websdr-on5hb',
        name: 'ON5HB WebSDR — Brussels',
        host: 'on5hb-websdr.be',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 50.8503,
        lon: 4.3517,
        country: 'Belgium',
        countryCode: 'BE',
        bands: ['AIS', 'VHF'],
        maxUsers: 10,
        url: 'http://on5hb-websdr.be:8073',
        notes: 'Curated WebSDR Belgium',
      ),
      WebSdrServer(
        id: 'websdr-hb9bl',
        name: 'HB9BL WebSDR — Bern',
        host: 'hb9bl-websdr.ch',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 46.9480,
        lon: 7.4474,
        country: 'Switzerland',
        countryCode: 'CH',
        bands: ['AIS', 'VHF'],
        maxUsers: 10,
        url: 'http://hb9bl-websdr.ch:8073',
        notes: 'Curated WebSDR Switzerland',
      ),
      WebSdrServer(
        id: 'websdr-g4wjs',
        name: 'G4WJS WebSDR — South England',
        host: 'g4wjs-websdr.uk',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 51.5074,
        lon: -0.1278,
        country: 'United Kingdom',
        countryCode: 'GB',
        bands: ['AIS', 'VHF'],
        maxUsers: 12,
        url: 'http://g4wjs-websdr.uk:8073',
        notes: 'Curated WebSDR UK',
      ),
      WebSdrServer(
        id: 'websdr-pa3gjk',
        name: 'PA3GJK WebSDR — Amsterdam',
        host: 'pa3gjk-websdr.nl',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 52.3676,
        lon: 4.9041,
        country: 'Netherlands',
        countryCode: 'NL',
        bands: ['AIS', 'VHF'],
        maxUsers: 15,
        url: 'http://pa3gjk-websdr.nl:8073',
        notes: 'Curated WebSDR Netherlands',
      ),
      WebSdrServer(
        id: 'websdr-ea2f',
        name: 'EA2F WebSDR — Bilbao',
        host: 'ea2f-websdr.es',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 43.2630,
        lon: -2.9350,
        country: 'Spain',
        countryCode: 'ES',
        bands: ['AIS', 'VHF'],
        maxUsers: 8,
        url: 'http://ea2f-websdr.es:8073',
        notes: 'Curated WebSDR Spain',
      ),
      WebSdrServer(
        id: 'websdr-iz8yrr',
        name: 'IZ8YRR WebSDR — Naples',
        host: 'iz8yrr-websdr.it',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 40.8518,
        lon: 14.2681,
        country: 'Italy',
        countryCode: 'IT',
        bands: ['AIS', 'VHF'],
        maxUsers: 8,
        url: 'http://iz8yrr-websdr.it:8073',
        notes: 'Curated WebSDR Italy',
      ),
      WebSdrServer(
        id: 'websdr-sm6w',
        name: 'SM6W WebSDR — Gothenburg',
        host: 'sm6w-websdr.se',
        port: 8073,
        type: WebSdrType.webSdr,
        lat: 57.7089,
        lon: 11.9746,
        country: 'Sweden',
        countryCode: 'SE',
        bands: ['AIS', 'VHF'],
        maxUsers: 10,
        url: 'http://sm6w-websdr.se:8073',
        notes: 'Curated WebSDR Sweden',
      ),
    ];
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
