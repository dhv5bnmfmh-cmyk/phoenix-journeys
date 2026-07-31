import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/missing_dynamic_background_styles.dart';

void main() {
  test('five new ordinary journeys are synchronized across all functions', () {
    const ids = <String>[
      'wuyishan-nine-bend-stream',
      'pingyao-ancient-city',
      'kaiping-diaolou-villages',
      'yuanyang-hani-rice-terraces',
      'wudang-mountains-ancient-buildings',
    ];
    for (final id in ids) {
      final journey = requireDailyJourneyExperience(id);
      expect(journey.id, id);
      expect(journey.content.sections, hasLength(4));
      expect(journey.storyAnnotations, hasLength(4));
      expect(journey.words.length, greaterThanOrEqualTo(9));
      expect(journey.discoveries.length, greaterThanOrEqualTo(4));
      expect(journey.stampSymbol, isNotEmpty);
      expect(dailyJourneyRecords.any((item) => item.id == id), isTrue);
      expect(dailyJourneyExperiences.any((item) => item.id == id), isTrue);
      expect(missingJourneyCinematicStyles.containsKey(id), isTrue);
    }
  });

  test('daily rotation includes every batch seven journey', () {
    final rotated = List.generate(
      dailyJourneyExperiences.length,
      (index) => dailyJourneyForDate(DateTime(2026, 1, 1 + index)).id,
    ).toSet();
    expect(rotated, containsAll(<String>[
      'wuyishan-nine-bend-stream',
      'pingyao-ancient-city',
      'kaiping-diaolou-villages',
      'yuanyang-hani-rice-terraces',
      'wudang-mountains-ancient-buildings',
    ]));
  });
}
