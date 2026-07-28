import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/challenge_option_balancer.dart';

void main() {
  test('balanced distractors stay unique and close to answer length', () {
    const correct = '他沿着长廊慢慢向前走。';
    final selected = selectBalancedChallengeDistractors(
      correctAnswers: const <String>[correct],
      candidates: const <String>[
        '短。',
        '他沿着长廊缓缓向前走。',
        '探索者沿着长廊继续向前走。',
        '沿着长廊，他慢慢向前走。',
        '他沿长廊向前走去。',
        '他沿着长廊缓缓向前走。',
        '这是一个非常非常长并且会明显暴露答案位置的候选句。',
      ],
      count: 4,
    );

    expect(selected, hasLength(4));
    expect(selected.toSet(), hasLength(4));
    expect(selected, isNot(contains(correct)));
    expect(selected, isNot(contains('短。')));
    expect(
      selected,
      isNot(contains('这是一个非常非常长并且会明显暴露答案位置的候选句。')),
    );
    expect(
      challengeOptionLengthSpread(<String>[correct, ...selected]),
      lessThanOrEqualTo(6),
    );
  });

  test('balanced distractors reject an insufficient unique pool', () {
    expect(
      () => selectBalancedChallengeDistractors(
        correctAnswers: const <String>['正确答案'],
        candidates: const <String>['正确答案', '同一个答案', '同一个答案'],
        count: 2,
      ),
      throwsStateError,
    );
  });
}
