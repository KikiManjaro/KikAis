import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'forwarder_ui.dart';

void main() {
  runApp(MyApp());

  doWhenWindowReady(() {
    appWindow.minSize = Size(720, 470);
    appWindow.size = Size(740, 520);
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
      ),

      // Force dark mode
      themeMode: ThemeMode.dark,

      home: ForwarderUI(),
    );
  }
}
