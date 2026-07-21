import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import {
  PhoenixBackgroundAgent,
  PHOENIX_BACKGROUND_DESTINATIONS,
} from './agents/phoenix_background_agent.mjs';
import { PhoenixVisualComplianceAgent } from './agents/phoenix_visual_compliance_agent.mjs';
import {
  PhoenixBackgroundScheduler,
  BACKGROUND_KPI,
} from './agents/phoenix_background_scheduler.mjs';

test('daily scheduler creates four original reviewed jobs per destination', () => {
  const plan = new PhoenixBackgroundScheduler().createDailyPlan({
    date: '2026-07-21',
  });
  assert.equal(plan.rejectedJobs.length, 0);
  assert.equal(
    plan.approvedJobs.length,
    PHOENIX_BACKGROUND_DESTINATIONS.length * 4,
  );
  assert.equal(plan.expected, 28);
  assert.equal(BACKGROUND_KPI.minimumInventoryPerDestination, 20);
  assert.equal(BACKGROUND_KPI.minimumInventoryPerPageType, 5);
  assert.equal(BACKGROUND_KPI.minimumVarietyScore, 80);
  assert.equal(BACKGROUND_KPI.uniqueDailyCompositionRate, 1);
  assert.equal(plan.uniqueVarietyKeys, plan.expected);
  assert.equal(plan.varietyKpiPassed, true);
  for (const journeyId of PHOENIX_BACKGROUND_DESTINATIONS) {
    const destinationJobs = plan.approvedJobs.filter(
      (job) => job.journeyId === journeyId,
    );
    assert.equal(new Set(destinationJobs.map((job) => job.camera)).size, 4);
    assert.equal(new Set(destinationJobs.map((job) => job.timeOfDay)).size, 4);
  }
});

test('prompts ban IP, logos, trademarks and artist imitation', () => {
  const jobs = new PhoenixBackgroundAgent().planDailyJobs({
    date: '2026-07-21',
  });
  const compliance = new PhoenixVisualComplianceAgent();
  for (const job of jobs) {
    assert.equal(compliance.reviewPrompt(job).approved, true);
    assert.match(job.prompt, /original/i);
    assert.match(job.prompt, /no logo/i);
    assert.match(job.prompt, /no trademark/i);
    assert.match(job.prompt, /no copyrighted character/i);
    assert.match(job.prompt, /no artist imitation/i);
    assert.match(job.prompt, /visibly different/i);
    assert.ok(job.timeOfDay);
    assert.ok(job.weather);
    assert.ok(job.camera);
    assert.ok(job.scene);
    assert.ok(job.varietyKey);
  }
});

test('explorer runtime reads pre-generated assets without image AI', () => {
  const widget = readFileSync(
    'app/lib/widgets/destination_background.dart',
    'utf8',
  );
  const policy = readFileSync(
    'app/lib/services/journey_background_policy.dart',
    'utf8',
  );
  const workflow = readFileSync(
    '.github/workflows/daily-background-refresh.yml',
    'utf8',
  );
  const generator = readFileSync(
    'worker/scripts/generate_daily_backgrounds.mjs',
    'utf8',
  );
  const rules = readFileSync(
    'docs/destination-background-policy.md',
    'utf8',
  );
  assert.match(widget, /Image\.asset/);
  assert.doesNotMatch(widget, /http|OpenAI|generate/);
  assert.match(policy, /_stableHash/);
  assert.match(policy, /JourneyBackgroundOrigin\.aiGenerated/);
  assert.match(policy, /minimumVarietyScore/);
  assert.match(workflow, /schedule:/);
  assert.match(workflow, /push:/);
  assert.match(workflow, /generate_daily_backgrounds\.mjs/);
  assert.match(generator, /seenIds/);
  assert.match(generator, /varietyScore:/);
  assert.match(rules, /PhoenixBackgroundAgent/);
  assert.match(rules, /PhoenixVisualComplianceAgent/);
  assert.match(rules, /PhoenixBackgroundScheduler/);
  assert.match(rules, /禁止现场生成/);
  assert.match(rules, /侵权合规通过率必须为 100%/);
});
