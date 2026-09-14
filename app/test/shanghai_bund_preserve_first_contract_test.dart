import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/shanghai_bund_level_support.dart';
import 'package:phoenix_journeys/data/shanghai_bund_one_pass.dart';

String pinyinFor(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  test('Shanghai reading support follows current level and paragraph identity',
      () {
    final fingerprints = <String>{};
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassLevels[level - 1];
      expect(shanghaiBundLevelForParagraphs(content.storyParagraphs), level);
      expect(
          content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (var index = 0; index < content.storyParagraphs.length; index++) {
        final paragraph = content.storyParagraphs[index];
        final support =
            shanghaiBundReadingAnnotationFor(level, index, paragraph);
        expect(support.pinyin, pinyinFor(paragraph),
            reason: 'Lv$level paragraph ${index + 1} Pinyin');
        expect(support.vietnamese.trim(), isNotEmpty);
        expect(support.english.trim(), isNotEmpty);
        if (paragraph.contains('提单')) {
          expect(support.vietnamese.toLowerCase(), contains('vận đơn'));
          expect(support.english.toLowerCase(), contains('bill'));
        }
        if (paragraph.contains('轮渡')) {
          expect(support.vietnamese.toLowerCase(), contains('phà'));
          expect(support.english.toLowerCase(), contains('ferry'));
        }
        if (paragraph.contains('1843')) {
          expect(support.vietnamese, contains('1843'));
          expect(support.english, contains('1843'));
        }
        fingerprints.add('${support.vietnamese}|${support.english}');
      }
    }
    expect(fingerprints, hasLength(18));
  });

  test('Shanghai vocabulary separates word gloss from sentence support', () {
    for (final word in shanghaiBundOnePassWords) {
      final trace = shanghaiBundOnePassWordTraces
          .firstWhere((entry) => entry.word == word.word);
      expect(word.examples, hasLength(3), reason: word.word);
      expect(word.examples.first.chinese, trace.sourceText);
      expect(word.examples.first.chinese, contains(word.word));
      expect(word.examples.first.pinyin, pinyinFor(trace.sourceText));
      expect(word.examples.first.vietnamese.trim(), isNotEmpty);
      expect(word.examples.first.english.trim(), isNotEmpty);
      expect(word.examples.first.vietnamese, isNot(word.translation));
      expect(word.examples.first.english, isNot(word.englishDefinition));
      for (final example in word.examples) {
        expect(example.pinyin, pinyinFor(example.chinese));
      }
    }
  });

  test('Shanghai Discovery is current-level and preserves time boundaries', () {
    final expected = <int, List<String>>{
      1: <String>['黄浦江西岸'],
      2: <String>['东金线'],
      3: <String>['海运提单', '黄浦江西岸'],
      4: <String>['1927', '东金线'],
      5: <String>['陆家嘴', '海运提单'],
      6: <String>['1927', '1843'],
      7: <String>['长期发展', '1927'],
      8: <String>['海运提单', '1990'],
      9: <String>['1990', '陆家嘴'],
      10: <String>['1843', '1990'],
    };
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassLevelContent(level);
      final joined = content.discoveries.map((entry) => entry.text).join('|');
      for (final anchor in expected[level]!) {
        expect(joined, contains(anchor), reason: 'Lv$level $anchor');
      }
      if (level < 4) expect(joined, isNot(contains('1927')));
      if (level < 6) {
        expect(joined, isNot(contains('1843')));
        expect(joined, isNot(contains('不平等条约')));
      }
      if (level < 8) expect(joined, isNot(contains('1990')));
      expect(content.discoveries.length, level <= 2 ? 1 : 2);
    }
  });

  test('Shanghai Memory and Completion stay inside current level', () {
    final closures = <String>{};
    for (var level = 1; level <= 10; level++) {
      final spec = batchOneMemorySpecFor(
        shanghaiBundJourneyId,
        phoenixLevel: level,
      )!;
      final joined =
          '${spec.storyResult}|${spec.culturalPoint}|${spec.completionSummary}|${spec.reviews.map((e) => e.answer).join('|')}';
      closures.add('${spec.culturalPoint}|${spec.completionSummary}');
      expect(spec.reviews.map((entry) => entry.category).toSet(),
          containsAll(<String>{'choice', 'relationship', 'place', 'memory'}));
      expect(spec.storyResult, contains('林岸'));
      expect(spec.longTermAnchor, '一张过江的旧提单');
      if (level < 3) expect(joined, isNot(contains('纸船')));
      if (level < 4) expect(joined, isNot(contains('1927')));
      if (level < 6) {
        expect(joined, isNot(contains('1843')));
        expect(joined, isNot(contains('不平等条约')));
      }
      if (level < 8) expect(joined, isNot(contains('1990')));
    }
    expect(closures, hasLength(10));
  });

  test('Shanghai popup and support questions follow current level', () {
    expect(shanghaiBundWonderQuestionForLevel(1), isNot(contains('1843')));
    expect(shanghaiBundExpressQuestionForLevel(1), isNot(contains('结算')));
    expect(shanghaiBundExpressQuestionForLevel(1), contains('轮渡'));
    expect(shanghaiBundExpressQuestionForLevel(4), contains('结算'));
    expect(shanghaiBundWonderQuestionForLevel(6), contains('历史时间层次'));
  });

  test('Shanghai Fact Pack uses authoritative legal and time provenance', () {
    final bill = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-port-trade-document-context',
    );
    expect(bill.publisher, contains('全国人民代表大会'));
    expect(bill.scope, contains('海上货物运输合同'));
    expect(bill.scope, contains('交付货物'));

    final customs = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-gov-customs-house-1927',
    );
    expect(customs.publisher, contains('上海市人民政府'));
    expect(customs.scope, contains('1927'));

    final lujiazui = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-gov-pudong-lujiazui-development',
    );
    expect(lujiazui.publisher, contains('浦东新区人民政府'));
    expect(lujiazui.scope, contains('1990'));
  });

  test('Shanghai keeps its independent narrative engine', () {
    final story = shanghaiBundOnePassLevels
        .map((level) => level.storyParagraphs.join())
        .join();
    for (final anchor in <String>[
      '林岸',
      '母亲',
      '旧海运提单',
      '黄浦江',
      '轮渡',
      '外滩',
      '陆家嘴',
    ]) {
      expect(story, contains(anchor));
    }
    for (final term in <String>['中轴观察', '东侧记录', '错误路线', '标准路线']) {
      expect(story, isNot(contains(term)));
    }
    for (final term in <String>['许澄', '周岚', '校展', '金光画面', '旧照片被风吹落']) {
      expect(story, isNot(contains(term)));
    }
  });
}
