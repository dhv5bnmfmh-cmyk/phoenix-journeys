import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/luoyang_longmen_gold.dart';
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
            journey.id == luoyangLongmenGoldJourneyId
                ? hasLength(profile.phoenixLevel! <= 4 ? 2 : 3)
                : profile.band == PhoenixReadingBand.beginner
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
          level.storyAnnotations.every(
            (annotation) =>
                annotation.pinyin.trim().isNotEmpty &&
                annotation.vietnamese.trim().isNotEmpty &&
                annotation.english.trim().isNotEmpty,
          ),
          isTrue,
          reason: '${journey.id} multilingual Story support',
        );
        expect(
          storyCharacters,
          inInclusiveRange(
            storyTarget.acceptedMinimumCharacters,
            storyTarget.acceptedMaximumCharacters,
          ),
          reason: '${journey.id} ${profile.displayLabel} story length with approved ±50 character tolerance',
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

  test('Summer Palace Lv.1 through Lv.10 preserve Pilot N1 invariants', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');
    for (final profile in agent.allProfiles) {
      final level = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final story = level.storyParagraphs.join();
      expect(story, contains('许澄'), reason: profile.displayLabel);
      expect(story, contains('周岚'), reason: profile.displayLabel);
      expect(story, contains('旧照片'), reason: profile.displayLabel);
      expect(story, contains('修复'), reason: profile.displayLabel);
      expect(
        story,
        anyOf(contains('选择'), contains('先捡'), contains('放弃追光')),
        reason: profile.displayLabel,
      );
      expect(level.storyAnnotations.length, level.storyParagraphs.length);
      expect(level.wonderQuestion, isNotEmpty);
      expect(level.expressQuestion, isNotEmpty);
    }
  });

  test('Lv.10 prompts stay specific across all journeys', () {
    final mastery = agent.allProfiles.last;
    final levels = allJourneyExperiences
        .map(
          (journey) => resolveAdaptiveJourneyLevel(
            journey,
            profile: mastery,
          ),
        )
        .toList(growable: false);

    expect(allJourneyExperiences, hasLength(36));
    expect(
      levels.map((level) => level.wonderQuestion).toSet(),
      hasLength(allJourneyExperiences.length),
    );
    expect(
      levels.map((level) => level.expressQuestion).toSet(),
      hasLength(allJourneyExperiences.length),
    );
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
