import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('every published journey follows the adaptive two-paragraph route', () {
    for (final journey in dailyJourneyExperiences) {
      for (final profile in agent.allProfiles) {
        final level = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        expect(
          level.storyParagraphs,
          hasLength(2),
          reason: '${journey.id} ${profile.displayLabel}',
        );
        expect(
          level.storyAnnotations,
          hasLength(2),
          reason: '${journey.id} annotations',
        );
        expect(level.discoveries, isNotEmpty, reason: journey.id);
        expect(level.words, isNotEmpty, reason: journey.id);
        expect(
          level.words.length,
          lessThanOrEqualTo(agent.planFor(profile).maximumVocabularyCount),
          reason: '${journey.id} vocabulary maximum',
        );
      }
    }
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
