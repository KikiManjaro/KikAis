import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ais/ais_decoder.dart';
import 'ais_message_details.dart';
import 'app_settings.dart';
import 'themes.dart';

class _DecodeResult {
  final String raw;
  final bool decoded;
  final String status;
  final AISMessage? message;
  final List<MessageField> fields;

  const _DecodeResult({
    required this.raw,
    required this.decoded,
    required this.status,
    this.message,
    this.fields = const [],
  });
}

class DecoderPage extends StatefulWidget {
  const DecoderPage({super.key});

  @override
  State<DecoderPage> createState() => _DecoderPageState();
}

class _DecoderPageState extends State<DecoderPage> {
  final TextEditingController _controller = TextEditingController();
  late bool _validateChecksum;
  List<_DecodeResult> _results = [];

  @override
  void initState() {
    super.initState();
    _validateChecksum = context.read<AppSettings>().validateChecksum;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _decode() {
    final lines = _controller.text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return;

    final decoder = AisNmeaDecoder(validateChecksum: _validateChecksum);
    final results = <_DecodeResult>[];
    for (final line in lines) {
      final invalidBefore = decoder.invalidChecksums;
      final errorsBefore = decoder.parseErrors;
      final message = decoder.decode(line);
      if (message != null) {
        results.add(
          _DecodeResult(
            raw: line,
            decoded: true,
            status: 'Decoded',
            message: message,
            fields: describeMessage(message),
          ),
        );
      } else if (decoder.invalidChecksums > invalidBefore) {
        results.add(
          _DecodeResult(
            raw: line,
            decoded: false,
            status: 'Invalid checksum',
          ),
        );
      } else if (decoder.parseErrors > errorsBefore) {
        results.add(
          _DecodeResult(
            raw: line,
            decoded: false,
            status: 'Parse error',
          ),
        );
      } else {
        results.add(
          _DecodeResult(
            raw: line,
            decoded: false,
            status: 'Waiting for more fragments…',
          ),
        );
      }
    }
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decoder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _controller.clear();
              setState(() => _results = []);
            },
            tooltip: 'Clear',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            decoration: const InputDecoration(
              labelText: 'Paste or write one or more NMEA AIS sentences',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Validate checksums'),
                  value: _validateChecksum,
                  onChanged: (v) => setState(() => _validateChecksum = v),
                ),
              ),
              FilledButton.icon(
                onPressed: _decode,
                icon: const Icon(Icons.manage_search),
                label: const Text('Decode'),
              ),
            ],
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
                          result.decoded
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          size: 18,
                          color: result.decoded
                              ? appColors.success
                              : appColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectableText(
                            result.raw,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Clipboard.setData(
                            ClipboardData(text: result.raw),
                          ),
                          tooltip: 'Copy this frame',
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        result.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: result.decoded
                              ? appColors.success
                              : appColors.warning,
                        ),
                      ),
                    ),
                    if (result.decoded)
                      for (final field in result.fields)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  field.$1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SelectableText(
                                  field.$2,
                                  style: const TextStyle(fontSize: 12),
                                ),
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
    ),
    );
  }
}
