import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const shell = readFileSync('app/lib/screens/home_shell.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/journey_plan_sheet.dart', 'utf8');

test('journey plans persist in AppState', () => {
  assert.match(state, /String journeyOrigin = '河内'/);
  assert.match(state, /DateTime\? plannedJourneyDate/);
  assert.match(state, /Future<void> saveJourneyPlan/);
  assert.match(state, /prefs\.setString\(\s*'plannedJourneyDate'/);
});

test('mobile and wide navigation open the planner', () => {
  const matches = shell.match(/showJourneyPlanSheet\(context\)/g) ?? [];
  assert.ok(matches.length >= 2);
  assert.match(shell, /Icons\.event_note_outlined/);
  assert.match(shell, /state\.journeyPlanDateLabel/);
});

test('planner captures only the real Beijing journey inputs', () => {
  assert.match(sheet, /journey-plan-origin/);
  assert.match(sheet, /journey-plan-date/);
  assert.match(sheet, /journey-plan-focus-/);
  assert.match(sheet, /saveJourneyPlan/);
  assert.match(sheet, /中国 · 北京 · 紫禁城/);
});
