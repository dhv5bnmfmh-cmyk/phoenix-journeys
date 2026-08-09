import 'journey_narrative_dna_baseline_snapshot.dart' as baseline;
import 'journey_narrative_dna_baseline_snapshot.dart' show JourneyNarrativeDnaRecord;

export 'journey_narrative_dna_baseline_snapshot.dart' show JourneyNarrativeDnaRecord;

const forbiddenCityRemediatedNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'beijing-forbidden-city',
  narrativeIdentity:
      'dual-valid-route-overlay-reveals-role-dependent-palace-space',
  protagonistIdentity:
      'Shen-Yan-seventeen-year-old-palace-construction-apprentice',
  protagonistAgeIdentity: 'seventeen-year-old-apprentice',
  protagonistArchetype:
      'young-construction-apprentice-building-readable-spatial-representation',
  openingSituation:
      'two-different-route-drawings-to-the-same-palace-node-appear-to-contradict',
  storyGoal:
      'represent-how-palace-spaces-connect-without-treating-one-persons-route-as-the-only-valid-path',
  locationMechanism:
      'Meridian-Gate-central-axis-Outer-Court-Inner-Court-and-Gate-of-Heavenly-Purity-as-shared-spatial-framework',
  movementPattern:
      'two-role-dependent-approaches-align-at-a-shared-node-briefly-overlap-then-diverge',
  conflictType:
      'single-authoritative-route-model-vs-coexisting-role-and-purpose-dependent-routes',
  choiceType:
      'preserve-both-valid-routes-by-overlaying-distinguishable-lines-on-one-sheet',
  climaxType:
      'aligned-routes-reveal-a-shared-junction-overlap-and-purpose-driven-divergence',
  consequenceType:
      'composite-map-adds-relational-information-without-erasing-either-route',
  emotionalArc:
      'single-line-certainty-to-apparent-contradiction-to-comparative-curiosity-to-plural-spatial-understanding',
  historicalLearningMechanism:
      'verified-axis-gate-and-Outer-Inner-Court-relations-become-the-common-spatial-scaffold-for-fictional-route-comparison',
  resolutionType:
      'two-partial-valid-perspectives-combine-into-one-readable-relational-representation',
  endingMechanism:
      'Shen-Yan-and-A-Ning-leave-the-shared-node-in-different-directions-while-both-lines-remain-legible',
  memoryAnchorType: 'one-sheet-with-two-overlaid-routes-and-a-shared-junction',
  achievementType: 'multi-perspective-palace-space-reader',
  rewardSymbolism:
      'shared-junction-mark-represents-relational-information-not-mentor-approval',
  temporalPattern: 'single-study-day-with-comparison-at-a-shared-palace-node',
  supportingStructure:
      'cross-role-peer-perspective-exchange-between-Shen-Yan-and-fictional-young-attendant-A-Ning-with-mentor-nondecisive',
  centralMetaphor:
      'one-architectural-frame-can-hold-multiple-valid-movement-logics-at-once',
  narrativeVoice: 'third-person-apprentice-spatial-comparison',
  storyRhythm:
      'route-assertion-peer-contradiction-comparison-alignment-overlay-shared-node-divergence',
);

const chengduRemediatedNarrativeDna = JourneyNarrativeDnaRecord(
  journeyId: 'chengdu-kuanzhai-alley',
  narrativeIdentity: 'courtyard-chair-handoffs-create-shared-use-rhythm',
  protagonistIdentity:
      'Lin-Xia-twenty-four-year-old-fictional-teahouse-courtyard-host',
  protagonistAgeIdentity: 'twenty-four-year-old-young-service-worker',
  protagonistArchetype:
      'young-courtyard-host-facilitating-changing-shared-use',
  openingSituation:
      'one-bamboo-chair-immediately-contested-by-legitimate-tea-seating-and-courtyard-passage',
  storyGoal:
      'keep-courtyard-usable-for-tea-staying-service-and-passage-without-permanent-exclusion',
  locationMechanism:
      'Kuanzhai-street-lane-courtyard-threshold-compresses-stopping-and-circulation-into-one-shared-entry-zone',
  movementPattern:
      'bamboo-chair-repeatedly-yields-from-threshold-to-wall-and-returns-to-tea-table',
  conflictType: 'fixed-space-assignment-vs-time-dependent-shared-use',
  choiceType:
      'facilitate-temporary-handoff-instead-of-permanent-seat-allocation',
  climaxType:
      'older-regular-independently-clears-passage-and-restores-tea-seat-without-host-instruction',
  consequenceType:
      'courtyard-remains-usable-through-repeated-sequential-handoffs-among-participants',
  emotionalArc:
      'arranging-confidence-to-irritation-to-negotiation-to-hesitation-to-relief-and-trust',
  historicalLearningMechanism:
      'verified-street-lane-courtyard-morphology-and-current-tea-use-create-the-spatial-constraint-while-factual-conservation-learning-stays-in-Discovery',
  resolutionType: 'repeated-spatial-handoffs-create-a-shared-use-protocol',
  endingMechanism:
      'another-user-moves-the-same-chair-for-passage-while-Lin-Xia-does-not-intervene',
  memoryAnchorType: 'one-bamboo-chair-without-a-fixed-position',
  achievementType: 'shared-courtyard-rhythm-facilitator',
  rewardSymbolism:
      'yield-and-return-motion-symbolizes-temporary-use-handoff-not-ownership-or-mentor-reward',
  temporalPattern: 'single-afternoon-use-cycle-without-external-countdown',
  supportingStructure:
      'practical-courtyard-host-and-older-regular-negotiate-and-reproduce-handoffs-without-mentor-authority',
  centralMetaphor:
      'shared-space-stays-usable-by-being-handed-on-rather-than-permanently-owned',
  narrativeVoice: 'third-person-action-led-courtyard-coordination',
  storyRhythm:
      'place-chair-first-handoff-fixed-layout-fails-again-negotiate-repeat-independent-reproduction-release-control',
);

final approvedNarrativeDnaCatalog =
    List<JourneyNarrativeDnaRecord>.unmodifiable(<JourneyNarrativeDnaRecord>[
  for (final record in baseline.approvedNarrativeDnaCatalog)
    if (record.journeyId == 'beijing-forbidden-city')
      forbiddenCityRemediatedNarrativeDna
    else if (record.journeyId == 'chengdu-kuanzhai-alley')
      chengduRemediatedNarrativeDna
    else
      record,
]);

int duplicatedMajorDimensions(
  JourneyNarrativeDnaRecord left,
  JourneyNarrativeDnaRecord right,
) {
  var duplicates = 0;
  final a = left.majorDimensions;
  final b = right.majorDimensions;
  for (var i = 0; i < a.length; i++) {
    if (a[i] == b[i]) duplicates++;
  }
  return duplicates;
}

bool narrativeDnaIsUnique(
  JourneyNarrativeDnaRecord candidate,
  Iterable<JourneyNarrativeDnaRecord> references,
) =>
    references
        .where((record) => record.journeyId != candidate.journeyId)
        .every((record) => duplicatedMajorDimensions(candidate, record) < 3);
