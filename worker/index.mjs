import {
  handlePhoenixAi,
  MODEL,
  GUIDE_FALLBACK_MODEL,
} from './phoenix_ai.mjs';

function diagnosticSession(value) {
  const session = `${value ?? ''}`.trim();
  return /^[A-Za-z0-9._-]{1,80}$/.test(session) ? session : null;
}

function diagnosticCacheKey(request, session, sequence) {
  const key = new URL(request.url);
  key.pathname = `/__pj_diagnostic/${session}/${sequence}`;
  key.search = '';
  return new Request(key.toString(), { method: 'GET' });
}

async function handlePhoenixDiagnostic(request) {
  const url = new URL(request.url);
  const session = diagnosticSession(url.searchParams.get('session'));
  if (!session) {
    return Response.json({ ok: false, error: 'invalid-session' }, { status: 400 });
  }

  const cache = caches.default;
  if (request.method === 'GET') {
    const events = [];
    for (let sequence = 1; sequence <= 24; sequence += 1) {
      const cached = await cache.match(diagnosticCacheKey(request, session, sequence));
      if (!cached) continue;
      events.push(await cached.json());
    }
    events.sort((a, b) => Number(a.sequence ?? 0) - Number(b.sequence ?? 0));
    return Response.json(
      { ok: true, session, events },
      { headers: { 'cache-control': 'no-store', 'x-content-type-options': 'nosniff' } },
    );
  }

  if (request.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  let event;
  try {
    event = await request.json();
  } catch (_) {
    return Response.json({ ok: false, error: 'invalid-json' }, { status: 400 });
  }
  const sequence = Number(event?.sequence);
  if (!Number.isInteger(sequence) || sequence < 1 || sequence > 24) {
    return Response.json({ ok: false, error: 'invalid-sequence' }, { status: 400 });
  }
  const stored = {
    ...event,
    sequence,
    receivedAt: new Date().toISOString(),
  };
  await cache.put(
    diagnosticCacheKey(request, session, sequence),
    new Response(JSON.stringify(stored), {
      headers: {
        'content-type': 'application/json; charset=utf-8',
        'cache-control': 'public, max-age=3600',
      },
    }),
  );
  return Response.json({ ok: true, session, sequence });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (
      url.hostname.startsWith('phoenix-journeys-pr-129.') &&
      url.pathname === '/' &&
      (url.searchParams.get('unlock') !== 'all' ||
        url.searchParams.get('prototype') !== 'journeys' ||
        url.searchParams.get('v') !== '211086ef')
    ) {
      const canonical = new URL(url.origin);
      canonical.searchParams.set('unlock', 'all');
      canonical.searchParams.set('prototype', 'journeys');
      canonical.searchParams.set('v', '211086ef');
      return Response.redirect(canonical.toString(), 308);
    }

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
          aiVersion: '2.0',
          aiProvider: openaiConfigured
            ? 'openai'
            : cloudflareConfigured
              ? 'cloudflare'
              : 'none',
          openaiConfigured,
          cloudflareFallbackConfigured: cloudflareConfigured,
          brainAgent: true,
          guideAgent: true,
          writingAgent: true,
          conversationAgent: true,
          learningAgent: true,
          vocabularyAgent: true,
          qualityAgent: true,
          memoryAgent: true,
          knowledgeAgent: true,
          memoryStorage: 'client-private',
          serverMemoryPersisted: false,
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

    if (url.pathname === '/api/diagnostic') {
      return handlePhoenixDiagnostic(request);
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
