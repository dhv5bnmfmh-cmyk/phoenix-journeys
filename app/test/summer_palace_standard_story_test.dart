import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_journey.dart';

void main() {
  test('Summer Palace uses two balanced long story paragraphs', () {
    expect(summerPalaceStoryParagraphs, hasLength(2));
    expect(summerPalaceStoryAnnotations, hasLength(2));
    for (final paragraph in summerPalaceStoryParagraphs) {
      expect(paragraph.length, inInclusiveRange(260, 380));
    }
    expect(
      summerPalaceStoryParagraphs.join().length,
      inInclusiveRange(600, 760),
    );
  });

  test('Pilot N1 declares causal narrative identity', () {
    expect(summerPalacePilotPhaseId, 'PILOT_N1');
    expect(
      summerPalacePilotPrimaryFinding,
      'PROTAGONIST_IDENTITY_MISSING',
    );
    expect(summerPalacePilotProtagonist, '许澄');
    expect(summerPalacePilotRelationship, contains('周岚'));
    expect(summerPalacePilotGoal, contains('校展'));
    expect(summerPalacePilotConflict, contains('选择'));
    expect(summerPalacePilotChoice, contains('旧照片'));
    expect(summerPalacePilotConsequence, contains('留下痕迹的风景'));
    expect(summerPalaceStoryFunctionContract, contains('冲突、选择与后果'));
    expect(summerPalaceDiscoveryFunctionContract, contains('不复述'));
  });

  test('Story enacts choice and caused consequence without tourist opening', () {
    final story = summerPalaceStoryParagraphs.join();
    expect(summerPalaceStoryParagraphs.first, isNot(startsWith('清晨，你')));
    expect(story, contains('许澄'));
    expect(story, contains('周岚'));
    expect(story, contains('必须选择'));
    expect(story, contains('先捡回照片'));
    expect(story, contains('明信片式的画面消失'));
    expect(story, contains('《留下痕迹的风景》'));
    expect(story, contains('只把旧照片交给她保存'));
  });

  test('Story annotations preserve all supported language evidence', () {
    for (final annotation in summerPalaceStoryAnnotations) {
      expect(annotation.pinyin.trim(), isNotEmpty);
      expect(annotation.vietnamese.trim(), isNotEmpty);
      expect(annotation.english.trim(), isNotEmpty);
    }
  });

  test('Discovery is factual and functionally separate from the character plot',
      () {
    expect(summerPalaceDiscoveries, hasLength(2));
    final discovery = summerPalaceDiscoveries.map((item) => item.text).join();
    for (final item in summerPalaceDiscoveries) {
      expect(item.text.length, inInclusiveRange(240, 340));
      expect(item.pinyin.trim(), isNotEmpty);
      expect(item.vietnamese.trim(), isNotEmpty);
      expect(item.english.trim(), isNotEmpty);
    }
    expect(discovery, contains('借景'));
    expect(discovery, contains('对景'));
    expect(discovery, contains('修复'));
    expect(discovery, isNot(contains('许澄')));
    expect(discovery, isNot(contains('周岚')));
    expect(discovery, isNot(contains('旧照片')));
  });
}
