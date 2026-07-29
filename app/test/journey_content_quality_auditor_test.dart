import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/services/journey_content_quality_auditor.dart';

void main() {
  const agent = PhoenixLanguageLevelAgent();

  for (final profile in agent.allProfiles) {
    test('${profile.displayLabel} passes the quality gate for every journey', () {
      for (final journey in dailyJourneyExperiences) {
        final content = resolveAdaptiveJourneyLevel(
          journey,
          profile: profile,
        );
        final report = auditJourneyContentQuality(
          journey,
          content,
          profile: profile,
        );

        expect(
          report.hasCriticalIssues,
          isFalse,
          reason: '${journey.id} / ${profile.displayLabel}: '
              '${report.issues.map((issue) => issue.code).join(', ')}',
        );
        expect(
          report.score,
          greaterThanOrEqualTo(90),
          reason: '${journey.id} / ${profile.displayLabel} should remain premium',
        );
      }
    });
  }

  test('detects a discovery that simply repeats the story', () {
    final journey = dailyJourneyExperiences.first;
    final profile = agent.allProfiles.first;
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );
    final duplicate = DiscoveryEntry(
      text: content.storyParagraphs.join(),
      pinyin: 'Duplicate pinyin.',
      simpleChinese: content.storyParagraphs.join(),
      vietnamese: 'Nội dung trùng lặp.',
      english: 'Duplicate content.',
    );
    final broken = JourneyLevelContent(
      storyParagraphs: content.storyParagraphs,
      storyAnnotations: content.storyAnnotations,
      words: content.words,
      discoveries: <DiscoveryEntry>[duplicate],
      wonderQuestion: content.wonderQuestion,
      expressQuestion: content.expressQuestion,
    );

    final report = auditJourneyContentQuality(
      journey,
      broken,
      profile: profile,
    );

    expect(
      report.issues.map((issue) => issue.code),
      contains('discovery-repeats-story-0'),
    );
    expect(report.hasCriticalIssues, isTrue);
  });

  test('detects an unresolved reference at the start of paragraph two', () {
    final journey = dailyJourneyExperiences.first;
    final profile = agent.allProfiles.firstWhere(
      (item) => agent.planFor(item).paragraphCount == 2,
    );
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );
    final broken = JourneyLevelContent(
      storyParagraphs: <String>[
        content.storyParagraphs.first,
        '因此，${content.storyParagraphs.last}',
      ],
      storyAnnotations: content.storyAnnotations,
      words: content.words,
      discoveries: content.discoveries,
      wonderQuestion: content.wonderQuestion,
      expressQuestion: content.expressQuestion,
    );

    final report = auditJourneyContentQuality(
      journey,
      broken,
      profile: profile,
    );

    expect(
      report.issues.map((issue) => issue.code),
      contains('dependent-paragraph-opening-1'),
    );
  });

  test('allows a paragraph to reopen the scene with a clear place anchor', () {
    expect(
      startsWithDependentNarrativeReference('这里曾经是皇帝处理国家事务的地方。'),
      isFalse,
    );
    expect(
      startsWithDependentNarrativeReference('因此，人们重新理解了这座宫殿。'),
      isTrue,
    );
  });

  test('Chinese similarity catches near-identical content', () {
    expect(
      chineseContentSimilarity(
        '十七孔桥连接湖岸和小岛。',
        '十七孔桥连接湖岸和小岛！',
      ),
      greaterThan(.95),
    );
    expect(
      chineseContentSimilarity(
        '十七孔桥连接湖岸和小岛。',
        '园林通过路线改变观看角度。',
      ),
      lessThan(.35),
    );
  });
}
