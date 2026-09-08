import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

const _journeyId = 'beijing-forbidden-city';
const _ttsChannel = MethodChannel('flutter_tts');

int _stableHash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash;
}

String _hashHex(String value) =>
    _stableHash(value).toRadixString(16).padLeft(8, '0');

String _plainText(Widget widget) {
  if (widget is Text) {
    return (widget.data ?? widget.textSpan?.toPlainText() ?? '').trim();
  }
  if (widget is RichText) return widget.text.toPlainText().trim();
  return '';
}

List<String> _renderedTexts({Finder? under}) {
  final result = <String>[];
  Iterable<Element> elements(Finder finder) => finder.evaluate();
  final textFinder = under == null
      ? find.byType(Text)
      : find.descendant(of: under, matching: find.byType(Text));
  final richFinder = under == null
      ? find.byType(RichText)
      : find.descendant(of: under, matching: find.byType(RichText));
  for (final element in <Element>[...elements(textFinder), ...elements(richFinder)]) {
    final value = _plainText(element.widget);
    if (value.isNotEmpty) result.add(value);
  }
  return result;
}

Map<String, Object?> _wordMap(WordEntry entry, List<String> visibleSources) {
  String firstOccurrence = '';
  for (final source in visibleSources) {
    if (source.contains(entry.word)) {
      firstOccurrence = source;
      break;
    }
  }
  return <String, Object?>{
    'word': entry.word,
    'pinyin': entry.pinyin,
    'partOfSpeech': entry.partOfSpeech,
    'simpleChinese': entry.simpleChinese,
    'translation': entry.translation,
    'englishDefinition': entry.englishDefinition,
    'firstOccurrence': firstOccurrence,
    'examples': <Map<String, String>>[
      for (final example in entry.studyExamples)
        <String, String>{
          'chinese': example.chinese,
          'pinyin': example.pinyin,
          'vietnamese': example.vietnamese,
          'english': example.english,
        },
    ],
  };
}

Map<String, Object?> _questionMap(StoryChallengeQuestion question) {
  final directCorrectIndex = question.options.length == 4
      ? question.options.indexWhere((value) => value == question.answer)
      : -1;
  return <String, Object?>{
    'id': question.id,
    'mode': question.mode.name,
    'sourceSentence': question.sourceSentence,
    'prompt': question.prompt,
    'answer': question.answer,
    'options': question.options,
    'directCorrectIndex': directCorrectIndex,
    'characterTiles': question.characterTiles,
    'errorSegments': question.errorSegments,
    'errorSegmentIndex': question.errorSegmentIndex,
    'grammarFamily': question.grammarFamily,
    'grammarWhyWrong': question.grammarWhyWrong,
    'grammarRevisionRule': question.grammarRevisionRule,
    'grammarOptionExplanations': question.grammarOptionExplanations,
    'completionSegments': question.completionSegments,
    'completionBlanks': <Map<String, Object?>>[
      for (final blank in question.completionBlanks)
        <String, Object?>{
          'answer': blank.answer,
          'options': blank.options,
          'correctIndex': blank.options.indexWhere((value) => value == blank.answer),
          'answerType': blank.answerType,
          'semanticSlotType': blank.semanticSlotType,
          'sourceStart': blank.sourceStart,
        },
    ],
    'narrationText': question.narrationText,
    'signature': <String, Object?>{
      'journeyId': question.signature.journeyId,
      'sessionLevel': question.signature.sessionLevel,
      'mode': question.signature.mode.name,
      'sourceParagraphIndex': question.signature.sourceParagraphIndex,
      'sourceSentenceIndex': question.signature.sourceSentenceIndex,
      'sourceHash': question.signature.sourceHash,
      'syntaxPattern': question.signature.syntaxPattern,
      'operationType': question.signature.operationType,
      'errorFamily': question.signature.errorFamily,
      'gapType': question.signature.gapType,
      'answerShape': question.signature.answerShape,
      'distractorStrategy': question.signature.distractorStrategy,
      'blankPositionPattern': question.signature.blankPositionPattern,
      'equivalenceKey': question.signature.equivalenceKey,
    },
  };
}

Future<void> _tapFinder(WidgetTester tester, Finder finder) async {
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 20));
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  expect(finder, findsOneWidget, reason: 'missing rendered text: $text');
  await _tapFinder(tester, finder);
}

List<String> _visibleChoiceLines() => _renderedTexts(
      under: find.byType(HskStoryChallenge),
    ).where((value) => RegExp(r'^[A-D]\s{2}').hasMatch(value)).toList(growable: false);

String _feedbackColor(String key) {
  final finder = find.byKey(ValueKey(key));
  if (finder.evaluate().isEmpty) return '';
  final widget = finder.evaluate().single.widget;
  if (widget is Text) return widget.style?.color.toString() ?? '';
  return '';
}

Future<List<Map<String, Object?>>> _exerciseChallenge(
  WidgetTester tester,
  StoryChallengeSet challenge,
) async {
  final rows = <Map<String, Object?>>[];

  for (var questionIndex = 0;
      questionIndex < challenge.questions.length;
      questionIndex += 1) {
    final question = challenge.questions[questionIndex];
    expect(
      find.byKey(ValueKey('hsk-challenge-question-${question.id}')),
      findsOneWidget,
      reason: 'question ${question.id} must be actually rendered',
    );

    final row = <String, Object?>{
      ..._questionMap(question),
      'renderedQuestionTextsBeforeSubmit': _renderedTexts(
        under: find.byKey(ValueKey('hsk-challenge-question-${question.id}')),
      ),
      'renderedDirectOptions': const <String>[],
      'renderedGrammarLocationOptions': const <String>[],
      'renderedCompletionOptionOrders': <List<String>>[],
      'renderedTileOrder': const <String>[],
    };

    switch (question.mode) {
      case StoryChallengeMode.sentenceRebuild:
        final tileOrder = <String>[];
        for (final chip in tester.widgetList<ActionChip>(
          find.descendant(
            of: find.byType(HskStoryChallenge),
            matching: find.byType(ActionChip),
          ),
        )) {
          final label = chip.label;
          if (label is Text) tileOrder.add(label.data ?? '');
        }
        row['renderedTileOrder'] = tileOrder;

        var tapOrder = List<String>.of(question.characterTiles);
        if (tapOrder.join() == question.answer && tapOrder.length > 1) {
          tapOrder = <String>[...tapOrder.skip(1), tapOrder.first];
        }
        for (final chunk in tapOrder) {
          final finder = find.widgetWithText(ActionChip, chunk);
          expect(finder, findsOneWidget, reason: 'missing rebuild tile $chunk');
          await _tapFinder(tester, finder);
        }
        await _tapFinder(
          tester,
          find.byKey(const ValueKey('challenge-submit')),
        );
        break;

      case StoryChallengeMode.grammarRepair:
        row['renderedGrammarLocationOptions'] = _visibleChoiceLines();
        final correctLocation = question.errorSegmentIndex ?? 0;
        final wrongLocation = List<int>.generate(
          question.errorSegments.length,
          (index) => index,
        ).firstWhere((index) => index != correctLocation);
        await _tapText(
          tester,
          '${String.fromCharCode(65 + wrongLocation)}  ${question.errorSegments[wrongLocation]}',
        );
        await _tapFinder(
          tester,
          find.byKey(const ValueKey('challenge-submit')),
        );
        row['grammarStep1Feedback'] = _renderedTexts(
          under: find.byType(HskStoryChallenge),
        ).where((value) =>
            value.contains('位置') || value.contains('真正的问题') || value.contains('语法点')).toList(growable: false);
        await _tapFinder(
          tester,
          find.byKey(const ValueKey('challenge-submit')),
        );
        row['renderedDirectOptions'] = _visibleChoiceLines();
        final wrongRepair = List<int>.generate(
          question.options.length,
          (index) => index,
        ).firstWhere((index) => question.options[index] != question.answer);
        await _tapText(
          tester,
          '${String.fromCharCode(65 + wrongRepair)}  ${question.options[wrongRepair]}',
        );
        await _tapFinder(
          tester,
          find.byKey(const ValueKey('challenge-submit')),
        );
        break;

      case StoryChallengeMode.storyCompletion:
        final renderedOrders = <List<String>>[];
        for (var blankIndex = 0;
            blankIndex < question.completionBlanks.length;
            blankIndex += 1) {
          final blank = question.completionBlanks[blankIndex];
          final visible = _visibleChoiceLines();
          renderedOrders.add(visible);
          final wrong = List<int>.generate(blank.options.length, (index) => index)
              .firstWhere((index) => blank.options[index] != blank.answer);
          await _tapText(
            tester,
            '${String.fromCharCode(65 + wrong)}  ${blank.options[wrong]}',
          );
        }
        row['renderedCompletionOptionOrders'] = renderedOrders;
        await _tapFinder(
          tester,
          find.byKey(const ValueKey('challenge-submit')),
        );
        break;
    }

    expect(
      find.byKey(const ValueKey('challenge-inline-feedback')),
      findsOneWidget,
      reason: '${question.id} must show inline feedback after submit',
    );
    expect(
      find.byKey(const ValueKey('challenge-inline-correct-answer')),
      findsOneWidget,
      reason: '${question.id} must show inline correct answer after submit',
    );
    row['renderedFeedback'] = _renderedTexts(
      under: find.byType(HskStoryChallenge),
    ).where((value) =>
        value.contains('回答') ||
        value.contains('正确答案') ||
        value.contains('填错') ||
        value.contains('位置错误') ||
        value.contains('修改错误') ||
        value.contains('为什么')).toList(growable: false);
    row['feedbackColor'] = _feedbackColor('challenge-inline-feedback');
    row['correctAnswerColor'] = _feedbackColor('challenge-inline-correct-answer');

    rows.add(row);

    if (questionIndex < challenge.questions.length - 1) {
      await _tapFinder(
        tester,
        find.byKey(const ValueKey('challenge-next')),
      );
    }
  }
  return rows;
}

Future<T> _withRenderedJourney<T>(
  WidgetTester tester, {
  required String storyId,
  required int level,
  required int step,
  bool completed = false,
  required Future<T> Function(AppState state) inspect,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  PhoenixLevelController.instance.setLevel(level);
  final state = AppState();
  await state.load();
  await state.activateJourney(_journeyId, storyId: storyId);
  await state.saveJourneyProgress(
    step: step,
    wonder: '',
    express: '',
    memory: '',
  );
  if (completed) {
    await state.completeJourney('', sessionLevel: level);
  }

  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        home: JourneyScreen(journeyId: _journeyId, storyId: storyId),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 160));

  expect(PhoenixLevelController.instance.level, level);
  expect(
    find.byKey(const ValueKey('journey-progress-strip')),
    findsOneWidget,
    reason: 'Journey runtime must be structurally rendered before inspection.',
  );
  final result = await inspect(state);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  state.dispose();
  return result;
}

Map<String, Object?> _stageRow({
  required String storyId,
  required String storyTitle,
  required int level,
  required String stage,
  required int step,
  required Object? actual,
  required String sourceController,
  required String contentGenerator,
  required String expectedContract,
}) {
  final canonical = const JsonEncoder().convert(actual);
  return <String, Object?>{
    'storyId': storyId,
    'story': storyTitle,
    'level': level,
    'stage': stage,
    'stepIndex': step,
    'pageType': stage,
    'controllerSource': sourceController,
    'contentGenerator': contentGenerator,
    'levelInput': level,
    'storyIdInput': storyId,
    'expectedContract': expectedContract,
    'actual': actual,
    'contentIdentity': _hashHex(canonical),
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var ttsSpeakCalls = 0;

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_ttsChannel, (call) async {
      if (call.method == 'speak') ttsSpeakCalls += 1;
      return 1;
    });
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_ttsChannel, null);
  });

  testWidgets('captures exact rendered Lv1-Lv10 x all Forbidden City learning stages',
      (tester) async {
    final previousLevel = PhoenixLevelController.instance.level;
    addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const stories = <Map<String, String>>[
      <String, String>{
        'id': forbiddenCityPrimaryStoryId,
        'title': '两条路，一张图',
      },
      <String, String>{
        'id': forbiddenCitySecondStoryId,
        'title': '交接前的标记',
      },
    ];

    final rows = <Map<String, Object?>>[];
    final topology = <Map<String, Object?>>[
      <String, Object?>{
        'stepIndex': 0,
        'runtimePage': 'Story',
        'widget': 'JourneyScreen._storyPage / InteractiveStoryText',
      },
      <String, Object?>{
        'stepIndex': 1,
        'runtimePage': 'Vocabulary',
        'widget': 'JourneyScreen._wordsPage / WordDetailSheet',
      },
      <String, Object?>{
        'stepIndex': 2,
        'runtimePage': 'Discovery',
        'widget': 'JourneyScreen._discoveryPage / InteractiveStoryText',
      },
      <String, Object?>{
        'stepIndex': 3,
        'runtimePage': 'Challenge',
        'widget': 'JourneyScreen._challengePage / HskStoryChallenge',
      },
      <String, Object?>{
        'stepIndex': 4,
        'runtimePage': 'Memory',
        'widget': 'JourneyScreen._memoryPage',
      },
      <String, Object?>{
        'stepIndex': 4,
        'runtimePage': 'Completion',
        'widget': 'JourneyScreen._memoryPage completed state',
      },
    ];

    for (final story in stories) {
      final storyId = story['id']!;
      final storyTitle = story['title']!;
      for (var level = 1; level <= 10; level += 1) {
        late List<InteractiveStoryText> storyBlocks;
        late List<WordEntry> words;

        final storyActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 0,
          inspect: (_) async {
            storyBlocks = tester
                .widgetList<InteractiveStoryText>(find.byType(InteractiveStoryText))
                .where((widget) => widget.narrationContentId == 'story')
                .toList(growable: false);
            expect(storyBlocks, isNotEmpty);
            words = storyBlocks.first.entries;
            final paragraphs = storyBlocks.map((widget) => widget.text).toList(growable: false);
            return <String, Object?>{
              'renderedParagraphs': paragraphs,
              'paragraphCount': paragraphs.length,
              'renderedPageTexts': _renderedTexts(),
            };
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Story',
          step: 0,
          actual: storyActual,
          sourceController: 'JourneyScreen._levelContent -> _defaultStoryPage',
          contentGenerator: storyId == forbiddenCitySecondStoryId
              ? 'forbiddenCitySecondStoryPreparedBundle'
              : 'JourneyPreparationCoordinator.prepared/prepareNow',
          expectedContract: storyId == forbiddenCitySecondStoryId
              ? 'Founder-reviewed narrative text protected; exercises may carry level progression.'
              : 'Primary Story may vary meaningfully by Phoenix level.',
        ));

        final visibleSources = <String>[
          for (final block in storyBlocks) block.text,
        ];
        final vocabularyModel = <Map<String, Object?>>[
          for (final word in words) _wordMap(word, visibleSources),
        ];
        final vocabularyActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 1,
          inspect: (_) async => <String, Object?>{
            'items': vocabularyModel,
            'itemCount': vocabularyModel.length,
            'renderedPageTexts': _renderedTexts(),
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Vocabulary',
          step: 1,
          actual: vocabularyActual,
          sourceController: 'JourneyScreen._levelContent.words -> _wordsPage / WordDetailSheet',
          contentGenerator: storyId == forbiddenCitySecondStoryId
              ? 'forbiddenCitySecondStoryPreparedBundle.levelContent.words'
              : 'JourneyPreparationCoordinator levelContent.words',
          expectedContract: 'Deterministic per level; Story-relevant vocabulary with meaningful level progression where required.',
        ));

        final discoveryActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 2,
          inspect: (_) async {
            final blocks = tester
                .widgetList<InteractiveStoryText>(find.byType(InteractiveStoryText))
                .where((widget) => widget.narrationContentId == 'discovery')
                .toList(growable: false);
            expect(blocks, isNotEmpty);
            return <String, Object?>{
              'renderedDiscoveries': blocks.map((widget) => widget.text).toList(growable: false),
              'discoveryCount': blocks.length,
              'renderedPageTexts': _renderedTexts(),
              'renderedAuthorityTexts': _renderedTexts()
                  .where((value) => value.contains('来源') || value.contains('故宫') || value.contains('UNESCO'))
                  .toList(growable: false),
            };
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Discovery',
          step: 2,
          actual: discoveryActual,
          sourceController: 'JourneyScreen._levelContent.discoveries -> _discoveryPage',
          contentGenerator: storyId == forbiddenCitySecondStoryId
              ? 'forbiddenCitySecondStoryPreparedBundle.levelContent.discoveries'
              : 'JourneyPreparationCoordinator levelContent.discoveries',
          expectedContract: 'Beijing / Forbidden City knowledge, current Story context, level-meaningful variation.',
        ));

        final challengeActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 3,
          inspect: (_) async {
            expect(find.byType(HskStoryChallenge), findsOneWidget);
            final widget = tester.widget<HskStoryChallenge>(find.byType(HskStoryChallenge));
            expect(widget.challenge.sessionLevel, level);
            final ttsBefore = ttsSpeakCalls;
            final renderedQuestions = await _exerciseChallenge(tester, widget.challenge);
            return <String, Object?>{
              'questionCount': widget.challenge.questions.length,
              'questions': renderedQuestions,
              'feedbackAudioCallbackBound': widget.onFeedbackAudio != null,
              'ttsSpeakCallsDuringChallenge': ttsSpeakCalls - ttsBefore,
            };
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Challenge',
          step: 3,
          actual: challengeActual,
          sourceController: 'JourneyScreen._preparedChallenge -> HskStoryChallenge',
          contentGenerator: 'JourneyChallengeEngine.build(final rendered order)',
          expectedContract: '12 rendered questions; Sentence Rebuild, Grammar, Completion; Lv progression; feedback; deterministic balanced MCQ; Beijing / Forbidden City relevance.',
        ));

        final memoryActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 4,
          inspect: (_) async => <String, Object?>{
            'renderedPageTexts': _renderedTexts(),
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Memory',
          step: 4,
          actual: memoryActual,
          sourceController: 'JourneyScreen._memoryPage',
          contentGenerator: storyId == forbiddenCitySecondStoryId
              ? 'forbiddenCitySecondStoryMemoryForLevel / CompletionForLevel'
              : 'forbiddenCityMemoryForLevel / CompletionForLevel',
          expectedContract: 'Story-isolated level-aware memory/review state.',
        ));

        final completionActual = await _withRenderedJourney<Map<String, Object?>>(
          tester,
          storyId: storyId,
          level: level,
          step: 4,
          completed: true,
          inspect: (_) async => <String, Object?>{
            'renderedPageTexts': _renderedTexts(),
          },
        );
        rows.add(_stageRow(
          storyId: storyId,
          storyTitle: storyTitle,
          level: level,
          stage: 'Completion',
          step: 4,
          actual: completionActual,
          sourceController: 'JourneyScreen._memoryPage completed state',
          contentGenerator: 'Forbidden City completion runtime',
          expectedContract: 'Completed Journey summary remains Story-isolated and reflects session level.',
        ));
      }
    }

    expect(rows.length, 2 * 10 * 6);
    final payload = <String, Object?>{
      'candidate_sha': Platform.environment['PR208_AUDIT_SHA'] ?? '',
      'journey': '中国 → 北京 → 紫禁城',
      'runtimeTopology': topology,
      'stories': stories,
      'rows': rows,
    };
    final output = Platform.environment['PR208_LEVEL_STAGE_RAW_JSON'];
    expect(output, isNotNull);
    expect(output, isNotEmpty);
    File(output!)
      ..createSync(recursive: true)
      ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(payload));
  });
}
