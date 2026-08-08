import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_scenes.dart';
import 'package:phoenix_journeys/data/story_scene_catalog.dart';
import 'package:phoenix_journeys/widgets/living_story_scene.dart';

void main() {
  test('scene cues are stable immutable location-variant data', () {
    final first = forbiddenCityCanonicalStoryVariant.cues;
    final second = forbiddenCityCanonicalStoryVariant.cues;
    expect(identical(first, second), isTrue);
    expect(first, hasLength(7));
    expect(first.map((cue) => cue.scene.assetPath).toSet(), hasLength(7));
  });

  test('scene enhancement is optional and threshold choreography is still', () {
    expect(storySceneVariantFor('beijing-summer-palace'), isNull);
    final threshold = forbiddenCityCanonicalStoryVariant.cues
        .firstWhere((cue) => cue.scene.id == 'open-threshold')
        .scene;
    expect(threshold.calm, isTrue);
    expect(threshold.cameraOffset, Offset.zero);
  });

  test('director notifies only after a cue boundary is crossed', () {
    final director = StorySceneDirector(forbiddenCityCanonicalStoryVariant);
    var transitions = 0;
    director.addListener(() => transitions += 1);

    expect(director.handleProgress(.02), isFalse);
    expect(director.handleProgress(.11), isFalse);
    expect(transitions, 0);
    expect(director.handleProgress(.12), isTrue);
    expect(transitions, 1);
    expect(director.handleProgress(.27), isFalse);
    expect(transitions, 1);
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
    progress.value = .74;
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
