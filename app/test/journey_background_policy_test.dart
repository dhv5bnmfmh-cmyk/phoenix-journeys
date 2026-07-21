import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/journey_background_catalog.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/services/journey_background_policy.dart';

void main() {
  const policy = JourneyBackgroundPolicy();

  test('same destination page and local day keep a stable image', () {
    final first = policy.select(
      journeyId: 'nanjing-qinhuai-river',
      page: JourneyBackgroundPage.story,
      localDate: DateTime(2026, 7, 21, 8),
      catalog: journeyBackgroundCatalog,
    );
    final second = policy.select(
      journeyId: 'nanjing-qinhuai-river',
      page: JourneyBackgroundPage.story,
      localDate: DateTime(2026, 7, 21, 22),
      catalog: journeyBackgroundCatalog,
    );
    expect(first, isNotNull);
    expect(first!.id, second!.id);
  });

  test('every published seed destination has three approved originals', () {
    const journeys = [
      'beijing-forbidden-city',
      'shanghai-bund',
      'xian-city-wall',
      'hangzhou-west-lake',
      'chengdu-kuanzhai-alley',
      'nanjing-qinhuai-river',
      'guangzhou-chen-clan',
    ];
    for (final journeyId in journeys) {
      final assets = seedJourneyBackgrounds
          .where((asset) => asset.journeyId == journeyId)
          .toList(growable: false);
      expect(assets, hasLength(3));
      expect(assets.every((asset) => asset.approved), isTrue);
    }
  });

  test('KPI constants remain centralized and adjustable', () {
    expect(JourneyBackgroundPolicy.dailyApprovedTargetPerDestination, 4);
    expect(JourneyBackgroundPolicy.minimumDestinationInventory, 20);
    expect(JourneyBackgroundPolicy.minimumPageInventory, 5);
    expect(JourneyBackgroundPolicy.minimumComplianceScore, 90);
  });
}
