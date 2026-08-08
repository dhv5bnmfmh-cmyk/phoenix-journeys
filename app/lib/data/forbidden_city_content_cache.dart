import 'forbidden_city_journey_runtime.dart';
import 'journey_level_catalog.dart';

/// Immutable Lv1-Lv10 content snapshots for the Forbidden City Journey.
///
/// The legacy content builder remains available to import/quality tests, but
/// normal Journey UI code must consume these snapshots so annotation Pinyin,
/// vocabulary filtering, discovery selection, and level assembly never run on
/// narration progress rebuilds.
final List<JourneyLevelContent> _forbiddenCityLevelSnapshots =
    List<JourneyLevelContent>.generate(10, (index) {
  final base = forbiddenCityLevelContent(index + 1);
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(base.storyParagraphs),
    storyAnnotations: List.unmodifiable(base.storyAnnotations),
    words: List.unmodifiable(base.words),
    discoveries: List.unmodifiable(base.discoveries),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}, growable: false);

/// Initializes every Forbidden City content snapshot once, outside narration
/// animation. Calling this repeatedly is O(1) after the first initialization.
void warmForbiddenCityContentCache() {
  _forbiddenCityLevelSnapshots.length;
}

JourneyLevelContent cachedForbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return _forbiddenCityLevelSnapshots[safeLevel - 1];
}
