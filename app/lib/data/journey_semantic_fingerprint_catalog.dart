import 'journey_semantic_fingerprint_baseline_snapshot.dart' as baseline;

/// Machine-controlled dimensions used by the Phoenix semantic anti-template gate.
enum NarrativeSemanticDimension {
  openingMechanism,
  protagonistRolePattern,
  relationshipGeometry,
  goalMechanism,
  conflictMechanism,
  choiceMechanism,
  climaxMechanism,
  consequenceMechanism,
  transformationMechanism,
  endingMechanism,
  culturalAnchorFunction,
  artifactObjectNarrativeFunction,
  movementSpatialMechanism,
  temporalPressureMechanism,
  supportingCharacterFunction,
  dramaticEngineFamily,
}

/// Reusable causal families. Identifiers describe mechanisms, never cities,
/// character names, or Journey-specific landmarks.
enum NarrativeMechanismFamily {
  deadlineWithIdealizedTarget,
  incompleteKnowledgeOpportunity,
  lifeTransitionWithCarriedPast,
  farewellCompletionRitual,
  fieldAssignmentWithPurityModel,
  fieldSurveyWithPriorClassification,
  operationalFailureCountdown,
  creatorProvingIndependentJudgment,
  apprenticeSeekingCompleteUnderstanding,
  youngProfessionalAtTransition,
  localMoverTestingBelonging,
  fieldRecorderTestingAuthenticityModel,
  researcherTestingAuthenticityModel,
  technicianSeekingIndependentTrust,
  intergenerationalMentorToRecognizedAgency,
  mentorToEntrustedAgency,
  parentChildContinuityWithoutCareerControl,
  familyAsBelongingAnchor,
  soloFieldworkAgainstInternalModel,
  supervisorToEntrustedResponsibility,
  produceIdealArtifact,
  completeKnowledgeRecord,
  crossIntoNewRoleWithoutPast,
  completeFarewellCircuit,
  capturePurifiedRecord,
  validatePriorAuthenticityModel,
  restoreCompleteOperationalResult,
  aestheticPerfectionVsRelationalTrace,
  completeResultVsResponsibleBoundary,
  ruptureVsContinuity,
  addressChangeVsBelongingContinuity,
  purityModelVsLivedEvidence,
  sacrificeIdealResultToPreserveRelationalEvidence,
  responsibleRefusalOfAvailableShortcut,
  carryPastObjectIntoChosenFuture,
  continueBeyondDeclaredFinish,
  reviseClassificationInsteadOfFilteringEvidence,
  forcedTradeoffCreatesNewFrame,
  refusalAtAvailableThreshold,
  spatialCrossingTriggersContinuityRecognition,
  completedCircuitBecomesDeparturePoint,
  evidenceReclassificationEnactedInArtifact,
  operationalRefusalLeavesVisibleIncompletion,
  sacrificedIdealCreatesAlternativeArtifact,
  intentionalVisibleIncompletion,
  carriedObjectCrossesIdentityBoundary,
  completedRecordExtendsBeyondOriginalBoundary,
  retainedEvidencePreservesReclassification,
  independenceReframedAsTraceableResponsibility,
  completionDriveToResponsibleRestraint,
  cleanBreakModelToContinuityModel,
  boundedBelongingToContinuingBelonging,
  purityModelToLayeredAuthenticity,
  intergenerationalObjectEntrustment,
  responsibilityTransferAfterRestraint,
  arrivalWithCarriedContinuityObject,
  artifactRecordsOpenContinuation,
  revisedArtifactRecordsChangedUnderstanding,
  restorationTraceMakesTimeReadable,
  heritageBoundaryMakesRestraintMeaningful,
  riverFlowConnectsCommercialEras,
  fortificationBoundaryReframesBelonging,
  livedCulturalLandscapeDisprovesPurity,
  livedUseDisprovesFrozenAuthenticity,
  heritageOperationsConstrainSpectacle,
  inheritedPhotographForcesRelationalChoice,
  mapBlankRecordsChosenBoundary,
  carriedTradeDocumentConnectsEras,
  runningRecordTurnsFinishIntoContinuation,
  fieldRecordingStoresReclassifiedEvidence,
  markedSurveyStoresReclassifiedEvidence,
  statusRecordTransfersOperationalOwnership,
  vantageSearchThenRecomposition,
  approachToUncrossedThreshold,
  oneWayCrossingBetweenContrastedBanks,
  closedCircuitThenOutboundContinuation,
  linearFieldTransectWithReorientation,
  comparativeFieldSurveyWithReturn,
  fixedFailureZoneDecision,
  expiringCreativeOpportunity,
  openAccessWithoutExternalDeadline,
  nextDayLifeTransition,
  selfDeclaredFinalOccurrence,
  approachingWeatherWindow,
  fieldDayThenSubmission,
  explicitOperationalCountdown,
  elderEmbodiesPriorKnowledgeThenEntrusts,
  mentorDefinesBoundaryThenWithholdsIntervention,
  parentOffersObjectWithoutBlockingDeparture,
  familyMessageReorientsMeaningOfDestination,
  noDecisiveSupportingCharacter,
  supervisorAbsentForChoiceThenTransfersOwnership,
  forcedTradeoffReframesCreativeAuthorship,
  spatialCrossingReframesTemporalContinuity,
  completedClosureBecomesOpenContinuation,
  evidenceForcesReclassification,

  // Reusable families introduced by Forbidden City debt remediation.
  dualValidRoutesCreateOpeningContradiction,
  crossRolePeerPerspectiveExchange,
  makePluralRouteRelationsLegible,
  singleAuthoritativeRouteVsCoexistingValidRoutes,
  preserveBothRoutesThroughOverlay,
  sharedNodeRevealsOverlapAndDivergence,
  compositeRepresentationAddsRelationalInformation,
  singleRouteTruthToRoleDependentSpatialSystem,
  sharedNodeThenPurposefulDivergence,
  roleDifferentiatedArchitectureMakesPluralRoutesLegible,
  overlaidRoutesPreserveCoexistingPerspectives,
  compareAlignOverlayThenDiverge,
  singleStudyDayWithoutExternalCountdown,
  peerContributesIndependentRoutePerspective,
  coexistingValidPerspectivesSynthesizeRelationalModel,
}

const Set<NarrativeSemanticDimension> narrativeSemanticCoreDimensions = {
  NarrativeSemanticDimension.openingMechanism,
  NarrativeSemanticDimension.conflictMechanism,
  NarrativeSemanticDimension.choiceMechanism,
  NarrativeSemanticDimension.climaxMechanism,
  NarrativeSemanticDimension.consequenceMechanism,
  NarrativeSemanticDimension.transformationMechanism,
  NarrativeSemanticDimension.endingMechanism,
  NarrativeSemanticDimension.relationshipGeometry,
  NarrativeSemanticDimension.culturalAnchorFunction,
  NarrativeSemanticDimension.dramaticEngineFamily,
};

const int semanticCollisionSameEngineAdditionalCoreThreshold = 3;
const int semanticCollisionIndependentCoreThreshold = 4;
const String semanticTemplateCollisionNotGoldReady =
    'TEMPLATE COLLISION - NOT GOLD READY';
const String activeGoldStorySourceId = 'active-lv1-lv10-story-package';

class NarrativeMechanismEvidence {
  const NarrativeMechanismEvidence({
    required this.journeyId,
    required this.dimension,
    required this.mechanism,
    required this.activeSourceId,
    required this.sourceTexts,
    required this.semanticRationale,
  });

  final String journeyId;
  final NarrativeSemanticDimension dimension;
  final NarrativeMechanismFamily mechanism;
  final String activeSourceId;
  final List<String> sourceTexts;
  final String semanticRationale;

  String get sourceText => sourceTexts.isEmpty ? '' : sourceTexts.first;
}

class JourneySemanticFingerprint {
  const JourneySemanticFingerprint({
    required this.journeyId,
    required this.surfaceIdentity,
    required this.mechanisms,
    required this.coreEvidence,
  });

  final String journeyId;
  final String surfaceIdentity;
  final Map<NarrativeSemanticDimension, NarrativeMechanismFamily> mechanisms;
  final List<NarrativeMechanismEvidence> coreEvidence;

  NarrativeMechanismFamily mechanism(NarrativeSemanticDimension dimension) =>
      mechanisms[dimension]!;
}

enum SemanticCollisionClassification {
  distinct,
  relatedButDistinct,
  semanticCollision,
  existingSemanticCollisionDebt,
}

class NarrativeSemanticComparison {
  const NarrativeSemanticComparison({
    required this.journeyA,
    required this.journeyB,
    required this.matchingCoreDimensions,
    required this.matchingSecondaryDimensions,
    required this.sameDramaticEngine,
    required this.ruleA,
    required this.ruleB,
    required this.classification,
  });

  final String journeyA;
  final String journeyB;
  final List<NarrativeSemanticDimension> matchingCoreDimensions;
  final List<NarrativeSemanticDimension> matchingSecondaryDimensions;
  final bool sameDramaticEngine;
  final bool ruleA;
  final bool ruleB;
  final SemanticCollisionClassification classification;

  int get coreMatchCount => matchingCoreDimensions.length;
  bool get isCollision => ruleA || ruleB;
}

class FutureGoldSemanticGateResult {
  const FutureGoldSemanticGateResult({
    required this.isGoldReady,
    required this.status,
    required this.comparisons,
  });

  final bool isGoldReady;
  final String status;
  final List<NarrativeSemanticComparison> comparisons;
}

NarrativeSemanticDimension _dimensionFromBaseline(
  baseline.NarrativeSemanticDimension value,
) =>
    NarrativeSemanticDimension.values.byName(value.name);

NarrativeMechanismFamily _mechanismFromBaseline(
  baseline.NarrativeMechanismFamily value,
) =>
    NarrativeMechanismFamily.values.byName(value.name);

JourneySemanticFingerprint _convertBaselineFingerprint(
  baseline.JourneySemanticFingerprint source,
) =>
    JourneySemanticFingerprint(
      journeyId: source.journeyId,
      surfaceIdentity: source.surfaceIdentity,
      mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
        for (final entry in source.mechanisms.entries)
          _dimensionFromBaseline(entry.key): _mechanismFromBaseline(entry.value),
      }),
      coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
        for (final evidence in source.coreEvidence)
          NarrativeMechanismEvidence(
            journeyId: evidence.journeyId,
            dimension: _dimensionFromBaseline(evidence.dimension),
            mechanism: _mechanismFromBaseline(evidence.mechanism),
            activeSourceId: evidence.activeSourceId,
            sourceTexts: List<String>.unmodifiable(evidence.sourceTexts),
            semanticRationale: evidence.semanticRationale,
          ),
      ]),
    );

const _forbidden = 'beijing-forbidden-city';

final _forbiddenFingerprint = JourneySemanticFingerprint(
  journeyId: _forbidden,
  surfaceIdentity:
      'Shen Yan / seventeen-year-old construction apprentice / A Ning / overlaid dual-route learning map',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.dualValidRoutesCreateOpeningContradiction,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.apprenticeSeekingCompleteUnderstanding,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.crossRolePeerPerspectiveExchange,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.makePluralRouteRelationsLegible,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.singleAuthoritativeRouteVsCoexistingValidRoutes,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.preserveBothRoutesThroughOverlay,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.sharedNodeRevealsOverlapAndDivergence,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.compositeRepresentationAddsRelationalInformation,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.singleRouteTruthToRoleDependentSpatialSystem,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.sharedNodeThenPurposefulDivergence,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.roleDifferentiatedArchitectureMakesPluralRoutesLegible,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.overlaidRoutesPreserveCoexistingPerspectives,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.compareAlignOverlayThenDiverge,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.singleStudyDayWithoutExternalCountdown,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.peerContributesIndependentRoutePerspective,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
  }),
  coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.openingMechanism,
      mechanism: NarrativeMechanismFamily.dualValidRoutesCreateOpeningContradiction,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '沈砚把自己的观察顺序连成一条清楚的线，直觉上认为“正确的空间图”应当收束为一个最权威的路线。',
        '阿宁在纸上画下这次具体行动的路线，明确只是自己的走法，不是官方历史路线。',
      ],
      semanticRationale:
          'The opening problem is generated by two action-grounded route representations that cannot both fit Shen Yan’s single-authoritative-route assumption; neither route is introduced as a shortcut or failure.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.conflictMechanism,
      mechanism: NarrativeMechanismFamily.singleAuthoritativeRouteVsCoexistingValidRoutes,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '两张图都忠实于各自行动，却在“只有一条正确路径”的假设下彼此冲突。',
        '沈砚没有把问题解决成谁对谁错。',
      ],
      semanticRationale:
          'Both routes remain valid descriptions of different actors’ movement, so the conflict is between a single-route authority model and simultaneous route validity, not bad model versus disproving evidence.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.choiceMechanism,
      mechanism: NarrativeMechanismFamily.preserveBothRoutesThroughOverlay,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '沈砚于是选择合成，而不是裁决。',
        '他用实线与点线在同一张纸上保留两条完整路线，标出共享节点、重合段与分岔，使建筑结构和人的目的同时可读。',
      ],
      semanticRationale:
          'Shen Yan enacts synthesis by preserving both complete paths in distinguishable line styles instead of refusing an opportunity, deleting one route, or correcting one into the other.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.climaxMechanism,
      mechanism: NarrativeMechanismFamily.sharedNodeRevealsOverlapAndDivergence,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '路线在乾清门前短暂重合，又因角色和目的不同向不同方向延伸。',
        '这个重合与分岔同时出现的瞬间成为关键：如果擦掉任何一条，图都会失去真实关系。',
      ],
      semanticRationale:
          'The decisive discovery is produced by spatial alignment itself: the lines share a node and then diverge for different purposes, revealing a relation that cannot exist if either perspective is erased.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.consequenceMechanism,
      mechanism: NarrativeMechanismFamily.compositeRepresentationAddsRelationalInformation,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '复合图揭示了两张原图单独都没有表达出的关系：同一宫城并不是一张“人人同路”的平面，建筑的轴线、宫门、庭院与功能分区提供共同空间骨架，不同角色则因行动目的而形成不同的合法叙事视角。',
      ],
      semanticRationale:
          'The enacted overlay produces additional relational information about shared structure and differentiated movement; the consequence is informational plurality rather than visible incompletion.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.transformationMechanism,
      mechanism: NarrativeMechanismFamily.singleRouteTruthToRoleDependentSpatialSystem,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '沈砚把自己的观察顺序连成一条清楚的线，直觉上认为“正确的空间图”应当收束为一个最权威的路线。',
        '复合图揭示了两张原图单独都没有表达出的关系：同一宫城并不是一张“人人同路”的平面，建筑的轴线、宫门、庭院与功能分区提供共同空间骨架，不同角色则因行动目的而形成不同的合法叙事视角。',
      ],
      semanticRationale:
          'His spatial model changes from one definitive route to a role- and purpose-dependent system in which common architecture supports several simultaneously valid movement logics.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.endingMechanism,
      mechanism: NarrativeMechanismFamily.sharedNodeThenPurposefulDivergence,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '傍晚，沈砚与阿宁从共同节点分别，继续各自要做的事。',
        '一张叠着两条路线的图留在纸上，两条线都清楚、都完整，也彼此说明。',
      ],
      semanticRationale:
          'The two participants continue along different purpose-appropriate paths while the final artifact preserves both; no mentor reward or transfer of authority closes the Story.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.relationshipGeometry,
      mechanism: NarrativeMechanismFamily.crossRolePeerPerspectiveExchange,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '年幼侍役阿宁看后却说，自己今天从东侧空间接近乾清门前，随后还要转向另一处，因此不会沿沈砚的整条线移动。',
        '他与阿宁把两张纸按共同宫门、庭院方向和乾清门前的位置逐点对齐，并追问每段路线在做什么。',
      ],
      semanticRationale:
          'A Ning contributes information Shen Yan cannot generate from his own movement, and the two young characters jointly compare their representations; the mentor does not own the decisive synthesis.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.culturalAnchorFunction,
      mechanism: NarrativeMechanismFamily.roleDifferentiatedArchitectureMakesPluralRoutesLegible,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '午门是紫禁城正门，位于南北轴线上；外朝的核心殿宇、开阔庭院和层层门序共同形成强烈的轴线秩序。',
        '乾清门既是内廷正宫门，也是连接内廷与外朝往来的重要通道。',
        '建筑的轴线、宫门、庭院与功能分区提供共同空间骨架，不同角色则因行动目的而形成不同的合法叙事视角。',
      ],
      semanticRationale:
          'Verified Forbidden City axis, gate, courtyard, and Outer/Inner Court relationships supply the shared architectural framework that makes route overlap and role-dependent divergence meaningful and non-interchangeable with a generic setting.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _forbidden,
      dimension: NarrativeSemanticDimension.dramaticEngineFamily,
      mechanism: NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '两张图都忠实于各自行动，却在“只有一条正确路径”的假设下彼此冲突。',
        '沈砚没有把问题解决成谁对谁错。',
        '沈砚于是选择合成，而不是裁决。',
        '路线在乾清门前短暂重合，又因角色和目的不同向不同方向延伸。',
        '一张叠着两条路线的图留在纸上，两条线都清楚、都完整，也彼此说明。',
      ],
      semanticRationale:
          'The causal engine requires two valid partial perspectives, comparison without falsification, enacted composite synthesis, and a relation visible only after overlay; it is neither refusal/incompletion nor evidence-driven category replacement.',
    ),
  ]),
);

final Map<String, JourneySemanticFingerprint> approvedGoldSemanticFingerprints =
    Map<String, JourneySemanticFingerprint>.unmodifiable({
  for (final entry in baseline.approvedGoldSemanticFingerprints.entries)
    entry.key: entry.key == _forbidden
        ? _forbiddenFingerprint
        : _convertBaselineFingerprint(entry.value),
});

String activeCanonicalGoldStoryText(String journeyId) =>
    baseline.activeCanonicalGoldStoryText(journeyId);

List<String> semanticFingerprintCompletenessErrors(
  JourneySemanticFingerprint fingerprint,
) {
  final errors = <String>[];
  for (final dimension in NarrativeSemanticDimension.values) {
    if (!fingerprint.mechanisms.containsKey(dimension)) {
      errors.add('${fingerprint.journeyId}: missing ${dimension.name}');
    }
  }
  final evidenceByDimension =
      <NarrativeSemanticDimension, List<NarrativeMechanismEvidence>>{};
  for (final evidence in fingerprint.coreEvidence) {
    evidenceByDimension.putIfAbsent(evidence.dimension, () => []).add(evidence);
  }
  for (final dimension in narrativeSemanticCoreDimensions) {
    final records = evidenceByDimension[dimension] ?? const [];
    if (records.isEmpty) {
      errors.add('${fingerprint.journeyId}: missing evidence ${dimension.name}');
      continue;
    }
    if (records.length != 1) {
      errors.add('${fingerprint.journeyId}: duplicate evidence ${dimension.name}');
      continue;
    }
    if (records.single.mechanism != fingerprint.mechanism(dimension)) {
      errors.add('${fingerprint.journeyId}: evidence mismatch ${dimension.name}');
    }
  }
  return errors;
}

List<String> semanticEvidenceProvenanceErrors(
  JourneySemanticFingerprint fingerprint,
) {
  final story = activeCanonicalGoldStoryText(fingerprint.journeyId);
  final errors = <String>[];
  for (final evidence in fingerprint.coreEvidence) {
    final prefix = '${fingerprint.journeyId}:${evidence.dimension.name}';
    if (evidence.journeyId != fingerprint.journeyId) {
      errors.add('$prefix:journey');
    }
    if (evidence.activeSourceId != activeGoldStorySourceId) {
      errors.add('$prefix:activeSourceId');
    }
    if (evidence.sourceTexts.isEmpty) {
      errors.add('$prefix:missing-source-text');
      continue;
    }
    for (var index = 0; index < evidence.sourceTexts.length; index++) {
      final sourceText = evidence.sourceTexts[index];
      if (sourceText.trim().isEmpty) {
        errors.add('$prefix:empty-source-text-$index');
      } else if (!story.contains(sourceText)) {
        errors.add('$prefix:source-not-in-active-story-$index');
      }
    }
  }
  return errors;
}

List<String> semanticEvidenceContractErrors(
  JourneySemanticFingerprint fingerprint,
) {
  final errors = <String>[
    ...semanticFingerprintCompletenessErrors(fingerprint),
    ...semanticEvidenceProvenanceErrors(fingerprint),
  ];
  for (final evidence in fingerprint.coreEvidence) {
    final prefix = '${fingerprint.journeyId}:${evidence.dimension.name}';
    if (!narrativeSemanticCoreDimensions.contains(evidence.dimension)) {
      errors.add('$prefix:not-core');
    }
    if (fingerprint.mechanisms[evidence.dimension] != evidence.mechanism) {
      errors.add('$prefix:mechanism-mismatch');
    }
    if (evidence.semanticRationale.trim().isEmpty) {
      errors.add('$prefix:missing-semantic-rationale');
    }
  }
  return errors;
}

List<String> semanticEvidenceFidelityErrors(
  JourneySemanticFingerprint fingerprint,
) =>
    semanticEvidenceProvenanceErrors(fingerprint);

NarrativeSemanticComparison compareSemanticFingerprints(
  JourneySemanticFingerprint left,
  JourneySemanticFingerprint right, {
  bool approvedCatalogAudit = false,
}) {
  final matchingCore = <NarrativeSemanticDimension>[];
  final matchingSecondary = <NarrativeSemanticDimension>[];
  for (final dimension in NarrativeSemanticDimension.values) {
    if (left.mechanism(dimension) != right.mechanism(dimension)) continue;
    if (narrativeSemanticCoreDimensions.contains(dimension)) {
      matchingCore.add(dimension);
    } else {
      matchingSecondary.add(dimension);
    }
  }

  final sameEngine =
      left.mechanism(NarrativeSemanticDimension.dramaticEngineFamily) ==
          right.mechanism(NarrativeSemanticDimension.dramaticEngineFamily);
  final additionalCoreMatches = matchingCore
      .where(
        (dimension) =>
            dimension != NarrativeSemanticDimension.dramaticEngineFamily,
      )
      .length;
  final ruleA = sameEngine &&
      additionalCoreMatches >=
          semanticCollisionSameEngineAdditionalCoreThreshold;
  final ruleB =
      matchingCore.length >= semanticCollisionIndependentCoreThreshold;
  final collision = ruleA || ruleB;

  final classification = collision
      ? (approvedCatalogAudit
          ? SemanticCollisionClassification.existingSemanticCollisionDebt
          : SemanticCollisionClassification.semanticCollision)
      : (matchingCore.isNotEmpty || matchingSecondary.isNotEmpty
          ? SemanticCollisionClassification.relatedButDistinct
          : SemanticCollisionClassification.distinct);

  return NarrativeSemanticComparison(
    journeyA: left.journeyId,
    journeyB: right.journeyId,
    matchingCoreDimensions: List.unmodifiable(matchingCore),
    matchingSecondaryDimensions: List.unmodifiable(matchingSecondary),
    sameDramaticEngine: sameEngine,
    ruleA: ruleA,
    ruleB: ruleB,
    classification: classification,
  );
}

List<NarrativeSemanticComparison> semanticDifferenceMatrixAgainstApprovedGold(
  JourneySemanticFingerprint candidate,
) =>
    List<NarrativeSemanticComparison>.unmodifiable([
      for (final reference in approvedGoldSemanticFingerprints.values)
        if (reference.journeyId != candidate.journeyId)
          compareSemanticFingerprints(candidate, reference),
    ]);

List<NarrativeSemanticComparison> auditApprovedGoldSemanticPairs() {
  final catalog = approvedGoldSemanticFingerprints.values.toList(growable: false);
  final results = <NarrativeSemanticComparison>[];
  for (var i = 0; i < catalog.length; i++) {
    for (var j = i + 1; j < catalog.length; j++) {
      results.add(
        compareSemanticFingerprints(
          catalog[i],
          catalog[j],
          approvedCatalogAudit: true,
        ),
      );
    }
  }
  return List<NarrativeSemanticComparison>.unmodifiable(results);
}

FutureGoldSemanticGateResult evaluateFutureGoldSemanticCandidate(
  JourneySemanticFingerprint candidate,
) {
  final comparisons = semanticDifferenceMatrixAgainstApprovedGold(candidate);
  final collisions =
      comparisons.where((comparison) => comparison.isCollision).toList();
  return FutureGoldSemanticGateResult(
    isGoldReady: collisions.isEmpty,
    status: collisions.isEmpty
        ? 'SEMANTIC ANTI-TEMPLATE PASS'
        : semanticTemplateCollisionNotGoldReady,
    comparisons: comparisons,
  );
}
