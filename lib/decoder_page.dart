import 'package:flutter/material.dart';

import 'decoder_tools.dart';
import 'l10n_ext.dart';
import 'themes.dart';
import 'tools/binary_inspector_tool.dart';
import 'tools/checksum_tool.dart';
import 'tools/eta_calculator_tool.dart';
import 'tools/mmsi_lookup_tool.dart';
import 'tools/nmea_decoder_tool.dart';
import 'tools/radio_range_tool.dart';
import 'tools/speed_converter_tool.dart';
import 'tools/text_to_binary_tool.dart';

/// The Decoder tab: a hub of small AIS/NMEA utilities. A side rail selects the
/// active tool; each tool keeps its own state while the hub stays alive.
class DecoderPage extends StatefulWidget {
  const DecoderPage({super.key});

  @override
  State<DecoderPage> createState() => DecoderPageState();
}

class DecoderPageState extends State<DecoderPage> {
  final GlobalKey<NmeaDecoderToolState> _decoderToolKey =
      GlobalKey<NmeaDecoderToolState>();
  DecoderTool _tool = DecoderTool.decoder;

  /// Loads [text] into the NMEA decoder tool and decodes it immediately.
  /// Used by the Documentation tab's "Open in Decoder" action.
  void loadSentences(String text) {
    setState(() => _tool = DecoderTool.decoder);
    _decoderToolKey.currentState?.loadSentences(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tabTools)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ToolRail(
            selected: _tool,
            onSelected: (t) => setState(() => _tool = t),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _tool.index,
              children: [
                NmeaDecoderTool(key: _decoderToolKey),
                const ChecksumTool(),
                const MmsiLookupTool(),
                const SpeedConverterTool(),
                const BinaryInspectorTool(),
                const EtaCalculatorTool(),
                const RadioRangeTool(),
                const TextToBinaryTool(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The vertical tool list on the left of the Decoder tab.
class _ToolRail extends StatelessWidget {
  final DecoderTool selected;
  final ValueChanged<DecoderTool> onSelected;

  const _ToolRail({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return SizedBox(
      width: 210,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          for (final tool in DecoderTool.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Material(
                color: tool == selected
                    ? appColors.info.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onSelected(tool),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          tool.icon,
                          size: 20,
                          color: tool == selected
                              ? appColors.info
                              : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tool.title(context.l10n),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: tool == selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              Text(
                                tool.subtitle(context.l10n),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
