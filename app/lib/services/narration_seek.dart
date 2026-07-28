import 'dart:math' as math;

import 'narration_controller.dart';

int narrationSeekOffset({
  required double progress,
  required int totalCharacters,
}) {
  if (totalCharacters <= 0) return 0;
  final maxOffset = math.max(0, totalCharacters - 1);
  final safeProgress = progress.clamp(0.0, 1.0).toDouble();
  return (safeProgress * maxOffset).round().clamp(0, maxOffset).toInt();
}

extension NarrationSeekController on NarrationController {
  Future<void> seekToOffset(
    int offset, {
    required bool resumePlayback,
  }) async {
    if (!hasContent || totalCharacters <= 0) return;

    final safeOffset = offset
        .clamp(0, math.max(0, totalCharacters - 1))
        .toInt();

    // Stop the active browser/native utterance first. This prevents Safari's
    // paused-in-place session from resuming at the old position after a seek.
    await stop(resetPosition: false);
    if (resumePlayback) {
      await resumeFromOffset(safeOffset);
    } else {
      await pauseAtOffset(safeOffset);
    }
  }
}
