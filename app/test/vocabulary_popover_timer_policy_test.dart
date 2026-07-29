import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/vocabulary_popover_timer_policy.dart';

void main() {
  test('inline vocabulary explanation receives a readable display window', () {
    expect(
      resolvePhoenixTimerDuration(legacyInlineVocabularyPopoverDuration),
      readableInlineVocabularyPopoverDuration,
    );
    expect(
      readableInlineVocabularyPopoverDuration,
      const Duration(seconds: 12),
    );
  });

  test('unrelated application timers retain their original duration', () {
    const unrelated = Duration(milliseconds: 2400);
    expect(resolvePhoenixTimerDuration(unrelated), unrelated);
  });
}
