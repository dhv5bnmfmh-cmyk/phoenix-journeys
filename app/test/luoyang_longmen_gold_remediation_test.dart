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

  test('Discovery has 10 distinct factual learner values and complete support', () {
    final seen = <String>{};
    const chineseAnchors = <String>[
      '伊河',
      '两千三百',
      '北魏',
      '面容',
      '奉先寺',
      '观看',
      '佛教文化',
      '整体遗产景观',
      '亚洲',
      '世界遗产',
    ];
    const vietnameseAnchors = <String>[
      'sông y',
      '2.300',
      'bắc ngụy',
      'khuôn mặt',
      'phụng tiên',
      'khoảng cách',
      'phật giáo',
      'cảnh quan di sản',
      'châu á',
      'di sản thế giới',
    ];
    const englishAnchors = <String>[
      'yi river',
      '2,300',
      'northern wei',
      'facial',
      'fengxian',
      'distance',
      'buddhist',
      'heritage landscape',
      'asia',
      'world heritage',
    ];

    for (var level = 1; level <= 10; level++) {
      final active = resolveAdaptiveJourneyLevel(longmen, profile: _profile(level));
      expect(active.discoveries, hasLength(1));
      final discovery = active.discoveries.single;
      expect(seen.add(discovery.text), isTrue, reason: 'Lv$level must be distinct');
      expect(discovery.pinyin, _pinyin(discovery.text), reason: 'Lv$level Pinyin');
      expect(discovery.text, contains(chineseAnchors[level - 1]));
      expect(discovery.vietnamese.toLowerCase(),
          contains(vietnameseAnchors[level - 1]));
      expect(discovery.english.toLowerCase(),
          contains(englishAnchors[level - 1]));
      expect(discovery.text, isNot(contains('周岚')));
      expect(discovery.text, isNot(contains('周屿')));
    }
  });

  test('Vocabulary meets target/max and every selected word is visible', () {
    const agent = PhoenixLanguageLevelAgent();
    for (var level = 1; level <= 10; level++) {
      final profile = _profile(level);
      final active = resolveAdaptiveJourneyLevel(longmen, profile: profile);
      final plan = agent.planFor(profile);
      final visible = '${active.storyParagraphs.join()}${active.discoveries.single.text}';
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
            discoveryTexts: active.discoveries.map((item) => item.text).toList(),
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
