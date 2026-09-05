import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/critical_persistence_store.dart';
import 'package:phoenix_journeys/services/journey_access_policy.dart';
import 'package:phoenix_journeys/state/access_controlled_app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FaultBackend implements CriticalPersistenceBackend {
  final Map<String, String> values = <String, String>{};
  bool failNextWrite = false;
  bool throwNextWrite = false;
  int writes = 0;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<bool> write(String key, String value) async {
    writes += 1;
    if (throwNextWrite) {
      throwNextWrite = false;
      throw StateError('injected critical write exception');
    }
    if (failNextWrite) {
      failNextWrite = false;
      return false;
    }
    values[key] = value;
    return true;
  }
}

const _seed =
    '1111111111111111111111111111111111111111111111111111111111111111';

AccessControlledAppState _criticalState(
  _FaultBackend backend, {
  DateTime Function()? clock,
}) {
  return AccessControlledAppState(
    clock: clock ?? () => DateTime(2026, 8, 3, 13),
    debugBuild: false,
    runtimeUri: Uri.parse('https://phoenix.example.com/'),
    accessMode: JourneyAccessMode.developmentExperience,
    explorerSeedGenerator: () => _seed,
    criticalPersistenceBackend: backend,
  );
}

Map<String, dynamic> _journeyPayload(
  Map<String, dynamic> payload,
  String journeyId,
) {
  final journeys = payload['journeys'] as Map;
  return (journeys[journeyId] as Map).map(
    (key, value) => MapEntry(key.toString(), value),
  );
}

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

  test('failed Active Journey activation preserves memory and committed identity',
      () async {
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();
    final originalId = state.activeJourneyId;
    final originalPath = state.activeJourneyStoragePath;
    const targetId = 'literary-roaming';

    backend.failNextWrite = true;
    await expectLater(
      state.activateJourney(targetId),
      throwsA(isA<CriticalPersistenceException>()),
    );

    expect(state.activeJourneyId, originalId);
    expect(state.activeJourneyStoragePath, originalPath);
    final payload = await state.readCommittedCriticalPayload();
    expect(payload['activeJourneyId'], originalId);

    final restored = _criticalState(backend);
    await restored.load();
    expect(restored.activeJourneyId, originalId);
    expect(restored.activeJourneyStoragePath, originalPath);
  });

  test('progress failure exposes no mixed step, drafts, or narration', () async {
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();
    final journeyId = state.activeJourneyId;

    await state.saveJourneyProgress(
      step: 2,
      wonder: '旧观察',
      express: '旧表达',
      memory: '旧回忆',
    );
    await state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'story-old',
      offset: 31,
    );

    backend.throwNextWrite = true;
    await expectLater(
      state.saveJourneyProgress(
        step: 4,
        wonder: '新观察',
        express: '新表达',
        memory: '新回忆',
      ),
      throwsA(isA<CriticalPersistenceException>()),
    );

    expect(state.journeyStep, 2);
    expect(state.journeyFurthestStep, 2);
    expect(state.wonderDraft, '旧观察');
    expect(state.expressDraft, '旧表达');
    expect(state.memoryDraft, '旧回忆');
    expect(state.journeyNarrationContentSignature, 'story-old');
    expect(state.journeyNarrationOffset, 31);

    final committed = _journeyPayload(
      await state.readCommittedCriticalPayload(),
      journeyId,
    );
    expect(committed['step'], 2);
    expect(committed['wonderDraft'], '旧观察');
    expect(committed['narrationContentSignature'], 'story-old');
    expect(committed['narrationOffset'], 31);

    final restored = _criticalState(backend);
    await restored.load();
    expect(restored.journeyStep, 2);
    expect(restored.wonderDraft, '旧观察');
    expect(restored.journeyNarrationOffset, 31);
  });

  test('different Journey namespaces retain independent snapshots', () async {
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();
    final firstId = state.activeJourneyId;
    const secondId = 'literary-roaming';

    await state.saveJourneyProgress(
      step: 2,
      wonder: '第一旅程',
      express: '',
      memory: '',
    );
    await state.activateJourney(secondId);
    await state.saveJourneyProgress(
      step: 4,
      wonder: '第二旅程',
      express: '',
      memory: '',
    );
    await state.activateJourney(firstId);

    expect(state.journeyStep, 2);
    expect(state.wonderDraft, '第一旅程');
    await state.activateJourney(secondId);
    expect(state.journeyStep, 4);
    expect(state.wonderDraft, '第二旅程');
  });

  test('completion failure commits no completion, Stamp, Memory, or cleanup',
      () async {
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();
    final journeyId = state.activeJourneyId;
    await state.saveJourneyProgress(
      step: 4,
      wonder: '保留观察',
      express: '保留表达',
      memory: '保留草稿',
    );
    await state.saveJourneyNarrationPosition(
      contentId: 'discovery',
      contentSignature: 'discovery-before-completion',
      offset: 22,
    );

    backend.failNextWrite = true;
    await expectLater(
      state.completeJourney('不可提交的回忆'),
      throwsA(isA<CriticalPersistenceException>()),
    );

    expect(state.journeyCompleted, isFalse);
    expect(state.earnedJourneyStampIds, isNot(contains(journeyId)));
    expect(state.memories, isNot(contains(contains('不可提交的回忆'))));
    expect(state.wonderDraft, '保留观察');
    expect(state.memoryDraft, '保留草稿');
    expect(state.journeyNarrationOffset, 22);

    final restored = _criticalState(backend);
    await restored.load();
    expect(restored.journeyCompleted, isFalse);
    expect(restored.earnedJourneyStampIds, isNot(contains(journeyId)));
    expect(restored.wonderDraft, '保留观察');
    expect(restored.journeyNarrationOffset, 22);

    await restored.completeJourney('完整回忆');
    expect(restored.journeyCompleted, isTrue);
    expect(restored.journeyStep, AppState.journeyLastStep);
    expect(restored.journeyFurthestStep, AppState.journeyLastStep);
    expect(restored.earnedJourneyStampIds, contains(journeyId));
    expect(restored.memories.where((item) => item.contains('完整回忆')), hasLength(1));
    expect(restored.wonderDraft, isEmpty);
    expect(restored.journeyNarrationOffset, 0);

    await restored.completeJourney('完整回忆');
    expect(restored.memories.where((item) => item.contains('完整回忆')), hasLength(1));
  });

  test('restart failure preserves the complete resumable state and wallet',
      () async {
    SharedPreferences.setMockInitialValues({
      'wallet.gold': 3,
      'earnedJourneyStampIds': <String>['beijing-forbidden-city'],
    });
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();
    await state.saveJourneyProgress(
      step: 3,
      wonder: '重启前观察',
      express: '重启前表达',
      memory: '重启前回忆',
    );
    await state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'restart-story',
      offset: 19,
    );

    backend.failNextWrite = true;
    await expectLater(
      state.restartJourney(),
      throwsA(isA<CriticalPersistenceException>()),
    );

    expect(state.journeyStep, 3);
    expect(state.wonderDraft, '重启前观察');
    expect(state.journeyNarrationOffset, 19);
    expect(state.goldCoins, 3);
    expect(state.earnedJourneyStampIds, contains('beijing-forbidden-city'));

    await state.restartJourney();
    expect(state.journeyStep, 0);
    expect(state.journeyFurthestStep, 0);
    expect(state.journeyCompleted, isFalse);
    expect(state.wonderDraft, isEmpty);
    expect(state.expressDraft, isEmpty);
    expect(state.memoryDraft, isEmpty);
    expect(state.journeyNarrationOffset, 0);
    expect(state.goldCoins, 3);
    expect(state.earnedJourneyStampIds, contains('beijing-forbidden-city'));
  });

  test('Reward failure changes neither Award ID nor balance and retry is once',
      () async {
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();

    backend.failNextWrite = true;
    await expectLater(
      state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'award-failure-retry',
      ),
      throwsA(isA<CriticalPersistenceException>()),
    );
    expect(state.goldCoins, 0);
    expect(state.awardedChallengeIds, isNot(contains('award-failure-retry')));

    expect(
      await state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'award-failure-retry',
      ),
      isTrue,
    );
    expect(
      await state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'award-failure-retry',
      ),
      isFalse,
    );
    expect(state.goldCoins, 1);

    final concurrent = await Future.wait([
      state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'award-concurrent',
      ),
      state.awardChallengeRewardOnce(
        reward: '金币',
        awardId: 'award-concurrent',
      ),
    ]);
    expect(concurrent.where((awarded) => awarded), hasLength(1));
    expect(state.goldCoins, 2);
    expect(
      state.awardedChallengeIds.where((id) => id == 'award-concurrent'),
      hasLength(1),
    );
  });

  test('Special unlock failure and concurrent retry deduct exactly once',
      () async {
    SharedPreferences.setMockInitialValues({'wallet.gold': 3});
    final backend = _FaultBackend();
    final state = _criticalState(backend);
    await state.load();

    backend.failNextWrite = true;
    await expectLater(
      state.unlockSpecialJourney(
        journeyId: 'literary-roaming',
        currency: '金币',
        cost: 2,
      ),
      throwsA(isA<CriticalPersistenceException>()),
    );
    expect(state.goldCoins, 3);
    expect(
      state.unlockedSpecialJourneyIds,
      isNot(contains('literary-roaming')),
    );

    final results = await Future.wait([
      state.unlockSpecialJourney(
        journeyId: 'literary-roaming',
        currency: '金币',
        cost: 2,
      ),
      state.unlockSpecialJourney(
        journeyId: 'literary-roaming',
        currency: '金币',
        cost: 2,
      ),
    ]);

    expect(
      results.map((result) => result.status),
      containsAll([
        SpecialJourneyUnlockStatus.unlocked,
        SpecialJourneyUnlockStatus.alreadyUnlocked,
      ]),
    );
    expect(state.goldCoins, 1);
    expect(
      state.unlockedSpecialJourneyIds.where(
        (id) => id == 'literary-roaming',
      ),
      hasLength(1),
    );

    final restored = _criticalState(backend);
    await restored.load();
    expect(restored.goldCoins, 1);
    expect(restored.canOpenJourney('literary-roaming'), isTrue);
    await restored.activateJourney('literary-roaming');
    expect(restored.activeJourneyId, 'literary-roaming');
  });
}
