import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/xian_city_wall_one_pass.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

String _expectedXianPinyin(String source) {
  var pinyin = PinyinHelper.getPinyinE(
    source,
    separator: ' ',
    format: PinyinFormat.WITH_TONE_MARK,
  );
  const phraseCorrections = <List<String>>[
    <String>['照片', 'zhào piān', 'zhào piàn'],
    <String>['得到', 'de dào', 'dé dào'],
    <String>['干净', 'gàn jìng', 'gān jìng'],
    <String>['太阳落下', 'tài yang là xià', 'tài yáng luò xià'],
    <String>['长方形', 'zhǎng fāng xíng', 'cháng fāng xíng'],
    <String>['调动', 'tiáo dòng', 'diào dòng'],
    <String>['当作', 'dāng zuò', 'dàng zuò'],
    <String>['成为', 'chéng wèi', 'chéng wéi'],
    <String>['远处', 'yuǎn chǔ', 'yuǎn chù'],
    <String>['两只', 'liǎng zhǐ', 'liǎng zhī'],
    <String>['增长', 'zēng cháng', 'zēng zhǎng'],
    <String>['可量化', 'kě liáng huà', 'kě liàng huà'],
    <String>['塞进', 'sài jìn', 'sāi jìn'],
    <String>['塞进', 'sè jìn', 'sāi jìn'],
    <String>['当返乡', 'dāng fǎn xiāng', 'dàng fǎn xiāng'],
    <String>['命名为', 'mìng míng wèi', 'mìng míng wéi'],
  ];
  for (final correction in phraseCorrections) {
    if (source.contains(correction[0])) {
      pinyin = pinyin.replaceAll(correction[1], correction[2]);
    }
  }
  return pinyin;
}

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Fact Pack separates verified world facts from ordinary fiction', () {
    final sourceIds = xianCityWallSourceLedger
        .map((source) => source['id'])
        .whereType<String>()
        .toSet();
    expect(sourceIds, hasLength(xianCityWallSourceLedger.length));
    expect(
      xianCityWallSourceLedger.every(
        (source) {
          final uri = Uri.parse(source['url']!);
          return source['publisher']!.trim().isNotEmpty &&
              uri.hasScheme &&
              uri.host.isNotEmpty &&
              source['supports']!.trim().isNotEmpty;
        },
      ),
      isTrue,
    );
    expect(
      xianCityWallClaimLedger.where(
        (claim) => !claim['status']!.startsWith('ALLOWED'),
      ),
      isEmpty,
    );
    expect(
      xianCityWallFactFictionLedger.any(
        (row) =>
            row['category'] == 'REAL PERSON HIGH-PROTECTION' &&
            row['status'] == 'NOT USED',
      ),
      isTrue,
    );
    expect(
      xianCityWallFactFictionLedger.any(
        (row) =>
            row['category'] == 'UNSUPPORTED / FALSE FACTUAL CLAIM' &&
            row['status']!.startsWith('BLOCKED'),
      ),
      isTrue,
    );
  });

  test('Xi\'an Story obeys Lv1-Lv10 requested length and paragraph policy', () {
    expect(xianCityWallOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = xianCityWallOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      // ignore: avoid_print
      print('XI_AN_STORY_METRIC Lv$level characters=$characters paragraphs=${content.storyParagraphs.length}');
      expect(
        characters,
        inInclusiveRange(
          target.acceptedMinimumCharacters,
          target.acceptedMaximumCharacters,
        ),
        reason: 'Lv$level Story-only accepted range',
      );
      expect(
        content.storyParagraphs.length,
        target.paragraphCount,
        reason: 'Lv$level strict paragraph shape',
      );
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
      for (var paragraph = 0;
          paragraph < content.storyParagraphs.length;
          paragraph++) {
        final source = content.storyParagraphs[paragraph];
        final annotation = content.storyAnnotations[paragraph];
        expect(
          annotation.pinyin,
          _expectedXianPinyin(source),
          reason: 'Lv$level paragraph ${paragraph + 1} Pinyin source identity',
        );
        expect(annotation.vietnamese.trim(), isNotEmpty);
        expect(annotation.english.trim(), isNotEmpty);
        expect(annotation.vietnamese, isNot(contains(source)));
        expect(annotation.english, isNot(contains(source)));
      }
    }
  });

  test('Xi\'an Lv8/Lv10 ReadingAnnotation locks audited Pinyin contexts', () {
    const expectedByPhrase = <String, String>{
      '照片': 'zhào piàn',
      '得到': 'dé dào',
      '干净': 'gān jìng',
      '太阳落下': 'tài yáng luò xià',
      '长方形': 'cháng fāng xíng',
      '调动': 'diào dòng',
      '当作': 'dàng zuò',
      '成为': 'chéng wéi',
      '远处': 'yuǎn chù',
      '两只': 'liǎng zhī',
      '增长': 'zēng zhǎng',
      '可量化': 'kě liàng huà',
      '塞进': 'sāi jìn',
      '当返乡': 'dàng fǎn xiāng',
      '命名为': 'mìng míng wéi',
    };
    final seen = <String>{};
    for (final level in <int>[8, 10]) {
      final content = xianCityWallOnePassLevels[level - 1];
      for (var paragraph = 0;
          paragraph < content.storyParagraphs.length;
          paragraph++) {
        final source = content.storyParagraphs[paragraph];
        final pinyin = content.storyAnnotations[paragraph].pinyin;
        for (final entry in expectedByPhrase.entries) {
          if (!source.contains(entry.key)) continue;
          seen.add(entry.key);
          expect(
            pinyin,
            contains(entry.value),
            reason: 'Lv$level paragraph ${paragraph + 1} ${entry.key} context reading',
          );
        }
      }
    }
    expect(seen, equals(expectedByPhrase.keys.toSet()));
  });

  test('all levels preserve one canonical Xi\'an narrative DNA', () {
    for (var level = 1; level <= 10; level++) {
      final story = xianCityWallOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['周遥', '搬', '永宁门', '城墙', '跑表', '新家']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(story, isNot(contains('你从永宁门走上西安城墙')));
      expect(story, isNot(contains('时间边界')));
      expect(story, isNot(contains('沈砚')));
      expect(story, isNot(contains('林岸')));
      expect(story, isNot(contains('提单')));
      expect(story, isNot(contains('门槛')));
      expect(story, isNot(contains('地图上的空白')));
    }
  });

  test('location identity and verified historical anchors are Xi\'an-specific', () {
    final advanced = xianCityWallOnePassLevels[9].storyParagraphs.join();
    expect(advanced, contains('西安城墙'));
    expect(advanced, contains('永宁门'));
    expect(advanced, contains('十三点七四公里'));
    expect(advanced, contains('明洪武七年至十一年'));
    expect(advanced, contains('南墙、西墙'));
    expect(advanced, contains('1961年'));
    expect(advanced, contains('全国重点文物保护单位'));
    expect(advanced, contains('护城河'));
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[
      for (final level in xianCityWallOnePassLevels)
        level.storyParagraphs.join(),
    ];
    expect(xianCityWallOnePassWords, hasLength(xianCityWallWordTraces.length));
    expect(
      xianCityWallOnePassWords,
      hasLength(xianCityWallWordFirstAppears.length),
    );
    for (final word in xianCityWallOnePassWords) {
      final trace = xianCityWallWordTraces
          .firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(
        stories.any((story) => story.contains(trace.sourceText)),
        isTrue,
        reason: '${word.word} exact source',
      );
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(
        first,
        xianCityWallWordFirstAppears[word.word],
        reason: '${word.word} first appears',
      );
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.simpleChinese.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
  });

  test('Discovery is exactly one level-bound card with sources and Story Link', () {
    final sourceIds = xianCityWallSources.map((source) => source.id).toSet();
    expect(xianCityWallDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = xianCityWallDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.title.trim(), isNotEmpty);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final levelContent = xianCityWallOnePassLevelContent(level);
      expect(
        levelContent.discoveries,
        hasLength(level <= 4 ? 2 : 3),
      );
      expect(levelContent.discoveries, contains(spec.entry));
      for (final discovery in levelContent.discoveries) {
        expect(
          discovery.pinyin,
          PinyinHelper.getPinyinE(
            discovery.text,
            separator: ' ',
            format: PinyinFormat.WITH_TONE_MARK,
          ),
        );
        expect(discovery.vietnamese, isNot(contains(discovery.text)));
        expect(discovery.english, isNot(contains(discovery.text)));
      }
    }
  });

  test('Challenge covers all ten levels with only approved active-story types', () {
    const approved = <String>{
      'paragraphRebuild',
      'grammarRepair',
      'missingSentence',
    };
    expect(xianCityWallChallenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = xianCityWallOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = xianCityWallChallenges
          .where((item) => item.level == level)
          .toList();
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(
          story.contains(challenge.anchor),
          isTrue,
          reason: 'Lv$level ${challenge.type}',
        );
        if (challenge.type == 'missingSentence') {
          expect(challenge.answer, challenge.anchor);
          expect(story.contains(challenge.answer), isTrue);
          expect(
            RegExp(r'[^。！？!?]+[。！？!?]')
                .allMatches(story)
                .map((match) => match.group(0)!)
                .contains(challenge.answer),
            isTrue,
            reason: 'Lv$level missingSentence must be one exact Story sentence',
          );
        }
      }
    }
  });

  test('Memory and Complete remain bound to Zhou Yao route and original anchor', () {
    final memory = xianCityWallMemory.map((item) => item.answer).join();
    for (final anchor in <String>[
      '周遥',
      '永宁门',
      '母亲',
      '城墙',
      '跑表',
      '新家',
      '明洪武',
      '全国重点文物保护单位',
    ]) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(xianCityWallCompletion.journeySummary, contains('周遥'));
    expect(xianCityWallCompletion.achievement, '续程跑者');
    expect(xianCityWallCompletion.memoryAnchor, '永宁门后没有按停的跑表');
    expect(xianCityWallCompletion.challengeReward, '长安续程牌');
    expect(xianCityWallCompletion.journeyCompletion, contains('“回家”'));
  });

  test('Vocabulary popup examples stay on the current Story sentence', () {
    for (var level = 1; level <= 10; level++) {
      final content = xianCityWallOnePassLevelContent(level);
      final story = content.storyParagraphs.join();
      for (final word in content.words) {
        expect(word.examples, hasLength(3), reason: 'Lv$level ${word.word}');
        expect(story, contains(word.examples.first.chinese));
        expect(word.examples.first.chinese, contains(word.word));
        expect(word.examples.first.vietnamese.trim(), isNotEmpty);
        expect(word.examples.first.english.trim(), isNotEmpty);
      }
    }
  });

  test('Memory and Completion are isolated to the requested level', () {
    final lv1 = batchOneMemorySpecFor(xianCityWallJourneyId, phoenixLevel: 1)!;
    final lv5 = batchOneMemorySpecFor(xianCityWallJourneyId, phoenixLevel: 5)!;
    final lv10 = batchOneMemorySpecFor(xianCityWallJourneyId, phoenixLevel: 10)!;
    expect(lv1.culturalPoint, isNot(contains('1961')));
    expect(lv1.culturalPoint, isNot(contains('监测')));
    expect(lv5.culturalPoint, contains('护城河'));
    expect(lv10.culturalPoint, contains('明代主体'));
    expect(lv10.culturalPoint, contains('现代监测'));
    expect(lv1.completionSummary, isNot(lv10.completionSummary));
    expect(lv5.completionSummary, isNot(lv10.completionSummary));
    expect(lv10.longTermAnchor, lv1.longTermAnchor);
  });

  test('Narrative DNA metadata and difference matrix cover all Gold Journeys', () {
    expect(
      approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet(),
      containsAll(<String>{
        'beijing-summer-palace',
        'beijing-forbidden-city',
        'shanghai-bund',
        xianCityWallJourneyId,
      }),
    );
    expect(
      approvedNarrativeDnaCatalog.every(
        (item) =>
            item.narrativeIdentity.trim().isNotEmpty &&
            item.majorDimensions.every((dimension) => dimension.trim().isNotEmpty),
      ),
      isTrue,
    );
  });

  test('Narrative DNA differs materially from all approved Gold references', () {
    final xian = approvedNarrativeDnaCatalog
        .singleWhere((item) => item.journeyId == xianCityWallJourneyId);
    final references = approvedNarrativeDnaCatalog
        .where((item) => item.journeyId != xianCityWallJourneyId);
    expect(narrativeDnaIsUnique(xian, references), isTrue);
    for (final reference in references) {
      expect(
        duplicatedMajorDimensions(xian, reference),
        lessThan(3),
        reason: reference.journeyId,
      );
    }
  });

  test('anti-template regression logic fails a three-dimension template copy', () {
    final xian = approvedNarrativeDnaCatalog
        .singleWhere((item) => item.journeyId == xianCityWallJourneyId);
    final shanghai = approvedNarrativeDnaCatalog
        .singleWhere((item) => item.journeyId == 'shanghai-bund');
    final disguisedCopy = JourneyNarrativeDnaRecord(
      journeyId: 'template-copy-probe',
      narrativeIdentity: 'probe',
      protagonistIdentity: shanghai.protagonistIdentity,
      protagonistAgeIdentity: shanghai.protagonistAgeIdentity,
      protagonistArchetype: shanghai.protagonistArchetype,
      openingSituation: xian.openingSituation,
      storyGoal: xian.storyGoal,
      locationMechanism: xian.locationMechanism,
      movementPattern: xian.movementPattern,
      conflictType: xian.conflictType,
      choiceType: xian.choiceType,
      climaxType: xian.climaxType,
      consequenceType: xian.consequenceType,
      emotionalArc: xian.emotionalArc,
      historicalLearningMechanism: xian.historicalLearningMechanism,
      resolutionType: xian.resolutionType,
      endingMechanism: xian.endingMechanism,
      memoryAnchorType: xian.memoryAnchorType,
      achievementType: xian.achievementType,
      rewardSymbolism: xian.rewardSymbolism,
      temporalPattern: xian.temporalPattern,
      supportingStructure: xian.supportingStructure,
      centralMetaphor: xian.centralMetaphor,
      narrativeVoice: xian.narrativeVoice,
      storyRhythm: xian.storyRhythm,
    );
    expect(
      duplicatedMajorDimensions(disguisedCopy, shanghai),
      greaterThanOrEqualTo(3),
    );
    expect(narrativeDnaIsUnique(disguisedCopy, <JourneyNarrativeDnaRecord>[shanghai]), isFalse);
  });

  test('runtime classifies Xi\'an as dedicated Gold and resolves immutable snapshots', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(xianCityWallJourneyId), isTrue);
    expect(usesSharedGenericAdaptivePipeline(xianCityWallJourneyId), isFalse);
    final experience = requireDailyJourneyExperience(xianCityWallJourneyId);
    for (var level = 1; level <= 10; level++) {
      final profile = levelAgent.profileForPhoenixLevel(level);
      final resolved = resolveAdaptiveJourneyLevel(experience, profile: profile);
      expect(
        identical(
          resolved.storyParagraphs,
          xianCityWallOnePassLevels[level - 1].storyParagraphs,
        ),
        isTrue,
      );
      expect(
        resolved.storyParagraphs.join(),
        isNot(contains('傍晚，你从永宁门走上西安城墙')),
      );
      expect(resolved.storyAnnotations.length, resolved.storyParagraphs.length);
      expect(resolved.discoveries, hasLength(level <= 4 ? 2 : 3));
    }
  });

  test('Xi\'an adapter integration preserves approved Shanghai runtime prompts', () {
    final shanghai = requireDailyJourneyExperience('shanghai-bund');
    final resolved = resolveAdaptiveJourneyLevel(
      shanghai,
      profile: levelAgent.profileForPhoenixLevel(5),
    );
    expect(
      resolved.wonderQuestion,
      '林岸为什么在过江后不再把两岸理解成过去和未来？',
    );
    expect(
      resolved.expressQuestion,
      '旧海运提单与陆家嘴结算系统在故事里共同组织了哪些流动？',
    );
  });
}
