import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/language_difficulty_agent.dart';

void main() {
  const agent = LanguageDifficultyAgent();

  test('maps TOCFL C1 to mastery reading plan', () {
    final plan = agent.createPlan(
      const LearnerLanguageProfile(
        track: ChineseExamTrack.tocfl,
        level: 'C1',
      ),
    );

    expect(plan.band, PhoenixReadingBand.mastery);
    expect(plan.targetVocabularyCount, 18);
    expect(plan.paragraphCount, 3);
  });

  test('strong performance raises the next journey by one band', () {
    final plan = agent.createPlan(
      const LearnerLanguageProfile(
        track: ChineseExamTrack.hsk,
        level: 'HSK 3',
        recentComprehension: 0.92,
        recentVocabularyAccuracy: 0.90,
        lookupRate: 0.04,
      ),
    );

    expect(plan.band, PhoenixReadingBand.upperIntermediate);
    expect(plan.targetVocabularyCount, 11);
  });

  test('overload signals lower the next journey by one band', () {
    final plan = agent.createPlan(
      const LearnerLanguageProfile(
        track: ChineseExamTrack.tocfl,
        level: 'B2',
        recentComprehension: 0.54,
        recentVocabularyAccuracy: 0.58,
        lookupRate: 0.21,
      ),
    );

    expect(plan.band, PhoenixReadingBand.upperIntermediate);
    expect(plan.maxCharacters, 600);
  });
}
