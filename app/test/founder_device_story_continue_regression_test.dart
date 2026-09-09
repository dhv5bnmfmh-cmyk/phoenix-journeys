import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  const journeyId = 'beijing-forbidden-city';
  const flutterTtsChannel = MethodChannel('flutter_tts');

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  Future<void> expectContinueRendersVocabulary(
    WidgetTester tester, {
    required bool hangTransitionStop,
  }) async {
    final previousLevel = PhoenixLevelController.instance.level;
    addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
    PhoenixLevelController.instance.setLevel(5);

    final pendingStop = Completer<dynamic>();
    var speakCalls = 0;
    var transitionStopIssued = false;
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTtsChannel, (call) async {
      if (call.method == 'getVoices') return <dynamic>[];
      if (call.method == 'speak') {
        speakCalls += 1;
        return 1;
      }
      if (call.method == 'stop' && speakCalls > 0 && !transitionStopIssued) {
        transitionStopIssued = true;
        calls.add(find.byKey(const ValueKey('单词')).evaluate().isNotEmpty
            ? 'transition-stop:AFTER-VOCABULARY'
            : 'transition-stop:BEFORE-VOCABULARY');
        if (hangTransitionStop) return pendingStop.future;
      }
      return 1;
    });
    addTearDown(() {
      if (!pendingStop.isCompleted) pendingStop.complete(1);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterTtsChannel, null);
    });

    final state = AppState();
    addTearDown(state.dispose);
    await state.load();
    await state.activateJourney(journeyId);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: JourneyScreen(journeyId: journeyId)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 180));

    await tester.tap(find.byKey(const ValueKey('narration-main-control')));
    await tester.pump(const Duration(milliseconds: 260));
    await tester.tap(find.widgetWithText(FilledButton, '继续'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(calls, isNot(contains('transition-stop:BEFORE-VOCABULARY')));
    expect(calls, contains('transition-stop:AFTER-VOCABULARY'));
    expect(state.beijingJourneyStep, 1);
    expect(find.byKey(const ValueKey('单词')), findsOneWidget);

    await tester.pump(const Duration(seconds: 9));
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets(
    'Golden Story one tap renders Vocabulary before hanging cleanup',
    (tester) => expectContinueRendersVocabulary(
      tester,
      hangTransitionStop: true,
    ),
  );

  testWidgets(
    'Golden Story normal cleanup follows visible navigation',
    (tester) => expectContinueRendersVocabulary(
      tester,
      hangTransitionStop: false,
    ),
  );
}
