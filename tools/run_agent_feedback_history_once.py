from pathlib import Path
import subprocess
import traceback

state = Path('app/lib/state/app_state.dart').read_text(encoding='utf-8')
screen = Path('app/lib/screens/journey_screen.dart').read_text(encoding='utf-8')
diagnostic = Path('tools/agent_patch_error.txt')

if 'Future<void> saveGuideFeedback' in state and 'secondaryButtonText' in screen:
    if diagnostic.exists():
        diagnostic.unlink()
    raise SystemExit(0)

if diagnostic.exists():
    diagnostic.unlink()

try:
    source = Path('tools/apply_agent_feedback_history_v2.py').read_text(
        encoding='utf-8'
    )
    source = source.replace(
        """    primary = re.compile(
        r"(                       Expanded\\(\\n"
        r"                         flex: 2,\\n"
        r"                         child: FilledButton\\.icon\\(\\n)"
    )
""",
        """    primary = re.compile(
        r"(\\n\\s*Expanded\\(\\n\\s*flex: 2,\\n\\s*child: FilledButton\\.icon\\(\\n)"
    )
""",
    )
    exec(
        compile(
            source,
            'tools/apply_agent_feedback_history_v2.py',
            'exec',
        )
    )
except Exception as error:
    diagnostic.write_text(
        f'{type(error).__name__}: {error}\n\n{traceback.format_exc()}',
        encoding='utf-8',
    )
    subprocess.run(
        [
            'git',
            'checkout',
            '--',
            'app/lib/state/app_state.dart',
            'app/lib/screens/journey_screen.dart',
        ],
        check=True,
    )
    for path in [
        Path('app/test/journey_feedback_persistence_test.dart'),
        Path('worker/agent_feedback_history_rule.test.mjs'),
    ]:
        if path.exists():
            path.unlink()
