import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  test('five new ordinary journeys are synchronized across core features', () {
    const ids = <String>[
      'dujiangyan-irrigation-system',
      'chongqing-dazu-rock-carvings',
      'shiyan-wudang-mountains',
      'longyan-fujian-tulou',
      'shenyang-imperial-palace',
    ];
    final sourceIds = dailyStorySources.map((source) => source.id).toSet();

    for (final id in ids) {
      final journey = requireDailyJourneyExperience(id);
      final location = requireJourneyLocation(id);

      expect(journey.id, id);
      expect(journey.content.sections, hasLength(4));
      expect(journey.storyAnnotations, hasLength(4));
      expect(journey.words.length, greaterThanOrEqualTo(9));
      expect(journey.discoveries.length, greaterThanOrEqualTo(4));
      expect(journey.stampSymbol, isNotEmpty);
      expect(journey.stampTitle, contains(journey.city));
      expect(journey.wonderQuestion, isNotEmpty);
      expect(journey.expressQuestion, isNotEmpty);
      expect(dailyJourneyRecords.any((record) => record.id == id), isTrue);
      expect(dailyJourneyExperiences.any((item) => item.id == id), isTrue);
      expect(allJourneyExperiences.any((item) => item.id == id), isTrue);
      expect(journeyLocationBindings.containsKey(id), isTrue);
      expect(location.geoNodeId, journey.content.geoNodeId);
      expect(location.geoPath.last.id, journey.content.geoNodeId);
      expect(location.mapPoint.x, inInclusiveRange(0.38, 0.88));
      expect(location.mapPoint.y, inInclusiveRange(0.28, 0.72));
      expect(
        journey.content.sections
            .expand((section) => section.sourceIds)
            .every(sourceIds.contains),
        isTrue,
      );
      expect(
        journey.words.every(
          (word) => allDailyJourneyWords.any((entry) => entry.word == word.word),
        ),
        isTrue,
      );
    }
  });
}
