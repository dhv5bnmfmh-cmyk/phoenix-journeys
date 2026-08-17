import 'journey_semantic_fingerprint_catalog.dart';
import 'lijiang_old_town_gold_content.dart';

NarrativeMechanismEvidence _e(
  NarrativeSemanticDimension dimension,
  NarrativeMechanismFamily mechanism,
  String text,
  String rationale,
) =>
    NarrativeMechanismEvidence(
      journeyId: lijiangOldTownJourneyId,
      dimension: dimension,
      mechanism: mechanism,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[text],
      semanticRationale: rationale,
    );

final lijiangOldTownCandidateSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: lijiangOldTownJourneyId,
  surfaceIdentity:
      'He Qing / late-Qing fictional small trader / older sister He Su / jointly owned wet tea / canal bridge bucket relay',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.marketClosingBeforeSingleSaleWindow,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.smallTraderProtectingSharedLivelihood,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.jointOwnersUnderSharedDebt,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.preserveSharedLivelihoodBeforeBuyerLeaves,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.privateLivelihoodAssetVsImmediateSharedSafety,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.destroySharedAssetToOpenEmergencyAccess,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.bridgeClearsAsCargoFallsIntoCanal,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.emergencyWaterFlowContainsHazardWithTradeLoss,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.unilateralControlToJointlyBorneLoss,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.sharedCleanupWithoutVerbalReconciliation,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.distributedWaterInfrastructureEnablesEmergencyResponse,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.wetTradeGoodsEmbodyIrreversibleSharedCost,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.blockedBridgeToBucketRelay,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.nextMorningTradeWindowAfterMarketClose,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.sisterOpposesLossThenSharesCleanup,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.placeInfrastructureForcesLivelihoodSacrificeUnderHazard,
  }),
  coreEvidence: <NarrativeMechanismEvidence>[
    _e(
      NarrativeSemanticDimension.openingMechanism,
      NarrativeMechanismFamily.marketClosingBeforeSingleSaleWindow,
      lijiangOldTownGoldLevelContent(1).storyParagraphs.first,
      'The Story opens after Sifang market dispersal with one next-morning sale window; this is an economic timing condition, not a generic school deadline or aesthetic opportunity.',
    ),
    _e(
      NarrativeSemanticDimension.relationshipGeometry,
      NarrativeMechanismFamily.jointOwnersUnderSharedDebt,
      lijiangOldTownGoldLevelContent(5).storyParagraphs.first,
      'The sister and brother jointly own the endangered tea and jointly owe the debt; removing the sister deletes the authority conflict inside the choice.',
    ),
    _e(
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeMechanismFamily.privateLivelihoodAssetVsImmediateSharedSafety,
      lijiangOldTownGoldLevelContent(5).storyParagraphs.first,
      'The same jointly owned livelihood asset must be preserved for debt repayment yet physically blocks the shortest access across the canal during a fictional fire.',
    ),
    _e(
      NarrativeSemanticDimension.choiceMechanism,
      NarrativeMechanismFamily.destroySharedAssetToOpenEmergencyAccess,
      lijiangOldTownGoldLevelContent(5).storyParagraphs.last,
      'He Qing irreversibly cuts lashings and accepts damage to property that is not solely his, directly creating emergency passage.',
    ),
    _e(
      NarrativeSemanticDimension.climaxMechanism,
      NarrativeMechanismFamily.bridgeClearsAsCargoFallsIntoCanal,
      lijiangOldTownGoldLevelContent(10).storyParagraphs.last,
      'The climax is a physical change of state: the last rope parts, cargo falls and a narrow strip of bridge becomes usable.',
    ),
    _e(
      NarrativeSemanticDimension.consequenceMechanism,
      NarrativeMechanismFamily.emergencyWaterFlowContainsHazardWithTradeLoss,
      lijiangOldTownGoldLevelContent(6).storyParagraphs.last,
      'The immediate benefit and cost coexist: buckets cross the opened bridge while wet tea loses its sale and the debt remains.',
    ),
    _e(
      NarrativeSemanticDimension.transformationMechanism,
      NarrativeMechanismFamily.unilateralControlToJointlyBorneLoss,
      lijiangOldTownGoldLevelContent(10).storyParagraphs.last,
      'The relationship changes without declaring a winner: the sister first opposes unilateral loss, then joins the bucket relay and later shares the carrying weight.',
    ),
    _e(
      NarrativeSemanticDimension.endingMechanism,
      NarrativeMechanismFamily.sharedCleanupWithoutVerbalReconciliation,
      lijiangOldTownGoldLevelContent(10).storyParagraphs.last,
      'The ending refuses a reconciliation summary; the carrying pole shifts until its weight is literally borne between the siblings.',
    ),
    _e(
      NarrativeSemanticDimension.culturalAnchorFunction,
      NarrativeMechanismFamily.distributedWaterInfrastructureEnablesEmergencyResponse,
      lijiangOldTownGoldLevelContent(8).storyParagraphs.first,
      'Verified Lijiang canals, bridges, timber lanes and fire-prevention water change what actions are possible; water is a causal infrastructure, not decorative heritage vocabulary.',
    ),
    _e(
      NarrativeSemanticDimension.dramaticEngineFamily,
      NarrativeMechanismFamily.placeInfrastructureForcesLivelihoodSacrificeUnderHazard,
      lijiangOldTownGoldLevelContent(10).storyParagraphs.join('\n'),
      'Place infrastructure turns a jointly owned commercial load into an immediate physical obstruction, forcing irreversible livelihood sacrifice to release emergency flow.',
    ),
  ],
);

FutureGoldSemanticGateResult lijiangOldTownSemanticGate() =>
    evaluateFutureGoldSemanticCandidate(lijiangOldTownCandidateSemanticFingerprint);
