import 'beijing_city_standard.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';

/// Claim-level authoritative provenance for Forbidden City Discovery.
///
/// The references below are not a second source catalog. They are selected
/// from the canonical sourceRefs already owned by the Beijing City Standard.
/// Discovery only decides which existing reference supports each rendered
/// knowledge claim.
List<String> forbiddenCityDiscoverySourceRefs(DiscoveryEntry entry) {
  final baseIndex = forbiddenCityDiscoveries.indexWhere(
    (candidate) => candidate.text == entry.text,
  );
  if (baseIndex >= 0) {
    return _dedupeRefs(_baseDiscoveryRefs(baseIndex));
  }

  final focusIndex = forbiddenCityDiscoveryFocusByLevel.indexWhere(
    (candidate) => candidate.text == entry.text,
  );
  if (focusIndex >= 0) {
    return _dedupeRefs(_focusDiscoveryRefs(focusIndex));
  }

  return const <String>[];
}

List<String> forbiddenCityDiscoverySourceRefsForText(String text) {
  final base = forbiddenCityDiscoveries.where((entry) => entry.text == text);
  if (base.isNotEmpty) return forbiddenCityDiscoverySourceRefs(base.first);

  final focus =
      forbiddenCityDiscoveryFocusByLevel.where((entry) => entry.text == text);
  if (focus.isNotEmpty) return forbiddenCityDiscoverySourceRefs(focus.first);

  return const <String>[];
}

List<String> forbiddenCityDiscoveryAuthorityLabelsForText(String text) {
  final seen = <String>{};
  return <String>[
    for (final sourceRef in forbiddenCityDiscoverySourceRefsForText(text))
      if (_authorityLabel(sourceRef) case final label? when seen.add(label))
        label,
  ];
}

List<String> _baseDiscoveryRefs(int index) {
  final dpm = _canonicalRefContaining('dpm.org.cn');
  final axisPlan = _canonicalRefContaining('beijing.gov.cn');
  final unesco = _canonicalRefContaining('whc.unesco.org');
  final meridianGate = forbiddenCityJourney01Scenes.first.sourceRefs.firstWhere(
    (ref) => ref.contains('dpm.org.cn'),
    orElse: () => dpm,
  );
  final qianqingGate = forbiddenCityJourney01Scenes.last.sourceRefs.firstWhere(
    (ref) => ref.contains('dpm.org.cn'),
    orElse: () => dpm,
  );

  return switch (index) {
    0 => <String>[meridianGate, axisPlan],
    1 => <String>[qianqingGate],
    2 => <String>[dpm],
    3 => <String>[axisPlan, unesco],
    4 => <String>[axisPlan],
    _ => const <String>[],
  };
}

List<String> _focusDiscoveryRefs(int index) {
  final dpm = _canonicalRefContaining('dpm.org.cn');
  final axisPlan = _canonicalRefContaining('beijing.gov.cn');
  final unesco = _canonicalRefContaining('whc.unesco.org');
  final meridianGate = forbiddenCityJourney01Scenes.first.sourceRefs.firstWhere(
    (ref) => ref.contains('dpm.org.cn'),
    orElse: () => dpm,
  );
  final qianqingGate = forbiddenCityJourney01Scenes.last.sourceRefs.firstWhere(
    (ref) => ref.contains('dpm.org.cn'),
    orElse: () => dpm,
  );

  return switch (index) {
    0 => <String>[meridianGate, axisPlan],
    1 => <String>[axisPlan],
    2 => <String>[axisPlan],
    3 => <String>[qianqingGate, axisPlan],
    4 => <String>[dpm],
    5 => <String>[axisPlan],
    6 => <String>[axisPlan],
    7 => <String>[axisPlan],
    8 => <String>[axisPlan, unesco],
    9 => <String>[axisPlan],
    _ => const <String>[],
  };
}

String _canonicalRefContaining(String marker) {
  return forbiddenCityPlace.sourceRefs.firstWhere(
    (ref) => ref.contains(marker),
    orElse: () => throw StateError(
      'Forbidden City canonical sourceRef missing: $marker',
    ),
  );
}

List<String> _dedupeRefs(Iterable<String> refs) {
  final seen = <String>{};
  return List<String>.unmodifiable(
    refs.where((ref) => ref.trim().isNotEmpty && seen.add(ref)),
  );
}

String? _authorityLabel(String sourceRef) {
  if (sourceRef.contains('dpm.org.cn')) return '故宫博物院';
  if (sourceRef.contains('beijing.gov.cn')) return '北京市官方资料';
  if (sourceRef.contains('whc.unesco.org')) return 'UNESCO';
  return null;
}
