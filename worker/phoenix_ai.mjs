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
import { PhoenixQualityAgent } from './agents/phoenix_quality_agent.mjs';
import { safeLanguage } from './ai_model_utils.mjs';
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
    .slice(-8)
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

function safeStringList(value, { limit = 8, itemLimit = 500 } = {}) {
  if (!Array.isArray(value)) return [];
  return value
    .filter((item) => typeof item === 'string' && item.trim())
    .slice(-limit)
    .map((item) => item.trim().slice(0, itemLimit));
}

function safeLearnerProfile(value) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {};
  return {
    interfaceLanguage:
      typeof value.interfaceLanguage === 'string'
        ? value.interfaceLanguage.slice(0, 40)
        : '',
    scriptMode:
      typeof value.scriptMode === 'string' ? value.scriptMode.slice(0, 24) : '',
    currentLevel:
      typeof value.currentLevel === 'string'
        ? value.currentLevel.slice(0, 80)
        : '根据本次文字动态判断',
    savedWords: safeStringList(value.savedWords, { limit: 40, itemLimit: 40 }),
    completedJourneys: safeStringList(value.completedJourneys, {
      limit: 24,
      itemLimit: 120,
    }),
    recentGuideObservations: safeStringList(value.recentGuideObservations, {
      limit: 8,
      itemLimit: 500,
    }),
    recentWritingInsights: safeStringList(value.recentWritingInsights, {
      limit: 8,
      itemLimit: 600,
    }),
  };
}

export function buildMessages(payload) {
  return payload.mode === 'guide'
    ? buildGuideMessages(payload)
    : buildWritingMessages(payload);
}

async function readPayload(request) {
  const contentLength = Number(request.headers.get('content-length') || 0);
  if (contentLength > 32000) {
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

  if (!['guide', 'writing'].includes(mode)) {
    throw new TypeError('不支持的 AI 模式。');
  }
  if (text.length < 2) {
    throw new TypeError('请先写下一点内容。');
  }

  const limit = mode === 'guide' ? GUIDE_LIMIT : WRITING_LIMIT;
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
    if (payload.mode === 'guide') {
      const result = await new PhoenixGuideAgent(env).respond(payload);
      return json({ mode: 'guide', ...result });
    }

    const result = await new PhoenixWritingAgent(env).review(payload);
    return json({ mode: 'writing', ...result });
  } catch (error) {
    console.error('Phoenix agent request failed', {
      mode: payload.mode,
      error,
    });

    const message = payload.mode === 'guide'
      ? 'AI 导游暂时没有回应，请稍后再试。'
      : 'AI 写作教练暂时没有回应，请稍后再试。';

    return json({ error: message }, 503);
  }
}

export {
  GUIDE_MODEL as MODEL,
  GUIDE_MODEL,
  WRITING_MODEL,
  GUIDE_FALLBACK_MODEL,
  WRITING_FALLBACK_MODEL,
  OPENAI_DEFAULT_MODEL,
  PhoenixGuideAgent,
  PhoenixWritingAgent,
  PhoenixQualityAgent,
  buildGuideMessages,
  buildWritingMessages,
  parseWritingFeedback,
  safeLearnerProfile,
};
