import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_experience.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/models/story_content.dart';
import 'package:phoenix_journeys/services/journey_vocabulary_context.dart';

const _target = WordEntry(
  word: '中轴',
  pinyin: 'zhōngzhóu',
  simpleChinese: '贯穿中心的轴线。',
  translation: 'trục trung tâm',
  englishDefinition: 'central axis',
  symbol: '轴',
);

const _other = WordEntry(
  word: '宫门',
  pinyin: 'gōngmén',
  simpleChinese: '宫殿的门。',
  translation: 'cổng cung điện',
  englishDefinition: 'palace gate',
  symbol: '门',
);

DailyJourneyExperience _journey(
  String id, {
  required bool containsTarget,
  String? contextText,
}) {
  final text = contextText ?? (containsTarget ? '$id 的中轴语境。' : '$id 的普通语境。');
  return DailyJourneyExperience(
    id: id,
    city: '测试城',
    cityCode: 'TST',
    place: id,
    appBarTitle: id,
    storyTitle: id,
    headline: id,
    description: id,
    discoveryTeaser: id,
    distanceLabel: '0 km',
    stampSymbol: '测',
    content: JourneyContentRecord(
      id: id,
      title: id,
      geoNodeId: 'test-$id',
      languageCode: 'zh-CN',
      sections: [
        JourneyStorySection(id: 'story-0', text: text, sourceIds: const []),
      ],
      verificationStatus: StoryVerificationStatus.published,
    ),
    storyAnnotations: const [
      ReadingAnnotation(
        pinyin: 'test pinyin',
        vietnamese: 'test vietnamese',
        english: 'test english',
      ),
    ],
    words: [containsTarget ? _target : _other],
    discoveries: const [],
    wonderQuestion: '',
    expressQuestion: '',
  );
}

void main() {
  test('active Journey hit does not invoke unrelated lazy builders', () {
    var invoked = 0;
    final active = _journey(
      'active',
      containsTarget: true,
      contextText: 'active 中轴 context',
    );
    final lazyFallbacks = LazyJourneyList([
      () {
        invoked += 1;
        return _journey('fallback-1', containsTarget: false);
      },
      () {
        invoked += 1;
        return _journey('fallback-2', containsTarget: true);
      },
    ]);

    final result = findJourneyVocabularyContext(
      activeJourney: active,
      fallbackJourneys: lazyFallbacks,
      entry: _target,
    );

    expect(result.chinese, 'active 中轴 context');
    expect(result.pinyin, 'test pinyin');
    expect(invoked, 0);
  });

  test('early fallback hit invokes builders only through first match', () {
    final invoked = <String>[];
    final active = _journey('active', containsTarget: false);
    final lazyFallbacks = LazyJourneyList([
      () {
        invoked.add('first');
        return _journey('first', containsTarget: false);
      },
      () {
        invoked.add('match');
        return _journey(
          'match',
          containsTarget: true,
          contextText: 'fallback 中轴 context',
        );
      },
      () {
        invoked.add('after-match');
        return _journey('after-match', containsTarget: true);
      },
    ]);

    final result = findJourneyVocabularyContext(
      activeJourney: active,
      fallbackJourneys: lazyFallbacks,
      entry: _target,
    );

    expect(result.chinese, 'fallback 中轴 context');
    expect(invoked, ['first', 'match']);
  });

  test('no match is allowed to traverse the full lazy fallback list', () {
    final invoked = <String>[];
    final active = _journey('active', containsTarget: false);
    final lazyFallbacks = LazyJourneyList([
      for (final id in ['first', 'second', 'third'])
        () {
          invoked.add(id);
          return _journey(id, containsTarget: false);
        },
    ]);

    final result = findJourneyVocabularyContext(
      activeJourney: active,
      fallbackJourneys: lazyFallbacks,
      entry: _target,
    );

    expect(result.isEmpty, isTrue);
    expect(invoked, ['first', 'second', 'third']);
  });
}
