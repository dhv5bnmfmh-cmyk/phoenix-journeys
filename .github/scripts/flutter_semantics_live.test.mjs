import test from 'node:test';
import assert from 'node:assert/strict';
import {
  classifyDialogState,
  discoveryDepthFromText,
  levelFromRecords,
  semanticMatches,
  shouldAcceptTerminalCorpus,
  stageFromRecords,
  terminalNarrationState,
} from './flutter_semantics_live.mjs';

const rec = (text, overrides = {}) => ({
  role: '', label: text, value: '', description: '', text: '', disabled: false, visible: true, area: 100,
  ...overrides,
});

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
