import 'batch_one_journey_remediation.dart';

/// UI compatibility view over the canonical Batch 1 remediation record.
/// Story, Words, Discovery, Challenge, Memory and Completion all remain owned
/// by batch_one_journey_remediation.dart so there is only one content source.
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
