import 'forwarder_service.dart';

/// A send destination: incoming AIS frames are forwarded to every enabled
/// target, each with its own transport.
class TargetConfig {
  final String id;
  final String name;
  final ForwardProtocol protocol;
  final String host;
  final int port;
  final bool enabled;

  const TargetConfig({
    required this.id,
    required this.name,
    required this.protocol,
    required this.host,
    required this.port,
    this.enabled = true,
  });

  TargetConfig copyWith({
    String? name,
    ForwardProtocol? protocol,
    String? host,
    int? port,
    bool? enabled,
  }) =>
      TargetConfig(
        id: id,
        name: name ?? this.name,
        protocol: protocol ?? this.protocol,
        host: host ?? this.host,
        port: port ?? this.port,
        enabled: enabled ?? this.enabled,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'protocol': protocol.name,
        'host': host,
        'port': port,
        'enabled': enabled,
      };

  factory TargetConfig.fromJson(Map<String, dynamic> json) => TargetConfig(
        id: json['id'] as String,
        name: json['name'] as String,
        protocol: ForwardProtocol.values.firstWhere(
          (p) => p.name == json['protocol'],
          orElse: () => ForwardProtocol.udpServer,
        ),
        host: json['host'] as String,
        port: json['port'] as int,
        enabled: json['enabled'] as bool? ?? true,
      );

  static String newId() => 't${DateTime.now().microsecondsSinceEpoch}';
}

String protocolLabel(ForwardProtocol p) => switch (p) {
      ForwardProtocol.udpServer => 'UDP Server',
      ForwardProtocol.udpClient => 'UDP Client',
      ForwardProtocol.tcpClient => 'TCP Client',
      ForwardProtocol.tcpServer => 'TCP Server',
    };
