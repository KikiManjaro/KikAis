import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import '../tools_data/sixbit_text.dart';
import '../widgets.dart';

/// Encodes free text into the AIS 6-bit ASCII alphabet and shows the binary,
/// hex and byte representations ready to embed in a binary message
/// (types 6/8/25/26).
class TextToBinaryTool extends StatefulWidget {
  const TextToBinaryTool({super.key});

  @override
  State<TextToBinaryTool> createState() => _TextToBinaryToolState();
}

class _TextToBinaryToolState extends State<TextToBinaryTool> {
  final TextEditingController _controller = TextEditingController();
  List<int> _values = const [];
  String _binary = '';
  String _hex = '';
  String _editorList = '';
  String _hexPairs = '';
  String _payload = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() {
        _values = const [];
        _binary = '';
        _hex = '';
        _editorList = '';
        _hexPairs = '';
        _payload = '';
      });
      return;
    }
    final values = encodeTextSixBit(text);
    final binary = sixBitValuesToBinary(values);
    final bytes = binaryToBytes(binary);
    setState(() {
      _values = values;
      _binary = binary;
      _hex = binaryToHex(binary);
      _editorList = bytesToEditorList(bytes);
      _hexPairs = bytesToHexPairs(bytes);
      _payload = toAisPayload(binary);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasResult = _values.isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        SectionHeader(
          icon: Icons.swap_horizontal_circle,
          title: context.l10n.toolTextToBinary,
        ),
        TextField(
          controller: _controller,
          maxLines: 2,
          minLines: 1,
          decoration: InputDecoration(
            labelText: context.l10n.t2bInputLabel,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _run(),
        ),
        if (hasResult) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.t2bCharTable,
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
                      for (var i = 0; i < _values.length; i++)
                        Tooltip(
                          message:
                              "'${_controller.text[i].toUpperCase()}' = ${_values[i]}",
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_controller.text[i].toUpperCase()}  '
                              '${_values[i].toString().padLeft(2)}  '
                              '${_values[i].toRadixString(2).padLeft(6, '0')}',
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
          const SizedBox(height: 8),
          _section(
            context,
            context.l10n.t2bBinary,
            _binary,
            copy: _binary,
          ),
          _section(context, context.l10n.t2bHex, _hex, copy: _hex),
          _section(
            context,
            context.l10n.t2bBytes,
            '$_editorList   ·   $_hexPairs',
            copy: _editorList,
          ),
          _section(
            context,
            context.l10n.t2bPayload,
            _payload,
            copy: _payload,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.t2bNote,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    ),
  );
  }

  Widget _section(BuildContext context, String label, String value,
      {String? copy}) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
            if (copy != null) CopyIconButton(text: copy, padding: EdgeInsets.zero),
          ],
        ),
      ),
    );
  }
}
