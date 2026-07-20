from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
source = path.read_text(encoding='utf-8')
target = (
    "                  visualDensity: VisualDensity.compact,\n"
    "                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,\n"
    "                  padding: const EdgeInsets.all(4),\n"
)
replacement = (
    "                  visualDensity: VisualDensity.compact,\n"
    "                  padding: const EdgeInsets.all(4),\n"
)
if target in source:
    source = source.replace(target, replacement, 1)
if target in source:
    raise RuntimeError('support IconButton still uses unsupported tapTargetSize')
path.write_text(source, encoding='utf-8')
