import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/services/narration_follow_coordinator.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('auto-follow starts when a new paragraph becomes active', () {
    expect(
      shouldAutoFollowNarrationItem(
        status: NarrationStatus.playing,
        wasActive: false,
        isActive: true,
        sessionChanged: false,
      ),
      isTrue,
    );
  });

  test('auto-follow does not repeatedly move within the same paragraph', () {
    expect(
      shouldAutoFollowNarrationItem(
        status: NarrationStatus.playing,
        wasActive: true,
        isActive: true,
        sessionChanged: false,
      ),
      isFalse,
    );
  });

  test('paused narration never takes over manual reading position', () {
    expect(
      shouldAutoFollowNarrationItem(
        status: NarrationStatus.paused,
        wasActive: false,
        isActive: true,
        sessionChanged: true,
      ),
      isFalse,
    );
  });

  test('a restarted speech session may re-center the active paragraph', () {
    expect(
      shouldAutoFollowNarrationItem(
        status: NarrationStatus.playing,
        wasActive: true,
        isActive: true,
        sessionChanged: true,
      ),
      isTrue,
    );
  });
  test(
    'manual interaction keeps auto-follow asleep during the hold window',
    () {
      final now = DateTime(2026, 7, 29, 12);
      expect(
        narrationAutoFollowRemainingHold(
          now: now,
          holdUntil: now.add(const Duration(milliseconds: 2400)),
        ),
        const Duration(milliseconds: 2400),
      );
    },
  );

  test('auto-follow may resume after the manual hold expires', () {
    final now = DateTime(2026, 7, 29, 12);
    expect(
      narrationAutoFollowRemainingHold(
        now: now,
        holdUntil: now.subtract(const Duration(milliseconds: 1)),
      ),
      Duration.zero,
    );
    expect(
      narrationAutoFollowRemainingHold(now: now, holdUntil: null),
      Duration.zero,
    );
  });
}
