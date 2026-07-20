from pathlib import Path

path = Path('app/lib/data/daily_journey_catalog.dart')
source = path.read_text(encoding='utf-8')
export = "export 'daily_journey_experience.dart';\n"
if export not in source:
    source = source.replace(
        "import '../models/story_content.dart';\n",
        "import '../models/story_content.dart';\n\n" + export,
        1,
    )
    path.write_text(source, encoding='utf-8')
