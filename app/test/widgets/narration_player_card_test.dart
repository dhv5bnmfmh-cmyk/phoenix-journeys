import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/widgets/narration_player_card.dart';

void main() {
  test('ignores a premature idle completion jump from Safari', () {
    final offset = resolveNarrationDisplayOffset(
      estimatedOffset: 18,
      controllerOffset: 120,
      controllerStatus: NarrationStatus.idle,
      totalCharacters: 120,
    );

    expect(offset, 18);
  });

  test('uses native progress while narration is actively playing', () {
    final offset = resolveNarrationDisplayOffset(
      estimatedOffset: 18,
      controllerOffset: 27,
      controllerStatus: NarrationStatus.playing,
      totalCharacters: 120,
    );

    expect(offset, 27);
  });

  test('keeps the guarded offset inside the narration range', () {
    final offset = resolveNarrationDisplayOffset(
      estimatedOffset: 150,
      controllerOffset: 20,
      controllerStatus: NarrationStatus.idle,
      totalCharacters: 120,
    );

    expect(offset, 120);
  });

  // Audio resume must never move beyond the word visible at pause time.
  test('pause offset never jumps ahead of the native word position', () {
    final offset = resolveNarrationPauseOffset(
      controllerOffset: 23,
      estimatedOffset: 28,
      totalCharacters: 120,
    );

    expect(offset, 23);
  });

  test('pause offset remains inside the narration range', () {
    final offset = resolveNarrationPauseOffset(
      controllerOffset: 150,
      estimatedOffset: 145,
      totalCharacters: 120,
    );

    expect(offset, 119);
  });
}
