import 'l10n/generated/app_localizations.dart';
import 'l10n/translations_data_de.dart';
import 'l10n/translations_data_es.dart';
import 'l10n/translations_data_fr.dart';
import 'l10n/translations_data_it.dart';
import 'l10n/translations_data_ja.dart';
import 'l10n/translations_data_nl.dart';
import 'l10n/translations_data_pt.dart';
import 'l10n/translations_data_ru.dart';
import 'l10n/translations_data_zh.dart';

/// Localizes the canonical English *values* produced by the AIS decoder
/// (e.g. navigation statuses, ship types, EPFD fix types) at the UI boundary.
///
/// The decoder keeps producing canonical English text (as defined by the ITU
/// standards) so the `lib/ais` package and its tests stay untouched. The maps
/// below translate those fixed strings for display only; unknown values fall
/// back to the original English text.
String? valueLabel(AppLocalizations l10n, String? english) {
  if (english == null || english.isEmpty) return english;
  final translated = _valueLabels[l10n.localeName]?[english];
  return translated ?? english;
}

const Map<String, Map<String, String>> _valueLabels = {
  'fr': kValueLabelsFr,
  'es': kValueLabelsEs,
  'de': kValueLabelsDe,
  'pt': kValueLabelsPt,
  'it': kValueLabelsIt,
  'nl': kValueLabelsNl,
  'zh': kValueLabelsZh,
  'ja': kValueLabelsJa,
  'ru': kValueLabelsRu,
};
