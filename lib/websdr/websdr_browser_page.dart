import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../l10n_ext.dart';
import 'websdr_directory.dart';
import 'websdr_favorites.dart';
import 'websdr_history.dart';
import 'websdr_server.dart';

/// WebSDR browser tab: map + list of public servers. Adding a server does not
/// open a standalone connection — it creates/enables a regular reception feed
/// through the [WebSdrBrowserPage.addToFeeds] callback, so every source lives
/// in the Reception feed list and is started/stopped like any other feed.
class WebSdrBrowserPage extends StatefulWidget {
  final WebSdrDirectory directory;

  /// Whether the reception feed matching a server's feedKey exists & enabled.
  final bool Function(String feedKey) isFeedActive;
  final bool Function(WebSdrServer server) addToFeeds;
  final Future<void> Function(String feedKey) removeFromFeeds;
  final WebsdrFavorites? favorites;
  final WebsdrHistory? history;

  const WebSdrBrowserPage({
    super.key,
    required this.directory,
    required this.isFeedActive,
    required this.addToFeeds,
    required this.removeFromFeeds,
    this.favorites,
    this.history,
  });

  @override
  State<WebSdrBrowserPage> createState() => _WebSdrBrowserPageState();
}

class _WebSdrBrowserPageState extends State<WebSdrBrowserPage> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  List<WebSdrServer> _filtered = [];
  String? _selectedCountry;
  bool _availableOnly = true;
  bool _aisOnly = false;

  late final WebsdrFavorites _favorites;
  late final WebsdrHistory _history;

  @override
  void initState() {
    super.initState();
    _favorites = widget.favorites ?? WebsdrFavorites();
    _history = widget.history ?? WebsdrHistory();
    _loadServers();
    _loadFavorites();
    _loadHistory();
  }

  Future<void> _loadFavorites() async {
    await _favorites.load();
    if (mounted) setState(() {});
  }

  Future<void> _loadHistory() async {
    await _history.load();
    if (mounted) setState(() {});
  }

  Future<void> _loadServers() async {
    await widget.directory.fetch(force: true);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filtered = widget.directory.filter(
          query: _searchController.text,
          countryCode: _selectedCountry,
          availableOnly: _availableOnly,
          aisOnly: _aisOnly);
    });
  }

  Future<void> _toggleFavorite(WebSdrServer s) async {
    await _favorites.toggle(s);
    setState(() {});
  }

  void _addToFeeds(WebSdrServer server) {
    final added = widget.addToFeeds(server);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor:
          added ? Colors.green[700] : Colors.orange[700],
      content: Text(added
          ? '${server.name} added to reception feeds'
          : '${server.name} is already in reception feeds'),
    ));
  }

  Future<void> _removeFromFeeds(WebSdrServer server) async {
    await widget.removeFromFeeds(server.feedKey);
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text('${server.name} removed from reception feeds'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSDR Browser'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadServers),
        ],
      ),
      body: Column(children: [
        _buildFilters(),
        Expanded(
            child: Row(children: [
          Expanded(flex: 3, child: _buildMap()),
          SizedBox(width: 340, child: _buildServerList()),
        ])),
      ]),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                    hintText: 'Search servers...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true),
                onChanged: (_) => _applyFilters())),
        const SizedBox(width: 8),
        SizedBox(
            width: 120,
            child: DropdownButton<String>(
                value: _selectedCountry,
                isDense: true,
                hint: const Text('Country'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...widget.directory.countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                ],
                onChanged: (v) {
                  setState(() => _selectedCountry = v);
                  _applyFilters();
                })),
        const SizedBox(width: 8),
        FilterChip(
            label: const Text('Available'),
            selected: _availableOnly,
            onSelected: (v) {
              setState(() => _availableOnly = v);
              _applyFilters();
            }),
        const SizedBox(width: 4),
        FilterChip(
            label: Text(context.l10n.websdrFilterAis),
            selected: _aisOnly,
            onSelected: (v) {
              setState(() => _aisOnly = v);
              _applyFilters();
            }),
        const SizedBox(width: 8),
        Text('${_filtered.length} servers',
            style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: const LatLng(48.8, 2.3), initialZoom: 5),
      children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.kikimanjaro.kikais'),
        MarkerLayer(
            markers: _filtered
                .where((s) => s.lat != null && s.lon != null)
                .map((s) => Marker(
                    point: LatLng(s.lat!, s.lon!),
                    width: 32,
                    height: 32,
                    child: GestureDetector(
                        onTap: () => _showServerDetails(s),
                        child: Stack(alignment: Alignment.center, children: [
                          Icon(Icons.cell_tower,
                              color: widget.isFeedActive(s.feedKey)
                                  ? Colors.lightBlue
                                  : (s.available ? Colors.green : Colors.red),
                              size: 26),
                          if (_favorites.isFavorite(s.id))
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: const BoxDecoration(
                                    color: Colors.amber, shape: BoxShape.circle),
                                child: const Icon(Icons.star,
                                    size: 8, color: Colors.white),
                              ),
                            ),
                        ]))))
                .toList()),
      ],
    );
  }

  Widget _buildServerList() {
    if (widget.directory.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Partition favorites and others
    final favIds = _favorites.favorites.map((e) => e.id).toSet();
    final favoriteServers =
        _filtered.where((s) => favIds.contains(s.id)).toList();
    final otherServers =
        _filtered.where((s) => !favIds.contains(s.id)).toList();

    final hasFavorites = favoriteServers.isNotEmpty;
    final totalCount = _filtered.length;

    if (totalCount == 0) return const Center(child: Text('No servers found'));

    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: (hasFavorites ? favoriteServers.length + 1 : 0) +
              otherServers.length +
              (hasFavorites ? 1 : 0),
          itemBuilder: (context, index) {
            // Favorites section
            if (hasFavorites) {
              if (index == 0) {
                return Container(
                  color: Colors.amber.withValues(alpha: 0.12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('Favorites (${favoriteServers.length})',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                );
              }
              if (index <= favoriteServers.length) {
                final server = favoriteServers[index - 1];
                return _buildTile(server, isFavorite: true);
              }
              if (index == favoriteServers.length + 1) {
                return const Divider(height: 1);
              }
              final otherIdx = index - favoriteServers.length - 2;
              return _buildTile(otherServers[otherIdx], isFavorite: false);
            } else {
              return _buildTile(otherServers[index], isFavorite: false);
            }
          },
        ),
      ),
    ]);
  }

  Widget _buildTile(WebSdrServer server, {required bool isFavorite}) {
    final active = widget.isFeedActive(server.feedKey);
    return ListTile(
      leading: Icon(Icons.cell_tower,
          color: active
              ? Colors.lightBlue
              : (server.available ? Colors.green : Colors.red)),
      title: Text(server.name,
          style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.bold : FontWeight.normal),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
          '${server.country ?? "Unknown"} • ${server.users}/${server.maxUsers} • ${server.type.name}',
          style: const TextStyle(fontSize: 11)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          icon: Icon(isFavorite ? Icons.star : Icons.star_border,
              size: 18, color: isFavorite ? Colors.amber : Colors.grey),
          tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
          onPressed: () => _toggleFavorite(server),
          visualDensity: VisualDensity.compact,
        ),
        if (active)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: const Text('FEED',
                style: TextStyle(fontSize: 9, color: Colors.white)),
          ),
      ]),
      onTap: () => _showServerDetails(server),
      dense: true,
      selected: active,
      selectedTileColor: Colors.green.withValues(alpha: 0.08),
    );
  }

  void _showServerDetails(WebSdrServer server) async {
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _ServerDetailsSheet(
              server: server,
              favorites: _favorites,
              history: _history,
              isActive: widget.isFeedActive(server.feedKey),
              onToggleFavorite: () => _toggleFavorite(server),
              onAdd: () {
                Navigator.pop(context);
                _addToFeeds(server);
              },
              onRemove: () {
                Navigator.pop(context);
                _removeFromFeeds(server);
              },
            ));
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Bottom sheet showing one server's details with add/remove-feed actions.
class _ServerDetailsSheet extends StatelessWidget {
  final WebSdrServer server;
  final WebsdrFavorites favorites;
  final WebsdrHistory history;
  final bool isActive;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _ServerDetailsSheet({
    required this.server,
    required this.favorites,
    required this.history,
    required this.isActive,
    required this.onToggleFavorite,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final s = server;
    final isFavorite = favorites.isFavorite(s.id);
    final recent = history.forServer(s.id);

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Row(children: [
            Icon(
                switch (s.type) {
                  WebSdrType.kiwiSdr => Icons.radio,
                  _ => Icons.cloud,
                },
                size: 28,
                color: isActive ? Colors.lightBlue : null),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(s.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('${s.host}:${s.port}',
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.6))),
              ]),
            ),
            IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey),
              tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
              onPressed: onToggleFavorite,
            ),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _chip(context, Icons.public, s.country ?? 'Unknown'),
            _chip(context, Icons.settings_input_antenna,
                '${s.users}/${s.maxUsers} users'),
            if (s.coversAis)
              _chip(context, Icons.waves, 'AIS',
                  highlight: true),
            if (s.bands.isNotEmpty)
              _chip(context, Icons.graphic_eq, s.bands.join(', ')),
          ]),
          if (s.notes != null && s.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(s.notes!, style: const TextStyle(fontSize: 12)),
          ],
          const SizedBox(height: 16),
          // Feed state banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: (isActive ? Colors.green : Colors.grey)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Icon(isActive ? Icons.cloud_done : Icons.cloud_outlined,
                  size: 18,
                  color: isActive ? Colors.green : Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    isActive
                        ? 'In reception feeds — enable the feed and press Start to receive'
                        : 'Not in reception feeds',
                    style: const TextStyle(fontSize: 12)),
              ),
            ]),
          ),
          if (recent.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Recent connections',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 4),
            for (final e in recent.take(3))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                    '${e.startTime.day}/${e.startTime.month} — '
                    '${e.durationSeconds ?? 0}s',
                    style: const TextStyle(fontSize: 11)),
              ),
          ],
          const SizedBox(height: 16),
          Row(children: [
            if (isActive)
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                  label: const Text('Remove from feeds'),
                ),
              )
            else
              Expanded(
                child: FilledButton.icon(
                  onPressed: s.available ? onAdd : null,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Add to reception feeds'),
                ),
              ),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label,
      {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.lightBlue.withValues(alpha: 0.15)
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon,
            size: 13,
            color: highlight ? Colors.lightBlue : null),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ]),
    );
  }
}
