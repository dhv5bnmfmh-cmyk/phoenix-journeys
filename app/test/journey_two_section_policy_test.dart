import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  test('every journey presents exactly two rich story and discovery sections', () {
    for (final journey in allJourneyExperiences) {
      final story = journey.content.storyParagraphs;
      final annotations = journey.storyAnnotations;
      final discoveries = journey.discoveries;

      expect(story.length, 2, reason: '${journey.id} story must have two sections');
      expect(
        annotations.length,
        story.length,
        reason: '${journey.id} story annotations must match story sections',
      );
      expect(
        discoveries.length,
        2,
        reason: '${journey.id} discovery must have two sections',
      );
      expect(
        story.every((paragraph) => paragraph.length >= 70),
        isTrue,
        reason: '${journey.id} story sections should remain substantial',
      );
      expect(
        discoveries.every((entry) => entry.text.length >= 70),
        isTrue,
        reason: '${journey.id} discovery sections should include facts and meaning',
      );
    }
  });
}
