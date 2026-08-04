import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/summer_palace_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/summer_palace_journey.dart';

void main() {
  test('every N1 event owns aligned Chinese, pinyin, Vietnamese, and English',
      () {
    expect(
      summerPalaceN1SemanticEvents.map((event) => event.id),
      summerPalaceN1RequiredEventOrder,
    );
    expect(summerPalaceN1SemanticEvents, hasLength(14));

    for (final event in summerPalaceN1SemanticEvents) {
      expect(event.coreChinese.trim(), isNotEmpty, reason: event.id.name);
      expect(event.corePinyin.trim(), isNotEmpty, reason: event.id.name);
      expect(event.coreVietnamese.trim(), isNotEmpty, reason: event.id.name);
      expect(event.coreEnglish.trim(), isNotEmpty, reason: event.id.name);
      expect(event.detailChinese.trim(), isNotEmpty, reason: event.id.name);
      expect(event.detailPinyin.trim(), isNotEmpty, reason: event.id.name);
      expect(event.detailVietnamese.trim(), isNotEmpty, reason: event.id.name);
      expect(event.detailEnglish.trim(), isNotEmpty, reason: event.id.name);
    }
  });

  test('each effective level is assembled from the same multilingual event IDs',
      () {
    for (var level = 1; level <= 10; level += 1) {
      final content = summerPalaceN1LevelForPhoenixLevel(level);
      final chinese = content.storyParagraphs.join();
      final pinyin = content.storyAnnotations.map((entry) => entry.pinyin).join(' ');
      final vietnamese =
          content.storyAnnotations.map((entry) => entry.vietnamese).join(' ');
      final english =
          content.storyAnnotations.map((entry) => entry.english).join(' ');

      var chineseCursor = -1;
      var pinyinCursor = -1;
      var vietnameseCursor = -1;
      var englishCursor = -1;
      for (final event in summerPalaceN1SemanticEvents) {
        final nextChinese = chinese.indexOf(event.coreChinese, chineseCursor + 1);
        final nextPinyin = pinyin.indexOf(event.corePinyin, pinyinCursor + 1);
        final nextVietnamese =
            vietnamese.indexOf(event.coreVietnamese, vietnameseCursor + 1);
        final nextEnglish = english.indexOf(event.coreEnglish, englishCursor + 1);
        expect(nextChinese, greaterThan(chineseCursor),
            reason: 'Lv.$level Chinese ${event.id.name}');
        expect(nextPinyin, greaterThan(pinyinCursor),
            reason: 'Lv.$level pinyin ${event.id.name}');
        expect(nextVietnamese, greaterThan(vietnameseCursor),
            reason: 'Lv.$level Vietnamese ${event.id.name}');
        expect(nextEnglish, greaterThan(englishCursor),
            reason: 'Lv.$level English ${event.id.name}');
        chineseCursor = nextChinese;
        pinyinCursor = nextPinyin;
        vietnameseCursor = nextVietnamese;
        englishCursor = nextEnglish;
      }
    }
  });

  test('Standard Story preserves title, trust change, and handoff in all languages',
      () {
    final chinese = summerPalaceStoryParagraphs.join();
    final pinyin = summerPalaceStoryAnnotations.map((entry) => entry.pinyin).join(' ');
    final vietnamese =
        summerPalaceStoryAnnotations.map((entry) => entry.vietnamese).join(' ');
    final english =
        summerPalaceStoryAnnotations.map((entry) => entry.english).join(' ');

    expect(chinese, contains('《留下痕迹的风景》'));
    expect(chinese, contains('没有替她调整构图'));
    expect(chinese, contains('旧照片交给她保存'));

    expect(pinyin, contains('Liúxià Hénjì de Fēngjǐng'));
    expect(pinyin, contains('bù zài tì tā tiáozhěng gòutú'));
    expect(pinyin, contains('jiù zhàopiàn jiāogěi tā bǎocún'));

    expect(vietnamese, contains('Phong cảnh lưu lại dấu vết'));
    expect(vietnamese, contains('không còn chỉnh bố cục'));
    expect(vietnamese, contains('giao bức ảnh cũ'));

    expect(english, contains('A Landscape That Keeps Its Traces'));
    expect(english, contains('no longer adjusts the composition'));
    expect(english, contains('entrusts the old photograph'));
  });
}
