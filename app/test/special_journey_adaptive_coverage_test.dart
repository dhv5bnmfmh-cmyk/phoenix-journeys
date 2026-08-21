import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/special_journey_catalog.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const forbiddenGenericHeritageFiller = <String>[
    '建筑材料',
    '门窗修缮',
    '街道、气候',
    '保护遗产并不是把它冻结',
  ];

  test('Special catalog identity equals adaptive Special coverage exactly', () {
    final catalogIds = specialJourneyExperiences.map((item) => item.id).toSet();
    expect(specialAdaptiveJourneyIds, catalogIds);
    expect(specialAdaptiveJourneyIds, hasLength(9));
  });

  for (final profile in levelAgent.allProfiles) {
    test('${profile.displayLabel} keeps every Special out of generic filler', () {
      for (final journey in specialJourneyExperiences) {
        final story = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        ).storyParagraphs.join();
        expect(story.trim(), isNotEmpty, reason: journey.id);
        expect(
          forbiddenGenericHeritageFiller.any(story.contains),
          isFalse,
          reason: '${journey.id} ${profile.displayLabel} used generic filler',
        );
      }
    });
  }

  test('expansion-batch Specials retain mechanism anchors at Lv10', () {
    final profile = levelAgent.profileForPhoenixLevel(10);
    const anchors = <String, List<String>>{
      'changan-last-bus': <String>['末班车', '铜镜', '车票', '归还'],
      'tide-letter': <String>['收音机', '潮', '母亲', '录音'],
      'arcade-lost-property': <String>['骑楼', '红伞', '失物', '认领'],
      'tea-horse-echo': <String>['茶马古道', '录音', '马帮', '支路'],
      'ice-city-star-map': <String>['旧厂', '星图', '工人', '待考'],
    };

    for (final journey in specialJourneyExperiences.where(
      (item) => anchors.containsKey(item.id),
    )) {
      final story = resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
      ).storyParagraphs.join();
      expect(
        anchors[journey.id]!.every(story.contains),
        isTrue,
        reason: '${journey.id} lost its Special mechanism at Lv10',
      );
    }
  });
}
