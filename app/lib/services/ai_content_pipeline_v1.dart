import '../models/content_pipeline.dart';
import '../models/knowledge_universe.dart';
import '../models/story_engine.dart';

abstract interface class StoryWriter {
  CanonicalStoryContent writeStory(StoryPlan plan);
}

abstract interface class ContentGenerator {
  List<GeneratedVocabulary> generateVocabulary({
    required StoryPlan plan,
    required CanonicalStoryContent story,
  });

  List<GeneratedDiscovery> generateDiscoveries(StoryPlan plan);

  List<GeneratedChallengeTarget> generateChallenges(StoryPlan plan);

  GeneratedMemory generateMemory(StoryPlan plan);
}

class DeterministicStoryWriter implements StoryWriter {
  const DeterministicStoryWriter();

  @override
  CanonicalStoryContent writeStory(StoryPlan plan) {
    return CanonicalStoryContent(
      title: plan.title,
      lines: <StoryContentLine>[
        for (final beat in plan.storyBeats)
          StoryContentLine(
            id: 'story.${beat.type.name}',
            text: beat.text,
            knowledgeUnitRefs:
                List<String>.unmodifiable(beat.knowledgeUnitRefs),
          ),
      ],
    );
  }
}

class DeterministicContentGenerator implements ContentGenerator {
  DeterministicContentGenerator({
    required Map<String, VocabularyMetadata> vocabularyMetadataByTargetId,
    required Map<String, String> discoveryTextByTargetId,
    required List<ChallengeGenerationSpec> challengeSpecs,
    required this.memoryTemplate,
    required this.knowledgeUniverse,
  })  : vocabularyMetadataByTargetId =
            Map<String, VocabularyMetadata>.unmodifiable(
              vocabularyMetadataByTargetId,
            ),
        discoveryTextByTargetId = Map<String, String>.unmodifiable(
          discoveryTextByTargetId,
        ),
        challengeSpecs =
            List<ChallengeGenerationSpec>.unmodifiable(challengeSpecs);

  final Map<String, VocabularyMetadata> vocabularyMetadataByTargetId;
  final Map<String, String> discoveryTextByTargetId;
  final List<ChallengeGenerationSpec> challengeSpecs;
  final GeneratedMemory memoryTemplate;
  final KnowledgeUniverseRepository knowledgeUniverse;

  @override
  List<GeneratedVocabulary> generateVocabulary({
    required StoryPlan plan,
    required CanonicalStoryContent story,
  }) {
    final result = <GeneratedVocabulary>[];
    for (final target in plan.vocabularyTargets) {
      final metadata = vocabularyMetadataByTargetId[target.id];
      if (metadata == null) {
        throw ArgumentError('Missing deterministic vocabulary metadata: ${target.id}');
      }
      final sourceLines = story.lines
          .where((line) => line.text.contains(target.term))
          .toList(growable: false);
      if (sourceLines.isEmpty) {
        throw ArgumentError('Vocabulary is absent from Story: ${target.term}');
      }
      result.add(
        GeneratedVocabulary(
          id: target.id,
          word: target.term,
          pinyin: metadata.pinyin,
          partOfSpeech: metadata.partOfSpeech,
          simpleChinese: metadata.simpleChinese,
          storySource: sourceLines.first.id,
          usage: metadata.usage,
          semanticContrast: metadata.semanticContrast,
          knowledgeUnitRefs:
              List<String>.unmodifiable(target.knowledgeUnitRefs),
        ),
      );
    }
    return List<GeneratedVocabulary>.unmodifiable(result);
  }

  @override
  List<GeneratedDiscovery> generateDiscoveries(StoryPlan plan) {
    final result = <GeneratedDiscovery>[];
    for (final target in plan.discoveryTargets) {
      final text = discoveryTextByTargetId[target.id];
      if (text == null || text.trim().isEmpty) {
        throw ArgumentError('Missing deterministic Discovery text: ${target.id}');
      }
      final sources = <String>{};
      for (final ref in target.knowledgeUnitRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        if (unit == null || unit.status != KnowledgeStatus.verified) {
          throw ArgumentError('Discovery uses invalid KnowledgeUnit: $ref');
        }
        sources.addAll(unit.sourceRefs);
      }
      final sourceRefs = sources.toList(growable: false)..sort();
      result.add(
        GeneratedDiscovery(
          id: target.id,
          text: text,
          kind: DiscoveryAssertionKind.fact,
          knowledgeUnitRefs:
              List<String>.unmodifiable(target.knowledgeUnitRefs),
          sourceRefs: List<String>.unmodifiable(sourceRefs),
        ),
      );
    }
    return List<GeneratedDiscovery>.unmodifiable(result);
  }

  @override
  List<GeneratedChallengeTarget> generateChallenges(StoryPlan plan) {
    final taught = plan.knowledgeUnitRefs.toSet();
    final result = <GeneratedChallengeTarget>[];
    for (final spec in challengeSpecs) {
      for (final ref in spec.knowledgeUnitRefs) {
        if (!taught.contains(ref)) {
          throw ArgumentError('Challenge spec uses untaught KnowledgeUnit: $ref');
        }
      }
      result.add(
        GeneratedChallengeTarget(
          id: spec.id,
          kind: spec.kind,
          targetText: spec.targetText,
          teachingSourceRefs:
              List<String>.unmodifiable(spec.teachingSourceRefs),
          knowledgeUnitRefs:
              List<String>.unmodifiable(spec.knowledgeUnitRefs),
        ),
      );
    }
    return List<GeneratedChallengeTarget>.unmodifiable(result);
  }

  @override
  GeneratedMemory generateMemory(StoryPlan plan) {
    final taught = plan.knowledgeUnitRefs.toSet();
    for (final item in memoryTemplate.items) {
      for (final ref in item.knowledgeUnitRefs) {
        if (!taught.contains(ref)) {
          throw ArgumentError('Memory uses untaught KnowledgeUnit: $ref');
        }
      }
    }
    return memoryTemplate;
  }
}

class ContentQualityValidator {
  const ContentQualityValidator(this.knowledgeUniverse);

  final KnowledgeUniverseRepository knowledgeUniverse;

  ContentQualityReport validate({
    required StoryPlan plan,
    required CanonicalStoryContent story,
    required List<GeneratedVocabulary> vocabulary,
    required List<GeneratedDiscovery> discoveries,
    required List<GeneratedChallengeTarget> challenges,
    required GeneratedMemory memory,
    required List<FactualClaimTrace> factTrace,
    required List<ProvenanceRecord> provenance,
    required List<String> packageKnowledgeRefs,
    required List<String> packageSourceRefs,
  }) {
    final checks = <ContentQualityCheck>[
      _factTraceCheck(factTrace),
      _sourceCheck(packageSourceRefs),
      _knowledgeCheck(packageKnowledgeRefs),
      _storyStructureCheck(plan, story),
      _vocabularyCheck(story, vocabulary),
      _discoveryCheck(discoveries),
      _challengeCheck(plan, story, vocabulary, discoveries, challenges),
      _memoryCheck(plan, story, vocabulary, discoveries, memory),
      _provenanceCheck(
        story: story,
        vocabulary: vocabulary,
        discoveries: discoveries,
        challenges: challenges,
        memory: memory,
        provenance: provenance,
      ),
      _duplicationCheck(story, discoveries, challenges),
      _antiAiSlopCheck(story, discoveries),
      _deterministicStructureCheck(packageKnowledgeRefs, packageSourceRefs),
    ];
    final criticalPassed =
        checks.where((check) => check.critical).every((check) => check.passed);
    return ContentQualityReport(
      automatedChecks: checks,
      literaryReview: HumanReviewStatus.pending,
      storyDiscoveryFunctionalReview: HumanReviewStatus.pending,
      founderContentApproval: HumanReviewStatus.pending,
      overallCandidateStatus: criticalPassed
          ? ContentCandidateStatus.validated
          : ContentCandidateStatus.rejected,
    );
  }

  ContentQualityCheck _factTraceCheck(List<FactualClaimTrace> factTrace) {
    var valid = factTrace.isNotEmpty;
    for (final trace in factTrace) {
      valid = valid &&
          trace.knowledgeUnitRefs.isNotEmpty &&
          trace.sourceRefs.isNotEmpty;
      for (final ref in trace.knowledgeUnitRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        valid = valid &&
            unit != null &&
            unit.status == KnowledgeStatus.verified &&
            unit.sourceRefs.isNotEmpty &&
            trace.sourceRefs.toSet().containsAll(unit.sourceRefs);
      }
    }
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.factTrace,
      passed: valid,
      critical: true,
      message: valid ? 'FACT TRACE complete' : 'FACT TRACE incomplete',
    );
  }

  ContentQualityCheck _sourceCheck(List<String> sourceRefs) {
    var valid = sourceRefs.isNotEmpty;
    for (final ref in sourceRefs) {
      final source = knowledgeUniverse.sourceByRef[ref];
      final uri = source == null ? null : Uri.tryParse(source.url);
      valid = valid && source != null && uri != null && uri.hasScheme;
    }
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.sourceValidity,
      passed: valid,
      critical: true,
      message: valid ? 'Sources resolve to canonical records' : 'Invalid source',
    );
  }

  ContentQualityCheck _knowledgeCheck(List<String> knowledgeRefs) {
    var valid = knowledgeRefs.isNotEmpty;
    for (final ref in knowledgeRefs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      valid = valid &&
          unit != null &&
          unit.status == KnowledgeStatus.verified &&
          unit.sourceRefs.isNotEmpty;
    }
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.knowledgeProvenance,
      passed: valid,
      critical: true,
      message: valid ? 'Knowledge is verified and sourced' : 'Knowledge invalid',
    );
  }

  ContentQualityCheck _storyStructureCheck(
    StoryPlan plan,
    CanonicalStoryContent story,
  ) {
    final valid = plan.storyBeats.length == StoryBeatType.values.length &&
        plan.goal.trim().isNotEmpty &&
        plan.conflict.trim().isNotEmpty &&
        story.lines.length == StoryBeatType.values.length &&
        story.lines.every((line) => line.text.trim().isNotEmpty);
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.storyStructureSignals,
      passed: valid,
      critical: true,
      message: valid
          ? 'Canonical Story structure present; no literary approval implied'
          : 'Canonical Story structure incomplete',
    );
  }

  ContentQualityCheck _vocabularyCheck(
    CanonicalStoryContent story,
    List<GeneratedVocabulary> vocabulary,
  ) {
    final lineIds = story.lines.map((line) => line.id).toSet();
    final valid = vocabulary.isNotEmpty && vocabulary.every((item) {
      return story.text.contains(item.word) &&
          lineIds.contains(item.storySource) &&
          story.lines
              .singleWhere((line) => line.id == item.storySource)
              .text
              .contains(item.word);
    });
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.vocabularyOrigin,
      passed: valid,
      critical: true,
      message: valid ? 'Vocabulary originates in Story' : 'Vocabulary origin invalid',
    );
  }

  ContentQualityCheck _discoveryCheck(List<GeneratedDiscovery> discoveries) {
    var valid = discoveries.isNotEmpty;
    for (final item in discoveries) {
      if (item.kind == DiscoveryAssertionKind.fact) {
        valid = valid &&
            item.knowledgeUnitRefs.isNotEmpty &&
            item.sourceRefs.isNotEmpty;
      }
      for (final ref in item.knowledgeUnitRefs) {
        final unit = knowledgeUniverse.knowledgeById[ref];
        valid = valid &&
            unit != null &&
            unit.status == KnowledgeStatus.verified &&
            item.sourceRefs.toSet().containsAll(unit.sourceRefs);
      }
    }
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.discoveryGrounding,
      passed: valid,
      critical: true,
      message: valid ? 'Discovery is grounded' : 'Discovery grounding invalid',
    );
  }

  ContentQualityCheck _challengeCheck(
    StoryPlan plan,
    CanonicalStoryContent story,
    List<GeneratedVocabulary> vocabulary,
    List<GeneratedDiscovery> discoveries,
    List<GeneratedChallengeTarget> challenges,
  ) {
    final teachingIds = <String>{
      ...story.lines.map((line) => line.id),
      ...vocabulary.map((item) => item.id),
      ...discoveries.map((item) => item.id),
    };
    final taughtKnowledge = <String>{
      ...plan.knowledgeUnitRefs,
      for (final discovery in discoveries) ...discovery.knowledgeUnitRefs,
    };
    final kinds = challenges.map((item) => item.kind).toSet();
    final hasAllKinds = GeneratedChallengeKind.values.every(kinds.contains);
    final valid = challenges.isNotEmpty &&
        hasAllKinds &&
        challenges.every((item) {
          return item.teachingSourceRefs.isNotEmpty &&
              item.teachingSourceRefs.every(teachingIds.contains) &&
              item.knowledgeUnitRefs.every(taughtKnowledge.contains);
        });
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.challengeAlignment,
      passed: valid,
      critical: true,
      message: valid ? 'Challenge tests taught content only' : 'Challenge alignment invalid',
    );
  }

  ContentQualityCheck _memoryCheck(
    StoryPlan plan,
    CanonicalStoryContent story,
    List<GeneratedVocabulary> vocabulary,
    List<GeneratedDiscovery> discoveries,
    GeneratedMemory memory,
  ) {
    final teachingIds = <String>{
      ...story.lines.map((line) => line.id),
      ...vocabulary.map((item) => item.id),
      ...discoveries.map((item) => item.id),
    };
    final taughtKnowledge = plan.knowledgeUnitRefs.toSet();
    final valid = memory.items.every((item) {
      return item.text.trim().isNotEmpty &&
          item.teachingSourceRefs.isNotEmpty &&
          item.teachingSourceRefs.every(teachingIds.contains) &&
          item.knowledgeUnitRefs.every(taughtKnowledge.contains);
    });
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.memoryAlignment,
      passed: valid,
      critical: true,
      message: valid ? 'Memory aligns to Story/learning' : 'Memory alignment invalid',
    );
  }

  ContentQualityCheck _provenanceCheck({
    required CanonicalStoryContent story,
    required List<GeneratedVocabulary> vocabulary,
    required List<GeneratedDiscovery> discoveries,
    required List<GeneratedChallengeTarget> challenges,
    required GeneratedMemory memory,
    required List<ProvenanceRecord> provenance,
  }) {
    final expectedIds = <String>{
      ...story.lines.map((line) => line.id),
      ...vocabulary.map((item) => item.id),
      ...discoveries.map((item) => item.id),
      ...challenges.map((item) => item.id),
      ...memory.items.map((item) => item.id),
    };
    final actualIds = provenance.map((record) => record.elementId).toSet();
    final valid = expectedIds.length == provenance.length &&
        actualIds.length == provenance.length &&
        actualIds.containsAll(expectedIds) &&
        provenance.every((record) => record.why.trim().isNotEmpty);
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.provenanceCompleteness,
      passed: valid,
      critical: true,
      message: valid ? 'Every content element answers WHY IS THIS HERE' : 'Provenance incomplete',
    );
  }

  ContentQualityCheck _duplicationCheck(
    CanonicalStoryContent story,
    List<GeneratedDiscovery> discoveries,
    List<GeneratedChallengeTarget> challenges,
  ) {
    final storyLines = story.lines.map((line) => line.text.trim()).toList();
    final uniqueStory = storyLines.toSet().length == storyLines.length;
    final discoveryText = discoveries.map((item) => item.text.trim()).toList();
    final uniqueDiscovery = discoveryText.toSet().length == discoveryText.length;
    final noExactStoryDiscovery = discoveryText.every(
      (text) => !storyLines.contains(text),
    );
    final challengeTargets = challenges.map((item) => item.targetText).toList();
    final uniqueChallenges =
        challengeTargets.toSet().length == challengeTargets.length;
    final valid = uniqueStory &&
        uniqueDiscovery &&
        noExactStoryDiscovery &&
        uniqueChallenges;
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.duplication,
      passed: valid,
      critical: true,
      message: valid ? 'No structural exact duplication' : 'Duplicated content detected',
    );
  }

  ContentQualityCheck _antiAiSlopCheck(
    CanonicalStoryContent story,
    List<GeneratedDiscovery> discoveries,
  ) {
    const banned = <String>[
      '这说明',
      '由此可知',
      '通过这件事',
      '源远流长',
      '博大精深',
      '独特魅力',
      '值得我们',
    ];
    final combined = <String>[
      story.text,
      ...discoveries.map((item) => item.text),
    ].join('\n');
    final valid = banned.every((phrase) => !combined.contains(phrase));
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.antiAiSlopSignals,
      passed: valid,
      critical: true,
      message: valid ? 'Basic anti-AI-slop signals clear' : 'Generic AI filler detected',
    );
  }

  ContentQualityCheck _deterministicStructureCheck(
    List<String> knowledgeRefs,
    List<String> sourceRefs,
  ) {
    final sortedKnowledge = List<String>.from(knowledgeRefs)..sort();
    final sortedSources = List<String>.from(sourceRefs)..sort();
    final valid = _sameStrings(knowledgeRefs, sortedKnowledge) &&
        _sameStrings(sourceRefs, sortedSources);
    return ContentQualityCheck(
      kind: ContentQualityCheckKind.deterministicStructure,
      passed: valid,
      critical: true,
      message: valid ? 'Deterministic ordering enforced' : 'Ordering is unstable',
    );
  }

  static bool _sameStrings(List<String> left, List<String> right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) return false;
    }
    return true;
  }
}

class AiContentPipelineV1 {
  const AiContentPipelineV1({
    required this.knowledgeUniverse,
    required this.storyEngine,
    required this.storyWriter,
    required this.contentGenerator,
    required this.validator,
  });

  final KnowledgeUniverseRepository knowledgeUniverse;
  final StoryEngine storyEngine;
  final StoryWriter storyWriter;
  final ContentGenerator contentGenerator;
  final ContentQualityValidator validator;

  List<KnowledgeUnit> selectKnowledge(KnowledgeSelectionRequest request) {
    final matches = knowledgeUniverse.query(
      KnowledgeQuery(
        placeRefs: request.placeRefs,
        periodRefs: request.periodRefs,
        personRoleRefs: request.roleRefs,
        professionRefs: request.professionRefs,
        cultureRefs: request.cultureRefs,
        tags: request.topicTags,
        statuses: const <KnowledgeStatus>[KnowledgeStatus.verified],
      ),
    );
    if (request.requiredKnowledgeUnitRefs.isEmpty) return matches;

    final byId = <String, KnowledgeUnit>{for (final unit in matches) unit.id: unit};
    final selected = <KnowledgeUnit>[];
    for (final ref in request.requiredKnowledgeUnitRefs) {
      final unit = byId[ref];
      if (unit == null) {
        throw ArgumentError('Required KnowledgeUnit does not match selection: $ref');
      }
      selected.add(unit);
    }
    selected.sort((a, b) => a.id.compareTo(b.id));
    return List<KnowledgeUnit>.unmodifiable(selected);
  }

  JourneyContentPackage generate({
    required String packageId,
    required String pipelineVersion,
    required String knowledgeSnapshotVersion,
    required KnowledgeSelectionRequest selection,
    required StorySeed seedTemplate,
    required StoryBlueprint blueprint,
  }) {
    final selected = selectKnowledge(selection);
    if (selected.isEmpty) {
      throw ArgumentError('Knowledge selection must not be empty');
    }
    final selectedRefs = selected.map((unit) => unit.id).toList(growable: false)
      ..sort();
    final selectedSet = selectedRefs.toSet();
    for (final required in blueprint.requiredFacts) {
      if (!selectedSet.contains(required)) {
        throw ArgumentError('Blueprint fact missing from selected knowledge: $required');
      }
    }

    final seed = StorySeed(
      id: seedTemplate.id,
      placeRef: seedTemplate.placeRef,
      periodRef: seedTemplate.periodRef,
      characterRoleRef: seedTemplate.characterRoleRef,
      professionRef: seedTemplate.professionRef,
      goal: seedTemplate.goal,
      conflict: seedTemplate.conflict,
      knowledgeUnitRefs: selectedRefs,
      languageLevel: seedTemplate.languageLevel,
      learningFocus: seedTemplate.learningFocus,
    );
    final plan = storyEngine.compose(
      seed: seed,
      blueprint: blueprint,
      knowledgeSnapshotVersion: knowledgeSnapshotVersion,
    );
    final story = storyWriter.writeStory(plan);
    final vocabulary = contentGenerator.generateVocabulary(
      plan: plan,
      story: story,
    );
    final discoveries = contentGenerator.generateDiscoveries(plan);
    final challenges = contentGenerator.generateChallenges(plan);
    final memory = contentGenerator.generateMemory(plan);
    final factTrace = storyEngine.audit(plan).factualClaimMap;
    final sourceRefs = List<String>.from(plan.sourceRefs)..sort();
    final provenance = _buildProvenance(
      story: story,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
      memory: memory,
    );
    final alignment = PipelineLearningAlignment(
      storyKnowledgeUnitRefs: selectedRefs,
      vocabularyIds: vocabulary.map((item) => item.id).toList(growable: false),
      discoveryIds: discoveries.map((item) => item.id).toList(growable: false),
      challengeIds: challenges.map((item) => item.id).toList(growable: false),
      memoryIds: memory.items.map((item) => item.id).toList(growable: false),
    );
    final report = validator.validate(
      plan: plan,
      story: story,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
      memory: memory,
      factTrace: factTrace,
      provenance: provenance,
      packageKnowledgeRefs: selectedRefs,
      packageSourceRefs: sourceRefs,
    );
    final status = report.overallCandidateStatus;
    if (status == ContentCandidateStatus.approved) {
      throw StateError('Automated pipeline must never approve content');
    }
    return JourneyContentPackage(
      id: packageId,
      version: pipelineVersion,
      seedRef: seed.id,
      storyPlan: plan,
      storyContent: story,
      vocabulary: vocabulary,
      discoveries: discoveries,
      challenges: challenges,
      memory: memory,
      knowledgeUnitRefs: selectedRefs,
      sourceRefs: sourceRefs,
      factTrace: factTrace,
      learningAlignment: alignment,
      provenance: provenance,
      validationReport: report,
      status: status,
    );
  }

  List<ProvenanceRecord> _buildProvenance({
    required CanonicalStoryContent story,
    required List<GeneratedVocabulary> vocabulary,
    required List<GeneratedDiscovery> discoveries,
    required List<GeneratedChallengeTarget> challenges,
    required GeneratedMemory memory,
  }) {
    final records = <ProvenanceRecord>[];
    for (final line in story.lines) {
      records.add(
        ProvenanceRecord(
          elementId: line.id,
          why: line.knowledgeUnitRefs.isEmpty
              ? 'Deterministic StoryPlan narrative beat; no factual provenance claimed.'
              : 'Story factual beat grounded in verified KnowledgeUnit.',
          knowledgeUnitRefs: line.knowledgeUnitRefs,
          sourceRefs: _sourcesForKnowledge(line.knowledgeUnitRefs),
        ),
      );
    }
    for (final item in vocabulary) {
      records.add(
        ProvenanceRecord(
          elementId: item.id,
          why: 'Vocabulary appears in Story and supports a Story learning target.',
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: _sourcesForKnowledge(item.knowledgeUnitRefs),
          teachingSourceRefs: <String>[item.storySource],
        ),
      );
    }
    for (final item in discoveries) {
      records.add(
        ProvenanceRecord(
          elementId: item.id,
          why: 'Discovery explains selected verified knowledge without claiming Story review approval.',
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: item.sourceRefs,
        ),
      );
    }
    for (final item in challenges) {
      records.add(
        ProvenanceRecord(
          elementId: item.id,
          why: 'Challenge target is limited to previously taught Story/Vocabulary/Discovery material.',
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: _sourcesForKnowledge(item.knowledgeUnitRefs),
          teachingSourceRefs: item.teachingSourceRefs,
        ),
      );
    }
    for (final item in memory.items) {
      records.add(
        ProvenanceRecord(
          elementId: item.id,
          why: 'Memory anchor recalls Story or learning content already taught in the fixture.',
          knowledgeUnitRefs: item.knowledgeUnitRefs,
          sourceRefs: _sourcesForKnowledge(item.knowledgeUnitRefs),
          teachingSourceRefs: item.teachingSourceRefs,
        ),
      );
    }
    return List<ProvenanceRecord>.unmodifiable(records);
  }

  List<String> _sourcesForKnowledge(List<String> knowledgeRefs) {
    final refs = <String>{};
    for (final ref in knowledgeRefs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      if (unit == null) {
        throw ArgumentError('Unknown KnowledgeUnit while tracing provenance: $ref');
      }
      refs.addAll(unit.sourceRefs);
    }
    final sorted = refs.toList(growable: false)..sort();
    return List<String>.unmodifiable(sorted);
  }
}
