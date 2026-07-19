from pathlib import Path
import re

SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/agent_primary_action_rule.test.mjs')

text = SCREEN.read_text(encoding='utf-8')


def replace_once(source: str, old: str, new: str, label: str) -> str:
    if old not in source:
        raise RuntimeError(f'missing target: {label}')
    return source.replace(old, new, 1)


if "package:flutter/services.dart" not in text:
    text = replace_once(
        text,
        "import 'package:flutter/material.dart';\n",
        "import 'package:flutter/material.dart';\nimport 'package:flutter/services.dart';\n",
        'services import',
    )

agent_pattern = re.compile(
    r"  Future<void> _askGuide\(\) async \{.*?\n  Future<void> _showGuideFeedback\(\) async \{",
    re.S,
)
agent_replacement = '''  Future<void> _prepareAgentAction(
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
text, count = agent_pattern.subn(agent_replacement, text, count=1)
if count != 1:
    raise RuntimeError('unable to replace agent actions')

text = replace_once(
    text,
    "    final feedback = _guideFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n",
    "    final feedback = _guideFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');\n"
    "    if (!mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n"
    "      useRootNavigator: true,\n",
    'guide root sheet',
)
text = replace_once(
    text,
    "    final feedback = _writingFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n",
    "    final feedback = _writingFeedback;\n"
    "    if (feedback == null || !mounted) return;\n"
    "    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');\n"
    "    if (!mounted) return;\n"
    "    await showModalBottomSheet<void>(\n"
    "      context: context,\n"
    "      useRootNavigator: true,\n",
    'writing root sheet',
)

text = replace_once(
    text,
    "    bool keyboardAdaptive = false,\n"
    "    FocusNode? keyboardFocusNode,\n",
    "    bool keyboardAdaptive = false,\n"
    "    FocusNode? keyboardFocusNode,\n"
    "    bool primaryLoading = false,\n"
    "    bool primaryEnabled = true,\n",
    'page primary state parameters',
)
text = replace_once(
    text,
    "                          onPressed:\n"
    "                              onNext ?? () => unawaited(_goToStep(step + 1)),\n",
    "                          onPressed: primaryEnabled && !primaryLoading\n"
    "                              ? onNext ??\n"
    "                                  () => unawaited(_goToStep(step + 1))\n"
    "                              : null,\n",
    'page primary action',
)
text = replace_once(
    text,
    "                          icon: Icon(buttonIcon, size: 17),\n",
    "                          icon: primaryLoading\n"
    "                              ? const SizedBox(\n"
    "                                  width: 16,\n"
    "                                  height: 16,\n"
    "                                  child: CircularProgressIndicator(\n"
    "                                    strokeWidth: 2,\n"
    "                                    color: Colors.white,\n"
    "                                  ),\n"
    "                                )\n"
    "                              : Icon(buttonIcon, size: 17),\n",
    'page primary loading icon',
)

wonder_pattern = re.compile(
    r"  Widget _wonderPage\(\) \{.*?\n  \}\n\n  Widget _expressPage\(\) \{",
    re.S,
)
wonder_replacement = '''  Widget _wonderPage() {
    final keyboardVisible = wonderFocusNode.hasFocus;
    final hasFeedback = _guideFeedback != null;
    return _page(
      title: '思考',
      keyboardAdaptive: true,
      keyboardFocusNode: wonderFocusNode,
      buttonText: hasFeedback
          ? '继续'
          : (_guideLoading ? 'AI 正在回应…' : '问 PhoenixGuideAgent'),
      buttonIcon: hasFeedback ? Icons.arrow_forward : Icons.auto_awesome,
      primaryLoading: _guideLoading,
      primaryEnabled: !_guideLoading,
      onNext: hasFeedback ? null : () => unawaited(_askGuide()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wonderQuestion,
            maxLines: keyboardVisible ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: keyboardVisible ? 11 : 12,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 5),
          if (!keyboardVisible) ...[
            const _InlineTip(
              icon: Icons.explore_outlined,
              text: 'PhoenixGuideAgent 会补充探索角度，并提出下一步问题。',
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TextField(
              key: const ValueKey('wonder-writing-field'),
              controller: wonderController,
              focusNode: wonderFocusNode,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onChanged: _onWonderChanged,
              decoration: const InputDecoration(
                hintText: '写下你的想法……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expressPage() {'''
text, count = wonder_pattern.subn(wonder_replacement, text, count=1)
if count != 1:
    raise RuntimeError('unable to replace Think page')

express_pattern = re.compile(
    r"  Widget _expressPage\(\) \{.*?\n  \}\n\n  Widget _memoryPage\(\) \{",
    re.S,
)
express_replacement = '''  Widget _expressPage() {
    final keyboardVisible = expressFocusNode.hasFocus;
    final hasFeedback = _writingFeedback != null;
    return _page(
      title: '表达',
      keyboardAdaptive: true,
      keyboardFocusNode: expressFocusNode,
      buttonText: hasFeedback
          ? '继续'
          : (_writingLoading ? 'AI 正在批改…' : '请 PhoenixWritingAgent 批改'),
      buttonIcon: hasFeedback ? Icons.arrow_forward : Icons.spellcheck_rounded,
      primaryLoading: _writingLoading,
      primaryEnabled: !_writingLoading,
      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expressQuestion,
            maxLines: keyboardVisible ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: keyboardVisible ? 11 : 12,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 5),
          if (!keyboardVisible) ...[
            const _InlineTip(
              icon: Icons.edit_note_outlined,
              text: 'PhoenixWritingAgent 会保留原意，给出修改版和原因。',
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TextField(
              key: const ValueKey('express-writing-field'),
              controller: expressController,
              focusNode: expressFocusNode,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onChanged: _onExpressChanged,
              decoration: const InputDecoration(
                hintText: '用中文写下你的表达……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memoryPage() {'''
text, count = express_pattern.subn(express_replacement, text, count=1)
if count != 1:
    raise RuntimeError('unable to replace Express page')

if "key: const ValueKey('ask-phoenix-guide-agent')" in text:
    raise RuntimeError('old Think inline Agent button still exists')
if "key: const ValueKey('ask-phoenix-writing-agent')" in text:
    raise RuntimeError('old Express inline Agent button still exists')

SCREEN.write_text(text, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Think and Express use the bottom primary action area', () => {
  assert.doesNotMatch(screen, /ask-phoenix-guide-agent/);
  assert.doesNotMatch(screen, /ask-phoenix-writing-agent/);
  assert.match(screen, /buttonText: hasFeedback[\s\S]*问 PhoenixGuideAgent/);
  assert.match(screen, /buttonText: hasFeedback[\s\S]*请 PhoenixWritingAgent 批改/);
});

test('Agent buttons become Continue only after feedback exists', () => {
  const matches = screen.match(/hasFeedback \? '继续'/g) ?? [];
  assert.equal(matches.length, 2);
  assert.match(screen, /onNext: hasFeedback \? null : \(\) => unawaited\(_askGuide\(\)\)/);
  assert.match(screen, /onNext: hasFeedback \? null : \(\) => unawaited\(_reviewWriting\(\)\)/);
});

test('primary action shows loading and cannot accidentally continue', () => {
  assert.match(screen, /bool primaryLoading = false/);
  assert.match(screen, /bool primaryEnabled = true/);
  assert.match(screen, /primaryEnabled && !primaryLoading/);
  assert.match(screen, /CircularProgressIndicator/);
});

test('Agent actions safely close the iPhone keyboard and show results', () => {
  assert.match(screen, /focusNode\.unfocus\(\)/);
  assert.match(screen, /SystemChannels\.textInput/);
  assert.match(screen, /useRootNavigator: true/);
  assert.match(screen, /await _showGuideFeedback\(\)/);
  assert.match(screen, /await _showWritingFeedback\(\)/);
});

test('editing an answer resets the primary action back to Agent', () => {
  assert.match(screen, /_guideFeedback = null/);
  assert.match(screen, /_writingFeedback = null/);
});
""", encoding='utf-8')
