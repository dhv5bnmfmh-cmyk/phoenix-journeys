import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  test('seven reviewed journeys rotate without repeating during one week', () {
    expect(dailyJourneyExperiences, hasLength(7));
    expect(dailyJourneyExperiences.map((item) => item.id).toSet(), hasLength(7));

    final week = List.generate(
      7,
      (index) => dailyJourneyForDate(DateTime(2026, 1, 1 + index)).id,
    );
    expect(week.toSet(), hasLength(7));
  });

  test('every journey has complete story and learning content', () {
    for (final journey in dailyJourneyExperiences) {
      expect(journey.content.storyParagraphs.length, 4, reason: journey.id);
      expect(
        journey.storyAnnotations.length,
        journey.content.storyParagraphs.length,
        reason: journey.id,
      );
      expect(journey.words.length, greaterThanOrEqualTo(9), reason: journey.id);
      expect(
        journey.discoveries.length,
        greaterThanOrEqualTo(4),
        reason: journey.id,
      );
      expect(journey.wonderQuestion.trim(), isNotEmpty, reason: journey.id);
      expect(journey.expressQuestion.trim(), isNotEmpty, reason: journey.id);
    }
  });

  test('all published records use verified source ids', () {
    final sourceIds = dailyStorySources.map((item) => item.id).toSet();
    for (final record in dailyJourneyRecords) {
      expect(record.sourceIds, isNotEmpty, reason: record.id);
      expect(sourceIds.containsAll(record.sourceIds), isTrue, reason: record.id);
    }
  });
}
