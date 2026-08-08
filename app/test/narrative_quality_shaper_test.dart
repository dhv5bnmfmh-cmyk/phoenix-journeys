import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/services/narrative_quality_shaper.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('narrative selector preserves opening, turning point, and ending', () {
    final indexes = selectNarrativeSentenceIndexesForTesting(
      const <String>[
        '清晨，旅人来到河边。',
        '他沿着石路慢慢向前走。',
        '路边的灯一盏一盏亮起。',
        '然而，河水忽然开始倒流。',
        '人群停下来望向桥下。',
        '最后，他明白这条河保存着城市的记忆。',
      ],
      maximumSentences: 4,
      maximumCharacters: 90,
    );

    expect(indexes.first, 0);
    expect(indexes, contains(3));
    expect(indexes.last, 5);
  });

  for (final profile in agent.allProfiles) {
    test('${profile.displayLabel} keeps the narrative spine of every generic journey', () {
      final storyTarget = phoenixStoryLengthTargetFor(profile);

      for (final journey in dailyJourneyExperiences) {
        if (usesDedicatedAdaptiveJourneyRuntime(journey.id)) continue;

        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final sourceSentences = splitChineseNarrativeSentences(
          journey.content.storyParagraphs.join(),
        );
        final shapedSentences = splitChineseNarrativeSentences(
          content.storyParagraphs.join(),
        );
        final storyCharacters = content.storyParagraphs.join().runes.length;

        expect(
          shapedSentences.first,
          sourceSentences.first,
          reason: '${journey.id} should preserve its opening scene',
        );
        expect(
          shapedSentences.last,
          sourceSentences.last,
          reason: '${journey.id} should preserve its closing meaning',
        );
        expect(
          content.storyParagraphs.length,
          storyTarget.paragraphCount,
          reason: '${journey.id} should keep the approved reading shape',
        );
        expect(
          content.storyAnnotations.length,
          content.storyParagraphs.length,
          reason: '${journey.id} should keep multilingual support aligned',
        );
        expect(
          content.storyAnnotations.every(
            (annotation) =>
                annotation.pinyin.trim().isNotEmpty &&
                annotation.vietnamese.trim().isNotEmpty &&
                annotation.english.trim().isNotEmpty,
          ),
          isTrue,
          reason: '${journey.id} should not produce an empty annotation',
        );
        expect(
          storyCharacters,
          inInclusiveRange(
            storyTarget.acceptedMinimumCharacters,
            storyTarget.acceptedMaximumCharacters,
          ),
          reason: '${journey.id} should meet the accepted Phoenix reading range',
        );
      }
    });
  }
}
