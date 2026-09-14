import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const startup = readFileSync('app/lib/widgets/startup_gate.dart', 'utf8');
const shell = readFileSync('app/lib/screens/home_shell.dart', 'utf8');
const workflow = readFileSync('docs/development-workflow.md', 'utf8');

test('startup loading and error surfaces follow the selected script', () => {
  assert.match(startup, /_StartupLoading\(state: state\)/);
  assert.match(startup, /required this\.state/);
  assert.match(startup, /state\.displayText\('Phoenix Journeys 正在载入'\)/);
  assert.match(startup, /state\.displayText\('正在准备你的旅程…'\)/);
  assert.match(startup, /state\.displayText\('读取语言设置与学习记录'\)/);
  assert.match(startup, /state\.displayText\('旅程暂时停在登机口'\)/);
  assert.match(startup, /state\.displayText\('重新尝试'\)/);
});

test('wide and mobile navigation use the same script conversion', () => {
  for (const label of ['探索', '护照', '我的']) {
    const matches = shell.match(
      new RegExp(`state\\.displayText\\('${label}'\\)`, 'g'),
    );
    assert.equal(
      matches?.length,
      2,
      `${label} must convert in both NavigationRail and mobile navigation`,
    );
  }
});

test('global script consistency is a permanent development rule', () => {
  assert.match(
    workflow,
    /启动载入、启动错误、手机导航和宽屏导航必须统一跟随简体／繁体设置/,
  );
});
