import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
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

  Future<void> waitForStoryStart(WidgetTester tester) async {
    for (var attempt = 0; attempt < 30; attempt += 1) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byKey(const ValueKey('故事')).evaluate().isNotEmpty) return;
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
}
