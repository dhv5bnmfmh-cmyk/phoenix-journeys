import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/narration_player_card.dart';

void main() {
  test('uses exact native word start when progress is fresh', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 17,
        nativeProgressIsFresh: true,
        estimatedOffset: 24,
        totalCharacters: 100,
      ),
      17,
    );
  });

  test('Safari zero progress does not restart narration', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 0,
        nativeProgressIsFresh: false,
        estimatedOffset: 24,
        totalCharacters: 100,
      ),
      22,
    );
  });

  test('stale progress falls back to Phoenix clock', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 5,
        nativeProgressIsFresh: false,
        estimatedOffset: 31,
        totalCharacters: 100,
      ),
      29,
    );
  });

  test('transient controller zero keeps the last visible reading position', () {
    expect(
      resolveNarrationContinuationOffset(
        nativeOffset: 0,
        nativeProgressIsFresh: false,
        controllerOffset: 0,
        lastObservedOffset: 42,
        totalCharacters: 100,
      ),
      40,
    );
  });

  test('fresh native word remains the continuation source of truth', () {
    expect(
      resolveNarrationContinuationOffset(
        nativeOffset: 37,
        nativeProgressIsFresh: true,
        controllerOffset: 46,
        lastObservedOffset: 48,
        totalCharacters: 100,
      ),
      37,
    );
  });
}
