import 'package:flutter/material.dart';

import 'boat.dart';

class BoatInfoBubble extends StatelessWidget {
  final Boat boat;

  const BoatInfoBubble({super.key, required this.boat});

  static String _kindLabel(BoatKind kind) => switch (kind) {
        BoatKind.vessel => 'Vessel',
        BoatKind.aircraft => 'SAR Aircraft',
        BoatKind.aton => 'Aid to Navigation',
        BoatKind.station => 'Base Station',
      };

  Widget buildRow(String title, dynamic value) {
    return Text(
      "$title: ${value ?? "-"}",
      style: TextStyle(fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12, color: Colors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("General Information", style: TextStyle(fontWeight: FontWeight.bold)),
              buildRow("Kind", _kindLabel(boat.kind)),
              buildRow("MMSI", boat.mmsi),
              buildRow("Name", boat.name),
              if (boat.kind == BoatKind.aton) ...[
                buildRow("Aid Type", boat.aidType),
                buildRow("Virtual", boat.virtualAid),
              ],
              if (boat.kind == BoatKind.aircraft)
                buildRow("Altitude", boat.altitude != null ? "${boat.altitude} m" : null),
              buildRow("Call Sign", boat.callSign),
              buildRow("IMO", boat.imoNumber),
              SizedBox(height: 4),

              Text("Position & Navigation", style: TextStyle(fontWeight: FontWeight.bold)),
              buildRow("Latitude", boat.lat?.toStringAsFixed(5)),
              buildRow("Longitude", boat.lon?.toStringAsFixed(5)),
              buildRow("Heading", boat.heading != null ? "${boat.heading!.toStringAsFixed(0)}°" : null),
              buildRow("COG", boat.cog != null ? "${boat.cog!.toStringAsFixed(1)}°" : null),
              buildRow("SOG", boat.sog != null ? "${boat.sog!.toStringAsFixed(1)} kn" : null),
              buildRow("Navigation Status", boat.navigationStatus),
              buildRow("Timestamp", boat.timestamp),
              buildRow("RAIM", boat.raimFlag),
              SizedBox(height: 4),

              Text("Vessel Details", style: TextStyle(fontWeight: FontWeight.bold)),
              buildRow("Type", boat.vesselType),
              buildRow("Type (Int)", boat.vesselTypeInt),
              buildRow("Dimensions Bow/Stern", "${boat.dimensionBow ?? "-"} / ${boat.dimensionStern ?? "-"}"),
              buildRow("Dimensions Port/Starboard", "${boat.dimensionPort ?? "-"} / ${boat.dimensionStarboard ?? "-"}"),
              buildRow("EPFD Fix Type", boat.epfdFixType),
              buildRow("Regional Reserved", boat.regionalReserved),
              buildRow("Assigned Mode", boat.assignedMode),
              buildRow("DTE", boat.dte),
              buildRow("Spare", boat.spare),
              buildRow("Draught", boat.draught),
              buildRow("Destination", boat.destination),
              buildRow("ETA", "${boat.etaDay ?? "-"} / ${boat.etaMonth ?? "-"} ${boat.etaHour ?? "-"}:${boat.etaMinute ?? "-"}"),

            ],
          ),
        ),
      ),
    );
  }
}

class BoatMarkerWithInfo extends StatefulWidget {
  final Boat boat;

  const BoatMarkerWithInfo({super.key, required this.boat});

  @override
  State<BoatMarkerWithInfo> createState() => _BoatMarkerWithInfoState();
}

class _BoatMarkerWithInfoState extends State<BoatMarkerWithInfo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (widget.boat.kind) {
      BoatKind.aircraft => (Icons.flight, Colors.orange),
      BoatKind.aton => (Icons.waves, Colors.teal),
      BoatKind.station => (Icons.cell_tower, Colors.purple),
      BoatKind.vessel => (
          Icons.directions_boat_filled_outlined,
          Colors.blue,
        ),
    };
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          if (_hovered)
            Positioned(
              bottom: 24,
              child: BoatInfoBubble(boat: widget.boat),
            ),
        ],
      ),
    );
  }
}
