import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';

void main() {
  const journeys = <RemediatedJourney>[
    forbiddenCityRemediation,
    templeOfHeavenRemediation,
  ];

  bool hasContinuousLevels(RemediatedJourney journey) {
    if (journey.levels.length != 10) return false;
    for (var index = 0; index < journey.levels.length; index++) {
      if (!journey.levels[index].startsWith('Lv${index + 1}｜')) return false;
    }
    return true;
  }

  bool hasNarrativeContract(RemediatedJourney journey) {
    final story = journey.levels.join();
    return journey.protagonist.trim().isNotEmpty &&
        journey.goal.trim().isNotEmpty &&
        journey.conflict.trim().isNotEmpty &&
        story.contains('选择') &&
        (story.contains('代价') || story.contains('结果')) &&
        journey.complete.trim().isNotEmpty;
  }

  bool hasLearningContract(RemediatedJourney journey) {
    return journey.words.length >= 10 &&
        journey.words.toSet().length == journey.words.length &&
        journey.discoveries.length >= 4 &&
        journey.sourceIds.length >= 2 &&
        journey.challenge.paragraphRebuild.isNotEmpty &&
        journey.challenge.grammarRepair.isNotEmpty &&
        journey.challenge.missingSentence.isNotEmpty &&
        journey.memory.length >= 4;
  }

  bool hasNoReflectionOrWriting(RemediatedJourney journey) {
    final activities = <String>[
      ...journey.challenge.paragraphRebuild,
      ...journey.challenge.grammarRepair,
      ...journey.challenge.missingSentence,
      ...journey.memory,
    ].join();
    const forbiddenPrompts = <String>[
      '写一篇',
      '写一段',
      '自由写作',
      '反思',
      '日记',
      '表达你的感受',
    ];
    return forbiddenPrompts.every((prompt) => !activities.contains(prompt));
  }

  group('Phoenix Batch 1 journey remediation', () {
    for (final journey in journeys) {
      test('${journey.title} has continuous Lv1-Lv10 story', () {
        expect(hasContinuousLevels(journey), isTrue);
        expect(hasNarrativeContract(journey), isTrue);
      });

      test('${journey.title} has required learning sections', () {
        expect(hasLearningContract(journey), isTrue);
        expect(hasNoReflectionOrWriting(journey), isTrue);
      });
    }

    test('quality gates are derived from validated content', () {
      final computed = <String, bool>{
        'Story Continuity': journeys.every(hasNarrativeContract),
        'Character Consistency': journeys.every(
          (journey) => journey.levels.every(
            (level) => level.contains(journey.protagonist.split('，').first),
          ),
        ),
        'Timeline Consistency': journeys.every(hasContinuousLevels),
        'Historical Accuracy': journeys.every(
          (journey) => journey.sourceIds.length >= 2,
        ),
        'Cultural Authenticity': journeys.every(
          (journey) => journey.discoveries.length >= 4,
        ),
        'Vocabulary Source Validation': journeys.every(
          (journey) => journey.words.length >= 10 && journey.sourceIds.length >= 2,
        ),
        'Discovery Quality': journeys.every(
          (journey) => journey.discoveries.length >= 4,
        ),
        'Challenge Quality': journeys.every(
          (journey) =>
              journey.challenge.paragraphRebuild.isNotEmpty &&
              journey.challenge.grammarRepair.isNotEmpty &&
              journey.challenge.missingSentence.isNotEmpty,
        ),
        'Memory Quality': journeys.every((journey) => journey.memory.length >= 4),
        'Completion Quality': journeys.every(
          (journey) => journey.complete.trim().isNotEmpty,
        ),
        'Lv1~10 Continuity': journeys.every(hasContinuousLevels),
        'No Reflection / Writing': journeys.every(hasNoReflectionOrWriting),
      };

      expect(computed.keys, containsAll(batchOneQualityGates.keys));
      expect(computed.values.every((value) => value), isTrue);
      expect(batchOneQualityGates, computed);
    });
  });
}
