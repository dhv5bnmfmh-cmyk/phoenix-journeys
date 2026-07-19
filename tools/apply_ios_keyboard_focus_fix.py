from pathlib import Path

SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/keyboard_safe_writing_pages_rule.test.mjs')

screen = SCREEN.read_text(encoding='utf-8')
if 'wonderFocusNode' in screen and 'onTapOutside:' not in screen:
    raise SystemExit(0)

screen = screen.replace(
    "  final memoryController = TextEditingController();\n",
    "  final memoryController = TextEditingController();\n"
    "  final wonderFocusNode = FocusNode(debugLabel: 'wonder-writing');\n"
    "  final expressFocusNode = FocusNode(debugLabel: 'express-writing');\n"
    "  final memoryFocusNode = FocusNode(debugLabel: 'memory-writing');\n",
    1,
)

screen = screen.replace(
    "    _ai = PhoenixAiService();\n  }\n",
    "    _ai = PhoenixAiService();\n"
    "    wonderFocusNode.addListener(_handleWritingFocusChanged);\n"
    "    expressFocusNode.addListener(_handleWritingFocusChanged);\n"
    "    memoryFocusNode.addListener(_handleWritingFocusChanged);\n"
    "  }\n\n"
    "  void _handleWritingFocusChanged() {\n"
    "    if (mounted) setState(() {});\n"
    "  }\n",
    1,
)

screen = screen.replace(
    "    memoryController.dispose();\n    super.dispose();\n",
    "    memoryController.dispose();\n"
    "    wonderFocusNode.removeListener(_handleWritingFocusChanged);\n"
    "    expressFocusNode.removeListener(_handleWritingFocusChanged);\n"
    "    memoryFocusNode.removeListener(_handleWritingFocusChanged);\n"
    "    wonderFocusNode.dispose();\n"
    "    expressFocusNode.dispose();\n"
    "    memoryFocusNode.dispose();\n"
    "    super.dispose();\n",
    1,
)

screen = screen.replace(
    "    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;\n"
    "    return _page(\n"
    "      title: '思考',\n",
    "    final keyboardVisible = wonderFocusNode.hasFocus;\n"
    "    return _page(\n"
    "      title: '思考',\n",
    1,
)
screen = screen.replace(
    "    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;\n"
    "    return _page(\n"
    "      title: '表达',\n",
    "    final keyboardVisible = expressFocusNode.hasFocus;\n"
    "    return _page(\n"
    "      title: '表达',\n",
    1,
)
screen = screen.replace(
    "    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;\n"
    "    return _page(\n"
    "      title: '旅程回忆',\n",
    "    final keyboardVisible = memoryFocusNode.hasFocus;\n"
    "    return _page(\n"
    "      title: '旅程回忆',\n",
    1,
)

screen = screen.replace(
    "              controller: wonderController,\n",
    "              controller: wonderController,\n"
    "              focusNode: wonderFocusNode,\n",
    1,
)
screen = screen.replace(
    "              controller: expressController,\n",
    "              controller: expressController,\n"
    "              focusNode: expressFocusNode,\n",
    1,
)
screen = screen.replace(
    "              controller: memoryController,\n",
    "              controller: memoryController,\n"
    "              focusNode: memoryFocusNode,\n",
    1,
)

screen = screen.replace(
    "              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),\n",
    "",
)

if screen.count('focusNode: wonderFocusNode') != 1:
    raise RuntimeError('wonder focus node was not applied exactly once')
if screen.count('focusNode: expressFocusNode') != 1:
    raise RuntimeError('express focus node was not applied exactly once')
if screen.count('focusNode: memoryFocusNode') != 1:
    raise RuntimeError('memory focus node was not applied exactly once')
if 'onTapOutside:' in screen:
    raise RuntimeError('manual tap-outside unfocus still exists')

SCREEN.write_text(screen, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('journey screen resizes above the iPhone keyboard', () => {
  assert.match(screen, /resizeToAvoidBottomInset: true/);
  assert.match(screen, /MediaQuery\.viewInsetsOf\(context\)\.bottom > 0/);
});

test('keyboard mode hides fixed navigation that previously covered writing', () => {
  const start = screen.indexOf('Widget _page');
  const end = screen.indexOf('Widget _storyPage', start);
  const body = screen.slice(start, end);

  assert.match(body, /bool keyboardAdaptive = false/);
  assert.match(body, /if \(!keyboardVisible\)[\s\S]*JourneyProgressHeader/);
  assert.match(body, /if \(!keyboardVisible\)[\s\S]*FilledButton\.icon/);
  assert.match(body, /输入中/);
});

test('writing fields keep persistent focus nodes on iPhone Safari', () => {
  assert.match(screen, /final wonderFocusNode = FocusNode/);
  assert.match(screen, /final expressFocusNode = FocusNode/);
  assert.match(screen, /final memoryFocusNode = FocusNode/);
  assert.match(screen, /focusNode: wonderFocusNode/);
  assert.match(screen, /focusNode: expressFocusNode/);
  assert.match(screen, /focusNode: memoryFocusNode/);
  assert.match(screen, /wonderFocusNode\.hasFocus/);
  assert.match(screen, /expressFocusNode\.hasFocus/);
  assert.match(screen, /memoryFocusNode\.hasFocus/);
});

test('Safari keyboard cannot be dismissed by a synthetic tap outside', () => {
  assert.doesNotMatch(screen, /onTapOutside:/);
  assert.doesNotMatch(screen, /primaryFocus\?\.unfocus/);
});

for (const page of ['_wonderPage', '_expressPage', '_memoryPage']) {
  test(`${page} gives the text field the keyboard viewport`, () => {
    const start = screen.indexOf(`Widget ${page}`);
    const end = screen.indexOf('Widget _', start + 8);
    const body = screen.slice(start, end);

    assert.match(body, /keyboardAdaptive: true/);
    assert.match(body, /Expanded\([\s\S]*TextField\(/);
    assert.match(body, /scrollPadding: const EdgeInsets\.only\(bottom: 24\)/);
  });
}

test('all three writing fields have stable test keys', () => {
  assert.match(screen, /wonder-writing-field/);
  assert.match(screen, /express-writing-field/);
  assert.match(screen, /memory-writing-field/);
});
""", encoding='utf-8')
