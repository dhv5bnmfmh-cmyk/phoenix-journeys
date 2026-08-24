import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_cache.dart';
import 'package:phoenix_journeys/data/forbidden_city_discovery_curriculum.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

Set<String> _semanticBigrams(String story) {
  var text = story;
  for (final invariant in <String>[
    '沈砚',
    '阿宁',
    '周师傅',
    '紫禁城',
    '午门',
    '中轴',
    '乾清门',
    '路线',
  ]) {
    text = text.replaceAll(invariant, '');
  }
  text = text.replaceAll(
    RegExp(r'[\s，。！？；：“”‘’、（）《》·—…,.!?;:\-]'),
    '',
  );
  final result = <String>{};
  for (var index = 0; index + 2 <= text.length; index += 1) {
    result.add(text.substring(index, index + 2));
  }
  return result;
}

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
  final profiles = levelAgent.allProfiles.toList(growable: false)
    ..sort(
      (a, b) => (a.phoenixLevel ?? 0).compareTo(b.phoenixLevel ?? 0),
    );

  List<JourneyLevelContent> activeContents() => <JourneyLevelContent>[
        for (final profile in profiles)
          resolveAdaptiveJourneyLevel(journey, profile: profile),
      ];

  test('Founder revision keeps Story invariants and real adjacent-level deltas',
      () {
    final contents = activeContents();
    expect(contents, hasLength(10));
    final stories = <String>[
      for (final content in contents) content.storyParagraphs.join('\n\n'),
    ];

    for (var index = 0; index < stories.length; index += 1) {
      final level = index + 1;
      final story = stories[index];
      expect(story, contains('沈砚'), reason: 'Lv$level protagonist identity');
      expect(story, contains('阿宁'), reason: 'Lv$level relationship invariant');
      expect(story, contains('周师傅'), reason: 'Lv$level mentor function');
      expect(
        story.contains('路线') || story.contains('两条线'),
        isTrue,
        reason: 'Lv$level route conflict',
      );
      expect(
        story.contains('午门') || story.contains('中轴'),
        isTrue,
        reason: 'Lv$level Forbidden City spatial anchor',
      );
      expect(story, contains('乾清门'), reason: 'Lv$level shared node');
    }

    for (var index = 0; index < stories.length - 1; index += 1) {
      final current = _semanticBigrams(stories[index]);
      final next = _semanticBigrams(stories[index + 1]);
      final added = next.difference(current);
      final removed = current.difference(next);
      expect(
        added.length,
        greaterThanOrEqualTo(8),
        reason:
            'Lv${index + 1}→Lv${index + 2} must add semantic material, not only length',
      );
      expect(
        removed.length,
        greaterThanOrEqualTo(4),
        reason:
            'Lv${index + 1}→Lv${index + 2} must change understanding, not append a tail',
      );
    }
  });

  test('Vocabulary stays same-level sourced and changes selection or depth', () {
    final contents = activeContents();
    final signatures = <String>[];

    for (var index = 0; index < contents.length; index += 1) {
      final level = index + 1;
      final content = contents[index];
      final story = content.storyParagraphs.join('\n\n');
      final words = content.words;
      expect(words, isNotEmpty, reason: 'Lv$level Vocabulary');

      for (final word in words) {
        expect(
          story.contains(word.word),
          isTrue,
          reason: 'Lv$level same-level provenance: ${word.word}',
        );
        final source = word.studyExamples.first.chinese.replaceFirst(
          'Story 原句：',
          '',
        );
        expect(
          source.contains(word.word) && story.contains(source),
          isTrue,
          reason: 'Lv$level exact Story source: ${word.word}',
        );
        if (level <= 3) {
          expect(word.studyExamples[1].chinese, startsWith('意思：'));
        } else if (level <= 6) {
          expect(word.studyExamples[1].chinese, startsWith('搭配与语境：'));
        } else if (level <= 8) {
          expect(word.studyExamples[2].chinese, startsWith('对比：'));
        } else {
          expect(word.studyExamples[2].chinese, startsWith('对比：'));
          expect(word.studyExamples, hasLength(4));
          expect(word.studyExamples[3].chinese, startsWith('叙事功能：'));
        }
      }

      final signature = words.map((word) => word.word).toList(growable: false)
        ..sort();
      signatures.add(signature.join('|'));
    }

    expect(signatures.toSet(), hasLength(10));
    for (var index = 0; index < signatures.length - 1; index += 1) {
      expect(
        signatures[index],
        isNot(signatures[index + 1]),
        reason: 'Lv${index + 1}→Lv${index + 2} Vocabulary selection',
      );
    }
  });

  test('Discovery runtime exposes canonical 2-2-2-2-3-3-3-3-3-3 depth', () {
    final contents = activeContents();
    expect(
      forbiddenCityDiscoveryDepthByLevel,
      <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3],
    );

    for (var index = 0; index < contents.length; index += 1) {
      final level = index + 1;
      final expected = forbiddenCityDiscoveryDepthByLevel[index];
      final cached = cachedForbiddenCityLevelContent(level);
      final active = contents[index];
      expect(cached.discoveries, hasLength(expected), reason: 'Lv$level cache');
      expect(active.discoveries, hasLength(expected), reason: 'Lv$level adaptive');
      expect(
        active.discoveries.map((item) => item.text).toList(growable: false),
        cached.discoveries.map((item) => item.text).toList(growable: false),
        reason: 'Lv$level resolver must not drop Discovery entries',
      );
    }
  });

  test('Discovery adds fact-grounded knowledge instead of retelling Story', () {
    final contents = activeContents();
    final levelCorpora = <String>[];
    const anchors = <String>[
      '午门',
      '中轴',
      '太和门',
      '乾清门',
      '景运门',
      '隆宗门',
      '外朝',
      '内廷',
      '宫门',
      '广场',
    ];

    for (var index = 0; index < contents.length; index += 1) {
      final level = index + 1;
      final content = contents[index];
      final story = content.storyParagraphs.join('\n\n');
      final discoveryTexts = <String>[
        for (final item in content.discoveries) item.text,
      ];
      expect(discoveryTexts.toSet(), hasLength(discoveryTexts.length));

      for (final text in discoveryTexts) {
        expect(text, isNot(contains('沈砚')), reason: 'Lv$level no Story retell');
        expect(text, isNot(contains('阿宁')), reason: 'Lv$level no Story retell');
        expect(text, isNot(contains('周师傅')), reason: 'Lv$level no Story retell');
        expect(story.contains(text), isFalse, reason: 'Lv$level adds knowledge');
        final concreteGrounding = anchors.any(text.contains);
        final masteryTransferGrounding = level == 10 &&
            text.contains('故宫博物院') &&
            text.contains('建筑连接');
        expect(
          concreteGrounding || masteryTransferGrounding,
          isTrue,
          reason: 'Lv$level Discovery must remain Forbidden City grounded',
        );
      }

      final sharedAnchor = anchors.any(
        (anchor) =>
            story.contains(anchor) && discoveryTexts.any((text) => text.contains(anchor)),
      );
      expect(
        sharedAnchor,
        isTrue,
        reason: 'Lv$level Story→Discovery cultural/spatial linkage',
      );
      levelCorpora.add(discoveryTexts.join('|'));
    }

    expect(levelCorpora.toSet(), hasLength(10));
    for (var index = 0; index < levelCorpora.length - 1; index += 1) {
      expect(
        levelCorpora[index],
        isNot(levelCorpora[index + 1]),
        reason: 'Lv${index + 1}→Lv${index + 2} Discovery progression',
      );
    }
  });
}
