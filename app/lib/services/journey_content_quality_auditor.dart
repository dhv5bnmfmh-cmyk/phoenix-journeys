import '../data/daily_journey_experience.dart';
import '../data/dedicated_adaptive_journey_catalog.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';
import 'phoenix_story_length_policy.dart';

enum JourneyContentQualitySeverity { warning, critical }

class JourneyContentQualityIssue {
  const JourneyContentQualityIssue({
    required this.code,
    required this.message,
    required this.severity,
  });

  final String code;
  final String message;
  final JourneyContentQualitySeverity severity;
}

class JourneyContentQualityReport {
  const JourneyContentQualityReport({
    required this.journeyId,
    required this.profile,
    required this.issues,
  });

  final String journeyId;
  final ChineseProficiencyProfile profile;
  final List<JourneyContentQualityIssue> issues;

  bool get hasCriticalIssues => issues.any(
        (issue) => issue.severity == JourneyContentQualitySeverity.critical,
      );

  int get score {
    var value = 100;
    for (final issue in issues) {
      value -= issue.severity == JourneyContentQualitySeverity.critical ? 20 : 5;
    }
    return value.clamp(0, 100).toInt();
  }
}

final RegExp _dependentNarrativeOpeningPattern = RegExp(
  r'^(它|他|她|他们|她们|因此|于是|所以|然而|但是|但|同时|其中|此时|后来|随后|最后|而且|也|其(?!中))',
);
final RegExp _qualitySentencePattern = RegExp(r'[^。！？!?]+[。！？!?]?');
final RegExp _normalizeChinesePattern =
    RegExp(r'[\s，。！？!?、；;：:“”‘’（）()\-—…·]');

JourneyContentQualityReport auditJourneyContentQuality(
  DailyJourneyExperience experience,
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  final issues = <JourneyContentQualityIssue>[];
  final storyTarget = phoenixStoryLengthTargetFor(profile);
  final usesSharedGeneric = usesSharedGenericAdaptivePipeline(experience.id);
  final storyText = content.storyParagraphs.join();

  void add(
    String code,
    String message,
    JourneyContentQualitySeverity severity,
  ) {
    issues.add(
      JourneyContentQualityIssue(
        code: code,
        message: message,
        severity: severity,
      ),
    );
  }

  if (content.storyParagraphs.length != storyTarget.paragraphCount) {
    add(
      'story-paragraph-shape',
      'Story paragraph count does not match the selected Phoenix level.',
      JourneyContentQualitySeverity.critical,
    );
  }

  if (content.storyParagraphs.any((paragraph) => paragraph.trim().isEmpty)) {
    add(
      'empty-story-paragraph',
      'Story contains an empty paragraph.',
      JourneyContentQualitySeverity.critical,
    );
  }

  final storyCharacterCount = storyText.runes.length;
  if (storyCharacterCount < storyTarget.acceptedMinimumCharacters) {
    add(
      'story-below-level-range',
      'Story has $storyCharacterCount characters, below the Phoenix '
          '${profile.displayLabel} accepted minimum of ${storyTarget.acceptedMinimumCharacters} '
          '(target ${storyTarget.minimumCharacters}, approved tolerance ±${PhoenixStoryLengthTarget.approvedToleranceCharacters}).',
      JourneyContentQualitySeverity.critical,
    );
  }
  if (storyCharacterCount > storyTarget.acceptedMaximumCharacters) {
    add(
      'story-above-level-range',
      'Story has $storyCharacterCount characters, above the Phoenix '
          '${profile.displayLabel} accepted maximum of ${storyTarget.acceptedMaximumCharacters} '
          '(target ${storyTarget.maximumCharacters}, approved tolerance ±${PhoenixStoryLengthTarget.approvedToleranceCharacters}).',
      JourneyContentQualitySeverity.critical,
    );
  }

  if (content.storyAnnotations.length != content.storyParagraphs.length) {
    add(
      'story-annotation-count',
      'Story and multilingual annotation counts are not aligned.',
      JourneyContentQualitySeverity.critical,
    );
  }

  for (var index = 0; index < content.storyAnnotations.length; index += 1) {
    final annotation = content.storyAnnotations[index];
    if (annotation.pinyin.trim().isEmpty ||
        annotation.vietnamese.trim().isEmpty ||
        annotation.english.trim().isEmpty) {
      add(
        'empty-story-annotation-$index',
        'Story paragraph ${index + 1} is missing multilingual reading support.',
        JourneyContentQualitySeverity.critical,
      );
    }
  }

  // This lexical opening heuristic protects the shared generic shaper from
  // manufacturing a paragraph whose first token lost its antecedent while
  // slicing source prose. Dedicated Gold/candidate packages are authored as
  // whole level-specific passages, so a context-free token check cannot prove
  // that an opening pronoun is unresolved; their causal/semantic gates remain
  // authoritative instead of forcing Story prose to satisfy a brittle token.
  if (usesSharedGeneric) {
    for (var index = 1; index < content.storyParagraphs.length; index += 1) {
      if (startsWithDependentNarrativeReference(content.storyParagraphs[index])) {
        add(
          'dependent-paragraph-opening-$index',
          'Story paragraph ${index + 1} begins with an unresolved reference.',
          JourneyContentQualitySeverity.critical,
        );
      }
    }
  }

  if (usesSharedGeneric) {
    final sourceBoundary = _normalizedSentenceBoundary(
      experience.content.storyParagraphs.join(),
    );
    final shapedBoundary = _normalizedSentenceBoundary(storyText);
    if (sourceBoundary != null && shapedBoundary != null) {
      if (sourceBoundary.first != shapedBoundary.first) {
        add(
          'opening-scene-lost',
          'Adaptive shaping removed the original opening scene.',
          JourneyContentQualitySeverity.critical,
        );
      }
      if (sourceBoundary.last != shapedBoundary.last) {
        add(
          'closing-meaning-lost',
          'Adaptive shaping removed the original closing meaning.',
          JourneyContentQualitySeverity.critical,
        );
      }
    }
  }

  final phoenixLevel = profile.phoenixLevel;
  final levelSpecificGoldDiscoveryCount = phoenixLevel == null
      ? null
      : canonicalDiscoveryDepthForJourney(experience.id, phoenixLevel);
  final tooManyGenericDiscoveries = content.discoveries.length > 2;
  final invalidDiscoveryShape = levelSpecificGoldDiscoveryCount == null
      ? content.discoveries.isEmpty || tooManyGenericDiscoveries
      : content.discoveries.length != levelSpecificGoldDiscoveryCount;
  if (invalidDiscoveryShape) {
    add(
      'discovery-shape',
      levelSpecificGoldDiscoveryCount == null
          ? 'Discoveries must use the approved one- or two-entry shape.'
          : '${experience.id} must use exactly '
              '$levelSpecificGoldDiscoveryCount Discovery entries at '
              '${profile.displayLabel}.',
      JourneyContentQualitySeverity.critical,
    );
  }

  final storyPairs = content.discoveries.isEmpty
      ? const <int>{}
      : _chineseBigrams(storyText);
  final seenDiscoveries = <String>{};
  for (var index = 0; index < content.discoveries.length; index += 1) {
    final discovery = content.discoveries[index];
    final normalized = _normalizeChinese(discovery.text);

    if (normalized.length < 8) {
      add(
        'thin-discovery-$index',
        'Discovery ${index + 1} is too thin to add meaningful context.',
        JourneyContentQualitySeverity.warning,
      );
    }

    if (!seenDiscoveries.add(normalized)) {
      add(
        'duplicate-discovery-$index',
        'Discovery ${index + 1} duplicates an earlier discovery.',
        JourneyContentQualitySeverity.critical,
      );
    }

    if (_chineseContentSimilarityFromPairs(
          storyPairs,
          _chineseBigramsFromNormalized(normalized),
        ) >=
        .97) {
      add(
        'discovery-repeats-story-$index',
        'Discovery ${index + 1} repeats the story instead of adding context.',
        JourneyContentQualitySeverity.critical,
      );
    }

    if (discovery.pinyin.trim().isEmpty ||
        discovery.simpleChinese.trim().isEmpty ||
        discovery.vietnamese.trim().isEmpty ||
        discovery.english.trim().isEmpty) {
      add(
        'empty-discovery-annotation-$index',
        'Discovery ${index + 1} is missing multilingual support.',
        JourneyContentQualitySeverity.critical,
      );
    }
  }

  final vocabulary = <String>{};
  for (final word in content.words) {
    final normalized = word.word.trim();
    if (normalized.isEmpty || !vocabulary.add(normalized)) {
      add(
        'duplicate-or-empty-vocabulary',
        'Vocabulary contains an empty or duplicate entry.',
        JourneyContentQualitySeverity.warning,
      );
      break;
    }
  }

  if (content.wonderQuestion.trim().isEmpty ||
      content.expressQuestion.trim().isEmpty) {
    add(
      'empty-learning-prompt',
      'Reflection or writing prompt is empty.',
      JourneyContentQualitySeverity.critical,
    );
  }

  if (_normalizeChinese(content.wonderQuestion) ==
      _normalizeChinese(content.expressQuestion)) {
    add(
      'duplicate-learning-prompt',
      'Reflection and writing prompts ask the same thing.',
      JourneyContentQualitySeverity.warning,
    );
  }

  return JourneyContentQualityReport(
    journeyId: experience.id,
    profile: profile,
    issues: List<JourneyContentQualityIssue>.unmodifiable(issues),
  );
}

bool startsWithDependentNarrativeReference(String value) =>
    _dependentNarrativeOpeningPattern.hasMatch(value.trim());

List<String> splitChineseQualitySentences(String value) {
  final text = value.trim();
  if (text.isEmpty) return const <String>[];
  return _qualitySentencePattern
      .allMatches(text)
      .map((match) => match.group(0)?.trim() ?? '')
      .where((sentence) => sentence.isNotEmpty)
      .toList(growable: false);
}

({String first, String last})? _normalizedSentenceBoundary(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;

  String? first;
  String? last;
  for (final match in _qualitySentencePattern.allMatches(text)) {
    final sentence = match.group(0)?.trim() ?? '';
    if (sentence.isEmpty) continue;
    first ??= sentence;
    last = sentence;
  }
  if (first == null || last == null) return null;
  return (first: _normalizeChinese(first), last: _normalizeChinese(last));
}

double chineseContentSimilarity(String left, String right) =>
    _chineseContentSimilarityFromPairs(
      _chineseBigrams(left),
      _chineseBigrams(right),
    );

double _chineseContentSimilarityFromPairs(
  Set<int> leftPairs,
  Set<int> rightPairs,
) {
  if (leftPairs.isEmpty || rightPairs.isEmpty) return 0;

  final leftIsSmaller = leftPairs.length <= rightPairs.length;
  final smaller = leftIsSmaller ? leftPairs : rightPairs;
  final larger = leftIsSmaller ? rightPairs : leftPairs;
  var intersection = 0;
  for (final pair in smaller) {
    if (larger.contains(pair)) intersection += 1;
  }
  final union = leftPairs.length + rightPairs.length - intersection;
  return union == 0 ? 0 : intersection / union;
}

Set<int> _chineseBigrams(String value) =>
    _chineseBigramsFromNormalized(_normalizeChinese(value));

Set<int> _chineseBigramsFromNormalized(String normalized) {
  final runes = normalized.runes.iterator;
  if (!runes.moveNext()) return const <int>{};

  final first = runes.current;
  if (!runes.moveNext()) return <int>{-first - 1};

  const runeBase = 0x110000;
  final pairs = <int>{};
  var previous = first;
  do {
    final current = runes.current;
    pairs.add(previous * runeBase + current);
    previous = current;
  } while (runes.moveNext());
  return pairs;
}

String _normalizeChinese(String value) =>
    value.replaceAll(_normalizeChinesePattern, '').toLowerCase();
