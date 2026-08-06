import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feed_def.dart';
import 'forwarder_service.dart';
import 'themes.dart';

class AppSettings extends ChangeNotifier {
  static const _kHost = 'targetHost';
  static const _kPort = 'targetPort';
  static const _kProtocol = 'protocol';
  static const _kCluster = 'mapClusterEnabled';
  static const _kSendToMap = 'sendToMap';
  static const _kDecodeEnabled = 'decodeEnabled';
  static const _kValidateChecksum = 'validateChecksum';
  static const _kTheme = 'theme';
  static const _kCustomFeeds = 'customFeeds';
  static const _kFeedPrefix = 'feedEnabled.';

  String targetHost = '127.0.0.1';
  int targetPort = 33333;
  ForwardProtocol protocol = ForwardProtocol.udpServer;
  bool mapClusterEnabled = true;
  bool sendToMap = false;
  bool decodeEnabled = true;
  bool validateChecksum = true;
  AppTheme appTheme = AppTheme.dark;

  final Map<String, bool> feedEnabled = {};
  List<FeedDef> customFeeds = [];

  void setTheme(AppTheme theme) {
    if (appTheme == theme) return;
    appTheme = theme;
    notifyListeners();
    save();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    targetHost = prefs.getString(_kHost) ?? targetHost;
    targetPort = prefs.getInt(_kPort) ?? targetPort;
    final proto = prefs.getString(_kProtocol);
    if (proto != null) {
      protocol = ForwardProtocol.values.firstWhere(
        (p) => p.name == proto,
        orElse: () => ForwardProtocol.udpServer,
      );
    }
    mapClusterEnabled = prefs.getBool(_kCluster) ?? true;
    sendToMap = prefs.getBool(_kSendToMap) ?? false;
    decodeEnabled = prefs.getBool(_kDecodeEnabled) ?? true;
    validateChecksum = prefs.getBool(_kValidateChecksum) ?? true;
    final themeName = prefs.getString(_kTheme);
    if (themeName != null) {
      appTheme = AppTheme.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => AppTheme.dark,
      );
    }

    feedEnabled
      ..clear()
      ..addAll({
        for (final k in prefs.getKeys().where((k) => k.startsWith(_kFeedPrefix)))
          k.substring(_kFeedPrefix.length): prefs.getBool(k) ?? false,
      });

    final raw = prefs.getString(_kCustomFeeds);
    customFeeds = raw == null
        ? []
        : (jsonDecode(raw) as List)
            .map((e) => FeedDef.fromJson(e as Map<String, dynamic>))
            .toList();

    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHost, targetHost);
    await prefs.setInt(_kPort, targetPort);
    await prefs.setString(_kProtocol, protocol.name);
    await prefs.setBool(_kCluster, mapClusterEnabled);
    await prefs.setBool(_kSendToMap, sendToMap);
    await prefs.setBool(_kDecodeEnabled, decodeEnabled);
    await prefs.setBool(_kValidateChecksum, validateChecksum);
    await prefs.setString(_kTheme, appTheme.name);
    for (final e in feedEnabled.entries) {
      await prefs.setBool(_kFeedPrefix + e.key, e.value);
    }
    await prefs.setString(
      _kCustomFeeds,
      jsonEncode(customFeeds.map((f) => f.toJson()).toList()),
    );
  }
}
