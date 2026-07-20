from pathlib import Path
import re

STATE = Path('app/lib/state/app_state.dart')
SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/agent_feedback_history_rule.test.mjs')
TEST = Path('app/test/journey_feedback_persistence_test.dart')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing target: {label}')
    return text.replace(old, new, 1)


state = STATE.read_text(encoding='utf-8')
screen = SCREEN.read_text(encoding='utf-8')

if 'Future<void> saveGuideFeedback' in state and 'secondaryButtonText' in screen:
    raise SystemExit(0)

state = replace_once(
    state,
    "  String memoryDraft = '';\n"
    "  DateTime? journeyUpdatedAt;\n",
    "  String memoryDraft = '';\n"
    "  String guideFeedbackReply = '';\n"
    "  bool guideFeedbackOffline = false;\n"
    "  String writingFeedbackCorrected = '';\n"
    "  String writingFeedbackExplanation = '';\n"
    "  String writingFeedbackNatural = '';\n"
    "  String writingFeedbackEncouragement = '';\n"
    "  bool writingFeedbackOffline = false;\n"
    "  DateTime? journeyUpdatedAt;\n",
    'feedback fields',
)

state = replace_once(
    state,
    "  bool isWordSaved(String word) => savedWords.contains(word);\n",
    "  bool get hasGuideFeedback => guideFeedbackReply.trim().isNotEmpty;\n"
    "  bool get hasWritingFeedback =>\n"
    "      writingFeedbackCorrected.trim().isNotEmpty ||\n"
    "      writingFeedbackExplanation.trim().isNotEmpty ||\n"
    "      writingFeedbackNatural.trim().isNotEmpty ||\n"
    "      writingFeedbackEncouragement.trim().isNotEmpty;\n\n"
    "  bool isWordSaved(String word) => savedWords.contains(word);\n",
    'feedback getters',
)

state = replace_once(
    state,
    "    memoryDraft = prefs.getString(_key('memoryDraft')) ??\n"
    "        (isLegacyBeijing ? prefs.getString('memoryDraft') : null) ??\n"
    "        '';\n"
    "    journeyUpdatedAt = DateTime.tryParse(\n",
    "    memoryDraft = prefs.getString(_key('memoryDraft')) ??\n"
    "        (isLegacyBeijing ? prefs.getString('memoryDraft') : null) ??\n"
    "        '';\n"
    "    guideFeedbackReply = prefs.getString(_key('guideFeedbackReply')) ?? '';\n"
    "    guideFeedbackOffline =\n"
    "        prefs.getBool(_key('guideFeedbackOffline')) ?? false;\n"
    "    writingFeedbackCorrected =\n"
    "        prefs.getString(_key('writingFeedbackCorrected')) ?? '';\n"
    "    writingFeedbackExplanation =\n"
    "        prefs.getString(_key('writingFeedbackExplanation')) ?? '';\n"
    "    writingFeedbackNatural =\n"
    "        prefs.getString(_key('writingFeedbackNatural')) ?? '';\n"
    "    writingFeedbackEncouragement =\n"
    "        prefs.getString(_key('writingFeedbackEncouragement')) ?? '';\n"
    "    writingFeedbackOffline =\n"
    "        prefs.getBool(_key('writingFeedbackOffline')) ?? false;\n"
    "    journeyUpdatedAt = DateTime.tryParse(\n",
    'feedback load',
)

state = replace_once(
    state,
    "  Future<void> restartJourney() async {\n",
    "  Future<void> saveGuideFeedback({\n"
    "    required String reply,\n"
    "    required bool isOfflineFallback,\n"
    "  }) async {\n"
    "    guideFeedbackReply = reply.trim();\n"
    "    guideFeedbackOffline = isOfflineFallback;\n"
    "    notifyListeners();\n\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await Future.wait([\n"
    "      prefs.setString(_key('guideFeedbackReply'), guideFeedbackReply),\n"
    "      prefs.setBool(_key('guideFeedbackOffline'), guideFeedbackOffline),\n"
    "    ]);\n"
    "  }\n\n"
    "  Future<void> clearGuideFeedback() async {\n"
    "    if (!hasGuideFeedback) return;\n"
    "    guideFeedbackReply = '';\n"
    "    guideFeedbackOffline = false;\n"
    "    notifyListeners();\n\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await Future.wait([\n"
    "      prefs.remove(_key('guideFeedbackReply')),\n"
    "      prefs.remove(_key('guideFeedbackOffline')),\n"
    "    ]);\n"
    "  }\n\n"
    "  Future<void> saveWritingFeedback({\n"
    "    required String corrected,\n"
    "    required String explanation,\n"
    "    required String natural,\n"
    "    required String encouragement,\n"
    "    required bool isOfflineFallback,\n"
    "  }) async {\n"
    "    writingFeedbackCorrected = corrected.trim();\n"
    "    writingFeedbackExplanation = explanation.trim();\n"
    "    writingFeedbackNatural = natural.trim();\n"
    "    writingFeedbackEncouragement = encouragement.trim();\n"
    "    writingFeedbackOffline = isOfflineFallback;\n"
    "    notifyListeners();\n\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await Future.wait([\n"
    "      prefs.setString(\n"
    "        _key('writingFeedbackCorrected'),\n"
    "        writingFeedbackCorrected,\n"
    "      ),\n"
    "      prefs.setString(\n"
    "        _key('writingFeedbackExplanation'),\n"
    "        writingFeedbackExplanation,\n"
    "      ),\n"
    "      prefs.setString(\n"
    "        _key('writingFeedbackNatural'),\n"
    "        writingFeedbackNatural,\n"
    "      ),\n"
    "      prefs.setString(\n"
    "        _key('writingFeedbackEncouragement'),\n"
    "        writingFeedbackEncouragement,\n"
    "      ),\n"
    "      prefs.setBool(_key('writingFeedbackOffline'), writingFeedbackOffline),\n"
    "    ]);\n"
    "  }\n\n"
    "  Future<void> clearWritingFeedback() async {\n"
    "    if (!hasWritingFeedback) return;\n"
    "    writingFeedbackCorrected = '';\n"
    "    writingFeedbackExplanation = '';\n"
    "    writingFeedbackNatural = '';\n"
    "    writingFeedbackEncouragement = '';\n"
    "    writingFeedbackOffline = false;\n"
    "    notifyListeners();\n\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await Future.wait([\n"
    "      prefs.remove(_key('writingFeedbackCorrected')),\n"
    "      prefs.remove(_key('writingFeedbackExplanation')),\n"
    "      prefs.remove(_key('writingFeedbackNatural')),\n"
    "      prefs.remove(_key('writingFeedbackEncouragement')),\n"
    "      prefs.remove(_key('writingFeedbackOffline')),\n"
    "    ]);\n"
    "  }\n\n"
    "  Future<void> restartJourney() async {\n",
    'feedback persistence methods',
)

state = replace_once(
    state,
    "    memoryDraft = '';\n"
    "    journeyUpdatedAt = _clock();\n",
    "    memoryDraft = '';\n"
    "    guideFeedbackReply = '';\n"
    "    guideFeedbackOffline = false;\n"
    "    writingFeedbackCorrected = '';\n"
    "    writingFeedbackExplanation = '';\n"
    "    writingFeedbackNatural = '';\n"
    "    writingFeedbackEncouragement = '';\n"
    "    writingFeedbackOffline = false;\n"
    "    journeyUpdatedAt = _clock();\n",
    'restart feedback reset fields',
)

state = replace_once(
    state,
    "      prefs.remove(_key('memoryDraft')),\n"
    "      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),\n",
    "      prefs.remove(_key('memoryDraft')),\n"
    "      prefs.remove(_key('guideFeedbackReply')),\n"
    "      prefs.remove(_key('guideFeedbackOffline')),\n"
    "      prefs.remove(_key('writingFeedbackCorrected')),\n"
    "      prefs.remove(_key('writingFeedbackExplanation')),\n"
    "      prefs.remove(_key('writingFeedbackNatural')),\n"
    "      prefs.remove(_key('writingFeedbackEncouragement')),\n"
    "      prefs.remove(_key('writingFeedbackOffline')),\n"
    "      prefs.setString(_key('updatedAt'), journeyUpdatedAt!.toIso8601String()),\n",
    'restart feedback remove keys',
)
STATE.write_text(state, encoding='utf-8')

screen = replace_once(
    screen,
    "    memoryController.text = _appState.memoryDraft;\n"
    "    _initialized = true;\n",
    "    memoryController.text = _appState.memoryDraft;\n"
    "    if (_appState.hasGuideFeedback) {\n"
    "      _guideFeedback = PhoenixGuideFeedback(\n"
    "        reply: _appState.guideFeedbackReply,\n"
    "        isOfflineFallback: _appState.guideFeedbackOffline,\n"
    "      );\n"
    "    }\n"
    "    if (_appState.hasWritingFeedback) {\n"
    "      _writingFeedback = PhoenixWritingFeedback(\n"
    "        corrected: _appState.writingFeedbackCorrected,\n"
    "        explanation: _appState.writingFeedbackExplanation,\n"
    "        natural: _appState.writingFeedbackNatural,\n"
    "        encouragement: _appState.writingFeedbackEncouragement,\n"
    "        isOfflineFallback: _appState.writingFeedbackOffline,\n"
    "      );\n"
    "    }\n"
    "    _initialized = true;\n",
    'restore feedback in screen',
)

screen = replace_once(
    screen,
    "  void _onWonderChanged(String _) {\n"
    "    if (_guideFeedback != null) {\n"
    "      setState(() => _guideFeedback = null);\n"
    "    }\n"
    "    unawaited(_persistProgress());\n"
    "  }\n",
    "  void _onWonderChanged(String _) {\n"
    "    if (_guideFeedback != null) {\n"
    "      setState(() => _guideFeedback = null);\n"
    "      unawaited(_appState.clearGuideFeedback());\n"
    "    }\n"
    "    unawaited(_persistProgress());\n"
    "  }\n",
    'clear guide feedback on edit',
)

screen = replace_once(
    screen,
    "  void _onExpressChanged(String _) {\n"
    "    if (_writingFeedback != null) {\n"
    "      setState(() => _writingFeedback = null);\n"
    "    }\n"
    "    unawaited(_persistProgress());\n"
    "  }\n",
    "  void _onExpressChanged(String _) {\n"
    "    if (_writingFeedback != null) {\n"
    "      setState(() => _writingFeedback = null);\n"
    "      unawaited(_appState.clearWritingFeedback());\n"
    "    }\n"
    "    unawaited(_persistProgress());\n"
    "  }\n",
    'clear writing feedback on edit',
)

screen = replace_once(
    screen,
    "      final feedback = await _ai.askGuide(\n"
    "        text: answer,\n"
    "        language: _appState.translationLanguage,\n"
    "      );\n"
    "      if (!mounted) return;\n\n"
    "      _clearAgentStatus();\n",
    "      final feedback = await _ai.askGuide(\n"
    "        text: answer,\n"
    "        language: _appState.translationLanguage,\n"
    "        journeyId: _experience.id,\n"
    "      );\n"
    "      await _appState.saveGuideFeedback(\n"
    "        reply: feedback.reply,\n"
    "        isOfflineFallback: feedback.isOfflineFallback,\n"
    "      );\n"
    "      if (!mounted) return;\n\n"
    "      _clearAgentStatus();\n",
    'save guide response',
)

screen = replace_once(
    screen,
    "      final feedback = await _ai.reviewWriting(\n"
    "        text: writing,\n"
    "        language: _appState.translationLanguage,\n"
    "      );\n"
    "      if (!mounted) return;\n\n"
    "      _clearAgentStatus();\n",
    "      final feedback = await _ai.reviewWriting(\n"
    "        text: writing,\n"
    "        language: _appState.translationLanguage,\n"
    "      );\n"
    "      await _appState.saveWritingFeedback(\n"
    "        corrected: feedback.corrected,\n"
    "        explanation: feedback.explanation,\n"
    "        natural: feedback.natural,\n"
    "        encouragement: feedback.encouragement,\n"
    "        isOfflineFallback: feedback.isOfflineFallback,\n"
    "      );\n"
    "      if (!mounted) return;\n\n"
    "      _clearAgentStatus();\n",
    'save writing response',
)

screen = replace_once(
    screen,
    "    bool primaryLoading = false,\n"
    "    bool primaryEnabled = true,\n",
    "    bool primaryLoading = false,\n"
    "    bool primaryEnabled = true,\n"
    "    String? secondaryButtonText,\n"
    "    IconData secondaryButtonIcon = Icons.auto_awesome_outlined,\n"
    "    VoidCallback? onSecondary,\n",
    'secondary action params',
)

primary_marker = """                       Expanded(
                         flex: 2,
                         child: FilledButton.icon(
"""
secondary_block = """                       if (secondaryButtonText != null && onSecondary != null) ...[
                         Expanded(
                           child: OutlinedButton.icon(
                             key: ValueKey('journey-secondary-$title'),
                             onPressed: onSecondary,
                             style: OutlinedButton.styleFrom(
                               visualDensity: VisualDensity.compact,
                               padding: const EdgeInsets.symmetric(horizontal: 5),
                             ),
                             icon: Icon(secondaryButtonIcon, size: 15),
                             label: Text(
                               secondaryButtonText,
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               style: const TextStyle(
                                 fontSize: 10,
                                 fontWeight: FontWeight.w800,
                               ),
                             ),
                           ),
                         ),
                         const SizedBox(width: 7),
                       ],
                       Expanded(
                         flex: 2,
                         child: FilledButton.icon(
"""
screen = replace_once(screen, primary_marker, secondary_block, 'secondary footer button')

screen = replace_once(
    screen,
    "      onNext: hasFeedback ? null : () => unawaited(_askGuide()),\n"
    "      child: Column(\n",
    "      onNext: hasFeedback ? null : () => unawaited(_askGuide()),\n"
    "      secondaryButtonText: hasFeedback ? 'AI 回答' : null,\n"
    "      secondaryButtonIcon: Icons.forum_outlined,\n"
    "      onSecondary:\n"
    "          hasFeedback ? () => unawaited(_showGuideFeedback()) : null,\n"
    "      child: Column(\n",
    'Think feedback review button',
)

screen = replace_once(
    screen,
    "      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),\n"
    "      child: Column(\n",
    "      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),\n"
    "      secondaryButtonText: hasFeedback ? 'AI 批改' : null,\n"
    "      secondaryButtonIcon: Icons.fact_check_outlined,\n"
    "      onSecondary:\n"
    "          hasFeedback ? () => unawaited(_showWritingFeedback()) : null,\n"
    "      child: Column(\n",
    'Express feedback review button',
)
SCREEN.write_text(screen, encoding='utf-8')

TEST.write_text("""import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Agent feedback persists separately for each city journey', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(clock: () => DateTime(2026, 7, 20));
    await state.load();

    await state.saveGuideFeedback(
      reply: '西安的城墙让城市边界变得清楚。',
      isOfflineFallback: false,
    );
    await state.saveWritingFeedback(
      corrected: '我想从城墙上看古城。',
      explanation: '补充了完整标点。',
      natural: '我想站在城墙上看看古城。',
      encouragement: '表达很清楚。',
      isOfflineFallback: false,
    );

    final restored = AppState(clock: () => DateTime(2026, 7, 20));
    await restored.load();
    expect(restored.hasGuideFeedback, isTrue);
    expect(restored.guideFeedbackReply, contains('城墙'));
    expect(restored.hasWritingFeedback, isTrue);
    expect(restored.writingFeedbackNatural, contains('城墙'));

    await restored.activateJourney('beijing-forbidden-city');
    expect(restored.hasGuideFeedback, isFalse);
    expect(restored.hasWritingFeedback, isFalse);
  });
}
""", encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Agent feedback is persisted inside each journey namespace', () => {
  assert.match(state, /guideFeedbackReply/);
  assert.match(state, /writingFeedbackCorrected/);
  assert.match(state, /saveGuideFeedback/);
  assert.match(state, /saveWritingFeedback/);
  assert.match(state, /_key\('guideFeedbackReply'\)/);
  assert.match(state, /_key\('writingFeedbackCorrected'\)/);
});

test('Journey restores saved feedback after reopening', () => {
  assert.match(screen, /_appState\.hasGuideFeedback/);
  assert.match(screen, /_appState\.hasWritingFeedback/);
  assert.match(screen, /PhoenixGuideFeedback\(/);
  assert.match(screen, /PhoenixWritingFeedback\(/);
});

test('Think and Express show review buttons between Back and Continue', () => {
  assert.match(screen, /String\? secondaryButtonText/);
  assert.match(screen, /journey-secondary-\$title/);
  assert.match(screen, /secondaryButtonText: hasFeedback \? 'AI 回答' : null/);
  assert.match(screen, /secondaryButtonText: hasFeedback \? 'AI 批改' : null/);
  const back = screen.indexOf("label: const Text(\n                              '上一步'");
  const secondary = screen.indexOf("if (secondaryButtonText != null");
  const primary = screen.indexOf('child: FilledButton.icon', secondary);
  assert.ok(back >= 0 && secondary > back && primary > secondary);
});

test('editing an answer removes feedback that no longer matches it', () => {
  assert.match(screen, /clearGuideFeedback\(\)/);
  assert.match(screen, /clearWritingFeedback\(\)/);
});
""", encoding='utf-8')
