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
    expect(
      segments.where((segment) => segment.isVocabulary).single.text,
      '中轴',
    );

    final nextParagraph = segmentStoryText(
      '下一段重新学习中轴，中轴仍只标一次。',
      const <WordEntry>[entry],
    );
    expect(
      nextParagraph.where((segment) => segment.isVocabulary),
      hasLength(1),
    );
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
      expect(first, isNotEmpty, reason: 'Lv$level must teach vocabulary');
      expect(
        second.map((word) => word.word).toList(growable: false),
        selected,
        reason: 'Lv$level selection must be deterministic',
      );
      for (final word in selected) {
        expect(story, contains(word), reason: 'Lv$level word must exist in Story');
      }
      expect(
        selected,
        containsAll(introduced),
        reason: 'Lv$level must prioritize newly introduced Story vocabulary',
      );

      fingerprints.add(selected.join('|'));
    }

    expect(
      fingerprints.length,
      greaterThanOrEqualTo(6),
      reason: 'Lv1-Lv10 must not collapse to one repeated vocabulary set',
    );
  });

  Future<void> pumpQuestion(
    WidgetTester tester,
    StoryChallengeQuestion question,
  ) async {
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
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Sentence Rebuild wrong submission keeps correct answer green', (
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
      final tile = available.removeAt(match);
      correctChunks.add(tile);
      cursor += tile.length;
    }
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

    final wrongText = tester.widget<Text>(
      find.byKey(const ValueKey('challenge-rebuild-error-0')),
    );
    expect(wrongText.style?.color, Colors.redAccent);

    final correctTile = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-2')),
        matching: find.text(wrongChunks[2]),
      ),
    );
    expect(correctTile.style?.color, Colors.greenAccent);

    final correctAnswer = tester.widget<Text>(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
    );
    expect(correctAnswer.style?.color, Colors.greenAccent);
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

    test('all four Grammar categories keep key, correction and explanation aligned', () {
      expect(grammarQuestions, hasLength(4));
      expect(
        grammarQuestions.map((question) => question.grammarFamily).toSet(),
        <String>{'关联词错误', '搭配错误', '成分赘余', '成分缺失'},
      );

      for (final question in grammarQuestions) {
        expect(question.errorSegmentIndex, isNotNull);
        expect(
          question.errorSegments.join(),
          question.prompt,
          reason: question.grammarFamily,
        );
        expect(
          question.options.where((option) => option == question.answer),
          hasLength(1),
          reason: question.grammarFamily,
        );
        expect(question.grammarWhyWrong, isNotEmpty);
        expect(question.grammarRevisionRule, isNotEmpty);
        expect(
          question.grammarOptionExplanations,
          hasLength(question.options.length),
        );
      }
    });

    testWidgets('Case A correct location plus correct repair is green PASS', (
      tester,
    ) async {
      final question = grammarQuestions.first;
      await pumpQuestion(tester, question);
      final correctLocation = question.errorSegmentIndex!;
      final correctRepair = question.options.indexOf(question.answer);

      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + correctLocation)}  ${question.errorSegments[correctLocation]}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('确认位置'));
      await tester.pump();
      await tester.tap(find.text('继续修改'));
      await tester.pump();
      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + correctRepair)}  ${question.answer}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('提交'));
      await tester.pump();

      expect(find.text('回答正确'), findsOneWidget);
      expect(find.textContaining('回答错误'), findsNothing);
      final selectedRepair = tester.widget<Text>(
        find.byKey(const ValueKey('grammar-selected-repair')),
      );
      expect(selectedRepair.style?.color, Colors.greenAccent);
    });

    testWidgets('Case B wrong location is red and actual location is green', (
      tester,
    ) async {
      final question = grammarQuestions[1];
      await pumpQuestion(tester, question);
      final correctLocation = question.errorSegmentIndex!;
      final wrongLocation =
          List<int>.generate(question.errorSegments.length, (index) => index)
              .firstWhere((index) => index != correctLocation);
      final correctRepair = question.options.indexOf(question.answer);

      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + wrongLocation)}  ${question.errorSegments[wrongLocation]}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('确认位置'));
      await tester.pump();

      final wrongChoice = tester.widget<Text>(
        find.text(
          '${String.fromCharCode(65 + wrongLocation)}  ${question.errorSegments[wrongLocation]}',
        ),
      );
      final correctChoice = tester.widget<Text>(
        find.text(
          '${String.fromCharCode(65 + correctLocation)}  ${question.errorSegments[correctLocation]}',
        ),
      );
      expect(wrongChoice.style?.color, Colors.redAccent);
      expect(correctChoice.style?.color, Colors.greenAccent);

      await tester.tap(find.text('继续修改'));
      await tester.pump();
      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + correctRepair)}  ${question.answer}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('提交'));
      await tester.pump();

      expect(find.textContaining('回答错误'), findsOneWidget);
      final wrongLocationText = tester.widget<Text>(
        find.byKey(const ValueKey('grammar-wrong-location')),
      );
      final actualLocationText = tester.widget<Text>(
        find.byKey(const ValueKey('grammar-correct-location-final')),
      );
      expect(wrongLocationText.style?.color, Colors.redAccent);
      expect(actualLocationText.style?.color, Colors.greenAccent);
      expect(find.textContaining('为什么这里有语病：'), findsOneWidget);
      expect(find.textContaining('语法点：'), findsOneWidget);
    });

    testWidgets('Case C correct location plus wrong repair stays unambiguous', (
      tester,
    ) async {
      final question = grammarQuestions[2];
      await pumpQuestion(tester, question);
      final correctLocation = question.errorSegmentIndex!;
      final wrongRepair = List<int>.generate(question.options.length, (index) => index)
          .firstWhere((index) => question.options[index] != question.answer);

      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + correctLocation)}  ${question.errorSegments[correctLocation]}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('确认位置'));
      await tester.pump();
      await tester.tap(find.text('继续修改'));
      await tester.pump();
      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + wrongRepair)}  ${question.options[wrongRepair]}',
        ),
      );
      await tester.pump();
      await tester.tap(find.text('提交'));
      await tester.pump();

      expect(find.textContaining('回答错误'), findsOneWidget);
      final selectedRepair = tester.widget<Text>(
        find.byKey(const ValueKey('grammar-selected-repair')),
      );
      final actualLocationText = tester.widget<Text>(
        find.byKey(const ValueKey('grammar-correct-location-final')),
      );
      final correctAnswer = tester.widget<Text>(
        find.byKey(const ValueKey('challenge-inline-correct-answer')),
      );
      expect(selectedRepair.style?.color, Colors.redAccent);
      expect(actualLocationText.style?.color, Colors.greenAccent);
      expect(correctAnswer.style?.color, Colors.greenAccent);
      expect(find.textContaining('为什么这里有语病：'), findsOneWidget);
      expect(find.textContaining('修改原则：'), findsOneWidget);
      expect(find.textContaining('语法点：'), findsOneWidget);
    });
  });
}
