import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';

/// Typed access to the current [AppLocalizations] instance for a [BuildContext].
///
/// Usage: `context.l10n.someKey` (or `context.l10n.message(arg)`).
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The ISO 639-1 codes of the languages this application supports.
const List<String> kSupportedLocaleCodes = [
  'en',
  'fr',
  'es',
  'de',
  'pt',
  'it',
  'nl',
  'zh',
  'ja',
  'ru',
];

/// Maps a raw locale (from the operating system, e.g. `pt_BR`) to the nearest
/// supported language code, falling back to English.
String resolveSystemLocaleCode(Locale locale) {
  final code = locale.languageCode.toLowerCase();
  return kSupportedLocaleCodes.contains(code) ? code : 'en';
}
