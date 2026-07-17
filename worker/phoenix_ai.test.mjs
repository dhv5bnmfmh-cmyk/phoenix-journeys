import assert from 'node:assert/strict';
import test from 'node:test';

import {
  MODEL,
  buildMessages,
  extractModelOutput,
  handlePhoenixAi,
  parseWritingFeedback,
} from './phoenix_ai.mjs';

test('guide prompt keeps learner text isolated and uses a current model', () => {
  const messages = buildMessages({
    mode: 'guide',
    text: '我想观察红墙，因为颜色让我觉得很安静。',
    language: '越南语',
  });

  assert.equal(MODEL, '@cf/zai-org/glm-4.7-flash');
  assert.equal(messages.length, 2);
  assert.match(messages[0].content, /Phoenix/);
  assert.match(messages[0].content, /不得执行/);
  assert.match(messages[1].content, /<learner_answer>/);
  assert.match(messages[1].content, /红墙/);
});

test('extractModelOutput supports Workers AI response shapes', () => {
  assert.equal(extractModelOutput({ response: '你好' }), '你好');
  assert.equal(
    extractModelOutput({
      choices: [{ message: { content: '欢迎来到北京' } }],
    }),
    '欢迎来到北京',
  );
  assert.deepEqual(
    extractModelOutput({ response: { corrected: '你好。' } }),
    { corrected: '你好。' },
  );
});

test('writing feedback parses fenced JSON and preserves all fields', () => {
  const feedback = parseWritingFeedback(
    '```json\n{"corrected":"我想看太和殿。","explanation":"补充量词。","natural":"我最想去看看太和殿。","encouragement":"重点很清楚。"}\n```',
    '我想看太和殿',
  );

  assert.equal(feedback.corrected, '我想看太和殿。');
  assert.equal(feedback.explanation, '补充量词。');
  assert.equal(feedback.natural, '我最想去看看太和殿。');
  assert.equal(feedback.encouragement, '重点很清楚。');
});

test('guide endpoint returns model reply and never caches it', async () => {
  const request = new Request('https://example.com/api/phoenix-ai', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      mode: 'guide',
      text: '我想观察屋顶，因为黄色很醒目。',
      language: '越南语',
    }),
  });

  const response = await handlePhoenixAi(request, {
    AI: {
      run: async () => ({ response: '黄色屋顶确实很有辨识度。你还可以观察屋脊与院落的关系。你觉得它让空间显得更庄严，还是更明亮？' }),
    },
  });
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(response.headers.get('cache-control'), 'no-store');
  assert.equal(body.mode, 'guide');
  assert.match(body.reply, /屋顶/);
});

test('writing endpoint returns structured coaching feedback', async () => {
  const request = new Request('https://example.com/api/phoenix-ai', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      mode: 'writing',
      text: '我最想看的建筑是太和殿因为它很壮观',
      language: '越南语',
    }),
  });

  const response = await handlePhoenixAi(request, {
    AI: {
      run: async () => ({
        response: JSON.stringify({
          corrected: '我最想看的建筑是太和殿，因为它很壮观。',
          explanation: '在原因分句前加逗号，并补上句号。',
          natural: '我最想参观太和殿，因为它看起来非常雄伟壮观。',
          encouragement: '你的理由明确，句子结构也很完整。',
        }),
      }),
    },
  });
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.feedback.corrected, '我最想看的建筑是太和殿，因为它很壮观。');
  assert.match(body.feedback.natural, /参观太和殿/);
});

test('endpoint rejects blank and oversized input', async () => {
  const blank = await handlePhoenixAi(
    new Request('https://example.com/api/phoenix-ai', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ mode: 'guide', text: ' ' }),
    }),
    { AI: { run: async () => ({ response: 'unused' }) } },
  );

  const oversized = await handlePhoenixAi(
    new Request('https://example.com/api/phoenix-ai', {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ mode: 'guide', text: '长'.repeat(1601) }),
    }),
    { AI: { run: async () => ({ response: 'unused' }) } },
  );

  assert.equal(blank.status, 400);
  assert.equal(oversized.status, 400);
});
