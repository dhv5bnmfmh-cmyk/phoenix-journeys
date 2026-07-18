import { handlePhoenixAi, MODEL } from './phoenix_ai.mjs';

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/api/health') {
      return Response.json(
        {
          ok: true,
          service: 'phoenix-journeys',
          ai: Boolean(env?.AI),
          model: MODEL,
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
