import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/passport_narration_resume_policy.dart';

void main() {
  test('passport discovery resume requires explicit user playback', () {
    final decision = resolvePassportNarrationResume(
      enteredFromPassport: true,
      journeyStep: 2,
      savedOffset: 48,
    );

    expect(decision.preparePaused, isTrue);
    expect(decision.requireUserResume, isTrue);
  });

  test('fresh discovery entry keeps normal autoplay path', () {
    final decision = resolvePassportNarrationResume(
      enteredFromPassport: true,
      journeyStep: 2,
      savedOffset: 0,
    );

    expect(decision.preparePaused, isFalse);
    expect(decision.requireUserResume, isFalse);
  });

  test('non-discovery steps are unaffected', () {
    final decision = resolvePassportNarrationResume(
      enteredFromPassport: true,
      journeyStep: 1,
      savedOffset: 48,
    );

    expect(decision.preparePaused, isFalse);
    expect(decision.requireUserResume, isFalse);
  });
}
