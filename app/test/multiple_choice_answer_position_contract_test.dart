import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/challenge_option_balancer.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';

void main() {
  test('shared answer-position scheduler is deterministic and balanced', () {
    final first = balancedChallengeAnswerPositions(
      itemCount: 10,
      seed: 'journey:5:question-family',
      variationOrdinal: 5,
    );
    final second = balancedChallengeAnswerPositions(
      itemCount: 10,
      seed: 'journey:5:question-family',
      variationOrdinal: 5,
    );

    expect(second, first);
    expect(_spread(_counts(first)), lessThanOrEqualTo(1));
    expect(_maxStreak(first), lessThanOrEqualTo(2));
    expect(_hasSimpleFourCycle(first), isFalse);
  });

  test('Forbidden City Lv1-Lv10 final choice positions satisfy 2x6 contract', () {
    final grammarSequences = <String>{};

    for (var level = 1; level <= 10; level += 1) {
      final story = forbiddenCityStoryParagraphsByLevel[level - 1];
      final rendered = const JourneyChallengeEngine().build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: story,
      );
      final rebuilt = const JourneyChallengeEngine().build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: story,
      );

      expect(rendered.questions, hasLength(12), reason: 'Lv$level 2x6 total');
      expect(
        _renderedOptionSnapshot(rebuilt),
        _renderedOptionSnapshot(rendered),
        reason: 'Lv$level must rebuild to the identical rendered option order',
      );

      final grammar = rendered.questions
          .where((question) => question.mode == StoryChallengeMode.grammarRepair)
          .toList(growable: false);
      expect(grammar, hasLength(2), reason: 'Lv$level Grammar 2x6');

      final grammarPositions = <int>[];
      for (final question in grammar) {
        expect(question.options, hasLength(4));
        expect(
          question.options.where((option) => option == question.answer),
          hasLength(1),
          reason: 'Lv$level ${question.id} must have exactly one correct option',
        );
        grammarPositions.add(question.options.indexOf(question.answer));
        _expectGrammarContractPreserved(question, level);
      }
      grammarSequences.add(grammarPositions.join());

      final choiceQuestions = rendered.questions
          .where((question) => question.options.length == 4)
          .toList(growable: false);
      expect(choiceQuestions, hasLength(10), reason: 'Lv$level choice questions');
      final positions = <int>[
        for (final question in choiceQuestions)
          question.options.indexOf(question.answer),
      ];
      for (final position in positions) {
        expect(position, inInclusiveRange(0, 3));
      }
      final levelCounts = _counts(positions);
      expect(
        _spread(levelCounts),
        lessThanOrEqualTo(1),
        reason: 'Lv$level final choice window must stay balanced',
      );
      expect(
        _maxStreak(positions),
        lessThanOrEqualTo(2),
        reason: 'Lv$level must not repeat one correct position more than twice',
      );
      expect(
        _hasSimpleFourCycle(positions),
        isFalse,
        reason: 'Lv$level must not expose a mechanical A/B/C/D cycle',
      );
    }

    expect(
      grammarSequences.length,
      greaterThanOrEqualTo(8),
      reason: 'Lv1-Lv10 must not mechanically reuse one Grammar permutation',
    );
  });
}

void _expectGrammarContractPreserved(
  StoryChallengeQuestion rendered,
  int level,
) {
  expect(rendered.sourceSentence, isNotEmpty);
  expect(rendered.prompt, isNot(rendered.answer));
  expect(rendered.errorSegments.join(), rendered.prompt);
  expect(rendered.errorSegmentIndex, inInclusiveRange(0, 3));
  expect(rendered.grammarFamily, isNotEmpty);
  expect(rendered.grammarWhyWrong, isNotEmpty);
  expect(rendered.grammarRevisionRule, isNotEmpty);
  expect(rendered.narrationText, rendered.prompt);
  expect(rendered.options.toSet(), hasLength(4));
  expect(rendered.grammarOptionExplanations, hasLength(4));
  expect(
    rendered.grammarOptionExplanations.every((value) => value.isNotEmpty),
    isTrue,
    reason: 'Lv$level Grammar feedback must remain explanatory',
  );
}

List<String> _renderedOptionSnapshot(StoryChallengeSet set) => <String>[
      for (final question in set.questions)
        if (question.options.length == 4)
          '${question.id}:${question.options.join('|')}',
    ];

List<int> _counts(List<int> positions) {
  final counts = List<int>.filled(4, 0);
  for (final position in positions) {
    counts[position] += 1;
  }
  return counts;
}

int _spread(List<int> counts) {
  final sorted = List<int>.of(counts)..sort();
  return sorted.last - sorted.first;
}

int _maxStreak(List<int> positions) {
  var longest = 0;
  var current = 0;
  int? previous;
  for (final position in positions) {
    if (position == previous) {
      current += 1;
    } else {
      previous = position;
      current = 1;
    }
    if (current > longest) longest = current;
  }
  return longest;
}

bool _hasSimpleFourCycle(List<int> positions) {
  if (positions.length < 8) return false;
  for (var index = 4; index < positions.length; index += 1) {
    if (positions[index] != positions[index % 4]) return false;
  }
  return true;
}
