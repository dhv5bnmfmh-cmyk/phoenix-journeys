import '../models/journey_background.dart';
import 'journey_background_generated.dart';

const summerPalaceLivingBackgroundAssetPath =
    'assets/images/backgrounds/generated/beijing/summer-palace/06-summer-lotus-lake.webp';

const _seedJourneys = <String>[
  'beijing-forbidden-city',
  'shanghai-bund',
  'xian-city-wall',
  'hangzhou-west-lake',
  'chengdu-kuanzhai-alley',
  'nanjing-qinhuai-river',
  'guangzhou-chen-clan-academy',
];

final seedJourneyBackgrounds = <JourneyBackgroundAsset>[
  for (final journeyId in _seedJourneys)
    for (var variant = 1; variant <= 3; variant += 1)
      JourneyBackgroundAsset(
        id: '$journeyId-seed-v$variant',
        journeyId: journeyId,
        assetPath: 'assets/images/backgrounds/seed/$journeyId-v$variant.webp',
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
