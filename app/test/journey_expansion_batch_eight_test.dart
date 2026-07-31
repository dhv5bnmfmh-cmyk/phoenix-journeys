import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/missing_dynamic_background_styles.dart';

void main() {
  test('batch eight journeys are synchronized across all core features', () {
    const ids = <String>[
      'taishan-sacred-mountain',
      'lushan-cultural-landscape',
      'emeishan-sacred-ecology',
      'hangzhou-west-lake',
      'xiamen-gulangyu',
    ];

    for (final id in ids) {
      final journey = requireDailyJourneyExperience(id);
      expect(journey.id, id);
      expect(journey.content.sections, hasLength(4));
      expect(journey.storyAnnotations, hasLength(4));
      expect(journey.words.length, greaterThanOrEqualTo(9));
      expect(journey.discoveries.length, greaterThanOrEqualTo(4));
      expect(journey.stampSymbol, isNotEmpty);
      expect(dailyJourneyRecords.any((record) => record.id == id), isTrue);
      expect(dailyJourneyExperiences.any((item) => item.id == id), isTrue);
      expect(missingJourneyCinematicStyles.containsKey(id), isTrue);
    }
  });
}
