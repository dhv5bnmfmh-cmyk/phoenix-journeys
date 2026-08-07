import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  for (final profile in agent.allProfiles) {
    test('${profile.displayLabel} shapes every published journey', () {
      final plan = agent.planFor(profile);
      final storyTarget = phoenixStoryLengthTargetFor(profile);

      for (final journey in dailyJourneyExperiences) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );

        if (journey.id == forbiddenCityJourneyId) {
          final level = profile.phoenixLevel!;
          final story = forbiddenCityLockedStories[level - 1];
          expect(
            content.storyParagraphs,
            orderedEquals(<String>[story]),
            reason: 'Forbidden City ${profile.displayLabel} must use its locked runtime Story',
          );
          expect(content.words, isNotEmpty);
          expect(
            content.words.every((word) => story.contains(word.word)),
            isTrue,
            reason: 'Forbidden City Words must exist in the selected Story',
          );
          expect(content.discoveries.length, inInclusiveRange(1, 2));
          continue;
        }

        final storyCharacters = content.storyParagraphs.join().runes.length;
        expect(
          content.storyParagraphs.length,
          storyTarget.paragraphCount,
          reason: '${journey.id} should follow ${profile.displayLabel}',
        );
        expect(
          storyCharacters,
          inInclusiveRange(
            storyTarget.minimumCharacters,
            storyTarget.maximumCharacters,
          ),
          reason: '${journey.id} should meet the ${profile.displayLabel} '
              'story range, but produced $storyCharacters characters',
        );
        expect(
          content.storyAnnotations.length,
          content.storyParagraphs.length,
          reason: '${journey.id} should keep reading support aligned',
        );
        expect(
          content.storyParagraphs.every(
            (paragraph) => paragraph.trim().isNotEmpty,
          ),
          isTrue,
          reason: '${journey.id} should not produce an empty story paragraph',
        );
        expect(
          content.storyAnnotations.every(
            (annotation) =>
                annotation.pinyin.trim().isNotEmpty &&
                annotation.vietnamese.trim().isNotEmpty &&
                annotation.english.trim().isNotEmpty,
          ),
          isTrue,
          reason: '${journey.id} should preserve multilingual reading support',
        );
        expect(
          content.discoveries.length,
          profile.band == PhoenixReadingBand.beginner
              ? 1
              : inInclusiveRange(1, 2),
          reason: '${journey.id} should use the approved discovery shape',
        );
        expect(
          content.words.length,
          lessThanOrEqualTo(plan.maximumVocabularyCount),
          reason: '${journey.id} should respect the vocabulary ceiling',
        );
      }
    });
  }

  test('Phoenix exposes exactly ten fused levels', () {
    expect(agent.allProfiles, hasLength(10));
    expect(
      agent.allProfiles.map((item) => item.phoenixLevel),
      orderedEquals(List<int>.generate(10, (index) => index + 1)),
    );
    expect(
      agent.allProfiles.map((item) => item.storageValue).toSet(),
      hasLength(10),
    );
  });

  test('legacy HSK and TOCFL profiles remain available for migration', () {
    expect(agent.profilesFor(ChineseExamTrack.hsk), isNotEmpty);
    expect(agent.profilesFor(ChineseExamTrack.tocfl), isNotEmpty);
    expect(agent.phoenixLevelFromStorage('hsk:6'), 8);
    expect(agent.phoenixLevelFromStorage('tocfl:4'), 7);
  });
}
