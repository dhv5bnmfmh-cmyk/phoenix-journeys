import 'knowledge_universe.dart';

enum StoryBeatType {
  setup,
  observation,
  conflict,
  evidence,
  decision,
  resolution,
  takeaway,
}

enum StoryCharacterStatus { fictional, historical }

enum NarrativeClaimType { fact, fictionalNarrative }

enum StoryValidationStatus { draft, valid, invalid }

class StoryCharacter {
  const StoryCharacter({
    required this.name,
    required this.roleRef,
    required this.status,
    this.professionRef,
  });

  final String name;
  final String roleRef;
  final String? professionRef;
  final StoryCharacterStatus status;
}

class StoryBeat {
  const StoryBeat({
    required this.type,
    required this.text,
    this.knowledgeUnitRefs = const <String>[],
  });

  final StoryBeatType type;
  final String text;
  final List<String> knowledgeUnitRefs;
}

class NarrativeClaim {
  const NarrativeClaim({
    required this.id,
    required this.text,
    required this.type,
    this.knowledgeUnitRefs = const <String>[],
  });

  final String id;
  final String text;
  final NarrativeClaimType type;
  final List<String> knowledgeUnitRefs;
}

class VocabularyTarget {
  const VocabularyTarget({
    required this.id,
    required this.term,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final String term;
  final List<String> knowledgeUnitRefs;
}

class DiscoveryTarget {
  const DiscoveryTarget({
    required this.id,
    required this.concept,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final String concept;
  final List<String> knowledgeUnitRefs;
}

class ChallengeTarget {
  const ChallengeTarget({
    required this.id,
    required this.concept,
    required this.knowledgeUnitRefs,
  });

  final String id;
  final String concept;
  final List<String> knowledgeUnitRefs;
}

class StoryBlueprint {
  const StoryBlueprint({
    required this.id,
    required this.title,
    required this.characters,
    required this.storyBeats,
    required this.requiredFacts,
    required this.narrativeClaims,
    required this.vocabularyTargets,
    required this.discoveryTargets,
    required this.challengeTargets,
  });

  final String id;
  final String title;
  final List<StoryCharacter> characters;
  final List<StoryBeat> storyBeats;
  final List<String> requiredFacts;
  final List<NarrativeClaim> narrativeClaims;
  final List<VocabularyTarget> vocabularyTargets;
  final List<DiscoveryTarget> discoveryTargets;
  final List<ChallengeTarget> challengeTargets;
}

class StoryPlan {
  StoryPlan({
    required this.id,
    required this.seedRef,
    required this.knowledgeSnapshotVersion,
    required this.title,
    required List<String> placeRefs,
    required List<String> periodRefs,
    required List<StoryCharacter> characters,
    required this.goal,
    required this.conflict,
    required List<StoryBeat> storyBeats,
    required List<String> knowledgeUnitRefs,
    required List<String> requiredFacts,
    required List<NarrativeClaim> narrativeClaims,
    required List<String> learningFocus,
    required List<VocabularyTarget> vocabularyTargets,
    required List<DiscoveryTarget> discoveryTargets,
    required List<ChallengeTarget> challengeTargets,
    required List<String> sourceRefs,
    required this.validationStatus,
  })  : placeRefs = List<String>.unmodifiable(placeRefs),
        periodRefs = List<String>.unmodifiable(periodRefs),
        characters = List<StoryCharacter>.unmodifiable(characters),
        storyBeats = List<StoryBeat>.unmodifiable(storyBeats),
        knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        requiredFacts = List<String>.unmodifiable(requiredFacts),
        narrativeClaims = List<NarrativeClaim>.unmodifiable(narrativeClaims),
        learningFocus = List<String>.unmodifiable(learningFocus),
        vocabularyTargets = List<VocabularyTarget>.unmodifiable(vocabularyTargets),
        discoveryTargets = List<DiscoveryTarget>.unmodifiable(discoveryTargets),
        challengeTargets = List<ChallengeTarget>.unmodifiable(challengeTargets),
        sourceRefs = List<String>.unmodifiable(sourceRefs);

  final String id;
  final String seedRef;
  final String knowledgeSnapshotVersion;
  final String title;
  final List<String> placeRefs;
  final List<String> periodRefs;
  final List<StoryCharacter> characters;
  final String goal;
  final String conflict;
  final List<StoryBeat> storyBeats;
  final List<String> knowledgeUnitRefs;
  final List<String> requiredFacts;
  final List<NarrativeClaim> narrativeClaims;
  final List<String> learningFocus;
  final List<VocabularyTarget> vocabularyTargets;
  final List<DiscoveryTarget> discoveryTargets;
  final List<ChallengeTarget> challengeTargets;
  final List<String> sourceRefs;
  final StoryValidationStatus validationStatus;

  String get canonicalSignature => <String>[
        id,
        seedRef,
        knowledgeSnapshotVersion,
        title,
        placeRefs.join(','),
        periodRefs.join(','),
        for (final character in characters)
          '${character.name}|${character.roleRef}|${character.professionRef ?? ''}|${character.status.name}',
        goal,
        conflict,
        for (final beat in storyBeats)
          '${beat.type.name}|${beat.text}|${beat.knowledgeUnitRefs.join(',')}',
        knowledgeUnitRefs.join(','),
        requiredFacts.join(','),
        for (final claim in narrativeClaims)
          '${claim.id}|${claim.type.name}|${claim.text}|${claim.knowledgeUnitRefs.join(',')}',
        learningFocus.join(','),
        for (final target in vocabularyTargets)
          '${target.id}|${target.term}|${target.knowledgeUnitRefs.join(',')}',
        for (final target in discoveryTargets)
          '${target.id}|${target.concept}|${target.knowledgeUnitRefs.join(',')}',
        for (final target in challengeTargets)
          '${target.id}|${target.concept}|${target.knowledgeUnitRefs.join(',')}',
        sourceRefs.join(','),
        validationStatus.name,
      ].join('\n');
}

class FactualClaimTrace {
  FactualClaimTrace({
    required this.claimId,
    required this.storyClaim,
    required List<String> knowledgeUnitRefs,
    required List<String> sourceRefs,
  })  : knowledgeUnitRefs = List<String>.unmodifiable(knowledgeUnitRefs),
        sourceRefs = List<String>.unmodifiable(sourceRefs);

  final String claimId;
  final String storyClaim;
  final List<String> knowledgeUnitRefs;
  final List<String> sourceRefs;
}

class StoryKnowledgeCoverage {
  StoryKnowledgeCoverage({
    required List<String> usedKnowledge,
    required List<String> unusedKnowledge,
    required List<FactualClaimTrace> factualClaimMap,
  })  : usedKnowledge = List<String>.unmodifiable(usedKnowledge),
        unusedKnowledge = List<String>.unmodifiable(unusedKnowledge),
        factualClaimMap = List<FactualClaimTrace>.unmodifiable(factualClaimMap);

  final List<String> usedKnowledge;
  final List<String> unusedKnowledge;
  final List<FactualClaimTrace> factualClaimMap;
}

class StoryLearningAlignment {
  StoryLearningAlignment({required this.plan});

  final StoryPlan plan;

  List<String> whatDidThisStoryTeach() => plan.knowledgeUnitRefs;

  List<String> whatVocabularyCameFromIt() => List<String>.unmodifiable(
        plan.vocabularyTargets.map((target) => target.term),
      );

  List<String> whatDiscoveryFactsSupportIt() {
    final refs = <String>{};
    for (final target in plan.discoveryTargets) {
      refs.addAll(target.knowledgeUnitRefs);
    }
    final sorted = refs.toList(growable: false)..sort();
    return List<String>.unmodifiable(sorted);
  }

  List<String> whatChallengeConceptsAreAllowed() => List<String>.unmodifiable(
        plan.challengeTargets.map((target) => target.concept),
      );
}

class StoryEngine {
  StoryEngine(this.knowledgeUniverse);

  final KnowledgeUniverseRepository knowledgeUniverse;

  StoryPlan compose({
    required StorySeed seed,
    required StoryBlueprint blueprint,
    required String knowledgeSnapshotVersion,
  }) {
    validateSeed(seed);
    if (knowledgeSnapshotVersion.trim().isEmpty) {
      throw ArgumentError('Knowledge snapshot version must be non-empty');
    }

    final knowledgeRefs = seed.knowledgeUnitRefs.toSet().toList(growable: false)
      ..sort();
    final sourceRefs = _sourceRefsForKnowledge(knowledgeRefs);
    final plan = StoryPlan(
      id: '${blueprint.id}@$knowledgeSnapshotVersion',
      seedRef: seed.id,
      knowledgeSnapshotVersion: knowledgeSnapshotVersion,
      title: blueprint.title,
      placeRefs: <String>[seed.placeRef],
      periodRefs: seed.periodRef == null ? const <String>[] : <String>[seed.periodRef!],
      characters: blueprint.characters,
      goal: seed.goal,
      conflict: seed.conflict,
      storyBeats: blueprint.storyBeats,
      knowledgeUnitRefs: knowledgeRefs,
      requiredFacts: blueprint.requiredFacts,
      narrativeClaims: blueprint.narrativeClaims,
      learningFocus: seed.learningFocus,
      vocabularyTargets: blueprint.vocabularyTargets,
      discoveryTargets: blueprint.discoveryTargets,
      challengeTargets: blueprint.challengeTargets,
      sourceRefs: sourceRefs,
      validationStatus: StoryValidationStatus.valid,
    );
    validatePlan(plan, seed: seed);
    return plan;
  }

  void validateSeed(StorySeed seed) {
    if (!knowledgeUniverse.placeById.containsKey(seed.placeRef)) {
      throw ArgumentError('StorySeed place missing: ${seed.id}');
    }
    if (seed.periodRef != null &&
        !knowledgeUniverse.periodById.containsKey(seed.periodRef)) {
      throw ArgumentError('StorySeed period missing: ${seed.id}');
    }
    if (!knowledgeUniverse.personRoleById.containsKey(seed.characterRoleRef)) {
      throw ArgumentError('StorySeed role missing: ${seed.id}');
    }
    if (seed.professionRef != null &&
        !knowledgeUniverse.professionById.containsKey(seed.professionRef)) {
      throw ArgumentError('StorySeed profession missing: ${seed.id}');
    }
    if (seed.knowledgeUnitRefs.isEmpty) {
      throw ArgumentError('StorySeed requires KnowledgeUnit refs: ${seed.id}');
    }
    for (final ref in seed.knowledgeUnitRefs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      if (unit == null) {
        throw ArgumentError('StorySeed invalid KnowledgeUnit: $ref');
      }
      if (unit.status != KnowledgeStatus.verified || unit.sourceRefs.isEmpty) {
        throw ArgumentError('StorySeed factual KnowledgeUnit is not verified: $ref');
      }
      _validateKnownSources(unit.sourceRefs, owner: ref);
    }
  }

  void validatePlan(StoryPlan plan, {required StorySeed seed}) {
    if (plan.seedRef != seed.id) {
      throw ArgumentError('StoryPlan seedRef mismatch: ${plan.seedRef}');
    }
    if (plan.validationStatus != StoryValidationStatus.valid) {
      throw ArgumentError('StoryPlan is not valid: ${plan.id}');
    }
    if (plan.placeRefs.length != 1 || plan.placeRefs.single != seed.placeRef) {
      throw ArgumentError('StoryPlan placeRefs mismatch: ${plan.id}');
    }
    final expectedPeriods = seed.periodRef == null
        ? const <String>[]
        : <String>[seed.periodRef!];
    if (!_sameStrings(plan.periodRefs, expectedPeriods)) {
      throw ArgumentError('StoryPlan periodRefs mismatch: ${plan.id}');
    }

    for (final character in plan.characters) {
      if (character.name.trim().isEmpty ||
          !knowledgeUniverse.personRoleById.containsKey(character.roleRef)) {
        throw ArgumentError('Story character invalid: ${character.name}');
      }
      if (character.professionRef != null &&
          !knowledgeUniverse.professionById.containsKey(character.professionRef)) {
        throw ArgumentError('Story character profession invalid: ${character.name}');
      }
    }

    const expectedBeatTypes = StoryBeatType.values;
    if (plan.storyBeats.length != expectedBeatTypes.length) {
      throw ArgumentError('StoryPlan requires seven canonical beats: ${plan.id}');
    }
    for (var index = 0; index < expectedBeatTypes.length; index += 1) {
      final beat = plan.storyBeats[index];
      if (beat.type != expectedBeatTypes[index] || beat.text.trim().isEmpty) {
        throw ArgumentError('Story beat order/content invalid: ${plan.id}');
      }
      _validateVerifiedKnowledgeRefs(beat.knowledgeUnitRefs, owner: 'beat:${beat.type.name}');
    }

    final planKnowledge = plan.knowledgeUnitRefs.toSet();
    if (planKnowledge.length != plan.knowledgeUnitRefs.length) {
      throw ArgumentError('StoryPlan KnowledgeUnit refs must be unique: ${plan.id}');
    }
    _validateVerifiedKnowledgeRefs(plan.knowledgeUnitRefs, owner: plan.id);
    if (!_sameStrings(plan.knowledgeUnitRefs, List<String>.from(planKnowledge)..sort())) {
      throw ArgumentError('StoryPlan KnowledgeUnit refs must be deterministic: ${plan.id}');
    }

    for (final required in plan.requiredFacts) {
      if (!planKnowledge.contains(required)) {
        throw ArgumentError('Required fact is not taught by Story: $required');
      }
    }

    for (final claim in plan.narrativeClaims) {
      if (claim.id.trim().isEmpty || claim.text.trim().isEmpty) {
        throw ArgumentError('Narrative claim metadata must be non-empty');
      }
      if (claim.type == NarrativeClaimType.fact) {
        if (claim.knowledgeUnitRefs.isEmpty) {
          throw ArgumentError('Factual narrative must have KnowledgeUnit: ${claim.id}');
        }
        _validateVerifiedKnowledgeRefs(
          claim.knowledgeUnitRefs,
          owner: 'claim:${claim.id}',
        );
        for (final ref in claim.knowledgeUnitRefs) {
          if (!planKnowledge.contains(ref)) {
            throw ArgumentError('Factual claim uses untaught KnowledgeUnit: $ref');
          }
        }
      } else if (claim.knowledgeUnitRefs.isNotEmpty) {
        throw ArgumentError(
          'Fictional narrative must not fabricate provenance: ${claim.id}',
        );
      }
    }

    _validateTargets(plan.vocabularyTargets, planKnowledge);
    _validateDiscoveryTargets(plan.discoveryTargets, planKnowledge);
    final discoveryKnowledge = <String>{
      for (final target in plan.discoveryTargets) ...target.knowledgeUnitRefs,
    };
    for (final target in plan.challengeTargets) {
      if (target.id.trim().isEmpty || target.concept.trim().isEmpty) {
        throw ArgumentError('Challenge target metadata must be non-empty');
      }
      if (target.knowledgeUnitRefs.isEmpty) {
        throw ArgumentError('Challenge target needs taught knowledge: ${target.id}');
      }
      for (final ref in target.knowledgeUnitRefs) {
        if (!planKnowledge.contains(ref) || !discoveryKnowledge.contains(ref)) {
          throw ArgumentError('Challenge target uses untaught knowledge: $ref');
        }
      }
    }

    final expectedSources = _sourceRefsForKnowledge(plan.knowledgeUnitRefs);
    if (!_sameStrings(plan.sourceRefs, expectedSources)) {
      throw ArgumentError('StoryPlan sourceRefs do not match KnowledgeUnits: ${plan.id}');
    }
    _validateKnownSources(plan.sourceRefs, owner: plan.id);
  }

  StoryKnowledgeCoverage audit(StoryPlan plan) {
    final used = List<String>.from(plan.knowledgeUnitRefs)..sort();
    final usedSet = used.toSet();
    final unused = knowledgeUniverse.knowledgeUnits
        .where((unit) => unit.status == KnowledgeStatus.verified && !usedSet.contains(unit.id))
        .map((unit) => unit.id)
        .toList(growable: false)
      ..sort();
    final traces = <FactualClaimTrace>[];
    for (final claim in plan.narrativeClaims) {
      if (claim.type != NarrativeClaimType.fact) continue;
      final refs = List<String>.from(claim.knowledgeUnitRefs)..sort();
      traces.add(
        FactualClaimTrace(
          claimId: claim.id,
          storyClaim: claim.text,
          knowledgeUnitRefs: refs,
          sourceRefs: _sourceRefsForKnowledge(refs),
        ),
      );
    }
    traces.sort((a, b) => a.claimId.compareTo(b.claimId));
    return StoryKnowledgeCoverage(
      usedKnowledge: used,
      unusedKnowledge: unused,
      factualClaimMap: traces,
    );
  }

  StoryLearningAlignment alignment(StoryPlan plan) =>
      StoryLearningAlignment(plan: plan);

  void _validateTargets(
    List<VocabularyTarget> targets,
    Set<String> planKnowledge,
  ) {
    for (final target in targets) {
      if (target.id.trim().isEmpty || target.term.trim().isEmpty) {
        throw ArgumentError('Vocabulary target metadata must be non-empty');
      }
      if (target.knowledgeUnitRefs.isEmpty) {
        throw ArgumentError('Vocabulary target needs taught knowledge: ${target.id}');
      }
      for (final ref in target.knowledgeUnitRefs) {
        if (!planKnowledge.contains(ref)) {
          throw ArgumentError('Vocabulary target uses untaught knowledge: $ref');
        }
      }
    }
  }

  void _validateDiscoveryTargets(
    List<DiscoveryTarget> targets,
    Set<String> planKnowledge,
  ) {
    for (final target in targets) {
      if (target.id.trim().isEmpty || target.concept.trim().isEmpty) {
        throw ArgumentError('Discovery target metadata must be non-empty');
      }
      if (target.knowledgeUnitRefs.isEmpty) {
        throw ArgumentError('Discovery target needs taught knowledge: ${target.id}');
      }
      for (final ref in target.knowledgeUnitRefs) {
        if (!planKnowledge.contains(ref)) {
          throw ArgumentError('Discovery target uses untaught knowledge: $ref');
        }
      }
    }
  }

  void _validateVerifiedKnowledgeRefs(Iterable<String> refs, {required String owner}) {
    for (final ref in refs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      if (unit == null || unit.status != KnowledgeStatus.verified) {
        throw ArgumentError('Invalid factual KnowledgeUnit "$ref" on $owner');
      }
      if (unit.sourceRefs.isEmpty) {
        throw ArgumentError('Factual KnowledgeUnit has no source "$ref" on $owner');
      }
      _validateKnownSources(unit.sourceRefs, owner: ref);
    }
  }

  void _validateKnownSources(Iterable<String> refs, {required String owner}) {
    for (final ref in refs) {
      if (!knowledgeUniverse.sourceByRef.containsKey(ref)) {
        throw ArgumentError('Invalid sourceRef "$ref" on $owner');
      }
    }
  }

  List<String> _sourceRefsForKnowledge(Iterable<String> refs) {
    final sources = <String>{};
    for (final ref in refs) {
      final unit = knowledgeUniverse.knowledgeById[ref];
      if (unit == null) {
        throw ArgumentError('Invalid KnowledgeUnit: $ref');
      }
      sources.addAll(unit.sourceRefs);
    }
    final sorted = sources.toList(growable: false)..sort();
    return List<String>.unmodifiable(sorted);
  }

  static bool _sameStrings(List<String> left, List<String> right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index += 1) {
      if (left[index] != right[index]) return false;
    }
    return true;
  }
}
