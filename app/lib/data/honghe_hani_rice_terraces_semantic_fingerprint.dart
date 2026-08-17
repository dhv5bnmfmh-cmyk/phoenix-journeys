import 'honghe_hani_rice_terraces_gold_content.dart';
import 'journey_semantic_fingerprint_catalog.dart';

NarrativeMechanismEvidence _e(
  NarrativeSemanticDimension dimension,
  NarrativeMechanismFamily mechanism,
  String text,
  String rationale,
) =>
    NarrativeMechanismEvidence(
      journeyId: hongheHaniRiceTerracesJourneyId,
      dimension: dimension,
      mechanism: mechanism,
      activeSourceId: activeGoldStorySourceId,
      sourceTexts: <String>[text],
      semanticRationale: rationale,
    );

final hongheHaniRiceTerracesCandidateSemanticFingerprint =
    JourneySemanticFingerprint(
  journeyId: hongheHaniRiceTerracesJourneyId,
  surfaceIdentity:
      'Luo Qiu / contemporary fictional terrace farmer and water keeper / neighbor Ma Lan / recut wooden water divider / withdrawn buffalo labor',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.springIrrigationDutyBeginsWithPrivateLaborDependency,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.electedWaterKeeperDependentOnReciprocalNeighborLabor,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.neighboringFarmersBoundByPrivateLaborExchange,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.restoreAgreedWaterSharesAndFinishOwnField,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.communalWaterAllocationVsPrivateLaborReciprocity,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.restoreAgreedFlowDespitePrivateLaborLoss,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.carvedDividerResetsBranchFlows,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.downstreamFlowRestoredWhileOwnPloughingIsLost,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.privateReciprocityToAcceptedPublicRoleCost,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.ownFieldWorkContinuesWithoutRelationalRepair,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.carvedWaterDividerEmbodiesCollectiveAgreement,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.alteredGrooveEmbodiesPrivateAdvantage,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.branchingWaterRedistributionDownTerraceSlope,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.sameDaySpringIrrigationAndPloughingWindow,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.friendWithdrawsLaborAfterAllocationRestoration,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.communalWaterRuleForcesPrivateReciprocityCost,
  }),
  coreEvidence: <NarrativeMechanismEvidence>[
    _e(
      NarrativeSemanticDimension.openingMechanism,
      NarrativeMechanismFamily.springIrrigationDutyBeginsWithPrivateLaborDependency,
      hongheHaniRiceTerracesGoldLevelContent(1).storyParagraphs.first,
      'The Story opens with a public spring-irrigation ditch duty and a same-day private buffalo arrangement already interlocked; this is not a school assignment, aesthetic opportunity or generic deadline.',
    ),
    _e(
      NarrativeSemanticDimension.relationshipGeometry,
      NarrativeMechanismFamily.neighboringFarmersBoundByPrivateLaborExchange,
      hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs.first,
      'Luo Qiu and Ma Lan are neighboring farmers whose private labor exchange makes the public allocation decision personally costly; deleting Ma Lan removes the central relationship pressure.',
    ),
    _e(
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeMechanismFamily.communalWaterAllocationVsPrivateLaborReciprocity,
      hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs.first,
      'The widened groove favors the same friend whose buffalo Luo Qiu needs, making collectively agreed water distribution conflict directly with private reciprocity.',
    ),
    _e(
      NarrativeSemanticDimension.choiceMechanism,
      NarrativeMechanismFamily.restoreAgreedFlowDespitePrivateLaborLoss,
      hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs.last,
      'Luo Qiu restores the collectively agreed groove dimensions immediately instead of delaying public allocation until after receiving private labor help.',
    ),
    _e(
      NarrativeSemanticDimension.climaxMechanism,
      NarrativeMechanismFamily.carvedDividerResetsBranchFlows,
      hongheHaniRiceTerracesGoldLevelContent(10).storyParagraphs.last,
      'The climax is a coupled physical and relational state change: the recut divider restores two branch flows as Ma Lan lifts the buffalo rope and leaves.',
    ),
    _e(
      NarrativeSemanticDimension.consequenceMechanism,
      NarrativeMechanismFamily.downstreamFlowRestoredWhileOwnPloughingIsLost,
      hongheHaniRiceTerracesGoldLevelContent(6).storyParagraphs.last,
      'The lower branch receives water again while the promised buffalo labor disappears, leaving Luo Qiu’s own final terrace unploughed that day.',
    ),
    _e(
      NarrativeSemanticDimension.transformationMechanism,
      NarrativeMechanismFamily.privateReciprocityToAcceptedPublicRoleCost,
      hongheHaniRiceTerracesGoldLevelContent(10).storyParagraphs.join('\n'),
      'Luo Qiu begins by imagining water-keeper duty as extra ditch rounds and ends by carrying the private labor and friendship cost of enforcing a shared allocation.',
    ),
    _e(
      NarrativeSemanticDimension.endingMechanism,
      NarrativeMechanismFamily.ownFieldWorkContinuesWithoutRelationalRepair,
      hongheHaniRiceTerracesGoldLevelContent(10).storyParagraphs.last,
      'The ending gives no apology or reconciliation summary: Luo Qiu works the bund of her own unploughed field while the restored branches continue flowing.',
    ),
    _e(
      NarrativeSemanticDimension.culturalAnchorFunction,
      NarrativeMechanismFamily.carvedWaterDividerEmbodiesCollectiveAgreement,
      hongheHaniRiceTerracesGoldLevelContent(8).storyParagraphs.first,
      'The verified wooden water-division practice turns a negotiated community share into a material groove that changes real water flow; culture functions causally rather than decoratively.',
    ),
    _e(
      NarrativeSemanticDimension.dramaticEngineFamily,
      NarrativeMechanismFamily.communalWaterRuleForcesPrivateReciprocityCost,
      hongheHaniRiceTerracesGoldLevelContent(10).storyParagraphs.join('\n'),
      'A living communal water rule forces the protagonist to choose between restoring shared allocation and preserving the private reciprocal labor on which her own farm plan depends.',
    ),
  ],
);

FutureGoldSemanticGateResult hongheHaniRiceTerracesSemanticGate() =>
    evaluateFutureGoldSemanticCandidate(
      hongheHaniRiceTerracesCandidateSemanticFingerprint,
    );