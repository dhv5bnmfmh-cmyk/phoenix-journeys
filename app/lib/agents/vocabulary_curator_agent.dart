import '../data/journey_data.dart';
import 'language_difficulty_agent.dart';

class VocabularyCandidate {
  const VocabularyCandidate({
    required this.entry,
    required this.examLevel,
    this.frequencyScore = 0.5,
    this.expressionValue = 0.5,
    this.culturalValue = 0.0,
    this.mastery = 0.0,
  });

  final WordEntry entry;
  final int examLevel;
  final double frequencyScore;
  final double expressionValue;
  final double culturalValue;
  final double mastery;
}

class VocabularySelection {
  const VocabularySelection({
    required this.coreNewWords,
    required this.reviewWords,
    required this.culturalWords,
  });

  final List<WordEntry> coreNewWords;
  final List<WordEntry> reviewWords;
  final List<WordEntry> culturalWords;

  List<WordEntry> get all => <WordEntry>[
        ...coreNewWords,
        ...reviewWords,
        ...culturalWords,
      ];
}

class VocabularyCuratorAgent {
  const VocabularyCuratorAgent();

  VocabularySelection select({
    required List<VocabularyCandidate> candidates,
    required LanguageDifficultyPlan plan,
    required int learnerExamLevel,
  }) {
    final unique = <String, VocabularyCandidate>{};
    for (final candidate in candidates) {
      unique.putIfAbsent(candidate.entry.word, () => candidate);
    }

    final available = unique.values.toList(growable: false);
    final total = plan.targetVocabularyCount.clamp(1, available.length);
    final culturalTarget = total >= 8 ? (total * 0.15).round().clamp(1, 3) : 1;
    final reviewTarget = (total * 0.25).round().clamp(0, total - culturalTarget);
    final coreTarget = total - culturalTarget - reviewTarget;

    final cultural = available
        .where((item) => item.culturalValue > 0)
        .toList()
      ..sort((a, b) => _culturalScore(b).compareTo(_culturalScore(a)));

    final selectedCultural = cultural.take(culturalTarget).toList();
    final used = selectedCultural.map((item) => item.entry.word).toSet();

    final review = available
        .where((item) => !used.contains(item.entry.word) && item.mastery > 0 && item.mastery < 0.8)
        .toList()
      ..sort((a, b) => _reviewScore(b).compareTo(_reviewScore(a)));
    final selectedReview = review.take(reviewTarget).toList();
    used.addAll(selectedReview.map((item) => item.entry.word));

    final core = available
        .where((item) =>
            !used.contains(item.entry.word) &&
            item.examLevel >= learnerExamLevel &&
            item.mastery < 0.8)
        .toList()
      ..sort((a, b) => _coreScore(b, learnerExamLevel)
          .compareTo(_coreScore(a, learnerExamLevel)));

    final selectedCore = core.take(coreTarget).toList();
    used.addAll(selectedCore.map((item) => item.entry.word));

    if (used.length < total) {
      final fallback = available
          .where((item) => !used.contains(item.entry.word))
          .toList()
        ..sort((a, b) => _fallbackScore(b).compareTo(_fallbackScore(a)));
      for (final item in fallback.take(total - used.length)) {
        selectedCore.add(item);
        used.add(item.entry.word);
      }
    }

    return VocabularySelection(
      coreNewWords:
          selectedCore.map((item) => item.entry).toList(growable: false),
      reviewWords:
          selectedReview.map((item) => item.entry).toList(growable: false),
      culturalWords:
          selectedCultural.map((item) => item.entry).toList(growable: false),
    );
  }

  double _coreScore(VocabularyCandidate item, int learnerLevel) {
    final levelDistance = (item.examLevel - learnerLevel).abs();
    final levelFit = 1 / (1 + levelDistance);
    return levelFit * 0.35 +
        item.frequencyScore * 0.25 +
        item.expressionValue * 0.30 +
        (1 - item.mastery) * 0.10;
  }

  double _reviewScore(VocabularyCandidate item) =>
      (1 - (item.mastery - 0.55).abs()) * 0.55 +
      item.frequencyScore * 0.25 +
      item.expressionValue * 0.20;

  double _culturalScore(VocabularyCandidate item) =>
      item.culturalValue * 0.65 + item.expressionValue * 0.20 + item.frequencyScore * 0.15;

  double _fallbackScore(VocabularyCandidate item) =>
      item.expressionValue * 0.45 +
      item.frequencyScore * 0.35 +
      item.culturalValue * 0.20;
}
