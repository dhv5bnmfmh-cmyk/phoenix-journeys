import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/quanzhou_kaiyuan_gold_content.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  test('Founder repair keeps one dedicated Quanzhou source and closes both review defects', () {
    final matches = dailyJourneyExperiences
        .where((journey) => journey.id == quanzhouKaiyuanJourneyId)
        .toList(growable: false);
    expect(matches, hasLength(1));
    expect(usesDedicatedAdaptiveJourneyRuntime(quanzhouKaiyuanJourneyId), isTrue);

    final quanzhou = matches.single;
    final lv1 = resolveAdaptiveJourneyLevel(
      quanzhou,
      profile: agent.profileForPhoenixLevel(1),
    );
    final lv5 = resolveAdaptiveJourneyLevel(
      quanzhou,
      profile: agent.profileForPhoenixLevel(5),
    );

    final lv1Story = lv1.storyParagraphs.join();
    final lv5Story = lv5.storyParagraphs.join();

    expect(lv1Story, contains('旧宅也在西街'));
    expect(lv1Story, contains('沿街走到甘露戒坛前'));
    expect(
      quanzhouPlaceCausalMechanism['VERIFIED_PLACE_PROPERTY'],
      contains('西街'),
    );
    expect(
      quanzhouPlaceCausalMechanism['GENERIC_PLACE_SUBSTITUTION'],
      startsWith('PASS'),
    );

    expect(lv5Story, contains('你又不是走得回不来'));
    expect(lv5Story, isNot(contains('戒坛始建于1019年')));
    expect(lv5Story, isNot(contains('官方资料还记录')));
    expect(lv5.discoveries.any((item) => item.text.contains('1019年')), isTrue);
    expect(
      lv5.discoveries.any((item) => item.text.contains('西街中段北侧')),
      isTrue,
    );
  });
}
