import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_immersion_agent.dart';

void main() {
  testWidgets('enters immersion after idle and reveals on interaction', (
    tester,
  ) async {
    final agent = PhoenixImmersionAgent(
      idleDelay: const Duration(milliseconds: 120),
    );
    addTearDown(agent.dispose);

    agent.setEnabled(true);
    expect(agent.immersed, isFalse);

    await tester.pump(const Duration(milliseconds: 121));
    expect(agent.immersed, isTrue);

    agent.registerInteraction();
    expect(agent.immersed, isFalse);

    await tester.pump(const Duration(milliseconds: 121));
    expect(agent.immersed, isTrue);
  });

  testWidgets('disabled pages never enter immersion', (tester) async {
    final agent = PhoenixImmersionAgent(
      idleDelay: const Duration(milliseconds: 80),
    );
    addTearDown(agent.dispose);

    agent.setEnabled(false);
    await tester.pump(const Duration(milliseconds: 100));

    expect(agent.immersed, isFalse);
  });

  testWidgets('leaving a reading page cancels the pending idle fade', (
    tester,
  ) async {
    final agent = PhoenixImmersionAgent(
      idleDelay: const Duration(milliseconds: 100),
    );
    addTearDown(agent.dispose);

    agent.setEnabled(true);
    await tester.pump(const Duration(milliseconds: 45));
    agent.setEnabled(false);
    await tester.pump(const Duration(milliseconds: 100));

    expect(agent.enabled, isFalse);
    expect(agent.immersed, isFalse);
  });
}
