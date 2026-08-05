import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../services/journey_story_length_expander.dart';
import '../services/narrative_quality_shaper.dart';
import '../services/special_journey_story_length_expander.dart';
import 'all_journey_language_level_catalog.dart';
import 'daily_journey_experience.dart';
import 'journey_level_catalog.dart';
import 'summer_palace_adaptive_story_levels.dart';
import 'summer_palace_language_level_catalog.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();
const _specialJourneyIds = <String>{
  'literary-roaming',
  'myth-tracing',
  'strange-night-talks',
  'folk-secret-land',
};

JourneyLevelContent resolveAdaptiveJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (experience.id == 'beijing-summer-palace') {
    return _resolveSummerPalaceN1Level(
      profile: profile,
      knownWords: knownWords,
    );
  }
  return resolveSharedAdaptiveJourneyLevel(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
}

/// The unchanged shared pipeline used by every Journey except the isolated
/// Beijing Summer Palace Pilot N1. Tests compare this helper with the public
/// resolver for the other 35 Journeys to prove byte-for-byte output equality.
JourneyLevelContent resolveSharedAdaptiveJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final content = buildAdaptiveLevelForJourney(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
  final refined = refineAdaptiveNarrativeQuality(
    experience,
    content,
    profile: profile,
  );
  if (!profile.isPhoenix) return refined;
  if (_specialJourneyIds.contains(experience.id)) {
    return expandSpecialJourneyStoryToTarget(
      experience.id,
      refined,
      profile: profile,
    );
  }
  return expandJourneyStoryToTarget(
    experience,
    refined,
    profile: profile,
  );
}

/// Reconstructs the pre-remediation generic path for regression evidence.
/// Production never calls this helper. It proves why Pilot N1 must remain
/// isolated from shared tourist enrichment.
JourneyLevelContent resolveLegacySummerPalaceGenericExpansionForTesting(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final content = buildAdaptiveLevelForJourney(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
  final refined = refineAdaptiveNarrativeQuality(
    experience,
    content,
    profile: profile,
  );
  return expandJourneyStoryToTarget(
    experience,
    refined,
    profile: profile,
  );
}

JourneyLevelContent _resolveSummerPalaceN1Level({
  required ChineseProficiencyProfile profile,
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _legacySummerPalaceLevel(profile.band);
  final plan = _languageLevelAgent.planFor(profile);
  final base = summerPalaceN1LevelForPhoenixLevel(level).withReadingLimit(
    paragraphCount: plan.paragraphCount,
    discoveryCount: _summerPalaceN1DiscoveryCount(profile.band),
  );
  final context = <String>[
    ...base.storyParagraphs,
    ...base.discoveries.map((entry) => entry.text),
  ].join();
  final contextWords = summerPalaceAdaptiveWords
      .where((entry) => context.contains(entry.word))
      .toList(growable: false);
  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: contextWords,
    levelCatalog: summerPalaceVocabularyLevels,
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: selectedWords,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

int _summerPalaceN1DiscoveryCount(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary ||
      PhoenixReadingBand.intermediate => 2,
      PhoenixReadingBand.upperIntermediate ||
      PhoenixReadingBand.advanced ||
      PhoenixReadingBand.mastery => 2,
    };

int _legacySummerPalaceLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
