from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text(encoding='utf-8')


def replace_once(old: str, new: str, label: str) -> None:
    global text
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected one match, found {count}')
    text = text.replace(old, new, 1)


replace_once(
    "import 'package:provider/provider.dart';\n\nimport '../data/daily_journey_catalog.dart';",
    "import 'package:provider/provider.dart';\n\nimport '../agents/phoenix_immersion_agent.dart';\nimport '../data/daily_journey_catalog.dart';",
    'immersion import',
)
replace_once(
    "  late final NarrationController _narration;\n  late final DailyJourneyExperience _experience;",
    "  late final NarrationController _narration;\n  late final PhoenixImmersionAgent _immersion;\n  late final DailyJourneyExperience _experience;",
    'immersion field',
)
replace_once(
    "    _narration = NarrationController();\n    final worldStoryAgent = createPhoenixWorldStoryAgent();",
    "    _narration = NarrationController();\n    _immersion = PhoenixImmersionAgent();\n    final worldStoryAgent = createPhoenixWorldStoryAgent();",
    'immersion initialization',
)
replace_once(
    "  void _handleWritingFocusChanged() {\n    if (mounted) setState(() {});\n  }\n",
    "  void _handleWritingFocusChanged() {\n    if (mounted) setState(() {});\n  }\n\n  bool get _supportsImmersion => step >= 0 && step <= 2;\n\n  void _syncImmersion() {\n    _immersion.setEnabled(_supportsImmersion);\n  }\n",
    'immersion helpers',
)
replace_once(
    "    _initialized = true;\n\n    if (step == 2) _scheduleDiscoveryAutoStart();",
    "    _initialized = true;\n    _syncImmersion();\n\n    if (step == 2) _scheduleDiscoveryAutoStart();",
    'initial immersion sync',
)
replace_once(
    "  void didChangeAppLifecycleState(AppLifecycleState state) {\n    if (state == AppLifecycleState.resumed) return;",
    "  void didChangeAppLifecycleState(AppLifecycleState state) {\n    if (state == AppLifecycleState.resumed) {\n      _immersion.reveal();\n      return;\n    }",
    'resume reveal',
)
replace_once(
    "    if (_initialized) unawaited(_persistProgress());\n    _narration.dispose();",
    "    if (_initialized) unawaited(_persistProgress());\n    _immersion.dispose();\n    _narration.dispose();",
    'immersion disposal',
)
replace_once(
    "    if (safeStep == 2 && safeStep != step) {\n      setState(() => step = safeStep);\n      _discoveryAutoStarted = true;",
    "    if (safeStep == 2 && safeStep != step) {\n      setState(() => step = safeStep);\n      _syncImmersion();\n      _discoveryAutoStarted = true;",
    'discovery immersion sync',
)
replace_once(
    "    setState(() => step = safeStep);\n    await _persistProgress(overrideStep: safeStep);",
    "    setState(() => step = safeStep);\n    _syncImmersion();\n    await _persistProgress(overrideStep: safeStep);",
    'step immersion sync',
)
replace_once(
    "    );\n    if (!mounted || !shouldResume) return;\n\n    // Wait until the sheet animation",
    "    );\n    _immersion.reveal();\n    if (!mounted || !shouldResume) return;\n\n    // Wait until the sheet animation",
    'word sheet reveal',
)
replace_once(
    "    setState(() => step = AppState.journeyLastStep);\n  }\n\n  Future<void> _restartJourney() async {",
    "    setState(() => step = AppState.journeyLastStep);\n    _syncImmersion();\n  }\n\n  Future<void> _restartJourney() async {",
    'completion immersion sync',
)
replace_once(
    "    if (mounted) setState(() => step = 0);\n  }",
    "    if (mounted) {\n      setState(() => step = 0);\n      _syncImmersion();\n    }\n  }",
    'restart immersion sync',
)

old_build = """    return DestinationBackground(
      journeyId: _experience.id,
      pageType: _backgroundPageType,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 44,
          title: Text(
            _appState.displayText(_experience.appBarTitle),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          actions: [
            Consumer<AppState>(
              builder: (_, state, __) => TextButton(
                onPressed: state.toggleScript,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                  state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
                  style: const TextStyle(fontSize: 10.5),
                ),
              ),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: pages[step],
        ),
      ),
    );"""

new_build = """    final mediaQuery = MediaQuery.of(context);
    final automaticImmersionDisabled =
        mediaQuery.disableAnimations || mediaQuery.accessibleNavigation;

    return DestinationBackground(
      journeyId: _experience.id,
      pageType: _backgroundPageType,
      child: Listener(
        key: const ValueKey('journey-immersion-listener'),
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _immersion.registerInteraction(),
        child: AnimatedBuilder(
          animation: _immersion,
          builder: (context, _) {
            final immersed =
                _supportsImmersion &&
                _immersion.immersed &&
                !automaticImmersionDisabled;

            return Stack(
              fit: StackFit.expand,
              children: [
                AnimatedOpacity(
                  key: const ValueKey('journey-content-opacity'),
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.easeInOutCubic,
                  opacity: immersed ? .035 : 1,
                  child: IgnorePointer(
                    ignoring: immersed,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                        toolbarHeight: 44,
                        title: Text(
                          _appState.displayText(_experience.appBarTitle),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        actions: [
                          Consumer<AppState>(
                            builder: (_, state, __) => TextButton(
                              onPressed: state.toggleScript,
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),
                              child: Text(
                                state.scriptMode == ScriptMode.simplified
                                    ? '简 / 繁'
                                    : '繁 / 简',
                                style: const TextStyle(fontSize: 10.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      body: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: pages[step],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    key: const ValueKey('journey-immersion-hint'),
                    duration: const Duration(milliseconds: 500),
                    opacity: immersed ? 1 : 0,
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .22),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .22),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _appState.displayText('轻触屏幕显示内容'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );"""
replace_once(old_build, new_build, 'immersive journey build')
path.write_text(text, encoding='utf-8')

rule = Path('worker/journey_immersion_rule.test.mjs')
rule.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const agent = readFileSync(
  'app/lib/agents/phoenix_immersion_agent.dart',
  'utf8',
);

test('reading journeys enter calm immersion without destroying content state', () => {
  assert.match(journey, /bool get _supportsImmersion => step >= 0 && step <= 2/);
  assert.match(journey, /Duration\\(milliseconds: 1600\\)/);
  assert.match(journey, /opacity: immersed \\? \\.035 : 1/);
  assert.match(journey, /IgnorePointer\\([\\s\\S]*ignoring: immersed/);
  assert.match(journey, /onPointerDown: \\(_\\) => _immersion\\.registerInteraction\\(\\)/);
  assert.match(journey, /轻触屏幕显示内容/);
});

test('immersion timer is centralized in PhoenixImmersionAgent', () => {
  assert.match(agent, /idleDelay = const Duration\\(seconds: 7\\)/);
  assert.match(agent, /void registerInteraction\\(\\)/);
  assert.match(agent, /_idleTimer = Timer\\(idleDelay/);
});
""", encoding='utf-8')

docs = Path('docs/development-workflow.md')
docs_text = docs.read_text(encoding='utf-8')
marker = '- 完成后的城市印迹固定在目的地背景图右上角，底色必须透明，只保留半透明印泥视觉，不遮挡背景主体\n'
addition = (
    marker
    + '- 故事、生词和发现页必须由 `PhoenixImmersionAgent` 提供自动沉浸：无操作 7 秒后用约 1.6 秒渐隐内容，朗读和阅读状态不得中断；轻触任意位置立即恢复。思考、表达、回忆及无障碍／减少动态模式不得自动隐藏内容\n'
)
if marker not in docs_text:
    raise SystemExit('immersion documentation marker missing')
docs.write_text(docs_text.replace(marker, addition, 1), encoding='utf-8')
