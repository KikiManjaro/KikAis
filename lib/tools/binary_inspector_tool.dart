import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../themes.dart';
import '../tools_data/binary_inspect.dart';
import '../widgets.dart';

/// Inspects a raw NMEA AIS sentence or a bare 6-bit payload down to the bit
/// level (hex, bytes, per-character 6-bit values).
class BinaryInspectorTool extends StatefulWidget {
  const BinaryInspectorTool({super.key});

  @override
  State<BinaryInspectorTool> createState() => _BinaryInspectorToolState();
}

class _BinaryInspectorToolState extends State<BinaryInspectorTool> {
  final TextEditingController _controller = TextEditingController();
  final List<BinaryInspection> _results = [];

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
      _results
        ..clear()
        ..addAll(
          lines.map(inspectBinary).whereType<BinaryInspection>().toList(),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        SectionHeader(
          icon: Icons.memory,
          title: context.l10n.toolBinary,
        ),
        TextField(
          controller: _controller,
          maxLines: 4,
          minLines: 2,
          decoration: InputDecoration(
            labelText: context.l10n.binaryInputLabel,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _run(),
        ),
        const SizedBox(height: 16),
        for (final result in _results)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.hexagon_outlined,
                        size: 18,
                        color: appColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SelectableText(
                          result.sentence?.raw ?? result.payload,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      CopyIconButton(
                        text: result.sentence?.raw ?? result.payload,
                        message: context.l10n.receptionFrameCopied,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (result.sentence != null)
                    _row(context, context.l10n.binaryPayload, result.payload),
                  _row(
                    context,
                    context.l10n.binaryBits,
                    '${result.binary.length}',
                  ),
                  _row(context, context.l10n.binaryBinary, result.binary),
                  _row(context, context.l10n.binaryHex, result.hex),
                  _row(context, context.l10n.binaryHexBytes, result.hexBytes),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.binarySixBit,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (var i = 0; i < result.payload.length; i++)
                        Tooltip(
                          message:
                              "'${result.payload[i]}' → ${result.sixBitValues[i]}",
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              result.payload[i],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                fontSize: 12,
              ),
            ),
          ),
          CopyIconButton(text: value, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
