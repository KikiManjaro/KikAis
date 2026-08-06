import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/feed_def.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('AppSettings round-trips all values through SharedPreferences',
      () async {
    SharedPreferences.setMockInitialValues({});

    final settings = AppSettings();
    settings.targetHost = '10.0.0.1';
    settings.targetPort = 4000;
    settings.protocol = ForwardProtocol.tcpClient;
    settings.mapClusterEnabled = false;
    settings.sendToMap = true;
    settings.decodeEnabled = false;
    settings.validateChecksum = false;
    settings.setTheme(AppTheme.light);
    settings.feedEnabled['US'] = true;
    settings.feedEnabled['NO'] = false;
    settings.customFeeds = [
      const FeedDef(key: 'local', displayName: 'Local', host: '192.168.1.5', port: 9999),
    ];
    await settings.save();

    final loaded = AppSettings();
    await loaded.load();

    expect(loaded.targetHost, '10.0.0.1');
    expect(loaded.targetPort, 4000);
    expect(loaded.protocol, ForwardProtocol.tcpClient);
    expect(loaded.mapClusterEnabled, isFalse);
    expect(loaded.sendToMap, isTrue);
    expect(loaded.decodeEnabled, isFalse);
    expect(loaded.validateChecksum, isFalse);
    expect(loaded.appTheme, AppTheme.light);
    expect(loaded.feedEnabled['US'], isTrue);
    expect(loaded.feedEnabled['NO'], isFalse);
    expect(loaded.customFeeds, hasLength(1));
    expect(loaded.customFeeds.single.host, '192.168.1.5');
    expect(loaded.customFeeds.single.port, 9999);
  });

  test('AppSettings keeps defaults when nothing is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final loaded = AppSettings();
    await loaded.load();
    expect(loaded.targetHost, '127.0.0.1');
    expect(loaded.targetPort, 33333);
    expect(loaded.protocol, ForwardProtocol.udpServer);
    expect(loaded.mapClusterEnabled, isTrue);
    expect(loaded.decodeEnabled, isTrue);
    expect(loaded.validateChecksum, isTrue);
    expect(loaded.appTheme, AppTheme.dark);
    expect(loaded.customFeeds, isEmpty);
  });
}
