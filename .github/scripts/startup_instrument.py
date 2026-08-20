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
    "  if (html.window.performance.getEntriesByName(name, 'mark').isEmpty) {\n"
    "    html.window.performance.mark(name);\n"
    "  }\n"
    "}\n\n"
    "void startupPerformanceMarkAfter(String name, String prerequisite) {\n"
    "  if (html.window.performance.getEntriesByName(prerequisite, 'mark').isNotEmpty) {\n"
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

# Passive first-frame render-path instrumentation. This only exists in the
# benchmark working tree produced by this script; product behavior is not
# changed by these marks.
startup_gate_path = lib / 'widgets' / 'startup_gate.dart'
home_shell_path = lib / 'screens' / 'home_shell.dart'
city_passport_path = lib / 'screens' / 'city_passport_screen.dart'
city_catalog_path = lib / 'data' / 'journey_city_catalog.dart'
daily_experience_path = lib / 'data' / 'daily_journey_experience.dart'

startup_gate = read(startup_gate_path)
home_shell = read(home_shell_path)
city_passport = read(city_passport_path)
city_catalog = read(city_catalog_path)
daily_experience = read(daily_experience_path)

startup_gate = replace_one(
    startup_gate,
    "import '../state/app_state.dart';\n",
    "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'startup gate probe import',
)
startup_gate = replace_one(
    startup_gate,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return switch (state.loadStatus) {\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    if (state.loadStatus == AppLoadStatus.ready) {\n      startupPerformanceMark('phoenix-startup-gate-ready-build-start');\n    }\n\n    return switch (state.loadStatus) {\n",
    'startup gate ready build start',
)
startup_gate = replace_one(
    startup_gate,
    "  @override\n  Widget build(BuildContext context) => widget.child;\n",
    "  @override\n  Widget build(BuildContext context) {\n    startupPerformanceMarkAfter(\n      'phoenix-startup-gate-ready-child-start',\n      'phoenix-state-ready',\n    );\n    final child = widget.child;\n    startupPerformanceMarkAfter(\n      'phoenix-startup-gate-ready-child-end',\n      'phoenix-state-ready',\n    );\n    return child;\n  }\n",
    'startup settled child build',
)
startup_gate_path.write_text(startup_gate, encoding='utf-8')

home_shell = replace_one(
    home_shell,
    "import '../state/app_state.dart';\n",
    "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'home shell probe import',
)
home_shell = replace_one(
    home_shell,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return LayoutBuilder(\n      builder: (context, constraints) {\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-home-shell-build-start', 'phoenix-state-ready');\n\n    return LayoutBuilder(\n      builder: (context, constraints) {\n        startupPerformanceMarkAfter('phoenix-home-shell-layout-start', 'phoenix-state-ready');\n",
    'home shell build start',
)
home_shell = replace_one(
    home_shell,
    "        if (isWide) {\n          return Scaffold(\n",
    "        if (isWide) {\n          startupPerformanceMarkAfter('phoenix-home-shell-layout-end', 'phoenix-state-ready');\n          return Scaffold(\n",
    'home shell wide layout end',
)
home_shell = replace_one(
    home_shell,
    "        }\n\n        return Scaffold(\n          backgroundColor: Colors.transparent,\n          body: SafeArea(bottom: false, child: content),\n",
    "        }\n\n        startupPerformanceMarkAfter('phoenix-home-shell-layout-end', 'phoenix-state-ready');\n        return Scaffold(\n          backgroundColor: Colors.transparent,\n          body: SafeArea(bottom: false, child: content),\n",
    'home shell mobile layout end',
)
home_shell_path.write_text(home_shell, encoding='utf-8')

explore = read(explore_path)
explore = replace_one(
    explore,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    final viewportHeight = MediaQuery.sizeOf(context).height;\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-explore-build-start', 'phoenix-state-ready');\n    final viewportHeight = MediaQuery.sizeOf(context).height;\n",
    'explore build start',
)
explore = replace_one(
    explore,
    "  Widget build(BuildContext context) {\n    final state = widget.state;\n    final destination = state.activeJourneyLocation;\n",
    "  Widget build(BuildContext context) {\n    final state = widget.state;\n    startupPerformanceMarkAfter('phoenix-home-flight-card-build-start', 'phoenix-state-ready');\n    final destination = state.activeJourneyLocation;\n    startupPerformanceMarkAfter('phoenix-home-flight-card-location-ready', 'phoenix-state-ready');\n",
    'flight card build start',
)
explore_path.write_text(explore, encoding='utf-8')

city_passport = replace_one(
    city_passport,
    "import '../state/access_controlled_app_state.dart';\n",
    "import '../state/access_controlled_app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'passport probe import',
)
city_passport = replace_one(
    city_passport,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return Stack(\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-passport-build-start', 'phoenix-state-ready');\n\n    return Stack(\n",
    'passport build start',
)
city_passport = replace_one(
    city_passport,
    "Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Rect mapRect) {\n  const markerSize = Size(72, 28);\n",
    "Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Rect mapRect) {\n  startupPerformanceMarkAfter('phoenix-passport-marker-resolve-start', 'phoenix-state-ready');\n  const markerSize = Size(72, 28);\n",
    'passport marker resolve start',
)
city_passport = replace_one(
    city_passport,
    "  return Map<String, _CityMarkerPlacement>.unmodifiable(placements);\n}\n",
    "  startupPerformanceMarkAfter('phoenix-passport-marker-resolve-end', 'phoenix-state-ready');\n  return Map<String, _CityMarkerPlacement>.unmodifiable(placements);\n}\n",
    'passport marker resolve end',
)
city_passport_path.write_text(city_passport, encoding='utf-8')

city_catalog = replace_one(
    city_catalog,
    "import 'daily_journey_catalog.dart';\n",
    "import 'daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n",
    'city catalog probe import',
)
old_city_builder = """List<JourneyCityCatalogEntry> buildJourneyCityCatalog(
  Iterable<DailyJourneyExperience> journeys,
) {
  final cityOrder = <String>[];
  final grouped = <String, List<DailyJourneyExperience>>{};

  for (final journey in journeys) {
    final cityId = journey.cityId;
    final destinations = grouped.putIfAbsent(cityId, () {
      cityOrder.add(cityId);
      return <DailyJourneyExperience>[];
    });

    if (destinations.isNotEmpty) {
      final city = destinations.first;
      if (city.city != journey.city || city.cityCode != journey.cityCode) {
        throw StateError(
          'Journey city metadata does not match for $cityId: '
          '${city.city}/${city.cityCode} and '
          '${journey.city}/${journey.cityCode}.',
        );
      }
    }

    if (destinations.any(
      (destination) => destination.destinationId == journey.destinationId,
    )) {
      throw StateError(
        'Duplicate destination ${journey.destinationId} in city $cityId.',
      );
    }

    destinations.add(journey);
  }

  return List<JourneyCityCatalogEntry>.unmodifiable(
    cityOrder.map((cityId) {
      final destinations = List<DailyJourneyExperience>.unmodifiable(
        grouped[cityId]!,
      );
      final city = destinations.first;
      return JourneyCityCatalogEntry(
        id: cityId,
        name: city.city,
        cityCode: city.cityCode,
        destinations: destinations,
      );
    }),
  );
}
"""
new_city_builder = old_city_builder.replace(
    ") {\n  final cityOrder",
    ") {\n  startupPerformanceMarkAfter('phoenix-city-catalog-build-start', 'phoenix-state-ready');\n  final cityOrder",
).replace(
    "  return List<JourneyCityCatalogEntry>.unmodifiable(\n",
    "  final result = List<JourneyCityCatalogEntry>.unmodifiable(\n",
).replace(
    "    }),\n  );\n}\n",
    "    }),\n  );\n  startupPerformanceMarkAfter('phoenix-city-catalog-build-end', 'phoenix-state-ready');\n  return result;\n}\n",
)
city_catalog = replace_one(
    city_catalog,
    old_city_builder,
    new_city_builder,
    'city catalog builder timing',
)
city_catalog_path.write_text(city_catalog, encoding='utf-8')

daily_experience = replace_one(
    daily_experience,
    "import 'dart:collection';\n",
    "import 'dart:collection';\n\nimport '../startup_performance_probe.dart';\n",
    'lazy journey probe import',
)
daily_experience = replace_one(
    daily_experience,
    "  DailyJourneyExperience operator [](int index) {\n    RangeError.checkValidIndex(index, this);\n    return _cache[index] ??= _builders[index]();\n  }\n",
    "  DailyJourneyExperience operator [](int index) {\n    RangeError.checkValidIndex(index, this);\n    startupPerformanceMark('phoenix-lazy-journey-$index-start');\n    final journey = _cache[index] ??= _builders[index]();\n    startupPerformanceMark('phoenix-lazy-journey-$index-end');\n    return journey;\n  }\n",
    'lazy journey item timing',
)
daily_experience_path.write_text(daily_experience, encoding='utf-8')

app_state = read(app_state_path)
app_state = replace_one(
    app_state,
    "  DailyJourneyExperience get activeJourney =>\n      requireDailyJourneyExperience(activeJourneyId);\n",
    "  DailyJourneyExperience get activeJourney {\n    startupPerformanceMarkAfter('phoenix-active-journey-resolve-start', 'phoenix-state-ready');\n    final journey = requireDailyJourneyExperience(activeJourneyId);\n    startupPerformanceMarkAfter('phoenix-active-journey-resolve-end', 'phoenix-state-ready');\n    return journey;\n  }\n",
    'active journey resolver timing',
)
app_state_path.write_text(app_state, encoding='utf-8')

state = read(state_path)
state = replace_one(
    state,
    "  List<String> get eligibleRegularJourneyIds => dailyJourneyIds;\n",
    "  List<String> get eligibleRegularJourneyIds {\n    startupPerformanceMarkAfter('phoenix-eligible-regular-ids-start', 'phoenix-state-ready');\n    final ids = dailyJourneyIds;\n    startupPerformanceMarkAfter('phoenix-eligible-regular-ids-end', 'phoenix-state-ready');\n    return ids;\n  }\n",
    'eligible regular ids timing',
)
state = replace_one(
    state,
    "  DailyJourneyAssignment get dailyAssignment {\n    if (!_isValidExplorerSeed(localExplorerSeed)) {\n",
    "  DailyJourneyAssignment get dailyAssignment {\n    startupPerformanceMarkAfter('phoenix-daily-assignment-start', 'phoenix-state-ready');\n    if (!_isValidExplorerSeed(localExplorerSeed)) {\n",
    'daily assignment start',
)
state = replace_one(
    state,
    "    return JourneyAccessPolicy.assignDailyJourneys(\n      journeyIds: eligibleRegularJourneyIds,\n      explorerSeed: localExplorerSeed,\n      localDate: _clock(),\n    );\n  }\n",
    "    final assignment = JourneyAccessPolicy.assignDailyJourneys(\n      journeyIds: eligibleRegularJourneyIds,\n      explorerSeed: localExplorerSeed,\n      localDate: _clock(),\n    );\n    startupPerformanceMarkAfter('phoenix-daily-assignment-end', 'phoenix-state-ready');\n    return assignment;\n  }\n",
    'daily assignment end',
)
state = replace_one(
    state,
    "  Set<String> get releasedDailyJourneyIds =>\n      dailyAssignment.unlockedJourneyIds(releasedDailySlots);\n",
    "  Set<String> get releasedDailyJourneyIds {\n    startupPerformanceMarkAfter('phoenix-released-daily-ids-start', 'phoenix-state-ready');\n    final ids = dailyAssignment.unlockedJourneyIds(releasedDailySlots);\n    startupPerformanceMarkAfter('phoenix-released-daily-ids-end', 'phoenix-state-ready');\n    return ids;\n  }\n",
    'released daily ids timing',
)
state = replace_one(
    state,
    "  Set<String> get policyAccessibleRegularJourneyIds =>\n      JourneyAccessPolicy.accessibleJourneyIds(\n        mode: journeyAccessMode,\n        allJourneyIds: eligibleRegularJourneyIds,\n        freeAssignment: dailyAssignment,\n        releasedFreeSlots: releasedDailySlots,\n      );\n",
    "  Set<String> get policyAccessibleRegularJourneyIds {\n    startupPerformanceMarkAfter('phoenix-policy-accessible-ids-start', 'phoenix-state-ready');\n    final ids = JourneyAccessPolicy.accessibleJourneyIds(\n      mode: journeyAccessMode,\n      allJourneyIds: eligibleRegularJourneyIds,\n      freeAssignment: dailyAssignment,\n      releasedFreeSlots: releasedDailySlots,\n    );\n    startupPerformanceMarkAfter('phoenix-policy-accessible-ids-end', 'phoenix-state-ready');\n    return ids;\n  }\n",
    'policy accessible ids timing',
)
state = replace_one(
    state,
    "  @override\n  DailyJourneyExperience get todayJourney {\n    if (!_isValidExplorerSeed(localExplorerSeed)) {\n",
    "  @override\n  DailyJourneyExperience get todayJourney {\n    startupPerformanceMarkAfter('phoenix-today-journey-start', 'phoenix-state-ready');\n    if (!_isValidExplorerSeed(localExplorerSeed)) {\n",
    'today journey start',
)
state = replace_one(
    state,
    "    return requireDailyJourneyExperience(\n      dailyAssignment.journeyIdFor(currentDailySlot),\n    );\n  }\n",
    "    final journey = requireDailyJourneyExperience(\n      dailyAssignment.journeyIdFor(currentDailySlot),\n    );\n    startupPerformanceMarkAfter('phoenix-today-journey-end', 'phoenix-state-ready');\n    return journey;\n  }\n",
    'today journey end',
)
state_path.write_text(state, encoding='utf-8')

print('TEMPORARY STARTUP + JOURNEY-OPEN + FIRST-FRAME INSTRUMENTATION = PASS')
