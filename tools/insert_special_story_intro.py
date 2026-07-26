from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text(encoding='utf-8')
import_line = "import '../widgets/special_realm_story_intro.dart';\n"
while import_line + import_line in text:
    text = text.replace(import_line + import_line, import_line)
if import_line not in text:
    text = text.replace(
        "import '../widgets/journey_share_button.dart';\n",
        "import '../widgets/journey_share_button.dart';\n" + import_line,
        1,
    )
intro_marker = "SpecialRealmStoryIntro.supports(_experience.id)"
if intro_marker not in text:
    text = text.replace(
        "        children: [\n          NarrationPlayerCard(\n            controller: _narration,\n",
        "        children: [\n          if (SpecialRealmStoryIntro.supports(_experience.id))\n            SpecialRealmStoryIntro(\n              journeyId: _experience.id,\n              displayText: _appState.displayText,\n            ),\n          NarrationPlayerCard(\n            controller: _narration,\n",
        1,
    )
path.write_text(text, encoding='utf-8')
