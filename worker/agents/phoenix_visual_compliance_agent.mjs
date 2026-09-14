const forbiddenPromptPatterns = [
  /\b(use|include|show|copy|replicate)\b.{0,30}\b(logo|logotype|trademark|brand mark)\b/i,
  /\b(use|include|show|copy|replicate)\b.{0,30}\b(copyrighted character|movie character|anime character)\b/i,
  /\bin the style of\b/i,
  /\b(use|include|show|copy|replicate)\b.{0,40}\b(official poster|album cover|poster artwork)\b/i,
  /\b(add|include|show)\b.{0,20}\b(signature|watermark)\b/i,
];

export class PhoenixVisualComplianceAgent {
  constructor({ minimumScore = 90, minimumVarietyScore = 80 } = {}) {
    this.minimumScore = minimumScore;
    this.minimumVarietyScore = minimumVarietyScore;
  }

  reviewPrompt(job) {
    const combined = `${job.prompt ?? ''} ${job.negativePrompt ?? ''}`;
    const issues = forbiddenPromptPatterns
      .filter((pattern) => pattern.test(combined))
      .map((pattern) => `forbidden-prompt:${pattern.source}`);
    const required = [
      'original',
      'no text',
      'no logo',
      'no trademark',
      'no copyrighted character',
      'no artist imitation',
      'visibly different',
    ];
    for (const phrase of required) {
      if (!combined.toLowerCase().includes(phrase)) {
        issues.push(`missing-safety-or-variety-clause:${phrase}`);
      }
    }
    if (!job.varietyKey || !job.timeOfDay || !job.weather || !job.camera) {
      issues.push('missing-variety-dimensions');
    }
    return {
      agent: 'PhoenixVisualComplianceAgent',
      approved: issues.length === 0,
      score: issues.length === 0 ? 100 : 0,
      varietyScore: issues.length === 0 ? 100 : 0,
      issues,
    };
  }

  async reviewGeneratedImage({ imageBase64, callResponsesApi }) {
    const result = await callResponsesApi({
      model: process.env.PHOENIX_VISUAL_REVIEW_MODEL || 'gpt-5',
      instruction:
        'Review this mobile app background conservatively. Reject any recognizable logo, trademark, copyrighted character, celebrity likeness, signature, watermark, copied poster, or close imitation of a named living artist. Also reject generic, repetitive, near-duplicate, visually flat compositions and any image that makes interface text unreadable. Score both compliance and visual variety. Return JSON only with approved, score, varietyScore, issues.',
      imageBase64,
    });
    const score = Number(result?.score ?? 0);
    const varietyScore = Number(result?.varietyScore ?? 0);
    return {
      agent: 'PhoenixVisualComplianceAgent',
      approved:
        result?.approved === true &&
        score >= this.minimumScore &&
        varietyScore >= this.minimumVarietyScore,
      score,
      varietyScore,
      issues: Array.isArray(result?.issues) ? result.issues : [],
    };
  }
}
