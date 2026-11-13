import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../themes.dart';
import '../tools_data/nmea_checksum.dart';
import '../widgets.dart';

/// One input line plus its checksum report. Keeping the source [index] lets
/// [_ChecksumToolState._fix] rewrite only that line in a multi-line buffer.
class _ChecksumRow {
  final int index;
  final String line;
  final NmeaChecksumInfo info;

  const _ChecksumRow(this.index, this.line, this.info);

  /// Whether the checksum can be (re)written for this line.
  bool get canFix => info.parsed && (info.declared == null || !info.valid);
}

/// Computes and validates the NMEA XOR checksum of one or more sentences.
///
/// Every non-empty line gets a card, including lines that are not NMEA
/// sentences: the tool then reports the XOR of the text itself instead of
/// dropping the line (which previously made the result list shorter than the
/// input list and crashed the build).
class ChecksumTool extends StatefulWidget {
  const ChecksumTool({super.key});

  @override
  State<ChecksumTool> createState() => _ChecksumToolState();
}

class _ChecksumToolState extends State<ChecksumTool> {
  final TextEditingController _controller = TextEditingController();
  List<_ChecksumRow> _rows = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final rows = <_ChecksumRow>[];
    final lines = _controller.text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      rows.add(_ChecksumRow(i, line, checksumReport(line)));
    }
    setState(() => _rows = rows);
  }

  void _fix(_ChecksumRow row) {
    final lines = _controller.text.split('\n');
    lines[row.index] = fixChecksum(row.line);
    final text = lines.join('\n');
    _controller.text = text;
    _controller.selection = TextSelection.collapsed(offset: text.length);
    _run();
  }

  @override
  Widget build(BuildContext context) {
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
          for (final row in _rows) _ChecksumCard(row: row, onFix: _fix),
        ],
      ),
    );
  }
}

class _ChecksumCard extends StatelessWidget {
  final _ChecksumRow row;
  final void Function(_ChecksumRow row) onFix;

  const _ChecksumCard({required this.row, required this.onFix});

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final info = row.info;
    final (icon, color, status) = _state(context, appColors);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    row.line,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                CopyIconButton(
                  text: row.line,
                  message: context.l10n.receptionFrameCopied,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _resultRow(
              context,
              context.l10n.checksumComputed,
              info.computed,
              copy: info.computed,
            ),
            if (info.declared != null)
              _resultRow(
                context,
                context.l10n.checksumDeclared,
                info.declared!,
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(status, style: TextStyle(fontSize: 12, color: color)),
            ),
            if (row.canFix)
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: () => onFix(row),
                  icon: const Icon(Icons.build_circle_outlined, size: 16),
                  label: Text(context.l10n.checksumFix),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Icon, colour and status line for the current row.
  (IconData, Color, String) _state(BuildContext context, AppColors colors) {
    final info = row.info;
    if (!info.parsed) {
      return (
        Icons.info_outline,
        Theme.of(context).colorScheme.onSurfaceVariant,
        context.l10n.checksumNotNmea,
      );
    }
    if (info.declared == null) {
      return (
        Icons.info_outline,
        colors.warning,
        context.l10n.checksumNoDeclared,
      );
    }
    return info.valid
        ? (
            Icons.check_circle_outline,
            colors.success,
            context.l10n.checksumValid,
          )
        : (
            Icons.warning_amber_rounded,
            colors.danger,
            context.l10n.checksumInvalid,
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
