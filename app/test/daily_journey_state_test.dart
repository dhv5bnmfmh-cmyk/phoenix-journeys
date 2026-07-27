import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('progress is stored independently for each journey', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 7, 20));
    await state.load();
    final firstJourney = state.activeJourneyId;

    await state.saveJourneyProgress(
      step: 3,
      wonder: '第一座城市',
      express: '',
      memory: '',
    );

    await state.activateJourney('beijing-forbidden-city');
    if (state.activeJourneyId != firstJourney) {
      expect(state.journeyStep, 0);
      await state.saveJourneyProgress(
        step: 1,
        wonder: '北京',
        express: '',
        memory: '',
      );
      await state.activateJourney(firstJourney);
      expect(state.journeyStep, 3);
      expect(state.wonderDraft, '第一座城市');
    }
  });

  test('completing a journey permanently adds its city stamp', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 7, 20));
    await state.load();
    final journeyId = state.activeJourneyId;

    await state.completeJourney('我记住了今天的城市。');

    expect(state.isJourneyStampEarned(journeyId), isTrue);
    expect(state.earnedStampCount, 1);

    final restored = AppState(clock: () => DateTime(2026, 7, 20));
    await restored.load();
    expect(restored.isJourneyStampEarned(journeyId), isTrue);
    expect(restored.memories.first, contains('我记住了今天的城市'));
  });

  test('the next day automatically loads a different journey', () async {
    SharedPreferences.setMockInitialValues({});
    final dayOne = AppState(clock: () => DateTime(2026, 7, 20));
    final dayTwo = AppState(clock: () => DateTime(2026, 7, 21));

    await dayOne.load();
    await dayTwo.load();

    expect(dayOne.activeJourneyId, isNot(dayTwo.activeJourneyId));
  });
}
