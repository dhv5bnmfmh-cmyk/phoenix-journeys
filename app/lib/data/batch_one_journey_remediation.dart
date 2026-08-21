import 'journey_data.dart';
import 'journey_level_catalog.dart';

/// Shared Batch One data contracts only.
///
/// Forbidden City is no longer authored in this package. Reference Location
/// 001 is sourced exclusively from forbidden_city_journey_runtime.dart.
const batchOneJourneyIds = <String>{'shanghai-bund'};

const batchOneChallengeTypes = <String>[
  'paragraphRebuild',
  'grammarRepair',
  'missingSentence',
];

class RemediatedSourceBinding {
  const RemediatedSourceBinding({
    required this.id,
    required this.publisher,
    required this.scope,
  });

  final String id;
  final String publisher;
  final String scope;
}

class RemediatedSemanticEvent {
  const RemediatedSemanticEvent({
    required this.id,
    required this.coreChinese,
    required this.corePinyin,
    required this.coreVietnamese,
    required this.coreEnglish,
    required this.detailChinese,
    required this.detailPinyin,
    required this.detailVietnamese,
    required this.detailEnglish,
    required this.detailFromLevel,
  });

  final String id;
  final String coreChinese;
  final String corePinyin;
  final String coreVietnamese;
  final String coreEnglish;
  final String detailChinese;
  final String detailPinyin;
  final String detailVietnamese;
  final String detailEnglish;
  final int detailFromLevel;
}

class RemediatedWordTrace {
  const RemediatedWordTrace({
    required this.word,
    required this.eventId,
    required this.usage,
    required this.sourceText,
  });

  final String word;
  final String eventId;
  final String usage;
  final String sourceText;
}

class RemediatedDiscoveryTrace {
  const RemediatedDiscoveryTrace({
    required this.discoveryIndex,
    required this.storyEventIds,
    required this.sourceIds,
  });

  final int discoveryIndex;
  final List<String> storyEventIds;
  final List<String> sourceIds;
}

class RemediatedChallengeTrace {
  const RemediatedChallengeTrace({
    required this.type,
    required this.storyEventIds,
    required this.anchor,
  });

  final String type;
  final List<String> storyEventIds;
  final String anchor;
}

class RemediatedMemoryReview {
  const RemediatedMemoryReview({
    required this.category,
    required this.prompt,
    required this.answer,
    required this.storyEventIds,
  });

  final String category;
  final String prompt;
  final String answer;
  final List<String> storyEventIds;
}

class RemediatedCompletion {
  const RemediatedCompletion({
    required this.journeySummary,
    required this.achievement,
    required this.memoryAnchor,
    required this.challengeReward,
    required this.journeyCompletion,
  });

  final String journeySummary;
  final String achievement;
  final String memoryAnchor;
  final String challengeReward;
  final String journeyCompletion;
}

class RemediatedJourney {
  const RemediatedJourney({
    required this.id,
    required this.title,
    required this.protagonist,
    required this.goal,
    required this.conflict,
    required this.eventIds,
    required this.events,
    required this.levels,
    required this.words,
    required this.wordTraces,
    required this.discoveries,
    required this.discoveryTraces,
    required this.challenges,
    required this.memory,
    required this.completion,
    required this.sources,
  });

  final String id;
  final String title;
  final String protagonist;
  final String goal;
  final String conflict;
  final List<String> eventIds;
  final List<RemediatedSemanticEvent> events;
  final List<JourneyLevelContent> levels;
  final List<WordEntry> words;
  final List<RemediatedWordTrace> wordTraces;
  final List<DiscoveryEntry> discoveries;
  final List<RemediatedDiscoveryTrace> discoveryTraces;
  final List<RemediatedChallengeTrace> challenges;
  final List<RemediatedMemoryReview> memory;
  final RemediatedCompletion completion;
  final List<RemediatedSourceBinding> sources;

  JourneyLevelContent levelContent(int requestedLevel) {
    final level = requestedLevel.clamp(1, 10).toInt();
    final base = levels[level - 1];
    final story = base.storyParagraphs.join();
    final visibleWords = words
        .where((entry) => story.contains(entry.word))
        .take((4 + level).clamp(5, 12))
        .toList(growable: false);
    if (discoveries.isEmpty) {
      return JourneyLevelContent(
        storyParagraphs: base.storyParagraphs,
        storyAnnotations: base.storyAnnotations,
        words: visibleWords,
        discoveries: const <DiscoveryEntry>[],
        wonderQuestion: base.wonderQuestion,
        expressQuestion: base.expressQuestion,
      );
    }
    final start = (level - 1) % discoveries.length;
    final discoveryCount = level <= 2 ? 1 : 2;
    final visibleDiscoveries = <DiscoveryEntry>[
      for (var offset = 0; offset < discoveryCount; offset++)
        discoveries[(start + offset) % discoveries.length],
    ];
    return JourneyLevelContent(
      storyParagraphs: base.storyParagraphs,
      storyAnnotations: base.storyAnnotations,
      words: visibleWords,
      discoveries: visibleDiscoveries,
      wonderQuestion: base.wonderQuestion,
      expressQuestion: base.expressQuestion,
    );
  }
}

/// Legacy registry intentionally contains no Forbidden City entry.
/// Active packages own their own one-pass remediation objects.
const Map<String, RemediatedJourney> batchOneRemediatedJourneys =
    <String, RemediatedJourney>{};

RemediatedJourney? batchOneRemediationFor(String journeyId) =>
    batchOneRemediatedJourneys[journeyId];
