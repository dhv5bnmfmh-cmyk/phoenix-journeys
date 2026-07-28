import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  const beginner = ChineseProficiencyProfile(
    track: ChineseExamTrack.hsk,
    levelCode: '1',
    levelLabel: '1',
    band: PhoenixReadingBand.beginner,
  );
  const standard = ChineseProficiencyProfile(
    track: ChineseExamTrack.tocfl,
    levelCode: '3',
    levelLabel: 'Level 3',
    band: PhoenixReadingBand.intermediate,
  );
  const advanced = ChineseProficiencyProfile(
    track: ChineseExamTrack.hsk,
    levelCode: '7-9',
    levelLabel: '7–9',
    band: PhoenixReadingBand.mastery,
  );

  test('every adaptive challenge exposes five candidate answers', () {
    expect(journeyChallengeOptionCount, 5);
  });

  test('challenge difficulty follows the selected reading band', () {
    expect(
      challengeDifficultyForProfile(beginner),
      JourneyChallengeDifficulty.beginner,
    );
    expect(
      challengeDifficultyForProfile(standard),
      JourneyChallengeDifficulty.standard,
    );
    expect(
      challengeDifficultyForProfile(advanced),
      JourneyChallengeDifficulty.advanced,
    );
  });
}
