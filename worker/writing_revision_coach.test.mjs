import assert from 'node:assert/strict';
import test from 'node:test';
import { readFileSync } from 'node:fs';

import { parseWritingFeedback } from './agents/phoenix_writing_agent.mjs';

test('writing feedback preserves structured understanding and rewrite coaching', () => {
  const feedback = parseWritingFeedback(
    {
      understanding: '你想说明颐和园通过湖面扩大了空间感。',
      corrected: '颐和园通过湖面扩大了空间感。',
      explanation:
        '内容与任务：回答了空间观察。\n关键修改：通过湖水 → 通过湖面 → 搭配更准确。\n可迁移规则：描述视觉空间时可使用“通过……形成……”。',
      natural: '昆明湖让颐和园的视野更加开阔，也让远山进入园林画面。',
      abilityFocus: '优先练习句间因果关系，让观察和解释连接起来。',
      rewriteTask: '用“因为……，所以……”重写两句话，并加入一个具体画面。',
      encouragement: '你已经抓住了湖面与空间感的关系。',
      learnerScore: 78,
    },
    '颐和园有湖水所以空间很大',
  );

  assert.match(feedback.understanding, /湖面/);
  assert.match(feedback.abilityFocus, /因果/);
  assert.match(feedback.rewriteTask, /重新|重写|改写/);
  assert.equal(feedback.learnerScore, 78);
});

test('older four-field feedback remains compatible and receives a rewrite task', () => {
  const feedback = parseWritingFeedback(
    {
      corrected: '我想参观长廊。',
      explanation: '补充标点。',
      natural: '我最想沿着长廊慢慢走。',
      encouragement: '观察对象很明确。',
    },
    '我想参观长廊',
  );

  assert.equal(feedback.corrected, '我想参观长廊。');
  assert.ok(feedback.understanding.length > 0);
  assert.ok(feedback.abilityFocus.length > 0);
  assert.ok(feedback.rewriteTask.length > 0);
  assert.equal(feedback.learnerScore, 0);
});

test('app feedback card exposes copy, rewrite, understanding and score controls', () => {
  const card = readFileSync('app/lib/widgets/phoenix_agent_cards.dart', 'utf8');
  const service = readFileSync('app/lib/services/phoenix_ai_service.dart', 'utf8');
  const agent = readFileSync('worker/agents/phoenix_writing_agent.mjs', 'utf8');

  assert.match(card, /AI 理解到的意思/);
  assert.match(card, /下一轮改写任务/);
  assert.match(card, /copy-corrected-writing/);
  assert.match(card, /copy-natural-writing/);
  assert.match(card, /return-to-rewrite/);
  assert.match(card, /完成度 \$\{feedback\.learnerScore\}/);
  assert.match(service, /final String originalText/);
  assert.match(service, /final String rewriteTask/);
  assert.match(service, /final int learnerScore/);
  assert.match(agent, /不是 HSK、TOCFL 或任何正式考试分数/);
});
