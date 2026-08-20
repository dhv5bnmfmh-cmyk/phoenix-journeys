import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';

Map<String, Object?> _dnaJson(JourneyNarrativeDnaRecord dna) => {
  'journeyId': dna.journeyId,
  'narrativeIdentity': dna.narrativeIdentity,
  'protagonistIdentity': dna.protagonistIdentity,
  'protagonistAgeIdentity': dna.protagonistAgeIdentity,
  'protagonistArchetype': dna.protagonistArchetype,
  'openingSituation': dna.openingSituation,
  'storyGoal': dna.storyGoal,
  'locationMechanism': dna.locationMechanism,
  'movementPattern': dna.movementPattern,
  'conflictType': dna.conflictType,
  'choiceType': dna.choiceType,
  'climaxType': dna.climaxType,
  'consequenceType': dna.consequenceType,
  'emotionalArc': dna.emotionalArc,
  'historicalLearningMechanism': dna.historicalLearningMechanism,
  'resolutionType': dna.resolutionType,
  'endingMechanism': dna.endingMechanism,
  'memoryAnchorType': dna.memoryAnchorType,
  'supportingStructure': dna.supportingStructure,
  'centralMetaphor': dna.centralMetaphor,
  'storyRhythm': dna.storyRhythm,
};

void main() {
  test('exports active content for fresh Agent and Founder review', () {
    const agent = PhoenixLanguageLevelAgent();
    final approvedIds = approvedNarrativeDnaCatalog
        .map((entry) => entry.journeyId)
        .toSet();
    expect(allJourneyExperiences, hasLength(36));
    expect(approvedIds, hasLength(14));

    final journeys = <Map<String, Object?>>[];
    for (final journey in allJourneyExperiences) {
      final levels = <String, Object?>{};
      for (final level in [1, 5, 10]) {
        final active = resolveAdaptiveJourneyLevel(
          journey,
          profile: agent.profileForPhoenixLevel(level),
        );
        levels['$level'] = {
          'story': active.storyParagraphs,
          'discovery': active.discoveries
              .map((entry) => {
                  'id': '${journey.id}:discovery:lv$level',
                  'text': entry.text,
                  })
              .toList(growable: false),
          'words': active.words.map((entry) => entry.word).toList(growable: false),
          'wonderQuestion': active.wonderQuestion,
          'expressQuestion': active.expressQuestion,
        };
      }
      journeys.add({
        'journeyId': journey.id,
        'storyTitle': journey.storyTitle,
        'city': journey.city,
        'place': journey.place,
        'approvedGold': approvedIds.contains(journey.id),
        'goldCandidate': journey.id == 'pingyao-ancient-city',
        'levels': levels,
      });
    }

    final payload = {
      'journeys': journeys,
      'approvedGoldNarrativeDna': approvedNarrativeDnaCatalog
          .map(_dnaJson)
          .toList(growable: false),
    };
    final output = Platform.environment['PHOENIX_GLOBAL_AGENT_REVIEW_JSON'];
    if (output != null && output.isNotEmpty) {
      File(output)
        ..createSync(recursive: true)
        ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(payload));
    }
  });
}
