import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/summer_palace_language_level_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();
  final journey = requireDailyJourneyExperience('beijing-summer-palace');

  test('keeps HSK and TOCFL as independent profile tracks', () {
    expect(agent.profilesFor(ChineseExamTrack.hsk), hasLength(7));
    expect(agent.profilesFor(ChineseExamTrack.tocfl), hasLength(7));
    expect(
      agent.profileFromStorage('hsk:6')?.displayLabel,
      'HSK 6',
    );
    expect(
      agent.profileFromStorage('tocfl:5')?.displayLabel,
      'TOCFL Level 5',
    );
  });

  test('raises reading load gradually by Phoenix reading band', () {
    final plans = agent.allProfiles
        .map(agent.planFor)
        .toList(growable: false);

    expect(plans.first.targetVocabularyCount, 4);
    expect(
      plans.map((plan) => plan.targetVocabularyCount).toSet(),
      containsAll(<int>{4, 6, 9, 11, 14, 16}),
    );
    expect(
      agent.planFor(agent.profilesFor(ChineseExamTrack.tocfl).last)
          .maximumVocabularyCount,
      20,
    );
  });

  test('TOCFL Level 5 receives two focused advanced discoveries', () {
    final profile = agent.profilesFor(ChineseExamTrack.tocfl).firstWhere(
          (item) => item.levelCode == '5',
        );
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );

    expect(content.storyParagraphs, hasLength(1));
    expect(content.storyAnnotations, hasLength(1));
    expect(content.discoveries, hasLength(2));
    expect(content.words, hasLength(14));

    final issues = agent.validateJourney(
      paragraphs: content.storyParagraphs,
      vocabulary: content.words,
      profile: profile,
      sourceText: content.discoveries.map((entry) => entry.text).join(),
    );
    expect(issues, isEmpty);
  });

  test('TOCFL Level 6 can receive all 16 curated focus words', () {
    final profile = agent.profilesFor(ChineseExamTrack.tocfl).last;
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );

    expect(content.words, hasLength(16));
    expect(
      content.words.map((entry) => entry.word).toSet(),
      summerPalaceAdaptiveWords.map((entry) => entry.word).toSet(),
    );
  });

  test('reading shape follows the Phoenix level policy', () {
    for (final profile in agent.allProfiles) {
      final content = resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
      );
      final storyTarget = phoenixStoryLengthTargetFor(profile);
      final expectedDiscoveryCount =
          profile.band == PhoenixReadingBand.beginner ? 1 : 2;

      expect(
        content.storyParagraphs,
        hasLength(storyTarget.paragraphCount),
        reason: profile.displayLabel,
      );
      expect(
        content.storyAnnotations,
        hasLength(storyTarget.paragraphCount),
        reason: profile.displayLabel,
      );
      expect(
        content.storyParagraphs.join().runes.length,
        inInclusiveRange(
          storyTarget.minimumCharacters,
          storyTarget.maximumCharacters,
        ),
        reason: profile.displayLabel,
      );
      expect(
        content.discoveries,
        hasLength(expectedDiscoveryCount),
        reason: profile.displayLabel,
      );
      expect(
        content.words.length,
        agent.planFor(profile).targetVocabularyCount,
        reason: profile.displayLabel,
      );
    }
  });
}
