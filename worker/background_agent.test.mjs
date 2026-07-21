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
  assert.match(widget, /Image\.asset/);
  assert.doesNotMatch(widget, /http|OpenAI|generate/);
  assert.match(policy, /_stableHash/);
  assert.match(workflow, /schedule:/);
  assert.match(workflow, /generate_daily_backgrounds\.mjs/);
});
