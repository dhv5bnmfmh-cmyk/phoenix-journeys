import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/shadowing_passage_catalog.dart';

void main() {
  test('catalog provides short multi-sentence passages', () {
    expect(shadowingPassages.length, greaterThanOrEqualTo(6));
    for (final passage in shadowingPassages) {
      expect(passage.sentences.length, greaterThanOrEqualTo(3));
      expect(passage.estimatedMinutes, inInclusiveRange(1, 9));
    }
  });

  test('level filter grows with the learner level', () {
    expect(
      shadowingPassagesForLevel(10).length,
      greaterThan(shadowingPassagesForLevel(1).length),
    );
  });
}
