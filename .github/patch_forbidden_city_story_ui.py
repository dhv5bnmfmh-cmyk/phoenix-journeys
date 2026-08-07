from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text()

if 'int _storySegmentIndex = 0;' not in text:
    text = text.replace('  int step = 0;\n', '  int step = 0;\n  int _storySegmentIndex = 0;\n', 1)

marker = "  String _readingShapeLabel(int count) =>\n      count == 1 ? '深度长文' : '分段短文';\n"
helpers = marker + "\n  int get _safeStorySegmentIndex {\n    final count = _levelContent.storyParagraphs.length;\n    if (count <= 0) return 0;\n    return _storySegmentIndex.clamp(0, count - 1).toInt();\n  }\n\n  List<NarrationItem> get _storyPlaybackItems {\n    if (!_isForbiddenCity) return _storyNarrationItems;\n    final paragraphs = _levelContent.storyParagraphs;\n    if (paragraphs.isEmpty) return const <NarrationItem>[];\n    final index = _safeStorySegmentIndex;\n    return <NarrationItem>[\n      NarrationItem(\n        id: 'story-$index',\n        text: paragraphs[index],\n        label: '故事第 ${index + 1} 段',\n      ),\n    ];\n  }\n\n  Future<void> _advanceStoryOrEnterVocabulary() async {\n    if (!_isForbiddenCity) {\n      await _enterVocabularyAtFirstWord();\n      return;\n    }\n    final count = _levelContent.storyParagraphs.length;\n    if (count <= 0 || _safeStorySegmentIndex >= count - 1) {\n      await _enterVocabularyAtFirstWord();\n      return;\n    }\n    await _narration.stop();\n    await _appState.clearJourneyNarrationPosition(contentId: 'story');\n    if (!mounted) return;\n    setState(() => _storySegmentIndex = _safeStorySegmentIndex + 1);\n  }\n"
if 'List<NarrationItem> get _storyPlaybackItems' not in text:
    if marker not in text:
        raise SystemExit('reading label marker not found')
    text = text.replace(marker, helpers, 1)

text = text.replace("final items = contentId == 'story'\n          ? _storyNarrationItems\n          : _discoveryNarrationItems;", "final items = contentId == 'story'\n          ? _storyPlaybackItems\n          : _discoveryNarrationItems;")
text = text.replace("final items = contentId == 'story'\n        ? _storyNarrationItems\n        : _discoveryNarrationItems;", "final items = contentId == 'story'\n        ? _storyPlaybackItems\n        : _discoveryNarrationItems;")
text = text.replace("      items: _storyNarrationItems,\n", "      items: _storyPlaybackItems,\n", 1)

set_state_anchor = "      _challengeSeed += 1;\n"
if '      _storySegmentIndex = 0;\n' not in text:
    if set_state_anchor not in text:
        raise SystemExit('level change anchor not found')
    text = text.replace(set_state_anchor, "      _challengeSeed += 1;\n      _storySegmentIndex = 0;\n", 1)

start = text.index('  Widget _storyPage() {')
end = text.index('  Widget _wordsPage() {', start)
old_story = text[start:end]
if 'Widget _defaultStoryPage()' not in text:
    default_story = old_story.replace('  Widget _storyPage() {', '  Widget _defaultStoryPage() {', 1)
    forbidden_story = r'''  Widget _storyPage() {
    if (_isForbiddenCity) return _forbiddenCityStoryPage();
    return _defaultStoryPage();
  }

  Widget _forbiddenCityStoryPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;
    final paragraphs = _levelContent.storyParagraphs;
    if (paragraphs.isEmpty) return _defaultStoryPage();

    final index = _safeStorySegmentIndex;
    final paragraph = paragraphs[index];
    final annotation = _levelContent.storyAnnotations[index];
    final count = paragraphs.length;
    final isFinalSegment = index >= count - 1;

    return _page(
      title: '故事',
      buttonText: isFinalSegment ? '进入单词' : '下一段',
      onNext: () => unawaited(_advanceStoryOrEnterVocabulary()),
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: _appState.displayText(_experience.storyTitle),
            subtitle: '$_readingLevelLabel · 故事 ${index + 1} / $count',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: (index + 1) / count,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: .16),
                    color: PhoenixTheme.gold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${index + 1} / $count',
                key: const ValueKey('forbidden-city-story-segment-progress'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: LayoutBuilder(
                key: ValueKey('forbidden-city-story-segment-$index'),
                builder: (context, constraints) {
                  final fontSize = _fitJourneyTextSize(
                    context,
                    constraints,
                    <String>[paragraph],
                    minSize: 14,
                    maxSize: 18,
                    lineHeight: 1.55,
                  );
                  return AnimatedBuilder(
                    animation: _narration,
                    builder: (context, _) {
                      final snapshot = _narration.highlightSnapshot;
                      final isActive =
                          snapshot?.contentId == 'story' &&
                          snapshot?.itemId == 'story-$index';
                      return SingleChildScrollView(
                        key: const ValueKey('forbidden-city-story-segment-scroll'),
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _CompactTextBlock(
                          index: index + 1,
                          active: isActive,
                          transparentSurface: false,
                          onSupport: () => unawaited(
                            _showReadingSupport(
                              title: '故事第 ${index + 1} 段',
                              pinyin: annotation.pinyin,
                              nativeLabel: annotation.nativeLabel(language),
                              nativeText: annotation.nativeText(language, paragraph),
                              english: annotation.english,
                            ),
                          ),
                          child: InteractiveStoryText(
                            text: paragraph,
                            entries: _levelContent.words,
                            narrationController: _narration,
                            highlightStart: isActive ? snapshot!.start : null,
                            highlightEnd: isActive ? snapshot!.end : null,
                            revealEnd: null,
                            narrationContentId: 'story',
                            narrationItemId: 'story-$index',
                            narrationSessionToken: _narration.speechSessionToken,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              height: 1.55,
                              fontFamily: PhoenixTheme.chineseFontFamily,
                              fontFamilyFallback: PhoenixTheme.chineseFontFallback,
                              fontWeight: FontWeight.w700,
                              shadows: const [
                                Shadow(
                                  color: Color(0xE6000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                                Shadow(color: Color(0x99000000), blurRadius: 8),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

'''
    text = text[:start] + forbidden_story + default_story + text[end:]

path.write_text(text)
print('Forbidden City Story UI patch applied')
