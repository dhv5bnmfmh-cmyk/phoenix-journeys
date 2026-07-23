import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('journey completion labels follow the selected Chinese script', () => {
  const requiredSnippets = [
    "title: _appState.displayText('${_experience.city}已点亮')",
    "buttonText: _appState.displayText('返回首页')",
    "_appState.displayText('盖章成功')",
    "_appState.displayText('你完成的不是一堂课，而是一段旅程。')",
    "_appState.displayText('重新体验')",
  ];

  for (const snippet of requiredSnippets) {
    assert.ok(
      journey.includes(snippet),
      `completion page must convert through AppState: ${snippet}`,
    );
  }
});
