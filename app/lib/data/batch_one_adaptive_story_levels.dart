import '../models/language_proficiency.dart';
import 'batch_one_journey_remediation.dart';
import 'daily_journey_experience.dart';
import 'journey_level_catalog.dart';

bool isBatchOneGoldJourney(String journeyId) =>
    batchOneJourneyIds.contains(journeyId);

/// Thin adaptive adapter over the canonical remediation records.
/// It does not own Story, Words, Discovery, Challenge, Memory, or Completion
/// content; those remain in batch_one_journey_remediation.dart.
JourneyLevelContent buildBatchOneGoldLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final base = batchOneJourneyLevelContentFor(experience.id, level);
  if (base == null) {
    throw ArgumentError.value(experience.id, 'experience.id');
  }

  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final words = unseenWords.isEmpty ? base.words : unseenWords;
  final prompts = switch (experience.id) {
    'beijing-forbidden-city' => (
        understanding: '梁砚为什么宁可迟交，也不把冲突数据直接当成新的建筑位移？',
        expression: '请按证据链说明测量口径、复核与最终修缮判断之间的关系。',
      ),
    'shanghai-bund' => (
        understanding: '林乔为什么宁可让展览晚开，也不采用那句更吸引人的照片说明？',
        expression: '请按证据链说明视点、档案编号与不确定性怎样改变照片说明。',
      ),
    _ => (understanding: '', expression: ''),
  };

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: words,
    discoveries: base.discoveries,
    wonderQuestion: prompts.understanding,
    expressQuestion: prompts.expression,
  );
}

/// UI compatibility view over the canonical Batch 1 remediation record.
class BatchOneJourneyMemorySpec {
  const BatchOneJourneyMemorySpec({
    required this.storyResult,
    required this.culturalPoint,
    required this.longTermAnchor,
    required this.completionSummary,
  });

  final String storyResult;
  final String culturalPoint;
  final String longTermAnchor;
  final String completionSummary;
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(String journeyId) {
  final journey = batchOneRemediationFor(journeyId);
  if (journey == null) return null;

  String memoryAnswer(String category) => journey.memory
      .firstWhere((item) => item.category == category)
      .answer;

  return BatchOneJourneyMemorySpec(
    storyResult: journey.completion.journeySummary,
    culturalPoint:
        '${memoryAnswer('culture')} ${memoryAnswer('architecture')}',
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
