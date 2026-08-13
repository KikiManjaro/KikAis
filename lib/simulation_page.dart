import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'l10n/country_names.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';
import 'sim_fleet.dart';
import 'simulator_service.dart';
import 'themes.dart';
import 'widgets.dart';

/// Localized name of an ITU-R M.1371 ship type used by the simulated fleet.
String vesselTypeLabel(int type, AppLocalizations l10n) => switch (type) {
      70 => l10n.simVesselCargo,
      80 => l10n.simVesselTanker,
      30 => l10n.simVesselFishing,
      36 => l10n.simVesselSailing,
      60 => l10n.simVesselPassenger,
      52 => l10n.simVesselTug,
      40 => l10n.simVesselHsc,
      90 => l10n.simVesselOther,
      _ => '$type',
    };

/// Localized name of a simulated AIS message type.
String simTypeLabel(int type, AppLocalizations l10n) => switch (type) {
      1 => l10n.simType1,
      5 => l10n.simType5,
      9 => l10n.simType9,
      18 => l10n.simType18,
      19 => l10n.simType19,
      27 => l10n.simType27,
      4 => l10n.simType4,
      21 => l10n.simType21,
      8 => l10n.simType8,
      11 => l10n.simType11,
      12 => l10n.simType12,
      14 => l10n.simType14,
      22 => l10n.simType22,
      23 => l10n.simType23,
      24 => l10n.simType24,
      _ => 'T$type',
    };

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
  late bool _draftNmea4Tags;
  late String _draftNmeaTalker;
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
    _draftNmea4Tags = sim.config.nmea4Tags;
    _draftNmeaTalker = sim.config.nmeaTalker;
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
      nmeaTalker: _draftNmeaTalker,
      nmea4Tags: _draftNmea4Tags,
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
      appBar: AppBar(title: Text(context.l10n.simTitle)),
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
                        Expanded(
                          child: Text(
                            context.l10n.simInfoBanner,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        if (widget.onGoToReception != null)
                          OutlinedButton.icon(
                            onPressed: widget.onGoToReception,
                            icon: const Icon(Icons.rss_feed, size: 18),
                            label: Text(context.l10n.simOpenReception),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(
                  icon: Icons.workspaces,
                  title: context.l10n.simFleetSection,
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
                            _field(_radiusC, context.l10n.simRadiusKm),
                            _field(_countC, context.l10n.simVessels),
                            _field(_sogMinC, context.l10n.simSpeedMinKn),
                            _field(_sogMaxC, context.l10n.simSpeedMaxKn),
                            _field(_intervalC, context.l10n.simIntervalS),
                            _field(_seedC, context.l10n.simSeed),
                            _field(_anchoredC, context.l10n.simAnchoredPct),
                            _field(_namePrefixC, context.l10n.simNamePrefix),
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
                              label: context.l10n.simMmsiMid,
                              hint: context.l10n.simSearchMmid,
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
                              labelForOption: (m) => '${kSimMids[m] == null ? context.l10n.simCustom : localizedCountryName(kSimMids[m]!, context)} ($m)',
                              onSelected: (_) {},
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Text(
                          context.l10n.simVesselTypes,
                          style: const TextStyle(
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
                                    vesselTypeLabel(vt.$1, context.l10n),
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
                              context.l10n.simRealisticNames,
                              _draftRealisticNames,
                              (v) => setState(() => _draftRealisticNames = v),
                            ),
                            _switchTile(
                              context.l10n.simRealisticDimensions,
                              _draftRealisticDimensions,
                              (v) =>
                                  setState(() => _draftRealisticDimensions = v),
                            ),
                            _switchTile(
                              context.l10n.simRealisticMmsi,
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
                SectionHeader(
                  icon: Icons.map_outlined,
                  title: context.l10n.simZoneSection,
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
                          label: context.l10n.simLocationPreset,
                          hint: context.l10n.simSearchPort,
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
                        _field(_latC, context.l10n.simCenterLat),
                        _field(_lonC, context.l10n.simCenterLon),
                        _labelDropdown<SimZoneShape>(
                          context.l10n.simZoneShape,
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
                        _field(_transitC, context.l10n.simTransitPct),
                        _switchTile(
                          context.l10n.simRegeneratePeriodically,
                          _draftAutoRegenerate,
                          (v) => setState(() => _draftAutoRegenerate = v),
                        ),
                        _field(_regenEveryC, context.l10n.simRegenerateTicks),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    context.l10n.simPresetHint,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.timeline,
                  title: context.l10n.simMovementSection,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _switchTile(
                          context.l10n.simVarySpeed,
                          _draftVarySpeed,
                          (v) => setState(() => _draftVarySpeed = v),
                        ),
                        _field(_reportIntervalC, context.l10n.simReportIntervalTicks),
                        _field(_wanderC, context.l10n.simWander),
                        _switchTile(
                          context.l10n.simSpeedByType,
                          _draftSpeedByType,
                          (v) => setState(() => _draftSpeedByType = v),
                        ),
                        _field(_classBPctC, context.l10n.simClassBSharePct),
                        _switchTile(
                          context.l10n.simHighAccuracy,
                          _draftAccuratePosition,
                          (v) => setState(() => _draftAccuratePosition = v),
                        ),
                        _switchTile(
                          context.l10n.simRealisticRot,
                          _draftRealisticRot,
                          (v) => setState(() => _draftRealisticRot = v),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.text_snippet_outlined,
                  title: context.l10n.simContentSection,
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
                          context.l10n.simSafetyTexts,
                        ),
                        _multiField(
                          _destinationsC,
                          context.l10n.simDestinations,
                          lines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.cell_tower,
                  title: context.l10n.simStationsSection,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _field(_baseStationsC, context.l10n.simBaseStations),
                        _field(_atonC, context.l10n.simAtoN),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.error_outline,
                  title: context.l10n.simQualitySection,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        _switchTile(
                          context.l10n.simInjectErrors,
                          _draftInjectErrors,
                          (v) => setState(() => _draftInjectErrors = v),
                        ),
                        _field(_errorRateC, context.l10n.simErrorRatePct),
                        _labelDropdown<String>(
                          context.l10n.simTalkerId,
                          _draftNmeaTalker,
                          [
                            for (final t in kSimTalkers)
                              DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                          (v) => setState(() {
                            if (v != null) _draftNmeaTalker = v;
                          }),
                        ),
                        _switchTile(
                          context.l10n.simNmea4Tag,
                          _draftNmea4Tags,
                          (v) => setState(() => _draftNmea4Tags = v),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.message_outlined,
                  title: context.l10n.simMessagesSection,
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
                                simTypeLabel(entry.key, context.l10n),
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
                      label: Text(context.l10n.simApplyFleet),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _regenerate,
                      icon: const Icon(Icons.shuffle),
                      label: Text(context.l10n.simRegenerateFleet),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  icon: Icons.directions_boat,
                  title: context.l10n.simLiveFleet,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.simFleetSummary(
                            '${sim.fleet.boats.length}',
                            '${sim.emittedCount}',
                          ),
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
