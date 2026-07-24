import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const workflow = readFileSync('docs/development-workflow.md', 'utf8');

test('Summer Palace uses a subtle offline living background', () => {
  assert.match(background, /journeyId == 'beijing-summer-palace'/);
  assert.match(background, /summer-palace-living-background/);
  assert.match(background, /Duration\(seconds: 18\)/);
  assert.match(background, /Image\.asset\(\s*widget\.asset\.assetPath/);
});

test('living backgrounds respect reduced-motion accessibility', () => {
  assert.match(background, /disableAnimations/);
  assert.match(background, /_controller\s*\.\.stop\(\)\s*\.\.value = 0/);
  assert.match(workflow, /减少动态效果/);
});

test('preview links can open the Summer Palace living background directly', () => {
  assert.match(state, /queryParameters\['unlock'\] != 'all'/);
  assert.match(state, /queryParameters\['journey'\]/);
  assert.match(state, /_requestedPreviewJourneyId\(\) \?\?/);
});
