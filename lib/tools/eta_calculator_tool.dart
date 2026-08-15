import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../tools_data/eta_calc.dart';
import '../widgets.dart';

enum _DistanceUnit { nm, km }

/// Computes the ETA (in AIS Type 5 field layout) of a transit.
class EtaCalculatorTool extends StatefulWidget {
  const EtaCalculatorTool({super.key});

  @override
  State<EtaCalculatorTool> createState() => _EtaCalculatorToolState();
}

class _EtaCalculatorToolState extends State<EtaCalculatorTool> {
  final TextEditingController _distanceC = TextEditingController();
  final TextEditingController _speedC = TextEditingController();
  _DistanceUnit _unit = _DistanceUnit.nm;
  AisEta? _eta;
  double? _durationHours;

  @override
  void dispose() {
    _distanceC.dispose();
    _speedC.dispose();
    super.dispose();
  }

  void _run() {
    final distance = double.tryParse(_distanceC.text.replaceAll(',', '.'));
    final speed = double.tryParse(_speedC.text.replaceAll(',', '.'));
    if (distance == null ||
        speed == null ||
        distance < 0 ||
        speed < 0 ||
        _unit == _DistanceUnit.km && distance == 0) {
      setState(() {
        _eta = null;
        _durationHours = null;
      });
      return;
    }
    final distanceNm = _unit == _DistanceUnit.nm
        ? distance
        : distance / 1.852;
    setState(() {
      _durationHours = speed == 0 ? 0 : distanceNm / speed;
      _eta = computeEta(distanceNm: distanceNm, speedKn: speed);
    });
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final eta = _eta;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        SectionHeader(
          icon: Icons.schedule,
          title: context.l10n.toolEta,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _distanceC,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.etaDistance,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _run(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<_DistanceUnit>(
                    initialValue: _unit,
                    isExpanded: true,
                    mouseCursor: WidgetStateMouseCursor.clickable,
                    decoration: InputDecoration(
                      labelText: context.l10n.speedUnit,
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: _DistanceUnit.nm,
                        child: Text(context.l10n.etaUnitNm),
                      ),
                      DropdownMenuItem(
                        value: _DistanceUnit.km,
                        child: Text(context.l10n.etaUnitKm),
                      ),
                    ],
                    onChanged: (u) {
                      if (u == null) return;
                      setState(() => _unit = u);
                      _run();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _speedC,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.etaSpeed,
                      suffixText: 'kn',
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
        if (eta != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(
                    context,
                    context.l10n.etaDuration,
                    formatDuration(_durationHours ?? 0),
                  ),
                  _row(
                    context,
                    context.l10n.etaEtaLocal,
                    '${_pad(eta.utc.toLocal().day)}/${_pad(eta.utc.toLocal().month)} '
                    '${_pad(eta.utc.toLocal().hour)}:${_pad(eta.utc.toLocal().minute)}',
                  ),
                  _row(
                    context,
                    context.l10n.etaEtaUtc,
                    '${_pad(eta.utc.day)}/${_pad(eta.utc.month)} '
                    '${_pad(eta.utc.hour)}:${_pad(eta.utc.minute)} UTC',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.etaAisFields,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _row(
                    context,
                    context.l10n.etaMonth,
                    '${eta.month}',
                    copy: '${eta.month}',
                  ),
                  _row(
                    context,
                    context.l10n.etaDay,
                    '${eta.day}',
                    copy: '${eta.day}',
                  ),
                  _row(
                    context,
                    context.l10n.etaHour,
                    '${eta.hour}',
                    copy: '${eta.hour}',
                  ),
                  _row(
                    context,
                    context.l10n.etaMinute,
                    '${eta.minute}',
                    copy: '${eta.minute}',
                  ),
                  const SizedBox(height: 8),
                  _row(
                    context,
                    context.l10n.etaCombined,
                    '${_pad(eta.month)}/${_pad(eta.day)} '
                    '${_pad(eta.hour)}:${_pad(eta.minute)}',
                    copy:
                        '${_pad(eta.month)}/${_pad(eta.day)} ${_pad(eta.hour)}:${_pad(eta.minute)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {String? copy}) {
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
          if (copy != null) CopyIconButton(text: copy, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
