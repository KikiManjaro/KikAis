import 'package:flutter/material.dart';

import 'boat.dart';

class BoatInfoBubble extends StatelessWidget {
  final Boat boat;

  const BoatInfoBubble({Key? key, required this.boat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // nécessaire sinon bulle invisible
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
              Text(
                "MMSI: ${boat.mmsi}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Nom: ${boat.name ?? "Inconnu"}"),
              Text("Lat: ${boat.lat?.toStringAsFixed(5) ?? "-"}"),
              Text("Lon: ${boat.lon?.toStringAsFixed(5) ?? "-"}"),
              Text("COG: ${boat.cog?.toStringAsFixed(1) ?? "-"}°"),
              Text("SOG: ${boat.sog?.toStringAsFixed(1) ?? "-"} kn"),
              Text("Heading: ${boat.heading?.toStringAsFixed(0) ?? "-"}°"),
              Text("Nav. Status: ${boat.navigationStatus ?? "-"}"),
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
        clipBehavior: Clip.none, // permet à la bulle de dépasser
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.directions_boat_filled_outlined,
            color: Colors.blue,
            size: 16,
          ),
          if (_hovered)
            Positioned(
              bottom: 24, // distance au-dessus du bateau
              child: BoatInfoBubble(boat: widget.boat),
            ),
        ],
      ),
    );
  }
}
