import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/xian_city_wall_one_pass.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('profile three-city level resolution and Xi\'an Pinyin duplication', () {
    final journeys = <String>[
      'beijing-forbidden-city',
      'shanghai-bund',
      'xian-city-wall',
    ];

    resetXianLevelPerformanceProfile();
    for (final level in <int>[5, 6, 7, 6, 5]) {
      final profile = agent.allProfiles[level - 1];
      for (final journeyId in journeys) {
        final experience = dailyJourneyExperiences.firstWhere(
          (journey) => journey.id == journeyId,
        );
        final stopwatch = Stopwatch()..start();
        final content = resolveAdaptiveJourneyLevel(
          experience,
          profile: profile,
        );
        stopwatch.stop();
        print(
          'LEVEL_RESOLVE city=$journeyId level=$level '
          'micros=${stopwatch.elapsedMicroseconds} '
          'paragraphs=${content.storyParagraphs.length} '
          'words=${content.words.length}',
        );
      }
    }

    final snapshot = xianLevelPerformanceProfileSnapshot();
    print('XIAN_PINYIN_PROFILE $snapshot');
    expect(snapshot['pinyinCalls'], greaterThan(0));
    expect(snapshot['duplicateCalls'], greaterThan(0));
  });
}
