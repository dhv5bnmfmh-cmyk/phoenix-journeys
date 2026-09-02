import '../data/adaptive_journey_level_runtime.dart';
import '../data/daily_journey_catalog.dart';
import '../models/journey_prepared_bundle.dart';
import '../models/language_proficiency.dart';

class JourneyPreparationCoordinator {
  JourneyPreparationCoordinator._();

  static final JourneyPreparationCoordinator instance =
      JourneyPreparationCoordinator._();

  final Map<JourneyPreparationKey, JourneyPreparedBundle> _bundles = {};
  final Map<JourneyPreparationKey, Future<JourneyPreparedBundle>> _inFlight = {};

  JourneyPreparationKey keyFor({
    required String journeyId,
    required ChineseProficiencyProfile profile,
    required String scriptMode,
  }) =>
      JourneyPreparationKey(
        journeyId: journeyId,
        phoenixLevel: profile.phoenixLevel ?? 1,
        scriptMode: scriptMode,
      );

  JourneyPreparedBundle? prepared({
    required String journeyId,
    required ChineseProficiencyProfile profile,
    required String scriptMode,
  }) =>
      _bundles[keyFor(
        journeyId: journeyId,
        profile: profile,
        scriptMode: scriptMode,
      )];

  JourneyPreparedBundle prepareNow({
    required String journeyId,
    required ChineseProficiencyProfile profile,
    required String scriptMode,
    Set<String> knownWords = const {},
  }) {
    final key = keyFor(
      journeyId: journeyId,
      profile: profile,
      scriptMode: scriptMode,
    );
    return _bundles.putIfAbsent(key, () {
      final content = resolveAdaptiveJourneyLevel(
        requireDailyJourneyExperience(journeyId),
        profile: profile,
        knownWords: knownWords,
      );
      final paragraphs = List<String>.unmodifiable(content.storyParagraphs);
      return JourneyPreparedBundle(
        key: key,
        levelContent: content,
        narrationItems: paragraphs,
        challengeSourceMaterial: paragraphs,
        layoutMetadata: JourneyLayoutMetadata(
          storyCharacterCount:
              paragraphs.fold(0, (total, value) => total + value.length),
        ),
      );
    });
  }

  Future<JourneyPreparedBundle> prepare({
    required String journeyId,
    required ChineseProficiencyProfile profile,
    required String scriptMode,
    Set<String> knownWords = const {},
  }) {
    final key = keyFor(
      journeyId: journeyId,
      profile: profile,
      scriptMode: scriptMode,
    );
    final cached = _bundles[key];
    if (cached != null) return Future.value(cached);
    return _inFlight.putIfAbsent(
      key,
      () => Future<JourneyPreparedBundle>.sync(
        () => prepareNow(
          journeyId: journeyId,
          profile: profile,
          scriptMode: scriptMode,
          knownWords: knownWords,
        ),
      ).whenComplete(() {
        _inFlight.remove(key);
      }),
    );
  }

  void clearForTesting() {
    _bundles.clear();
    _inFlight.clear();
  }
}
