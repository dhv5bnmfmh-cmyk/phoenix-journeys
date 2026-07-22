import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('every Journey has one GeoNode, map point and location path', () {
    expect(journeyLocationBindings, hasLength(dailyJourneyExperiences.length));

    final paths = <String>{};
    final geoNodes = <String>{};
    final mapPoints = <JourneyMapPoint>{};
    for (final journey in dailyJourneyExperiences) {
      final binding = requireJourneyLocation(journey.id);
      expect(binding.locationPath, journey.locationPath);
      expect(binding.geoNodeId, journey.geoNodeId);
      expect(binding.placeNode.isPlace, isTrue);
      expect(binding.latitude, inInclusiveRange(20, 42));
      expect(binding.longitude, inInclusiveRange(100, 123));
      expect(binding.mapPoint.x, inInclusiveRange(.38, .88));
      expect(binding.mapPoint.y, inInclusiveRange(.28, .72));
      expect(
        binding.generatedBackgroundDirectory,
        contains('/${journey.locationPath}/'),
      );
      expect(paths.add(binding.locationPath), isTrue);
      expect(geoNodes.add(binding.geoNodeId), isTrue);
      mapPoints.add(binding.mapPoint);
    }

    expect(mapPoints.length, greaterThan(4));
  });

  test('legacy Journey keys migrate to city/destination path keys', () async {
    final state = AppState(clock: () => DateTime(2026, 7, 22));
    final target = dailyJourneyExperiences.firstWhere(
      (journey) => journey.id != state.activeJourneyId,
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      'journey.${target.id}.step': 3,
      'journey.${target.id}.furthestStep': 4,
      'journey.${target.id}.wonderDraft': '旧记录仍然存在',
    });

    await state.load();
    await state.activateJourney(target.id);

    expect(state.journeyStep, 3);
    expect(state.journeyFurthestStep, 4);
    expect(state.wonderDraft, '旧记录仍然存在');
    expect(state.activeJourneyStoragePath, 'journey.${target.locationPath}');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('journey.${target.locationPath}.step'), 3);
    expect(prefs.getInt('journey.${target.locationPath}.furthestStep'), 4);
    expect(
      prefs.getString('journey.${target.locationPath}.wonderDraft'),
      '旧记录仍然存在',
    );
  });
});
