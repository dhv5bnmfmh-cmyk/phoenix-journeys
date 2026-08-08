import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/shanghai_bund_one_pass.dart';

void main() {
  const acceptedRanges = <int, (int, int)>{
    1: (100, 270),
    2: (150, 330),
    3: (210, 390),
    4: (270, 470),
    5: (330, 550),
    6: (400, 630),
    7: (470, 700),
    8: (530, 770),
    9: (600, 850),
    10: (670, 950),
  };

  test('Shanghai Story obeys Lv1-Lv10 length and paragraph policy', () {
    expect(shanghaiBundOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().length;
      final range = acceptedRanges[level]!;
      expect(characters, inInclusiveRange(range.$1, range.$2), reason: 'Lv$level length');
      expect(content.storyParagraphs.length, level <= 2 ? 1 : 2, reason: 'Lv$level paragraphs');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve one canonical Bund narrative DNA', () {
    final canonical = <String>[];
    for (var level = 1; level <= 10; level++) {
      final story = shanghaiBundOnePassLevels[level - 1].storyParagraphs.join();
      canonical.add(story);
      expect(story, contains('林岸'));
      expect(story, contains('母亲'));
      expect(story, contains('外滩'));
      expect(story, contains('陆家嘴'));
      expect(story, contains('提单'));
      expect(story, contains('轮渡'));
      expect(story, contains('江没有把上海分成过去和未来'));
      expect(story, isNot(contains('陆潮')));
      expect(story, isNot(contains('金融公开课')));
      expect(story, isNot(contains('九点半')));
      expect(story, isNot(contains('赞助动画')));
      expect(story, isNot(contains('直播断线')));
      expect(story, isNot(contains('沈砚')));
      expect(story, isNot(contains('旧木尺')));
      expect(story, isNot(contains('一道没有跨过的门槛')));
    }
    expect(canonical.join(), contains('黄浦江'));
  });

  test('location identity is irreducibly Shanghai and Huangpu-river based', () {
    final mastery = shanghaiBundOnePassLevels[9].storyParagraphs.join();
    for (final anchor in <String>['外滩', '黄浦江', '海关大楼', '金陵东路轮渡站', '东昌路', '浦东', '陆家嘴']) {
      expect(mastery, contains(anchor));
    }
    expect(mastery, contains('货船'));
    expect(mastery, contains('银行'));
    expect(mastery, contains('结算'));
    expect(mastery, contains('1843'));
    expect(mastery, contains('不平等条约'));
  });

  test('Words package has exact Story trace and first-appearance truth', () {
    final allStories = <String>[
      for (final level in shanghaiBundOnePassLevels) level.storyParagraphs.join(),
    ];
    expect(shanghaiBundOnePassWords, hasLength(shanghaiBundOnePassWordTraces.length));
    for (final word in shanghaiBundOnePassWords) {
      final trace = shanghaiBundOnePassWordTraces.firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(allStories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} source');
      final first = allStories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(first, shanghaiBundWordFirstAppears[word.word], reason: '${word.word} first appears');
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
    }
  });

  test('Discovery source bindings and Story Links are complete', () {
    final sourceIds = shanghaiBundOnePassSources.map((source) => source.id).toSet();
    final eventIds = shanghaiBundOnePassRemediation.eventIds.toSet();
    expect(shanghaiBundOnePassDiscoveries, hasLength(shanghaiBundOnePassDiscoveryTraces.length));
    for (final trace in shanghaiBundOnePassDiscoveryTraces) {
      expect(trace.storyEventIds, isNotEmpty);
      expect(trace.sourceIds, isNotEmpty);
      expect(trace.storyEventIds.every(eventIds.contains), isTrue);
      expect(trace.sourceIds.every(sourceIds.contains), isTrue);
    }
    expect(shanghaiBundOnePassDiscoveries.map((d) => d.text).join(), contains('不平等条约'));
    expect(shanghaiBundOnePassDiscoveries.map((d) => d.text).join(), contains('东金线'));
  });

  test('Challenge package uses only approved types and active Story anchors', () {
    expect(shanghaiBundOnePassChallenges.map((c) => c.type).toSet(),
        <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'});
    final stories = shanghaiBundOnePassLevels.map((l) => l.storyParagraphs.join()).toList();
    expect(stories.every((story) => story.contains('江没有把上海分成过去和未来')), isTrue);
    expect(shanghaiBundOnePassChallenges.firstWhere((c) => c.type == 'missingSentence').anchor,
        '江没有把上海分成过去和未来。');
    expect(shanghaiBundOnePassChallenges.map((c) => c.anchor).join(), isNot(contains('陆潮')));
    expect(shanghaiBundOnePassChallenges.map((c) => c.anchor).join(), isNot(contains('九点半')));
  });

  test('Memory and Complete cover the canonical journey without writing stages', () {
    expect(shanghaiBundOnePassMemory.map((m) => m.category).toSet(),
        containsAll(<String>{'protagonist', 'events', 'history', 'culture', 'architecture', 'vocabulary'}));
    final memory = shanghaiBundOnePassMemory.map((m) => m.answer).join();
    for (final anchor in <String>['林岸', '母亲', '黄浦江', '外滩', '海关大楼', '轮渡', '陆家嘴', '提单', '开埠']) {
      expect(memory, contains(anchor));
    }
    expect(shanghaiBundOnePassCompletion.journeySummary, contains('林岸'));
    expect(shanghaiBundOnePassCompletion.achievement, contains('双岸行者'));
    expect(shanghaiBundOnePassCompletion.memoryAnchor, '一张过江的旧提单');
    expect(shanghaiBundOnePassCompletion.challengeReward, contains('黄浦渡签'));
    expect(shanghaiBundOnePassCompletion.journeyCompletion, contains('过江之前'));
  });

  test('Shanghai package remains immutable-content compatible with shared runtime', () {
    final first = shanghaiBundOnePassRemediation.levelContent(5);
    final second = shanghaiBundOnePassRemediation.levelContent(5);
    expect(identical(first.storyParagraphs, second.storyParagraphs), isTrue);
    expect(identical(first.storyAnnotations, second.storyAnnotations), isTrue);
    expect(first.wonderQuestion, isEmpty);
    expect(first.expressQuestion, isEmpty);
  });
}
