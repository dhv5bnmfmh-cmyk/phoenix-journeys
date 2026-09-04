import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/theme/phoenix_theme.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';
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

  testWidgets(
    'NARRATION INLINE ACTIVE HIGHLIGHT has no yellow surface decoration',
    (tester) async {
      final state = AppState();
      addTearDown(state.dispose);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const MaterialApp(
            home: Scaffold(
              body: InteractiveStoryText(
                text: '紫禁城里的路线会改变人物的选择。',
                entries: [],
                narrationItemId: 'borderless-active',
                highlightStart: 0,
                highlightEnd: 3,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final surface = tester.widget<AnimatedContainer>(
        find.byKey(
          const ValueKey('narration-follow-surface-borderless-active'),
        ),
      );
      expect(surface.decoration, isNull);

      final marker = find.byKey(
        const ValueKey('reading-highlight-borderless-active'),
      );
      expect(marker, findsOneWidget);
      final activeTextFinder = find.descendant(
        of: marker,
        matching: find.byType(Text),
      );
      expect(activeTextFinder, findsOneWidget);
      final activeText = tester.widget<Text>(activeTextFinder);
      expect(activeText.style?.color, const Color(0xFFFFE7AA));
      expect(activeText.style?.fontWeight, FontWeight.w900);
    },
  );

  testWidgets(
    'Lv1 Lv6 Lv10 Story and Discovery have no yellow narration surface',
    (tester) async {
      final state = AppState();
      addTearDown(state.dispose);

      for (final level in <int>[1, 6, 10]) {
        final bundle = JourneyPreparationCoordinator.instance.prepareNow(
          journeyId: 'beijing-forbidden-city',
          profile: profile(level),
          scriptMode: 'simplified',
        );
        final samples = <String, String>{
          'story-lv$level': bundle.levelContent.storyParagraphs.first,
          'discovery-lv$level': bundle.levelContent.discoveries.first.text,
        };

        for (final sample in samples.entries) {
          await tester.pumpWidget(
            ChangeNotifierProvider<AppState>.value(
              value: state,
              child: MaterialApp(
                home: Scaffold(
                  body: InteractiveStoryText(
                    text: sample.value,
                    entries: const [],
                    narrationItemId: sample.key,
                    highlightStart: 0,
                    highlightEnd: 1,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();

          final surface = tester.widget<AnimatedContainer>(
            find.byKey(ValueKey('narration-follow-surface-${sample.key}')),
          );
          expect(
            surface.decoration,
            isNull,
            reason: '${sample.key} must have no background, border, or shadow',
          );

          final marker = find.byKey(
            ValueKey('reading-highlight-${sample.key}'),
          );
          expect(marker, findsOneWidget, reason: sample.key);
          final activeTextFinder = find.descendant(
            of: marker,
            matching: find.byType(Text),
          );
          expect(activeTextFinder, findsOneWidget, reason: sample.key);
          final activeText = tester.widget<Text>(activeTextFinder);
          expect(
            activeText.style?.color,
            const Color(0xFFFFE7AA),
            reason: '${sample.key} must keep inline narration color',
          );
          expect(
            activeText.style?.fontWeight,
            FontWeight.w900,
            reason: '${sample.key} must keep inline narration weight',
          );
        }
      }
    },
  );

  test('Story and Discovery both route through InteractiveStoryText', () {
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
    final storyStart = journey.indexOf('Widget _defaultStoryPage()');
    final storyEnd = journey.indexOf('Widget _wordsPage()', storyStart);
    final discoveryStart = journey.indexOf('Widget _discoveryPage()');
    final discoveryEnd = journey.indexOf('Widget _wonderPage()', discoveryStart);

    expect(storyStart, isNonNegative);
    expect(storyEnd, greaterThan(storyStart));
    expect(discoveryStart, isNonNegative);
    expect(discoveryEnd, greaterThan(discoveryStart));

    final story = journey.substring(storyStart, storyEnd);
    final discovery = journey.substring(discoveryStart, discoveryEnd);
    expect(story, contains('InteractiveStoryText('));
    expect(discovery, contains('InteractiveStoryText('));
    expect(story, contains('transparentSurface: true'));
    expect(discovery, contains('transparentSurface: true'));
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

  testWidgets('Forbidden City completed Finale centers exactly one stamp', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final state = AppState();
    addTearDown(state.dispose);
    await state.load();
    await state.activateJourney('beijing-forbidden-city');
    await state.completeJourney('', sessionLevel: 4);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: JourneyScreen(journeyId: 'beijing-forbidden-city'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    final stamp = find.byKey(const ValueKey('animated-city-journey-stamp'));
    final city = find.textContaining('北京 · 紫禁城');
    final reward = find.text('Challenge Reward');

    expect(stamp, findsOneWidget);
    expect(find.byKey(const ValueKey('city-stamp-tool')), findsOneWidget);
    expect(find.byKey(const ValueKey('city-stamp-imprint')), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
    expect(find.text('Journey 完成'), findsNothing);
    expect(city, findsOneWidget);
    expect(reward, findsOneWidget);
    expect(find.textContaining('Spatial Evidence'), findsOneWidget);
    expect(find.textContaining('Journey 已记录'), findsOneWidget);
    expect(find.text('重新体验'), findsOneWidget);
    expect(find.text('返回首页'), findsOneWidget);

    expect(tester.getTopLeft(city).dy, lessThan(tester.getTopLeft(stamp).dy));
    expect(tester.getTopLeft(stamp).dy, lessThan(tester.getTopLeft(reward).dy));
  });

  testWidgets('completed progress header has no standalone top stamp', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyProgressHeader(
            currentStep: 4,
            furthestStep: 4,
            isCompleted: true,
            labels: const <String>[
              'Story',
              'Vocabulary',
              'Discovery',
              'Challenge',
              '回忆 · 完成',
            ],
            onStepSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('animated-city-journey-stamp')), findsNothing);
    expect(find.text('5/5'), findsOneWidget);
    expect(find.text('回忆 · 完成'), findsOneWidget);
    expect(find.text('课程已完成 · 可自由选择'), findsOneWidget);
  });

  test('Finale stamp wiring keeps persistence single and hero-local', () {
    final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
    final progress =
        File('lib/widgets/journey_progress_header.dart').readAsStringSync();

    expect(journey, contains('await _appState.completeJourney('));
    expect(journey, contains("'Challenge Reward'"));
    expect(journey, contains('Journey 已记录'));
    expect(progress, isNot(contains('AnimatedCityJourneyStamp(')));
    expect(progress, isNot(contains('completeJourney(')));
    expect(progress, isNot(contains('awardChallengeRewardOnce(')));

    final completedStart =
        journey.indexOf('if (_forbiddenCityFinaleCompleted) ...[');
    final completedEnd = journey.indexOf('] else ...[', completedStart);
    expect(completedStart, isNonNegative);
    expect(completedEnd, greaterThan(completedStart));
    final completedBranch = journey.substring(completedStart, completedEnd);

    expect(completedBranch, contains('AnimatedCityJourneyStamp('));
    expect(
      completedBranch,
      contains("key: const ValueKey('forbidden-city-finale-stamp')"),
    );
    expect(completedBranch, isNot(contains('check_circle_rounded')));
    expect(completedBranch, isNot(contains("'Journey 完成'")));
    expect(
      'AnimatedCityJourneyStamp('.allMatches(completedBranch).length,
      1,
    );
  });
}
