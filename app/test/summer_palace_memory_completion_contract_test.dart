import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';

String _memoryText(BatchOneJourneyMemorySpec spec) => <String>[
      spec.storyResult,
      spec.culturalPoint,
      ...spec.reviews.expand((review) => <String>[review.prompt, review.answer]),
      spec.longTermAnchor,
      spec.completionSummary,
    ].join('\n');

void main() {
  test('Summer Palace resolves Journey-specific Memory and Completion', () {
    final spec = batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 7);
    expect(spec, isNotNull);
    expect(spec!.reviews.map((review) => review.category),
        containsAll(<String>['choice', 'relationship', 'place', 'memory']));
    expect(spec.storyResult, contains('十七孔桥'));
    expect(spec.storyResult, contains('放下相机'));
    expect(spec.storyResult, contains('旧照片'));
    expect(spec.storyResult, contains('《留下痕迹的风景》'));
    final memoryText = _memoryText(spec);
    expect(memoryText, contains('周岚'));
    expect(memoryText, contains('许澄'));
    expect(memoryText, contains('下一次'));
    expect(memoryText, contains('现有史料'));
    expect(memoryText, isNot(contains('两条路线')));
    expect(memoryText, isNot(contains('乾清门')));
    expect(memoryText, isNot(contains('中轴')));
  });

  test('Memory and Completion follow CURRENT LEVEL without future-level leakage', () {
    const expectedByLevel = <int, String>{
      1: '万寿山与昆明湖',
      2: '政治行政',
      3: '一八八六年开始',
      4: '长廊位于',
      5: '玉泉山',
      6: '东接东堤',
      7: '现有史料没有证明',
      8: '园林系统',
      9: '多重连接',
      10: '一九九八年列入',
    };
    final progressiveClosures = <String>{};
    for (var level = 1; level <= 10; level += 1) {
      final spec = batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: level)!;
      final memoryText = _memoryText(spec);
      expect(memoryText, contains(expectedByLevel[level]), reason: 'Lv.$level');
      final place = spec.reviews.singleWhere((item) => item.category == 'place');
      progressiveClosures.add('${spec.culturalPoint}\n${place.answer}\n${spec.completionSummary}');
    }
    expect(progressiveClosures, hasLength(10));

    final lv1 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 1)!);
    final lv2 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 2)!);
    final lv3 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 3)!);
    final lv4 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 4)!);
    final lv6 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 6)!);
    final lv7 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 7)!);
    final lv10 = _memoryText(batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 10)!);
    for (final lowLevel in <String>[lv1, lv2]) {
      expect(lowLevel, isNot(contains('一八六〇年')));
      expect(lowLevel, isNot(contains('一八八六年')));
      expect(lowLevel, isNot(contains('长廊')));
    }
    expect(lv3, contains('一七五〇年'));
    expect(lv3, contains('一八六〇年'));
    expect(lv3, contains('一八八六年开始'));
    expect(lv3, isNot(contains('长廊')));
    expect(lv4, contains('长廊'));
    expect(lv4, isNot(contains('玉泉山')));
    expect(lv6, contains('东堤'));
    expect(lv6, isNot(contains('现有史料没有证明')));
    expect(lv7, contains('现有史料没有证明'));
    expect(lv7, isNot(contains('一九九八年')));
    expect(lv10, contains('一九九八年'));
  });

  test('implicit Summer Palace resolver reads global current Phoenix level', () {
    final controller = PhoenixLevelController.instance;
    final originalLevel = controller.level;
    addTearDown(() => controller.setLevel(originalLevel));
    controller.setLevel(2);
    final lv2 = batchOneMemorySpecFor('beijing-summer-palace')!;
    expect(_memoryText(lv2), contains('政治行政'));
    expect(_memoryText(lv2), isNot(contains('一八八六年')));
    controller.setLevel(3);
    final lv3 = batchOneMemorySpecFor('beijing-summer-palace')!;
    expect(_memoryText(lv3), contains('一八八六年开始'));
  });

  test('Summer Palace Memory preserves enacted choice, cost, and relationship', () {
    final spec = batchOneMemorySpecFor('beijing-summer-palace', phoenixLevel: 7)!;
    final choice = spec.reviews.singleWhere((review) => review.category == 'choice');
    final relationship = spec.reviews.singleWhere((review) => review.category == 'relationship');
    final place = spec.reviews.singleWhere((review) => review.category == 'place');
    expect(choice.answer, contains('放下相机'));
    expect(choice.answer, contains('错过'));
    expect(choice.storyEventIds, contains('enactedChoice'));
    expect(choice.storyEventIds, contains('lostLight'));
    expect(relationship.answer, contains('不再替许澄调构图'));
    expect(relationship.answer, contains('旧照片'));
    expect(relationship.storyEventIds, contains('trustChange'));
    expect(relationship.storyEventIds, contains('photographEntrusted'));
    expect(place.answer, contains('十七孔桥'));
    expect(place.answer, contains('冬至前后'));
    expect(place.answer, contains('现有史料'));
  });
}
