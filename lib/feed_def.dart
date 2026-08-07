enum FeedType { network, file, serial }

class FeedDef {
  final String key;
  final String displayName;
  final FeedType type;

  /// Network source details.
  final String host;
  final int port;
  final String? header;

  /// File source details.
  final String? path;
  final int intervalMs;
  final bool loop;

  /// Serial source details.
  final String? serialPort;
  final int baudRate;

  final String? tooltip;
  final bool builtIn;

  const FeedDef({
    required this.key,
    required this.displayName,
    this.type = FeedType.network,
    this.host = '',
    this.port = 0,
    this.header,
    this.path,
    this.intervalMs = 1000,
    this.loop = true,
    this.serialPort,
    this.baudRate = 38400,
    this.tooltip,
    this.builtIn = false,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'displayName': displayName,
        'type': type.name,
        'host': host,
        'port': port,
        'header': header,
        'path': path,
        'intervalMs': intervalMs,
        'loop': loop,
        'serialPort': serialPort,
        'baudRate': baudRate,
        'tooltip': tooltip,
      };

  /// Legacy JSON without a "type" field is treated as a network feed so
  /// previously saved custom feeds keep working.
  factory FeedDef.fromJson(Map<String, dynamic> json) => FeedDef(
        key: json['key'] as String,
        displayName: json['displayName'] as String,
        type: FeedType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => FeedType.network,
        ),
        host: json['host'] as String? ?? '',
        port: json['port'] as int? ?? 0,
        header: json['header'] as String?,
        path: json['path'] as String?,
        intervalMs: json['intervalMs'] as int? ?? 1000,
        loop: json['loop'] as bool? ?? true,
        serialPort: json['serialPort'] as String?,
        baudRate: json['baudRate'] as int? ?? 38400,
        tooltip: json['tooltip'] as String?,
      );
}

const List<FeedDef> kFeedDefs = [
  FeedDef(
    key: "Kikistream.io",
    displayName: "Kikistream.io",
    host: "kikimanjaro.hd.free.fr",
    port: 20000,
    builtIn: true,
    tooltip: "Kikistream.io is based on a public AIS feed (aisstream.io),\n"
        "each message is transformed to a standard NMEA0183 AIS sentence\n"
        "(messages could be wrong or malformed)",
  ),
  FeedDef(
    key: "NO",
    displayName: "Norwegian Feed",
    host: "153.44.253.27",
    port: 5631,
    builtIn: true,
  ),
  FeedDef(
    key: "GPSD1",
    displayName: "Sinagot 2947 (GPSD1)",
    host: "5.39.78.33",
    port: 2947,
    header: '?WATCH={"enable":true,"raw":1}',
    builtIn: true,
  ),
  FeedDef(
    key: "GPSD2",
    displayName: "Sinagot 2948 (GPSD2)",
    host: "5.39.78.33",
    port: 2948,
    header: '?WATCH={"enable":true,"raw":1}',
    builtIn: true,
  ),
  FeedDef(
    key: "Sinagot 5121 (simulated)",
    displayName: "Sinagot 5121 (simulated)",
    host: "5.39.78.33",
    port: 5121,
    builtIn: true,
  ),
  FeedDef(
    key: "US",
    displayName: "US East Coast Feed (simulated)",
    host: "ssia-ais.erau.edu",
    port: 4000,
    builtIn: true,
  ),
];
