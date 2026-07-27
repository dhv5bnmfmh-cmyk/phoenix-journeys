import { safeLanguage } from '../ai_model_utils.mjs';
import {
  PhoenixModelGateway,
  OPENAI_DEFAULT_MODEL,
  CLOUDFLARE_FALLBACK_MODEL,
} from '../ai/phoenix_model_gateway.mjs';
import { PhoenixQualityAgent } from './phoenix_quality_agent.mjs';

export const VOCABULARY_MODEL = OPENAI_DEFAULT_MODEL;
export const VOCABULARY_FALLBACK_MODEL = CLOUDFLARE_FALLBACK_MODEL;
export const VOCABULARY_LIMIT = 120;

export const vocabularyExampleSchema = {
  type: 'object',
  additionalProperties: false,
  required: ['chinese', 'pinyin', 'native', 'english', 'usageNote'],
  properties: {
    chinese: { type: 'string' },
    pinyin: { type: 'string' },
    native: { type: 'string' },
    english: { type: 'string' },
    usageNote: { type: 'string' },
  },
};

export function buildVocabularyMessages({
  word,
  pinyin,
  partOfSpeech,
  simpleChinese,
  nativeDefinition,
  englishDefinition,
  contextChinese,
  contextPinyin,
  contextNative,
  contextEnglish,
  language,
  knowledge = {},
}) {
  return [
    {
      role: 'system',
      content: [
        '你是 PhoenixVocabularyAgent，专门为成年中文学习者查询并生成词语的真实应用例句。',
        '例句必须像母语者在旅行、工作、生活或文化交流中真的会说或写的句子，并准确体现指定词义和词性。',
        '中文例句必须自然包含目标词，建议 12–32 个汉字；不要为了塞入词语而写生硬句子。',
        '禁止使用“故事里出现了这个词”“老师请我解释这个词”“我想学会使用这个词”及任何讨论词语本身的占位句。',
        '不要编造当前 Journey 资料之外的年代、人物、数字或历史事实；可借鉴提供的旅程语境，但应生成新的实际应用句。',
        '拼音必须覆盖完整中文例句并带声调；native 必须使用探索者辅助语言；English 必须准确自然。',
        'usageNote 用简体中文说明一个最有价值的搭配、语体或使用限制，控制在一句话内。',
        `探索者辅助语言是：${safeLanguage(language)}。`,
        '只输出符合 JSON Schema 的对象。',
      ].join('\n'),
    },
    {
      role: 'user',
      content: [
        `<word>${word}</word>`,
        `<word_pinyin>${pinyin}</word_pinyin>`,
        `<part_of_speech>${partOfSpeech}</part_of_speech>`,
        `<simple_chinese_definition>${simpleChinese}</simple_chinese_definition>`,
        `<native_definition>${nativeDefinition}</native_definition>`,
        `<english_definition>${englishDefinition}</english_definition>`,
        `<journey_context_chinese>${contextChinese}</journey_context_chinese>`,
        `<journey_context_pinyin>${contextPinyin}</journey_context_pinyin>`,
        `<journey_context_native>${contextNative}</journey_context_native>`,
        `<journey_context_english>${contextEnglish}</journey_context_english>`,
        `<phoenix_knowledge>${JSON.stringify(knowledge ?? {})}</phoenix_knowledge>`,
      ].join('\n'),
    },
  ];
}

export function normalizeVocabularyExample(value, word = '') {
  const source = value && typeof value === 'object' ? value : {};
  const read = (key) =>
    typeof source[key] === 'string' ? source[key].trim() : '';
  const example = {
    chinese: read('chinese'),
    pinyin: read('pinyin'),
    native: read('native'),
    english: read('english'),
    usageNote: read('usageNote'),
  };

  if (
    !example.chinese ||
    !example.pinyin ||
    !example.native ||
    !example.english ||
    !example.usageNote ||
    (word && !example.chinese.includes(word))
  ) {
    throw new TypeError('PhoenixVocabularyAgent returned an incomplete example.');
  }
  return example;
}

export class PhoenixVocabularyAgent {
  constructor(env, { gateway } = {}) {
    this.gateway = gateway ?? new PhoenixModelGateway(env);
    this.quality = new PhoenixQualityAgent(this.gateway);
  }

  get isAvailable() {
    return this.gateway.isAvailable;
  }

  async generate(payload) {
    if (!this.isAvailable) {
      throw new Error('PhoenixVocabularyAgent is unavailable.');
    }

    const primary = await this.gateway.generateStructured({
      messages: buildVocabularyMessages(payload),
      schema: vocabularyExampleSchema,
      schemaName: 'phoenix_vocabulary_example',
      maxOutputTokens: 700,
      reasoningEffort: 'medium',
      temperature: 0.25,
      purpose: 'vocabulary',
    });
    const candidate = normalizeVocabularyExample(primary.value, payload.word);

    let quality = {
      example: candidate,
      reviewed: false,
      approved: false,
      score: 0,
      issues: [],
    };
    try {
      quality = await this.quality.reviewVocabulary({
        word: payload.word,
        meaning: payload.simpleChinese,
        partOfSpeech: payload.partOfSpeech,
        context: payload.contextChinese,
        candidate,
        language: safeLanguage(payload.language),
      });
    } catch (error) {
      console.error('PhoenixQualityAgent vocabulary review failed', error);
    }

    return {
      agent: 'PhoenixVocabularyAgent',
      provider: primary.provider,
      model: primary.model,
      fallbackModel: VOCABULARY_FALLBACK_MODEL,
      journeyId: payload.journeyId,
      example: normalizeVocabularyExample(quality.example, payload.word),
      quality: {
        reviewed: quality.reviewed,
        approved: quality.approved,
        score: quality.score,
        issues: quality.issues,
      },
    };
  }
}
