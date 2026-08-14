import '../models/language_proficiency.dart';
import 'batch_one_journey_remediation.dart';
import 'chengdu_kuanzhai_one_pass.dart';
import 'daily_journey_experience.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'luoyang_longmen_level_depth.dart';
import 'luoyang_longmen_one_pass.dart';
import 'nanjing_qinhuai_one_pass.dart';
import 'nanjing_qinhuai_vocabulary_curation.dart';
import 'shanghai_bund_one_pass.dart';
import 'xian_city_wall_one_pass.dart';

bool isBatchOneGoldJourney(String journeyId) =>
    journeyId == shanghaiBundJourneyId ||
    journeyId == xianCityWallJourneyId ||
    journeyId == hangzhouWestLakeJourneyId ||
    journeyId == chengduKuanzhaiJourneyId ||
    journeyId == nanjingQinhuaiJourneyId ||
    journeyId == luoyangLongmenJourneyId;

/// Thin adaptive adapter over canonical one-pass content packages.
/// Story, Words, Discovery, Challenge, Memory, and Completion remain immutable
/// content definitions; narration/progress updates never rebuild them.
JourneyLevelContent buildBatchOneGoldLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (!isBatchOneGoldJourney(experience.id)) {
    throw ArgumentError.value(experience.id, 'experience.id');
  }
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final base = switch (experience.id) {
    xianCityWallJourneyId => xianCityWallOnePassLevelContent(level),
    hangzhouWestLakeJourneyId => hangzhouWestLakeOnePassLevelContent(level),
    chengduKuanzhaiJourneyId => chengduKuanzhaiOnePassLevelContent(level),
    nanjingQinhuaiJourneyId => nanjingQinhuaiCuratedLevelContent(level),
    luoyangLongmenJourneyId => luoyangLongmenGoldLevelContent(level),
    _ => shanghaiBundOnePassRemediation.levelContent(level),
  };
  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final wonderQuestion = experience.id == shanghaiBundJourneyId
      ? '林岸为什么在过江后不再把两岸理解成过去和未来？'
      : base.wonderQuestion;
  final expressQuestion = experience.id == shanghaiBundJourneyId
      ? '旧海运提单与陆家嘴结算系统在故事里共同组织了哪些流动？'
      : base.expressQuestion;

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: unseenWords.isEmpty
        ? base.words
        : List<WordEntry>.unmodifiable(unseenWords),
    discoveries: base.discoveries,
    wonderQuestion: wonderQuestion,
    expressQuestion: expressQuestion,
  );
}

class BatchOneJourneyMemorySpec {
  const BatchOneJourneyMemorySpec({
    required this.storyResult,
    required this.culturalPoint,
    required this.reviews,
    required this.longTermAnchor,
    required this.completionSummary,
  });

  final String storyResult;
  final String culturalPoint;
  final List<RemediatedMemoryReview> reviews;
  final String longTermAnchor;
  final String completionSummary;
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(String journeyId) {
  final journey = switch (journeyId) {
    shanghaiBundJourneyId => shanghaiBundOnePassRemediation,
    xianCityWallJourneyId => xianCityWallOnePassRemediation,
    hangzhouWestLakeJourneyId => hangzhouWestLakeReopenedRemediation,
    chengduKuanzhaiJourneyId => chengduKuanzhaiOnePassRemediation,
    nanjingQinhuaiJourneyId => nanjingQinhuaiRemediatedJourney,
    luoyangLongmenJourneyId => luoyangLongmenGoldJourney,
    _ => null,
  };
  if (journey == null) return null;

  String memoryAnswer(String category) => journey.memory
      .firstWhere((item) => item.category == category)
      .answer;

  final culturalPoint = switch (journeyId) {
    chengduKuanzhaiJourneyId =>
      '${memoryAnswer('history')} ${memoryAnswer('preservation')}',
    nanjingQinhuaiJourneyId =>
      '${memoryAnswer('选择')} ${memoryAnswer('画面')}',
    luoyangLongmenJourneyId =>
      '${memoryAnswer('truth')} ${memoryAnswer('place')}',
    xianCityWallJourneyId || hangzhouWestLakeJourneyId =>
      '${memoryAnswer('history')} ${memoryAnswer('culture')}',
    _ => '${memoryAnswer('culture')} ${memoryAnswer('architecture')}',
  };

  return BatchOneJourneyMemorySpec(
    storyResult: journey.completion.journeySummary,
    culturalPoint: culturalPoint,
    reviews: List<RemediatedMemoryReview>.unmodifiable(journey.memory),
    longTermAnchor: journey.completion.memoryAnchor,
    completionSummary:
        '${journey.completion.achievement} ${journey.completion.challengeReward}',
  );
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
