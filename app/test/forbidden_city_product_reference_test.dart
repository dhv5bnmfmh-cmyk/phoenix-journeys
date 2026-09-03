import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';

void main() {
  const engine = JourneyChallengeEngine();
  const auditor = ChallengeAntiTemplateAuditor();

  ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
        track: ChineseExamTrack.hsk,
        levelCode: '$level',
        levelLabel: '$level',
        band: level <= 2
            ? PhoenixReadingBand.beginner
            : level <= 4
                ? PhoenixReadingBand.elementary
                : level <= 6
                    ? PhoenixReadingBand.intermediate
                    : level <= 8
                        ? PhoenixReadingBand.upperIntermediate
                        : PhoenixReadingBand.advanced,
        phoenixLevel: level,
      );

  StoryChallengeSet challenge(int level) {
    final bundle = JourneyPreparationCoordinator.instance.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile(level),
      scriptMode: 'simplified',
    );
    return engine.build(
      journeyId: 'beijing-forbidden-city',
      sessionLevel: level,
      storyParagraphs: bundle.challengeSourceMaterial,
    );
  }

  int hanCount(String value) =>
      RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

  List<String> storyMaterial(int level) {
    final bundle = JourneyPreparationCoordinator.instance.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile(level),
      scriptMode: 'simplified',
    );
    return bundle.challengeSourceMaterial;
  }

  test('Forbidden City challenge keeps 4 + 4 + 4 = 12', () {
    final set = challenge(5);
    expect(set.questions, hasLength(12));
    for (final mode in StoryChallengeMode.values) {
      expect(set.questions.where((q) => q.mode == mode), hasLength(4));
    }
  });

  for (final level in [1, 5, 10]) {
    test('Lv$level sentence rebuild uses short grounded semantic chunks', () {
      final set = challenge(level);
      final rebuild = set.questions
          .where((q) => q.mode == StoryChallengeMode.sentenceRebuild)
          .toList();
      expect(rebuild, hasLength(4));
      for (final q in rebuild) {
        expect(hanCount(q.answer), inInclusiveRange(10, 30));
        expect(
          q.sourceSentence.replaceAll(RegExp(r'[^\u3400-\u9fff]'), ''),
          q.answer,
        );
        expect(q.prompt, contains('紫禁城相关的知识句'));
        expect(q.characterTiles, hasLength(greaterThanOrEqualTo(2)));
        expect(q.characterTiles.every((tile) => hanCount(tile) == 1), isFalse);
        expect(q.characterTiles.join().length, q.answer.length);
        for (final proper in ['沈砚', '阿宁', '紫禁城', '乾清门', '午门']) {
          if (q.answer.contains(proper)) {
            expect(q.characterTiles, contains(proper),
                reason: '$proper must remain one semantic tile');
          }
        }
      }
      expect(
        rebuild.map((q) => q.characterTiles.map(hanCount).join('-')).toSet().length,
        greaterThan(1),
      );
    });

    test('Lv$level grammar shows full broken sentence and four error families', () {
      final grammar = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.grammarRepair)
          .toList();
      expect(grammar, hasLength(4));
      expect(grammar.map((q) => q.signature.errorFamily).toSet(),
          {'关联词错误', '搭配错误', '成分赘余', '成分缺失'});
      for (final q in grammar) {
        expect(q.prompt, isNotEmpty);
        expect(q.prompt, isNot(q.answer));
        expect(q.errorSegments, hasLength(4));
        expect(q.errorSegmentIndex, inInclusiveRange(0, 3));
        expect(q.options, hasLength(4));
        expect(q.options.where((option) => option == q.answer), hasLength(1));
        expect(q.narrationText, q.prompt);
      }
    });

    test('Lv$level completion has exactly level blanks in all four questions', () {
      final completion = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.storyCompletion)
          .toList();
      expect(completion, hasLength(4));
      for (final q in completion) {
        expect(q.signature.gapType, '多空位选择填空');
        expect(q.completionBlanks, hasLength(level));
        expect(q.completionSegments, hasLength(level + 1));
        expect(q.prompt, isNot(contains('选择能补回这里的完整句')));
        for (final blank in q.completionBlanks) {
          expect(blank.options, hasLength(4));
          expect(blank.options.toSet(), hasLength(4));
          expect(
            blank.options.where((option) => option == blank.answer),
            hasLength(1),
          );
        }
      }
      expect(completion.map((q) => q.signature.sourceHash).toSet(), hasLength(4));
      expect(
        completion.map((q) => q.signature.blankPositionPattern).toSet(),
        hasLength(4),
      );
      expect(
        completion.map((q) => q.signature.distractorStrategy).toSet(),
        hasLength(4),
      );
    });
  }

  test('completion correct option and answer-shape invariants hold Lv1-Lv10', () {
    for (var level = 1; level <= 10; level++) {
      final completion = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.storyCompletion)
          .toList(growable: false);
      expect(completion, hasLength(4));
      expect(
        completion.map((q) => q.signature.answerShape).toSet().length,
        greaterThanOrEqualTo(2),
        reason: 'Lv$level completion answer shapes must vary across four questions',
      );
      for (final q in completion) {
        expect(q.signature.gapType, '多空位选择填空');
        expect(q.completionBlanks, hasLength(level));
        for (final blank in q.completionBlanks) {
          expect(blank.options, hasLength(4));
          expect(blank.options.toSet(), hasLength(4));
          expect(
            blank.options.where((option) => option == blank.answer),
            hasLength(1),
            reason: 'Lv$level ${q.id} must contain its correct option exactly once',
          );
        }
      }
    }
  });

  test('completion blank count equals current session Lv for Lv1-Lv10', () {
    for (var level = 1; level <= 10; level++) {
      final completion = challenge(level).questions
          .where((q) => q.mode == StoryChallengeMode.storyCompletion);
      expect(
        completion.every((q) => q.completionBlanks.length == level),
        isTrue,
        reason: 'Lv$level must expose exactly $level independent blanks',
      );
    }
  });

  test('Challenge Standard keeps learning value, place grounding and narration', () {
    const placeAnchors = <String>[
      '紫禁城',
      '午门',
      '中轴',
      '乾清门',
      '故宫博物院',
      '外朝',
      '内廷',
      '沈砚',
      '阿宁',
    ];
    for (final level in [1, 5, 10]) {
      final set = challenge(level);
      final corpus = storyMaterial(level).join();
      for (final q in set.questions) {
        expect(q.narrationText.trim(), isNotEmpty);
        if (q.mode == StoryChallengeMode.storyCompletion) {
          final groundedPieces = RegExp(r'[^。！？!?]+[。！？!?]')
              .allMatches(q.sourceSentence)
              .map((match) => match.group(0)!.trim())
              .where((piece) => piece.isNotEmpty);
          for (final piece in groundedPieces) {
            expect(
              corpus,
              contains(piece),
              reason:
                  'Lv$level ${q.id} completion remains current-Story grounded',
            );
          }
        } else {
          expect(
            placeAnchors.any(q.sourceSentence.contains),
            isTrue,
            reason:
                'Lv$level ${q.id} must teach current Journey/Place knowledge',
          );
        }
      }
    }
  });

  test('Anti-template auditor passes every Forbidden City Lv1-Lv10', () {
    for (var level = 1; level <= 10; level++) {
      final report = auditor.audit(challenge(level));
      expect(report.passed, isTrue, reason: 'Lv$level: ${report.failures}');
    }
  });

  testWidgets('challenge keeps question body and shows feedback inline', (tester) async {
    final set = challenge(5);
    String? narratedId;
    String? narratedText;
    bool? feedbackCorrect;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 760,
            child: HskStoryChallenge(
              challenge: set,
              displayText: (value) => value,
              onNarrate: (id, text) async {
                narratedId = id;
                narratedText = text;
              },
              onFeedbackAudio: (_, correct) async {
                feedbackCorrect = correct;
              },
              onCompleted: () async {},
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('challenge-rebuild-body')), findsOneWidget);
    expect(find.byTooltip('朗读当前题目'), findsOneWidget);
    await tester.tap(find.byTooltip('朗读当前题目'));
    await tester.pump();
    expect(narratedId, 'rebuild-1');
    expect(narratedText, isNotEmpty);

    final question = set.questions.first;
    final firstTile = question.characterTiles.first;
    await tester.tap(find.widgetWithText(ActionChip, firstTile).last);
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.byKey(const ValueKey('challenge-rebuild-body')), findsOneWidget);
    expect(find.byKey(const ValueKey('challenge-inline-feedback')), findsOneWidget);
    expect(feedbackCorrect, isFalse);
    expect(find.byKey(const ValueKey('challenge-wrong-rebuild-0')), findsOneWidget);
    expect(find.textContaining('位置错误'), findsWidgets);
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
    expect(find.text('下一题'), findsOneWidget);
  });

  Future<void> pumpSingleQuestion(
    WidgetTester tester,
    StoryChallengeQuestion question, {
    required Future<void> Function(bool correct) onFeedback,
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
                sessionLevel: 5,
                questions: <StoryChallengeQuestion>[question],
              ),
              displayText: (value) => value,
              onNarrate: (_, __) async {},
              onFeedbackAudio: (_, correct) => onFeedback(correct),
              onCompleted: () async {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('correct rebuild emits correct audio feedback', (tester) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.sentenceRebuild);
    bool? feedback;
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback = correct,
    );

    final available = List<String>.of(question.characterTiles);
    final ordered = <String>[];
    var cursor = 0;
    while (available.isNotEmpty) {
      final match = available.indexWhere(
        (tile) => question.answer.startsWith(tile, cursor),
      );
      expect(match, isNonNegative);
      final tile = available.removeAt(match);
      ordered.add(tile);
      cursor += tile.length;
    }

    for (final tile in ordered) {
      await tester.tap(find.widgetWithText(ActionChip, tile));
      await tester.pump();
    }
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(feedback, isTrue);
    expect(find.text('回答正确'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
  });

  testWidgets('grammar wrong location and repair are explicit red feedback', (
    tester,
  ) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.grammarRepair);
    bool? feedback;
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback = correct,
    );

    final wrongError = (question.errorSegmentIndex! + 1) % 4;
    await tester.tap(
      find.text(
        '${String.fromCharCode(65 + wrongError)}  '
        '${question.errorSegments[wrongError]}',
      ),
    );
    await tester.pump();
    await tester.tap(find.text('提交位置'));
    await tester.pump();

    final wrongOption = question.options.indexWhere(
      (option) => option != question.answer,
    );
    await tester.tap(
      find.text(
        '${String.fromCharCode(65 + wrongOption)}  '
        '${question.options[wrongOption]}',
      ),
    );
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(feedback, isFalse);
    final errorLocation = tester.widget<Text>(
      find.byKey(const ValueKey('grammar-error-location')),
    );
    expect(errorLocation.style?.color, Colors.redAccent);
    expect(find.byKey(const ValueKey('grammar-wrong-location')), findsOneWidget);
    expect(find.byKey(const ValueKey('grammar-wrong-repair')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
  });

  testWidgets('completion marks every wrong blank red and keeps answer inline', (
    tester,
  ) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.storyCompletion);
    bool? feedback;
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback = correct,
    );

    for (var blankIndex = 0;
        blankIndex < question.completionBlanks.length;
        blankIndex++) {
      final blank = question.completionBlanks[blankIndex];
      final wrongOption = blank.options.indexWhere(
        (option) => option != blank.answer,
      );
      await tester.tap(
        find.text(
          '${String.fromCharCode(65 + wrongOption)}  '
          '${blank.options[wrongOption]}',
        ),
      );
      await tester.pump();
    }
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(feedback, isFalse);
    for (var index = 0; index < question.completionBlanks.length; index++) {
      final error = tester.widget<Text>(
        find.byKey(ValueKey('completion-error-$index')),
      );
      expect(error.style?.color, Colors.redAccent);
    }
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
  });

  test('session challenge remains locked after global profile changes', () {
    final locked = challenge(5);
    final next = challenge(7);
    expect(locked.sessionLevel, 5);
    expect(locked.questions.every((q) => q.signature.sessionLevel == 5), isTrue);
    expect(next.sessionLevel, 7);
    expect(locked.questions.every((q) => q.signature.sessionLevel == 5), isTrue);
    expect(next.questions.every((q) => q.signature.sessionLevel == 7), isTrue);
  });
}
