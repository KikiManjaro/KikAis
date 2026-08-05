import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'boat.dart';
import 'boatmanager.dart';
import 'bubble_boat.dart';

class WorldMapPage extends StatefulWidget {
  const WorldMapPage({super.key});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  bool clusterEnabled = true;

  void toggleMarkers() {
    setState(() {
      clusterEnabled = !clusterEnabled;
    });
  }

  void toggleCompute(BoatManager boatManager) {
    boatManager.setSendToMap(!boatManager.sendToMap);
  }

  List<Marker> _buildMarkers(List<Boat> boats) {
    return boats
        .where(
          (boat) =>
              boat.lat != null &&
              boat.lon != null &&
              boat.lat! >= -90 &&
              boat.lat! <= 90 &&
              boat.lon! >= -180 &&
              boat.lon! <= 180,
        )
        .map((boat) {
          try {
            return Marker(
              point: LatLng(boat.lat!, boat.lon!),
              width: 80,
              height: 50,
              child: BoatMarkerWithInfo(boat: boat),
            );
          } catch (e, stack) {
            debugPrint(
              'Error creating marker for boat ${boat.mmsi}: $e\n$stack',
            );
            return null;
          }
        })
        .where((marker) => marker != null)
        .cast<Marker>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final boatManager = context.watch<BoatManager>();
    final markers = _buildMarkers(boatManager.boats);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [
          IconButton(
            icon: Icon(
              clusterEnabled ? Icons.scatter_plot : Icons.group_work,
            ),
            onPressed: toggleMarkers,
            tooltip: clusterEnabled ? "Disable clustering" : "Enable clustering",
          ),
          IconButton(
            icon: Icon(
              boatManager.sendToMap
                  ? Icons.directions_boat
                  : Icons.hide_source_rounded,
            ),
            onPressed: () => toggleCompute(boatManager),
            tooltip: boatManager.sendToMap
                ? "Don't compute boats"
                : "Compute boats",
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(48.8566, 2.3522),
          initialZoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.kikimanjaro.kikais',
          ),
          if (clusterEnabled)
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                polygonOptions: PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 3,
                ),
                builder: (context, markers) {
                  return FloatingActionButton(
                    onPressed: null,
                    child: Text(markers.length.toString()),
                  );
                },
                markers: markers,
              ),
            )
          else
            MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
