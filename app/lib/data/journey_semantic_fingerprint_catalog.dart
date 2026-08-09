import 'chengdu_kuanzhai_one_pass.dart';
import 'forbidden_city_journey_runtime.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'nanjing_qinhuai_one_pass.dart';
import 'shanghai_bund_one_pass.dart';
import 'summer_palace_adaptive_story_levels.dart';
import 'xian_city_wall_one_pass.dart';

/// Machine-controlled dimensions used by the Phoenix semantic anti-template gate.
/// Surface identity is intentionally excluded from CORE collision arithmetic.
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

/// Reusable causal families. These identifiers describe mechanisms, never a
/// city, character, landmark, or Journey-specific event name.
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

/// CI can verify provenance and contract completeness. It cannot independently
/// prove natural-language semantic entailment. [semanticRationale] is mandatory
/// human-auditable metadata explaining the causal mapping.
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

typedef _MechanismEvidenceEntry = (
  NarrativeSemanticDimension,
  NarrativeMechanismFamily,
  List<String>,
  String,
);

NarrativeMechanismEvidence _e(
  String journeyId,
  _MechanismEvidenceEntry entry,
) =>
    NarrativeMechanismEvidence(
      journeyId: journeyId,
      dimension: entry.$1,
      mechanism: entry.$2,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: List<String>.unmodifiable(entry.$3),
      semanticRationale: entry.$4,
    );

List<NarrativeMechanismEvidence> _evidence(
  String journeyId,
  List<_MechanismEvidenceEntry> entries,
) =>
    List<NarrativeMechanismEvidence>.unmodifiable([
      for (final entry in entries) _e(journeyId, entry),
    ]);

Map<NarrativeSemanticDimension, NarrativeMechanismFamily> _mechanisms({
  required NarrativeMechanismFamily opening,
  required NarrativeMechanismFamily protagonist,
  required NarrativeMechanismFamily relationship,
  required NarrativeMechanismFamily goal,
  required NarrativeMechanismFamily conflict,
  required NarrativeMechanismFamily choice,
  required NarrativeMechanismFamily climax,
  required NarrativeMechanismFamily consequence,
  required NarrativeMechanismFamily transformation,
  required NarrativeMechanismFamily ending,
  required NarrativeMechanismFamily culturalAnchor,
  required NarrativeMechanismFamily artifact,
  required NarrativeMechanismFamily movement,
  required NarrativeMechanismFamily temporalPressure,
  required NarrativeMechanismFamily supportingCharacter,
  required NarrativeMechanismFamily dramaticEngine,
}) =>
    Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
      NarrativeSemanticDimension.openingMechanism: opening,
      NarrativeSemanticDimension.protagonistRolePattern: protagonist,
      NarrativeSemanticDimension.relationshipGeometry: relationship,
      NarrativeSemanticDimension.goalMechanism: goal,
      NarrativeSemanticDimension.conflictMechanism: conflict,
      NarrativeSemanticDimension.choiceMechanism: choice,
      NarrativeSemanticDimension.climaxMechanism: climax,
      NarrativeSemanticDimension.consequenceMechanism: consequence,
      NarrativeSemanticDimension.transformationMechanism: transformation,
      NarrativeSemanticDimension.endingMechanism: ending,
      NarrativeSemanticDimension.culturalAnchorFunction: culturalAnchor,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction: artifact,
      NarrativeSemanticDimension.movementSpatialMechanism: movement,
      NarrativeSemanticDimension.temporalPressureMechanism: temporalPressure,
      NarrativeSemanticDimension.supportingCharacterFunction:
          supportingCharacter,
      NarrativeSemanticDimension.dramaticEngineFamily: dramaticEngine,
    });

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
    surfaceIdentity:
        'Xu Cheng / student photographer / Summer Palace / old photograph',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.deadlineWithIdealizedTarget,
      protagonist: NarrativeMechanismFamily.creatorProvingIndependentJudgment,
      relationship:
          NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
      goal: NarrativeMechanismFamily.produceIdealArtifact,
      conflict: NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
      choice: NarrativeMechanismFamily
          .sacrificeIdealResultToPreserveRelationalEvidence,
      climax: NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
      consequence:
          NarrativeMechanismFamily.sacrificedIdealCreatesAlternativeArtifact,
      transformation:
          NarrativeMechanismFamily.independenceReframedAsTraceableResponsibility,
      ending: NarrativeMechanismFamily.intergenerationalObjectEntrustment,
      culturalAnchor: NarrativeMechanismFamily.restorationTraceMakesTimeReadable,
      artifact:
          NarrativeMechanismFamily.inheritedPhotographForcesRelationalChoice,
      movement: NarrativeMechanismFamily.vantageSearchThenRecomposition,
      temporalPressure: NarrativeMechanismFamily.expiringCreativeOpportunity,
      supportingCharacter:
          NarrativeMechanismFamily.elderEmbodiesPriorKnowledgeThenEntrusts,
      dramaticEngine:
          NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
    ),
    coreEvidence: _evidence(_summer, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.deadlineWithIdealizedTarget,
        ['她要为校展拍照。'],
        'The exhibition assignment establishes an externally bounded production goal with an ideal-result target.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
        ['许澄要无瑕画面，周岚要她看修复痕迹。'],
        'Xu Cheng seeks flawlessness while Zhou Lan asks her to preserve and read restoration traces, creating the central perfection-versus-trace conflict.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
        ['许澄放弃原构图，先捡回照片。'],
        'She gives up the planned composition to recover the relational photograph, explicitly sacrificing the ideal result for inherited evidence.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
        ['她必须在追光和捡照片之间选择。'],
        'The two actions become mutually exclusive at the decisive moment, forcing the tradeoff that changes what image can be made.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.sacrificedIdealCreatesAlternativeArtifact,
        ['因此，她错失最佳光线。'],
        'The Story explicitly makes the lost ideal light a direct consequence of the enacted choice, requiring a different resulting image.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.independenceReframedAsTraceableResponsibility,
        ['许澄不再只想证明独立。','她理解修复不是抹去痕迹，而是让失去、选择、守护与关系继续被后来的人读见。'],
        'Her model shifts from proving independence through flawlessness to accepting accountable choices whose losses and inherited traces remain legible.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.intergenerationalObjectEntrustment,
        ['她把旧照片交给许澄保存。'],
        'The senior generation entrusts the inherited photograph to Xu Cheng, making transferred stewardship the ending state.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
        ['周岚不再替她调整构图。','她把旧照片交给许澄保存。'],
        'Zhou Lan stops directing the younger photographer and then entrusts the family artifact, moving the relationship toward recognized agency.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.restorationTraceMakesTimeReadable,
        ['周岚曾保护长廊彩画。','她年轻时参与修复，如今视力衰退，仍记得褪色、裂纹和补绘的位置。'],
        'The Long Corridor restoration history gives visible traces a place-specific temporal function: damage, retouching, and conservation make time readable and drive the value conflict.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
        ['她必须在追光和捡照片之间选择。','许澄放弃原构图，先捡回照片。','因此，她错失最佳光线。'],
        'A forced either-or choice sacrifices the ideal shot, and that loss compels a new understanding of responsible authorship.'),
    ]),
  ),
  _forbidden: JourneySemanticFingerprint(
    journeyId: _forbidden,
    surfaceIdentity:
        'Shen Yan / seventeen-year-old construction apprentice / palace map / wooden ruler',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.incompleteKnowledgeOpportunity,
      protagonist:
          NarrativeMechanismFamily.apprenticeSeekingCompleteUnderstanding,
      relationship: NarrativeMechanismFamily.mentorToEntrustedAgency,
      goal: NarrativeMechanismFamily.completeKnowledgeRecord,
      conflict: NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
      choice: NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
      climax: NarrativeMechanismFamily.refusalAtAvailableThreshold,
      consequence: NarrativeMechanismFamily.intentionalVisibleIncompletion,
      transformation:
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
      ending: NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
      culturalAnchor:
          NarrativeMechanismFamily.heritageBoundaryMakesRestraintMeaningful,
      artifact: NarrativeMechanismFamily.mapBlankRecordsChosenBoundary,
      movement: NarrativeMechanismFamily.approachToUncrossedThreshold,
      temporalPressure:
          NarrativeMechanismFamily.openAccessWithoutExternalDeadline,
      supportingCharacter:
          NarrativeMechanismFamily.mentorDefinesBoundaryThenWithholdsIntervention,
      dramaticEngine:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
    ),
    coreEvidence: _evidence(_forbidden, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.incompleteKnowledgeOpportunity,
        ['十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。'],
        'An apprentice enters the palace for the first time with a knowledge gap, establishing an opportunity to complete understanding rather than a deadline or crisis.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
        ['沈砚知道自己不该进去，可门后恰好是那块最刺眼的空白。','沈砚开始动摇，却仍本能地厌恶地图上的空白'],
        'The open doorway simultaneously offers map completion and violates a known boundary, opposing his completion drive to responsible spatial restraint.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
        ['于是沈砚停下，没有跨过门槛。'],
        'Physical access is immediately available, but Shen Yan deliberately refuses to use availability as permission to advance his completion goal.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.refusalAtAvailableThreshold,
        ['就在这时，年幼侍役沿规定路线匆匆经过。','沈砚最终没有跨过去。'],
        'The servant makes identity-bound movement visible at the threshold, and Shen Yan resolves the decisive moment by refusing to cross.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.intentionalVisibleIncompletion,
        ['门后来关上，地图仍留下空白。'],
        'Because he does not cross, the missing area remains visibly unfilled rather than hidden or retrospectively completed.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
        ['不再追求填满','沈砚终于知道，理解空间不只靠进入，也靠承认边界。'],
        'His model changes from filling every blank through access to recognizing restraint and boundary acknowledgment as part of architectural understanding.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
        ['周师傅把用了多年的旧木尺交给他。'],
        'The mentor entrusts a working tool after Shen Yan demonstrates restraint, converting the ending into transferred responsibility and trust.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.mentorToEntrustedAgency,
        ['周师傅告诉他，真正的营造不仅处理结构，也要读懂人与空间之间的关系。','周师傅把用了多年的旧木尺交给他。'],
        'The mentor first frames the spatial ethic and later entrusts his own tool, showing a mentor-to-apprentice relationship culminating in recognized agency.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.heritageBoundaryMakesRestraintMeaningful,
        ['宫门既连接也区分','沈砚忽然明白，门既连接空间，也界定谁能够进入。'],
        'The palace gate is not decorative scenery: its architectural and historical function organizes access by identity, making restraint causally meaningful.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
        ['若他只因为门开着就跨过去','于是他没有跨过门槛。','门后来关上，地图仍不完整。'],
        'A completion-serving opportunity becomes physically available, is refused for responsibility rather than inability, and leaves the desired result intentionally incomplete.'),
    ]),
  ),
  _shanghai: JourneySemanticFingerprint(
    journeyId: _shanghai,
    surfaceIdentity:
        'Lin An / fintech transition / Huangpu ferry / old bill of lading',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
      protagonist: NarrativeMechanismFamily.youngProfessionalAtTransition,
      relationship:
          NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
      goal: NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
      conflict: NarrativeMechanismFamily.ruptureVsContinuity,
      choice: NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
      climax:
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
      consequence: NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
      transformation: NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
      ending: NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
      culturalAnchor: NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
      artifact: NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
      movement: NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
      temporalPressure: NarrativeMechanismFamily.nextDayLifeTransition,
      supportingCharacter:
          NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
      dramaticEngine:
          NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
    ),
    coreEvidence: _evidence(_shanghai, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
        ['这个晚上，他要去浦东陆家嘴，为第二天的新工作做准备。'],
        'The Story opens immediately before a new career role, with the family past still present in the transition.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.ruptureVsContinuity,
        ['过了黄浦江，就是离开旧上海，进入新上海。'],
        'Lin An frames the crossing as a clean rupture between old and new Shanghai, establishing the binary the Story later overturns.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
        ['最后还是把它放进包里。'],
        'He chooses to carry the inherited trade document rather than return or discard it before entering the new professional future.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
        ['轮渡离开西岸','江没有把上海分成过去和未来。'],
        'Recognition occurs during the literal crossing as the banks shift in view, so spatial movement itself overturns his old-versus-new model.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
        ['也把那张旧单据带过了江。'],
        'The chosen object physically crosses with him into the new-role side of the river, making continuity a visible consequence.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
        ['江没有把上海分成过去和未来。'],
        'His interpretive model explicitly changes from clean temporal rupture to continuity across the river.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
        ['船靠东岸后，他继续走向新的工作'],
        'He reaches the new-role side without reversing his career choice while retaining the inherited object, ending on continuity rather than return.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
        ['母亲没有劝他留下，只把提单递过去。'],
        'The mother transmits an object and history without blocking the son’s departure, carrying continuity without controlling his career choice.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
        ['两人沿黄浦江西岸向南走，身后是外滩历史建筑，江上船只拖着灯影，东岸的陆家嘴已经亮起来。','他忽然明白，江没有把上海分成过去和未来；人、货物、信息和钱一直在两岸之间换着方式流动。'],
        'The Huangpu holds historic Bund commerce and modern Lujiazui in one spatial field, while continuing flows provide the evidence that breaks the rupture model.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
        ['最后还是把它放进包里。','轮渡离开西岸','江没有把上海分成过去和未来。','也把那张旧单据带过了江。'],
        'The carried document and one-way river crossing jointly transform a past-versus-future split into intergenerational continuity without cancelling forward choice.'),
    ]),
  ),
  _xian: JourneySemanticFingerprint(
    journeyId: _xian,
    surfaceIdentity:
        'Zhou Yao / local runner / city-wall circuit / running watch',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.farewellCompletionRitual,
      protagonist: NarrativeMechanismFamily.localMoverTestingBelonging,
      relationship: NarrativeMechanismFamily.familyAsBelongingAnchor,
      goal: NarrativeMechanismFamily.completeFarewellCircuit,
      conflict: NarrativeMechanismFamily.addressChangeVsBelongingContinuity,
      choice: NarrativeMechanismFamily.continueBeyondDeclaredFinish,
      climax: NarrativeMechanismFamily.completedCircuitBecomesDeparturePoint,
      consequence:
          NarrativeMechanismFamily.completedRecordExtendsBeyondOriginalBoundary,
      transformation:
          NarrativeMechanismFamily.boundedBelongingToContinuingBelonging,
      ending: NarrativeMechanismFamily.artifactRecordsOpenContinuation,
      culturalAnchor:
          NarrativeMechanismFamily.fortificationBoundaryReframesBelonging,
      artifact:
          NarrativeMechanismFamily.runningRecordTurnsFinishIntoContinuation,
      movement: NarrativeMechanismFamily.closedCircuitThenOutboundContinuation,
      temporalPressure: NarrativeMechanismFamily.selfDeclaredFinalOccurrence,
      supportingCharacter:
          NarrativeMechanismFamily.familyMessageReorientsMeaningOfDestination,
      dramaticEngine:
          NarrativeMechanismFamily.completedClosureBecomesOpenContinuation,
    ),
    coreEvidence: _evidence(_xian, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.farewellCompletionRitual,
        ['想跑完一圈，把这条熟悉的路当成最后一次告别。'],
        'He deliberately defines a complete wall circuit as a final farewell ritual before relocation.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.addressChangeVsBelongingContinuity,
        ['搬出去以后，自己还算不算“城里人”'],
        'The explicit question makes address change threaten his sense of continuing belonging to the old city.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.continueBeyondDeclaredFinish,
        ['他没有按停，而是下城继续往南跑。'],
        'At the self-declared finish, he deliberately refuses closure and continues the same run toward the new home.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.completedCircuitBecomesDeparturePoint,
        ['跑表刚好记下一整圈。'],
        'The watch verifies that the promised closed circuit is complete, turning the finish point into the decision point for onward movement.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.completedRecordExtendsBeyondOriginalBoundary,
        ['他的距离还在增加。'],
        'Because he keeps running after completion, the same record extends beyond the boundary it was originally meant to close.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.boundedBelongingToContinuingBelonging,
        ['周遥小时候在墙下骑车，上学后又常来跑步，这些记忆并不只在墙内。','周遥没有按停计时。他下城后继续向南跑，穿过晚高峰的路口。'],
        'His memories and enacted continuation show that belonging is no longer contained by the wall or address; it continues toward the new home.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.artifactRecordsOpenContinuation,
        ['跑表上的距离越过那一圈。'],
        'The ending artifact records distance beyond the completed circuit, preserving open continuation instead of a sealed farewell.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.familyAsBelongingAnchor,
        ['母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。'],
        'The family does not oppose his run; the message makes the new home an awaiting relational destination and anchors belonging beyond the wall.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.fortificationBoundaryReframesBelonging,
        ['现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。','这些记忆并不只在墙内。'],
        'The protected fortification supplies the literal inside/outside boundary he initially equates with belonging, then reinterprets through lived use and memory.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.completedClosureBecomesOpenContinuation,
        ['跑表刚好记下一整圈。','他没有按停，而是下城继续往南跑。','跑表上的距离越过那一圈。'],
        'A deliberately completed closed circuit becomes the departure point for continuing motion, and the same artifact records the shift from closure to continuation.'),
    ]),
  ),
  _hangzhou: JourneySemanticFingerprint(
    journeyId: _hangzhou,
    surfaceIdentity:
        'Xu Cheng / urban sound archivist / Su Causeway / field recording',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.fieldAssignmentWithPurityModel,
      protagonist: NarrativeMechanismFamily.fieldRecorderTestingAuthenticityModel,
      relationship: NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
      goal: NarrativeMechanismFamily.capturePurifiedRecord,
      conflict: NarrativeMechanismFamily.purityModelVsLivedEvidence,
      choice:
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
      climax: NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
      consequence:
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
      transformation: NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
      ending:
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
      culturalAnchor:
          NarrativeMechanismFamily.livedCulturalLandscapeDisprovesPurity,
      artifact:
          NarrativeMechanismFamily.fieldRecordingStoresReclassifiedEvidence,
      movement: NarrativeMechanismFamily.linearFieldTransectWithReorientation,
      temporalPressure: NarrativeMechanismFamily.approachingWeatherWindow,
      supportingCharacter:
          NarrativeMechanismFamily.noDecisiveSupportingCharacter,
      dramaticEngine: NarrativeMechanismFamily.evidenceForcesReclassification,
    ),
    coreEvidence: _evidence(_hangzhou, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.fieldAssignmentWithPurityModel,
        ['想收下一段“干净”的声音'],
        'The field-recording task begins with a self-imposed purity criterion defining what evidence she intends to admit or reject.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.purityModelVsLivedEvidence,
        ['一声自行车铃闯进录音，她皱眉删掉重来。'],
        'Ordinary lived sound contradicts her clean-West-Lake model and she initially treats the contradiction as contamination to remove.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
        ['她忽然没有再删。'],
        'At the repeated contamination point, she changes behavior from deleting contrary evidence to retaining it.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
        ['许澄把麦克风转向堤上和水面'],
        'She actively re-aims the recorder to include previously rejected human and environmental layers, enacting the new classification in the artifact.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
        ['让雨声、脚步和人声一起进入录音。'],
        'The revised decision leaves the contrary layers inside the recording rather than deleting them.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
        ['她不再追赶“干净”，而是把麦克风转向堤上与水面，让变化同时进入一条录音。','第二天，她把文件名写成日期、苏堤路线和“在场”。'],
        'Her behavior and final naming show a changed authenticity model: value moves from purified absence to layered presence recorded as part of the place.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
        ['第二天，她把文件写成日期、苏堤路线和两个字：“在场”。'],
        'The final archive record names and stores the revised understanding rather than a cleaned replacement take.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
        ['许澄私下又加了一条标准：她想录到“最像西湖”的声音。','她没有删除，而在记录表上写下“桥上人流”。'],
        'The decisive standard and its reversal are both generated and enacted by Xu Cheng during fieldwork; no mentor or supporting character supplies the causal reinterpretation.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.livedCulturalLandscapeDisprovesPurity,
        ['苏堤本身就来自长期的湖水治理和人工营造，西湖的堤、岛、桥、园林与山水共同组成文化景观；把所有人的声音清掉，反而像把其中一层历史关系擦掉。'],
        'Su Causeway and West Lake function as a historically made, continuously inhabited cultural landscape; that place-specific fact directly disproves human-free purity.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.evidenceForcesReclassification,
        ['她觉得这一段被“污染”了，停下录音，删掉文件，从头再来。','苏堤本身就来自长期的湖水治理和人工营造，西湖的堤、岛、桥、园林与山水共同组成文化景观；把所有人的声音清掉，反而像把其中一层历史关系擦掉。','她不再追赶“干净”，而是把麦克风转向堤上与水面，让变化同时进入一条录音。'],
        'The engine moves from filtering contradictory evidence, through place-specific evidence that invalidates the purity model, to an artifact practice that adopts the revised classification.'),
    ]),
  ),
  _chengdu: JourneySemanticFingerprint(
    journeyId: _chengdu,
    surfaceIdentity:
        'Lin Xia / architecture researcher / Kuanzhai Alley / marked survey sheet',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.fieldSurveyWithPriorClassification,
      protagonist: NarrativeMechanismFamily.researcherTestingAuthenticityModel,
      relationship: NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
      goal: NarrativeMechanismFamily.validatePriorAuthenticityModel,
      conflict: NarrativeMechanismFamily.purityModelVsLivedEvidence,
      choice:
          NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
      climax: NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
      consequence:
          NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
      transformation: NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
      ending:
          NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
      culturalAnchor:
          NarrativeMechanismFamily.livedUseDisprovesFrozenAuthenticity,
      artifact:
          NarrativeMechanismFamily.markedSurveyStoresReclassifiedEvidence,
      movement: NarrativeMechanismFamily.comparativeFieldSurveyWithReturn,
      temporalPressure: NarrativeMechanismFamily.fieldDayThenSubmission,
      supportingCharacter:
          NarrativeMechanismFamily.noDecisiveSupportingCharacter,
      dramaticEngine: NarrativeMechanismFamily.evidenceForcesReclassification,
    ),
    coreEvidence: _evidence(_chengdu, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.fieldSurveyWithPriorClassification,
        ['她带着“使用痕迹调查”表走进宽窄巷子'],
        'She enters fieldwork with a formal survey instrument and an already defined authenticity classification to test against the site.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.purityModelVsLivedEvidence,
        ['认定商业越多，历史越不真实'],
        'Her prior purity model treats visible commerce as loss of authenticity while observed continuing use contradicts that classification.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.reviseClassificationInsteadOfFilteringEvidence,
        ['林夏把“商业活动”四个字轻轻划掉'],
        'She explicitly removes the original negative category instead of discarding the contrary observations that challenged it.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.evidenceReclassificationEnactedInArtifact,
        ['在旁边写：“仍在使用。”'],
        'The revised classification is enacted directly on the survey artifact at the decisive moment.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.retainedEvidencePreservesReclassification,
        ['第二天交表时，她没有誊清那一页。'],
        'She preserves the crossed-out classification and revision in the submitted record rather than cleaning away evidence of changed judgment.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.purityModelToLayeredAuthenticity,
        ['椅脚磨出的痕迹和旧门槛一样真实。','林夏把“商业活动”四个字轻轻划掉'],
        'She recognizes contemporary use traces as authentically legible alongside older fabric, then changes her classification to a layered authenticity model.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.revisedArtifactRecordsChangedUnderstanding,
        ['第二天交表时，她没有誊清那一页。'],
        'The Story ends with the visibly revised original survey surviving into submission, making changed understanding durable in the artifact.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.soloFieldworkAgainstInternalModel,
        ['导师布置“使用痕迹调查”时，要求学生不要只拍建筑，而要记录历史街区如何被今天的人真正使用。','林夏翻到第一页，看着自己写的“商业活动”，没有加一句辩解，只把四个字划掉，在旁边写：“仍在使用。”'],
        'The instructor defines the assignment but not the conclusion; Lin Xia’s own observations confront her internal model and she independently revises the record.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.livedUseDisprovesFrozenAuthenticity,
        ['林夏选择宽窄巷子，因为它由宽巷子、窄巷子和井巷子构成，旧街巷、院落与现代经营挤在一起，正适合检验她熟悉的保护观念。','杯底留下的水圈很快会干，椅脚和门槛的磨痕却是日复一日积出的；新活动没有把旧空间变成静止展品，反而持续留下可读的使用证据。'],
        'Kuanzhai Alley’s coexistence of historic spatial fabric and ongoing social/commercial use supplies the evidence that frozen authenticity is inadequate.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.evidenceForcesReclassification,
        ['她一直倾向于把“原真”理解成减少后来加入的东西：商业越少，历史空间越纯。','新活动没有把旧空间变成静止展品，反而持续留下可读的使用证据。','林夏翻到第一页，看着自己写的“商业活动”，没有加一句辩解，只把四个字划掉，在旁边写：“仍在使用。”'],
        'The engine begins with a prior authenticity category, accumulates site evidence that falsifies it, and ends with the protagonist revising the category in the survey.'),
    ]),
  ),
  _nanjing: JourneySemanticFingerprint(
    journeyId: _nanjing,
    surfaceIdentity:
        'Wei Zhou / lighting technician / Qinhuai festival route / final status record',
    mechanisms: _mechanisms(
      opening: NarrativeMechanismFamily.operationalFailureCountdown,
      protagonist: NarrativeMechanismFamily.technicianSeekingIndependentTrust,
      relationship:
          NarrativeMechanismFamily.supervisorToEntrustedResponsibility,
      goal: NarrativeMechanismFamily.restoreCompleteOperationalResult,
      conflict: NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
      choice: NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
      climax:
          NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion,
      consequence: NarrativeMechanismFamily.intentionalVisibleIncompletion,
      transformation:
          NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
      ending: NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
      culturalAnchor:
          NarrativeMechanismFamily.heritageOperationsConstrainSpectacle,
      artifact:
          NarrativeMechanismFamily.statusRecordTransfersOperationalOwnership,
      movement: NarrativeMechanismFamily.fixedFailureZoneDecision,
      temporalPressure: NarrativeMechanismFamily.explicitOperationalCountdown,
      supportingCharacter: NarrativeMechanismFamily
          .supervisorAbsentForChoiceThenTransfersOwnership,
      dramaticEngine:
          NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
    ),
    coreEvidence: _evidence(_nanjing, [
      (NarrativeSemanticDimension.openingMechanism,
        NarrativeMechanismFamily.operationalFailureCountdown,
        ['离秦淮灯会亮灯还有七分钟'],
        'A public-opening lighting failure arrives with a seven-minute operational deadline, creating an immediate countdown mechanism.'),
      (NarrativeSemanticDimension.conflictMechanism,
        NarrativeMechanismFamily.completeResultVsResponsibleBoundary,
        ['最快的办法是临时改动原来的照明线路，但这项改动没有经过确认'],
        'The fastest route to full visual completion requires an unconfirmed change, opposing spectacle completion to responsible operating boundaries.'),
      (NarrativeSemanticDimension.choiceMechanism,
        NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
        ['最后还是停下了手。'],
        'Wei Zhou deliberately stops himself from using the available shortcut even though it could restore the missing decorative effect.'),
      (NarrativeSemanticDimension.climaxMechanism,
        NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion,
        ['放弃一段装饰灯。'],
        'The decisive operational action accepts a visibly reduced decorative result to preserve the approved safe configuration.'),
      (NarrativeSemanticDimension.consequenceMechanism,
        NarrativeMechanismFamily.intentionalVisibleIncompletion,
        ['那一段装饰灯仍然黑着。'],
        'The refused shortcut leaves a clearly visible dark section when the route opens, making incompletion an intentional consequence.'),
      (NarrativeSemanticDimension.transformationMechanism,
        NarrativeMechanismFamily.completionDriveToResponsibleRestraint,
        ['他很想把所有灯都亮起来，最后还是停下了手。','他保留原有安全方案，把能用的电力留给通行照明，放弃一段装饰灯。'],
        'His goal shifts from proving competence through total illumination to accepting a reduced result that prioritizes confirmed safety and responsibility.'),
      (NarrativeSemanticDimension.endingMechanism,
        NarrativeMechanismFamily.responsibilityTransferAfterRestraint,
        ['只把最终灯光状态记录交给魏舟填写。'],
        'After the restrained decision stands, the supervisor transfers final-state documentation to Wei Zhou, ending on entrusted operational ownership.'),
      (NarrativeSemanticDimension.relationshipGeometry,
        NarrativeMechanismFamily.supervisorToEntrustedResponsibility,
        ['周工正在另一段处理问题，不能马上回来。','只把最终灯光状态记录交给魏舟填写。'],
        'The supervisor is absent for the decisive judgment and later hands the final record to Wei Zhou, shifting toward entrusted responsibility.'),
      (NarrativeSemanticDimension.culturalAnchorFunction,
        NarrativeMechanismFamily.heritageOperationsConstrainSpectacle,
        ['这里属于历史风貌敏感的河岸段，临时改动公用照明安排需要确认，剩下的时间也不够重新完成安全检查。'],
        'The Qinhuai heritage-sensitive riverbank makes the operating constraint place-specific: decorative spectacle cannot override confirmed infrastructure and safety procedures.'),
      (NarrativeSemanticDimension.dramaticEngineFamily,
        NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
        ['最快的办法是临时改动原来的照明线路，但这项改动没有经过确认，也来不及重新检查安全。','最后还是停下了手。','那一段装饰灯仍然黑着。'],
        'A completion-restoring shortcut is technically available but unconfirmed, the protagonist refuses it on responsibility grounds, and visible incompletion remains.'),
    ]),
  ),
});

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
  final evidenceByDimension = <NarrativeSemanticDimension,
      List<NarrativeMechanismEvidence>>{};
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

/// Deterministic provenance only. This proves source identity and exact spans,
/// not semantic entailment.
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

/// CI verifies provenance, completeness, and registry alignment. Founder/Agent
/// review verifies semantic sufficiency by auditing the rationale against the
/// cited active-Story spans.
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
) => semanticEvidenceProvenanceErrors(fingerprint);

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
