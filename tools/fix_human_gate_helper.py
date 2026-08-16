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
path.write_text(text.replace(old, new, 1), encoding='utf-8')
print('fixed human-gate helper top-level Journey section locator')
