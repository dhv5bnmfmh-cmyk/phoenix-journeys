import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('legacy static Chengdu catalog exposes canonical handoff Story, not tourist or survey prose', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    final story = experience.content.storyParagraphs.join();
    expect(story, contains('林夏'));
    expect(story, contains('周叔'));
    expect(story, contains('竹椅'));
    expect(story, contains('院落'));
    expect(story, contains('通行'));
    expect(story, isNot(contains('午后，你走进成都宽窄巷子')));
    expect(story, isNot(contains('慢生活')));
    expect(story, isNot(contains('调查表')));
    expect(story, isNot(contains('商业活动')));
    expect(story, isNot(contains('仍在使用')));
  });

  test('published Chengdu adapter binds exact Gold Lv5 and complete Discovery', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    expect(experience.content.storyParagraphs, chengduKuanzhaiOnePassLevels[4].storyParagraphs);
    expect(experience.storyAnnotations, chengduKuanzhaiOnePassLevels[4].storyAnnotations);
    expect(experience.discoveries, chengduKuanzhaiOnePassDiscoveries);
    expect(experience.words.length, greaterThanOrEqualTo(9));

    final publishedContext = <String>[
      ...experience.content.storyParagraphs,
      ...experience.discoveries.map((entry) => entry.text),
    ].join();
    for (final word in experience.words) {
      expect(
        publishedContext,
        contains(word.word),
        reason: 'Published Chengdu Word lacks Story/Discovery context: ${word.word}',
      );
    }
  });

  test('legacy difficulty resolver maps Chengdu to canonical handoff Gold levels', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    final easy = resolveJourneyLevel(experience, JourneyDifficulty.easy);
    final standard = resolveJourneyLevel(experience, JourneyDifficulty.standard);
    final challenge = resolveJourneyLevel(experience, JourneyDifficulty.challenge);
    expect(identical(easy.storyParagraphs, chengduKuanzhaiOnePassLevels[0].storyParagraphs), isTrue);
    expect(identical(standard.storyParagraphs, chengduKuanzhaiOnePassLevels[4].storyParagraphs), isTrue);
    expect(identical(challenge.storyParagraphs, chengduKuanzhaiOnePassLevels[9].storyParagraphs), isTrue);
  });

  test('adaptive resolver cannot resurrect old Chengdu tourist or survey prose', () {
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      final story = resolved.storyParagraphs.join();
      expect(story, contains('林夏'));
      expect(story, contains('竹椅'));
      expect(story, isNot(contains('午后，你走进成都宽窄巷子')));
      expect(story, isNot(contains('慢生活')));
      expect(story, isNot(contains('调查表')));
      expect(story, isNot(contains('仍在使用')));
    }
  });
}
