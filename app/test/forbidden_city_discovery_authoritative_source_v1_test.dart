import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/widgets/discovery_authority_line.dart';
import 'package:phoenix_journeys/widgets/interactive_story_text.dart';

void main() {
  test('Forbidden City Discovery owns claim-specific optional canonical sources', () {
    for (var level = 1; level <= 10; level += 1) {
      final first = forbiddenCityLevelContent(level);
      final second = forbiddenCityLevelContent(level);
      expect(first.discoveries, hasLength(2));
      expect(
        second.discoveries.map((entry) => entry.text).toList(growable: false),
        first.discoveries.map((entry) => entry.text).toList(growable: false),
        reason: 'Lv$level Discovery must remain deterministic',
      );
      for (final entry in first.discoveries) {
        expect(entry.sourceRefs.toSet().length, entry.sourceRefs.length);
        if (entry.sourceRefs.isEmpty) continue;
        final labels = forbiddenCityAuthorityLabels(entry.sourceRefs);
        expect(labels, isNotEmpty);
        expect(
          labels.length,
          lessThan(3),
          reason: 'Do not attach every authority family to every claim',
        );
      }
    }
  });

  test('sourceRefs correspond to concrete knowledge claims', () {
    final lv1 = forbiddenCityLevelContent(1).discoveries.first;
    expect(lv1.text, contains('午门'));
    expect(lv1.sourceRefs, contains(forbiddenCityMeridianGateSourceRef));
    expect(lv1.sourceRefs, contains(forbiddenCityAxisPlanSourceRef));
    expect(lv1.sourceRefs, isNot(contains(forbiddenCityQianqingGateSourceRef)));

    final lv4 = forbiddenCityLevelContent(4).discoveries.first;
    expect(lv4.text, contains('乾清门'));
    expect(lv4.sourceRefs, contains(forbiddenCityQianqingGateSourceRef));

    final lv5 = forbiddenCityLevelContent(5).discoveries.first;
    expect(lv5.text, contains('景运门'));
    expect(
      lv5.sourceRefs,
      equals(<String>[forbiddenCityJingyunGateSourceRef]),
    );
    expect(lv5.sourceRefs, isNot(contains(forbiddenCityDpmSourceRef)));
    expect(lv5.sourceRefs, isNot(contains(forbiddenCityQianqingGateSourceRef)));

    final lv6Inference = forbiddenCityLevelContent(6).discoveries.first;
    expect(lv6Inference.text, contains('可行性和任务适配'));
    expect(lv6Inference.sourceRefs, isEmpty);

    final lv10 = forbiddenCityLevelContent(10).discoveries;
    expect(lv10.every((entry) => entry.sourceRefs.isEmpty), isTrue);
  });

  test('source labels and URLs are non-empty for every displayed authority', () {
    for (var level = 1; level <= 10; level += 1) {
      for (final entry in forbiddenCityLevelContent(level).discoveries) {
        for (final sourceRef in entry.sourceRefs) {
          expect(sourceRef.trim(), isNotEmpty);
          final uri = Uri.tryParse(sourceRef);
          expect(uri, isNotNull);
          expect(uri!.scheme, 'https');
          final label = forbiddenCityAuthorityLabelForSourceRef(sourceRef);
          expect(label, isNotNull);
          expect(label!.trim(), isNotEmpty);
        }
      }
    }
    expect(
      forbiddenCityJingyunGateSourceRef,
      'https://www.dpm.org.cn/explore/building/236497.html',
    );
  });

  test('no-source Discovery is safe and authority labels are deduplicated', () {
    const entry = DiscoveryEntry(
      text: '无来源测试正文',
      simpleChinese: '无来源',
      vietnamese: 'Không nguồn',
      english: 'No source',
    );
    expect(entry.sourceRefs, isEmpty);
    expect(forbiddenCityAuthorityLabels(entry.sourceRefs), isEmpty);
    expect(
      forbiddenCityAuthorityLabels(<String>[
        forbiddenCityDpmSourceRef,
        forbiddenCityMeridianGateSourceRef,
      ]),
      equals(<String>['故宫博物院']),
    );
  });

  test('source metadata does not mutate Discovery body or level progression', () {
    for (var level = 1; level <= 10; level += 1) {
      final beforeWords = forbiddenCityWordsForLevel(level)
          .map((entry) => entry.word)
          .toList(growable: false);
      final content = forbiddenCityLevelContent(level);
      final body = content.discoveries
          .map((entry) => entry.text)
          .toList(growable: false);

      for (final entry in content.discoveries) {
        forbiddenCityAuthorityLabels(entry.sourceRefs);
      }

      expect(
        content.discoveries.map((entry) => entry.text).toList(growable: false),
        body,
      );
      expect(
        forbiddenCityWordsForLevel(level)
            .map((entry) => entry.word)
            .toList(growable: false),
        beforeWords,
      );
    }
  });

  test('interactive Discovery text remains byte-for-byte complete', () {
    for (var level = 1; level <= 10; level += 1) {
      final content = forbiddenCityLevelContent(level);
      for (final discovery in content.discoveries) {
        expect(
          segmentStoryText(discovery.text, content.words)
              .map((segment) => segment.text)
              .join(),
          discovery.text,
        );
      }
    }
  });

  testWidgets('authority UI is lightweight and hides cleanly without sources', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              DiscoveryAuthorityLine(
                key: ValueKey('with-source'),
                authorityLabels: <String>['故宫博物院', '故宫博物院'],
              ),
              DiscoveryAuthorityLine(
                key: ValueKey('without-source'),
                authorityLabels: <String>[],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('知识依据 · 故宫博物院'), findsOneWidget);
    expect(find.textContaining('http'), findsNothing);
    expect(
      tester.widget<DiscoveryAuthorityLine>(find.byKey(const ValueKey('without-source')))
          .authorityLabels,
      isEmpty,
    );
  });
}
