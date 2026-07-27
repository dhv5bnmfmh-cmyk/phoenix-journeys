import {
  PhoenixBackgroundAgent,
  PHOENIX_BACKGROUND_DESTINATIONS,
  PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
} from './phoenix_background_agent.mjs';
import { PhoenixVisualComplianceAgent } from './phoenix_visual_compliance_agent.mjs';

export const BACKGROUND_KPI = Object.freeze({
  requiredOfflineInventoryPerDestination:
    PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
  requiredTotalOfflineInventory:
    PHOENIX_BACKGROUND_DESTINATIONS.length *
    PHOENIX_OFFLINE_IMAGES_PER_DESTINATION,
  compliancePassRate: 1,
  minimumComplianceScore: 90,
  minimumVarietyScore: 80,
  uniqueCompositionRate: 1,
  publicationSuccessRate: 1,
});

export class PhoenixBackgroundScheduler {
  constructor({
    backgroundAgent = new PhoenixBackgroundAgent(),
    complianceAgent = new PhoenixVisualComplianceAgent(),
  } = {}) {
    this.backgroundAgent = backgroundAgent;
    this.complianceAgent = complianceAgent;
  }

  createLibraryPlan({ existingIds = [], maxNewImages } = {}) {
    const allMissingJobs = this.backgroundAgent.planOfflineLibrary({
      journeyIds: PHOENIX_BACKGROUND_DESTINATIONS,
      existingIds,
    });
    const requestedJobs = Number.isFinite(maxNewImages)
      ? allMissingJobs.slice(0, Math.max(0, maxNewImages))
      : allMissingJobs;
    const reviewed = requestedJobs.map((job) => ({
      ...job,
      promptReview: this.complianceAgent.reviewPrompt(job),
    }));
    const approvedJobs = reviewed.filter((job) => job.promptReview.approved);
    const uniqueVarietyKeys = new Set(approvedJobs.map((job) => job.varietyKey));
    return {
      agent: 'PhoenixBackgroundLibrarianAgent',
      mode: 'offline-library',
      kpi: BACKGROUND_KPI,
      destinationCount: PHOENIX_BACKGROUND_DESTINATIONS.length,
      targetPerDestination:
        BACKGROUND_KPI.requiredOfflineInventoryPerDestination,
      targetInventory: BACKGROUND_KPI.requiredTotalOfflineInventory,
      existingInventory: existingIds.length,
      missingInventory: allMissingJobs.length,
      requestedImages: requestedJobs.length,
      expected: requestedJobs.length,
      approvedJobs,
      uniqueVarietyKeys: uniqueVarietyKeys.size,
      varietyKpiPassed: uniqueVarietyKeys.size === approvedJobs.length,
      rejectedJobs: reviewed.filter((job) => !job.promptReview.approved),
    };
  }

  // Kept only for compatibility with older tooling. It now returns the stable
  // offline-library plan and never implies a paid daily API schedule.
  createDailyPlan() {
    return this.createLibraryPlan();
  }
}
