import '../data/forbidden_city_challenge_package.dart';
import '../data/forbidden_city_journey_runtime.dart';
import '../data/forbidden_city_trace_validation.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';
import 'journey_content_quality_auditor.dart';

JourneyContentQualityReport auditForbiddenCityLockedQuality(
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  final issues = <JourneyContentQualityIssue>[];
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final story = forbiddenCityLockedStories[level - 1];

  void critical(String code, String message) {
    issues.add(
      JourneyContentQualityIssue(
        code: code,
        message: message,
        severity: JourneyContentQualitySeverity.critical,
      ),
    );
  }

  if (content.storyParagraphs.length != 1 ||
      content.storyParagraphs.first != story) {
    critical(
      'forbidden-city-runtime-binding',
      'Forbidden City must bind the exact locked Story for Phoenix Lv.$level.',
    );
  }

  if (story.trim().isEmpty || !story.contains('沈砚')) {
    critical(
      'forbidden-city-story-identity',
      'Locked Forbidden City Story must preserve Shen Yan as protagonist.',
    );
  }

  final traceRecords = forbiddenCityTraceRecordsForLevel(level);
  final traceByWord = <String, ForbiddenCityWordRecord>{
    for (final record in traceRecords) record.entry.word: record,
  };
  for (final word in content.words) {
    final record = traceByWord[word.word];
    if (record == null ||
        !forbiddenCityWordTraceIsValid(record) ||
        !story.contains(word.word) ||
        !record.storySource.contains(word.word)) {
      critical(
        'forbidden-city-word-trace-${word.word}',
        'Word ${word.word} must trace verbatim to its authoritative Story source and correct First Appears At level.',
      );
    }
  }

  if (content.words.isEmpty) {
    critical(
      'forbidden-city-empty-words',
      'Forbidden City must expose Story-grounded vocabulary.',
    );
  }

  if (content.discoveries.isEmpty || content.discoveries.length > 2) {
    critical(
      'forbidden-city-discovery-shape',
      'Forbidden City must expose one or two level-appropriate discoveries.',
    );
  }
  final discoveryTexts = forbiddenCityDiscoveries.map((entry) => entry.text).toSet();
  for (final discovery in content.discoveries) {
    if (!discoveryTexts.contains(discovery.text)) {
      critical(
        'forbidden-city-discovery-trace',
        'Forbidden City Discovery must derive from its reviewed discovery catalog.',
      );
    }
  }

  final rebuild = forbiddenCityParagraphRebuild[level - 1];
  if (rebuild.level != level ||
      rebuild.segments.any((segment) => !story.contains(segment))) {
    critical(
      'forbidden-city-paragraph-rebuild-trace',
      'Paragraph rebuild must use verbatim segments from the selected Story.',
    );
  }

  final grammar = forbiddenCityGrammarRepair[level - 1];
  if (grammar.level != level || !story.contains(grammar.correct)) {
    critical(
      'forbidden-city-grammar-repair-trace',
      'Grammar repair answer must be grounded verbatim in the selected Story.',
    );
  }

  final missing = forbiddenCityMissingSentence[level - 1];
  if (missing.level != level ||
      !story.contains(missing.before) ||
      !story.contains(missing.answer) ||
      !story.contains(missing.after)) {
    critical(
      'forbidden-city-missing-sentence-trace',
      'Missing-sentence challenge must use an actual Story sentence and context.',
    );
  }

  if (forbiddenCityMemoryReviews.length < 4 ||
      forbiddenCityMemoryAnchor.trim().isEmpty) {
    critical(
      'forbidden-city-memory',
      'Forbidden City Memory must retain its reviewed recall set and anchor.',
    );
  }

  if (forbiddenCityJourneySummary.trim().isEmpty ||
      forbiddenCityAchievementName.trim().isEmpty ||
      forbiddenCityChallengeRewardName.trim().isEmpty) {
    critical(
      'forbidden-city-complete',
      'Forbidden City Complete must retain summary and achievement metadata.',
    );
  }

  if (content.wonderQuestion.isNotEmpty || content.expressQuestion.isNotEmpty) {
    critical(
      'forbidden-city-retired-stages',
      'Reflection and Writing prompts must remain absent from the six-stage Journey.',
    );
  }

  return JourneyContentQualityReport(
    journeyId: forbiddenCityJourneyId,
    profile: profile,
    issues: List<JourneyContentQualityIssue>.unmodifiable(issues),
  );
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 9,
      PhoenixReadingBand.mastery => 10,
    };
