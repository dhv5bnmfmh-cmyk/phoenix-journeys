from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    target = Path(path)
    text = target.read_text()
    if old not in text:
        raise SystemExit(f'missing patch anchor in {path}: {old[:100]!r}')
    target.write_text(text.replace(old, new, 1))


replace_once(
    'app/lib/data/beijing_city_standard.dart',
    "const _unesco = 'https://whc.unesco.org/en/list/439/';\n",
    """const _unesco = 'https://whc.unesco.org/en/list/439/';

// Discovery provenance reuses these existing canonical Beijing sourceRefs.
const forbiddenCityDpmSourceRef = _dpm;
const forbiddenCityMeridianGateSourceRef = _meridianGate;
const forbiddenCityQianqingGateSourceRef = _qianqingGate;
const forbiddenCityAxisPlanSourceRef = _axisPlan;
const forbiddenCityUnescoSourceRef = _unesco;

String? forbiddenCityAuthorityLabelForSourceRef(String sourceRef) {
  if (sourceRef.contains('dpm.org.cn')) return '故宫博物院';
  if (sourceRef.contains('beijing.gov.cn')) return '北京市官方资料';
  if (sourceRef.contains('whc.unesco.org')) return 'UNESCO';
  return null;
}

List<String> forbiddenCityAuthorityLabels(Iterable<String> sourceRefs) {
  final seen = <String>{};
  final labels = <String>[];
  for (final sourceRef in sourceRefs) {
    final label = forbiddenCityAuthorityLabelForSourceRef(sourceRef);
    if (label != null && seen.add(label)) labels.add(label);
  }
  return List<String>.unmodifiable(labels);
}
""",
)

replace_once(
    'app/lib/data/journey_data.dart',
    """    required this.english,
    this.pinyin = '',
  });

  final String text;
  final String simpleChinese;
  final String vietnamese;
  final String english;
  final String pinyin;
""",
    """    required this.english,
    this.pinyin = '',
    this.sourceRefs = const <String>[],
  });

  final String text;
  final String simpleChinese;
  final String vietnamese;
  final String english;
  final String pinyin;
  final List<String> sourceRefs;
""",
)

replace_once(
    'app/lib/data/journey_level_catalog.dart',
    """DiscoveryEntry _mergeDiscoveries(List<DiscoveryEntry> entries) {
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese: _joinChinese(entries.map((entry) => entry.simpleChinese)),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
  );
}
""",
    """DiscoveryEntry _mergeDiscoveries(List<DiscoveryEntry> entries) {
  final seenRefs = <String>{};
  final sourceRefs = <String>[
    for (final entry in entries)
      for (final sourceRef in entry.sourceRefs)
        if (sourceRef.trim().isNotEmpty && seenRefs.add(sourceRef)) sourceRef,
  ];
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese: _joinChinese(entries.map((entry) => entry.simpleChinese)),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
    sourceRefs: List<String>.unmodifiable(sourceRefs),
  );
}
""",
)

replace_once(
    'app/lib/data/forbidden_city_journey_runtime.dart',
    """import 'journey_data.dart';
import 'journey_level_catalog.dart';
""",
    """import 'beijing_city_standard.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
""",
)

replace_once(
    'app/lib/data/forbidden_city_journey_runtime.dart',
    """List<DiscoveryEntry> _discoveriesForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final focus = forbiddenCityDiscoveryFocusByLevel[safeLevel - 1];
  final grounding = switch (safeLevel) {
    1 || 2 => forbiddenCityDiscoveries[0],
    3 || 4 => forbiddenCityDiscoveries[1],
    5 || 6 => forbiddenCityDiscoveries[2],
    7 || 8 => forbiddenCityDiscoveries[3],
    _ => forbiddenCityDiscoveries[4],
  };
  return <DiscoveryEntry>[focus, grounding];
}
""",
    """const _forbiddenCityGroundingSourceRefs = <List<String>>[
  <String>[forbiddenCityMeridianGateSourceRef, forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityQianqingGateSourceRef],
  <String>[forbiddenCityDpmSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef, forbiddenCityUnescoSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
];

const _forbiddenCityFocusSourceRefs = <List<String>>[
  <String>[forbiddenCityMeridianGateSourceRef, forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityQianqingGateSourceRef, forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityDpmSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef, forbiddenCityUnescoSourceRef],
  <String>[forbiddenCityAxisPlanSourceRef],
];

DiscoveryEntry _discoveryWithSources(
  DiscoveryEntry entry,
  List<String> sourceRefs,
) {
  final seen = <String>{};
  return DiscoveryEntry(
    text: entry.text,
    simpleChinese: entry.simpleChinese,
    vietnamese: entry.vietnamese,
    english: entry.english,
    pinyin: entry.pinyin,
    sourceRefs: List<String>.unmodifiable(
      sourceRefs.where((ref) => ref.trim().isNotEmpty && seen.add(ref)),
    ),
  );
}

List<DiscoveryEntry> _discoveriesForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final focusIndex = safeLevel - 1;
  final groundingIndex = switch (safeLevel) {
    1 || 2 => 0,
    3 || 4 => 1,
    5 || 6 => 2,
    7 || 8 => 3,
    _ => 4,
  };
  return <DiscoveryEntry>[
    _discoveryWithSources(
      forbiddenCityDiscoveryFocusByLevel[focusIndex],
      _forbiddenCityFocusSourceRefs[focusIndex],
    ),
    _discoveryWithSources(
      forbiddenCityDiscoveries[groundingIndex],
      _forbiddenCityGroundingSourceRefs[groundingIndex],
    ),
  ];
}
""",
)

replace_once(
    'app/lib/screens/journey_screen.dart',
    "import '../widgets/destination_background.dart';\n",
    """import '../widgets/destination_background.dart';
import '../widgets/discovery_authority_line.dart';
""",
)

replace_once(
    'app/lib/screens/journey_screen.dart',
    """                        final item = entry.value;
                        final snapshot = _narration.highlightSnapshot;
""",
    """                        final item = entry.value;
                        final sourceLabels = _isForbiddenCity
                            ? forbiddenCityAuthorityLabels(item.sourceRefs)
                            : const <String>[];
                        final snapshot = _narration.highlightSnapshot;
""",
)

replace_once(
    'app/lib/screens/journey_screen.dart',
    """                          transparentSurface: true,
                          onSupport: () => unawaited(
""",
    """                          transparentSurface: true,
                          footer: sourceLabels.isEmpty
                              ? null
                              : DiscoveryAuthorityLine(
                                  key: ValueKey(
                                    'discovery-authoritative-source-${entry.key}',
                                  ),
                                  authorityLabels: sourceLabels,
                                ),
                          onSupport: () => unawaited(
""",
)

replace_once(
    'app/lib/screens/journey_screen.dart',
    """    required this.onSupport,
    this.transparentSurface = false,
  });

  final int index;
  final bool active;
  final Widget child;
  final VoidCallback onSupport;
  final bool transparentSurface;
""",
    """    required this.onSupport,
    this.footer,
    this.transparentSurface = false,
  });

  final int index;
  final bool active;
  final Widget child;
  final VoidCallback onSupport;
  final Widget? footer;
  final bool transparentSurface;
""",
)

replace_once(
    'app/lib/screens/journey_screen.dart',
    """          const SizedBox(width: 4),
          Expanded(child: child),
          SizedBox(
""",
    """          const SizedBox(width: 4),
          Expanded(
            child: footer == null
                ? child
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      child,
                      footer!,
                    ],
                  ),
          ),
          SizedBox(
""",
)

Path('app/lib/data/forbidden_city_discovery_sources.dart').unlink(missing_ok=True)
