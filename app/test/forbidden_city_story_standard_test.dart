import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

List<String> _sentences(String story) => RegExp(r'[^。！？!?]+[。！？!?]')
    .allMatches(story)
    .map((match) => match.group(0)!.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

void main() {
  const agent = PhoenixLanguageLevelAgent();
  final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
  final profiles = agent.allProfiles.toList(growable: false)
    ..sort(
      (a, b) => (a.phoenixLevel ?? 0).compareTo(b.phoenixLevel ?? 0),
    );

  String activeStory(int level) {
    final profile =
        profiles.singleWhere((item) => item.phoenixLevel == level);
    return resolveAdaptiveJourneyLevel(journey, profile: profile)
        .storyParagraphs
        .join('\n\n');
  }

  test('Phoenix Lv1-Lv10 Story Standard is explicit and canonical', () {
    expect(forbiddenCityPhoenixLevelStandard.keys, orderedEquals(
      List<int>.generate(10, (index) => index + 1),
    ));

    final stories = <String>[for (var level = 1; level <= 10; level++) activeStory(level)];
    expect(stories.toSet(), hasLength(10));

    for (var level = 1; level <= 10; level++) {
      final story = stories[level - 1];
      for (final anchor in <String>[
        '沈砚',
        '阿宁',
        '周师傅',
        '午门',
        '中轴',
        '乾清门',
        '东侧',
      ]) {
        expect(story, contains(anchor), reason: 'Lv$level canonical anchor: $anchor');
      }
      expect(
        story.contains('路线') || story.contains('两条线'),
        isTrue,
        reason: 'Lv$level route mechanism',
      );
    }

    final lv1 = stories[0];
    final lv2 = stories[1];
    final lv5 = stories[4];
    final lv10 = stories[9];

    expect(_sentences(lv1).every((sentence) => _hanCount(sentence) <= 22), isTrue);
    expect(lv1, isNot(contains('证据')));
    expect(lv1, isNot(contains('约束')));
    expect(lv1, isNot(contains('权衡')));

    expect(_sentences(lv2).every((sentence) => _hanCount(sentence) <= 28), isTrue);
    expect(lv2, contains('所以'));
    expect(lv2, contains('任务'));

    expect(lv5, contains('标注'));
    expect(lv5, contains('证据'));
    expect(lv5, contains('判断'));

    expect(lv10, contains('建筑连接'));
    expect(lv10, contains('人物目标'));
    expect(lv10, contains('行动后果'));
    expect(lv10, contains('共同空间骨架'));
    expect(lv10, contains('成立条件'));

    expect(_hanCount(lv1), lessThan(_hanCount(lv5)));
    expect(_hanCount(lv5), lessThan(_hanCount(lv10)));
  });

  test('Story scene resolution follows semantic A-B-C-D anchors at every level', () {
    for (var level = 1; level <= 10; level++) {
      final profile =
          profiles.singleWhere((item) => item.phoenixLevel == level);
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final spans = forbiddenCityStorySceneSpans(
        level: level,
        paragraphs: content.storyParagraphs,
      );
      final sequence = <String>[];
      for (final span in spans) {
        if (sequence.isEmpty || sequence.last != span.sceneId) {
          sequence.add(span.sceneId);
        }
      }
      expect(
        sequence,
        orderedEquals(<String>['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D']),
        reason: 'Lv$level semantic Story→Scene order',
      );
    }
  });

  test('Journey stage backgrounds bind to the canonical scene world', () {
    expect(forbiddenCitySceneForStage('vocabulary').sceneId, 'FC01-B');
    expect(forbiddenCitySceneForStage('discovery').sceneId, 'FC01-C');
    expect(forbiddenCitySceneForStage('challenge').sceneId, 'FC01-D');
    expect(forbiddenCitySceneForStage('memory').sceneId, 'FC01-D');
    expect(forbiddenCitySceneForStage('completion').sceneId, 'FC01-D');

    for (final scene in forbiddenCityJourney01Scenes) {
      expect(File(scene.landscapeAsset).existsSync(), isTrue,
          reason: scene.landscapeAsset);
      expect(File(scene.portraitAsset).existsSync(), isTrue,
          reason: scene.portraitAsset);
    }
  });
}
