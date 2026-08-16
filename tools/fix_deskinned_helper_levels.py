from pathlib import Path
import re

path = Path('tools/close_human_deskinned_grammar_collisions.py')
text = path.read_text(encoding='utf-8')
start = text.index('def replace_by_broken(')
end = text.index('\n\n# Forbidden City:', start)
new_func = '''def replace_by_broken(journey_id: str, level: int, block: str) -> None:
    global text
    start, end = bounds(journey_id)
    section = text[start:end]
    starts = [m.start() for m in re.finditer(r'GoldChallengeGrammarSpec\\(', section)]
    if len(starts) != 10:
        raise SystemExit(f'{journey_id}: expected 10 grammar blocks, found {len(starts)}')
    if level < 1 or level > 10:
        raise SystemExit(f'{journey_id}: invalid level {level}')
    block_start = starts[level - 1]
    grammar_end = section.find('\\n      ),', block_start)
    if grammar_end < 0:
        raise SystemExit(f'{journey_id} Lv{level}: missing grammar block end')
    grammar_end += len('\\n      ),')
    section = section[:block_start] + block.strip() + ',' + section[grammar_end:]
    text = text[:start] + section + text[end:]
'''
text = text[:start] + new_func + text[end:]

levels = {
    'beijing-forbidden-city': [5, 7, 8, 9],
    'beijing-summer-palace': [7, 9, 10],
    'chengdu-kuanzhai-alley': [4, 5, 8],
    'guangzhou-chen-clan-academy': [4, 6, 7, 10],
    'hangzhou-west-lake': [5, 7, 8, 9, 10],
    'jiangmen-kaiping-diaolou': [5, 7, 8, 9, 10],
    'luoyang-longmen-grottoes': [4, 7, 10],
    'nanjing-qinhuai-river': [5, 6, 7, 8],
    'shanghai-bund': [5, 7, 8, 9],
    'suzhou-humble-administrators-garden': [5, 7, 8, 9, 10],
    'xian-city-wall': [6, 7, 8, 9, 10],
}

for journey_id, journey_levels in levels.items():
    pattern = re.compile(
        r"replace_by_broken\('" + re.escape(journey_id) + r"',\s*'(?:\\'|[^'])*',"
    )
    matches = list(pattern.finditer(text))
    if len(matches) != len(journey_levels):
        raise SystemExit(
            f'{journey_id}: expected {len(journey_levels)} helper calls, found {len(matches)}'
        )
    offset = 0
    for match, level in zip(matches, journey_levels):
        s = match.start() + offset
        e = match.end() + offset
        replacement = f"replace_by_broken('{journey_id}', {level},"
        text = text[:s] + replacement + text[e:]
        offset += len(replacement) - (e - s)

path.write_text(text, encoding='utf-8')
print('converted de-skinned grammar helper to exact Journey-level addressing')
