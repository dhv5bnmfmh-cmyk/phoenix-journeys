import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/summer_palace_journey.dart';
import 'package:phoenix_journeys/models/story_content.dart';

void main() {
  test('published Summer Palace shell uses the same active cultural Story', () {
    final active = summerPalaceN1LevelForPhoenixLevel(8);
    expect(summerPalaceStoryParagraphs, active.storyParagraphs);
    expect(
      summerPalaceStoryAnnotations
          .map((entry) => (entry.pinyin, entry.vietnamese, entry.english))
          .toList(),
      active.storyAnnotations
          .map((entry) => (entry.pinyin, entry.vietnamese, entry.english))
          .toList(),
    );
    expect(summerPalaceStoryParagraphs, hasLength(2));
    expect(
      summerPalaceStoryParagraphs.join().runes.length,
      inInclusiveRange(600, 760),
    );
  });

  test('Pilot identity preserves human bones while making place causal', () {
    expect(summerPalacePilotPhaseId, 'PILOT_N1');
    expect(
      summerPalacePilotPrimaryFinding,
      'CULTURAL_PLACE_CAUSALITY_MISSING',
    );
    expect(summerPalacePilotProtagonist, '许澄');
    expect(summerPalacePilotRelationship, contains('周岚'));
    expect(summerPalacePilotGoal, contains('校展'));
    expect(summerPalacePilotConflict, contains('十七孔桥'));
    expect(summerPalacePilotChoice, contains('旧照片'));
    expect(summerPalacePilotConsequence, contains('金光'));
    expect(summerPalaceStoryFunctionContract, contains('地点机制'));
    expect(summerPalaceDiscoveryFunctionContract, contains('不复述'));
  });

  test('official source records cover Story and Discovery cultural mechanisms', () {
    final ids = summerPalaceStorySources.map((source) => source.id).toSet();
    expect(
      ids,
      containsAll(<String>{
        'unesco-summer-palace-880',
        'beijing-parks-summer-palace-overview',
        'beijing-parks-seventeen-arch-bridge',
        'beijing-parks-seventeen-arch-winter-light',
      }),
    );
    for (final source in summerPalaceStorySources) {
      expect(source.verificationStatus, StoryVerificationStatus.verified);
    }
  });

  test('static Discovery is compact factual and plot-free', () {
    expect(summerPalaceDiscoveries, hasLength(2));
    final text = summerPalaceDiscoveries.map((item) => item.text).join();
    expect(text, contains('十七孔桥'));
    expect(text, contains('冬至'));
    expect(text, isNot(contains('许澄')));
    expect(text, isNot(contains('周岚')));
    for (final item in summerPalaceDiscoveries) {
      expect(item.pinyin.trim(), isNotEmpty);
      expect(item.vietnamese.trim(), isNotEmpty);
      expect(item.english.trim(), isNotEmpty);
    }
  });

  test('Entry copy names the active causal mechanism rather than generic lesson', () {
    expect(summerPalaceJourneyExperience.description, contains('十七孔桥'));
    expect(summerPalaceJourneyExperience.description, contains('旧照片'));
    expect(summerPalaceJourneyExperience.discoveryTeaser, contains('季节光线'));
  });
}
