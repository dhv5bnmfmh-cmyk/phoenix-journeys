import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
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

  test('paragraph boundary never clears the whole narration for one frame', () {
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 12,
      ),
      12,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 1,
        itemLength: 10,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 12,
      ),
      0,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 0,
        currentOffset: 0,
      ),
      0,
    );
  });

  test('cinematic reveal interpolates each glyph with a bounded duration', () {
    expect(
      cinematicRevealProgress(revealCursor: 4, characterIndex: 4),
      0,
    );
    final half = cinematicRevealProgress(
      revealCursor: 4.5,
      characterIndex: 4,
    );
    expect(half, greaterThan(.5));
    expect(half, lessThan(1));
    expect(
      cinematicRevealProgress(revealCursor: 5, characterIndex: 4),
      1,
    );
    expect(cinematicRevealDuration(1).inMilliseconds, 120);
    expect(cinematicRevealDuration(30).inMilliseconds, 420);
  });

  test('cinematic reveal keeps a pale-to-deep six-character tail', () {
    expect(
      cinematicDepthProgress(revealCursor: 8, characterIndex: 8),
      0,
    );
    final fresh = cinematicDepthProgress(
      revealCursor: 8.5,
      characterIndex: 8,
    );
    final deepening = cinematicDepthProgress(
      revealCursor: 11,
      characterIndex: 8,
    );
    expect(fresh, greaterThan(0));
    expect(fresh, lessThan(.5));
    expect(deepening, greaterThan(fresh));
    expect(
      cinematicDepthProgress(revealCursor: 14, characterIndex: 8),
      1,
    );
  });
}
