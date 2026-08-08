import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/shanghai_bund_one_pass.dart';

void main() {
  test('final preview binds Forbidden City to the locked Shen Yan runtime', () {
    expect(forbiddenCityLockedStories, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final story = forbiddenCityLockedStories[level - 1];
      expect(story, contains('沈砚'));
      expect(story, isNot(contains('纪衡')));
      expect(story, isNot(contains('梁砚')));
    }
    expect(forbiddenCityMemoryAnchor, '一道没有跨过的门槛');
    expect(isBatchOneGoldJourney(forbiddenCityJourneyId), isFalse);
    expect(batchOneMemorySpecFor(forbiddenCityJourneyId), isNull);
  });

  test('Forbidden City review levels expose the normal Phoenix paragraph shape', () {
    for (final level in <int>[1, 5, 10]) {
      final content = forbiddenCityLevelContent(level);
      expect(content.storyParagraphs.length, level <= 2 ? 1 : 2);
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
      expect(content.storyParagraphs.join('\n\n'), forbiddenCityLockedStories[level - 1]);
    }
  });

  test('final preview binds Shanghai Bund to the one-pass Lv1-Lv10 package', () {
    expect(isBatchOneGoldJourney(shanghaiBundJourneyId), isTrue);
    expect(shanghaiBundOnePassRemediation.levels, hasLength(10));
    expect(shanghaiBundOnePassRemediation.protagonist, contains('林岸'));
    expect(shanghaiBundOnePassRemediation.title, contains('过江之前'));
    final canonical = <String>[];
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassRemediation.levelContent(level);
      final story = content.storyParagraphs.join();
      canonical.add(story);
      expect(content.storyParagraphs.length, level <= 2 ? 1 : 2);
      expect(story, contains('林岸'));
      expect(story, contains('外滩'));
      expect(story, contains('陆家嘴'));
      expect(story, isNot(contains('陆潮')));
      expect(story, isNot(contains('九点半')));
      expect(story, isNot(contains('赞助动画')));
      expect(story, isNot(contains('直播断线')));
    }
    expect(canonical.join(), contains('黄浦江'));
    expect(batchOneMemorySpecFor(shanghaiBundJourneyId), isNotNull);
  });
}
