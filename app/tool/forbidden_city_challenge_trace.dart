// ignore_for_file: avoid_print

import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Founder Lv4 and Lv7 challenge design trace', () {
  for (final level in [4, 7]) {
    final profile = ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '$level',
      levelLabel: '$level',
      band: level == 4
          ? PhoenixReadingBand.elementary
          : PhoenixReadingBand.upperIntermediate,
      phoenixLevel: level,
    );
    final bundle = JourneyPreparationCoordinator.instance.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile,
      scriptMode: 'simplified',
    );
    final set = const JourneyChallengeEngine().build(
      journeyId: 'beijing-forbidden-city',
      sessionLevel: level,
      storyParagraphs: bundle.challengeSourceMaterial,
    );
    print('## Lv$level');
    for (var index = 0; index < set.questions.length; index++) {
      final q = set.questions[index];
      final s = q.signature;
      print('Q${index + 1} | source: ${q.sourceSentence} | mode: ${q.mode.name} | '
          'syntax: ${s.syntaxPattern} | operation: ${s.operationType} | '
          'answer type: ${s.answerShape} | distractor: ${s.distractorStrategy}');
    }
  }
  });
}
