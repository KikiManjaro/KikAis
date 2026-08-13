import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';
import 'message_stats.dart';
import 'swipper.dart';
import 'themes.dart';
import 'update_notifier.dart';

const _appcastUrl = 'https://kikimanjaro.github.io/KikAis/appcast.xml';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final stats = MessageStats();
  final boatManager = BoatManager(stats: stats);
  await boatManager.startDecoder();

  final settings = AppSettings();
  await settings.load();

  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.buildNumber.isEmpty
      ? packageInfo.version
      : '${packageInfo.version}+${packageInfo.buildNumber}';

  final updateNotifier = UpdateNotifier();
  // Auto-update is only meaningful for the installed app. The portable
  // self-extracting exe runs from a temporary directory, so skip it there.
  final exePath = Platform.resolvedExecutable.toLowerCase();
  final updatesSupported =
      !exePath.startsWith(Directory.systemTemp.path.toLowerCase());
  await updateNotifier.initialize(
    _appcastUrl,
    supported: updatesSupported,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: boatManager),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: stats),
        ChangeNotifierProvider.value(value: updateNotifier),
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

    // Null means "follow the operating system"; otherwise the selected code.
    final localeCode = settings.localeCode;
    final Locale? locale = localeCode == null
        ? null
        : Locale(resolveSystemLocaleCode(
            Locale(localeCode),
          ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KikAis',
      onGenerateTitle: (context) => 'KikAis',
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: buildAppTheme(settings.appTheme),
      themeMode: ThemeMode.light,
      home: SwipperUi(version: version),
    );
  }
}
