import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('simplified and traditional mode stay consistent in mobile and wide navigation', async () => {
  const shell = await read('app/lib/screens/home_shell.dart');

  for (const label of ['探索', '护照', '我的']) {
    const escapedLabel = label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    assert.match(
      shell,
      new RegExp(`label: Text\\(state\\.displayText\\('${escapedLabel}'\\)\\)`),
      `wide navigation must convert ${label} through AppState.displayText`,
    );
    assert.match(
      shell,
      new RegExp(`label: state\\.displayText\\('${escapedLabel}'\\)`),
      `compact navigation must convert ${label} through AppState.displayText`,
    );
  }

  assert.doesNotMatch(
    shell,
    /NavigationRailDestination\([\s\S]*?label: Text\('(探索|护照|我的)'\)/,
    'wide navigation must not hardcode simplified-only labels',
  );
});
