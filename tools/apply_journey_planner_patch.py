from pathlib import Path

STATE = Path('app/lib/state/app_state.dart')
EXPLORE = Path('app/lib/screens/explore_screen.dart')
TEST = Path('app/test/journey_plan_state_test.dart')
RULE = Path('worker/journey_plan_rule.test.mjs')


def replace_once(text, old, new, label):
    if old not in text:
        raise RuntimeError(f'missing target: {label}')
    return text.replace(old, new, 1)

state = STATE.read_text(encoding='utf-8')
if 'saveJourneyPlan' not in state:
    state = replace_once(
        state,
        "  DateTime? journeyUpdatedAt;\n",
        "  DateTime? journeyUpdatedAt;\n"
        "  String journeyOrigin = '河内';\n"
        "  DateTime? plannedJourneyDate;\n"
        "  String journeyLearningFocus = '文化';\n",
        'planner fields',
    )
    state = replace_once(
        state,
        "  bool isWordSaved(String word) => savedWords.contains(word);\n",
        "  bool get hasJourneyPlan => plannedJourneyDate != null;\n\n"
        "  String get journeyPlanDateLabel {\n"
        "    final date = plannedJourneyDate;\n"
        "    if (date == null) return '尚未计划';\n"
        "    return '${date.month}月${date.day}日';\n"
        "  }\n\n"
        "  String get journeyPlanCountdownLabel {\n"
        "    final date = plannedJourneyDate;\n"
        "    if (date == null) return '计划旅程';\n"
        "    final now = DateTime.now();\n"
        "    final today = DateTime(now.year, now.month, now.day);\n"
        "    final target = DateTime(date.year, date.month, date.day);\n"
        "    final days = target.difference(today).inDays;\n"
        "    if (days < 0) return '计划日期已过';\n"
        "    if (days == 0) return '今天出发';\n"
        "    return '还有 $days 天';\n"
        "  }\n\n"
        "  bool isWordSaved(String word) => savedWords.contains(word);\n",
        'planner getters',
    )
    state = replace_once(
        state,
        "      journeyUpdatedAt = DateTime.tryParse(\n"
        "        prefs.getString('journeyUpdatedAt') ?? '',\n"
        "      );\n",
        "      journeyUpdatedAt = DateTime.tryParse(\n"
        "        prefs.getString('journeyUpdatedAt') ?? '',\n"
        "      );\n"
        "      final storedOrigin = prefs.getString('journeyOrigin')?.trim();\n"
        "      journeyOrigin = storedOrigin == null || storedOrigin.isEmpty\n"
        "          ? '河内'\n"
        "          : storedOrigin;\n"
        "      plannedJourneyDate = DateTime.tryParse(\n"
        "        prefs.getString('plannedJourneyDate') ?? '',\n"
        "      );\n"
        "      journeyLearningFocus =\n"
        "          prefs.getString('journeyLearningFocus') ?? '文化';\n",
        'planner load',
    )
    state = replace_once(
        state,
        "  Future<void> restartJourney() async {\n",
        "  Future<void> saveJourneyPlan({\n"
        "    required String origin,\n"
        "    required DateTime date,\n"
        "    required String focus,\n"
        "  }) async {\n"
        "    final normalizedOrigin = origin.trim();\n"
        "    if (normalizedOrigin.isEmpty) return;\n"
        "    journeyOrigin = normalizedOrigin;\n"
        "    plannedJourneyDate = DateTime(date.year, date.month, date.day);\n"
        "    journeyLearningFocus = focus;\n"
        "    notifyListeners();\n\n"
        "    final prefs = await SharedPreferences.getInstance();\n"
        "    await Future.wait([\n"
        "      prefs.setString('journeyOrigin', journeyOrigin),\n"
        "      prefs.setString(\n"
        "        'plannedJourneyDate',\n"
        "        plannedJourneyDate!.toIso8601String(),\n"
        "      ),\n"
        "      prefs.setString('journeyLearningFocus', journeyLearningFocus),\n"
        "    ]);\n"
        "  }\n\n"
        "  Future<void> restartJourney() async {\n",
        'planner save',
    )
    STATE.write_text(state, encoding='utf-8')

explore = EXPLORE.read_text(encoding='utf-8')
if 'showJourneyPlanSheet' not in explore:
    explore = replace_once(
        explore,
        "import '../theme/phoenix_theme.dart';\n",
        "import '../theme/phoenix_theme.dart';\n"
        "import '../widgets/journey_plan_sheet.dart';\n",
        'planner import',
    )
    explore = replace_once(
        explore,
        "    Future<void> openJourney() async {\n",
        "    Future<void> openJourneyPlanner() => showJourneyPlanSheet(context);\n\n"
        "    Future<void> openJourney() async {\n",
        'planner callback',
    )
    explore = replace_once(
        explore,
        "              _JourneyCard(state: state, onOpen: openJourney),\n",
        "              _JourneyCard(\n"
        "                state: state,\n"
        "                onOpen: openJourney,\n"
        "                onPlan: openJourneyPlanner,\n"
        "              ),\n",
        'planner card callback',
    )
    explore = replace_once(
        explore,
        "          child: Column(\n            children: [\n",
        "          child: SingleChildScrollView(\n"
        "            physics: const BouncingScrollPhysics(),\n"
        "            child: Column(\n"
        "              children: [\n",
        'explore scroll start',
    )
    explore = replace_once(
        explore,
        "               const _DiscoveryCard(),\n              ],\n            ),\n          ),\n        ),\n",
        "               const _DiscoveryCard(),\n"
        "              ],\n"
        "            ),\n"
        "          ),\n"
        "        ),\n",
        'explore scroll end',
    )
    explore = replace_once(
        explore,
        "  const _JourneyCard({required this.state, required this.onOpen});\n\n"
        "  final AppState state;\n"
        "  final VoidCallback onOpen;\n",
        "  const _JourneyCard({\n"
        "    required this.state,\n"
        "    required this.onOpen,\n"
        "    required this.onPlan,\n"
        "  });\n\n"
        "  final AppState state;\n"
        "  final VoidCallback onOpen;\n"
        "  final VoidCallback onPlan;\n",
        'journey card constructor',
    )
    explore = replace_once(
        explore,
        "              const Spacer(),\n"
        "              Text(\n"
        "                state.displayText('第一站'),\n"
        "                style: const TextStyle(color: Colors.black54, fontSize: 10),\n"
        "              ),\n",
        "              const Spacer(),\n"
        "              TextButton.icon(\n"
        "                key: const ValueKey('open-journey-planner'),\n"
        "                onPressed: onPlan,\n"
        "                style: TextButton.styleFrom(\n"
        "                  visualDensity: VisualDensity.compact,\n"
        "                  padding: const EdgeInsets.symmetric(horizontal: 6),\n"
        "                ),\n"
        "                icon: const Icon(Icons.calendar_month_outlined, size: 14),\n"
        "                label: Text(\n"
        "                  state.displayText(\n"
        "                    state.hasJourneyPlan ? '修改计划' : '计划旅程',\n"
        "                  ),\n"
        "                  style: const TextStyle(fontSize: 10),\n"
        "                ),\n"
        "              ),\n",
        'planner button',
    )
    explore = replace_once(
        explore,
        "          Text(\n"
        "            state.displayText('跟随 AI 导游，用故事、词汇和文化打开北京。'),\n"
        "            maxLines: 1,\n"
        "            overflow: TextOverflow.ellipsis,\n"
        "            style: const TextStyle(fontSize: 11.5, height: 1.15),\n"
        "          ),\n",
        "          Text(\n"
        "            state.displayText('跟随 AI 导游，用故事、词汇和文化打开北京。'),\n"
        "            maxLines: 1,\n"
        "            overflow: TextOverflow.ellipsis,\n"
        "            style: const TextStyle(fontSize: 11.5, height: 1.15),\n"
        "          ),\n"
        "          if (state.hasJourneyPlan) ...[\n"
        "            const SizedBox(height: 6),\n"
        "            Container(\n"
        "              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),\n"
        "              decoration: BoxDecoration(\n"
        "                color: PhoenixTheme.gold.withValues(alpha: .12),\n"
        "                borderRadius: BorderRadius.circular(11),\n"
        "              ),\n"
        "              child: Row(\n"
        "                children: [\n"
        "                  const Icon(Icons.event_available_rounded,\n"
        "                      size: 15, color: PhoenixTheme.red),\n"
        "                  const SizedBox(width: 6),\n"
        "                  Expanded(\n"
        "                    child: Text(\n"
        "                      state.displayText(\n"
        "                        '${state.journeyOrigin} → 北京 · '\n"
        "                        '${state.journeyPlanDateLabel} · '\n"
        "                        '${state.journeyLearningFocus}',\n"
        "                      ),\n"
        "                      maxLines: 1,\n"
        "                      overflow: TextOverflow.ellipsis,\n"
        "                      style: const TextStyle(\n"
        "                        fontSize: 9.5,\n"
        "                        fontWeight: FontWeight.w800,\n"
        "                      ),\n"
        "                    ),\n"
        "                  ),\n"
        "                  Text(\n"
        "                    state.displayText(state.journeyPlanCountdownLabel),\n"
        "                    style: const TextStyle(\n"
        "                      color: PhoenixTheme.red,\n"
        "                      fontSize: 9.5,\n"
        "                      fontWeight: FontWeight.w900,\n"
        "                    ),\n"
        "                  ),\n"
        "                ],\n"
        "              ),\n"
        "            ),\n"
        "          ],\n",
        'planner summary',
    )
    EXPLORE.write_text(explore, encoding='utf-8')

TEST.write_text("""import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('journey plan persists across app reloads', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    await state.saveJourneyPlan(
      origin: '海防',
      date: DateTime(2026, 8, 20),
      focus: '表达',
    );

    final restored = AppState();
    await restored.load();
    expect(restored.journeyOrigin, '海防');
    expect(restored.plannedJourneyDate, DateTime(2026, 8, 20));
    expect(restored.journeyLearningFocus, '表达');
    expect(restored.hasJourneyPlan, isTrue);
    expect(restored.journeyPlanDateLabel, '8月20日');
  });
}
""", encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/journey_plan_sheet.dart', 'utf8');

test('journey plan is persisted in AppState', () => {
  assert.match(state, /String journeyOrigin = '河内'/);
  assert.match(state, /DateTime\? plannedJourneyDate/);
  assert.match(state, /Future<void> saveJourneyPlan/);
  assert.match(state, /prefs\.setString\('plannedJourneyDate'/);
});

test('Explore opens the real Beijing journey planner', () => {
  assert.match(explore, /showJourneyPlanSheet\(context\)/);
  assert.match(explore, /open-journey-planner/);
  assert.match(explore, /state\.journeyPlanCountdownLabel/);
  assert.match(explore, /SingleChildScrollView/);
});

test('planner captures origin, date and learning focus', () => {
  assert.match(sheet, /journey-plan-origin/);
  assert.match(sheet, /journey-plan-date/);
  assert.match(sheet, /journey-plan-focus-/);
  assert.match(sheet, /saveJourneyPlan/);
  assert.match(sheet, /中国 · 北京 · 紫禁城/);
});
""", encoding='utf-8')
