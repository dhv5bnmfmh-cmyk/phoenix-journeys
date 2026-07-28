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
  final plan = _languageLevelAgent.planFor(profile);
  final story = _buildStory(experience, profile);
  final discoveries = _discoveriesForProfile(experience, profile);
  final searchable =
      '${story.paragraphs.join()}${discoveries.map((item) => item.text).join()}';
  final wordsInContent = experience.words
      .where((entry) => searchable.contains(entry.word))
      .toList(growable: false);
  final vocabularyCandidates =
      wordsInContent.isEmpty ? experience.words : wordsInContent;
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
    paragraphCount: plan.paragraphCount,
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

class _StorySentence {
  const _StorySentence({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
}

_AdaptiveStory _buildStory(
  DailyJourneyExperience experience,
  ChineseProficiencyProfile profile,
) {
  final packets = _storySentencePackets(experience);
  if (packets.isEmpty) return _fallbackStory();

  final plan = _languageLevelAgent.planFor(profile);
  final sentenceLimit = switch (profile.band) {
    PhoenixReadingBand.beginner => 4,
    PhoenixReadingBand.elementary => 7,
    PhoenixReadingBand.intermediate => 10,
    PhoenixReadingBand.upperIntermediate => 14,
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery => packets.length,
  };
  final selected = _selectNarrativePackets(
    packets,
    maximumSentences: sentenceLimit,
    maximumCharacters: plan.maxTotalCharacters,
  );
  final groups = _partitionPackets(selected, plan.paragraphCount);

  return _AdaptiveStory(
    paragraphs: groups
        .map((group) => _joinChinese(group.map((item) => item.chinese)))
        .where((text) => text.isNotEmpty)
        .toList(growable: false),
    annotations: groups
        .map(
          (group) => ReadingAnnotation(
            pinyin: _joinLatin(group.map((item) => item.pinyin)),
            vietnamese: _joinLatin(group.map((item) => item.vietnamese)),
            english: _joinLatin(group.map((item) => item.english)),
          ),
        )
        .toList(growable: false),
  );
}

List<_StorySentence> _storySentencePackets(
  DailyJourneyExperience experience,
) {
  final paragraphs = experience.content.storyParagraphs;
  final annotations = experience.storyAnnotations;
  if (paragraphs.isEmpty || annotations.isEmpty) return const [];

  final packets = <_StorySentence>[];
  for (var paragraphIndex = 0;
      paragraphIndex < paragraphs.length;
      paragraphIndex += 1) {
    final chinese = _splitChineseSentences(paragraphs[paragraphIndex]);
    if (chinese.isEmpty) continue;
    final annotation =
        annotations[paragraphIndex.clamp(0, annotations.length - 1).toInt()];
    final pinyin = _splitLatinSentences(annotation.pinyin);
    final vietnamese = _splitLatinSentences(annotation.vietnamese);
    final english = _splitLatinSentences(annotation.english);

    for (var sentenceIndex = 0;
        sentenceIndex < chinese.length;
        sentenceIndex += 1) {
      packets.add(
        _StorySentence(
          chinese: chinese[sentenceIndex],
          pinyin: _alignedSentence(pinyin, sentenceIndex),
          vietnamese: _alignedSentence(vietnamese, sentenceIndex),
          english: _alignedSentence(english, sentenceIndex),
        ),
      );
    }
  }
  return packets;
}

List<_StorySentence> _selectNarrativePackets(
  List<_StorySentence> source, {
  required int maximumSentences,
  required int maximumCharacters,
}) {
  if (source.length <= maximumSentences &&
      _storyCharacterCount(source) <= maximumCharacters) {
    return source;
  }
  if (source.length <= 2) return source;

  var target = maximumSentences.clamp(2, source.length).toInt();
  var selected = _evenlySample(source, target);
  while (selected.length > 2 &&
      _storyCharacterCount(selected) > maximumCharacters) {
    target -= 1;
    selected = _evenlySample(source, target);
  }
  return selected;
}

List<_StorySentence> _evenlySample(
  List<_StorySentence> source,
  int target,
) {
  if (target >= source.length) return source;
  if (target <= 1) return <_StorySentence>[source.first];

  final indexes = <int>{0, source.length - 1};
  for (var position = 1; position < target - 1; position += 1) {
    final ratio = position / (target - 1);
    indexes.add((ratio * (source.length - 1)).round());
  }
  final ordered = indexes.toList()..sort();
  return ordered.map((index) => source[index]).toList(growable: false);
}

int _storyCharacterCount(Iterable<_StorySentence> packets) =>
    packets.fold(0, (total, item) => total + item.chinese.length);

List<List<_StorySentence>> _partitionPackets(
  List<_StorySentence> packets,
  int paragraphCount,
) {
  if (paragraphCount <= 1 || packets.length <= 1) {
    return <List<_StorySentence>>[packets];
  }

  final groups = <List<_StorySentence>>[];
  var start = 0;
  for (var index = 0; index < paragraphCount; index += 1) {
    final remainingItems = packets.length - start;
    final remainingGroups = paragraphCount - index;
    final take = (remainingItems / remainingGroups).ceil();
    groups.add(packets.sublist(start, start + take));
    start += take;
  }
  return groups.where((group) => group.isNotEmpty).toList(growable: false);
}

_AdaptiveStory _fallbackStory() {
  return const _AdaptiveStory(
    paragraphs: <String>['这段旅程正在准备中。请稍后再来继续探索。'],
    annotations: <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin:
            'Zhè duàn lǚchéng zhèngzài zhǔnbèi zhōng. Qǐng shāohòu zài lái jìxù tànsuǒ.',
        vietnamese:
            'Hành trình này đang được chuẩn bị. Hãy quay lại sau để tiếp tục khám phá.',
        english:
            'This journey is being prepared. Please return later to continue exploring.',
      ),
    ],
  );
}

List<DiscoveryEntry> _discoveriesForProfile(
  DailyJourneyExperience experience,
  ChineseProficiencyProfile profile,
) {
  final source = experience.discoveries;
  if (source.isEmpty) return const <DiscoveryEntry>[];

  final targetCount = _discoveryParagraphCount(profile.band);
  return switch (profile.band) {
    PhoenixReadingBand.beginner => <DiscoveryEntry>[
        _compressDiscovery(source.first, maximumSentences: 2),
      ],
    PhoenixReadingBand.elementary => _selectDiscoveryArc(
        source,
        targetCount: targetCount,
        maximumSentencesPerEntry: 2,
      ),
    PhoenixReadingBand.intermediate => _selectDiscoveryArc(
        source,
        targetCount: targetCount,
        maximumSentencesPerEntry: 3,
      ),
    PhoenixReadingBand.upperIntermediate => _groupDiscoveries(
        source,
        targetCount: targetCount,
      ),
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      _groupDiscoveries(
        source,
        targetCount: targetCount,
      ),
  };
}

List<DiscoveryEntry> _selectDiscoveryArc(
  List<DiscoveryEntry> source, {
  required int targetCount,
  required int maximumSentencesPerEntry,
}) {
  if (targetCount <= 1) {
    return <DiscoveryEntry>[
      _compressDiscovery(
        source.first,
        maximumSentences: maximumSentencesPerEntry,
      ),
    ];
  }
  if (source.length == 1) {
    return <DiscoveryEntry>[
      _compressDiscovery(
        source.first,
        maximumSentences: maximumSentencesPerEntry,
      ),
    ];
  }

  return <DiscoveryEntry>[
    _compressDiscovery(
      source.first,
      maximumSentences: maximumSentencesPerEntry,
    ),
    _compressDiscovery(
      source.last,
      maximumSentences: maximumSentencesPerEntry,
    ),
  ];
}

List<DiscoveryEntry> _groupDiscoveries(
  List<DiscoveryEntry> source, {
  required int targetCount,
}) {
  if (source.length <= targetCount) return source;
  if (targetCount <= 1) return <DiscoveryEntry>[_mergeDiscoveryEntries(source)];

  final split = (source.length / 2).ceil();
  return <DiscoveryEntry>[
    _mergeDiscoveryEntries(source.take(split)),
    _mergeDiscoveryEntries(source.skip(split)),
  ];
}

DiscoveryEntry _compressDiscovery(
  DiscoveryEntry entry, {
  required int maximumSentences,
}) {
  return DiscoveryEntry(
    text: _selectSentences(entry.text, maximumSentences, chinese: true),
    pinyin: _selectSentences(entry.pinyin, maximumSentences),
    simpleChinese:
        _selectSentences(entry.simpleChinese, maximumSentences, chinese: true),
    vietnamese: _selectSentences(entry.vietnamese, maximumSentences),
    english: _selectSentences(entry.english, maximumSentences),
  );
}

String _selectSentences(
  String value,
  int maximumSentences, {
  bool chinese = false,
}) {
  final sentences =
      chinese ? _splitChineseSentences(value) : _splitLatinSentences(value);
  if (sentences.length <= maximumSentences) return value.trim();

  final selected = _evenlySampleStrings(sentences, maximumSentences);
  return chinese ? _joinChinese(selected) : _joinLatin(selected);
}

List<String> _evenlySampleStrings(List<String> source, int target) {
  if (target >= source.length) return source;
  if (target <= 1) return <String>[source.first];

  final indexes = <int>{0, source.length - 1};
  for (var position = 1; position < target - 1; position += 1) {
    final ratio = position / (target - 1);
    indexes.add((ratio * (source.length - 1)).round());
  }
  final ordered = indexes.toList()..sort();
  return ordered.map((index) => source[index]).toList(growable: false);
}

int _discoveryParagraphCount(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner => 1,
  PhoenixReadingBand.elementary ||
  PhoenixReadingBand.intermediate ||
  PhoenixReadingBand.upperIntermediate ||
  PhoenixReadingBand.advanced ||
  PhoenixReadingBand.mastery => 2,
};

DiscoveryEntry _mergeDiscoveryEntries(Iterable<DiscoveryEntry> source) {
  final entries = source.toList(growable: false);
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese:
        _joinChinese(entries.map((entry) => entry.simpleChinese)),
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
  final isCulture = entry.partOfSpeech.contains('文化');
  final hskLevel = (1 + index ~/ 2).clamp(1, 6).toInt();
  final tocflLevel = (1 + (index + 1) ~/ 2).clamp(1, 6).toInt();

  return VocabularyLevelTag(
    hskLevel: isProperNoun ? null : hskLevel,
    tocflLevel: isProperNoun ? null : tocflLevel,
    kind: isProperNoun
        ? VocabularyKind.properNoun
        : isPhrase
            ? VocabularyKind.idiom
            : isCulture
                ? VocabularyKind.cultural
                : VocabularyKind.general,
    evidence: isProperNoun || isPhrase || isCulture
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
      '在${experience.place}，你最想先看什么？请用一到两句话说明原因。',
    PhoenixReadingBand.elementary =>
      '请引用故事中的一个细节回答：${experience.wonderQuestion}',
    PhoenixReadingBand.intermediate =>
      '请结合故事中的两个细节回答，并说明原因：${experience.wonderQuestion}',
    PhoenixReadingBand.upperIntermediate =>
      '请从空间、历史或人物感受中选择两个角度回答：${experience.wonderQuestion}',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '请从历史语境、空间设计和今天的使用中选择一个角度深入回答：${experience.wonderQuestion}',
  };
}

String _expressQuestion(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  return switch (band) {
    PhoenixReadingBand.beginner =>
      '请用一到两句话介绍${experience.place}，尽量使用一个重点单词。',
    PhoenixReadingBand.elementary =>
      '${experience.expressQuestion}请加入一个具体画面。',
    PhoenixReadingBand.intermediate =>
      '${experience.expressQuestion}请补充一个原因，并使用两个重点单词。',
    PhoenixReadingBand.upperIntermediate =>
      '${experience.expressQuestion}请使用“既……也……”或“不是……而是……”，并引用故事细节。',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '${experience.expressQuestion}请说明景观、历史与今天生活之间的关系，并形成完整论述。',
  };
}

List<String> _splitChineseSentences(String value) {
  final text = value.trim();
  if (text.isEmpty) return const <String>[];
  return RegExp(r'[^。！？!?]+[。！？!?]?')
      .allMatches(text)
      .map((match) => match.group(0)?.trim() ?? '')
      .where((sentence) => sentence.isNotEmpty)
      .toList(growable: false);
}

List<String> _splitLatinSentences(String value) {
  final text = value.trim();
  if (text.isEmpty) return const <String>[];
  return RegExp(r'[^.!?]+[.!?]?')
      .allMatches(text)
      .map((match) => match.group(0)?.trim() ?? '')
      .where((sentence) => sentence.isNotEmpty)
      .toList(growable: false);
}

String _alignedSentence(List<String> sentences, int index) {
  if (sentences.isEmpty) return '';
  if (index < sentences.length) return sentences[index];
  return '';
}

String _joinChinese(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join(' ');
