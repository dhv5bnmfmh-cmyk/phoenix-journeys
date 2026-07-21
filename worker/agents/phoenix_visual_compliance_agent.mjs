const forbiddenPromptPatterns = [
  /\b(use|include|show|copy|replicate)\b.{0,30}\b(logo|logotype|trademark|brand mark)\b/i,
  /\b(use|include|show|copy|replicate)\b.{0,30}\b(copyrighted character|movie character|anime character)\b/i,
  /\bin the style of\b/i,
  /\b(official poster|album cover replica|copied poster)\b/i,
  /\b(add|include|show)\b.{0,20}\b(signature|watermark)\b/i,
];

export class PhoenixVisualComplianceAgent {
  constructor({ minimumScore = 90 } = {}) {
    this.minimumScore = minimumScore;
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
    ];
    for (const phrase of required) {
      if (!combined.toLowerCase().includes(phrase)) {
        issues.push(`missing-safety-clause:${phrase}`);
      }
    }
    return {
      agent: 'PhoenixVisualComplianceAgent',
      approved: issues.length === 0,
      score: issues.length === 0 ? 100 : 0,
      issues,
    };
  }

  async reviewGeneratedImage({ imageBase64, callResponsesApi }) {
    const result = await callResponsesApi({
      model: process.env.PHOENIX_VISUAL_REVIEW_MODEL || 'gpt-5',
      instruction:
        'Review this mobile app background conservatively. Reject any recognizable logo, trademark, copyrighted character, celebrity likeness, signature, watermark, copied poster, close imitation of a named living artist, or composition that makes interface text unreadable. Return JSON only with approved, score, issues.',
      imageBase64,
    });
    const score = Number(result?.score ?? 0);
    return {
      agent: 'PhoenixVisualComplianceAgent',
      approved: result?.approved === true && score >= this.minimumScore,
      score,
      issues: Array.isArray(result?.issues) ? result.issues : [],
    };
  }
}
