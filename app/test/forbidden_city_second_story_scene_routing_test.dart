import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';

void main() {
  test('Second Story Lv5 presentation keeps seven beats internal and exposes two paragraphs', () {
    final content = forbiddenCitySecondStoryLevelContent();
    expect(content.storyParagraphs, hasLength(2));
    expect(content.storyParagraphs.join().length, inInclusiveRange(280, 400));
    final sentenceLengths = content.storyParagraphs
        .expand((paragraph) => paragraph.split(RegExp(r'[。！？]')))
        .map((sentence) => sentence.trim().length)
        .where((length) => length > 0);
    expect(sentenceLengths.every((length) => length <= 30), isTrue);
  });

  test('Second Story narration uses independent Story scene routing', () {
    final content = forbiddenCitySecondStoryLevelContent();
    expect(
      resolveForbiddenCityStorySceneId(
        isSecondStory: true,
        level: 5,
        paragraphs: content.storyParagraphs,
        paragraphIndex: 1,
        characterOffset: 24,
      ),
      forbiddenCitySceneForStage('story').sceneId,
    );
  });
}
