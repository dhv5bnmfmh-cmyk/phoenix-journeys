import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  test('Pilot N1 keeps committed steps 3 and 4 while exposing subpages', () {
    expect(
      resolvePilotN1CompositePage(
        step: 3,
        challengeVisible: false,
        memoryVisible: false,
      ),
      PilotN1CompositePage.reflection,
    );
    expect(
      resolvePilotN1CompositePage(
        step: 3,
        challengeVisible: true,
        memoryVisible: false,
      ),
      PilotN1CompositePage.challenge,
    );
    expect(
      resolvePilotN1CompositePage(
        step: 4,
        challengeVisible: true,
        memoryVisible: false,
      ),
      PilotN1CompositePage.writing,
    );
    expect(
      resolvePilotN1CompositePage(
        step: 4,
        challengeVisible: true,
        memoryVisible: true,
      ),
      PilotN1CompositePage.memory,
    );
  });

  test('Pilot N1 does not change the B3 top-level step contract', () {
    expect(AppState.journeyLastStep, 5);
    expect(
      AppState.journeyStepLabels,
      const ['故事', '单词', '发现', '挑战', '回忆', '完成'],
    );
  });

  test('composite resolver rejects non-composite committed steps', () {
    expect(
      () => resolvePilotN1CompositePage(
        step: 2,
        challengeVisible: false,
        memoryVisible: false,
      ),
      throwsArgumentError,
    );
  });
}
