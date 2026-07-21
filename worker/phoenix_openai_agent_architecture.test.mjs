import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import {
  OpenAIResponsesProvider,
  OPENAI_DEFAULT_MODEL,
} from './ai/openai_responses_provider.mjs';
import {
  PhoenixModelGateway,
  CLOUDFLARE_FALLBACK_MODEL,
} from './ai/phoenix_model_gateway.mjs';
import { PhoenixQualityAgent } from './agents/phoenix_quality_agent.mjs';

const read = (path) => readFileSync(path, 'utf8');
const guide = read('worker/agents/phoenix_guide_agent.mjs');
const writing = read('worker/agents/phoenix_writing_agent.mjs');
const memory = read('worker/agents/phoenix_memory_agent.mjs');
const endpoint = read('worker/phoenix_ai.mjs');
const health = read('worker/index.mjs');
const appService = read('app/lib/services/phoenix_ai_service.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const cards = read('app/lib/widgets/phoenix_agent_cards.dart');
const workflow = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');

test('OpenAI Responses provider keeps the key server-side and disables storage', async () => {
  let request;
  const provider = new OpenAIResponsesProvider(
    { OPENAI_API_KEY: 'server-secret', OPENAI_MODEL: 'gpt-test' },
    {
      fetchImpl: async (url, init) => {
        request = { url, init };
        return new Response(
          JSON.stringify({
            model: 'gpt-test',
            output: [
              { content: [{ type: 'output_text', text: '更聪明的回答' }] },
            ],
          }),
          { status: 200, headers: { 'x-request-id': 'req_phoenix' } },
        );
      },
    },
  );

  const result = await provider.generate({
    messages: [
      { role: 'system', content: '系统规则' },
      { role: 'user', content: '学习内容' },
    ],
  });
  const body = JSON.parse(request.init.body);

  assert.equal(request.url, 'https://api.openai.com/v1/responses');
  assert.equal(request.init.headers.authorization, 'Bearer server-secret');
  assert.equal(body.store, false);
  assert.equal(body.model, 'gpt-test');
  assert.doesNotMatch(request.init.body, /server-secret/);
  assert.equal(result.output, '更聪明的回答');
  assert.equal(result.provider, 'openai');
});

test('model gateway prefers OpenAI and automatically falls back to Workers AI', async () => {
  const openaiGateway = new PhoenixModelGateway(
    { OPENAI_API_KEY: 'secret' },
    {
      fetchImpl: async () =>
        new Response(
          JSON.stringify({
            model: OPENAI_DEFAULT_MODEL,
            output: [{ content: [{ type: 'output_text', text: 'GPT result' }] }],
          }),
          { status: 200 },
        ),
    },
  );
  const primary = await openaiGateway.generate({
    messages: [{ role: 'user', content: 'hello' }],
  });
  assert.equal(primary.provider, 'openai');

  let fallbackCalls = 0;
  const fallbackGateway = new PhoenixModelGateway(
    {
      OPENAI_API_KEY: 'secret',
      AI: {
        run: async (model) => {
          fallbackCalls += 1;
          assert.equal(model, CLOUDFLARE_FALLBACK_MODEL);
          return { response: 'fallback result' };
        },
      },
    },
    {
      fetchImpl: async () =>
        new Response(JSON.stringify({ error: { message: 'temporary' } }), {
          status: 503,
        }),
    },
  );
  const fallback = await fallbackGateway.generate({
    messages: [{ role: 'user', content: 'hello' }],
  });
  assert.equal(fallback.provider, 'cloudflare');
  assert.equal(fallback.output, 'fallback result');
  assert.equal(fallbackCalls, 1);
});

test('hidden quality agent replaces weak guide and writing results', async () => {
  const outputs = [
    {
      value: {
        approved: false,
        score: 70,
        issues: ['过于模板化'],
        revisedReply: '这是针对学习者具体观察重写后的回答。',
      },
      provider: 'openai',
      model: 'gpt-test',
    },
    {
      value: {
        approved: false,
        score: 78,
        issues: ['解释不够具体'],
        revisedFeedback: {
          corrected: '修改后',
          explanation: '具体解释',
          natural: '自然表达',
          encouragement: '具体鼓励',
        },
      },
      provider: 'openai',
      model: 'gpt-test',
    },
  ];
  const quality = new PhoenixQualityAgent({
    generateStructured: async () => outputs.shift(),
  });

  const guideReview = await quality.reviewGuide({
    learnerText: '我喜欢红墙',
    candidate: '很好，继续观察。',
    journey: {},
    language: '越南语',
    profile: {},
  });
  assert.equal(guideReview.reviewed, true);
  assert.match(guideReview.reply, /具体观察/);

  const writingReview = await quality.reviewWriting({
    learnerText: '原文',
    candidate: {
      corrected: '原文',
      explanation: '很好',
      natural: '原文',
      encouragement: '加油',
    },
    language: '越南语',
    profile: {},
  });
  assert.equal(writingReview.feedback.explanation, '具体解释');
});

test('Guide and Writing are expert agents with a hidden quality pass', () => {
  assert.match(guide, /new PhoenixModelGateway/);
  assert.match(guide, /new PhoenixQualityAgent/);
  assert.match(guide, /reviewGuide/);
  assert.match(guide, /避免.*模板/);
  assert.match(writing, /new PhoenixModelGateway/);
  assert.match(writing, /new PhoenixQualityAgent/);
  assert.match(writing, /reviewWriting/);
  assert.match(writing, /不得为了.*制造错误/);
  assert.match(writing, /writingFeedbackSchema/);
});

test('learner memory is sanitized, sent by Flutter, and used by both agents', () => {
  assert.match(endpoint, /safeLearnerProfile/);
  assert.match(memory, /savedWords/);
  assert.match(memory, /completedJourneys/);
  assert.match(memory, /recentGuideObservations/);
  assert.match(memory, /recentWritingInsights/);
  assert.match(memory, /storage: 'client-private'/);
  assert.match(memory, /serverPersisted: false/);
  assert.match(appService, /learnerProfile/);
  assert.match(journey, /_aiLearnerProfile/);
  assert.match(journey, /_appState\.savedWords/);
  assert.match(journey, /_appState\.earnedJourneyStampIds/);
  assert.match(guide, /learner_profile/);
  assert.match(writing, /learner_profile/);
});

test('health and UI truthfully expose provider and quality status', () => {
  assert.match(health, /openaiConfigured/);
  assert.match(health, /cloudflareFallbackConfigured/);
  assert.match(health, /qualityAgent: true/);
  assert.match(appService, /qualityReviewed/);
  assert.match(cards, /GPT · 已复核/);
  assert.match(cards, /AI · 已复核/);
  assert.match(cards, /本地建议/);
});

test('permanent workflow forbids leaked secrets and unreviewed AI changes', () => {
  assert.match(workflow, /永久 AI Agent 开发准则/);
  assert.match(workflow, /OpenAI Responses API/);
  assert.match(workflow, /Cloudflare Workers AI/);
  assert.match(workflow, /PhoenixQualityAgent/);
  assert.match(workflow, /OPENAI_API_KEY/);
  assert.match(template, /OpenAI Responses API/);
  assert.match(template, /PhoenixQualityAgent/);
  assert.match(template, /OPENAI_API_KEY/);
});
