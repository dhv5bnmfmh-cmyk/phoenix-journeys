const QUALITY_THRESHOLD = 84;

const guideSchema = {
  type: 'object',
  additionalProperties: false,
  required: ['approved', 'score', 'issues', 'revisedReply'],
  properties: {
    approved: { type: 'boolean' },
    score: { type: 'integer', minimum: 0, maximum: 100 },
    issues: {
      type: 'array',
      maxItems: 5,
      items: { type: 'string' },
    },
    revisedReply: { type: 'string' },
  },
};

const writingSchema = {
  type: 'object',
  additionalProperties: false,
  required: ['approved', 'score', 'issues', 'revisedFeedback'],
  properties: {
    approved: { type: 'boolean' },
    score: { type: 'integer', minimum: 0, maximum: 100 },
    issues: {
      type: 'array',
      maxItems: 6,
      items: { type: 'string' },
    },
    revisedFeedback: {
      type: 'object',
      additionalProperties: false,
      required: ['corrected', 'explanation', 'natural', 'encouragement'],
      properties: {
        corrected: { type: 'string' },
        explanation: { type: 'string' },
        natural: { type: 'string' },
        encouragement: { type: 'string' },
      },
    },
  },
};

function profileText(profile) {
  try {
    return JSON.stringify(profile ?? {});
  } catch (_) {
    return '{}';
  }
}

export class PhoenixQualityAgent {
  constructor(gateway) {
    this.gateway = gateway;
  }

  async reviewGuide({ learnerText, candidate, journey, language, profile }) {
    const messages = [
      {
        role: 'system',
        content: [
          '你是隐藏的 PhoenixQualityAgent，只负责审核 PhoenixGuideAgent 的回复。',
          '检查回复是否真正回应学习者的具体内容，是否有依据地使用 Journey 背景，是否自然、有启发性，并避免模板化赞美。',
          '回复必须适合成年中高级中文学习者；不能编造 Journey 之外的历史事实；最多提出一个清楚而有深度的问题。',
          '如果质量不足，请直接给出可替换的 revisedReply；如果合格，revisedReply 原样返回。',
          '只输出符合 JSON Schema 的对象。',
        ].join('\n'),
      },
      {
        role: 'user',
        content: [
          `<journey>${JSON.stringify(journey ?? {})}</journey>`,
          `<learner_language>${language}</learner_language>`,
          `<learner_profile>${profileText(profile)}</learner_profile>`,
          `<learner_text>${learnerText}</learner_text>`,
          `<candidate_reply>${candidate}</candidate_reply>`,
        ].join('\n'),
      },
    ];

    const result = await this.gateway.generateStructured({
      messages,
      schema: guideSchema,
      schemaName: 'phoenix_guide_quality',
      maxOutputTokens: 850,
      reasoningEffort: 'medium',
      temperature: 0.15,
      purpose: 'quality-guide',
    });
    const review = result.value;
    const accepted =
      review.approved === true && Number(review.score) >= QUALITY_THRESHOLD;
    const revised = typeof review.revisedReply === 'string'
      ? review.revisedReply.trim()
      : '';

    return {
      reply: accepted || !revised ? candidate : revised,
      reviewed: true,
      approved: accepted,
      score: Number(review.score) || 0,
      issues: Array.isArray(review.issues) ? review.issues : [],
      provider: result.provider,
      model: result.model,
    };
  }

  async reviewWriting({ learnerText, candidate, language, profile }) {
    const messages = [
      {
        role: 'system',
        content: [
          '你是隐藏的 PhoenixQualityAgent，只负责审核中文写作批改。',
          '核对 corrected 是否只做必要修改，explanation 是否指出真实且最重要的问题，natural 是否自然但不改变原意，encouragement 是否具体而不空泛。',
          '不得虚构错误；原文正确时必须明确说明表达已正确，并解释可选的语体优化。',
          '如果质量不足，请重写完整 revisedFeedback；如果合格，原样返回。',
          '只输出符合 JSON Schema 的对象。',
        ].join('\n'),
      },
      {
        role: 'user',
        content: [
          `<learner_language>${language}</learner_language>`,
          `<learner_profile>${profileText(profile)}</learner_profile>`,
          `<learner_writing>${learnerText}</learner_writing>`,
          `<candidate_feedback>${JSON.stringify(candidate)}</candidate_feedback>`,
        ].join('\n'),
      },
    ];

    const result = await this.gateway.generateStructured({
      messages,
      schema: writingSchema,
      schemaName: 'phoenix_writing_quality',
      maxOutputTokens: 1300,
      reasoningEffort: 'medium',
      temperature: 0.1,
      purpose: 'quality-writing',
    });
    const review = result.value;
    const accepted =
      review.approved === true && Number(review.score) >= QUALITY_THRESHOLD;
    const revised = review.revisedFeedback;
    const validRevision =
      revised &&
      typeof revised.corrected === 'string' &&
      typeof revised.explanation === 'string' &&
      typeof revised.natural === 'string' &&
      typeof revised.encouragement === 'string';

    return {
      feedback: accepted || !validRevision ? candidate : revised,
      reviewed: true,
      approved: accepted,
      score: Number(review.score) || 0,
      issues: Array.isArray(review.issues) ? review.issues : [],
      provider: result.provider,
      model: result.model,
    };
  }
}

export { QUALITY_THRESHOLD, guideSchema, writingSchema };
