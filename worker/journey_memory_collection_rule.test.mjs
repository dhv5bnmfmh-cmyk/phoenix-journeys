import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const meScreenPath = new URL('../app/lib/screens/me_screen.dart', import.meta.url);
const timelinePath = new URL(
  '../app/lib/widgets/journey_memory_timeline.dart',
  import.meta.url,
);

test('Me screen uses the journey-aware memory collection', async () => {
  const source = await readFile(meScreenPath, 'utf8');

  assert.match(source, /journey_memory_timeline\.dart/);
  assert.match(source, /JourneyMemoryTimeline\(state: state\)/);
  assert.doesNotMatch(source, /次北京之旅/);
});

test('memory collection resolves every entry back to its journey', async () => {
  const source = await readFile(timelinePath, 'utf8');

  assert.match(source, /allJourneyExperiences/);
  assert.match(source, /candidate\.stampTitle == storedTitle/);
  assert.match(source, /candidate\.appBarTitle == storedTitle/);
  assert.match(source, /journey\?\.appBarTitle \?\? title/);
  assert.match(source, /state\.displayText\(entry\.displayTitle\)/);
  assert.match(source, /journey-memory-detail/);
  assert.match(source, /永久收藏/);
  assert.doesNotMatch(source, /次北京之旅/);
});
