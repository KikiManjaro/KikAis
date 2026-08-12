import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart' show NmeaFormat;
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/target_config.dart';

void main() {
  test('TargetConfig round-trips through JSON', () {
    const target = TargetConfig(
      id: 't1',
      name: 'Local',
      protocol: ForwardProtocol.tcpClient,
      host: '10.0.0.1',
      port: 4000,
      enabled: false,
    );

    final restored = TargetConfig.fromJson(target.toJson());
    expect(restored.id, 't1');
    expect(restored.name, 'Local');
    expect(restored.protocol, ForwardProtocol.tcpClient);
    expect(restored.host, '10.0.0.1');
    expect(restored.port, 4000);
    expect(restored.enabled, isFalse);
    expect(restored.sendFormat, NmeaFormat.passthrough);
  });

  test('TargetConfig round-trips the send format', () {
    const target = TargetConfig(
      id: 't2',
      name: 'Tagged',
      protocol: ForwardProtocol.udpServer,
      host: '10.0.0.1',
      port: 4000,
      sendFormat: NmeaFormat.tag,
      tagSourceId: 'MYSITE',
    );

    final restored = TargetConfig.fromJson(target.toJson());
    expect(restored.sendFormat, NmeaFormat.tag);
    expect(restored.tagSourceId, 'MYSITE');
  });

  test('TargetConfig copyWith keeps id and overrides fields', () {
    const target = TargetConfig(
      id: 't1',
      name: 'Local',
      protocol: ForwardProtocol.udpServer,
      host: '10.0.0.1',
      port: 4000,
      enabled: true,
    );
    final updated = target.copyWith(port: 5000, enabled: false);
    expect(updated.id, 't1');
    expect(updated.port, 5000);
    expect(updated.enabled, isFalse);
    expect(updated.host, '10.0.0.1');
  });

  test('protocolLabel covers all protocols', () {
    for (final p in ForwardProtocol.values) {
      expect(protocolLabel(p), isNotEmpty);
    }
  });
}
