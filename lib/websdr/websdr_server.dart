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
  final String? hardware;

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
    this.hardware,
  });

  double? get occupancy => maxUsers > 0 ? users / maxUsers : null;
  bool get available => online && (maxUsers == 0 || users < maxUsers);
  String get feedKey => 'websdr:$id';

  /// True when the receiver advertises or — by hardware — can likely tune
  /// the AIS marine band (~156–163 MHz).
  ///
  /// 1) Explicit: any [bands] entry contains "ais" or its numeric range
  ///    overlaps 155–164 MHz (e.g. "0-30000000" from remote lists vs
  ///    `AIS`/`VHF` on curated entries).
  /// 2) Heuristic: wide-band SDR hardware (RTL-SDR, Airspy, SDRplay,
  ///    HackRF, LimeSDR, Pluto, USRP, bladeRF …) physically covers VHF
  ///    even when the advertised [bands] string is generic/HF. KiwiSDR
  ///    hardware is 0–30 MHz only and is therefore excluded.
  /// 3) Generic VHF hint: textual bands mentioning vhf/uhf/marine/2m or a
  ///    numeric range whose upper bound exceeds ~50 MHz implies VHF-capable
  ///    hardware that *could* be tuned to 162 MHz.
  bool get coversAis {
    const aisLow = 155000000;
    const aisHigh = 164000000;
    final range = RegExp(r'^\s*(\d+)\s*-\s*(\d+)\s*$');
    bool hasWideBandHint = false;
    for (final b in bands) {
      final low = b.toLowerCase();
      if (low.contains('ais')) return true;
      if (low.contains('wideband') || low.contains('vhf') || low.contains('uhf') || low.contains('marine') || low.contains('2m') || low.contains('wide')) {
        hasWideBandHint = true;
      }
      final m = range.firstMatch(b);
      if (m == null) continue;
      final lo = int.tryParse(m.group(1)!) ?? -1;
      final hi = int.tryParse(m.group(2)!) ?? -1;
      if (lo < 0 || hi < 0) continue;
      if (hi >= aisLow && lo <= aisHigh) return true;
      if (hi > 50000000) hasWideBandHint = true;
    }
    if (hasWideBandHint && type != WebSdrType.kiwiSdr) return true;

    // Hardware heuristic — only for non-Kiwi receivers (Kiwi is HF-only).
    if (type == WebSdrType.kiwiSdr) {
      // KiwiSDR 1/2 is 0-30 MHz fixed; a wideband Kiwi entry usually means
      // a mis-labelled custom SDR — keep it excluded unless it strictly
      // overlaps the AIS band (already returned above).
      return false;
    }
    final hw = '${hardware ?? ''} ${notes ?? ''}'.toLowerCase();
    // "wideband" in name/notes/bands is explicit: this is the 0-3 GHz
    // SDR the user saw disappear when the AIS filter was on — it must
    // stay visible because wideband = covers VHF marine.
    if (hw.contains('wideband') || hw.contains('wide band') || hw.contains('0-3') || hw.contains('3 ghz') || hw.contains('3ghz')) {
      return true;
    }
    const widebandMarkers = [
      'rtl', 'airspy', 'sdrplay', 'hackrf', 'limesdr', 'pluto',
      'usrp', 'bladerf', 'blade', 'fcd', 'funcube', 'colibri',
      'afedri', 'perseus', 'elad', 'rfscape',
    ];
    for (final m in widebandMarkers) {
      if (hw.contains(m)) return true;
    }
    // Unknown curated/openwebrx/web888 hardware but advertised as WebSDR
    // with no restrictive band — keep curated entries already covered above.
    return false;
  }

  Map<String, dynamic> toJson() => {
        'id': id, 'name': name, 'host': host, 'port': port,
        'type': type.name, 'lat': lat, 'lon': lon,
        'country': country, 'countryCode': countryCode,
        'bands': bands, 'users': users, 'maxUsers': maxUsers,
        'online': online, 'url': url, 'notes': notes,
        'hardware': hardware,
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
        hardware: json['hardware'] as String?,
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
