import { safeLanguage } from '../ai_model_utils.mjs';
import {
  PhoenixModelGateway,
  OPENAI_DEFAULT_MODEL,
  CLOUDFLARE_FALLBACK_MODEL,
} from '../ai/phoenix_model_gateway.mjs';
import { PhoenixQualityAgent } from './phoenix_quality_agent.mjs';

export const LEARNING_MODEL = OPENAI_DEFAULT_MODEL;
export const LEARNING_FALLBACK_MODEL = CLOUDFLARE_FALLBACK_MODEL;
export const LEARNING_LIMIT = 4000;

export const learningReportSchema = {
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
  properties: {
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
  },
};

export function buildLearningMessages({
  text,
  language,
  learnerProfile = {},
  knowledge = {},
}) {
  return [
    {
      role: 'system',
      content: [
        '你是 PhoenixLearningAgent，负责把学习记录整理成精确、可执行的中文学习建议。',
        '只根据本次内容、学习档案和 Phoenix knowledge 分析，不得虚构学习时长、正确率、考试成绩或不存在的错误。',
        '先识别真实优势，再选择最多四个高价值重点；下一步必须具体到学习者下一次能完成的动作。',
        'recommendedWords 优先选择学习档案或当前 Journey 中真正相关的词。',
        'recommendedPattern 只推荐一个最值得练习的句型，并给出简短模板。',
        `探索者辅助语言是：${safeLanguage(language)}。报告主体使用简体中文。`,
        '只输出符合 JSON Schema 的对象。',
      ].join('\n'),
    },
    {
      role: 'user',
      content: [
        `<phoenix_knowledge>${JSON.stringify(knowledge)}</phoenix_knowledge>`,
        `<learner_profile>${JSON.stringify(learnerProfile)}</learner_profile>`,
        `<latest_learning>${text}</latest_learning>`,
      ].join('\n'),
    },
  ];
}

function normalizeReport(value) {
  const report = value && typeof value === 'object' ? value : {};
  const list = (key) =>
    Array.isArray(report[key])
      ? report[key].filter((item) => typeof item === 'string' && item.trim())
      : [];
  const text = (key, fallback = '') =>
    typeof report[key] === 'string' && report[key].trim()
      ? report[key].trim()
      : fallback;

  return {
    summary: text('summary', '本次学习记录已整理。'),
    strengths: list('strengths'),
    focusAreas: list('focusAreas'),
    nextActions: list('nextActions'),
    recommendedWords: list('recommendedWords'),
    recommendedPattern: text('recommendedPattern'),
  };
}

export class PhoenixLearningAgent {
  constructor(env, { gateway } = {}) {
    this.gateway = gateway ?? new PhoenixModelGateway(env);
    this.quality = new PhoenixQualityAgent(this.gateway);
  }

  get isAvailable() {
    return this.gateway.isAvailable;
  }

  async analyze({
    text,
    language,
    learnerProfile = {},
    knowledge = {},
    journeyId = 'beijing-forbidden-city',
  }) {
    if (!this.isAvailable) {
      throw new Error('PhoenixLearningAgent is unavailable.');
    }

    const primary = await this.gateway.generateStructured({
      messages: buildLearningMessages({
        text,
        language,
        learnerProfile,
        knowledge,
      }),
      schema: learningReportSchema,
      schemaName: 'phoenix_learning_report',
      maxOutputTokens: 1700,
      reasoningEffort: 'medium',
      temperature: 0.15,
      purpose: 'learning',
    });
    const candidate = normalizeReport(primary.value);

    let quality = {
      report: candidate,
      reviewed: false,
      approved: false,
      score: 0,
      issues: [],
    };
    try {
      quality = await this.quality.reviewLearning({
        learnerText: text,
        candidate,
        knowledge,
        language: safeLanguage(language),
        profile: learnerProfile,
      });
    } catch (error) {
      console.error('PhoenixQualityAgent learning review failed', error);
    }

    return {
      agent: 'PhoenixLearningAgent',
      provider: primary.provider,
      model: primary.model,
      fallbackModel: LEARNING_FALLBACK_MODEL,
      journeyId,
      report: normalizeReport(quality.report),
      quality: {
        reviewed: quality.reviewed,
        approved: quality.approved,
        score: quality.score,
        issues: quality.issues,
      },
    };
  }
}

export { normalizeReport };
