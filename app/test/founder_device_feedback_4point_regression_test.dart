import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
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
      'Case 1 Grammar Step 1 wrong gives feedback before Step 2 and audio matches',
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
        expect(find.text('STEP 2 · 怎么改？'), findsNothing);
        expect(
          find.byKey(const ValueKey('grammar-step1-continue')),
          findsOneWidget,
        );
        expect(
          find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
          findsOneWidget,
        );

        await tester.tap(
          find.byKey(ValueKey('challenge-feedback-speaker-${question.id}')),
        );
        await tester.pump();
        expect(audio, hasLength(1));
        expect(audio.single, contains('回答错误'));
        expect(
          audio.single,
          contains('你的选择：${question.errorSegments[wrongLocation]}'),
        );
        expect(
          audio.single,
          contains('真正错误位置：${question.errorSegments[correctLocation]}'),
        );
        expect(audio.single, contains('为什么这里错：${question.grammarWhyWrong}'));

        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('grammar-step1-feedback-block')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Case 2 Grammar Step 1 correct gives explicit teaching feedback first',
      (tester) async {
        final question = grammarQuestions.first;
        await pumpQuestion(tester, question);
        final correctLocation = question.errorSegmentIndex!;
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

        expect(find.text('回答正确'), findsOneWidget);
        expect(
          find.textContaining(
            '错误位置：${question.errorSegments[correctLocation]}',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('为什么这里错：'), findsOneWidget);
        expect(find.text('STEP 2 · 怎么改？'), findsNothing);
      },
    );

    testWidgets(
      'Cases 3 and 4 Grammar Step 2 shows one non-duplicated teaching block',
      (tester) async {
        final question = grammarQuestions.first;
        await pumpQuestion(tester, question);
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
        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        await tester.tap(find.byKey(ValueKey('grammar-repair-$wrongRepair')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

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

        await pumpQuestion(tester, question);
        final correctRepair = question.options.indexOf(question.answer);
        await tester.tap(
          find.byKey(ValueKey('grammar-location-$correctLocation')),
        );
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
        await tester.pump();
        await tester.tap(find.byKey(ValueKey('grammar-repair-$correctRepair')));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('challenge-submit')));
        await tester.pump();

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
