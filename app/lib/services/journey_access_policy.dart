enum JourneyAccessMode {
  developmentExperience,
  productionFreeExplorer,
  productionPaidExplorer,
}

enum JourneyReleaseSlot { morning, afternoon }

class DailyJourneyAssignment {
  const DailyJourneyAssignment({
    required this.morningJourneyId,
    required this.afternoonJourneyId,
  });

  final String morningJourneyId;
  final String afternoonJourneyId;

  String journeyIdFor(JourneyReleaseSlot slot) {
    return switch (slot) {
      JourneyReleaseSlot.morning => morningJourneyId,
      JourneyReleaseSlot.afternoon => afternoonJourneyId,
    };
  }

  Set<String> unlockedJourneyIds(Set<JourneyReleaseSlot> releasedSlots) {
    return releasedSlots.map(journeyIdFor).toSet();
  }
}

class JourneyAccessPolicy {
  const JourneyAccessPolicy._();

  static DailyJourneyAssignment assignDailyJourneys({
    required List<String> journeyIds,
    required String explorerSeed,
    required DateTime localDate,
  }) {
    final uniqueJourneyIds = journeyIds.toSet().toList(growable: false);
    if (uniqueJourneyIds.isEmpty) {
      throw ArgumentError.value(journeyIds, 'journeyIds', 'must not be empty');
    }
    if (explorerSeed.trim().isEmpty) {
      throw ArgumentError.value(
        explorerSeed,
        'explorerSeed',
        'must be a stable non-empty explorer identifier',
      );
    }

    final dateKey = _localDateKey(localDate);
    final morningIndex = _stableHash(
          '$explorerSeed|$dateKey|morning',
        ) %
        uniqueJourneyIds.length;

    if (uniqueJourneyIds.length == 1) {
      final onlyJourney = uniqueJourneyIds.single;
      return DailyJourneyAssignment(
        morningJourneyId: onlyJourney,
        afternoonJourneyId: onlyJourney,
      );
    }

    var afternoonIndex = _stableHash(
          '$explorerSeed|$dateKey|afternoon',
        ) %
        uniqueJourneyIds.length;
    if (afternoonIndex == morningIndex) {
      afternoonIndex = (afternoonIndex + 1) % uniqueJourneyIds.length;
    }

    return DailyJourneyAssignment(
      morningJourneyId: uniqueJourneyIds[morningIndex],
      afternoonJourneyId: uniqueJourneyIds[afternoonIndex],
    );
  }

  static Set<String> accessibleJourneyIds({
    required JourneyAccessMode mode,
    required List<String> allJourneyIds,
    DailyJourneyAssignment? freeAssignment,
    Set<JourneyReleaseSlot> releasedFreeSlots = const {},
  }) {
    return switch (mode) {
      JourneyAccessMode.developmentExperience ||
      JourneyAccessMode.productionPaidExplorer => allJourneyIds.toSet(),
      JourneyAccessMode.productionFreeExplorer =>
        (freeAssignment ?? _missingFreeAssignment())
            .unlockedJourneyIds(releasedFreeSlots),
    };
  }

  static bool canOpenJourney({
    required JourneyAccessMode mode,
    required String journeyId,
    required List<String> allJourneyIds,
    DailyJourneyAssignment? freeAssignment,
    Set<JourneyReleaseSlot> releasedFreeSlots = const {},
  }) {
    return accessibleJourneyIds(
      mode: mode,
      allJourneyIds: allJourneyIds,
      freeAssignment: freeAssignment,
      releasedFreeSlots: releasedFreeSlots,
    ).contains(journeyId);
  }

  static Never _missingFreeAssignment() {
    throw ArgumentError(
      'freeAssignment is required for productionFreeExplorer mode',
    );
  }

  static String _localDateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static int _stableHash(String value) {
    var hash = 0x811C9DC5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }
}
