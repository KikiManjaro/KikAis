import 'package:flutter/widgets.dart';

import 'translations_data_de.dart';
import 'translations_data_es.dart';
import 'translations_data_fr.dart';
import 'translations_data_it.dart';
import 'translations_data_ja.dart';
import 'translations_data_nl.dart';
import 'translations_data_pt.dart';
import 'translations_data_ru.dart';
import 'translations_data_zh.dart';

/// Localized country names keyed by language code, then by the canonical
/// English name (as found in `mid_countries.dart`). See docs/i18n.md.
///
/// A missing entry falls back to the English name, so adding a language only
/// requires filling in the countries you care about.
const Map<String, Map<String, String>> kLocalizedCountryNames = {
  'fr': kCountryNamesFr,
  'es': kCountryNamesEs,
  'de': kCountryNamesDe,
  'pt': kCountryNamesPt,
  'it': kCountryNamesIt,
  'nl': kCountryNamesNl,
  'zh': kCountryNamesZh,
  'ja': kCountryNamesJa,
  'ru': kCountryNamesRu,
};

/// Returns the localized name of a country, given its canonical English name
/// (e.g. from `mid_countries.dart`). Falls back to the English name when no
/// translation is available for the current locale.
String localizedCountryName(String englishName, BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return kLocalizedCountryNames[code]?[englishName] ?? englishName;
}
