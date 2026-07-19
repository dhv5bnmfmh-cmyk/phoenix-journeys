import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/world_story_runtime.dart';

void main() {
  test('the same calendar day always returns the same journey', () {
    final morning = dailyJourneyForDate(DateTime(2026, 7, 20, 8));
    final evening = dailyJourneyForDate(DateTime(2026, 7, 20, 22));

    expect(morning.id, evening.id);
  });

  test('three consecutive days rotate through three different journeys', () {
    final ids = <String>{
      dailyJourneyForDate(DateTime(2026, 7, 20)).id,
      dailyJourneyForDate(DateTime(2026, 7, 21)).id,
      dailyJourneyForDate(DateTime(2026, 7, 22)).id,
    };

    expect(ids, hasLength(3));
  });

  test('all daily journeys pass publication checks', () {
    final agent = createPhoenixWorldStoryAgent();

    for (final journey in dailyJourneyExperiences) {
      expect(
        agent.publicationIssues(journey.id),
        isEmpty,
        reason: journey.id,
      );
      expect(journey.storyAnnotations.length, journey.content.sections.length);
      expect(journey.words.length, greaterThanOrEqualTo(9));
      expect(journey.discoveries.length, 4);
    }
  });
}
