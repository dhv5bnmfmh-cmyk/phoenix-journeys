import 'forbidden_city_discovery_curriculum.dart';
import 'forbidden_city_journey_runtime.dart';
import 'forbidden_city_story_annotation_support.dart';
import 'journey_level_catalog.dart';

/// Immutable Lv1-Lv10 content snapshots for the Forbidden City Journey.
///
/// The legacy content builder remains available to import/quality tests, but
/// normal Journey UI code must consume these snapshots so annotation Pinyin,
/// vocabulary filtering, discovery selection, and level assembly never run on
/// narration progress rebuilds.
final List<JourneyLevelContent?> _forbiddenCityLevelSnapshots =
    List<JourneyLevelContent?>.filled(10, null, growable: false);

JourneyLevelContent _buildForbiddenCityLevelSnapshot(int level) {
  final base = forbiddenCityLevelContent(level);
  final paragraphs = List<String>.unmodifiable(base.storyParagraphs);
  return JourneyLevelContent(
    storyParagraphs: paragraphs,
    storyAnnotations: List.unmodifiable(
      forbiddenCityStoryAnnotationsForCurrentParagraphs(
        level: level,
        paragraphs: paragraphs,
      ),
    ),
    words: List.unmodifiable(base.words),
    discoveries: List.unmodifiable(
      forbiddenCityDiscoveryCurriculumForLevel(level),
    ),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

/// Initializes every Forbidden City content snapshot once, outside narration
/// animation. Calling this repeatedly is O(1) after the first initialization.
void warmForbiddenCityContentCache() {
  for (var level = 1; level <= 10; level += 1) {
    cachedForbiddenCityLevelContent(level);
  }
}

JourneyLevelContent cachedForbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return _forbiddenCityLevelSnapshots[safeLevel - 1] ??=
      _buildForbiddenCityLevelSnapshot(safeLevel);
}
