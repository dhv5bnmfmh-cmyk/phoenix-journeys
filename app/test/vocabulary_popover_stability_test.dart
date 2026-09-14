import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('equivalent vocabulary lists survive narration rebuilds', () {
    expect(
      vocabularyWordListsEquivalent(
        const ['月光', '河灯'],
        const ['河灯', '月光'],
      ),
      isTrue,
    );
    expect(
      vocabularyWordListsEquivalent(
        const ['月光', '河灯'],
        const ['月光', '古城'],
      ),
      isFalse,
    );
  });

  test('inline vocabulary explanation remains readable', () {
    expect(
      vocabularyPopoverAutoHideDuration,
      const Duration(seconds: 12),
    );
  });
}
