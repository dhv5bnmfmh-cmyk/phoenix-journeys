import 'dart:convert';
import 'dart:io';

import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/special_journey_catalog.dart';

const _qualityAgent = PhoenixJourneyContentQualityAgent();
const _languageAgent = PhoenixLanguageLevelAgent();

const _pendingHumanReview = 'pending-human-review';
const _pendingFounderReview = 'pending-founder-review';

Future<void> main(List<String> arguments) async {
  final markdownPath = _argumentValue(
    arguments,
    '--markdown',
    fallback: 'build/reports/journey-content-quality.md',
  );
  final jsonPath = _argumentValue(
    arguments,
    '--json',
    fallback: 'build/reports/journey-content-quality.json',
  );

  final generatedAt = DateTime.now().toUtc();
  final profiles = _languageAgent.allProfiles;
  final batch = _qualityAgent.inspectPublishedCatalog(
    journeys: allJourneyExperiences,
    profiles: profiles,
    resolveContent: (journey, profile) => resolveAdaptiveJourneyLevel(
      journey,
      profile: profile,
    ),
  );

  final decisions = batch.decisions;
  final averageScore = decisions.isEmpty
      ? 0.0
      : decisions.fold<int>(0, (total, item) => total + item.score) /
          decisions.length;
  final journeySummaries = _summariesByJourney(decisions);
  final automatedGateStatus = batch.automatedGatePass ? 'pass' : 'blocked';
  final canEnterHumanReview = batch.automatedGatePass;

  final jsonReport = <String, Object?>{
    'agent': 'PhoenixJourneyContentQualityAgent',
    'generatedAt': generatedAt.toIso8601String(),
    'automatedGateStatus': automatedGateStatus,
    'canEnterHumanReview': canEnterHumanReview,
    'agentSemanticSufficiencyStatus': _pendingHumanReview,
    'agentLiteraryReviewStatus': _pendingHumanReview,
    'humanNarrativeAntiTemplateStatus': _pendingHumanReview,
    'founderStoryApprovalStatus': _pendingFounderReview,
    'overallStoryQualityStatus': _pendingHumanReview,
    'automatedScoreUsedAsLiteraryApproval': false,
    // Legacy field retained for existing consumers. Its scope is machine-only.
    'canPublish': batch.canPublish,
    'canPublishScope': 'automated-content-contract-only',
    'journeyCount': allJourneyExperiences.length,
    'regularJourneyCount': dailyJourneyExperiences.length,
    'specialJourneyCount': specialJourneyExperiences.length,
    'profileCount': profiles.length,
    'inspectionCount': decisions.length,
    'approvedCount': batch.approvedCount,
    'needsRevisionCount': batch.needsRevisionCount,
    'blockedCount': batch.blockedCount,
    'minimumScore': batch.minimumScore,
    'averageScore': double.parse(averageScore.toStringAsFixed(2)),
    'journeys': journeySummaries,
    'findings': [
      for (final decision in decisions)
        if (!decision.passesAutomatedContentGate)
          <String, Object?>{
            'journeyId': decision.report.journeyId,
            'profile': decision.report.profile.displayLabel,
            'status': decision.status.name,
            'score': decision.score,
            'grade': decision.grade,
            'issues': [
              for (final issue in decision.report.issues)
                <String, Object?>{
                  'code': issue.code,
                  'severity': issue.severity.name,
                  'message': issue.message,
                },
            ],
            'recommendations': [
              for (final recommendation in decision.recommendations)
                <String, Object?>{
                  'code': recommendation.code,
                  'dimension': recommendation.dimension.name,
                  'priority': recommendation.priority.name,
                  'title': recommendation.title,
                  'action': recommendation.action,
                },
            ],
          },
    ],
  };

  final markdownReport = _buildMarkdown(
    generatedAt: generatedAt,
    automatedGateStatus: automatedGateStatus,
    batch: batch,
    averageScore: averageScore,
    journeySummaries: journeySummaries,
  );

  await _writeText(
    jsonPath,
    const JsonEncoder.withIndent('  ').convert(jsonReport),
  );
  await _writeText(markdownPath, markdownReport);

  stdout.writeln(
    'Phoenix automated content gate: $automatedGateStatus, '
    '${batch.approvedCount}/${decisions.length} automated checks passed, '
    'minimum ${batch.minimumScore}, average ${averageScore.toStringAsFixed(1)}.',
  );
  stdout.writeln(
    'Human narrative/literary review: PENDING. '
    'Automated results do not grant Story Quality or Gold approval.',
  );
  stdout.writeln('Markdown: $markdownPath');
  stdout.writeln('JSON: $jsonPath');
}

List<Map<String, Object?>> _summariesByJourney(
  List<PhoenixJourneyContentQualityDecision> decisions,
) {
  final grouped = <String, List<PhoenixJourneyContentQualityDecision>>{};
  for (final decision in decisions) {
    grouped
        .putIfAbsent(decision.report.journeyId, () => [])
        .add(decision);
  }

  final summaries = <Map<String, Object?>>[];
  for (final entry in grouped.entries) {
    final values = entry.value;
    final minimumScore = values
        .map((item) => item.score)
        .reduce((left, right) => left < right ? left : right);
    final blocked = values
        .where((item) => item.status == PhoenixJourneyReleaseStatus.blocked)
        .length;
    final needsRevision = values
        .where(
          (item) => item.status == PhoenixJourneyReleaseStatus.needsRevision,
        )
        .length;
    summaries.add(<String, Object?>{
      'journeyId': entry.key,
      'minimumScore': minimumScore,
      'blockedProfiles': blocked,
      'needsRevisionProfiles': needsRevision,
      'profileCount': values.length,
    });
  }
  summaries.sort(
    (left, right) => (left['journeyId']! as String)
        .compareTo(right['journeyId']! as String),
  );
  return summaries;
}

String _buildMarkdown({
  required DateTime generatedAt,
  required String automatedGateStatus,
  required PhoenixJourneyContentQualityBatch batch,
  required double averageScore,
  required List<Map<String, Object?>> journeySummaries,
}) {
  final buffer = StringBuffer()
    ..writeln('<!-- phoenix-content-quality-agent-report -->')
    ..writeln('# Phoenix 全旅程内容品质报告')
    ..writeln()
    ..writeln('- Agent：`PhoenixJourneyContentQualityAgent`')
    ..writeln('- 等级体系：`Phoenix Lv.1–10`')
    ..writeln('- 普通旅程：`${dailyJourneyExperiences.length}`')
    ..writeln('- 特别旅程：`${specialJourneyExperiences.length}`')
    ..writeln('- 旅程总数：`${allJourneyExperiences.length}`')
    ..writeln('- 生成时间：`${generatedAt.toIso8601String()}`')
    ..writeln('- 自动内容门禁：`${automatedGateStatus.toUpperCase()}`')
    ..writeln('- Agent 语义充分性审核：`PENDING`')
    ..writeln('- Agent 文学品质审核：`PENDING`')
    ..writeln('- Human Narrative Anti-Template：`PENDING`')
    ..writeln('- Founder Story Approval：`PENDING`')
    ..writeln('- Overall Story Quality：`PENDING`')
    ..writeln('- Automated score used as literary approval：`NO`')
    ..writeln('- 检查组合：`${batch.decisions.length}`')
    ..writeln('- 自动通过：`${batch.approvedCount}`')
    ..writeln('- 需要修改：`${batch.needsRevisionCount}`')
    ..writeln('- 自动阻塞：`${batch.blockedCount}`')
    ..writeln('- 最低分：`${batch.minimumScore}`')
    ..writeln('- 平均分：`${averageScore.toStringAsFixed(1)}`')
    ..writeln()
    ..writeln(
      '> 自动门禁 PASS 仅表示可进入 Agent / human / Founder Story 审核。'
      '它不构成文学品质、Human Anti-Template、Gold 或 Founder 批准。',
    )
    ..writeln()
    ..writeln('| 旅程 | 最低分 | 需修改等级 | 自动阻塞等级 |')
    ..writeln('| --- | ---: | ---: | ---: |');

  for (final summary in journeySummaries) {
    buffer.writeln(
      '| `${summary['journeyId']}` | ${summary['minimumScore']} | '
      '${summary['needsRevisionProfiles']} | ${summary['blockedProfiles']} |',
    );
  }

  final findings = batch.decisions
      .where((decision) => !decision.passesAutomatedContentGate)
      .toList(growable: false);
  buffer
    ..writeln()
    ..writeln('## Agent 自动检查结论');

  if (findings.isEmpty) {
    buffer.writeln(
      '所有普通旅程、特别旅程及 Phoenix Lv.1–10 的自动内容契约均通过。'
      '当前结果仅允许进入人工语义充分性、文学品质、Human Anti-Template 与 Founder 审核；'
      '不得据此宣称 `NARRATIVE_QUALITY = PASS`、`STORY QUALITY = PASS` 或 `GOLD READY`。',
    );
    return buffer.toString();
  }

  buffer.writeln('以下自动内容契约必须修正后才能进入后续人工审核：');
  for (final decision in findings.take(50)) {
    buffer
      ..writeln()
      ..writeln(
        '### `${decision.report.journeyId}` · '
        '${decision.report.profile.displayLabel} · '
        '${decision.status.name} · ${decision.score}/${decision.grade}',
      );
    for (final recommendation in decision.recommendations) {
      buffer.writeln(
        '- **${recommendation.title}**：${recommendation.action} '
        '`${recommendation.code}`',
      );
    }
  }
  if (findings.length > 50) {
    buffer.writeln('\n另有 ${findings.length - 50} 项请查看 JSON 报告。');
  }
  return buffer.toString();
}

String _argumentValue(
  List<String> arguments,
  String name, {
  required String fallback,
}) {
  final prefix = '$name=';
  for (final argument in arguments) {
    if (argument.startsWith(prefix)) return argument.substring(prefix.length);
  }
  return fallback;
}

Future<void> _writeText(String path, String content) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString('$content\n');
}
