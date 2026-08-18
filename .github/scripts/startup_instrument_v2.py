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
explore_path = lib / 'screens' / 'explore_screen.dart'
journey_screen_path = lib / 'screens' / 'journey_screen.dart'


def read(path):
    return path.read_text(encoding='utf-8')


def replace_one(text, old, new, label):
    count = text.count(old)
    print(f'ANCHOR {label} MATCH COUNT = {count}')
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one anchor, found {count}')
    return text.replace(old, new, 1)

main = read(main_path)
state = read(state_path)
app_state = read(app_state_path)
daily_catalog = read(daily_catalog_path)
location = read(location_path)
explore = read(explore_path)
journey_screen = read(journey_screen_path)

candidate_arch = 'dailyJourneyIdForDate(DateTime date)' in daily_catalog
print('STARTUP ARCHITECTURE =', 'REMEDIATED' if candidate_arch else 'BASELINE')

# Validate architecture-specific anchors without mutating in check-only mode.
required = [
    ('main import', main, "import 'app.dart';\n"),
    ('main startup', main, "Future<void> main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n  await const LanguageLevelPreferenceStore().initializePhoenixLevel();\n"),
    ('runApp callback', main, "    () {\n      runApp(\n"),
    ('state foundation import', state, "import 'package:flutter/foundation.dart';\n"),
    ('state catalog import', state, "import '../data/daily_journey_catalog.dart';\n"),
    ('state load start', state, "  Future<void> load() async {\n    loadStatus = AppLoadStatus.loading;\n"),
    ('preferences load', state, "      final preferences = await _preferencesLoader();\n      _preferences = preferences;\n      _restoreNonCriticalPreferences(preferences);\n"),
    ('critical read', state, "      var committed = await _criticalStore!.readCommitted();\n      if (committed == null) {\n"),
    ('state ready', state, "      _activeIdentityReady = true;\n      loadStatus = AppLoadStatus.ready;\n    } catch (error, stackTrace) {\n"),
    ('final load notification', state, "    notifyListeners();\n  }\n\n  @override\n  Future<void> activateJourney"),
    ('activate journey resolve', state, "  Future<void> activateJourney(String journeyId) async {\n    final journey = requireDailyJourneyExperience(journeyId);\n"),
    ('app state catalog import', app_state, "import '../data/daily_journey_catalog.dart';\n"),
    ('catalog import', daily_catalog, "import '../models/story_content.dart';\n"),
    ('location model import', location, "import '../models/geo_node.dart';\n"),
    ('explore state import', explore, "import '../state/app_state.dart';\n"),
    ('explore open function', explore, "    Future<void> chooseJourney() async {\n"),
    ('journey state import', journey_screen, "import '../state/app_state.dart';\n"),
    ('journey initialized', journey_screen, "    _initialized = true;\n    unawaited(_loadLanguageProfile());\n"),
]
ctor_anchor = (
    "    activeJourneyId = dailyJourneyIdForDate(_clock());\n"
    if candidate_arch
    else "    activeJourneyId = dailyJourneyForDate(_clock()).id;\n"
)
required.append(('daily journey constructor', app_state, ctor_anchor))
for label, text, anchor in required:
    count = text.count(anchor)
    print(f'ANCHOR {label} MATCH COUNT = {count}')
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one anchor, found {count}')
if check_only:
    print('ALL STARTUP INSTRUMENTATION ANCHORS = PASS')
    raise SystemExit(0)

probe_path = lib / 'startup_performance_probe.dart'
probe_path.write_text(
    "// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use\n\n"
    "import 'dart:async';\n"
    "import 'dart:html' as html;\n\n"
    "void startupPerformanceMark(String name) {\n"
    "  if (html.window.performance.getEntriesByName(name).isEmpty) {\n"
    "    html.window.performance.mark(name);\n"
    "  }\n"
    "}\n\n"
    "void startupPerformanceMarkAfter(String name, String prerequisite) {\n"
    "  if (html.window.performance.getEntriesByName(prerequisite).isNotEmpty) {\n"
    "    startupPerformanceMark(name);\n"
    "  }\n"
    "}\n\n"
    "Future<void> Function()? _journeyOpenCallback;\n"
    "StreamSubscription<html.Event>? _journeyOpenSubscription;\n\n"
    "void installStartupBenchmarkJourneyOpen(Future<void> Function() callback) {\n"
    "  _journeyOpenCallback = callback;\n"
    "  _journeyOpenSubscription ??= html.window.on['phoenix-benchmark-open-current-journey'].listen((_) async {\n"
    "    startupPerformanceMark('phoenix-journey-open-start');\n"
    "    await _journeyOpenCallback?.call();\n"
    "    startupPerformanceMark('phoenix-journey-navigation-triggered');\n"
    "  });\n"
    "}\n",
    encoding='utf-8',
)

main = replace_one(main, "import 'app.dart';\n", "import 'app.dart';\nimport 'startup_performance_probe.dart';\n", 'main import')
main = replace_one(
    main,
    "Future<void> main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n  await const LanguageLevelPreferenceStore().initializePhoenixLevel();\n",
    "Future<void> main() async {\n  startupPerformanceMark('phoenix-main-entry');\n  WidgetsFlutterBinding.ensureInitialized();\n  startupPerformanceMark('phoenix-language-init-start');\n  await const LanguageLevelPreferenceStore().initializePhoenixLevel();\n  startupPerformanceMark('phoenix-language-init-end');\n",
    'main startup',
)
main = replace_one(
    main,
    "    () {\n      runApp(\n",
    "    () {\n      startupPerformanceMark('phoenix-runapp-start');\n      WidgetsBinding.instance.addPostFrameCallback((_) {\n        startupPerformanceMark('phoenix-first-frame');\n      });\n      runApp(\n",
    'runApp callback',
)
main_path.write_text(main, encoding='utf-8')

state = replace_one(state, "import 'package:flutter/foundation.dart';\n", "import 'package:flutter/foundation.dart';\nimport 'package:flutter/scheduler.dart';\n", 'state foundation import')
state = replace_one(state, "import '../data/daily_journey_catalog.dart';\n", "import '../data/daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n", 'state catalog import')
state = replace_one(state, "  Future<void> load() async {\n    loadStatus = AppLoadStatus.loading;\n", "  Future<void> load() async {\n    startupPerformanceMark('phoenix-state-load-start');\n    loadStatus = AppLoadStatus.loading;\n", 'state load start')
state = replace_one(state, "      final preferences = await _preferencesLoader();\n      _preferences = preferences;\n      _restoreNonCriticalPreferences(preferences);\n", "      startupPerformanceMark('phoenix-preferences-start');\n      final preferences = await _preferencesLoader();\n      startupPerformanceMark('phoenix-preferences-ready');\n      _preferences = preferences;\n      _restoreNonCriticalPreferences(preferences);\n", 'preferences load')
state = replace_one(state, "      var committed = await _criticalStore!.readCommitted();\n      if (committed == null) {\n", "      startupPerformanceMark('phoenix-critical-read-start');\n      var committed = await _criticalStore!.readCommitted();\n      startupPerformanceMark('phoenix-critical-read-end');\n      if (committed == null) {\n        startupPerformanceMark('phoenix-legacy-path-start');\n", 'critical read')
state = replace_one(state, "        final legacy = await _buildLegacySnapshot(preferences);\n        legacy.snapshot.validate();\n", "        startupPerformanceMark('phoenix-legacy-build-start');\n        final legacy = await _buildLegacySnapshot(preferences);\n        startupPerformanceMark('phoenix-legacy-build-end');\n        legacy.snapshot.validate();\n", 'legacy build')
state = replace_one(state, "        committed = await _criticalStore!.commitInitial(\n          legacy.snapshot.toJson(),\n        );\n", "        committed = await _criticalStore!.commitInitial(\n          legacy.snapshot.toJson(),\n        );\n        startupPerformanceMark('phoenix-legacy-path-end');\n", 'legacy commit')
state = replace_one(state, "      final snapshot = _PhoenixCriticalSnapshot.fromJson(committed.payload)\n        ..validate();\n", "      startupPerformanceMark('phoenix-snapshot-decode-validate-start');\n      final snapshot = _PhoenixCriticalSnapshot.fromJson(committed.payload)\n        ..validate();\n      startupPerformanceMark('phoenix-snapshot-decode-validate-end');\n", 'snapshot decode')
state = replace_one(state, "      _applyCommitted(\n        snapshot,\n        revision: committed.revision,\n        schemaVersion: committed.schemaVersion,\n      );\n", "      startupPerformanceMark('phoenix-apply-committed-start');\n      _applyCommitted(\n        snapshot,\n        revision: committed.revision,\n        schemaVersion: committed.schemaVersion,\n      );\n      startupPerformanceMark('phoenix-apply-committed-end');\n", 'apply committed')
state = replace_one(state, "      if (!_canRestoreActiveJourney(activeJourneyId)) {\n        throw StateError(\n          'Persisted active Journey is not eligible for safe restore.',\n        );\n      }\n", "      startupPerformanceMark('phoenix-restore-eligibility-start');\n      if (!_canRestoreActiveJourney(activeJourneyId)) {\n        throw StateError(\n          'Persisted active Journey is not eligible for safe restore.',\n        );\n      }\n      startupPerformanceMark('phoenix-restore-eligibility-end');\n", 'restore eligibility')
state = replace_one(state, "      _activeIdentityReady = true;\n      loadStatus = AppLoadStatus.ready;\n    } catch (error, stackTrace) {\n", "      _activeIdentityReady = true;\n      loadStatus = AppLoadStatus.ready;\n      startupPerformanceMark('phoenix-state-ready');\n    } catch (error, stackTrace) {\n", 'state ready')
state = replace_one(state, "    notifyListeners();\n  }\n\n  @override\n  Future<void> activateJourney", "    notifyListeners();\n    if (loadStatus == AppLoadStatus.ready) {\n      SchedulerBinding.instance.addPostFrameCallback((_) {\n        startupPerformanceMark('phoenix-first-meaningful-screen');\n      });\n    }\n  }\n\n  @override\n  Future<void> activateJourney", 'final load notification')
state = replace_one(state, "  Future<void> activateJourney(String journeyId) async {\n    final journey = requireDailyJourneyExperience(journeyId);\n", "  Future<void> activateJourney(String journeyId) async {\n    final journey = requireDailyJourneyExperience(journeyId);\n    startupPerformanceMarkAfter('phoenix-journey-content-ready', 'phoenix-journey-open-start');\n", 'activate journey resolve')
state_path.write_text(state, encoding='utf-8')

app_state = replace_one(app_state, "import '../data/daily_journey_catalog.dart';\n", "import '../data/daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n", 'app state catalog import')
app_state = replace_one(app_state, ctor_anchor, "    startupPerformanceMark('phoenix-appstate-daily-journey-start');\n" + ctor_anchor + "    startupPerformanceMark('phoenix-appstate-daily-journey-end');\n", 'daily journey constructor')
app_state_path.write_text(app_state, encoding='utf-8')

daily_catalog = replace_one(daily_catalog, "import '../models/story_content.dart';\n", "import '../models/story_content.dart';\nimport '../startup_performance_probe.dart';\n", 'catalog import')
if candidate_arch:
    old = "String dailyJourneyIdForDate(DateTime date) {\n  final day = DateTime.utc(date.year, date.month, date.day);\n  final epoch = DateTime.utc(2026, 1, 1);\n  final dayNumber = day.difference(epoch).inDays;\n  final index = dayNumber % dailyJourneyIds.length;\n  return dailyJourneyIds[index < 0 ? index + dailyJourneyIds.length : index];\n}\n"
    new = "String dailyJourneyIdForDate(DateTime date) {\n  final day = DateTime.utc(date.year, date.month, date.day);\n  final epoch = DateTime.utc(2026, 1, 1);\n  final dayNumber = day.difference(epoch).inDays;\n  startupPerformanceMark('phoenix-daily-catalog-first-touch-start');\n  final catalogLength = dailyJourneyIds.length;\n  startupPerformanceMark('phoenix-daily-catalog-length-ready');\n  final index = dayNumber % catalogLength;\n  final normalizedIndex = index < 0 ? index + catalogLength : index;\n  startupPerformanceMark('phoenix-daily-catalog-index-start');\n  final id = dailyJourneyIds[normalizedIndex];\n  startupPerformanceMark('phoenix-daily-catalog-index-ready');\n  return id;\n}\n"
else:
    old = "DailyJourneyExperience dailyJourneyForDate(DateTime date) {\n  final day = DateTime.utc(date.year, date.month, date.day);\n  final epoch = DateTime.utc(2026, 1, 1);\n  final dayNumber = day.difference(epoch).inDays;\n  final index = dayNumber % dailyJourneyExperiences.length;\n  return dailyJourneyExperiences[index < 0\n      ? index + dailyJourneyExperiences.length\n      : index];\n}\n"
    new = "DailyJourneyExperience dailyJourneyForDate(DateTime date) {\n  final day = DateTime.utc(date.year, date.month, date.day);\n  final epoch = DateTime.utc(2026, 1, 1);\n  final dayNumber = day.difference(epoch).inDays;\n  startupPerformanceMark('phoenix-daily-catalog-first-touch-start');\n  final catalogLength = dailyJourneyExperiences.length;\n  startupPerformanceMark('phoenix-daily-catalog-length-ready');\n  final index = dayNumber % catalogLength;\n  final normalizedIndex = index < 0 ? index + catalogLength : index;\n  startupPerformanceMark('phoenix-daily-catalog-index-start');\n  final experience = dailyJourneyExperiences[normalizedIndex];\n  startupPerformanceMark('phoenix-daily-catalog-index-ready');\n  return experience;\n}\n"
daily_catalog = replace_one(daily_catalog, old, new, 'daily schedule function')
daily_catalog_path.write_text(daily_catalog, encoding='utf-8')

location = replace_one(location, "import '../models/geo_node.dart';\n", "import '../models/geo_node.dart';\nimport '../startup_performance_probe.dart';\n", 'location model import')
if candidate_arch:
    location = replace_one(location, "JourneyLocationBinding _buildJourneyLocationBinding(\n  DailyJourneyExperience journey,\n) {\n  final node =", "JourneyLocationBinding _buildJourneyLocationBinding(\n  DailyJourneyExperience journey,\n) {\n  startupPerformanceMark('phoenix-location-bindings-start');\n  final node =", 'selected binding start')
    location = replace_one(location, "  return JourneyLocationBinding(\n    journey: journey,\n    placeNode: node,\n    geoPath: List<GeoNode>.unmodifiable(geoPath),\n  );\n}\n", "  final binding = JourneyLocationBinding(\n    journey: journey,\n    placeNode: node,\n    geoPath: List<GeoNode>.unmodifiable(geoPath),\n  );\n  startupPerformanceMark('phoenix-location-bindings-end');\n  return binding;\n}\n", 'selected binding end')
else:
    location = replace_one(location, "Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {\n  final bindings = <String, JourneyLocationBinding>{};\n", "Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {\n  startupPerformanceMark('phoenix-location-bindings-start');\n  final bindings = <String, JourneyLocationBinding>{};\n", 'binding build start')
    location = replace_one(location, "  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);\n}\n\nJourneyLocationBinding requireJourneyLocation", "  startupPerformanceMark('phoenix-location-bindings-end');\n  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);\n}\n\nJourneyLocationBinding requireJourneyLocation", 'binding build end')
location_path.write_text(location, encoding='utf-8')

explore = replace_one(explore, "import '../state/app_state.dart';\n", "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n", 'explore state import')
explore = replace_one(explore, "    Future<void> chooseJourney() async {\n", "    installStartupBenchmarkJourneyOpen(() async {\n      await openJourneyById(state.activeJourneyId);\n    });\n\n    Future<void> chooseJourney() async {\n", 'explore benchmark install')
explore_path.write_text(explore, encoding='utf-8')

journey_screen = replace_one(journey_screen, "import '../state/app_state.dart';\n", "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n", 'journey state import')
journey_screen = replace_one(journey_screen, "    _experience = requireDailyJourneyExperience(journeyId);\n", "    _experience = requireDailyJourneyExperience(journeyId);\n    startupPerformanceMarkAfter('phoenix-journey-content-ready', 'phoenix-journey-open-start');\n", 'journey content ready')
journey_screen = replace_one(journey_screen, "    _initialized = true;\n    unawaited(_loadLanguageProfile());\n", "    _initialized = true;\n    WidgetsBinding.instance.addPostFrameCallback((_) {\n      startupPerformanceMarkAfter('phoenix-journey-story-usable', 'phoenix-journey-open-start');\n    });\n    unawaited(_loadLanguageProfile());\n", 'journey story usable')
journey_screen_path.write_text(journey_screen, encoding='utf-8')

print('TEMPORARY STARTUP + JOURNEY-OPEN INSTRUMENTATION = PASS')
