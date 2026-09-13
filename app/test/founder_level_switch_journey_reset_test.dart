import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/journey_level_selector_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const journeyId = 'beijing-forbidden-city';
  const flutterTtsChannel = MethodChannel('flutter_tts');
  final ttsCalls = <String>[];

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PhoenixLevelController.instance.setLevel(5);
    ttsCalls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTtsChannel, (call) async {
      ttsCalls.add(call.method);
      if (call.method == 'getVoices') return <dynamic>[];
      return 1;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(flutterTtsChannel, null);
    PhoenixLevelController.instance.setLevel(
      PhoenixLevelController.defaultLevel,
    );
  });

  Future<AppState> pumpChallenge(WidgetTester tester, {required int level}) async {
    PhoenixLevelController.instance.setLevel(level);
    final state = AppState();
    await state.load();
    await state.activateJourney(journeyId);
    await state.saveJourneyProgress(
      step: 3,
      wonder: '',
      express: '',
      memory: '',
    );
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: JourneyScreen(journeyId: journeyId),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Challenge'), findsOneWidget);
    expect(find.text('挑战 1/12'), findsOneWidget);
    return state;
  }

  Future<AppState> stateAtStep({required int level, required int step}) async {
    PhoenixLevelController.instance.setLevel(level);
    final state = AppState();
    await state.load();
    await state.activateJourney(journeyId);
    await state.saveJourneyProgress(
      step: step,
      wonder: '',
      express: '',
      memory: '',
    );
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('phoenix.level', level);
    await preferences.setString('phoenix.languageProficiency', 'phoenix:$level');
    return state;
  }

  Finder levelPlus() => find.descendant(
        of: find.byKey(const ValueKey('phoenix-level-plus')),
        matching: find.byType(IconButton),
      );

  Future<void> pumpLevelSelector(WidgetTester tester, AppState state) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(
            body: Center(child: JourneyLevelSelectorButton()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpJourney(WidgetTester tester, AppState state) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(
          home: JourneyScreen(journeyId: journeyId),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> waitForStoryStart(WidgetTester tester) async {
    for (var attempt = 0; attempt < 30; attempt += 1) {
      await tester.pump(const Duration(milliseconds: 100));
      final storyVisible =
          find.byKey(const ValueKey('故事')).evaluate().isNotEmpty;
      final oldChallengeGone = find.text('挑战 1/12').evaluate().isEmpty;
      if (storyVisible && oldChallengeGone) return;
    }
  }

  void disposeStateAfterWidget(WidgetTester tester, AppState state) {
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    });
  }

  testWidgets('Lv5 Challenge Q1 to Lv6 starts Lv6 Golden Story', (tester) async {
    final state = await pumpChallenge(tester, level: 5);
    disposeStateAfterWidget(tester, state);

    PhoenixLevelController.instance.setLevel(6);
    await waitForStoryStart(tester);

    expect(state.beijingJourneyStep, 0);
    expect(find.byKey(const ValueKey('journey-session-level-badge')), findsOneWidget);
    expect(find.text('Lv.6'), findsWidgets);
    expect(find.byKey(const ValueKey('故事')), findsOneWidget);
    expect(find.text('挑战 1/12'), findsNothing);
    expect(find.text('回答正确'), findsNothing);
    expect(find.text('回答错误'), findsNothing);
    debugPrint('LEVEL SWITCH MOUNTED → STORY START: PASS');
  });

  testWidgets('submitted Challenge and audio reset before Lv7 Story', (tester) async {
    final state = await pumpChallenge(tester, level: 3);
    disposeStateAfterWidget(tester, state);

    final questionSpeaker = find.byTooltip('朗读题目');
    expect(questionSpeaker, findsOneWidget);
    await tester.tap(questionSpeaker);
    await tester.pump(const Duration(milliseconds: 200));
    while (find.byType(ActionChip).evaluate().isNotEmpty) {
      await tester.tap(find.byType(ActionChip).first);
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();
    expect(find.textContaining('回答'), findsWidgets);
    final feedbackSpeaker = find.byTooltip('朗读答题反馈');
    expect(feedbackSpeaker, findsOneWidget);
    await tester.tap(feedbackSpeaker);
    await tester.pump(const Duration(milliseconds: 200));
    final stopsBeforeLevelSwitch =
        ttsCalls.where((method) => method == 'stop').length;

    PhoenixLevelController.instance.setLevel(7);
    await waitForStoryStart(tester);

    expect(state.beijingJourneyStep, 0);
    expect(find.text('Lv.7'), findsWidgets);
    expect(find.byKey(const ValueKey('故事')), findsOneWidget);
    expect(find.text('挑战 1/12'), findsNothing);
    expect(find.text('回答正确'), findsNothing);
    expect(find.text('回答错误'), findsNothing);
    expect(find.byKey(const ValueKey('challenge-inline-feedback')), findsNothing);
    expect(
      ttsCalls.where((method) => method == 'stop').length,
      greaterThan(stopsBeforeLevelSwitch),
    );
  });

  testWidgets('multiple switches each restart at selected-level Story', (tester) async {
    final state = await pumpChallenge(tester, level: 3);
    disposeStateAfterWidget(tester, state);

    for (final level in <int>[6, 2]) {
      PhoenixLevelController.instance.setLevel(level);
      await waitForStoryStart(tester);
      expect(state.beijingJourneyStep, 0, reason: 'Lv$level');
      expect(find.text('Lv.$level'), findsWidgets);
      expect(find.byKey(const ValueKey('故事')), findsOneWidget);
      expect(find.text('挑战 1/12'), findsNothing);
    }
  });

  testWidgets('replay Challenge first question back returns to Discovery', (tester) async {
    final state = await stateAtStep(level: 5, step: 4);
    disposeStateAfterWidget(tester, state);
    await state.completeJourney('', sessionLevel: 5);
    expect(state.journeyCompleted, isTrue);
    await state.restartJourney();
    await state.saveJourneyProgress(
      step: 3,
      wonder: '',
      express: '',
      memory: '',
    );

    await pumpJourney(tester, state);
    expect(find.text('Challenge'), findsOneWidget);
    expect(find.text('挑战 1/12'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('challenge-bottom-actions')),
      findsOneWidget,
    );
    final back = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('challenge-back')),
    );
    expect(back.onPressed, isNotNull);

    await tester.tap(find.byKey(const ValueKey('challenge-back')));
    await tester.pump(const Duration(milliseconds: 700));

    expect(state.beijingJourneyStep, 2);
    expect(find.byKey(const ValueKey('发现')), findsOneWidget);
    expect(find.text('挑战 1/12'), findsNothing);
    expect(
      find.byKey(const ValueKey('challenge-bottom-actions')),
      findsNothing,
    );
    debugPrint('REPLAY BACK NAV: PASS');
    debugPrint('REPLAY 上一步 ENABLED: PASS');
    debugPrint('BOTTOM NAV ROW COUNT: 1 MAX');
  });

  testWidgets('unmounted selector switch resets Challenge before next Journey mount', (
    tester,
  ) async {
    final state = await stateAtStep(level: 3, step: 3);
    disposeStateAfterWidget(tester, state);
    expect(state.beijingJourneyStep, 3);

    // JourneyScreen is deliberately absent while the global selector changes level.
    await pumpLevelSelector(tester, state);
    expect(find.text('Lv.3'), findsOneWidget);
    await tester.tap(levelPlus());
    await tester.pump();

    expect(PhoenixLevelController.instance.level, 4);
    expect(state.beijingJourneyStep, 0);
    expect(state.journeyCompleted, isFalse);

    await pumpJourney(tester, state);
    await waitForStoryStart(tester);
    expect(find.text('Lv.4'), findsWidgets);
    expect(find.byKey(const ValueKey('故事')), findsOneWidget);
    expect(find.text('挑战 1/12'), findsNothing);
    expect(find.text('回答正确'), findsNothing);
    expect(find.text('回答错误'), findsNothing);
    expect(find.text('继续留下回忆'), findsNothing);
    debugPrint('LEVEL SWITCH UNMOUNTED → STORY START: PASS');
    debugPrint('LEVEL STATE LEAK: 0');
  });

  testWidgets('unmounted selector switch resets Memory before next Journey mount', (
    tester,
  ) async {
    final state = await stateAtStep(level: 3, step: 4);
    disposeStateAfterWidget(tester, state);
    expect(state.beijingJourneyStep, 4);

    await pumpLevelSelector(tester, state);
    await tester.tap(levelPlus());
    await tester.pump();

    expect(PhoenixLevelController.instance.level, 4);
    expect(state.beijingJourneyStep, 0);
    expect(state.journeyCompleted, isFalse);

    await pumpJourney(tester, state);
    await waitForStoryStart(tester);
    expect(find.text('Lv.4'), findsWidgets);
    expect(find.byKey(const ValueKey('故事')), findsOneWidget);
    expect(find.text('回忆 · 完成'), findsNothing);
    expect(find.text('挑战 1/12'), findsNothing);
    expect(find.text('继续留下回忆'), findsNothing);
    debugPrint('LEVEL SWITCH FROM MEMORY → STORY START: PASS');
    debugPrint('LEVEL STATE LEAK: 0');
  });
}
