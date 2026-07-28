import 'dart:convert';
import 'dart:io';

import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

const _qualityAgent = PhoenixJourneyContentQualityAgent();
const _languageAgent = PhoenixLanguageLevelAgent();

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
  final releaseStatus = batch.canPublish ? 'approved' : 'blocked';

  final jsonReport = <String, Object?>{
    'agent': 'PhoenixJourneyContentQualityAgent',
    'generatedAt': generatedAt.toIso8601String(),
    'releaseStatus': releaseStatus,
    'canPublish': batch.canPublish,
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
        if (!decision.isPublishable)
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
    releaseStatus: releaseStatus,
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
    'Phoenix quality report: $releaseStatus, '
    '${batch.approvedCount}/${decisions.length} approved, '
    'minimum ${batch.minimumScore}, average ${averageScore.toStringAsFixed(1)}.',
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
  required String releaseStatus,
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
    ..writeln('- 发布判定：`${releaseStatus.toUpperCase()}`')
    ..writeln('- 检查组合：`${batch.decisions.length}`')
    ..writeln('- 通过：`${batch.approvedCount}`')
    ..writeln('- 需要修改：`${batch.needsRevisionCount}`')
    ..writeln('- 禁止发布：`${batch.blockedCount}`')
    ..writeln('- 最低分：`${batch.minimumScore}`')
    ..writeln('- 平均分：`${averageScore.toStringAsFixed(1)}`')
    ..writeln()
    ..writeln('| 旅程 | 最低分 | 需修改等级 | 禁止发布等级 |')
    ..writeln('| --- | ---: | ---: | ---: |');

  for (final summary in journeySummaries) {
    buffer.writeln(
      '| `${summary['journeyId']}` | ${summary['minimumScore']} | '
      '${summary['needsRevisionProfiles']} | ${summary['blockedProfiles']} |',
    );
  }

  final findings = batch.decisions
      .where((decision) => !decision.isPublishable)
      .toList(growable: false);
  buffer
    ..writeln()
    ..writeln('## Agent 结论');

  if (findings.isEmpty) {
    buffer.writeln('所有普通旅程、特别旅程及 Phoenix Lv.1–10 均通过，允许进入发布流程。');
    return buffer.toString();
  }

  buffer.writeln('以下内容必须修正后才能发布：');
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
