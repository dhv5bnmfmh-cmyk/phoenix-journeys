import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/challenge_option_balancer.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine_legacy.dart'
    as legacy;

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

  test('Forbidden City Lv1-Lv10 final A/B/C/D order satisfies contract', () {
    final cumulative = List<int>.filled(4, 0);
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
      final authored = const legacy.JourneyChallengeEngine().build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: story,
      );

      expect(
        _renderedOptionSnapshot(rebuilt),
        _renderedOptionSnapshot(rendered),
        reason: 'Lv$level must rebuild to the identical rendered option order',
      );

      final grammar = rendered.questions
          .where((question) => question.mode == StoryChallengeMode.grammarRepair)
          .toList(growable: false);
      final completion = rendered.questions
          .where((question) => question.mode == StoryChallengeMode.storyCompletion)
          .toList(growable: false);
      final authoredGrammar = authored.questions
          .where((question) => question.mode == StoryChallengeMode.grammarRepair)
          .toList(growable: false);
      final authoredCompletion = authored.questions
          .where((question) => question.mode == StoryChallengeMode.storyCompletion)
          .toList(growable: false);

      final grammarPositions = <int>[];
      for (var questionIndex = 0;
          questionIndex < grammar.length;
          questionIndex += 1) {
        final question = grammar[questionIndex];
        final source = authoredGrammar[questionIndex];
        expect(question.options, hasLength(4));
        expect(
          question.options.where((option) => option == question.answer),
          hasLength(1),
          reason: 'Lv$level ${question.id} must have exactly one correct option',
        );
        grammarPositions.add(question.options.indexOf(question.answer));
        _expectGrammarSemanticsPreserved(source, question, level);
      }
      expect(
        _counts(grammarPositions),
        <int>[1, 1, 1, 1],
        reason: 'Lv$level Grammar must use A/B/C/D exactly once',
      );
      grammarSequences.add(grammarPositions.join());

      final completionPositions = <int>[];
      for (var questionIndex = 0;
          questionIndex < completion.length;
          questionIndex += 1) {
        final question = completion[questionIndex];
        final source = authoredCompletion[questionIndex];
        expect(question.completionBlanks, hasLength(level));
        expect(question.answer, source.answer);
        expect(question.prompt, source.prompt);
        expect(question.narrationText, source.narrationText);
        expect(question.completionSegments, source.completionSegments);

        for (var blankIndex = 0;
            blankIndex < question.completionBlanks.length;
            blankIndex += 1) {
          final blank = question.completionBlanks[blankIndex];
          final sourceBlank = source.completionBlanks[blankIndex];
          expect(blank.options, hasLength(4));
          expect(
            blank.options.where((option) => option == blank.answer),
            hasLength(1),
            reason:
                'Lv$level ${question.id} blank $blankIndex must have one answer',
          );
          completionPositions.add(blank.options.indexOf(blank.answer));
          expect(blank.answer, sourceBlank.answer);
          expect(blank.options.toSet(), sourceBlank.options.toSet());
          expect(blank.answerType, sourceBlank.answerType);
          expect(blank.semanticSlotType, sourceBlank.semanticSlotType);
          expect(blank.sourceStart, sourceBlank.sourceStart);
        }
      }
      expect(
        _counts(completionPositions),
        <int>[level, level, level, level],
        reason: 'Lv$level Completion must be exactly balanced',
      );

      final finalRenderedPositions = <int>[
        ...grammarPositions,
        ...completionPositions,
      ];
      final levelCounts = _counts(finalRenderedPositions);
      expect(
        levelCounts,
        <int>[level + 1, level + 1, level + 1, level + 1],
        reason: 'Lv$level final rendered A/B/C/D window must be balanced',
      );
      expect(_spread(levelCounts), lessThanOrEqualTo(1));
      expect(
        _maxStreak(finalRenderedPositions),
        lessThanOrEqualTo(2),
        reason: 'Lv$level must not repeat one correct position more than twice',
      );
      expect(
        _hasSimpleFourCycle(finalRenderedPositions),
        isFalse,
        reason: 'Lv$level must not expose a mechanical A/B/C/D cycle',
      );

      for (var position = 0; position < 4; position += 1) {
        cumulative[position] += levelCounts[position];
      }
    }

    expect(cumulative, <int>[65, 65, 65, 65]);
    expect(
      grammarSequences,
      hasLength(10),
      reason: 'Lv1-Lv10 must not mechanically reuse one Grammar permutation',
    );
  });
}

void _expectGrammarSemanticsPreserved(
  StoryChallengeQuestion source,
  StoryChallengeQuestion rendered,
  int level,
) {
  expect(rendered.answer, source.answer);
  expect(rendered.sourceSentence, source.sourceSentence);
  expect(rendered.prompt, source.prompt);
  expect(rendered.errorSegments, source.errorSegments);
  expect(rendered.errorSegmentIndex, source.errorSegmentIndex);
  expect(rendered.grammarFamily, source.grammarFamily);
  expect(rendered.grammarWhyWrong, source.grammarWhyWrong);
  expect(rendered.grammarRevisionRule, source.grammarRevisionRule);
  expect(rendered.narrationText, source.narrationText);
  expect(rendered.options.toSet(), source.options.toSet());

  expect(source.grammarOptionExplanations, hasLength(source.options.length));
  final explanationByOption = <String, String>{
    for (var index = 0; index < source.options.length; index += 1)
      source.options[index]: source.grammarOptionExplanations[index],
  };
  for (var index = 0; index < rendered.options.length; index += 1) {
    expect(
      rendered.grammarOptionExplanations[index],
      explanationByOption[rendered.options[index]],
      reason: 'Lv$level Grammar explanation must follow its reordered option',
    );
  }
}

List<String> _renderedOptionSnapshot(StoryChallengeSet set) => <String>[
      for (final question in set.questions)
        if (question.options.length == 4)
          '${question.id}:${question.options.join('|')}',
      for (final question in set.questions)
        for (var blankIndex = 0;
            blankIndex < question.completionBlanks.length;
            blankIndex += 1)
          if (question.completionBlanks[blankIndex].options.length == 4)
            '${question.id}:$blankIndex:'
                '${question.completionBlanks[blankIndex].options.join('|')}',
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
