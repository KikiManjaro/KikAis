class FeedDef {
  final String key;
  final String displayName;
  final String host;
  final int port;
  final String? header;
  final String? tooltip;
  final bool builtIn;

  const FeedDef({
    required this.key,
    required this.displayName,
    required this.host,
    required this.port,
    this.header,
    this.tooltip,
    this.builtIn = false,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'displayName': displayName,
        'host': host,
        'port': port,
        'header': header,
        'tooltip': tooltip,
      };

  factory FeedDef.fromJson(Map<String, dynamic> json) => FeedDef(
        key: json['key'] as String,
        displayName: json['displayName'] as String,
        host: json['host'] as String,
        port: json['port'] as int,
        header: json['header'] as String?,
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
