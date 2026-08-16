from pathlib import Path

path = Path('tools/naturalize_all_gold_grammar_distractors.py')
text = path.read_text(encoding='utf-8')
old = """    candidates = [broken, *alts]
    chosen = []
"""
new = """    current_match = re.search(r'distractors: <String>\\[(.*?)\\],', block, re.S)
    if not current_match:
        raise SystemExit(f'{journey_id} Lv{level}: cannot read current distractors')
    current = [
        value.replace("\\\\'", "'")
        for value in re.findall(r"'((?:\\\\'|[^'])*)'", current_match.group(1))
    ]
    candidates = [broken, *alts, *current]
    chosen = []
"""
if text.count(old) != 1:
    raise SystemExit(f'naturalizer dedup anchor expected 1, found {text.count(old)}')
path.write_text(text.replace(old, new, 1), encoding='utf-8')
print('naturalizer now falls back to existing near-misses only after deduplication')
