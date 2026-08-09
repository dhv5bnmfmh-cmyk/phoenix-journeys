import 'chengdu_kuanzhai_one_pass.dart';
import 'forbidden_city_journey_runtime.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'nanjing_qinhuai_one_pass.dart';
import 'shanghai_bund_one_pass.dart';
import 'summer_palace_adaptive_story_levels.dart';
import 'xian_city_wall_one_pass.dart';

/// Machine-controlled dimensions used by the Phoenix semantic anti-template gate.
///
/// Surface identity is intentionally excluded from the CORE collision decision.
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

/// Reusable semantic families. These identifiers must describe causal mechanisms,
/// never a city, character, landmark, or Journey-specific event name.
enum NarrativeMechanismFamily {
  // Opening families.
  deadlineWithIdealizedTarget,
  incompleteKnowledgeOpportunity,
  lifeTransitionWithCarriedPast,
  farewellCompletionRitual,
  fieldAssignmentWithPurityModel,
  fieldSurveyWithPriorClassification,
  operationalFailureCountdown,

  // Protagonist role patterns.
  creatorProvingIndependentJudgment,
  apprenticeSeekingCompleteUnderstanding,
  youngProfessionalAtTransition,
  localMoverTestingBelonging,
  fieldRecorderTestingAuthenticityModel,
  researcherTestingAuthenticityModel,
  technicianSeekingIndependentTrust,

  // Relationship geometries.
  intergenerationalMentorToRecognizedAgency,
  mentorToEntrustedAgency,
  parentChildContinuityWithoutCareerControl,
  familyAsBelongingAnchor,
  soloFieldworkAgainstInternalModel,
  supervisorToEntrustedResponsibility,

  // Goal mechanisms.
  produceIdealArtifact,
  completeKnowledgeRecord,
  crossIntoNewRoleWithoutPast,
  completeFarewellCircuit,
  capturePurifiedRecord,
  validatePriorAuthenticityModel,
  restoreCompleteOperationalResult,

  // Conflict mechanisms.
  aestheticPerfectionVsRelationalTrace,
  completeResultVsResponsibleBoundary,
  ruptureVsContinuity,
  addressChangeVsBelongingContinuity,
  purityModelVsLivedEvidence,

  // Choice mechanisms.
  sacrificeIdealResultToPreserveRelationalEvidence,
  responsibleRefusalOfAvailableShortcut,
  carryPastObjectIntoChosenFuture,
  continueBeyondDeclaredFinish,
  reviseClassificationInsteadOfFilteringEvidence,

  // Climax mechanisms.
  forcedTradeoffCreatesNewFrame,
  refusalAtAvailableThreshold,
  spatialCrossingTriggersContinuityRecognition,
  completedCircuitBecomesDeparturePoint,
  evidenceReclassificationEnactedInArtifact,
  operationalRefusalLeavesVisibleIncompletion,

  // Consequence mechanisms.
  sacrificedIdealCreatesAlternativeArtifact,
  intentionalVisibleIncompletion,
  carriedObjectCrossesIdentityBoundary,
  completedRecordExtendsBeyondOriginalBoundary,
  retainedEvidencePreservesReclassification,

  // Transformation mechanisms.
  independenceReframedAsTraceableResponsibility,
  completionDriveToResponsibleRestraint,
  cleanBreakModelToContinuityModel,
  boundedBelongingToContinuingBelonging,
  purityModelToLayeredAuthenticity,

  // Ending mechanisms.
  intergenerationalObjectEntrustment,
  responsibilityTransferAfterRestraint,
  arrivalWithCarriedContinuityObject,
  artifactRecordsOpenContinuation,
  revisedArtifactRecordsChangedUnderstanding,

  // Cultural-anchor functions.
  restorationTraceMakesTimeReadable,
  heritageBoundaryMakesRestraintMeaningful,
  riverFlowConnectsCommercialEras,
  fortificationBoundaryReframesBelonging,
  livedCulturalLandscapeDisprovesPurity,
  livedUseDisprovesFrozenAuthenticity,
  heritageOperationsConstrainSpectacle,

  // Artifact / object functions.
  inheritedPhotographForcesRelationalChoice,
  mapBlankRecordsChosenBoundary,
  carriedTradeDocumentConnectsEras,
  runningRecordTurnsFinishIntoContinuation,
  fieldRecordingStoresReclassifiedEvidence,
  markedSurveyStoresReclassifiedEvidence,
  statusRecordTransfersOperationalOwnership,

  // Movement / spatial families.
  vantageSearchThenRecomposition,
  approachToUncrossedThreshold,
  oneWayCrossingBetweenContrastedBanks,
  closedCircuitThenOutboundContinuation,
  linearFieldTransectWithReorientation,
  comparativeFieldSurveyWithReturn,
  fixedFailureZoneDecision,

  // Temporal pressure families.
  expiringCreativeOpportunity,
  openAccessWithoutExternalDeadline,
  nextDayLifeTransition,
  selfDeclaredFinalOccurrence,
  approachingWeatherWindow,
  fieldDayThenSubmission,
  explicitOperationalCountdown,

  // Supporting-character functions.
  elderEmbodiesPriorKnowledgeThenEntrusts,
  mentorDefinesBoundaryThenWithholdsIntervention,
  parentOffersObjectWithoutBlockingDeparture,
  familyMessageReorientsMeaningOfDestination,
  noDecisiveSupportingCharacter,
  supervisorAbsentForChoiceThenTransfersOwnership,

  // Dramatic engine families.
  forcedTradeoffReframesCreativeAuthorship,
  responsibleRefusalOfAvailableShortcut,
  spatialCrossingReframesTemporalContinuity,
  completedClosureBecomesOpenContinuation,
  evidenceForcesReclassification,
}

/// The deterministic CORE set. Surface details and incidental similarities do
/// not count toward the blocking threshold.
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

/// Rule A: same dramatic engine plus this many ADDITIONAL CORE matches blocks.
const int semanticCollisionSameEngineAdditionalCoreThreshold = 3;

/// Rule B: this many CORE matches blocks even when engine labels differ.
const int semanticCollisionIndependentCoreThreshold = 4;

const String semanticTemplateCollisionNotGoldReady =
    'TEMPLATE COLLISION - NOT GOLD READY';

class NarrativeMechanismEvidence {
  const NarrativeMechanismEvidence({
    required this.journeyId,
    required this.dimension,
    required this.mechanism,
    required this.activeSourceId,
    required this.sourceText,
    this.note = '',
  });

  final String journeyId;
  final NarrativeSemanticDimension dimension;
  final NarrativeMechanismFamily mechanism;
  final String activeSourceId;
  final String sourceText;
  final String note;
}

class JourneySemanticFingerprint {
  const JourneySemanticFingerprint({
    required this.journeyId,
    required this.surfaceIdentity,
    required this.mechanisms,
    required this.coreEvidence,
  });

  final String journeyId;

  /// Human-readable identity remains useful for review, but never participates
  /// in semantic collision arithmetic.
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

NarrativeMechanismEvidence _e(
  String journeyId,
  NarrativeSemanticDimension dimension,
  NarrativeMechanismFamily mechanism,
  String sourceText, {
  String note = '',
}) =>
    NarrativeMechanismEvidence(
      journeyId: journeyId,
      dimension: dimension,
      mechanism: mechanism,
      activeSourceId: 'active-lv1-lv10-story-package',
      sourceText: sourceText,
      note: note,
    );

const _summer = 'beijing-summer-palace';
const _forbidden = 'beijing-forbidden-city';
const _shanghai = 'shanghai-bund';
const _xian = 'xian-city-wall';
const _hangzhou = 'hangzhou-west-lake';
const _chengdu = 'chengdu-kuanzhai-alley';
const _nanjing = 'nanjing-qinhuai-river';

final Map<String, JourneySemanticFingerprint> approvedGoldSemanticFingerprints =
    Map<String, JourneySemanticFingerprint>.unmodifiable({
  _summer: JourneySemanticFingerprint(
    journeyId: _summer,
    surfaceIdentity: 'Xu Cheng / student photographer / Summer Palace / old photograph',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.deadlineWithIdealizedTarget,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.creatorProvingIndependentJudgment,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.produceIdealArtifact,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.sacrificedIdealCreatesAlternativeArtifact,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.independenceReframedAsTraceableResponsibility,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.intergenerationalObjectEntrustment,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.restorationTraceMakesTimeReadable,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.inheritedPhotographForcesRelationalChoice,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.vantageSearchThenRecomposition,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.expiringCreativeOpportunity,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.elderEmbodiesPriorKnowledgeThenEntrusts,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
    },
    coreEvidence: [
      _e(_summer, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.deadlineWithIdealizedTarget, '她要为校展拍照。'),
      _e(_summer, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
          '许澄要无瑕画面，周岚要她看修复痕迹。'),
      _e(_summer, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
          '许澄放弃原构图，先捡回照片。'),
      _e(_summer, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
          '她必须在追光和捡照片之间选择。'),
      _e(_summer, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.sacrificedIdealCreatesAlternativeArtifact,
          '因此，她错失最佳光线。'),
      _e(_summer, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.independenceReframedAsTraceableResponsibility,
          '许澄不再只想证明独立。'),
      _e(_summer, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.intergenerationalObjectEntrustment,
          '她把旧照片交给许澄保存。'),
      _e(_summer, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
          '周岚不再替她调整构图。'),
      _e(_summer, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.restorationTraceMakesTimeReadable,
          '周岚曾保护长廊彩画。'),
      _e(_summer, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
          '许澄放弃原构图，先捡回照片。'),
    ],
  ),
  _forbidden: JourneySemanticFingerprint(
    journeyId: _forbidden,
    surfaceIdentity: 'Shen Yan / seventeen-year-old construction apprentice / palace map / wooden ruler',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.incompleteKnowledgeOpportunity,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.apprenticeSeekingCompleteUnderstanding,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.mentorToEntrustedAgency,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.completeKnowledgeRecord,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.refusalAtAvailableThreshold,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.intentionalVisibleIncompletion,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.heritageBoundaryMakesRestraintMeaningful,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.mapBlankRecordsChosenBoundary,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.approachToUncrossedThreshold,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.openAccessWithoutExternalDeadline,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.mentorDefinesBoundaryThenWithholdsIntervention,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
    },
    coreEvidence: [
      _e(_forbidden, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.incompleteKnowledgeOpportunity,
          '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。'),
      _e(_forbidden, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
          '沈砚开始动摇，却仍本能地厌恶地图上的空白'),
      _e(_forbidden, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
          '于是沈砚停下，没有跨过门槛。'),
      _e(_forbidden, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.refusalAtAvailableThreshold,
          '就在这时，年幼侍役沿规定路线匆匆经过。'),
      _e(_forbidden, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.intentionalVisibleIncompletion,
          '门后来关上，地图仍留下空白。'),
      _e(_forbidden, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
          '不再追求填满'),
      _e(_forbidden, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
          '周师傅把用了多年的旧木尺交给他。'),
      _e(_forbidden, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.mentorToEntrustedAgency,
          '周师傅告诉他，真正的营造不仅处理结构，也要读懂人与空间之间的关系。'),
      _e(_forbidden, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.heritageBoundaryMakesRestraintMeaningful,
          '宫门既连接也区分'),
      _e(_forbidden, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
          '若他只因为门开着就跨过去'),
    ],
  ),
  _shanghai: JourneySemanticFingerprint(
    journeyId: _shanghai,
    surfaceIdentity: 'Lin An / fintech transition / Huangpu ferry / old bill of lading',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.youngProfessionalAtTransition,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.ruptureVsContinuity,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.nextDayLifeTransition,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
    },
    coreEvidence: [
      _e(_shanghai, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
          '这个晚上，他要去浦东陆家嘴，为第二天的新工作做准备。'),
      _e(_shanghai, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.ruptureVsContinuity,
          '过了黄浦江，就是离开旧上海，进入新上海。'),
      _e(_shanghai, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
          '最后还是把它放进包里。'),
      _e(_shanghai, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
          '轮渡离开西岸'),
      _e(_shanghai, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
          '也把那张旧单据带过了江。'),
      _e(_shanghai, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
          '江没有把上海分成过去和未来。'),
      _e(_shanghai, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
          '船靠东岸后，他继续走向新的工作'),
      _e(_shanghai, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
          '母亲没有劝他留下，只把提单递过去。'),
      _e(_shanghai, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
          '黄浦江'),
      _e(_shanghai, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
          '轮渡离开西岸'),
    ],
  ),
  _xian: JourneySemanticFingerprint(
    journeyId: _xian,
    surfaceIdentity: 'Zhou Yao / local runner / city-wall circuit / running watch',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.farewellCompletionRitual,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.localMoverTestingBelonging,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.familyAsBelongingAnchor,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.completeFarewellCircuit,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.addressChangeVsBelongingContinuity,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.continueBeyondDeclaredFinish,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.completedCircuitBecomesDeparturePoint,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.completedRecordExtendsBeyondOriginalBoundary,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.boundedBelongingToContinuingBelonging,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.artifactRecordsOpenContinuation,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.fortificationBoundaryReframesBelonging,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.runningRecordTurnsFinishIntoContinuation,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.closedCircuitThenOutboundContinuation,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.selfDeclaredFinalOccurrence,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.familyMessageReorientsMeaningOfDestination,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.completedClosureBecomesOpenContinuation,
    },
    coreEvidence: [
      _e(_xian, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.farewellCompletionRitual,
          '想跑完一圈，把这条熟悉的路当成最后一次告别。'),
      _e(_xian, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.addressChangeVsBelongingContinuity,
          '搬出去以后，自己还算不算“城里人”'),
      _e(_xian, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.continueBeyondDeclaredFinish,
          '他没有按停，而是下城继续往南跑。'),
      _e(_xian, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.completedCircuitBecomesDeparturePoint,
          '跑表刚好记下一整圈。'),
      _e(_xian, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.completedRecordExtendsBeyondOriginalBoundary,
          '他的距离还在增加。'),
      _e(_xian, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.boundedBelongingToContinuingBelonging,
          '身后的城墙亮起灯'),
      _e(_xian, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.artifactRecordsOpenContinuation,
          '跑表上的距离越过那一圈。'),
      _e(_xian, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.familyAsBelongingAnchor,
          '母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。'),
      _e(_xian, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.fortificationBoundaryReframesBelonging,
          '西安城墙'),
      _e(_xian, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.completedClosureBecomesOpenContinuation,
          '他没有按停，而是下城继续往南跑。'),
    ],
  ),
  _hangzhou: JourneySemanticFingerprint(
    journeyId: _hangzhou,
    surfaceIdentity: 'Xu Cheng / urban sound archivist / Su Causeway / field recording',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.fieldAssignmentWithPurityModel,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.fieldRecorderTestingAuthenticityModel,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.capturePurifiedRecord,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.purityModelVsLivedEvidence,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.livedCulturalLandscapeDisprovesPurity,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.fieldRecordingStoresReclassifiedEvidence,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.linearFieldTransectWithReorientation,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.approachingWeatherWindow,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.noDecisiveSupportingCharacter,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.evidenceForcesReclassification,
    },
    coreEvidence: [
      _e(_hangzhou, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.fieldAssignmentWithPurityModel,
          '想收下一段“干净”的声音'),
      _e(_hangzhou, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.purityModelVsLivedEvidence,
          '一声自行车铃闯进录音，她皱眉删掉重来。'),
      _e(_hangzhou, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
          '她忽然没有再删。'),
      _e(_hangzhou, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
          '许澄把麦克风转向堤上和水面'),
      _e(_hangzhou, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
          '让雨声、脚步和人声一起进入录音。'),
      _e(_hangzhou, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
          '最好没有人声。'),
      _e(_hangzhou, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
          '第二天，她把文件写成日期、苏堤路线和两个字：“在场”。'),
      _e(_hangzhou, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
          '许澄二十一岁，是杭州本地大学生。'),
      _e(_hangzhou, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.livedCulturalLandscapeDisprovesPurity,
          '苏堤'),
      _e(_hangzhou, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.evidenceForcesReclassification,
          '她忽然没有再删。'),
    ],
  ),
  _chengdu: JourneySemanticFingerprint(
    journeyId: _chengdu,
    surfaceIdentity: 'Lin Xia / architecture researcher / Kuanzhai Alley / marked survey sheet',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.fieldSurveyWithPriorClassification,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.researcherTestingAuthenticityModel,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.validatePriorAuthenticityModel,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.purityModelVsLivedEvidence,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.livedUseDisprovesFrozenAuthenticity,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.markedSurveyStoresReclassifiedEvidence,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.comparativeFieldSurveyWithReturn,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.fieldDayThenSubmission,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.noDecisiveSupportingCharacter,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.evidenceForcesReclassification,
    },
    coreEvidence: [
      _e(_chengdu, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.fieldSurveyWithPriorClassification,
          '她带着“使用痕迹调查”表走进宽窄巷子'),
      _e(_chengdu, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.purityModelVsLivedEvidence,
          '认定商业越多，历史越不真实'),
      _e(_chengdu, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
          '林夏把“商业活动”四个字轻轻划掉'),
      _e(_chengdu, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
          '在旁边写：“仍在使用。”'),
      _e(_chengdu, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
          '第二天交表时，她没有誊清那一页。'),
      _e(_chengdu, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
          '椅脚磨出的痕迹和旧门槛一样真实。'),
      _e(_chengdu, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
          '第二天交表时，她没有誊清那一页。'),
      _e(_chengdu, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
          '林夏二十四岁，是成都本地建筑系研究生。'),
      _e(_chengdu, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.livedUseDisprovesFrozenAuthenticity,
          '宽窄巷子'),
      _e(_chengdu, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.evidenceForcesReclassification,
          '林夏把“商业活动”四个字轻轻划掉'),
    ],
  ),
  _nanjing: JourneySemanticFingerprint(
    journeyId: _nanjing,
    surfaceIdentity: 'Wei Zhou / lighting technician / Qinhuai festival route / final status record',
    mechanisms: const {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.operationalFailureCountdown,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.technicianSeekingIndependentTrust,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.supervisorToEntrustedResponsibility,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.restoreCompleteOperationalResult,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.intentionalVisibleIncompletion,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.heritageOperationsConstrainSpectacle,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.statusRecordTransfersOperationalOwnership,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.fixedFailureZoneDecision,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.explicitOperationalCountdown,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.supervisorAbsentForChoiceThenTransfersOwnership,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
    },
    coreEvidence: [
      _e(_nanjing, NarrativeSemanticDimension.openingMechanism,
          NarrativeMechanismFamily.operationalFailureCountdown,
          '离秦淮灯会亮灯还有七分钟'),
      _e(_nanjing, NarrativeSemanticDimension.conflictMechanism,
          NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
          '最快的办法是临时改动原来的照明线路，但这项改动没有经过确认'),
      _e(_nanjing, NarrativeSemanticDimension.choiceMechanism,
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
          '最后还是停下了手。'),
      _e(_nanjing, NarrativeSemanticDimension.climaxMechanism,
          NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion,
          '放弃一段装饰灯。'),
      _e(_nanjing, NarrativeSemanticDimension.consequenceMechanism,
          NarrativeMechanismFamily.intentionalVisibleIncompletion,
          '那一段装饰灯仍然黑着。'),
      _e(_nanjing, NarrativeSemanticDimension.transformationMechanism,
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
          '他保留原有安全方案'),
      _e(_nanjing, NarrativeSemanticDimension.endingMechanism,
          NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
          '只把最终灯光状态记录交给魏舟填写。'),
      _e(_nanjing, NarrativeSemanticDimension.relationshipGeometry,
          NarrativeMechanismFamily.supervisorToEntrustedResponsibility,
          '周工正在另一段处理问题，不能马上回来。'),
      _e(_nanjing, NarrativeSemanticDimension.culturalAnchorFunction,
          NarrativeMechanismFamily.heritageOperationsConstrainSpectacle,
          '秦淮河古桥'),
      _e(_nanjing, NarrativeSemanticDimension.dramaticEngineFamily,
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
          '最快的办法是临时改动原来的照明线路'),
    ],
  ),
});

/// The active production Story package only. Legacy remediation prose is never
/// included here and therefore cannot satisfy semantic evidence.
String activeCanonicalGoldStoryText(String journeyId) {
  switch (journeyId) {
    case _summer:
      return [
        for (var level = 1; level <= 10; level++)
          summerPalaceN1LevelForPhoenixLevel(level).storyParagraphs.join('\n'),
      ].join('\n');
    case _forbidden:
      return forbiddenCityLockedStories.join('\n');
    case _shanghai:
      return shanghaiBundOnePassLevels
          .map((level) => level.storyParagraphs.join('\n'))
          .join('\n');
    case _xian:
      return xianCityWallOnePassLevels
          .map((level) => level.storyParagraphs.join('\n'))
          .join('\n');
    case _hangzhou:
      return hangzhouWestLakeOnePassLevels
          .map((level) => level.storyParagraphs.join('\n'))
          .join('\n');
    case _chengdu:
      return chengduKuanzhaiOnePassLevels
          .map((level) => level.storyParagraphs.join('\n'))
          .join('\n');
    case _nanjing:
      return nanjingQinhuaiOnePassLevels
          .map((level) => level.storyParagraphs.join('\n'))
          .join('\n');
  }
  throw StateError('No active Gold Story package for $journeyId');
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
  final evidenceByDimension = {
    for (final evidence in fingerprint.coreEvidence) evidence.dimension: evidence,
  };
  for (final dimension in narrativeSemanticCoreDimensions) {
    final evidence = evidenceByDimension[dimension];
    if (evidence == null) {
      errors.add('${fingerprint.journeyId}: missing evidence ${dimension.name}');
    } else if (evidence.mechanism != fingerprint.mechanism(dimension)) {
      errors.add('${fingerprint.journeyId}: evidence mismatch ${dimension.name}');
    }
  }
  return errors;
}

List<String> semanticEvidenceFidelityErrors(
  JourneySemanticFingerprint fingerprint,
) {
  final story = activeCanonicalGoldStoryText(fingerprint.journeyId);
  return <String>[
    for (final evidence in fingerprint.coreEvidence)
      if (evidence.sourceText.trim().isEmpty || !story.contains(evidence.sourceText))
        '${fingerprint.journeyId}:${evidence.dimension.name}:${evidence.sourceText}',
  ];
}

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

  final sameEngine = left.mechanism(NarrativeSemanticDimension.dramaticEngineFamily) ==
      right.mechanism(NarrativeSemanticDimension.dramaticEngineFamily);
  final additionalCoreMatches = matchingCore
      .where((dimension) =>
          dimension != NarrativeSemanticDimension.dramaticEngineFamily)
      .length;
  final ruleA = sameEngine &&
      additionalCoreMatches >= semanticCollisionSameEngineAdditionalCoreThreshold;
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

/// Normalized structural Difference Matrix. Free-form difference prose may be
/// shown beside this result but cannot override these machine-controlled fields.
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
      results.add(compareSemanticFingerprints(
        catalog[i],
        catalog[j],
        approvedCatalogAudit: true,
      ));
    }
  }
  return List.unmodifiable(results);
}

FutureGoldSemanticGateResult evaluateFutureGoldSemanticCandidate(
  JourneySemanticFingerprint candidate,
) {
  final comparisons = semanticDifferenceMatrixAgainstApprovedGold(candidate);
  final collisions = comparisons.where((comparison) => comparison.isCollision).toList();
  return FutureGoldSemanticGateResult(
    isGoldReady: collisions.isEmpty,
    status: collisions.isEmpty ? 'SEMANTIC ANTI-TEMPLATE PASS' : semanticTemplateCollisionNotGoldReady,
    comparisons: comparisons,
  );
}
