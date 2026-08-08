import 'chengdu_kuanzhai_one_pass.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'xian_city_wall_one_pass.dart';

class JourneyNarrativeDnaRecord {
  const JourneyNarrativeDnaRecord({
    required this.journeyId,
    required this.narrativeIdentity,
    required this.protagonistIdentity,
    required this.protagonistAgeIdentity,
    required this.protagonistArchetype,
    required this.openingSituation,
    required this.storyGoal,
    required this.locationMechanism,
    required this.movementPattern,
    required this.conflictType,
    required this.choiceType,
    required this.climaxType,
    required this.consequenceType,
    required this.emotionalArc,
    required this.historicalLearningMechanism,
    required this.resolutionType,
    required this.endingMechanism,
    required this.memoryAnchorType,
    required this.achievementType,
    required this.rewardSymbolism,
    required this.temporalPattern,
    required this.supportingStructure,
    required this.centralMetaphor,
    required this.narrativeVoice,
    required this.storyRhythm,
  });

  final String journeyId;
  final String narrativeIdentity;
  final String protagonistIdentity;
  final String protagonistAgeIdentity;
  final String protagonistArchetype;
  final String openingSituation;
  final String storyGoal;
  final String locationMechanism;
  final String movementPattern;
  final String conflictType;
  final String choiceType;
  final String climaxType;
  final String consequenceType;
  final String emotionalArc;
  final String historicalLearningMechanism;
  final String resolutionType;
  final String endingMechanism;
  final String memoryAnchorType;
  final String achievementType;
  final String rewardSymbolism;
  final String temporalPattern;
  final String supportingStructure;
  final String centralMetaphor;
  final String narrativeVoice;
  final String storyRhythm;

  List<String> get majorDimensions => <String>[
        protagonistIdentity,
        protagonistAgeIdentity,
        protagonistArchetype,
        openingSituation,
        storyGoal,
        locationMechanism,
        movementPattern,
        conflictType,
        choiceType,
        climaxType,
        consequenceType,
        emotionalArc,
        historicalLearningMechanism,
        resolutionType,
        endingMechanism,
        memoryAnchorType,
        achievementType,
        rewardSymbolism,
        temporalPattern,
        supportingStructure,
        centralMetaphor,
        narrativeVoice,
        storyRhythm,
      ];
}

final approvedNarrativeDnaCatalog =
    List<JourneyNarrativeDnaRecord>.unmodifiable(<JourneyNarrativeDnaRecord>[
  const JourneyNarrativeDnaRecord(
    journeyId: 'beijing-summer-palace',
    narrativeIdentity: 'photograph-recovery-reframes-restoration-and-relationship',
    protagonistIdentity: 'Xu-Cheng-student-photographer-with-grandmother-Zhou-Lan',
    protagonistAgeIdentity: 'seventeen-year-old-student',
    protagonistArchetype: 'young-photographer-proving-independent-judgment',
    openingSituation: 'school-exhibition-deadline-and-perfect-image-intention',
    storyGoal: 'make-a-Summer-Palace-photograph-without-grandmother-guidance',
    locationMechanism: 'garden-composition-and-Seventeen-Arch-Bridge-light',
    movementPattern: 'garden-route-toward-bridge-and-photographic-vantage',
    conflictType: 'perfect-image-vs-recovering-a-family-photograph',
    choiceType: 'abandon-best-light-to-retrieve-windblown-old-photo',
    climaxType: 'retrieval-causes-loss-of-ideal-light-and-new-composition',
    consequenceType: 'missed-light-produces-a-different-relational-photograph',
    emotionalArc: 'self-proof-to-attention-to-traces-and-relationship',
    historicalLearningMechanism: 'restoration-traces-enter-through-grandmother-work-and-camera-framing',
    resolutionType: 'new-photograph-and-changed-grandmother-granddaughter-working-relation',
    endingMechanism: 'old-photo-is-entrusted-after-grandmother-stops-adjusting-composition',
    memoryAnchorType: 'recovered-worn-photograph-inside-new-composition',
    achievementType: 'photographic-attention-to-preserved-traces',
    rewardSymbolism: 'image-and-restoration-trace-specific-reward',
    temporalPattern: 'single-deadline-day-with-shifting-best-light',
    supportingStructure: 'grandmother-granddaughter-relationship',
    centralMetaphor: 'restoration-keeps-visible-traces-rather-than-erasing-time',
    narrativeVoice: 'third-person-photographic-causal',
    storyRhythm: 'deadline-observation-loss-choice-recomposition',
  ),
  const JourneyNarrativeDnaRecord(
    journeyId: 'beijing-forbidden-city',
    narrativeIdentity: 'maintenance-risk-and-palace-boundary',
    protagonistIdentity: 'Shen-Yan-young-palace-maintenance-worker',
    protagonistAgeIdentity: 'young-working-adult',
    protagonistArchetype: 'young-palace-maintenance-worker',
    openingSituation: 'professional-maintenance-duty-inside-controlled-palace-space',
    storyGoal: 'verify-and-handle-a-palace-maintenance-risk',
    locationMechanism: 'controlled-palace-axis-rooms-and-access-rules',
    movementPattern: 'palace-axis-and-controlled-space',
    conflictType: 'access-boundary-and-professional-responsibility',
    choiceType: 'decline-to-treat-available-access-as-permission-to-possess',
    climaxType: 'permission-boundary-decision',
    consequenceType: 'unentered-space-and-uncompleted-map-retain-meaning',
    emotionalArc: 'task-completion-drive-to-professional-restraint',
    historicalLearningMechanism: 'institutional-space-and-maintenance-duty-reveal-palace-order',
    resolutionType: 'professional-restraint-inside-palace-system',
    endingMechanism: 'boundary-remains-meaningful',
    memoryAnchorType: 'uncrossed-threshold-object',
    achievementType: 'restraint-and-historical-responsibility',
    rewardSymbolism: 'old-wooden-ruler-linked-to-measured-restraint',
    temporalPattern: 'weather-window-before-closing',
    supportingStructure: 'work-team-and-institutional-rules',
    centralMetaphor: 'access-does-not-equal-possession',
    narrativeVoice: 'third-person-professional',
    storyRhythm: 'warning-task-risk-decision',
  ),
  const JourneyNarrativeDnaRecord(
    journeyId: 'shanghai-bund',
    narrativeIdentity: 'family-trade-document-crosses-river-into-new-job',
    protagonistIdentity: 'Lin-An-fintech-worker-from-port-trade-family',
    protagonistAgeIdentity: 'twenty-four-year-old-young-professional',
    protagonistArchetype: 'young-fintech-worker-from-port-trade-family',
    openingSituation: 'eve-of-new-Lujiazui-job-meeting-mother-at-Bund-Customs-House',
    storyGoal: 'cross-to-new-job-while-deciding-what-to-carry-forward',
    locationMechanism: 'Bund-waterfront-facing-Pudong-and-ferry-connection',
    movementPattern: 'bund-walk-then-one-way-ferry-crossing',
    conflictType: 'old-document-vs-new-career-continuity',
    choiceType: 'carry-old-bill-of-lading-onto-ferry-instead-of-returning-it',
    climaxType: 'river-crossing-recognition',
    consequenceType: 'family-trade-document-arrives-with-him-in-new-work-district',
    emotionalArc: 'clean-break-assumption-to-recognition-of-changing-flow-systems',
    historicalLearningMechanism: 'family-trade-document-connects-port-commerce-to-modern-settlement',
    resolutionType: 'carry-document-into-new-career',
    endingMechanism: 'arrival-on-opposite-bank-with-document',
    memoryAnchorType: 'old-bill-of-lading-carried-across-river',
    achievementType: 'flow-reader-across-commercial-eras',
    rewardSymbolism: 'trade-flow-document-continuity',
    temporalPattern: 'single-evening-west-bank-to-east-bank',
    supportingStructure: 'mother-and-son-conversation',
    centralMetaphor: 'flows-change-tools-not-city-continuity',
    narrativeVoice: 'third-person-intergenerational',
    storyRhythm: 'meeting-walk-ferry-arrival',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: xianCityWallJourneyId,
    narrativeIdentity: xianCityWallNarrativeDna.narrativeIdentity,
    protagonistIdentity: 'Zhou-Yao-Xian-local-runner-moving-with-family',
    protagonistAgeIdentity: 'twenty-two-year-old-local',
    protagonistArchetype: xianCityWallNarrativeDna.protagonistArchetype,
    openingSituation: 'family-move-weekend-and-self-declared-final-wall-circuit',
    storyGoal: xianCityWallNarrativeDna.storyGoal,
    locationMechanism: 'closed-city-wall-circuit-visible-against-lived-routes-inside-and-outside',
    movementPattern: xianCityWallNarrativeDna.movementPattern,
    conflictType: xianCityWallNarrativeDna.conflictType,
    choiceType: 'leave-running-watch-active-after-lap-completion-and-descend-toward-new-home',
    climaxType: xianCityWallNarrativeDna.climaxType,
    consequenceType: 'saved-run-route-extends-beyond-wall-to-new-address',
    emotionalArc: 'farewell-by-closure-to-belonging-through-continuation',
    historicalLearningMechanism: 'wall-circuit-running-places-Ming-defence-conservation-and-modern-use-inside-one-lived-route',
    resolutionType: xianCityWallNarrativeDna.resolutionType,
    endingMechanism: xianCityWallNarrativeDna.endingMechanism,
    memoryAnchorType: xianCityWallNarrativeDna.memoryAnchorType,
    achievementType: 'continuation-runner-Xucheng-Paozhe',
    rewardSymbolism: 'Changan-continuation-route-badge-not-permission-token',
    temporalPattern: xianCityWallNarrativeDna.temporalPattern,
    supportingStructure: xianCityWallNarrativeDna.supportingStructure,
    centralMetaphor: xianCityWallNarrativeDna.centralMetaphor,
    narrativeVoice: 'third-person-local-runner',
    storyRhythm: 'lap-accumulation-finish-alert-continuation',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: hangzhouWestLakeJourneyId,
    narrativeIdentity: hangzhouWestLakeNarrativeDna.narrativeIdentity,
    protagonistIdentity: 'Xu-Cheng-Hangzhou-local-university-urban-sound-archivist',
    protagonistAgeIdentity: 'twenty-one-year-old-local-university-student',
    protagonistArchetype: hangzhouWestLakeNarrativeDna.protagonistArchetype,
    openingSituation: 'summer-rain-forecast-and-continuous-West-Lake-field-recording-assignment',
    storyGoal: hangzhouWestLakeNarrativeDna.storyGoal,
    locationMechanism: 'Su-Causeway-bridges-water-surface-and-living-cultural-landscape-acoustics',
    movementPattern: hangzhouWestLakeNarrativeDna.movementPattern,
    conflictType: hangzhouWestLakeNarrativeDna.conflictType,
    choiceType: 'reclassify-human-sound-as-evidence-and-reorient-microphone-into-rain-changed-public-space',
    climaxType: hangzhouWestLakeNarrativeDna.climaxType,
    consequenceType: 'archive-preserves-weather-human-movement-and-lake-as-one-layered-field-recording',
    emotionalArc: 'curatorial-control-to-listening-attention-to-layered-presence',
    historicalLearningMechanism: 'causeway-dredging-bridges-and-lived-use-are-heard-as-structural-parts-of-a-cultural-landscape',
    resolutionType: hangzhouWestLakeNarrativeDna.resolutionType,
    endingMechanism: hangzhouWestLakeNarrativeDna.endingMechanism,
    memoryAnchorType: hangzhouWestLakeNarrativeDna.memoryAnchorType,
    achievementType: 'West-Lake-rain-soundscape-listener',
    rewardSymbolism: 'lake-rain-soundwave-mark-representing-layered-presence',
    temporalPattern: hangzhouWestLakeNarrativeDna.temporalPattern,
    supportingStructure: hangzhouWestLakeNarrativeDna.supportingStructure,
    centralMetaphor: hangzhouWestLakeNarrativeDna.centralMetaphor,
    narrativeVoice: 'third-person-auditory-close-observation',
    storyRhythm: 'clean-take-deletion-bridge-listening-cloud-pressure-rain-recomposition-archive',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: chengduKuanzhaiJourneyId,
    narrativeIdentity: chengduKuanzhaiNarrativeDna.narrativeIdentity,
    protagonistIdentity: 'Lin-Xia-Chengdu-local-architecture-graduate-researcher',
    protagonistAgeIdentity: 'twenty-four-year-old-local-graduate-student',
    protagonistArchetype: chengduKuanzhaiNarrativeDna.protagonistArchetype,
    openingSituation: 'use-trace-field-survey-with-commerce-preclassified-as-authenticity-interference',
    storyGoal: chengduKuanzhaiNarrativeDna.storyGoal,
    locationMechanism: 'three-alley-courtyard-system-read-through-doors-thresholds-tea-tables-and-use-traces',
    movementPattern: chengduKuanzhaiNarrativeDna.movementPattern,
    conflictType: chengduKuanzhaiNarrativeDna.conflictType,
    choiceType: 'cross-out-commerce-as-automatic-negative-category-and-write-still-in-use',
    climaxType: chengduKuanzhaiNarrativeDna.climaxType,
    consequenceType: 'marked-survey-page-preserves-original-judgment-and-evidence-driven-reclassification',
    emotionalArc: 'rigid-analytic-framework-to-more-precise-evidence-based-preservation-judgment',
    historicalLearningMechanism: 'lane-courtyard-fabric-and-renewal-are-understood-through-observed-use-rather-than-lecture',
    resolutionType: chengduKuanzhaiNarrativeDna.resolutionType,
    endingMechanism: chengduKuanzhaiNarrativeDna.endingMechanism,
    memoryAnchorType: chengduKuanzhaiNarrativeDna.memoryAnchorType,
    achievementType: 'courtyard-use-trace-observer',
    rewardSymbolism: 'survey-mark-and-courtyard-use-trace-imprint',
    temporalPattern: chengduKuanzhaiNarrativeDna.temporalPattern,
    supportingStructure: chengduKuanzhaiNarrativeDna.supportingStructure,
    centralMetaphor: chengduKuanzhaiNarrativeDna.centralMetaphor,
    narrativeVoice: 'third-person-architectural-field-observation',
    storyRhythm: 'preclassification-measurement-comparison-tea-table-reclassification-submission',
  ),
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
) => references
    .where((record) => record.journeyId != candidate.journeyId)
    .every((record) => duplicatedMajorDimensions(candidate, record) < 3);
