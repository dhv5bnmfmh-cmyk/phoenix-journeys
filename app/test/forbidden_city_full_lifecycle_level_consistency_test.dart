import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';

void main() {
  const engine = JourneyChallengeEngine();

  ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
        track: ChineseExamTrack.hsk,
        levelCode: '$level',
        levelLabel: '$level',
        band: level <= 2
            ? PhoenixReadingBand.beginner
            : level <= 4
                ? PhoenixReadingBand.elementary
                : level <= 6
                    ? PhoenixReadingBand.intermediate
                    : level <= 8
                        ? PhoenixReadingBand.upperIntermediate
                        : PhoenixReadingBand.advanced,
        phoenixLevel: level,
      );

  test('Lv1 Lv5 Lv10 keep one authoritative level through all six stages', () {
    final stageFingerprints = <String>{};
    for (final level in <int>[1, 5, 10]) {
      final prepared = JourneyPreparationCoordinator.instance.prepareNow(
        journeyId: 'beijing-forbidden-city',
        profile: profile(level),
        scriptMode: 'simplified',
      );
      final challenge = engine.build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: prepared.challengeSourceMaterial,
      );
      final memory = forbiddenCityMemoryForLevel(level);
      final completion = forbiddenCityCompletionForLevel(level);

      expect(prepared.key.phoenixLevel, level);
      expect(prepared.levelContent.storyParagraphs,
          forbiddenCityStoryParagraphsByLevel[level - 1]);
      expect(prepared.levelContent.words, isNotEmpty);
      expect(prepared.levelContent.discoveries, isNotEmpty);
      expect(challenge.sessionLevel, level);
      expect(challenge.questions, hasLength(12));
      expect(memory.level, level);
      expect(completion.level, level);

      stageFingerprints.add(<String>[
        prepared.levelContent.storyParagraphs.join(),
        prepared.levelContent.words.map((word) => word.word).join(),
        prepared.levelContent.discoveries.map((item) => item.text).join(),
        challenge.questions.map((question) => question.answer).join(),
        '${memory.anchor}${memory.recall}${memory.characterShift}${memory.takeaway}',
        completion.narration,
      ].join('|'));
    }
    expect(stageFingerprints, hasLength(3));
  });

  test('Journey UI wires level-specific Memory Completion and Q12 handoff', () {
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
    final challenge =
        File('lib/widgets/hsk_story_challenge.dart').readAsStringSync();

    expect(journey, contains('forbiddenCityMemoryForLevel('));
    expect(journey, contains('forbiddenCityCompletionForLevel('));
    expect(journey, contains('_sessionLanguageProfile.phoenixLevel ?? 1'));
    expect(journey, contains("'继续留下回忆'"));
    expect(journey, contains('setState(() => _challengeResolved = true)'));
    expect(challenge, isNot(contains("'完成挑战'")));
    expect(challenge, contains('completionReported = true'));
    expect(challenge, contains('unawaited(widget.onCompleted())'));
    expect(challenge, contains("? '下一题'"));
  });
}
