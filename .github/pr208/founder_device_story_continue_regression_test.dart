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
  }) async {
    final previousLevel = PhoenixLevelController.instance.level;
    addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
    PhoenixLevelController.instance.setLevel(level);

    final pendingStop = Completer<dynamic>();
    var speakCalls = 0;
    var hangingStopIssued = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTtsChannel, (call) async {
      calls.add(call.method);
      if (call.method == 'getVoices') return <dynamic>[];
      if (call.method == 'speak') {
        speakCalls += 1;
        return 1;
      }
      if (call.method == 'stop' && speakCalls > 0 && !hangingStopIssued) {
        hangingStopIssued = true;
        calls.add('stop:HANG');
        return pendingStop.future;
      }
      return 1;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterTtsChannel, null);
    });

    final state = AppState();
    addTearDown(state.dispose);
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
  }) async {
    final calls = <String>[];
    final state = await pumpStory(
      tester,
      storyId: storyId,
      level: level,
      calls: calls,
    );
    await startStoryNarration(tester);

    final continueButton = find.widgetWithText(FilledButton, '继续');
    expect(continueButton, findsOneWidget);
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    expect(state.beijingJourneyStep, 0);

    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(
      calls.contains('stop:HANG'),
      isTrue,
      reason: '$label must exercise a never-returning speech stop.',
    );
    expect(
      tester.takeException(),
      isNull,
      reason: '$label must not throw during transition.',
    );
    expect(
      state.beijingJourneyStep,
      1,
      reason: '$label must commit Story -> Vocabulary.',
    );
    expect(
      find.byKey(const ValueKey('next-word-button')),
      findsOneWidget,
      reason: '$label must render the next phase, not only mutate state.',
    );

    await tester.pump(const Duration(seconds: 9));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
  }

  testWidgets(
    'Second Story Lv5 Continue renders Vocabulary when narration stop never returns',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCitySecondStoryId,
        level: 5,
        label: 'Second Story Lv5',
      );
    },
  );

  testWidgets(
    'Second Story Lv6 Continue renders Vocabulary when narration stop never returns',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCitySecondStoryId,
        level: 6,
        label: 'Second Story Lv6',
      );
    },
  );

  testWidgets(
    'Existing Story Lv5 Continue renders Vocabulary when narration stop never returns',
    (tester) async {
      await expectContinueRendersVocabulary(
        tester,
        storyId: forbiddenCityPrimaryStoryId,
        level: 5,
        label: 'Existing Story Lv5',
      );
    },
  );
}
