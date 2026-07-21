const forbiddenPromptPatterns = [
  /logo|logotype|trademark|brand mark/i,
  /copyrighted character|movie character|anime character/i,
  /in the style of|style of [A-Z]/i,
  /poster for|official poster|album cover/i,
  /signature|watermark/i,
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
      model: process.env.PHOENIX_VISUAL_REVIEW_MODEL || 'gpt-5.6-luna',
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
