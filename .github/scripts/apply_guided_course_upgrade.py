from pathlib import Path
import re


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise SystemExit(f"{label} target not found")
    return text.replace(old, new, 1)


# 1) Journey layout, adaptive vocabulary cards, and sequential navigation.
journey_path = Path("app/lib/screens/journey_screen.dart")
journey = journey_path.read_text(encoding="utf-8")

if "narrationController: _narration," not in journey[journey.index("Future<void> _openWord"):journey.index("Future<void> _prepareAgentAction")]:
    journey = replace_once(
        journey,
        """      entry,
      entries: _experience.words,""",
        """      entry,
      narrationController: _narration,
      entries: _experience.words,""",
        "word detail narration controller",
    )

if "safeStep != step - 1" not in journey:
    journey = replace_once(
        journey,
        """  Future<void> _goToStep(int targetStep) async {
    final safeStep = targetStep.clamp(0, AppState.journeyLastStep);
    await _narration.stop();""",
        """  Future<void> _goToStep(int targetStep) async {
    final safeStep = targetStep.clamp(0, AppState.journeyLastStep);
    if (!_appState.journeyCompleted &&
        safeStep != step &&
        safeStep != step - 1 &&
        safeStep != step + 1) {
      return;
    }
    await _narration.stop();""",
        "sequential step guard",
    )

if "isCompleted: state.journeyCompleted," not in journey:
    journey = replace_once(
        journey,
        """                  currentStep: step,
                  furthestStep: state.beijingJourneyFurthestStep,
                  labels: AppState.journeyStepLabels,""",
        """                  currentStep: step,
                  furthestStep: state.beijingJourneyFurthestStep,
                  isCompleted: state.journeyCompleted,
                  labels: AppState.journeyStepLabels,""",
        "progress completion state",
    )

journey = journey.replace(
    "    final availableHeight = constraints.maxHeight;",
    "    final availableHeight = math.max(0.0, constraints.maxHeight - 8);",
    1,
)
journey = journey.replace(
    "        totalHeight += math.max(18, painter.height) + 6;",
    "        totalHeight += math.max(18, painter.height) + 12;",
    1,
)

story_start = journey.index("  Widget _storyPage()")
story_end = journey.index("  Widget _wordsPage()", story_start)
story = journey[story_start:story_end]
if "story-auto-visibility-scroll" not in story:
    story = replace_once(
        story,
        """                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:""",
        """                    return SingleChildScrollView(
                      key: const ValueKey('story-auto-visibility-scroll'),
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:""",
        "story scroll fallback start",
    )
    story = replace_once(
        story,
        """                          .toList(growable: false),
                    );""",
        """                          .toList(growable: false),
                      ),
                    );""",
        "story scroll fallback end",
    )
    journey = journey[:story_start] + story + journey[story_end:]

words_start = journey.index("  Widget _wordsPage()")
words_end = journey.index("  Widget _discoveryPage()", words_start)
words = journey[words_start:words_end]

if "final language = state.translationLanguage;" not in words:
    words = replace_once(
        words,
        """  Widget _wordsPage() {
    final state = context.watch<AppState>();""",
        """  Widget _wordsPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;""",
        "word page language",
    )

old_thresholds = """          final showPartOfSpeech =
              cellHeight >= 108 && _experience.words.length <= 12;
          final showMeaning =
              cellHeight >= 145 && _experience.words.length <= 9;"""
new_thresholds = """          final showPartOfSpeech = cellHeight >= 52;
          final showNativeMeaning = cellHeight >= 72;
          final showEnglishMeaning = cellHeight >= 96 && language != '英语';
          final showChineseMeaning =
              cellHeight >= 122 && language != '中文解释';
          final nativeLabel = switch (language) {
            '英语' => 'English',
            '中文解释' => '中文',
            _ => '母语',
          };"""
if "showNativeMeaning" not in words:
    words = replace_once(words, old_thresholds, new_thresholds, "adaptive word thresholds")

old_meaning = """                        if (showMeaning) ...[
                          const SizedBox(height: 4),
                          Text(
                            state.displayText(entry.simpleChinese),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 9.5,
                              height: 1.2,
                            ),
                          ),
                        ],"""
new_meaning = """                        if (showNativeMeaning) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$nativeLabel · ${state.displayText(entry.nativeDefinition(language))}',
                            maxLines: cellHeight >= 112 ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: PhoenixTheme.translation,
                              fontSize: 8.6,
                              height: 1.15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        if (showEnglishMeaning) ...[
                          const SizedBox(height: 3),
                          Text(
                            'EN · ${entry.englishDefinition}',
                            maxLines: cellHeight >= 126 ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: PhoenixTheme.ai,
                              fontSize: 8.4,
                              height: 1.15,
                            ),
                          ),
                        ],
                        if (showChineseMeaning) ...[
                          const SizedBox(height: 3),
                          Text(
                            state.displayText('中 · ${entry.simpleChinese}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 8.4,
                              height: 1.15,
                            ),
                          ),
                        ],"""
if "showEnglishMeaning" in words and "EN · ${entry.englishDefinition}" not in words:
    words = replace_once(words, old_meaning, new_meaning, "adaptive word meanings")
elif "showNativeMeaning" not in words:
    raise SystemExit("adaptive word meaning patch failed")

journey = journey[:words_start] + words + journey[words_end:]
journey_path.write_text(journey, encoding="utf-8")

# 2) Inline vocabulary automatically scrolls into view after expanding.
interactive_path = Path("app/lib/widgets/interactive_story_text.dart")
interactive = interactive_path.read_text(encoding="utf-8")
if "word-popover-auto-visible" not in interactive:
    interactive = replace_once(
        interactive,
        """  void _showEntry(WordEntry entry) {
    _hideTimer?.cancel();
    setState(() => _selectedEntry = entry);
    _hideTimer = Timer(const Duration(milliseconds: 3200), () {""",
        """  void _showEntry(WordEntry entry) {
    _hideTimer?.cancel();
    setState(() => _selectedEntry = entry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Scrollable.ensureVisible(
        context,
        alignment: .18,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    });
    _hideTimer = Timer(const Duration(milliseconds: 3200), () {""",
        "inline word auto visibility",
    )
    interactive = interactive.replace(
        "key: ValueKey('word-popover-${selectedEntry.word}'),",
        "key: ValueKey('word-popover-auto-visible-${selectedEntry.word}'),",
        1,
    )
interactive_path.write_text(interactive, encoding="utf-8")

# 3) Guided progress: no arbitrary step jumping before completion.
progress_path = Path("app/lib/widgets/journey_progress_header.dart")
progress = progress_path.read_text(encoding="utf-8")
if "required this.isCompleted," not in progress:
    progress = replace_once(
        progress,
        """    required this.furthestStep,
    required this.labels,""",
        """    required this.furthestStep,
    required this.isCompleted,
    required this.labels,""",
        "progress constructor",
    )
if "final bool isCompleted;" not in progress:
    progress = replace_once(
        progress,
        """  final int furthestStep;
  final List<String> labels;""",
        """  final int furthestStep;
  final bool isCompleted;
  final List<String> labels;""",
        "progress field",
    )
progress = re.sub(
    r"\n  bool get _allAccessPreview \{[\s\S]*?\n  \}\n",
    "\n",
    progress,
    count=1,
)
progress = replace_once(
    progress,
    "        onTap: () => _showSteps(context),",
    """        onTap: isCompleted
            ? () => _showSteps(context)
            : () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('请按顺序完成课程；全部完成后可自由选择页面。'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },""",
    "progress tap gate",
)
progress = replace_once(
    progress,
    """                    currentStep == labels.length - 1
                        ? '旅程完成'
                        : '下一步 $nextLabel',""",
    """                    isCompleted
                        ? '课程已完成 · 可自由选择'
                        : currentStep == labels.length - 1
                            ? '完成最后一步'
                            : '下一步 $nextLabel',""",
    "progress trailing label",
)
progress = replace_once(
    progress,
    """                  const Icon(
                    Icons.expand_more,
                    size: 17,
                    color: Colors.black38,
                  ),""",
    """                  Icon(
                    isCompleted ? Icons.expand_more : Icons.lock_outline,
                    size: 17,
                    color: Colors.black38,
                  ),""",
    "progress lock icon",
)
progress = progress.replace(
    "    final allAccess = _allAccessPreview;\n",
    "",
    1,
)
progress = replace_once(
    progress,
    "                allAccess ? '选择学习步骤 · 体验全开放' : '选择学习步骤',",
    "                isCompleted ? '选择学习步骤 · 课程已完成' : '请按顺序完成课程',",
    "progress sheet title",
)
progress = replace_once(
    progress,
    "                final enabled = allAccess || index <= furthestStep;",
    "                final enabled = isCompleted;",
    "progress step gate",
)
progress_path.write_text(progress, encoding="utf-8")

# 4) Natural local speed at 1.0x, adjustable from 0.5x to 2.0x.
narration_path = Path("app/lib/services/narration_controller.dart")
narration = narration_path.read_text(encoding="utf-8")
narration = re.sub(
    r"  static const speedOptions = <NarrationSpeedOption>\[[\s\S]*?\n  \];",
    """  static const speedOptions = <NarrationSpeedOption>[
    NarrationSpeedOption(label: '0.5×', rate: .5),
    NarrationSpeedOption(label: '0.75×', rate: .75),
    NarrationSpeedOption(label: '1.0×', rate: 1.0),
    NarrationSpeedOption(label: '1.25×', rate: 1.25),
    NarrationSpeedOption(label: '1.5×', rate: 1.5),
    NarrationSpeedOption(label: '1.75×', rate: 1.75),
    NarrationSpeedOption(label: '2.0×', rate: 2.0),
  ];""",
    narration,
    count=1,
)
narration = re.sub(
    r"  double _ttsSpeechRate\(double multiplier\) \{[\s\S]*?\n  \}",
    """  double _ttsSpeechRate(double multiplier) {
    if (kIsWeb) return multiplier.clamp(0.5, 2.0).toDouble();
    return (0.50 + (multiplier - 1.0) * 0.20)
        .clamp(0.40, 0.70)
        .toDouble();
  }""",
    narration,
    count=1,
)
for required in ["label: '0.5×'", "label: '2.0×'", "double _speechRate = 1.0;"]:
    if required not in narration:
        raise SystemExit(f"narration speed upgrade missing: {required}")
if "label: '2.5×'" in narration or "label: '3.0×'" in narration:
    raise SystemExit("old over-fast speed option remains")
narration_path.write_text(narration, encoding="utf-8")

# 5) Add real parts of speech for all non-Beijing daily journey words.
pos_map = {
    "外滩": "名词（专名）", "滨水": "形容词", "黄浦江": "名词（专名）", "轮廓": "名词",
    "见证": "动词", "金融": "名词", "贸易": "名词", "天际线": "名词",
    "隔江相望": "动词短语", "灯火": "名词", "时代": "名词", "走向": "动词",
    "城墙": "名词", "永宁门": "名词（专名）", "砖石": "名词", "角楼": "名词",
    "护城河": "名词", "防御": "动词", "现存": "形容词", "规模": "名词",
    "修缮": "动词", "巡查": "动词", "古都": "名词", "边界": "名词",
    "苏堤": "名词（专名）", "倒映": "动词", "堤岸": "名词", "疏浚": "动词",
    "亭台": "名词", "融合": "动词", "景点": "名词", "山水": "名词", "彼此": "代词",
    "巷子": "名词", "青砖": "名词", "院落": "名词", "平行": "形容词",
    "茶馆": "名词", "盖碗茶": "名词", "保留": "动词", "慢生活": "名词", "商业": "名词",
    "秦淮河": "名词（专名）", "夫子庙": "名词（专名）", "牌坊": "名词", "贡院": "名词",
    "交织": "动词", "灯会": "名词", "曲艺": "名词", "游船": "名词", "静止": "形容词",
    "陈家祠": "名词（专名）", "屋脊": "名词", "木雕": "名词", "砖雕": "名词",
    "陶塑": "名词", "灰塑": "名词", "工匠": "名词", "宗族": "名词", "岭南": "名词（专名）",
}


def add_parts_of_speech(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    for word, pos in pos_map.items():
        if f"word: '{word}'" not in text:
            continue
        pattern = rf"(WordEntry\(word: '{re.escape(word)}', pinyin: '[^']+', )(?!partOfSpeech:)"
        text, count = re.subn(
            pattern,
            rf"\1partOfSpeech: '{pos}', ",
            text,
            count=1,
        )
        if count == 0 and f"word: '{word}'" in text:
            block_start = text.index(f"word: '{word}'")
            block = text[block_start:block_start + 180]
            if "partOfSpeech:" not in block:
                raise SystemExit(f"part of speech not inserted for {word}")
    path.write_text(text, encoding="utf-8")


add_parts_of_speech(Path("app/lib/data/daily_journey_catalog.dart"))
add_parts_of_speech(Path("app/lib/data/extended_journey_catalog.dart"))

# 6) Update regression tests.
narration_test_path = Path("app/test/narration_text_plan_test.dart")
narration_test = narration_test_path.read_text(encoding="utf-8")
narration_test = re.sub(
    r"  test\('offers unified player speed presets from 1x to 3x', \(\) \{[\s\S]*?\n  \}\);",
    """  test('offers natural player speed presets from 0.5x to 2x', () {
    const options = NarrationController.speedOptions;

    expect(options.map((option) => option.label), [
      '0.5×',
      '0.75×',
      '1.0×',
      '1.25×',
      '1.5×',
      '1.75×',
      '2.0×',
    ]);
    expect(options.first.rate, .5);
    expect(options[2].rate, 1.0);
    expect(options.last.rate, 2.0);
  });""",
    narration_test,
    count=1,
)
narration_test_path.write_text(narration_test, encoding="utf-8")

adaptive_test = """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const progress = readFileSync('app/lib/widgets/journey_progress_header.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const daily = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const extended = readFileSync('app/lib/data/extended_journey_catalog.dart', 'utf8');

test('story vocabulary automatically remains visible above the bottom controls', () => {
  const start = journey.indexOf('Widget _storyPage()');
  const end = journey.indexOf('Widget _wordsPage()', start);
  const story = journey.slice(start, end);
  assert.match(story, /story-auto-visibility-scroll/);
  assert.match(interactive, /Scrollable\\.ensureVisible/);
  assert.match(interactive, /word-popover-auto-visible/);
});

test('word cards prioritize part of speech, explorer language, English, then Chinese', () => {
  assert.match(journey, /showPartOfSpeech/);
  assert.match(journey, /showNativeMeaning/);
  assert.match(journey, /showEnglishMeaning/);
  assert.match(journey, /showChineseMeaning/);
  assert.match(journey, /entry\\.partOfSpeech/);
  assert.match(journey, /entry\\.nativeDefinition\\(language\\)/);
  assert.match(journey, /entry\\.englishDefinition/);
  for (const source of [daily, extended]) {
    assert.doesNotMatch(source, /WordEntry\\(word: '[^']+', pinyin: '[^']+', simpleChinese:/);
  }
});

test('all Phoenix speech uses a natural 0.5x to 2x scale with 1x default', () => {
  for (const label of ['0.5×', '0.75×', '1.0×', '1.25×', '1.5×', '1.75×', '2.0×']) {
    assert.ok(narration.includes(label));
  }
  assert.doesNotMatch(narration, /label: '2\\.5×'/);
  assert.doesNotMatch(narration, /label: '3\\.0×'/);
  assert.match(narration, /double _speechRate = 1\\.0/);
  assert.match(narration, /clamp\\(0\\.5, 2\\.0\\)/);
  assert.match(sheet, /word-detail-speed-control/);
});

test('step picker stays locked until the whole journey is completed', () => {
  assert.match(journey, /isCompleted: state\\.journeyCompleted/);
  assert.match(journey, /safeStep != step - 1/);
  assert.match(progress, /required this\\.isCompleted/);
  assert.match(progress, /final enabled = isCompleted/);
  assert.doesNotMatch(progress, /_allAccessPreview/);
  assert.match(progress, /全部完成后可自由选择页面/);
});
"""
Path("worker/adaptive_word_audio_upgrade.test.mjs").write_text(
    adaptive_test,
    encoding="utf-8",
)
