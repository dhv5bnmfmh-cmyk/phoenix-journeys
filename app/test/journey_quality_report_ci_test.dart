import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/generate_journey_quality_report.dart' as quality_report;

void main() {
  test('generates publishable PR evidence when explicitly enabled', () async {
    final enabled =
        Platform.environment['PHOENIX_GENERATE_QUALITY_REPORT'] == '1';
    if (!enabled) {
      expect(enabled, isFalse);
      return;
    }

    final markdownPath =
        Platform.environment['PHOENIX_QUALITY_MARKDOWN'] ??
            '../journey-quality-report.md';
    final jsonPath = Platform.environment['PHOENIX_QUALITY_JSON'] ??
        '../journey-quality-report.json';

    await quality_report.main(<String>[
      '--markdown=$markdownPath',
      '--json=$jsonPath',
    ]);

    final markdownFile = File(markdownPath);
    final jsonFile = File(jsonPath);
    expect(await markdownFile.exists(), isTrue);
    expect(await jsonFile.exists(), isTrue);

    final markdown = await markdownFile.readAsString();
    final report = jsonDecode(await jsonFile.readAsString())
        as Map<String, dynamic>;

    expect(markdown, contains('Phoenix 全旅程内容品质报告'));
    expect(markdown, contains('特别旅程：`9`'));
    expect(markdown, contains('自动内容门禁：`PASS`'));
    expect(markdown, contains('Agent 文学品质审核：`PENDING`'));
    expect(markdown, contains('Human Narrative Anti-Template：`PENDING`'));
    expect(markdown, contains('Founder Story Approval：`PENDING`'));
    expect(markdown, contains('Automated score used as literary approval：`NO`'));
    expect(
      markdown,
      contains('不得据此宣称 `NARRATIVE_QUALITY = PASS`'),
    );

    expect(report['agent'], 'PhoenixJourneyContentQualityAgent');
    expect(report['journeyCount'], 36);
    expect(report['regularJourneyCount'], 27);
    expect(report['specialJourneyCount'], 9);
    expect(report['profileCount'], 10);
    expect(report['inspectionCount'], 360);
    expect(report['automatedGateStatus'], 'pass');
    expect(report['canEnterHumanReview'], isTrue);
    expect(report['agentSemanticSufficiencyStatus'], 'pending-human-review');
    expect(report['agentLiteraryReviewStatus'], 'pending-human-review');
    expect(report['humanNarrativeAntiTemplateStatus'], 'pending-human-review');
    expect(report['founderStoryApprovalStatus'], 'pending-founder-review');
    expect(report['overallStoryQualityStatus'], 'pending-human-review');
    expect(report['automatedScoreUsedAsLiteraryApproval'], isFalse);
    expect(report['canPublish'], isTrue);
    expect(report['canPublishScope'], 'automated-content-contract-only');
    expect(report['approvedCount'], 360);
    expect(report['needsRevisionCount'], 0);
    expect(report['blockedCount'], 0);
  }, timeout: const Timeout(Duration(minutes: 3)));
}
