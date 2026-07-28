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
  if (experience.id != 'beijing-summer-palace') {
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

  final base = switch (profile.band) {
    PhoenixReadingBand.beginner => summerPalaceBeginnerLevel,
    PhoenixReadingBand.elementary => summerPalaceElementaryLevel,
    PhoenixReadingBand.intermediate => summerPalaceIntermediateLevel,
    PhoenixReadingBand.upperIntermediate => JourneyLevelContent.fromExperience(
        experience,
      ),
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      JourneyLevelContent(
        storyParagraphs: experience.content.storyParagraphs,
        storyAnnotations: experience.storyAnnotations,
        words: experience.words,
        discoveries: experience.discoveries,
        wonderQuestion: summerPalaceChallengeLevel.wonderQuestion,
        expressQuestion: summerPalaceChallengeLevel.expressQuestion,
      ),
  };

  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: summerPalaceAdaptiveWords,
    levelCatalog: summerPalaceVocabularyLevels,
    profile: profile,
    knownWords: knownWords,
  );
  final plan = _languageLevelAgent.planFor(profile);
  final discoveryCount = switch (profile.band) {
    PhoenixReadingBand.beginner => 1,
    PhoenixReadingBand.elementary ||
    PhoenixReadingBand.intermediate ||
    PhoenixReadingBand.upperIntermediate ||
    PhoenixReadingBand.advanced ||
    PhoenixReadingBand.mastery => 2,
  };

  final limited = JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: selectedWords,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  ).withReadingLimit(
    paragraphCount: plan.paragraphCount,
    discoveryCount: discoveryCount,
  );

  if (!profile.isPhoenix) return limited;
  return expandJourneyStoryToTarget(
    experience,
    limited,
    profile: profile,
  );
}
