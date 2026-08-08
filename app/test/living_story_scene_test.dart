import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_scenes.dart';
import 'package:phoenix_journeys/data/story_scene_catalog.dart';
import 'package:phoenix_journeys/widgets/living_story_scene.dart';

void main() {
  test('scene cues are stable immutable location-variant data', () {
    final first = forbiddenCityStoryVariantForLevel(5).cues;
    final second = forbiddenCityStoryVariantForLevel(5).cues;
    expect(identical(first, second), isTrue);
    expect(first, hasLength(9));
    expect(first.map((cue) => cue.scene.assetPath).toSet(), hasLength(7));
  });

  test('per-level timelines are cached and follow story-specific anchors', () {
    final lv1 = storySceneVariantFor('beijing-forbidden-city', level: 1)!;
    final lv10 = storySceneVariantFor('beijing-forbidden-city', level: 10)!;
    expect(
        identical(
            lv1, storySceneVariantFor('beijing-forbidden-city', level: 1)),
        isTrue);
    expect(lv1.level, 1);
    expect(lv10.level, 10);
    expect(
      lv1.cues.map((cue) => cue.progress),
      isNot(equals(lv10.cues.map((cue) => cue.progress))),
    );
    for (final variant in forbiddenCityStoryVariantsByLevel) {
      for (var index = 1; index < variant.cues.length; index += 1) {
        expect(variant.cues[index].progress,
            greaterThan(variant.cues[index - 1].progress));
      }
    }
  });

  test('scene enhancement is optional and threshold choreography stops', () {
    expect(storySceneVariantFor('beijing-summer-palace'), isNull);
    final threshold = forbiddenCityCanonicalStoryVariant.cues
        .firstWhere((cue) => cue.scene.id == 'threshold-stillness')
        .scene;
    expect(threshold.narrativeTravel, Offset.zero);
    expect(threshold.ambientStrength, lessThan(.1));
  });

  test('director notifies only after a cue boundary is crossed', () {
    final director = StorySceneDirector(forbiddenCityCanonicalStoryVariant);
    var transitions = 0;
    director.addListener(() => transitions += 1);
    final firstBoundary = forbiddenCityCanonicalStoryVariant.cues[1].progress;
    final secondBoundary = forbiddenCityCanonicalStoryVariant.cues[2].progress;

    expect(director.handleProgress(firstBoundary * .25), isFalse);
    expect(director.handleProgress(firstBoundary - .001), isFalse);
    expect(transitions, 0);
    expect(director.handleProgress(firstBoundary), isTrue);
    expect(transitions, 1);
    expect(
      director.handleProgress((firstBoundary + secondBoundary) / 2),
      isFalse,
    );
    expect(transitions, 1);
    director.dispose();
  });

  test('debug cue transition uses the same shared director', () {
    final director = StorySceneDirector(forbiddenCityCanonicalStoryVariant);
    expect(director.showCue(6), isTrue);
    expect(director.scene.id, 'threshold-approach');
    expect(director.showCue(6), isFalse);
    director.dispose();
  });

  testWidgets('reduced motion keeps scene state and removes camera travel', (
    tester,
  ) async {
    final progress = ValueNotifier<double>(0);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: LivingStoryScene(
            variant: forbiddenCityCanonicalStoryVariant,
            progressListenable: progress,
            readProgress: () => progress.value,
          ),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('living-story-scene')), findsOneWidget);
    final openThresholdProgress = forbiddenCityCanonicalStoryVariant.cues
        .firstWhere((cue) => cue.scene.id == 'open-threshold')
        .progress;
    progress.value = openThresholdProgress + .001;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(
      find.byKey(const ValueKey('living-story-asset-open-threshold')),
      findsOneWidget,
    );
    final transforms = tester.widgetList<Transform>(find.byType(Transform));
    expect(
      transforms.where(
        (transform) => transform.transform.getTranslation().x != 0,
      ),
      isEmpty,
    );
    progress.dispose();
  });
}
