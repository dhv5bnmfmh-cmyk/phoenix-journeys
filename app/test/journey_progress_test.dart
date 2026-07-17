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
      step: 4,
      wonder: '我想观察红墙和屋顶。',
      express: '故宫保存了很多历史记忆。',
      memory: '今天记住了太和殿。',
    );

    final restored = AppState();
    await restored.load();

    expect(restored.beijingJourneyStep, 4);
    expect(restored.beijingJourneyFurthestStep, 4);
    expect(restored.beijingJourneyStepLabel, '表达');
    expect(restored.beijingJourneyProgressPercent, 71);
    expect(restored.wonderDraft, '我想观察红墙和屋顶。');
    expect(restored.expressDraft, '故宫保存了很多历史记忆。');
    expect(restored.memoryDraft, '今天记住了太和殿。');
    expect(restored.hasJourneyInProgress, isTrue);
  });

  test('going back does not lock previously reached steps', () async {
    final state = AppState();
    await state.load();

    await state.saveJourneyProgress(
      step: 5,
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
    expect(state.beijingJourneyFurthestStep, 5);
    expect(state.beijingJourneyFurthestStepLabel, '回忆');
  });

  test('completion earns a permanent stamp and restart keeps it', () async {
    final state = AppState();
    await state.load();
    await state.saveJourneyProgress(
      step: 5,
      wonder: '草稿一',
      express: '草稿二',
      memory: '北京的红墙',
    );

    await state.completeJourney('北京的红墙');

    expect(state.journeyCompleted, isTrue);
    expect(state.beijingStampEarned, isTrue);
    expect(state.beijingJourneyStep, AppState.beijingJourneyLastStep);
    expect(state.memories.first, '北京的红墙');
    expect(state.wonderDraft, isEmpty);

    await state.restartJourney();

    expect(state.journeyCompleted, isFalse);
    expect(state.beijingStampEarned, isTrue);
    expect(state.beijingJourneyStep, 0);
    expect(state.beijingJourneyFurthestStep, 0);
    expect(state.memories.first, '北京的红墙');

    final restored = AppState();
    await restored.load();

    expect(restored.journeyCompleted, isFalse);
    expect(restored.beijingStampEarned, isTrue);
    expect(restored.memories.first, '北京的红墙');
  });
}
