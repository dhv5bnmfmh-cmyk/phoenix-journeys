import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_journey.dart';

void main() {
  test('Summer Palace uses one continuous longer story article', () {
    expect(summerPalaceStoryParagraphs, hasLength(1));
    expect(summerPalaceStoryAnnotations, hasLength(1));
    expect(
      summerPalaceStoryParagraphs.single.length,
      inInclusiveRange(600, 1300),
    );
  });
}
