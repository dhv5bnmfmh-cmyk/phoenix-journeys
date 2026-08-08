import '../widgets/living_story_scene.dart';
import 'forbidden_city_story_scenes.dart';

/// Shared location/variant registry. Adding a future story variant does not
/// change the shared Journey screen or narration runtime.
StorySceneVariant? storySceneVariantFor(
  String locationId, {
  String variantId = 'canonical-001',
}) {
  return switch ((locationId, variantId)) {
    ('beijing-forbidden-city', 'canonical-001') =>
      forbiddenCityCanonicalStoryVariant,
    _ => null,
  };
}
