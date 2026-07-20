import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import {
  PhoenixBrainAgent,
  PHOENIX_AI_MODES,
} from './agents/phoenix_brain_agent.mjs';
import {
  PhoenixMemoryAgent,
  safeLearnerProfile,
} from './agents/phoenix_memory_agent.mjs';
import { PhoenixKnowledgeAgent } from './agents/phoenix_knowledge_agent.mjs';
import { OPENAI_DEFAULT_MODEL } from './ai/openai_responses_provider.mjs';

const read = (path) => readFileSync(path, 'utf8');
const brainSource = read('worker/agents/phoenix_brain_agent.mjs');
const conversationSource = read('worker/agents/phoenix_conversation_agent.mjs');
const learningSource = read('worker/agents/phoenix_learning_agent.mjs');
const qualitySource = read('worker/agents/phoenix_quality_agent.mjs');
const endpoint = read('worker/phoenix_ai.mjs');
const health = read('worker/index.mjs');
const appService = read('app/lib/services/phoenix_ai_service.dart');
const workflow = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');

test('PhoenixBrainAgent is the only orchestrator for all four specialist modes', async () => {
  assert.deepEqual(PHOENIX_AI_MODES, [
    'guide',
    'writing',
    'conversation',
    'learning',
  ]);

  const brain = new PhoenixBrainAgent({}, { gateway: { isAvailable: true } });
  const calls = [];
  brain.guide = { respond: async (payload) => (calls.push(payload.mode), { agent: 'guide' }) };
  brain.writing = { review: async (payload) => (calls.push(payload.mode), { agent: 'writing' }) };
  brain.conversation = { respond: async (payload) => (calls.push(payload.mode), { agent: 'conversation' }) };
  brain.learning = { analyze: async (payload) => (calls.push(payload.mode), { agent: 'learning' }) };

  for (const mode of PHOENIX_AI_MODES) {
    const result = await brain.run({
      mode,
      text: '学习内容',
      language: '越南语',
      journeyId: 'beijing-forbidden-city',
      learnerProfile: { savedWords: ['红墙'] },
    });
    assert.equal(result.orchestrator, 'PhoenixBrainAgent');
    assert.equal(result.memory.agent, 'PhoenixMemoryAgent');
    assert.equal(result.knowledge.agent, 'PhoenixKnowledgeAgent');
  }
  assert.deepEqual(calls, PHOENIX_AI_MODES);
});

test('PhoenixMemoryAgent bounds client-private memory and never persists it server-side', () => {
  const profile = safeLearnerProfile({
    savedWords: Array.from({ length: 70 }, (_, index) => `词${index}`),
    completedJourneys: ['beijing-forbidden-city'],
    recentGuideObservations: ['观察'.repeat(700)],
    recentWritingInsights: ['语法'.repeat(700)],
  });
  assert.equal(profile.savedWords.length, 40);
  assert.ok(profile.recentGuideObservations[0].length <= 500);
  assert.ok(profile.recentWritingInsights[0].length <= 600);

  const prepared = new PhoenixMemoryAgent().prepare(profile);
  assert.equal(prepared.metadata.storage, 'client-private');
  assert.equal(prepared.metadata.serverPersisted, false);
});

test('PhoenixKnowledgeAgent grounds every specialist in reviewed Journey context', () => {
  const knowledge = new PhoenixKnowledgeAgent().ground('hangzhou-west-lake');
  assert.equal(knowledge.journey.city, '杭州');
  assert.equal(knowledge.journey.place, '西湖');
  assert.equal(knowledge.metadata.grounded, true);
  assert.equal(knowledge.metadata.source, 'phoenix-reviewed-journey-catalog');
  assert.match(knowledge.boundaries.join(''), /不得猜测/);
});

test('Conversation and Learning both use the model gateway and hidden quality review', () => {
  assert.match(conversationSource, /PhoenixModelGateway/);
  assert.match(conversationSource, /PhoenixQualityAgent/);
  assert.match(conversationSource, /reviewConversation/);
  assert.match(learningSource, /PhoenixModelGateway/);
  assert.match(learningSource, /PhoenixQualityAgent/);
  assert.match(learningSource, /reviewLearning/);
  assert.match(learningSource, /learningReportSchema/);
  assert.match(qualitySource, /conversationSchema/);
  assert.match(qualitySource, /learningSchema/);
});

test('endpoint, health and Flutter expose the complete AI 2 capability set', () => {
  for (const mode of ['guide', 'writing', 'conversation', 'learning']) {
    assert.ok(endpoint.includes(`'${mode}'`));
  }
  assert.match(endpoint, /new PhoenixBrainAgent\(env\)\.run\(payload\)/);
  assert.match(health, /aiVersion: '2\.0'/);
  assert.match(health, /brainAgent: true/);
  assert.match(health, /conversationAgent: true/);
  assert.match(health, /learningAgent: true/);
  assert.match(health, /memoryStorage: 'client-private'/);
  assert.match(appService, /Future<PhoenixConversationFeedback> practiceConversation/);
  assert.match(appService, /Future<PhoenixLearningReport> buildLearningReport/);
});

test('GPT-5.6 is primary while Cloudflare remains the automatic fallback', () => {
  assert.equal(OPENAI_DEFAULT_MODEL, 'gpt-5.6');
  assert.match(workflow, /默认使用 OpenAI Responses API 的 `gpt-5\.6`/);
  assert.match(workflow, /自动回退 Cloudflare Workers AI/);
  assert.match(template, /GPT-5\.6/);
});

test('permanent rules protect orchestration, privacy, grounding and quality', () => {
  assert.match(brainSource, /PhoenixMemoryAgent/);
  assert.match(brainSource, /PhoenixKnowledgeAgent/);
  assert.match(workflow, /PhoenixBrainAgent 是唯一 AI 总调度入口/);
  assert.match(workflow, /服务器不得持久保存学习记忆/);
  assert.match(workflow, /只提供 Phoenix 已审核 Journey 背景/);
  assert.match(workflow, /Guide、Writing、Conversation 和 Learning/);
  assert.match(template, /PhoenixBrainAgent 是唯一 AI 总调度入口/);
  assert.match(template, /服务器不持久保存/);
});
