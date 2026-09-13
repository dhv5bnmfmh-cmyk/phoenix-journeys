import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_publication_catalog.dart';
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

  test('production query parameters cannot unlock Development Experience',
      () async {
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

  test('trusted PR Preview host receives isolated Development Experience',
      () async {
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
    expect(state.policyAccessibleRegularJourneyIds,
        publishedJourneyRuntimeIds.toSet());
    expect(state.canOpenJourney('literary-roaming'), isTrue);
    expect(state.canOpenJourney('tide-letter'), isTrue);
  });

  test('lookalike workers.dev host cannot obtain Preview all-access', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      runtimeUri: Uri.parse(
        'https://phoenix-journeys-pr-145.attacker.workers.dev/'
        '?unlock=all&prototype=journeys',
      ),
    );

    await state.load();

    expect(
      state.journeyAccessMode,
      JourneyAccessMode.productionFreeExplorer,
    );
    expect(state.policyAccessibleRegularJourneyIds.length, 1);
    expect(state.canOpenJourney('literary-roaming'), isFalse);
    expect(state.canOpenJourney('tide-letter'), isFalse);
  });

  test('non-HTTPS Preview-shaped host cannot obtain all-access', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
      runtimeUri: Uri.parse(
        'http://phoenix-journeys-pr-145.7hn5tyrjgh.workers.dev/'
        '?unlock=all',
      ),
    );

    await state.load();

    expect(
      state.journeyAccessMode,
      JourneyAccessMode.productionFreeExplorer,
    );
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
    final committed = await first.readCommittedCriticalPayload();

    expect(generatorCalls, 1);
    expect(first.localExplorerSeed, seedA);
    expect(first.localExplorerSeed, hasLength(64));
    expect(first.localExplorerSeed, matches(RegExp(r'^[0-9a-f]+$')));
    expect(first.localExplorerSeed, isNot(contains('@')));
    expect(first.localExplorerSeed, isNot(contains('name')));
    expect(first.localExplorerSeed, isNot(contains('email')));
    expect(committed['explorerSeed'], seedA);
    expect(
      committed['explorerSeedVersion'],
      AccessControlledAppState.explorerSeedVersion,
    );
    expect(
      preferences.getString(
        AccessControlledAppState.explorerSeedStorageKey,
      ),
      isNull,
    );
    expect(
      preferences.getInt(
        AccessControlledAppState.explorerSeedVersionStorageKey,
      ),
      isNull,
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

  test('Daily resolution cannot fall back before a valid Seed exists', () {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
    );

    expect(() => state.todayJourney, throwsStateError);
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
    expect(() => state.todayJourney, throwsStateError);
  });

  test('partial Seed record fails closed without migration reroll', () async {
    SharedPreferences.setMockInitialValues({
      AccessControlledAppState.explorerSeedStorageKey: seedA,
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
    expect(state.explorerSeedFailureReason, contains('incomplete'));
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

  test('single Reference Journey is stable across both daily slots', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 8);
    final state = productionState(clock: () => now);

    await state.load();
    final first = state.dailyAssignment;
    final refreshed = state.dailyAssignment;

    expect(refreshed.morningJourneyId, first.morningJourneyId);
    expect(refreshed.afternoonJourneyId, first.afternoonJourneyId);
    expect(first.morningJourneyId, referenceJourneyRuntimeId);
    expect(first.afternoonJourneyId, referenceJourneyRuntimeId);
    expect(state.releasedDailyJourneyIds, {first.morningJourneyId});
    expect(state.todayJourney.id, first.morningJourneyId);

    now = DateTime(2026, 8, 3, 12);
    expect(state.releasedDailyJourneyIds, {
      first.morningJourneyId,
      first.afternoonJourneyId,
    });
    expect(state.releasedDailyJourneyIds, hasLength(1));
    expect(state.todayJourney.id, first.afternoonJourneyId);
  });

  test('duplicate candidates do not duplicate or bias slot output', () {
    final assignment = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: const ['journey-a', 'journey-a', 'journey-b'],
      explorerSeed: seedA,
      localDate: DateTime(2026, 8, 3),
    );

    expect(
      {assignment.morningJourneyId, assignment.afternoonJourneyId},
      {'journey-a', 'journey-b'},
    );
  });

  test('empty eligible catalog fails explicitly', () {
    expect(
      () => JourneyAccessPolicy.assignDailyJourneys(
        journeyIds: const [],
        explorerSeed: seedA,
        localDate: DateTime(2026, 8, 3),
      ),
      throwsArgumentError,
    );
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

  test('local calendar date is used without UTC rollover drift', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 4, 0, 5);
    final state = productionState(clock: () => now);
    await state.load();

    final localDay = state.dailyAssignment;
    final expected = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: state.eligibleRegularJourneyIds,
      explorerSeed: seedA,
      localDate: DateTime(2026, 8, 4),
    );

    expect(localDay.morningJourneyId, expected.morningJourneyId);
    expect(localDay.afternoonJourneyId, expected.afternoonJourneyId);
    expect(state.releasedDailySlots, {JourneyReleaseSlot.morning});

    now = DateTime(2026, 8, 4, 12);
    expect(state.releasedDailySlots, {
      JourneyReleaseSlot.morning,
      JourneyReleaseSlot.afternoon,
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
    expect(
      first.dailyAssignment.morningJourneyId,
      firstAssignment.morningJourneyId,
    );
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

  test('date rollover uses the new date deterministic assignment', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 10);
    final state = productionState(clock: () => now);
    await state.load();

    now = DateTime(2026, 8, 4, 10);
    final dayTwo = state.dailyAssignment;
    final dayTwoAgain = state.dailyAssignment;
    final expectedDayTwo = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: state.eligibleRegularJourneyIds,
      explorerSeed: seedA,
      localDate: now,
    );

    expect(dayTwo.morningJourneyId, dayTwoAgain.morningJourneyId);
    expect(dayTwo.afternoonJourneyId, dayTwoAgain.afternoonJourneyId);
    expect(dayTwo.morningJourneyId, expectedDayTwo.morningJourneyId);
    expect(dayTwo.afternoonJourneyId, expectedDayTwo.afternoonJourneyId);
  });

  test('unreleased regular Journey activation fails without mutation',
      () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
    );
    await state.load();

    final originalId = state.activeJourneyId;
    final originalStorage = state.activeJourneyStoragePath;
    final originalCommitted = await state.readCommittedCriticalPayload();
    final lockedId =
        dailyJourneyExperiences.map((journey) => journey.id).firstWhere(
              (id) =>
                  id != originalId &&
                  !state.policyAccessibleRegularJourneyIds.contains(id),
            );

    await expectLater(
      state.activateJourney(lockedId),
      throwsA(isA<JourneyAccessDeniedException>()),
    );
    expect(state.activeJourneyId, originalId);
    expect(state.activeJourneyStoragePath, originalStorage);

    final committed = await state.readCommittedCriticalPayload();
    expect(committed['activeJourneyId'], originalId);
    expect(
      committed['activeJourneyNamespace'],
      originalCommitted['activeJourneyNamespace'],
    );
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(AppState.activeJourneyIdStorageKey),
      isNull,
    );
  });

  test('invalid direct activation retains B1 fail-closed behavior', () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 10),
    );
    await state.load();
    final originalId = state.activeJourneyId;

    await expectLater(
      state.activateJourney('removed-or-forged-journey'),
      throwsStateError,
    );
    expect(state.activeJourneyId, originalId);
  });

  test('legacy hidden active identity migrates to Beijing without deletion',
      () async {
    SharedPreferences.setMockInitialValues({
      AppState.activeJourneyIdStorageKey: 'shanghai-bund',
      AppState.activeJourneyNamespaceStorageKey: 'journey.shanghai/bund',
      AppState.activeJourneyVersionStorageKey:
          AppState.activeJourneyIdentityVersion,
    });
    final state = productionState(clock: () => DateTime(2026, 8, 3, 10));

    await state.load();

    expect(state.activeJourneyId, referenceJourneyRuntimeId);
    expect(state.canOpenJourney('shanghai-bund'), isFalse);
    expect(requireDailyJourneyExperience('shanghai-bund').id, 'shanghai-bund');
    final committed = await state.readCommittedCriticalPayload();
    expect(committed['activeJourneyId'], referenceJourneyRuntimeId);
  });

  test('date rollover keeps the only published Beijing Journey', () async {
    SharedPreferences.setMockInitialValues({});
    var now = DateTime(2026, 8, 3, 10);
    final state = productionState(clock: () => now);
    await state.load();

    now = DateTime(2026, 8, 4, 13);
    await state.load();

    expect(state.activeJourneyId, referenceJourneyRuntimeId);
    expect(
        state.policyAccessibleRegularJourneyIds, {referenceJourneyRuntimeId});
  });

  test('held Special Journeys stay unpublished even when locally listed',
      () async {
    SharedPreferences.setMockInitialValues({});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 13),
    );
    await state.load();

    state.unlockedSpecialJourneyIds.add('tide-letter');

    expect(state.canOpenJourney('tide-letter'), isFalse);
    await expectLater(
      state.activateJourney('tide-letter'),
      throwsA(isA<JourneyAccessDeniedException>()),
    );
  });

  test('published Special Journey wallet unlock remains unchanged', () async {
    SharedPreferences.setMockInitialValues({'wallet.gold': 3});
    final state = productionState(
      clock: () => DateTime(2026, 8, 3, 13),
    );
    await state.load();

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

  test('production never enters Paid Explorer without explicit entitlement',
      () async {
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
