import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/extended_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

String _identity(String value) => value;

Finder _key(String value) => find.byKey(ValueKey(value));

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = _key(key);
  expect(finder, findsOneWidget, reason: 'missing key $key');
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

List<String> _textsUnder(Finder finder) => find
    .descendant(of: finder, matching: find.byType(Text))
    .evaluate()
    .map((element) => element.widget)
    .whereType<Text>()
    .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .toList(growable: false);

String _optionText(String key) {
  final finder = _key(key);
  if (finder.evaluate().isEmpty) return '';
  final texts = _textsUnder(finder)
      .where((value) => !RegExp(r'^[A-D]$').hasMatch(value))
      .toList(growable: false);
  return texts.isEmpty ? '' : texts.last;
}

List<String> _visibleOptions() {
  final finder = _key('challenge-four-options');
  if (finder.evaluate().isEmpty) return const <String>[];
  return _textsUnder(finder)
      .where((value) => !RegExp(r'^[A-D]$').hasMatch(value))
      .toList(growable: false);
}

Future<void> _pump(
  WidgetTester tester, {
  required DailyJourneyExperience journey,
  required int level,
}) async {
  const agent = PhoenixLanguageLevelAgent();
  final profile = agent.profileForPhoenixLevel(level);
  final active = resolveAdaptiveJourneyLevel(journey, profile: profile);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 430,
          height: 900,
          child: JourneyChallengePanel(
            journeyId: journey.id,
            storyParagraphs: active.storyParagraphs,
            discoveryTexts: active.discoveries
                .map((entry) => entry.text)
                .toList(growable: false),
            profile: profile,
            seed: 17000 + level,
            displayText: _identity,
            onResolved: (_, __) async {},
            onAllCompleted: () async {},
            autoNarrate: false,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _completeParagraph(
  WidgetTester tester, {
  required String journeyId,
  required int level,
}) async {
  for (var index = 0; index < 4; index++) {
    final key = 'challenge-option-correct-$index';
    if (_key(key).evaluate().isNotEmpty) await _tap(tester, key);
  }
  await _tap(tester, 'challenge-submit');
  expect(_key('challenge-explanation-dialog'), findsOneWidget);
}

Future<void> _completeGrammar(WidgetTester tester) async {
  for (var segment = 0; segment < 6; segment++) {
    final segmentKey = 'challenge-grammar-segment-$segment';
    if (_key(segmentKey).evaluate().isEmpty) continue;
    await _tap(tester, segmentKey);
    await _tap(tester, 'challenge-option-correct');
    await _tap(tester, 'challenge-submit');
    if (_key('challenge-explanation-dialog').evaluate().isNotEmpty) return;
  }
  fail('grammarRepair did not resolve with any visible segment');
}

Future<void> _completeMissing(WidgetTester tester) async {
  await _tap(tester, 'challenge-option-correct');
  await _tap(tester, 'challenge-submit');
  expect(_key('challenge-explanation-dialog'), findsOneWidget);
}

Map<String, Object?> _baseRow({
  required DailyJourneyExperience journey,
  required int level,
  required String mode,
  required List<String> story,
  required List<String> discovery,
  required List<String> vocabulary,
  required String correctAnswer,
}) {
  final question = _key('challenge-question-card').evaluate().isEmpty
      ? const <String>[]
      : _textsUnder(_key('challenge-question-card'));
  return <String, Object?>{
    'journeyId': journey.id,
    'city': journey.city,
    'place': journey.place,
    'storyTitle': journey.storyTitle,
    'level': level,
    'mode': mode,
    'question': question,
    'options': _visibleOptions(),
    'correctAnswer': correctAnswer,
    'story': story,
    'discovery': discovery,
    'vocabulary': vocabulary,
    'activeStorySource': 'resolveAdaptiveJourneyLevel:${journey.id}:Lv$level',
    'activeDiscoverySource':
        'resolveAdaptiveJourneyLevel:${journey.id}:Lv$level',
    'activeVocabularySource':
        'resolveAdaptiveJourneyLevel:${journey.id}:Lv$level',
    'activeChallengeSource': 'JourneyChallengePanel',
    'activeResolver': 'resolveAdaptiveJourneyLevel',
    'activeBinding': 'dedicatedAdaptiveJourneyIds',
  };
}

void main() {
  testWidgets('exports every approved Gold active Challenge unit', (
    tester,
  ) async {
    const agent = PhoenixLanguageLevelAgent();
    final approvedIds = approvedNarrativeDnaCatalog
        .map((record) => record.journeyId)
        .toSet();

    // Runtime candidate membership is intentionally broader than Founder-approved
    // Gold membership. Every approved Gold must be active, but an active candidate
    // such as Lijiang must not be promoted merely to satisfy this snapshot.
    expect(dedicatedAdaptiveJourneyIds, containsAll(approvedIds));

    final byId = <String, DailyJourneyExperience>{
      for (final journey in <DailyJourneyExperience>[
        ...dailyJourneyExperiences,
        ...extendedJourneyExperiences,
      ])
        journey.id: journey,
    };
    expect(byId.keys, containsAll(approvedIds));

    final rows = <Map<String, Object?>>[];
    for (final journeyId in approvedIds.toList()..sort()) {
      final journey = byId[journeyId]!;
      for (var level = 1; level <= 10; level++) {
        final profile = agent.profileForPhoenixLevel(level);
        final active = resolveAdaptiveJourneyLevel(journey, profile: profile);
        final story = active.storyParagraphs.toList(growable: false);
        final discovery = active.discoveries
            .map((entry) => entry.text)
            .toList(growable: false);
        final vocabulary = active.words
            .map((entry) => entry.word)
            .toList(growable: false);

        await _pump(tester, journey: journey, level: level);

        final paragraphAnswer = <String>[
          for (var index = 0; index < 4; index++)
            if (_optionText('challenge-option-correct-$index').isNotEmpty)
              _optionText('challenge-option-correct-$index'),
        ].join('\n');
        rows.add(
          _baseRow(
            journey: journey,
            level: level,
            mode: 'paragraphRebuild',
            story: story,
            discovery: discovery,
            vocabulary: vocabulary,
            correctAnswer: paragraphAnswer,
          ),
        );
        await _completeParagraph(tester, journeyId: journeyId, level: level);
        rows.last['explanation'] = _textsUnder(
          _key('challenge-explanation-dialog'),
        );
        await _tap(tester, 'challenge-dialog-action');

        final grammarAnswer = _optionText('challenge-option-correct');
        rows.add(
          _baseRow(
            journey: journey,
            level: level,
            mode: 'grammarRepair',
            story: story,
            discovery: discovery,
            vocabulary: vocabulary,
            correctAnswer: grammarAnswer,
          ),
        );
        rows.last['grammarSentence'] =
            _key('challenge-grammar-sentence').evaluate().isEmpty
            ? const <String>[]
            : _textsUnder(_key('challenge-grammar-sentence'));
        await _completeGrammar(tester);
        rows.last['explanation'] = _textsUnder(
          _key('challenge-explanation-dialog'),
        );
        await _tap(tester, 'challenge-dialog-action');

        final missingAnswer = _optionText('challenge-option-correct');
        rows.add(
          _baseRow(
            journey: journey,
            level: level,
            mode: 'missingSentence',
            story: story,
            discovery: discovery,
            vocabulary: vocabulary,
            correctAnswer: missingAnswer,
          ),
        );
        rows.last['contextBefore'] =
            _textsUnder(find.byKey(const ValueKey('challenge-fit-area')))
                .where(
                  (value) =>
                      story.any((paragraph) => paragraph.contains(value)),
                )
                .take(4)
                .toList(growable: false);
        await _completeMissing(tester);
        rows.last['explanation'] = _textsUnder(
          _key('challenge-explanation-dialog'),
        );
        await _tap(tester, 'challenge-dialog-action');
      }
    }

    expect(rows.length, approvedIds.length * 10 * 3);
    for (final row in rows) {
      final visible = <String>[
        if (row['correctAnswer'] case final String value) value,
        for (final value in (row['options'] as List<String>)) value,
      ];
      for (final value in visible) {
        expect(
          value.contains('。”。') ||
              value.contains('！”。') ||
              value.contains('？”。'),
          isFalse,
          reason:
              '${row['journeyId']} Lv${row['level']} ${row['mode']} duplicated quote punctuation: $value',
        );
      }
    }
    final payload = <String, Object?>{
      'approvedGoldCount': approvedIds.length,
      'expectedChallengeUnits': approvedIds.length * 10 * 3,
      'approvedJourneyIds': approvedIds.toList()..sort(),
      'rows': rows,
    };
    final output = Platform.environment['PHOENIX_ALL_GOLD_SNAPSHOT_JSON'];
    if (output != null && output.isNotEmpty) {
      File(output)
        ..createSync(recursive: true)
        ..writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(payload),
        );
    }
  });
}
