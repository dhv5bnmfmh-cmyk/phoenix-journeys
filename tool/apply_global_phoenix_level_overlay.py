from pathlib import Path

home_path = Path('app/lib/screens/home_shell.dart')
home = home_path.read_text(encoding='utf-8')

old_import = "import '../widgets/destination_background.dart';\n"
new_import = (
    "import '../widgets/destination_background.dart';\n"
    "import '../widgets/journey_level_selector_button.dart';\n"
)
if old_import not in home:
    raise SystemExit('HomeShell import anchor not found')
home = home.replace(old_import, new_import, 1)

old_content = '''        final content = state.selectedTab == 0
            ? indexedPages
            : DestinationBackground(
                journeyId: state.activeJourneyId,
                pageType: pageType,
                child: indexedPages,
              );
'''
new_content = '''        final baseContent = state.selectedTab == 0
            ? indexedPages
            : DestinationBackground(
                journeyId: state.activeJourneyId,
                pageType: pageType,
                child: indexedPages,
              );
        final content = Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: baseContent),
            const Positioned(
              top: 6,
              right: 8,
              child: JourneyLevelSelectorButton(compact: true),
            ),
          ],
        );
'''
if old_content not in home:
    raise SystemExit('HomeShell content anchor not found')
home = home.replace(old_content, new_content, 1)
home_path.write_text(home, encoding='utf-8')

city_path = Path('app/lib/screens/city_passport_screen.dart')
city = city_path.read_text(encoding='utf-8')
city = city.replace("import '../widgets/journey_level_selector_button.dart';\n", '', 1)
old_city_control = '''        const JourneyLevelSelectorButton(compact: true),
        const SizedBox(width: 6),
'''
if old_city_control not in city:
    raise SystemExit('City passport duplicate level control not found')
city = city.replace(old_city_control, '', 1)
city_path.write_text(city, encoding='utf-8')

Path('tool/apply_global_phoenix_level_overlay.py').unlink(missing_ok=True)
Path('.github/workflows/apply-global-phoenix-level-overlay.yml').unlink(missing_ok=True)
