import '../models/journey_background.dart';
import 'journey_story_identity.dart';

final forbiddenCityStoryTwoBackgrounds = <JourneyBackgroundAsset>[
  for (final assetName in <String>[
    '01-palace-axis-soft-morning',
    '02-roofline-haze',
    '03-red-wall-eaves',
    '04-doorway-observer',
    '05-golden-courtyard',
    '06-courtyard-profile',
    '07-old-paper-shadow',
    '08-old-paper-light',
    '09-palace-wall-sunset',
    '10-quiet-palace-edge',
  ])
    JourneyBackgroundAsset(
      id: '$forbiddenCityStoryTwoJourneyId-$assetName',
      journeyId: forbiddenCityStoryTwoJourneyId,
      assetPath:
          'assets/images/backgrounds/generated/beijing/forbidden-city/wuying-hall-light-limit/$assetName.webp',
      generatedOn: DateTime.utc(2026, 9, 16),
      origin: JourneyBackgroundOrigin.aiGenerated,
      complianceReviewed: true,
      complianceScore: 100,
      varietyScore: 90,
    ),
];
