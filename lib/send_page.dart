import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ais/ais_decoder.dart' show NmeaFormat;
import 'app_settings.dart';
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
import 'l10n_ext.dart';
import 'labels.dart';
import 'port_input_formatter.dart';
import 'target_config.dart';
import 'themes.dart';
import 'widgets.dart';

/// Send page: manages the list of send destinations. Each destination has its
/// own transport. The list is locked while the forwarder (reception) runs.
class SendPage extends StatefulWidget {
  final ForwarderService? Function() serviceGetter;
  final ValueListenable<bool> running;

  const SendPage({
    super.key,
    required this.serviceGetter,
    required this.running,
  });

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  Future<void> _apply(List<TargetConfig> targets) async {
    final settings = context.read<AppSettings>();
    settings.setTargets(targets);
    await widget.serviceGetter()?.setTargets(targets);
  }

  Future<void> _upsert(TargetConfig target) async {
    final settings = context.read<AppSettings>();
    final list = List<TargetConfig>.of(settings.targets);
    final index = list.indexWhere((t) => t.id == target.id);
    if (index == -1) {
      list.add(target);
    } else {
      list[index] = target;
    }
    await _apply(list);
  }

  Future<void> _remove(TargetConfig target) async {
    final settings = context.read<AppSettings>();
    final list = List<TargetConfig>.of(settings.targets)
      ..removeWhere((t) => t.id == target.id);
    await _apply(list);
  }

  void _editTarget(TargetConfig? target) {
    _showEditor(existing: target);
  }

  void _toggleCard(TargetConfig target) {
    _upsert(target);
  }

  Future<void> _showEditor({TargetConfig? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final hostController = TextEditingController(text: existing?.host ?? '');
    final portController = TextEditingController(
      text: (existing?.port ?? 33333).toString(),
    );
    final tagSourceController = TextEditingController(
      text: existing?.tagSourceId ?? '',
    );
    var protocol = existing?.protocol ?? ForwardProtocol.udpServer;
    var sendFormat = existing?.sendFormat ?? NmeaFormat.passthrough;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            existing == null
                ? ctx.l10n.sendAddDestination
                : ctx.l10n.sendEditDestination,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: ctx.l10n.fieldName),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ForwardProtocol>(
                  initialValue: protocol,
                  decoration: InputDecoration(
                    labelText: ctx.l10n.fieldProtocol,
                  ),
                  items: [
                    for (final p in ForwardProtocol.values)
                      DropdownMenuItem(
                        value: p,
                        child: Text(protocolLabelLocalized(p, ctx.l10n)),
                      ),
                  ],
                  onChanged: (p) {
                    if (p != null) setDialogState(() => protocol = p);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hostController,
                  decoration: InputDecoration(labelText: ctx.l10n.fieldHost),
                  inputFormatters: [HostInputFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: portController,
                  decoration: InputDecoration(labelText: ctx.l10n.fieldPort),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PortInputFormatter(),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<NmeaFormat>(
                  initialValue: sendFormat,
                  decoration: InputDecoration(labelText: ctx.l10n.sendFormat),
                  items: [
                    for (final f in NmeaFormat.values)
                      DropdownMenuItem(
                        value: f,
                        child: Text(nmeaFormatLabelLocalized(f, ctx.l10n)),
                      ),
                  ],
                  onChanged: (f) {
                    if (f != null) setDialogState(() => sendFormat = f);
                  },
                ),
                if (sendFormat == NmeaFormat.tag)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: tagSourceController,
                      decoration: InputDecoration(
                        labelText: ctx.l10n.fieldTagSourceId,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.l10n.fieldCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                existing == null ? ctx.l10n.fieldAdd : ctx.l10n.sendSave,
              ),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    hostController.dispose();
    portController.dispose();
    tagSourceController.dispose();

    if (saved != true || !mounted) return;
    final name = nameController.text.trim();
    final host = hostController.text.trim();
    if (name.isEmpty || host.isEmpty) return;

    final tagSource = tagSourceController.text.trim();
    await _upsert(
      TargetConfig(
        id: existing?.id ?? TargetConfig.newId(),
        name: name,
        protocol: protocol,
        host: host,
        port: int.tryParse(portController.text) ?? 33333,
        enabled: existing?.enabled ?? true,
        sendFormat: sendFormat,
        tagSourceId: tagSource.isEmpty ? null : tagSource,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetIds = context.select<AppSettings, List<String>>(
      (s) => [for (final t in s.targets) t.id],
    );
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tabSend),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.running,
            builder: (context, running, _) => HoverTooltip(
              message: context.l10n.tooltipSendAdd,
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: running ? null : () => _showEditor(),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.running,
        builder: (context, running, _) {
          return AbsorbPointer(
            absorbing: running,
            child: Opacity(
              opacity: running ? 0.6 : 1.0,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (running)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: appColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.sendLockedBanner,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (targetIds.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(child: Text(context.l10n.sendEmpty)),
                    )
                  else
                    for (final id in targetIds)
                      _TargetCard(
                        key: ValueKey(id),
                        targetId: id,
                        onToggle: _toggleCard,
                        onEdit: _editTarget,
                        onDelete: _remove,
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A single destination card. It watches only its own [TargetConfig] from
/// [AppSettings] (via [context.select]), so toggling a switch rebuilds just
/// this card instead of the whole page and the entire application.
class _TargetCard extends StatelessWidget {
  final String targetId;
  final ValueChanged<TargetConfig> onToggle;
  final ValueChanged<TargetConfig?> onEdit;
  final ValueChanged<TargetConfig> onDelete;

  const _TargetCard({
    super.key,
    required this.targetId,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final target = context.select<AppSettings, TargetConfig>(
      (s) => s.targets.firstWhere((t) => t.id == targetId),
    );
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TintedCard(
        accent: target.enabled ? appColors.success : Colors.grey,
        child: Row(
          children: [
            HoverTooltip(
              message: context.l10n.tooltipSendToggle,
              child: Switch(
                value: target.enabled,
                onChanged: (v) => onToggle(target.copyWith(enabled: v)),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${protocolLabelLocalized(target.protocol, context.l10n)} · '
                    '${target.host}:${target.port} · '
                    '${nmeaFormatLabelLocalized(target.sendFormat, context.l10n)}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            HoverTooltip(
              message: context.l10n.tooltipSendEdit,
              child: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: () => onEdit(target),
              ),
            ),
            HoverTooltip(
              message: context.l10n.tooltipSendDelete,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: () => onDelete(target),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
