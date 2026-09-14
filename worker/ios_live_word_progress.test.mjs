import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('iOS narration starts its progress watchdog before Safari speech can block', () => {
  assert.match(
    controller,
    /unawaited\(_startProgressWatchdog\(sessionToken, safeOffset\)\);[\s\S]*final result = await _tts\.speak\(remainingText\);/,
  );
  assert.match(controller, /Duration\(milliseconds: 260\)/);
});

test('active narration always derives an inline highlight item', () => {
  assert.match(
    controller,
    /sessionActive[\s\S]*_plan\.indexForOffset\(_currentOffset\)/,
  );
  assert.match(
    controller,
    /_status = NarrationStatus\.playing;[\s\S]*_applyProgress\(0\);/,
  );
});
