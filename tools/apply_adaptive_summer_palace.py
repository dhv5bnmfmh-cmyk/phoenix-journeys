from pathlib import Path


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f"{label}: expected exactly one match, found {count}")
    return text.replace(old, new, 1)


root = Path(".")

# Fix the apostrophe that must be escaped in the generated pinyin string.
catalog_path = root / "app/lib/data/journey_level_catalog.dart"
catalog = catalog_path.read_text(encoding="utf-8")
catalog = catalog.replace("fǎn'ér", "fǎn\\'ér")
catalog_path.write_text(catalog, encoding="utf-8")

state_path = root / "app/lib/state/app_state.dart"
state = state_path.read_text(encoding="utf-8")
state = replace_once(
    state,
    "import '../data/daily_journey_catalog.dart';\n",
    "import '../data/daily_journey_catalog.dart';\n"
    "import '../data/journey_level_catalog.dart';\n",
    "AppState level import",
)
state = replace_once(
    state,
    "  String translationLanguage = '越南语';\n"
    "  int selectedTab = 0;\n",
    "  String translationLanguage = '越南语';\n"
    "  JourneyDifficulty journeyDifficulty = JourneyDifficulty.standard;\n"
    "  bool journeyDifficultyChosen = false;\n"
    "  int selectedTab = 0;\n",
    "AppState level fields",
)
state = replace_once(
    state,
    "  void _loadActiveJourney(SharedPreferences prefs) {\n"
    "    final isLegacyBeijing = activeJourneyId == 'beijing-forbidden-city';\n",
    "  void _loadActiveJourney(SharedPreferences prefs) {\n"
    "    final isLegacyBeijing = activeJourneyId == 'beijing-forbidden-city';\n"
    "    final storedDifficulty = _readJourneyString(prefs, 'difficulty');\n"
    "    journeyDifficulty = parseJourneyDifficulty(storedDifficulty);\n"
    "    journeyDifficultyChosen = storedDifficulty != null;\n",
    "AppState load difficulty",
)
state = replace_once(
    state,
    "  Future<void> setTranslationLanguage(String value) async {\n"
    "    translationLanguage = value;\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await prefs.setString('translationLanguage', value);\n"
    "    notifyListeners();\n"
    "  }\n\n",
    "  Future<void> setTranslationLanguage(String value) async {\n"
    "    translationLanguage = value;\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await prefs.setString('translationLanguage', value);\n"
    "    notifyListeners();\n"
    "  }\n\n"
    "  Future<void> setJourneyDifficulty(JourneyDifficulty value) async {\n"
    "    journeyDifficulty = value;\n"
    "    journeyDifficultyChosen = true;\n"
    "    notifyListeners();\n\n"
    "    final prefs = await SharedPreferences.getInstance();\n"
    "    await prefs.setString(_key('difficulty'), value.storageValue);\n"
    "  }\n\n",
    "AppState set difficulty",
)
state_path.write_text(state, encoding="utf-8")

screen_path = root / "app/lib/screens/journey_screen.dart"
screen = screen_path.read_text(encoding="utf-8")
screen = replace_once(
    screen,
    "import '../data/journey_data.dart';\n"
    "import '../data/world_story_runtime.dart';\n"
    "import '../models/journey_background.dart';\n"
    "import '../models/story_content.dart';\n",
    "import '../data/journey_data.dart';\n"
    "import '../data/journey_level_catalog.dart';\n"
    "import '../models/journey_background.dart';\n",
    "JourneyScreen imports",
)
screen = replace_once(
    screen,
    "  late final DailyJourneyExperience _experience;\n"
    "  late final JourneyContentRecord _journeyContent;\n"
    "  late final PhoenixAiService _ai;\n",
    "  late final DailyJourneyExperience _experience;\n"
    "  late final PhoenixAiService _ai;\n",
    "JourneyScreen remove content field",
)
screen = replace_once(
    screen,
    "  bool _initialized = false;\n"
    "  bool _discoveryAutoStarted = false;\n",
    "  bool _initialized = false;\n"
    "  bool _discoveryAutoStarted = false;\n"
    "  bool _difficultyPromptScheduled = false;\n",
    "JourneyScreen prompt field",
)
screen = replace_once(
    screen,
    "    _narration = NarrationController();\n"
    "    final worldStoryAgent = createPhoenixWorldStoryAgent();\n"
    "    final journeyId =\n"
    "        widget.journeyId ?? dailyJourneyForDate(DateTime.now()).id;\n"
    "    _experience = requireDailyJourneyExperience(journeyId);\n"
    "    _journeyContent = requireJourneyContent(worldStoryAgent, _experience.id);\n"
    "    _ai = PhoenixAiService();\n",
    "    _narration = NarrationController();\n"
    "    final journeyId =\n"
    "        widget.journeyId ?? dailyJourneyForDate(DateTime.now()).id;\n"
    "    _experience = requireDailyJourneyExperience(journeyId);\n"
    "    _ai = PhoenixAiService();\n",
    "JourneyScreen initialization",
)
screen = replace_once(
    screen,
    "    _initialized = true;\n\n"
    "    if (step == 2) _scheduleDiscoveryAutoStart();\n",
    "    _initialized = true;\n"
    "    unawaited(\n"
    "      _narration.setSpeechRate(_appState.journeyDifficulty.speechRate),\n"
    "    );\n"
    "    _scheduleDifficultyWelcome();\n\n"
    "    if (step == 2) _scheduleDiscoveryAutoStart();\n",
    "JourneyScreen dependency initialization",
)
screen = replace_once(
    screen,
    "  Future<void> _persistProgress({int? overrideStep}) {\n"
    "    return _appState.saveJourneyProgress(\n"
    "      step: overrideStep ?? step,\n"
    "      wonder: wonderController.text,\n"
    "      express: expressController.text,\n"
    "      memory: memoryController.text,\n"
    "    );\n"
    "  }\n\n",
    "  Future<void> _persistProgress({int? overrideStep}) {\n"
    "    return _appState.saveJourneyProgress(\n"
    "      step: overrideStep ?? step,\n"
    "      wonder: wonderController.text,\n"
    "      express: expressController.text,\n"
    "      memory: memoryController.text,\n"
    "    );\n"
    "  }\n\n"
    "  JourneyLevelContent get _levelContent =>\n"
    "      resolveJourneyLevel(_experience, _appState.journeyDifficulty);\n\n"
    "  List<JourneyDifficulty> get _supportedDifficulties =>\n"
    "      supportedJourneyDifficulties(_experience);\n\n"
    "  Future<void> _changeDifficulty(JourneyDifficulty value) async {\n"
    "    if (value == _appState.journeyDifficulty &&\n"
    "        _appState.journeyDifficultyChosen) {\n"
    "      return;\n"
    "    }\n"
    "    await _narration.stop();\n"
    "    await _narration.setSpeechRate(value.speechRate);\n"
    "    await _appState.setJourneyDifficulty(value);\n"
    "    if (!mounted) return;\n"
    "    setState(() => _discoveryAutoStarted = false);\n"
    "    if (step == 2) _scheduleDiscoveryAutoStart();\n"
    "  }\n\n"
    "  void _scheduleDifficultyWelcome() {\n"
    "    if (_difficultyPromptScheduled ||\n"
    "        _appState.journeyDifficultyChosen ||\n"
    "        _supportedDifficulties.length < 2) {\n"
    "      return;\n"
    "    }\n"
    "    _difficultyPromptScheduled = true;\n"
    "    WidgetsBinding.instance.addPostFrameCallback((_) {\n"
    "      if (mounted) unawaited(_showDifficultyWelcome());\n"
    "    });\n"
    "  }\n\n"
    "  Future<void> _showDifficultyWelcome() async {\n"
    "    final selected = await showModalBottomSheet<JourneyDifficulty>(\n"
    "      context: context,\n"
    "      useSafeArea: true,\n"
    "      showDragHandle: true,\n"
    "      builder: (sheetContext) {\n"
    "        return Padding(\n"
    "          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),\n"
    "          child: Column(\n"
    "            mainAxisSize: MainAxisSize.min,\n"
    "            crossAxisAlignment: CrossAxisAlignment.start,\n"
    "            children: [\n"
    "              Text(\n"
    "                _appState.displayText('选择适合你的旅程'),\n"
    "                style: const TextStyle(\n"
    "                  fontSize: 18,\n"
    "                  fontWeight: FontWeight.w900,\n"
    "                ),\n"
    "              ),\n"
    "              const SizedBox(height: 4),\n"
    "              Text(\n"
    "                _appState.displayText('目的地不变，只调整中文难度。之后可以随时更换。'),\n"
    "                style: const TextStyle(fontSize: 12, height: 1.35),\n"
    "              ),\n"
    "              const SizedBox(height: 10),\n"
    "              for (final difficulty in _supportedDifficulties)\n"
    "                ListTile(\n"
    "                  key: ValueKey(\n"
    "                    'journey-difficulty-welcome-${difficulty.storageValue}',\n"
    "                  ),\n"
    "                  contentPadding: EdgeInsets.zero,\n"
    "                  leading: CircleAvatar(\n"
    "                    backgroundColor: PhoenixTheme.red.withValues(alpha: .12),\n"
    "                    child: Text(\n"
    "                      difficulty == JourneyDifficulty.easy\n"
    "                          ? '轻'\n"
    "                          : difficulty == JourneyDifficulty.standard\n"
    "                          ? '标'\n"
    "                          : '挑',\n"
    "                      style: const TextStyle(\n"
    "                        color: PhoenixTheme.red,\n"
    "                        fontWeight: FontWeight.w900,\n"
    "                      ),\n"
    "                    ),\n"
    "                  ),\n"
    "                  title: Row(\n"
    "                    children: [\n"
    "                      Text(\n"
    "                        _appState.displayText(difficulty.label),\n"
    "                        style: const TextStyle(fontWeight: FontWeight.w900),\n"
    "                      ),\n"
    "                      if (difficulty == JourneyDifficulty.standard) ...[\n"
    "                        const SizedBox(width: 7),\n"
    "                        const Text(\n"
    "                          '推荐',\n"
    "                          style: TextStyle(\n"
    "                            color: PhoenixTheme.red,\n"
    "                            fontSize: 10,\n"
    "                            fontWeight: FontWeight.w900,\n"
    "                          ),\n"
    "                        ),\n"
    "                      ],\n"
    "                    ],\n"
    "                  ),\n"
    "                  subtitle: Text(_appState.displayText(difficulty.hint)),\n"
    "                  trailing: const Icon(Icons.chevron_right_rounded),\n"
    "                  onTap: () => Navigator.of(sheetContext).pop(difficulty),\n"
    "                ),\n"
    "            ],\n"
    "          ),\n"
    "        );\n"
    "      },\n"
    "    );\n"
    "    await _changeDifficulty(selected ?? JourneyDifficulty.standard);\n"
    "  }\n\n",
    "JourneyScreen level helpers",
)
screen = screen.replace("_journeyContent.storyParagraphs", "_levelContent.storyParagraphs")
screen = screen.replace("_experience.storyAnnotations", "_levelContent.storyAnnotations")
screen = screen.replace("_experience.words", "_levelContent.words")
screen = screen.replace("_experience.discoveries", "_levelContent.discoveries")
screen = screen.replace("_experience.wonderQuestion", "_levelContent.wonderQuestion")
screen = screen.replace("_experience.expressQuestion", "_levelContent.expressQuestion")
screen = replace_once(
    screen,
    "      'currentLevel': '根据学习者本次中文动态判断',\n",
    "      'currentLevel': _appState.journeyDifficulty.label,\n",
    "JourneyScreen AI level profile",
)
screen = replace_once(
    screen,
    "          actions: [\n"
    "            Consumer<AppState>(\n"
    "              builder: (_, state, __) => TextButton(\n"
    "                onPressed: state.toggleScript,\n"
    "                style: TextButton.styleFrom(\n"
    "                  visualDensity: VisualDensity.compact,\n"
    "                  padding: const EdgeInsets.symmetric(horizontal: 8),\n"
    "                ),\n"
    "                child: Text(\n"
    "                  state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',\n"
    "                  style: const TextStyle(fontSize: 10.5),\n"
    "                ),\n"
    "              ),\n"
    "            ),\n"
    "          ],\n",
    "          actions: [\n"
    "            Consumer<AppState>(\n"
    "              builder: (_, state, __) {\n"
    "                if (_supportedDifficulties.length < 2) {\n"
    "                  return const SizedBox.shrink();\n"
    "                }\n"
    "                return PopupMenuButton<JourneyDifficulty>(\n"
    "                  key: const ValueKey('journey-difficulty-selector'),\n"
    "                  tooltip: _appState.displayText('选择旅程难度'),\n"
    "                  initialValue: state.journeyDifficulty,\n"
    "                  onSelected: (value) => unawaited(_changeDifficulty(value)),\n"
    "                  itemBuilder: (_) => [\n"
    "                    for (final difficulty in _supportedDifficulties)\n"
    "                      PopupMenuItem<JourneyDifficulty>(\n"
    "                        value: difficulty,\n"
    "                        child: Row(\n"
    "                          children: [\n"
    "                            Expanded(\n"
    "                              child: Column(\n"
    "                                crossAxisAlignment: CrossAxisAlignment.start,\n"
    "                                children: [\n"
    "                                  Text(\n"
    "                                    state.displayText(difficulty.label),\n"
    "                                    style: const TextStyle(\n"
    "                                      fontWeight: FontWeight.w900,\n"
    "                                    ),\n"
    "                                  ),\n"
    "                                  Text(\n"
    "                                    state.displayText(difficulty.hint),\n"
    "                                    style: const TextStyle(fontSize: 10.5),\n"
    "                                  ),\n"
    "                                ],\n"
    "                              ),\n"
    "                            ),\n"
    "                            if (state.journeyDifficulty == difficulty)\n"
    "                              const Icon(\n"
    "                                Icons.check_rounded,\n"
    "                                size: 18,\n"
    "                                color: PhoenixTheme.red,\n"
    "                              ),\n"
    "                          ],\n"
    "                        ),\n"
    "                      ),\n"
    "                  ],\n"
    "                  child: Container(\n"
    "                    margin: const EdgeInsets.symmetric(vertical: 8),\n"
    "                    padding: const EdgeInsets.symmetric(horizontal: 8),\n"
    "                    decoration: BoxDecoration(\n"
    "                      color: Colors.black.withValues(alpha: .22),\n"
    "                      borderRadius: BorderRadius.circular(99),\n"
    "                      border: Border.all(\n"
    "                        color: Colors.white.withValues(alpha: .2),\n"
    "                      ),\n"
    "                    ),\n"
    "                    alignment: Alignment.center,\n"
    "                    child: Text(\n"
    "                      state.displayText('${state.journeyDifficulty.label} ▾'),\n"
    "                      style: const TextStyle(\n"
    "                        color: Colors.white,\n"
    "                        fontSize: 10,\n"
    "                        fontWeight: FontWeight.w900,\n"
    "                      ),\n"
    "                    ),\n"
    "                  ),\n"
    "                );\n"
    "              },\n"
    "            ),\n"
    "            Consumer<AppState>(\n"
    "              builder: (_, state, __) => TextButton(\n"
    "                onPressed: state.toggleScript,\n"
    "                style: TextButton.styleFrom(\n"
    "                  visualDensity: VisualDensity.compact,\n"
    "                  padding: const EdgeInsets.symmetric(horizontal: 8),\n"
    "                ),\n"
    "                child: Text(\n"
    "                  state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',\n"
    "                  style: const TextStyle(fontSize: 10.5),\n"
    "                ),\n"
    "              ),\n"
    "            ),\n"
    "          ],\n",
    "JourneyScreen difficulty selector",
)
screen = replace_once(
    screen,
    "            subtitle: '普通话 · ${_levelContent.storyParagraphs.length} 段',\n",
    "            subtitle:\n"
    "                '${_appState.journeyDifficulty.label} · 普通话 · ${_levelContent.storyParagraphs.length} 段',\n",
    "JourneyScreen story level subtitle",
)
screen = replace_once(
    screen,
    "            subtitle: '中文朗读 · ${_levelContent.discoveries.length} 段',\n",
    "            subtitle:\n"
    "                '${_appState.journeyDifficulty.label} · 中文朗读 · ${_levelContent.discoveries.length} 段',\n",
    "JourneyScreen discovery level subtitle",
)
screen_path.write_text(screen, encoding="utf-8")

docs_path = root / "docs/development-workflow.md"
docs = docs_path.read_text(encoding="utf-8")
rule = (
    "\n- Adaptive journey rule: a destination may offer light, standard, and "
    "challenge Chinese content without changing its identity, background, "
    "progress, or stamp; the explorer can switch levels and the choice persists.\n"
)
if "Adaptive journey rule:" not in docs:
    docs += rule
docs_path.write_text(docs, encoding="utf-8")
