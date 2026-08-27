import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

int? _goldDiscoveryCount(String journeyId, int phoenixLevel) =>
    canonicalDiscoveryDepthForJourney(journeyId, phoenixLevel);

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('every regular and special journey stays within its approved reading shape', () {
    for (final journey in allJourneyExperiences) {
      final standard = resolveJourneyLevel(
        journey,
        JourneyDifficulty.standard,
      );
      expect(
        standard.storyParagraphs.length,
        inInclusiveRange(1, 2),
        reason: '${journey.id} standard story',
      );
      expect(
        standard.discoveries.length,
        _goldDiscoveryCount(journey.id, 5) != null
            ? inInclusiveRange(2, 3)
            : inInclusiveRange(1, 2),
        reason: '${journey.id} standard discoveries',
      );

      for (final profile in levelAgent.allProfiles) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        expect(
          content.storyParagraphs.length,
          inInclusiveRange(1, 2),
          reason: '${journey.id} ${profile.displayLabel} story',
        );
        final goldDepth = _goldDiscoveryCount(
          journey.id,
          profile.phoenixLevel!,
        );
        expect(
          content.discoveries.length,
          goldDepth ?? inInclusiveRange(1, 2),
          reason: '${journey.id} ${profile.displayLabel} discoveries',
        );
        expect(
          content.storyAnnotations.length,
          content.storyParagraphs.length,
          reason: '${journey.id} keeps story support aligned',
        );
      }
    }
  });

  test('generic level controls one long block or two shorter blocks', () {
    final journey = allJourneyExperiences.firstWhere(
      (journey) => usesSharedGenericAdaptivePipeline(journey.id),
    );

    for (final profile in levelAgent.allProfiles) {
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
      );
      final storyTarget = phoenixStoryLengthTargetFor(profile);
      final expectedDiscoveryCount =
          profile.band == PhoenixReadingBand.beginner ||
                  profile.band == PhoenixReadingBand.advanced ||
                  profile.band == PhoenixReadingBand.mastery
              ? 1
              : 2;

      expect(content.storyParagraphs.length, storyTarget.paragraphCount);
      expect(content.discoveries.length, expectedDiscoveryCount);
      expect(
        content.storyParagraphs.join().runes.length,
        inInclusiveRange(
          storyTarget.acceptedMinimumCharacters,
          storyTarget.acceptedMaximumCharacters,
        ),
      );
    }
  });

  test('story and discovery retain separate purposes', () {
    for (final journey in allJourneyExperiences) {
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: PhoenixLanguageLevelAgent.hskProfiles[2],
      );
      final story = content.storyParagraphs.join();
      for (final discovery in content.discoveries) {
        expect(
          story.contains(discovery.text),
          isFalse,
          reason: '${journey.id} must not paste Discovery into Story',
        );
      }
    }
  });

  test('repeated adaptive resolution preserves multilingual story identity', () {
    final journey = allJourneyExperiences.firstWhere(
      (journey) => usesSharedGenericAdaptivePipeline(journey.id),
    );
    final profile = PhoenixLanguageLevelAgent.hskProfiles[4];

    final first = resolveAdaptiveJourneyLevel(journey, profile: profile);
    final repeated = resolveAdaptiveJourneyLevel(journey, profile: profile);

    expect(repeated.storyParagraphs, orderedEquals(first.storyParagraphs));
    expect(
      repeated.storyAnnotations.map((annotation) => annotation.pinyin),
      orderedEquals(
        first.storyAnnotations.map((annotation) => annotation.pinyin),
      ),
    );
    expect(
      repeated.storyAnnotations.map((annotation) => annotation.vietnamese),
      orderedEquals(
        first.storyAnnotations.map((annotation) => annotation.vietnamese),
      ),
    );
    expect(
      repeated.storyAnnotations.map((annotation) => annotation.english),
      orderedEquals(
        first.storyAnnotations.map((annotation) => annotation.english),
      ),
    );
  });
}
