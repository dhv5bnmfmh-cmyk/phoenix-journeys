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
      'cross-role-peer-perspective-exchange-between-Shen-Yan-and-fictional-young-attendant-A-Ning-with-mentor-nondeci­sive',
  centralMetaphor:
      'one-architectural-frame-can-hold-multiple-valid-movement-logics-at-once',
  narrativeVoice: 'third-person-apprentice-spatial-comparison',
  storyRhythm:
      'route-assertion-peer-contradiction-comparison-alignment-overlay-shared-node-divergence',
);

final approvedNarrativeDnaCatalog =
    List<JourneyNarrativeDnaRecord>.unmodifiable(<JourneyNarrativeDnaRecord>[
  for (final record in baseline.approvedNarrativeDnaCatalog)
    if (record.journeyId == 'beijing-forbidden-city')
      forbiddenCityRemediatedNarrativeDna
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
