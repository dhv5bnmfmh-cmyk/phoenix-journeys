import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_access_policy.dart';
import 'package:phoenix_journeys/state/access_controlled_app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const seedA =
      '0101010101010101010101010101010101010101010101010101010101010101';
  const seedB =
      '0202020202020202020202020202020202020202020202020202020202020202';

  AccessControlledAppState productionState({
    required DateTime Function() clock,
    String Function()? seedGenerator,
    ExplorerSeedPersister? seedPersister,
    Uri? runtimeUri,
  }) {
    return AccessControlledAppState(
      clock: clock,
      debugBuild: false,
      runtimeUri: runtimeUri ?? Uri.parse('https://phoenix.example.com/'),
      explorerSeedGenerator: seedGenerator ?? () => seedA,
      explorerSeedPersister: seedPersister,
    );
  }

  test('production query parameters cannot unlock Development Experience', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      runtimeUri: Uri.parse(
        'https://phoenix.example.com/?unlock=all&prototype=journeys',
      ),
    );

    await state.load();

    expect(state.loadStatus, AppLoadStatus.ready);
    expect(
      state.journeyAccessMode,
      JourneyAccessMode.productionFreeExplorer,
    );
    expect(state.policyAccessibleRegularJourneyIds.length, 1);
    expect(state.canOpenJourney('literary-roaming'), isFalse);
  });

  test('trusted PR Preview host receives isolated Development Experience', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AccessControlledAppState(
      clock: () => DateTime(2026, 8, 3, 10),
      debugBuild: false,
      runtimeUri: Uri.parse(
        'https://phoenix-journeys-pr-145.7hn5tyrjgh.workers.dev/'
        '?unlock=all&prototype=journeys',
      ),
      explorerSeedGenerator: () => seedA,
    );

    await state.load();

    expect(state.isDevelopmentExperience, isTrue);
    expect(
      state.policyAccessibleRegularJourneyIds,
      dailyJourneyExperiences.map((journey) => journey.id).toSet(),
    );
    expect(state.canOpenJourney('literary-roaming'), isTrue);
    expect(state.canOpenJourney('tide-letter'), isTrue);
  });

  test('fresh install creates one opaque local Seed and restores it', () async {
    SharedPreferences.setMockInitialValues({});
    var generatorCalls = 0;
    final first = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      seedGenerator: () {
        generatorCalls += 1;
        return seedA;
      },
    );

    await first.load();
    final preferences = await SharedPreferences.getInstance();

    expect(generatorCalls, 1);
    expect(first.localExplorerSeed, seedA);
    expect(first.localExplorerSeed, hasLength(64));
    expect(first.localExplorerSeed, matches(RegExp(r'^[0-9a-f]+$')));
    expect(first.localExplorerSeed, isNot(contains('@')));
    expect(
      preferences.getString(
        AccessControlledAppState.explorerSeedStorageKey,
      ),
      seedA,
    );
    expect(
      preferences.getInt(
        AccessControlledAppState.explorerSeedVersionStorageKey,
      ),
      AccessControlledAppState.explorerSeedVersion,
    );

    final restored = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      seedGenerator: () {
        generatorCalls += 1;
        return seedB;
      },
    );
    await restored.load();

    expect(restored.localExplorerSeed, seedA);
    expect(generatorCalls, 1);
  });

  test('corrupt Seed fails closed without silently rerolling', () async {
    SharedPreferences.setMockInitialValues({
      AccessControlledAppState.explorerSeedStorageKey: '',
      AccessControlledAppState.explorerSeedVersionStorageKey:
          AccessControlledAppState.explorerSeedVersion,
    });
    var generatorCalls = 0;
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      seedGenerator: () {
        generatorCalls += 1;
        return seedB;
      },
    );

    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.explorerSeedFailureReason, contains('empty or corrupt'));
    expect(generatorCalls, 0);
  });

  test('Seed persistence failure reaches safe startup error', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      seedPersister: (_, __, ___) async => false,
    );

    await state.load();

    expect(state.loadStatus, AppLoadStatus.error);
    expect(state.explorerSeedFailureReason, contains('persistence failed'));
  });

  test('morning and afternoon assignments are stable and distinct', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 8);
    final state = productionState(clock: () => now);

    await state.load();
    final first = state.dailyAssignment;
    final refreshed = state.dailyAssignment;

    expect(refreshed.morningJourneyId, first.morningJourneyId);
    expect(refreshed.afternoonJourneyId, first.afternoonJourneyId);
    expect(first.morningJourneyId, isNot(first.afternoonJourneyId));
    expect(state.releasedDailyJourneyIds, {first.morningJourneyId});
    expect(state.todayJourney.id, first.morningJourneyId);

    now = DateTime(2026, 8, 3, 12);
    expect(state.releasedDailyJourneyIds, {
      first.morningJourneyId,
      first.afternoonJourneyId,
    });
    expect(state.todayJourney.id, first.afternoonJourneyId);
  });

  test('slot boundary uses local 00:00, 11:59, 12:00, and 23:59', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3);
    final state = productionState(clock: () => now);
    await state.load();

    final assignment = state.dailyAssignment;
    expect(state.releasedDailyJourneyIds, {assignment.morningJourneyId});

    now = DateTime(2026, 8, 3, 11, 59);
    expect(state.releasedDailyJourneyIds, {assignment.morningJourneyId});

    now = DateTime(2026, 8, 3, 12);
    expect(state.releasedDailyJourneyIds, {
      assignment.morningJourneyId,
      assignment.afternoonJourneyId,
    });

    now = DateTime(2026, 8, 3, 23, 59);
    expect(state.releasedDailyJourneyIds, {
      assignment.morningJourneyId,
      assignment.afternoonJourneyId,
    });
  });

  test('same-day refresh and restart never reroll assignments', () async {
    SharedPreferences.setMockInitialValues({});
    final now = DateTime(2026, 8, 3, 16);
    final first = productionState(clock: () => now);
    await first.load();
    final firstAssignment = first.dailyAssignment;

    await first.refreshDailyJourney();
    expect(first.activeJourneyId, firstAssignment.afternoonJourneyId);
    expect(first.dailyAssignment.morningJourneyId, firstAssignment.morningJourneyId);
    expect(
      first.dailyAssignment.afternoonJourneyId,
      firstAssignment.afternoonJourneyId,
    );

    final restored = productionState(
      clock: () => now,
      seedGenerator: () => seedB,
    );
    await restored.load();

    expect(restored.localExplorerSeed, seedA);
    expect(
      restored.dailyAssignment.morningJourneyId,
      firstAssignment.morningJourneyId,
    );
    expect(
      restored.dailyAssignment.afternoonJourneyId,
      firstAssignment.afternoonJourneyId,
    );
  });

  test('date rollover creates a new deterministic assignment', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 10);
    final state = productionState(clock: () => now);
    await state.load();
    final dayOne = state.dailyAssignment;

    now = DateTime(2026, 8, 4, 10);
    final dayTwo = state.dailyAssignment;
    final dayTwoAgain = state.dailyAssignment;

    expect(dayTwo.morningJourneyId, dayTwoAgain.morningJourneyId);
    expect(dayTwo.afternoonJourneyId, dayTwoAgain.afternoonJourneyId);
    expect(
      '${dayOne.morningJourneyId}|${dayOne.afternoonJourneyId}',
      isNot('${dayTwo.morningJourneyId}|${dayTwo.afternoonJourneyId}'),
    );
  });

  test('unreleased regular Journey activation fails without mutation', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
    );
    await state.load();

    final originalId = state.activeJourneyId;
    final originalStorage = state.activeJourneyStoragePath;
    final lockedId = dailyJourneyExperiences
        .map((journey) => journey.id)
        .firstWhere(
          (id) =>
              id != originalId &&
              !state.policyAccessibleRegularJourneyIds.contains(id),
        );

    expect(
      () => state.activateJourney(lockedId),
      throwsA(isA<JourneyAccessDeniedException>()),
    );
    expect(state.activeJourneyId, originalId);
    expect(state.activeJourneyStoragePath, originalStorage);

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(AppState.activeJourneyIdStorageKey),
      originalId,
    );
  });

  test('previous-day active Journey is the only resumable exception', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 10);
    final state = productionState(clock: () => now);
    await state.load();
    final previousDayId = state.activeJourneyId;

    await state.saveJourneyProgress(
      step: 2,
      wonder: '继续昨天的旅程',
      express: '',
      memory: '',
    );

    now = DateTime(2026, 8, 4, 13);
    await state.load();

    expect(state.activeJourneyId, previousDayId);
    expect(state.canOpenJourney(previousDayId), isTrue);
    expect(state.journeyStep, 2);

    final todayId = state.dailyAssignment.afternoonJourneyId;
    await state.activateJourney(todayId);
    expect(state.activeJourneyId, todayId);

    if (!state.policyAccessibleRegularJourneyIds.contains(previousDayId)) {
      expect(state.canOpenJourney(previousDayId), isFalse);
    }
  });

  test('held Special Journeys stay unpublished even when locally listed', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 13),
    );
    await state.load();

    state.unlockedSpecialJourneyIds.add('tide-letter');

    expect(state.canOpenJourney('tide-letter'), isFalse);
    expect(
      () => state.activateJourney('tide-letter'),
      throwsA(isA<JourneyAccessDeniedException>()),
    );
  });

  test('published Special Journey wallet unlock remains unchanged', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 13),
    );
    await state.load();
    state.goldCoins = 3;

    expect(state.canOpenJourney('literary-roaming'), isFalse);
    final result = await state.unlockSpecialJourney(
      journeyId: 'literary-roaming',
      currency: '金币',
      cost: 2,
    );

    expect(result.status, SpecialJourneyUnlockStatus.unlocked);
    expect(state.goldCoins, 1);
    expect(state.canOpenJourney('literary-roaming'), isTrue);
    await state.activateJourney('literary-roaming');
    expect(state.activeJourneyId, 'literary-roaming');
  });

  test('production never enters Paid Explorer without explicit entitlement', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 13),
    );
    await state.load();

    expect(
      state.journeyAccessMode,
      isNot(JourneyAccessMode.productionPaidExplorer),
    );
  });
}
