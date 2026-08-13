import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/summer_palace_cultural_discovery_levels.dart';

void main() {
  test('every Story event owns complete aligned CN Pinyin Vietnamese English', () {
    expect(summerPalaceN1SemanticEvents, hasLength(14));
    for (final event in summerPalaceN1SemanticEvents) {
      for (final value in <String>[
        event.coreChinese,
        event.corePinyin,
        event.coreVietnamese,
        event.coreEnglish,
        event.detailChinese,
        event.detailPinyin,
        event.detailVietnamese,
        event.detailEnglish,
      ]) {
        expect(value.trim(), isNotEmpty, reason: event.id.name);
      }
    }

    for (var level = 1; level <= 10; level += 1) {
      final content = summerPalaceN1LevelForPhoenixLevel(level);
      final chinese = content.storyParagraphs.join();
      final pinyin = content.storyAnnotations.map((entry) => entry.pinyin).join(' ');
      final vietnamese =
          content.storyAnnotations.map((entry) => entry.vietnamese).join(' ');
      final english =
          content.storyAnnotations.map((entry) => entry.english).join(' ');

      for (final event in summerPalaceN1SemanticEvents) {
        expect(chinese, contains(event.coreChinese),
            reason: 'Lv.$level CN ${event.id.name}');
        expect(pinyin, contains(event.corePinyin),
            reason: 'Lv.$level PY ${event.id.name}');
        expect(vietnamese, contains(event.coreVietnamese),
            reason: 'Lv.$level VI ${event.id.name}');
        expect(english, contains(event.coreEnglish),
            reason: 'Lv.$level EN ${event.id.name}');
        if (level >= event.detailFromLevel) {
          expect(chinese, contains(event.detailChinese));
          expect(pinyin, contains(event.detailPinyin));
          expect(vietnamese, contains(event.detailVietnamese));
          expect(english, contains(event.detailEnglish));
        }
      }
    }
  });

  test('Discovery depth matrix is exact multilingual sourced and non-padded', () {
    const expected = <int, int>{
      1: 2,
      2: 2,
      3: 2,
      4: 2,
      5: 3,
      6: 3,
      7: 3,
      8: 3,
      9: 3,
      10: 3,
    };
    for (var level = 1; level <= 10; level += 1) {
      final units = summerPalaceDiscoveryUnitsForLevel(level);
      expect(units, hasLength(expected[level]!));
      final texts = <String>{};
      final questions = <String>{};
      for (final unit in units) {
        expect(texts.add(unit.entry.text), isTrue,
            reason: 'Lv.$level duplicate text');
        expect(questions.add(unit.learnerQuestion), isTrue,
            reason: 'Lv.$level duplicate question');
        expect(unit.newFactOrConcept.trim(), isNotEmpty);
        expect(unit.sourceIds, isNotEmpty);
        expect(unit.whyDistinct.trim(), isNotEmpty);
        expect(unit.storyBridge.trim(), isNotEmpty);
        expect(unit.entry.text.trim(), isNotEmpty);
        expect(unit.entry.pinyin.trim(), isNotEmpty);
        expect(unit.entry.vietnamese.trim(), isNotEmpty);
        expect(unit.entry.english.trim(), isNotEmpty);
        expect(unit.entry.text, isNot(contains('许澄')));
        expect(unit.entry.text, isNot(contains('周岚')));
        expect(unit.entry.text, isNot(contains('旧照片')));
      }
    }
  });

  test('Story and Discovery form one cultural bridge without retelling plot', () {
    final story = summerPalaceN1LevelForPhoenixLevel(7).storyParagraphs.join();
    final discovery =
        summerPalaceDiscoveryEntriesForLevel(7).map((entry) => entry.text).join();
    for (final anchor in <String>['十七孔桥', '冬至', '桥洞', '西北']) {
      expect(story, contains(anchor));
      expect(discovery, contains(anchor));
    }
    for (final plot in <String>['许澄', '周岚', '旧照片', '先捡回照片', '校展']) {
      expect(discovery, isNot(contains(plot)));
    }
  });
}
