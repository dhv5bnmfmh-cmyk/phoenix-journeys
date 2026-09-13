import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('Story vocabulary annotates the same term only once per paragraph', () {
    const entry = WordEntry(
      word: '中轴',
      pinyin: 'zhōngzhóu',
      simpleChinese: '中心轴线',
      translation: 'trục trung tâm',
      englishDefinition: 'central axis',
      symbol: '↕️',
    );
    const paragraph = '中轴组织空间，中轴也连接宫门，再看中轴。';

    final segments = segmentStoryText(paragraph, const <WordEntry>[entry]);
    expect(segments.map((segment) => segment.text).join(), paragraph);
    expect(segments.where((segment) => segment.isVocabulary), hasLength(1));
    expect(segments.where((segment) => segment.isVocabulary).single.text, '中轴');
  });

  test('Forbidden City Vocabulary has deterministic Lv1-Lv10 progression', () {
    const maximums = <int>[5, 6, 7, 7, 8, 8, 8, 8, 8, 8];
    final fingerprints = <String>{};
    for (var level = 1; level <= 10; level += 1) {
      final first = forbiddenCityWordsForLevel(level);
      final second = forbiddenCityWordsForLevel(level);
      final story = forbiddenCityLockedStories[level - 1];
      final selected = first.map((word) => word.word).toList(growable: false);
      final introduced = forbiddenCityWordRecords
          .where(
            (record) =>
                record.firstAppearsAt == level && story.contains(record.entry.word),
          )
          .map((record) => record.entry.word)
          .take(maximums[level - 1])
          .toList(growable: false);
      expect(first.length, lessThanOrEqualTo(maximums[level - 1]));
      expect(first, isNotEmpty);
      expect(second.map((word) => word.word).toList(growable: false), selected);
      for (final word in selected) {
        expect(story, contains(word));
      }
      expect(selected, containsAll(introduced));
      fingerprints.add(selected.join('|'));
    }
    expect(fingerprints.length, greaterThanOrEqualTo(6));
  });

  test('Final Memory narration follows rendered summary source and excludes controls', () {
    const excluded = <String>['添加照片', '完成旅程', '照片仅保存在此设备'];
    for (var level = 1; level <= 10; level += 1) {
      final completion = forbiddenCityCompletionForLevel(level);
      final memory = forbiddenCityMemoryForLevel(level);
      final sections = forbiddenCityFinalMemorySections(
        discovery: completion.discovery,
        learning: completion.learning,
        anchor: memory.anchor,
      );
      final narration = forbiddenCityFinalMemoryNarrationLines(sections);
      expect(
        narration,
        <String>[
          '文化发现',
          completion.discovery,
          '学习结果',
          completion.learning,
          'Memory Anchor',
          memory.anchor,
          forbiddenCityFinalMemoryPrompt,
        ],
        reason: 'Lv$level Final Memory narration order/content',
      );
      for (final controlText in excluded) {
        expect(
          narration,
          isNot(contains(controlText)),
          reason: 'Lv$level must not narrate control text: $controlText',
        );
      }
    }
    debugPrint('FINAL MEMORY AUDIO: PASS');
  });

  test('Final Memory back releases outer Challenge navigation ownership', () {
    expect(
      shouldReleaseOuterChallengeNavigation(currentStep: 4, targetStep: 3),
      isTrue,
    );
    expect(
      shouldReleaseOuterChallengeNavigation(currentStep: 5, targetStep: 3),
      isTrue,
    );
    expect(
      shouldReleaseOuterChallengeNavigation(currentStep: 3, targetStep: 2),
      isFalse,
    );
    expect(
      shouldReleaseOuterChallengeNavigation(currentStep: 3, targetStep: 4),
      isFalse,
    );
    debugPrint('BACK FROM FINAL MEMORY: PASS');
  });

  Future<void> pumpQuestion(
    WidgetTester tester,
    StoryChallengeQuestion question, {
    List<String>? feedbackAudio,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 760,
            child: HskStoryChallenge(
              key: UniqueKey(),
              challenge: StoryChallengeSet(
                journeyId: 'beijing-forbidden-city',
                sessionLevel: 8,
                questions: <StoryChallengeQuestion>[question],
              ),
              displayText: (value) => value,
              onCompleted: () async {},
              onNarrate: (_, __) async {},
              onFeedbackAudio: feedbackAudio == null
                  ? null
                  : (_, text) async => feedbackAudio.add(text),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Semantic Rebuild wrong submission marks wrong and correct chunks', (
    tester,
  ) async {
    final question = const JourneyChallengeEngine()
        .build(
          journeyId: 'beijing-forbidden-city',
          sessionLevel: 8,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[7],
        )
        .questions
        .firstWhere((item) => item.mode == StoryChallengeMode.sentenceRebuild);
    await pumpQuestion(tester, question);

    final correctChunks = <String>[];
    final available = List<String>.of(question.characterTiles);
    var cursor = 0;
    while (available.isNotEmpty && cursor < question.answer.length) {
      final match = available.indexWhere(
        (tile) => question.answer.startsWith(tile, cursor),
      );
      expect(match, isNonNegative);
      final tile = available.removeAt(match);
      correctChunks.add(tile);
      cursor += tile.length;
    }
    expect(cursor, question.answer.length);
    expect(correctChunks.length, greaterThanOrEqualTo(3));

    final wrongChunks = List<String>.of(correctChunks);
    final swap = wrongChunks[0];
    wrongChunks[0] = wrongChunks[1];
    wrongChunks[1] = swap;
    for (final chunk in wrongChunks) {
      await tester.tap(find.widgetWithText(ActionChip, chunk).first);
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();
    expect(find.byKey(const ValueKey('challenge-inline-correct-answer')), findsOneWidget);
    expect(find.byKey(const ValueKey('challenge-why-correct')), findsOneWidget);
  });

  testWidgets('Challenge keeps exactly one internal bottom navigation row', (
    tester,
  ) async {
    final question = const JourneyChallengeEngine()
        .build(
          journeyId: 'beijing-forbidden-city',
          sessionLevel: 8,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[7],
        )
        .questions
        .firstWhere((item) => item.mode == StoryChallengeMode.storyCompletion);
    await pumpQuestion(tester, question);

    expect(
      find.byKey(const ValueKey('challenge-bottom-actions')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-submit')), findsOneWidget);
    expect(find.text('上一步'), findsOneWidget);
    expect(find.text('继续留下回忆'), findsNothing);
    expect(find.text('完成旅程'), findsNothing);

    final answerIndex = question.options.indexOf(question.answer);
    await tester.tap(find.byKey(ValueKey('challenge-option-$answerIndex')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('challenge-bottom-actions')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-next')), findsOneWidget);
    expect(find.text('上一步'), findsOneWidget);
    expect(find.text('继续留下回忆'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('challenge-next')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('challenge-bottom-actions')),
      findsNothing,
    );
    expect(find.text('上一步'), findsNothing);
    debugPrint('BOTTOM NAV ROW COUNT: 1 MAX');
    debugPrint('DUPLICATE 上一步: 0');
    debugPrint('STALE OUTER CTA: 0');
  });

  group('Grammar feedback semantic matrix', () {
    final set = const JourneyChallengeEngine().build(
      journeyId: 'beijing-forbidden-city',
      sessionLevel: 8,
      storyParagraphs: forbiddenCityStoryParagraphsByLevel[7],
    );
    final grammarQuestions = set.questions
        .where((item) => item.mode == StoryChallengeMode.grammarRepair)
        .toList(growable: false);

    test('both Grammar questions keep key, correction and explanation aligned', () {
      expect(grammarQuestions, hasLength(2));
      for (final question in grammarQuestions) {
        expect(question.errorSegments.join(), question.prompt);
        expect(
          question.options.where((option) => option == question.answer),
          hasLength(1),
        );
        expect(question.grammarWhyWrong, isNotEmpty);
      }
    });

    testWidgets(
      'Case 1 Grammar Step 1 wrong stays inline and auto narration matches feedback',
      (tester) async {
        final audio = <String>[];
        final question = grammarQuestions.last;
        await pumpQuestion(tester, question, feedbackAudio: audio);
        final correctLocation = question.errorSegmentIndex!;
        final wrongLocation = List<int>.generate(
          question.errorSegments.length,
          (i) => i,
        ).firstWhere((i) => i != correctLocation);
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$wrongLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

        expect(
          find.byKey(const ValueKey('grammar-broken-sentence')),
          findsOneWidget,
        );
        expect(find.text('STEP 1 · 哪里错？'), findsOneWidget);
        for (var i = 0; i < question.errorSegments.length; i += 1) {
          expect(find.byKey(ValueKey('grammar-location-$i')), findsOneWidget);
        }
        final lockedChoice = tester.widget<InkWell>(
          find.byKey(ValueKey('grammar-location-$wrongLocation')),
        );
        expect(lockedChoice.onTap, isNull);
        expect(find.byKey(const ValueKey('grammar-step1-status')), findsOneWidget);
        expect(find.text('回答错误'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('grammar-step1-user-choice')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('grammar-step1-error-location')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('grammar-step1-explanation')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('challenge-grammar-body')),
            matching:
                find.byKey(const ValueKey('grammar-step1-feedback-block')),
          ),
          findsOneWidget,
        );
        expect(find.text('STEP 2 · 怎么改？'), findsNothing);
        expect(
          find.byKey(const ValueKey('grammar-step1-continue')),
          findsOneWidget,
        );
        expect(find.text('下一步'), findsOneWidget);
        expect(find.text('进入 STEP 2'), findsNothing);
        expect(
          find.byKey(const ValueKey('challenge-bottom-actions')),
          findsOneWidget,
        );
        expect(find.text('上一步'), findsOneWidget);
        expect(find.text('继续留下回忆'), findsNothing);
        expect(find.text('完成旅程'), findsNothing);
        expect(
          find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
          findsOneWidget,
        );

        expect(audio, hasLength(1));
        final automaticFeedback = audio.single;
        expect(automaticFeedback, contains('回答错误'));
        expect(
          automaticFeedback,
          contains('你的选择：${question.errorSegments[wrongLocation]}'),
        );
        expect(
          automaticFeedback,
          contains('真正错误位置：${question.errorSegments[correctLocation]}'),
        );
        expect(
          automaticFeedback,
          contains('为什么这里错：${question.grammarWhyWrong}'),
        );

        await tester.tap(
          find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
        );
        await tester.pump();
        expect(audio, hasLength(2));
        expect(audio.last, automaticFeedback);

        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('grammar-step1-feedback-block')),
          findsNothing,
        );
        debugPrint('GRAMMAR STEP 1 INLINE FEEDBACK: PASS');
        debugPrint('GRAMMAR STEP 1 AUTO FEEDBACK AUDIO: PASS');
        debugPrint('GRAMMAR CTA LABEL: 下一步');
        debugPrint('进入 STEP 2: 0');
        debugPrint('STANDALONE FEEDBACK PAGE: 0');
      },
    );

    testWidgets(
      'Case 2 Grammar Step 1 correct stays inline and auto narrates full feedback',
      (tester) async {
        final audio = <String>[];
        final question = grammarQuestions.first;
        await pumpQuestion(tester, question, feedbackAudio: audio);
        final correctLocation = question.errorSegmentIndex!;
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

        expect(
          find.byKey(const ValueKey('grammar-broken-sentence')),
          findsOneWidget,
        );
        expect(find.text('STEP 1 · 哪里错？'), findsOneWidget);
        for (var i = 0; i < question.errorSegments.length; i += 1) {
          expect(find.byKey(ValueKey('grammar-location-$i')), findsOneWidget);
        }
        final lockedChoice = tester.widget<InkWell>(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        expect(lockedChoice.onTap, isNull);
        expect(find.text('回答正确'), findsOneWidget);
        expect(
          find.textContaining(
            '错误位置：${question.errorSegments[correctLocation]}',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('为什么这里错：'), findsOneWidget);
        expect(find.text('STEP 2 · 怎么改？'), findsNothing);
        expect(
          find.byKey(const ValueKey('grammar-step1-continue')),
          findsOneWidget,
        );
        expect(find.text('下一步'), findsOneWidget);
        expect(find.text('进入 STEP 2'), findsNothing);
        expect(
          find.byKey(const ValueKey('challenge-bottom-actions')),
          findsOneWidget,
        );
        expect(find.text('上一步'), findsOneWidget);
        expect(audio, hasLength(1));
        expect(audio.single, contains('回答正确'));
        expect(
          audio.single,
          contains('错误位置：${question.errorSegments[correctLocation]}'),
        );
        expect(audio.single, contains('为什么这里错：${question.grammarWhyWrong}'));
      },
    );

    testWidgets(
      'Cases 3 and 4 Grammar Step 2 keeps task/options and auto narrates effective feedback',
      (tester) async {
        final audio = <String>[];
        final question = grammarQuestions.first;
        await pumpQuestion(tester, question, feedbackAudio: audio);
        final correctLocation = question.errorSegmentIndex!;
        final wrongRepair = List<int>.generate(
          question.options.length,
          (i) => i,
        ).firstWhere((i) => question.options[i] != question.answer);
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();
        expect(audio, hasLength(1));
        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        audio.clear();
        await tester.tap(find.byKey(ValueKey('grammar-repair-$wrongRepair')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

        expect(
          find.byKey(const ValueKey('grammar-broken-sentence')),
          findsOneWidget,
        );
        expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);
        for (var i = 0; i < question.options.length; i += 1) {
          expect(find.byKey(ValueKey('grammar-repair-$i')), findsOneWidget);
        }
        final root = find.byKey(ValueKey('hsk-challenge-question-${question.id}'));
        expect(
          find.descendant(
            of: root,
            matching:
                find.byKey(const ValueKey('grammar-step2-feedback-block')),
          ),
          findsOneWidget,
        );
        expect(find.text('回答错误'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('grammar-step2-user-choice')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('grammar-step2-correct-answer')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('grammar-step2-explanation')),
          findsOneWidget,
        );
        expect(find.textContaining('修正规则：'), findsNothing);
        expect(find.textContaining('你的修改（正确）'), findsNothing);
        expect(find.textContaining('为什么错：'), findsNothing);
        expect(
          find.byKey(const ValueKey('challenge-bottom-actions')),
          findsOneWidget,
        );
        expect(audio, hasLength(1));
        expect(audio.single, contains('回答错误'));
        expect(audio.single, contains('你的修改：${question.options[wrongRepair]}'));
        expect(audio.single, contains('正确答案：${question.answer}'));
        expect(audio.single, contains('为什么这样改才对：'));

        await pumpQuestion(tester, question, feedbackAudio: audio);
        final correctRepair = question.options.indexOf(question.answer);
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        audio.clear();
        await tester.tap(find.byKey(ValueKey('grammar-repair-$correctRepair')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

        expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);
        for (var i = 0; i < question.options.length; i += 1) {
          expect(find.byKey(ValueKey('grammar-repair-$i')), findsOneWidget);
        }
        expect(find.text('回答正确'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('grammar-step2-user-choice')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey('grammar-step2-correct-answer')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('grammar-step2-explanation')),
          findsOneWidget,
        );
        expect(audio, hasLength(1));
        expect(audio.single, contains('回答正确'));
        expect(audio.single, contains('正确答案：${question.answer}'));
        expect(audio.single, contains('为什么这样改才对：'));
        debugPrint('GRAMMAR STEP 2 INLINE FEEDBACK: PASS');
        debugPrint('GRAMMAR STEP 2 AUTO FEEDBACK AUDIO: PASS');
      },
    );
  });

  test('all 120 Challenge feedback presentations pass deterministic quality scan', () {
    var duplicateFeedback = 0;
    var internalAuditLanguage = 0;
    var missingWhy = 0;
    var audioUiMismatch = 0;
    var rendered = 0;
    const unsafe = <String>[
      '不满足“',
      '证据不一致',
      '不满足“从目标推导行动”',
    ];

    void scan(ChallengeFeedbackPresentation presentation) {
      final lines = presentation.lines((value) => value);
      final narration = presentation.narrationText((value) => value);
      final labels = presentation.fields.map((field) => field.label).toList();
      if (labels.toSet().length != labels.length) duplicateFeedback += 1;
      final visible = lines.join('\n');
      if (unsafe.any(visible.contains)) internalAuditLanguage += 1;
      final explanation = presentation.fields.where(
        (field) => field.kind == ChallengeFeedbackFieldKind.explanation,
      );
      if (explanation.isEmpty ||
          explanation.any((field) => field.value.trim().isEmpty)) {
        missingWhy += 1;
      }
      if (lines.any((line) => !narration.contains(line))) audioUiMismatch += 1;
    }

    for (var level = 1; level <= 10; level += 1) {
      final questions = const JourneyChallengeEngine().build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: forbiddenCityStoryParagraphsByLevel[level - 1],
      ).questions;
      expect(questions, hasLength(12));
      rendered += questions.length;
      for (final question in questions) {
        if (question.mode == StoryChallengeMode.grammarRepair) {
          final correctLocation = question.errorSegmentIndex!;
          scan(grammarLocationFeedbackPresentation(question, correctLocation));
          final wrongLocation = List<int>.generate(
            question.errorSegments.length,
            (i) => i,
          ).firstWhere((i) => i != correctLocation);
          scan(grammarLocationFeedbackPresentation(question, wrongLocation));

          final correctRepair = question.options.indexOf(question.answer);
          scan(grammarRepairFeedbackPresentation(question, correctRepair));
          for (var i = 0; i < question.options.length; i += 1) {
            if (i != correctRepair) {
              scan(grammarRepairFeedbackPresentation(question, i));
            }
          }
        } else {
          scan(
            singleStepFeedbackPresentation(
              question,
              selectedAnswer: question.answer,
            ),
          );
          if (question.options.isNotEmpty) {
            for (final option in question.options) {
              if (option != question.answer) {
                scan(
                  singleStepFeedbackPresentation(
                    question,
                    selectedAnswer: option,
                  ),
                );
              }
            }
          } else {
            scan(
              singleStepFeedbackPresentation(
                question,
                selectedAnswer: '${question.answer}（错误选择）',
              ),
            );
          }
        }
      }
    }

    debugPrint('DUPLICATE FEEDBACK BLOCK: $duplicateFeedback');
    debugPrint('INTERNAL AUDIT LANGUAGE EXPOSED TO USER: $internalAuditLanguage');
    debugPrint('MISSING WHY EXPLANATION: $missingWhy');
    debugPrint('AUDIO/UI FEEDBACK MISMATCH: $audioUiMismatch');
    expect(rendered, 120);
    expect(duplicateFeedback, 0);
    expect(internalAuditLanguage, 0);
    expect(missingWhy, 0);
    expect(audioUiMismatch, 0);
  });
}
