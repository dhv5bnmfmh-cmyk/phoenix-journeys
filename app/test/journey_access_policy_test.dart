import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/services/journey_access_policy.dart';

void main() {
  const journeys = <String>[
    'beijing-forbidden-city',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
  ];

  test('development experience keeps every journey open', () {
    final accessible = JourneyAccessPolicy.accessibleJourneyIds(
      mode: JourneyAccessMode.developmentExperience,
      allJourneyIds: journeys,
    );

    expect(accessible, journeys.toSet());
  });

  test('paid explorers can open every journey', () {
    final accessible = JourneyAccessPolicy.accessibleJourneyIds(
      mode: JourneyAccessMode.productionPaidExplorer,
      allJourneyIds: journeys,
    );

    expect(accessible, journeys.toSet());
  });

  test('free assignment is stable for one explorer, date, and slot', () {
    final first = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: journeys,
      explorerSeed: 'explorer-001',
      localDate: DateTime(2026, 7, 21, 8),
    );
    final refreshed = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: journeys,
      explorerSeed: 'explorer-001',
      localDate: DateTime(2026, 7, 21, 17),
    );

    expect(refreshed.morningJourneyId, first.morningJourneyId);
    expect(refreshed.afternoonJourneyId, first.afternoonJourneyId);
    expect(first.morningJourneyId, isNot(first.afternoonJourneyId));
  });

  test('free explorers receive one morning and one afternoon journey', () {
    final assignment = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: journeys,
      explorerSeed: 'explorer-002',
      localDate: DateTime(2026, 7, 21),
    );

    final morningAccess = JourneyAccessPolicy.accessibleJourneyIds(
      mode: JourneyAccessMode.productionFreeExplorer,
      allJourneyIds: journeys,
      freeAssignment: assignment,
      releasedFreeSlots: const {JourneyReleaseSlot.morning},
    );
    final fullDayAccess = JourneyAccessPolicy.accessibleJourneyIds(
      mode: JourneyAccessMode.productionFreeExplorer,
      allJourneyIds: journeys,
      freeAssignment: assignment,
      releasedFreeSlots: const {
        JourneyReleaseSlot.morning,
        JourneyReleaseSlot.afternoon,
      },
    );

    expect(morningAccess, {assignment.morningJourneyId});
    expect(fullDayAccess, {
      assignment.morningJourneyId,
      assignment.afternoonJourneyId,
    });
  });

  test('free explorers cannot open an unreleased journey', () {
    final assignment = JourneyAccessPolicy.assignDailyJourneys(
      journeyIds: journeys,
      explorerSeed: 'explorer-003',
      localDate: DateTime(2026, 7, 21),
    );
    final lockedJourney = journeys.firstWhere(
      (id) =>
          id != assignment.morningJourneyId &&
          id != assignment.afternoonJourneyId,
    );

    expect(
      JourneyAccessPolicy.canOpenJourney(
        mode: JourneyAccessMode.productionFreeExplorer,
        journeyId: lockedJourney,
        allJourneyIds: journeys,
        freeAssignment: assignment,
        releasedFreeSlots: const {
          JourneyReleaseSlot.morning,
          JourneyReleaseSlot.afternoon,
        },
      ),
      isFalse,
    );
  });
}
