import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'basemaps.dart';
import 'boat.dart';
import 'boat_map_layer.dart';
import 'boatmanager.dart';
import 'bubble_boat.dart';
import 'mid_countries.dart';

class MapFilters {
  String? vesselType;
  String? navigationStatus;
  String? country;
  double? minSog;
  double? maxSog;
  bool onlyNamed = false;

  bool get active =>
      vesselType != null ||
      navigationStatus != null ||
      country != null ||
      minSog != null ||
      maxSog != null ||
      onlyNamed;
}

class WorldMapPage extends StatefulWidget {
  /// Overridable for tests (avoids real network tile requests).
  final TileProvider? tileProvider;

  const WorldMapPage({super.key, this.tileProvider});

  @override
  State<WorldMapPage> createState() => _WorldMapPageState();
}

class _WorldMapPageState extends State<WorldMapPage> {
  final MapController _mapController = MapController();
  double _zoom = 5.0;
  bool clusterEnabled = true;
  String? _followingMmsi;
  MapFilters _filters = MapFilters();
  Boat? _selected;
  String? _hoverName;
  late BoatManager _boatManager;
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _boatManager = context.read<BoatManager>();
    _settings = context.read<AppSettings>();
    clusterEnabled = _settings.mapClusterEnabled;
    // Defer the BoatManager sync to the first post-frame so setSendToMap's
    // notifyListeners() doesn't fire while the tree is being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_boatManager.sendToMap != _settings.sendToMap) {
        _boatManager.setSendToMap(_settings.sendToMap);
      }
    });
    _boatManager.addListener(_onBoatsChanged);
  }

  @override
  void dispose() {
    _boatManager.removeListener(_onBoatsChanged);
    _mapController.dispose();
    super.dispose();
  }

  void _onBoatsChanged() {
    if (_followingMmsi == null) return;
    final boat = _findBoat(_followingMmsi!);
    if (boat?.lat == null || boat?.lon == null) return;
    try {
      _mapController.move(LatLng(boat!.lat!, boat.lon!), _zoom);
    } catch (_) {
      // Map not ready yet.
    }
  }

  Boat? _findBoat(String mmsi) {
    for (final b in _boatManager.boats) {
      if (b.mmsi == mmsi) return b;
    }
    return null;
  }

  void toggleMarkers() {
    setState(() {
      clusterEnabled = !clusterEnabled;
    });
    _settings.mapClusterEnabled = clusterEnabled;
    _settings.save();
  }

  void toggleCompute() {
    _boatManager.setSendToMap(!_boatManager.sendToMap);
    _settings.sendToMap = _boatManager.sendToMap;
    _settings.save();
  }

  bool _matchesFilters(Boat boat) {
    final f = _filters;
    if (f.onlyNamed && (boat.name == null || boat.name!.isEmpty)) return false;
    if (f.vesselType != null && boat.vesselType != f.vesselType) return false;
    if (f.navigationStatus != null &&
        boat.navigationStatus != f.navigationStatus) {
      return false;
    }
    if (f.country != null && midCountryOf(boat.mmsi) != f.country) return false;
    if (f.minSog != null && (boat.sog == null || boat.sog! < f.minSog!)) {
      return false;
    }
    if (f.maxSog != null && (boat.sog == null || boat.sog! > f.maxSog!)) {
      return false;
    }
    return true;
  }

  List<Boat> _visibleBoats() {
    return _boatManager.boats
        .where((b) => b.lat != null && b.lon != null && _matchesFilters(b))
        .toList();
  }

  Future<String?> _showSearchDialog() async {
    final controller = TextEditingController();
    String? selected;
    await showDialog<String>(
      context: context,
      builder: (ctx) {
        final manager = ctx.read<BoatManager>();
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final q = controller.text.trim().toLowerCase();
            final results = manager.boats.where((b) {
              if (q.isEmpty) return true;
              return (b.name?.toLowerCase().contains(q) ?? false) ||
                  b.mmsi.contains(q) ||
                  (b.imoNumber?.toString().contains(q) ?? false);
            }).toList();
            return AlertDialog(
              title: const Text('Search vessels'),
              content: SizedBox(
                width: 420,
                height: 420,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Name, MMSI or IMO',
                      ),
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: results.isEmpty
                          ? const Center(child: Text('No results'))
                          : ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (ctx, i) {
                                final b = results[i];
                                return ListTile(
                                  dense: true,
                                  title: Text(b.name ?? b.mmsi),
                                  subtitle: Text(
                                    'MMSI ${b.mmsi}'
                                    '${b.imoNumber != null ? ' · IMO ${b.imoNumber}' : ''}'
                                    '${b.vesselType != null ? ' · ${b.vesselType}' : ''}',
                                  ),
                                  onTap: () {
                                    selected = b.mmsi;
                                    Navigator.pop(ctx);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
    return selected;
  }

  Future<void> _handleSearch() async {
    final mmsi = await _showSearchDialog();
    if (mmsi == null || !mounted) return;
    final boat = _findBoat(mmsi);
    if (boat == null) return;
    setState(() => _followingMmsi = mmsi);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || boat.lat == null || boat.lon == null) return;
      try {
        _mapController.move(LatLng(boat.lat!, boat.lon!), _zoom);
      } catch (_) {}
    });
  }

  Future<void> _showFiltersDialog() async {
    final manager = context.read<BoatManager>();

    final types = <String>{
      for (final b in manager.boats)
        if (b.vesselType != null && b.vesselType!.isNotEmpty) b.vesselType!,
    }.toList()..sort();
    final statuses = <String>{
      for (final b in manager.boats)
        if (b.navigationStatus != null && b.navigationStatus!.isNotEmpty)
          b.navigationStatus!,
    }.toList()..sort();
    final countries = kMidCountries.values.toSet().toList()..sort();

    var draft = MapFilters()
      ..vesselType = _filters.vesselType
      ..navigationStatus = _filters.navigationStatus
      ..country = _filters.country
      ..minSog = _filters.minSog
      ..maxSog = _filters.maxSog
      ..onlyNamed = _filters.onlyNamed;

    final minSogController =
        TextEditingController(text: _filters.minSog?.toString() ?? '');
    final maxSogController =
        TextEditingController(text: _filters.maxSog?.toString() ?? '');

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Widget buildDropdown<T>({
            required String label,
            required List<T> options,
            required T? value,
            required String Function(T) labelOf,
            required void Function(T?) onChanged,
          }) {
            return InputDecorator(
              decoration: InputDecoration(labelText: label, isDense: true),
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem<T>(
                    value: null,
                    child: Text('All ${label.toLowerCase()}'),
                  ),
                  for (final o in options)
                    DropdownMenuItem<T>(value: o, child: Text(labelOf(o))),
                ],
                onChanged: (v) => setDialogState(() => onChanged(v)),
              ),
            );
          }

            return AlertDialog(
              title: const Text('Filters'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildDropdown<String>(
                        label: 'Vessel type',
                        options: types,
                        value: draft.vesselType,
                        labelOf: (t) => t,
                        onChanged: (v) => draft.vesselType = v,
                      ),
                      const SizedBox(height: 12),
                      buildDropdown<String>(
                        label: 'Navigation status',
                        options: statuses,
                        value: draft.navigationStatus,
                        labelOf: (t) => t,
                        onChanged: (v) => draft.navigationStatus = v,
                      ),
                      const SizedBox(height: 12),
                      buildDropdown<String>(
                        label: 'Country',
                        options: countries,
                        value: draft.country,
                        labelOf: (t) => t,
                        onChanged: (v) => draft.country = v,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minSogController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Min SOG (kn)',
                              ),
                              onChanged: (_) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: maxSogController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Max SOG (kn)',
                              ),
                              onChanged: (_) => setDialogState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Only vessels with a name'),
                        value: draft.onlyNamed,
                        onChanged: (v) => setDialogState(() => draft.onlyNamed = v),
                      ),
                    ],
                  ),
                ),
              ),
            actions: [
              TextButton(
                onPressed: () {
                  draft = MapFilters();
                  minSogController.clear();
                  maxSogController.clear();
                  setDialogState(() {});
                },
                child: const Text('Reset'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  draft.minSog = double.tryParse(minSogController.text);
                  draft.maxSog = double.tryParse(maxSogController.text);
                  Navigator.pop(ctx);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );

    setState(() => _filters = draft);
  }

  @override
  Widget build(BuildContext context) {
    final boatManager = context.watch<BoatManager>();
    final settings = context.watch<AppSettings>();

    final baseMap = settings.basemapId.isEmpty
        ? baseMapById(defaultBasemapIdFor(settings.appTheme))
        : baseMapById(settings.basemapId);
    final boats = boatManager.sendToMap ? _visibleBoats() : const <Boat>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _handleSearch,
            tooltip: 'Search vessels',
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _filters.active
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: _showFiltersDialog,
            tooltip: 'Filters',
          ),
          IconButton(
            icon: Icon(
              clusterEnabled ? Icons.scatter_plot : Icons.group_work,
            ),
            onPressed: toggleMarkers,
            tooltip: clusterEnabled ? "Disable clustering" : "Enable clustering",
          ),
          IconButton(
            icon: Icon(
              settings.showTrails ? Icons.route : Icons.route_outlined,
              color: settings.showTrails
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () => settings.setShowTrails(!settings.showTrails),
            tooltip: settings.showTrails
                ? 'Hide vessel trails'
                : 'Show vessel trails',
          ),
          IconButton(
            icon: Icon(
              settings.showVectors ? Icons.explore : Icons.explore_outlined,
              color: settings.showVectors
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () => settings.setShowVectors(!settings.showVectors),
            tooltip: settings.showVectors
                ? 'Hide speed vectors'
                : 'Show speed vectors',
          ),
          IconButton(
            icon: Icon(
              boatManager.sendToMap
                  ? Icons.directions_boat
                  : Icons.hide_source_rounded,
            ),
            onPressed: toggleCompute,
            tooltip: boatManager.sendToMap
                ? 'Statistics only (hide vessels)'
                : 'Show decoded vessels on map',
          ),
          PopupMenuButton<String>(
            tooltip: 'Basemap',
            icon: const Icon(Icons.layers_outlined),
            onSelected: (id) => settings.setBasemap(id),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: '',
                child: Row(
                  children: [
                    Icon(
                      settings.basemapId.isEmpty
                          ? Icons.check
                          : Icons.auto_awesome,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text('Auto (follow theme)'),
                  ],
                ),
              ),
              for (final b in kBaseMaps)
                PopupMenuItem<String>(
                  value: b.id,
                  child: Row(
                    children: [
                      Icon(
                        baseMap.id == b.id ? Icons.check : Icons.map_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(b.label),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(48.8566, 2.3522),
              initialZoom: 5.0,
              onPositionChanged: (camera, hasGesture) =>
                  _zoom = camera.zoom,
            ),
            children: [
              TileLayer(
                urlTemplate: baseMap.urlTemplate,
                subdomains: baseMap.subdomains,
                tileProvider: widget.tileProvider ??
                    CancellableNetworkTileProvider(),
                userAgentPackageName: 'com.kikimanjaro.kikais',
              ),
              BoatMapLayer(
                boats: boats,
                clusterEnabled: clusterEnabled,
                showTrails: settings.showTrails,
                showVectors: settings.showVectors,
                onBoatTap: (boat) => setState(() => _selected = boat),
                onClusterTap: (latLng) {
                  try {
                    _mapController.move(latLng, _zoom + 1);
                  } catch (_) {}
                },
                onBoatHover: (boat) {
                  final name = boat?.name?.trim().isNotEmpty == true
                      ? boat!.name!.trim()
                      : (boat != null ? 'MMSI ${boat.mmsi}' : null);
                  if (name != _hoverName) {
                    setState(() => _hoverName = name);
                  }
                },
              ),
              SimpleAttributionWidget(
                source: Text(
                  baseMap.attribution,
                  style: const TextStyle(fontSize: 10),
                ),
                alignment: Alignment.bottomLeft,
              ),
            ],
          ),
          if (_followingMmsi != null)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.my_location,
                          size: 16,
                          color: Colors.lightBlueAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Following $_followingMmsi',
                          style: const TextStyle(fontSize: 13),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => setState(
                            () => _followingMmsi = null,
                          ),
                          tooltip: 'Stop following',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_hoverName != null)
            Positioned(
              top: 8,
              right: 12,
              child: Material(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    _hoverName!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: _selected != null ? 0 : -360,
            top: 0,
            bottom: 0,
            width: 340,
            child: IgnorePointer(
              ignoring: _selected == null,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _selected == null
                    ? const SizedBox.shrink()
                    : BoatInfoBubble(
                        boat: _selected!,
                        onClose: () => setState(() => _selected = null),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
