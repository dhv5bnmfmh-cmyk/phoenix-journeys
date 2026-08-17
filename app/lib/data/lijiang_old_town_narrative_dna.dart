import 'journey_narrative_dna_catalog.dart';

const lijiangOldTownCandidateNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'lijiang-old-town',
  narrativeIdentity:
      'jointly-owned-tea-is-destroyed-to-open-canal-bridge-for-emergency-water',
  protagonistIdentity:
      'He-Qing-fictional-late-Qing-small-trader-sharing-tea-and-debt-with-older-sister',
  protagonistAgeIdentity: 'fictional-adult-younger-brother-and-adult-older-sister',
  protagonistArchetype:
      'small-trader-learning-that-shared-responsibility-is-not-the-same-as-unilateral-control',
  openingSituation:
      'Sifang-market-has-dispersed-before-a-single-next-morning-sale-needed-to-pay-shared-debt',
  storyGoal:
      'preserve-jointly-owned-tea-for-the-next-morning-buyer-and-clear-shared-debt',
  locationMechanism:
      'verified-Lijiang-canal-bridge-timber-lane-and-caravan-market-configuration-makes-cargo-an-emergency-obstruction',
  movementPattern:
      'loaded-mule-blocks-bridge-rope-is-cut-tea-falls-buckets-cross-wet-tea-returns-by-shared-pole',
  conflictType:
      'joint-livelihood-asset-vs-immediate-emergency-access-with-conflicting-owner-authority',
  choiceType:
      'cut-lashings-without-sisters-consent-and-accept-damage-to-both-owners-capital',
  climaxType:
      'last-rope-parts-tea-drops-and-first-usable-strip-of-bridge-opens',
  consequenceType:
      'bucket-relay-crosses-bridge-fire-is-contained-in-fiction-while-sale-is-lost-and-debt-remains',
  emotionalArc:
      'prove-I-can-decide-to-hesitation-over-shared-ownership-to-costly-action-to-jointly-borne-loss',
  historicalLearningMechanism:
      'verified-water-used-for-fire-prevention-and-daily-life-combines-with-bridges-timber-buildings-and-Tea-Horse-commerce-to-make-the-fictional-private-choice-place-causal',
  resolutionType:
      'shared-consequence-replaces-the-argument-over-who-gets-to-decide-without-verbal-reconciliation',
  endingMechanism:
      'older-sister-shoulders-the-other-end-of-the-pole-and-shifts-the-wet-tea-weight-between-them',
  memoryAnchorType:
      'lashings-snap-tea-rolls-into-water-bridge-opens-and-first-bucket-crosses',
  achievementType: 'reader-of-place-infrastructure-as-human-choice-pressure',
  rewardSymbolism:
      'wet-tea-and-shared-carrying-weight-mark-irreversible-cost-and-joint-responsibility',
  temporalPattern:
      'late-Qing-evening-after-market-close-through-dawn-before-an-uncertain-buyer',
  supportingStructure:
      'older-sister-opposes-unilateral-loss-then-joins-bucket-relay-and-shares-cleanup-without-mentor-authority',
  centralMetaphor:
      'when-the-bridge-must-open-the-weight-of-a-shared-life-does-not-disappear-it-moves-between-people',
  narrativeVoice: 'third-person-close-action-led-historical-fiction',
  storyRhythm:
      'market-close-shared-debt-fire-blocked-bridge-owner-conflict-knife-hesitation-rope-cut-bucket-flow-wet-tea-shared-pole',
);

bool lijiangNarrativeDnaIsUniqueAgainstApproved() =>
    narrativeDnaIsUnique(
      lijiangOldTownCandidateNarrativeDna,
      approvedNarrativeDnaCatalog,
    );
