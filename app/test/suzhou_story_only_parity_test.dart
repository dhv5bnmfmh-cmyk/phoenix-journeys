import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  final suzhou = dailyJourneyExperiences.firstWhere(
    (journey) => journey.id == 'suzhou-humble-administrators-garden',
  );

  test('Suzhou keeps the pre-change Phoenix product identity and bindings', () {
    expect(suzhou.id, 'suzhou-humble-administrators-garden');
    expect(suzhou.city, '苏州');
    expect(suzhou.cityCode, 'SZV');
    expect(suzhou.place, '拙政园');
    expect(suzhou.appBarTitle, '苏州 · 拙政园');
    expect(suzhou.distanceLabel, '1,820 km');
    expect(suzhou.stampSymbol, '园');
    expect(
      suzhou.content.geoNodeId,
      'cn-jiangsu-suzhou-gusu-humble-administrators-garden',
    );
    expect(
      suzhou.content.tags,
      orderedEquals(const ['苏州', '拙政园', '古典园林', '借景', '世界遗产']),
    );
    expect(suzhou.words.map((word) => word.word), orderedEquals(const [
      '园林',
      '亭子',
      '漏窗',
      '长廊',
      '借景',
      '池水',
      '曲桥',
      '山水画',
      '层次',
      '外婆',
      '自己',
      '转弯',
      '消失',
      '视线',
      '抬起',
      '水面',
      '回头',
      '追上',
      '遮挡',
      '世界遗产',
      '保护',
    ]));
    expect(suzhou.discoveries, hasLength(10));
  });

  test('Founder-visible Lv1 Lv5 Lv10 use the new Story through the original runtime', () {
    for (final level in const [1, 5, 10]) {
      final profile = levelAgent.allProfiles.firstWhere(
        (profile) => profile.phoenixLevel == level,
      );
      final content = resolveAdaptiveJourneyLevel(
        suzhou,
        profile: profile,
      );
      final story = content.storyParagraphs.join();

      expect(story, contains('程朗'), reason: 'Lv$level must use the new Story');
      expect(story, contains('陈玉兰'), reason: 'Lv$level must use the new Story');
      expect(
        story,
        isNot(contains('清晨，你走进苏州拙政园')),
        reason: 'Lv$level must not fall back to the rejected generic opening',
      );
      expect(story, isNot(contains('顾澄')), reason: 'Lv$level old protagonist');
      expect(story, isNot(contains('周屿')), reason: 'Lv$level old supporting character');
      expect(story, isNot(contains('四折')), reason: 'Lv$level old artifact');
    }
  });

  test('higher Founder levels preserve the decisive action and ending', () {
    for (final level in const [5, 10]) {
      final profile = levelAgent.allProfiles.firstWhere(
        (profile) => profile.phoenixLevel == level,
      );
      final story = resolveAdaptiveJourneyLevel(
        suzhou,
        profile: profile,
      ).storyParagraphs.join();

      expect(
        story.contains('没有喊') || story.contains('却没有喊'),
        isTrue,
        reason: 'Lv$level must preserve the second-occlusion choice',
      );
      expect(
        story,
        contains('下一处等我'),
        reason: 'Lv$level must preserve the relationship response',
      );
    }
  });
}
