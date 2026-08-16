from pathlib import Path

path = Path('tools/refine_all_gold_human_gate.py')
text = path.read_text(encoding='utf-8')
old = '''    next_start = text.find("  '", start + len(start_marker))
    end = next_start if next_start >= 0 else text.find("};", start)
    section = text[start:end]
'''
new = '''    top_level_profiles = list(
        re.finditer(r"(?m)^  '[^']+': GoldChallengeProfile\\(", text)
    )
    starts = [match.start() for match in top_level_profiles if match.start() > start]
    end = min(starts) if starts else text.find("};", start)
    section = text[start:end]
'''
if text.count(old) != 1:
    raise SystemExit(f'helper locator anchor expected 1, found {text.count(old)}')
text = text.replace(old, new, 1)
old_xian = "    'xian-city-wall',\n    'subject-position',"
new_xian = "    'xian-city-wall',\n    'time-order',"
if text.count(old_xian) != 1:
    raise SystemExit(f'Xi’an target anchor expected 1, found {text.count(old_xian)}')
text = text.replace(old_xian, new_xian, 1)
path.write_text(text, encoding='utf-8')
print('fixed human-gate helper Journey locator and Xi’an target id')
