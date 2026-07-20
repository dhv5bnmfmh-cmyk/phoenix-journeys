import {
  handlePhoenixAi,
  MODEL,
  GUIDE_FALLBACK_MODEL,
} from './phoenix_ai.mjs';

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/api/health') {
      const openaiConfigured = Boolean(
        typeof env?.OPENAI_API_KEY === 'string' && env.OPENAI_API_KEY.trim(),
      );
      const cloudflareConfigured = Boolean(env?.AI);
      return Response.json(
        {
          ok: true,
          service: 'phoenix-journeys',
          ai: openaiConfigured || cloudflareConfigured,
          aiProvider: openaiConfigured
            ? 'openai'
            : cloudflareConfigured
              ? 'cloudflare'
              : 'none',
          openaiConfigured,
          cloudflareFallbackConfigured: cloudflareConfigured,
          qualityAgent: true,
          learningMemory: true,
          model:
            (typeof env?.OPENAI_MODEL === 'string' && env.OPENAI_MODEL.trim()) ||
            MODEL,
          fallbackModel: GUIDE_FALLBACK_MODEL,
          release: env?.PHOENIX_RELEASE ?? 'local',
        },
        {
          headers: {
            'cache-control': 'no-store',
            'x-content-type-options': 'nosniff',
          },
        },
      );
    }

    if (url.pathname === '/api/phoenix-ai') {
      return handlePhoenixAi(request, env);
    }

    if (!env?.ASSETS || typeof env.ASSETS.fetch !== 'function') {
      return new Response('Phoenix Journeys assets are unavailable.', {
        status: 503,
      });
    }

    return env.ASSETS.fetch(request);
  },
};
