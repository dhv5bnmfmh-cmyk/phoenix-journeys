import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/language_difficulty_agent.dart';
import 'package:phoenix_journeys/agents/vocabulary_curator_agent.dart';
import 'package:phoenix_journeys/data/journey_data.dart';

WordEntry word(String value) => WordEntry(
      word: value,
      pinyin: value,
      simpleChinese: value,
      translation: value,
      symbol: '📘',
    );

void main() {
  const difficultyAgent = LanguageDifficultyAgent();
  const curator = VocabularyCuratorAgent();

  test('selects the target amount without duplicate words', () {
    final plan = difficultyAgent.createPlan(
      const LearnerLanguageProfile(
        track: ChineseExamTrack.hsk,
        level: 'HSK2',
      ),
    );
    final candidates = List.generate(
      10,
      (index) => VocabularyCandidate(
        entry: word('词$index'),
        examLevel: 2 + index % 2,
        expressionValue: 0.6 + index / 100,
        culturalValue: index < 2 ? 0.9 : 0,
        mastery: index >= 2 && index < 5 ? 0.5 : 0,
      ),
    );

    final selection = curator.select(
      candidates: candidates,
      plan: plan,
      learnerExamLevel: 2,
    );

    expect(selection.all, hasLength(plan.targetVocabularyCount));
    expect(selection.all.map((item) => item.word).toSet(),
        hasLength(plan.targetVocabularyCount));
    expect(selection.culturalWords, isNotEmpty);
    expect(selection.reviewWords, isNotEmpty);
  });

  test('returns an empty selection when no candidates exist', () {
    final plan = difficultyAgent.createPlan(
      const LearnerLanguageProfile(
        track: ChineseExamTrack.phoenix,
        level: 'starter',
      ),
    );

    final selection = curator.select(
      candidates: const <VocabularyCandidate>[],
      plan: plan,
      learnerExamLevel: 1,
    );

    expect(selection.all, isEmpty);
  });
}
