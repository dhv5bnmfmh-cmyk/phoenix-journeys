import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('startup loading and error copy follow the selected Chinese script', async () => {
  const startup = await read('app/lib/widgets/startup_gate.dart');

  for (const copy of [
    'Phoenix Journeys 正在载入',
    '正在准备你的旅程…',
    '读取语言设置与学习记录',
    '旅程暂时停在登机口',
    '重新尝试',
  ]) {
    assert.match(
      startup,
      new RegExp(`state\\.displayText\\('${copy.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}'\\)`),
      `startup copy must use AppState.displayText: ${copy}`,
    );
  }

  assert.match(startup, /state\.displayText\(message\)/);
  assert.doesNotMatch(startup, /const _StartupLoading\(\)/);
});
