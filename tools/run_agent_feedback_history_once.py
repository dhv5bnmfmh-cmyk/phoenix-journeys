from pathlib import Path

state = Path('app/lib/state/app_state.dart').read_text(encoding='utf-8')
screen = Path('app/lib/screens/journey_screen.dart').read_text(encoding='utf-8')

if 'Future<void> saveGuideFeedback' in state and 'secondaryButtonText' in screen:
    raise SystemExit(0)

exec(
    compile(
        Path('tools/apply_agent_feedback_history_v2.py').read_text(encoding='utf-8'),
        'tools/apply_agent_feedback_history_v2.py',
        'exec',
    )
)
