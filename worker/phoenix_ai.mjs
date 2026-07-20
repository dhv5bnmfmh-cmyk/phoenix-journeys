import {
  PhoenixGuideAgent,
  GUIDE_LIMIT,
  GUIDE_MODEL,
  GUIDE_FALLBACK_MODEL,
  buildGuideMessages,
} from './agents/phoenix_guide_agent.mjs';
import {
  PhoenixWritingAgent,
  WRITING_LIMIT,
  WRITING_MODEL,
  WRITING_FALLBACK_MODEL,
  buildWritingMessages,
  parseWritingFeedback,
} from './agents/phoenix_writing_agent.mjs';
import {
  PhoenixConversationAgent,
  CONVERSATION_LIMIT,
  CONVERSATION_MODEL,
  CONVERSATION_FALLBACK_MODEL,
  buildConversationMessages,
} from './agents/phoenix_conversation_agent.mjs';
import {
  PhoenixLearningAgent,
  LEARNING_LIMIT,
  LEARNING_MODEL,
  LEARNING_FALLBACK_MODEL,
  buildLearningMessages,
  learningReportSchema,
} from './agents/phoenix_learning_agent.mjs';
import {
  PhoenixBrainAgent,
  PHOENIX_AI_MODES,
} from './agents/phoenix_brain_agent.mjs';
import {
  PhoenixMemoryAgent,
  safeLearnerProfile,
} from './agents/phoenix_memory_agent.mjs';
import { PhoenixKnowledgeAgent } from './agents/phoenix_knowledge_agent.mjs';
import { PhoenixQualityAgent } from './agents/phoenix_quality_agent.mjs';
import { extractModelOutput, safeLanguage } from './ai_model_utils.mjs';
import { OPENAI_DEFAULT_MODEL } from './ai/openai_responses_provider.mjs';

function json(data, status = 200) {
  return Response.json(data, {
    status,
    headers: {
      'cache-control': 'no-store',
      'x-content-type-options': 'nosniff',
    },
  });
}

function safeConversation(value) {
  if (!Array.isArray(value)) return [];

  return value
    .slice(-10)
    .filter(
      (item) =>
        item &&
        ['user', 'assistant'].includes(item.role) &&
        typeof item.content === 'string' &&
        item.content.trim(),
    )
    .map((item) => ({
      role: item.role,
      content: item.content.trim().slice(0, 1000),
    }));
}

const MODE_LIMITS = {
  guide: GUIDE_LIMIT,
  writing: WRITING_LIMIT,
  conversation: CONVERSATION_LIMIT,
  learning: LEARNING_LIMIT,
};

export function buildMessages(payload) {
  switch (payload.mode) {
    case 'guide':
      return buildGuideMessages(payload);
    case 'writing':
      return buildWritingMessages(payload);
    case 'conversation':
      return buildConversationMessages(payload);
    case 'learning':
      return buildLearningMessages(payload);
    default:
      throw new TypeError('不支持的 AI 模式。');
  }
}

async function readPayload(request) {
  const contentLength = Number(request.headers.get('content-length') || 0);
  if (contentLength > 40000) {
    throw new RangeError('请求内容过长。');
  }

  const body = await request.json();
  const mode = body?.mode;
  const text = typeof body?.text === 'string' ? body.text.trim() : '';
  const language = safeLanguage(body?.language);
  const journeyId =
    typeof body?.journeyId === 'string' && body.journeyId.trim()
      ? body.journeyId.trim().slice(0, 120)
      : 'beijing-forbidden-city';
  const conversation = safeConversation(body?.conversation);
  const learnerProfile = safeLearnerProfile(body?.learnerProfile);

  if (!PHOENIX_AI_MODES.includes(mode)) {
    throw new TypeError('不支持的 AI 模式。');
  }
  if (text.length < 2) {
    throw new TypeError('请先写下一点内容。');
  }

  const limit = MODE_LIMITS[mode];
  if (text.length > limit) {
    throw new RangeError(`内容请控制在 ${limit} 个字符以内。`);
  }

  return {
    mode,
    text,
    language,
    journeyId,
    conversation,
    learnerProfile,
  };
}

const ERROR_MESSAGES = {
  guide: 'AI 导游暂时没有回应，请稍后再试。',
  writing: 'AI 写作教练暂时没有回应，请稍后再试。',
  conversation: 'AI 口语伙伴暂时没有回应，请稍后再试。',
  learning: 'AI 学习分析暂时没有回应，请稍后再试。',
};

export async function handlePhoenixAi(request, env) {
  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204 });
  }

  if (request.method !== 'POST') {
    return json({ error: '请使用 POST 请求。' }, 405);
  }

  let payload;
  try {
    payload = await readPayload(request);
  } catch (error) {
    if (error instanceof SyntaxError) {
      return json({ error: '请求格式不正确。' }, 400);
    }
    if (error instanceof TypeError || error instanceof RangeError) {
      return json({ error: error.message }, 400);
    }
    return json({ error: '无法读取请求。' }, 400);
  }

  try {
    const result = await new PhoenixBrainAgent(env).run(payload);
    return json({ mode: payload.mode, ...result });
  } catch (error) {
    console.error('Phoenix agent request failed', {
      mode: payload.mode,
      error,
    });

    return json(
      { error: ERROR_MESSAGES[payload.mode] ?? 'Phoenix AI 暂时没有回应。' },
      503,
    );
  }
}

export {
  GUIDE_MODEL as MODEL,
  GUIDE_MODEL,
  WRITING_MODEL,
  CONVERSATION_MODEL,
  LEARNING_MODEL,
  GUIDE_FALLBACK_MODEL,
  WRITING_FALLBACK_MODEL,
  CONVERSATION_FALLBACK_MODEL,
  LEARNING_FALLBACK_MODEL,
  OPENAI_DEFAULT_MODEL,
  PhoenixBrainAgent,
  PhoenixGuideAgent,
  PhoenixWritingAgent,
  PhoenixConversationAgent,
  PhoenixLearningAgent,
  PhoenixMemoryAgent,
  PhoenixKnowledgeAgent,
  PhoenixQualityAgent,
  PHOENIX_AI_MODES,
  buildGuideMessages,
  buildWritingMessages,
  buildConversationMessages,
  buildLearningMessages,
  learningReportSchema,
  extractModelOutput,
  parseWritingFeedback,
  safeLearnerProfile,
};
