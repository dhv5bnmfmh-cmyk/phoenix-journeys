import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../services/journey_story_length_expander.dart';
import '../services/narrative_quality_shaper.dart';
import '../services/phoenix_story_length_policy.dart';
import '../services/special_journey_story_length_expander.dart';
import 'all_journey_language_level_catalog.dart';
import 'batch_one_adaptive_story_levels.dart';
import 'daily_journey_experience.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';
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
  if (experience.id == forbiddenCityJourneyId) {
    return _resolveForbiddenCityAdaptiveLevel(
      profile,
      knownWords: knownWords,
    );
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
  return resolveSharedAdaptiveJourneyLevel(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
}

JourneyLevelContent _resolveForbiddenCityAdaptiveLevel(
  ChineseProficiencyProfile profile, {
  required Set<String> knownWords,
}) {
  final level = profile.phoenixLevel ?? _legacyForbiddenCityLevel(profile.band);
  final base = _normalizeForbiddenCityReadingSupport(
    forbiddenCityLevelContent(level),
    level,
  );
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

JourneyLevelContent _normalizeForbiddenCityReadingSupport(
  JourneyLevelContent base,
  int level,
) {
  if (level != 8 && level != 10) return base;
  final annotations = List<ReadingAnnotation>.of(base.storyAnnotations);
  final index = annotations.length - 1;
  final current = annotations[index];
  annotations[index] = ReadingAnnotation(
    pinyin: current.pinyin,
    vietnamese: level == 8
        ? 'Cậu nhận ra việc bước qua chỉ để lấp đầy bản đồ có thể biến “hiểu” thành “chiếm hữu”, nên giữ lại khoảng trống như một phần của hiểu biết lịch sử.'
        : 'Khi cánh cổng mở, cậu từ chối biến khả năng thành quyền chiếm hữu, để “giới”, bản đồ thứ hai và chiếc thước gỗ cũ trở thành dấu mốc của cách nhìn mới.',
    english: current.english,
  );
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: base.words,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

int _legacyForbiddenCityLevel(PhoenixReadingBand band) => switch (band) {
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
  return expandJourneyStoryToTarget(
    experience,
    refined,
    profile: profile,
  );
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
  final target = phoenixStoryLengthTargetFor(profile);
  final plan = _languageLevelAgent.planFor(profile);
  final base = summerPalaceN1LevelForPhoenixLevel(level).withReadingLimit(
    paragraphCount:
        profile.isPhoenix ? target.paragraphCount : plan.paragraphCount,
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
