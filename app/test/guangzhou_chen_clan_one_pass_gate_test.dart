import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/extended_journey_catalog.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

void main() {
  final experience = extendedJourneyExperiences.singleWhere(
    (item) => item.id == guangzhouChenClanJourneyId,
  );

  test('Guangzhou exposes exactly ten canonical Gold levels', () {
    expect(guangzhouChenClanOnePassLevels, hasLength(10));
    expect(guangzhouChenClanCanonicalTitle, '纸桥');
    expect(guangzhouChenClanMemoryAnchor, '纸桥');
    expect(guangzhouChenClanChallengeSpecs, hasLength(30));
    expect(guangzhouChenClanDiscoverySpecs, hasLength(10));
    expect(guangzhouChenClanReflectionPrompts, hasLength(10));
    expect(guangzhouChenClanWritingPrompts, hasLength(10));
  });

  test('every level keeps the full material-translation causal contract', () {
    for (var level = 1; level <= 10; level++) {
      final story = guangzhouChenClanOnePassLevels[level - 1].storyParagraphs.join();
      expect(story, contains('梁遥'), reason: 'Lv$level protagonist');
      expect(story, contains('二十二岁'), reason: 'Lv$level age');
      expect(story, contains('贺真'), reason: 'Lv$level peer');
      expect(story, contains('陈家祠'), reason: 'Lv$level cultural anchor');
      expect(story, contains('原型'), reason: 'Lv$level prototype');
      expect(story, anyOf(contains('断开'), contains('散开')), reason: 'Lv$level physical failure');
      expect(story, contains('纸桥'), reason: 'Lv$level enacted choice');
      expect(story, anyOf(contains('第二张'), contains('第二件'), contains('第二个')), reason: 'Lv$level revised prototype');
      expect(story, anyOf(contains('提起'), contains('拿起')), reason: 'Lv$level physical climax');
      expect(story, anyOf(contains('认出'), contains('识别'), contains('指出')), reason: 'Lv$level peer legibility test');
      expect(
        story,
        anyOf(
          contains('翻译'),
          contains('改对'),
          contains('改变编码'),
          contains('编码改变'),
          contains('改变表达方式'),
          contains('改变连接'),
        ),
        reason: 'Lv$level transformation/consequence',
      );
      expect(story, contains('工作室'), reason: 'Lv$level action ending');
      expect(
        story,
        anyOf(
          contains('新材料'),
          contains('版材'),
          contains('新的版材'),
          contains('另一种版画材料'),
        ),
        reason: 'Lv$level next material study',
      );
      expect(story, isNot(contains(guangzhouChenClanLegacyOpening)), reason: 'Lv$level legacy opening retired');
      expect(story, isNot(contains(guangzhouChenClanLegacyMetaphor)), reason: 'Lv$level legacy metaphor retired');
    }
  });

  test('Lv9/Lv10 reader Story excludes semantic-governance meta language', () {
    final advancedStory = <String>[
      ...guangzhouChenClanOnePassLevels[8].storyParagraphs,
      ...guangzhouChenClanOnePassLevels[9].storyParagraphs,
    ].join();
    const forbiddenMeta = <String>[
      '历史证据',
      '重新分类',
      '历史解释',
      '导师',
      '妥协',
      '改分类',
      '故意残缺',
    ];
    for (final phrase in forbiddenMeta) {
      expect(advancedStory, isNot(contains(phrase)), reason: phrase);
    }
    expect(advancedStory, contains('把断开的几片重新并在桌上'));
    expect(advancedStory, contains('把草图扣在桌面，只看成品'));
    expect(advancedStory, contains('纸桥改变了局部轮廓'));
  });

  test('Story explicitly avoids heritage-surface contact', () {
    final story = guangzhouChenClanOnePassLevels.expand((item) => item.storyParagraphs).join();
    const forbiddenContact = <String>[
      '在文物上描',
      '把纸贴在文物',
      '把纸贴到历史装饰',
      '在历史表面拓印',
      '对历史装饰拓印',
      '切割建筑',
      '在雕刻上切',
    ];
    for (final phrase in forbiddenContact) {
      expect(story, isNot(contains(phrase)), reason: phrase);
    }
    expect(story, contains('所有试切都在自己的材料上完成'));
  });

  test('Story stays making-led while Discovery carries factual craft breadth', () {
    final story = guangzhouChenClanOnePassLevels.expand((item) => item.storyParagraphs).join();
    final discovery = guangzhouChenClanOnePassDiscoveries.map((item) => item.text).join();
    expect(story, contains('纸桥'));
    expect(story, contains('梁遥'));
    expect(discovery, isNot(contains('梁遥')));
    expect(discovery, isNot(contains('贺真')));
    expect(discovery, isNot(contains('纸桥')));
    for (final craft in const ['木雕', '砖雕', '石雕', '陶塑', '灰塑', '铸造', '彩绘']) {
      expect(discovery, contains(craft), reason: 'Discovery factual craft: $craft');
    }
  });

  test('Words are curated in Story context and provenance is truthful', () {
    final stories = <String>[
      for (final level in guangzhouChenClanOnePassLevels)
        level.storyParagraphs.join(),
    ];
    final allStory = stories.join('\n');
    for (var level = 1; level <= 10; level++) {
      final content = guangzhouChenClanOnePassLevelContent(level);
      final story = content.storyParagraphs.join();
      expect(content.words.map((word) => word.word).toSet(), hasLength(content.words.length));
      for (final word in content.words) {
        expect(story, contains(word.word), reason: 'Lv$level ${word.word}');
        expect(guangzhouChenClanWordFirstAppears[word.word], lessThanOrEqualTo(level));
      }
    }
    for (final word in guangzhouChenClanOnePassWords) {
      final observedFirstLevel = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(observedFirstLevel, greaterThan(0), reason: '${word.word} must occur in Story');
      expect(
        guangzhouChenClanWordFirstAppears[word.word],
        observedFirstLevel,
        reason: '${word.word} exact Story first appearance',
      );
    }
    for (final trace in guangzhouChenClanWordTraces) {
      expect(trace.sourceText, contains(trace.word), reason: trace.word);
      expect(allStory, contains(trace.sourceText), reason: trace.word);
    }
  });

  test('Memory, completion, reflection and writing stay synchronized', () {
    expect(guangzhouChenClanMemory, hasLength(3));
    final memoryPayload = guangzhouChenClanMemory
        .map((item) => '${item.prompt}${item.answer}')
        .join();
    expect(memoryPayload, contains('纸桥'));
    expect(guangzhouChenClanCompletion.memoryAnchor, '纸桥');
    expect(guangzhouChenClanCompletion.journeySummary, contains('第二件单张纸'));
    for (var level = 1; level <= 10; level++) {
      final content = guangzhouChenClanOnePassLevelContent(level);
      expect(content.wonderQuestion, contains('纸桥'));
      expect(content.expressQuestion, contains('第一件断开'));
    }
  });

  test('runtime difficulty mapping resolves Guangzhou to Lv1 Lv5 Lv10', () {
    expect(
      resolveJourneyLevel(experience, JourneyDifficulty.easy).storyParagraphs,
      guangzhouChenClanOnePassLevels[0].storyParagraphs,
    );
    expect(
      resolveJourneyLevel(experience, JourneyDifficulty.standard).storyParagraphs,
      guangzhouChenClanOnePassLevels[4].storyParagraphs,
    );
    expect(
      resolveJourneyLevel(experience, JourneyDifficulty.challenge).storyParagraphs,
      guangzhouChenClanOnePassLevels[9].storyParagraphs,
    );
  });

  test('legacy Guangzhou product identity and geo node remain stable', () {
    expect(experience.id, 'guangzhou-chen-clan-academy');
    expect(experience.city, '广州');
    expect(experience.cityCode, 'CAN');
    expect(experience.place, '陈家祠');
    expect(experience.content.geoNodeId, 'cn-guangdong-guangzhou-chen-clan');
    expect(guangzhouChenClanRemediatedJourney.id, experience.id);
  });
}
