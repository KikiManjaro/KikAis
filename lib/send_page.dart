import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ais/ais_decoder.dart' show NmeaFormat;
import 'app_settings.dart';
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
import 'l10n_ext.dart';
import 'l10n/generated/app_localizations.dart';
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

  /// One-line explanation of what the selected protocol actually does.
  static String _modeHelp(AppLocalizations l10n, ForwardProtocol p) =>
      switch (p) {
        ForwardProtocol.udpServer => l10n.sendModeUdpListen,
        ForwardProtocol.udpClient => l10n.sendModeUdpSend,
        ForwardProtocol.tcpClient => l10n.sendModeTcpSend,
        ForwardProtocol.tcpServer => l10n.sendModeTcpListen,
      };

  Future<void> _showEditor({TargetConfig? existing}) async {
    final isNew = existing == null;
    final nameController = TextEditingController(text: existing?.name ?? '');
    final hostController = TextEditingController(
      text: existing?.host ?? (isNew ? '127.0.0.1' : ''),
    );
    final portController = TextEditingController(
      text: (existing?.port ?? 33333).toString(),
    );
    final tagSourceController = TextEditingController(
      text: existing?.tagSourceId ?? '',
    );
    var protocol = existing?.protocol ?? ForwardProtocol.udpClient;
    var sendFormat = existing?.sendFormat ?? NmeaFormat.passthrough;

    // A listening destination cannot share its port with another listener.
    final settings = context.read<AppSettings>();
    final usedPorts = {
      for (final t in settings.targets)
        if (t.id != existing?.id && _isListenProtocol(t.protocol)) t.port,
    };

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final l10n = ctx.l10n;
          final isListen = _isListenProtocol(protocol);
          final port = int.tryParse(portController.text);
          final portValid = port != null && port > 0 && port <= 65535;
          final portTaken = isListen && portValid && usedPorts.contains(port);
          final canSave =
              nameController.text.trim().isNotEmpty &&
              (isListen || hostController.text.trim().isNotEmpty) &&
              portValid &&
              !portTaken;
          final scheme = Theme.of(ctx).colorScheme;

          return AlertDialog(
            title: Text(
              isNew ? l10n.sendAddDestination : l10n.sendEditDestination,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.fieldName),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ForwardProtocol>(
                    initialValue: protocol,
                    mouseCursor: WidgetStateMouseCursor.clickable,
                    decoration: InputDecoration(labelText: l10n.fieldProtocol),
                    items: [
                      for (final p in ForwardProtocol.values)
                        DropdownMenuItem(
                          value: p,
                          child: Text(protocolLabelLocalized(p, l10n)),
                        ),
                    ],
                    onChanged: (p) {
                      if (p != null) setDialogState(() => protocol = p);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _modeHelp(l10n, protocol),
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (!isListen) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: hostController,
                      decoration: InputDecoration(
                        labelText: l10n.fieldRemoteHost,
                      ),
                      inputFormatters: [HostInputFormatter()],
                      onChanged: (_) => setDialogState(() {}),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: isListen
                          ? l10n.fieldListenPort
                          : l10n.fieldRemotePort,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PortInputFormatter(),
                    ],
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  if (portTaken)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        l10n.sendPortInUse,
                        style: TextStyle(fontSize: 12, color: scheme.error),
                      ),
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<NmeaFormat>(
                    initialValue: sendFormat,
                    mouseCursor: WidgetStateMouseCursor.clickable,
                    decoration: InputDecoration(labelText: l10n.sendFormat),
                    items: [
                      for (final f in NmeaFormat.values)
                        DropdownMenuItem(
                          value: f,
                          child: Text(nmeaFormatLabelLocalized(f, l10n)),
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
                          labelText: l10n.fieldTagSourceId,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.fieldCancel),
              ),
              FilledButton(
                onPressed: canSave ? () => Navigator.pop(ctx, true) : null,
                child: Text(isNew ? l10n.fieldAdd : l10n.sendSave),
              ),
            ],
          );
        },
      ),
    );

    if (saved != true || !mounted) {
      nameController.dispose();
      hostController.dispose();
      portController.dispose();
      tagSourceController.dispose();
      return;
    }
    final name = nameController.text.trim();
    final host = hostController.text.trim();
    final port = int.tryParse(portController.text) ?? 33333;
    final tagSource = tagSourceController.text.trim();

    nameController.dispose();
    hostController.dispose();
    portController.dispose();
    tagSourceController.dispose();

    await _upsert(
      TargetConfig(
        id: existing?.id ?? TargetConfig.newId(),
        name: name,
        protocol: protocol,
        // A listening target accepts every interface; the host is unused.
        host: _isListenProtocol(protocol) ? '0.0.0.0' : host,
        port: port,
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

/// Whether [protocol] makes KikAis listen on its own port (server role)
/// rather than connect out to a remote endpoint (client role).
bool _isListenProtocol(ForwardProtocol protocol) =>
    protocol == ForwardProtocol.udpServer ||
    protocol == ForwardProtocol.tcpServer;

/// Endpoint shown on a destination card: the listen port for a server role,
/// the remote endpoint for a client role.
String targetEndpointLabel(BuildContext context, TargetConfig target) =>
    _isListenProtocol(target.protocol)
    ? '${context.l10n.fieldListenPort} ${target.port}'
    : '${target.host}:${target.port}';

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
                    '${nmeaFormatLabelLocalized(target.sendFormat, context.l10n)}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    targetEndpointLabel(context, target),
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
