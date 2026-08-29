import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../themes.dart';
import '../tools_data/nmea_checksum.dart';
import '../widgets.dart';

/// Computes and validates the NMEA XOR checksum of one or more sentences.
class ChecksumTool extends StatefulWidget {
  const ChecksumTool({super.key});

  @override
  State<ChecksumTool> createState() => _ChecksumToolState();
}

class _ChecksumToolState extends State<ChecksumTool> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _lines = [];
  final List<NmeaChecksumInfo> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final lines = _controller.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    setState(() {
      _lines
        ..clear()
        ..addAll(lines);
      _results
        ..clear()
        ..addAll(
          lines.map(inspectChecksum).whereType<NmeaChecksumInfo>().toList(),
        );
    });
  }

  void _fix(int index) {
    final fixed = fixChecksum(_lines[index]);
    _controller.text = fixed;
    _controller.selection = TextSelection.collapsed(offset: fixed.length);
    _run();
  }

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(icon: Icons.rule, title: context.l10n.toolChecksum),
          TextField(
            controller: _controller,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
              labelText: context.l10n.checksumInputLabel,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => _run(),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _lines.length; i++)
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
                          _results[i].valid
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          size: 18,
                          color: _results[i].valid
                              ? appColors.success
                              : appColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectableText(
                            _lines[i],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        CopyIconButton(
                          text: _lines[i],
                          message: context.l10n.receptionFrameCopied,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _resultRow(
                      context,
                      context.l10n.checksumComputed,
                      _results[i].computed,
                      copy: _results[i].computed,
                    ),
                    if (_results[i].declared != null)
                      _resultRow(
                        context,
                        context.l10n.checksumDeclared,
                        _results[i].declared!,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _results[i].valid
                            ? context.l10n.checksumValid
                            : context.l10n.checksumInvalid,
                        style: TextStyle(
                          fontSize: 12,
                          color: _results[i].valid
                              ? appColors.success
                              : appColors.danger,
                        ),
                      ),
                    ),
                    if (!_results[i].valid)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.tonalIcon(
                          onPressed: () => _fix(i),
                          icon: const Icon(
                            Icons.build_circle_outlined,
                            size: 16,
                          ),
                          label: Text(context.l10n.checksumFix),
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

  Widget _resultRow(
    BuildContext context,
    String label,
    String value, {
    String? copy,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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
            child: SelectableText(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (copy != null)
            CopyIconButton(text: copy, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
