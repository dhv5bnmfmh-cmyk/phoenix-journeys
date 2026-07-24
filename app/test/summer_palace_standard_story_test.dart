import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_journey.dart';

void main() {
  test('Summer Palace uses two balanced long story paragraphs', () {
    expect(summerPalaceStoryParagraphs, hasLength(2));
    expect(summerPalaceStoryAnnotations, hasLength(2));
    for (final paragraph in summerPalaceStoryParagraphs) {
      expect(paragraph.length, inInclusiveRange(260, 380));
    }
    expect(
      summerPalaceStoryParagraphs.join().length,
      inInclusiveRange(600, 760),
    );
  });

  test('Summer Palace discovery mirrors the two-paragraph story rhythm', () {
    expect(summerPalaceDiscoveries, hasLength(2));
    for (final discovery in summerPalaceDiscoveries) {
      expect(discovery.text.length, inInclusiveRange(240, 340));
    }
  });
}
