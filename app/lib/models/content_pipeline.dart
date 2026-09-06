import 'knowledge_universe.dart';
import 'story_engine.dart';

enum JourneyContentStatus { draft, validated, rejected, approved }

enum PipelineChallengeKind {
  sentenceRebuild,
  grammar,
  knowledgeMcq,
  completion,
}

class KnowledgeSelectionRequest {
  const KnowledgeSelectionRequest({
    this.placeRefs = const <String>[],
    this.periodRefs = const <String>[],
    this.personRoleRefs = const <String>[],
    this.professionRefs = const <String>[],
    this.cultureRefs = const <String>[],
    this.topicTags = const <String>[],
    this.requiredKnowledgeUnitRefs = const <String>[],
  });

  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<String> personRoleRefs;
  final List<String> professionRefs;
  final List<String> cultureRefs;
  final List<String> topicTags;
  final List<String> requiredKnowledgeUnitRefs;
}

class KnowledgeSelectionResult {
  KnowledgeSelectionResult({
    required List<KnowledgeUnit> units,
  }) : units = List<KnowledgeUnit>.unmodifiable(units);

  final List<KnowledgeUnit> units;

  List<String> get knowledgeUnitRefs => List<String>.unmodifiable(
        units.map((unit) => unit.id),
      );

  String get canonicalSignature => units.map((unit) => unit.id).join('|');
}

class StorySeedRequest {
  const StorySeedRequest({
    required this.id,
    required this.placeRef,
    required this.characterRoleRef,
    required this.goal,
    required this.conflict,
    required this.languageLevel,
    required this.learningFocus,
    this.periodRef,
    this.professionRef,
  });

  final String id;
  final String placeRef;
  final String? periodRef;
  final String characterRoleRef;
  final String? professionRef;
  final String goal;
  final String conflict;
  final int languageLevel;
  final List<String> learningFocus;
}

class StoryContentBeat {
  StoryContentBeat({
    required this.id,
    required this.type,
    required this.text,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
  })  : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs);

  final String id;
  final StoryBeatType type;
  final String text;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;

  bool get containsFact => knowledgeUnitRefs.isNotEmpty;
}

class CanonicalStoryContent {
  CanonicalStoryContent({required List<StoryContentBeat> beats})
      : beats = List<StoryContentBeat>.unmodifiable(beats);

  final List<StoryContentBeat> beats;

  String get text => beats.map((beat) => beat.text).join('\n');

  String get canonicalSignature => beats
      .map(
        (beat) => <String>[
          beat.id,
          beat.type.name,
          beat.text,
          beat.knowledgeUnitRefs.join(','),
          beat.sourceRefs.join(','),
        ].join('|'),
      )
      .join('\n');
}

class VocabularyLexeme {
  const VocabularyLexeme({
    required this.word,
    required this.pinyin,
    required this.partOfSpeech,
    required this.simpleChinese,
    required this.semanticContrast,
  });

  final String word;
  final String pinyin;
  final String partOfSpeech;
  final String simpleChinese;
  final String semanticContrast;
}

class PipelineVocabularyItem {
  PipelineVocabularyItem({
    required this.id,
    required this.word,
    required this.pinyin,
    required this.partOfSpeech,
    required this.simpleChinese,
    required this.storySource,
    required this.usage,
    required this.semanticContrast,
    required List<String> knowledgeUnitRefs,
  }) : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs);

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

class PipelineDiscoveryItem {
  PipelineDiscoveryItem({
    required this.id,
    required this.text,
    required this.status,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
  })  : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs);

  final String id;
  final String text;
  final KnowledgeStatus status;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
}

class PipelineChallengeTarget {
  PipelineChallengeTarget({
    required this.id,
    required this.kind,
    required this.target,
    required List<String> knowledgeUnitRefs,
    required List<String> vocabularyRefs,
    required List<String> teachingRefs,
  })  : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        vocabularyRefs = List<String>.unmodifiable(vocabularyRefs),
        teachingRefs = List<String>.unmodifiable(teachingRefs);

  final String id;
  final PipelineChallengeKind kind;
  final String target;
  final List<String> knowledgeUnitRefs;
  final List<String> vocabularyRefs;
  final List<String> teachingRefs;
}

class PipelineMemoryContent {
  PipelineMemoryContent({
    required this.storyAnchor,
    required this.knowledgeTakeaway,
    required List<String> knowledgeUnitRefs,
    required List<String> vocabularyRecall,
    required this.characterMoment,
  })  : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        vocabularyRecall = List<String>.unmodifiable(vocabularyRecall);

  final String storyAnchor;
  final String knowledgeTakeaway;
  final List<String> knowledgeUnitRefs;
  final List<String> vocabularyRecall;
  final String characterMoment;
}

class ContentProvenanceRecord {
  ContentProvenanceRecord({
    required this.contentId,
    required this.kind,
    required List<String> originRefs,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
  })  : originRefs = List<String>.unmodifiable(originRefs),
        knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs);

  final String contentId;
  final String kind;
  final List<String> originRefs;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
}

class PipelineLearningAlignment {
  PipelineLearningAlignment({
    required List<String> taughtKnowledgeRefs,
    required List<String> vocabularyRefs,
    required List<String> discoveryRefs,
    required List<String> allowedChallengeKnowledgeRefs,
    required List<String> challengeRefs,
  })  : taughtKnowledgeRefs = List<String>.unmodifiable(taughtKnowledgeRefs),
        vocabularyRefs = List<String>.unmodifiable(vocabularyRefs),
        discoveryRefs = List<String>.unmodifiable(discoveryRefs),
        allowedChallengeKnowledgeRefs =
            List<String>.unmodifiable(allowedChallengeKnowledgeRefs),
        challengeRefs = List<String>.unmodifiable(challengeRefs);

  final List<String> taughtKnowledgeRefs;
  final List<String> vocabularyRefs;
  final List<String> discoveryRefs;
  final List<String> allowedChallengeKnowledgeRefs;
  final List<String> challengeRefs;
}

class ContentQualityReport {
  ContentQualityReport({
    required this.factTracePass,
    required this.sourceValidityPass,
    required this.storyQualityPass,
    required this.vocabularyOriginPass,
    required this.discoveryGroundingPass,
    required this.challengeAlignmentPass,
    required this.memoryAlignmentPass,
    required this.duplicationPass,
    required this.determinismPass,
    required List<String> criticalFailures,
    required List<String> warnings,
  })  : criticalFailures = List<String>.unmodifiable(criticalFailures),
        warnings = List<String>.unmodifiable(warnings);

  factory ContentQualityReport.pending() => ContentQualityReport(
        factTracePass: false,
        sourceValidityPass: false,
        storyQualityPass: false,
        vocabularyOriginPass: false,
        discoveryGroundingPass: false,
        challengeAlignmentPass: false,
        memoryAlignmentPass: false,
        duplicationPass: false,
        determinismPass: false,
        criticalFailures: const <String>['PENDING'],
        warnings: const <String>[],
      );

  final bool factTracePass;
  final bool sourceValidityPass;
  final bool storyQualityPass;
  final bool vocabularyOriginPass;
  final bool discoveryGroundingPass;
  final bool challengeAlignmentPass;
  final bool memoryAlignmentPass;
  final bool duplicationPass;
  final bool determinismPass;
  final List<String> criticalFailures;
  final List<String> warnings;

  bool get passed =>
      factTracePass &&
      sourceValidityPass &&
      storyQualityPass &&
      vocabularyOriginPass &&
      discoveryGroundingPass &&
      challengeAlignmentPass &&
      memoryAlignmentPass &&
      duplicationPass &&
      determinismPass &&
      criticalFailures.isEmpty;
}

class PipelineValidationReport {
  PipelineValidationReport({
    required this.isValid,
    required List<String> criticalErrors,
    required List<String> warnings,
  })  : criticalErrors = List<String>.unmodifiable(criticalErrors),
        warnings = List<String>.unmodifiable(warnings);

  factory PipelineValidationReport.pending() => PipelineValidationReport(
        isValid: false,
        criticalErrors: const <String>['PENDING'],
        warnings: const <String>[],
      );

  final bool isValid;
  final List<String> criticalErrors;
  final List<String> warnings;
}

class JourneyContentPackage {
  JourneyContentPackage({
    required this.id,
    required this.version,
    required this.pipelineVersion,
    required this.seedRef,
    required this.storyPlan,
    required this.storyContent,
    required List<PipelineVocabularyItem> vocabulary,
    required List<PipelineDiscoveryItem> discoveries,
    required List<PipelineChallengeTarget> challenges,
    required this.memory,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
    required List<FactualClaimTrace> factTrace,
    required this.learningAlignment,
    required List<ContentProvenanceRecord> provenance,
    required this.qualityReport,
    required this.validationReport,
    required this.status,
  })  : vocabulary = List<PipelineVocabularyItem>.unmodifiable(vocabulary),
        discoveries = List<PipelineDiscoveryItem>.unmodifiable(discoveries),
        challenges = List<PipelineChallengeTarget>.unmodifiable(challenges),
        knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs),
        factTrace = List<FactualClaimTrace>.unmodifiable(factTrace),
        provenance = List<ContentProvenanceRecord>.unmodifiable(provenance);

  final String id;
  final String version;
  final String pipelineVersion;
  final String seedRef;
  final StoryPlan storyPlan;
  final CanonicalStoryContent storyContent;
  final List<PipelineVocabularyItem> vocabulary;
  final List<PipelineDiscoveryItem> discoveries;
  final List<PipelineChallengeTarget> challenges;
  final PipelineMemoryContent memory;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
  final List<FactualClaimTrace> factTrace;
  final PipelineLearningAlignment learningAlignment;
  final List<ContentProvenanceRecord> provenance;
  final ContentQualityReport qualityReport;
  final PipelineValidationReport validationReport;
  final JourneyContentStatus status;

  JourneyContentPackage copyWith({
    CanonicalStoryContent? storyContent,
    List<PipelineVocabularyItem>? vocabulary,
    List<PipelineDiscoveryItem>? discoveries,
    List<PipelineChallengeTarget>? challenges,
    PipelineMemoryContent? memory,
    List<ContentProvenanceRecord>? provenance,
    ContentQualityReport? qualityReport,
    PipelineValidationReport? validationReport,
    JourneyContentStatus? status,
  }) =>
      JourneyContentPackage(
        id: id,
        version: version,
        pipelineVersion: pipelineVersion,
        seedRef: seedRef,
        storyPlan: storyPlan,
        storyContent: storyContent ?? this.storyContent,
        vocabulary: vocabulary ?? this.vocabulary,
        discoveries: discoveries ?? this.discoveries,
        challenges: challenges ?? this.challenges,
        memory: memory ?? this.memory,
        knowledgeUnitRefs: knowledgeUnitRefs,
        sourceRefs: sourceRefs,
        factTrace: factTrace,
        learningAlignment: learningAlignment,
        provenance: provenance ?? this.provenance,
        qualityReport: qualityReport ?? this.qualityReport,
        validationReport: validationReport ?? this.validationReport,
        status: status ?? this.status,
      );

  String get canonicalSignature => <String>[
        id,
        version,
        pipelineVersion,
        seedRef,
        storyPlan.canonicalSignature,
        storyContent.canonicalSignature,
        for (final item in vocabulary)
          '${item.id}|${item.word}|${item.pinyin}|${item.partOfSpeech}|${item.simpleChinese}|${item.storySource}|${item.usage}|${item.semanticContrast}|${item.knowledgeUnitRefs.join(',')}',
        for (final item in discoveries)
          '${item.id}|${item.text}|${item.status.name}|${item.knowledgeUnitRefs.join(',')}|${item.sourceRefs.join(',')}',
        for (final item in challenges)
          '${item.id}|${item.kind.name}|${item.target}|${item.knowledgeUnitRefs.join(',')}|${item.vocabularyRefs.join(',')}|${item.teachingRefs.join(',')}',
        '${memory.storyAnchor}|${memory.knowledgeTakeaway}|${memory.knowledgeUnitRefs.join(',')}|${memory.vocabularyRecall.join(',')}|${memory.characterMoment}',
        knowledgeUnitRefs.join(','),
        sourceRefs.join(','),
        for (final trace in factTrace)
          '${trace.claimId}|${trace.storyClaim}|${trace.knowledgeUnitRefs.join(',')}|${trace.sourceRefs.join(',')}',
        for (final record in provenance)
          '${record.contentId}|${record.kind}|${record.originRefs.join(',')}|${record.knowledgeUnitRefs.join(',')}|${record.sourceRefs.join(',')}',
        status.name,
      ].join('\n');
}

abstract class ContentGenerator {
  CanonicalStoryContent writeStory({
    required StoryPlan plan,
    required KnowledgeUniverseRepository knowledgeUniverse,
  });
}

class DeterministicStoryWriter implements ContentGenerator {
  const DeterministicStoryWriter();

  @override
  CanonicalStoryContent writeStory({
    required StoryPlan plan,
    required KnowledgeUniverseRepository knowledgeUniverse,
  }) {
    final beats = <StoryContentBeat>[];
    for (var index = 0; index < plan.storyBeats.length; index += 1) {
      final beat = plan.storyBeats[index];
      final knowledgeRefs = List<String>.from(beat.knowledgeUnitRefs)..sort();
      final sources = <String>{};
      for (final ref in knowledgeRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        if (unit == null ||
            unit.status != KnowledgeStatus.verified ||
            unit.sourceRefs.isEmpty) {
          throw ArgumentError('Story content uses invalid factual KnowledgeUnit: $ref');
        }
        sources.addAll(unit.sourceRefs);
      }
      final sourceRefs = sources.toList(growable: false)..sort();
      beats.add(
        StoryContentBeat(
          id: 'story.beat.${index + 1}.${beat.type.name}',
          type: beat.type,
          text: beat.text,
          knowledgeUnitRefs: knowledgeRefs,
          sourceRefs: sourceRefs,
        ),
      );
    }
    return CanonicalStoryContent(beats: beats);
  }
}

class ContentQualityGate {
  const ContentQualityGate(this.knowledgeUniverse);

  final KnowledgeUniverseRepository knowledgeUniverse;

  ContentQualityReport evaluate(JourneyContentPackage package) {
    final failures = <String>[];
    final warnings = <String>[];
    final storyText = package.storyContent.text;
    final storyBeatIds = package.storyContent.beats.map((beat) => beat.id).toSet();
    final vocabIds = package.vocabulary.map((item) => item.id).toSet();
    final discoveryIds = package.discoveries.map((item) => item.id).toSet();

    final factTracePass = package.factTrace.every((trace) {
      if (trace.knowledgeUnitRefs.isEmpty || trace.sourceRefs.isEmpty) return false;
      for (final ref in trace.knowledgeUnitRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        if (unit == null || unit.status != KnowledgeStatus.verified) return false;
        if (!trace.sourceRefs.toSet().containsAll(unit.sourceRefs)) return false;
      }
      return true;
    }) && package.storyPlan.narrativeClaims
        .where((claim) => claim.type == NarrativeClaimType.fact)
        .length == package.factTrace.length;
    if (!factTracePass) failures.add('FACT_TRACE');

    final sourceValidityPass = package.sourceRefs.every(
      knowledgeUniverse.sourceByRef.containsKey,
    ) && package.storyContent.beats.every(
      (beat) => beat.sourceRefs.every(knowledgeUniverse.sourceByRef.containsKey),
    ) && package.discoveries.every(
      (item) => item.sourceRefs.every(knowledgeUniverse.sourceByRef.containsKey),
    );
    if (!sourceValidityPass) failures.add('SOURCE_VALIDITY');

    const slopPhrases = <String>[
      '这说明',
      '由此可知',
      '通过这件事',
      '源远流长',
      '博大精深',
      '独特魅力',
      '丰富多彩',
    ];
    final uniqueStoryLines = package.storyContent.beats.map((beat) => beat.text).toSet();
    final storyQualityPass = package.storyContent.beats.length == StoryBeatType.values.length &&
        uniqueStoryLines.length == package.storyContent.beats.length &&
        slopPhrases.every((phrase) => !storyText.contains(phrase));
    if (!storyQualityPass) failures.add('STORY_QUALITY');

    final vocabularyOriginPass = package.vocabulary.every(
      (item) => storyText.contains(item.word) &&
          storyBeatIds.contains(item.storySource) &&
          package.storyContent.beats
              .where((beat) => beat.id == item.storySource)
              .single
              .text
              .contains(item.word),
    );
    if (!vocabularyOriginPass) failures.add('VOCABULARY_ORIGIN');

    final storyLines = package.storyContent.beats.map((beat) => beat.text).toSet();
    final discoveryGroundingPass = package.discoveries.every((item) {
      if (item.status == KnowledgeStatus.verified &&
          (item.knowledgeUnitRefs.isEmpty || item.sourceRefs.isEmpty)) {
        return false;
      }
      if (storyLines.contains(item.text)) return false;
      for (final ref in item.knowledgeUnitRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        if (unit == null) return false;
        if (item.status == KnowledgeStatus.verified &&
            unit.status != KnowledgeStatus.verified) {
          return false;
        }
        if (!item.sourceRefs.toSet().containsAll(unit.sourceRefs)) return false;
      }
      return true;
    });
    if (!discoveryGroundingPass) failures.add('DISCOVERY_GROUNDING');

    final taught = package.learningAlignment.taughtKnowledgeRefs.toSet();
    final allowedChallengeKnowledge =
        package.learningAlignment.allowedChallengeKnowledgeRefs.toSet();
    final challengeKnowledgeSignatures = <String>{};
    var challengeAlignmentPass = true;
    for (final item in package.challenges) {
      if (item.knowledgeUnitRefs.isEmpty || item.teachingRefs.isEmpty) {
        challengeAlignmentPass = false;
        break;
      }
      if (!item.knowledgeUnitRefs.every(taught.contains) ||
          !item.knowledgeUnitRefs.every(allowedChallengeKnowledge.contains)) {
        challengeAlignmentPass = false;
        break;
      }
      if (!item.vocabularyRefs.every(vocabIds.contains)) {
        challengeAlignmentPass = false;
        break;
      }
      if (!item.teachingRefs.every(
        (ref) => storyBeatIds.contains(ref) ||
            vocabIds.contains(ref) ||
            discoveryIds.contains(ref),
      )) {
        challengeAlignmentPass = false;
        break;
      }
      final signature = item.knowledgeUnitRefs.join(',');
      if (!challengeKnowledgeSignatures.add(signature)) {
        challengeAlignmentPass = false;
        warnings.add('CHALLENGE_REPEATED_KNOWLEDGE:$signature');
        break;
      }
    }
    if (!challengeAlignmentPass) failures.add('CHALLENGE_ALIGNMENT');

    final memoryAlignmentPass = storyBeatIds.contains(package.memory.storyAnchor) &&
        storyBeatIds.contains(package.memory.characterMoment) &&
        package.memory.knowledgeUnitRefs.every(taught.contains) &&
        package.memory.vocabularyRecall.every(vocabIds.contains);
    if (!memoryAlignmentPass) failures.add('MEMORY_ALIGNMENT');

    final discoveryTexts = package.discoveries.map((item) => item.text).toList();
    final duplicateDiscovery = discoveryTexts.toSet().length != discoveryTexts.length;
    final slopInDiscovery = discoveryTexts.any(
      (text) => slopPhrases.any(text.contains),
    );
    final duplicationPass = !duplicateDiscovery &&
        !slopInDiscovery &&
        uniqueStoryLines.length == package.storyContent.beats.length;
    if (!duplicationPass) failures.add('DUPLICATION_OR_AI_SLOP');

    final determinismPass = package.pipelineVersion.trim().isNotEmpty &&
        package.storyPlan.knowledgeSnapshotVersion.trim().isNotEmpty;
    if (!determinismPass) failures.add('DETERMINISM_METADATA');

    return ContentQualityReport(
      factTracePass: factTracePass,
      sourceValidityPass: sourceValidityPass,
      storyQualityPass: storyQualityPass,
      vocabularyOriginPass: vocabularyOriginPass,
      discoveryGroundingPass: discoveryGroundingPass,
      challengeAlignmentPass: challengeAlignmentPass,
      memoryAlignmentPass: memoryAlignmentPass,
      duplicationPass: duplicationPass,
      determinismPass: determinismPass,
      criticalFailures: failures,
      warnings: warnings,
    );
  }
}

class AiContentPipeline {
  AiContentPipeline({
    required this.knowledgeUniverse,
    required this.storyEngine,
    required this.storyWriter,
    required this.pipelineVersion,
  });

  final KnowledgeUniverseRepository knowledgeUniverse;
  final StoryEngine storyEngine;
  final ContentGenerator storyWriter;
  final String pipelineVersion;

  KnowledgeSelectionResult selectKnowledge(KnowledgeSelectionRequest request) {
    _validateSelectionDimensions(request);
    final units = knowledgeUniverse.query(
      KnowledgeQuery(
        placeRefs: request.placeRefs,
        periodRefs: request.periodRefs,
        personRoleRefs: request.personRoleRefs,
        professionRefs: request.professionRefs,
        cultureRefs: request.cultureRefs,
        tags: request.topicTags,
        statuses: const <KnowledgeStatus>[KnowledgeStatus.verified],
      ),
    );
    final required = request.requiredKnowledgeUnitRefs.toSet();
    final selected = units
        .where((unit) => required.isEmpty || required.contains(unit.id))
        .toList(growable: false)
      ..sort((a, b) => a.id.compareTo(b.id));
    if (required.isNotEmpty) {
      final selectedRefs = selected.map((unit) => unit.id).toSet();
      final missing = required.difference(selectedRefs).toList(growable: false)..sort();
      if (missing.isNotEmpty) {
        throw ArgumentError('Required KnowledgeUnit rejected by selection: ${missing.join(',')}');
      }
    }
    if (selected.isEmpty) {
      throw ArgumentError('Knowledge selection returned no verified KnowledgeUnits');
    }
    return KnowledgeSelectionResult(units: selected);
  }

  StorySeed buildStorySeed({
    required StorySeedRequest request,
    required KnowledgeSelectionResult selection,
  }) {
    if (!knowledgeUniverse.placeById.containsKey(request.placeRef)) {
      throw ArgumentError('StorySeed place missing: ${request.placeRef}');
    }
    if (request.periodRef != null &&
        !knowledgeUniverse.periodById.containsKey(request.periodRef)) {
      throw ArgumentError('StorySeed period missing: ${request.periodRef}');
    }
    if (!knowledgeUniverse.personRoleById.containsKey(request.characterRoleRef)) {
      throw ArgumentError('StorySeed role missing: ${request.characterRoleRef}');
    }
    if (request.professionRef != null &&
        !knowledgeUniverse.professionById.containsKey(request.professionRef)) {
      throw ArgumentError('StorySeed profession missing: ${request.professionRef}');
    }
    return StorySeed(
      id: request.id,
      placeRef: request.placeRef,
      periodRef: request.periodRef,
      characterRoleRef: request.characterRoleRef,
      professionRef: request.professionRef,
      goal: request.goal,
      conflict: request.conflict,
      knowledgeUnitRefs: selection.knowledgeUnitRefs,
      languageLevel: request.languageLevel,
      learningFocus: request.learningFocus,
    );
  }

  JourneyContentPackage build({
    required String packageId,
    required String packageVersion,
    required String knowledgeSnapshotVersion,
    required KnowledgeSelectionRequest knowledgeSelection,
    required StorySeedRequest seedRequest,
    required StoryBlueprint storyBlueprint,
    required Map<String, VocabularyLexeme> vocabularyLexicon,
  }) {
    if (pipelineVersion.trim().isEmpty ||
        packageId.trim().isEmpty ||
        packageVersion.trim().isEmpty) {
      throw ArgumentError('Pipeline/package identity must be non-empty');
    }

    final selected = selectKnowledge(knowledgeSelection);
    final seed = buildStorySeed(request: seedRequest, selection: selected);
    final plan = storyEngine.compose(
      seed: seed,
      blueprint: storyBlueprint,
      knowledgeSnapshotVersion: knowledgeSnapshotVersion,
    );
    final storyContent = storyWriter.writeStory(
      plan: plan,
      knowledgeUniverse: knowledgeUniverse,
    );
    final vocabulary = _generateVocabulary(
      plan: plan,
      storyContent: storyContent,
      lexicon: vocabularyLexicon,
    );
    final discoveries = _generateDiscoveries(plan);
    final challenges = _generateChallenges(
      plan: plan,
      storyContent: storyContent,
      vocabulary: vocabulary,
      discoveries: discoveries,
    );
    final memory = _generateMemory(
      plan: plan,
      storyContent: storyContent,
      vocabulary: vocabulary,
    );
    final audit = storyEngine.audit(plan);
    final alignment = _buildAlignment(
      plan: plan,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
    );
    final provenance = _buildProvenance(
      plan: plan,
      storyContent: storyContent,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
      memory: memory,
    );
    final draft = JourneyContentPackage(
      id: packageId,
      version: packageVersion,
      pipelineVersion: pipelineVersion,
      seedRef: seed.id,
      storyPlan: plan,
      storyContent: storyContent,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
      memory: memory,
      knowledgeUnitRefs: plan.knowledgeUnitRefs,
      sourceRefs: plan.sourceRefs,
      factTrace: audit.factualClaimMap,
      learningAlignment: alignment,
      provenance: provenance,
      qualityReport: ContentQualityReport.pending(),
      validationReport: PipelineValidationReport.pending(),
      status: JourneyContentStatus.draft,
    );
    final quality = ContentQualityGate(knowledgeUniverse).evaluate(draft);
    final validation = _validatePackage(draft, quality);
    return draft.copyWith(
      qualityReport: quality,
      validationReport: validation,
      status: quality.passed && validation.isValid
          ? JourneyContentStatus.validated
          : JourneyContentStatus.rejected,
    );
  }

  JourneyContentPackage approve(JourneyContentPackage package) {
    throw StateError(
      'AI Content Pipeline V1 cannot APPROVE candidates; Founder/editorial gate required.',
    );
  }

  void _validateSelectionDimensions(KnowledgeSelectionRequest request) {
    for (final ref in request.placeRefs) {
      if (!knowledgeUniverse.placeById.containsKey(ref)) {
        throw ArgumentError('Unknown placeRef: $ref');
      }
    }
    for (final ref in request.periodRefs) {
      if (!knowledgeUniverse.periodById.containsKey(ref)) {
        throw ArgumentError('Unknown periodRef: $ref');
      }
    }
    for (final ref in request.personRoleRefs) {
      if (!knowledgeUniverse.personRoleById.containsKey(ref)) {
        throw ArgumentError('Unknown personRoleRef: $ref');
      }
    }
    for (final ref in request.professionRefs) {
      if (!knowledgeUniverse.professionById.containsKey(ref)) {
        throw ArgumentError('Unknown professionRef: $ref');
      }
    }
    for (final ref in request.cultureRefs) {
      if (!knowledgeUniverse.cultureTopicById.containsKey(ref)) {
        throw ArgumentError('Unknown cultureRef: $ref');
      }
    }
    for (final ref in request.requiredKnowledgeUnitRefs) {
      if (!knowledgeUniverse.knowledgeById.containsKey(ref)) {
        throw ArgumentError('Unknown required KnowledgeUnit: $ref');
      }
    }
  }

  List<PipelineVocabularyItem> _generateVocabulary({
    required StoryPlan plan,
    required CanonicalStoryContent storyContent,
    required Map<String, VocabularyLexeme> lexicon,
  }) {
    final result = <PipelineVocabularyItem>[];
    for (final target in plan.vocabularyTargets) {
      final lexeme = lexicon[target.term];
      if (lexeme == null || lexeme.word != target.term) {
        throw ArgumentError('Missing deterministic vocabulary lexeme: ${target.term}');
      }
      final sourceBeat = storyContent.beats.firstWhere(
        (beat) => beat.text.contains(target.term),
        orElse: () => throw ArgumentError(
          'Vocabulary target does not appear in Story: ${target.term}',
        ),
      );
      result.add(
        PipelineVocabularyItem(
          id: target.id,
          word: lexeme.word,
          pinyin: lexeme.pinyin,
          partOfSpeech: lexeme.partOfSpeech,
          simpleChinese: lexeme.simpleChinese,
          storySource: sourceBeat.id,
          usage: sourceBeat.text,
          semanticContrast: lexeme.semanticContrast,
          knowledgeUnitRefs: List<String>.from(target.knowledgeUnitRefs)..sort(),
        ),
      );
    }
    return List<PipelineVocabularyItem>.unmodifiable(result);
  }

  List<PipelineDiscoveryItem> _generateDiscoveries(StoryPlan plan) {
    final result = <PipelineDiscoveryItem>[];
    for (final target in plan.discoveryTargets) {
      final units = target.knowledgeUnitRefs
          .map((ref) => knowledgeUniverse.knowledgeById[ref])
          .whereType<KnowledgeUnit>()
          .toList(growable: false)
        ..sort((a, b) => a.id.compareTo(b.id));
      if (units.length != target.knowledgeUnitRefs.length ||
          units.any((unit) =>
              unit.status != KnowledgeStatus.verified || unit.sourceRefs.isEmpty)) {
        throw ArgumentError('Discovery uses invalid KnowledgeUnit: ${target.id}');
      }
      final sources = <String>{for (final unit in units) ...unit.sourceRefs}.toList()
        ..sort();
      final explanations = units.map((unit) => unit.simpleChinese).toSet().toList()
        ..sort();
      result.add(
        PipelineDiscoveryItem(
          id: target.id,
          text: '${target.concept}。核对要点：${explanations.join('；')}',
          status: KnowledgeStatus.verified,
          knowledgeUnitRefs: units.map((unit) => unit.id).toList(growable: false),
          sourceRefs: sources,
        ),
      );
    }
    return List<PipelineDiscoveryItem>.unmodifiable(result);
  }

  List<PipelineChallengeTarget> _generateChallenges({
    required StoryPlan plan,
    required CanonicalStoryContent storyContent,
    required List<PipelineVocabularyItem> vocabulary,
    required List<PipelineDiscoveryItem> discoveries,
  }) {
    final knowledgeRefs = List<String>.from(plan.knowledgeUnitRefs)..sort();
    if (knowledgeRefs.length < PipelineChallengeKind.values.length) {
      throw ArgumentError('Pipeline V1 fixture needs at least four taught KnowledgeUnits');
    }
    final result = <PipelineChallengeTarget>[];
    for (var index = 0; index < PipelineChallengeKind.values.length; index += 1) {
      final kind = PipelineChallengeKind.values[index];
      final knowledgeRef = knowledgeRefs[index];
      final unit = knowledgeUniverse.knowledgeById[knowledgeRef]!;
      final teachingRefs = <String>{};
      final vocabRefs = <String>[];
      for (final beat in storyContent.beats) {
        if (beat.knowledgeUnitRefs.contains(knowledgeRef)) teachingRefs.add(beat.id);
      }
      for (final discovery in discoveries) {
        if (discovery.knowledgeUnitRefs.contains(knowledgeRef)) {
          teachingRefs.add(discovery.id);
        }
      }
      for (final item in vocabulary) {
        if (item.knowledgeUnitRefs.contains(knowledgeRef)) {
          teachingRefs.add(item.id);
          vocabRefs.add(item.id);
        }
      }
      final sortedTeaching = teachingRefs.toList(growable: false)..sort();
      vocabRefs.sort();
      if (sortedTeaching.isEmpty) {
        throw ArgumentError('Challenge has no prior teaching target: $knowledgeRef');
      }
      result.add(
        PipelineChallengeTarget(
          id: 'pipeline.challenge.${kind.name}',
          kind: kind,
          target: unit.simpleChinese,
          knowledgeUnitRefs: <String>[knowledgeRef],
          vocabularyRefs: vocabRefs,
          teachingRefs: sortedTeaching,
        ),
      );
    }
    return List<PipelineChallengeTarget>.unmodifiable(result);
  }

  PipelineMemoryContent _generateMemory({
    required StoryPlan plan,
    required CanonicalStoryContent storyContent,
    required List<PipelineVocabularyItem> vocabulary,
  }) {
    final setup = storyContent.beats.firstWhere(
      (beat) => beat.type == StoryBeatType.setup,
    );
    final decision = storyContent.beats.firstWhere(
      (beat) => beat.type == StoryBeatType.decision,
    );
    final takeaway = storyContent.beats.firstWhere(
      (beat) => beat.type == StoryBeatType.takeaway,
    );
    return PipelineMemoryContent(
      storyAnchor: setup.id,
      knowledgeTakeaway: takeaway.text,
      knowledgeUnitRefs: plan.knowledgeUnitRefs,
      vocabularyRecall: vocabulary.map((item) => item.id).toList(growable: false),
      characterMoment: decision.id,
    );
  }

  PipelineLearningAlignment _buildAlignment({
    required StoryPlan plan,
    required List<PipelineVocabularyItem> vocabulary,
    required List<PipelineDiscoveryItem> discoveries,
    required List<PipelineChallengeTarget> challenges,
  }) {
    final allowedKnowledge = <String>{...plan.knowledgeUnitRefs};
    for (final discovery in discoveries) {
      allowedKnowledge.addAll(discovery.knowledgeUnitRefs);
    }
    final sortedAllowed = allowedKnowledge.toList(growable: false)..sort();
    return PipelineLearningAlignment(
      taughtKnowledgeRefs: List<String>.from(plan.knowledgeUnitRefs)..sort(),
      vocabularyRefs: vocabulary.map((item) => item.id).toList(growable: false),
      discoveryRefs: discoveries.map((item) => item.id).toList(growable: false),
      allowedChallengeKnowledgeRefs: sortedAllowed,
      challengeRefs: challenges.map((item) => item.id).toList(growable: false),
    );
  }

  List<ContentProvenanceRecord> _buildProvenance({
    required StoryPlan plan,
    required CanonicalStoryContent storyContent,
    required List<PipelineVocabularyItem> vocabulary,
    required List<PipelineDiscoveryItem> discoveries,
    required List<PipelineChallengeTarget> challenges,
    required PipelineMemoryContent memory,
  }) {
    final records = <ContentProvenanceRecord>[];
    for (final beat in storyContent.beats) {
      records.add(
        ContentProvenanceRecord(
          contentId: beat.id,
          kind: beat.containsFact ? 'STORY_FACTUAL_BEAT' : 'STORY_FICTIONAL_NARRATIVE',
          originRefs: <String>[plan.id],
          knowledgeUnitRefs: beat.knowledgeUnitRefs,
          sourceRefs: beat.sourceRefs,
        ),
      );
    }
    for (final item in vocabulary) {
      records.add(
        ContentProvenanceRecord(
          contentId: item.id,
          kind: 'VOCABULARY_FROM_STORY',
          originRefs: <String>[item.storySource],
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: const <String>[],
        ),
      );
    }
    for (final item in discoveries) {
      records.add(
        ContentProvenanceRecord(
          contentId: item.id,
          kind: 'DISCOVERY_FROM_KNOWLEDGE',
          originRefs: item.knowledgeUnitRefs,
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: item.sourceRefs,
        ),
      );
    }
    for (final item in challenges) {
      records.add(
        ContentProvenanceRecord(
          contentId: item.id,
          kind: 'CHALLENGE_FROM_TAUGHT_CONTENT',
          originRefs: item.teachingRefs,
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: const <String>[],
        ),
      );
    }
    records.addAll(<ContentProvenanceRecord>[
      ContentProvenanceRecord(
        contentId: 'memory.storyAnchor',
        kind: 'MEMORY_FROM_STORY',
        originRefs: <String>[memory.storyAnchor],
        knowledgeUnitRefs: const <String>[],
        sourceRefs: const <String>[],
      ),
      ContentProvenanceRecord(
        contentId: 'memory.knowledgeTakeaway',
        kind: 'MEMORY_FROM_LEARNING',
        originRefs: <String>[plan.id],
        knowledgeUnitRefs: memory.knowledgeUnitRefs,
        sourceRefs: plan.sourceRefs,
      ),
      ContentProvenanceRecord(
        contentId: 'memory.vocabularyRecall',
        kind: 'MEMORY_FROM_VOCABULARY',
        originRefs: memory.vocabularyRecall,
        knowledgeUnitRefs: const <String>[],
        sourceRefs: const <String>[],
      ),
      ContentProvenanceRecord(
        contentId: 'memory.characterMoment',
        kind: 'MEMORY_FROM_STORY',
        originRefs: <String>[memory.characterMoment],
        knowledgeUnitRefs: const <String>[],
        sourceRefs: const <String>[],
      ),
    ]);
    records.sort((a, b) => a.contentId.compareTo(b.contentId));
    return List<ContentProvenanceRecord>.unmodifiable(records);
  }

  PipelineValidationReport _validatePackage(
    JourneyContentPackage package,
    ContentQualityReport quality,
  ) {
    final errors = <String>[];
    final warnings = <String>[];
    final knowledgeSet = package.knowledgeUnitRefs.toSet();
    final sourceSet = package.sourceRefs.toSet();
    if (knowledgeSet.length != package.knowledgeUnitRefs.length) {
      errors.add('DUPLICATE_KNOWLEDGE_REFS');
    }
    for (final ref in package.knowledgeUnitRefs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      if (unit == null || unit.status != KnowledgeStatus.verified) {
        errors.add('INVALID_KNOWLEDGE:$ref');
      }
    }
    for (final ref in package.sourceRefs) {
      if (!knowledgeUniverse.sourceByRef.containsKey(ref)) {
        errors.add('INVALID_SOURCE:$ref');
      }
    }
    for (final ref in package.storyPlan.sourceRefs) {
      if (!sourceSet.contains(ref)) errors.add('MISSING_PACKAGE_SOURCE:$ref');
    }

    final expectedContentIds = <String>{
      ...package.storyContent.beats.map((beat) => beat.id),
      ...package.vocabulary.map((item) => item.id),
      ...package.discoveries.map((item) => item.id),
      ...package.challenges.map((item) => item.id),
      'memory.storyAnchor',
      'memory.knowledgeTakeaway',
      'memory.vocabularyRecall',
      'memory.characterMoment',
    };
    final provenanceIds = package.provenance.map((item) => item.contentId).toSet();
    final missingProvenance = expectedContentIds.difference(provenanceIds).toList()..sort();
    if (missingProvenance.isNotEmpty) {
      errors.add('MISSING_PROVENANCE:${missingProvenance.join(',')}');
    }
    if (!quality.passed) errors.addAll(quality.criticalFailures);
    warnings.addAll(quality.warnings);
    return PipelineValidationReport(
      isValid: errors.isEmpty,
      criticalErrors: errors,
      warnings: warnings,
    );
  }
}
