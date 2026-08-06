import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ais_editor_specs.dart';
import 'boatmanager.dart';
import 'widgets.dart';

class AisEditorPage extends StatefulWidget {
  final Future<void> Function(String nmea)? onSendToTarget;
  final ValueListenable<bool> running;

  const AisEditorPage({
    super.key,
    this.onSendToTarget,
    required this.running,
  });

  @override
  State<AisEditorPage> createState() => _AisEditorPageState();
}

class _AisEditorPageState extends State<AisEditorPage> {
  int _type = 1;
  final Map<String, TextEditingController> _controllers = {};

  String? _sentence;
  String? _error;

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
    super.dispose();
  }

  void _recreateControllers() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    for (final spec in fieldsForType(_type)) {
      _controllers[spec.key] = TextEditingController(text: spec.defaultText);
    }
  }

  Map<String, dynamic> _values() {
    final map = <String, dynamic>{};
    for (final spec in fieldsForType(_type)) {
      final c = _controllers[spec.key];
      if (c != null) {
        map[spec.key] = parseField(spec, c.text);
      }
    }
    return map;
  }

  void _rebuild() {
    try {
      final sentence = encodeMessage(_type, _values());
      setState(() {
        _sentence = sentence;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = '$e');
    }
  }

  Future<void> _inject() async {
    final sentence = _sentence;
    if (sentence == null) return;
    await context
        .read<BoatManager>()
        .processMessage(sentence, feed: 'KikAis');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message injected'),
          duration: Duration(seconds: 2),
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
        const SnackBar(
          content: Text('Message sent to target'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final specs = fieldsForType(_type);

    return Scaffold(
      appBar: AppBar(title: const Text('AIS Message Editor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              icon: Icons.edit_note,
              title: 'Compose message',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _type,
                      decoration: const InputDecoration(
                        labelText: 'Message type',
                        isDense: true,
                      ),
                      items: kEditorTypeLabels.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final spec in specs)
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
                                labelText: spec.label,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: 'Decode and add/update the vessel on the map '
                      'and in the statistics',
                  child: FilledButton.icon(
                    onPressed: _sentence == null ? null : _inject,
                    icon: const Icon(Icons.map),
                    label: const Text('Inject to map'),
                  ),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.running,
                  builder: (context, running, _) {
                    final enabled = _sentence != null &&
                        widget.onSendToTarget != null &&
                        running;
                    return Tooltip(
                      message: running
                          ? 'Send this NMEA sentence to the configured target'
                          : 'Start the forwarder first to send this sentence',
                      child: FilledButton.icon(
                        onPressed: enabled ? _sendToTarget : null,
                        icon: const Icon(Icons.send),
                        label: const Text('Send to target'),
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
                        const Text(
                          'NMEA preview',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        CopyIconButton(
                          text: _sentence ?? '',
                          message: 'NMEA copied',
                          padding: EdgeInsets.zero,
                          tooltip: 'Copy the NMEA sentence',
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
