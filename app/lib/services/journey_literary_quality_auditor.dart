import '../data/editorial_story_revision_model.dart';
import 'journey_content_quality_auditor.dart';

enum LiteraryIssueSeverity { severe, medium, light }

class LiteraryQualityIssue {
  const LiteraryQualityIssue({
    required this.code,
    required this.severity,
    required this.message,
  });

  final String code;
  final LiteraryIssueSeverity severity;
  final String message;
}

class JourneyLiteraryQualityReport {
  const JourneyLiteraryQualityReport({
    required this.totalStories,
    required this.genericOpeningCount,
    required this.conservationEndingCount,
    required this.dialogueStoryCount,
    required this.maxPairSimilarity,
    required this.maxPair,
    required this.issues,
  });

  final int totalStories;
  final int genericOpeningCount;
  final int conservationEndingCount;
  final int dialogueStoryCount;
  final double maxPairSimilarity;
  final String maxPair;
  final List<LiteraryQualityIssue> issues;

  bool get hasSevereIssues =>
      issues.any((issue) => issue.severity == LiteraryIssueSeverity.severe);

  bool get hasMediumIssues =>
      issues.any((issue) => issue.severity == LiteraryIssueSeverity.medium);

  int get score {
    var result = 100;
    for (final issue in issues) {
      result -= switch (issue.severity) {
        LiteraryIssueSeverity.severe => 20,
        LiteraryIssueSeverity.medium => 8,
        LiteraryIssueSeverity.light => 2,
      };
    }
    return result.clamp(0, 100).toInt();
  }
}

JourneyLiteraryQualityReport auditJourneyLiteraryQuality(
  Map<String, EditorialStoryRevision> revisions, {
  int expectedStoryCount = 41,
}) {
  final issues = <LiteraryQualityIssue>[];
  final stories = revisions.values.toList(growable: false);

  if (stories.length != expectedStoryCount) {
    issues.add(LiteraryQualityIssue(
      code: 'story-library-count',
      severity: LiteraryIssueSeverity.severe,
      message: 'Expected $expectedStoryCount editorial stories, found ${stories.length}.',
    ));
  }

  for (final story in stories) {
    if (story.sections.length != 4 || story.annotations.length != 4) {
      issues.add(LiteraryQualityIssue(
        code: 'incomplete-editorial-package-${story.id}',
        severity: LiteraryIssueSeverity.severe,
        message: '${story.id} must contain four sections and four annotations.',
      ));
    }
    if (story.protagonist.trim().isEmpty ||
        story.narrativeMode.trim().isEmpty ||
        story.emotionalArc.trim().isEmpty ||
        story.endingMode.trim().isEmpty) {
      issues.add(LiteraryQualityIssue(
        code: 'missing-literary-identity-${story.id}',
        severity: LiteraryIssueSeverity.severe,
        message: '${story.id} is missing protagonist, mode, arc, or ending identity.',
      ));
    }
    if (!_openingEstablishesProtagonist(story)) {
      issues.add(LiteraryQualityIssue(
        code: 'protagonist-not-established-${story.id}',
        severity: LiteraryIssueSeverity.medium,
        message: '${story.id} does not establish its protagonist in the opening section.',
      ));
    }
  }

  final genericOpeningCount = stories.where((story) {
    final opening = story.sections.first.trim();
    return _genericOpening.hasMatch(opening);
  }).length;
  final genericOpeningRate =
      stories.isEmpty ? 0.0 : genericOpeningCount / stories.length;
  if (genericOpeningRate > .20) {
    issues.add(LiteraryQualityIssue(
      code: 'generic-opening-rate-severe',
      severity: LiteraryIssueSeverity.severe,
      message: 'Generic time/weather openings reached '
          '${(genericOpeningRate * 100).toStringAsFixed(1)}%.',
    ));
  } else if (genericOpeningRate > .10) {
    issues.add(LiteraryQualityIssue(
      code: 'generic-opening-rate-medium',
      severity: LiteraryIssueSeverity.medium,
      message: 'Generic time/weather openings reached '
          '${(genericOpeningRate * 100).toStringAsFixed(1)}%.',
    ));
  }

  final conservationEndingCount = stories.where((story) {
    final ending = story.sections.last;
    return _conservationEnding.hasMatch(ending);
  }).length;
  final conservationEndingRate =
      stories.isEmpty ? 0.0 : conservationEndingCount / stories.length;
  if (conservationEndingRate > .25) {
    issues.add(LiteraryQualityIssue(
      code: 'conservation-ending-rate-severe',
      severity: LiteraryIssueSeverity.severe,
      message: 'Protection-themed endings reached '
          '${(conservationEndingRate * 100).toStringAsFixed(1)}%.',
    ));
  } else if (conservationEndingRate > .15) {
    issues.add(LiteraryQualityIssue(
      code: 'conservation-ending-rate-medium',
      severity: LiteraryIssueSeverity.medium,
      message: 'Protection-themed endings reached '
          '${(conservationEndingRate * 100).toStringAsFixed(1)}%.',
    ));
  }

  final dialogueStoryCount = stories.where((story) {
    final text = story.sections.join();
    return text.contains('“') && text.contains('”');
  }).length;
  if (dialogueStoryCount < (stories.length * .70).ceil()) {
    issues.add(LiteraryQualityIssue(
      code: 'dialogue-diversity-medium',
      severity: LiteraryIssueSeverity.medium,
      message: 'Only $dialogueStoryCount stories contain direct character voice.',
    ));
  }

  final duplicateModes = _duplicates(
    stories.map((story) => story.narrativeMode),
  );
  if (duplicateModes.isNotEmpty) {
    issues.add(LiteraryQualityIssue(
      code: 'duplicate-narrative-mode',
      severity: LiteraryIssueSeverity.medium,
      message: 'Repeated narrative modes: ${duplicateModes.join(', ')}.',
    ));
  }

  final duplicateEndings = _duplicates(
    stories.map((story) => story.endingMode),
  );
  if (duplicateEndings.isNotEmpty) {
    issues.add(LiteraryQualityIssue(
      code: 'duplicate-ending-mode',
      severity: LiteraryIssueSeverity.medium,
      message: 'Repeated ending modes: ${duplicateEndings.join(', ')}.',
    ));
  }

  var maxPairSimilarity = 0.0;
  var maxPair = '';
  for (var i = 0; i < stories.length; i += 1) {
    for (var j = i + 1; j < stories.length; j += 1) {
      final similarity = chineseContentSimilarity(
        stories[i].sections.join(),
        stories[j].sections.join(),
      );
      if (similarity > maxPairSimilarity) {
        maxPairSimilarity = similarity;
        maxPair = '${stories[i].id} / ${stories[j].id}';
      }
    }
  }
  if (maxPairSimilarity > .55) {
    issues.add(LiteraryQualityIssue(
      code: 'cross-story-similarity-severe',
      severity: LiteraryIssueSeverity.severe,
      message: '$maxPair reached ${maxPairSimilarity.toStringAsFixed(3)} similarity.',
    ));
  } else if (maxPairSimilarity > .42) {
    issues.add(LiteraryQualityIssue(
      code: 'cross-story-similarity-medium',
      severity: LiteraryIssueSeverity.medium,
      message: '$maxPair reached ${maxPairSimilarity.toStringAsFixed(3)} similarity.',
    ));
  }

  final aiPhraseCount = stories.fold<int>(0, (sum, story) {
    final text = story.sections.join();
    return sum + _aiPhrases.allMatches(text).length;
  });
  if (aiPhraseCount > stories.length) {
    issues.add(LiteraryQualityIssue(
      code: 'ai-transition-density-light',
      severity: LiteraryIssueSeverity.light,
      message: 'Formulaic contrast phrases appeared $aiPhraseCount times across '
          '${stories.length} stories.',
    ));
  }

  return JourneyLiteraryQualityReport(
    totalStories: stories.length,
    genericOpeningCount: genericOpeningCount,
    conservationEndingCount: conservationEndingCount,
    dialogueStoryCount: dialogueStoryCount,
    maxPairSimilarity: maxPairSimilarity,
    maxPair: maxPair,
    issues: List.unmodifiable(issues),
  );
}

bool _openingEstablishesProtagonist(EditorialStoryRevision story) {
  final opening = story.sections.first;
  final names = story.protagonist
      .split(RegExp(r'[与和、/ ]'))
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty);
  for (final name in names) {
    final candidates = <String>{name};
    if (name.length >= 2) candidates.add(name.substring(name.length - 2));
    if (name.length >= 3) candidates.add(name.substring(name.length - 3));
    if (candidates.any(opening.contains)) return true;
  }
  return false;
}

Set<String> _duplicates(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts[value] = (counts[value] ?? 0) + 1;
  }
  return {
    for (final entry in counts.entries)
      if (entry.value > 1) entry.key,
  };
}

final _genericOpening = RegExp(
  r'^(清晨|傍晚|上午|午后|夜色|日出|晨光|薄雾|海风|冬日清晨|天还没有亮)[，,]?你',
);
final _conservationEnding = RegExp(r'(保护|保存|维护|修复|守护).{0,18}(遗产|建筑|环境|记忆|传统)');
final _aiPhrases = RegExp(r'(不只是|不仅是|真正.{0,4}的是|而是让|需要同时|共同形成)');
