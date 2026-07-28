import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  for (final profile in agent.allProfiles) {
    test('${profile.displayLabel} shapes every published journey', () {
      final plan = agent.planFor(profile);

      for (final journey in dailyJourneyExperiences) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );

        expect(
          content.storyParagraphs.length,
          plan.paragraphCount,
          reason: '${journey.id} should follow ${profile.displayLabel}',
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
          profile.band == PhoenixReadingBand.beginner ||
                  profile.band == PhoenixReadingBand.advanced ||
                  profile.band == PhoenixReadingBand.mastery
              ? 1
              : 2,
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
