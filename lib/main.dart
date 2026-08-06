import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'message_stats.dart';
import 'swipper.dart';
import 'themes.dart';

Future<void> main() async {
  final stats = MessageStats();
  final boatManager = BoatManager(stats: stats);
  await boatManager.startDecoder();

  final settings = AppSettings();
  await settings.load();

  final packageInfo = await PackageInfo.fromPlatform();
  final version = '${packageInfo.version}+${packageInfo.buildNumber}';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: boatManager),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: stats),
      ],
      child: MyApp(version: version),
    ),
  );

  doWhenWindowReady(() {
    appWindow.minSize = const Size(640, 480);
    appWindow.size = const Size(1024, 810);
    appWindow.alignment = Alignment.center;
    appWindow.title = "KikAis";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  final String version;

  const MyApp({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KikAis',
      theme: buildAppTheme(settings.appTheme),
      themeMode: ThemeMode.light,
      home: SwipperUi(version: version),
    );
  }
}
