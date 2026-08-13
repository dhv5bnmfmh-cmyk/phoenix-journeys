import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/journey_expansion_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/luoyang_longmen_gold.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

ChineseProficiencyProfile _profile(int level) => ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '$level',
      levelLabel: '$level',
      band: PhoenixReadingBand.intermediate,
      phoenixLevel: level,
    );

String _pinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  final longmen = journeyExpansionExperiences.singleWhere(
    (item) => item.id == luoyangLongmenGoldJourneyId,
  );

  test('Longmen active runtime is the same canonical human Story at Lv1-Lv10', () {
    for (var level = 1; level <= 10; level++) {
      final active = resolveAdaptiveJourneyLevel(longmen, profile: _profile(level));
      final canonical = longmenGoldStoryForLevel(level);
      expect(active.storyParagraphs, canonical.chinese, reason: 'Lv$level Chinese');
      final story = active.storyParagraphs.join();
      for (final anchor in <String>['周岚', '周屿', '签字', '定金']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(story, contains('撕'), reason: 'Lv$level decisive choice');
      expect(story, isNot(contains('傍晚，你沿伊河走到龙门石窟')));
      expect(story, isNot(contains('刻在山崖上的艺术史')));
    }
  });

  test('Story Reading Support is complete and exact for every active paragraph', () {
    for (var level = 1; level <= 10; level++) {
      final active = resolveAdaptiveJourneyLevel(longmen, profile: _profile(level));
      expect(active.storyAnnotations, hasLength(active.storyParagraphs.length));
      for (var index = 0; index < active.storyParagraphs.length; index++) {
        final annotation = active.storyAnnotations[index];
        expect(annotation.pinyin, _pinyin(active.storyParagraphs[index]),
            reason: 'Lv$level paragraph ${index + 1} Pinyin');
        expect(annotation.vietnamese.toLowerCase(), contains('chu'),
            reason: 'Lv$level paragraph ${index + 1} Vietnamese identity');
        expect(annotation.english.toLowerCase(), contains('zhou'),
            reason: 'Lv$level paragraph ${index + 1} English identity');
      }
      final support = active.storyAnnotations
          .map((item) => '${item.vietnamese} ${item.english}')
          .join(' ')
          .toLowerCase();
      expect(support, contains('long m'));
      expect(support, contains('longmen'));
      expect(support, anyOf(contains('ký'), contains('chữ ký')));
      expect(support, contains('sign'));
    }
  });

  test('Discovery depth is exact, multilingual, grounded, and non-padded', () {
    const expectedCounts = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
    const themeAnchors = <String>[
      '石灰岩',
      '两千三百',
      '北魏',
      '衣纹',
      '奉先寺',
      '观看距离',
      '持续互动',
      '整体遗产景观',
      '亚洲',
      '世界遗产',
    ];
    const audit = <List<Map<String, String>>>[
      <Map<String, String>>[
        <String, String>{
          'question': '龙门的河流、山崖与洞窟首先是什么基本关系？',
          'fact': '石灰岩山崖',
          'why': '先定位遗址地貌与洞窟分布，不讨论开凿方式。',
          'vi': 'đá vôi',
          'en': 'limestone cliffs',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '洞窟和佛龛怎样进入这片山崖空间？',
          'fact': '直接开凿',
          'why': '补充开凿与河谷地貌的空间关系，不重复地点定位。',
          'vi': 'đục trực tiếp',
          'en': 'cut directly',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门在多大范围内保存了多少洞窟和佛龛？',
          'fact': '两千三百',
          'why': '回答规模与数量。',
          'vi': '2.300',
          'en': '2,300',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '这些洞窟和佛龛在崖壁上怎样分布？',
          'fact': '连续分布',
          'why': '把数量放回约一公里连续崖壁，不重复计数本身。',
          'vi': 'phân bố liên tục',
          'en': 'extend continuously',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门主要营造跨越什么时间框架？',
          'fact': '五世纪末',
          'why': '回答营造时段与最密集阶段。',
          'vi': 'cuối thế kỷ 5',
          'en': 'late fifth',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '这一营造时段与洛阳的历史地位有什么时间关系？',
          'fact': '都城',
          'why': '补充洛阳都城背景，不重复雕刻年代。',
          'vi': 'kinh đô',
          'en': 'capital status',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '不同时代的造像哪些可见处理会发生变化？',
          'fact': '衣纹',
          'why': '识别面容、衣纹、比例与雕刻处理的可见差异。',
          'vi': 'nếp áo',
          'en': 'drapery',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '这些变化怎样形成可比较的时代风格？',
          'fact': '中原风格',
          'why': '从局部特征上升到较早与较晚风格的跨时代比较。',
          'vi': 'Trung Nguyên',
          'en': 'Central China Style',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '奉先寺首先让学习者看到哪一种规模的造像？',
          'fact': '唐代皇家石窟艺术',
          'why': '确认奉先寺巨型造像的代表性与尺度。',
          'vi': 'hoàng gia đời Đường',
          'en': 'Tang royal cave-temple art',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '奉先寺大型造像群怎样组织空间？',
          'fact': '中央大像',
          'why': '说明中央与周围造像的组织关系，不重复代表性。',
          'vi': 'tượng lớn trung tâm',
          'en': 'central giant figure',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '学习者应该怎样阅读这一整组造像？',
          'fact': '同一布局',
          'why': '把前两项转化为整体阅读方法，而不是再描述一尊造像。',
          'vi': 'cùng một bố cục',
          'en': 'one layout',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门为什么天然包含多种观看尺度？',
          'fact': '尺度差异',
          'why': '先建立小龛、洞窟与大型群组的对象尺度差异。',
          'vi': 'khác biệt rõ rệt về quy mô',
          'en': 'differ clearly in scale',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '近距离主要帮助看什么？',
          'fact': '局部雕刻细节',
          'why': '只解释近看获得的小尺度信息。',
          'vi': 'chi tiết chạm khắc',
          'en': 'carving details',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '为什么面对大型造像群要改变观看距离？',
          'fact': '观看距离',
          'why': '解释远看整体与对象尺度之间的观看规则。',
          'vi': 'khoảng cách xem',
          'en': 'viewing distance',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门造像的宗教题材是什么？',
          'fact': '佛教',
          'why': '先确认佛教题材与中国石刻传统这一基本组合。',
          'vi': 'Phật giáo',
          'en': 'Buddhist subjects',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '佛教题材进入中国后是否保持固定造型？',
          'fact': '单一固定',
          'why': '用北魏至唐的风格变化回答表现方式是否固定。',
          'vi': 'cố định duy nhất',
          'en': 'single fixed form',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '学习者怎样理解佛教内容与本土艺术的关系？',
          'fact': '持续互动',
          'why': '综合前两项，明确宗教内容与本土雕塑风格的互动。',
          'vi': 'tương tác liên tục',
          'en': 'continued interaction',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '洞窟、佛龛、大型造像群与伊河山崖是什么关系？',
          'fact': '整体遗产景观',
          'why': '建立文化遗存与河谷环境的一体关系。',
          'vi': 'cảnh quan di sản thống nhất',
          'en': 'integrated heritage landscape',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '世界遗产完整性还包含哪些自然环境？',
          'fact': '东山、西山',
          'why': '补充完整性所覆盖的东西山与河谷环境。',
          'vi': 'Đông Sơn, Tây Sơn',
          'en': 'East Hill, West Hill',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '学习者如何把不同尺度连成一个遗产整体？',
          'fact': '三个尺度',
          'why': '给出洞窟、群组、河谷环境三个尺度的阅读框架。',
          'vi': 'ba quy mô',
          'en': 'three connected scales',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门记录了中国艺术发展的什么内容？',
          'fact': '重要阶段',
          'why': '聚焦中国佛教艺术与石雕的长期发展记录。',
          'vi': 'giai đoạn quan trọng',
          'en': 'important stages',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '龙门雕塑风格的影响到达哪里？',
          'fact': '亚洲其他地区',
          'why': '单独说明中国以外的亚洲影响范围。',
          'vi': 'các khu vực khác của châu Á',
          'en': 'other parts of Asia',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '为什么这种影响比单纯数量更重要？',
          'fact': '艺术传播',
          'why': '把中国风格演变与更广的亚洲传播连接起来。',
          'vi': 'lan truyền nghệ thuật',
          'en': 'artistic transmission',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
      <Map<String, String>>[
        <String, String>{
          'question': '龙门的世界遗产价值依赖什么整体？',
          'fact': '世界遗产',
          'why': '先确定洞窟、造像与河谷环境的整体价值。',
          'vi': 'Di sản Thế giới',
          'en': 'World Heritage',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '完整性和真实性分别要求学习者注意什么？',
          'fact': '真实性',
          'why': '解释布局、材料、技术、位置和内在联系的真实性维度。',
          'vi': 'tính xác thực',
          'en': 'authenticity',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
        <String, String>{
          'question': '保护为什么不能只围绕著名大像？',
          'fact': '整个遗产地',
          'why': '把保护范围落到整个遗产地、环境与长期管理。',
          'vi': 'toàn bộ khu di sản',
          'en': 'whole heritage property',
          'source': 'unesco-luoyang-longmen-grottoes',
        },
      ],
    ];

    final approvedSourceIds =
        journeyExpansionSources.map((item) => item.id).toSet();
    final seenLevelThemes = <String>{};

    for (var level = 1; level <= 10; level++) {
      final active =
          resolveAdaptiveJourneyLevel(longmen, profile: _profile(level));
      final levelAudit = audit[level - 1];
      final expectedCount = expectedCounts[level - 1];
      expect(active.discoveries, hasLength(expectedCount),
          reason: 'Lv$level active Discovery count');
      expect(levelAudit, hasLength(expectedCount),
          reason: 'Lv$level audit record count');

      final combinedChinese =
          active.discoveries.map((item) => item.text).join();
      expect(combinedChinese, contains(themeAnchors[level - 1]),
          reason: 'Lv$level approved learner theme');
      expect(seenLevelThemes.add(combinedChinese), isTrue,
          reason: 'Lv$level theme set must remain distinct');

      final seenEntries = <String>{};
      final seenFacts = <String>{};
      var totalCharacters = 0;

      for (var index = 0; index < active.discoveries.length; index++) {
        final discovery = active.discoveries[index];
        final itemAudit = levelAudit[index];
        totalCharacters += discovery.text.runes.length;

        expect(seenEntries.add(discovery.text), isTrue,
            reason: 'Lv$level item ${index + 1} duplicate text');
        expect(seenFacts.add(itemAudit['fact']!), isTrue,
            reason: 'Lv$level item ${index + 1} duplicate learner fact');
        expect(discovery.text, contains(itemAudit['fact']),
            reason: 'Lv$level item ${index + 1} new fact');
        expect(discovery.pinyin, _pinyin(discovery.text),
            reason: 'Lv$level item ${index + 1} exact Pinyin');
        expect(discovery.vietnamese, contains(itemAudit['vi']),
            reason: 'Lv$level item ${index + 1} Vietnamese support');
        expect(discovery.english, contains(itemAudit['en']),
            reason: 'Lv$level item ${index + 1} English support');
        expect(itemAudit['question']!.trim(), isNotEmpty);
        expect(itemAudit['why']!.trim(), isNotEmpty);
        expect(approvedSourceIds, contains(itemAudit['source']),
            reason: 'Lv$level item ${index + 1} source support');
        expect(discovery.text, isNot(contains('周岚')));
        expect(discovery.text, isNot(contains('周屿')));
      }

      expect(
        totalCharacters,
        lessThanOrEqualTo(level <= 4 ? 125 : 185),
        reason: 'Lv$level mobile Discovery density',
      );
    }
  });

  test('Discovery ordering is stable for existing narration list behavior', () {
    const expectedCounts = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
    for (var level = 1; level <= 10; level++) {
      final active =
          resolveAdaptiveJourneyLevel(longmen, profile: _profile(level));
      final expected = longmenGoldDiscoveriesForLevel(level);
      expect(active.discoveries, orderedEquals(expected),
          reason: 'Lv$level narration input order');
      expect(
        active.discoveries.map((item) => item.text).toSet(),
        hasLength(expectedCounts[level - 1]),
        reason: 'Lv$level narration input must not duplicate entries',
      );
    }
  });

  test('Vocabulary meets target/max and every selected word is visible', () {
    const agent = PhoenixLanguageLevelAgent();
    for (var level = 1; level <= 10; level++) {
      final profile = _profile(level);
      final active = resolveAdaptiveJourneyLevel(longmen, profile: profile);
      final plan = agent.planFor(profile);
      final visible =
          '${active.storyParagraphs.join()}${active.discoveries.map((item) => item.text).join()}';
      expect(active.words.length, greaterThanOrEqualTo(plan.targetVocabularyCount),
          reason: 'Lv$level target');
      expect(active.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount),
          reason: 'Lv$level max');
      for (final word in active.words) {
        expect(visible, contains(word.word),
            reason: 'Lv$level provenance ${word.word}');
      }
    }
  });

  test('knownWords behavior remains review-aware without changing Story', () {
    final baseline = resolveAdaptiveJourneyLevel(longmen, profile: _profile(8));
    final known = baseline.words.first.word;
    final reviewed = resolveAdaptiveJourneyLevel(
      longmen,
      profile: _profile(8),
      knownWords: <String>{known},
    );
    expect(reviewed.storyParagraphs, baseline.storyParagraphs);
    expect(reviewed.words.map((item) => item.word), contains(known));
    expect(reviewed.words.map((item) => item.word).toList(),
        isNot(baseline.words.map((item) => item.word).toList()));
  });

  test('Entry is synchronized and Longmen keeps generic Memory/Completion mode', () {
    expect(longmen.storyTitle, luoyangLongmenGoldStoryTitle);
    expect(longmen.headline, luoyangLongmenGoldHeadline);
    expect(longmen.description, luoyangLongmenGoldDescription);
    expect(longmen.discoveryTeaser, luoyangLongmenGoldDiscoveryTeaser);
    expect(longmen.wonderQuestion, luoyangLongmenGoldWonderQuestion);
    expect(longmen.expressQuestion, luoyangLongmenGoldExpressQuestion);
    expect(batchOneMemorySpecFor(longmen.id), isNull);
  });


  test('Longmen static publication shell remains four-section compatible', () {
    final publishedSections = longmen.content.sections;
    final publishedParagraphs = publishedSections
        .map((section) => section.text)
        .toList(growable: false);
    expect(publishedSections, hasLength(4));
    expect(longmen.storyAnnotations, hasLength(4));
    expect(longmen.discoveries, hasLength(4));
    expect(publishedParagraphs.join(), contains('周岚'));
    expect(publishedParagraphs.join(), contains('撕开签字页'));
    expect(publishedParagraphs.join(), isNot(contains('傍晚，你沿伊河')));
    for (var index = 0; index < publishedSections.length; index++) {
      expect(
        longmen.storyAnnotations[index].pinyin,
        _pinyin(publishedParagraphs[index]),
      );
    }
  });

  test('Gold DNA catalog is 10 Journeys / 45 pairs and Longmen is unique', () {
    expect(approvedNarrativeDnaCatalog, hasLength(10));
    final ids = approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet();
    expect(ids, hasLength(10));
    expect(ids, contains(luoyangLongmenGoldJourneyId));
    var pairCount = 0;
    for (var i = 0; i < approvedNarrativeDnaCatalog.length; i++) {
      for (var j = i + 1; j < approvedNarrativeDnaCatalog.length; j++) {
        pairCount++;
        expect(
          duplicatedMajorDimensions(
            approvedNarrativeDnaCatalog[i],
            approvedNarrativeDnaCatalog[j],
          ),
          lessThan(3),
          reason:
              '${approvedNarrativeDnaCatalog[i].journeyId} vs ${approvedNarrativeDnaCatalog[j].journeyId}',
        );
      }
    }
    expect(pairCount, 45);
  });


  test('Longmen Story metrics obey active paragraph policy', () {
    for (var level = 1; level <= 10; level++) {
      final story = longmenGoldStoryForLevel(level);
      final characters = story.chinese.join().runes.length;
      // ignore: avoid_print
      print('LONGMEN_STORY_METRIC Lv$level characters=$characters paragraphs=${story.chinese.length}');
      expect(story.chinese.length, story.vietnamese.length, reason: 'Lv$level Vietnamese paragraph alignment');
      expect(story.chinese.length, story.english.length, reason: 'Lv$level English paragraph alignment');
      if (level == 4) expect(characters, inInclusiveRange(270, 470));
      if (level >= 8) expect(story.chinese, hasLength(2), reason: 'Lv$level literary paragraph shape');
    }
  });

  test('Longmen is fully registered in semantic Gold with active Story evidence', () {
    expect(approvedGoldSemanticFingerprints, hasLength(10));
    final fingerprint = approvedGoldSemanticFingerprints[luoyangLongmenGoldJourneyId];
    expect(fingerprint, isNotNull);
    expect(semanticEvidenceContractErrors(fingerprint!), isEmpty);
    final pairs = auditApprovedGoldSemanticPairs();
    expect(pairs, hasLength(45));
    expect(pairs.where((item) => item.ruleA || item.ruleB), isEmpty);
  });

  testWidgets('Longmen Challenge keeps all modes and uses Longmen-specific grammar',
      (tester) async {
    final active = resolveAdaptiveJourneyLevel(longmen, profile: _profile(5));
    final discoveryTexts =
        active.discoveries.map((item) => item.text).toList(growable: false);
    expect(discoveryTexts, hasLength(3));
    expect(discoveryTexts.toSet(), hasLength(3));
    expect(
      fixedJourneyChallengeTypes.map((item) => item.name).toList(),
      <String>['paragraphRebuild', 'grammarRepair', 'missingSentence'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyChallengePanel(
            journeyId: longmen.id,
            storyParagraphs: active.storyParagraphs,
            discoveryTexts: discoveryTexts,
            profile: _profile(5),
            seed: 174,
            displayText: (value) => value,
            autoNarrate: false,
            onResolved: (_, __) async {},
            onAllCompleted: () async {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('故事中的地点突然改变'), findsNothing);
    expect(find.textContaining('园林采用了借景手法'), findsNothing);
    expect(find.textContaining('这条长廊不但可以避雨'), findsNothing);

    final storySentences = active.storyParagraphs
        .expand((paragraph) => paragraph
            .split(RegExp(r'(?<=[。！？])'))
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty))
        .toList(growable: false);
    for (final sentence in storySentences.take(3)) {
      await tester.tap(find.text(sentence));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('challenge-dialog-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('challenge-mode-grammarRepair')), findsOneWidget);
    expect(find.textContaining('奉先寺'), findsWidgets);
    expect(find.textContaining('长廊不但可以避雨'), findsNothing);
    expect(find.textContaining('园林采用了借景手法'), findsNothing);

    final grammarSegment =
        find.byKey(const ValueKey('challenge-grammar-segment-1'));
    final grammarOptions =
        find.byKey(const ValueKey('challenge-four-options'));
    final correctGrammarOption =
        find.byKey(const ValueKey('challenge-option-correct'));
    expect(grammarSegment, findsOneWidget);
    expect(
      find.descendant(of: grammarSegment, matching: find.text('而且游客还')),
      findsOneWidget,
    );
    expect(tester.widget<ChoiceChip>(grammarSegment).selected, isFalse);
    expect(grammarOptions, findsOneWidget);
    final keyedGrammarOptions = find.descendant(
      of: grammarOptions,
      matching: find.byWidgetPredicate((widget) {
        final key = widget.key;
        return widget is Material &&
            key is ValueKey<String> &&
            key.value.startsWith('challenge-option-');
      }),
    );
    expect(keyedGrammarOptions, findsNWidgets(journeyChallengeOptionCount));
    for (final optionId in <String>[
      'correct',
      'distractor-1',
      'distractor-2',
      'distractor-3',
    ]) {
      expect(
        find.descendant(
          of: grammarOptions,
          matching: find.byKey(ValueKey('challenge-option-$optionId')),
        ),
        findsOneWidget,
      );
    }
    expect(correctGrammarOption, findsOneWidget);
    expect(
      find.descendant(
        of: correctGrammarOption,
        matching: find.text('而且让游客'),
      ),
      findsOneWidget,
    );
    await tester.tap(grammarSegment);
    await tester.pump();
    expect(tester.widget<ChoiceChip>(grammarSegment).selected, isTrue);
    expect(correctGrammarOption, findsOneWidget);
    await tester.tap(correctGrammarOption);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('challenge-dialog-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('challenge-mode-missingSentence')), findsOneWidget);
    expect(find.textContaining('周岚'), findsWidgets);
    expect(find.textContaining('故事中的地点突然改变'), findsNothing);
  });
}
