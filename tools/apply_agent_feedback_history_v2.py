from pathlib import Path
import re

STATE = Path('app/lib/state/app_state.dart')
SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/agent_feedback_history_rule.test.mjs')
TEST = Path('app/test/journey_feedback_persistence_test.dart')

state = STATE.read_text(encoding='utf-8')
screen = SCREEN.read_text(encoding='utf-8')

if 'Future<void> saveGuideFeedback' in state and 'secondaryButtonText' in screen:
    raise SystemExit(0)


def require_replace(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(label)
    return text.replace(old, new, 1)


# AppState fields and getters.
if 'String guideFeedbackReply' not in state:
    state = require_replace(
        state,
        "  String memoryDraft = '';\n  DateTime? journeyUpdatedAt;\n",
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

if 'bool get hasGuideFeedback' not in state:
    state = require_replace(
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

if "_key('guideFeedbackReply')" not in state:
    memory_load = re.compile(
        r"(    memoryDraft = prefs\.getString\(_key\('memoryDraft'\)\) \?\?\n"
        r"        \(isLegacyBeijing \? prefs\.getString\('memoryDraft'\) : null\) \?\?\n"
        r"        '';\n)"
    )
    state, count = memory_load.subn(
        r"\1"
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
        "        prefs.getBool(_key('writingFeedbackOffline')) ?? false;\n",
        state,
        count=1,
    )
    if count != 1:
        raise RuntimeError('feedback load')

if 'Future<void> saveGuideFeedback' not in state:
    methods = """  Future<void> saveGuideFeedback({
    required String reply,
    required bool isOfflineFallback,
  }) async {
    guideFeedbackReply = reply.trim();
    guideFeedbackOffline = isOfflineFallback;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_key('guideFeedbackReply'), guideFeedbackReply),
      prefs.setBool(_key('guideFeedbackOffline'), guideFeedbackOffline),
    ]);
  }

  Future<void> clearGuideFeedback() async {
    if (!hasGuideFeedback) return;
    guideFeedbackReply = '';
    guideFeedbackOffline = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_key('guideFeedbackReply')),
      prefs.remove(_key('guideFeedbackOffline')),
    ]);
  }

  Future<void> saveWritingFeedback({
    required String corrected,
    required String explanation,
    required String natural,
    required String encouragement,
    required bool isOfflineFallback,
  }) async {
    writingFeedbackCorrected = corrected.trim();
    writingFeedbackExplanation = explanation.trim();
    writingFeedbackNatural = natural.trim();
    writingFeedbackEncouragement = encouragement.trim();
    writingFeedbackOffline = isOfflineFallback;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(
        _key('writingFeedbackCorrected'),
        writingFeedbackCorrected,
      ),
      prefs.setString(
        _key('writingFeedbackExplanation'),
        writingFeedbackExplanation,
      ),
      prefs.setString(
        _key('writingFeedbackNatural'),
        writingFeedbackNatural,
      ),
      prefs.setString(
        _key('writingFeedbackEncouragement'),
        writingFeedbackEncouragement,
      ),
      prefs.setBool(_key('writingFeedbackOffline'), writingFeedbackOffline),
    ]);
  }

  Future<void> clearWritingFeedback() async {
    if (!hasWritingFeedback) return;
    writingFeedbackCorrected = '';
    writingFeedbackExplanation = '';
    writingFeedbackNatural = '';
    writingFeedbackEncouragement = '';
    writingFeedbackOffline = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_key('writingFeedbackCorrected')),
      prefs.remove(_key('writingFeedbackExplanation')),
      prefs.remove(_key('writingFeedbackNatural')),
      prefs.remove(_key('writingFeedbackEncouragement')),
      prefs.remove(_key('writingFeedbackOffline')),
    ]);
  }

"""
    state = require_replace(
        state,
        '  Future<void> restartJourney() async {\n',
        methods + '  Future<void> restartJourney() async {\n',
        'feedback methods',
    )

# Reset feedback only when explicitly restarting a city journey.
restart_start = state.index('  Future<void> restartJourney() async {')
restart_end = state.index('  Future<void> completeJourney', restart_start)
restart = state[restart_start:restart_end]
if "guideFeedbackReply = '';" not in restart:
    restart = require_replace(
        restart,
        "    memoryDraft = '';\n    journeyUpdatedAt = _clock();\n",
        "    memoryDraft = '';\n"
        "    guideFeedbackReply = '';\n"
        "    guideFeedbackOffline = false;\n"
        "    writingFeedbackCorrected = '';\n"
        "    writingFeedbackExplanation = '';\n"
        "    writingFeedbackNatural = '';\n"
        "    writingFeedbackEncouragement = '';\n"
        "    writingFeedbackOffline = false;\n"
        "    journeyUpdatedAt = _clock();\n",
        'restart feedback values',
    )
if "prefs.remove(_key('guideFeedbackReply'))" not in restart:
    restart = require_replace(
        restart,
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
        'restart feedback keys',
    )
state = state[:restart_start] + restart + state[restart_end:]
STATE.write_text(state, encoding='utf-8')

# Restore persisted feedback when reopening a journey.
if '_appState.hasGuideFeedback' not in screen:
    screen = require_replace(
        screen,
        "    memoryController.text = _appState.memoryDraft;\n    _initialized = true;\n",
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
        'screen feedback restore',
    )

if 'clearGuideFeedback()' not in screen:
    screen = require_replace(
        screen,
        "      setState(() => _guideFeedback = null);\n    }\n    unawaited(_persistProgress());\n  }\n\n  void _onExpressChanged",
        "      setState(() => _guideFeedback = null);\n"
        "      unawaited(_appState.clearGuideFeedback());\n"
        "    }\n"
        "    unawaited(_persistProgress());\n"
        "  }\n\n"
        "  void _onExpressChanged",
        'clear guide on edit',
    )
if 'clearWritingFeedback()' not in screen:
    screen = require_replace(
        screen,
        "      setState(() => _writingFeedback = null);\n    }\n    unawaited(_persistProgress());\n  }\n\n  Future<void> _finishJourney",
        "      setState(() => _writingFeedback = null);\n"
        "      unawaited(_appState.clearWritingFeedback());\n"
        "    }\n"
        "    unawaited(_persistProgress());\n"
        "  }\n\n"
        "  Future<void> _finishJourney",
        'clear writing on edit',
    )

if 'saveGuideFeedback(' not in screen:
    guide_call = re.compile(
        r"(      final feedback = await _ai\.askGuide\(\n"
        r"        text: answer,\n"
        r"        language: _appState\.translationLanguage,\n"
        r"      \);\n)"
    )
    screen, count = guide_call.subn(
        r"\1"
        "      await _appState.saveGuideFeedback(\n"
        "        reply: feedback.reply,\n"
        "        isOfflineFallback: feedback.isOfflineFallback,\n"
        "      );\n",
        screen,
        count=1,
    )
    if count != 1:
        raise RuntimeError('save guide feedback call')
    screen = screen.replace(
        "        language: _appState.translationLanguage,\n      );\n"
        "      await _appState.saveGuideFeedback(",
        "        language: _appState.translationLanguage,\n"
        "        journeyId: _experience.id,\n"
        "      );\n"
        "      await _appState.saveGuideFeedback(",
        1,
    )

if 'saveWritingFeedback(' not in screen:
    writing_call = re.compile(
        r"(      final feedback = await _ai\.reviewWriting\(\n"
        r"        text: writing,\n"
        r"        language: _appState\.translationLanguage,\n"
        r"      \);\n)"
    )
    screen, count = writing_call.subn(
        r"\1"
        "      await _appState.saveWritingFeedback(\n"
        "        corrected: feedback.corrected,\n"
        "        explanation: feedback.explanation,\n"
        "        natural: feedback.natural,\n"
        "        encouragement: feedback.encouragement,\n"
        "        isOfflineFallback: feedback.isOfflineFallback,\n"
        "      );\n",
        screen,
        count=1,
    )
    if count != 1:
        raise RuntimeError('save writing feedback call')

if 'String? secondaryButtonText' not in screen:
    screen = require_replace(
        screen,
        "    bool primaryLoading = false,\n    bool primaryEnabled = true,\n",
        "    bool primaryLoading = false,\n"
        "    bool primaryEnabled = true,\n"
        "    String? secondaryButtonText,\n"
        "    IconData secondaryButtonIcon = Icons.auto_awesome_outlined,\n"
        "    VoidCallback? onSecondary,\n",
        'secondary footer params',
    )

if "journey-secondary-$title" not in screen:
    primary = re.compile(
        r"(                       Expanded\(\n"
        r"                         flex: 2,\n"
        r"                         child: FilledButton\.icon\(\n)"
    )
    block = """                       if (secondaryButtonText != null && onSecondary != null) ...[
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
"""
    screen, count = primary.subn(block + r"\1", screen, count=1)
    if count != 1:
        raise RuntimeError('secondary footer placement')

if "secondaryButtonText: hasFeedback ? 'AI 回答' : null" not in screen:
    screen = require_replace(
        screen,
        "      onNext: hasFeedback ? null : () => unawaited(_askGuide()),\n",
        "      onNext: hasFeedback ? null : () => unawaited(_askGuide()),\n"
        "      secondaryButtonText: hasFeedback ? 'AI 回答' : null,\n"
        "      secondaryButtonIcon: Icons.forum_outlined,\n"
        "      onSecondary:\n"
        "          hasFeedback ? () => unawaited(_showGuideFeedback()) : null,\n",
        'Think review button',
    )
if "secondaryButtonText: hasFeedback ? 'AI 批改' : null" not in screen:
    screen = require_replace(
        screen,
        "      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),\n",
        "      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),\n"
        "      secondaryButtonText: hasFeedback ? 'AI 批改' : null,\n"
        "      secondaryButtonIcon: Icons.fact_check_outlined,\n"
        "      onSecondary:\n"
        "          hasFeedback ? () => unawaited(_showWritingFeedback()) : null,\n",
        'Express review button',
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
  const back = screen.indexOf("'上一步'");
  const secondary = screen.indexOf('if (secondaryButtonText != null');
  const primary = screen.indexOf('child: FilledButton.icon', secondary);
  assert.ok(back >= 0 && secondary > back && primary > secondary);
});

test('editing an answer removes feedback that no longer matches it', () => {
  assert.match(screen, /clearGuideFeedback\(\)/);
  assert.match(screen, /clearWritingFeedback\(\)/);
});
""", encoding='utf-8')
