import 'package:flutter/foundation.dart';

/// Prevents a restored discovery narration from entering a false "playing"
/// state when browser speech has lost the original user gesture during route
/// navigation from the passport.
@immutable
class PassportNarrationResumeDecision {
  const PassportNarrationResumeDecision({
    required this.preparePaused,
    required this.requireUserResume,
  });

  final bool preparePaused;
  final bool requireUserResume;
}

PassportNarrationResumeDecision resolvePassportNarrationResume({
  required bool enteredFromPassport,
  required int journeyStep,
  required int savedOffset,
}) {
  final resumesDiscovery =
      enteredFromPassport && journeyStep == 2 && savedOffset > 0;

  return PassportNarrationResumeDecision(
    preparePaused: resumesDiscovery,
    requireUserResume: resumesDiscovery,
  );
}
