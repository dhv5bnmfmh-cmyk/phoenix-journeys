import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const coordinator = readFileSync(
  'app/lib/services/narration_follow_coordinator.dart',
  'utf8',
);
const storyText = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);
const followStatus = readFileSync(
  'app/lib/widgets/narration_follow_status.dart',
  'utf8',
);

test('manual narration follow state is shared per controller', () => {
  assert.match(coordinator, /Expando<NarrationFollowCoordinator>/);
  assert.match(coordinator, /narrationAutoFollowManualHold/);
  assert.match(coordinator, /void suspend/);
  assert.match(coordinator, /void resume/);
  assert.match(coordinator, /notifyListeners\(\)/);
});

test('reading text listens for manual hold and immediate resume', () => {
  assert.match(storyText, /NarrationFollowCoordinator/);
  assert.match(storyText, /addListener\(_handleNarrationFollowChanged\)/);
  assert.match(storyText, /removeListener\(_handleNarrationFollowChanged\)/);
  assert.match(storyText, /_followCoordinator\?\.suspend\(\)/);
  assert.match(storyText, /_followCoordinator\?\.remainingHold/);
});

test('follow status exposes a compact explicit resume action', () => {
  assert.match(followStatus, /已暂停跟随/);
  assert.match(followStatus, /恢复跟随/);
  assert.match(followStatus, /narration-follow-resume/);
  assert.match(followStatus, /onTap: coordinator\.resume/);
  assert.match(followStatus, /pan_tool_alt_rounded/);
});
