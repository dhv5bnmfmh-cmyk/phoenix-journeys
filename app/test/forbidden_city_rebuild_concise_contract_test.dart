import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';

void main() {
  const engine = JourneyChallengeEngine();
  const auditor = ChallengeAntiTemplateAuditor();
  const levelAgent = PhoenixLanguageLevelAgent();

  int hanCount(String value) =>
      RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

  test('Forbidden City Sentence Rebuild stays concise from Lv1 to Lv10', () {
    for (var level = 1; level <= 10; level += 1) {
      final profile = levelAgent.allProfiles.singleWhere(
        (item) => item.phoenixLevel == level,
      );
      final bundle = JourneyPreparationCoordinator.instance.prepareNow(
        journeyId: 'beijing-forbidden-city',
        profile: profile,
        scriptMode: 'simplified',
      );
      final set = engine.build(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: level,
        storyParagraphs: bundle.challengeSourceMaterial,
      );
      final rebuild = set.questions
          .where((question) => question.mode.name == 'sentenceRebuild')
          .toList(growable: false);

      expect(rebuild, hasLength(4), reason: 'Lv$level');
      for (final question in rebuild) {
        expect(
          hanCount(question.answer),
          10,
          reason: 'Lv$level ${question.id} must remain a phone-sized knowledge sentence',
        );
        expect(
          question.characterTiles.toSet(),
          hasLength(question.characterTiles.length),
          reason: 'Lv$level ${question.id} should not duplicate semantic tiles',
        );
        expect(
          question.characterTiles.fold<int>(
            0,
            (total, tile) => total + hanCount(tile),
          ),
          10,
          reason: 'Lv$level ${question.id} tiles must cover the whole answer',
        );
        expect(
          const <String>[
            '紫禁城',
            '午门',
            '中轴',
            '乾清门',
            '故宫博物院',
          ].any(question.answer.contains),
          isTrue,
          reason: 'Lv$level ${question.id} must remain Forbidden City grounded',
        );
        if (level >= 7) {
          expect(
            question.characterTiles.length,
            greaterThanOrEqualTo(4),
            reason: 'Lv$level keeps concise wording without making the rebuild trivial',
          );
        }
      }

      expect(
        auditor.audit(set).passed,
        isTrue,
        reason: 'Lv$level must preserve the existing challenge quality gate',
      );
    }
  });
}
