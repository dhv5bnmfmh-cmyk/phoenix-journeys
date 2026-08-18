from pathlib import Path
import re
import sys

ROOT = Path(sys.argv[1] if len(sys.argv) > 1 else '.').resolve()


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding='utf-8')


def write(path: str, text: str) -> None:
    target = ROOT / path
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(text, encoding='utf-8')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected exactly one anchor, found {count}')
    return text.replace(old, new, 1)


def lazy_group(path: str, variable: str, expected_count: int) -> None:
    text = read(path)
    opening = f'final {variable} = <DailyJourneyExperience>['
    start = text.find(opening)
    if start < 0:
        raise SystemExit(f'{path}: missing {variable} opening')
    close = text.find('\n];', start)
    if close < 0:
        raise SystemExit(f'{path}: missing {variable} close')
    block = text[start:close + 3]
    block = block.replace(
        opening,
        f'final {variable} = LazyJourneyList(<DailyJourneyExperience Function()>[',
        1,
    )
    block, count = re.subn(
        r'(?m)^(\s*)DailyJourneyExperience\(',
        r'\1() => DailyJourneyExperience(',
        block,
    )
    if count != expected_count:
        raise SystemExit(
            f'{path}: expected {expected_count} builders for {variable}, found {count}'
        )
    block = block[:-3] + '\n]);'
    text = text[:start] + block + text[close + 3:]
    write(path, text)


# Immutable lazy List. Existing learner-content constructors remain canonical.
path = 'app/lib/data/daily_journey_experience.dart'
text = read(path)
if 'class LazyJourneyList' not in text:
    text = "import 'dart:collection';\n\n" + text
    text += """

typedef DailyJourneyExperienceBuilder = DailyJourneyExperience Function();

class LazyJourneyList extends ListBase<DailyJourneyExperience> {
  LazyJourneyList(List<DailyJourneyExperienceBuilder> builders)
      : _builders = List<DailyJourneyExperienceBuilder>.unmodifiable(builders),
        _cache = List<DailyJourneyExperience?>.filled(
          builders.length,
          null,
          growable: false,
        );

  final List<DailyJourneyExperienceBuilder> _builders;
  final List<DailyJourneyExperience?> _cache;

  @override
  int get length => _builders.length;

  @override
  set length(int value) {
    throw UnsupportedError('LazyJourneyList is immutable.');
  }

  @override
  DailyJourneyExperience operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return _cache[index] ??= _builders[index]();
  }

  @override
  void operator []=(int index, DailyJourneyExperience value) {
    throw UnsupportedError('LazyJourneyList is immutable.');
  }
}
"""
write(path, text)

# Each publication group now materializes only its requested element.
lazy_group('app/lib/data/extended_journey_catalog.dart', 'extendedJourneyExperiences', 5)
lazy_group('app/lib/data/journey_expansion_catalog.dart', 'journeyExpansionExperiences', 3)
lazy_group('app/lib/data/journey_expansion_batch_two.dart', 'journeyExpansionBatchTwoExperiences', 2)
lazy_group('app/lib/data/journey_expansion_batch_three.dart', 'journeyExpansionBatchThreeExperiences', 3)
lazy_group('app/lib/data/journey_expansion_batch_four.dart', 'journeyExpansionBatchFourExperiences', 5)
lazy_group('app/lib/data/journey_expansion_batch_five.dart', 'journeyExpansionBatchFiveExperiences', 5)

# Daily schedule: ID selection is lightweight; full learner content is resolved by direct index only on demand.
path = 'app/lib/data/daily_journey_catalog.dart'
text = read(path)
schedule = """final List<String> dailyJourneyIds = List<String>.unmodifiable(
  const <String>[
    'beijing-forbidden-city',
    'beijing-summer-palace',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
    'jiangmen-kaiping-diaolou',
    'suzhou-humble-administrators-garden',
    'luoyang-longmen-grottoes',
    'quanzhou-kaiyuan-temple',
    'datong-yungang-grottoes',
    'lijiang-old-town',
    'dunhuang-mogao-caves',
    'chengde-mountain-resort',
    'xiamen-kulangsu',
    'pingyao-ancient-city',
    'qufu-confucius-sites',
    'leshan-giant-buddha',
    'wuyishan-nine-bend-stream',
    'honghe-hani-rice-terraces',
    'huangshan-cloud-peaks',
    'zhangjiajie-wulingyuan',
    'kaifeng-song-capital',
    'dali-cangshan-erhai',
    'harbin-central-street',
  ],
);

final Map<String, int> _dailyJourneyIndexById = <String, int>{
  for (var index = 0; index < dailyJourneyIds.length; index += 1)
    dailyJourneyIds[index]: index,
};

"""
anchor = 'final dailyJourneyExperiences = <DailyJourneyExperience>['
if text.count(anchor) != 1:
    raise SystemExit('daily catalog: dailyJourneyExperiences anchor mismatch')
text = text.replace(anchor, schedule + anchor, 1)
start = text.find(anchor)
close = text.find('\n];', start)
if close < 0:
    raise SystemExit('daily catalog: missing dailyJourneyExperiences close')
block = text[start:close + 3]
block = block.replace(
    anchor,
    'final dailyJourneyExperiences = LazyJourneyList(<DailyJourneyExperience Function()>[',
    1,
)
block, direct_count = re.subn(
    r'(?m)^(\s*)DailyJourneyExperience\(',
    r'\1() => DailyJourneyExperience(',
    block,
)
if direct_count != 3:
    raise SystemExit(f'daily catalog: expected 3 direct builders, got {direct_count}')
block = replace_once(
    block,
    '  summerPalaceJourneyExperience,\n',
    '  () => summerPalaceJourneyExperience,\n',
    'daily catalog Summer Palace builder',
)
spreads = {
    '  ...extendedJourneyExperiences,\n': ''.join(f'  () => extendedJourneyExperiences[{i}],\n' for i in range(5)),
    '  ...journeyExpansionExperiences,\n': ''.join(f'  () => journeyExpansionExperiences[{i}],\n' for i in range(3)),
    '  ...journeyExpansionBatchTwoExperiences,\n': ''.join(f'  () => journeyExpansionBatchTwoExperiences[{i}],\n' for i in range(2)),
    '  ...journeyExpansionBatchThreeExperiences,\n': ''.join(f'  () => journeyExpansionBatchThreeExperiences[{i}],\n' for i in range(3)),
    '  ...journeyExpansionBatchFourExperiences,\n': ''.join(f'  () => journeyExpansionBatchFourExperiences[{i}],\n' for i in range(5)),
    '  ...journeyExpansionBatchFiveExperiences,\n': ''.join(f'  () => journeyExpansionBatchFiveExperiences[{i}],\n' for i in range(5)),
}
for old, new in spreads.items():
    block = replace_once(block, old, new, f'daily catalog spread {old.strip()}')
block = block[:-3] + '\n]);'
text = text[:start] + block + text[close + 3:]
old_functions = """DailyJourneyExperience? journeyExperienceById(String id) {
  if (id.isEmpty) return null;
  for (final journey in allJourneyExperiences) {
    if (journey.id == id) return journey;
  }
  return null;
}

DailyJourneyExperience requireDailyJourneyExperience(String id) {
  final journey = journeyExperienceById(id);
  if (journey == null) {
    throw StateError('Journey is not registered: \"$id\".');
  }
  return journey;
}

DailyJourneyExperience dailyJourneyForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2026, 1, 1);
  final dayNumber = day.difference(epoch).inDays;
  final index = dayNumber % dailyJourneyExperiences.length;
  return dailyJourneyExperiences[index < 0
      ? index + dailyJourneyExperiences.length
      : index];
}
"""
new_functions = """DailyJourneyExperience? journeyExperienceById(String id) {
  if (id.isEmpty) return null;
  final dailyIndex = _dailyJourneyIndexById[id];
  if (dailyIndex != null) {
    return dailyJourneyExperiences[dailyIndex];
  }
  for (final journey in specialJourneyExperiences) {
    if (journey.id == id) return journey;
  }
  return null;
}

DailyJourneyExperience requireDailyJourneyExperience(String id) {
  final journey = journeyExperienceById(id);
  if (journey == null) {
    throw StateError('Journey is not registered: \"$id\".');
  }
  return journey;
}

String dailyJourneyIdForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2026, 1, 1);
  final dayNumber = day.difference(epoch).inDays;
  final index = dayNumber % dailyJourneyIds.length;
  return dailyJourneyIds[index < 0 ? index + dailyJourneyIds.length : index];
}

DailyJourneyExperience dailyJourneyForDate(DateTime date) {
  final id = dailyJourneyIdForDate(date);
  return dailyJourneyExperiences[_dailyJourneyIndexById[id]!];
}
"""
text = replace_once(text, old_functions, new_functions, 'daily catalog resolver functions')
write(path, text)

path = 'app/lib/state/app_state.dart'
text = read(path)
text = replace_once(
    text,
    '    activeJourneyId = dailyJourneyForDate(_clock()).id;\n',
    '    activeJourneyId = dailyJourneyIdForDate(_clock());\n',
    'AppState lightweight daily ID',
)
write(path, text)

path = 'app/lib/state/access_controlled_app_state.dart'
text = read(path)
text = replace_once(
    text,
    """  List<String> get eligibleRegularJourneyIds =>
      List<String>.unmodifiable(
        <String>{for (final journey in dailyJourneyExperiences) journey.id},
      );
""",
    """  List<String> get eligibleRegularJourneyIds =>
      List<String>.unmodifiable(dailyJourneyIds);
""",
    'access-control lightweight daily IDs',
)
write(path, text)

# Selected location resolution is lazy/cached. Full all-catalog validation remains callable and powers coverage.
path = 'app/lib/services/journey_location_binding.dart'
text = read(path)
old = """Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {
  final bindings = <String, JourneyLocationBinding>{};
  final paths = <String>{};
  final geoNodeIds = <String>{};

  for (final journey in allJourneyExperiences) {
    final node = _journeyGeoAgent.find(journey.content.geoNodeId);
    if (node == null) {
      throw StateError(
        'Journey ${journey.id} references unknown GeoNode: '
        '${journey.content.geoNodeId}.',
      );
    }
    if (!node.isPlace || node.latitude == null || node.longitude == null) {
      throw StateError(
        'Journey ${journey.id} must bind to a place GeoNode with coordinates.',
      );
    }
    if (!paths.add(journey.locationPath)) {
      throw StateError(
        'Duplicate Journey location path: ${journey.locationPath}.',
      );
    }
    if (!geoNodeIds.add(node.id)) {
      throw StateError('Duplicate Journey GeoNode binding: ${node.id}.');
    }

    final geoPath = _journeyGeoAgent.pathTo(node.id);
    if (geoPath.isEmpty || geoPath.last.id != node.id) {
      throw StateError('Incomplete GeoNode path for Journey ${journey.id}.');
    }

    final countryNodes = geoPath.where(
      (pathNode) => pathNode.kind == GeoNodeKind.country,
    );
    if (countryNodes.length != 1) {
      throw StateError(
        'Journey ${journey.id} must have exactly one country ancestor.',
      );
    }

    bindings[journey.id] = JourneyLocationBinding(
      journey: journey,
      placeNode: node,
      geoPath: List<GeoNode>.unmodifiable(geoPath),
    );
  }

  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);
}

JourneyLocationBinding requireJourneyLocation(String journeyId) {
  final binding = journeyLocationBindings[journeyId];
  if (binding == null) {
    throw StateError('Journey location is not registered: $journeyId.');
  }
  return binding;
}
"""
new = """final Map<String, JourneyLocationBinding> _journeyLocationBindingCache =
    <String, JourneyLocationBinding>{};

JourneyLocationBinding _buildJourneyLocationBinding(
  DailyJourneyExperience journey,
) {
  final node = _journeyGeoAgent.find(journey.geoNodeId);
  if (node == null) {
    throw StateError(
      'Journey ${journey.id} references unknown GeoNode: ${journey.geoNodeId}.',
    );
  }
  if (!node.isPlace || node.latitude == null || node.longitude == null) {
    throw StateError(
      'Journey ${journey.id} must bind to a place GeoNode with coordinates.',
    );
  }

  final geoPath = _journeyGeoAgent.pathTo(node.id);
  if (geoPath.isEmpty || geoPath.last.id != node.id) {
    throw StateError('Incomplete GeoNode path for Journey ${journey.id}.');
  }

  final countryNodes = geoPath.where(
    (pathNode) => pathNode.kind == GeoNodeKind.country,
  );
  if (countryNodes.length != 1) {
    throw StateError(
      'Journey ${journey.id} must have exactly one country ancestor.',
    );
  }

  return JourneyLocationBinding(
    journey: journey,
    placeNode: node,
    geoPath: List<GeoNode>.unmodifiable(geoPath),
  );
}

Map<String, JourneyLocationBinding> buildJourneyLocationBindingsForValidation(
  Iterable<DailyJourneyExperience> journeys,
) {
  final bindings = <String, JourneyLocationBinding>{};
  final paths = <String>{};
  final geoNodeIds = <String>{};

  for (final journey in journeys) {
    final binding = _buildJourneyLocationBinding(journey);
    if (!paths.add(binding.locationPath)) {
      throw StateError(
        'Duplicate Journey location path: ${binding.locationPath}.',
      );
    }
    if (!geoNodeIds.add(binding.geoNodeId)) {
      throw StateError(
        'Duplicate Journey GeoNode binding: ${binding.geoNodeId}.',
      );
    }
    if (bindings.containsKey(journey.id)) {
      throw StateError('Duplicate Journey ID: ${journey.id}.');
    }
    bindings[journey.id] = binding;
  }

  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);
}

Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() =>
    buildJourneyLocationBindingsForValidation(allJourneyExperiences);

JourneyLocationBinding requireJourneyLocation(String journeyId) {
  final cached = _journeyLocationBindingCache[journeyId];
  if (cached != null) return cached;
  final journey = requireDailyJourneyExperience(journeyId);
  final binding = _buildJourneyLocationBinding(journey);
  _journeyLocationBindingCache[journeyId] = binding;
  return binding;
}
"""
text = replace_once(text, old, new, 'lazy Journey location binding')
write(path, text)

# Web StartupGate settlement event.
write(
    'app/lib/services/startup_readiness_notifier.dart',
    """export 'startup_readiness_notifier_stub.dart'
    if (dart.library.html) 'startup_readiness_notifier_web.dart';
""",
)
write(
    'app/lib/services/startup_readiness_notifier_stub.dart',
    'void notifyPhoenixStartupSettled({required bool ready}) {}\n',
)
write(
    'app/lib/services/startup_readiness_notifier_web.dart',
    """import 'dart:html' as html;

void notifyPhoenixStartupSettled({required bool ready}) {
  html.window.dispatchEvent(
    html.CustomEvent(
      'phoenix-startup-settled',
      detail: ready ? 'ready' : 'error',
    ),
  );
}
""",
)

path = 'app/lib/widgets/startup_gate.dart'
text = read(path)
text = replace_once(
    text,
    "import '../screens/home_shell.dart';\n",
    "import '../screens/home_shell.dart';\nimport '../services/startup_readiness_notifier.dart';\n",
    'StartupGate notifier import',
)
text = replace_once(
    text,
    """      AppLoadStatus.error => _StartupError(
          state: state,
          message: state.displayText(
            state.loadErrorMessage ?? '暂时无法打开 Phoenix Journeys。',
          ),
          onRetry: state.load,
        ),
      AppLoadStatus.ready => const HomeShell(),
""",
    """      AppLoadStatus.error => _StartupSettled(
          ready: false,
          child: _StartupError(
            state: state,
            message: state.displayText(
              state.loadErrorMessage ?? '暂时无法打开 Phoenix Journeys。',
            ),
            onRetry: state.load,
          ),
        ),
      AppLoadStatus.ready => const _StartupSettled(
          ready: true,
          child: HomeShell(),
        ),
""",
    'StartupGate settled states',
)
settled = """
class _StartupSettled extends StatefulWidget {
  const _StartupSettled({required this.ready, required this.child});

  final bool ready;
  final Widget child;

  @override
  State<_StartupSettled> createState() => _StartupSettledState();
}

class _StartupSettledState extends State<_StartupSettled> {
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  @override
  void didUpdateWidget(covariant _StartupSettled oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ready != widget.ready) {
      _notified = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
    }
  }

  void _notify() {
    if (!mounted || _notified) return;
    _notified = true;
    notifyPhoenixStartupSettled(ready: widget.ready);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
"""
text = replace_once(
    text,
    '\nclass _StartupLoading extends StatelessWidget {',
    '\n' + settled + '\nclass _StartupLoading extends StatelessWidget {',
    'StartupGate settled widget insertion',
)
write(path, text)

# Short branded Phoenix flight, then subtle hover only if runtime is still loading.
path = 'app/web/index.html'
text = read(path)
if text.count('phoenix-time-flight-v2 12.4s') != 1:
    raise SystemExit('index.html: expected one 12.4s Phoenix flight')
text = text.replace('phoenix-time-flight-v2 12.4s', 'phoenix-time-flight-v2 3.2s', 1)
write(path, text)

write(
    'app/web/flutter_bootstrap.js',
    """{{flutter_js}}
{{flutter_build_config}}

const cover = document.getElementById('phoenix-loading');
const traveler = cover?.querySelector('.phoenix-time-traveler') ?? null;
const loadingStartedAt = performance.now();
const minimumJourneyDurationMs = 3000;
const phoenixFlightDurationMs = 3200;
let coverHidden = false;
let hoverAnimation = null;

window.__phoenixStartupTiming = {
  minimumJourneyDurationMs,
  phoenixFlightDurationMs,
};

function mark(name) {
  try {
    performance.mark(name);
  } catch (_) {}
}

mark('phoenix-cover-created');

if (traveler) {
  traveler.addEventListener('animationstart', (event) => {
    if (event.animationName === 'phoenix-time-flight-v2') {
      mark('phoenix-flight-start');
    }
  }, {passive: true});
  traveler.addEventListener('animationend', (event) => {
    if (event.animationName !== 'phoenix-time-flight-v2') return;
    mark('phoenix-flight-end');
    if (!coverHidden && typeof traveler.animate === 'function') {
      hoverAnimation = traveler.animate(
        [
          {transform: 'translateY(0) scale(1)', filter: 'brightness(1)'},
          {transform: 'translateY(-5px) scale(1.025)', filter: 'brightness(1.08)'},
          {transform: 'translateY(0) scale(1)', filter: 'brightness(1)'},
        ],
        {duration: 1350, iterations: Infinity, easing: 'ease-in-out'},
      );
    }
  }, {passive: true});
}

let settleResolve;
const startupSettled = new Promise((resolve) => {
  settleResolve = resolve;
});

window.addEventListener('phoenix-startup-settled', (event) => {
  const status = event?.detail === 'error' ? 'error' : 'ready';
  mark(status === 'ready' ? 'phoenix-home-ready' : 'phoenix-startup-error');
  settleResolve(status);
}, {once: true});

async function waitForStartupSettled() {
  return Promise.race([
    startupSettled,
    new Promise((_, reject) => {
      setTimeout(
        () => reject(new Error('Phoenix StartupGate did not settle within 60s.')),
        60000,
      );
    }),
  ]);
}

async function hideLoading() {
  if (!cover || coverHidden) return;
  mark('phoenix-hide-loading-requested');
  const elapsed = performance.now() - loadingStartedAt;
  const remaining = Math.max(0, minimumJourneyDurationMs - elapsed);
  mark('phoenix-minimum-duration-wait-start');
  if (remaining > 0) {
    await new Promise((resolve) => setTimeout(resolve, remaining));
  }
  mark('phoenix-minimum-duration-wait-end');
  coverHidden = true;
  hoverAnimation?.cancel();
  cover.classList.add('phoenix-loading-hidden');
  mark('phoenix-cover-hidden');
  setTimeout(() => {
    cover.remove();
    mark('phoenix-cover-removed');
  }, 760);
}

try {
  mark('phoenix-flutter-loader-start');
  await _flutter.loader.load({
    onEntrypointLoaded: async (engineInitializer) => {
      mark('phoenix-entrypoint-loaded');
      mark('phoenix-engine-initialize-start');
      const appRunner = await engineInitializer.initializeEngine({
        useColorEmoji: true,
      });
      mark('phoenix-engine-initialize-end');
      mark('phoenix-app-runner-start');
      await appRunner.runApp();
      mark('phoenix-app-runner-end');
      await waitForStartupSettled();
      await hideLoading();
    },
  });
} catch (error) {
  console.error('Phoenix startup failed:', error);
  mark('phoenix-startup-bootstrap-error');
  if (cover) {
    cover.querySelector('.phoenix-loading-title').textContent =
      'Phoenix Journeys · 启动失败';
    cover.querySelector('.phoenix-loading-subtitle').textContent =
      '请刷新页面后重试';
  }
}
""",
)

# Focused parity and lazy-runtime regression coverage.
write(
    'app/test/startup_lazy_runtime_test.dart',
    """import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  group('startup lazy Journey registry', () {
    test('schedule IDs preserve canonical publication order and membership', () {
      expect(dailyJourneyIds, hasLength(27));
      expect(dailyJourneyIds.toSet(), hasLength(dailyJourneyIds.length));
      expect(
        dailyJourneyExperiences.map((journey) => journey.id).toList(),
        dailyJourneyIds,
      );
    });

    test('date mapping preserves modulo semantics including pre-epoch', () {
      final dates = <DateTime>[
        DateTime.utc(2025, 12, 1),
        DateTime.utc(2025, 12, 31),
        DateTime.utc(2026, 1, 1),
        DateTime.utc(2026, 1, 27),
        DateTime.utc(2026, 8, 18),
        DateTime.utc(2030, 1, 1),
      ];
      final epoch = DateTime.utc(2026, 1, 1);
      for (final date in dates) {
        final day = DateTime.utc(date.year, date.month, date.day);
        final dayNumber = day.difference(epoch).inDays;
        final rawIndex = dayNumber % dailyJourneyIds.length;
        final index = rawIndex < 0 ? rawIndex + dailyJourneyIds.length : rawIndex;
        expect(dailyJourneyIdForDate(date), dailyJourneyIds[index]);
        expect(dailyJourneyForDate(date).id, dailyJourneyIds[index]);
      }
    });

    test('every registered ID resolves directly', () {
      for (final id in dailyJourneyIds) {
        expect(requireDailyJourneyExperience(id).id, id);
      }
    });

    test('full catalog remains available to governance paths', () {
      expect(allJourneyExperiences, isNotEmpty);
      expect(
        allJourneyExperiences.map((journey) => journey.id).toSet(),
        containsAll(dailyJourneyIds),
      );
    });
  });

  group('lazy Journey location binding', () {
    test('selected binding preserves namespaces and identity', () {
      const id = 'lijiang-old-town';
      final journey = requireDailyJourneyExperience(id);
      final binding = requireJourneyLocation(id);
      expect(binding.journeyId, id);
      expect(binding.geoNodeId, journey.geoNodeId);
      expect(binding.locationPath, journey.locationPath);
      expect(binding.storageNamespace, 'journey.${journey.locationPath}');
      expect(binding.legacyStorageNamespace, 'journey.$id');
    });

    test('full validation still materializes complete valid coverage', () {
      final bindings =
          buildJourneyLocationBindingsForValidation(allJourneyExperiences);
      expect(bindings.length, allJourneyExperiences.length);
      expect(bindings.keys.toSet(), allJourneyExperiences.map((e) => e.id).toSet());
      expect(
        bindings.values.map((e) => e.locationPath).toSet().length,
        bindings.length,
      );
      expect(
        bindings.values.map((e) => e.geoNodeId).toSet().length,
        bindings.length,
      );
    });
  });
}
""",
)

# Static architecture gates before Flutter validation.
if 'activeJourneyId = dailyJourneyForDate' in read('app/lib/state/app_state.dart'):
    raise SystemExit('AppState still resolves full Journey during constructor')
if 'for (final journey in dailyJourneyExperiences) journey.id' in read('app/lib/state/access_controlled_app_state.dart'):
    raise SystemExit('Access policy still materializes the regular Journey catalog')
if 'final binding = journeyLocationBindings[journeyId]' in read('app/lib/services/journey_location_binding.dart'):
    raise SystemExit('requireJourneyLocation still touches the full binding map')
if 'minimumJourneyDurationMs = 11550' in read('app/web/flutter_bootstrap.js'):
    raise SystemExit('long intentional cover hold survived remediation')
if 'phoenix-time-flight-v2 12.4s' in read('app/web/index.html'):
    raise SystemExit('long one-shot Phoenix flight survived remediation')

print('PR194 RUNTIME REMEDIATION PATCH = APPLIED')
