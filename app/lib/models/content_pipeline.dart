import 'story_engine.dart';

enum ContentCandidateStatus { draft, validated, rejected, approved }

enum HumanReviewStatus { pending, approved, rejected }

enum DiscoveryAssertionKind { fact, interpretation, inference }

enum GeneratedChallengeKind {
  sentenceRebuild,
  grammar,
  knowledgeMcq,
  completion,
}

enum ContentQualityCheckKind {
  factTrace,
  sourceValidity,
  knowledgeProvenance,
  storyStructureSignals,
  vocabularyOrigin,
  discoveryGrounding,
  challengeAlignment,
  memoryAlignment,
  provenanceCompleteness,
  duplication,
  antiAiSlopSignals,
  deterministicStructure,
}

class KnowledgeSelectionRequest {
  const KnowledgeSelectionRequest({
    this.placeRefs = const <String>[],
    this.periodRefs = const <String>[],
    this.roleRefs = const <String>[],
    this.professionRefs = const <String>[],
    this.cultureRefs = const <String>[],
    this.topicTags = const <String>[],
    this.requiredKnowledgeUnitRefs = const <String>[],
  });

  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<String> roleRefs;
  final List<String> professionRefs;
  final List<String> cultureRefs;
  final List<String> topicTags;
  final List<String> requiredKnowledgeUnitRefs;
}

class StoryContentLine {
  const StoryContentLine({
    required this.id,
    required this.text,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final String text;
  final List<String> knowledgeUnitRefs;
}

class CanonicalStoryContent {
  CanonicalStoryContent({
    required this.title,
    required List<StoryContentLine> lines,
  }) : lines = List<StoryContentLine>.unmodifiable(lines);

  final String title;
  final List<StoryContentLine> lines;

  String get text => lines.map((line) => line.text).join('\n');
}

class VocabularyMetadata {
  const VocabularyMetadata({
    required this.pinyin,
    required this.partOfSpeech,
    required this.simpleChinese,
    required this.usage,
    required this.semanticContrast,
  });

  final String pinyin;
  final String partOfSpeech;
  final String simpleChinese;
  final String usage;
  final String semanticContrast;
}

class GeneratedVocabulary {
  const GeneratedVocabulary({
    required this.id,
    required this.word,
    required this.pinyin,
    required this.partOfSpeech,
    required this.simpleChinese,
    required this.storySource,
    required this.usage,
    required this.semanticContrast,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final String word;
  final String pinyin;
  final String partOfSpeech;
  final String simpleChinese;
  final String storySource;
  final String usage;
  final String semanticContrast;
  final List<String> knowledgeUnitRefs;
}

class GeneratedDiscovery {
  const GeneratedDiscovery({
    required this.id,
    required this.text,
    required this.kind,
    required this.knowledgeUnitRefs,
    required this.sourceRefs,
  });

  final String id;
  final String text;
  final DiscoveryAssertionKind kind;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
}

class ChallengeGenerationSpec {
  const ChallengeGenerationSpec({
    required this.id,
    required this.kind,
    required this.targetText,
    required this.teachingSourceRefs,
    this.knowledgeUnitRefs = const <String>[],
  });

  final String id;
  final GeneratedChallengeKind kind;
  final String targetText;
  final List<String> teachingSourceRefs;
  final List<String> knowledgeUnitRefs;
}

class GeneratedChallengeTarget {
  const GeneratedChallengeTarget({
    required this.id,
    required this.kind,
    required this.targetText,
    required this.teachingSourceRefs,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final GeneratedChallengeKind kind;
  final String targetText;
  final List<String> teachingSourceRefs;
  final List<String> knowledgeUnitRefs;
}

class GeneratedMemoryItem {
  const GeneratedMemoryItem({
    required this.id,
    required this.text,
    required this.teachingSourceRefs,
    this.knowledgeUnitRefs = const <String>[],
  });

  final String id;
  final String text;
  final List<String> teachingSourceRefs;
  final List<String> knowledgeUnitRefs;
}

class GeneratedMemory {
  const GeneratedMemory({
    required this.storyAnchor,
    required this.knowledgeTakeaway,
    required this.vocabularyRecall,
    required this.characterMoment,
  });

  final GeneratedMemoryItem storyAnchor;
  final GeneratedMemoryItem knowledgeTakeaway;
  final GeneratedMemoryItem vocabularyRecall;
  final GeneratedMemoryItem characterMoment;

  List<GeneratedMemoryItem> get items => <GeneratedMemoryItem>[
        storyAnchor,
        knowledgeTakeaway,
        vocabularyRecall,
        characterMoment,
      ];
}

class ProvenanceRecord {
  const ProvenanceRecord({
    required this.elementId,
    required this.why,
    this.knowledgeUnitRefs = const <String>[],
    this.sourceRefs = const <String>[],
    this.teachingSourceRefs = const <String>[],
  });

  final String elementId;
  final String why;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
  final List<String> teachingSourceRefs;
}

class PipelineLearningAlignment {
  PipelineLearningAlignment({
    required List<String> storyKnowledgeUnitRefs,
    required List<String> vocabularyIds,
    required List<String> discoveryIds,
    required List<String> challengeIds,
    required List<String> memoryIds,
  })  : storyKnowledgeUnitRefs =
            List<String>.unmodifiable(storyKnowledgeUnitRefs),
        vocabularyIds = List<String>.unmodifiable(vocabularyIds),
        discoveryIds = List<String>.unmodifiable(discoveryIds),
        challengeIds = List<String>.unmodifiable(challengeIds),
        memoryIds = List<String>.unmodifiable(memoryIds);

  final List<String> storyKnowledgeUnitRefs;
  final List<String> vocabularyIds;
  final List<String> discoveryIds;
  final List<String> challengeIds;
  final List<String> memoryIds;
}

class ContentQualityCheck {
  const ContentQualityCheck({
    required this.kind,
    required this.passed,
    required this.critical,
    required this.message,
  });

  final ContentQualityCheckKind kind;
  final bool passed;
  final bool critical;
  final String message;
}

class ContentQualityReport {
  ContentQualityReport({
    required List<ContentQualityCheck> automatedChecks,
    required this.literaryReview,
    required this.storyDiscoveryFunctionalReview,
    required this.founderContentApproval,
    required this.overallCandidateStatus,
  }) : automatedChecks =
            List<ContentQualityCheck>.unmodifiable(automatedChecks);

  final List<ContentQualityCheck> automatedChecks;
  final HumanReviewStatus literaryReview;
  final HumanReviewStatus storyDiscoveryFunctionalReview;
  final HumanReviewStatus founderContentApproval;
  final ContentCandidateStatus overallCandidateStatus;

  bool get automatedValidation => automatedChecks
      .where((check) => check.critical)
      .every((check) => check.passed);

  bool passed(ContentQualityCheckKind kind) =>
      automatedChecks.singleWhere((check) => check.kind == kind).passed;
}

class JourneyContentPackage {
  JourneyContentPackage({
    required this.id,
    required this.version,
    required this.seedRef,
    required this.storyPlan,
    required this.storyContent,
    required List<GeneratedVocabulary> vocabulary,
    required List<GeneratedDiscovery> discoveries,
    required List<GeneratedChallengeTarget> challenges,
    required this.memory,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
    required List<FactualClaimTrace> factTrace,
    required this.learningAlignment,
    required List<ProvenanceRecord> provenance,
    required this.validationReport,
    required this.status,
  })  : vocabulary = List<GeneratedVocabulary>.unmodifiable(vocabulary),
        discoveries = List<GeneratedDiscovery>.unmodifiable(discoveries),
        challenges = List<GeneratedChallengeTarget>.unmodifiable(challenges),
        knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs),
        factTrace = List<FactualClaimTrace>.unmodifiable(factTrace),
        provenance = List<ProvenanceRecord>.unmodifiable(provenance);

  final String id;
  final String version;
  final String seedRef;
  final StoryPlan storyPlan;
  final CanonicalStoryContent storyContent;
  final List<GeneratedVocabulary> vocabulary;
  final List<GeneratedDiscovery> discoveries;
  final List<GeneratedChallengeTarget> challenges;
  final GeneratedMemory memory;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
  final List<FactualClaimTrace> factTrace;
  final PipelineLearningAlignment learningAlignment;
  final List<ProvenanceRecord> provenance;
  final ContentQualityReport validationReport;
  final ContentCandidateStatus status;

  String get canonicalSignature => <String>[
        id,
        version,
        seedRef,
        storyPlan.canonicalSignature,
        for (final line in storyContent.lines)
          '${line.id}|${line.text}|${line.knowledgeUnitRefs.join(',')}',
        for (final item in vocabulary)
          '${item.id}|${item.word}|${item.pinyin}|${item.partOfSpeech}|${item.simpleChinese}|${item.storySource}|${item.usage}|${item.semanticContrast}|${item.knowledgeUnitRefs.join(',')}',
        for (final item in discoveries)
          '${item.id}|${item.kind.name}|${item.text}|${item.knowledgeUnitRefs.join(',')}|${item.sourceRefs.join(',')}',
        for (final item in challenges)
          '${item.id}|${item.kind.name}|${item.targetText}|${item.teachingSourceRefs.join(',')}|${item.knowledgeUnitRefs.join(',')}',
        for (final item in memory.items)
          '${item.id}|${item.text}|${item.teachingSourceRefs.join(',')}|${item.knowledgeUnitRefs.join(',')}',
        knowledgeUnitRefs.join(','),
        sourceRefs.join(','),
        for (final trace in factTrace)
          '${trace.claimId}|${trace.storyClaim}|${trace.knowledgeUnitRefs.join(',')}|${trace.sourceRefs.join(',')}',
        for (final record in provenance)
          '${record.elementId}|${record.why}|${record.knowledgeUnitRefs.join(',')}|${record.sourceRefs.join(',')}|${record.teachingSourceRefs.join(',')}',
        for (final check in validationReport.automatedChecks)
          '${check.kind.name}|${check.passed}|${check.critical}|${check.message}',
        validationReport.literaryReview.name,
        validationReport.storyDiscoveryFunctionalReview.name,
        validationReport.founderContentApproval.name,
        validationReport.overallCandidateStatus.name,
        status.name,
      ].join('\n');
}
