enum StoryChallengeMode { sentenceRebuild, grammarRepair, storyCompletion }

class QuestionDesignSignature {
  const QuestionDesignSignature({
    required this.journeyId,
    required this.sessionLevel,
    required this.mode,
    required this.sourceParagraphIndex,
    required this.sourceSentenceIndex,
    required this.sourceHash,
    required this.syntaxPattern,
    required this.operationType,
    required this.errorFamily,
    required this.gapType,
    required this.answerShape,
    required this.distractorStrategy,
    this.blankPositionPattern,
  });

  final String journeyId;
  final int sessionLevel;
  final StoryChallengeMode mode;
  final int sourceParagraphIndex;
  final int sourceSentenceIndex;
  final String sourceHash;
  final String syntaxPattern;
  final String operationType;
  final String? errorFamily;
  final String? gapType;
  final String answerShape;
  final String distractorStrategy;
  final String? blankPositionPattern;

  String get equivalenceKey => [
        mode.name,
        syntaxPattern,
        operationType,
        errorFamily ?? '-',
        gapType ?? '-',
        answerShape,
        distractorStrategy,
        blankPositionPattern ?? '-',
      ].join('|');
}

class StoryCompletionBlank {
  const StoryCompletionBlank({
    required this.answer,
    required this.options,
    required this.answerType,
    required this.sourceStart,
  });

  final String answer;
  final List<String> options;
  final String answerType;
  final int sourceStart;
}

class StoryChallengeQuestion {
  const StoryChallengeQuestion({
    required this.id,
    required this.mode,
    required this.sourceSentence,
    required this.prompt,
    required this.answer,
    required this.options,
    required this.signature,
    required this.narrationText,
    this.characterTiles = const [],
    this.errorSegments = const [],
    this.errorSegmentIndex,
    this.completionSegments = const [],
    this.completionBlanks = const [],
  });

  final String id;
  final StoryChallengeMode mode;
  final String sourceSentence;
  final String prompt;
  final String answer;
  final List<String> options;
  final List<String> characterTiles;
  final List<String> errorSegments;
  final int? errorSegmentIndex;
  final List<String> completionSegments;
  final List<StoryCompletionBlank> completionBlanks;
  final String narrationText;
  final QuestionDesignSignature signature;
}

class StoryChallengeSet {
  const StoryChallengeSet({
    required this.journeyId,
    required this.sessionLevel,
    required this.questions,
  });

  final String journeyId;
  final int sessionLevel;
  final List<StoryChallengeQuestion> questions;
}

class ChallengeAuditReport {
  const ChallengeAuditReport({required this.failures});
  final List<String> failures;
  bool get passed => failures.isEmpty;
}
