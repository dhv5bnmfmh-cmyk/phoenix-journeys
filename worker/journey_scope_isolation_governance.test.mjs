import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const narrativeStandard = readFileSync(
  new URL('../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md', import.meta.url),
  'utf8',
);
const aiBehavior = readFileSync(
  new URL('../ai/AI_BEHAVIOR.md', import.meta.url),
  'utf8',
);
const developmentWorkflow = readFileSync(
  new URL('../docs/development-workflow.md', import.meta.url),
  'utf8',
);
const completionStandard = readFileSync(
  new URL('../docs/PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md', import.meta.url),
  'utf8',
);

test('canonical Journey scope isolation gate is binding', () => {
  for (const required of [
    '### 20.13 Journey Scope Isolation Gate',
    '`JOURNEY_SCOPE_LEAKAGE`',
    '`AUTHORIZED_BASELINE_SHA`',
    '`AUTHORIZED_JOURNEY_SET`',
    '`OUT_OF_SCOPE_JOURNEY`',
    '`SHARED FILE != SHARED AUTHORITY`',
    '`GOOD CHANGE != AUTHORIZED CHANGE`',
    '`NOTICE != AUTHORIZATION`',
    '`GREEN CI != SCOPE APPROVAL`',
    '`OTHER_JOURNEY_CONTENT_DELTA`',
    '`SHARED_INFRASTRUCTURE_DELTA`',
    '`OUT_OF_SCOPE_FINDING`',
    'SCOPE LEAKAGE — NOT READY FOR FOUNDER APPROVAL',
  ]) {
    assert.match(narrativeStandard, new RegExp(required.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
  }
});

test('AI and development governance require ownership-level scope audit', () => {
  for (const required of [
    '`AUTHORIZED_BASELINE_SHA`',
    '`AUTHORIZED_JOURNEY_SET`',
    '`OUT_OF_SCOPE_FINDING`',
    '`JOURNEY_SCOPE_LEAKAGE`',
    'SCOPE LEAKAGE — NOT READY FOR FOUNDER APPROVAL',
  ]) {
    assert.match(aiBehavior, new RegExp(required.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
  }

  for (const required of [
    'FINAL DIFF OWNERSHIP AUDIT',
    '`AUTHORIZED_BASELINE_SHA`',
    '`AUTHORIZED_JOURNEY_SET`',
    '`OTHER_JOURNEY_CONTENT_DELTA`',
    '`JOURNEY_SCOPE_LEAKAGE`',
  ]) {
    assert.match(developmentWorkflow, new RegExp(required.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
  }
});

test('completion cannot use green tests to waive Journey scope leakage', () => {
  for (const required of [
    '`AUTHORIZED_BASELINE_SHA`',
    '`AUTHORIZED_JOURNEY_SET`',
    '`OTHER_JOURNEY_CONTENT_DELTA = NONE`',
    '`JOURNEY_SCOPE_LEAKAGE`',
  ]) {
    assert.match(completionStandard, new RegExp(required.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));
  }
  assert.match(completionStandard, /tests? pass/i);
  assert.match(completionStandard, /scope authorization/i);
});
