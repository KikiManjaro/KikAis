import 'package:kik_ais/swipper.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'boatmanager.dart';

Future<void> main() async {
  final boatManager = BoatManager();
  await boatManager.startDecoder();

  runApp(
    ChangeNotifierProvider.value(
      value: boatManager,
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    appWindow.minSize = const Size(890, 540);
    appWindow.size = const Size(900, 600);
    appWindow.alignment = Alignment.center;
    appWindow.title = "KikAis";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KikAis',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.blue,
          surface: Colors.grey[800]!,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white60),
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.lightBlueAccent, width: 1),
          ),
          waitDuration: const Duration(milliseconds: 500),
          showDuration: const Duration(seconds: 5),
        ),
      ),

      themeMode: ThemeMode.dark,

      home: const SwipperUi(),
    );
  }
}
