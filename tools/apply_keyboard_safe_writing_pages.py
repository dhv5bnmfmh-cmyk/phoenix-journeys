from pathlib import Path
import re

SCREEN = Path('app/lib/screens/journey_screen.dart')
RULE = Path('worker/keyboard_safe_writing_pages_rule.test.mjs')

screen = SCREEN.read_text(encoding='utf-8')
if "keyboardAdaptive: true" in screen and "输入中" in screen:
    raise SystemExit(0)

screen = screen.replace(
    "    return Scaffold(\n      appBar: AppBar(",
    "    return Scaffold(\n      resizeToAvoidBottomInset: true,\n      appBar: AppBar(",
    1,
)

page_pattern = re.compile(
    r"  Widget _page\(\{.*?\n  \}\n\n  Widget _storyPage\(\) \{",
    re.S,
)
page_replacement = '''  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    IconData buttonIcon = Icons.arrow_forward,
    VoidCallback? onNext,
    bool showBack = true,
    bool keyboardAdaptive = false,
  }) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      key: ValueKey(title),
      builder: (context, constraints) {
        final keyboardVisible =
            keyboardAdaptive && MediaQuery.viewInsetsOf(context).bottom > 0;
        final compact = constraints.maxHeight < 590 || keyboardVisible;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            keyboardVisible ? 2 : (compact ? 4 : 6),
            12,
            keyboardVisible ? 3 : 8,
          ),
          child: Column(
            children: [
              if (!keyboardVisible) ...[
                JourneyProgressHeader(
                  currentStep: step,
                  furthestStep: state.beijingJourneyFurthestStep,
                  labels: AppState.beijingJourneyStepLabels,
                  onStepSelected: (value) => unawaited(_goToStep(value)),
                ),
                SizedBox(height: compact ? 3 : 5),
              ],
              SizedBox(
                height: keyboardVisible ? 26 : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: keyboardVisible ? 15 : (compact ? 17 : 19),
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (keyboardVisible)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.gold.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text(
                          '输入中',
                          style: TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.gold.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text(
                          '单屏模式',
                          style: TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: keyboardVisible ? 3 : (compact ? 4 : 6)),
              Expanded(child: child),
              if (!keyboardVisible) ...[
                SizedBox(height: compact ? 4 : 7),
                SizedBox(
                  height: compact ? 36 : 40,
                  child: Row(
                    children: [
                      if (showBack &&
                          step > 0 &&
                          step < AppState.beijingJourneyLastStep) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => unawaited(_goToStep(step - 1)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            icon: const Icon(Icons.arrow_back_rounded, size: 17),
                            label: const Text(
                              '上一步',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed:
                              onNext ?? () => unawaited(_goToStep(step + 1)),
                          style: FilledButton.styleFrom(
                            backgroundColor: PhoenixTheme.red,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          icon: Icon(buttonIcon, size: 17),
                          label: Text(
                            buttonText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _storyPage() {'''
screen, count = page_pattern.subn(page_replacement, screen, count=1)
if count != 1:
    raise RuntimeError('unable to replace _page')

wonder_pattern = re.compile(
    r"  Widget _wonderPage\(\) \{.*?\n  \}\n\n  Widget _expressPage\(\) \{",
    re.S,
)
wonder_replacement = '''  Widget _wonderPage() {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    return _page(
      title: '思考',
      keyboardAdaptive: true,
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
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: _onWonderChanged,
              decoration: const InputDecoration(
                hintText: '写下你的想法……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (!keyboardVisible) ...[
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
        ],
      ),
    );
  }

  Widget _expressPage() {'''
screen, count = wonder_pattern.subn(wonder_replacement, screen, count=1)
if count != 1:
    raise RuntimeError('unable to replace _wonderPage')

express_pattern = re.compile(
    r"  Widget _expressPage\(\) \{.*?\n  \}\n\n  Widget _memoryPage\(\) \{",
    re.S,
)
express_replacement = '''  Widget _expressPage() {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    return _page(
      title: '表达',
      keyboardAdaptive: true,
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
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: _onExpressChanged,
              decoration: const InputDecoration(
                hintText: '用中文写下你的表达……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (!keyboardVisible) ...[
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
        ],
      ),
    );
  }

  Widget _memoryPage() {'''
screen, count = express_pattern.subn(express_replacement, screen, count=1)
if count != 1:
    raise RuntimeError('unable to replace _expressPage')

memory_pattern = re.compile(
    r"  Widget _memoryPage\(\) \{.*?\n  \}\n\n  Widget _completePage\(\) \{",
    re.S,
)
memory_replacement = '''  Widget _memoryPage() {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    return _page(
      title: '旅程回忆',
      keyboardAdaptive: true,
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今天最想记住的一件事是什么？',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: keyboardVisible ? 11 : 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 6),
          Expanded(
            child: TextField(
              key: const ValueKey('memory-writing-field'),
              controller: memoryController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: (_) => unawaited(_persistProgress()),
              decoration: const InputDecoration(
                hintText: '写下感受，未来回来比较自己的变化。',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (!keyboardVisible) ...[
            const SizedBox(height: 6),
            const _InlineTip(
              icon: Icons.approval_outlined,
              text: '结束后自动保存回忆，并由 PhoenixStampAgent 完成盖章。',
            ),
          ],
        ],
      ),
    );
  }

  Widget _completePage() {'''
screen, count = memory_pattern.subn(memory_replacement, screen, count=1)
if count != 1:
    raise RuntimeError('unable to replace _memoryPage')

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

for (const page of ['_wonderPage', '_expressPage', '_memoryPage']) {
  test(`${page} gives the text field the keyboard viewport`, () => {
    const start = screen.indexOf(`Widget ${page}`);
    const end = screen.indexOf('Widget _', start + 8);
    const body = screen.slice(start, end);

    assert.match(body, /keyboardAdaptive: true/);
    assert.match(body, /Expanded\([\s\S]*TextField\(/);
    assert.match(body, /scrollPadding: const EdgeInsets\.only\(bottom: 24\)/);
    assert.match(body, /onTapOutside:/);
  });
}

test('all three writing fields have stable test keys', () => {
  assert.match(screen, /wonder-writing-field/);
  assert.match(screen, /express-writing-field/);
  assert.match(screen, /memory-writing-field/);
});
""", encoding='utf-8')
