from pathlib import Path

SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/keyboard_safe_writing_pages_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing target: {label}')
    return text.replace(old, new, 1)


screen = SCREEN.read_text(encoding='utf-8')
if 'keyboardFocusNode: wonderFocusNode' in screen and 'keyboardVisible ? 34 : 38' in screen:
    raise SystemExit(0)

screen = replace_once(
    screen,
    "    bool keyboardAdaptive = false,\n  }) {",
    "    bool keyboardAdaptive = false,\n    FocusNode? keyboardFocusNode,\n  }) {",
    'page focus parameter',
)
screen = replace_once(
    screen,
    "        final keyboardVisible =\n            keyboardAdaptive && MediaQuery.viewInsetsOf(context).bottom > 0;",
    "        final keyboardVisible = keyboardAdaptive &&\n            (keyboardFocusNode?.hasFocus ??\n                MediaQuery.viewInsetsOf(context).bottom > 0);",
    'focus-driven keyboard state',
)

for page, focus in (
    ('思考', 'wonderFocusNode'),
    ('表达', 'expressFocusNode'),
    ('旅程回忆', 'memoryFocusNode'),
):
    screen = replace_once(
        screen,
        f"      title: '{page}',\n      keyboardAdaptive: true,",
        f"      title: '{page}',\n      keyboardAdaptive: true,\n      keyboardFocusNode: {focus},",
        f'{page} focus node',
    )

wonder_old = """          if (!keyboardVisible) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('ask-phoenix-guide-agent'),
                    onPressed: _guideLoading
                        ? null
                        : () => unawaited(_askGuide()),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: _guideLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome, size: 17),
                    label: Text(
                      _guideLoading ? 'AI 正在回应…' : '问 PhoenixGuideAgent',
                      style: const TextStyle(fontSize: 10.5),
                    ),
                  ),
                ),
                if (_guideFeedback != null) ...[
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: '查看 AI 回应',
                    onPressed: () => unawaited(_showGuideFeedback()),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.forum_rounded, size: 18),
                  ),
                ],
              ],
            ),
          ],
"""
wonder_new = """          SizedBox(height: keyboardVisible ? 3 : 6),
          SizedBox(
            height: keyboardVisible ? 34 : 38,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('ask-phoenix-guide-agent'),
                    onPressed: _guideLoading
                        ? null
                        : () => unawaited(_askGuide()),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: _guideLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome, size: 16),
                    label: Text(
                      _guideLoading ? 'AI 正在回应…' : '问 PhoenixGuideAgent',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: keyboardVisible ? 9.5 : 10.5,
                      ),
                    ),
                  ),
                ),
                if (_guideFeedback != null) ...[
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: '查看 AI 回应',
                    onPressed: () => unawaited(_showGuideFeedback()),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.forum_rounded, size: 17),
                  ),
                ],
              ],
            ),
          ),
"""
screen = replace_once(screen, wonder_old, wonder_new, 'wonder AI action')

express_old = """          if (!keyboardVisible) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    key: const ValueKey('ask-phoenix-writing-agent'),
                    onPressed: _writingLoading
                        ? null
                        : () => unawaited(_reviewWriting()),
                    style: FilledButton.styleFrom(
                      backgroundColor: PhoenixTheme.red,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: _writingLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.spellcheck_rounded, size: 17),
                    label: Text(
                      _writingLoading ? 'AI 正在批改…' : '请 PhoenixWritingAgent 批改',
                      style: const TextStyle(fontSize: 10.5),
                    ),
                  ),
                ),
                if (_writingFeedback != null) ...[
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: '查看批改结果',
                    onPressed: () => unawaited(_showWritingFeedback()),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.fact_check_rounded, size: 18),
                  ),
                ],
              ],
            ),
          ],
"""
express_new = """          SizedBox(height: keyboardVisible ? 3 : 6),
          SizedBox(
            height: keyboardVisible ? 34 : 38,
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    key: const ValueKey('ask-phoenix-writing-agent'),
                    onPressed: _writingLoading
                        ? null
                        : () => unawaited(_reviewWriting()),
                    style: FilledButton.styleFrom(
                      backgroundColor: PhoenixTheme.red,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: _writingLoading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.spellcheck_rounded, size: 16),
                    label: Text(
                      _writingLoading ? 'AI 正在批改…' : '请 PhoenixWritingAgent 批改',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: keyboardVisible ? 9.5 : 10.5,
                      ),
                    ),
                  ),
                ),
                if (_writingFeedback != null) ...[
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: '查看批改结果',
                    onPressed: () => unawaited(_showWritingFeedback()),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.fact_check_rounded, size: 17),
                  ),
                ],
              ],
            ),
          ),
"""
screen = replace_once(screen, express_old, express_new, 'express AI action')

SCREEN.write_text(screen, encoding='utf-8')

rule = RULE.read_text(encoding='utf-8')
rule += """

test('writing page shell follows the persistent FocusNode on iPhone Safari', () => {
  const start = screen.indexOf('Widget _page');
  const end = screen.indexOf('Widget _storyPage', start);
  const body = screen.slice(start, end);

  assert.match(body, /FocusNode\? keyboardFocusNode/);
  assert.match(body, /keyboardFocusNode\?\.hasFocus/);
  assert.match(screen, /keyboardFocusNode: wonderFocusNode/);
  assert.match(screen, /keyboardFocusNode: expressFocusNode/);
  assert.match(screen, /keyboardFocusNode: memoryFocusNode/);
});

test('Think and Express AI actions remain above the keyboard', () => {
  const wonderStart = screen.indexOf('Widget _wonderPage');
  const expressStart = screen.indexOf('Widget _expressPage');
  const memoryStart = screen.indexOf('Widget _memoryPage');
  const wonder = screen.slice(wonderStart, expressStart);
  const express = screen.slice(expressStart, memoryStart);

  assert.match(wonder, /height: keyboardVisible \? 34 : 38/);
  assert.match(wonder, /ask-phoenix-guide-agent/);
  assert.doesNotMatch(wonder, /if \(!keyboardVisible\)[\s\S]*ask-phoenix-guide-agent/);
  assert.match(express, /height: keyboardVisible \? 34 : 38/);
  assert.match(express, /ask-phoenix-writing-agent/);
  assert.doesNotMatch(express, /if \(!keyboardVisible\)[\s\S]*ask-phoenix-writing-agent/);
});
"""
RULE.write_text(rule, encoding='utf-8')
