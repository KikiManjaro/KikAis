import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'sim_fleet.dart';
import 'simulator_service.dart';
import 'themes.dart';
import 'widgets.dart';

/// Simulation tab: configures a personalizable fleet of vessels around a chosen
/// location. The fleet is emitted when the "Simulation" feed on the Reception
/// tab is enabled and the forwarder is running.
class SimulationPage extends StatefulWidget {
  final SimulatorService? Function() simGetter;
  final VoidCallback? onGoToReception;

  const SimulationPage({
    super.key,
    required this.simGetter,
    this.onGoToReception,
  });

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  late final SimulatorService sim;
  late AppSettings settings;
  late BoatManager boatManager;
  late Set<int> _draftTypes;

  final _latC = TextEditingController();
  final _lonC = TextEditingController();
  final _radiusC = TextEditingController();
  final _countC = TextEditingController();
  final _sogMinC = TextEditingController();
  final _sogMaxC = TextEditingController();
  final _intervalC = TextEditingController();
  final _seedC = TextEditingController();

  @override
  void initState() {
    super.initState();
    settings = context.read<AppSettings>();
    boatManager = context.read<BoatManager>();
    sim = widget.simGetter() ?? SimulatorService(config: settings.simConfig);
    _draftTypes = Set.of(sim.config.messageTypes);
    _syncControllers(sim.config);
  }

  @override
  void dispose() {
    for (final c in [
      _latC,
      _lonC,
      _radiusC,
      _countC,
      _sogMinC,
      _sogMaxC,
      _intervalC,
      _seedC,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(SimFleetConfig config) {
    _latC.text = config.centerLat.toStringAsFixed(5);
    _lonC.text = config.centerLon.toStringAsFixed(5);
    _radiusC.text = config.radiusKm.toStringAsFixed(1);
    _countC.text = '${config.boatCount}';
    _sogMinC.text = config.sogMin.toStringAsFixed(1);
    _sogMaxC.text = config.sogMax.toStringAsFixed(1);
    _intervalC.text = '${config.emitIntervalSec}';
    _seedC.text = '${config.seed}';
  }

  void _apply() {
    final config = SimFleetConfig(
      centerLat: double.tryParse(_latC.text) ?? sim.config.centerLat,
      centerLon: double.tryParse(_lonC.text) ?? sim.config.centerLon,
      radiusKm: double.tryParse(_radiusC.text) ?? sim.config.radiusKm,
      boatCount: int.tryParse(_countC.text) ?? sim.config.boatCount,
      sogMin: double.tryParse(_sogMinC.text) ?? sim.config.sogMin,
      sogMax: double.tryParse(_sogMaxC.text) ?? sim.config.sogMax,
      emitIntervalSec:
          int.tryParse(_intervalC.text) ?? sim.config.emitIntervalSec,
      seed: int.tryParse(_seedC.text) ?? sim.config.seed,
      messageTypes: Set.of(_draftTypes),
    );
    sim.setConfig(config);
    settings.simConfig = config;
    settings.save();
  }

  void _regenerate() {
    _seedC.text =
        '${DateTime.now().millisecondsSinceEpoch % 100000}';
    _apply();
  }

  IconData _kindIcon(int emitType) => switch (simBoatKind(emitType)) {
        SimBoatKind.vessel => Icons.directions_boat,
        SimBoatKind.aircraft => Icons.flight_takeoff,
        SimBoatKind.baseStation => Icons.radio,
        SimBoatKind.aton => Icons.anchor,
      };

  Color _kindColor(int emitType) => switch (simBoatKind(emitType)) {
        SimBoatKind.vessel => Colors.lightBlue,
        SimBoatKind.aircraft => Colors.deepPurpleAccent,
        SimBoatKind.baseStation => Colors.orange,
        SimBoatKind.aton => Colors.teal,
      };

  String _kindLabel(int emitType) => switch (simBoatKind(emitType)) {
        SimBoatKind.vessel => 'Vessel',
        SimBoatKind.aircraft => 'Aircraft',
        SimBoatKind.baseStation => 'Base station',
        SimBoatKind.aton => 'Aid to navigation',
      };

  Widget _field(TextEditingController controller, String label) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label, isDense: true),
      ),
    );
  }

  Widget _buildBoatRow(SimBoat b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Tooltip(
            message: _kindLabel(b.emitType),
            child: Icon(
              _kindIcon(b.emitType),
              size: 16,
              color: _kindColor(b.emitType),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 110,
            child: Text(
              '${b.mmsi}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              b.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              'T${b.emitType}',
              style: const TextStyle(fontSize: 11),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${b.sog.toStringAsFixed(1)} kn',
              style: const TextStyle(fontSize: 11),
            ),
          ),
          SizedBox(
            width: 55,
            child: Text(
              '${b.cog.toStringAsFixed(0)}°',
              style: const TextStyle(fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              '${b.lat.toStringAsFixed(4)}, '
              '${b.lon.toStringAsFixed(4)}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation')),
      body: ListenableBuilder(
        listenable: sim,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          sim.isRunning
                              ? Icons.play_circle
                              : Icons.pause_circle,
                          color: sim.isRunning
                              ? appColors.success
                              : appColors.warning,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'The fleet is emitted when the "Simulation" feed '
                            'is enabled on the Reception tab and the '
                            'forwarder is running.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        if (widget.onGoToReception != null)
                          OutlinedButton.icon(
                            onPressed: widget.onGoToReception,
                            icon: const Icon(Icons.rss_feed, size: 18),
                            label: const Text('Open Reception'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const SectionHeader(
                  icon: Icons.workspaces,
                  title: 'Fleet',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _field(_latC, 'Center latitude'),
                        _field(_lonC, 'Center longitude'),
                        _field(_radiusC, 'Radius (km)'),
                        _field(_countC, 'Vessels'),
                        _field(_sogMinC, 'Speed min (kn)'),
                        _field(_sogMaxC, 'Speed max (kn)'),
                        _field(_intervalC, 'Interval (s)'),
                        _field(_seedC, 'Seed'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.message_outlined,
                  title: 'Messages',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        for (final entry in kSimTypeLabels.entries)
                          SizedBox(
                            width: 210,
                            child: CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 12),
                              ),
                              value: _draftTypes.contains(entry.key),
                              onChanged: (v) => setState(() {
                                if (v == true) {
                                  _draftTypes.add(entry.key);
                                } else {
                                  _draftTypes.remove(entry.key);
                                }
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _apply,
                      icon: const Icon(Icons.check),
                      label: const Text('Apply fleet'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _regenerate,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Regenerate fleet'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.directions_boat,
                  title: 'Live fleet',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${sim.fleet.boats.length} boats · '
                          '${sim.emittedCount} frames emitted',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 320,
                          child: ListView.builder(
                            itemCount: sim.fleet.boats.length,
                            itemBuilder: (context, index) =>
                                _buildBoatRow(sim.fleet.boats[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
