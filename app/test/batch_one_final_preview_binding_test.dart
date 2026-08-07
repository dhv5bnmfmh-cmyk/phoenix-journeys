import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/batch_one_journey_remediation.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';

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
      expect(
        content.storyParagraphs.length,
        level <= 2 ? 1 : 2,
        reason: 'Lv$level must use the normal Phoenix adaptive paragraph shape',
      );
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
      expect(
        content.storyParagraphs.every((paragraph) => paragraph.trim().isNotEmpty),
        isTrue,
      );
      expect(
        content.storyParagraphs.join('\n\n'),
        forbiddenCityLockedStories[level - 1],
        reason: 'Lv$level paragraph structure must preserve the locked adaptive Story text',
      );
    }
  });

  test('final preview binds Shanghai Bund to its Lv1-Lv10 runtime', () {
    expect(isBatchOneGoldJourney('shanghai-bund'), isTrue);
    final bund = batchOneRemediationFor('shanghai-bund');
    expect(bund, isNotNull);
    expect(bund!.levels, hasLength(10));
    expect(bund.protagonist, contains('陆潮'));
    for (var level = 1; level <= 10; level++) {
      final content = batchOneJourneyLevelContentFor('shanghai-bund', level);
      expect(content, isNotNull);
      expect(content!.storyParagraphs.join(), contains('陆潮'));
    }
    expect(batchOneMemorySpecFor('shanghai-bund'), isNotNull);
  });
}
