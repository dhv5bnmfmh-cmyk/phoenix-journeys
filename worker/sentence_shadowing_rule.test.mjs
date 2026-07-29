import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const status = fs.readFileSync(
  new URL('../app/lib/widgets/narration_follow_status.dart', import.meta.url),
  'utf8',
);
const practice = fs.readFileSync(
  new URL('../app/lib/widgets/sentence_shadowing_practice.dart', import.meta.url),
  'utf8',
);
const recognition = fs.readFileSync(
  new URL('../app/lib/services/sentence_recognition_service_web.dart', import.meta.url),
  'utf8',
);

test('sentence guidance exposes one compact shadowing action', () => {
  assert.match(status, /SentenceShadowingPractice/);
  assert.match(practice, /sentence-shadowing-action/);
  assert.match(practice, /跟读这句/);
  assert.match(practice, /再读一次/);
});

test('shadowing pauses narration before using the microphone', () => {
  assert.match(status, /NarrationStatus\.playing/);
  assert.match(status, /await controller\.pause\(\)/);
  assert.match(practice, /await widget\.onBeforeListen\(\)/);
});

test('short Chinese speech is recognized and scored locally', () => {
  assert.match(recognition, /SpeechRecognition/);
  assert.match(recognition, /webkitSpeechRecognition/);
  assert.match(recognition, /zh-CN/);
  assert.match(practice, /evaluateShadowing/);
  assert.match(practice, /evaluation\.score/);
  assert.match(practice, /72/);
});

test('unsupported browsers receive a calm fallback', () => {
  assert.match(practice, /当前浏览器暂不支持跟读识别/);
  assert.match(practice, /没有听清，请再试一次/);
});
