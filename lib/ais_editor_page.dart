import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ais/src/nmea/nmea_format.dart'
    show buildTagBlock, msSinceUtcMidnight, wrapNmea4;
import 'ais_editor_specs.dart';
import 'asm_registry.dart';
import 'boatmanager.dart';
import 'l10n_ext.dart';
import 'sim_fleet.dart' show kSimTalkers;
import 'themes.dart';
import 'widgets.dart';

class AisEditorPage extends StatefulWidget {
  final Future<void> Function(String nmea)? onSendToTarget;
  final ValueListenable<bool> running;

  const AisEditorPage({super.key, this.onSendToTarget, required this.running});

  @override
  State<AisEditorPage> createState() => _AisEditorPageState();
}

class _AisEditorPageState extends State<AisEditorPage> {
  int _type = 1;
  final Map<String, TextEditingController> _controllers = {};
  String _talker = 'AI';
  bool _nmea4Tags = false;
  final _tagSourceC = TextEditingController();

  String? _sentence;
  String? _error;
  AsmFormat? _asm;
  AsmFormat? _lockedPreset;
  EditorDataSource _dataSource = EditorDataSource.asm;

  bool get _isBinaryType =>
      _type == 6 || _type == 8 || _type == 25 || _type == 26;

  @override
  void initState() {
    super.initState();
    _recreateControllers();
    _rebuild();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _tagSourceC.dispose();
    super.dispose();
  }

  void _recreateControllers() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    _lockedPreset = null;
    _dataSource = EditorDataSource.asm;
    for (final spec in fieldsForType(_type)) {
      _controllers[spec.key] = TextEditingController(text: spec.defaultText);
    }
    _syncAsm();
  }

  Map<String, dynamic> _specValues() {
    final map = <String, dynamic>{};
    for (final spec in fieldsForType(_type)) {
      final c = _controllers[spec.key];
      if (c != null) {
        map[spec.key] = parseField(spec, c.text);
      }
    }
    return map;
  }

  Map<String, dynamic> _values() {
    final map = _specValues();
    final asm = _asm;
    if (asm != null) {
      for (final spec in asmFieldsFor(asm)) {
        final c = _controllers[spec.key];
        if (c != null) {
          map[spec.key] = parseField(spec, c.text);
        }
      }
    }
    return map;
  }

  /// Recomputes the active ASM and keeps a matching set of sub-field
  /// controllers. In "Custom" mode (no preset locked) no ASM is active, so the
  /// structured fields stay hidden and the raw Data bytes field is used.
  void _syncAsm() {
    final asm = _lockedPreset;
    if (identical(asm, _asm)) return;
    if (_asm != null) {
      for (final spec in asmFieldsFor(_asm!)) {
        _controllers.remove(spec.key)?.dispose();
      }
    }
    _asm = asm;
    if (asm != null) {
      for (final spec in asmFieldsFor(asm)) {
        _controllers[spec.key] =
            TextEditingController(text: spec.defaultText);
      }
    }
  }

  /// Writes the DAC/FID (or App DAC/FID) of [asm] into their controllers.
  void _setAsmControllers(AsmFormat asm) {
    final dacKey = _type == 25 || _type == 26 ? 'appDac' : 'dac';
    final fidKey = _type == 25 || _type == 26 ? 'appFid' : 'fid';
    _controllers[dacKey]?.text = '${asm.dac}';
    _controllers[fidKey]?.text = '${asm.fid}';
  }

  /// Locks a catalog ASM as the current preset.
  void _selectAsm(AsmFormat asm) {
    _setAsmControllers(asm);
    setState(() {
      _lockedPreset = asm;
      _dataSource = EditorDataSource.asm;
    });
    _rebuild();
  }

  /// Stable identifier used as the picker value.
  static String _asmKey(AsmFormat asm) => asmKey(asm);

  static String _asmShortKey(AsmFormat asm) => asmShortKey(asm);

  String _stateLabel(AsmState state) => switch (state) {
        AsmState.inForce => context.l10n.asmStateInForce,
        AsmState.deprecated => context.l10n.asmStateDeprecated,
        AsmState.replaced => context.l10n.asmStateReplaced,
        AsmState.discontinued => context.l10n.asmStateDiscontinued,
        AsmState.draft => context.l10n.asmStateDraft,
        AsmState.proposal => context.l10n.asmStateProposal,
        AsmState.testing => context.l10n.asmStateTesting,
      };

  /// Small colored badge for the ASM lifecycle state.
  Widget _stateBadge(AsmFormat asm) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final color = asm.isDeprecated
        ? appColors.danger
        : (asm.state == AsmState.draft ||
                asm.state == AsmState.proposal ||
                asm.state == AsmState.testing)
            ? appColors.warning
            : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _stateLabel(asm.state),
        style: TextStyle(fontSize: 10, color: color),
      ),
    );
  }

  /// Whether the generic field [spec] should be rendered, given the ASM preset
  /// lock and the active data source.
  bool _showSpecField(FieldSpec spec) {
    if (spec.key == 'data' &&
        _asm != null &&
        _asm!.hasLayout &&
        _dataSource == EditorDataSource.asm) {
      return false;
    }
    if (_lockedPreset != null &&
        (spec.key == 'dac' ||
            spec.key == 'fid' ||
            spec.key == 'appDac' ||
            spec.key == 'appFid')) {
      return false;
    }
    return true;
  }

  void _rebuild() {
    _syncAsm();
    try {
      final base = encodeMessage(
        _type,
        _values(),
        dataSource: _dataSource,
      );
      final tag = _nmea4Tags
          ? buildTagBlock(
              sourceId: _tagSourceC.text.trim().isEmpty
                  ? 'KIKAIS'
                  : _tagSourceC.text.trim(),
              timeMs: msSinceUtcMidnight(DateTime.now()),
            )
          : null;
      setState(() {
        _sentence = wrapNmea4(base, talker: _talker, tagBlock: tag);
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '$e');
    }
  }

  Future<void> _inject() async {
    final sentence = _sentence;
    if (sentence == null) return;
    await context.read<BoatManager>().processMessage(sentence, feed: 'KikAis');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.editorInjected),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _sendToTarget() async {
    final sentence = _sentence;
    final onSend = widget.onSendToTarget;
    if (sentence == null || onSend == null) return;
    await onSend(sentence);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.editorSentToTarget),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final specs = fieldsForType(_type);
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editorTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              icon: Icons.edit_note,
              title: context.l10n.editorCompose,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _type,
                      mouseCursor: WidgetStateMouseCursor.clickable,
                      decoration: InputDecoration(
                        labelText: context.l10n.editorMessageType,
                        isDense: true,
                      ),
                      items: kEditorTypeLabels.keys
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                editorMessageTypeLabel(t, context.l10n),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (t) {
                        if (t == null) return;
                        setState(() => _type = t);
                        _recreateControllers();
                        _rebuild();
                      },
                    ),
                    if (_isBinaryType) ...[
                      const SizedBox(height: 8),
                      SearchAnchor(
                        key: ValueKey('asm-picker-$_type'),
                        builder: (context, controller) {
                          final locked = _lockedPreset;
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => controller.openView(),
                            child: InputDecorator(
                              isEmpty: false,
                              decoration: InputDecoration(
                                labelText: context.l10n.editorAsmPreset,
                                isDense: true,
                                suffixIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                ),
                              ),
                              child: locked == null
                                  ? Text(context.l10n.editorAsmPresetManual)
                                  : Text(
                                      '${_asmShortKey(locked)} · ${locked.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          final query = controller.text.trim().toLowerCase();
                          final suggestions = <Widget>[];
                          suggestions.add(
                            ListTile(
                              dense: true,
                              leading: const Icon(Icons.edit_outlined, size: 18),
                              title: Text(context.l10n.editorAsmPresetManual),
                              onTap: () {
                                setState(() => _lockedPreset = null);
                                controller.closeView('');
                                _rebuild();
                              },
                            ),
                          );
                          for (final asm in kAsmFormats) {
                            if (!asm.validFor(_type)) continue;
                            final label = '${_asmShortKey(asm)} · ${asm.name}';
                            if (query.isNotEmpty &&
                                !label.toLowerCase().contains(query)) {
                              continue;
                            }
                            suggestions.add(
                              ListTile(
                                dense: true,
                                leading: const Icon(Icons.apps, size: 18),
                                title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                                subtitle: asm.registrant == null
                                    ? null
                                    : Text(
                                        asm.registrant!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _stateBadge(asm),
                                    if (asm.notToBeUsedAfter != null)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          asm.notToBeUsedAfter!,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  _selectAsm(asm);
                                  controller.closeView(_asmKey(asm));
                                },
                              ),
                            );
                          }
                          return suggestions;
                        },
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final spec in specs)
                          if (_showSpecField(spec))
                            SizedBox(
                              width: 170,
                              child: TextField(
                                controller: _controllers[spec.key],
                                onChanged: (_) => _rebuild(),
                                keyboardType: spec.kind == FieldKind.decimal
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true,
                                      )
                                    : TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: editorFieldLabel(
                                    context.l10n,
                                    spec.label,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                      ],
                    ),
                    if (_asm != null && _asm!.hasLayout) ...[
                      const SizedBox(height: 8),
                      SegmentedButton<EditorDataSource>(
                        segments: [
                          ButtonSegment(
                            value: EditorDataSource.raw,
                            label: Text(context.l10n.editorDataSourceRaw),
                            icon: const Icon(Icons.data_object, size: 16),
                          ),
                          ButtonSegment(
                            value: EditorDataSource.asm,
                            label: Text(context.l10n.editorDataSourceAsm),
                            icon: const Icon(Icons.apps, size: 16),
                          ),
                        ],
                        selected: {_dataSource},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) {
                          setState(() => _dataSource = s.first);
                          _rebuild();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_asm != null && !_asm!.hasLayout)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.asmLayoutUnknown(_asm!.name),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_asm != null && _asm!.hasLayout &&
                _dataSource == EditorDataSource.asm)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.apps, size: 18, color: scheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.editorAsmDetected(_asm!.name),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _stateBadge(_asm!),
                        ],
                      ),
                      if (_asm!.registrant != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _asm!.registrant!,
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (_asm!.deprecatedSince != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.asmDeprecatedSince(
                            _asm!.deprecatedSince!,
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: appColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final spec in asmFieldsFor(_asm!))
                            SizedBox(
                              width: 170,
                              child: TextField(
                                controller: _controllers[spec.key],
                                onChanged: (_) => _rebuild(),
                                keyboardType: spec.kind == FieldKind.decimal
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true,
                                      )
                                    : TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: editorFieldLabel(
                                    context.l10n,
                                    spec.label,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SectionHeader(
              icon: Icons.settings_input_antenna,
              title: context.l10n.editorAddTagBlock,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            initialValue: _talker,
                            mouseCursor: WidgetStateMouseCursor.clickable,
                            decoration: InputDecoration(
                              labelText: context.l10n.simTalkerId,
                              isDense: true,
                            ),
                            items: [
                              for (final t in kSimTalkers)
                                DropdownMenuItem(value: t, child: Text(t)),
                            ],
                            onChanged: (t) {
                              if (t == null) return;
                              setState(() => _talker = t);
                              _rebuild();
                            },
                          ),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            context.l10n.editorAddTagBlock,
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: _nmea4Tags,
                          onChanged: (v) {
                            setState(() => _nmea4Tags = v);
                            _rebuild();
                          },
                        ),
                        if (_nmea4Tags)
                          SizedBox(
                            width: 160,
                            child: TextField(
                              controller: _tagSourceC,
                              decoration: InputDecoration(
                                labelText: context.l10n.editorSourceId,
                                isDense: true,
                              ),
                              onChanged: (_) => _rebuild(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoverTooltip(
                  message: context.l10n.tooltipEditorInject,
                  child: FilledButton.icon(
                    onPressed: _sentence == null ? null : _inject,
                    icon: const Icon(Icons.map),
                    label: Text(context.l10n.editorInjectToMap),
                  ),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.running,
                  builder: (context, running, _) {
                    final enabled =
                        _sentence != null &&
                        widget.onSendToTarget != null &&
                        running;
                    return HoverTooltip(
                      message: context.l10n.tooltipEditorSend,
                      child: FilledButton.icon(
                        onPressed: enabled ? _sendToTarget : null,
                        icon: const Icon(Icons.send),
                        label: Text(context.l10n.editorSendToTarget),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.l10n.editorPreview,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        CopyIconButton(
                          text: _sentence ?? '',
                          message: context.l10n.editorNmeaCopied,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _sentence ?? _error ?? '',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
