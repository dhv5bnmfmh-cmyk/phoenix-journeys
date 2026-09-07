import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/screens/journey_screen.dart';
import 'package:phoenix_journeys/services/narration_controller.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/word_detail_sheet.dart';

void main() {
  const journeyId = 'beijing-forbidden-city';

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<AppState> pumpStory(
    WidgetTester tester, {
    required String storyId,
  }) async {
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
    await tester.pump(const Duration(milliseconds: 120));
    return state;
  }

  Future<void> expectStoryToVocabularyTransition(
    WidgetTester tester, {
    required String storyId,
  }) async {
    final state = await pumpStory(tester, storyId: storyId);
    expect(state.beijingJourneyStep, 0);

    final continueButton = find.widgetWithText(FilledButton, '继续');
    expect(continueButton, findsOneWidget);
    await tester.tap(continueButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 420));

    expect(state.beijingJourneyStep, 1);
    expect(
      find.byKey(const ValueKey('next-word-button')),
      findsOneWidget,
      reason: 'Vocabulary phase must render its first word after Continue.',
    );
  }

  testWidgets(
    'Founder regression: Second Story Lv6 Story Continue renders Vocabulary',
    (tester) async {
      final previousLevel = PhoenixLevelController.instance.level;
      addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
      PhoenixLevelController.instance.setLevel(6);

      await expectStoryToVocabularyTransition(
        tester,
        storyId: forbiddenCitySecondStoryId,
      );
    },
  );

  testWidgets(
    'Existing Story Story Continue still renders Vocabulary',
    (tester) async {
      final previousLevel = PhoenixLevelController.instance.level;
      addTearDown(() => PhoenixLevelController.instance.setLevel(previousLevel));
      PhoenixLevelController.instance.setLevel(6);

      await expectStoryToVocabularyTransition(
        tester,
        storyId: forbiddenCityPrimaryStoryId,
      );
    },
  );

  testWidgets(
    'hanging word TTS cannot permanently lock Vocabulary navigation',
    (tester) async {
      final state = AppState();
      addTearDown(state.dispose);
      await state.load();
      await state.activateJourney(
        journeyId,
        storyId: forbiddenCitySecondStoryId,
      );

      final controller = NarrationController();
      addTearDown(controller.dispose);
      final pendingSpeech = Completer<bool>();
      final words = forbiddenCitySecondStoryLevelContent().words;

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: FilledButton(
                  key: const ValueKey('open-word-detail'),
                  onPressed: () {
                    unawaited(
                      showWordDetail(
                        context,
                        words.first,
                        narrationController: controller,
                        onSpeak: () => pendingSpeech.future,
                        entries: words,
                        initialIndex: 0,
                        onSpeakEntry: (_) => pendingSpeech.future,
                      ),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('open-word-detail')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      var next = tester.widget<FilledButton>(
        find.byKey(const ValueKey('next-word-button')),
      );
      expect(next.onPressed, isNull);

      await tester.pump(const Duration(seconds: 4));
      await tester.pump();

      next = tester.widget<FilledButton>(
        find.byKey(const ValueKey('next-word-button')),
      );
      expect(next.onPressed, isNotNull);
      expect(
        find.text('当前浏览器没有提供中文语音，请检查静音设置。'),
        findsOneWidget,
      );
    },
  );

  test('Second Story pronunciation source audit covers risky readings', () {
    String reading(String text) => PinyinHelper.getPinyinE(
          text,
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        );

    expect(reading('乾清门'), 'qián qīng mén');
    expect(reading('景运门'), 'jǐng yùn mén');
    expect(reading('中轴'), 'zhōng zhóu');
    expect(reading('许澄'), 'xǔ chéng');
    expect(reading('圈出'), 'quān chū');
    expect(reading('更正'), 'gēng zhèng');
    expect(reading('留空'), 'liú kòng');
    expect(reading('空格'), 'kòng gé');
    expect(reading('折了角'), 'zhé le jiǎo');

    final content = forbiddenCitySecondStoryLevelContent();
    final words = {for (final word in content.words) word.word: word.pinyin};
    expect(words['中轴'], 'zhōngzhóu');
    expect(words['景运门'], 'jǐngyùnmén');
    expect(words['核对'], 'héduì');
    expect(words['交接'], 'jiāojiē');

    final bundle = forbiddenCitySecondStoryPreparedBundle(
      phoenixLevel: 6,
      scriptMode: 'simplified',
    );
    expect(
      bundle.narrationItems,
      content.storyParagraphs,
      reason: 'Story narration must contain source prose only, not UI metadata.',
    );
  });
}
