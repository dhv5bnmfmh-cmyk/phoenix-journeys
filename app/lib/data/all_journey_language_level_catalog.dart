import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent buildAdaptiveLevelForJourney(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final story = _buildStory(experience, profile.band);
  final discoveries = _discoveriesForBand(experience, profile.band);
  final searchable =
      '${story.paragraphs.join()}${discoveries.map((item) => item.text).join()}';
  final wordsInContent = experience.words
      .where((entry) => searchable.contains(entry.word))
      .toList(growable: false);
  final vocabularyCandidates = wordsInContent.isEmpty
      ? experience.words
      : wordsInContent;
  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: vocabularyCandidates,
    levelCatalog: _buildVocabularyCatalog(experience.words),
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: story.paragraphs,
    storyAnnotations: story.annotations,
    words: selectedWords,
    discoveries: discoveries,
    wonderQuestion: _wonderQuestion(experience, profile.band),
    expressQuestion: _expressQuestion(experience, profile.band),
  ).withReadingLimit(
    paragraphCount: _languageLevelAgent.planFor(profile).paragraphCount,
    discoveryCount: _discoveryParagraphCount(profile.band),
  );
}

class _AdaptiveStory {
  const _AdaptiveStory({
    required this.paragraphs,
    required this.annotations,
  });

  final List<String> paragraphs;
  final List<ReadingAnnotation> annotations;
}

_AdaptiveStory _buildStory(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  final paragraphs = experience.content.storyParagraphs;
  final annotations = experience.storyAnnotations;

  if (paragraphs.isEmpty || annotations.isEmpty) {
    return const _AdaptiveStory(
      paragraphs: <String>['这段旅程正在准备中。', '请稍后再来继续探索。'],
      annotations: <ReadingAnnotation>[
        ReadingAnnotation(
          pinyin: 'Zhè duàn lǚchéng zhèngzài zhǔnbèi zhōng.',
          vietnamese: 'Hành trình này đang được chuẩn bị.',
          english: 'This journey is being prepared.',
        ),
        ReadingAnnotation(
          pinyin: 'Qǐng shāohòu zài lái jìxù tànsuǒ.',
          vietnamese: 'Hãy quay lại sau để tiếp tục khám phá.',
          english: 'Please return later to continue exploring.',
        ),
      ],
    );
  }

  final lastIndex = paragraphs.length - 1;
  final secondIndex = paragraphs.length > 1 ? 1 : 0;
  final thirdIndex = paragraphs.length > 2 ? 2 : lastIndex;
  final lastAnnotationIndex = lastIndex.clamp(0, annotations.length - 1).toInt();
  final secondAnnotationIndex =
      secondIndex.clamp(0, annotations.length - 1).toInt();
  final thirdAnnotationIndex =
      thirdIndex.clamp(0, annotations.length - 1).toInt();

  switch (band) {
    case PhoenixReadingBand.beginner:
      return _AdaptiveStory(
        paragraphs: <String>[
          _joinChinese(<String>[
            _firstChineseSentence(paragraphs.first),
            _firstChineseSentence(paragraphs[lastIndex]),
          ]),
        ],
        annotations: <ReadingAnnotation>[
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations.first,
              annotations[lastAnnotationIndex],
            ],
            firstSentenceOnly: true,
          ),
        ],
      );
    case PhoenixReadingBand.elementary:
      return _AdaptiveStory(
        paragraphs: <String>[
          _joinChinese(<String>[paragraphs.first, paragraphs[secondIndex]]),
          _joinChinese(<String>[paragraphs[thirdIndex], paragraphs[lastIndex]]),
        ],
        annotations: <ReadingAnnotation>[
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations.first,
              annotations[secondAnnotationIndex],
            ],
          ),
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations[thirdAnnotationIndex],
              annotations[lastAnnotationIndex],
            ],
          ),
        ],
      );
    case PhoenixReadingBand.intermediate:
      return _pairedStory(
        paragraphs: paragraphs,
        annotations: annotations,
      );
    case PhoenixReadingBand.upperIntermediate:
      return _pairedStory(
        paragraphs: paragraphs,
        annotations: annotations,
      );
    case PhoenixReadingBand.advanced:
    case PhoenixReadingBand.mastery:
      return _AdaptiveStory(
        paragraphs: <String>[_joinChinese(paragraphs)],
        annotations: <ReadingAnnotation>[
          _combineAnnotation(annotations: annotations),
        ],
      );
  }
}

_AdaptiveStory _pairedStory({
  required List<String> paragraphs,
  required List<ReadingAnnotation> annotations,
}) {
  final split = (paragraphs.length / 2).ceil();
  final firstParagraphs = paragraphs.take(split).toList(growable: false);
  final secondParagraphs = paragraphs.skip(split).toList(growable: false);
  final firstAnnotations = annotations.take(split).toList(growable: false);
  final secondAnnotations = annotations.skip(split).toList(growable: false);

  return _AdaptiveStory(
    paragraphs: <String>[
      _joinChinese(firstParagraphs),
      _joinChinese(secondParagraphs),
    ],
    annotations: <ReadingAnnotation>[
      _combineAnnotation(annotations: firstAnnotations),
      _combineAnnotation(annotations: secondAnnotations),
    ],
  );
}

ReadingAnnotation _combineAnnotation({
  required List<ReadingAnnotation> annotations,
  List<DiscoveryEntry> discoveries = const <DiscoveryEntry>[],
  bool firstSentenceOnly = false,
}) {
  String prepare(String value) {
    return firstSentenceOnly ? _firstLatinSentence(value) : value.trim();
  }

  return ReadingAnnotation(
    pinyin: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.pinyin)),
      ...discoveries.map((item) => item.pinyin.trim()),
    ]),
    vietnamese: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.vietnamese)),
      ...discoveries.map((item) => item.vietnamese.trim()),
    ]),
    english: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.english)),
      ...discoveries.map((item) => item.english.trim()),
    ]),
  );
}

List<DiscoveryEntry> _discoveriesForBand(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  final count = _discoveryParagraphCount(band);
  final source = experience.discoveries;
  if (source.length <= count) return source;
  if (count == 1) return <DiscoveryEntry>[_mergeDiscoveryEntries(source)];
  final split = (source.length / 2).ceil();
  return <DiscoveryEntry>[
    _mergeDiscoveryEntries(source.take(split)),
    _mergeDiscoveryEntries(source.skip(split)),
  ];
}

int _discoveryParagraphCount(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner ||
  PhoenixReadingBand.advanced ||
  PhoenixReadingBand.mastery => 1,
  PhoenixReadingBand.elementary ||
  PhoenixReadingBand.intermediate ||
  PhoenixReadingBand.upperIntermediate => 2,
};

DiscoveryEntry _mergeDiscoveryEntries(Iterable<DiscoveryEntry> source) {
  final entries = source.toList(growable: false);
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese: _joinChinese(
      entries.map((entry) => entry.simpleChinese),
    ),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
  );
}

Map<String, VocabularyLevelTag> _buildVocabularyCatalog(
  List<WordEntry> words,
) {
  return <String, VocabularyLevelTag>{
    for (var index = 0; index < words.length; index += 1)
      words[index].word: _tagFor(words[index], index),
  };
}

VocabularyLevelTag _tagFor(WordEntry entry, int index) {
  final isProperNoun = entry.partOfSpeech.contains('专名');
  final isPhrase = entry.partOfSpeech.contains('短语');
  final level = (1 + index ~/ 2).clamp(1, 6).toInt();
  return VocabularyLevelTag(
    hskLevel: isProperNoun ? null : level,
    tocflLevel: isProperNoun ? null : level,
    kind: isProperNoun
        ? VocabularyKind.properNoun
        : isPhrase
            ? VocabularyKind.idiom
            : VocabularyKind.general,
    evidence: isProperNoun || isPhrase
        ? VocabularyLevelEvidence.cultural
        : VocabularyLevelEvidence.curated,
  );
}

String _wonderQuestion(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  return switch (band) {
    PhoenixReadingBand.beginner =>
      '在${experience.place}，你最想先看什么？为什么？',
    PhoenixReadingBand.elementary || PhoenixReadingBand.intermediate =>
      experience.wonderQuestion,
    PhoenixReadingBand.upperIntermediate =>
      '请结合故事中的两个细节回答：${experience.wonderQuestion}',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '请从历史、空间和今天的使用中选择一个角度深入回答：${experience.wonderQuestion}',
  };
}

String _expressQuestion(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  return switch (band) {
    PhoenixReadingBand.beginner =>
      '请用一到两句话介绍${experience.place}。',
    PhoenixReadingBand.elementary => experience.expressQuestion,
    PhoenixReadingBand.intermediate =>
      '${experience.expressQuestion}请补充一个具体画面或原因。',
    PhoenixReadingBand.upperIntermediate =>
      '${experience.expressQuestion}请使用“既……也……”或“不是……而是……”。',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '${experience.expressQuestion}请说明景观、历史与今天生活之间的关系。',
  };
}

String _firstChineseSentence(String value) {
  final text = value.trim();
  if (text.isEmpty) return text;
  final end = text.indexOf('。');
  return end < 0 ? text : text.substring(0, end + 1);
}

String _firstLatinSentence(String value) {
  final text = value.trim();
  if (text.isEmpty) return text;
  final match = RegExp(r'[.!?](?:\s|$)').firstMatch(text);
  return match == null ? text : text.substring(0, match.start + 1).trim();
}

String _joinChinese(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join(' ');
