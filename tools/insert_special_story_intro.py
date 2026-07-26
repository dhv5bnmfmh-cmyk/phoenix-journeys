from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text(encoding='utf-8')
text = text.replace(
    "import '../widgets/journey_share_button.dart';\n",
    "import '../widgets/journey_share_button.dart';\nimport '../widgets/special_realm_story_intro.dart';\n",
    1,
)
text = text.replace(
    "        children: [\n          NarrationPlayerCard(\n            controller: _narration,\n",
    "        children: [\n          if (SpecialRealmStoryIntro.supports(_experience.id))\n            SpecialRealmStoryIntro(\n              journeyId: _experience.id,\n              displayText: _appState.displayText,\n            ),\n          NarrationPlayerCard(\n            controller: _narration,\n",
    1,
)
path.write_text(text, encoding='utf-8')
