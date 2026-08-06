import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/world_map_page.dart';
import 'package:provider/provider.dart';

/// A tile provider that serves a 1x1 transparent PNG so widget tests never
/// hit the network.
class _FakeTileProvider extends TileProvider {
  static final Uint8List _png = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  );

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(_png);
}

PositionMessage _boat(String mmsi, double lat, double lon, double heading) {
  return PositionMessage(
    messageType: 1,
    mmsi: int.parse(mmsi),
    repeatIndicator: 0,
    navigationStatus: 'Under way using engine',
    latitude: lat,
    longitude: lon,
    speedOverGround: 10,
    courseOverGround: heading,
    maneuverIndicator: '',
    rateOfTurn: 0,
    heading: heading,
    timestamp: 30,
    raimEnabled: 0,
  );
}

void main() {
  testWidgets('map renders vessels through the canvas layer without errors',
      (tester) async {
    final stats = MessageStats();
    final boatManager = BoatManager(stats: stats);
    final settings = AppSettings();
    settings.sendToMap = true;
    boatManager.setSendToMap(true);

    boatManager.updateFromMessage(_boat('226545000', 48.85, 1.05, 45));
    boatManager.updateFromMessage(_boat('227000000', 48.90, 1.10, 200));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: boatManager),
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider.value(value: stats),
        ],
        child: MaterialApp(
          home: WorldMapPage(tileProvider: _FakeTileProvider()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);

    boatManager.dispose();
    stats.dispose();
  });
}
