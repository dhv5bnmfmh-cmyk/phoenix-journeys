import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  test('five new journeys are synchronized across the full experience', () {
    const ids = <String>[
      'dunhuang-mogao-caves',
      'suzhou-classical-gardens',
      'quanzhou-maritime-emporium',
      'lhasa-potala-palace',
      'luoyang-longmen-grottoes',
    ];
    for (final id in ids) {
      final journey = requireDailyJourneyExperience(id);
      expect(journey.id, id);
      expect(journey.content.sections.length, greaterThanOrEqualTo(4));
      expect(journey.storyAnnotations.length, journey.content.sections.length);
      expect(journey.words.length, greaterThanOrEqualTo(8));
      expect(journey.discoveries.length, greaterThanOrEqualTo(4));
      expect(journey.stampSymbol, isNotEmpty);
      expect(dailyJourneyExperiences.any((item) => item.id == id), isTrue);
      expect(dailyJourneyRecords.any((item) => item.id == id), isTrue);
    }
  });
}
