import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

int _occurrences(String value, String needle) {
  var count = 0;
  var start = 0;
  while (true) {
    final index = value.indexOf(needle, start);
    if (index < 0) return count;
    count++;
    start = index + needle.length;
  }
}

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
    expect(suzhou.discoveries, hasLength(26));
  });

  test('Founder-locked four Story paragraphs remain byte-for-byte unchanged', () {
    expect(
      suzhou.content.sections.map((section) => section.text),
      orderedEquals(const [
        '下周一，十二岁的程朗要开始自己坐车去初中。六年来，外婆陈玉兰几乎每天都去接他放学；这个星期天，她带他来到拙政园，程朗第一次认真提出：“今天让我走前面吧，我在下一处等你。”陈玉兰看了他一眼，只说：“别走太快。”',
        '沿着池水转过长廊，亭子、白墙和树影叠得像一幅被墙角切开的山水画。程朗的背影第一次从她眼前消失时，陈玉兰立刻喊了他的名字。程朗从转角退回来，没有争辩，只把脚步放慢了一点。',
        '再往前走，曲桥和屋角又一次截断视线，廊下的人声盖住了程朗的脚步声。陈玉兰抬起手，他的名字已经到了嘴边，却没有喊；她把手放下来，自己走完那几步看不见他的路。',
        '下一处水面重新打开时，程朗已经停在前面，正回头找她。他问：“外婆，我还能走前面吗？”陈玉兰把肩上的水壶带往上提了提，说：“下一处等我。”程朗转过去，背影很快又被房屋挡住。陈玉兰没有追上去。',
      ]),
    );
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

  test('Lv3 Lv4 Lv5 add distinct Story-understanding deltas without changing the spine', () {
    final byLevel = <int, String>{};

    for (final level in const [3, 4, 5]) {
      final profile = levelAgent.allProfiles.firstWhere(
        (profile) => profile.phoenixLevel == level,
      );
      final content = resolveAdaptiveJourneyLevel(
        suzhou,
        profile: profile,
      );
      final story = content.storyParagraphs.join();
      byLevel[level] = story;

      expect(story, contains('程朗'));
      expect(story, contains('陈玉兰'));
      expect(story, contains('没有喊'));
      expect(story, contains('下一处等我'));
      expect(story, contains('没有追'));
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (final annotation in content.storyAnnotations) {
        expect(annotation.pinyin, isNotEmpty);
        expect(annotation.vietnamese, isNotEmpty);
        expect(annotation.english, isNotEmpty);
      }
    }

    expect(byLevel[3], isNot(equals(byLevel[4])));
    expect(byLevel[4], isNot(equals(byLevel[5])));
    expect(byLevel[3], contains('白墙和树影把前后的视线分成一段一段'));
    expect(byLevel[4], contains('看不见他的几步，仍在同一条向前的路上'));
    expect(byLevel[5], contains('外婆，我还能走前面吗'));
  });

  test('Lv6-Lv10 add one new understanding each without duplicate event rendering', () {
    final byLevel = <int, String>{};
    const scaffoldChinese = [
      '已经说出的事实',
      '这意味着',
      '这说明',
      '这一层',
      '前面的情节',
      '读者可以',
      '可以理解为',
      '表现了',
      '体现了',
    ];
    const scaffoldSupport = [
      'facts the two have spoken aloud',
      'have all been stated',
      'this means',
      'shows that',
      'reader can',
      'đều là những điều hai người đã nói',
      'đều đã được nói ra',
      'điều này có nghĩa',
      'cho thấy',
      'người đọc',
    ];

    for (final level in const [6, 7, 8, 9, 10]) {
      final profile = levelAgent.allProfiles.firstWhere(
        (profile) => profile.phoenixLevel == level,
      );
      final content = resolveAdaptiveJourneyLevel(suzhou, profile: profile);
      final story = content.storyParagraphs.join();
      final support = content.storyAnnotations
          .map((annotation) => '${annotation.vietnamese} ${annotation.english}')
          .join(' ')
          .toLowerCase();
      byLevel[level] = story;

      expect(_occurrences(story, '别走太快'), 1, reason: 'Lv$level dialogue');
      expect(_occurrences(story, '喊了他的名字'), 1, reason: 'Lv$level first call');
      expect(
        _occurrences(story, '外婆，我还能走前面吗'),
        1,
        reason: 'Lv$level agency question',
      );
      expect(_occurrences(story, '下一处等我'), 1, reason: 'Lv$level ending reply');
      expect(_occurrences(story, '没有追上去'), 1, reason: 'Lv$level final action');
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (final annotation in content.storyAnnotations) {
        expect(annotation.pinyin, isNotEmpty);
        expect(annotation.vietnamese, isNotEmpty);
        expect(annotation.english, isNotEmpty);
      }
      for (final forbidden in scaffoldChinese) {
        expect(story, isNot(contains(forbidden)), reason: 'Lv$level $forbidden');
      }
      for (final forbidden in scaffoldSupport) {
        expect(support, isNot(contains(forbidden.toLowerCase())),
            reason: 'Lv$level support $forbidden');
      }
    }

    expect(byLevel[6], contains('那一声把已经转过墙角的程朗叫了回来'));
    expect(byLevel[7], contains('这一次，她没有出声'));
    expect(byLevel[8], contains('程朗没有继续往远处走'));
    expect(byLevel[9], contains('陈玉兰没有让他退回来'));
    expect(byLevel[10], contains('陈玉兰看不见他，也听不清他走到哪里'));
    expect(byLevel[10], endsWith('廊下的人声仍在。陈玉兰没有追上去。'));

    for (var level = 6; level <= 10; level++) {
      expect(
        byLevel[level],
        isNot(equals(byLevel[level - 1])),
        reason: 'Lv${level - 1} -> Lv$level must add Story understanding',
      );
    }
  });
}
