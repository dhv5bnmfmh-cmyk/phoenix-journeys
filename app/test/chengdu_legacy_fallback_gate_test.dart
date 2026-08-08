import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('legacy static Chengdu catalog no longer exposes tourist Story', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    final story = experience.content.storyParagraphs.join();
    expect(story, contains('林夏'));
    expect(story, contains('商业活动'));
    expect(story, contains('仍在使用'));
    expect(story, isNot(contains('午后，你走进成都宽窄巷子')));
    expect(story, isNot(contains('慢生活')));
  });

  test('legacy difficulty resolver maps Chengdu to canonical Gold levels', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    final easy = resolveJourneyLevel(experience, JourneyDifficulty.easy);
    final standard = resolveJourneyLevel(experience, JourneyDifficulty.standard);
    final challenge = resolveJourneyLevel(experience, JourneyDifficulty.challenge);
    expect(identical(easy.storyParagraphs, chengduKuanzhaiOnePassLevels[0].storyParagraphs), isTrue);
    expect(identical(standard.storyParagraphs, chengduKuanzhaiOnePassLevels[4].storyParagraphs), isTrue);
    expect(identical(challenge.storyParagraphs, chengduKuanzhaiOnePassLevels[9].storyParagraphs), isTrue);
  });

  test('adaptive resolver cannot resurrect old Chengdu tourist prose', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      final story = resolved.storyParagraphs.join();
      expect(story, contains('林夏'));
      expect(story, isNot(contains('午后，你走进成都宽窄巷子')));
      expect(story, isNot(contains('慢生活')));
    }
  });
}
