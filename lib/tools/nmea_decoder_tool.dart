import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ais/ais_decoder.dart';
import '../ais_message_details.dart';
import '../app_settings.dart';
import '../l10n_ext.dart';
import '../nmea_field_breakdown.dart';
import '../themes.dart';
import '../widgets.dart';

class _DecodeResult {
  final List<String> raws;
  final bool decoded;
  final String status;
  final AISMessage? message;
  final List<MessageField> fields;

  const _DecodeResult({
    required this.raws,
    required this.decoded,
    required this.status,
    this.message,
    this.fields = const [],
  });
}

/// The NMEA AIS sentence decoder — the classic paste-and-decode tool.
class NmeaDecoderTool extends StatefulWidget {
  const NmeaDecoderTool({super.key});

  @override
  State<NmeaDecoderTool> createState() => NmeaDecoderToolState();
}

class NmeaDecoderToolState extends State<NmeaDecoderTool> {
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
    final pending = <String>[];
    for (final line in lines) {
      final invalidBefore = decoder.invalidChecksums;
      final errorsBefore = decoder.parseErrors;
      final message = decoder.decode(line);
      if (message != null) {
        final raws = decoder.lastRawSentences;
        if (raws.length > 1) {
          for (final earlier in raws.sublist(0, raws.length - 1)) {
            pending.remove(earlier);
          }
        }
        results.add(
          _DecodeResult(
            raws: raws,
            decoded: true,
            status: raws.length > 1
                ? context.l10n.decoderDecodedN(raws.length)
                : context.l10n.decoderDecoded,
            message: message,
            fields: describeMessage(message, context.l10n),
          ),
        );
      } else if (decoder.invalidChecksums > invalidBefore) {
        results.add(
          _DecodeResult(
            raws: [line],
            decoded: false,
            status: context.l10n.decoderInvalidChecksum,
          ),
        );
      } else if (decoder.parseErrors > errorsBefore) {
        results.add(
          _DecodeResult(
            raws: [line],
            decoded: false,
            status: context.l10n.decoderParseError,
          ),
        );
      } else {
        pending.add(line);
      }
    }
    for (final line in pending) {
      results.add(
        _DecodeResult(
          raws: [line],
          decoded: false,
          status: context.l10n.decoderWaitingFragments,
        ),
      );
    }
    setState(() => _results = results);
  }

  /// Loads [text] into the decoder box and decodes it immediately. Used by
  /// the Documentation tab's "Open in Decoder" action.
  void loadSentences(String text) {
    _controller.text = text;
    _decode();
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
          SectionHeader(
            icon: Icons.manage_search,
            title: context.l10n.toolDecoder,
            trailing: HoverTooltip(
              message: context.l10n.tooltipDecoderClear,
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  _controller.clear();
                  setState(() => _results = []);
                },
              ),
            ),
          ),
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              labelText: context.l10n.decoderInputLabel,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(context.l10n.decoderValidateChecksums),
                  value: _validateChecksum,
                  onChanged: (v) => setState(() => _validateChecksum = v),
                ),
              ),
              FilledButton.icon(
                onPressed: _decode,
                icon: const Icon(Icons.manage_search),
                label: Text(context.l10n.decoderDecode),
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
                            result.raws.join('\n'),
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        CopyIconButton(
                          text: result.raws.join('\n'),
                          message: context.l10n.receptionFrameCopied,
                          padding: EdgeInsets.zero,
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
                    if (result.raws.isNotEmpty)
                      Builder(
                        builder: (context) {
                          final (tag, _) = NmeaTagBlock.split(
                            result.raws.first,
                          );
                          if (tag == null) return const SizedBox.shrink();
                          final parts = <String>[
                            if (tag.sourceId != null)
                              context.l10n.decoderTagSource(tag.sourceId!),
                            if (tag.timeMs != null) 't:${tag.timeMs}',
                            if (tag.relativeTime != null)
                              'r:${tag.relativeTime}',
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              context.l10n.decoderTagBlock(
                                parts.isEmpty ? tag.raw : parts.join(' · '),
                              ),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    for (final raw in result.raws)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: NmeaFieldBreakdown(sentence: raw),
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
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
    );
  }
}
