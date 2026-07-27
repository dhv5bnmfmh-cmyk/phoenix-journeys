import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

test('story cards expose the destination image and vocabulary stays legible', () => {
  const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
  const story = readFileSync(
    'app/lib/widgets/interactive_story_text.dart',
    'utf8',
  );
  const player = readFileSync(
    'app/lib/widgets/narration_player_card.dart',
    'utf8',
  );

  assert.match(journey, /color: Colors\.transparent/);
  assert.match(journey, /color: Colors\.white/);
  assert.match(story, /color: const Color\(0xFFFFD879\)/);
  assert.match(story, /Shadow\(/);
  assert.match(player, /PhoenixTheme\.journeyPanelDecoration/);
  assert.match(journey, /fontFamily: PhoenixTheme\.chineseFontFamily/);
  assert.ok(
    (journey.match(/PhoenixTheme\.journeyPanelDecoration/g) ?? []).length >= 2,
  );
});

test('vocabulary detail has a distinct readable destination surface', () => {
  const detail = readFileSync(
    'app/lib/widgets/word_detail_sheet.dart',
    'utf8',
  );

  assert.match(detail, /barrierColor: Colors\.black\.withValues\(alpha: \.42\)/);
  assert.match(detail, /PhoenixTheme\.journeySolidPanelDecoration/);
});
