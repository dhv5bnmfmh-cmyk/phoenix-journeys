from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
journey_path = ROOT / 'app/lib/screens/journey_screen.dart'
doc_path = ROOT / 'docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md'
widget_path = ROOT / 'app/lib/widgets/journey_stage_narration_button.dart'
widget_test_path = ROOT / 'app/test/journey_stage_narration_button_test.dart'
contract_test_path = ROOT / 'app/test/journey_memory_completion_narration_contract_test.dart'


def replace_once(source: str, old: str, new: str, label: str) -> str:
    count = source.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected exactly one match, found {count}')
    return source.replace(old, new, 1)


def replace_count(source: str, old: str, new: str, expected: int, label: str) -> str:
    count = source.count(old)
    if count != expected:
        raise RuntimeError(f'{label}: expected {expected} matches, found {count}')
    return source.replace(old, new)


widget_path.write_text(r'''import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

@visibleForTesting
String journeyStageNarrationLanguageCode(bool isTraditional) =>
    isTraditional ? 'zh-TW' : 'zh-CN';

@visibleForTesting
List<NarrationItem> buildJourneyStageNarrationItems({
  required String stage,
  required List<String> displayedLines,
}) {
  final cleanLines = displayedLines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);
  return [
    for (var index = 0; index < cleanLines.length; index++)
      NarrationItem(
        id: '$stage-$index',
        text: cleanLines[index],
        label: '${stage == 'memory' ? '回忆' : '完成'} ${index + 1}',
      ),
  ];
}

class JourneyStageNarrationButton extends StatelessWidget {
  const JourneyStageNarrationButton({
    super.key,
    required this.stage,
    required this.isPlaying,
    required this.onPressed,
  });

  final String stage;
  final bool isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isPlaying ? '停止朗读' : '播放朗读';
    return Semantics(
      button: true,
      label: label,
      value: isPlaying ? '正在朗读' : '未播放',
      child: ExcludeSemantics(
        child: SizedBox(
          key: ValueKey('$stage-narration-touch-target'),
          width: 44,
          height: 44,
          child: IconButton(
            tooltip: label,
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              foregroundColor: PhoenixTheme.red,
              backgroundColor: Colors.white.withValues(alpha: .72),
              side: BorderSide(
                color: PhoenixTheme.gold.withValues(alpha: .34),
              ),
            ),
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
              key: ValueKey('$stage-narration-${isPlaying ? 'stop' : 'play'}'),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
''', encoding='utf-8')

widget_test_path.write_text(r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_stage_narration_button.dart';

void main() {
  testWidgets('Memory speaker exposes play semantics and 44px touch target', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerRight,
            child: JourneyStageNarrationButton(
              key: const ValueKey('memory-narration-button'),
              stage: 'memory',
              isPlaying: false,
              onPressed: () => taps += 1,
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('播放朗读'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    final size = tester.getSize(
      find.byKey(const ValueKey('memory-narration-touch-target')),
    );
    expect(size.width, greaterThanOrEqualTo(44));
    expect(size.height, greaterThanOrEqualTo(44));

    await tester.tap(find.byKey(const ValueKey('memory-narration-touch-target')));
    expect(taps, 1);
  });

  testWidgets('Completion speaker renders an explicit stop state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyStageNarrationButton(
            stage: 'completion',
            isPlaying: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('停止朗读'), findsOneWidget);
    expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
  });

  testWidgets('speaker remains layout-safe at narrow width and large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: const Scaffold(
            body: SizedBox(
              width: 48,
              child: JourneyStageNarrationButton(
                stage: 'memory',
                isPlaying: false,
                onPressed: null,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('memory-narration-touch-target')), findsOneWidget);
  });

  test('narration item builder is empty-safe and preserves displayed script', () {
    final traditional = buildJourneyStageNarrationItems(
      stage: 'memory',
      displayedLines: const ['  記憶中的城牆。  ', '', '回家。'],
    );
    expect(traditional.map((item) => item.text).toList(), [
      '記憶中的城牆。',
      '回家。',
    ]);
    expect(
      buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: const ['', '  '],
      ),
      isEmpty,
    );
  });

  test('narration locale follows the displayed Chinese script', () {
    expect(journeyStageNarrationLanguageCode(false), 'zh-CN');
    expect(journeyStageNarrationLanguageCode(true), 'zh-TW');
  });
}
''', encoding='utf-8')

contract_test_path.write_text(r'''import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
  final standard = File('../docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md').readAsStringSync();

  test('Memory and Completion use one shared narration runtime', () {
    expect(RegExp(r'NarrationController\(\)').allMatches(journey).length, 1);
    expect(RegExp("narrationStage: 'memory'").allMatches(journey).length, 3);
    expect(RegExp("narrationStage: 'completion'").allMatches(journey).length, 3);
    expect(journey, contains('Widget _stageNarrationFrame({'));
    expect(journey, contains('await _narration.stop();'));
    expect(journey, contains('await _narration.play('));
  });

  test('narration is user initiated and cancelled on Journey exits', () {
    expect(journey, isNot(contains('_scheduleStageNarration')));
    expect(journey, contains('Future<void> _stopJourneyNarration()'));
    expect(journey, contains('Future<void> _exitJourney()'));
    expect(
      RegExp(r'onNext: \(\) => unawaited\(_exitJourney\(\)\),')
          .allMatches(journey)
          .length,
      3,
    );
    expect(journey, contains('Future<void> _restartJourney() async {\n    await _stopJourneyNarration();'));
    expect(journey, contains('await _stopJourneyNarration();\n    await _appState.clearJourneyNarrationPosition();'));
  });

  test('stage narration binds active Journey level and displayed script', () {
    expect(journey, contains("'${_experience.id}:${_readingLevelLabel}:$stage'"));
    expect(journey, contains('journeyStageNarrationLanguageCode(_appState.isTraditional)'));
    expect(journey, contains('_appState.displayText(review.prompt)'));
    expect(journey, contains('_appState.displayText(item.answer)'));
    expect(journey, contains('memoryController.text.trim()'));
  });

  test('six-stage architecture is unchanged', () {
    final expected = <String>[
      '_storyPage(),',
      '_wordsPage(),',
      '_discoveryPage(),',
      ': _challengePage(),',
      ': _memoryPage(),',
      '_completePage(),',
    ];
    for (final anchor in expected) {
      expect(journey, contains(anchor));
    }
    expect(journey, isNot(contains('Audio Stage')));
  });

  test('canonical authority binds optional Memory and Completion narration', () {
    expect(
      standard,
      contains('MEMORY AND COMPLETION MUST SUPPORT USER-INITIATED NARRATION'),
    );
    expect(standard, contains('no forced autoplay'));
    expect(standard, contains('leave-page auto stop'));
  });
}
''', encoding='utf-8')

journey = journey_path.read_text(encoding='utf-8')
journey = replace_once(
    journey,
    "import '../widgets/journey_progress_header.dart';\n",
    "import '../widgets/journey_progress_header.dart';\nimport '../widgets/journey_stage_narration_button.dart';\n",
    'speaker import',
)
journey = replace_once(
    journey,
    '  late final NarrationController _narration;\n',
    '  late final NarrationController _narration;\n  String? _stageNarrationRequestedId;\n  int _stageNarrationIntent = 0;\n',
    'stage narration state',
)

# Existing navigation/lifecycle stop sites now also invalidate rapid-tap start intents.
existing_await_stops = journey.count('await _narration.stop();')
if existing_await_stops < 3:
    raise RuntimeError(f'expected at least 3 awaited narration stop sites, found {existing_await_stops}')
journey = journey.replace('await _narration.stop();', 'await _stopJourneyNarration();')
existing_unawaited_stops = journey.count('unawaited(_narration.stop());')
if existing_unawaited_stops < 1:
    raise RuntimeError('expected lifecycle narration stop site')
journey = journey.replace('unawaited(_narration.stop());', 'unawaited(_stopJourneyNarration());')

journey = replace_once(
    journey,
    '    _narration.dispose();\n',
    '    _stageNarrationIntent += 1;\n    _stageNarrationRequestedId = null;\n    _narration.dispose();\n',
    'dispose cancellation',
)

helper_anchor = '  List<NarrationItem> get _storyPlaybackItems => _storyNarrationItems;\n\n'
helpers = r'''  String _stageNarrationContentId(String stage) =>
      '${_experience.id}:${_readingLevelLabel}:$stage';

  List<String> _batchSummaryNarrationLines({required bool completion}) {
    final spec = batchOneMemorySpecFor(_experience.id);
    if (spec == null) return const <String>[];
    final levelVocabulary = _levelContent.words.isEmpty
        ? '本级重点词已复习'
        : _levelContent.words.take(6).map((entry) => entry.word).join(' · ');
    const challenge = '短文复原 · 语病修复 · 补回句子：三种模式全部完成';
    final lines = <String>[
      _appState.displayText(
        completion ? '这段旅程留下了什么' : 'Phoenix 已为你整理这段旅程',
      ),
    ];
    for (final review in spec.reviews) {
      lines.add(_appState.displayText(review.prompt));
      lines.add(
        _appState.displayText(
          review.category == 'vocabulary'
              ? '${review.answer}\n本级复习：$levelVocabulary'
              : review.answer,
        ),
      );
    }
    lines
      ..add(_appState.displayText('Challenge 表现'))
      ..add(_appState.displayText(challenge))
      ..add(_appState.displayText('长期记忆点'))
      ..add(_appState.displayText(spec.longTermAnchor));
    if (completion) {
      lines
        ..add(_appState.displayText('旅程结果'))
        ..add(_appState.displayText(spec.storyResult))
        ..add(_appState.displayText('旅程收束'))
        ..add(_appState.displayText(spec.completionSummary))
        ..add(_appState.displayText('继续探索'))
        ..add(
          _appState.displayText(
            '把这个记忆锚点带进下一段 Journey，继续用中文观察、判断和表达。',
          ),
        );
    }
    return lines;
  }

  List<NarrationItem> _memoryNarrationItems() {
    final batchSpec = batchOneMemorySpecFor(_experience.id);
    if (batchSpec != null) {
      return buildJourneyStageNarrationItems(
        stage: 'memory',
        displayedLines: _batchSummaryNarrationLines(completion: false),
      );
    }
    if (_isForbiddenCity) {
      return buildJourneyStageNarrationItems(
        stage: 'memory',
        displayedLines: [
          for (final item in forbiddenCityMemoryReviews) ...[
            _appState.displayText(item.prompt),
            _appState.displayText(item.answer),
          ],
        ],
      );
    }
    return buildJourneyStageNarrationItems(
      stage: 'memory',
      displayedLines: [
        '今天最想记住的一件事是什么？',
        if (memoryController.text.trim().isNotEmpty) memoryController.text.trim(),
      ],
    );
  }

  List<NarrationItem> _completionNarrationItems() {
    final batchSpec = batchOneMemorySpecFor(_experience.id);
    if (batchSpec != null) {
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: [
          '盖章成功',
          ..._batchSummaryNarrationLines(completion: true),
        ],
      );
    }
    if (_isForbiddenCity) {
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: const [
          forbiddenCityAchievementName,
          forbiddenCityJourneySummary,
          forbiddenCityMemoryAnchor,
          forbiddenCityChallengeRewardName,
          forbiddenCityChallengeRewardMeaning,
          forbiddenCityJourneyCompletion,
        ],
      );
    }
    return buildJourneyStageNarrationItems(
      stage: 'completion',
      displayedLines: const [
        '盖章成功',
        '你完成的不是一堂课，而是一段旅程。',
      ],
    );
  }

  Future<void> _stopJourneyNarration() async {
    _stageNarrationIntent += 1;
    if (mounted && _stageNarrationRequestedId != null) {
      setState(() => _stageNarrationRequestedId = null);
    } else {
      _stageNarrationRequestedId = null;
    }
    await _narration.stop();
  }

  Future<void> _toggleStageNarration({
    required String stage,
    required List<NarrationItem> items,
  }) async {
    if (items.isEmpty) return;
    final contentId = _stageNarrationContentId(stage);
    final active = _stageNarrationRequestedId == contentId ||
        (_narration.contentId == contentId &&
            _narration.status == NarrationStatus.playing);
    final intent = ++_stageNarrationIntent;
    if (mounted) {
      setState(() => _stageNarrationRequestedId = active ? null : contentId);
    }

    await _narration.stop();
    if (!mounted || intent != _stageNarrationIntent || active) return;

    await _narration.play(
      contentId: contentId,
      items: items,
      languageCode: journeyStageNarrationLanguageCode(_appState.isTraditional),
    );
    if (!mounted) return;
    if (intent != _stageNarrationIntent) {
      await _narration.stop();
      return;
    }
    setState(() => _stageNarrationRequestedId = null);
  }

  Widget _stageNarrationFrame({
    required String stage,
    required List<NarrationItem> items,
    required Widget child,
  }) {
    final contentId = _stageNarrationContentId(stage);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              final isPlaying = _stageNarrationRequestedId == contentId ||
                  (_narration.contentId == contentId &&
                      _narration.status == NarrationStatus.playing);
              return JourneyStageNarrationButton(
                key: ValueKey('$stage-narration-button'),
                stage: stage,
                isPlaying: isPlaying,
                onPressed: items.isEmpty
                    ? null
                    : () => unawaited(
                          _toggleStageNarration(stage: stage, items: items),
                        ),
              );
            },
          ),
        ),
        const SizedBox(height: 2),
        Expanded(child: child),
      ],
    );
  }

  Future<void> _exitJourney() async {
    await _stopJourneyNarration();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

'''
journey = replace_once(journey, helper_anchor, helper_anchor + helpers, 'stage narration helpers')

journey = replace_once(
    journey,
    '  Future<void> _restartJourney() async {\n    await _appState.restartJourney();\n',
    '  Future<void> _restartJourney() async {\n    await _stopJourneyNarration();\n    await _appState.restartJourney();\n',
    'restart auto stop',
)
journey = replace_count(
    journey,
    'onNext: () => Navigator.of(context).pop(),',
    'onNext: () => unawaited(_exitJourney()),',
    3,
    'completion exit auto stop',
)

journey = replace_count(
    journey,
    "        title: '旅程回忆',\n",
    "        title: '旅程回忆',\n        narrationStage: 'memory',\n        narrationItems: _memoryNarrationItems(),\n",
    3,
    'Memory shared narration binding',
)
journey = replace_count(
    journey,
    "        title: '${_experience.city}已点亮',\n",
    "        title: '${_experience.city}已点亮',\n        narrationStage: 'completion',\n        narrationItems: _completionNarrationItems(),\n",
    2,
    'Completion shared narration binding',
)
journey = replace_once(
    journey,
    "      title: '北京已点亮',\n",
    "      title: '北京已点亮',\n      narrationStage: 'completion',\n      narrationItems: _completionNarrationItems(),\n",
    'Forbidden City Completion narration binding',
)

journey = replace_once(
    journey,
    '    required Widget child,\n    String buttonText = \'继续\',\n',
    '    required Widget child,\n    String? narrationStage,\n    List<NarrationItem> narrationItems = const <NarrationItem>[],\n    String buttonText = \'继续\',\n',
    '_page narration parameters',
)
journey = replace_once(
    journey,
    '    final state = context.watch<AppState>();\n\n    return LayoutBuilder(\n',
    "    final state = context.watch<AppState>();\n    final pageBody = narrationStage == null\n        ? child\n        : _stageNarrationFrame(\n            stage: narrationStage,\n            items: narrationItems,\n            child: child,\n          );\n\n    return LayoutBuilder(\n",
    '_page narration body',
)
page_start = journey.index('  Widget _page({')
page_end = journey.index('  int? _narrationRevealEnd({', page_start)
page_section = journey[page_start:page_end]
page_section = replace_once(
    page_section,
    '              Expanded(child: child),\n',
    '              Expanded(child: pageBody),\n',
    '_page displayed body',
)
journey = journey[:page_start] + page_section + journey[page_end:]
journey_path.write_text(journey, encoding='utf-8')

standard = doc_path.read_text(encoding='utf-8')
canonical = r'''

## Memory / Completion narration accessibility

**MEMORY AND COMPLETION MUST SUPPORT USER-INITIATED NARRATION.** This is a shared product requirement inside the existing Stage 5 Memory and Stage 6 Completion surfaces; it does not create an Audio stage or change the six-stage order.

Required behavior:
- a visible, quiet speaker control on Memory and Completion;
- user-initiated play and stop, with no forced autoplay;
- one active narration at a time and no overlapping speech;
- leave-page auto stop, including stage navigation, Journey exit, restart, and level change;
- narration of the current learner-facing content in natural reading order, excluding internal metadata, IDs, debug text, and developer terminology;
- narration must match the learner-facing script/locale currently displayed, including Simplified/Traditional mode;
- accessible play/stop semantics, keyboard/screen-reader reachability, and an adequate mobile touch target;
- graceful empty-content and unavailable-TTS behavior without a crash;
- implementation must reuse Phoenix's shared narration architecture and MUST NOT introduce forced autoplay or a parallel TTS system when the shared runtime can satisfy the requirement.
'''
if 'MEMORY AND COMPLETION MUST SUPPORT USER-INITIATED NARRATION' in standard:
    raise RuntimeError('canonical Memory/Completion narration rule already exists')
doc_path.write_text(standard.rstrip() + canonical + '\n', encoding='utf-8')
