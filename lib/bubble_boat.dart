import 'package:flutter/material.dart';

import 'boat.dart';

class BoatInfoBubble extends StatelessWidget {
  final Boat boat;

  const BoatInfoBubble({Key? key, required this.boat}) : super(key: key);

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
              buildRow("MMSI", boat.mmsi),
              buildRow("Name", boat.name),
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

  const BoatMarkerWithInfo({Key? key, required this.boat}) : super(key: key);

  @override
  State<BoatMarkerWithInfo> createState() => _BoatMarkerWithInfoState();
}

class _BoatMarkerWithInfoState extends State<BoatMarkerWithInfo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.directions_boat_filled_outlined,
            color: Colors.blue,
            size: 16,
          ),
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
