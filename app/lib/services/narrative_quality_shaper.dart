import 'package:flutter/foundation.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../data/daily_journey_experience.dart';
import '../data/journey_data.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();
final _storyPacketsByExperience =
    Expando<List<_NarrativePacket>>('narrative story packets');

class _NarrativePacket {
  const _NarrativePacket({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
    required this.paragraphIndex,
    required this.sentenceIndex,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
  final int paragraphIndex;
  final int sentenceIndex;
}

class _NarrativeShape {
  const _NarrativeShape({
    required this.paragraphs,
    required this.annotations,
  });

  final List<String> paragraphs;
  final List<ReadingAnnotation> annotations;
}

JourneyLevelContent refineAdaptiveNarrativeQuality(
  DailyJourneyExperience experience,
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  final plan = _languageLevelAgent.planFor(profile);
  final packets = _storyPackets(experience);
  final story = packets.isEmpty
      ? _NarrativeShape(
          paragraphs: content.storyParagraphs,
          annotations: content.storyAnnotations,
        )
      : _shapeStory(
          packets,
          paragraphCount: plan.paragraphCount,
          maximumSentences: _sentenceLimit(profile.band, packets.length),
          maximumCharacters: plan.maxTotalCharacters,
        );

  return JourneyLevelContent(
    storyParagraphs: story.paragraphs,
    storyAnnotations: story.annotations,
    words: content.words,
    discoveries: _shapeDiscoveries(experience, content, profile.band),
    wonderQuestion: content.wonderQuestion,
    expressQuestion: content.expressQuestion,
  );
}

int _sentenceLimit(PhoenixReadingBand band, int sourceLength) => switch (band) {
      PhoenixReadingBand.beginner => 4,
      PhoenixReadingBand.elementary => 7,
      PhoenixReadingBand.intermediate => 10,
      PhoenixReadingBand.upperIntermediate => 14,
      PhoenixReadingBand.advanced || PhoenixReadingBand.mastery => sourceLength,
    };

List<_NarrativePacket> _storyPackets(DailyJourneyExperience experience) {
  final cached = _storyPacketsByExperience[experience];
  if (cached != null) return cached;

  final paragraphs = experience.content.storyParagraphs;
  final annotations = experience.storyAnnotations;
  if (paragraphs.isEmpty || annotations.isEmpty) {
    const empty = <_NarrativePacket>[];
    _storyPacketsByExperience[experience] = empty;
    return empty;
  }

  final packets = <_NarrativePacket>[];
  for (var paragraphIndex = 0;
      paragraphIndex < paragraphs.length;
      paragraphIndex += 1) {
    final chinese = splitChineseNarrativeSentences(paragraphs[paragraphIndex]);
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
        _NarrativePacket(
          chinese: chinese[sentenceIndex],
          pinyin: _mappedSentence(pinyin, sentenceIndex, chinese.length),
          vietnamese: _mappedSentence(vietnamese, sentenceIndex, chinese.length),
          english: _mappedSentence(english, sentenceIndex, chinese.length),
          paragraphIndex: paragraphIndex,
          sentenceIndex: sentenceIndex,
        ),
      );
    }
  }
  final immutablePackets = List<_NarrativePacket>.unmodifiable(packets);
  _storyPacketsByExperience[experience] = immutablePackets;
  return immutablePackets;
}

_NarrativeShape _shapeStory(
  List<_NarrativePacket> source, {
  required int paragraphCount,
  required int maximumSentences,
  required int maximumCharacters,
}) {
  final indexes = _selectNarrativeIndexes(
    source,
    maximumSentences: maximumSentences,
    maximumCharacters: maximumCharacters,
  );
  final selected = indexes.map((index) => source[index]).toList(growable: false);
  final groups = _partitionNarrative(selected, paragraphCount);

  return _NarrativeShape(
    paragraphs: groups
        .map((group) => _joinChinese(group.map((item) => item.chinese)))
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

List<int> _selectNarrativeIndexes(
  List<_NarrativePacket> source, {
  required int maximumSentences,
  required int maximumCharacters,
}) {
  if (source.length <= maximumSentences &&
      _packetCharacterCount(source) <= maximumCharacters) {
    return List<int>.generate(source.length, (index) => index, growable: false);
  }
  if (source.length <= 2) {
    return List<int>.generate(source.length, (index) => index, growable: false);
  }

  final target = maximumSentences.clamp(2, source.length).toInt();
  final selected = <int>{0, source.length - 1};

  for (var slot = 1; slot < target - 1; slot += 1) {
    final rawStart = (slot * (source.length - 1) / (target - 1)).floor();
    final rawEnd =
        ((slot + 1) * (source.length - 1) / (target - 1)).ceil();
    final start = rawStart.clamp(1, source.length - 2).toInt();
    final end = rawEnd.clamp(start, source.length - 2).toInt();

    int? bestIndex;
    var bestScore = -100000;
    for (var index = start; index <= end; index += 1) {
      if (selected.contains(index)) continue;
      final score = _packetScore(source[index]) * 10 -
          ((index * (target - 1) - slot * (source.length - 1)).abs());
      if (score > bestScore) {
        bestScore = score;
        bestIndex = index;
      }
    }
    if (bestIndex != null) selected.add(bestIndex);
  }

  while (selected.length < target) {
    int? bestIndex;
    var bestScore = -100000;
    for (var index = 1; index < source.length - 1; index += 1) {
      if (selected.contains(index)) continue;
      final nearest = selected
          .map((chosen) => (chosen - index).abs())
          .reduce((left, right) => left < right ? left : right);
      final score = _packetScore(source[index]) * 10 + nearest * 3;
      if (score > bestScore) {
        bestScore = score;
        bestIndex = index;
      }
    }
    if (bestIndex == null) break;
    selected.add(bestIndex);
  }

  _repairDependentOpenings(source, selected, target);
  _trimToCharacterBudget(source, selected, maximumCharacters);

  final ordered = selected.toList()..sort();
  return ordered;
}

void _repairDependentOpenings(
  List<_NarrativePacket> source,
  Set<int> selected,
  int target,
) {
  final ordered = selected.toList()..sort();
  for (final index in ordered) {
    if (index <= 0 ||
        !_startsWithDependentReference(source[index].chinese) ||
        selected.contains(index - 1)) {
      continue;
    }

    if (selected.length < target) {
      selected.add(index - 1);
      continue;
    }

    final removable = selected
        .where(
          (candidate) =>
              candidate != 0 &&
              candidate != source.length - 1 &&
              candidate != index,
        )
        .toList()
      ..sort(
        (left, right) =>
            _packetScore(source[left]).compareTo(_packetScore(source[right])),
      );
    if (removable.isNotEmpty &&
        _packetScore(source[index - 1]) >=
            _packetScore(source[removable.first])) {
      selected
        ..remove(removable.first)
        ..add(index - 1);
    }
  }
}

void _trimToCharacterBudget(
  List<_NarrativePacket> source,
  Set<int> selected,
  int maximumCharacters,
) {
  while (selected.length > 2 &&
      _packetCharacterCount(
            selected.map((index) => source[index]),
          ) >
          maximumCharacters) {
    final protected = <int>{0, source.length - 1};
    for (final index in selected) {
      if (index > 0 &&
          _startsWithDependentReference(source[index].chinese) &&
          selected.contains(index - 1)) {
        protected.add(index - 1);
      }
    }

    final removable = selected.where((index) => !protected.contains(index)).toList()
      ..sort((left, right) {
        final byScore =
            _packetScore(source[left]).compareTo(_packetScore(source[right]));
        if (byScore != 0) return byScore;
        return source[right].chinese.length.compareTo(source[left].chinese.length);
      });
    if (removable.isEmpty) break;
    selected.remove(removable.first);
  }
}

int _packetScore(_NarrativePacket packet) {
  final text = packet.chinese;
  var score = 0;
  if (packet.sentenceIndex == 0) score += 3;
  if (_turningPointPattern.hasMatch(text)) score += 9;
  if (_insightPattern.hasMatch(text)) score += 8;
  if (_actionPattern.hasMatch(text)) score += 4;
  if (text.contains('：') || text.contains('“') || text.contains('”')) score += 2;
  if (text.runes.length >= 12 && text.runes.length <= 55) score += 2;
  if (_startsWithDependentReference(text)) score -= 2;
  return score;
}

final RegExp _turningPointPattern = RegExp(
  r'然而|但是|但|却|后来|于是|因此|直到|突然|终于|原来|从此|正当|与此同时|不只是|而是',
);

final RegExp _insightPattern = RegExp(
  r'最特别|真正|意味着|象征|看见|发现|理解|见证|保存|保留|连接|组成|形成|改变|让人|所谓|其实',
);

final RegExp _actionPattern = RegExp(
  r'来到|站在|走|沿着|进入|穿过|望向|抬头|听见|看见|回到|离开|展开|出现|开始',
);

bool _startsWithDependentReference(String value) => RegExp(
      r'^(它|他|她|他们|她们|这|那|因此|于是|所以|然而|但是|但|同时|其中|此时|后来|随后|最后|而且|也|其|这种|这些|这里|那里)',
    ).hasMatch(value.trim());

List<List<_NarrativePacket>> _partitionNarrative(
  List<_NarrativePacket> packets,
  int paragraphCount,
) {
  if (paragraphCount <= 1 || packets.length <= 1) {
    return <List<_NarrativePacket>>[packets];
  }

  var bestSplit = (packets.length / 2).ceil();
  var bestScore = -100000;
  for (var split = 1; split < packets.length; split += 1) {
    final distance = ((split * 2) - packets.length).abs();
    var score = -distance * 2;
    if (packets[split - 1].paragraphIndex != packets[split].paragraphIndex) {
      score += 12;
    }
    if (!_startsWithDependentReference(packets[split].chinese)) score += 7;
    if (_turningPointPattern.hasMatch(packets[split].chinese)) score += 2;
    if (score > bestScore) {
      bestScore = score;
      bestSplit = split;
    }
  }

  return <List<_NarrativePacket>>[
    packets.take(bestSplit).toList(growable: false),
    packets.skip(bestSplit).toList(growable: false),
  ];
}

List<DiscoveryEntry> _shapeDiscoveries(
  DailyJourneyExperience experience,
  JourneyLevelContent content,
  PhoenixReadingBand band,
) {
  final source =
      experience.discoveries.isEmpty ? content.discoveries : experience.discoveries;
  if (source.isEmpty) return const <DiscoveryEntry>[];

  return switch (band) {
    PhoenixReadingBand.beginner => <DiscoveryEntry>[
        _compressDiscovery(source.first, maximumSentences: 2),
      ],
    PhoenixReadingBand.elementary => _discoveryArc(
        source,
        maximumSentences: 2,
      ),
    PhoenixReadingBand.intermediate => _discoveryArc(
        source,
        maximumSentences: 3,
      ),
    PhoenixReadingBand.upperIntermediate => _groupDiscoveries(source),
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      <DiscoveryEntry>[_mergeDiscoveries(source)],
  };
}

List<DiscoveryEntry> _discoveryArc(
  List<DiscoveryEntry> source, {
  required int maximumSentences,
}) {
  if (source.length == 1) {
    return <DiscoveryEntry>[
      _compressDiscovery(source.first, maximumSentences: maximumSentences),
    ];
  }
  return <DiscoveryEntry>[
    _compressDiscovery(source.first, maximumSentences: maximumSentences),
    _compressDiscovery(source.last, maximumSentences: maximumSentences),
  ];
}

List<DiscoveryEntry> _groupDiscoveries(List<DiscoveryEntry> source) {
  if (source.length <= 2) return source;
  final split = (source.length / 2).ceil();
  return <DiscoveryEntry>[
    _mergeDiscoveries(source.take(split)),
    _mergeDiscoveries(source.skip(split)),
  ];
}

DiscoveryEntry _compressDiscovery(
  DiscoveryEntry entry, {
  required int maximumSentences,
}) {
  final chinese = splitChineseNarrativeSentences(entry.text);
  if (chinese.isEmpty || chinese.length <= maximumSentences) return entry;

  final indexes = _selectTextIndexes(chinese, maximumSentences);
  final pinyin = _splitLatinSentences(entry.pinyin);
  final simpleChinese = splitChineseNarrativeSentences(entry.simpleChinese);
  final vietnamese = _splitLatinSentences(entry.vietnamese);
  final english = _splitLatinSentences(entry.english);

  return DiscoveryEntry(
    text: _joinChinese(indexes.map((index) => chinese[index])),
    pinyin: _joinLatin(
      indexes.map((index) => _mappedSentence(pinyin, index, chinese.length)),
    ),
    simpleChinese: _joinChinese(
      indexes.map(
        (index) => _mappedSentence(simpleChinese, index, chinese.length),
      ),
    ),
    vietnamese: _joinLatin(
      indexes.map((index) => _mappedSentence(vietnamese, index, chinese.length)),
    ),
    english: _joinLatin(
      indexes.map((index) => _mappedSentence(english, index, chinese.length)),
    ),
  );
}

List<int> _selectTextIndexes(List<String> source, int target) {
  if (target >= source.length) {
    return List<int>.generate(source.length, (index) => index, growable: false);
  }
  if (target <= 1) return const <int>[0];

  final selected = <int>{0, source.length - 1};
  while (selected.length < target) {
    int? best;
    var bestScore = -100000;
    for (var index = 1; index < source.length - 1; index += 1) {
      if (selected.contains(index)) continue;
      final score = (_turningPointPattern.hasMatch(source[index]) ? 8 : 0) +
          (_insightPattern.hasMatch(source[index]) ? 7 : 0) +
          selected
              .map((chosen) => (chosen - index).abs())
              .reduce((left, right) => left < right ? left : right);
      if (score > bestScore) {
        bestScore = score;
        best = index;
      }
    }
    if (best == null) break;
    selected.add(best);
  }
  final ordered = selected.toList()..sort();
  return ordered;
}

DiscoveryEntry _mergeDiscoveries(Iterable<DiscoveryEntry> source) {
  final entries = source.toList(growable: false);
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese: _joinChinese(entries.map((entry) => entry.simpleChinese)),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
  );
}

int _packetCharacterCount(Iterable<_NarrativePacket> packets) =>
    packets.fold(0, (total, item) => total + item.chinese.runes.length);

@visibleForTesting
List<int> selectNarrativeSentenceIndexesForTesting(
  List<String> sentences, {
  required int maximumSentences,
  required int maximumCharacters,
}) {
  final packets = <_NarrativePacket>[
    for (var index = 0; index < sentences.length; index += 1)
      _NarrativePacket(
        chinese: sentences[index],
        pinyin: sentences[index],
        vietnamese: sentences[index],
        english: sentences[index],
        paragraphIndex: index ~/ 2,
        sentenceIndex: index % 2,
      ),
  ];
  return _selectNarrativeIndexes(
    packets,
    maximumSentences: maximumSentences,
    maximumCharacters: maximumCharacters,
  );
}

@visibleForTesting
List<String> splitChineseNarrativeSentences(String value) {
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

String _mappedSentence(List<String> sentences, int index, int sourceLength) {
  if (sentences.isEmpty) return '';
  if (sentences.length == 1 || sourceLength <= 1) return sentences.first;
  final mapped =
      (index * (sentences.length - 1) / (sourceLength - 1))
          .round()
          .clamp(0, sentences.length - 1)
          .toInt();
  return sentences[mapped];
}

String _joinChinese(Iterable<String> values) {
  final output = <String>[];
  for (final value in values) {
    final text = value.trim();
    if (text.isEmpty || (output.isNotEmpty && output.last == text)) continue;
    output.add(text);
  }
  return output.join();
}

String _joinLatin(Iterable<String> values) {
  final output = <String>[];
  for (final value in values) {
    final text = value.trim();
    if (text.isEmpty || (output.isNotEmpty && output.last == text)) continue;
    output.add(text);
  }
  return output.join(' ');
}
