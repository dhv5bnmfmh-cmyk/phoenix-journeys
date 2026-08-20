import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const csv = path => {
  const lines = readFileSync(new URL(`../${path}`, import.meta.url), 'utf8')
    .trimEnd()
    .split(/\r?\n/);
  return { header: lines[0], rows: lines.slice(1) };
};

test('global convergence evidence uses the current active and Gold registries', () => {
  const active = csv('docs/PHOENIX_CURRENT_ACTIVE_JOURNEY_INVENTORY.csv');
  assert.equal(active.rows.length, 36);
  assert.equal(active.rows.filter(row => row.includes(',"APPROVED_GOLD",')).length, 14);
  assert.equal(active.rows.filter(row => row.includes(',"GOLD_CANDIDATE",')).length, 1);
  assert.match(active.rows.find(row => row.includes('pingyao-ancient-city')), /GOLD_CANDIDATE/);
});

test('requirement matrix generator maps every extracted clause to every active Journey', () => {
  const standards = csv('docs/PHOENIX_CURRENT_STANDARD_INVENTORY.csv');
  const generator = readFileSync(
    new URL('../.github/scripts/generate_global_compliance_evidence.mjs', import.meta.url),
    'utf8',
  );
  assert.equal(standards.rows.length, 23);
  assert.match(generator, /for \(const journey of allJourneys\) for \(const requirement of requirements\)/);
  assert.match(generator, /EVIDENCE_LEVEL/);
  assert.match(generator, /REPAIR_SHA/);
  assert.match(generator, /requirements\.length \* allJourneys\.length/);
});

test('human Gold evidence is provenance-safe and never machine-promoted', () => {
  const human = csv('docs/PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv');
  assert.equal(human.rows.length, 14 * 3 * 3);
  for (const row of human.rows) {
    assert.match(row, /HUMAN_REVIEW_REQUIRED/);
    assert.doesNotMatch(row, /,"PASS"$/);
  }
  const summary = readFileSync(
    new URL('../docs/PHOENIX_GLOBAL_CURRENT_STANDARD_COMPLIANCE.md', import.meta.url),
    'utf8',
  );
  assert.match(summary, /Objective defects remaining: \*\*0\*\*/);
  assert.match(summary, /Human\/Founder gates are not represented as machine PASS/);
});
