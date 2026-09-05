import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/journey_memory_photo_panel.dart';

void main() {
  StoryChallengeQuestion rebuildQuestion() {
    return const JourneyChallengeEngine()
        .build(
          journeyId: 'beijing-forbidden-city',
          sessionLevel: 8,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[7],
        )
        .questions
        .firstWhere((item) => item.mode == StoryChallengeMode.sentenceRebuild);
  }

  List<String> correctChunks(StoryChallengeQuestion question) {
    final available = List<String>.of(question.characterTiles);
    final ordered = <String>[];
    var cursor = 0;
    while (available.isNotEmpty && cursor < question.answer.length) {
      final match = available.indexWhere(
        (tile) => question.answer.startsWith(tile, cursor),
      );
      expect(match, isNonNegative);
      final tile = available.removeAt(match);
      ordered.add(tile);
      cursor += tile.length;
    }
    expect(cursor, question.answer.length);
    return ordered;
  }

  Future<List<String>> pumpRebuild(
    WidgetTester tester,
    StoryChallengeQuestion question,
  ) async {
    final narration = <String>[];
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
              onNarrate: (_, text) async => narration.add(text),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return narration;
  }

  Future<void> submitRebuild(
    WidgetTester tester,
    StoryChallengeQuestion question, {
    required bool correct,
  }) async {
    final chunks = correctChunks(question);
    if (!correct) {
      expect(chunks.length, greaterThan(1));
      final first = chunks[0];
      chunks[0] = chunks[1];
      chunks[1] = first;
    }
    for (final chunk in chunks) {
      await tester.tap(find.widgetWithText(ActionChip, chunk).first);
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();
  }

  testWidgets('Sentence Rebuild speaker is hidden before submit with no leak', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);

    expect(
      find.byKey(ValueKey('challenge-speaker-${question.id}')),
      findsNothing,
    );
    expect(narration, isEmpty);
  });

  testWidgets('Sentence Rebuild speaker uses question.answer after correct submit', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);
    await submitRebuild(tester, question, correct: true);

    final speaker = find.byKey(ValueKey('challenge-speaker-${question.id}'));
    expect(speaker, findsOneWidget);
    await tester.tap(speaker);
    await tester.pump();
    expect(narration, <String>[question.answer]);
  });

  testWidgets('Sentence Rebuild speaker also appears after wrong submit', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);
    await submitRebuild(tester, question, correct: false);

    final speaker = find.byKey(ValueKey('challenge-speaker-${question.id}'));
    expect(speaker, findsOneWidget);
    await tester.tap(speaker);
    await tester.pump();
    expect(narration, <String>[question.answer]);
  });

  Uint8List previewPng() => base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9ZC7sAAAAASUVORK5CYII=',
      );

  testWidgets('Photo Memory shows add state and local-only hint', (tester) async {
    var picks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: null,
            loadPhoto: (_) async => null,
            busy: false,
            onPick: () => picks += 1,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('journey-memory-photo-add')), findsOneWidget);
    expect(find.text('照片仅保存在此设备'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('journey-memory-photo-add')));
    expect(picks, 1);
  });

  testWidgets('Photo Memory renders preview with replace and delete controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: 'local-photo-ref',
            loadPhoto: (_) async => previewPng(),
            busy: false,
            onPick: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('journey-memory-photo-preview')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('journey-memory-photo-replace')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('journey-memory-photo-delete')),
      findsOneWidget,
    );
    expect(find.text('local-photo-ref'), findsNothing);
  });

  testWidgets('Photo Memory busy state blocks duplicate taps and reports failure', (
    tester,
  ) async {
    var picks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: null,
            loadPhoto: (_) async => null,
            busy: true,
            errorText: '无法读取照片，请重试',
            onPick: () => picks += 1,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('journey-memory-photo-add')));
    expect(picks, 0);
    expect(find.text('无法读取照片，请重试'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Photo Memory preview read failure is explicit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: 'broken-local-ref',
            loadPhoto: (_) async => throw StateError('read failed'),
            busy: false,
            onPick: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('无法读取照片，请重试'), findsOneWidget);
    expect(find.text('broken-local-ref'), findsNothing);
  });
}
