import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../tools_data/speed_units.dart';
import '../widgets.dart';

String speedUnitLabel(SpeedUnit unit) => switch (unit) {
  SpeedUnit.knots => 'kn',
  SpeedUnit.kmh => 'km/h',
  SpeedUnit.ms => 'm/s',
  SpeedUnit.mph => 'mph',
};

/// Converts a speed between knots, km/h, m/s and mph.
class SpeedConverterTool extends StatefulWidget {
  const SpeedConverterTool({super.key});

  @override
  State<SpeedConverterTool> createState() => _SpeedConverterToolState();
}

class _SpeedConverterToolState extends State<SpeedConverterTool> {
  final TextEditingController _controller = TextEditingController();
  SpeedUnit _unit = SpeedUnit.knots;
  Map<SpeedUnit, double>? _results;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final value = double.tryParse(_controller.text.replaceAll(',', '.'));
    setState(
      () => _results = value == null || value.isNaN
          ? null
          : convertSpeed(value, _unit),
    );
  }

  String _fmt(double v) {
    final abs = v.abs();
    if (abs >= 1000) return v.toStringAsFixed(0);
    if (abs >= 100) return v.toStringAsFixed(1);
    if (abs >= 10) return v.toStringAsFixed(2);
    return v.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(icon: Icons.speed, title: context.l10n.toolSpeed),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.speedValue,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => _run(),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<SpeedUnit>(
                      initialValue: _unit,
                      isExpanded: true,
                      mouseCursor: WidgetStateMouseCursor.clickable,
                      decoration: InputDecoration(
                        labelText: context.l10n.speedUnit,
                        isDense: true,
                      ),
                      items: [
                        for (final u in SpeedUnit.values)
                          DropdownMenuItem(
                            value: u,
                            child: Text(speedUnitLabel(u)),
                          ),
                      ],
                      onChanged: (u) {
                        if (u == null) return;
                        setState(() => _unit = u);
                        _run();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_results != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    for (final unit in SpeedUnit.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                speedUnitLabel(unit),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SelectableText(
                                _fmt(_results![unit]!),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            CopyIconButton(
                              text: _fmt(_results![unit]!),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
