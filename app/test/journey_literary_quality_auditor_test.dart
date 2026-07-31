import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_editorial_revisions.dart';
import 'package:phoenix_journeys/services/journey_literary_quality_auditor.dart';

void main() {
  test('every published journey has one formal editorial revision', () {
    expect(
      editorialStoryRevisions.keys.toSet(),
      allJourneyExperiences.map((journey) => journey.id).toSet(),
    );
    expect(editorialStoryRevisions, hasLength(41));
  });

  test('formal story library has no severe or medium literary issues', () {
    final report = auditJourneyLiteraryQuality(editorialStoryRevisions);

    expect(
      report.hasSevereIssues,
      isFalse,
      reason: report.issues
          .where((issue) => issue.severity == LiteraryIssueSeverity.severe)
          .map((issue) => '${issue.code}: ${issue.message}')
          .join('\n'),
    );
    expect(
      report.hasMediumIssues,
      isFalse,
      reason: report.issues
          .where((issue) => issue.severity == LiteraryIssueSeverity.medium)
          .map((issue) => '${issue.code}: ${issue.message}')
          .join('\n'),
    );
    expect(report.score, greaterThanOrEqualTo(98));
    expect(report.genericOpeningCount, lessThanOrEqualTo(4));
    expect(report.conservationEndingCount, lessThanOrEqualTo(6));
    expect(report.dialogueStoryCount, greaterThanOrEqualTo(29));
    expect(report.maxPairSimilarity, lessThanOrEqualTo(.42));
  });

  test('applied stories keep four aligned multilingual sections', () {
    for (final journey in allJourneyExperiences) {
      expect(
        journey.content.sections,
        hasLength(4),
        reason: '${journey.id} must keep four editorial sections',
      );
      expect(
        journey.storyAnnotations,
        hasLength(4),
        reason: '${journey.id} must keep four aligned annotations',
      );
      expect(
        journey.wonderQuestion.trim(),
        isNotEmpty,
        reason: '${journey.id} must keep a learning question',
      );
      expect(
        journey.expressQuestion.trim(),
        isNotEmpty,
        reason: '${journey.id} must keep an expression prompt',
      );
      for (final annotation in journey.storyAnnotations) {
        expect(annotation.pinyin.trim(), isNotEmpty);
        expect(annotation.vietnamese.trim(), isNotEmpty);
        expect(annotation.english.trim(), isNotEmpty);
      }
    }
  });
}
