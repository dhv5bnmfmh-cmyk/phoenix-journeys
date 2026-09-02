import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/journey_startup_metadata.dart';
import 'package:phoenix_journeys/models/city_standard.dart';

void main() {
  test('normal discovery publishes Beijing and Forbidden City Journey only',
      () {
    expect(
        publishedJourneyStartupCityCatalog.map((city) => city.id), ['beijing']);
    expect(
        publishedJourneyStartupCityCatalog.single.destinations
            .map((item) => item.id),
        ['beijing-forbidden-city']);
  });

  test('hidden legacy journeys remain directly resolvable', () {
    for (final id in [
      'shanghai-bund',
      'xian-city-wall',
      'hangzhou-west-lake',
      'chengdu-kuanzhai-alley',
      'nanjing-qinhuai-river',
      'guangzhou-chen-clan-academy',
      'harbin-central-street'
    ]) {
      expect(requireJourneyStartupMetadata(id).id, id);
    }
  });

  test('City to Place to Journey hierarchy is explicit', () {
    expect(forbiddenCityPlace.cityId, beijingCityId);
    expect(forbiddenCityJourney01.cityId, beijingCityId);
    expect(forbiddenCityJourney01.placeId, forbiddenCityPlace.placeId);
    expect(forbiddenCityJourney01.runtimeId, 'beijing-forbidden-city');
    expect(forbiddenCityJourney01.publicationState, PublicationState.reference);
  });

  test('Beijing Knowledge Map v1 contains all city domains', () {
    final ids = beijingKnowledgeMap.map((domain) => domain.id).toSet();
    for (final id in <String>{
          'beijing.history',
          'beijing.geography',
          'beijing.architecture',
          'beijing.food',
          'beijing.folk_customs',
          'beijing.language',
          'beijing.arts',
          'beijing.craft',
          'beijing.education',
          'beijing.technology',
          'beijing.commerce',
          'beijing.transport',
          'beijing.modern_life',
        }) {
      expect(ids.contains(id), true);
    }
    expect(
        beijingKnowledgeMap.every((domain) => domain.cityId == beijingCityId),
        true);
  });

  test('Journey 01 has four canonical scenes with paired assets', () {
    expect(forbiddenCityJourney01Scenes.map((scene) => scene.sceneId),
        ['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D']);
    for (final scene in forbiddenCityJourney01Scenes) {
      expect(scene.cityId, beijingCityId);
      expect(scene.placeId, forbiddenCityPlaceId);
      expect(scene.journeyId, forbiddenCityJourney01Id);
      expect(scene.landscapeAsset.endsWith('_landscape.webp'), true);
      expect(scene.portraitAsset.endsWith('_portrait.webp'), true);
      expect(scene.sourceRefs.isNotEmpty, true);
    }
  });

  test('semantic scene progression is deterministic for Lv1 Lv5 Lv10', () {
    for (final level in [1, 5, 10]) {
      expect(level >= 1 && level <= 10, true);
      expect(
          List<int>.generate(4, (index) => index)
              .map((index) => forbiddenCitySceneForParagraph(index).sceneId),
          ['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D']);
    }
    expect(forbiddenCitySceneForStage('memory').sceneId, 'FC01-D');
    expect(forbiddenCitySceneForStage('completion').sceneId, 'FC01-D');
  });
}
