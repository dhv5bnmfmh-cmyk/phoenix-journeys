import '../data/daily_journey_experience.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';
import '../services/journey_content_quality_auditor.dart';

typedef PhoenixJourneyContentResolver = JourneyLevelContent Function(
  DailyJourneyExperience experience,
  ChineseProficiencyProfile profile,
);

enum PhoenixJourneyReleaseStatus {
  approved,
  needsRevision,
  blocked,
}

enum PhoenixJourneyQualityDimension {
  narrative,
  discoveries,
  multilingualSupport,
  vocabulary,
  learningPrompts,
  levelFit,
}

enum PhoenixJourneyRecommendationPriority {
  improve,
  mustFix,
}

class PhoenixJourneyQualityRecommendation {
  const PhoenixJourneyQualityRecommendation({
    required this.code,
    required this.dimension,
    required this.priority,
    required this.title,
    required this.action,
  });

  final String code;
  final PhoenixJourneyQualityDimension dimension;
  final PhoenixJourneyRecommendationPriority priority;
  final String title;
  final String action;
}

class PhoenixJourneyContentQualityDecision {
  const PhoenixJourneyContentQualityDecision({
    required this.report,
    required this.status,
    required this.recommendations,
  });

  final JourneyContentQualityReport report;
  final PhoenixJourneyReleaseStatus status;
  final List<PhoenixJourneyQualityRecommendation> recommendations;

  int get score => report.score;

  bool get isPublishable => status == PhoenixJourneyReleaseStatus.approved;

  String get grade => switch (score) {
        >= 98 => 'S',
        >= 95 => 'A+',
        >= 90 => 'A',
        >= 80 => 'B',
        >= 70 => 'C',
        _ => 'D',
      };

  String get summary => switch (status) {
        PhoenixJourneyReleaseStatus.approved =>
          '内容品质通过，可进入发布流程。',
        PhoenixJourneyReleaseStatus.needsRevision =>
          '内容基本完整，但仍有可改善项目。',
        PhoenixJourneyReleaseStatus.blocked =>
          '发现关键品质问题，必须修正后才能发布。',
      };
}

class PhoenixJourneyContentQualityBatch {
  const PhoenixJourneyContentQualityBatch(this.decisions);

  final List<PhoenixJourneyContentQualityDecision> decisions;

  int get approvedCount => decisions
      .where((decision) => decision.status == PhoenixJourneyReleaseStatus.approved)
      .length;

  int get needsRevisionCount => decisions
      .where(
        (decision) =>
            decision.status == PhoenixJourneyReleaseStatus.needsRevision,
      )
      .length;

  int get blockedCount => decisions
      .where((decision) => decision.status == PhoenixJourneyReleaseStatus.blocked)
      .length;

  bool get canPublish =>
      decisions.isNotEmpty && blockedCount == 0 && needsRevisionCount == 0;

  int get minimumScore => decisions.isEmpty
      ? 0
      : decisions
          .map((decision) => decision.score)
          .reduce((left, right) => left < right ? left : right);
}

class PhoenixJourneyContentQualityAgent {
  const PhoenixJourneyContentQualityAgent();

  PhoenixJourneyContentQualityDecision inspect({
    required DailyJourneyExperience experience,
    required JourneyLevelContent content,
    required ChineseProficiencyProfile profile,
  }) {
    final report = auditJourneyContentQuality(
      experience,
      content,
      profile: profile,
    );
    final recommendations = report.issues
        .map(_recommendationFor)
        .toList(growable: false);

    final status = report.hasCriticalIssues
        ? PhoenixJourneyReleaseStatus.blocked
        : report.issues.isNotEmpty
            ? PhoenixJourneyReleaseStatus.needsRevision
            : PhoenixJourneyReleaseStatus.approved;

    return PhoenixJourneyContentQualityDecision(
      report: report,
      status: status,
      recommendations: recommendations,
    );
  }

  PhoenixJourneyContentQualityBatch inspectPublishedCatalog({
    required Iterable<DailyJourneyExperience> journeys,
    required Iterable<ChineseProficiencyProfile> profiles,
    required PhoenixJourneyContentResolver resolveContent,
  }) {
    final decisions = <PhoenixJourneyContentQualityDecision>[];
    for (final journey in journeys) {
      for (final profile in profiles) {
        decisions.add(
          inspect(
            experience: journey,
            content: resolveContent(journey, profile),
            profile: profile,
          ),
        );
      }
    }
    return PhoenixJourneyContentQualityBatch(
      List<PhoenixJourneyContentQualityDecision>.unmodifiable(decisions),
    );
  }

  PhoenixJourneyQualityRecommendation _recommendationFor(
    JourneyContentQualityIssue issue,
  ) {
    final priority = issue.severity == JourneyContentQualitySeverity.critical
        ? PhoenixJourneyRecommendationPriority.mustFix
        : PhoenixJourneyRecommendationPriority.improve;
    final code = issue.code;

    if (code == 'story-paragraph-shape' ||
        code == 'empty-story-paragraph' ||
        code.startsWith('dependent-paragraph-opening') ||
        code == 'opening-scene-lost' ||
        code == 'closing-meaning-lost') {
      return PhoenixJourneyQualityRecommendation(
        code: code,
        dimension: PhoenixJourneyQualityDimension.narrative,
        priority: priority,
        title: '修复故事结构',
        action: code.startsWith('dependent-paragraph-opening')
            ? '重新选择第二段开头，让新段落从完整主体或场景开始。'
            : '保留开场、发展、转折与收束，并按当前等级重新组织为一至两段。',
      );
    }

    if (code == 'story-annotation-count' ||
        code.startsWith('empty-story-annotation') ||
        code.startsWith('empty-discovery-annotation')) {
      return PhoenixJourneyQualityRecommendation(
        code: code,
        dimension: PhoenixJourneyQualityDimension.multilingualSupport,
        priority: priority,
        title: '补齐多语言对应',
        action: '逐段核对中文、拼音、越南语和英语，确保内容完整且顺序一致。',
      );
    }

    if (code == 'discovery-shape' ||
        code.startsWith('thin-discovery') ||
        code.startsWith('duplicate-discovery') ||
        code.startsWith('discovery-repeats-story')) {
      return PhoenixJourneyQualityRecommendation(
        code: code,
        dimension: PhoenixJourneyQualityDimension.discoveries,
        priority: priority,
        title: '提升发现价值',
        action: code.startsWith('discovery-repeats-story')
            ? '删除与故事重复的句子，补充历史背景、空间设计或文化意义。'
            : '让每条发现提供独立的新信息，并保持一至两条的批准结构。',
      );
    }

    if (code == 'duplicate-or-empty-vocabulary') {
      return PhoenixJourneyQualityRecommendation(
        code: code,
        dimension: PhoenixJourneyQualityDimension.vocabulary,
        priority: priority,
        title: '整理重点词汇',
        action: '移除空白或重复词条，并确认词汇确实出现在故事或发现中。',
      );
    }

    if (code == 'empty-learning-prompt' || code == 'duplicate-learning-prompt') {
      return PhoenixJourneyQualityRecommendation(
        code: code,
        dimension: PhoenixJourneyQualityDimension.learningPrompts,
        priority: priority,
        title: '区分学习任务',
        action: '让思考题检查理解，让表达题要求输出，两者不要询问同一件事。',
      );
    }

    return PhoenixJourneyQualityRecommendation(
      code: code,
      dimension: PhoenixJourneyQualityDimension.levelFit,
      priority: priority,
      title: '校正等级适配',
      action: '根据当前 HSK／TOCFL 等级重新检查长度、难度与学习负荷。',
    );
  }
}
