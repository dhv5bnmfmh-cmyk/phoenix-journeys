import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, Object> activeIdentity(String journeyId) {
  final binding = requireJourneyLocation(journeyId);
  return <String, Object>{
    AppState.activeJourneyIdStorageKey: journeyId,
    AppState.activeJourneyNamespaceStorageKey: binding.storageNamespace,
    AppState.activeJourneyVersionStorageKey:
        AppState.activeJourneyIdentityVersion,
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('normal Journey identity, drafts, and narration survive reload', () async {
    final state = AppState(clock: () => DateTime(2026, 1, 1));
    await state.load();
    await state.activateJourney('beijing-summer-palace');
    await state.saveJourneyProgress(
      step: 3,
      wonder: 'normal wonder',
      express: 'normal express',
      memory: 'normal memory',
    );
    await state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'normal-story-v1',
      offset: 37,
    );

    final restored = AppState(clock: () => DateTime(2026, 1, 9));
    await restored.load();

    expect(restored.loadStatus, AppLoadStatus.ready);
    expect(restored.activeJourneyId, 'beijing-summer-palace');
    expect(restored.activeJourney.id, 'beijing-summer-palace');
    expect(restored.journeyStep, 3);
    expect(restored.wonderDraft, 'normal wonder');
    expect(restored.expressDraft, 'normal express');
    expect(restored.memoryDraft, 'normal memory');
    expect(restored.journeyNarrationContentId, 'story');
    expect(restored.journeyNarrationContentSignature, 'normal-story-v1');
    expect(restored.journeyNarrationOffset, 37);
  });

  test('original special Journey identity and completion survive reload', () async {
    final state = AppState();
    await state.load();
    await state.activateJourney('literary-roaming');
    await state.completeJourney('special memory');

    final restored = AppState(clock: () => DateTime(2027, 2, 2));
    await restored.load();

    expect(restored.loadStatus, AppLoadStatus.ready);
    expect(restored.activeJourneyId, 'literary-roaming');
    expect(restored.activeJourney.id, 'literary-roaming');
    expect(restored.journeyCompleted, isTrue);
    expect(restored.isJourneyStampEarned('literary-roaming'), isTrue);
    expect(restored.memories.first, contains('special memory'));
  });

  test('expansion special Journey identity survives reload', () async {
    expect(journeyExperienceById('tide-letter'), isNotNull);
    final state = AppState();
    await state.load();
    await state.activateJourney('tide-letter');
    await state.saveJourneyProgress(
      step: 2,
      wonder: 'tide wonder',
      express: 'tide express',
      memory: 'tide memory',
    );

    final restored = AppState(clock: () => DateTime(2028, 3, 3));
    await restored.load();

    expect(restored.loadStatus, AppLoadStatus.ready);
    expect(restored.activeJourneyId, 'tide-letter');
    expect(restored.activeJourney.id, 'tide-letter');
    expect(restored.journeyStep, 2);
    expect(restored.memoryDraft, 'tide memory');
  });

  test('persisted identity is restored before Daily selection', () async {
    final firstClock = DateTime(2026, 1, 1);
    final laterClock = DateTime(2026, 1, 17);
    final target = dailyJourneyExperiences.firstWhere(
      (journey) =>
          journey.id != dailyJourneyForDate(firstClock).id &&
          journey.id != dailyJourneyForDate(laterClock).id,
    );

    final state = AppState(clock: () => firstClock);
    await state.load();
    await state.activateJourney(target.id);

    final restored = AppState(clock: () => laterClock);
    await restored.load();

    expect(restored.todayJourney.id, dailyJourneyForDate(laterClock).id);
    expect(restored.activeJourneyId, target.id);
    expect(restored.activeJourneyId, isNot(restored.todayJourney.id));
  });

  test('local date change does not replace a resumable active Journey', () async {
    var currentDate = DateTime(2026, 1, 2);
    final state = AppState(clock: () => currentDate);
    await state.load();
    await state.activateJourney('shanghai-bund');
    await state.saveJourneyProgress(
      step: 4,
      wonder: 'date wonder',
      express: '',
      memory: '',
    );

    currentDate = DateTime(2026, 6, 21);
    await state.load();

    expect(state.loadStatus, AppLoadStatus.ready);
    expect(state.activeJourneyId, 'shanghai-bund');
    expect(state.journeyStep, 4);
    expect(state.wonderDraft, 'date wonder');
  });

  test('invalid persisted ID enters safe recovery without substitution', () async {
    final protected = requireJourneyLocation('beijing-summer-palace');
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppState.activeJourneyIdStorageKey: 'removed-journey-v0',
      AppState.activeJourneyNamespaceStorageKey:
          'journey/removed/namespace',
      AppState.activeJourneyVersionStorageKey:
          AppState.activeJourneyIdentityVersion,
      '${protected.storageNamespace}.step': 4,
      '${protected.storageNamespace}.wonderDraft': 'must remain',
      'earnedJourneyStampIds': <String>['beijing-summer-palace'],
      'wallet.gold': 7,
    });

    final state = AppState(clock: () => DateTime(2026, 1, 1));
    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.activeJourneyId, 'removed-journey-v0');
    expect(state.activeJourneyRestoreFailureId, 'removed-journey-v0');
    expect(state.activeJourneyRestoreFailureReason, contains('no longer'));
    expect(journeyExperienceById(state.activeJourneyId), isNull);
    expect(state.goldCoins, 7);
    expect(state.isJourneyStampEarned('beijing-summer-palace'), isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('${protected.storageNamespace}.step'), 4);
    expect(
      prefs.getString('${protected.storageNamespace}.wonderDraft'),
      'must remain',
    );
    expect(
      prefs.getString(AppState.activeJourneyIdStorageKey),
      'removed-journey-v0',
    );
  });

  test('missing persisted ID metadata does not select a Daily Journey', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppState.activeJourneyNamespaceStorageKey:
          'journey/beijing/summer-palace',
      AppState.activeJourneyVersionStorageKey:
          AppState.activeJourneyIdentityVersion,
    });

    final state = AppState(clock: () => DateTime(2026, 1, 1));
    final constructorDefault = state.activeJourneyId;
    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.activeJourneyId, isEmpty);
    expect(state.activeJourneyId, isNot(constructorDefault));
    expect(state.activeJourneyRestoreFailureId, isEmpty);
    expect(state.activeJourneyRestoreFailureReason, contains('missing'));
  });

  test('namespace mismatch cannot load another Journey namespace', () async {
    final journey = requireDailyJourneyExperience('shanghai-bund');
    final correct = requireJourneyLocation(journey.id);
    final unrelated = requireJourneyLocation('beijing-forbidden-city');
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppState.activeJourneyIdStorageKey: journey.id,
      AppState.activeJourneyNamespaceStorageKey: unrelated.storageNamespace,
      AppState.activeJourneyVersionStorageKey:
          AppState.activeJourneyIdentityVersion,
      '${correct.storageNamespace}.step': 3,
      '${unrelated.storageNamespace}.step': 5,
    });

    final state = AppState();
    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.activeJourneyId, journey.id);
    expect(state.activeJourneyRestoreFailureReason, contains('mismatch'));
    expect(state.journeyStep, 0);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('${correct.storageNamespace}.step'), 3);
    expect(prefs.getInt('${unrelated.storageNamespace}.step'), 5);
  });

  test('explicit Journey selection updates persisted active identity', () async {
    final state = AppState();
    await state.load();
    await state.activateJourney('xian-city-wall');

    final binding = requireJourneyLocation('xian-city-wall');
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(AppState.activeJourneyIdStorageKey),
      'xian-city-wall',
    );
    expect(
      prefs.getString(AppState.activeJourneyNamespaceStorageKey),
      binding.storageNamespace,
    );
    expect(
      prefs.getInt(AppState.activeJourneyVersionStorageKey),
      AppState.activeJourneyIdentityVersion,
    );

    final restored = AppState();
    await restored.load();
    expect(restored.activeJourneyId, 'xian-city-wall');
  });

  test('Journey progress namespaces remain isolated without duplicates', () async {
    final state = AppState();
    await state.load();

    await state.activateJourney('beijing-summer-palace');
    await state.saveJourneyProgress(
      step: 1,
      wonder: 'summer only',
      express: '',
      memory: '',
    );

    await state.activateJourney('shanghai-bund');
    await state.saveJourneyProgress(
      step: 4,
      wonder: 'shanghai only',
      express: '',
      memory: '',
    );

    await state.activateJourney('beijing-summer-palace');
    expect(state.journeyStep, 1);
    expect(state.wonderDraft, 'summer only');

    await state.activateJourney('shanghai-bund');
    expect(state.journeyStep, 4);
    expect(state.wonderDraft, 'shanghai only');

    final prefs = await SharedPreferences.getInstance();
    final summer = requireJourneyLocation('beijing-summer-palace');
    final shanghai = requireJourneyLocation('shanghai-bund');
    expect(prefs.getInt('${summer.storageNamespace}.step'), 1);
    expect(prefs.getInt('${shanghai.storageNamespace}.step'), 4);
    expect(
      prefs.getString('${summer.storageNamespace}.wonderDraft'),
      'summer only',
    );
    expect(
      prefs.getString('${shanghai.storageNamespace}.wonderDraft'),
      'shanghai only',
    );
  });

  test('legacy Journey-ID storage migration remains intact', () async {
    const targetId = 'shanghai-bund';
    final binding = requireJourneyLocation(targetId);
    SharedPreferences.setMockInitialValues(<String, Object>{
      ...activeIdentity(targetId),
      '${binding.legacyStorageNamespace}.step': 3,
      '${binding.legacyStorageNamespace}.furthestStep': 4,
      '${binding.legacyStorageNamespace}.wonderDraft': 'legacy draft',
    });

    final state = AppState();
    await state.load();

    expect(state.loadStatus, AppLoadStatus.ready);
    expect(state.activeJourneyId, targetId);
    expect(state.journeyStep, 3);
    expect(state.journeyFurthestStep, 4);
    expect(state.wonderDraft, 'legacy draft');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('${binding.storageNamespace}.step'), 3);
    expect(prefs.getInt('${binding.storageNamespace}.furthestStep'), 4);
    expect(
      prefs.getString('${binding.storageNamespace}.wonderDraft'),
      'legacy draft',
    );
    expect(
      prefs.getString('${binding.legacyStorageNamespace}.wonderDraft'),
      'legacy draft',
    );
  });

  test('fresh install keeps the existing Daily default and persists identity',
      () async {
    final clock = DateTime(2026, 4, 5);
    final expected = dailyJourneyForDate(clock);
    final state = AppState(clock: () => clock);

    await state.load();

    expect(state.loadStatus, AppLoadStatus.ready);
    expect(state.activeJourneyId, expected.id);
    expect(state.activeJourney, same(expected));
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(AppState.activeJourneyIdStorageKey),
      expected.id,
    );
    expect(
      prefs.getString(AppState.activeJourneyNamespaceStorageKey),
      requireJourneyLocation(expected.id).storageNamespace,
    );
  });

  test('storage-read failure reaches startup error state', () async {
    final state = AppState(
      preferencesLoader: () async => throw StateError('storage read failed'),
    );

    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.loadErrorMessage, isNotEmpty);
    expect(state.activeJourneyRestoreFailureId, isNull);
  });

  test('repeated load is idempotent for active identity and progress', () async {
    final state = AppState();
    await state.load();
    await state.activateJourney('beijing-summer-palace');
    await state.saveJourneyProgress(
      step: 2,
      wonder: 'idempotent',
      express: 'same',
      memory: 'same',
    );

    await state.load();
    final first = (
      id: state.activeJourneyId,
      step: state.journeyStep,
      wonder: state.wonderDraft,
      namespace: state.activeJourneyStoragePath,
    );
    await state.load();
    final second = (
      id: state.activeJourneyId,
      step: state.journeyStep,
      wonder: state.wonderDraft,
      namespace: state.activeJourneyStoragePath,
    );

    expect(second, first);
  });

  test('invalid explicit activation cannot replace the current Journey', () async {
    final state = AppState();
    await state.load();
    await state.activateJourney('beijing-summer-palace');
    final before = state.activeJourneyId;

    await expectLater(
      state.activateJourney('unknown-explicit-journey'),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('unknown-explicit-journey'),
        ),
      ),
    );

    expect(state.activeJourneyId, before);
    expect(state.activeJourney.id, before);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(AppState.activeJourneyIdStorageKey), before);
  });
}
