import 'guangzhou_chen_clan_one_pass.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'luoyang_longmen_gold.dart';
import 'journey_expansion_catalog.dart';
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

  // Reusable families introduced by Chengdu shared-space debt remediation.
  immediateSharedUseContentionAtThreshold,
  serviceHostManagingChangingSharedSpace,
  serviceParticipantNegotiatedHandoff,
  maintainUsabilityAcrossSequentialUses,
  fixedAssignmentVsTimeDependentSharedUse,
  facilitateHandoffInsteadOfPermanentAllocation,
  participantIndependentlyReproducesHandoff,
  repeatedHandoffsSustainSharedUsability,
  controllerToSharedRhythmFacilitator,
  sharedProtocolContinuesBeyondFacilitator,
  historicCourtyardMorphologyConstrainsSharedUse,
  movableObjectEmbodiesTemporaryClaim,
  thresholdRepositioningAcrossSequentialUses,
  singleAfternoonUseCycleWithoutDeadline,
  regularParticipantLearnsAndReproducesProtocol,
  repeatedSpatialHandoffsCreateSharedUseProtocol,

  // Reusable families introduced by Guangzhou cross-medium making.
  prototypeFailureExposesMediumConstraint,
  youngMakerTranslatingHistoricCraft,
  peerMakersTestFidelityThroughPrototype,
  preserveSourceRelationInNewMedium,
  literalCopyVsMaterialSpecificStructure,
  reencodeConnectionsForNewMedium,
  translatedPrototypeSurvivesAndRemainsLegible,
  changedFormFunctionsInNewMedium,
  surfaceCopyistToMaterialTranslator,
  translationMethodCarriesIntoNextMaterial,
  multiCraftArchitectureMakesMaterialDifferenceCausal,
  prototypeEmbodiesMediumSpecificTranslation,
  observePrototypeReviseMaterialTranslation,
  peerTestsLegibilityWithoutMentorAuthority,
  materialConstraintForcesCrossMediumReencoding,

  // Reusable families introduced by caregiver/child visibility release.
  impendingIndependentTravelRehearsal,
  dailyCaregiverReleasingVisualControl,
  caregiverChildReciprocalAdjustment,
  practiceIndependentMovementWithoutBreakingCare,
  continuousVisibilityVsAgeAppropriateSeparation,
  withholdProtectiveRecall,
  completeIntervalWithoutVisualContact,
  childWaitsAndLooksBackWithoutRecall,
  vigilanceToReciprocalTrust,
  separationAndWaitingContinueWithoutPursuit,
  layeredSightlinesCreateLossAndRecoveryOfView,
  raisedThenLoweredHandEmbodiesRestraint,
  repeatedOcclusionAndReappearance,
  lastWalkBeforeIndependentRoutine,
  childAcceptsResponsibilityToWaitAndLookBack,
  releasedVisualControlCreatesReciprocalWaiting,

  // Reusable families introduced by private kinship boundary protection.
  privateReunionWithNoPublicProofAgreement,
  estrangedBirthMotherSeekingContinuedContact,
  birthMotherAdultDaughterWithRemoteKinPressure,
  continueContactWithoutErasingPresentIdentity,
  publicKinshipProofVsAdultChildBoundary,
  refusePublicImageAndNamePresentIdentity,
  faceDownPhoneRejectsCollectiveRecognition,
  noReunionPhotoButPrivateWalkContinues,
  hopedForRestorationToConsentBasedContinuation,
  thresholdSlowdownContinuesUnrepairedRelationship,
  pooledLineageInstitutionIntensifiesSurnameClaim,
  phoneAsRefusedPublicProof,
  courtyardProgressionUnderRemoteFamilyGaze,
  unplannedLiveFamilyCall,
  daughterSetsBoundaryAndOffersSmallContinuation,
  publicKinshipProofSacrificedForPresentIdentity,

  // Reusable families introduced by the reopened older-spouse memory Story.
  concealedClinicVisitBehindFamiliarWalk,
  olderSpouseTestingPartnersMemory,
  longMarriedSpousesConcealSharedFear,
  verifySharedPastThroughPlaceNameAnswers,
  memoryQuizVsHonestMedicalDisclosure,
  stopTestingAndHandOverAppointment,
  embodiedCareInterruptsVerbalMemoryTest,
  appointmentAcceptedAndHospitalRouteRequested,
  proofSeekingToMutualAdmission,
  hospitalQuestionEndsConcealment,
  namedSeasonalViewsCueConflictingMemory,
  appointmentCardEmbodiesNamedFear,
  questioningWalkToWetStepAndBus,
  weekendBeforeMemoryClinic,
  spouseAcknowledgesFearAndKeepsCard,
  embodiedRecognitionEndsHiddenMemoryExam,

  // Reusable families introduced by Longmen adult-sibling shared-agency remediation.
  jointAssetDeadlineCreatedBeforeSharedConsent,
  responsibleSiblingEquatingBurdenWithAuthority,
  adultSiblingsNegotiatingFutureSharedAgency,
  completeJointTransactionWithoutLosingSharedAgency,
  administrativeBurdenVsEqualDecisionParticipation,
  acceptFinancialLossToPreserveFutureParticipation,
  withdrawExecutableConsentAtLastMoment,
  deadlinePassesWhileJointOwnershipRemains,
  unilateralControlTowardPriorConsultation,
  futureProcessRequestAcceptedWithoutFullRepair,
  nearFarViewingRequirementDisruptsDeadlinePace,
  destroyedConsentPageEmbodiesRefusedExchange,
  alternatingCloseAndDistantViewingAlongLinearRoute,
  sameDayTransactionDeadlineBackedBySunkDeposit,
  siblingSetsExitPriceThenRequestsFutureInclusion,
  sunkFinancialCostPreservesRelationalDecisionRights,
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
const _chengdu = 'chengdu-kuanzhai-alley';
const _guangzhou = guangzhouChenClanJourneyId;

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

final _chengduFingerprint = JourneySemanticFingerprint(
  journeyId: _chengdu,
  surfaceIdentity:
      'Lin Xia / twenty-four-year-old fictional courtyard teahouse host / Zhou Shu / movable bamboo chair',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.immediateSharedUseContentionAtThreshold,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.serviceHostManagingChangingSharedSpace,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.serviceParticipantNegotiatedHandoff,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.maintainUsabilityAcrossSequentialUses,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.fixedAssignmentVsTimeDependentSharedUse,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.facilitateHandoffInsteadOfPermanentAllocation,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.participantIndependentlyReproducesHandoff,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.repeatedHandoffsSustainSharedUsability,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.controllerToSharedRhythmFacilitator,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.sharedProtocolContinuesBeyondFacilitator,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.historicCourtyardMorphologyConstrainsSharedUse,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.movableObjectEmbodiesTemporaryClaim,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.thresholdRepositioningAcrossSequentialUses,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.singleAfternoonUseCycleWithoutDeadline,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.regularParticipantLearnsAndReproducesProtocol,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol,
  }),
  coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.openingMechanism,
      mechanism: NarrativeMechanismFamily.immediateSharedUseContentionAtThreshold,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她把一把普通竹椅放到门边，常来的周叔习惯坐在靠入口的茶桌旁，既能喝茶，也能看见巷子。',
        '周叔刚落座，服务员托着茶盘进门，椅背便压缩了转身空间。',
      ],
      semanticRationale:
          'The Story opens on one threshold immediately needed by two legitimate uses, making physical contention visible before exposition.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.conflictMechanism,
      mechanism: NarrativeMechanismFamily.fixedAssignmentVsTimeDependentSharedUse,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '第二个方案也失败了。林夏开始烦躁，因为每一种永久安排都只适合刚才那一刻。',
        '真正冲突的是院落入口的有限空间与不断变化的使用时序：同一小块地方不能永久交给一种用途，却可以在不同时间服务不同的人。',
      ],
      semanticRationale:
          'The conflict is spatial and temporal: permanent allocation cannot serve legitimate uses that recur at different moments.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.choiceMechanism,
      mechanism: NarrativeMechanismFamily.facilitateHandoffInsteadOfPermanentAllocation,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '林夏放弃给竹椅指定永久归属，改成亲手建立交接节奏。',
        '她邀请周叔一起留意下一次需要，谁先看见，谁先移动，不必等她发令。',
      ],
      semanticRationale:
          'Lin Xia enacts the choice by replacing permanent allocation with a temporary yield-and-return handoff shared with another participant.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.climaxMechanism,
      mechanism: NarrativeMechanismFamily.participantIndependentlyReproducesHandoff,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '周叔先看见来人，没有喊她，也没有等提示，自己起身把竹椅挪到院墙边；客人跨过门槛进入院落后，他又把椅子推回茶桌旁，继续喝茶。',
      ],
      semanticRationale:
          'The climax is behavioral replication by Zhou Shu without instruction, proving the protocol has become shared social choreography.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.consequenceMechanism,
      mechanism: NarrativeMechanismFamily.repeatedHandoffsSustainSharedUsability,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '茶客继续停留，服务人员继续穿行，院落在一轮轮临时交接中保持可用。',
      ],
      semanticRationale:
          'The consequence is continued usability across sequential tea, service, and passage rather than a revised record or sacrificed result.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.transformationMechanism,
      mechanism: NarrativeMechanismFamily.controllerToSharedRhythmFacilitator,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她一向相信，把桌椅一次摆到“正确位置”才算把空间管好，于是趁入口暂时空下，重新调整竹椅，想给它一个整日下午都不用改变的固定位置。',
        '她没有再伸手，也没有把椅子校正到某个标准点。',
      ],
      semanticRationale:
          'Lin Xia changes from personally controlling permanent placement to allowing participants to carry a shared use rhythm themselves.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.endingMechanism,
      mechanism: NarrativeMechanismFamily.sharedProtocolContinuesBeyondFacilitator,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '最后，一位离桌的客人顺手又为经过的人移开同一把竹椅。',
        '林夏看着那只手完成动作，没有出声。',
        '一把没有固定位置的竹椅，已经把共享空间的节奏交给了下一位使用者。',
      ],
      semanticRationale:
          'The ending proves continuation beyond Lin Xia because a further participant performs the handoff while she deliberately does not intervene.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.relationshipGeometry,
      mechanism: NarrativeMechanismFamily.serviceParticipantNegotiatedHandoff,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她邀请周叔一起留意下一次需要，谁先看见，谁先移动，不必等她发令。',
        '周叔先看见来人，没有喊她，也没有等提示，自己起身把竹椅挪到院墙边；客人跨过门槛进入院落后，他又把椅子推回茶桌旁，继续喝茶。',
      ],
      semanticRationale:
          'Host and regular negotiate and then jointly perform the practical handoff; Zhou Shu is causal rather than a mentor delivering interpretation.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.culturalAnchorFunction,
      mechanism: NarrativeMechanismFamily.historicCourtyardMorphologyConstrainsSharedUse,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '宽巷子、窄巷子与井巷子构成历史街区的核心街巷，沿巷院落把街面的流动收进更小的入口、门槛和内部停留空间。',
        '真正冲突的是院落入口的有限空间与不断变化的使用时序：同一小块地方不能永久交给一种用途，却可以在不同时间服务不同的人。',
      ],
      semanticRationale:
          'Kuanzhai street-lane-courtyard morphology is causal because its threshold compresses tea stopping and circulation into the shared zone that requires handoff.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _chengdu,
      dimension: NarrativeSemanticDimension.dramaticEngineFamily,
      mechanism: NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '林夏放弃给竹椅指定永久归属，改成亲手建立交接节奏。',
        '起初周叔仍看她一眼才动，后来服务员端茶、客人离院、另一桌有人经过，竹椅反复几次让位又归还，动作越来越自然。',
        '周叔先看见来人，没有喊她，也没有等提示，自己起身把竹椅挪到院墙边；客人跨过门槛进入院落后，他又把椅子推回茶桌旁，继续喝茶。',
        '最后，一位离桌的客人顺手又为经过的人移开同一把竹椅。',
      ],
      semanticRationale:
          'The engine requires repeated physical yield-and-return handoffs until participants reproduce the behavior independently; no evidence classification, representational synthesis, refusal, or artifact correction drives the change.',
    ),
  ]),
);

final guangzhouChenClanLegacyPaperBridgeSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _guangzhou,
  surfaceIdentity:
      'Liang Yao / twenty-two-year-old fictional printmaking student / He Zhen ceramics peer / connected single-sheet paper prototype',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.prototypeFailureExposesMediumConstraint,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.youngMakerTranslatingHistoricCraft,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.peerMakersTestFidelityThroughPrototype,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.preserveSourceRelationInNewMedium,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.literalCopyVsMaterialSpecificStructure,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.reencodeConnectionsForNewMedium,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.translatedPrototypeSurvivesAndRemainsLegible,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.changedFormFunctionsInNewMedium,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.surfaceCopyistToMaterialTranslator,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.translationMethodCarriesIntoNextMaterial,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.multiCraftArchitectureMakesMaterialDifferenceCausal,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.prototypeEmbodiesMediumSpecificTranslation,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.observePrototypeReviseMaterialTranslation,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.singleStudyDayWithoutExternalCountdown,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.peerTestsLegibilityWithoutMentorAuthority,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.materialConstraintForcesCrossMediumReencoding,
  }),
  coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.openingMechanism,
      mechanism: NarrativeMechanismFamily.prototypeFailureExposesMediumConstraint,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她的第一件原型却在桌面上散开：她把每一道看见的轮廓都当成必须照搬的边界，剪到两组形体之间时，纸上原本承担连接的部分也被一起去掉，几个部分随即断开。',
      ],
      semanticRationale:
          'The causal problem enters as a physical prototype failure produced by the new medium, not as exposition, missing evidence, a route conflict, or an operational shortcut.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.conflictMechanism,
      mechanism: NarrativeMechanismFamily.literalCopyVsMaterialSpecificStructure,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她把散开的几片重新并在桌上，发现最后被剪掉的正是让整张纸保持相连的部分。原来的形体可以依靠材料和基底保持关系，单张薄纸却需要自己的连接。',
        '字面复制越彻底，单张纸反而越无法成为一件东西。',
      ],
      semanticRationale:
          'Literal surface fidelity directly destroys the structural connectedness required by paper, so the conflict belongs to medium-specific making rather than authenticity classification or responsible refusal.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.choiceMechanism,
      mechanism: NarrativeMechanismFamily.reencodeConnectionsForNewMedium,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她停下逐线描摹，在第二张自己的纸上重新编码连接：保留主要形体的相对位置，却在原本会断开的地方留下窄窄的纸桥。',
      ],
      semanticRationale:
          'Liang Yao enacts the choice on her own second sheet by deliberately changing the connection encoding instead of sacrificing the goal, rejecting a shortcut, or revising a classification.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.climaxMechanism,
      mechanism: NarrativeMechanismFamily.translatedPrototypeSurvivesAndRemainsLegible,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她剪完第二件原型，从一角把它提起；整张纸没有散开。',
        '贺真把草图扣在桌面，只看成品。几秒后，他准确指出两组主要形体之间原先最重要的相接关系。',
      ],
      semanticRationale:
          'The climax is a two-part physical test: the translated object survives handling as one piece and a peer independently confirms the important visual relation remains legible.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.consequenceMechanism,
      mechanism: NarrativeMechanismFamily.changedFormFunctionsInNewMedium,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '梁遥改变连接后，纸桥改变了局部轮廓，却让整张纸既能被拿起，也没有丢掉那组相接关系。',
      ],
      semanticRationale:
          'The revised form succeeds according to the new medium’s logic; its changed geometry creates both structural function and legibility rather than leaving a responsible defect.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.transformationMechanism,
      mechanism: NarrativeMechanismFamily.surfaceCopyistToMaterialTranslator,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她在笔记本上把“照着表面复制”划掉，写下“先问材料怎样连接”。',
      ],
      semanticRationale:
          'Her working rule changes from copying source contours to interrogating how a target material must carry relations, marking a maker-level transformation rather than a theory-only conclusion.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.endingMechanism,
      mechanism: NarrativeMechanismFamily.translationMethodCarriesIntoNextMaterial,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '回到工作室，她拿起一块新的版材，先标出这种材料必须保留的连接，再开始下一次材料研究。',
      ],
      semanticRationale:
          'The ending is enacted continuation of the new translation method on a fresh material problem, not a mentor judgment, philosophical summary, record correction, or farewell continuation engine.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.relationshipGeometry,
      mechanism: NarrativeMechanismFamily.peerMakersTestFidelityThroughPrototype,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠观察建筑装饰。',
        '贺真把草图扣在桌面，只看成品。几秒后，他准确指出两组主要形体之间原先最重要的相接关系。',
      ],
      semanticRationale:
          'He Zhen is a maker peer whose independent recognition tests the translated prototype; he neither mentors Liang Yao nor transfers authority to her.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.culturalAnchorFunction,
      mechanism: NarrativeMechanismFamily.multiCraftArchitectureMakesMaterialDifferenceCausal,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '陈家祠集中展示多种岭南装饰工艺，正因为材料并不相同，梁遥把“材料怎样让形体相接”当成观察重点。',
      ],
      semanticRationale:
          'The verified multi-craft character of the Chen Clan Academy makes material difference causal to Liang Yao’s making question, while factual craft enumeration remains in Discovery.',
    ),
    const NarrativeMechanismEvidence(
      journeyId: _guangzhou,
      dimension: NarrativeSemanticDimension.dramaticEngineFamily,
      mechanism: NarrativeMechanismFamily.materialConstraintForcesCrossMediumReencoding,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[
        '她的第一件原型却在桌面上散开：她把每一道看见的轮廓都当成必须照搬的边界，剪到两组形体之间时，纸上原本承担连接的部分也被一起去掉，几个部分随即断开。',
        '她停下逐线描摹，在第二张自己的纸上重新编码连接：保留主要形体的相对位置，却在原本会断开的地方留下窄窄的纸桥。',
        '她剪完第二件原型，从一角把它提起；整张纸没有散开。',
        '贺真把草图扣在桌面，只看成品。几秒后，他准确指出两组主要形体之间原先最重要的相接关系。',
      ],
      semanticRationale:
          'The engine requires a material-caused physical failure, deliberate cross-medium re-encoding, and a successful structural-plus-legibility test. It is not tradeoff, synthesis, crossing, closure, reclassification, handoff, or refusal.',
    ),
  ]),
);

final guangzhouChenClanGoldSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _guangzhou,
  surfaceIdentity: 'birth-mother-turns-family-video-face-down-and-names-adult-daughter-Liu-Jiahe',
  mechanisms: const <NarrativeSemanticDimension, NarrativeMechanismFamily>{
    NarrativeSemanticDimension.openingMechanism: NarrativeMechanismFamily.privateReunionWithNoPublicProofAgreement,
    NarrativeSemanticDimension.protagonistRolePattern: NarrativeMechanismFamily.estrangedBirthMotherSeekingContinuedContact,
    NarrativeSemanticDimension.relationshipGeometry: NarrativeMechanismFamily.birthMotherAdultDaughterWithRemoteKinPressure,
    NarrativeSemanticDimension.goalMechanism: NarrativeMechanismFamily.continueContactWithoutErasingPresentIdentity,
    NarrativeSemanticDimension.conflictMechanism: NarrativeMechanismFamily.publicKinshipProofVsAdultChildBoundary,
    NarrativeSemanticDimension.choiceMechanism: NarrativeMechanismFamily.refusePublicImageAndNamePresentIdentity,
    NarrativeSemanticDimension.climaxMechanism: NarrativeMechanismFamily.faceDownPhoneRejectsCollectiveRecognition,
    NarrativeSemanticDimension.consequenceMechanism: NarrativeMechanismFamily.noReunionPhotoButPrivateWalkContinues,
    NarrativeSemanticDimension.transformationMechanism: NarrativeMechanismFamily.hopedForRestorationToConsentBasedContinuation,
    NarrativeSemanticDimension.endingMechanism: NarrativeMechanismFamily.thresholdSlowdownContinuesUnrepairedRelationship,
    NarrativeSemanticDimension.culturalAnchorFunction: NarrativeMechanismFamily.pooledLineageInstitutionIntensifiesSurnameClaim,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction: NarrativeMechanismFamily.phoneAsRefusedPublicProof,
    NarrativeSemanticDimension.movementSpatialMechanism: NarrativeMechanismFamily.courtyardProgressionUnderRemoteFamilyGaze,
    NarrativeSemanticDimension.temporalPressureMechanism: NarrativeMechanismFamily.unplannedLiveFamilyCall,
    NarrativeSemanticDimension.supportingCharacterFunction: NarrativeMechanismFamily.daughterSetsBoundaryAndOffersSmallContinuation,
    NarrativeSemanticDimension.dramaticEngineFamily: NarrativeMechanismFamily.publicKinshipProofSacrificedForPresentIdentity,
  },
  coreEvidence: <NarrativeMechanismEvidence>[
    for (final item in <(NarrativeSemanticDimension, NarrativeMechanismFamily, String, String)>[
      (NarrativeSemanticDimension.openingMechanism, NarrativeMechanismFamily.privateReunionWithNoPublicProofAgreement, '嘉禾事先说好：只见她，不见陈家亲戚，也不拍“认回来”的照片。', 'The first meeting begins with an explicit privacy and image boundary.'),
      (NarrativeSemanticDimension.relationshipGeometry, NarrativeMechanismFamily.birthMotherAdultDaughterWithRemoteKinPressure, '三十四年前，她把刚出生的女儿交给亲戚收养。女儿如今叫刘嘉禾。', 'An estranged birth mother and adopted adult daughter face pressure from remote birth relatives.'),
      (NarrativeSemanticDimension.conflictMechanism, NarrativeMechanismFamily.publicKinshipProofVsAdultChildBoundary, '有人催秀仪把镜头转过去，说在陈氏书院前拍一张，事情就算圆满。', 'Relatives demand visible completion that conflicts with the daughter’s boundary.'),
      (NarrativeSemanticDimension.choiceMechanism, NarrativeMechanismFamily.refusePublicImageAndNamePresentIdentity, '她把手机翻过来，扣在身旁的青砖台上，说：“她叫刘嘉禾。今天不入镜。”', 'Xiuyi enacts refusal and affirms the daughter’s present name.'),
      (NarrativeSemanticDimension.climaxMechanism, NarrativeMechanismFamily.faceDownPhoneRejectsCollectiveRecognition, '她把手机翻过来，扣在身旁的青砖台上', 'The face-down phone visibly denies collective access to the reunion.'),
      (NarrativeSemanticDimension.consequenceMechanism, NarrativeMechanismFamily.noReunionPhotoButPrivateWalkContinues, '那张她等了三十四年的合照没有拍成。', 'The desired public image is genuinely lost rather than replaced.'),
      (NarrativeSemanticDimension.transformationMechanism, NarrativeMechanismFamily.hopedForRestorationToConsentBasedContinuation, '秀仪没有去拉她，只把红围巾留在包里，跟到她身边。', 'Xiuyi stops staging restoration and follows without claiming or dressing the daughter.'),
      (NarrativeSemanticDimension.endingMechanism, NarrativeMechanismFamily.thresholdSlowdownContinuesUnrepairedRelationship, '经过门槛时，嘉禾放慢了一步。两个人并排走了进去。', 'A small reciprocal action continues the unrepaired relationship without declaring completion.'),
      (NarrativeSemanticDimension.culturalAnchorFunction, NarrativeMechanismFamily.pooledLineageInstitutionIntensifiesSurnameClaim, '秀仪说起这里由广东各地陈姓宗族合资兴建', 'The verified pooled-lineage identity makes surname-based public pressure causal.'),
      (NarrativeSemanticDimension.dramaticEngineFamily, NarrativeMechanismFamily.publicKinshipProofSacrificedForPresentIdentity, '她叫刘嘉禾。今天不入镜。', 'The engine sacrifices public kinship proof to preserve an adult daughter’s present identity and consent.'),
    ])
      NarrativeMechanismEvidence(journeyId: _guangzhou, dimension: item.$1, mechanism: item.$2, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>[item.$3], semanticRationale: item.$4),
  ],
);

const _suzhou = 'suzhou-humble-administrators-garden';

final suzhouGardenGoldSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _suzhou,
  surfaceIdentity: 'grandmother-grandson-disappear-wait-and-reappear-in-layered-garden-space',
  mechanisms: const <NarrativeSemanticDimension, NarrativeMechanismFamily>{
    NarrativeSemanticDimension.openingMechanism: NarrativeMechanismFamily.impendingIndependentTravelRehearsal,
    NarrativeSemanticDimension.protagonistRolePattern: NarrativeMechanismFamily.dailyCaregiverReleasingVisualControl,
    NarrativeSemanticDimension.relationshipGeometry: NarrativeMechanismFamily.caregiverChildReciprocalAdjustment,
    NarrativeSemanticDimension.goalMechanism: NarrativeMechanismFamily.practiceIndependentMovementWithoutBreakingCare,
    NarrativeSemanticDimension.conflictMechanism: NarrativeMechanismFamily.continuousVisibilityVsAgeAppropriateSeparation,
    NarrativeSemanticDimension.choiceMechanism: NarrativeMechanismFamily.withholdProtectiveRecall,
    NarrativeSemanticDimension.climaxMechanism: NarrativeMechanismFamily.completeIntervalWithoutVisualContact,
    NarrativeSemanticDimension.consequenceMechanism: NarrativeMechanismFamily.childWaitsAndLooksBackWithoutRecall,
    NarrativeSemanticDimension.transformationMechanism: NarrativeMechanismFamily.vigilanceToReciprocalTrust,
    NarrativeSemanticDimension.endingMechanism: NarrativeMechanismFamily.separationAndWaitingContinueWithoutPursuit,
    NarrativeSemanticDimension.culturalAnchorFunction: NarrativeMechanismFamily.layeredSightlinesCreateLossAndRecoveryOfView,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction: NarrativeMechanismFamily.raisedThenLoweredHandEmbodiesRestraint,
    NarrativeSemanticDimension.movementSpatialMechanism: NarrativeMechanismFamily.repeatedOcclusionAndReappearance,
    NarrativeSemanticDimension.temporalPressureMechanism: NarrativeMechanismFamily.lastWalkBeforeIndependentRoutine,
    NarrativeSemanticDimension.supportingCharacterFunction: NarrativeMechanismFamily.childAcceptsResponsibilityToWaitAndLookBack,
    NarrativeSemanticDimension.dramaticEngineFamily: NarrativeMechanismFamily.releasedVisualControlCreatesReciprocalWaiting,
  },
  coreEvidence: <NarrativeMechanismEvidence>[
    for (final item in <(NarrativeSemanticDimension, NarrativeMechanismFamily, String, String)>[
      (NarrativeSemanticDimension.openingMechanism, NarrativeMechanismFamily.impendingIndependentTravelRehearsal, '下周一，十二岁的程朗要开始自己坐车去初中。', 'The coming Monday makes this walk the last rehearsal before independent travel.'),
      (NarrativeSemanticDimension.relationshipGeometry, NarrativeMechanismFamily.caregiverChildReciprocalAdjustment, '六年来，外婆陈玉兰几乎每天都去接他放学', 'A long daily-care relationship, not a mentor or peer project, creates the emotional pressure.'),
      (NarrativeSemanticDimension.conflictMechanism, NarrativeMechanismFamily.continuousVisibilityVsAgeAppropriateSeparation, '程朗的背影第一次从她眼前消失时，陈玉兰立刻喊了他的名字。', 'The conflict is continuous protective visibility against a child beginning independent movement.'),
      (NarrativeSemanticDimension.choiceMechanism, NarrativeMechanismFamily.withholdProtectiveRecall, '陈玉兰抬起手，他的名字已经到了嘴边，却没有喊；她把手放下来', 'The enacted choice is the visible withholding of an immediately available call.'),
      (NarrativeSemanticDimension.climaxMechanism, NarrativeMechanismFamily.completeIntervalWithoutVisualContact, '她把手放下来，自己走完那几步看不见他的路。', 'She physically completes the unseen interval instead of restoring control by calling.'),
      (NarrativeSemanticDimension.consequenceMechanism, NarrativeMechanismFamily.childWaitsAndLooksBackWithoutRecall, '下一处水面重新打开时，程朗已经停在前面，正回头找她。', 'The child answers released control with reciprocal waiting and looking back.'),
      (NarrativeSemanticDimension.transformationMechanism, NarrativeMechanismFamily.vigilanceToReciprocalTrust, '外婆，我还能走前面吗？', 'Care changes from one-sided visual vigilance to mutual adjustment.'),
      (NarrativeSemanticDimension.endingMechanism, NarrativeMechanismFamily.separationAndWaitingContinueWithoutPursuit, '程朗转过去，背影很快又被房屋挡住。陈玉兰没有追上去。', 'The new wait-and-look-back relation continues without the caregiver catching up.'),
      (NarrativeSemanticDimension.culturalAnchorFunction, NarrativeMechanismFamily.layeredSightlinesCreateLossAndRecoveryOfView, '曲桥和屋角又一次截断视线', 'Garden turns and built layers causally alternate concealment with reappearance.'),
      (NarrativeSemanticDimension.dramaticEngineFamily, NarrativeMechanismFamily.releasedVisualControlCreatesReciprocalWaiting, '下一处等我。', 'Repeated loss and recovery of sight transforms continuous control into reciprocal waiting.'),
    ])
      NarrativeMechanismEvidence(
        journeyId: _suzhou,
        dimension: item.$1,
        mechanism: item.$2,
        activeSourceId: activeGoldStorySourceId,
        sourceTexts: <String>[item.$3],
        semanticRationale: item.$4,
      ),
  ],
);

const _hangzhouReopened = 'hangzhou-west-lake';

final hangzhouWestLakeReopenedSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _hangzhouReopened,
  surfaceIdentity: 'Fang Yu / sixty-nine-year-old wife / Zhou Shaoting / hidden memory-clinic card / Broken Bridge walk',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism: NarrativeMechanismFamily.concealedClinicVisitBehindFamiliarWalk,
    NarrativeSemanticDimension.protagonistRolePattern: NarrativeMechanismFamily.olderSpouseTestingPartnersMemory,
    NarrativeSemanticDimension.relationshipGeometry: NarrativeMechanismFamily.longMarriedSpousesConcealSharedFear,
    NarrativeSemanticDimension.goalMechanism: NarrativeMechanismFamily.verifySharedPastThroughPlaceNameAnswers,
    NarrativeSemanticDimension.conflictMechanism: NarrativeMechanismFamily.memoryQuizVsHonestMedicalDisclosure,
    NarrativeSemanticDimension.choiceMechanism: NarrativeMechanismFamily.stopTestingAndHandOverAppointment,
    NarrativeSemanticDimension.climaxMechanism: NarrativeMechanismFamily.embodiedCareInterruptsVerbalMemoryTest,
    NarrativeSemanticDimension.consequenceMechanism: NarrativeMechanismFamily.appointmentAcceptedAndHospitalRouteRequested,
    NarrativeSemanticDimension.transformationMechanism: NarrativeMechanismFamily.proofSeekingToMutualAdmission,
    NarrativeSemanticDimension.endingMechanism: NarrativeMechanismFamily.hospitalQuestionEndsConcealment,
    NarrativeSemanticDimension.culturalAnchorFunction: NarrativeMechanismFamily.namedSeasonalViewsCueConflictingMemory,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction: NarrativeMechanismFamily.appointmentCardEmbodiesNamedFear,
    NarrativeSemanticDimension.movementSpatialMechanism: NarrativeMechanismFamily.questioningWalkToWetStepAndBus,
    NarrativeSemanticDimension.temporalPressureMechanism: NarrativeMechanismFamily.weekendBeforeMemoryClinic,
    NarrativeSemanticDimension.supportingCharacterFunction: NarrativeMechanismFamily.spouseAcknowledgesFearAndKeepsCard,
    NarrativeSemanticDimension.dramaticEngineFamily: NarrativeMechanismFamily.embodiedRecognitionEndsHiddenMemoryExam,
  }),
  coreEvidence: <NarrativeMechanismEvidence>[
    for (final item in <(NarrativeSemanticDimension, NarrativeMechanismFamily, String, String)>[
      (NarrativeSemanticDimension.openingMechanism, NarrativeMechanismFamily.concealedClinicVisitBehindFamiliarWalk, '周一他要去医院做记忆检查，她却一直没把预约卡拿出来。', 'A familiar walk conceals an already scheduled clinic visit.'),
      (NarrativeSemanticDimension.relationshipGeometry, NarrativeMechanismFamily.longMarriedSpousesConcealSharedFear, '方毓六十九岁，和周绍庭结婚四十三年。', 'The causal relationship is a forty-three-year marriage facing memory decline, not a project team or mentor pair.'),
      (NarrativeSemanticDimension.conflictMechanism, NarrativeMechanismFamily.memoryQuizVsHonestMedicalDisclosure, '两人从断桥往前走，方毓不停问他西湖景名。', 'Serial place-name questions substitute for direct disclosure and humiliate rather than clarify.'),
      (NarrativeSemanticDimension.choiceMechanism, NarrativeMechanismFamily.stopTestingAndHandOverAppointment, '方毓不再出题，把预约卡交给他。', 'The choice is to end concealment and hand over the medical appointment openly.'),
      (NarrativeSemanticDimension.climaxMechanism, NarrativeMechanismFamily.embodiedCareInterruptsVerbalMemoryTest, '方毓脚下一滑，他立刻扶住她的手肘，说：“这里一直滑。”', 'Embodied relational memory interrupts the verbal test without proving cognitive recovery.'),
      (NarrativeSemanticDimension.consequenceMechanism, NarrativeMechanismFamily.appointmentAcceptedAndHospitalRouteRequested, '他把卡放进自己的钱包。公交车来时，他问司机：“去医院，哪一站下？”', 'He accepts the appointment and takes practical ownership of the hospital route.'),
      (NarrativeSemanticDimension.transformationMechanism, NarrativeMechanismFamily.proofSeekingToMutualAdmission, '我知道你在怕什么。我也怕。', 'Both spouses move from private proof-seeking to naming shared fear.'),
      (NarrativeSemanticDimension.endingMechanism, NarrativeMechanismFamily.hospitalQuestionEndsConcealment, '去医院，哪一站下？', 'The ending is a practical question toward care, not an artifact, archive, separation, or restored result.'),
      (NarrativeSemanticDimension.culturalAnchorFunction, NarrativeMechanismFamily.namedSeasonalViewsCueConflictingMemory, '周绍庭把“断桥残雪”说成夏天。', 'A named seasonal West Lake view makes place, season, and memory answer causally inseparable.'),
      (NarrativeSemanticDimension.dramaticEngineFamily, NarrativeMechanismFamily.embodiedRecognitionEndsHiddenMemoryExam, '石阶被雨打湿，方毓脚下一滑，他立刻扶住她的手肘', 'The engine turns on embodied recognition ending a concealed spousal exam, materially unlike project revision, boundary refusal, or visual separation.'),
    ])
      NarrativeMechanismEvidence(
        journeyId: _hangzhouReopened,
        dimension: item.$1,
        mechanism: item.$2,
        activeSourceId: activeGoldStorySourceId,
        sourceTexts: <String>[item.$3],
        semanticRationale: item.$4,
      ),
  ],
);


const _longmen = luoyangLongmenGoldJourneyId;

final luoyangLongmenGoldSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: _longmen,
  surfaceIdentity: 'adult-sister-tears-joint-property-signature-page-to-preserve-younger-brother-future-shared-agency',
  mechanisms: const <NarrativeSemanticDimension, NarrativeMechanismFamily>{
    NarrativeSemanticDimension.openingMechanism: NarrativeMechanismFamily.jointAssetDeadlineCreatedBeforeSharedConsent,
    NarrativeSemanticDimension.protagonistRolePattern: NarrativeMechanismFamily.responsibleSiblingEquatingBurdenWithAuthority,
    NarrativeSemanticDimension.relationshipGeometry: NarrativeMechanismFamily.adultSiblingsNegotiatingFutureSharedAgency,
    NarrativeSemanticDimension.goalMechanism: NarrativeMechanismFamily.completeJointTransactionWithoutLosingSharedAgency,
    NarrativeSemanticDimension.conflictMechanism: NarrativeMechanismFamily.administrativeBurdenVsEqualDecisionParticipation,
    NarrativeSemanticDimension.choiceMechanism: NarrativeMechanismFamily.acceptFinancialLossToPreserveFutureParticipation,
    NarrativeSemanticDimension.climaxMechanism: NarrativeMechanismFamily.withdrawExecutableConsentAtLastMoment,
    NarrativeSemanticDimension.consequenceMechanism: NarrativeMechanismFamily.deadlinePassesWhileJointOwnershipRemains,
    NarrativeSemanticDimension.transformationMechanism: NarrativeMechanismFamily.unilateralControlTowardPriorConsultation,
    NarrativeSemanticDimension.endingMechanism: NarrativeMechanismFamily.futureProcessRequestAcceptedWithoutFullRepair,
    NarrativeSemanticDimension.culturalAnchorFunction: NarrativeMechanismFamily.nearFarViewingRequirementDisruptsDeadlinePace,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction: NarrativeMechanismFamily.destroyedConsentPageEmbodiesRefusedExchange,
    NarrativeSemanticDimension.movementSpatialMechanism: NarrativeMechanismFamily.alternatingCloseAndDistantViewingAlongLinearRoute,
    NarrativeSemanticDimension.temporalPressureMechanism: NarrativeMechanismFamily.sameDayTransactionDeadlineBackedBySunkDeposit,
    NarrativeSemanticDimension.supportingCharacterFunction: NarrativeMechanismFamily.siblingSetsExitPriceThenRequestsFutureInclusion,
    NarrativeSemanticDimension.dramaticEngineFamily: NarrativeMechanismFamily.sunkFinancialCostPreservesRelationalDecisionRights,
  },
  coreEvidence: <NarrativeMechanismEvidence>[
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.openingMechanism, mechanism: NarrativeMechanismFamily.jointAssetDeadlineCreatedBeforeSharedConsent, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['为了锁定新房，她先交了不能退的定金，然后才把合同发给周屿：“回来签字就行。”'], semanticRationale: 'The deadline exists because Zhou Lan commits money before obtaining her co-owner sibling’s consent.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.relationshipGeometry, mechanism: NarrativeMechanismFamily.adultSiblingsNegotiatingFutureSharedAgency, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['父母搬离洛阳后，姐弟共同拥有的旧房空了两年。'], semanticRationale: 'Adult sibling co-owners remain structurally tied through future family decisions.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.conflictMechanism, mechanism: NarrativeMechanismFamily.administrativeBurdenVsEqualDecisionParticipation, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['责任积得越久，周岚越习惯把责任和决定权当成同一件事。'], semanticRationale: 'Accumulated administrative burden has been converted into unilateral authority.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.choiceMechanism, mechanism: NarrativeMechanismFamily.acceptFinancialLossToPreserveFutureParticipation, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['她把合同抽回来，沿中间那道旧折痕把签字页撕成两半。'], semanticRationale: 'The sister physically removes the immediate transaction path and accepts its financial cost.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.climaxMechanism, mechanism: NarrativeMechanismFamily.withdrawExecutableConsentAtLastMoment, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['“我可以签。你拿到房款，不丢定金。可是签完以后，家里的事你自己决定，别再叫我回来。”', '她把合同抽回来，沿中间那道旧折痕把签字页撕成两半。'], semanticRationale: 'The two-span climax binds the brother’s permanent-exit condition to the sister’s destruction of the executable signature page.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.consequenceMechanism, mechanism: NarrativeMechanismFamily.deadlinePassesWhileJointOwnershipRemains, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['两人离开时，原定签约时间已经过去，旧房仍属于两个人，责任怎么分、房子卖不卖，都没有答案。'], semanticRationale: 'The transaction deadline genuinely passes while ownership remains joint and unresolved.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.transformationMechanism, mechanism: NarrativeMechanismFamily.unilateralControlTowardPriorConsultation, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['回到伊河边，周屿问：“下次谈房子，你能不能先把所有方案都发给我？”周岚没有保证自己从此会变成另一个人。她只说：“能。”'], semanticRationale: 'Change is narrow and procedural: future consultation is accepted without claiming total repair.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.endingMechanism, mechanism: NarrativeMechanismFamily.futureProcessRequestAcceptedWithoutFullRepair, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['然后摸到包里的两半签字页，没有再拿出来。'], semanticRationale: 'The torn consent artifact remains present but unshown, preserving residue.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.culturalAnchorFunction, mechanism: NarrativeMechanismFamily.nearFarViewingRequirementDisruptsDeadlinePace, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['到了奉先寺大型造像群前，尺度改变，中央大像与周围造像需要拉开距离才能看出安排。'], semanticRationale: 'Longmen’s near/far viewing structure materially controls pace and therefore signing pressure.'),
    NarrativeMechanismEvidence(journeyId: _longmen, dimension: NarrativeSemanticDimension.dramaticEngineFamily, mechanism: NarrativeMechanismFamily.sunkFinancialCostPreservesRelationalDecisionRights, activeSourceId: activeGoldStorySourceId, sourceTexts: <String>['“我可以签。你拿到房款，不丢定金。可是签完以后，家里的事你自己决定，别再叫我回来。”', '“定金我自己赔。房子今天不卖。”'], semanticRationale: 'A real sunk financial loss and failed sale preserve future shared relational agency.'),
  ],
);

final Map<String, JourneySemanticFingerprint> approvedGoldSemanticFingerprints =
    Map<String, JourneySemanticFingerprint>.unmodifiable({
  for (final entry in baseline.approvedGoldSemanticFingerprints.entries)
    entry.key: entry.key == _hangzhouReopened
        ? hangzhouWestLakeReopenedSemanticFingerprint
        : entry.key == _forbidden
        ? _forbiddenFingerprint
        : entry.key == _chengdu
            ? _chengduFingerprint
            : _convertBaselineFingerprint(entry.value),
  _guangzhou: guangzhouChenClanGoldSemanticFingerprint,
  _suzhou: suzhouGardenGoldSemanticFingerprint,
  _longmen: luoyangLongmenGoldSemanticFingerprint,
});

String activeCanonicalGoldStoryText(String journeyId) {
  if (journeyId == _hangzhouReopened) {
    return hangzhouWestLakeReopenedLevels
        .expand((level) => level.storyParagraphs)
        .join('\n');
  }
  if (journeyId == _guangzhou) {
    return guangzhouChenClanOnePassLevels
        .expand((level) => level.storyParagraphs)
        .join('\n');
  }
  if (journeyId == _suzhou) {
    return suzhouGardenCanonicalLevelContent(10).storyParagraphs.join('\n');
  }
  if (journeyId == _longmen) {
    return longmenGoldStoryLevels.expand((level) => level.chinese).join('\n');
  }
  return baseline.activeCanonicalGoldStoryText(journeyId);
}

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
