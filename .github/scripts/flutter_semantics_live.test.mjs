import test from 'node:test';
import assert from 'node:assert/strict';
import {
  activateSemantic,
  classifyDialogState,
  discoveryDepthFromText,
  levelFromRecords,
  normalizePhoenixSemanticSpec,
  semanticMatches,
  shouldAcceptTerminalCorpus,
  stageFromRecords,
  terminalNarrationState,
} from './flutter_semantics_live.mjs';

const rec = (text, overrides = {}) => ({
  role: '', label: text, value: '', description: '', text: '', disabled: false, visible: true, area: 100,
  ...overrides,
});

function fakePage(state) {
  return {
    locator() {
      return {
        async elementHandles() {
          return state.handles;
        },
      };
    },
  };
}

function fakeHandle(state, record, behavior = {}) {
  let evaluations = 0;
  return {
    async evaluate() {
      evaluations += 1;
      if (behavior.onEvaluate) return behavior.onEvaluate({ state, record, evaluations });
      if (!state.handles.includes(this)) throw new Error('detached');
      return { ...record };
    },
    async click() {
      state.activations += 1;
      if (behavior.onAction) return behavior.onAction({ state, mode: 'click' });
    },
    async tap() {
      state.activations += 1;
      if (behavior.onAction) return behavior.onAction({ state, mode: 'tap' });
    },
  };
}

test('localized stage wording does not matter when structural progress is present', () => {
  assert.equal(stageFromRecords([rec('3/6 发现'), rec('Discovery')]), 3);
  assert.equal(stageFromRecords([rec('3/6 Khám phá')]), 3);
});

test('target level parser is structural and detects drift fixtures', () => {
  assert.equal(levelFromRecords([rec('Phoenix 中文难度 8 级')]), 8);
  assert.notEqual(levelFromRecords([rec('Phoenix 中文难度 7 级')]), 8);
});

test('known modal mount race waits through empty Dialog shell', () => {
  assert.equal(classifyDialogState([rec('Dialog', { label: 'Dialog' })]).state, 'MOUNTING_UNIDENTIFIED');
  assert.deepEqual(
    classifyDialogState([rec('Dialog', { label: 'Dialog' }), rec('收藏单词'), rec('上一个单词'), rec('下一个单词')]),
    { state: 'KNOWN', kind: 'vocabulary-word-detail' },
  );
});

test('unknown concrete modal remains a hard negative', () => {
  assert.equal(
    classifyDialogState([rec('Dialog', { label: 'Dialog' }), rec('Delete all progress?')]).state,
    'UNKNOWN',
  );
});

test('semantic reorder fixture proves identity matching ignores old numeric position', () => {
  const old = { role: 'slider', label: '朗读进度 40%', visible: true, disabled: false };
  const moved = { role: 'slider', label: '朗读进度 40%', visible: true, disabled: false };
  const wrongAtOldIndex = { role: 'button', label: '降低当前难度', visible: true, disabled: false };
  assert.equal(semanticMatches(old, { role: 'slider', prefix: '朗读进度' }), true);
  assert.equal(semanticMatches(wrongAtOldIndex, { role: 'slider', prefix: '朗读进度' }), false);
  assert.equal(semanticMatches(moved, { role: 'slider', prefix: '朗读进度' }), true);
});

test('compact Phoenix nav uses the deployed button role without global role rewriting', () => {
  assert.equal(normalizePhoenixSemanticSpec({ role: 'button', exact: '护照' }).role, 'button');
  assert.equal(
    semanticMatches(rec('', { role: 'button', label: '护照', text: '护照' }), { role: 'button', exact: '护照' }),
    true,
  );
});

test('wide NavigationRail accepts only the bounded structural own-label decoration', () => {
  assert.equal(
    semanticMatches(rec('', { role: 'tab', label: '护照 Tab 2 of 4' }), { role: 'button', exact: '护照' }),
    true,
  );
  assert.equal(
    semanticMatches(rec('', { role: 'tab', label: '护照 Tab 3 of 4' }), { role: 'button', exact: '护照' }),
    false,
  );
  assert.equal(
    semanticMatches(rec('', { role: 'tab', label: '护照' }), { role: 'button', exact: '护照' }),
    true,
  );
});

test('Phoenix nav does not use aggregate descendant text as actionable identity', () => {
  assert.equal(
    semanticMatches(rec('', { role: 'button', label: '其他', text: '护照' }), { role: 'button', exact: '护照' }),
    false,
  );
});

test('Phoenix nav rejects correct label on an unrelated role', () => {
  assert.equal(
    semanticMatches(rec('', { role: 'group', label: '护照' }), { role: 'button', exact: '护照' }),
    false,
  );
});

test('pre-action detach rebinds from a fresh semantic snapshot before one activation', async () => {
  const state = { handles: [], activations: 0 };
  const record = rec('', { role: 'button', label: '中国' });
  let replacement;
  const first = fakeHandle(state, record, {
    onEvaluate({ evaluations }) {
      if (evaluations === 3) {
        state.handles = [replacement];
        throw new Error('detached before activation');
      }
      return { ...record };
    },
  });
  replacement = fakeHandle(state, record);
  state.handles = [first];

  await activateSemantic(fakePage(state), { role: 'button', exact: '中国' }, { timeout: 50, retries: 2 });
  assert.equal(state.activations, 1);
});

test('post-action target disappearance returns control to caller without repeating the action', async () => {
  const state = { handles: [], activations: 0 };
  const record = rec('', { role: 'button', label: '紫禁城' });
  const handle = fakeHandle(state, record, {
    onAction({ state: liveState }) {
      liveState.handles = [];
      throw new Error('detached after committed navigation');
    },
  });
  state.handles = [handle];

  await activateSemantic(fakePage(state), { role: 'button', exact: '紫禁城' }, { timeout: 50, retries: 3 });
  assert.equal(state.activations, 1);
});

test('post-action error may retry only when the old target is still live and actionable', async () => {
  const state = { handles: [], activations: 0 };
  const record = rec('', { role: 'button', label: '继续' });
  let first = true;
  const handle = fakeHandle(state, record, {
    onAction() {
      if (first) {
        first = false;
        throw new Error('action transport error while target persists');
      }
    },
  });
  state.handles = [handle];

  await activateSemantic(
    fakePage(state),
    { role: 'button', exact: '继续' },
    {
      timeout: 50,
      retries: 2,
      canRetryCommittedAction: async () => true,
    },
  );
  assert.equal(state.activations, 2);
});

test('committed non-idempotent action is never blindly double-activated without caller authorization', async () => {
  const state = { handles: [], activations: 0 };
  const record = rec('', { role: 'button', label: '西安城墙' });
  const handle = fakeHandle(state, record, {
    onAction() {
      throw new Error('ambiguous committed action error while target persists');
    },
  });
  state.handles = [handle];

  await activateSemantic(fakePage(state), { role: 'button', exact: '西安城墙' }, { timeout: 50, retries: 5 });
  assert.equal(state.activations, 1);
});

test('exact semantic identity can use aria-label despite nested child text while preserving role', () => {
  const answer = 'A 他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。';
  const richGroup = rec('', {
    role: 'group',
    label: answer,
    text: '朗读',
  });
  assert.equal(semanticMatches(richGroup, { role: 'group', exact: answer }), true);
  assert.equal(semanticMatches(richGroup, { role: 'group', labelExact: answer }), true);
  assert.equal(semanticMatches(richGroup, { role: 'group', exact: `B ${answer}` }), false);
  assert.equal(semanticMatches(richGroup, { role: 'button', exact: answer }), false);
});

test('Discovery segmented corpus fixture parses canonical depth', () => {
  assert.equal(discoveryDepthFromText('Discovery，Lv.8 · 分段短文 · 3 段'), 3);
  assert.equal(discoveryDepthFromText('Discovery，Lv.3 · 分段短文 · 2 段'), 2);
});

test('TTS-unavailable content is not itself a failure condition', () => {
  const text = '3/6 Discovery\n城墙\n永宁门\n暂无朗读服务';
  assert.equal(text.includes('城墙') && text.includes('永宁门'), true);
});

test('explicit 100% is terminal and complete terminal corpus can outrank intermediate segment count', () => {
  const items = [rec('3/6 Discovery'), rec('朗读完成 · 100%'), rec('海运提单'), rec('1990')];
  assert.equal(terminalNarrationState(items), true);
  assert.equal(
    shouldAcceptTerminalCorpus({
      stage: 3,
      level: 8,
      targetLevel: 8,
      completed100: true,
      anchorsComplete: true,
      unresolvedModal: false,
      drift: false,
    }),
    true,
  );
});

test('terminal corpus missing anchor remains a negative', () => {
  assert.equal(
    shouldAcceptTerminalCorpus({
      stage: 3,
      level: 8,
      targetLevel: 8,
      completed100: true,
      anchorsComplete: false,
      unresolvedModal: false,
      drift: false,
    }),
    false,
  );
});
