import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/extended_journey_catalog.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
  track: ChineseExamTrack.hsk, levelCode: '$level', levelLabel: '$level',
  band: PhoenixReadingBand.intermediate, phoenixLevel: level,
);

void main() {
  final experience = extendedJourneyExperiences.singleWhere(
    (item) => item.id == guangzhouChenClanJourneyId,
  );

  test('Guangzhou exposes ten locked Not in Frame levels', () {
    expect(guangzhouChenClanCanonicalTitle, '不入镜');
    expect(guangzhouChenClanOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final story = guangzhouChenClanOnePassLevels[level - 1].storyParagraphs.join();
      expect(story, contains('陈秀仪'));
      expect(story, contains('刘嘉禾'));
      expect(story, contains('陈家祠'));
      expect(story, contains('不入镜'));
      expect(story, contains('并排'));
      expect(story, isNot(contains('纸桥')));
      expect(story, isNot(contains('梁遥')));
    }
  });

  test('runtime Lv1 Lv5 Lv10 equal canonical package', () {
    for (final level in <int>[1, 5, 10]) {
      final runtime = resolveAdaptiveJourneyLevel(
        experience,
        profile: profile(level),
      );
      final canonical = guangzhouChenClanOnePassLevelContent(level);
      expect(runtime.storyParagraphs, canonical.storyParagraphs);
      expect(runtime.discoveries, canonical.discoveries);
      expect(runtime.wonderQuestion, canonical.wonderQuestion);
      expect(runtime.expressQuestion, canonical.expressQuestion);
    }
  });

  test('Memory and Completion preserve the baseline generic product branch', () {
    expect(batchOneMemorySpecFor(guangzhouChenClanJourneyId), isNull);
  });

  test('knownWords filtering stays active on canonical Story vocabulary', () {
    final baseline = resolveAdaptiveJourneyLevel(experience, profile: profile(10));
    final known = baseline.words.first.word;
    final filtered = resolveAdaptiveJourneyLevel(
      experience,
      profile: profile(10),
      knownWords: <String>{known},
    );
    expect(filtered.words.map((entry) => entry.word), isNot(contains(known)));
    expect(filtered.storyParagraphs, baseline.storyParagraphs);
    expect(filtered.words.map((entry) => entry.word), isNot(contains('纸桥')));
  });

  test('Discovery remains factual and separate from plot', () {
    final discovery = guangzhouChenClanOnePassDiscoveries.map((e) => e.text).join();
    expect(discovery, contains('陈氏书院'));
    expect(discovery, contains('宗族'));
    expect(discovery, isNot(contains('陈秀仪')));
    expect(discovery, isNot(contains('刘嘉禾')));
    expect(discovery, isNot(contains('纸桥')));
  });
}
