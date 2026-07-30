import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_score.dart';

void main() {
  group('scoreShadowing', () {
    setUp(resetShadowingAttemptProgress);

    test('gives full credit to an exact reading', () {
      final score = scoreShadowing(
        reference: '天刚亮，市场里已经很热闹。',
        recognized: '天刚亮市场里已经很热闹',
        recognitionConfidence: 1,
      );

      expect(score.overall, 100);
      expect(score.accuracy, 100);
      expect(score.completeness, 100);
      expect(score.fluency, 100);
      expect(score.omittedCharacters, 0);
      expect(score.wrongCharacters, 0);
      expect(score.extraCharacters, 0);
      expect(score.label, '非常自然');
      expect(score.diagnosisSummary, contains('准确度 100%'));
      expect(score.attemptDelta, isNull);
    });

    test('ignores punctuation and whitespace', () {
      expect(
        normalizeShadowingText(' 你好，世界！ '),
        '你好世界',
      );
    });

    test('scores a partial reading below a complete reading', () {
      final partial = scoreShadowing(
        reference: '有人买菜，有人坐下来吃早餐。',
        recognized: '有人买菜',
        recognitionConfidence: .8,
      );

      expect(partial.overall, lessThan(100));
      expect(partial.completeness, lessThan(partial.accuracy));
      expect(partial.matchedCharacters, lessThan(partial.referenceCharacters));
      expect(partial.omittedCharacters, greaterThan(0));
      expect(partial.wrongCharacters, 0);
      expect(partial.coaching, contains('红色文字'));
    });

    test('extra words lower accuracy without lowering completeness', () {
      final score = scoreShadowing(
        reference: '今天去旅行',
        recognized: '今天去旅行旅行',
        recognitionConfidence: .9,
      );

      expect(score.completeness, 100);
      expect(score.accuracy, lessThan(100));
      expect(score.extraCharacters, 2);
      expect(score.wrongCharacters, 0);
      expect(score.coaching, contains('多读'));
    });

    test('distinguishes a wrong character from omission and addition', () {
      final score = scoreShadowing(
        reference: '今天去旅行',
        recognized: '今天去旅形',
        recognitionConfidence: .9,
      );

      expect(score.completeness, 100);
      expect(score.accuracy, lessThan(100));
      expect(score.omittedCharacters, 0);
      expect(score.wrongCharacters, 1);
      expect(score.extraCharacters, 0);
      expect(score.issueSummary, '漏读 0 · 错读 1 · 多读 0');
      expect(score.coaching, contains('错读 1 个字'));
    });

    test('recognition confidence contributes to fluency', () {
      final confident = scoreShadowing(
        reference: '语言让旅行留下温度',
        recognized: '语言让旅行留下温度',
        recognitionConfidence: 1,
      );
      final hesitant = scoreShadowing(
        reference: '语言让旅行留下温度',
        recognized: '语言让旅行留下温度',
        recognitionConfidence: .4,
      );

      expect(confident.fluency, greaterThan(hesitant.fluency));
      expect(confident.overall, greaterThan(hesitant.overall));
      expect(hesitant.attemptDelta, isNotNull);
      expect(hesitant.attemptDelta!.overall, lessThan(0));
    });

    test('compares consecutive attempts of the same sentence', () {
      final first = scoreShadowing(
        reference: '旅行让语言留下温度',
        recognized: '旅行语言',
        recognitionConfidence: .6,
      );
      final second = scoreShadowing(
        reference: '旅行让语言留下温度',
        recognized: '旅行让语言留下温度',
        recognitionConfidence: .95,
      );

      expect(first.attemptDelta, isNull);
      expect(second.attemptDelta, isNotNull);
      expect(second.attemptDelta!.overall, greaterThan(0));
      expect(second.attemptDelta!.completeness, greaterThan(0));
      expect(second.coaching, contains('比上次提升'));
      expect(second.coaching, contains('本次进步最大的是'));
    });

    test('changing the sentence starts a new comparison baseline', () {
      scoreShadowing(
        reference: '第一句练习',
        recognized: '第一句',
        recognitionConfidence: .8,
      );
      final nextSentence = scoreShadowing(
        reference: '第二句练习',
        recognized: '第二句练习',
        recognitionConfidence: 1,
      );

      expect(nextSentence.attemptDelta, isNull);
    });

    test('reset clears the previous attempt baseline', () {
      scoreShadowing(
        reference: '今天去旅行',
        recognized: '今天旅行',
        recognitionConfidence: .8,
      );
      resetShadowingAttemptProgress();
      final score = scoreShadowing(
        reference: '今天去旅行',
        recognized: '今天去旅行',
        recognitionConfidence: 1,
      );

      expect(score.attemptDelta, isNull);
    });

    test('marks omitted reference characters for focused retry', () {
      final feedback = buildShadowingReferenceFeedback(
        reference: '今天的新鲜菜',
        recognized: '今天的菜',
      );

      expect(
        feedback
            .where((unit) => !unit.matched)
            .map((unit) => unit.text)
            .join(),
        '新鲜',
      );
    });

    test('uses every sentence when calculating the passage score', () {
      expect(
        averageShadowingSessionScore(
          sentenceScores: const [90, 60, 75],
          sentenceCount: 3,
        ),
        75,
      );
    });
  });
}
