import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_one_pass.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Nanjing Story obeys Lv1-Lv10 length and paragraph policy', () {
    expect(nanjingQinhuaiOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = nanjingQinhuaiOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      // ignore: avoid_print
      print(
        'NANJING_STORY_METRIC Lv$level characters=$characters paragraphs=${content.storyParagraphs.length}',
      );
      expect(
        characters,
        inInclusiveRange(
          target.acceptedMinimumCharacters,
          target.acceptedMaximumCharacters,
        ),
        reason: 'Lv$level accepted Story range',
      );
      expect(
        content.storyParagraphs.length,
        target.paragraphCount,
        reason: 'Lv$level paragraph count',
      );
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve one causal Nanjing lighting narrative spine', () {
    for (var level = 1; level <= 10; level++) {
      final story = nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>[
        '魏舟',
        '周工',
        '秦淮灯会',
        '秦淮河',
        '古桥',
        '七分钟',
        '照明',
        '通行',
        '装饰灯',
        '记录',
      ]) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(
        story.contains('故障') || story.contains('不亮'),
        isTrue,
        reason: 'Lv$level operational incident',
      );
      expect(
        story.contains('临时改线') ||
            story.contains('临时改变') ||
            story.contains('临时改动'),
        isTrue,
        reason: 'Lv$level tempting workaround',
      );
      expect(
        story.contains('黑着') ||
            story.contains('黑暗') ||
            story.contains('暗区') ||
            story.contains('暗口') ||
            story.contains('没有亮') ||
            story.contains('熄灭'),
        isTrue,
        reason: 'Lv$level visible decorative-light sacrifice',
      );
      expect(story, isNot(contains(nanjingQinhuaiLegacyOpening)));
      expect(story, isNot(contains('真正重要的不是')));
      expect(story, isNot(contains('这一刻，他终于明白')));
      expect(story, isNot(contains('秦淮河告诉他')));
    }
  });

  test('Lv1 remains a causal Story with person problem goal choice result', () {
    final story = nanjingQinhuaiOnePassLevels.first.storyParagraphs.single;
    expect(story, contains('魏舟'));
    expect(story, contains('七分钟'));
    expect(story, contains('不亮'));
    expect(story, contains('安全'));
    expect(story, contains('停下了手'));
    expect(story, contains('放弃一段装饰灯'));
    expect(story, contains('河边的路亮了'));
    expect(story, contains('仍然黑着'));
    expect(story, contains('记录交给魏舟'));
  });

  test('Lv10 remains event-driven and keeps the visible imperfect climax', () {
    final story = nanjingQinhuaiOnePassLevels.last.storyParagraphs.join();
    expect(story, contains('未经授权'));
    expect(story, contains('安全复核'));
    expect(story, contains('把临时改线从处理方案中删掉'));
    expect(story, contains('一段装饰灯明确保持关闭'));
    expect(story, contains('那一截黑暗始终留在夜景里'));
    expect(story, contains('开场按缩减配置继续'));
    expect(story, contains('最终灯光状态记录交给他'));
    expect(story, endsWith('魏舟接过记录，开始填写第一行。'));
  });

  test('mentor relationship causally changes from instruction waiting to ownership', () {
    for (var level = 1; level <= 10; level++) {
      final story = nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.join();
      expect(story, contains('周工'), reason: 'Lv$level mentor present');
      expect(
        story.contains('不能马上回来') ||
            story.contains('赶不过来') ||
            story.contains('无法赶回') ||
            story.contains('短时间内无法赶回') ||
            story.contains('不能马上回来') ||
            story.contains('正在上游') ||
            story.contains('另一处异常'),
        isTrue,
        reason: 'Lv$level mentor cannot make the choice',
      );
      expect(story, contains('记录'), reason: 'Lv$level responsibility transfer');
    }
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[
      for (final level in nanjingQinhuaiOnePassLevels)
        level.storyParagraphs.join(),
    ];
    expect(
      nanjingQinhuaiOnePassWords,
      hasLength(nanjingQinhuaiWordTraces.length),
    );
    expect(
      nanjingQinhuaiOnePassWords,
      hasLength(nanjingQinhuaiWordFirstAppears.length),
    );
    for (final word in nanjingQinhuaiOnePassWords) {
      final trace = nanjingQinhuaiWordTraces
          .singleWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(
        stories.any((story) => story.contains(trace.sourceText)),
        isTrue,
        reason: '${word.word} exact source',
      );
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(
        first,
        nanjingQinhuaiWordFirstAppears[word.word],
        reason: '${word.word} truthful first appearance',
      );
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.simpleChinese.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
  });

  test('Discovery is exactly one sourced level-bound item and not Story retelling', () {
    expect(nanjingQinhuaiDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = nanjingQinhuaiDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.sourceIds, const [nanjingQinhuaiSourceRecordId]);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.entry.text, isNot(contains('魏舟')));
      expect(spec.entry.text, isNot(contains('周工')));
      expect(spec.entry.text, isNot(contains('故障')));
      expect(spec.entry.pinyin.trim(), isNotEmpty);
      expect(spec.entry.vietnamese.trim(), isNotEmpty);
      expect(spec.entry.english.trim(), isNotEmpty);

      final resolved = nanjingQinhuaiOnePassLevelContent(level);
      expect(resolved.discoveries, hasLength(1));
      expect(identical(resolved.discoveries.single, spec.entry), isTrue);
    }
  });

  test('Challenge evidence is confined to each active level', () {
    const types = <String>{
      'paragraphRebuild',
      'grammarRepair',
      'missingSentence',
    };
    expect(nanjingQinhuaiChallengeSpecs, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = nanjingQinhuaiChallengeSpecs
          .where((item) => item.level == level)
          .toList(growable: false);
      expect(challenges.map((item) => item.type).toSet(), types);
      for (final challenge in challenges) {
        expect(challenge.prompt.trim(), isNotEmpty);
        expect(challenge.answer.trim(), isNotEmpty);
        expect(
          story,
          contains(challenge.anchor),
          reason: 'Lv$level ${challenge.type} active Story evidence',
        );
      }
    }
  });

  test('Memory and Complete preserve the distinctive dark-section image', () {
    final memory = nanjingQinhuaiMemory
        .map((item) => '${item.prompt}${item.answer}')
        .join();
    for (final anchor in <String>[
      '魏舟',
      '秦淮河',
      '古桥',
      '装饰灯',
      '黑着',
      '周工',
      '记录',
    ]) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(
      nanjingQinhuaiCompletion.memoryAnchor,
      nanjingQinhuaiMemoryAnchor,
    );
    expect(nanjingQinhuaiCompletion.journeySummary, contains('七分钟'));
    expect(nanjingQinhuaiCompletion.journeySummary, contains('拒绝未经确认'));
    expect(nanjingQinhuaiCompletion.journeyCompletion, contains('主要路线开放'));
    expect(nanjingQinhuaiCompletion.journeyCompletion, contains('暗段仍然保留'));
    expect(nanjingQinhuaiCompletion.journeyCompletion, contains('秦淮河仍有更多故事'));
    expect(nanjingQinhuaiCompletion.journeyCompletion, isNot(contains('完成南京')));
  });

  test('Narrative Difference Matrix explicitly covers all six approved Gold references', () {
    expect(nanjingQinhuaiDifferenceMatrix, hasLength(6));
    expect(
      nanjingQinhuaiDifferenceMatrix.map((item) => item.referenceJourneyId).toSet(),
      <String>{
        'beijing-summer-palace',
        'beijing-forbidden-city',
        'shanghai-bund',
        'xian-city-wall',
        'hangzhou-west-lake',
        'chengdu-kuanzhai-alley',
      },
    );
    for (final item in nanjingQinhuaiDifferenceMatrix) {
      final dimensions = <String>[
        item.opening,
        item.protagonist,
        item.role,
        item.relationship,
        item.goal,
        item.conflict,
        item.choice,
        item.consequence,
        item.emotionalArc,
        item.narrativeEngine,
        item.climax,
        item.ending,
        item.culturalAnchor,
        item.pace,
        item.perspective,
        item.memoryAnchor,
        item.visualMotif,
        item.specialMechanism,
      ];
      expect(dimensions.every((value) => value.trim().isNotEmpty), isTrue);
    }
    expect(
      nanjingQinhuaiNarrativeDna.narrativeIdentity,
      contains('lighting-deadline'),
    );
    expect(nanjingQinhuaiNarrativeDna.choiceType, contains('unapproved'));
    expect(nanjingQinhuaiNarrativeDna.climaxType, contains('remains-dark'));
  });

  test('production adaptive runtime resolves Nanjing to canonical Gold package', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(nanjingQinhuaiJourneyId), isTrue);
    expect(usesSharedGenericAdaptivePipeline(nanjingQinhuaiJourneyId), isFalse);
    final experience = requireDailyJourneyExperience(nanjingQinhuaiJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      expect(
        identical(
          resolved.storyParagraphs,
          nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs,
        ),
        isTrue,
      );
      expect(resolved.storyParagraphs.join(), contains('魏舟'));
      expect(resolved.storyParagraphs.join(), isNot(contains(nanjingQinhuaiLegacyOpening)));
      expect(resolved.discoveries, hasLength(1));
    }
  });
}
