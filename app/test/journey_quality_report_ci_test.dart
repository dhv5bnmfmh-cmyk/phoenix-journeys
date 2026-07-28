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
    expect(report['agent'], 'PhoenixJourneyContentQualityAgent');
    expect(report['inspectionCount'], greaterThan(0));
    expect(report['canPublish'], isTrue);
    expect(report['needsRevisionCount'], 0);
    expect(report['blockedCount'], 0);
  });
}
