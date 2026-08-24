import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'websdr_directory.dart';
import 'websdr_server.dart';

class WebSdrBrowserPage extends StatefulWidget {
  final WebSdrDirectory directory;
  const WebSdrBrowserPage({super.key, required this.directory});
  @override
  State<WebSdrBrowserPage> createState() => _WebSdrBrowserPageState();
}

class _WebSdrBrowserPageState extends State<WebSdrBrowserPage> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  List<WebSdrServer> _filtered = [];
  String? _selectedCountry;
  bool _onlineOnly = true;
  bool _availableOnly = true;

  @override
  void initState() { super.initState(); _loadServers(); }

  Future<void> _loadServers() async {
    await widget.directory.fetch(force: true);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filtered = widget.directory.filter(query: _searchController.text, countryCode: _selectedCountry, onlineOnly: _onlineOnly, availableOnly: _availableOnly);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSDR Browser'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadServers)]),
      body: Column(children: [
        _buildFilters(),
        Expanded(child: Row(children: [
          Expanded(flex: 3, child: _buildMap()),
          SizedBox(width: 320, child: _buildServerList()),
        ])),
      ]),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(flex: 2, child: TextField(controller: _searchController, decoration: const InputDecoration(hintText: 'Search servers...', prefixIcon: Icon(Icons.search), isDense: true), onChanged: (_) => _applyFilters())),
        const SizedBox(width: 8),
        SizedBox(width: 120, child: DropdownButton<String>(value: _selectedCountry, isDense: true, hint: const Text('Country'), items: [const DropdownMenuItem(value: null, child: Text('All')), ...widget.directory.countries.map((c) => DropdownMenuItem(value: c, child: Text(c)))], onChanged: (v) { setState(() => _selectedCountry = v); _applyFilters(); })),
        const SizedBox(width: 8),
        FilterChip(label: const Text('Online'), selected: _onlineOnly, onSelected: (v) { setState(() => _onlineOnly = v); _applyFilters(); }),
        const SizedBox(width: 4),
        FilterChip(label: const Text('Available'), selected: _availableOnly, onSelected: (v) { setState(() => _availableOnly = v); _applyFilters(); }),
        const SizedBox(width: 8),
        Text('${_filtered.length} servers', style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: const LatLng(48.8, 2.3), initialZoom: 5),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.kikimanjaro.kikais'),
        MarkerLayer(markers: _filtered.where((s) => s.lat != null && s.lon != null).map((s) => Marker(point: LatLng(s.lat!, s.lon!), width: 30, height: 30, child: GestureDetector(onTap: () => _showServerDetails(s), child: Icon(Icons.cell_tower, color: s.available ? Colors.green : Colors.red, size: 24)))).toList()),
      ],
    );
  }

  Widget _buildServerList() {
    if (widget.directory.isLoading) return const Center(child: CircularProgressIndicator());
    if (_filtered.isEmpty) return const Center(child: Text('No servers found'));
    return ListView.builder(itemCount: _filtered.length, itemBuilder: (context, index) {
      final server = _filtered[index];
      return ListTile(leading: Icon(Icons.cell_tower, color: server.available ? Colors.green : Colors.red), title: Text(server.name, style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text('${server.country ?? "Unknown"} • ${server.users}/${server.maxUsers}', style: const TextStyle(fontSize: 11)), onTap: () => _showServerDetails(server), dense: true);
    });
  }

  void _showServerDetails(WebSdrServer server) async {
    final result = await showModalBottomSheet<WebSdrServer>(context: context, builder: (context) => _ServerDetailsSheet(server: server, onConnect: (s) => Navigator.pop(context, s)));
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connecting to ${result.name} (${result.host}:${result.port})...'), duration: const Duration(seconds: 3)));
    }
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }
}

class _ServerDetailsSheet extends StatelessWidget {
  final WebSdrServer server;
  final Function(WebSdrServer) onConnect;
  const _ServerDetailsSheet({required this.server, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.cell_tower, color: server.available ? Colors.green : Colors.red, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(server.name, style: Theme.of(context).textTheme.titleMedium),
            Text('${server.host}:${server.port}', style: Theme.of(context).textTheme.bodySmall),
          ])),
        ]),
        const SizedBox(height: 16),
        _infoRow('Country', server.country ?? 'Unknown'),
        _infoRow('Users', '${server.users}/${server.maxUsers}'),
        _infoRow('Type', server.type.name),
        if (server.bands.isNotEmpty) _infoRow('Bands', server.bands.join(', ')),
        if (server.lat != null && server.lon != null) _infoRow('Position', '${server.lat!.toStringAsFixed(4)}, ${server.lon!.toStringAsFixed(4)}'),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          const SizedBox(width: 8),
          FilledButton.icon(onPressed: server.available ? () => onConnect(server) : null, icon: const Icon(Icons.play_arrow), label: const Text('Connect')),
        ]),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
    ]));
  }
}
