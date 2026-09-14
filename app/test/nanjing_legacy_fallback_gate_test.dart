import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_one_pass.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('legacy Nanjing compatibility prose is not the adaptive canonical Story', () {
    final experience = requireDailyJourneyExperience(nanjingQinhuaiJourneyId);
    expect(
      usesDedicatedAdaptiveJourneyRuntime(nanjingQinhuaiJourneyId),
      isTrue,
    );
    expect(
      usesSharedGenericAdaptivePipeline(nanjingQinhuaiJourneyId),
      isFalse,
    );

    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      final story = resolved.storyParagraphs.join();
      expect(story, contains('魏舟'));
      expect(story, contains('秦淮灯会'));
      expect(story, contains('装饰灯'));
      expect(story, isNot(contains(nanjingQinhuaiLegacyOpening)));
      expect(story, isNot(contains('金陵小吃')));
      expect(story, isNot(contains('曲艺')));
      expect(
        identical(
          resolved.storyParagraphs,
          nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs,
        ),
        isTrue,
      );
    }
  });

  test('canonical package contains no second-person tourism opening', () {
    final canonical = nanjingQinhuaiOnePassLevels
        .expand((level) => level.storyParagraphs)
        .join('\n');
    expect(canonical, isNot(contains(nanjingQinhuaiLegacyOpening)));
    expect(canonical, isNot(contains('你沿着秦淮河')));
    expect(canonical, isNot(contains('你走向夫子庙')));
  });
}
