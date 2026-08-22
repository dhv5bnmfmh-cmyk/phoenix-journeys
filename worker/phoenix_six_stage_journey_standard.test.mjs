import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

function read(path) {
  assert.ok(fs.existsSync(path), `${path} must exist`);
  return fs.readFileSync(path, 'utf8');
}

const standard = read('docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md');
const matrix = read('docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md');
const state = read('app/lib/state/app_state.dart');
const challenge = read('app/lib/widgets/journey_challenge_panel_legacy.dart');

const requiredStageLabels = ['故事', '单词', '发现', '挑战', '回忆', '完成'];
const requiredModes = ['paragraphRebuild', 'grammarRepair', 'missingSentence'];

test('binding Journey standard defines exactly six user-visible stages', () => {
  assert.ok(standard.includes('**Status:** BINDING'));
  assert.ok(standard.includes('Every normal and special Journey MUST use exactly these six committed stages'));
  assert.ok(standard.includes('The committed top-level range remains `0–5`'));
  assert.ok(standard.includes('No Journey may add a seventh or eighth user-visible stage'));
  for (const label of requiredStageLabels) assert.ok(standard.includes(label));
  assert.ok(standard.includes('Standalone Reflection present:'));
  assert.ok(standard.includes('Standalone Writing present:'));
});

test('acceptance matrix records the six stages and rejects standalone Reflection and Writing', () => {
  for (const label of requiredStageLabels) assert.ok(matrix.includes(label));
  assert.ok(matrix.includes('Top-level committed range: `0–5`'));
  assert.ok(matrix.includes('Standalone Reflection present: `NO`'));
  assert.ok(matrix.includes('Standalone Writing present: `NO`'));
});

test('all three Challenge modes are binding and implemented', () => {
  for (const mode of requiredModes) {
    assert.ok(standard.includes(`\`${mode}\``), `standard must require ${mode}`);
    assert.ok(matrix.includes(`\`${mode}\``), `matrix must verify ${mode}`);
    assert.ok(challenge.includes(mode), `runtime Challenge must implement ${mode}`);
  }
});

test('runtime top-level Journey identity remains 0-5 with canonical labels', () => {
  assert.match(state, /static const int journeyLastStep = 5;/);
  for (const label of requiredStageLabels) {
    assert.ok(state.includes(`'${label}'`), `AppState must include ${label}`);
  }
});

test('automated evidence cannot replace semantic or Founder approval', () => {
  assert.ok(standard.includes('Automated scores cannot approve literary quality'));
  assert.ok(standard.includes('Founder mobile approval is REQUIRED'));
  assert.ok(standard.includes('Every completed modification must provide an exact-Head experience link'));
});
