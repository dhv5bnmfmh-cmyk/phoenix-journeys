import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/services/narration_follow_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('remaining hold reports only future time', () {
    final now = DateTime(2026, 7, 29, 12);
    expect(
      narrationAutoFollowRemainingHold(
        now: now,
        holdUntil: now.add(const Duration(milliseconds: 2400)),
      ),
      const Duration(milliseconds: 2400),
    );
    expect(
      narrationAutoFollowRemainingHold(
        now: now,
        holdUntil: now.subtract(const Duration(milliseconds: 1)),
      ),
      Duration.zero,
    );
  });

  test('one narration controller owns one shared follow coordinator', () {
    final controller = NarrationController();
    final first = NarrationFollowCoordinator.forController(controller);
    final second = NarrationFollowCoordinator.forController(controller);

    expect(identical(first, second), isTrue);
  });

  test('manual follow hold can be resumed immediately', () {
    final controller = NarrationController();
    final coordinator = NarrationFollowCoordinator.forController(controller);

    coordinator.suspend();
    expect(coordinator.isManualHoldActive, isTrue);

    coordinator.resume();
    expect(coordinator.isManualHoldActive, isFalse);
    expect(coordinator.remainingHold, Duration.zero);
  });
}
