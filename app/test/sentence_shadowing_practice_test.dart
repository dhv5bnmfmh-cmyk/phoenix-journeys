import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/sentence_shadowing_practice.dart';

void main() {
  test('normalizes Chinese punctuation before comparison', () {
    expect(normalizeShadowingText('你好，世界！'), '你好世界');
  });

  test('gives a perfect score to an exact sentence', () {
    final result = evaluateShadowing(
      target: '午门并不是一扇普通的门。',
      spoken: '午门并不是一扇普通的门',
    );

    expect(result.score, 100);
    expect(result.excellent, isTrue);
  });

  test('keeps partial speech below the pass threshold', () {
    final result = evaluateShadowing(
      target: '今天我们从河内飞往北京。',
      spoken: '今天北京',
    );

    expect(result.score, lessThan(72));
    expect(result.passed, isFalse);
  });

  test('accepts a close recognition result without requiring perfection', () {
    final result = evaluateShadowing(
      target: '沿着城墙慢慢往前走。',
      spoken: '沿着城墙慢慢向前走',
    );

    expect(result.passed, isTrue);
    expect(result.score, lessThan(100));
  });
}
