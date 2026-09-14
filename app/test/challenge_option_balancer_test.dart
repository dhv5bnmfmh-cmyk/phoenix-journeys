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
      count: 3,
    );

    expect(selected, hasLength(3));
    expect(selected.toSet(), hasLength(3));
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

  test('prefers a plausible near-miss over an unrelated same-length option', () {
    const correct = '长廊连接湖岸，也改变观看节奏。';
    final selected = selectBalancedChallengeDistractors(
      correctAnswers: const <String>[correct],
      candidates: const <String>[
        '月光照亮河灯，也提醒人们回家。',
        '长廊连接景点，却没有改变行走节奏。',
        '游客经过入口，也准备开始拍照。',
      ],
      count: 1,
    );

    expect(selected, <String>['长廊连接景点，却没有改变行走节奏。']);
    expect(
      challengeKeywordOverlap(selected.single, correct),
      inInclusiveRange(.25, .75),
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
