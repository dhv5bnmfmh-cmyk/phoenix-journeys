import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/services/journey_content_quality_auditor.dart';

void main() {
  const qualityAgent = PhoenixJourneyContentQualityAgent();
  const levelAgent = PhoenixLanguageLevelAgent();

  test('quality agent approves every published journey and profile', () {
    final batch = qualityAgent.inspectPublishedCatalog(
      journeys: dailyJourneyExperiences,
      profiles: levelAgent.allProfiles,
      resolveContent: (journey, profile) => resolveAdaptiveJourneyLevel(
        journey,
        profile: profile,
      ),
    );

    expect(batch.decisions, isNotEmpty);
    expect(batch.blockedCount, 0);
    expect(batch.needsRevisionCount, 0);
    expect(batch.approvedCount, batch.decisions.length);
    expect(batch.minimumScore, greaterThanOrEqualTo(90));
    expect(batch.canPublish, isTrue);
  });

  test('quality similarity keeps punctuation-normalized bigram semantics', () {
    expect(
      chineseContentSimilarity('城墙，永宁门。', '城墙永宁门'),
      1,
    );
    expect(
      chineseContentSimilarity('城墙永宁门', '完全不同'),
      0,
    );
  });

  test('quality agent blocks repeated discovery content and explains the fix', () {
    final journey = dailyJourneyExperiences.firstWhere(
      (item) => item.id != forbiddenCityJourneyId,
    );
    final profile = levelAgent.allProfiles.first;
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );
    final repeated = DiscoveryEntry(
      text: content.storyParagraphs.join(),
      pinyin: 'Chóngfù de nèiróng.',
      simpleChinese: content.storyParagraphs.join(),
      vietnamese: 'Nội dung bị lặp lại.',
      english: 'Repeated content.',
    );
    final broken = JourneyLevelContent(
      storyParagraphs: content.storyParagraphs,
      storyAnnotations: content.storyAnnotations,
      words: content.words,
      discoveries: <DiscoveryEntry>[repeated],
      wonderQuestion: content.wonderQuestion,
      expressQuestion: content.expressQuestion,
    );

    final decision = qualityAgent.inspect(
      experience: journey,
      content: broken,
      profile: profile,
    );

    expect(decision.status, PhoenixJourneyReleaseStatus.blocked);
    expect(decision.isPublishable, isFalse);
    expect(decision.summary, contains('必须修正'));
    expect(
      decision.recommendations.any(
        (item) =>
            item.dimension == PhoenixJourneyQualityDimension.discoveries &&
            item.priority == PhoenixJourneyRecommendationPriority.mustFix &&
            item.action.contains('历史背景'),
      ),
      isTrue,
    );
  });

  test('quality agent converts warnings into revision decisions', () {
    final journey = dailyJourneyExperiences.firstWhere(
      (item) =>
          item.id != forbiddenCityJourneyId &&
          item.id != 'beijing-summer-palace',
    );
    final profile = levelAgent.allProfiles.first;
    final content = resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    );
    const thinDiscovery = DiscoveryEntry(
      text: '新信息。',
      pinyin: 'Xīn xìnxī.',
      simpleChinese: '新信息。',
      vietnamese: 'Thông tin mới.',
      english: 'New information.',
    );
    final needsWork = JourneyLevelContent(
      storyParagraphs: content.storyParagraphs,
      storyAnnotations: content.storyAnnotations,
      words: content.words,
      discoveries: const <DiscoveryEntry>[thinDiscovery],
      wonderQuestion: content.wonderQuestion,
      expressQuestion: content.expressQuestion,
    );

    final decision = qualityAgent.inspect(
      experience: journey,
      content: needsWork,
      profile: profile,
    );

    expect(decision.status, PhoenixJourneyReleaseStatus.needsRevision);
    expect(decision.isPublishable, isFalse);
    expect(decision.grade, anyOf('A+', 'A'));
    expect(
      decision.recommendations.single.priority,
      PhoenixJourneyRecommendationPriority.improve,
    );
  });
}
