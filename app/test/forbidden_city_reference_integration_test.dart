import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_trace_validation.dart';
import 'package:phoenix_journeys/screens/forbidden_city_reference_journey_screen.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _referenceLevels = <int>[1, 3, 5, 8, 10];
const _legacyStoryTokens = <String>[
  '一道没有跨过的门槛',
  '没有跨过门槛',
  '没有跨过去',
  '地图空白',
  '空白地图',
  '规定路线',
  '不该跨',
  '写下“界”',
  '旧木尺',
  'only prescribed route',
  'blank map',
  'threshold boundary',
];

class _RouteHarness extends StatelessWidget {
  const _RouteHarness();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          key: const ValueKey('launch-forbidden-city'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  const JourneyScreen(journeyId: forbiddenCityJourneyId),
            ),
          ),
          child: const Text('Launch Forbidden City'),
        ),
      ),
    );
  }
}

Future<AppState> _pumpHarness(WidgetTester tester) async {
  final state = AppState(clock: () => DateTime(2026, 8, 21, 21, 30));
  await state.load();
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: const MaterialApp(home: _RouteHarness()),
    ),
  );
  await tester.tap(find.byKey(const ValueKey('launch-forbidden-city')));
  await tester.pumpAndSettle();
  return state;
}

Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  expect(finder, findsOneWidget, reason: key);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _tapExactText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  expect(finder, findsOneWidget, reason: text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _finishReferenceChallenge(WidgetTester tester, int level) async {
  final story = forbiddenCityParagraphRebuild.singleWhere(
    (item) => item.level == level,
  );
  final evidence = forbiddenCityGrammarRepair.singleWhere(
    (item) => item.level == level,
  );
  final transfer = forbiddenCityMissingSentence.singleWhere(
    (item) => item.level == level,
  );

  expect(find.text('故事理解'), findsOneWidget);
  for (final index in story.correctOrder) {
    await _tapKey(tester, 'forbidden-city-story-option-$index');
  }
  await _tapKey(tester, 'forbidden-city-challenge-submit');
  expect(
    find.byKey(const ValueKey('forbidden-city-challenge-resolution')),
    findsOneWidget,
  );
  await _tapKey(tester, 'forbidden-city-challenge-continue');

  expect(find.text('证据推理'), findsOneWidget);
  expect(
    find.byKey(const ValueKey('forbidden-city-evidence-context')),
    findsOneWidget,
  );
  await _tapExactText(tester, evidence.evidenceAnswer);
  await _tapKey(tester, 'forbidden-city-challenge-submit');
  await _tapKey(tester, 'forbidden-city-challenge-continue');

  expect(find.text('迁移决策'), findsOneWidget);
  expect(
    find.byKey(const ValueKey('forbidden-city-transfer-context')),
    findsOneWidget,
  );
  await _tapExactText(tester, transfer.transferAnswer);
  await _tapKey(tester, 'forbidden-city-challenge-submit');
  await _tapKey(tester, 'forbidden-city-challenge-continue');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('Reference Journey keeps the only six-stage order', () {
    expect(AppState.journeyStepLabels, const <String>[
      '故事',
      '单词',
      '发现',
      '挑战',
      '回忆',
      '完成',
    ]);
    expect(AppState.journeyLastStep, 5);
  });

  test('Vocabulary earliest Story trace is derived and has zero orphans', () {
    expect(validateForbiddenCityWordTrace(), isEmpty);
    expect(validateForbiddenCityImportedWords(), isEmpty);

    for (final record in forbiddenCityWordRecords) {
      final earliest = forbiddenCityLockedStories.indexWhere(
            (story) => story.contains(record.entry.word),
          ) +
          1;
      expect(earliest, greaterThan(0), reason: record.entry.word);
      expect(record.firstAppearsAt, earliest, reason: record.entry.word);
      expect(record.storySource, contains(record.entry.word));
      expect(
        forbiddenCityLockedStories[earliest - 1],
        contains(record.storySource),
        reason: '${record.entry.word} storySource',
      );
    }

    expect(
      forbiddenCityWordRecords
          .singleWhere((record) => record.entry.word == '判断')
          .firstAppearsAt,
      3,
    );
    expect(
      forbiddenCityWordRecords
          .singleWhere((record) => record.entry.word == '证据')
          .firstAppearsAt,
      5,
    );

    for (var level = 1; level <= 10; level++) {
      final story = forbiddenCityLockedStories[level - 1];
      for (final word in forbiddenCityWordsForLevel(level)) {
        final trace = forbiddenCityWordRecords.singleWhere(
          (record) => record.entry.word == word.word,
        );
        expect(story, contains(word.word), reason: 'Lv$level ${word.word}');
        expect(
          story,
          contains(trace.storySource),
          reason: 'Lv$level ${word.word} storySource',
        );
      }
    }
  });

  test('Reference Challenge package is cognition-first at Lv1/3/5/8/10', () {
    for (final level in _referenceLevels) {
      final story = forbiddenCityLockedStories[level - 1];
      final comprehension = forbiddenCityParagraphRebuild.singleWhere(
        (item) => item.level == level,
      );
      final evidence = forbiddenCityGrammarRepair.singleWhere(
        (item) => item.level == level,
      );
      final transfer = forbiddenCityMissingSentence.singleWhere(
        (item) => item.level == level,
      );

      expect(comprehension.cognitiveTarget, startsWith('Story comprehension'));
      expect(comprehension.segments.every(story.contains), isTrue);
      expect(evidence.evidenceQuestion.trim(), isNotEmpty);
      expect(evidence.evidenceAnswer.trim(), isNotEmpty);
      expect(evidence.evidenceAnswer, isNot(equals(evidence.broken)));
      expect(transfer.transferOptions, hasLength(4));
      expect(transfer.transferOptions, contains(transfer.transferAnswer));
      expect(story, isNot(contains(transfer.transferQuestion)));
      expect(story, isNot(contains(transfer.transferAnswer)));
      expect(transfer.transferQuestion, isNot(equals(transfer.answer)));
    }
  });

  test('Lv-specific Memory and Completion payloads are all distinct', () {
    final memories = <String>{};
    final completions = <String>{};
    for (final level in _referenceLevels) {
      final memory = forbiddenCityMemoryForLevel(level);
      final completion = forbiddenCityCompletionForLevel(level);
      memories.add(
        '${memory.recall}|${memory.characterShift}|${memory.anchor}|${memory.takeaway}',
      );
      completions.add(
        '${completion.storyClosure}|${completion.discovery}|${completion.learning}|'
        '${completion.memory}|${completion.relationship}|'
        '${completion.emotionalClosure}|${completion.unlockResult}',
      );
      expect(memory.anchor.trim(), isNotEmpty, reason: 'Lv$level memory');
      expect(completion.unlockResult, contains('Lv$level'));
    }
    expect(memories, hasLength(_referenceLevels.length));
    expect(completions, hasLength(_referenceLevels.length));
  });

  test(
    'Geo registry returns World Asia China Beijing Dongcheng Forbidden City',
    () {
      final binding = requireJourneyLocation(forbiddenCityJourneyId);
      expect(binding.geoNodeId, 'cn-beijing-dongcheng-forbidden-city');
      expect(
        binding.geoPath.map((node) => node.id).toList(growable: false),
        const <String>[
          'world',
          'asia',
          'cn',
          'cn-beijing',
          'cn-beijing-dongcheng',
          'cn-beijing-dongcheng-forbidden-city',
        ],
      );
      expect(binding.countryNode?.id, 'cn');
      expect(binding.districtNode?.id, 'cn-beijing-dongcheng');
    },
  );

  test(
    'active Reference payloads contain zero legacy Forbidden City semantics',
    () {
      final active = StringBuffer()
        ..writeln(forbiddenCityLockedStories.join('\n'))
        ..writeln(forbiddenCityDiscoveries.map((item) => item.text).join('\n'));
      for (var level = 1; level <= 10; level++) {
        final memory = forbiddenCityMemoryForLevel(level);
        final completion = forbiddenCityCompletionForLevel(level);
        active
          ..writeln(memory.recall)
          ..writeln(memory.characterShift)
          ..writeln(memory.anchor)
          ..writeln(memory.takeaway)
          ..writeln(completion.storyClosure)
          ..writeln(completion.discovery)
          ..writeln(completion.learning)
          ..writeln(completion.memory)
          ..writeln(completion.relationship)
          ..writeln(completion.emotionalClosure)
          ..writeln(completion.unlockResult);
      }
      final corpus = active.toString().toLowerCase();
      for (final legacy in _legacyStoryTokens) {
        expect(corpus, isNot(contains(legacy.toLowerCase())), reason: legacy);
      }
    },
  );

  testWidgets('canonical routing renders only the Reference Journey screen', (
    tester,
  ) async {
    await _pumpHarness(tester);
    expect(find.byType(ForbiddenCityReferenceJourneyScreen), findsOneWidget);
    expect(
      find.byKey(const ValueKey('forbidden-city-level-selection')),
      findsOneWidget,
    );
  });

  for (final level in _referenceLevels) {
    testWidgets('Lv$level full Reference Journey persists and returns', (
      tester,
    ) async {
      final state = await _pumpHarness(tester);
      await _tapKey(tester, 'forbidden-city-level-$level');

      expect(
        find.byKey(ValueKey('forbidden-city-stage-story-lv-$level')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('forbidden-city-six-stage-header')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('forbidden-city-pinyin-0')),
        findsOneWidget,
      );
      final speak = tester.widget<IconButton>(
        find.byKey(const ValueKey('forbidden-city-story-speak-0')),
      );
      expect(speak.onPressed, isNotNull);

      await _tapKey(tester, 'forbidden-city-next');
      expect(
        find.byKey(ValueKey('forbidden-city-stage-vocabulary-lv-$level')),
        findsOneWidget,
      );

      await _tapKey(tester, 'forbidden-city-next');
      expect(
        find.byKey(ValueKey('forbidden-city-stage-discovery-lv-$level')),
        findsOneWidget,
      );

      await _tapKey(tester, 'forbidden-city-next');
      expect(
        find.byKey(ValueKey('forbidden-city-stage-challenge-lv-$level')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('forbidden-city-reference-challenge-lv-$level')),
        findsOneWidget,
      );
      await _finishReferenceChallenge(tester, level);

      final memory = forbiddenCityMemoryForLevel(level);
      expect(
        find.byKey(ValueKey('forbidden-city-stage-memory-lv-$level')),
        findsOneWidget,
      );
      expect(find.text(memory.anchor), findsOneWidget);

      await _tapKey(tester, 'forbidden-city-next');
      final completion = forbiddenCityCompletionForLevel(level);
      expect(
        find.byKey(ValueKey('forbidden-city-stage-completion-lv-$level')),
        findsOneWidget,
      );
      expect(find.text(completion.storyClosure), findsOneWidget);
      expect(find.text(completion.unlockResult), findsOneWidget);
      expect(state.journeyCompleted, isTrue);
      expect(state.journeyStep, AppState.journeyLastStep);
      expect(state.isJourneyStampEarned(forbiddenCityJourneyId), isTrue);

      final restored = AppState(clock: () => DateTime(2026, 8, 22, 8));
      await restored.load();
      expect(restored.activeJourneyId, forbiddenCityJourneyId);
      expect(restored.journeyCompleted, isTrue);
      expect(restored.journeyStep, AppState.journeyLastStep);
      expect(restored.isJourneyStampEarned(forbiddenCityJourneyId), isTrue);

      await _tapKey(tester, 'forbidden-city-return');
      expect(
        find.byKey(const ValueKey('launch-forbidden-city')),
        findsOneWidget,
      );
    });
  }

  testWidgets(
    'runtime exposes Simplified Traditional English Vietnamese and Pinyin',
    (tester) async {
      final state = await _pumpHarness(tester);
      await _tapKey(tester, 'forbidden-city-level-10');
      final content = forbiddenCityLevelContent(10);
      final annotation = content.storyAnnotations.first;

      expect(find.text(content.storyParagraphs.first), findsOneWidget);
      expect(find.text(annotation.vietnamese), findsOneWidget);
      expect(find.text(annotation.pinyin), findsOneWidget);

      await state.setTranslationLanguage('英语');
      await tester.pumpAndSettle();
      expect(find.text(annotation.english), findsOneWidget);

      await state.toggleScript();
      await tester.pumpAndSettle();
      expect(
        find.text(state.displayText(content.storyParagraphs.first)),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('forbidden-city-pinyin-0')),
        findsOneWidget,
      );
    },
  );
}
