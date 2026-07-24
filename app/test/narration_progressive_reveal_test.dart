import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('narration reveal preserves layout while exposing only spoken text', () {
    expect(revealedSegmentLength(segmentStart: 5, segmentEnd: 10), 5);
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

  test('missing snapshots use local controller progress without jumping', () {
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 1,
        itemLength: 10,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      4,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 0,
        itemLength: 12,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      12,
    );
    expect(
      stableNarrationRevealEnd(
        sessionActive: true,
        itemIndex: 2,
        itemLength: 8,
        snapshotItemIndex: null,
        snapshotEnd: null,
        controllerItemIndex: 1,
        controllerItemStartOffset: 13,
        currentOffset: 17,
      ),
      0,
    );
  });

  test('linear reveal duration follows natural Chinese reading pace', () {
    expect(cinematicRevealDuration(1).inMilliseconds, 210);
    expect(cinematicRevealDuration(30).inMilliseconds, 700);
  });

  test('cinematic reveal keeps a short pale-to-deep tail', () {
    expect(cinematicDepthProgress(revealCursor: 8, characterIndex: 8), 0);
    final fresh = cinematicDepthProgress(revealCursor: 8.5, characterIndex: 8);
    final deepening = cinematicDepthProgress(
      revealCursor: 9.5,
      characterIndex: 8,
    );
    expect(fresh, greaterThan(0));
    expect(fresh, lessThan(deepening));
    expect(cinematicDepthProgress(revealCursor: 11, characterIndex: 8), 1);
  });
}
