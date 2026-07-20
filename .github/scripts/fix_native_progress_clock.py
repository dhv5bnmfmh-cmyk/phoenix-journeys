from pathlib import Path

path = Path('app/lib/services/narration_controller.dart')
text = path.read_text(encoding='utf-8')
old = "      final charsPerSecond = 3.35 * _speechRate;\n"
new = (
    "      final charsPerSecond =\n"
    "          _nativeCharsPerSecond(_narrationLanguageCode) * _speechRate;\n"
)
if text.count(old) != 1:
    raise SystemExit(f'expected one old progress clock, found {text.count(old)}')
path.write_text(text.replace(old, new, 1), encoding='utf-8')
Path('.github/scripts/fix_native_progress_clock.py').unlink()
Path('.github/workflows/fix-native-progress-clock.yml').unlink()
