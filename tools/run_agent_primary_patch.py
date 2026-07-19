from pathlib import Path

screen = Path('app/lib/screens/journey_screen.dart').read_text(encoding='utf-8')
if (
    'bool primaryLoading = false' in screen
    and "key: const ValueKey('ask-phoenix-guide-agent')" not in screen
    and "key: const ValueKey('ask-phoenix-writing-agent')" not in screen
):
    raise SystemExit(0)

exec(Path('tools/apply_agent_primary_actions.py').read_text(encoding='utf-8'))
