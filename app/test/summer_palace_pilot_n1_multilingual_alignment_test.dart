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

  test('core Reading Support exactly follows the shortened Chinese event contract', () {
    const expectedPinyin = <SummerPalaceN1EventId, String>{
      SummerPalaceN1EventId.protagonist:
          'Dōngzhì qián, Xǔ Chéng dài xiàngjī dào Yíhéyuán.',
      SummerPalaceN1EventId.schoolExhibitionGoal:
          'Tā yào wèi xiàozhǎn pāi yì zhāng “wúxiá” zhàopiàn.',
      SummerPalaceN1EventId.independenceMotive:
          'Tā xiǎng zhèngmíng bú kào wàipó Zhōu Lán xuǎn gòutú.',
      SummerPalaceN1EventId.grandmotherConservationBackground:
          'Zhōu Lán zuò guò yuánlín xiūfù, dàizhe jiù zhàopiàn.',
      SummerPalaceN1EventId.valuesConflict:
          'Xǔ Chéng bìkāi jiù hénjì, Zhōu Lán yào tā duō kàn yì yǎn.',
      SummerPalaceN1EventId.photographFalls:
          'Shíqīkǒng Qiáo xīběi cè, qiáodòng liàng qǐ shí, jiù zhàopiàn bèi fēng chuīluò.',
      SummerPalaceN1EventId.forcedChoice:
          'Tā bìxū zài àn kuàimén hé jiǎn zhàopiàn zhījiān xuǎnzé.',
      SummerPalaceN1EventId.enactedChoice:
          'Xǔ Chéng fàngxià xiàngjī, xiān jiǎn huí zhàopiàn.',
      SummerPalaceN1EventId.lostLight:
          'Tā zài jǔ jī shí, qiáodòng jīnguāng yǐ yídòng, děng le yí xiàwǔ de huàmiàn méi le.',
      SummerPalaceN1EventId.threeLayerComposition:
          'Tā gǎi pāi jiù zhàopiàn, wàipó de shǒu hé àn xià de qiáodòng.',
      SummerPalaceN1EventId.workTitle:
          'Zuòpǐn jiào “Liúxià Hénjì de Fēngjǐng”.',
      SummerPalaceN1EventId.trustChange:
          'Zhōu Lán kàn wán, bú zài tì tā tiáo gòutú.',
      SummerPalaceN1EventId.photographEntrusted:
          'Tā bǎ jiù zhàopiàn jiāogěi Xǔ Chéng bǎocún.',
      SummerPalaceN1EventId.changedUnderstanding:
          'Xǔ Chéng bǎ xīn jiù zhàopiàn fàngjìn xiàngjī bāo.',
    };

    for (final event in summerPalaceN1SemanticEvents) {
      expect(event.corePinyin, expectedPinyin[event.id], reason: event.id.name);
    }

    final byId = <SummerPalaceN1EventId, SummerPalaceN1SemanticEvent>{
      for (final event in summerPalaceN1SemanticEvents) event.id: event,
    };

    expect(
      byId[SummerPalaceN1EventId.protagonist]!.coreVietnamese,
      'Trước Đông chí, Hứa Trừng mang máy ảnh đến Di Hòa Viên.',
    );
    expect(
      byId[SummerPalaceN1EventId.protagonist]!.coreEnglish,
      'Before the winter solstice, Xu Cheng brings a camera to the Summer Palace.',
    );
    expect(
      byId[SummerPalaceN1EventId.schoolExhibitionGoal]!.coreVietnamese,
      'Cô muốn chụp một bức ảnh “không tì vết” cho triển lãm trường.',
    );
    expect(
      byId[SummerPalaceN1EventId.schoolExhibitionGoal]!.coreEnglish,
      'She wants to take a “flawless” photograph for a school exhibition.',
    );
    expect(
      byId[SummerPalaceN1EventId.independenceMotive]!.detailPinyin,
      'Zhōu Lán zhǐ wèn tā wèishénme zhàn zhèlǐ, wèishénme děng zhège shíkè, Xǔ Chéng bǎ měi gè wèntí dōu tīng chéng gānshè.',
    );
    expect(
      byId[SummerPalaceN1EventId.independenceMotive]!.detailVietnamese,
      'Chu Lam chỉ hỏi vì sao cô đứng ở đây và vì sao chờ đúng lúc này; Hứa Trừng nghe mỗi câu hỏi như một sự can thiệp.',
    );
    expect(
      byId[SummerPalaceN1EventId.independenceMotive]!.detailEnglish,
      'Zhou Lan only asks why she stands here and why she waits for this moment, but Xu Cheng hears every question as interference.',
    );
    expect(
      byId[SummerPalaceN1EventId.photographEntrusted]!.detailVietnamese,
      'Chu Lam cho bức ảnh cũ vào một túi trong suốt rồi đặt vào tay Hứa Trừng: “Tấm này cũng giao cho con giữ.”',
    );
    expect(
      byId[SummerPalaceN1EventId.changedUnderstanding]!.coreVietnamese,
      'Hứa Trừng đặt ảnh mới và ảnh cũ vào túi máy ảnh.',
    );
    expect(
      byId[SummerPalaceN1EventId.changedUnderstanding]!.coreEnglish,
      'Xu Cheng places the new and old photographs in her camera bag.',
    );
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
