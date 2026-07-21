from pathlib import Path


def replace_once(path, old, new):
    file = Path(path)
    text = file.read_text()
    if new in text:
        return
    if old not in text:
        raise SystemExit(f'Expected pattern not found in {path}')
    file.write_text(text.replace(old, new, 1))

replace_once(
    'app/lib/screens/journey_screen.dart',
    "import '../models/story_content.dart';\n",
    "import '../models/journey_background.dart';\nimport '../models/story_content.dart';\n",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    "import '../widgets/city_journey_stamp.dart';\n",
    "import '../widgets/city_journey_stamp.dart';\nimport '../widgets/destination_background.dart';\n",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[""",
    """  JourneyBackgroundPage get _backgroundPageType => switch (step) {
    0 => JourneyBackgroundPage.story,
    1 => JourneyBackgroundPage.vocabulary,
    2 => JourneyBackgroundPage.discovery,
    3 => JourneyBackgroundPage.reflection,
    4 => JourneyBackgroundPage.writing,
    5 => JourneyBackgroundPage.memory,
    _ => JourneyBackgroundPage.completion,
  };

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """    return Scaffold(
      resizeToAvoidBottomInset: true,""",
    """    return DestinationBackground(
      journeyId: _experience.id,
      pageType: _backgroundPageType,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: pages[step],
      ),
    );
  }""",
    """        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: pages[step],
        ),
      ),
    );
  }""",
)
