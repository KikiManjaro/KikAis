import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'websdr_connection.dart';
import 'websdr_directory.dart';
import 'websdr_favorites.dart';
import 'websdr_history.dart';
import 'websdr_server.dart';

class WebSdrBrowserPage extends StatefulWidget {
  final WebSdrDirectory directory;
  final WebsdrConnection? connection;
  final WebsdrFavorites? favorites;
  final WebsdrHistory? history;

  const WebSdrBrowserPage({
    super.key,
    required this.directory,
    this.connection,
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
  bool _onlineOnly = true;
  bool _availableOnly = true;

  late final WebsdrConnection _connection;
  late final WebsdrFavorites _favorites;
  late final WebsdrHistory _history;
  bool _favoritesLoaded = false;
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _connection = widget.connection ?? WebsdrConnection();
    _favorites = widget.favorites ?? WebsdrFavorites();
    _history = widget.history ?? WebsdrHistory();
    _loadServers();
    _loadFavorites();
    _loadHistory();
  }

  Future<void> _loadFavorites() async {
    await _favorites.load();
    if (mounted) setState(() => _favoritesLoaded = true);
  }

  Future<void> _loadHistory() async {
    await _history.load();
    if (mounted) setState(() => _historyLoaded = true);
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
          onlineOnly: _onlineOnly,
          availableOnly: _availableOnly);
    });
  }

  Future<void> _toggleFavorite(WebSdrServer s) async {
    await _favorites.toggle(s);
    setState(() {});
  }

  Future<void> _connectTo(WebSdrServer server) async {
    // Record history start
    await _history.startConnection(server);
    setState(() {});

    _connection.onStatus = (msg) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      setState(() {});
    };

    await _connection.connect(server);
    setState(() {});

    if (_connection.state == WebSdrConnectionState.connected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${server.name} — AIS-catcher running'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } else if (_connection.state == WebSdrConnectionState.error) {
      await _history.endConnection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_connection.error ?? 'Connection failed'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
      setState(() {});
    }
  }

  Future<void> _disconnect() async {
    await _connection.disconnect();
    await _history.endConnection();
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected from WebSDR')),
      );
    }
  }

  Color _stateColor(WebSdrConnectionState s) {
    return switch (s) {
      WebSdrConnectionState.connected => Colors.green,
      WebSdrConnectionState.connecting => Colors.orange,
      WebSdrConnectionState.error => Colors.red,
      WebSdrConnectionState.disconnected => Colors.grey,
    };
  }

  String _stateLabel(WebSdrConnectionState s) {
    return switch (s) {
      WebSdrConnectionState.connected => 'Connected',
      WebSdrConnectionState.connecting => 'Connecting…',
      WebSdrConnectionState.error => 'Error',
      WebSdrConnectionState.disconnected => 'Disconnected',
    };
  }

  IconData _stateIcon(WebSdrConnectionState s) {
    return switch (s) {
      WebSdrConnectionState.connected => Icons.cloud_done,
      WebSdrConnectionState.connecting => Icons.cloud_sync,
      WebSdrConnectionState.error => Icons.cloud_off,
      WebSdrConnectionState.disconnected => Icons.cloud_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSDR Browser'),
        actions: [
          // Connection state indicator
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _stateColor(_connection.state).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _stateColor(_connection.state)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(_stateIcon(_connection.state),
                  size: 14, color: _stateColor(_connection.state)),
              const SizedBox(width: 4),
              Text(_stateLabel(_connection.state),
                  style: TextStyle(
                      fontSize: 11, color: _stateColor(_connection.state))),
              if (_connection.server != null) ...[
                const SizedBox(width: 4),
                Text('• ${_connection.server!.name}',
                    style: const TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis),
              ],
            ]),
          ),
          if (_connection.state == WebSdrConnectionState.connected ||
              _connection.state == WebSdrConnectionState.connecting)
            IconButton(
              tooltip: 'Disconnect',
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: _disconnect,
            ),
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
            label: const Text('Online'),
            selected: _onlineOnly,
            onSelected: (v) {
              setState(() => _onlineOnly = v);
              _applyFilters();
            }),
        const SizedBox(width: 4),
        FilterChip(
            label: const Text('Available'),
            selected: _availableOnly,
            onSelected: (v) {
              setState(() => _availableOnly = v);
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
                              color: s.available ? Colors.green : Colors.red,
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
      // Small connection banner when connected
      if (_connection.state == WebSdrConnectionState.connected &&
          _connection.server != null)
        Container(
          width: double.infinity,
          color: Colors.green.withValues(alpha: 0.12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(children: [
            const Icon(Icons.graphic_eq, size: 14, color: Colors.green),
            const SizedBox(width: 6),
            Expanded(
                child: Text('Receiving AIS from ${_connection.server!.name}',
                    style: const TextStyle(fontSize: 11))),
            TextButton(
                onPressed: _disconnect,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 30)),
                child: const Text('Stop', style: TextStyle(fontSize: 11))),
          ]),
        ),
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
    final connected = _connection.server?.id == server.id &&
        _connection.state == WebSdrConnectionState.connected;
    return ListTile(
      leading: Icon(Icons.cell_tower,
          color: connected
              ? Colors.green
              : (server.available ? Colors.green : Colors.red)),
      title: Text(server.name,
          style: TextStyle(
              fontSize: 13,
              fontWeight: connected ? FontWeight.bold : FontWeight.normal),
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
        if (connected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: const Text('LIVE',
                style: TextStyle(fontSize: 9, color: Colors.white)),
          ),
      ]),
      onTap: () => _showServerDetails(server),
      dense: true,
      selected: connected,
      selectedTileColor: Colors.green.withValues(alpha: 0.08),
    );
  }

  void _showServerDetails(WebSdrServer server) async {
    final result = await showModalBottomSheet<WebSdrServer>(
        context: context,
        isScrollControlled: true,
        builder: (context) => _ServerDetailsSheet(
              server: server,
              connection: _connection,
              favorites: _favorites,
              history: _history,
              onToggleFavorite: () {
                _toggleFavorite(server);
              },
              onConnect: (s) => Navigator.pop(context, s),
              onDisconnect: () {
                Navigator.pop(context);
                _disconnect();
              },
            ));
    if (result != null && mounted) {
      await _connectTo(result);
    } else {
      // Refresh favorites/history state after sheet closed (may have toggled)
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Do not dispose injected connection if it was provided from outside
    if (widget.connection == null) {
      _connection.dispose();
    }
    super.dispose();
  }
}

class _ServerDetailsSheet extends StatefulWidget {
  final WebSdrServer server;
  final WebsdrConnection connection;
  final WebsdrFavorites favorites;
  final WebsdrHistory history;
  final VoidCallback onToggleFavorite;
  final Function(WebSdrServer) onConnect;
  final VoidCallback onDisconnect;
  const _ServerDetailsSheet({
    required this.server,
    required this.connection,
    required this.favorites,
    required this.history,
    required this.onToggleFavorite,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  State<_ServerDetailsSheet> createState() => _ServerDetailsSheetState();
}

class _ServerDetailsSheetState extends State<_ServerDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    final s = widget.server;
    final isFav = widget.favorites.isFavorite(s.id);
    final isConnected = widget.connection.server?.id == s.id &&
        widget.connection.state == WebSdrConnectionState.connected;
    final isConnecting = widget.connection.server?.id == s.id &&
        widget.connection.state == WebSdrConnectionState.connecting;
    final serverHistory = widget.history.forServer(s.id).take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.cell_tower,
                    color: s.available ? Colors.green : Colors.red, size: 32),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(s.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('${s.host}:${s.port}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ])),
                IconButton(
                  icon: Icon(isFav ? Icons.star : Icons.star_border,
                      color: isFav ? Colors.amber : Colors.grey),
                  tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                  onPressed: () {
                    widget.onToggleFavorite();
                    setState(() {});
                  },
                ),
              ]),
              const SizedBox(height: 8),
              // Connection state badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _stateBg(widget.connection.state, isConnected),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_stateIconFor(widget.connection.state, isConnected),
                      size: 14,
                      color: _stateColorFor(
                          widget.connection.state, isConnected)),
                  const SizedBox(width: 4),
                  Text(
                    isConnected
                        ? 'Connected — receiving AIS'
                        : isConnecting
                            ? 'Connecting…'
                            : widget.connection.state ==
                                    WebSdrConnectionState.error
                                ? 'Error: ${widget.connection.error ?? "unknown"}'
                                : 'Disconnected',
                    style: TextStyle(
                        fontSize: 11,
                        color: _stateColorFor(
                            widget.connection.state, isConnected)),
                  ),
                ]),
              ),
              const SizedBox(height: 12),
              _infoRow('Country', s.country ?? 'Unknown'),
              _infoRow('Users', '${s.users}/${s.maxUsers}'),
              _infoRow('Type', s.type.name),
              if (s.bands.isNotEmpty) _infoRow('Bands', s.bands.join(', ')),
              if (s.lat != null && s.lon != null)
                _infoRow('Position',
                    '${s.lat!.toStringAsFixed(4)}, ${s.lon!.toStringAsFixed(4)}'),
              if (s.url != null) _infoRow('URL', s.url!),
              if (s.notes != null) _infoRow('Notes', s.notes!),
              const SizedBox(height: 12),
              // History section
              if (serverHistory.isNotEmpty) ...[
                const Divider(),
                Row(children: [
                  const Icon(Icons.history, size: 14),
                  const SizedBox(width: 4),
                  Text('Recent connections',
                      style: Theme.of(context).textTheme.titleSmall),
                ]),
                const SizedBox(height: 4),
                ...serverHistory.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(children: [
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 6),
                        Text(
                          '${e.startTime.toLocal().toString().substring(0, 19)} • ${e.durationLabel}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ]),
                    )),
                const SizedBox(height: 4),
                if (widget.history.entries.isNotEmpty)
                  Text('${widget.history.entries.length} total connections',
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
              ],
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
                const SizedBox(width: 8),
                if (isConnected)
                  FilledButton.icon(
                    onPressed: widget.onDisconnect,
                    icon: const Icon(Icons.stop),
                    label: const Text('Disconnect'),
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.red),
                  )
                else
                  FilledButton.icon(
                    onPressed: s.available && !isConnecting
                        ? () => widget.onConnect(s)
                        : null,
                    icon: isConnecting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow),
                    label: Text(isConnecting ? 'Connecting…' : 'Connect'),
                  ),
              ]),
            ]),
      ),
    );
  }

  Color _stateBg(WebSdrConnectionState state, bool isConnected) {
    if (isConnected) return Colors.green.withValues(alpha: 0.15);
    return switch (state) {
      WebSdrConnectionState.error => Colors.red.withValues(alpha: 0.12),
      WebSdrConnectionState.connecting => Colors.orange.withValues(alpha: 0.12),
      _ => Colors.grey.withValues(alpha: 0.08),
    };
  }

  Color _stateColorFor(WebSdrConnectionState state, bool isConnected) {
    if (isConnected) return Colors.green;
    return switch (state) {
      WebSdrConnectionState.error => Colors.red,
      WebSdrConnectionState.connecting => Colors.orange,
      _ => Colors.grey,
    };
  }

  IconData _stateIconFor(WebSdrConnectionState state, bool isConnected) {
    if (isConnected) return Icons.cloud_done;
    return switch (state) {
      WebSdrConnectionState.error => Icons.cloud_off,
      WebSdrConnectionState.connecting => Icons.cloud_sync,
      _ => Icons.cloud_outlined,
    };
  }

  Widget _infoRow(String label, String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ]));
  }
}
