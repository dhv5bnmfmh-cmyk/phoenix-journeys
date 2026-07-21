import '../models/journey_background.dart';
import 'journey_background_generated.dart';

class _SeedJourneySpec {
  const _SeedJourneySpec(this.journeyId, this.assetPrefix);

  final String journeyId;
  final String assetPrefix;
}

const _seedJourneys = <_SeedJourneySpec>[
  _SeedJourneySpec('beijing-forbidden-city', 'beijing-forbidden-city'),
  _SeedJourneySpec('shanghai-bund', 'shanghai-bund'),
  _SeedJourneySpec('xian-city-wall', 'xian-city-wall'),
  _SeedJourneySpec('hangzhou-west-lake', 'hangzhou-west-lake'),
  _SeedJourneySpec('chengdu-kuanzhai-alley', 'chengdu-kuanzhai-alley'),
  _SeedJourneySpec('nanjing-qinhuai-river', 'nanjing-qinhuai-river'),
  _SeedJourneySpec(
    'guangzhou-chen-clan-academy',
    'guangzhou-chen-clan',
  ),
];

final seedJourneyBackgrounds = <JourneyBackgroundAsset>[
  for (final journey in _seedJourneys)
    for (var variant = 1; variant <= 3; variant += 1)
      JourneyBackgroundAsset(
        id: '${journey.journeyId}-seed-v$variant',
        journeyId: journey.journeyId,
        assetPath:
            'assets/images/backgrounds/seed/${journey.assetPrefix}-v$variant.webp',
        generatedOn: DateTime.utc(2026, 7, 21),
        origin: JourneyBackgroundOrigin.originalSeed,
        complianceReviewed: true,
        complianceScore: 100,
      ),
];

final journeyBackgroundCatalog = <JourneyBackgroundAsset>[
  ...generatedJourneyBackgrounds,
  ...seedJourneyBackgrounds,
];
