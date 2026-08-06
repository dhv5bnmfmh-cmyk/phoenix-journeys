import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';

void main() {
  group('Phoenix Batch 1 journey remediation', () {
    for (final journey in <RemediatedJourney>[
      forbiddenCityRemediation,
      templeOfHeavenRemediation,
    ]) {
      test('${journey.title} has continuous Lv1-Lv10 story', () {
        expect(journey.levels, hasLength(10));
        for (var index = 0; index < journey.levels.length; index++) {
          expect(journey.levels[index], startsWith('Lv${index + 1}｜'));
        }
        expect(journey.protagonist, isNotEmpty);
        expect(journey.goal, isNotEmpty);
        expect(journey.conflict, isNotEmpty);
      });

      test('${journey.title} has required learning sections', () {
        expect(journey.words.length, greaterThanOrEqualTo(10));
        expect(journey.discoveries.length, greaterThanOrEqualTo(4));
        expect(journey.challenge.paragraphRebuild, isNotEmpty);
        expect(journey.challenge.grammarRepair, isNotEmpty);
        expect(journey.challenge.missingSentence, isNotEmpty);
        expect(journey.memory, isNotEmpty);
        expect(journey.complete, isNotEmpty);
        expect(journey.sourceIds, isNotEmpty);
      });
    }

    test('all declared quality gates pass', () {
      expect(batchOneQualityGates.keys, containsAll(<String>[
        'Story Continuity',
        'Character Consistency',
        'Timeline Consistency',
        'Historical Accuracy',
        'Cultural Authenticity',
        'Vocabulary Source Validation',
        'Discovery Quality',
        'Challenge Quality',
        'Memory Quality',
        'Completion Quality',
        'Lv1~10 Continuity',
        'No Reflection / Writing',
      ]));
      expect(batchOneQualityGates.values.every((value) => value), isTrue);
    });
  });
}
