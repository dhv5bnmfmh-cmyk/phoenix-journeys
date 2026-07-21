import {
  PhoenixBackgroundAgent,
  PHOENIX_BACKGROUND_DESTINATIONS,
} from './phoenix_background_agent.mjs';
import { PhoenixVisualComplianceAgent } from './phoenix_visual_compliance_agent.mjs';

export const BACKGROUND_KPI = Object.freeze({
  dailyApprovedPerDestination: 4,
  minimumInventoryPerDestination: 20,
  minimumInventoryPerPageType: 5,
  compliancePassRate: 1,
  generationRecoveryRate: 0.95,
  dailyPublicationSuccessRate: 0.99,
});

export class PhoenixBackgroundScheduler {
  constructor({
    backgroundAgent = new PhoenixBackgroundAgent({
      variantsPerDestination: BACKGROUND_KPI.dailyApprovedPerDestination,
    }),
    complianceAgent = new PhoenixVisualComplianceAgent(),
  } = {}) {
    this.backgroundAgent = backgroundAgent;
    this.complianceAgent = complianceAgent;
  }

  createDailyPlan({ date }) {
    const jobs = this.backgroundAgent.planDailyJobs({
      date,
      journeyIds: PHOENIX_BACKGROUND_DESTINATIONS,
    });
    const reviewed = jobs.map((job) => ({
      ...job,
      promptReview: this.complianceAgent.reviewPrompt(job),
    }));
    const approvedJobs = reviewed.filter((job) => job.promptReview.approved);
    return {
      agent: 'PhoenixBackgroundScheduler',
      date,
      kpi: BACKGROUND_KPI,
      expected:
        PHOENIX_BACKGROUND_DESTINATIONS.length *
        BACKGROUND_KPI.dailyApprovedPerDestination,
      approvedJobs,
      rejectedJobs: reviewed.filter((job) => !job.promptReview.approved),
    };
  }
}
