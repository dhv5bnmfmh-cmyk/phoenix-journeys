import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
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

Map<String, Object?> _annotationJson(
  String chinese,
  ReadingAnnotation annotation,
) => {
  'chinese': chinese,
  'pinyin': annotation.pinyin,
  'vietnamese': annotation.vietnamese,
  'english': annotation.english,
};

Map<String, Object?> _wordJson(WordEntry entry) => {
  'word': entry.word,
  'pinyin': entry.pinyin,
  'partOfSpeech': entry.partOfSpeech,
  'simpleChinese': entry.simpleChinese,
  'vietnamese': entry.translation,
  'english': entry.englishDefinition,
  'examples': entry.examples
      .map(
        (example) => {
          'chinese': example.chinese,
          'pinyin': example.pinyin,
          'vietnamese': example.vietnamese,
          'english': example.english,
        },
      )
      .toList(growable: false),
};

Map<String, Object?> _discoveryJson(
  String journeyId,
  int level,
  int index,
  DiscoveryEntry entry,
) => {
  'id': '$journeyId:discovery:lv$level:$index',
  'text': entry.text,
  'pinyin': entry.pinyin,
  'simpleChinese': entry.simpleChinese,
  'vietnamese': entry.vietnamese,
  'english': entry.english,
};

void main() {
  test('exports all active Lv1-Lv10 content for fresh Agent and Founder review', () {
    const agent = PhoenixLanguageLevelAgent();
    final approvedIds = approvedNarrativeDnaCatalog
        .map((entry) => entry.journeyId)
        .toSet();
    expect(allJourneyExperiences, hasLength(36));
    expect(approvedIds, hasLength(14));

    var exportedLevelCount = 0;
    final journeys = <Map<String, Object?>>[];
    for (final journey in allJourneyExperiences) {
      final levels = <String, Object?>{};
      for (var level = 1; level <= 10; level++) {
        final active = resolveAdaptiveJourneyLevel(
          journey,
          profile: agent.profileForPhoenixLevel(level),
        );
        expect(
          active.storyAnnotations,
          hasLength(active.storyParagraphs.length),
          reason: '${journey.id} Lv$level Story translation alignment',
        );
        levels['$level'] = {
          'story': active.storyParagraphs,
          'storyAnnotations': [
            for (var index = 0; index < active.storyParagraphs.length; index++)
              _annotationJson(
                active.storyParagraphs[index],
                active.storyAnnotations[index],
              ),
          ],
          'vocabulary': active.words.map(_wordJson).toList(growable: false),
          'discovery': [
            for (var index = 0; index < active.discoveries.length; index++)
              _discoveryJson(
                journey.id,
                level,
                index,
                active.discoveries[index],
              ),
          ],
          'wonderQuestion': active.wonderQuestion,
          'expressQuestion': active.expressQuestion,
        };
        exportedLevelCount += 1;
      }
      expect(levels, hasLength(10), reason: '${journey.id} must export Lv1-Lv10');
      journeys.add({
        'journeyId': journey.id,
        'storyTitle': journey.storyTitle,
        'city': journey.city,
        'place': journey.place,
        'approvedGold': approvedIds.contains(journey.id),
        'goldCandidate': journey.id == 'pingyao-ancient-city',
        'specialJourney': specialAdaptiveJourneyIds.contains(journey.id),
        'levels': levels,
      });
    }
    expect(exportedLevelCount, 360);

    final payload = {
      'journeyCount': journeys.length,
      'phoenixLevelsPerJourney': 10,
      'journeyLevelSurfaces': exportedLevelCount,
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
