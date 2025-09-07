import 'package:KikAis/swipper.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'boatmanager.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BoatManager(),
      child: MyApp(),
    ),
  );

  doWhenWindowReady(() {
    appWindow.minSize = Size(810, 520);
    appWindow.size = Size(820, 600);
    appWindow.alignment = Alignment.center;
    appWindow.title = "KikAis";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KikAis',
      // Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.blue,
          background: Colors.grey[900]!,
          surface: Colors.grey[800]!,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white60),
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(color: Colors.white, fontSize: 12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(color: Colors.lightBlueAccent, width: 1),
          ),
          waitDuration: Duration(milliseconds: 500),
          showDuration: Duration(seconds: 5),
        ),
      ),

      // Force dark mode
      themeMode: ThemeMode.dark,

      home: SwipperUi(),
    );
  }
}
