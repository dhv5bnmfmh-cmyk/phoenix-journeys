import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

import { PhoenixBrainAgent } from './agents/phoenix_brain_agent.mjs';
import {
  buildVocabularyMessages,
  normalizeVocabularyExample,
} from './agents/phoenix_vocabulary_agent.mjs';

const candidate = {
  chinese: '傍晚的灯光照亮了古老的牌坊。',
  pinyin: 'Bàngwǎn de dēngguāng zhàoliàng le gǔlǎo de páifāng.',
  native: 'Ánh đèn buổi tối chiếu sáng cổng vòm cổ.',
  english: 'Evening lights illuminated the old ceremonial archway.',
  usageNote: '“牌坊”常与“古老、石制、入口处”等词搭配。',
};

test('vocabulary prompt requires real usage and forbids placeholder sentences', () => {
  const messages = buildVocabularyMessages({
    word: '牌坊',
    pinyin: 'páifāng',
    partOfSpeech: '名词',
    simpleChinese: '有纪念或标志作用的传统门式建筑。',
    nativeDefinition: 'Cổng bài truyền thống.',
    englishDefinition: 'ceremonial archway',
    contextChinese: '秦淮河边可以看到传统牌坊。',
    contextPinyin: 'Qínhuái Hé biān kěyǐ kàndào chuántǒng páifāng.',
    contextNative: 'Có thể thấy cổng bài truyền thống bên sông Tần Hoài.',
    contextEnglish: 'Traditional archways can be seen beside the Qinhuai River.',
    language: '越南语',
    knowledge: {},
  });
  const prompt = messages.map((message) => message.content).join('\n');

  assert.match(prompt, /真实应用例句/);
  assert.match(prompt, /禁止使用“故事里出现了这个词”/);
  assert.match(prompt, /<word>牌坊<\/word>/);
});

test('normalization rejects examples that do not actually use the word', () => {
  assert.throws(
    () => normalizeVocabularyExample({ ...candidate, chinese: '傍晚的灯光很漂亮。' }, '牌坊'),
    /incomplete example/,
  );
  assert.equal(normalizeVocabularyExample(candidate, '牌坊').chinese, candidate.chinese);
});

test('PhoenixBrainAgent routes authoring through specialist and quality review', async () => {
  const calls = [];
  const gateway = {
    isAvailable: true,
    async generateStructured(options) {
      calls.push(options.purpose);
      if (options.purpose === 'vocabulary') {
        return { provider: 'test', model: 'test-model', value: candidate };
      }
      if (options.purpose === 'quality-vocabulary') {
        return {
          provider: 'test',
          model: 'quality-model',
          value: {
            approved: true,
            score: 96,
            issues: [],
            revisedExample: candidate,
          },
        };
      }
      throw new Error(`Unexpected purpose: ${options.purpose}`);
    },
  };

  const result = await new PhoenixBrainAgent({}, { gateway }).run({
    mode: 'vocabulary',
    text: '牌坊',
    word: '牌坊',
    pinyin: 'páifāng',
    partOfSpeech: '名词',
    simpleChinese: '有纪念或标志作用的传统门式建筑。',
    nativeDefinition: 'Cổng bài truyền thống.',
    englishDefinition: 'ceremonial archway',
    contextChinese: '秦淮河边可以看到传统牌坊。',
    contextPinyin: '',
    contextNative: '',
    contextEnglish: '',
    language: '越南语',
    journeyId: 'nanjing-qinhuai-river',
    learnerProfile: {},
  });

  assert.deepEqual(calls, ['vocabulary', 'quality-vocabulary']);
  assert.equal(result.agent, 'PhoenixVocabularyAgent');
  assert.equal(result.orchestrator, 'PhoenixBrainAgent');
  assert.equal(result.example.chinese, candidate.chinese);
  assert.equal(result.quality.reviewed, true);
});

test('explorers read bundled examples and never wait for a model request', () => {
  const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
  const service = readFileSync(
    'app/lib/services/phoenix_vocabulary_service.dart',
    'utf8',
  );
  const runtime = service.match(
    /Future<PhoenixVocabularyExample> generateExample\([\s\S]*?\n  }\n\n  \/\/\/ Content-authoring path only\./,
  )?.[0] ?? '';

  assert.match(sheet, /PhoenixVocabularyService/);
  assert.doesNotMatch(sheet, /entry\.studyExamples/);
  assert.match(runtime, /phoenix-preloaded-pack/);
  assert.match(runtime, /Future<PhoenixVocabularyExample>\.value\(preloaded\)/);
  assert.doesNotMatch(runtime, /_client\s*\.post/);
  assert.match(service, /generateExampleForContentPipeline/);
  assert.match(service, /forbidden\.any/);
});
