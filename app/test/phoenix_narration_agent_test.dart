import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/phoenix_narration_agent.dart';

void main() {
  test('PhoenixNarrationAgent exposes narration and interruption state', () {
    final agent = PhoenixNarrationAgent();

    expect(agent.status, NarrationStatus.idle);
    expect(agent.isInterrupting, isFalse);
    expect(agent.interruptionLabel, isNull);
    expect(PhoenixNarrationAgent.speedOptions, isNotEmpty);

    agent.dispose();
  });
}
