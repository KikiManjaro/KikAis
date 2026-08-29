import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../tools_data/radio_range.dart';
import '../widgets.dart';

/// Computes the VHF radio horizon between two antenna heights (AIS range).
class RadioRangeTool extends StatefulWidget {
  const RadioRangeTool({super.key});

  @override
  State<RadioRangeTool> createState() => _RadioRangeToolState();
}

class _RadioRangeToolState extends State<RadioRangeTool> {
  final TextEditingController _h1 = TextEditingController();
  final TextEditingController _h2 = TextEditingController();
  double? _nm;

  @override
  void dispose() {
    _h1.dispose();
    _h2.dispose();
    super.dispose();
  }

  void _run() {
    final a = double.tryParse(_h1.text.replaceAll(',', '.'));
    final b = double.tryParse(_h2.text.replaceAll(',', '.'));
    setState(() {
      _nm = (a == null || b == null)
          ? null
          : radioHorizonNm(a < 0 ? 0 : a, b < 0 ? 0 : b);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final nm = _nm;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(icon: Icons.radar, title: context.l10n.toolRadio),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    child: TextField(
                      controller: _h1,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.radioHeight1,
                        suffixText: 'm',
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => _run(),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: TextField(
                      controller: _h2,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.radioHeight2,
                        suffixText: 'm',
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => _run(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (nm != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row(
                      context,
                      context.l10n.radioHorizon,
                      '${nm.toStringAsFixed(1)} nm',
                    ),
                    _row(
                      context,
                      context.l10n.radioHorizonKm,
                      '${(nm * 1.852).toStringAsFixed(1)} km',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.radioFrequencies,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _row(context, context.l10n.radioAis1, '161.975 MHz (87B)'),
                    _row(context, context.l10n.radioAis2, '162.025 MHz (88B)'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: const TextStyle(fontSize: 13)),
          ),
          CopyIconButton(text: value, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
