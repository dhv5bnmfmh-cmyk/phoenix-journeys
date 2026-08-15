import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/quanzhou_kaiyuan_gold_content.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('Quanzhou Lv8 keeps the repaired hinge without repeating the relationship explanation', () {
    final quanzhou = dailyJourneyExperiences.singleWhere(
      (journey) => journey.id == quanzhouKaiyuanJourneyId,
    );
    final content = resolveAdaptiveJourneyLevel(
      quanzhou,
      profile: agent.profileForPhoenixLevel(8),
    );
    final story = content.storyParagraphs.join();
    final target = phoenixStoryLengthTargetForLevel(8);
    final length = story.runes.length;

    expect(
      length,
      inInclusiveRange(
        target.acceptedMinimumCharacters,
        target.acceptedMaximumCharacters,
      ),
      reason: 'Lv8 should stay inside the canonical accepted reading range',
    );
    expect(story, contains('你敲，我就开'));
    expect(story, contains('同一条西街'));
    expect(story, isNot(contains('姐弟可以继续，不必靠空房作保证')));
  });
}
