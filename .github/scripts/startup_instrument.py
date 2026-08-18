from pathlib import Path
import sys

root = Path(sys.argv[1])
check_only = '--check-only' in sys.argv[2:]
lib = root / 'app' / 'lib'
main_path = lib / 'main.dart'
state_path = lib / 'state' / 'access_controlled_app_state.dart'
app_state_path = lib / 'state' / 'app_state.dart'
daily_catalog_path = lib / 'data' / 'daily_journey_catalog.dart'
location_path = lib / 'services' / 'journey_location_binding.dart'
main = main_path.read_text(encoding='utf-8')
state = state_path.read_text(encoding='utf-8')
app_state = app_state_path.read_text(encoding='utf-8')
daily_catalog = daily_catalog_path.read_text(encoding='utf-8')
location = location_path.read_text(encoding='utf-8')

anchors = {
    'main': {
        'main import': "import 'app.dart';\n",
        'main startup': "Future<void> main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n  await const LanguageLevelPreferenceStore().initializePhoenixLevel();\n",
        'runApp callback': "    () {\n      runApp(\n",
    },
    'state': {
        'state foundation import': "import 'package:flutter/foundation.dart';\n",
        'state catalog import': "import '../data/daily_journey_catalog.dart';\n",
        'state load start': "  Future<void> load() async {\n    loadStatus = AppLoadStatus.loading;\n",
        'preferences load': "      final preferences = await _preferencesLoader();\n      _preferences = preferences;\n      _restoreNonCriticalPreferences(preferences);\n",
        'critical read': "      var committed = await _criticalStore!.readCommitted();\n      if (committed == null) {\n",
        'legacy build': "        final legacy = await _buildLegacySnapshot(preferences);\n        legacy.snapshot.validate();\n",
        'legacy commit': "        committed = await _criticalStore!.commitInitial(\n          legacy.snapshot.toJson(),\n        );\n",
        'snapshot decode': "      final snapshot = _PhoenixCriticalSnapshot.fromJson(committed.payload)\n        ..validate();\n",
        'apply committed': "      _applyCommitted(\n        snapshot,\n        revision: committed.revision,\n        schemaVersion: committed.schemaVersion,\n      );\n",
        'restore eligibility': "      if (!_canRestoreActiveJourney(activeJourneyId)) {\n        throw StateError(\n          'Persisted active Journey is not eligible for safe restore.',\n        );\n      }\n",
        'state ready': "      _activeIdentityReady = true;\n      loadStatus = AppLoadStatus.ready;\n    } catch (error, stackTrace) {\n",
        'final load notification': "    notifyListeners();\n  }\n\n  @override\n  Future<void> activateJourney",
    },
    'app_state': {
        'app state catalog import': "import '../data/daily_journey_catalog.dart';\n",
        'daily journey constructor': "    activeJourneyId = dailyJourneyForDate(_clock()).id;\n",
    },
    'daily_catalog': {
        'catalog import': "import '../models/story_content.dart';\n",
        'daily journey function': "DailyJourneyExperience dailyJourneyForDate(DateTime date) {\n  final day = DateTime.utc(date.year, date.month, date.day);\n  final epoch = DateTime.utc(2026, 1, 1);\n  final dayNumber = day.difference(epoch).inDays;\n  final index = dayNumber % dailyJourneyExperiences.length;\n  return dailyJourneyExperiences[index < 0\n      ? index + dailyJourneyExperiences.length\n      : index];\n}\n",
    },
    'location': {
        'location model import': "import '../models/geo_node.dart';\n",
        'binding build start': "Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {\n  final bindings = <String, JourneyLocationBinding>{};\n",
        'binding build end': "  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);\n}\n\nJourneyLocationBinding requireJourneyLocation",
    },
}

texts = {
    'main': main,
    'state': state,
    'app_state': app_state,
    'daily_catalog': daily_catalog,
    'location': location,
}
failures = []
for group, group_anchors in anchors.items():
    text = texts[group]
    for name, anchor in group_anchors.items():
        count = text.count(anchor)
        print(f'ANCHOR {group}:{name} MATCH COUNT = {count}')
        if count != 1:
            failures.append(f'{group}:{name} count={count}')
if failures:
    print('STARTUP INSTRUMENTATION ANCHOR PREFLIGHT = FAIL')
    for failure in failures:
        print(f'ANCHOR FAILURE = {failure}')
    raise SystemExit(1)
print('ALL STARTUP INSTRUMENTATION ANCHORS = PASS')
if check_only:
    raise SystemExit(0)

probe_path = lib / 'startup_performance_probe.dart'
probe_path.write_text(
    "import 'dart:html' as html;\n\n"
    "void startupPerformanceMark(String name) {\n"
    "  html.window.performance.mark(name);\n"
    "}\n",
    encoding='utf-8',
)

main = main.replace(
    anchors['main']['main import'],
    "import 'app.dart';\nimport 'startup_performance_probe.dart';\n",
    1,
)
main = main.replace(
    anchors['main']['main startup'],
    "Future<void> main() async {\n"
    "  startupPerformanceMark('phoenix-main-entry');\n"
    "  WidgetsFlutterBinding.ensureInitialized();\n"
    "  startupPerformanceMark('phoenix-language-init-start');\n"
    "  await const LanguageLevelPreferenceStore().initializePhoenixLevel();\n"
    "  startupPerformanceMark('phoenix-language-init-end');\n",
    1,
)
main = main.replace(
    anchors['main']['runApp callback'],
    "    () {\n"
    "      startupPerformanceMark('phoenix-runapp-start');\n"
    "      WidgetsBinding.instance.addPostFrameCallback((_) {\n"
    "        startupPerformanceMark('phoenix-first-frame');\n"
    "      });\n"
    "      runApp(\n",
    1,
)
main_path.write_text(main, encoding='utf-8')

state = state.replace(
    anchors['state']['state foundation import'],
    "import 'package:flutter/foundation.dart';\nimport 'package:flutter/scheduler.dart';\n",
    1,
)
state = state.replace(
    anchors['state']['state catalog import'],
    "import '../data/daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n",
    1,
)
state = state.replace(
    anchors['state']['state load start'],
    "  Future<void> load() async {\n"
    "    startupPerformanceMark('phoenix-state-load-start');\n"
    "    loadStatus = AppLoadStatus.loading;\n",
    1,
)
state = state.replace(
    anchors['state']['preferences load'],
    "      startupPerformanceMark('phoenix-preferences-start');\n"
    "      final preferences = await _preferencesLoader();\n"
    "      startupPerformanceMark('phoenix-preferences-ready');\n"
    "      _preferences = preferences;\n"
    "      _restoreNonCriticalPreferences(preferences);\n"
    "      startupPerformanceMark('phoenix-noncritical-preferences-restored');\n",
    1,
)
state = state.replace(
    anchors['state']['critical read'],
    "      startupPerformanceMark('phoenix-critical-read-start');\n"
    "      var committed = await _criticalStore!.readCommitted();\n"
    "      startupPerformanceMark('phoenix-critical-read-end');\n"
    "      if (committed == null) {\n"
    "        startupPerformanceMark('phoenix-legacy-path-start');\n",
    1,
)
state = state.replace(
    anchors['state']['legacy build'],
    "        startupPerformanceMark('phoenix-legacy-build-start');\n"
    "        final legacy = await _buildLegacySnapshot(preferences);\n"
    "        startupPerformanceMark('phoenix-legacy-build-end');\n"
    "        startupPerformanceMark('phoenix-legacy-validate-start');\n"
    "        legacy.snapshot.validate();\n"
    "        startupPerformanceMark('phoenix-legacy-validate-end');\n",
    1,
)
state = state.replace(
    anchors['state']['legacy commit'],
    "        startupPerformanceMark('phoenix-commit-initial-start');\n"
    "        committed = await _criticalStore!.commitInitial(\n"
    "          legacy.snapshot.toJson(),\n"
    "        );\n"
    "        startupPerformanceMark('phoenix-commit-initial-end');\n"
    "        startupPerformanceMark('phoenix-legacy-path-end');\n",
    1,
)
state = state.replace(
    anchors['state']['snapshot decode'],
    "      startupPerformanceMark('phoenix-snapshot-decode-validate-start');\n"
    "      final snapshot = _PhoenixCriticalSnapshot.fromJson(committed.payload)\n"
    "        ..validate();\n"
    "      startupPerformanceMark('phoenix-snapshot-decode-validate-end');\n",
    1,
)
state = state.replace(
    anchors['state']['apply committed'],
    "      startupPerformanceMark('phoenix-apply-committed-start');\n"
    "      _applyCommitted(\n"
    "        snapshot,\n"
    "        revision: committed.revision,\n"
    "        schemaVersion: committed.schemaVersion,\n"
    "      );\n"
    "      startupPerformanceMark('phoenix-apply-committed-end');\n",
    1,
)
state = state.replace(
    anchors['state']['restore eligibility'],
    "      startupPerformanceMark('phoenix-restore-eligibility-start');\n"
    "      if (!_canRestoreActiveJourney(activeJourneyId)) {\n"
    "        throw StateError(\n"
    "          'Persisted active Journey is not eligible for safe restore.',\n"
    "        );\n"
    "      }\n"
    "      startupPerformanceMark('phoenix-restore-eligibility-end');\n",
    1,
)
state = state.replace(
    anchors['state']['state ready'],
    "      _activeIdentityReady = true;\n"
    "      loadStatus = AppLoadStatus.ready;\n"
    "      startupPerformanceMark('phoenix-state-ready');\n"
    "    } catch (error, stackTrace) {\n",
    1,
)
state = state.replace(
    anchors['state']['final load notification'],
    "    notifyListeners();\n"
    "    if (loadStatus == AppLoadStatus.ready) {\n"
    "      SchedulerBinding.instance.addPostFrameCallback((_) {\n"
    "        startupPerformanceMark('phoenix-first-meaningful-screen');\n"
    "      });\n"
    "    }\n"
    "  }\n\n"
    "  @override\n"
    "  Future<void> activateJourney",
    1,
)
state_path.write_text(state, encoding='utf-8')

app_state = app_state.replace(
    anchors['app_state']['app state catalog import'],
    "import '../data/daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n",
    1,
)
app_state = app_state.replace(
    anchors['app_state']['daily journey constructor'],
    "    startupPerformanceMark('phoenix-appstate-daily-journey-start');\n"
    "    activeJourneyId = dailyJourneyForDate(_clock()).id;\n"
    "    startupPerformanceMark('phoenix-appstate-daily-journey-end');\n",
    1,
)
app_state_path.write_text(app_state, encoding='utf-8')

daily_catalog = daily_catalog.replace(
    anchors['daily_catalog']['catalog import'],
    "import '../models/story_content.dart';\nimport '../startup_performance_probe.dart';\n",
    1,
)
daily_catalog = daily_catalog.replace(
    anchors['daily_catalog']['daily journey function'],
    "DailyJourneyExperience dailyJourneyForDate(DateTime date) {\n"
    "  final day = DateTime.utc(date.year, date.month, date.day);\n"
    "  final epoch = DateTime.utc(2026, 1, 1);\n"
    "  final dayNumber = day.difference(epoch).inDays;\n"
    "  startupPerformanceMark('phoenix-daily-catalog-first-touch-start');\n"
    "  final catalogLength = dailyJourneyExperiences.length;\n"
    "  startupPerformanceMark('phoenix-daily-catalog-length-ready');\n"
    "  final index = dayNumber % catalogLength;\n"
    "  final normalizedIndex = index < 0 ? index + catalogLength : index;\n"
    "  startupPerformanceMark('phoenix-daily-catalog-index-start');\n"
    "  final experience = dailyJourneyExperiences[normalizedIndex];\n"
    "  startupPerformanceMark('phoenix-daily-catalog-index-ready');\n"
    "  return experience;\n"
    "}\n",
    1,
)
daily_catalog_path.write_text(daily_catalog, encoding='utf-8')

location = location.replace(
    anchors['location']['location model import'],
    "import '../models/geo_node.dart';\nimport '../startup_performance_probe.dart';\n",
    1,
)
location = location.replace(
    anchors['location']['binding build start'],
    "Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {\n"
    "  startupPerformanceMark('phoenix-location-bindings-start');\n"
    "  final bindings = <String, JourneyLocationBinding>{};\n",
    1,
)
location = location.replace(
    anchors['location']['binding build end'],
    "  startupPerformanceMark('phoenix-location-bindings-end');\n"
    "  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);\n"
    "}\n\n"
    "JourneyLocationBinding requireJourneyLocation",
    1,
)
location_path.write_text(location, encoding='utf-8')

expected_marks = (
    'phoenix-main-entry',
    'phoenix-language-init-start',
    'phoenix-language-init-end',
    'phoenix-runapp-start',
    'phoenix-first-frame',
    'phoenix-appstate-daily-journey-start',
    'phoenix-appstate-daily-journey-end',
    'phoenix-daily-catalog-first-touch-start',
    'phoenix-daily-catalog-length-ready',
    'phoenix-daily-catalog-index-start',
    'phoenix-daily-catalog-index-ready',
    'phoenix-state-load-start',
    'phoenix-preferences-start',
    'phoenix-preferences-ready',
    'phoenix-noncritical-preferences-restored',
    'phoenix-critical-read-start',
    'phoenix-critical-read-end',
    'phoenix-legacy-path-start',
    'phoenix-legacy-build-start',
    'phoenix-legacy-build-end',
    'phoenix-legacy-validate-start',
    'phoenix-legacy-validate-end',
    'phoenix-commit-initial-start',
    'phoenix-commit-initial-end',
    'phoenix-legacy-path-end',
    'phoenix-snapshot-decode-validate-start',
    'phoenix-snapshot-decode-validate-end',
    'phoenix-location-bindings-start',
    'phoenix-location-bindings-end',
    'phoenix-apply-committed-start',
    'phoenix-apply-committed-end',
    'phoenix-restore-eligibility-start',
    'phoenix-restore-eligibility-end',
    'phoenix-state-ready',
    'phoenix-first-meaningful-screen',
)
combined = ''.join(
    path.read_text(encoding='utf-8')
    for path in (
        main_path,
        state_path,
        app_state_path,
        daily_catalog_path,
        location_path,
    )
)
if not probe_path.exists():
    raise SystemExit('temporary startup probe file was not created')
mark_failures = []
for mark in expected_marks:
    count = combined.count(mark)
    print(f'MARK {mark} SOURCE COUNT = {count}')
    if count != 1:
        mark_failures.append(f'{mark} count={count}')
if mark_failures:
    for failure in mark_failures:
        print(f'MARK FAILURE = {failure}')
    raise SystemExit(1)
print('TEMPORARY STARTUP INSTRUMENTATION = PASS')
