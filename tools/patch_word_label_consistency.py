from pathlib import Path

replacements = {
    Path('app/lib/state/app_state.dart'): {
        "    '生词',": "    '单词',",
    },
    Path('app/lib/screens/journey_screen.dart'): {
        "      title: '生词',": "      title: '单词',",
    },
    Path('app/lib/widgets/word_detail_sheet.dart'): {
        "isSaved ? '已收藏' : '收藏生词'": "isSaved ? '已收藏' : '收藏单词'",
        "state.displayText('上一个生词')": "state.displayText('上一个单词')",
    },
    Path('app/lib/screens/me_screen.dart'): {
        "'我的生词 · $vocabularyCount'": "'我的单词 · $vocabularyCount'",
        "'查看全部 ${entries.length} 个生词'": "'查看全部 ${entries.length} 个单词'",
        "title: '还没有收藏生词'": "title: '还没有收藏单词'",
        "text: '在 Journey 点红色词语，再加入生词本。'": "text: '在 Journey 点红色词语，再加入单词本。'",
    },
    Path('worker/compact_word_study.test.mjs'): {
        "state.displayText(isSaved ? '已收藏' : '收藏生词')": "state.displayText(isSaved ? '已收藏' : '收藏单词')",
        "state.displayText('上一个生词')": "state.displayText('上一个单词')",
    },
}

for path, mapping in replacements.items():
    text = path.read_text(encoding='utf-8')
    for old, new in mapping.items():
        if old not in text:
            raise SystemExit(f'Missing expected label in {path}: {old}')
        text = text.replace(old, new)
    path.write_text(text, encoding='utf-8')

Path('worker/word_label_consistency.test.mjs').write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const me = readFileSync('app/lib/screens/me_screen.dart', 'utf8');
const explorerUi = [state, journey, sheet, me].join('\\n');

test('explorer-facing vocabulary labels consistently use 单词', () => {
  assert.doesNotMatch(explorerUi, /生词/);
  assert.match(state, /'单词'/);
  assert.match(journey, /title: '单词'/);
  assert.match(sheet, /收藏单词/);
  assert.match(sheet, /上一个单词/);
  assert.match(sheet, /下一个单词/);
  assert.match(me, /我的单词/);
  assert.match(me, /单词本/);
});
""",
    encoding='utf-8',
)
