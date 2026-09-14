import assert from 'node:assert/strict';

import {
  PhoenixBackgroundAgent,
  PHOENIX_BACKGROUND_DESTINATIONS,
  PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
} from '../agents/phoenix_background_agent.mjs';
import {
  PhoenixBackgroundScheduler,
  BACKGROUND_KPI,
} from '../agents/phoenix_background_scheduler.mjs';

const checkOnly = process.argv.includes('--check');
const limitArgument = process.argv.find((value) => value.startsWith('--limit='));
const maxNewImages = limitArgument
  ? Number.parseInt(limitArgument.split('=')[1], 10)
  : Number.POSITIVE_INFINITY;

const agent = new PhoenixBackgroundAgent();
const scheduler = new PhoenixBackgroundScheduler({ backgroundAgent: agent });
const plan = scheduler.createLibraryPlan({ maxNewImages });

if (checkOnly) {
  assert.equal(PHOENIX_OFFLINE_IMAGES_PER_DESTINATION, 10);
  assert.equal(PHOENIX_BACKGROUND_DESTINATIONS.length, 7);
  assert.equal(BACKGROUND_KPI.requiredTotalOfflineInventory, 70);
  assert.equal(plan.targetInventory, 70);
  assert.equal(plan.missingInventory, 70);
  assert.equal(plan.approvedJobs.length, 70);
  assert.equal(plan.rejectedJobs.length, 0);
  assert.equal(plan.uniqueVarietyKeys, 70);
  assert.equal(plan.varietyKpiPassed, true);
  for (const journeyId of PHOENIX_BACKGROUND_DESTINATIONS) {
    const cityJobs = plan.approvedJobs.filter(
      (job) => job.journeyId === journeyId,
    );
    assert.equal(cityJobs.length, 10);
    assert.equal(new Set(cityJobs.map((job) => job.fileName)).size, 10);
  }
  console.log('Phoenix offline background library rule passed: 7 cities × 10 images.');
} else {
  console.log(
    JSON.stringify(
      {
        agent: plan.agent,
        mode: plan.mode,
        destinationCount: plan.destinationCount,
        targetPerDestination: plan.targetPerDestination,
        targetInventory: plan.targetInventory,
        requestedImages: plan.requestedImages,
        jobs: plan.approvedJobs.map((job) => ({
          id: job.id,
          journeyId: job.journeyId,
          fileName: job.fileName,
          slot: job.slot,
          prompt: job.prompt,
          negativePrompt: job.negativePrompt,
        })),
      },
      null,
      2,
    ),
  );
}
