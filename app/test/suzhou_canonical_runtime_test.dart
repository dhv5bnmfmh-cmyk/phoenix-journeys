import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
  track: ChineseExamTrack.hsk, levelCode: '$level', levelLabel: '$level',
  band: PhoenixReadingBand.intermediate, phoenixLevel: level,
);

void main() {
  final experience = dailyJourneyExperiences.singleWhere(
    (item) => item.id == 'suzhou-humble-administrators-garden',
  );

  test('runtime Lv1 Lv5 Lv10 equal locked Next Place package', () {
    for (final level in <int>[1, 5, 10]) {
      final runtime = resolveAdaptiveJourneyLevel(
        experience,
        profile: profile(level),
      );
      final canonical = suzhouGardenCanonicalLevelContent(level);
      expect(runtime.storyParagraphs, canonical.storyParagraphs);
      expect(runtime.discoveries, canonical.discoveries);
      expect(runtime.wonderQuestion, canonical.wonderQuestion);
      expect(runtime.expressQuestion, canonical.expressQuestion);
    }
  });

  test('Memory and Completion preserve the baseline generic product branch', () {
    expect(batchOneMemorySpecFor(experience.id), isNull);
    expect(experience.discoveryTeaser, contains('视线'));
    expect(experience.discoveryTeaser, isNot(contains('喊他回来')));
  });

  test('knownWords keep baseline review semantics on locked vocabulary', () {
    final baseline = resolveAdaptiveJourneyLevel(experience, profile: profile(10));
    final known = <String>{'园林'};
    final reviewed = resolveAdaptiveJourneyLevel(
      experience,
      profile: profile(10),
      knownWords: known,
    );
    expect(reviewed.words.map((entry) => entry.word).toSet().intersection(known), isNotEmpty);
    expect(
      reviewed.words.map((entry) => entry.word).toList(),
      isNot(equals(baseline.words.map((entry) => entry.word).toList())),
    );
    expect(reviewed.words.length, lessThanOrEqualTo(20));
    expect(reviewed.storyParagraphs, baseline.storyParagraphs);
  });

  test('Lv1 Lv5 Lv10 Reading Support matches the locked Story facts', () {
    for (final level in <int>[1, 5, 10]) {
      final content = suzhouGardenCanonicalLevelContent(level);
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      final support = content.storyAnnotations
          .map((item) => '${item.pinyin} ${item.vietnamese} ${item.english}')
          .join(' ');
      for (final anchor in <String>[
        'Chen Yulan',
        'Cheng Lang',
        'calls',
        'does not call',
        'next place',
        'does not chase',
      ]) {
        expect(support, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(support, isNot(contains('does not look back')));
      expect(support, isNot(contains('never chase')));
    }
  });

  test('Lv10 ends at the Founder-approved final action', () {
    final story = suzhouGardenCanonicalLevelContent(10).storyParagraphs.join();
    expect(story, endsWith('程朗转过去，背影很快又被房屋挡住。陈玉兰没有追上去。'));
    expect(story, isNot(contains('我会担心，却不再每次都追上去')));
    expect(story, isNot(contains('没有加快脚步，也没有回头')));
  });
}
