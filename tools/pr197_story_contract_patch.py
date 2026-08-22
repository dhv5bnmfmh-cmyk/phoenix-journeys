from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / 'worker/story_culture_level_standard.test.mjs'
WORKFLOW = ROOT / '.github/workflows/pr197-story-contract-fix.yml'
SELF = Path(__file__).resolve()

text = TARGET.read_text(encoding='utf-8')
replacements = {
    "    '想做一张能解释宫城空间的学习图',\n": "    '想做一张能解释紫禁城空间组织的学习图',\n",
    "    '一张好图应该有一条明确主线',\n": "    '误把“最容易组织的路线”当成“所有人都应采用的路线”',\n",
    "    '两条路线都来自真实的行动',\n": "    '两条路线都能走通',\n",
    "    '不选一条覆盖另一条',\n": "    '不再用一条线覆盖另一条',\n",
}
for old, new in replacements.items():
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'Expected one stale Story contract occurrence for {old!r}, got {count}')
    text = text.replace(old, new, 1)

TARGET.write_text(text, encoding='utf-8')
if WORKFLOW.exists():
    WORKFLOW.unlink()
SELF.unlink()
print('PR197 STORY CONTENT CONTRACT ALIGNED')
