import 'journey_narrative_dna_catalog.dart';

const hongheHaniRiceTerracesCandidateNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'honghe-hani-rice-terraces',
  narrativeIdentity:
      'elected-water-keeper-restores-agreed-wooden-water-share-and-loses-private-buffalo-labor',
  protagonistIdentity:
      'Luo-Qiu-fictional-contemporary-terrace-farmer-serving-first-round-as-community-water-keeper',
  protagonistAgeIdentity: 'fictional-adult-farmer',
  protagonistArchetype:
      'ordinary-farmer-learning-that-public-water-duty-can-impose-private-reciprocity-cost',
  openingSituation:
      'spring-irrigation-day-begins-with-first-public-ditch-round-and-private-buffalo-labor-arrangement',
  storyGoal:
      'restore-agreed-branch-water-shares-while-finishing-own-final-terrace-with-neighbors-buffalo',
  locationMechanism:
      'forest-fed-descending-shared-channels-and-negotiated-groove-widths-physically-distribute-water-among-terraces',
  movementPattern:
      'forest-flow-to-village-channel-to-divider-groove-recut-to-downstream-terrace-while-buffalo-departs',
  conflictType:
      'communal-water-allocation-duty-vs-private-reciprocal-labor-dependence-on-the-favored-neighbor',
  choiceType:
      'restore-agreed-groove-width-immediately-instead-of-delaying-until-private-buffalo-help-is-finished',
  climaxType:
      'recut-divider-seats-into-water-and-branch-flows-rebalance-as-neighbor-lifts-buffalo-rope',
  consequenceType:
      'downstream-water-share-returns-while-protagonists-own-final-terrace-remains-unploughed-that-day',
  emotionalArc:
      'routine-duty-confidence-to-recognition-of-private-leverage-to-hesitation-to-public-action-to-unreconciled-private-cost',
  historicalLearningMechanism:
      'verified-wood-carved-water-allocation-community-water-keeper-role-and-forest-village-terrace-hydrology-make-the-fictional-private-conflict-place-causal',
  resolutionType:
      'communal-allocation-is-restored-without-erasing-the-friendship-cost-or-rewarding-the-protagonist',
  endingMechanism:
      'protagonist-works-her-own-unploughed-bund-by-foot-while-two-restored-channel-flows-continue-and-she-does-not-look-back',
  memoryAnchorType:
      'recut-hardwood-divider-separates-two-streams-as-buffalo-bell-turns-away',
  achievementType: 'reader-of-living-water-governance-as-private-human-pressure',
  rewardSymbolism:
      'two-different-water-sounds-and-absent-buffalo-mark-restored-public-share-with-private-cost',
  temporalPattern: 'single-contemporary-spring-irrigation-day-from-morning-ditch-round-to-dusk',
  supportingStructure:
      'longtime-neighbor-and-labor-exchange-partner-asks-for-temporary-private-water-advantage-then-withdraws-promised-buffalo-without-mentor-authority',
  centralMetaphor:
      'a-shared-flow-can-be-set-back-to-its-agreed-width-without-making-private-relationships-even-again',
  narrativeVoice: 'third-person-close-action-led-contemporary-cultural-fiction',
  storyRhythm:
      'spring-round-private-help-plan-widened-groove-admission-private-leverage-hesitation-recut-divider-flow-return-buffalo-departure-own-field-work',
);

bool hongheNarrativeDnaIsUniqueAgainstApproved() =>
    narrativeDnaIsUnique(
      hongheHaniRiceTerracesCandidateNarrativeDna,
      approvedNarrativeDnaCatalog,
    );