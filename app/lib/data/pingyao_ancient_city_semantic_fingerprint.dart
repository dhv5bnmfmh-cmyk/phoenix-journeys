import 'journey_semantic_fingerprint_catalog.dart';
import 'pingyao_ancient_city_gold_content.dart';

NarrativeMechanismEvidence _e(
  NarrativeSemanticDimension dimension,
  NarrativeMechanismFamily mechanism,
  String text,
  String rationale,
) => NarrativeMechanismEvidence(
  journeyId: pingyaoAncientCityJourneyId,
  dimension: dimension,
  mechanism: mechanism,
  activeSourceId: pingyaoActiveGoldStorySourceId,
  sourceTexts: <String>[text],
  semanticRationale: rationale,
);

final pingyaoAncientCityCandidateSemanticFingerprint = JourneySemanticFingerprint(
  journeyId: pingyaoAncientCityJourneyId,
  surfaceIdentity: 'Cheng Yan / fictional late-Qing Pingyao cloth-shop coowner / older brother Cheng Yue / draft-bank remittance / stationary silver chest / separated ledgers',
  mechanisms: Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.unmodifiable({
    NarrativeSemanticDimension.openingMechanism:
        NarrativeMechanismFamily.lateQingShopDayCombinesIllnessAndDuePayment,
    NarrativeSemanticDimension.protagonistRolePattern:
        NarrativeMechanismFamily.coownerReframingResponsibilityThroughNetworkedCredit,
    NarrativeSemanticDimension.relationshipGeometry:
        NarrativeMechanismFamily.coowningBrothersBoundBySharedRiskPractice,
    NarrativeSemanticDimension.goalMechanism:
        NarrativeMechanismFamily.settleDistantPaymentWhileRemainingWithSickMother,
    NarrativeSemanticDimension.conflictMechanism:
        NarrativeMechanismFamily.bodilySilverCustodyVsNetworkedCreditPresence,
    NarrativeSemanticDimension.choiceMechanism:
        NarrativeMechanismFamily.sendVerifiableDraftInsteadOfEscortSilver,
    NarrativeSemanticDimension.climaxMechanism:
        NarrativeMechanismFamily.draftDepartsAsSharedLedgerSeparates,
    NarrativeSemanticDimension.consequenceMechanism:
        NarrativeMechanismFamily.paymentCanSettleWhileBusinessPartnershipSplits,
    NarrativeSemanticDimension.transformationMechanism:
        NarrativeMechanismFamily.bodilyRiskProofToInstitutionalCreditResponsibility,
    NarrativeSemanticDimension.endingMechanism:
        NarrativeMechanismFamily.newLedgerBeginsWithoutBrotherlyVindication,
    NarrativeSemanticDimension.culturalAnchorFunction:
        NarrativeMechanismFamily.draftBankRemittanceSeparatesValueFromSilverTransport,
    NarrativeSemanticDimension.artifactObjectNarrativeFunction:
        NarrativeMechanismFamily.stationarySilverChestAndSeparatedLedgerShowChangedMobility,
    NarrativeSemanticDimension.movementSpatialMechanism:
        NarrativeMechanismFamily.draftMovesAcrossBranchNetworkWhileBodyStays,
    NarrativeSemanticDimension.temporalPressureMechanism:
        NarrativeMechanismFamily.sameDayIllnessAndDuePaymentPressure,
    NarrativeSemanticDimension.supportingCharacterFunction:
        NarrativeMechanismFamily.olderBrotherSeparatesAccountsAfterRemittanceChoice,
    NarrativeSemanticDimension.dramaticEngineFamily:
        NarrativeMechanismFamily.networkedCreditReassignsWhoMustTravelAtPrivateRelationshipCost,
  }),
  coreEvidence: <NarrativeMechanismEvidence>[
    _e(
      NarrativeSemanticDimension.openingMechanism,
      NarrativeMechanismFamily.lateQingShopDayCombinesIllnessAndDuePayment,
      pingyaoAncientCityGoldLevelContent(5).storyParagraphs.first,
      'The opening interlocks a sick mother with a due distant supplier payment inside one fictional Pingyao shop day; it is not an assignment, field-study opportunity, heritage deadline, or public-duty shift.',
    ),
    _e(
      NarrativeSemanticDimension.relationshipGeometry,
      NarrativeMechanismFamily.coowningBrothersBoundBySharedRiskPractice,
      pingyaoAncientCityGoldLevelContent(7).storyParagraphs.first,
      'The brothers are both kin and coowners whose long-shared silver chest and ledger make bodily risk-sharing a private proof of responsibility. Deleting the brother deletes the central cost.',
    ),
    _e(
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeMechanismFamily.bodilySilverCustodyVsNetworkedCreditPresence,
      pingyaoAncientCityGoldLevelContent(9).storyParagraphs.first,
      'The conflict is not rule compliance or shortcut refusal: it is whether responsibility must remain embodied in a family member escorting silver when verified networked credit can move value without that body leaving home.',
    ),
    _e(
      NarrativeSemanticDimension.choiceMechanism,
      NarrativeMechanismFamily.sendVerifiableDraftInsteadOfEscortSilver,
      pingyaoAncientCityGoldLevelContent(10).storyParagraphs.first,
      'Cheng Yan chooses to deposit silver and send a verifiable draft through the branch network, specifically separating value movement from his own physical departure.',
    ),
    _e(
      NarrativeSemanticDimension.climaxMechanism,
      NarrativeMechanismFamily.draftDepartsAsSharedLedgerSeparates,
      pingyaoAncientCityGoldLevelContent(10).storyParagraphs.last,
      'The climax couples two opposite movements: the draft leaves while the original silver remains, and Cheng Yue removes his ledger from the shared counter.',
    ),
    _e(
      NarrativeSemanticDimension.consequenceMechanism,
      NarrativeMechanismFamily.paymentCanSettleWhileBusinessPartnershipSplits,
      pingyaoAncientCityGoldLevelContent(9).storyParagraphs.last,
      'The financial system can complete distant settlement and let Cheng Yan remain with his mother, while the brothers still split their business accounts. Institutional success does not erase private cost.',
    ),
    _e(
      NarrativeSemanticDimension.transformationMechanism,
      NarrativeMechanismFamily.bodilyRiskProofToInstitutionalCreditResponsibility,
      pingyaoAncientCityGoldLevelContent(10).storyParagraphs.join('\n'),
      'Cheng Yan moves from inherited bodily custody as the measure of responsibility to accepting verified institutional credit as a real form of responsibility, without demanding that his brother share that interpretation.',
    ),
    _e(
      NarrativeSemanticDimension.endingMechanism,
      NarrativeMechanismFamily.newLedgerBeginsWithoutBrotherlyVindication,
      pingyaoAncientCityGoldLevelContent(10).storyParagraphs.last,
      'The ending refuses a proof-of-rightness or reconciliation button: the receipt enters a new ledger, the unused silver chest is locked, and Cheng Yan returns to his mother while two ledgers remain apart.',
    ),
    _e(
      NarrativeSemanticDimension.culturalAnchorFunction,
      NarrativeMechanismFamily.draftBankRemittanceSeparatesValueFromSilverTransport,
      pingyaoDiscoveriesForLevel(8).last.text,
      'The verified Pingyao draft-bank mechanism is causal: a branch-verifiable credit instrument lets value settle across distance without the original silver chest taking the same route.',
    ),
    _e(
      NarrativeSemanticDimension.dramaticEngineFamily,
      NarrativeMechanismFamily.networkedCreditReassignsWhoMustTravelAtPrivateRelationshipCost,
      pingyaoAncientCityGoldLevelContent(10).storyParagraphs.join('\n'),
      'Networked credit changes who physically must travel, which directly changes family presence and the brothers’ definition of shared responsibility. The place mechanism creates the human tradeoff rather than decorating it.',
    ),
  ],
);

FutureGoldSemanticGateResult pingyaoAncientCitySemanticGate() =>
    evaluateFutureGoldSemanticCandidate(pingyaoAncientCityCandidateSemanticFingerprint);
