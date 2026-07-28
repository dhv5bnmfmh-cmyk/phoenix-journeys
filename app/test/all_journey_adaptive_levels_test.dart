import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('every published journey follows its adaptive reading shape', () {
    for (final journey in dailyJourneyExperiences) {
      for (final profile in agent.allProfiles) {
        final level = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final storyTarget = phoenixStoryLengthTargetFor(profile);
        final expectedDiscoveryShape =
            profile.band == PhoenixReadingBand.beginner
                ? hasLength(1)
                : hasLength(inInclusiveRange(1, 2));
        final storyCharacters = level.storyParagraphs.join().runes.length;

        expect(
          level.storyParagraphs,
          hasLength(storyTarget.paragraphCount),
          reason: '${journey.id} ${profile.displayLabel}',
        );
        expect(
          level.storyAnnotations,
          hasLength(storyTarget.paragraphCount),
          reason: '${journey.id} annotations',
        );
        expect(
          storyCharacters,
          inInclusiveRange(
            storyTarget.minimumCharacters,
            storyTarget.maximumCharacters,
          ),
          reason: '${journey.id} ${profile.displayLabel} story length',
        );
        expect(
          level.discoveries,
          expectedDiscoveryShape,
          reason: '${journey.id} discoveries',
        );
        expect(level.words, isNotEmpty, reason: journey.id);
        expect(
          level.words.length,
          lessThanOrEqualTo(agent.planFor(profile).maximumVocabularyCount),
          reason: '${journey.id} vocabulary maximum',
        );
      }
    }
  });

  test('Lv.10 prompts stay specific across all twelve journeys', () {
    final mastery = agent.allProfiles.last;
    final levels = allJourneyExperiences
        .map(
          (journey) => resolveAdaptiveJourneyLevel(
            journey,
            profile: mastery,
          ),
        )
        .toList(growable: false);

    expect(allJourneyExperiences, hasLength(12));
    expect(
      levels.map((level) => level.wonderQuestion).toSet(),
      hasLength(12),
    );
    expect(
      levels.map((level) => level.expressQuestion).toSet(),
      hasLength(12),
    );
    expect(levels.every((level) => level.wonderQuestion.contains('请')), isTrue);
    expect(levels.every((level) => level.expressQuestion.contains('请')), isTrue);
  });

  test('beginner and advanced content differ on every migrated journey', () {
    final beginner = PhoenixLanguageLevelAgent.hskProfiles.first;
    final advanced = PhoenixLanguageLevelAgent.hskProfiles.firstWhere(
      (profile) => profile.band == PhoenixReadingBand.advanced,
    );

    for (final journey in dailyJourneyExperiences.where(
      (item) => item.id != 'beijing-summer-palace',
    )) {
      final easy = resolveAdaptiveJourneyLevel(journey, profile: beginner);
      final deep = resolveAdaptiveJourneyLevel(journey, profile: advanced);
      expect(easy.storyParagraphs.join(), isNot(deep.storyParagraphs.join()));
      expect(
        easy.discoveries.length,
        lessThanOrEqualTo(deep.discoveries.length),
      );
      expect(easy.words.length, lessThanOrEqualTo(deep.words.length));
    }
  });
}
