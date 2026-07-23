import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('narration reveal preserves layout while exposing only spoken text', () {
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10),
      5,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 3),
      0,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 7),
      2,
    );
    expect(
      revealedSegmentLength(segmentStart: 5, segmentEnd: 10, revealEnd: 14),
      5,
    );
  });
}
