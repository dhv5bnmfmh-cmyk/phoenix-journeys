import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_background_catalog.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/services/journey_background_policy.dart';

void main() {
  test('Xian ships a complete reviewed ten-image offline library', () {
    final assets = journeyBackgroundCatalog
        .where(
          (asset) =>
              asset.journeyId == 'xian-city-wall' &&
              asset.origin == JourneyBackgroundOrigin.aiGenerated,
        )
        .toList(growable: false);

    expect(assets, hasLength(10));
    expect(assets.map((asset) => asset.id).toSet(), hasLength(10));
    expect(assets.every((asset) => asset.approved), isTrue);
    expect(assets.every((asset) => asset.assetPath.endsWith('.webp')), isTrue);

    final kpi = const JourneyBackgroundPolicy().inspect(
      journeyId: 'xian-city-wall',
      page: JourneyBackgroundPage.story,
      catalog: journeyBackgroundCatalog,
    );
    expect(kpi.destinationTargetMet, isTrue);
    expect(kpi.pageTargetMet, isTrue);
  });
}
