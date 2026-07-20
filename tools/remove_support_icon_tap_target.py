from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
source = path.read_text(encoding='utf-8')
source = source.replace(
    "                  visualDensity: VisualDensity.compact,\n"
    "                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,\n"
    "                  padding: const EdgeInsets.all(4),\n",
    "                  visualDensity: VisualDensity.compact,\n"
    "                  padding: const EdgeInsets.all(4),\n",
    1,
)
if 'tapTargetSize: MaterialTapTargetSize.shrinkWrap' in source:
    raise RuntimeError('support IconButton still uses unsupported tapTargetSize')
path.write_text(source, encoding='utf-8')
