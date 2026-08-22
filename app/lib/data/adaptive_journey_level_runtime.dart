import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../services/journey_story_length_expander.dart';
import '../services/narrative_quality_shaper.dart';
import '../services/phoenix_story_length_policy.dart';
import '../services/special_journey_story_length_expander.dart';
import 'all_journey_language_level_catalog.dart';
import 'batch_one_adaptive_story_levels.dart';
import 'daily_journey_experience.dart';
import 'dedicated_adaptive_journey_catalog.dart';
import 'forbidden_city_content_cache.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_level_catalog.dart';
import 'guangzhou_chen_clan_one_pass.dart';
import 'journey_expansion_catalog.dart';
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
  if (!usesDedicatedAdaptiveJourneyRuntime(experience.id)) {
    return resolveSharedAdaptiveJourneyLevel(
      experience,
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == forbiddenCityJourneyId) {
    return _resolveForbiddenCityAdaptiveLevel(profile, knownWords: knownWords);
  }
  if (isBatchOneGoldJourney(experience.id)) {
    return buildBatchOneGoldLevel(
      experience,
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == 'beijing-summer-palace') {
    return _resolveSummerPalaceN1Level(
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == guangzhouChenClanJourneyId) {
    return guangzhouChenClanOnePassLevelContent(
      profile.phoenixLevel ?? _levelForBand(profile.band),
      profile: profile,
      knownWords: knownWords,
    );
  }
  if (experience.id == 'suzhou-humble-administrators-garden') {
    return suzhouGardenCanonicalLevelContent(
      profile.phoenixLevel ?? _levelForBand(profile.band),
      profile: profile,
      knownWords: knownWords,
    );
  }
  throw StateError(
    'Dedicated adaptive Journey has no registered resolver: ${experience.id}',
  );
}

JourneyLevelContent _resolveForbiddenCityAdaptiveLevel(
  ChineseProficiencyProfile profile, {
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _levelForBand(profile.band);
  final base = cachedForbiddenCityLevelContent(level);
  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: unseenWords.isEmpty ? base.words : unseenWords,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

int _levelForBand(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 9,
      PhoenixReadingBand.mastery => 10,
    };

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
  return expandJourneyStoryToTarget(experience, refined, profile: profile);
}

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
  return expandJourneyStoryToTarget(experience, refined, profile: profile);
}

JourneyLevelContent _resolveSummerPalaceN1Level({
  required ChineseProficiencyProfile profile,
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _legacySummerPalaceLevel(profile.band);
  final target = phoenixStoryLengthTargetFor(profile);
  final plan = _languageLevelAgent.planFor(profile);
  final source = summerPalaceN1LevelForPhoenixLevel(level);
  final limited = source.withReadingLimit(
    paragraphCount:
        profile.isPhoenix ? target.paragraphCount : plan.paragraphCount,
  );
  final base = JourneyLevelContent(
    storyParagraphs: limited.storyParagraphs,
    storyAnnotations: limited.storyAnnotations,
    words: source.words,
    discoveries: source.discoveries,
    wonderQuestion: source.wonderQuestion,
    expressQuestion: source.expressQuestion,
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

int _legacySummerPalaceLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
