import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n_ext.dart';
import '../themes.dart';
import '../tools_data/mmsi_info.dart';
import '../widgets.dart';

class _DigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 9) return oldValue;
    return newValue.copyWith(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

/// Validates an MMSI and looks up its MID country and station type.
class MmsiLookupTool extends StatefulWidget {
  const MmsiLookupTool({super.key});

  @override
  State<MmsiLookupTool> createState() => _MmsiLookupToolState();
}

class _MmsiLookupToolState extends State<MmsiLookupTool> {
  final TextEditingController _controller = TextEditingController();
  MmsiInfo? _info;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final text = _controller.text.trim();
    setState(() => _info = text.isEmpty ? null : inspectMmsi(text));
  }

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final info = _info;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(icon: Icons.badge, title: context.l10n.toolMmsi),
          TextField(
            controller: _controller,
            maxLength: 9,
            keyboardType: TextInputType.number,
            inputFormatters: [_DigitsFormatter()],
            decoration: InputDecoration(
              labelText: context.l10n.mmsiInputLabel,
              border: const OutlineInputBorder(),
              counterText: '',
            ),
            onChanged: (_) => _run(),
          ),
          const SizedBox(height: 16),
          if (info != null) ...[
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          info.valid
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          size: 18,
                          color: info.valid
                              ? appColors.success
                              : appColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          info.valid
                              ? context.l10n.mmsiValid
                              : context.l10n.mmsiInvalid,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (info.valid) ...[
                      const SizedBox(height: 10),
                      _row(context, context.l10n.mmsiMid, info.mid!),
                      _row(
                        context,
                        context.l10n.mmsiCountry,
                        info.country ?? context.l10n.mmsiCountryUnknown,
                      ),
                      _row(context, context.l10n.mmsiType, _typeLabel(context)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (_info!.stationType) {
      MmsiStationType.groupCall => l10n.mmsiGroupCall,
      MmsiStationType.sarAircraft => l10n.mmsiSarAircraft,
      MmsiStationType.coastStation => l10n.mmsiCoastStation,
      MmsiStationType.shipStation => l10n.mmsiShipStation,
      MmsiStationType.handheldVhf => l10n.mmsiHandheldVhf,
      MmsiStationType.aton => l10n.mmsiAton,
      MmsiStationType.sar => l10n.mmsiSar,
      MmsiStationType.other => l10n.mmsiOther,
    };
  }

  Widget _row(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
