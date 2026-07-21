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
    'app/lib/screens/explore_screen.dart',
    "import '../state/app_state.dart';\n",
    "import '../models/journey_background.dart';\nimport '../state/app_state.dart';\n",
)
replace_once(
    'app/lib/screens/explore_screen.dart',
    "import '../theme/phoenix_theme.dart';\n",
    "import '../theme/phoenix_theme.dart';\nimport '../widgets/destination_background.dart';\n",
)
replace_once(
    'app/lib/screens/explore_screen.dart',
    'const Positioned.fill(child: _JourneyBackground()),',
    """Positioned.fill(
          child: _JourneyBackground(journeyId: state.activeJourneyId),
        ),""",
)
replace_once(
    'app/lib/screens/explore_screen.dart',
    """class _JourneyBackground extends StatelessWidget {
  const _JourneyBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7EA), Color(0xFFF6E7D4), PhoenixTheme.paper],
        ),
      ),
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}""",
    """class _JourneyBackground extends StatelessWidget {
  const _JourneyBackground({required this.journeyId});

  final String journeyId;

  @override
  Widget build(BuildContext context) {
    return DestinationBackground(
      journeyId: journeyId,
      pageType: JourneyBackgroundPage.explore,
      scrimStrength: .56,
      child: CustomPaint(painter: _CloudPainter()),
    );
  }
}""",
)

explore = Path('app/lib/screens/explore_screen.dart')
text = explore.read_text()
text = text.replace(
    """    if (state.hasJourneyInProgress)
      return '继续${state.activeJourney.city} Journey';""",
    """    if (state.hasJourneyInProgress) {
      return '继续${state.activeJourney.city} Journey';
    }""",
)
explore.write_text(text)
