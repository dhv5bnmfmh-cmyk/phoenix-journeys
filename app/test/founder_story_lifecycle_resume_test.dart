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

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets(
    'Story lock and unlock resumes once beyond the saved position',
    (tester) async {
      final previousLevel = PhoenixLevelController.instance.level;
      addTearDown(
        () => PhoenixLevelController.instance.setLevel(previousLevel),
      );
      PhoenixLevelController.instance.setLevel(5);

      final spokenTexts = <String>[];
      var stopCalls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterTtsChannel, (call) async {
        if (call.method == 'getVoices') return <dynamic>[];
        if (call.method == 'speak') {
          spokenTexts.add(call.arguments as String);
          return 1;
        }
        if (call.method == 'stop') stopCalls += 1;
        return 1;
      });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(flutterTtsChannel, null);
      });

      final state = AppState();
      addTearDown(state.dispose);
      await state.load();
      await state.activateJourney(journeyId);
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: const MaterialApp(
            home: JourneyScreen(journeyId: journeyId),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.byKey(const ValueKey('narration-main-control')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(seconds: 3));
      expect(spokenTexts, hasLength(1));

      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.inactive,
      );
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.hidden,
      );
      await tester.pump(const Duration(milliseconds: 500));
      final savedOffset = state.journeyNarrationOffsetFor('story');
      expect(savedOffset, greaterThan(0));

      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      await tester.pump(const Duration(milliseconds: 800));

      expect(spokenTexts, hasLength(2));
      expect(spokenTexts.last.length, lessThan(spokenTexts.first.length));
      expect(
        spokenTexts.first.length - spokenTexts.last.length,
        closeTo(savedOffset, 2),
      );
      expect(stopCalls, greaterThanOrEqualTo(1));

      // Explicit replay remains the only path that starts this identity at 0.
      await tester.tap(find.byTooltip('重新播放'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(spokenTexts, hasLength(3));
      expect(spokenTexts.last, spokenTexts.first);
    },
  );
}
