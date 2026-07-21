import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import {
  PhoenixBackgroundAgent,
  PHOENIX_BACKGROUND_DESTINATIONS,
  PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
} from './agents/phoenix_background_agent.mjs';
import { PhoenixVisualComplianceAgent } from './agents/phoenix_visual_compliance_agent.mjs';
import {
  PhoenixBackgroundScheduler,
  BACKGROUND_KPI,
} from './agents/phoenix_background_scheduler.mjs';

test('offline librarian plans ten reviewed backgrounds per destination', () => {
  const plan = new PhoenixBackgroundScheduler().createLibraryPlan();
  assert.equal(plan.rejectedJobs.length, 0);
  assert.equal(PHOENIX_OFFLINE_IMAGES_PER_DESTINATION, 10);
  assert.equal(plan.targetPerDestination, 10);
  assert.equal(plan.destinationCount, 7);
  assert.equal(plan.targetInventory, 70);
  assert.equal(plan.approvedJobs.length, 70);
  assert.equal(BACKGROUND_KPI.requiredOfflineInventoryPerDestination, 10);
  assert.equal(BACKGROUND_KPI.requiredTotalOfflineInventory, 70);
  assert.equal(BACKGROUND_KPI.minimumVarietyScore, 80);
  assert.equal(BACKGROUND_KPI.uniqueCompositionRate, 1);
  assert.equal(plan.uniqueVarietyKeys, plan.targetInventory);
  assert.equal(plan.varietyKpiPassed, true);

  for (const journeyId of PHOENIX_BACKGROUND_DESTINATIONS) {
    const destinationJobs = plan.approvedJobs.filter(
      (job) => job.journeyId === journeyId,
    );
    assert.equal(destinationJobs.length, 10);
    assert.equal(new Set(destinationJobs.map((job) => job.id)).size, 10);
    assert.equal(new Set(destinationJobs.map((job) => job.fileName)).size, 10);
    assert.equal(new Set(destinationJobs.map((job) => job.varietyKey)).size, 10);
  }
});

test('future commands can request only the next missing image batch', () => {
  const agent = new PhoenixBackgroundAgent();
  const fullPlan = agent.planOfflineLibrary();
  const existingIds = fullPlan.slice(0, 12).map((job) => job.id);
  const nextBatch = agent.planOfflineLibrary({
    existingIds,
    maxNewImages: 5,
  });
  assert.equal(nextBatch.length, 5);
  assert.equal(
    nextBatch.some((job) => existingIds.includes(job.id)),
    false,
  );
});

test('prompts ban IP, logos, trademarks and artist imitation', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary();
  const compliance = new PhoenixVisualComplianceAgent();
  for (const job of jobs) {
    assert.equal(compliance.reviewPrompt(job).approved, true);
    assert.match(job.prompt, /original/i);
    assert.match(job.prompt, /no logo/i);
    assert.match(job.prompt, /no trademark/i);
    assert.match(job.prompt, /no copyrighted character/i);
    assert.match(job.prompt, /no artist imitation/i);
    assert.match(job.prompt, /clearly different/i);
    assert.ok(job.timeOfDay);
    assert.ok(job.weather);
    assert.ok(job.camera);
    assert.ok(job.scene);
    assert.ok(job.varietyKey);
  }
});

test('explorer runtime reads offline assets without paid image API', () => {
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
  const planner = readFileSync(
    'worker/scripts/plan_offline_background_library.mjs',
    'utf8',
  );
  const rules = readFileSync(
    'docs/destination-background-policy.md',
    'utf8',
  );
  assert.match(widget, /Image\.asset/);
  assert.doesNotMatch(widget, /http|OpenAI|generate/);
  assert.match(policy, /_stableHash/);
  assert.match(policy, /requiredOfflineInventoryPerDestination = 10/);
  assert.match(policy, /JourneyBackgroundOrigin\.aiGenerated/);
  assert.match(policy, /minimumVarietyScore/);
  assert.doesNotMatch(workflow, /OPENAI_API_KEY/);
  assert.doesNotMatch(workflow, /schedule:/);
  assert.match(workflow, /plan_offline_background_library\.mjs --check/);
  assert.match(planner, /7 cities × 10 images/);
  assert.match(rules, /PhoenixBackgroundLibrarianAgent/);
  assert.match(rules, /固定保持 10 张/);
  assert.match(rules, /禁止现场生成/);
  assert.match(rules, /不再依赖 OpenAI API Key/);
});
