from pathlib import Path


def replace_once(path, old, new):
    file = Path(path)
    text = file.read_text()
    if new in text:
        return
    if old not in text:
        raise SystemExit(f'Expected pattern not found in {path}')
    file.write_text(text.replace(old, new, 1))

pubspec = Path('app/pubspec.yaml')
text = pubspec.read_text()
if 'assets/images/backgrounds/' not in text:
    text = text.replace(
        '    - assets/images/\n',
        '    - assets/images/\n    - assets/images/backgrounds/\n',
    )
    pubspec.write_text(text)

replace_once(
    'app/lib/screens/home_shell.dart',
    "import '../state/app_state.dart';\n",
    "import '../models/journey_background.dart';\nimport '../state/app_state.dart';\n",
)
replace_once(
    'app/lib/screens/home_shell.dart',
    "import '../theme/phoenix_theme.dart';\n",
    "import '../theme/phoenix_theme.dart';\nimport '../widgets/destination_background.dart';\n",
)
replace_once(
    'app/lib/screens/home_shell.dart',
    """        final content = IndexedStack(
          index: state.selectedTab,
          children: _pages,
        );""",
    """        final pageType = switch (state.selectedTab) {
          1 => JourneyBackgroundPage.passport,
          2 => JourneyBackgroundPage.profile,
          _ => JourneyBackgroundPage.explore,
        };
        final content = DestinationBackground(
          journeyId: state.activeJourneyId,
          pageType: pageType,
          child: IndexedStack(
            index: state.selectedTab,
            children: _pages,
          ),
        );""",
)
home = Path('app/lib/screens/home_shell.dart')
text = home.read_text()
text = text.replace(
    'backgroundColor: PhoenixTheme.paper,',
    'backgroundColor: Colors.transparent,',
)
text = text.replace(
    'color: PhoenixTheme.paper,\n                      child: Center(',
    'color: Colors.transparent,\n                      child: Center(',
)
text = text.replace(
    'return Scaffold(\n          body:',
    'return Scaffold(\n          backgroundColor: Colors.transparent,\n          body:',
    1,
)
home.write_text(text)
