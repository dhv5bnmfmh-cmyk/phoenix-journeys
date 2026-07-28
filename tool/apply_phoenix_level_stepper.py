from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text(encoding='utf-8')


def require_replace(old: str, new: str) -> None:
    global text
    if old not in text:
        raise SystemExit(f'Expected journey_screen.dart fragment not found:\n{old[:180]}')
    text = text.replace(old, new, 1)


require_replace(
    "import '../services/language_level_preference_store.dart';\n",
    "import '../services/language_level_preference_store.dart';\n"
    "import '../services/phoenix_level_controller.dart';\n",
)
require_replace(
    "import '../widgets/journey_challenge_panel.dart';\n",
    "import '../widgets/journey_challenge_panel.dart';\n"
    "import '../widgets/journey_level_selector_button.dart';\n",
)
require_replace(
    "  static const LanguageLevelPreferenceStore _languageLevelStore =\n"
    "      LanguageLevelPreferenceStore();\n"
    "  ChineseProficiencyProfile? _languageProfile;\n"
    "  bool _languageProfilePromptScheduled = false;\n",
    "  static const LanguageLevelPreferenceStore _languageLevelStore =\n"
    "      LanguageLevelPreferenceStore();\n"
    "  static final PhoenixLevelController _phoenixLevelController =\n"
    "      PhoenixLevelController.instance;\n"
    "  ChineseProficiencyProfile? _languageProfile;\n"
    "  int _levelChangeToken = 0;\n",
)
require_replace(
    "    _narration = NarrationController();\n",
    "    _narration = NarrationController();\n"
    "    _phoenixLevelController.addListener(_handlePhoenixLevelChanged);\n",
)
require_replace(
    "    _narration.dispose();\n",
    "    _phoenixLevelController.removeListener(_handlePhoenixLevelChanged);\n"
    "    _narration.dispose();\n",
)

start = text.index('  Future<void> _loadLanguageProfile() async {')
end = text.index('  Future<void> _goToStep(int targetStep) async {')
replacement = '''  Future<void> _loadLanguageProfile() async {
    final profile = await _languageLevelStore.load();
    if (!mounted || profile == null) return;
    await _narration.setSpeechRate(
      _languageLevelAgent.planFor(profile).speechRate,
    );
    if (!mounted) return;
    setState(() => _languageProfile = profile);
  }

  void _handlePhoenixLevelChanged() {
    unawaited(_applyPhoenixLevelChange());
  }

  Future<void> _applyPhoenixLevelChange() async {
    if (!_initialized) return;
    final token = ++_levelChangeToken;
    final profile = _phoenixLevelController.profile;

    await _narration.stop();
    await _narration.setSpeechRate(
      _languageLevelAgent.planFor(profile).speechRate,
    );
    await Future.wait([
      _appState.clearGuideFeedback(),
      _appState.clearWritingFeedback(),
    ]);
    if (!mounted || token != _levelChangeToken) return;

    setState(() {
      _languageProfile = profile;
      _guideFeedback = null;
      _writingFeedback = null;
      _challengeResolved = false;
      _challengeSeed += 1;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _appState.displayText(
              '${profile.displayLabel} 已即时应用到当前故事与挑战',
            ),
          ),
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

'''
text = text[:start] + replacement + text[end:]

selector_start = text.index(
    "            Tooltip(\n"
    "              message: _appState.displayText('切换 HSK / TOCFL 等级'),"
)
selector_end = text.index('            Consumer<AppState>(', selector_start)
selector = '''            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: JourneyLevelSelectorButton(compact: true),
            ),
'''
text = text[:selector_start] + selector + text[selector_end:]

path.write_text(text, encoding='utf-8')

# Remove this one-time migration machinery after applying the source patch.
Path('tool/apply_phoenix_level_stepper.py').unlink(missing_ok=True)
Path('.github/workflows/apply-phoenix-level-stepper.yml').unlink(missing_ok=True)
