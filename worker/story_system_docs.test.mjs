import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const storyFiles = [
  'docs/story/README.md',
  'docs/story/STORY_GUIDELINES.md',
  'docs/story/STORY_STYLE_GUIDE.md',
  'docs/story/STORY_QUALITY_GATE.md',
  'docs/story/STORY_REVIEW_PROMPT.md',
  'docs/story/STORY_GENERATION_GUIDE.md',
  'docs/story/STORY_LIBRARY_RULES.md',
  'docs/story/SPECIAL_JOURNEY_GUIDE.md',
  'docs/story/CONTENT_VARIETY_GUIDE.md',
];

const [docsIndex, ...storyDocs] = await Promise.all([
  readFile('docs/README.md', 'utf8'),
  ...storyFiles.map((path) => readFile(path, 'utf8')),
]);

test('Story System publishes all nine non-empty normative files', () => {
  assert.equal(storyDocs.length, 9);
  for (const [index, content] of storyDocs.entries()) {
    assert.ok(content.trim().length > 500, `${storyFiles[index]} is incomplete`);
    assert.match(content, /Story System Version：`1\.0\.0`/);
  }
});

test('Phoenix permanently requires all story rules before story work', () => {
  assert.match(docsIndex, /必须在开始前完整读取 `story\/` 下全部规范/);
  assert.match(storyDocs[0], /不得只读一份文件后开始写作/);
  assert.match(storyDocs[0], /故事 → 单词 → 发现 → 挑战 → 回忆 → 完成与盖章/);
});

test('Story Quality Gate contains ten blocking publication gates', () => {
  const qualityGate = storyDocs[3];
  for (let gate = 1; gate <= 10; gate += 1) {
    assert.match(qualityGate, new RegExp(`Gate ${gate}：`));
  }
  assert.match(qualityGate, /任何一道 Gate 未通过，禁止发布/);
  assert.match(qualityGate, /severe = 0/);
  assert.match(qualityGate, /medium = 0/);
});

test('Story System covers generation, review, library and special sources', () => {
  const reviewPrompt = storyDocs[4];
  const generationGuide = storyDocs[5];
  const libraryRules = storyDocs[6];
  const specialGuide = storyDocs[7];
  const varietyGuide = storyDocs[8];

  assert.match(reviewPrompt, /国际出版社总编辑/);
  assert.match(reviewPrompt, /儿童文学编辑/);
  assert.match(reviewPrompt, /HSK 教材专家/);
  assert.match(reviewPrompt, /TOCFL 教材专家/);
  assert.match(generationGuide, /独立灵魂/);
  assert.match(libraryRules, /一本经过总编辑统筹的正式故事书/);
  assert.match(specialGuide, /志怪/);
  assert.match(specialGuide, /散曲/);
  assert.match(specialGuide, /禁止现代网络小说化/);
  assert.match(varietyGuide, /当前 41 篇故事身份矩阵/);
  assert.match(varietyGuide, /人物矩阵/);
  assert.match(varietyGuide, /结局矩阵/);
});
