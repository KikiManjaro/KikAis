import 'package:flutter/material.dart';

import 'package:kik_ais/l10n/generated/app_localizations.dart';

/// Wraps [child] in a [MaterialApp] configured with the app's localization
/// delegates so `context.l10n` works in widget tests. The default locale is
/// English so existing English text assertions keep passing.
Widget withLocalizations(
  Widget child, {
  Locale locale = const Locale('en'),
  ThemeData? theme,
}) {
  return MaterialApp(
    locale: locale,
    theme: theme,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: child,
  );
}
