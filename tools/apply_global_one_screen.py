from pathlib import Path
import re


def replace_once(source: str, pattern: str, replacement: str, label: str) -> str:
    updated, count = re.subn(pattern, replacement, source, count=1, flags=re.S)
    if count != 1:
        raise SystemExit(f'{label}: expected one replacement, got {count}')
    return updated


journey_path = Path('app/lib/screens/journey_screen.dart')
source = journey_path.read_text()

source = source.replace(
    "import '../widgets/annotated_reading_card.dart';\n",
    "import '../widgets/annotated_reading_card.dart';\nimport '../widgets/compact_pager.dart';\n",
    1,
)

ask_guide = r'''  Future<void> _askGuide() async {
    if (_guideLoading) return;

    setState(() => _guideLoading = true);
    final feedback = await _ai.askGuide(
      text: wonderController.text,
      language: _appState.translationLanguage,
    );
    if (!mounted) return;

    setState(() {
      _guideFeedback = feedback;
      _guideLoading = false;
    });
    await _showGuideFeedback();
  }
'''
source = replace_once(
    source,
    r'  Future<void> _askGuide\(\) async \{.*?\n  \}\n\n(?=  Future<void> _reviewWriting)',
    ask_guide + '\n',
    '_askGuide',
)

review_writing = r'''  Future<void> _reviewWriting() async {
    if (_writingLoading) return;

    setState(() => _writingLoading = true);
    final feedback = await _ai.reviewWriting(
      text: expressController.text,
      language: _appState.translationLanguage,
    );
    if (!mounted) return;

    setState(() {
      _writingFeedback = feedback;
      _writingLoading = false;
    });
    await _showWritingFeedback();
  }

  Future<void> _showGuideFeedback() async {
    final feedback = _guideFeedback;
    if (feedback == null || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .78,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
          child: PhoenixGuideReplyCard(feedback: feedback),
        ),
      ),
    );
  }

  Future<void> _showWritingFeedback() async {
    final feedback = _writingFeedback;
    if (feedback == null || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .82,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
          child: PhoenixWritingFeedbackCard(feedback: feedback),
        ),
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Future<void> _reviewWriting\(\) async \{.*?\n  \}\n\n(?=  void _onWonderChanged)',
    review_writing + '\n',
    '_reviewWriting and feedback sheets',
)

source = source.replace(
    "      appBar: AppBar(\n        title: const Text('北京 · 紫禁城'),",
    "      appBar: AppBar(\n        toolbarHeight: 44,\n        title: const Text(\n          '北京 · 紫禁城',\n          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),\n        ),",
    1,
)
source = source.replace(
    "              child: Text(\n                state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',\n              ),",
    "              style: TextButton.styleFrom(\n                visualDensity: VisualDensity.compact,\n                padding: const EdgeInsets.symmetric(horizontal: 8),\n              ),\n              child: Text(\n                state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',\n                style: const TextStyle(fontSize: 10.5),\n              ),",
    1,
)

page_method = r'''  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    IconData buttonIcon = Icons.arrow_forward,
    VoidCallback? onNext,
    bool showBack = true,
  }) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      key: ValueKey(title),
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 590;
        return Padding(
          padding: EdgeInsets.fromLTRB(12, compact ? 4 : 6, 12, 8),
          child: Column(
            children: [
              JourneyProgressHeader(
                currentStep: step,
                furthestStep: state.beijingJourneyFurthestStep,
                labels: AppState.beijingJourneyStepLabels,
                onStepSelected: (value) => unawaited(_goToStep(value)),
              ),
              SizedBox(height: compact ? 3 : 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: compact ? 17 : 19,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
              SizedBox(height: compact ? 4 : 6),
              Expanded(child: child),
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
                          label: const Text('上一步', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: onNext ?? () => unawaited(_goToStep(step + 1)),
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
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _page\(\{.*?\n  \}\n\n(?=  Widget _storyPage)',
    page_method + '\n',
    '_page',
)

story_method = r'''  Widget _storyPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    final pages = _journeyContent.storyParagraphs.asMap().entries.map((entry) {
      final annotation = storyAnnotations[entry.key];
      final paragraphWords = words
          .where((word) => entry.value.contains(word.word))
          .toList(growable: false);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _narration,
                builder: (context, _) {
                  final isActive = _isNarrating('story', entry.key);
                  return AnnotatedReadingCard(
                    id: 'story-${entry.key}',
                    elevated: true,
                    isActive: isActive,
                    padding: const EdgeInsets.all(12),
                    pinyin: annotation.pinyin,
                    nativeLabel: annotation.nativeLabel(language),
                    nativeText: annotation.nativeText(language, entry.value),
                    english: annotation.english,
                    leading: isActive
                        ? const Icon(
                            Icons.graphic_eq_rounded,
                            size: 18,
                            color: PhoenixTheme.red,
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundColor: PhoenixTheme.gold.withValues(alpha: .16),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: PhoenixTheme.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                    mainText: InteractiveStoryText(
                      text: entry.value,
                      entries: words,
                      narrationContentId: 'story',
                      narrationItemId: 'story-${entry.key}',
                    ),
                  );
                },
              ),
              if (paragraphWords.isNotEmpty) ...[
                const SizedBox(height: 5),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: paragraphWords.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      final word = paragraphWords[index];
                      return ActionChip(
                        visualDensity: VisualDensity.compact,
                        avatar: WordMark(word: word.word, size: 21),
                        label: Text(
                          '${state.displayText(word.word)} · ${word.pinyin}',
                          style: const TextStyle(fontSize: 9.5),
                        ),
                        onPressed: () => unawaited(_openWord(word)),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList(growable: false);

    return _page(
      title: '故事',
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            onPlay: _playStory,
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.touch_app_outlined,
            text: '左右翻页阅读；点红色词语看释义，点“注”看拼音、母语与 English。',
          ),
          const SizedBox(height: 5),
          Expanded(
            child: CompactPager(
              semanticLabel: '故事段落分页',
              pages: pages,
            ),
          ),
        ],
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _storyPage\(\) \{.*?\n  \}\n\n(?=  Widget _wordsPage)',
    story_method + '\n',
    '_storyPage',
)

words_method = r'''  Widget _wordsPage() {
    final state = context.watch<AppState>();
    final chunks = compactChunks(words, 6);

    return _page(
      title: '生词',
      child: CompactPager(
        semanticLabel: '生词分页',
        pages: chunks.map((entries) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 2),
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2.05,
            children: entries.map((entry) {
              return Material(
                color: Colors.white.withValues(alpha: .94),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => unawaited(_openWord(entry)),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: PhoenixTheme.gold.withValues(alpha: .24),
                      ),
                    ),
                    child: Row(
                      children: [
                        WordMark(word: entry.word, size: 35),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.displayText(entry.word),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  if (state.isWordSaved(entry.word))
                                    const Icon(
                                      Icons.bookmark_rounded,
                                      size: 14,
                                      color: PhoenixTheme.red,
                                    ),
                                ],
                              ),
                              Text(
                                entry.pinyin,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 9.5,
                                ),
                              ),
                              Text(
                                state.displayText(entry.partOfSpeech),
                                maxLines: 1,
                                style: const TextStyle(
                                  color: PhoenixTheme.red,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          );
        }).toList(growable: false),
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _wordsPage\(\) \{.*?\n  \}\n\n(?=  Widget _discoveryPage)',
    words_method + '\n',
    '_wordsPage',
)

discovery_method = r'''  Widget _discoveryPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    final pages = discoveries.asMap().entries.map((entry) {
      final item = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              final isActive = _isNarrating('discovery', entry.key);
              return AnnotatedReadingCard(
                id: 'discovery-${entry.key}',
                elevated: true,
                isActive: isActive,
                padding: const EdgeInsets.all(13),
                pinyin: item.pinyin,
                nativeLabel: item.nativeLabel(language),
                nativeText: item.nativeText(language),
                english: item.english,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: isActive
                      ? PhoenixTheme.red
                      : PhoenixTheme.gold.withValues(alpha: .18),
                  child: isActive
                      ? const Icon(Icons.graphic_eq, size: 17, color: Colors.white)
                      : Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
                mainText: Text(
                  state.displayText(item.text),
                  style: TextStyle(
                    height: 1.45,
                    fontSize: 14.5,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }).toList(growable: false);

    return _page(
      title: '发现',
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery',
            subtitle: '中文朗读 · ${discoveries.length} 段',
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.notes_rounded,
            text: '左右翻页浏览发现；点“注”查看拼音、探索者母语和 English。',
          ),
          const SizedBox(height: 5),
          Expanded(
            child: CompactPager(
              semanticLabel: '发现分页',
              pages: pages,
            ),
          ),
        ],
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _discoveryPage\(\) \{.*?\n  \}\n\n(?=  Widget _wonderPage)',
    discovery_method + '\n',
    '_discoveryPage',
)

wonder_method = r'''  Widget _wonderPage() {
    return _page(
      title: '思考',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wonderQuestion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, height: 1.25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.explore_outlined,
            text: 'PhoenixGuideAgent 会补充探索角度，并提出下一步问题。',
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: wonderController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _onWonderChanged,
              decoration: const InputDecoration(
                hintText: '写下你的想法……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('ask-phoenix-guide-agent'),
                  onPressed: _guideLoading ? null : () => unawaited(_askGuide()),
                  style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
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
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _wonderPage\(\) \{.*?\n  \}\n\n(?=  Widget _expressPage)',
    wonder_method + '\n',
    '_wonderPage',
)

express_method = r'''  Widget _expressPage() {
    return _page(
      title: '表达',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expressQuestion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, height: 1.25, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.edit_note_outlined,
            text: 'PhoenixWritingAgent 会保留原意，给出修改版和原因。',
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: expressController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _onExpressChanged,
              decoration: const InputDecoration(
                hintText: '用中文写下你的表达……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('ask-phoenix-writing-agent'),
                  onPressed: _writingLoading ? null : () => unawaited(_reviewWriting()),
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
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _expressPage\(\) \{.*?\n  \}\n\n(?=  Widget _memoryPage)',
    express_method + '\n',
    '_expressPage',
)

memory_method = r'''  Widget _memoryPage() {
    return _page(
      title: '旅程回忆',
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今天最想记住的一件事是什么？',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: memoryController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (_) => unawaited(_persistProgress()),
              decoration: const InputDecoration(
                hintText: '写下感受，未来回来比较自己的变化。',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const _InlineTip(
            icon: Icons.approval_outlined,
            text: '结束后自动保存回忆，并由 PhoenixStampAgent 完成盖章。',
          ),
        ],
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _memoryPage\(\) \{.*?\n  \}\n\n(?=  Widget _completePage)',
    memory_method + '\n',
    '_memoryPage',
)

complete_method = r'''  Widget _completePage() {
    return _page(
      title: '北京已点亮',
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: AnimatedForbiddenCityStamp(),
              ),
            ),
          ),
          const Text(
            '盖章成功',
            style: TextStyle(
              color: PhoenixTheme.red,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '你完成的不是一堂课，而是一段旅程。',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(fontSize: 12, height: 1.25),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 34,
            child: OutlinedButton.icon(
              onPressed: () => unawaited(_restartJourney()),
              style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text('重新体验北京 Journey', style: TextStyle(fontSize: 10.5)),
            ),
          ),
        ],
      ),
    );
  }
'''
source = replace_once(
    source,
    r'  Widget _completePage\(\) \{.*?\n  \}\n(?=\})',
    complete_method,
    '_completePage',
)

journey_path.write_text(source)

explore_path = Path('app/lib/screens/explore_screen.dart')
explore = explore_path.read_text()
explore = explore.replace(
    "        ListView(\n          padding: const EdgeInsets.fromLTRB(14, 10, 14, 60),\n          children: [",
    "        Padding(\n          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),\n          child: Column(\n            children: [",
    1,
)
explore = explore.replace(
    "            const _DiscoveryCard(),\n          ],\n        ),",
    "              const _DiscoveryCard(),\n            ],\n          ),\n        ),",
    1,
)
explore_path.write_text(explore)

worker_test = Path('worker/one_screen_layout.test.mjs')
worker_test.write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');

test('primary Phoenix screens obey the one-screen layout rule', () => {
  const explore = read('app/lib/screens/explore_screen.dart');
  const passport = read('app/lib/screens/passport_screen.dart');
  const me = read('app/lib/screens/me_screen.dart');
  const journey = read('app/lib/screens/journey_screen.dart');

  assert.doesNotMatch(explore, /ListView\(\s*padding: const EdgeInsets\.fromLTRB\(14, 10, 14, 60\)/);
  assert.doesNotMatch(passport, /return ListView\(/);
  assert.doesNotMatch(me, /return ListView\(/);
  assert.match(journey, /Expanded\(child: child\)/);
  assert.match(journey, /CompactPager\(/);
  assert.doesNotMatch(journey, /return ListView\(\s*key: ValueKey\(title\)/);
});

test('one-screen rule is documented for future development', () => {
  const policy = read('docs/one-screen-interface-rule.md');
  assert.match(policy, /one phone viewport/i);
  assert.match(policy, /horizontal paging, tabs, grouped cards, or modal sheets/i);
  assert.match(policy, /Do not add a top-level vertically scrolling feature stack/i);
});
''')
