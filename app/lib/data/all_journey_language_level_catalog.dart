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
  final searchable = '${story.paragraphs.join()}${discoveries.map((item) => item.text).join()}';
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
  final discoveries = experience.discoveries;

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

  switch (band) {
    case PhoenixReadingBand.beginner:
      return _AdaptiveStory(
        paragraphs: <String>[
          _joinChinese(<String>[
            _firstChineseSentence(paragraphs.first),
            if (discoveries.isNotEmpty) discoveries.first.text,
          ]),
          _joinChinese(<String>[
            _firstChineseSentence(paragraphs[lastIndex]),
            if (discoveries.length > 1) discoveries[1].text,
          ]),
        ],
        annotations: <ReadingAnnotation>[
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations.first,
            ],
            discoveries: discoveries.isEmpty
                ? const <DiscoveryEntry>[]
                : <DiscoveryEntry>[discoveries.first],
            firstSentenceOnly: true,
          ),
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations[lastIndex.clamp(0, annotations.length - 1)],
            ],
            discoveries: discoveries.length > 1
                ? <DiscoveryEntry>[discoveries[1]]
                : const <DiscoveryEntry>[],
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
              annotations[secondIndex.clamp(0, annotations.length - 1)],
            ],
          ),
          _combineAnnotation(
            annotations: <ReadingAnnotation>[
              annotations[thirdIndex.clamp(0, annotations.length - 1)],
              annotations[lastIndex.clamp(0, annotations.length - 1)],
            ],
          ),
        ],
      );
    case PhoenixReadingBand.intermediate:
      return _pairedStory(
        paragraphs: paragraphs,
        annotations: annotations,
        discoveries: discoveries.take(2).toList(growable: false),
      );
    case PhoenixReadingBand.upperIntermediate:
    case PhoenixReadingBand.advanced:
    case PhoenixReadingBand.mastery:
      return _pairedStory(
        paragraphs: paragraphs,
        annotations: annotations,
        discoveries: discoveries,
      );
  }
}

_AdaptiveStory _pairedStory({
  required List<String> paragraphs,
  required List<ReadingAnnotation> annotations,
  required List<DiscoveryEntry> discoveries,
}) {
  final split = (paragraphs.length / 2).ceil();
  final firstParagraphs = paragraphs.take(split).toList(growable: false);
  final secondParagraphs = paragraphs.skip(split).toList(growable: false);
  final firstAnnotations = annotations.take(split).toList(growable: false);
  final secondAnnotations = annotations.skip(split).toList(growable: false);
  final discoverySplit = (discoveries.length / 2).ceil();
  final firstDiscoveries = discoveries
      .take(discoverySplit)
      .toList(growable: false);
  final secondDiscoveries = discoveries
      .skip(discoverySplit)
      .toList(growable: false);

  return _AdaptiveStory(
    paragraphs: <String>[
      _joinChinese(<String>[
        ...firstParagraphs,
        ...firstDiscoveries.map((item) => item.text),
      ]),
      _joinChinese(<String>[
        ...secondParagraphs,
        ...secondDiscoveries.map((item) => item.text),
      ]),
    ],
    annotations: <ReadingAnnotation>[
      _combineAnnotation(
        annotations: firstAnnotations,
        discoveries: firstDiscoveries,
      ),
      _combineAnnotation(
        annotations: secondAnnotations,
        discoveries: secondDiscoveries,
      ),
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
  final count = switch (band) {
    PhoenixReadingBand.beginner => 2,
    PhoenixReadingBand.elementary => 3,
    PhoenixReadingBand.intermediate ||
    PhoenixReadingBand.upperIntermediate ||
    PhoenixReadingBand.advanced ||
    PhoenixReadingBand.mastery => 4,
  };
  return experience.discoveries.take(count).toList(growable: false);
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
  final match = RegExp(r'(?<=[.!?])\s').firstMatch(text);
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
