import 'package:flutter/material.dart';

import 'ais/src/utils/convert_char_to_bin.dart' show aisDataChars;
import 'documentation_content.dart';
import 'themes.dart';
import 'widgets.dart';

/// Interactive widgets used by the Documentation tab: bit-layout viewer,
/// six-bit encoder, checksum calculator, coordinate encoder, ship-type
/// browser, glossary, class comparison and cheat sheet.

// ------------------------------------------------------------------ helpers

Color _accent(BuildContext context, int i) {
  const palette = [
    Colors.lightBlue,
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
  ];
  return palette[i % palette.length];
}

// --------------------------------------------------------------- bit layout

/// An interactive bit-field viewer that lets you switch between the main
/// AIS message layouts.
class BitLayoutViewer extends StatefulWidget {
  const BitLayoutViewer({super.key});

  @override
  State<BitLayoutViewer> createState() => _BitLayoutViewerState();
}

class _BitLayoutViewerState extends State<BitLayoutViewer> {
  int _layoutIndex = 0;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final layout = kBitLayouts[_layoutIndex];
    final fields = layout.fields;
    if (_selected >= fields.length) _selected = fields.length - 1;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<int>(
              value: _layoutIndex,
              isExpanded: true,
              items: [
                for (var i = 0; i < kBitLayouts.length; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(
                      kBitLayouts[i].label,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
              onChanged: (v) => setState(() {
                _layoutIndex = v ?? 0;
                _selected = 0;
              }),
            ),
            const SizedBox(height: 10),
            _bar(scheme, fields),
            const SizedBox(height: 8),
            _labels(scheme, fields),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _accent(context, _selected % 8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fields[_selected].name} · bits '
                    '${fields[_selected].start}-${fields[_selected].end}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _accent(context, _selected % 8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fields[_selected].description,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${fields.length} fields · '
              '${fields.last.end + 1} bits total · tap a segment',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(ColorScheme scheme, List<DocBitField> fields) {
    return SizedBox(
      height: 26,
      child: Row(
        children: [
          for (var i = 0; i < fields.length; i++)
            Expanded(
              flex: (fields[i].end - fields[i].start + 1).round(),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 1),
                  decoration: BoxDecoration(
                    color: _accent(context, i % 8)
                        .withValues(alpha: i == _selected ? 0.95 : 0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _labels(ColorScheme scheme, List<DocBitField> fields) {
    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < fields.length; i++)
            Expanded(
              flex: (fields[i].end - fields[i].start + 1).round(),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      fields[i].name,
                      style: TextStyle(
                        fontSize: 9,
                        color: i == _selected
                            ? _accent(context, i % 8)
                            : scheme.onSurfaceVariant,
                        fontWeight:
                            i == _selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ six-bit encoder

/// Encodes a typed text into the six-bit AIS alphabet, character by character.
class SixBitEncoder extends StatefulWidget {
  const SixBitEncoder({super.key});

  @override
  State<SixBitEncoder> createState() => _SixBitEncoderState();
}

class _SixBitEncoderState extends State<SixBitEncoder> {
  final _controller = TextEditingController(text: 'KIKAIS');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _code(String c) {
    final v = aisDataChars.indexOf(c);
    return v < 0 ? '—' : v.toRadixString(2).padLeft(6, '0');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = _controller.text.toUpperCase();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Text to encode',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            if (text.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final c in text.split(''))
                    Container(
                      width: 40,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Text(
                            c,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          ),
                          Text(
                            _code(c),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              'Each character is one 6-bit value ("@" = 0, space = 32, '
              '"A" = 1…). Lowercase letters are not encodable and are '
              'usually sent as uppercase.',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------- checksum calculator

/// Computes the NMEA XOR checksum of any string.
class ChecksumCalculator extends StatefulWidget {
  const ChecksumCalculator({super.key});

  @override
  State<ChecksumCalculator> createState() => _ChecksumCalculatorState();
}

class _ChecksumCalculatorState extends State<ChecksumCalculator> {
  final _controller = TextEditingController(
    text: 'AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0',
  );
  String _checksum = '';

  @override
  void initState() {
    super.initState();
    _compute();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _compute() {
    var xor = 0;
    for (final c in _controller.text.codeUnits) {
      xor ^= c;
    }
    setState(() => _checksum = xor.toRadixString(16).padLeft(2, '0').toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Body (without leading ! and trailing *XX)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _compute(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: appColors.success),
                  ),
                  child: Text(
                    '*$_checksum',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: appColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'The NMEA checksum is the XOR of every byte between the "!" '
              'and the "*".',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------ coordinate encoder

/// Converts a latitude/longitude into the raw 27/28-bit payload integers.
class CoordinateEncoder extends StatefulWidget {
  const CoordinateEncoder({super.key});

  @override
  State<CoordinateEncoder> createState() => _CoordinateEncoderState();
}

class _CoordinateEncoderState extends State<CoordinateEncoder> {
  final _latC = TextEditingController(text: '48.39000');
  final _lonC = TextEditingController(text: '-4.49000');

  @override
  void dispose() {
    _latC.dispose();
    _lonC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lat = double.tryParse(_latC.text);
    final lon = double.tryParse(_lonC.text);
    final rawLat = lat == null ? null : (lat * 600000).round();
    final rawLon = lon == null ? null : (lon * 600000).round();

    Widget value(Widget child) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _latC,
                    style: const TextStyle(fontFamily: 'monospace'),
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _lonC,
                    style: const TextStyle(fontFamily: 'monospace'),
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            value(
              SelectableText(
                rawLat == null
                    ? 'Latitude: enter a number'
                    : 'Latitude → ${rawLat < 0 ? '-' : ''}'
                        '${rawLat.abs()} (${27}-bit signed, '
                        'deg = $rawLat / 600000)',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 6),
            value(
              SelectableText(
                rawLon == null
                    ? 'Longitude: enter a number'
                    : 'Longitude → ${rawLon < 0 ? '-' : ''}'
                        '${rawLon.abs()} (${28}-bit signed, '
                        'deg = $rawLon / 600000)',
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coordinates are stored in 1/10 000 of a minute: divide by '
              '600 000 to recover degrees.',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- ship types

/// Searchable, grouped ITU ship-type table (0-99).
class ShipTypeBrowser extends StatefulWidget {
  const ShipTypeBrowser({super.key});

  @override
  State<ShipTypeBrowser> createState() => _ShipTypeBrowserState();
}

class _ShipTypeBrowserState extends State<ShipTypeBrowser> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rows = kVesselTypesFull();
    final q = _query.trim().toLowerCase();
    final grouped = <String, List<(int, String)>>{};
    for (final (t, name) in rows) {
      if (q.isNotEmpty &&
          !name.toLowerCase().contains(q) &&
          !'$t'.contains(q)) {
        continue;
      }
      final cat = _categoryOf(t);
      grouped.putIfAbsent(cat, () => []).add((t, name));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 18),
                labelText: 'Search ship types',
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final entry in grouped.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 2),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    for (final (t, name) in entry.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 34,
                              child: Text(
                                '$t',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryOf(int t) {
    if (t < 20) return '0-19 · Reserved';
    if (t < 30) return '20-29 · Wing in ground (WIG)';
    if (t < 40) return '30-39 · Fishing';
    if (t < 50) return '40-49 · High-speed craft';
    if (t < 60) return '50-59 · Special craft';
    if (t < 70) return '60-69 · Passenger';
    if (t < 80) return '70-79 · Cargo';
    if (t < 90) return '80-89 · Tanker';
    return '90-99 · Other';
  }
}

// -------------------------------------------------------------- glossary

/// A searchable list of AIS terms.
class GlossarySearch extends StatefulWidget {
  const GlossarySearch({super.key});

  @override
  State<GlossarySearch> createState() => _GlossarySearchState();
}

class _GlossarySearchState extends State<GlossarySearch> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final q = _query.trim().toLowerCase();
    final terms = q.isEmpty
        ? kGlossary
        : kGlossary
            .where((t) => t.$1.toLowerCase().contains(q) || t.$2.toLowerCase().contains(q))
            .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 18),
                labelText: 'Search glossary',
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final (term, def) in terms)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            term,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          ),
                          Text(def, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  if (terms.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No matching terms.',
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------- class comparison

/// Class A vs Class B comparison table.
class ClassComparisonTable extends StatelessWidget {
  const ClassComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    'Aspect',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Class A',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: appColors.info,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Class B',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: appColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 12),
            for (final (aspect, a, b) in kClassComparison)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        aspect,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(a, style: const TextStyle(fontSize: 11.5)),
                    ),
                    Expanded(
                      child: Text(b, style: const TextStyle(fontSize: 11.5)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------- distress devices

/// Cards describing distress / safety transmitters.
class DistressDeviceCards extends StatelessWidget {
  const DistressDeviceCards({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Column(
      children: [
        for (final (mmsi, name, text) in kDistressDevices)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TintedCard(
              accent: appColors.danger,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      mmsi,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(text, style: const TextStyle(fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// -------------------------------------------------------------- gotchas

/// Real-world AIS quirks as expandable cards.
class GotchasList extends StatelessWidget {
  const GotchasList({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Column(
      children: [
        for (final (title, text) in kAisGotchas)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              shape: const Border(),
              leading: Icon(Icons.warning_amber, color: appColors.warning),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 12.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// -------------------------------------------------------------- cheat sheet

/// A compact at-a-glance reference.
class CheatSheet extends StatelessWidget {
  const CheatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _block(
          context,
          'Radio',
          const [
            ('Frequencies', 'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)'),
            ('Modulation', 'GMSK, 9 600 bits/s'),
            ('Range', '~10-20 NM ship-to-ship, line of sight'),
          ],
        ),
        _block(
          context,
          'Reporting rates',
          const [
            ('Class A position (1)', 'Every 2-10 s underway, 3 min anchored'),
            ('Static (5)', 'Every 6 min'),
            ('Class B position (18)', '~Every 30 s'),
            ('Aid to navigation (21)', 'Every 3 min'),
          ],
        ),
        _block(
          context,
          'Navigation status (0-15)',
          const [
            ('0', 'Under way using engine'),
            ('1', 'At anchor'),
            ('3', 'Restricted manoeuvrability'),
            ('5', 'Moored'),
            ('6', 'Aground'),
            ('7', 'Fishing'),
            ('8', 'Under way sailing'),
            ('14', 'AIS-SART active'),
          ],
        ),
        _block(
          context,
          'MMSI formats',
          kMmsiFormats.take(6).toList(),
        ),
        _block(
          context,
          'Fix types (EPFD)',
          const [
            ('1', 'GPS'),
            ('2', 'GLONASS'),
            ('3', 'GPS + GLONASS'),
            ('8', 'Galileo'),
            ('15', 'Internal GNSS'),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'KikAis ships a full interactive reference on every tab — the '
          'Editor can build any message, the Decoder reads them back.',
          style: TextStyle(
            fontSize: 12,
            color: appColors.info,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _block(BuildContext context, String title, List<(String, String)> rows) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              for (final (k, v) in rows)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          k,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(child: Text(v, style: const TextStyle(fontSize: 11.5))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
