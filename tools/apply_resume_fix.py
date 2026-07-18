from pathlib import Path
import re


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if new in text:
        return text
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"{label}: expected one match, got {count}")
    return text.replace(old, new, 1)


def sub_once(text: str, pattern: str, replacement: str, label: str) -> str:
    updated, count = re.subn(pattern, replacement, text, count=1, flags=re.S)
    if count != 1:
        raise RuntimeError(f"{label}: expected one match, got {count}")
    return updated


controller_path = Path("app/lib/services/narration_controller.dart")
controller = controller_path.read_text()
controller = replace_once(
    controller,
    "  DateTime? _lastNativeProgressAt;\n",
    "  DateTime? _lastNativeProgressAt;\n  int _lastNativeOffset = 0;\n",
    "native offset field",
)
controller = replace_once(
    controller,
    "  int get currentOffset => _currentOffset;\n  int get totalCharacters => _plan.text.length;\n",
    """  int get currentOffset => _currentOffset;
  int get lastNativeOffset => _lastNativeOffset;
  bool get hasFreshNativeProgress {
    final last = _lastNativeProgressAt;
    return last != null &&
        DateTime.now().difference(last).inMilliseconds < 1200;
  }
  int get totalCharacters => _plan.text.length;
""",
    "native offset getters",
)
controller = replace_once(
    controller,
    "      _lastNativeProgressAt = DateTime.now();\n      _estimateAnchorTime = _lastNativeProgressAt;\n",
    "      _lastNativeOffset = globalStart;\n      _lastNativeProgressAt = DateTime.now();\n      _estimateAnchorTime = _lastNativeProgressAt;\n",
    "native progress capture",
)
controller = replace_once(
    controller,
    "    _currentOffset = 0;\n    _currentItemIndex = 0;\n",
    "    _currentOffset = 0;\n    _lastNativeOffset = 0;\n    _lastNativeProgressAt = null;\n    _currentItemIndex = 0;\n",
    "play reset",
)
if "Future<void> pauseAtOffset" not in controller:
    controller = sub_once(
        controller,
        r"  Future<void> pause\(\) async \{.*?\n  \}\n\n(?=  Future<void> resume\(\))",
        """  Future<void> pause() async {
    await pauseAtOffset(_currentOffset);
  }

  Future<void> pauseAtOffset(int offset) async {
    if (_plan.isEmpty || _disposed) return;

    final maxOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _cancelProgressClock();
    _applyProgress(safeOffset);

    await _stopSpeechEngine();
    if (_disposed) return;

    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _applyProgress(safeOffset);
  }

""",
        "pauseAtOffset",
    )
controller = replace_once(
    controller,
    "      _speechMode = _NarrationSpeechMode.narration;\n      _speechBaseOffset = safeOffset;\n",
    "      _speechMode = _NarrationSpeechMode.narration;\n      _lastNativeOffset = safeOffset;\n      _lastNativeProgressAt = null;\n      _speechBaseOffset = safeOffset;\n",
    "speak reset",
)
controller_path.write_text(controller)

player_path = Path("app/lib/widgets/narration_player_card.dart")
player = player_path.read_text()
if "required bool nativeProgressIsFresh" not in player:
    player = sub_once(
        player,
        r"int resolveNarrationPauseOffset\(\{.*?\n\}\n\n(?=class NarrationPlayerCard)",
        """int resolveNarrationPauseOffset({
  required int nativeOffset,
  required bool nativeProgressIsFresh,
  required int estimatedOffset,
  required int totalCharacters,
}) {
  if (totalCharacters <= 0) return 0;
  final maxOffset = math.max(0, totalCharacters - 1);
  if (nativeProgressIsFresh) {
    return nativeOffset.clamp(0, maxOffset).toInt();
  }

  // Safari often keeps returning zero even while speech is audible. In that
  // case use Phoenix's running clock and repeat one character for safety.
  final estimated = estimatedOffset.clamp(0, maxOffset).toInt();
  return math.max(0, estimated - 1);
}

""",
        "pause resolver",
    )
player = sub_once(
    player,
    r"\? resolveNarrationPauseOffset\(\s*controllerOffset: widget\.controller\.currentOffset,\s*estimatedOffset: estimatedOffset,\s*totalCharacters: widget\.controller\.totalCharacters,\s*\)",
    """? resolveNarrationPauseOffset(
            nativeOffset: widget.controller.lastNativeOffset,
            nativeProgressIsFresh: widget.controller.hasFreshNativeProgress,
            estimatedOffset: estimatedOffset,
            totalCharacters: widget.controller.totalCharacters,
          )""",
    "pause resolver call",
) if "nativeOffset: widget.controller.lastNativeOffset" not in player else player
player = player.replace(
    "    await widget.controller.stop(resetPosition: false);\n",
    "    await widget.controller.pauseAtOffset(offset);\n",
    1,
)
player_path.write_text(player)

journey_path = Path("app/lib/screens/journey_screen.dart")
journey = journey_path.read_text()
story_section = r'''  Widget _storyPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '故事',
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: AnimatedBuilder(
              animation: _narration,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _journeyContent.storyParagraphs
                        .asMap()
                        .entries
                        .map((entry) {
                          final annotation = storyAnnotations[entry.key];
                          final isActive = _isNarrating('story', entry.key);
                          return _CompactTextBlock(
                            index: entry.key + 1,
                            active: isActive,
                            onSupport: () => unawaited(
                              _showReadingSupport(
                                title: '故事第 ${entry.key + 1} 段',
                                pinyin: annotation.pinyin,
                                nativeLabel: annotation.nativeLabel(language),
                                nativeText: annotation.nativeText(
                                  language,
                                  entry.value,
                                ),
                                english: annotation.english,
                              ),
                            ),
                            child: InteractiveStoryText(
                              text: entry.value,
                              entries: words,
                              narrationContentId: 'story',
                              narrationItemId: 'story-${entry.key}',
                              style: const TextStyle(
                                fontSize: 10.8,
                                height: 1.18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
'''
journey = sub_once(
    journey,
    r"  Widget _storyPage\(\) \{.*?\n  \}\n\n(?=  Widget _wordsPage\(\))",
    story_section + "\n",
    "story section",
)
compact_block = r'''class _CompactTextBlock extends StatelessWidget {
  const _CompactTextBlock({
    required this.index,
    required this.active,
    required this.child,
    required this.onSupport,
  });

  final int index;
  final bool active;
  final Widget child;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: BoxDecoration(
        color: active
            ? PhoenixTheme.gold.withValues(alpha: .18)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? PhoenixTheme.gold
              : PhoenixTheme.gold.withValues(alpha: .22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: CircleAvatar(
              radius: 9,
              backgroundColor: active
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .18),
              child: active
                  ? const Icon(
                      Icons.graphic_eq_rounded,
                      size: 10,
                      color: Colors.white,
                    )
                  : Text(
                      '$index',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(child: child),
          SizedBox(
            width: 23,
            height: 23,
            child: TextButton(
              onPressed: onSupport,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(23, 23),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text(
                '注',
                style: TextStyle(
                  color: PhoenixTheme.red,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
'''
journey = sub_once(
    journey,
    r"class _CompactTextBlock extends StatelessWidget \{.*?\n\}\n\n(?=class _ReadingSupportSheet)",
    compact_block + "\n",
    "compact text block",
)
journey_path.write_text(journey)

Path("app/test/narration_resume_offset_test.dart").write_text(
    r'''import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/narration_player_card.dart';

void main() {
  test('uses exact native word start when progress is fresh', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 17,
        nativeProgressIsFresh: true,
        estimatedOffset: 24,
        totalCharacters: 100,
      ),
      17,
    );
  });

  test('Safari zero progress does not restart narration', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 0,
        nativeProgressIsFresh: false,
        estimatedOffset: 24,
        totalCharacters: 100,
      ),
      23,
    );
  });

  test('stale progress falls back to Phoenix clock', () {
    expect(
      resolveNarrationPauseOffset(
        nativeOffset: 5,
        nativeProgressIsFresh: false,
        estimatedOffset: 31,
        totalCharacters: 100,
      ),
      30,
    );
  });
}
'''
)
