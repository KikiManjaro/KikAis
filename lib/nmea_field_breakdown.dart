import 'package:flutter/material.dart';

import 'ais/ais_decoder.dart' show NmeaTagBlock;
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';

/// Localized label for the comma-separated fields of an AIVDM/AIVDO sentence.
String nmeaFieldLabel(AppLocalizations l10n, int index) => switch (index) {
      0 => l10n.nmeaTalker,
      1 => l10n.nmeaFragments,
      2 => l10n.nmeaFragmentN,
      3 => l10n.nmeaMessageId,
      4 => l10n.nmeaChannel,
      5 => l10n.nmeaPayload,
      6 => l10n.nmeaFillBits,
      _ => '',
    };

/// Renders a single NMEA AIS sentence as coloured, per-field chips so the
/// framing is obvious at a glance (the "sentence inspector").
///
/// Colours are adapted to the current theme so they stay readable in both
/// light and dark themes: labels/borders use a darker shade on light themes
/// and a lighter shade on dark themes, and the value text always uses
/// [ColorScheme.onSurface].
class NmeaFieldBreakdown extends StatelessWidget {
  final String sentence;

  const NmeaFieldBreakdown({super.key, required this.sentence});

  static const List<MaterialColor> _palette = [
    Colors.lightBlue,
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (tagBlock, sentencePart) = NmeaTagBlock.split(sentence);
    final line = sentencePart;
    final star = line.indexOf('*');
    final body = star >= 0 ? line.substring(0, star) : line;
    final checksum = star >= 0 ? line.substring(star + 1) : '';
    final parts = body.split(',');

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (tagBlock != null)
          _chip(
            scheme,
            isDark,
            7 % _palette.length,
            context.l10n.nmeaTagBlock,
            tagBlock.sourceId != null
                ? 's:${tagBlock.sourceId}'
                : tagBlock.raw,
          ),
        for (var i = 0; i < parts.length; i++) ...[
          _chip(
            scheme,
            isDark,
            i % _palette.length,
            nmeaFieldLabel(context.l10n, i),
            parts[i].isEmpty ? context.l10n.nmeaEmpty : parts[i],
          ),
        ],
        if (checksum.isNotEmpty)
          _chip(
            scheme,
            isDark,
            7 % _palette.length,
            context.l10n.nmeaChecksum,
            checksum,
          ),
      ],
    );
  }

  Widget _chip(
    ColorScheme scheme,
    bool isDark,
    int paletteIndex,
    String label,
    String value,
  ) {
    final base = _palette[paletteIndex];
    final accent = isDark ? base.shade300 : base.shade800;
    final bg = base.withValues(alpha: isDark ? 0.22 : 0.14);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
          SelectableText(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
