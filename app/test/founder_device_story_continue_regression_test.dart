import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  const journeyId = 'beijing-forbidden-city';
  const flutterTtsChannel = MethodChannel('flutter_tts');

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<AppState> pumpStory(
    WidgetTester tester, {
    required String storyId,
    required int level,
    required List<String> calls,
    required bool hangTransitionStop,
  }) async {
    final previousLevel = PhoenixLevelController.instance.level;
    addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
    PhoenixLevelController.instance.setLevel(level);

    final pendingStop = Completer<dynamic>();
    var speakCalls = 0;
    var transitionStopIssued = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTtsChannel, (call) async {
      calls.add(call.method);
      if (call.method == 'getVoices') return <dynamic>[];
      if (call.method == 'speak') {
        speakCalls += 1;
        return 1;
      }
      if (call.method == 'stop' && speakCalls > 0 && !transitionStopIssued) {
        transitionStopIssued = true;
        final vocabularyAlreadyBuilt =
            find.byKey(const ValueKey('单词')).evaluate().isNotEmpty;
        calls.add(
          vocabularyAlreadyBuilt
              ? 'transition-stop:AFTER-VOCABULARY'
              : 'transition-stop:BEFORE-VOCABULARY',
        );
        if (hangTransitionStop) return pendingStop.future;
        return 1;
      }
      return 1;
    });
    addTearDown(() {
      if (!pendingStop.isCompleted) pendingStop.complete(1);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterTtsChannel, null);
    });

    final state = AppState();
    await state.load();
    await state.activateJourney(journeyId, storyId: storyId);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          home: JourneyScreen(journeyId: journeyId, storyId: storyId),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    return state;
  }

  Future<void> startStoryNarration(WidgetTester tester) async {
    final narration = find.byKey(const ValueKey('narration-main-control'));
    expect(narration, findsOneWidget);
    await tester.tap(narration);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));
    expect(
      find.byTooltip('暂停朗读'),
      findsOneWidget,
      reason: 'Story narration must be active before Continue.',
    );
  }

  Future<void> expectContinueRendersVocabulary(
    WidgetTester tester, {
    required String storyId,
    required int level,
    required String label,
    required bool hangTransitionStop,
  }) async {
    final calls = <String>[];
    final state = await pumpStory(
      tester,
      storyId: storyId,
      level: level,
      calls: calls,
      hangTransitionStop: hangTransitionStop,
    );
    await startStoryNarration(tester);

    final continueButton = find.widgetWithText(FilledButton, '继续');
    expect(continueButton, findsOneWidget);
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    expect(state.beijingJourneyStep, 0);

    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();

    expect(
      calls.contains('transition-stop:BEFORE-VOCABULARY'),
      isFalse,
      reason:
          '$label must commit/render primary navigation before any external engine cleanup is invoked.',
    );
    expect(
      calls.contains('transition-stop:AFTER-VOCABULARY'),
      isTrue,
      reason:
          '$label must still issue best-effort engine cleanup after Vocabulary has built.',
    );
    expect(tester.takeException(), isNull);
    expect(state.beijingJourneyStep, 1);
    expect(
      find.byKey(const ValueKey('单词')),
      findsOneWidget,
      reason: '$label must visibly render Vocabulary after one tap.',
    );

    await tester.pump(const Duration(seconds: 9));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
  }

  testWidgets(
    'Second Story Lv6 one tap renders Vocabulary before hanging external cleanup',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCitySecondStoryId,
        level: 6,
        label: 'Second Story Lv6',
        hangTransitionStop: true,
      );
    },
  );

  testWidgets(
    'Second Story Lv5 one tap renders Vocabulary before hanging external cleanup',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCitySecondStoryId,
        level: 5,
        label: 'Second Story Lv5',
        hangTransitionStop: true,
      );
    },
  );

  testWidgets(
    'Existing Story Lv5 one tap renders Vocabulary before hanging external cleanup',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCityPrimaryStoryId,
        level: 5,
        label: 'Existing Story Lv5',
        hangTransitionStop: true,
      );
    },
  );

  testWidgets(
    'Second Story Lv6 normal external cleanup still follows visible navigation',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCitySecondStoryId,
        level: 6,
        label: 'Second Story Lv6 normal stop',
        hangTransitionStop: false,
      );
    },
  );
}
