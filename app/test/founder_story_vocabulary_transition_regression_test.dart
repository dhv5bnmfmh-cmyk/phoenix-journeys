import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test('Second Story runtime pronunciation audit covers risky readings', () {
    final content = forbiddenCitySecondStoryLevelContent();

    expect(
      content.storyParagraphs,
      const <String>[
        '交接前，林乔把记录册推到新同事许澄面前。许澄第二天就要接手，问明天是否直接照表使用。林乔已经拔开笔帽，却又把笔放回桌上：“先一起核对一遍。”两人从前面的页码往后看。许澄圈出“中轴”，又在“景运门”旁做了记号。他说这两处还容易弄混。林乔让他先标出不确定处。翻到旧表时，两人发现景运门被标在乾清门前广场西侧。许澄问：“如果我明天照这张表走呢？”林乔的手停在签名栏上。她原本只差签名就能完成交接，现在却不愿把疑问留给接手的人。',
        '两人把图页摊开，核到景运门位于乾清门前广场东侧。许澄圈住旧表的“西”，没有擦掉。林乔也没有只把“西”改成“东”。她让许澄把疑问写在页边，再一起核对。能确认的当场更正，不能确认的先留空。林乔签下更正，把笔递给许澄。“接手以后，也照这个办法往下查。”许澄接过册子，指着两个空格确认要继续核对。最后，他把待核的格子折了角，把签字笔放到两人中间。他问：“下一页一起看完？”林乔把椅子拉近。',
      ],
      reason: 'Founder-reviewed Second Story source prose must remain unchanged.',
    );

    final runtimeSources = <MapEntry<String, String>>[
      for (var index = 0; index < content.storyParagraphs.length; index += 1)
        MapEntry(
          content.storyParagraphs[index],
          content.storyAnnotations[index].pinyin,
        ),
      for (final discovery in content.discoveries)
        MapEntry(discovery.text, discovery.pinyin),
    ];

    void expectRuntimeReading(String phrase, String expected) {
      final matches = runtimeSources
          .where((source) => source.key.contains(phrase))
          .toList(growable: false);
      expect(
        matches,
        isNotEmpty,
        reason: 'Pronunciation audit phrase must come from visible runtime content: $phrase',
      );
      for (final source in matches) {
        expect(
          source.value,
          contains(expected),
          reason: 'Visible runtime pinyin must read $phrase as $expected.',
        );
      }
    }

    const expectedReadings = <String, String>{
      '林乔': 'lín qiáo',
      '许澄': 'xǔ chéng',
      '紫禁城': 'zǐ jìn chéng',
      '乾清门': 'qián qīng mén',
      '景运门': 'jǐng yùn mén',
      '中轴': 'zhōng zhóu',
      '午门': 'wǔ mén',
      '核对': 'hé duì',
      '交接': 'jiāo jiē',
      '空格': 'kòng gé',
      '还容易': 'hái róng yì',
      '不确定处': 'bù què dìng chù',
      '只差签名': 'zhǐ chà qiān míng',
      '当场更正': 'dāng chǎng gēng zhèng',
      '更正': 'gēng zhèng',
      '折了角': 'zhé le jiǎo',
      '待核': 'dài hé',
      '圈出': 'quān chū',
      '留空': 'liú kòng',
      '前面的页码': 'qián miàn de yè mǎ',
      '确认的当场': 'què rèn de dāng chǎng',
      '指着': 'zhǐ zhe',
      '地图': 'dì tú',
      '背建筑名字': 'bèi jiàn zhù míng zi',
    };
    for (final entry in expectedReadings.entries) {
      expectRuntimeReading(entry.key, entry.value);
    }

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
