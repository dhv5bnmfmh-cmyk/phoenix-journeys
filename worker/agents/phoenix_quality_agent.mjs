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

const writingFeedbackProperties = {
  corrected: { type: 'string' },
  explanation: { type: 'string' },
  natural: { type: 'string' },
  encouragement: { type: 'string' },
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
      properties: writingFeedbackProperties,
    },
  },
};

const conversationSchema = {
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

const learningReportProperties = {
  summary: { type: 'string' },
  strengths: {
    type: 'array',
    maxItems: 4,
    items: { type: 'string' },
  },
  focusAreas: {
    type: 'array',
    maxItems: 4,
    items: { type: 'string' },
  },
  nextActions: {
    type: 'array',
    maxItems: 5,
    items: { type: 'string' },
  },
  recommendedWords: {
    type: 'array',
    maxItems: 8,
    items: { type: 'string' },
  },
  recommendedPattern: { type: 'string' },
};

const learningSchema = {
  type: 'object',
  additionalProperties: false,
  required: ['approved', 'score', 'issues', 'revisedReport'],
  properties: {
    approved: { type: 'boolean' },
    score: { type: 'integer', minimum: 0, maximum: 100 },
    issues: {
      type: 'array',
      maxItems: 6,
      items: { type: 'string' },
    },
    revisedReport: {
      type: 'object',
      additionalProperties: false,
      required: [
        'summary',
        'strengths',
        'focusAreas',
        'nextActions',
        'recommendedWords',
        'recommendedPattern',
      ],
      properties: learningReportProperties,
    },
  },
};

const vocabularyExampleProperties = {
  chinese: { type: 'string' },
  pinyin: { type: 'string' },
  native: { type: 'string' },
  english: { type: 'string' },
  usageNote: { type: 'string' },
};

const vocabularySchema = {
  type: 'object',
  additionalProperties: false,
  required: ['approved', 'score', 'issues', 'revisedExample'],
  properties: {
    approved: { type: 'boolean' },
    score: { type: 'integer', minimum: 0, maximum: 100 },
    issues: {
      type: 'array',
      maxItems: 6,
      items: { type: 'string' },
    },
    revisedExample: {
      type: 'object',
      additionalProperties: false,
      required: ['chinese', 'pinyin', 'native', 'english', 'usageNote'],
      properties: vocabularyExampleProperties,
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

function qualityResult(review) {
  return {
    reviewed: true,
    approved:
      review?.approved === true &&
      Number(review?.score) >= QUALITY_THRESHOLD,
    score: Number(review?.score) || 0,
    issues: Array.isArray(review?.issues) ? review.issues : [],
  };
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
    const status = qualityResult(review);
    const revised = typeof review.revisedReply === 'string'
      ? review.revisedReply.trim()
      : '';

    return {
      reply: status.approved || !revised ? candidate : revised,
      ...status,
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
    const status = qualityResult(review);
    const revised = review.revisedFeedback;
    const validRevision =
      revised &&
      typeof revised.corrected === 'string' &&
      typeof revised.explanation === 'string' &&
      typeof revised.natural === 'string' &&
      typeof revised.encouragement === 'string';

    return {
      feedback: status.approved || !validRevision ? candidate : revised,
      ...status,
      provider: result.provider,
      model: result.model,
    };
  }

  async reviewConversation({ learnerText, candidate, knowledge, language, profile }) {
    const result = await this.gateway.generateStructured({
      messages: [
        {
          role: 'system',
          content: [
            '你是隐藏的 PhoenixQualityAgent，只审核中文口语陪练回复。',
            '回复必须自然、像真实对话，紧扣学习者刚说的话，并推动下一轮表达。',
            '避免连续提问、机械称赞、过度纠错和超出 Phoenix 知识背景的事实。',
            '不合格时给出完整 revisedReply；合格时原样返回。',
            '只输出符合 JSON Schema 的对象。',
          ].join('\n'),
        },
        {
          role: 'user',
          content: [
            `<knowledge>${JSON.stringify(knowledge ?? {})}</knowledge>`,
            `<learner_language>${language}</learner_language>`,
            `<learner_profile>${profileText(profile)}</learner_profile>`,
            `<learner_text>${learnerText}</learner_text>`,
            `<candidate_reply>${candidate}</candidate_reply>`,
          ].join('\n'),
        },
      ],
      schema: conversationSchema,
      schemaName: 'phoenix_conversation_quality',
      maxOutputTokens: 850,
      reasoningEffort: 'medium',
      temperature: 0.12,
      purpose: 'quality-conversation',
    });
    const review = result.value;
    const status = qualityResult(review);
    const revised = typeof review.revisedReply === 'string'
      ? review.revisedReply.trim()
      : '';

    return {
      reply: status.approved || !revised ? candidate : revised,
      ...status,
      provider: result.provider,
      model: result.model,
    };
  }

  async reviewLearning({ learnerText, candidate, knowledge, language, profile }) {
    const result = await this.gateway.generateStructured({
      messages: [
        {
          role: 'system',
          content: [
            '你是隐藏的 PhoenixQualityAgent，只审核中文学习报告。',
            '报告必须依据提供的学习档案和本次内容，不得虚构学习时长、考试分数或错误。',
            '建议必须少而具体，能在下一次学习中执行，并适合学习者当前水平。',
            '不合格时重写完整 revisedReport；合格时原样返回。',
            '只输出符合 JSON Schema 的对象。',
          ].join('\n'),
        },
        {
          role: 'user',
          content: [
            `<knowledge>${JSON.stringify(knowledge ?? {})}</knowledge>`,
            `<learner_language>${language}</learner_language>`,
            `<learner_profile>${profileText(profile)}</learner_profile>`,
            `<learner_text>${learnerText}</learner_text>`,
            `<candidate_report>${JSON.stringify(candidate)}</candidate_report>`,
          ].join('\n'),
        },
      ],
      schema: learningSchema,
      schemaName: 'phoenix_learning_quality',
      maxOutputTokens: 1500,
      reasoningEffort: 'medium',
      temperature: 0.08,
      purpose: 'quality-learning',
    });
    const review = result.value;
    const status = qualityResult(review);
    const revised = review.revisedReport;
    const validRevision =
      revised &&
      typeof revised.summary === 'string' &&
      Array.isArray(revised.strengths) &&
      Array.isArray(revised.focusAreas) &&
      Array.isArray(revised.nextActions) &&
      Array.isArray(revised.recommendedWords) &&
      typeof revised.recommendedPattern === 'string';

    return {
      report: status.approved || !validRevision ? candidate : revised,
      ...status,
      provider: result.provider,
      model: result.model,
    };
  }

  async reviewVocabulary({
    word,
    meaning,
    partOfSpeech,
    context,
    candidate,
    language,
  }) {
    const result = await this.gateway.generateStructured({
      messages: [
        {
          role: 'system',
          content: [
            '你是隐藏的 PhoenixQualityAgent，只审核 PhoenixVocabularyAgent 生成的实际应用例句。',
            '中文句子必须自然包含目标词，并准确体现给定词义和词性，而不是讨论“这个词”本身。',
            '禁止“故事里出现了”“老师请我解释”“我想学会使用”等模板占位句。',
            '核对完整拼音、探索者语言翻译和英文翻译是否与中文一致；usageNote 必须提供真实搭配、语体或限制。',
            '不得编造提供语境之外的历史年代、人物、数字或事件。',
            '不合格时重写完整 revisedExample；合格时原样返回。',
            '只输出符合 JSON Schema 的对象。',
          ].join('\n'),
        },
        {
          role: 'user',
          content: [
            `<word>${word}</word>`,
            `<meaning>${meaning}</meaning>`,
            `<part_of_speech>${partOfSpeech}</part_of_speech>`,
            `<journey_context>${context}</journey_context>`,
            `<learner_language>${language}</learner_language>`,
            `<candidate_example>${JSON.stringify(candidate)}</candidate_example>`,
          ].join('\n'),
        },
      ],
      schema: vocabularySchema,
      schemaName: 'phoenix_vocabulary_quality',
      maxOutputTokens: 850,
      reasoningEffort: 'medium',
      temperature: 0.08,
      purpose: 'quality-vocabulary',
    });
    const review = result.value;
    const status = qualityResult(review);
    const revised = review.revisedExample;
    const validRevision =
      revised &&
      typeof revised.chinese === 'string' &&
      revised.chinese.includes(word) &&
      typeof revised.pinyin === 'string' &&
      typeof revised.native === 'string' &&
      typeof revised.english === 'string' &&
      typeof revised.usageNote === 'string';

    return {
      example: status.approved || !validRevision ? candidate : revised,
      ...status,
      provider: result.provider,
      model: result.model,
    };
  }
}

export {
  QUALITY_THRESHOLD,
  guideSchema,
  writingSchema,
  conversationSchema,
  learningSchema,
  learningReportProperties,
  vocabularySchema,
  vocabularyExampleProperties,
};
