/// Represents a WebSDR server available for connection.
class WebSdrServer {
  final String id;
  final String name;
  final String host;
  final int port;
  final WebSdrType type;
  final double? lat;
  final double? lon;
  final String? country;
  final String? countryCode;
  final List<String> bands;
  final int users;
  final int maxUsers;
  final bool online;
  final String? url;
  final String? notes;

  const WebSdrServer({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    this.type = WebSdrType.kiwiSdr,
    this.lat,
    this.lon,
    this.country,
    this.countryCode,
    this.bands = const [],
    this.users = 0,
    this.maxUsers = 4,
    this.online = true,
    this.url,
    this.notes,
  });

  double? get occupancy => maxUsers > 0 ? users / maxUsers : null;
  bool get available => online && (maxUsers == 0 || users < maxUsers);
  String get feedKey => 'websdr:$id';

  Map<String, dynamic> toJson() => {
        'id': id, 'name': name, 'host': host, 'port': port,
        'type': type.name, 'lat': lat, 'lon': lon,
        'country': country, 'countryCode': countryCode,
        'bands': bands, 'users': users, 'maxUsers': maxUsers,
        'online': online, 'url': url, 'notes': notes,
      };

  factory WebSdrServer.fromJson(Map<String, dynamic> json) => WebSdrServer(
        id: json['id'] as String,
        name: json['name'] as String? ?? json['id'] as String,
        host: json['host'] as String,
        port: json['port'] as int? ?? 8073,
        type: WebSdrType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => WebSdrType.kiwiSdr,
        ),
        lat: (json['lat'] as num?)?.toDouble(),
        lon: (json['lon'] as num?)?.toDouble(),
        country: json['country'] as String?,
        countryCode: json['countryCode'] as String?,
        bands: (json['bands'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        users: json['users'] as int? ?? 0,
        maxUsers: json['maxUsers'] as int? ?? 4,
        online: json['online'] as bool? ?? true,
        url: json['url'] as String?,
        notes: json['notes'] as String?,
      );

  factory WebSdrServer.fromKiwiSdrJson(Map<String, dynamic> json) {
    final sdr = json['sdr'] as Map<String, dynamic>? ?? {};
    final gps = sdr['gps'] as Map<String, dynamic>? ?? {};
    return WebSdrServer(
      id: json['id'] as String? ?? sdr['ip'] as String? ?? '',
      name: json['name'] as String? ?? sdr['name'] as String? ?? 'Unknown',
      host: sdr['dns'] as String? ?? sdr['ip'] as String? ?? '',
      port: sdr['port'] as int? ?? 8073,
      type: WebSdrType.kiwiSdr,
      lat: (gps['lat'] as num?)?.toDouble(),
      lon: (gps['lon'] as num?)?.toDouble(),
      country: sdr['country'] as String?,
      countryCode: sdr['cc'] as String?,
      bands: _parseBands(sdr),
      users: sdr['users'] as int? ?? 0,
      maxUsers: sdr['max_recv'] as int? ?? 4,
      online: sdr['status'] == 'ok' || sdr['online'] == true,
      url: json['url'] as String?,
    );
  }

  static List<String> _parseBands(Map<String, dynamic> sdr) {
    final bands = <String>[];
    if (sdr['bands'] != null) {
      for (final band in (sdr['bands'] as List<dynamic>)) {
        if (band is String) bands.add(band);
      }
    }
    return bands;
  }
}

enum WebSdrType { kiwiSdr, webSdr, sdrSharp, custom }
