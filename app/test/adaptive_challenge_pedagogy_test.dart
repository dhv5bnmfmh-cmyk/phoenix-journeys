import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  test('beginner hints are shorter and more direct', () {
    final hint = adaptiveChallengeHint(
      type: JourneyChallengeType.missingSentence,
      difficulty: JourneyChallengeDifficulty.beginner,
      attempt: 1,
    );
    final advanced = adaptiveChallengeHint(
      type: JourneyChallengeType.missingSentence,
      difficulty: JourneyChallengeDifficulty.advanced,
      attempt: 1,
    );

    expect(hint, contains('前一句'));
    expect(advanced, contains('主题链'));
    expect(advanced.length, greaterThan(hint.length));
  });

  test('standard explanation preserves authored content', () {
    const authored = '原有完整讲解';
    expect(
      adaptiveChallengeExplanation(
        type: JourneyChallengeType.paragraphRebuild,
        difficulty: JourneyChallengeDifficulty.standard,
        baseExplanation: authored,
      ),
      authored,
    );
  });

  test('advanced memory support adds an analysis action', () {
    final tip = adaptiveChallengeMemoryTip(
      type: JourneyChallengeType.grammarRepair,
      difficulty: JourneyChallengeDifficulty.advanced,
      baseTip: '检查主语',
    );
    expect(tip, contains('改动最小'));
  });
}
