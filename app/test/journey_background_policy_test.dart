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

  test('every published seed destination has three approved fallbacks', () {
    const journeys = [
      'beijing-forbidden-city',
      'shanghai-bund',
      'xian-city-wall',
      'hangzhou-west-lake',
      'chengdu-kuanzhai-alley',
      'nanjing-qinhuai-river',
      'guangzhou-chen-clan-academy',
    ];
    for (final journeyId in journeys) {
      final assets = seedJourneyBackgrounds
          .where((asset) => asset.journeyId == journeyId)
          .toList(growable: false);
      expect(assets, hasLength(3));
      expect(assets.every((asset) => asset.approved), isTrue);
    }
  });

  test('approved AI backgrounds replace geometric seed fallbacks', () {
    final selected = policy.select(
      journeyId: 'beijing-forbidden-city',
      page: JourneyBackgroundPage.story,
      localDate: DateTime(2026, 7, 21),
      catalog: [
        _asset(id: 'seed', origin: JourneyBackgroundOrigin.originalSeed),
        _asset(id: 'ai', origin: JourneyBackgroundOrigin.aiGenerated),
      ],
    );

    expect(selected, isNotNull);
    expect(selected!.id, 'ai');
  });

  test('AI backgrounds below the variety threshold never reach runtime', () {
    final selected = policy.select(
      journeyId: 'beijing-forbidden-city',
      page: JourneyBackgroundPage.story,
      localDate: DateTime(2026, 7, 21),
      catalog: [
        _asset(id: 'seed', origin: JourneyBackgroundOrigin.originalSeed),
        _asset(
          id: 'flat-ai',
          origin: JourneyBackgroundOrigin.aiGenerated,
          varietyScore: 79,
        ),
      ],
    );

    expect(selected, isNotNull);
    expect(selected!.id, 'seed');
  });

  test('inventory KPI counts reviewed AI assets rather than fallbacks', () {
    final kpi = policy.inspect(
      journeyId: 'beijing-forbidden-city',
      page: JourneyBackgroundPage.story,
      catalog: [
        _asset(id: 'seed', origin: JourneyBackgroundOrigin.originalSeed),
        _asset(id: 'ai', origin: JourneyBackgroundOrigin.aiGenerated),
      ],
    );

    expect(kpi.destinationInventory, 1);
    expect(kpi.pageInventory, 1);
    expect(kpi.destinationTargetMet, isFalse);
    expect(kpi.pageTargetMet, isFalse);
  });

  test('runtime AI background must match the Journey location folder', () {
    final selected = policy.select(
      journeyId: 'beijing-forbidden-city',
      locationPath: 'beijing/forbidden-city',
      page: JourneyBackgroundPage.story,
      localDate: DateTime(2026, 7, 22),
      catalog: [
        JourneyBackgroundAsset(
          id: 'wrong-folder',
          journeyId: 'beijing-forbidden-city',
          assetPath:
              'assets/images/backgrounds/generated/beijing/summer-palace/wrong.webp',
          generatedOn: DateTime.utc(2026, 7, 22),
          origin: JourneyBackgroundOrigin.aiGenerated,
          complianceReviewed: true,
          complianceScore: 100,
        ),
        JourneyBackgroundAsset(
          id: 'correct-folder',
          journeyId: 'beijing-forbidden-city',
          assetPath:
              'assets/images/backgrounds/generated/beijing/forbidden-city/correct.webp',
          generatedOn: DateTime.utc(2026, 7, 22),
          origin: JourneyBackgroundOrigin.aiGenerated,
          complianceReviewed: true,
          complianceScore: 100,
        ),
      ],
    );

    expect(selected, isNotNull);
    expect(selected!.id, 'correct-folder');
  });

  test('KPI constants permanently require ten offline images per city', () {
    expect(JourneyBackgroundPolicy.requiredOfflineInventoryPerDestination, 10);
    expect(JourneyBackgroundPolicy.minimumDestinationInventory, 10);
    expect(JourneyBackgroundPolicy.minimumPageInventory, 10);
    expect(JourneyBackgroundPolicy.minimumComplianceScore, 90);
    expect(JourneyBackgroundPolicy.minimumVarietyScore, 80);
  });
}

JourneyBackgroundAsset _asset({
  required String id,
  required JourneyBackgroundOrigin origin,
  int varietyScore = 100,
}) {
  return JourneyBackgroundAsset(
    id: id,
    journeyId: 'beijing-forbidden-city',
    assetPath: 'assets/images/backgrounds/$id.webp',
    generatedOn: DateTime.utc(2026, 7, 21),
    origin: origin,
    complianceReviewed: true,
    complianceScore: 100,
    varietyScore: varietyScore,
  );
}
