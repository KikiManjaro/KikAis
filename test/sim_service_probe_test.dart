import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/simulator_service.dart';

void main() {
  test('SimulatorService emits frames while running', () async {
    final sim = SimulatorService();
    final frames = <String>[];
    sim.onSentence = (n) async => frames.add(n);
    sim.start();
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    sim.stop();
    expect(frames, isNotEmpty);
    sim.dispose();
  });
}
