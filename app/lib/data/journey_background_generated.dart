import '../models/journey_background.dart';

// Rewritten automatically by PhoenixBackgroundScheduler after compliance review.
final generatedJourneyBackgrounds = <JourneyBackgroundAsset>[
  for (final assetName in <String>[
    '01-twilight-courtyard',
    '02-moonlit-palace',
    '03-golden-gate',
    '04-winter-snow',
    '05-after-rain',
    '06-autumn-maples',
    '07-clear-morning',
    '08-sunlit-corridor',
    '09-misty-courtyard',
    '10-sunset-panorama',
  ])
    JourneyBackgroundAsset(
      id: 'beijing-forbidden-city-$assetName',
      journeyId: 'beijing-forbidden-city',
      assetPath:
          'assets/images/backgrounds/generated/beijing-forbidden-city-$assetName.webp',
      generatedOn: DateTime.utc(2026, 7, 22),
      origin: JourneyBackgroundOrigin.aiGenerated,
      complianceReviewed: true,
      complianceScore: 100,
      varietyScore: 100,
    ),
];
