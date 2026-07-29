import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/shadowing_score.dart';

void main() {
  group('scoreShadowing', () {
    test('gives full credit to an exact reading', () {
      final score = scoreShadowing(
        reference: '天刚亮，市场里已经很热闹。',
        recognized: '天刚亮市场里已经很热闹',
        recognitionConfidence: 1,
      );

      expect(score.overall, 100);
      expect(score.completeness, 100);
      expect(score.label, '非常自然');
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
      expect(partial.matchedCharacters, lessThan(partial.referenceCharacters));
    });
  });
}
