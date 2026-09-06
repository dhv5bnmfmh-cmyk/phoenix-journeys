from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
text = path.read_text()


def replace_once(old: str, new: str, label: str):
    global text
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected 1 match, got {count}')
    text = text.replace(old, new, 1)


replace_once(
    "import '../data/forbidden_city_journey_runtime.dart';\n",
    "import '../data/forbidden_city_journey_runtime.dart';\n"
    "import '../data/forbidden_city_second_story_runtime.dart';\n",
    'second-story import',
)

replace_once(
    "  bool get _isForbiddenCity => _experience.id == forbiddenCityJourneyId;\n",
    "  bool get _isForbiddenCity => _experience.id == forbiddenCityJourneyId;\n"
    "  bool get _isSecondStoryPilot =>\n"
    "      _isForbiddenCity && forbiddenCitySecondStoryPilotRequested;\n"
    "  String get _activeStoryTitle => _isSecondStoryPilot\n"
    "      ? forbiddenCitySecondStoryPilotTitle\n"
    "      : _experience.storyTitle;\n",
    'pilot getters',
)

old_prepare = """    _appState = context.read<AppState>();
    _preparedBundle = JourneyPreparationCoordinator.instance.prepared(
          journeyId: _experience.id,
          profile: _sessionLanguageProfile,
          scriptMode: _appState.scriptMode.name,
        ) ??
        JourneyPreparationCoordinator.instance.prepareNow(
          journeyId: _experience.id,
          profile: _sessionLanguageProfile,
          scriptMode: _appState.scriptMode.name,
          knownWords: _appState.savedWords,
        );
    _preparedChallenge = const JourneyChallengeEngine().build(
      journeyId: _experience.id,
      sessionLevel: _sessionLanguageProfile.phoenixLevel ?? 1,
      storyParagraphs: _preparedBundle.challengeSourceMaterial,
    );
    step = _appState.beijingJourneyStep;
    if (_isForbiddenCity) {
      _forbiddenCityFinaleCompleted = _appState.journeyCompleted;
      if (_forbiddenCityFinaleCompleted || step >= AppState.journeyLastStep) {
        step = 4;
      }
    }
    wonderController.text = _appState.wonderDraft;
    expressController.text = _appState.expressDraft;
    memoryController.text = _appState.memoryDraft;
"""
new_prepare = """    _appState = context.read<AppState>();
    final sessionLevel = _sessionLanguageProfile.phoenixLevel ?? 1;
    if (_isSecondStoryPilot) {
      _preparedBundle = forbiddenCitySecondStoryPilotPreparedBundle(
        phoenixLevel: sessionLevel,
        scriptMode: _appState.scriptMode.name,
      );
      _preparedChallenge = forbiddenCitySecondStoryPilotChallengeSet(
        sessionLevel,
      );
      step = 0;
      _forbiddenCityFinaleCompleted = false;
    } else {
      _preparedBundle = JourneyPreparationCoordinator.instance.prepared(
            journeyId: _experience.id,
            profile: _sessionLanguageProfile,
            scriptMode: _appState.scriptMode.name,
          ) ??
          JourneyPreparationCoordinator.instance.prepareNow(
            journeyId: _experience.id,
            profile: _sessionLanguageProfile,
            scriptMode: _appState.scriptMode.name,
            knownWords: _appState.savedWords,
          );
      _preparedChallenge = const JourneyChallengeEngine().build(
        journeyId: _experience.id,
        sessionLevel: sessionLevel,
        storyParagraphs: _preparedBundle.challengeSourceMaterial,
      );
      step = _appState.beijingJourneyStep;
      if (_isForbiddenCity) {
        _forbiddenCityFinaleCompleted = _appState.journeyCompleted;
        if (_forbiddenCityFinaleCompleted || step >= AppState.journeyLastStep) {
          step = 4;
        }
      }
    }
    wonderController.text = _isSecondStoryPilot ? '' : _appState.wonderDraft;
    expressController.text = _isSecondStoryPilot ? '' : _appState.expressDraft;
    memoryController.text = _isSecondStoryPilot ? '' : _appState.memoryDraft;
"""
replace_once(old_prepare, new_prepare, 'prepared bundle routing')

replace_once(
    "  Future<void> _persistProgress({int? overrideStep}) {\n"
    "    return _appState.saveJourneyProgress(\n",
    "  Future<void> _persistProgress({int? overrideStep}) {\n"
    "    if (_isSecondStoryPilot) return Future<void>.value();\n"
    "    return _appState.saveJourneyProgress(\n",
    'pilot progress isolation',
)

replace_once(
    "  Future<void> _persistNarrationPosition() {\n"
    "    final contentId = _narration.contentId;\n",
    "  Future<void> _persistNarrationPosition() {\n"
    "    if (_isSecondStoryPilot) return Future<void>.value();\n"
    "    final contentId = _narration.contentId;\n",
    'pilot narration isolation',
)

old_title = "title: _appState.displayText(_experience.storyTitle),"
count = text.count(old_title)
if count < 1:
    raise SystemExit('active story title: no matches')
text = text.replace(old_title, "title: _appState.displayText(_activeStoryTitle),")

old_memory_inner = """      final memory = forbiddenCityMemoryForLevel(
        _sessionLanguageProfile.phoenixLevel ?? 1,
      );
      final completion = forbiddenCityCompletionForLevel(
        _sessionLanguageProfile.phoenixLevel ?? 1,
      );
"""
new_memory_inner = """      final runtimeLevel = _sessionLanguageProfile.phoenixLevel ?? 1;
      final memory = _isSecondStoryPilot
          ? forbiddenCitySecondStoryPilotMemoryForLevel(runtimeLevel)
          : forbiddenCityMemoryForLevel(runtimeLevel);
      final completion = _isSecondStoryPilot
          ? forbiddenCitySecondStoryPilotCompletionForLevel(runtimeLevel)
          : forbiddenCityCompletionForLevel(runtimeLevel);
"""
replace_once(old_memory_inner, new_memory_inner, 'memory narration routing')

old_memory_page = """    final memory = forbiddenCityMemoryForLevel(
      _sessionLanguageProfile.phoenixLevel ?? 1,
    );
    final completion = forbiddenCityCompletionForLevel(
      _sessionLanguageProfile.phoenixLevel ?? 1,
    );
"""
new_memory_page = """    final runtimeLevel = _sessionLanguageProfile.phoenixLevel ?? 1;
    final memory = _isSecondStoryPilot
        ? forbiddenCitySecondStoryPilotMemoryForLevel(runtimeLevel)
        : forbiddenCityMemoryForLevel(runtimeLevel);
    final completion = _isSecondStoryPilot
        ? forbiddenCitySecondStoryPilotCompletionForLevel(runtimeLevel)
        : forbiddenCityCompletionForLevel(runtimeLevel);
"""
replace_once(old_memory_page, new_memory_page, 'memory page routing')

replace_once(
    ".where((entry) => entry.journeyId == _experience.id && !entry.legacy);",
    ".where((entry) =>\n"
    "            !_isSecondStoryPilot &&\n"
    "            entry.journeyId == _experience.id &&\n"
    "            !entry.legacy);",
    'pilot memory isolation',
)

replace_once(
    "  Future<void> _finishJourney() async {\n"
    "    await _stopJourneyNarration();\n",
    "  Future<void> _finishJourney() async {\n"
    "    await _stopJourneyNarration();\n"
    "    if (_isSecondStoryPilot) {\n"
    "      if (!mounted) return;\n"
    "      setState(() {\n"
    "        _forbiddenCityFinaleCompleted = true;\n"
    "        step = 4;\n"
    "      });\n"
    "      return;\n"
    "    }\n",
    'pilot local completion',
)

replace_once(
    "  Future<void> _restartJourney() async {\n"
    "    await _stopJourneyNarration();\n"
    "    await _appState.restartJourney();\n",
    "  Future<void> _restartJourney() async {\n"
    "    await _stopJourneyNarration();\n"
    "    if (_isSecondStoryPilot) {\n"
    "      wonderController.clear();\n"
    "      expressController.clear();\n"
    "      memoryController.clear();\n"
    "      if (!mounted) return;\n"
    "      setState(() {\n"
    "        step = 0;\n"
    "        _challengeResolved = false;\n"
    "        _forbiddenCityFinaleCompleted = false;\n"
    "      });\n"
    "      return;\n"
    "    }\n"
    "    await _appState.restartJourney();\n",
    'pilot local restart',
)

replace_once(
    """                forbiddenCityChallengeRewardName,
                forbiddenCityChallengeRewardMeaning,
""",
    """                _isSecondStoryPilot
                    ? completion.storyClosure
                    : forbiddenCityChallengeRewardName,
                _isSecondStoryPilot
                    ? completion.relationship
                    : forbiddenCityChallengeRewardMeaning,
""",
    'memory completed narration',
)

old_completion_branch = """    if (_isForbiddenCity) {
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: [
          'Journey 完成',
          forbiddenCityChallengeRewardName,
          forbiddenCityChallengeRewardMeaning,
          'Lv.${_sessionLanguageProfile.phoenixLevel} Journey 已记录',
        ],
      );
    }
"""
new_completion_branch = """    if (_isForbiddenCity) {
      final completion = _isSecondStoryPilot
          ? forbiddenCitySecondStoryPilotCompletionForLevel(
              _sessionLanguageProfile.phoenixLevel ?? 1,
            )
          : null;
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: [
          'Journey 完成',
          completion?.storyClosure ?? forbiddenCityChallengeRewardName,
          completion?.relationship ?? forbiddenCityChallengeRewardMeaning,
          'Lv.${_sessionLanguageProfile.phoenixLevel} Journey 已记录',
        ],
      );
    }
"""
replace_once(old_completion_branch, new_completion_branch, 'completion narration routing')

reward_marker = "              title: 'Challenge Reward',\n"
marker_index = text.find(reward_marker)
if marker_index < 0:
    raise SystemExit('completion reward routing: marker missing')
reward_start = text.rfind('            const _ForbiddenCityCompleteCard(\n', 0, marker_index)
if reward_start < 0:
    raise SystemExit('completion reward routing: card start missing')
reward_end = text.find('            ),\n', marker_index)
if reward_end < 0:
    raise SystemExit('completion reward routing: card end missing')
reward_end += len('            ),\n')
new_reward_card = """            _ForbiddenCityCompleteCard(
              title: 'Challenge Reward',
              body: _isSecondStoryPilot
                  ? '${completion.storyClosure}\\n${completion.relationship}'
                  : '$forbiddenCityChallengeRewardName\\n$forbiddenCityChallengeRewardMeaning',
            ),
"""
text = text[:reward_start] + new_reward_card + text[reward_end:]

path.write_text(text)
