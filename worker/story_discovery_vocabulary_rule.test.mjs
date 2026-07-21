import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');
const interactive = read('app/lib/widgets/interactive_story_text.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const workflow = read('docs/development-workflow.md');
const template = read('.github/pull_request_template.md');

test('Story and Discovery share one interactive vocabulary component', () => {
  assert.ok((journey.match(/InteractiveStoryText\(/g) ?? []).length >= 2);
  assert.match(interactive, /entry\.nativeLabel\(state\.translationLanguage\)/);
  assert.match(interactive, /entry\.nativeDefinition\(state\.translationLanguage\)/);
  assert.match(interactive, /entry\.englishDefinition\.trim\(\)/);
  assert.match(interactive, /entry\.partOfSpeech/);
});

test('short-text vocabulary shows explorer native and English meanings', () => {
  assert.match(interactive, /story-discovery-word-native-label/);
  assert.match(interactive, /story-discovery-word-native-/);
  assert.match(interactive, /story-discovery-word-english-label/);
  assert.match(interactive, /story-discovery-word-english-/);
  assert.match(interactive, /'English'/);
});

test('permanent rules prevent Story and Discovery vocabulary from drifting apart', () => {
  assert.match(workflow, /永久生词展示与例句准则/);
  assert.match(workflow, /探索者母语释义和英文释义/);
  assert.match(workflow, /不得隐藏这两项释义/);
  assert.match(workflow, /PhoenixVocabularyAgent/);
  assert.match(workflow, /永久禁止使用“故事里出现了这个词”/);
  assert.match(template, /故事页与发现页生词均显示词性、探索者母语和英文释义/);
  assert.match(template, /PhoenixVocabularyAgent/);
});

test('Story Continue enters the first vocabulary word automatically', () => {
  assert.match(journey, /Future<void> _enterVocabularyAtFirstWord\(\) async/);
  assert.match(journey, /await _goToStep\(1\);/);
  assert.match(journey, /await WidgetsBinding\.instance\.endOfFrame;/);
  assert.match(journey, /await _openWord\(_experience\.words\.first\);/);
  assert.match(
    journey,
    /onNext: \(\) => unawaited\(_enterVocabularyAtFirstWord\(\)\),/,
  );
});
