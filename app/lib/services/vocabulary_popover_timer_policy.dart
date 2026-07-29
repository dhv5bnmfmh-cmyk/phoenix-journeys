import 'dart:async';

const Duration legacyInlineVocabularyPopoverDuration = Duration(
  milliseconds: 3200,
);
const Duration readableInlineVocabularyPopoverDuration = Duration(seconds: 12);

Duration resolvePhoenixTimerDuration(Duration requested) {
  if (requested == legacyInlineVocabularyPopoverDuration) {
    return readableInlineVocabularyPopoverDuration;
  }
  return requested;
}

R runWithPhoenixTimerPolicy<R>(R Function() body) {
  return runZoned(
    body,
    zoneSpecification: ZoneSpecification(
      createTimer: (self, parent, zone, duration, callback) {
        return parent.createTimer(
          zone,
          resolvePhoenixTimerDuration(duration),
          callback,
        );
      },
    ),
  );
}
