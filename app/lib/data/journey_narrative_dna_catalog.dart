import 'xian_city_wall_one_pass.dart';

class JourneyNarrativeDnaRecord {
  const JourneyNarrativeDnaRecord({
    required this.journeyId,
    required this.narrativeIdentity,
    required this.protagonistArchetype,
    required this.storyGoal,
    required this.conflictType,
    required this.climaxType,
    required this.resolutionType,
    required this.memoryAnchorType,
    required this.movementPattern,
    required this.temporalPattern,
    required this.supportingStructure,
    required this.endingMechanism,
    required this.centralMetaphor,
    required this.narrativeVoice,
    required this.storyRhythm,
  });

  final String journeyId;
  final String narrativeIdentity;
  final String protagonistArchetype;
  final String storyGoal;
  final String conflictType;
  final String climaxType;
  final String resolutionType;
  final String memoryAnchorType;
  final String movementPattern;
  final String temporalPattern;
  final String supportingStructure;
  final String endingMechanism;
  final String centralMetaphor;
  final String narrativeVoice;
  final String storyRhythm;

  List<String> get majorDimensions => <String>[
        protagonistArchetype,
        storyGoal,
        conflictType,
        climaxType,
        resolutionType,
        memoryAnchorType,
        movementPattern,
        temporalPattern,
        supportingStructure,
        endingMechanism,
        centralMetaphor,
        narrativeVoice,
        storyRhythm,
      ];
}

const approvedNarrativeDnaCatalog = <JourneyNarrativeDnaRecord>[
  JourneyNarrativeDnaRecord(
    journeyId: 'beijing-summer-palace',
    narrativeIdentity: 'lake-garden-causal-pilot',
    protagonistArchetype: 'place-bound-young-observer-with-relational-duty',
    storyGoal: 'resolve-a-summer-palace-specific-causal-situation',
    conflictType: 'relationship-and-place-causality',
    climaxType: 'consequence-through-local-choice',
    resolutionType: 'relationship-state-changes-inside-garden',
    memoryAnchorType: 'summer-palace-specific-causal-anchor',
    movementPattern: 'garden-and-lake-sequence',
    temporalPattern: 'pilot-specific-palace-time',
    supportingStructure: 'relationship-driven-support',
    endingMechanism: 'garden-specific-consequence',
    centralMetaphor: 'landscape-and-human-causality',
    narrativeVoice: 'third-person-causal',
    storyRhythm: 'scene-choice-consequence',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: 'beijing-forbidden-city',
    narrativeIdentity: 'maintenance-risk-and-palace-boundary',
    protagonistArchetype: 'young-palace-maintenance-worker',
    storyGoal: 'verify-and-handle-a-palace-maintenance-risk',
    conflictType: 'access-boundary-and-professional-responsibility',
    climaxType: 'permission-boundary-decision',
    resolutionType: 'professional-restraint-inside-palace-system',
    memoryAnchorType: 'uncrossed-threshold-object',
    movementPattern: 'palace-axis-and-controlled-space',
    temporalPattern: 'weather-window-before-closing',
    supportingStructure: 'work-team-and-institutional-rules',
    endingMechanism: 'boundary-remains-meaningful',
    centralMetaphor: 'access-does-not-equal-possession',
    narrativeVoice: 'third-person-professional',
    storyRhythm: 'warning-task-risk-decision',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: 'shanghai-bund',
    narrativeIdentity: 'family-trade-document-crosses-river-into-new-job',
    protagonistArchetype: 'young-fintech-worker-from-port-trade-family',
    storyGoal: 'cross-to-new-job-while-deciding-what-to-carry-forward',
    conflictType: 'old-document-vs-new-career-continuity',
    climaxType: 'river-crossing-recognition',
    resolutionType: 'carry-document-into-new-career',
    memoryAnchorType: 'old-bill-of-lading-carried-across-river',
    movementPattern: 'bund-walk-then-one-way-ferry-crossing',
    temporalPattern: 'single-evening-west-bank-to-east-bank',
    supportingStructure: 'mother-and-son-conversation',
    endingMechanism: 'arrival-on-opposite-bank-with-document',
    centralMetaphor: 'flows-change-tools-not-city-continuity',
    narrativeVoice: 'third-person-intergenerational',
    storyRhythm: 'meeting-walk-ferry-arrival',
  ),
  JourneyNarrativeDnaRecord(
    journeyId: xianCityWallJourneyId,
    narrativeIdentity: xianCityWallNarrativeDna.narrativeIdentity,
    protagonistArchetype: xianCityWallNarrativeDna.protagonistArchetype,
    storyGoal: xianCityWallNarrativeDna.storyGoal,
    conflictType: xianCityWallNarrativeDna.conflictType,
    climaxType: xianCityWallNarrativeDna.climaxType,
    resolutionType: xianCityWallNarrativeDna.resolutionType,
    memoryAnchorType: xianCityWallNarrativeDna.memoryAnchorType,
    movementPattern: xianCityWallNarrativeDna.movementPattern,
    temporalPattern: xianCityWallNarrativeDna.temporalPattern,
    supportingStructure: xianCityWallNarrativeDna.supportingStructure,
    endingMechanism: xianCityWallNarrativeDna.endingMechanism,
    centralMetaphor: xianCityWallNarrativeDna.centralMetaphor,
    narrativeVoice: 'third-person-local-runner',
    storyRhythm: 'lap-accumulation-finish-alert-continuation',
  ),
];

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
