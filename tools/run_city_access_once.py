from pathlib import Path

journey = Path('app/lib/screens/journey_screen.dart').read_text(encoding='utf-8')
explore = Path('app/lib/screens/explore_screen.dart').read_text(encoding='utf-8')

if '单屏模式' not in journey and 'choose-city-journey' in explore:
    raise SystemExit(0)

exec(
    compile(
        Path('tools/apply_city_journey_access.py').read_text(encoding='utf-8'),
        'tools/apply_city_journey_access.py',
        'exec',
    )
)
