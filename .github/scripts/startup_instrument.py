from pathlib import Path
import subprocess
import sys
import tempfile

PREVIOUS_HARNESS_SHA = '0412e14a10daca013a318993ae181277c8618309'
root = Path(sys.argv[1])
check_only = '--check-only' in sys.argv[2:]
repo = Path(__file__).resolve().parents[2]


def read(path):
    return path.read_text(encoding='utf-8')


def replace_one(text, old, new, label):
    count = text.count(old)
    print(f'FIRST-FRAME ANCHOR {label} MATCH COUNT = {count}')
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one anchor, found {count}')
    return text.replace(old, new, 1)


# Preserve the already-verified startup/snapshot/Journey-open harness verbatim.
base_script = subprocess.check_output(
    [
        'git',
        '-C',
        str(repo),
        'show',
        f'{PREVIOUS_HARNESS_SHA}:.github/scripts/startup_instrument.py',
    ],
    text=True,
)
with tempfile.NamedTemporaryFile('w', suffix='.py', encoding='utf-8', delete=False) as handle:
    handle.write(base_script)
    base_path = Path(handle.name)
try:
    command = [sys.executable, str(base_path), str(root)]
    if check_only:
        command.append('--check-only')
    subprocess.run(command, check=True)
finally:
    base_path.unlink(missing_ok=True)

if check_only:
    raise SystemExit(0)

lib = root / 'app' / 'lib'
daily_catalog_path = lib / 'data' / 'daily_journey_catalog.dart'
# The baseline keeps its established harness. These passive marks are only
# needed on the already-remediated candidate to locate its residual first-frame
# synchronous block.
if 'dailyJourneyIdForDate(DateTime date)' not in read(daily_catalog_path):
    print('FIRST-FRAME PASSIVE INSTRUMENTATION = SKIPPED FOR BASELINE')
    raise SystemExit(0)

startup_gate_path = lib / 'widgets' / 'startup_gate.dart'
home_shell_path = lib / 'screens' / 'home_shell.dart'
explore_path = lib / 'screens' / 'explore_screen.dart'
city_passport_path = lib / 'screens' / 'city_passport_screen.dart'
city_catalog_path = lib / 'data' / 'journey_city_catalog.dart'
daily_experience_path = lib / 'data' / 'daily_journey_experience.dart'
app_state_path = lib / 'state' / 'app_state.dart'
state_path = lib / 'state' / 'access_controlled_app_state.dart'

startup_gate = read(startup_gate_path)
startup_gate = replace_one(
    startup_gate,
    "import '../state/app_state.dart';\n",
    "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'startup gate import',
)
startup_gate = replace_one(
    startup_gate,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return switch (state.loadStatus) {\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    if (state.loadStatus == AppLoadStatus.ready) {\n      startupPerformanceMark('phoenix-startup-gate-ready-build-start');\n    }\n\n    return switch (state.loadStatus) {\n",
    'startup gate ready build',
)
startup_gate_path.write_text(startup_gate, encoding='utf-8')

home_shell = read(home_shell_path)
home_shell = replace_one(
    home_shell,
    "import '../state/app_state.dart';\n",
    "import '../state/app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'home shell import',
)
home_shell = replace_one(
    home_shell,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return LayoutBuilder(\n      builder: (context, constraints) {\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-home-shell-build-start', 'phoenix-state-ready');\n\n    return LayoutBuilder(\n      builder: (context, constraints) {\n        startupPerformanceMarkAfter('phoenix-home-shell-layout-start', 'phoenix-state-ready');\n",
    'home shell build',
)
home_shell_path.write_text(home_shell, encoding='utf-8')

explore = read(explore_path)
# Base harness has already added the probe import to ExploreScreen.
explore = replace_one(
    explore,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    final viewportHeight = MediaQuery.sizeOf(context).height;\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-explore-build-start', 'phoenix-state-ready');\n    final viewportHeight = MediaQuery.sizeOf(context).height;\n",
    'explore build',
)
explore = replace_one(
    explore,
    "  Widget build(BuildContext context) {\n    final state = widget.state;\n    final destination = state.activeJourneyLocation;\n",
    "  Widget build(BuildContext context) {\n    final state = widget.state;\n    startupPerformanceMarkAfter('phoenix-home-flight-card-build-start', 'phoenix-state-ready');\n    final destination = state.activeJourneyLocation;\n    startupPerformanceMarkAfter('phoenix-home-flight-card-location-ready', 'phoenix-state-ready');\n",
    'home flight card',
)
explore_path.write_text(explore, encoding='utf-8')

city_passport = read(city_passport_path)
city_passport = replace_one(
    city_passport,
    "import '../state/access_controlled_app_state.dart';\n",
    "import '../state/access_controlled_app_state.dart';\nimport '../startup_performance_probe.dart';\n",
    'passport import',
)
city_passport = replace_one(
    city_passport,
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n\n    return Stack(\n",
    "  Widget build(BuildContext context) {\n    final state = context.watch<AppState>();\n    startupPerformanceMarkAfter('phoenix-passport-build-start', 'phoenix-state-ready');\n\n    return Stack(\n",
    'passport build',
)
city_passport = replace_one(
    city_passport,
    "Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Rect mapRect) {\n  const markerSize = Size(72, 28);\n",
    "Map<String, _CityMarkerPlacement> _resolveCityMarkerPlacements(Rect mapRect) {\n  startupPerformanceMarkAfter('phoenix-passport-marker-resolve-start', 'phoenix-state-ready');\n  const markerSize = Size(72, 28);\n",
    'passport marker start',
)
city_passport = replace_one(
    city_passport,
    "  return placements;\n}\n\nclass _CityMarkerLeader",
    "  startupPerformanceMarkAfter('phoenix-passport-marker-resolve-end', 'phoenix-state-ready');\n  return placements;\n}\n\nclass _CityMarkerLeader",
    'passport marker end',
)
city_passport_path.write_text(city_passport, encoding='utf-8')

city_catalog = read(city_catalog_path)
city_catalog = replace_one(
    city_catalog,
    "import 'daily_journey_catalog.dart';\n",
    "import 'daily_journey_catalog.dart';\nimport '../startup_performance_probe.dart';\n",
    'city catalog import',
)
city_catalog = replace_one(
    city_catalog,
    "List<JourneyCityCatalogEntry> buildJourneyCityCatalog(\n  Iterable<DailyJourneyExperience> journeys,\n) {\n  final cityOrder = <String>[];\n",
    "List<JourneyCityCatalogEntry> buildJourneyCityCatalog(\n  Iterable<DailyJourneyExperience> journeys,\n) {\n  startupPerformanceMarkAfter('phoenix-city-catalog-build-start', 'phoenix-state-ready');\n  final cityOrder = <String>[];\n",
    'city catalog start',
)
city_catalog = replace_one(
    city_catalog,
    "  return List<JourneyCityCatalogEntry>.unmodifiable(\n    cityOrder.map((cityId) {\n",
    "  final result = List<JourneyCityCatalogEntry>.unmodifiable(\n    cityOrder.map((cityId) {\n",
    'city catalog result',
)
city_catalog = replace_one(
    city_catalog,
    "    }),\n  );\n}\n\nfinal List<JourneyCityCatalogEntry> journeyCityCatalog",
    "    }),\n  );\n  startupPerformanceMarkAfter('phoenix-city-catalog-build-end', 'phoenix-state-ready');\n  return result;\n}\n\nfinal List<JourneyCityCatalogEntry> journeyCityCatalog",
    'city catalog end',
)
city_catalog_path.write_text(city_catalog, encoding='utf-8')

daily_experience = read(daily_experience_path)
daily_experience = replace_one(
    daily_experience,
    "import 'dart:collection';\n",
    "import 'dart:collection';\n\nimport '../startup_performance_probe.dart';\n",
    'lazy journey import',
)
daily_experience = replace_one(
    daily_experience,
    "  DailyJourneyExperience operator [](int index) {\n    RangeError.checkValidIndex(index, this);\n    return _cache[index] ??= _builders[index]();\n  }\n",
    "  DailyJourneyExperience operator [](int index) {\n    RangeError.checkValidIndex(index, this);\n    startupPerformanceMark('phoenix-lazy-journey-$index-start');\n    final journey = _cache[index] ??= _builders[index]();\n    startupPerformanceMark('phoenix-lazy-journey-$index-end');\n    return journey;\n  }\n",
    'lazy journey item',
)
daily_experience_path.write_text(daily_experience, encoding='utf-8')

app_state = read(app_state_path)
app_state = replace_one(
    app_state,
    "  DailyJourneyExperience get activeJourney =>\n      requireDailyJourneyExperience(activeJourneyId);\n",
    "  DailyJourneyExperience get activeJourney {\n    startupPerformanceMarkAfter('phoenix-active-journey-resolve-start', 'phoenix-state-ready');\n    final journey = requireDailyJourneyExperience(activeJourneyId);\n    startupPerformanceMarkAfter('phoenix-active-journey-resolve-end', 'phoenix-state-ready');\n    return journey;\n  }\n",
    'active journey resolver',
)
app_state_path.write_text(app_state, encoding='utf-8')

state = read(state_path)
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
    "  Set<String> get policyAccessibleRegularJourneyIds =>\n      JourneyAccessPolicy.accessibleJourneyIds(\n        mode: journeyAccessMode,\n        allJourneyIds: eligibleRegularJourneyIds,\n        freeAssignment: dailyAssignment,\n        releasedFreeSlots: releasedDailySlots,\n      );\n",
    "  Set<String> get policyAccessibleRegularJourneyIds {\n    startupPerformanceMarkAfter('phoenix-policy-accessible-ids-start', 'phoenix-state-ready');\n    final ids = JourneyAccessPolicy.accessibleJourneyIds(\n      mode: journeyAccessMode,\n      allJourneyIds: eligibleRegularJourneyIds,\n      freeAssignment: dailyAssignment,\n      releasedFreeSlots: releasedDailySlots,\n    );\n    startupPerformanceMarkAfter('phoenix-policy-accessible-ids-end', 'phoenix-state-ready');\n    return ids;\n  }\n",
    'policy resolver',
)
state_path.write_text(state, encoding='utf-8')

print('FIRST-FRAME PASSIVE INSTRUMENTATION = PASS')
