import 'package:flutter/material.dart';

import 'boat.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';
import 'value_labels.dart';
import 'widgets.dart';

class BoatInfoBubble extends StatelessWidget {
  final Boat boat;
  final VoidCallback? onClose;

  const BoatInfoBubble({super.key, required this.boat, this.onClose});

  static String _kindLabel(BoatKind kind, AppLocalizations l10n) =>
      switch (kind) {
        BoatKind.vessel => l10n.bubbleKindVessel,
        BoatKind.aircraft => l10n.bubbleKindAircraft,
        BoatKind.aton => l10n.bubbleKindAton,
        BoatKind.station => l10n.bubbleKindStation,
      };

  Widget buildRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 2),
    child: Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 6),
          child: Row(
            children: [
              Icon(_kindIcon(boat.kind), color: scheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  boat.name?.trim().isNotEmpty == true
                      ? boat.name!.trim()
                      : l10n.mapMmsi(boat.mmsi),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onClose != null)
                HoverTooltip(
                  message: context.l10n.tooltipClose,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    visualDensity: VisualDensity.compact,
                    onPressed: onClose,
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 12, color: scheme.onSurface),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(l10n.bubbleGeneralInfo),
                  buildRow(l10n.bubbleKind, _kindLabel(boat.kind, l10n)),
                  buildRow(l10n.fMmsi, boat.mmsi),
                  buildRow(l10n.fName, boat.name),
                  if (boat.kind == BoatKind.aton) ...[
                    buildRow(
                      l10n.bubbleAidType,
                      boat.aidType == null
                          ? null
                          : valueLabel(l10n, boat.aidType!),
                    ),
                    buildRow(l10n.bubbleVirtual, boat.virtualAid),
                  ],
                  if (boat.kind == BoatKind.aircraft)
                    buildRow(
                      l10n.bubbleAltitude,
                      boat.altitude != null ? '${boat.altitude} m' : null,
                    ),
                  buildRow(l10n.bubbleCallSign, boat.callSign),
                  buildRow(l10n.fImo, boat.imoNumber),
                  _section(l10n.bubblePosNav),
                  buildRow(l10n.fLatitude, boat.lat?.toStringAsFixed(5)),
                  buildRow(l10n.fLongitude, boat.lon?.toStringAsFixed(5)),
                  buildRow(
                    l10n.bubbleHeading,
                    boat.heading != null
                        ? '${boat.heading!.toStringAsFixed(0)}°'
                        : null,
                  ),
                  buildRow(
                    l10n.bubbleCog,
                    boat.cog != null
                        ? '${boat.cog!.toStringAsFixed(1)}°'
                        : null,
                  ),
                  buildRow(
                    l10n.bubbleSog,
                    boat.sog != null
                        ? '${boat.sog!.toStringAsFixed(1)} kn'
                        : null,
                  ),
                  buildRow(
                    l10n.fNavStatus,
                    boat.navigationStatus == null
                        ? null
                        : valueLabel(l10n, boat.navigationStatus!),
                  ),
                  buildRow(l10n.fTimestamp, boat.timestamp),
                  buildRow(l10n.fRaim, boat.raimFlag),
                  _section(l10n.bubbleVesselDetails),
                  buildRow(
                    l10n.bubbleType,
                    boat.vesselType == null
                        ? null
                        : valueLabel(l10n, boat.vesselType!),
                  ),
                  buildRow(l10n.bubbleTypeInt, boat.vesselTypeInt),
                  buildRow(
                    l10n.bubbleDimsBowStern,
                    '${boat.dimensionBow ?? '-'} / '
                    '${boat.dimensionStern ?? '-'}',
                  ),
                  buildRow(
                    l10n.bubbleDimsPortStarboard,
                    '${boat.dimensionPort ?? '-'} / '
                    '${boat.dimensionStarboard ?? '-'}',
                  ),
                  buildRow(
                    l10n.fEpfdFixType,
                    boat.epfdFixType == null
                        ? null
                        : valueLabel(l10n, boat.epfdFixType!),
                  ),
                  buildRow(l10n.fRegionalReserved, boat.regionalReserved),
                  buildRow(l10n.fAssignedMode, boat.assignedMode),
                  buildRow(l10n.fDte, boat.dte),
                  buildRow(l10n.bubbleSpare, boat.spare),
                  buildRow(l10n.bubbleDraught, boat.draught),
                  buildRow(l10n.fDestination, boat.destination),
                  buildRow(
                    l10n.fEta,
                    '${boat.etaDay ?? '-'} / ${boat.etaMonth ?? '-'} '
                    '${boat.etaHour ?? '-'}:${boat.etaMinute ?? '-'}',
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        _BoatFrameLog(boat: boat),
      ],
    );
  }

  IconData _kindIcon(BoatKind kind) => switch (kind) {
    BoatKind.vessel => Icons.directions_boat,
    BoatKind.aircraft => Icons.flight,
    BoatKind.aton => Icons.waves,
    BoatKind.station => Icons.cell_tower,
  };
}

/// Bottom panel listing the raw NMEA frames that decoded for this boat, with
/// a copy button per frame and a copy-all action.
class _BoatFrameLog extends StatefulWidget {
  final Boat boat;

  const _BoatFrameLog({required this.boat});

  @override
  State<_BoatFrameLog> createState() => _BoatFrameLogState();
}

class _BoatFrameLogState extends State<_BoatFrameLog> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final frames = widget.boat.frameLog;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
            child: Row(
              children: [
                Icon(Icons.list_alt, size: 16, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  context.l10n.bubbleFrames('${frames.length}'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (frames.isNotEmpty)
                  CopyIconButton(
                    text: frames.map((f) => f.raw).join('\n'),
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                  ),
                Icon(
                  _expanded ? Icons.expand_more : Icons.expand_less,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          SizedBox(
            height: 170,
            child: frames.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.bubbleNoFrames,
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: frames.length,
                    itemBuilder: (context, i) {
                      final frame = frames[frames.length - 1 - i];
                      return _FrameRow(frame: frame);
                    },
                  ),
          ),
      ],
    );
  }
}

class _FrameRow extends StatelessWidget {
  final BoatFrame frame;

  const _FrameRow({required this.frame});

  static String _time(DateTime t) {
    final local = t.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            _time(frame.time),
            style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          if (frame.feed != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                frame.feed!,
                style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              frame.raw,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: scheme.onSurface,
              ),
            ),
          ),
          CopyIconButton(
            text: frame.raw,
            iconSize: 14,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
