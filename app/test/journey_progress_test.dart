import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('restores the last journey step and writing drafts', () async {
    final state = AppState();
    await state.load();

    await state.saveJourneyProgress(
      step: 3,
      wonder: '我想观察红墙和屋顶。',
      express: '故宫保存了很多历史记忆。',
      memory: '今天记住了太和殿。',
    );

    final restored = AppState();
    await restored.load();

    expect(restored.beijingJourneyStep, 3);
    expect(restored.beijingJourneyFurthestStep, 3);
    expect(restored.beijingJourneyStepLabel, '挑战');
    expect(restored.beijingJourneyProgressPercent, 67);
    expect(restored.wonderDraft, '我想观察红墙和屋顶。');
    expect(restored.expressDraft, '故宫保存了很多历史记忆。');
    expect(restored.memoryDraft, '今天记住了太和殿。');
    expect(restored.hasJourneyInProgress, isTrue);
  });

  test('going back does not lock previously reached steps', () async {
    final state = AppState();
    await state.load();

    await state.saveJourneyProgress(
      step: 4,
      wonder: '',
      express: '',
      memory: '',
    );
    await state.saveJourneyProgress(
      step: 2,
      wonder: '',
      express: '',
      memory: '',
    );

    expect(state.beijingJourneyStep, 2);
    expect(state.beijingJourneyFurthestStep, 4);
    expect(state.beijingJourneyFurthestStepLabel, '回忆');
  });

  test('restores and clears a journey narration position', () async {
    final state = AppState();
    await state.load();
    await state.saveJourneyNarrationPosition(
      contentId: 'discovery',
      contentSignature: 'discovery-v1',
      offset: 42,
    );

    final restored = AppState();
    await restored.load();
    expect(restored.journeyNarrationContentId, 'discovery');
    expect(restored.journeyNarrationContentSignature, 'discovery-v1');
    expect(restored.journeyNarrationOffset, 42);

    await restored.clearJourneyNarrationPosition();
    expect(restored.journeyNarrationContentId, isNull);
    expect(restored.journeyNarrationContentSignature, isNull);
    expect(restored.journeyNarrationOffset, 0);
  });

  test('completion earns a permanent Beijing stamp and restart keeps it', () async {
    DateTime clock() => DateTime(2026, 1, 1);
    final state = AppState(clock: clock);
    await state.load();
    await state.activateJourney('beijing-forbidden-city');
    expect(state.activeJourneyId, 'beijing-forbidden-city');

    await state.saveJourneyProgress(
      step: 4,
      wonder: '草稿一',
      express: '草稿二',
      memory: '北京的红墙',
    );

    await state.completeJourney('北京的红墙');

    expect(state.journeyCompleted, isTrue);
    expect(state.beijingStampEarned, isTrue);
    expect(state.beijingJourneyStep, AppState.beijingJourneyLastStep);
    expect(state.memories.first, '北京 · 紫禁城｜北京的红墙');
    expect(state.wonderDraft, isEmpty);

    await state.restartJourney();

    expect(state.journeyCompleted, isFalse);
    expect(state.beijingStampEarned, isTrue);
    expect(state.beijingJourneyStep, 0);
    expect(state.beijingJourneyFurthestStep, 0);
    expect(state.memories.first, '北京 · 紫禁城｜北京的红墙');

    final restored = AppState(clock: clock);
    await restored.load();
    await restored.activateJourney('beijing-forbidden-city');

    expect(restored.journeyCompleted, isFalse);
    expect(restored.beijingStampEarned, isTrue);
    expect(restored.memories.first, '北京 · 紫禁城｜北京的红墙');
  });
}
