import 'journey_narrative_dna_catalog.dart';

const pingyaoAncientCityCandidateNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'pingyao-ancient-city',
  narrativeIdentity: 'brother-uses-draft-bank-remittance-so-credit-travels-while-he-stays-with-sick-mother-and-shared-ledger-splits',
  protagonistIdentity: 'Cheng-Yan-fictional-late-Qing-Pingyao-cloth-shop-coowner-and-younger-brother',
  protagonistAgeIdentity: 'fictional-adult-merchant-household-member',
  protagonistArchetype: 'ordinary-coowner-redefining-responsibility-from-bodily-custody-to-verifiable-networked-credit',
  openingSituation: 'sick-mother-and-due-Beijing-supplier-payment-collide-on-one-late-Qing-shop-day',
  storyGoal: 'settle-distant-payment-without-leaving-sick-mother',
  locationMechanism: 'Pingyao-draft-bank-remittance-separates-value-movement-from-long-distance-movement-of-original-silver-through-draft-branch-ledger-and-verification',
  movementPattern: 'silver-chest-stays-under-Pingyao-counter-draft-travels-to-Beijing-branch-while-protagonist-turns-back-to-inner-room',
  conflictType: 'kin-bodily-custody-as-proof-of-shared-responsibility-vs-institutional-credit-that-allows-protagonist-to-remain-present-at-home',
  choiceType: 'deposit-silver-and-send-verifiable-draft-instead-of-personally-escorting-silver',
  climaxType: 'draft-enters-envelope-as-silver-chest-stays-and-brother-removes-ledger-from-shared-counter',
  consequenceType: 'distant-payment-can-settle-and-protagonist-stays-home-but-brothers-split-business-accounts',
  emotionalArc: 'shared-routine-to-dual-pressure-to-recognition-of-bodily-duty-rule-to-networked-credit-choice-to-visible-business-separation-without-vindication',
  historicalLearningMechanism: 'verified-Pingyao-draft-bank-remittance-and-branch-verification-make-the-fictional-question-of-who-must-travel-place-causal',
  resolutionType: 'financial-network-completes-its-task-without-proving-private-choice-right-or-restoring-brotherly-trust',
  endingMechanism: 'receipt-enters-new-ledger-unused-silver-chest-is-locked-and-protagonist-returns-to-mothers-room-while-two-ledgers-remain-apart',
  memoryAnchorType: 'thin-draft-leaves-heavy-silver-stays-and-shared-ledger-space-opens-between-brothers',
  achievementType: 'reader-of-financial-infrastructure-as-human-presence-and-relationship-pressure',
  rewardSymbolism: 'moving-paper-still-silver-and-separated-ledgers-mark-value-mobility-with-private-cost',
  temporalPattern: 'single-late-Qing-day-from-due-payment-and-illness-to-draft-dispatch-and-account-separation',
  supportingStructure: 'older-brother-and-coowner-treats-personal-silver-escort-as-proof-of-shared-risk-then-separates-business-accounts-without-mentor-authority',
  centralMetaphor: 'credit-can-cross-distance-for-silver-but-cannot-cross-the-last-step-between-two-brothers-for-them',
  narrativeVoice: 'third-person-close-action-led-historical-fiction-with-verified-financial-world',
  storyRhythm: 'shared-shop-dual-deadline-silver-box-preparation-mother-cough-trust-reframe-draft-bank-counter-draft-dispatch-ledger-separation-return-inside',
);

bool pingyaoNarrativeDnaIsUniqueAgainstApproved() =>
    narrativeDnaIsUnique(
      pingyaoAncientCityCandidateNarrativeDna,
      approvedNarrativeDnaCatalog,
    );
