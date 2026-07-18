from pathlib import Path
import re


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if new in text:
        return text
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, got {count}')
    return text.replace(old, new, 1)


# NarrationController owns the current highlight snapshot so UI components can
# listen to the same controller that drives audio and progress.
controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
controller = replace_once(
    controller,
    '  String? _configuredVoiceLanguage;\n',
    '  String? _configuredVoiceLanguage;\n  NarrationHighlightSnapshot? _highlightSnapshot;\n',
    'controller snapshot field',
)
controller = replace_once(
    controller,
    '  String? get spokenWord => _spokenWord;\n',
    '  String? get spokenWord => _spokenWord;\n  NarrationHighlightSnapshot? get highlightSnapshot => _highlightSnapshot;\n',
    'controller snapshot getter',
)
controller = controller.replace(
    '    NarrationHighlightBus.instance.clear(contentId: _contentId);',
    '    _highlightSnapshot = null;\n    NarrationHighlightBus.instance.clear(contentId: _contentId);',
)
old_update = '''      NarrationHighlightBus.instance.update(
        NarrationHighlightSnapshot(
          contentId: _contentId!,
          itemId: item.id,
          itemText: item.text,
          itemIndex: itemIndex,
          start: localStart,
          end: localEnd,
          word: word,
        ),
      );
'''
new_update = '''      final snapshot = NarrationHighlightSnapshot(
        contentId: _contentId!,
        itemId: item.id,
        itemText: item.text,
        itemIndex: itemIndex,
        start: localStart,
        end: localEnd,
        word: word,
      );
      _highlightSnapshot = snapshot;
      NarrationHighlightBus.instance.update(snapshot);
'''
controller = replace_once(controller, old_update, new_update, 'controller snapshot update')
controller_path.write_text(controller)


# InteractiveStoryText listens directly to NarrationController when supplied.
interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
interactive = replace_once(
    interactive,
    '    this.narrationContentId,\n    this.narrationItemId,\n',
    '    this.narrationContentId,\n    this.narrationItemId,\n    this.narrationController,\n',
    'interactive controller constructor',
)
interactive = replace_once(
    interactive,
    '  final String? narrationContentId;\n  final String? narrationItemId;\n',
    '  final String? narrationContentId;\n  final String? narrationItemId;\n  final NarrationController? narrationController;\n',
    'interactive controller field',
)
interactive = replace_once(
    interactive,
    '    final selectedEntry = _selectedEntry;\n\n    return Column(',
    '''    final selectedEntry = _selectedEntry;
    final Listenable highlightSource =
        widget.narrationController ?? NarrationHighlightBus.instance;

    return Column(''',
    'interactive highlight source',
)
interactive = replace_once(
    interactive,
    '          animation: NarrationHighlightBus.instance,\n          builder: (context, _) {\n            final snapshot = NarrationHighlightBus.instance.snapshot;\n',
    '''          animation: highlightSource,
          builder: (context, _) {
            final snapshot = widget.narrationController?.highlightSnapshot ??
                NarrationHighlightBus.instance.snapshot;
''',
    'interactive direct snapshot',
)
interactive_path.write_text(interactive)


# Story and Discovery explicitly bind their text to the active controller.
journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
journey = replace_once(
    journey,
    "                              narrationContentId: 'story',\n",
    "                              narrationController: _narration,\n                              narrationContentId: 'story',\n",
    'story direct controller binding',
)
journey = replace_once(
    journey,
    "                              narrationContentId: 'discovery',\n",
    "                              narrationController: _narration,\n                              narrationContentId: 'discovery',\n",
    'discovery direct controller binding',
)
journey_path.write_text(journey)


# Cap the vocabulary sheet at 48% of the viewport and scale all content into it.
sheet_path = Path('app/lib/widgets/word_detail_sheet.dart')
sheet = sheet_path.read_text()
old_builder = '''    builder: (_) => _WordDetailSheet(
      entries: studyEntries,
      initialIndex: safeIndex,
      onSpeak: onSpeak,
      onSpeakEntry: onSpeakEntry,
    ),
'''
new_builder = '''    builder: (sheetContext) {
      final size = MediaQuery.sizeOf(sheetContext);
      final sheetWidth = (size.width - 20).clamp(0.0, 560.0).toDouble();
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * .48),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: sheetWidth,
            child: _WordDetailSheet(
              entries: studyEntries,
              initialIndex: safeIndex,
              onSpeak: onSpeak,
              onSpeakEntry: onSpeakEntry,
            ),
          ),
        ),
      );
    },
'''
sheet = replace_once(sheet, old_builder, new_builder, 'half-height sheet builder')
replacements = [
    ('        14,\n        0,\n        14,', '        10,\n        0,\n        10,', 'sheet horizontal padding'),
    ('WordMark(word: entry.word, size: compact ? 34 : 38)', 'WordMark(word: entry.word, size: compact ? 28 : 31)', 'word mark size'),
    ('fontSize: compact ? 18.5 : 20,', 'fontSize: compact ? 16 : 17.5,', 'word heading size'),
    ('fontSize: 13,\n                            fontWeight: FontWeight.w800,', 'fontSize: 10.5,\n                            fontWeight: FontWeight.w800,', 'pinyin size'),
    ('iconSize: 19,', 'iconSize: 16,', 'word audio icon'),
    ('minimumSize: const Size.fromHeight(36),', 'minimumSize: const Size.fromHeight(32),', 'save button height'),
    ('minimumSize: const Size.fromHeight(40),', 'minimumSize: const Size.fromHeight(32),', 'next button height'),
    ('padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),', 'padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),', 'definition padding'),
    ('width: 54,', 'width: 44,', 'definition label width'),
]
for old, new, label in replacements:
    sheet = replace_once(sheet, old, new, label)
sheet_path.write_text(sheet)


Path('worker/direct_narration_binding.test.mjs').write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');

test('story text listens directly to the same narration controller as audio', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot/);
  assert.match(controller, /_highlightSnapshot = snapshot/);
  assert.match(interactive, /final NarrationController\? narrationController/);
  assert.match(interactive, /widget\.narrationController\?\.highlightSnapshot/);
});

test('Story and Discovery both pass the active controller to highlighted text', () => {
  const bindings = journey.match(/narrationController: _narration/g) ?? [];
  assert.equal(bindings.length, 2);
  assert.match(journey, /narrationContentId: 'story'/);
  assert.match(journey, /narrationContentId: 'discovery'/);
});

test('vocabulary detail stays content-sized and below half a phone viewport', () => {
  assert.match(sheet, /maxHeight: size\.height \* \.48/);
  assert.match(sheet, /FittedBox\(/);
  assert.match(sheet, /fit: BoxFit\.scaleDown/);
});
''')
