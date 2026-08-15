import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';

/// The tools available in the Decoder tab. Order defines the side-rail order.
enum DecoderTool {
  decoder('decoder', Icons.manage_search_outlined),
  checksum('checksum', Icons.rule_outlined),
  mmsi('mmsi', Icons.badge_outlined),
  speed('speed', Icons.speed_outlined),
  binary('binary', Icons.memory_outlined),
  eta('eta', Icons.schedule_outlined),
  radio('radio', Icons.radar_outlined),
  textToBinary('textToBinary', Icons.swap_horizontal_circle_outlined);

  const DecoderTool(this.key, this.icon);

  /// Stable identifier, used to persist the selected tool.
  final String key;

  final IconData icon;

  String title(AppLocalizations l10n) => switch (this) {
        DecoderTool.decoder => l10n.toolDecoder,
        DecoderTool.checksum => l10n.toolChecksum,
        DecoderTool.mmsi => l10n.toolMmsi,
        DecoderTool.speed => l10n.toolSpeed,
        DecoderTool.binary => l10n.toolBinary,
        DecoderTool.eta => l10n.toolEta,
        DecoderTool.radio => l10n.toolRadio,
        DecoderTool.textToBinary => l10n.toolTextToBinary,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        DecoderTool.decoder => l10n.toolDecoderSub,
        DecoderTool.checksum => l10n.toolChecksumSub,
        DecoderTool.mmsi => l10n.toolMmsiSub,
        DecoderTool.speed => l10n.toolSpeedSub,
        DecoderTool.binary => l10n.toolBinarySub,
        DecoderTool.eta => l10n.toolEtaSub,
        DecoderTool.radio => l10n.toolRadioSub,
        DecoderTool.textToBinary => l10n.toolTextToBinarySub,
      };
}
