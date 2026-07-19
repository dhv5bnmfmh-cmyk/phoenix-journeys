from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text(encoding='utf-8')
old = "    FocusManager.instance.primaryFocus?.unfocus();\n"
count = text.count(old)
if count == 0:
    raise SystemExit(0)
if count != 2:
    raise RuntimeError(f'unexpected global unfocus count: {count}')
path.write_text(text.replace(old, ''), encoding='utf-8')
