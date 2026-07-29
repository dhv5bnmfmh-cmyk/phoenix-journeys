import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/widgets/narration_player_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses exact native word start when progress is fresh', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 17,
        nativeProgressIsFresh: true,
        estimatedOffset: 24,
        totalCharacters: 100,
      ),
      23,
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
      23,
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
      30,
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
      41,
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
      47,
    );
  });

  test('restored narration is prepared paused at the saved offset', () {
    final controller = NarrationController();

    controller.preparePaused(
      contentId: 'discovery',
      items: const [
        NarrationItem(id: 'first', text: '第一段内容。', label: '第一段'),
        NarrationItem(id: 'second', text: '第二段内容。', label: '第二段'),
      ],
      offset: 8,
    );

    expect(controller.contentId, 'discovery');
    expect(controller.status, NarrationStatus.paused);
    expect(controller.isRestoredPosition, isTrue);
    expect(controller.currentOffset, 8);
    expect(controller.currentItemIndex, 1);
  });

  test('checkpoints only meaningful active narration movement', () {
    expect(
      shouldCheckpointNarration(
        status: NarrationStatus.playing,
        contentId: 'discovery',
        offset: 24,
        totalCharacters: 100,
        lastSavedOffset: 8,
      ),
      isTrue,
    );
    expect(
      shouldCheckpointNarration(
        status: NarrationStatus.paused,
        contentId: 'discovery',
        offset: 24,
        totalCharacters: 100,
        lastSavedOffset: 8,
      ),
      isFalse,
    );
    expect(
      shouldCheckpointNarration(
        status: NarrationStatus.playing,
        contentId: 'discovery',
        offset: 15,
        totalCharacters: 100,
        lastSavedOffset: 8,
      ),
      isFalse,
    );
  });

  test('narration signature changes when the spoken content changes', () {
    const original = [
      NarrationItem(id: 'story-0', text: '原来的故事。'),
    ];
    const updated = [
      NarrationItem(id: 'story-0', text: '更新后的故事。'),
    ];

    expect(narrationContentSignature(original), hasLength(8));
    expect(
      narrationContentSignature(original),
      isNot(narrationContentSignature(updated)),
    );
  });
}
