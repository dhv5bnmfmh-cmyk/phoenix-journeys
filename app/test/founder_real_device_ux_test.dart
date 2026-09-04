import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';
import 'package:phoenix_journeys/theme/phoenix_theme.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/journey_progress_header.dart';

void main() {
  const engine = JourneyChallengeEngine();

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

  Future<void> pumpSingleQuestion(
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
                sessionLevel: 4,
                questions: <StoryChallengeQuestion>[question],
              ),
              displayText: (value) => value,
              onNarrate: (_, __) async {},
              onFeedbackAudio: (_, __) async {},
              onCompleted: () async {},
            ),
          ),
        ),
      ),
    );
  }

  FilledButton submitButton(WidgetTester tester) => tester.widget<FilledButton>(
        find.byKey(const ValueKey('challenge-submit')),
      );

  test('shared Journey content surfaces are borderless glass', () {
    expect(PhoenixTheme.destinationGlass().border, isNull);
    expect(PhoenixTheme.journeyPanelDecoration.border, isNull);
    expect(PhoenixTheme.journeyWritingPanelDecoration.border, isNull);
    expect(PhoenixTheme.journeySolidPanelDecoration.border, isNull);

    final focused = PhoenixTheme.journeyWritingInputDecoration('hint').focusedBorder
        as OutlineInputBorder;
    expect(focused.borderSide.color, PhoenixTheme.contentAccent);
    expect(focused.borderSide.width, greaterThan(0));
  });

  testWidgets('Sentence Rebuild tap returns only the chosen built tile', (
    tester,
  ) async {
    final question = challenge(5).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.sentenceRebuild);
    expect(question.characterTiles.length, greaterThanOrEqualTo(3));
    await pumpSingleQuestion(tester, question);

    final selected = question.characterTiles.take(3).toList(growable: false);
    for (final tile in selected) {
      await tester.tap(find.widgetWithText(ActionChip, tile).first);
      await tester.pump();
    }

    expect(submitButton(tester).onPressed, isNull);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-0')),
        matching: find.text(selected[0]),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-1')),
        matching: find.text(selected[1]),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-2')),
        matching: find.text(selected[2]),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('challenge-rebuild-built-1')));
    await tester.pump();

    expect(find.widgetWithText(ActionChip, selected[1]), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-0')),
        matching: find.text(selected[0]),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('challenge-rebuild-built-1')),
        matching: find.text(selected[2]),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('challenge-rebuild-built-2')), findsNothing);
  });

  testWidgets('Lv4 Completion clears and refills one filled blank directly', (
    tester,
  ) async {
    final question = challenge(4).questions
        .firstWhere((q) => q.mode == StoryChallengeMode.storyCompletion);
    expect(question.completionBlanks, hasLength(4));
    await pumpSingleQuestion(tester, question);

    for (final blank in question.completionBlanks) {
      final correctIndex = blank.options.indexOf(blank.answer);
      await tester.tap(
        find.text('${String.fromCharCode(65 + correctIndex)}  ${blank.answer}'),
      );
      await tester.pump();
    }

    expect(submitButton(tester).onPressed, isNotNull);
    for (var i = 0; i < question.completionBlanks.length; i++) {
      expect(
        find.text('〔${i + 1}〕${question.completionBlanks[i].answer}'),
        findsOneWidget,
      );
    }

    await tester.tap(find.byKey(const ValueKey('completion-passage-blank-1')));
    await tester.pump();

    expect(find.text('〔2〕____'), findsOneWidget);
    expect(find.text('〔1〕${question.completionBlanks[0].answer}'), findsOneWidget);
    expect(find.text('〔3〕${question.completionBlanks[2].answer}'), findsOneWidget);
    expect(find.text('〔4〕${question.completionBlanks[3].answer}'), findsOneWidget);
    expect(submitButton(tester).onPressed, isNull);

    final blankTwo = question.completionBlanks[1];
    final correctIndex = blankTwo.options.indexOf(blankTwo.answer);
    await tester.tap(
      find.text('${String.fromCharCode(65 + correctIndex)}  ${blankTwo.answer}'),
    );
    await tester.pump();

    expect(find.text('〔2〕${blankTwo.answer}'), findsOneWidget);
    expect(submitButton(tester).onPressed, isNotNull);
  });

  testWidgets('Forbidden City completed Finale restores existing stamp motion', (
    tester,
  ) async {
    final completed = ValueNotifier<bool>(false);
    addTearDown(completed.dispose);
    const labels = <String>[
      'Story',
      'Vocabulary',
      'Discovery',
      'Challenge',
      '回忆 · 完成',
    ];

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: completed,
            builder: (context, done, _) => Column(
              children: [
                JourneyProgressHeader(
                  currentStep: 4,
                  furthestStep: 4,
                  isCompleted: done,
                  labels: labels,
                  onStepSelected: (_) {},
                ),
                if (done) ...const [
                  Text('Journey 完成'),
                  Text('Challenge Reward'),
                  Text('返回首页'),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('animated-city-journey-stamp')), findsNothing);
    completed.value = true;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(
      find.byKey(const ValueKey('animated-city-journey-stamp')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('city-stamp-tool')), findsOneWidget);
    expect(find.byKey(const ValueKey('city-stamp-imprint')), findsOneWidget);
    expect(find.text('Journey 完成'), findsOneWidget);
    expect(find.text('Challenge Reward'), findsOneWidget);
    expect(find.text('返回首页'), findsOneWidget);
  });

  test('Finale stamp wiring does not duplicate completion persistence', () {
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
    final progress =
        File('lib/widgets/journey_progress_header.dart').readAsStringSync();

    expect(journey, contains('await _appState.completeJourney('));
    expect(journey, contains("'Journey 完成'"));
    expect(journey, contains("'Challenge Reward'"));
    expect(journey, contains('Journey 已记录'));
    expect(progress, contains('AnimatedCityJourneyStamp('));
    expect(progress, isNot(contains('completeJourney(')));
    expect(progress, isNot(contains('awardChallengeRewardOnce(')));
  });
}
