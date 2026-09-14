enum StoryChallengeMode {
  sentenceRebuild,
  grammarRepair,
  storyCompletion,
  storyEvidence,
  knowledgeReasoning,
  scenarioDecision,
}

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
    this.templateSignature = '',
    this.semanticSignature = '',
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
  final String templateSignature;
  final String semanticSignature;

  String get equivalenceKey => [
        mode.name,
        syntaxPattern,
        operationType,
        errorFamily ?? '-',
        gapType ?? '-',
        answerShape,
        distractorStrategy,
        blankPositionPattern ?? '-',
        templateSignature,
        semanticSignature,
      ].join('|');
}

class StoryCompletionBlank {
  const StoryCompletionBlank({
    required this.answer,
    required this.options,
    required this.answerType,
    required this.semanticSlotType,
    required this.sourceStart,
  });

  final String answer;
  final List<String> options;
  final String answerType;
  final String semanticSlotType;
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
    this.grammarFamily,
    this.grammarWhyWrong,
    this.grammarRevisionRule,
    this.grammarOptionExplanations = const [],
    this.completionSegments = const [],
    this.completionBlanks = const [],
    this.learningObjective = '',
    this.knowledgeTarget = '',
    this.languageTarget = '',
    this.reasoningTarget = '',
    this.whyCorrect = '',
    this.distractorRationales = const [],
    this.difficulty = '',
    this.storyEvidence = '',
    this.knowledgeSource = '',
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
  final String? grammarFamily;
  final String? grammarWhyWrong;
  final String? grammarRevisionRule;
  final List<String> grammarOptionExplanations;
  final List<String> completionSegments;
  final List<StoryCompletionBlank> completionBlanks;
  final String narrationText;
  final QuestionDesignSignature signature;

  final String learningObjective;
  final String knowledgeTarget;
  final String languageTarget;
  final String reasoningTarget;
  final String whyCorrect;
  final List<String> distractorRationales;
  final String difficulty;
  final String storyEvidence;
  final String knowledgeSource;
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
