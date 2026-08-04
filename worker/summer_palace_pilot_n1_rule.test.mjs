import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

function read(path) {
  assert.ok(fs.existsSync(path), `${path} must exist`);
  return fs.readFileSync(path, 'utf8');
}

const story = read('app/lib/data/summer_palace_journey.dart');
const adaptive = read('app/lib/data/summer_palace_adaptive_story_levels.dart');
const levels = read('app/lib/data/journey_level_catalog.dart');
const screen = read('app/lib/screens/journey_screen.dart');
const matrix = read('docs/PHOENIX_PILOT_N1_BEIJING_SUMMER_PALACE_MATRIX.md');
const state = read('app/lib/state/app_state.dart');
const criticalStore = read('app/lib/services/critical_persistence_store.dart');

function requireAll(text, values, label) {
  for (const value of values) {
    assert.ok(text.includes(value), `${label} must include ${value}`);
  }
}

test('Pilot N1 declares its exact governance identity and causal story', () => {
  requireAll(
    story,
    [
      "summerPalacePilotPhaseId = 'PILOT_N1'",
      "summerPalacePilotPrimaryFinding = 'PROTAGONIST_IDENTITY_MISSING'",
      "summerPalacePilotProtagonist = '许澄'",
      '外婆周岚',
      '必须选择',
      '先捡回照片',
      '《留下痕迹的风景》',
      '只把旧照片交给她保存',
    ],
    'Summer Palace Story',
  );
  assert.ok(!story.includes("'清晨，你来到颐和园"));
});

test('Story and Discovery have separate functions', () => {
  requireAll(
    story,
    [
      'summerPalaceStoryFunctionContract',
      'summerPalaceDiscoveryFunctionContract',
      '不复述许澄的事件链',
      '借景',
      '对景',
      '修复记录',
    ],
    'Summer Palace function contracts',
  );
  const discoveryStart = story.indexOf('const summerPalaceDiscoveries');
  const discoveryEnd = story.indexOf('final summerPalaceJourneyContent');
  const discovery = story.slice(discoveryStart, discoveryEnd);
  assert.ok(!discovery.includes('许澄'));
  assert.ok(!discovery.includes('周岚'));
  assert.ok(!discovery.includes('旧照片'));
});

test('difficulty and adaptive levels preserve narrative invariants', () => {
  for (const source of [adaptive, levels]) {
    requireAll(
      source,
      ['许澄', '周岚', '旧照片', '修复'],
      'Summer Palace level content',
    );
  }
  assert.ok(adaptive.match(/许澄/g).length >= 6);
  assert.ok(levels.match(/许澄/g).length >= 6);
});

test('Reflection and Writing are Pilot-scoped composite pages', () => {
  requireAll(
    screen,
    [
      'enum PilotN1CompositePage',
      'resolvePilotN1CompositePage',
      "_experience.id == 'beijing-summer-palace'",
      '_wonderPage()',
      '_challengePage()',
      '_expressPage()',
      '_memoryPage()',
      '_pilotChallengeVisible',
      '_pilotMemoryVisible',
    ],
    'Journey Screen',
  );
  assert.ok(!screen.includes('AppState.journeyLastStep ='));
});

test('Critical State schema v1 and top-level step count remain unchanged', () => {
  assert.match(state, /static const int journeyLastStep = 5;/);
  assert.match(
    criticalStore,
    /static const int phoenixCriticalStateSchemaVersion = 1;/,
  );
});

test('Pilot matrix separates automated and human literary evidence', () => {
  requireAll(
    matrix,
    [
      'Governance Phase ID: `PILOT_N1`',
      'Primary Finding: `PROTAGONIST_IDENTITY_MISSING`',
      'Story Function Contract',
      'Discovery Function Contract',
      'Automated Structural Result',
      'Human Literary Result',
      'Automated score used as literary approval: NO',
      'Founder approval state: PENDING',
      'Critical State schema version: `1`',
      'Top-level step range: `0–5`',
    ],
    'Pilot matrix',
  );
});
