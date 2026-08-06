import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
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

  Future<void> _toggleEnabled(TargetConfig target, bool enabled) async {
    await _upsert(target.copyWith(enabled: enabled));
  }

  Future<void> _showEditor({TargetConfig? existing}) async {
    final nameController =
        TextEditingController(text: existing?.name ?? '');
    final hostController = TextEditingController(text: existing?.host ?? '');
    final portController =
        TextEditingController(text: (existing?.port ?? 33333).toString());
    var protocol = existing?.protocol ?? ForwardProtocol.udpServer;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add destination' : 'Edit destination'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ForwardProtocol>(
                  initialValue: protocol,
                  decoration: const InputDecoration(labelText: 'Protocol'),
                  items: [
                    for (final p in ForwardProtocol.values)
                      DropdownMenuItem(
                        value: p,
                        child: Text(protocolLabel(p)),
                      ),
                  ],
                  onChanged: (p) {
                    if (p != null) setDialogState(() => protocol = p);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hostController,
                  decoration: const InputDecoration(labelText: 'Host'),
                  inputFormatters: [HostInputFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: portController,
                  decoration: const InputDecoration(labelText: 'Port'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PortInputFormatter(),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    hostController.dispose();
    portController.dispose();

    if (saved != true || !mounted) return;
    final name = nameController.text.trim();
    final host = hostController.text.trim();
    if (name.isEmpty || host.isEmpty) return;

    await _upsert(
      TargetConfig(
        id: existing?.id ?? TargetConfig.newId(),
        name: name,
        protocol: protocol,
        host: host,
        port: int.tryParse(portController.text) ?? 33333,
        enabled: existing?.enabled ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final appColors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.running,
            builder: (context, running, _) => IconButton(
              icon: const Icon(Icons.add),
              onPressed: running ? null : () => _showEditor(),
              tooltip: running
                  ? 'Stop the forwarder to edit destinations'
                  : 'Add destination',
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
                          const Expanded(
                            child: Text(
                              'Forwarder is running — destinations are '
                              'locked.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (settings.targets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text('No destination yet. Add one to '
                            'forward received AIS frames.'),
                      ),
                    )
                  else
                    for (final target in settings.targets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TintedCard(
                          accent: target.enabled
                              ? appColors.success
                              : Colors.grey,
                          child: Row(
                            children: [
                              Switch(
                                value: target.enabled,
                                onChanged: (v) => _toggleEnabled(target, v),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      target.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${protocolLabel(target.protocol)} · '
                                      '${target.host}:${target.port}',
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                ),
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    _showEditor(existing: target),
                                tooltip: 'Edit destination',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _remove(target),
                                tooltip: 'Remove destination',
                              ),
                            ],
                          ),
                        ),
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
