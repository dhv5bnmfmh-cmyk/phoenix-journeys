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
const accessState = read('app/lib/state/access_controlled_app_state.dart');
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
      "summerPalacePilotPrimaryFinding = 'CULTURAL_PLACE_CAUSALITY_MISSING'",
      "summerPalacePilotProtagonist = '许澄'",
      '外婆周岚',
      '迫使许澄在作品和外婆的记忆之间选择',
      '先捡回旧照片',
      '等了一下午的十七孔桥桥洞金光真实消失',
      '周岚停止替她调整构图并把旧照片交给她保存',
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
      '不复述许澄事件链',
      '借景',
      '十七孔桥空间与季节光线',
      'World Heritage保护',
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

test('Summer Palace uses the stable six-stage Journey flow', () => {
  requireAll(
    screen,
    [
      'bool get _isSummerPalacePilot => false;',
      '_storyPage()',
      '_wordsPage()',
      '_discoveryPage()',
      '_challengePage()',
      '_memoryPage()',
      '_completePage()',
    ],
    'Journey Screen',
  );
  requireAll(
    state,
    [
      "static const int journeyLastStep = 5;",
      "'故事',",
      "'单词',",
      "'发现',",
      "'挑战',",
      "'回忆',",
      "'完成',",
      'return journeyStepLabels[_safeJourneyStep(step)];',
      'enum JourneyCompositeSubstage',
      'summerPalaceJourneyFlowVersion = 2',
      'journeyChallengeAttemptId',
      'guideFeedbackInputIdentity',
      'writingFeedbackInputIdentity',
    ],
    'Stable Journey flow and compatibility state',
  );
  assert.ok(!screen.includes("_experience.id == 'beijing-summer-palace'"));
  assert.ok(!state.includes("return substage == JourneyCompositeSubstage.challenge ? '挑战' : '思考';"));
  assert.ok(!state.includes("return substage == JourneyCompositeSubstage.memory ? '回忆' : '表达';"));
  assert.ok(!screen.includes('AppState.journeyLastStep ='));
});

test('Critical State migrates v1 to v2 while top-level steps remain 0-5', () => {
  assert.match(state, /static const int journeyLastStep = 5;/);
  assert.match(
    criticalStore,
    /static const int phoenixCriticalStateLegacySchemaVersion = 1;/,
  );
  assert.match(
    criticalStore,
    /static const int phoenixCriticalStateSchemaVersion = 2;/,
  );
  requireAll(
    accessState,
    [
      'phoenixCriticalStateLegacySchemaVersion',
      '.migratedToV2()',
      'commitPayload(',
      'Critical state did not reach schema v2',
    ],
    'Critical State migration',
  );
});

test('Pilot matrix separates automated and human literary evidence', () => {
  requireAll(
    matrix,
    [
      '**Governance Phase ID:** `PILOT_N1`',
      '**Primary Finding:** `PROTAGONIST_IDENTITY_MISSING`',
      'Story Function Contract',
      'Discovery Function Contract',
      'Automated Structural Result',
      'Human Literary Result',
      'Automated score used as literary approval: NO',
      'Founder approval state: PENDING',
      'Critical State schema version: `2`',
      'Legacy readable schema version: `1`',
      'Persisted composite substage field: YES',
      'Top-level step range: `0–5`',
      'Global background zoom behavior: unchanged',
    ],
    'Pilot matrix',
  );
});