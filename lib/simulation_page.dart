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
  final _anchoredC = TextEditingController();
  final _reportIntervalC = TextEditingController();
  final _baseStationsC = TextEditingController();
  final _atonC = TextEditingController();
  final _errorRateC = TextEditingController();
  final _namePrefixC = TextEditingController();
  final _mmsiMidC = TextEditingController();
  final _locationC = TextEditingController();
  final _wanderC = TextEditingController();
  final _transitC = TextEditingController();
  final _classBPctC = TextEditingController();
  final _regenEveryC = TextEditingController();
  final _safetyTextsC = TextEditingController();
  final _destinationsC = TextEditingController();
  final _mmsiMidFocus = FocusNode();
  final _locationFocus = FocusNode();

  late Set<int> _draftVesselTypes;
  late bool _draftRealisticNames;
  late bool _draftRealisticDimensions;
  late bool _draftVarySpeed;
  late bool _draftInjectErrors;
  late bool _draftRealisticMmsi;
  late bool _draftSpeedByType;
  late bool _draftAutoRegenerate;
  late bool _draftAccuratePosition;
  late bool _draftRealisticRot;
  late SimZoneShape _draftZoneShape;

  @override
  void initState() {
    super.initState();
    settings = context.read<AppSettings>();
    boatManager = context.read<BoatManager>();
    sim = widget.simGetter() ?? SimulatorService(config: settings.simConfig);
    _draftTypes = Set.of(sim.config.messageTypes);
    _draftVesselTypes = Set.of(sim.config.vesselTypes);
    _draftRealisticNames = sim.config.realisticNames;
    _draftRealisticDimensions = sim.config.realisticDimensions;
    _draftVarySpeed = sim.config.varySpeed;
    _draftInjectErrors = sim.config.injectErrors;
    _draftRealisticMmsi = sim.config.realisticMmsi;
    _draftSpeedByType = sim.config.speedByType;
    _draftAutoRegenerate = sim.config.autoRegenerate;
    _draftAccuratePosition = sim.config.accuratePosition;
    _draftRealisticRot = sim.config.realisticRot;
    _draftZoneShape = sim.config.zoneShape;
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
      _anchoredC,
      _reportIntervalC,
      _baseStationsC,
      _atonC,
      _errorRateC,
      _namePrefixC,
      _mmsiMidC,
      _locationC,
      _wanderC,
      _transitC,
      _classBPctC,
      _regenEveryC,
      _safetyTextsC,
      _destinationsC,
    ]) {
      c.dispose();
    }
    _mmsiMidFocus.dispose();
    _locationFocus.dispose();
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
    _anchoredC.text = '${config.anchoredPercent}';
    _reportIntervalC.text = '${config.reportIntervalMax}';
    _baseStationsC.text = '${config.baseStationCount}';
    _atonC.text = '${config.atonCount}';
    _errorRateC.text = (config.errorRate * 100).toStringAsFixed(0);
    _namePrefixC.text = config.namePrefix;
    _mmsiMidC.text = '${config.mmsiMid}';
    _locationC.text =
        _presetNameFor(config.centerLat, config.centerLon) ?? '';
    _wanderC.text = config.wanderStrength.toStringAsFixed(1);
    _transitC.text = '${config.transitPercent}';
    _classBPctC.text = '${config.classBPercent}';
    _regenEveryC.text = '${config.regenEveryTicks}';
    _safetyTextsC.text = config.safetyTexts.join('\n');
    _destinationsC.text = config.destinations.join('\n');
  }

  List<String> _parseLines(String text) => text
      .split(RegExp(r'[\n,]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  /// The preset whose coordinates exactly match [lat]/[lon], if any.
  String? _presetNameFor(double lat, double lon) {
    for (final e in kSimLocationPresets.entries) {
      final (pl, pn) = e.value;
      if ((pl - lat).abs() < 0.0001 && (pn - lon).abs() < 0.0001) {
        return e.key;
      }
    }
    return null;
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
      vesselTypes: Set.of(_draftVesselTypes),
      realisticNames: _draftRealisticNames,
      realisticDimensions: _draftRealisticDimensions,
      anchoredPercent: int.tryParse(_anchoredC.text) ?? sim.config.anchoredPercent,
      varySpeed: _draftVarySpeed,
      reportIntervalMax:
          int.tryParse(_reportIntervalC.text) ?? sim.config.reportIntervalMax,
      baseStationCount:
          int.tryParse(_baseStationsC.text) ?? sim.config.baseStationCount,
      atonCount: int.tryParse(_atonC.text) ?? sim.config.atonCount,
      injectErrors: _draftInjectErrors,
      errorRate:
          (int.tryParse(_errorRateC.text) ?? 0) / 100,
      mmsiMid: int.tryParse(_mmsiMidC.text) ?? sim.config.mmsiMid,
      realisticMmsi: _draftRealisticMmsi,
      namePrefix: _namePrefixC.text,
      safetyTexts: _parseLines(_safetyTextsC.text),
      destinations: _parseLines(_destinationsC.text),
      zoneShape: _draftZoneShape,
      transitPercent: int.tryParse(_transitC.text) ?? sim.config.transitPercent,
      autoRegenerate: _draftAutoRegenerate,
      regenEveryTicks:
          int.tryParse(_regenEveryC.text) ?? sim.config.regenEveryTicks,
      wanderStrength:
          double.tryParse(_wanderC.text) ?? sim.config.wanderStrength,
      speedByType: _draftSpeedByType,
      classBPercent: int.tryParse(_classBPctC.text) ?? sim.config.classBPercent,
      accuratePosition: _draftAccuratePosition,
      realisticRot: _draftRealisticRot,
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
        SimBoatKind.safety => Icons.warning_amber,
        SimBoatKind.weather => Icons.cloud,
      };

  Color _kindColor(int emitType) => switch (simBoatKind(emitType)) {
        SimBoatKind.vessel => Colors.lightBlue,
        SimBoatKind.aircraft => Colors.deepPurpleAccent,
        SimBoatKind.baseStation => Colors.orange,
        SimBoatKind.aton => Colors.teal,
        SimBoatKind.safety => Colors.redAccent,
        SimBoatKind.weather => Colors.cyan,
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

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: 280,
      child: SwitchListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(title, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _labelDropdown<T>(
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T?> onChanged, {
    Widget? hint,
  }) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          DropdownButton<T>(
            value: value,
            isExpanded: true,
            items: items,
            hint: hint,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _multiField(
    TextEditingController controller,
    String label, {
    int lines = 4,
  }) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
        maxLines: lines,
        minLines: lines,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(labelText: label, isDense: true),
      ),
    );
  }

  /// A text field that filters a list of options as the user types. Selecting
  /// an option fills the field via [displayForOption].
  Widget _searchCombo<T extends Object>({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required Iterable<T> Function(TextEditingValue) optionsBuilder,
    required String Function(T) displayForOption,
    required String Function(T) labelForOption,
    required ValueChanged<T> onSelected,
    double width = 260,
  }) {
    return SizedBox(
      width: width,
      child: RawAutocomplete<T>(
        textEditingController: controller,
        focusNode: focusNode,
        displayStringForOption: displayForOption,
        optionsBuilder: optionsBuilder,
        onSelected: onSelected,
        fieldViewBuilder: (context, c, f, onSubmit) => TextField(
          controller: c,
          focusNode: f,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            isDense: true,
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 240,
                  maxWidth: 300,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    for (final option in options)
                      ListTile(
                        dense: true,
                        title: Text(
                          labelForOption(option),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => onSelected(option),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoatRow(SimBoat b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            _kindIcon(b.emitType),
            size: 16,
            color: _kindColor(b.emitType),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _field(_radiusC, 'Radius (km)'),
                            _field(_countC, 'Vessels'),
                            _field(_sogMinC, 'Speed min (kn)'),
                            _field(_sogMaxC, 'Speed max (kn)'),
                            _field(_intervalC, 'Interval (s)'),
                            _field(_seedC, 'Seed'),
                            _field(_anchoredC, 'Anchored (%)'),
                            _field(_namePrefixC, 'Name prefix'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _searchCombo<int>(
                              controller: _mmsiMidC,
                              focusNode: _mmsiMidFocus,
                              label: 'MMSI country / MID',
                              hint: 'Search a country or type a 3-digit MID',
                              optionsBuilder: (value) {
                                final q = value.text.trim().toLowerCase();
                                final matches = q.isEmpty
                                    ? kSimMids.keys.toList()
                                    : kSimMids.keys
                                        .where((m) =>
                                            '${kSimMids[m]}'
                                                .toLowerCase()
                                                .contains(q) ||
                                            '$m'.contains(q))
                                        .toList();
                                final custom = int.tryParse(value.text.trim());
                                if (custom != null &&
                                    !kSimMids.containsKey(custom)) {
                                  return [...matches, custom];
                                }
                                return matches;
                              },
                              displayForOption: (m) => '$m',
                              labelForOption: (m) =>
                                  '${kSimMids[m] ?? 'Custom'} ($m)',
                              onSelected: (_) {},
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        const Text(
                          'Vessel types',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            for (final vt in kSimVesselTypes)
                              SizedBox(
                                width: 130,
                                child: CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    vt.$2,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  value:
                                      _draftVesselTypes.contains(vt.$1),
                                  onChanged: (v) => setState(() {
                                    if (v == true) {
                                      _draftVesselTypes.add(vt.$1);
                                    } else {
                                      _draftVesselTypes.remove(vt.$1);
                                    }
                                  }),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            _switchTile(
                              'Realistic names',
                              _draftRealisticNames,
                              (v) => setState(() => _draftRealisticNames = v),
                            ),
                            _switchTile(
                              'Realistic dimensions',
                              _draftRealisticDimensions,
                              (v) =>
                                  setState(() => _draftRealisticDimensions = v),
                            ),
                            _switchTile(
                              'Realistic ITU MMSI',
                              _draftRealisticMmsi,
                              (v) => setState(() => _draftRealisticMmsi = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.map_outlined,
                  title: 'Zone & traffic',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _searchCombo<String>(
                          controller: _locationC,
                          focusNode: _locationFocus,
                          label: 'Location preset',
                          hint: 'Search a port…',
                          optionsBuilder: (value) {
                            final q = value.text.trim().toLowerCase();
                            final names = kSimLocationPresets.keys.toList();
                            if (q.isEmpty) return names;
                            return names
                                .where((n) => n.toLowerCase().contains(q))
                                .toList();
                          },
                          displayForOption: (n) => n,
                          labelForOption: (n) {
                            final (lat, lon) = kSimLocationPresets[n]!;
                            return '$n — ${lat.toStringAsFixed(2)}, '
                                '${lon.toStringAsFixed(2)}';
                          },
                          onSelected: (name) {
                            final (lat, lon) = kSimLocationPresets[name]!;
                            setState(() {
                              _latC.text = lat.toStringAsFixed(5);
                              _lonC.text = lon.toStringAsFixed(5);
                            });
                          },
                        ),
                        _field(_latC, 'Center latitude'),
                        _field(_lonC, 'Center longitude'),
                        _labelDropdown<SimZoneShape>(
                          'Zone shape',
                          _draftZoneShape,
                          [
                            for (final s in SimZoneShape.values)
                              DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                          (v) => setState(() {
                            if (v != null) _draftZoneShape = v;
                          }),
                        ),
                        _field(_transitC, 'Transit (%)'),
                        _switchTile(
                          'Regenerate periodically',
                          _draftAutoRegenerate,
                          (v) => setState(() => _draftAutoRegenerate = v),
                        ),
                        _field(_regenEveryC, 'Regenerate (ticks)'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Pick a preset to fill the coordinates, or type '
                    'Center latitude / longitude directly.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.timeline,
                  title: 'Movement & emission',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _switchTile(
                          'Vary speed over time',
                          _draftVarySpeed,
                          (v) => setState(() => _draftVarySpeed = v),
                        ),
                        _field(_reportIntervalC, 'Report interval (ticks)'),
                        _field(_wanderC, 'Wander (0-3)'),
                        _switchTile(
                          'Speed by vessel type',
                          _draftSpeedByType,
                          (v) => setState(() => _draftSpeedByType = v),
                        ),
                        _field(_classBPctC, 'Class B share (%)'),
                        _switchTile(
                          'High accuracy',
                          _draftAccuratePosition,
                          (v) => setState(() => _draftAccuratePosition = v),
                        ),
                        _switchTile(
                          'Realistic rate of turn',
                          _draftRealisticRot,
                          (v) => setState(() => _draftRealisticRot = v),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.text_snippet_outlined,
                  title: 'Content',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _multiField(
                          _safetyTextsC,
                          'Safety texts (one per line)',
                        ),
                        _multiField(
                          _destinationsC,
                          'Destinations (one per line)',
                          lines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.cell_tower,
                  title: 'Stations',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _field(_baseStationsC, 'Base stations'),
                        _field(_atonC, 'AtoN'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(
                  icon: Icons.error_outline,
                  title: 'Transmission quality',
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _switchTile(
                          'Inject errors',
                          _draftInjectErrors,
                          (v) => setState(() => _draftInjectErrors = v),
                        ),
                        _field(_errorRateC, 'Error rate (%)'),
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
