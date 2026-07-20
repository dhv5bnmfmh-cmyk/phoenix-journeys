import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

// Regression coverage for the guided course, adaptive word cards, and audio range.
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const speedControl = readFileSync(
  'app/lib/widgets/narration_speed_stepper.dart',
  'utf8',
);
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
  assert.match(interactive, /Scrollable\.ensureVisible/);
  assert.match(interactive, /word-popover-auto-visible/);
});

test('word cards prioritize part of speech, explorer language, English, then Chinese', () => {
  assert.match(journey, /showPartOfSpeech/);
  assert.match(journey, /showNativeMeaning/);
  assert.match(journey, /showEnglishMeaning/);
  assert.match(journey, /showChineseMeaning/);
  assert.match(journey, /entry\.partOfSpeech/);
  assert.match(journey, /entry\.nativeDefinition\(language\)/);
  assert.match(journey, /entry\.englishDefinition/);
  for (const source of [daily, extended]) {
    assert.doesNotMatch(source, /WordEntry\(word: '[^']+', pinyin: '[^']+', simpleChinese:/);
  }
});

test('all Phoenix speech uses a natural 0.5x to 1.5x scale with 1x default', () => {
  for (const label of ['0.5×', '0.75×', '1.0×', '1.25×', '1.5×']) {
    assert.ok(narration.includes(label));
  }
  assert.doesNotMatch(narration, /label: '1\.75×'/);
  assert.doesNotMatch(narration, /label: '2\.0×'/);
  assert.doesNotMatch(narration, /label: '2\.5×'/);
  assert.doesNotMatch(narration, /label: '3\.0×'/);
  assert.match(narration, /static const double nativeDefaultRate = 1\.0/);
  assert.match(narration, /double _speechRate = nativeDefaultRate/);
  assert.match(narration, /clamp\(0\.5, 1\.5\)/);
  assert.match(speedControl, /label: '减速'/);
  assert.match(speedControl, /label: '加速'/);
  assert.match(sheet, /word-detail-speed-control/);
});

test('step picker stays locked until the whole journey is completed', () => {
  assert.match(journey, /isCompleted: state\.journeyCompleted/);
  assert.match(journey, /safeStep != step - 1/);
  assert.match(progress, /required this\.isCompleted/);
  assert.match(progress, /final enabled = isCompleted/);
  assert.doesNotMatch(progress, /_allAccessPreview/);
  assert.match(progress, /全部完成后可自由选择页面/);
});
