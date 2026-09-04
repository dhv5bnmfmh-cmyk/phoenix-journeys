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
            expect(
              q.characterTiles.any((tile) => tile.contains(proper)),
              isTrue,
              reason: '$proper must remain intact inside one semantic tile',
            );
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
        expect(q.grammarFamily, q.signature.errorFamily);
        expect(q.grammarWhyWrong, isNotEmpty);
        expect(q.grammarRevisionRule, isNotEmpty);
        expect(q.grammarOptionExplanations, hasLength(4));
        expect(
          q.grammarOptionExplanations.every((value) => value.isNotEmpty),
          isTrue,
        );
      }
      expect(grammar.map((q) => q.grammarWhyWrong).toSet(), hasLength(4));
      expect(grammar.map((q) => q.grammarRevisionRule).toSet(), hasLength(4));
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
          expect(blank.semanticSlotType, isNotEmpty);
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

  test('Challenge Difficulty v2 exposes five Grammar and Rebuild bands', () {
    final bandLevels = <int>[1, 3, 5, 7, 9];
    final grammarFingerprints = <String>{};
    final rebuildFingerprints = <String>{};
    for (final level in bandLevels) {
      final set = challenge(level);
      grammarFingerprints.add(set.questions
          .where((q) => q.mode == StoryChallengeMode.grammarRepair)
          .map((q) => '${q.prompt}|${q.options.join('¦')}')
          .join('§'));
      rebuildFingerprints.add(set.questions
          .where((q) => q.mode == StoryChallengeMode.sentenceRebuild)
          .map((q) => '${q.answer}|${q.characterTiles.join('¦')}')
          .join('§'));
    }
    expect(grammarFingerprints, hasLength(5));
    expect(rebuildFingerprints, hasLength(5));
  });

  test('Completion distractors are slot-compatible and avoid position cycles', () {
    for (final level in <int>[1, 5, 10]) {
      final positions = <int>[];
      for (final question in challenge(level).questions.where(
            (q) => q.mode == StoryChallengeMode.storyCompletion,
          )) {
        for (final blank in question.completionBlanks) {
          expect(blank.semanticSlotType, isNotEmpty);
          expect(blank.options, hasLength(4));
          expect(blank.options.toSet(), hasLength(4));
          expect(
            blank.options.any(const {'的任', '是把', '路线因'}.contains),
            isFalse,
          );
          positions.add(blank.options.indexOf(blank.answer));
        }
      }
      if (positions.length >= 8) {
        expect(
          List<bool>.generate(
            positions.length - 4,
            (index) => positions[index + 4] == positions[index],
          ).every((same) => same),
          isFalse,
        );
      }
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

    final builtTile = tester.widget<Container>(
      find.byKey(const ValueKey('challenge-rebuild-built-0')),
    );
    final builtDecoration = builtTile.decoration! as BoxDecoration;
    expect(builtDecoration.color, const Color(0xF0221815));
    final builtText = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-0')),
        matching: find.text(firstTile),
      ),
    );
    expect(builtText.style?.color, Colors.white);

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

  testWidgets('final Q12 submits once, keeps feedback, and has no internal CTA',
      (tester) async {
    final finalQuestion = challenge(5).questions.last;
    var completed = 0;
    final feedbackEvents = <bool>[];
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HskStoryChallenge(
            challenge: StoryChallengeSet(
              journeyId: 'beijing-forbidden-city',
              sessionLevel: 5,
              questions: <StoryChallengeQuestion>[finalQuestion],
            ),
            displayText: (value) => value,
            onNarrate: (_, __) async {},
            onFeedbackAudio: (_, correct) async {
              feedbackEvents.add(correct);
            },
            onCompleted: () async {
              completed += 1;
            },
          ),
        ),
      ),
    );

    for (final blank in finalQuestion.completionBlanks) {
      final correctIndex = blank.options.indexOf(blank.answer);
      await tester.tap(
        find.text('${String.fromCharCode(65 + correctIndex)}  ${blank.answer}'),
      );
      await tester.pump();
    }
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(completed, 1);
    expect(feedbackEvents, <bool>[true]);
    expect(find.byKey(const ValueKey('challenge-inline-feedback')), findsOneWidget);
    expect(find.byKey(const ValueKey('challenge-inline-correct-answer')), findsOneWidget);
    expect(find.text('完成挑战'), findsNothing);
    expect(find.byKey(const ValueKey('challenge-next')), findsNothing);

    await tester.pump();
    expect(completed, 1);
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
              key: UniqueKey(),
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
    final feedback = <bool>[];
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback.add(correct),
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

    expect(feedback, <bool>[true]);
    expect(find.text('回答正确'), findsOneWidget);
    final correctBuiltText = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-0')),
        matching: find.text(ordered.first),
      ),
    );
    expect(correctBuiltText.style?.color, Colors.greenAccent);
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
  });

  testWidgets('grammar wrong STEP 1 stays visible before continue', (
    tester,
  ) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.grammarRepair);
    final feedback = <bool>[];
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback.add(correct),
    );

    final wrongError = (question.errorSegmentIndex! + 1) % 4;
    final wrongLabel =
        '${String.fromCharCode(65 + wrongError)}  '
        '${question.errorSegments[wrongError]}';
    final correctLabel =
        '${String.fromCharCode(65 + question.errorSegmentIndex!)}  '
        '${question.errorSegments[question.errorSegmentIndex!]}';

    await tester.tap(find.text(wrongLabel));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('STEP 1 · 哪里错？'), findsOneWidget);
    expect(find.text('STEP 2 · 怎么改？'), findsNothing);
    expect(find.text('位置错误'), findsOneWidget);
    expect(find.text('继续修改'), findsOneWidget);
    expect(find.byKey(const ValueKey('grammar-correct-location')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-step1-why-wrong')),
      findsOneWidget,
    );
    expect(tester.widget<Text>(find.text(wrongLabel)).style?.color, Colors.redAccent);
    expect(
      tester.widget<Text>(find.text(correctLabel)).style?.color,
      Colors.greenAccent,
    );
    expect(feedback, <bool>[false]);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    expect(feedback, <bool>[false]);
    expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);

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

    expect(feedback, <bool>[false, false]);
    expect(find.byKey(const ValueKey('grammar-error-location')), findsOneWidget);
    expect(find.byKey(const ValueKey('grammar-wrong-location')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-selected-repair')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grammar-option-explanation')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grammar-revision-rule')),
      findsOneWidget,
    );
  });

  testWidgets('grammar correct STEP 1 waits for continue and final audio works', (
    tester,
  ) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.grammarRepair);
    final feedback = <bool>[];
    await pumpSingleQuestion(
      tester,
      question,
      onFeedback: (correct) async => feedback.add(correct),
    );

    final errorIndex = question.errorSegmentIndex!;
    final correctLocationLabel =
        '${String.fromCharCode(65 + errorIndex)}  '
        '${question.errorSegments[errorIndex]}';
    await tester.tap(find.text(correctLocationLabel));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('STEP 1 · 哪里错？'), findsOneWidget);
    expect(find.text('STEP 2 · 怎么改？'), findsNothing);
    expect(find.text('位置正确'), findsOneWidget);
    expect(find.text('继续修改'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text(correctLocationLabel)).style?.color,
      Colors.greenAccent,
    );
    expect(feedback, <bool>[true]);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    expect(feedback, <bool>[true]);
    expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);

    final correctOption = question.options.indexOf(question.answer);
    await tester.tap(
      find.text(
        '${String.fromCharCode(65 + correctOption)}  '
        '${question.options[correctOption]}',
      ),
    );
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(feedback, <bool>[true, true]);
    expect(find.text('回答正确'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
    );
  });

  testWidgets('Lv5 grammar 1 authored explanations teach wrong and correct choices', (
    tester,
  ) async {
    final question = challenge(5).questions
        .where((q) => q.mode == StoryChallengeMode.grammarRepair)
        .elementAt(0);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final wrongLocation = (question.errorSegmentIndex! + 1) % 4;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongLocation)}  '
      '${question.errorSegments[wrongLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.byKey(const ValueKey('grammar-step1-why-wrong')), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-selected-location-explanation')),
      findsOneWidget,
    );
    expect(find.text('继续修改'), findsOneWidget);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    final wrongOption = question.options.indexWhere(
      (option) => option != question.answer,
    );
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongOption)}  '
      '${question.options[wrongOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改错误'), findsOneWidget);
    expect(
      find.textContaining(question.grammarOptionExplanations[wrongOption]),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('grammar-revision-rule')), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final correctLocation = question.errorSegmentIndex!;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctLocation)}  '
      '${question.errorSegments[correctLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('位置正确'), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    await tester.tap(find.text('继续修改'));
    await tester.pump();

    final correctOption = question.options.indexOf(question.answer);
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctOption)}  '
      '${question.options[correctOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改正确'), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);
  });

  testWidgets('Lv5 grammar 2 authored explanations teach wrong and correct choices', (
    tester,
  ) async {
    final question = challenge(5).questions
        .where((q) => q.mode == StoryChallengeMode.grammarRepair)
        .elementAt(1);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final wrongLocation = (question.errorSegmentIndex! + 1) % 4;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongLocation)}  '
      '${question.errorSegments[wrongLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.byKey(const ValueKey('grammar-step1-why-wrong')), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-selected-location-explanation')),
      findsOneWidget,
    );
    expect(find.text('继续修改'), findsOneWidget);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    final wrongOption = question.options.indexWhere(
      (option) => option != question.answer,
    );
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongOption)}  '
      '${question.options[wrongOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改错误'), findsOneWidget);
    expect(
      find.textContaining(question.grammarOptionExplanations[wrongOption]),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('grammar-revision-rule')), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final correctLocation = question.errorSegmentIndex!;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctLocation)}  '
      '${question.errorSegments[correctLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('位置正确'), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    await tester.tap(find.text('继续修改'));
    await tester.pump();

    final correctOption = question.options.indexOf(question.answer);
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctOption)}  '
      '${question.options[correctOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改正确'), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);
  });

  testWidgets('Lv5 grammar 3 authored explanations teach wrong and correct choices', (
    tester,
  ) async {
    final question = challenge(5).questions
        .where((q) => q.mode == StoryChallengeMode.grammarRepair)
        .elementAt(2);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final wrongLocation = (question.errorSegmentIndex! + 1) % 4;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongLocation)}  '
      '${question.errorSegments[wrongLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.byKey(const ValueKey('grammar-step1-why-wrong')), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-selected-location-explanation')),
      findsOneWidget,
    );
    expect(find.text('继续修改'), findsOneWidget);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    final wrongOption = question.options.indexWhere(
      (option) => option != question.answer,
    );
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongOption)}  '
      '${question.options[wrongOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改错误'), findsOneWidget);
    expect(
      find.textContaining(question.grammarOptionExplanations[wrongOption]),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('grammar-revision-rule')), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final correctLocation = question.errorSegmentIndex!;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctLocation)}  '
      '${question.errorSegments[correctLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('位置正确'), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    await tester.tap(find.text('继续修改'));
    await tester.pump();

    final correctOption = question.options.indexOf(question.answer);
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctOption)}  '
      '${question.options[correctOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改正确'), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);
  });

  testWidgets('Lv5 grammar 4 authored explanations teach wrong and correct choices', (
    tester,
  ) async {
    final question = challenge(5).questions
        .where((q) => q.mode == StoryChallengeMode.grammarRepair)
        .elementAt(3);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final wrongLocation = (question.errorSegmentIndex! + 1) % 4;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongLocation)}  '
      '${question.errorSegments[wrongLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.byKey(const ValueKey('grammar-step1-why-wrong')), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar-selected-location-explanation')),
      findsOneWidget,
    );
    expect(find.text('继续修改'), findsOneWidget);

    await tester.tap(find.text('继续修改'));
    await tester.pump();
    final wrongOption = question.options.indexWhere(
      (option) => option != question.answer,
    );
    await tester.tap(find.text(
      '${String.fromCharCode(65 + wrongOption)}  '
      '${question.options[wrongOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改错误'), findsOneWidget);
    expect(
      find.textContaining(question.grammarOptionExplanations[wrongOption]),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('grammar-revision-rule')), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);

    await pumpSingleQuestion(tester, question, onFeedback: (_) async {});

    final correctLocation = question.errorSegmentIndex!;
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctLocation)}  '
      '${question.errorSegments[correctLocation]}',
    ));
    await tester.pump();
    await tester.tap(find.text('确认位置'));
    await tester.pump();

    expect(find.text('位置正确'), findsOneWidget);
    expect(find.textContaining(question.grammarWhyWrong!), findsOneWidget);
    await tester.tap(find.text('继续修改'));
    await tester.pump();

    final correctOption = question.options.indexOf(question.answer);
    await tester.tap(find.text(
      '${String.fromCharCode(65 + correctOption)}  '
      '${question.options[correctOption]}',
    ));
    await tester.pump();
    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.text('修改正确'), findsOneWidget);
    expect(find.textContaining(question.grammarRevisionRule!), findsOneWidget);
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
