from pathlib import Path
import re

SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/ai_action_response_rule.test.mjs')

screen = SCREEN.read_text(encoding='utf-8')
if 'PhoenixGuideAgent 正在思考' in screen and 'TextInput.hide' in screen:
    raise SystemExit(0)

screen = screen.replace(
    "import 'package:flutter/material.dart';\n",
    "import 'package:flutter/material.dart';\nimport 'package:flutter/services.dart';\n",
    1,
)

pattern = re.compile(
    r"  Future<void> _askGuide\(\) async \{.*?\n  Future<void> _showGuideFeedback\(\) async \{",
    re.S,
)
replacement = '''  Future<void> _prepareAgentAction(
    FocusNode focusNode,
    String message,
  ) async {
    focusNode.unfocus();
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(seconds: 20),
          behavior: SnackBarBehavior.floating,
        ),
      );

    // iPhone Safari needs one keyboard animation frame before a modal route.
    await Future<void>.delayed(const Duration(milliseconds: 180));
  }

  void _clearAgentStatus() {
    if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _showAgentMessage(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _askGuide() async {
    if (_guideLoading) return;
    final answer = wonderController.text.trim();
    if (answer.length < 2) {
      _showAgentMessage('请先写下一点想法。');
      return;
    }

    setState(() => _guideLoading = true);
    await _prepareAgentAction(
      wonderFocusNode,
      'PhoenixGuideAgent 正在思考…',
    );
    if (!mounted) return;

    try {
      final feedback = await _ai.askGuide(
        text: answer,
        language: _appState.translationLanguage,
      );
      if (!mounted) return;

      _clearAgentStatus();
      setState(() {
        _guideFeedback = feedback;
        _guideLoading = false;
      });
      await _showGuideFeedback();
    } catch (_) {
      if (!mounted) return;
      _clearAgentStatus();
      _showAgentMessage('PhoenixGuideAgent 暂时没有回应，请再试一次。');
    } finally {
      if (mounted && _guideLoading) {
        setState(() => _guideLoading = false);
      }
    }
  }

  Future<void> _reviewWriting() async {
    if (_writingLoading) return;
    final writing = expressController.text.trim();
    if (writing.length < 2) {
      _showAgentMessage('请先写下至少两个字。');
      return;
    }

    setState(() => _writingLoading = true);
    await _prepareAgentAction(
      expressFocusNode,
      'PhoenixWritingAgent 正在批改…',
    );
    if (!mounted) return;

    try {
      final feedback = await _ai.reviewWriting(
        text: writing,
        language: _appState.translationLanguage,
      );
      if (!mounted) return;

      _clearAgentStatus();
      setState(() {
        _writingFeedback = feedback;
        _writingLoading = false;
      });
      await _showWritingFeedback();
    } catch (_) {
      if (!mounted) return;
      _clearAgentStatus();
      _showAgentMessage('PhoenixWritingAgent 暂时无法批改，请再试一次。');
    } finally {
      if (mounted && _writingLoading) {
        setState(() => _writingLoading = false);
      }
    }
  }

  Future<void> _showGuideFeedback() async {'''
screen, count = pattern.subn(replacement, screen, count=1)
if count != 1:
    raise RuntimeError('unable to replace AI action methods')

screen = screen.replace(
    "  Future<void> _showGuideFeedback() async {\n"
    "    final feedback = _guideFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n",
    "  Future<void> _showGuideFeedback() async {\n"
    "    final feedback = _guideFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    FocusManager.instance.primaryFocus?.unfocus();\n"
    "    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');\n"
    "    if (!mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n"
    "      useRootNavigator: true,\n",
    1,
)
screen = screen.replace(
    "  Future<void> _showWritingFeedback() async {\n"
    "    final feedback = _writingFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n",
    "  Future<void> _showWritingFeedback() async {\n"
    "    final feedback = _writingFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    FocusManager.instance.primaryFocus?.unfocus();\n"
    "    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');\n"
    "    if (!mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n"
    "      useRootNavigator: true,\n",
    1,
)

if "PhoenixGuideAgent 正在思考" not in screen:
    raise RuntimeError('guide loading feedback missing')
if "PhoenixWritingAgent 正在批改" not in screen:
    raise RuntimeError('writing loading feedback missing')
if screen.count("useRootNavigator: true") < 2:
    raise RuntimeError('result sheets are not using root navigator')

SCREEN.write_text(screen, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Think and Express dismiss the iPhone keyboard before calling AI', () => {
  assert.match(screen, /import 'package:flutter\/services\.dart'/);
  assert.match(screen, /focusNode\.unfocus\(\)/);
  assert.match(screen, /SystemChannels\.textInput\.invokeMethod<void>\('TextInput\.hide'\)/);
  assert.match(screen, /_prepareAgentAction\([\s\S]*wonderFocusNode/);
  assert.match(screen, /_prepareAgentAction\([\s\S]*expressFocusNode/);
});

test('both agent actions show immediate progress instead of appearing frozen', () => {
  assert.match(screen, /PhoenixGuideAgent 正在思考/);
  assert.match(screen, /PhoenixWritingAgent 正在批改/);
  assert.match(screen, /CircularProgressIndicator/);
  assert.match(screen, /SnackBarBehavior\.floating/);
});

test('both agent actions always clear loading state', () => {
  const guideStart = screen.indexOf('Future<void> _askGuide');
  const writingStart = screen.indexOf('Future<void> _reviewWriting');
  const showStart = screen.indexOf('Future<void> _showGuideFeedback');
  const guide = screen.slice(guideStart, writingStart);
  const writing = screen.slice(writingStart, showStart);

  assert.match(guide, /try \{/);
  assert.match(guide, /finally \{/);
  assert.match(guide, /_guideLoading = false/);
  assert.match(writing, /try \{/);
  assert.match(writing, /finally \{/);
  assert.match(writing, /_writingLoading = false/);
});

test('AI results open above Safari with the root navigator', () => {
  const matches = screen.match(/useRootNavigator: true/g) ?? [];
  assert.ok(matches.length >= 2);
  assert.match(screen, /await _showGuideFeedback\(\)/);
  assert.match(screen, /await _showWritingFeedback\(\)/);
});

test('short input receives a visible message', () => {
  assert.match(screen, /请先写下一点想法/);
  assert.match(screen, /请先写下至少两个字/);
});
""", encoding='utf-8')
