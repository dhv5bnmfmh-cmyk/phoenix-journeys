import '../data/journey_data.dart';
import '../data/journey_level_catalog.dart';
import '../data/special_journey_expansion_batch_one_enrichment.dart';
import '../data/special_journey_story_enrichment.dart';
import '../models/language_proficiency.dart';
import 'phoenix_story_length_policy.dart';

class _SpecialStoryPacket {
  const _SpecialStoryPacket({
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

JourneyLevelContent expandSpecialJourneyStoryToTarget(
  String journeyId,
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  final source = _packetsFromContent(content);
  final enrichment = <SpecialJourneyEnrichmentText>[
    ...specialJourneyStoryEnrichmentFor(journeyId),
    ...specialJourneyExpansionBatchOneEnrichmentFor(journeyId),
  ]
      .map(
        (item) => _SpecialStoryPacket(
          chinese: item.chinese,
          pinyin: item.pinyin,
          vietnamese: item.vietnamese,
          english: item.english,
        ),
      )
      .toList(growable: false);
  if (source.isEmpty || enrichment.isEmpty) return content;

  final target = phoenixStoryLengthTargetFor(profile);
  final opening = source.first;
  final closing = source.length > 1 ? source.last : null;
  final middle = source.length > 2
      ? source.sublist(1, source.length - 1)
      : const <_SpecialStoryPacket>[];
  final selected = <_SpecialStoryPacket>[opening];
  final candidates = <_SpecialStoryPacket>[...middle, ...enrichment];

  for (final packet in candidates) {
    final projected = _characterCount(selected) +
        packet.chinese.runes.length +
        (closing?.chinese.runes.length ?? 0);
    if (projected > target.maximumCharacters) continue;
    selected.add(packet);
    if (projected >= target.preferredCharacters) break;
  }

  if (closing != null) selected.add(closing);

  if (_characterCount(selected) < target.minimumCharacters) {
    final used = selected.map((item) => item.chinese).toSet();
    final insertionIndex = closing == null ? selected.length : selected.length - 1;
    for (final packet in enrichment) {
      if (used.contains(packet.chinese)) continue;
      final projected = _characterCount(selected) + packet.chinese.runes.length;
      if (projected > target.maximumCharacters) continue;
      selected.insert(insertionIndex, packet);
      used.add(packet.chinese);
      if (_characterCount(selected) >= target.minimumCharacters) break;
    }
  }

  final groups = _partition(selected, target.paragraphCount);
  return JourneyLevelContent(
    storyParagraphs: groups
        .map((group) => _joinChinese(group.map((item) => item.chinese)))
        .toList(growable: false),
    storyAnnotations: groups
        .map(
          (group) => ReadingAnnotation(
            pinyin: _joinLatin(group.map((item) => item.pinyin)),
            vietnamese: _joinLatin(group.map((item) => item.vietnamese)),
            english: _joinLatin(group.map((item) => item.english)),
          ),
        )
        .toList(growable: false),
    words: content.words,
    discoveries: content.discoveries,
    wonderQuestion: content.wonderQuestion,
    expressQuestion: content.expressQuestion,
  );
}

List<_SpecialStoryPacket> _packetsFromContent(JourneyLevelContent content) {
  final packets = <_SpecialStoryPacket>[];
  for (var paragraphIndex = 0;
      paragraphIndex < content.storyParagraphs.length;
      paragraphIndex += 1) {
    final chinese = _splitChinese(content.storyParagraphs[paragraphIndex]);
    if (chinese.isEmpty) continue;
    final annotation = content.storyAnnotations[
      paragraphIndex.clamp(0, content.storyAnnotations.length - 1).toInt()
    ];
    final pinyin = _splitLatin(annotation.pinyin);
    final vietnamese = _splitLatin(annotation.vietnamese);
    final english = _splitLatin(annotation.english);

    for (var index = 0; index < chinese.length; index += 1) {
      packets.add(
        _SpecialStoryPacket(
          chinese: chinese[index],
          pinyin: _mappedSentence(pinyin, index, chinese.length),
          vietnamese: _mappedSentence(vietnamese, index, chinese.length),
          english: _mappedSentence(english, index, chinese.length),
        ),
      );
    }
  }
  return packets;
}

String _mappedSentence(List<String> source, int index, int targetLength) {
  if (source.isEmpty) return '';
  if (source.length == 1 || targetLength <= 1) return source.first;
  final mapped = (index * source.length / targetLength)
      .floor()
      .clamp(0, source.length - 1)
      .toInt();
  return source[mapped];
}

List<List<_SpecialStoryPacket>> _partition(
  List<_SpecialStoryPacket> packets,
  int paragraphCount,
) {
  if (paragraphCount <= 1 || packets.length <= 1) {
    return <List<_SpecialStoryPacket>>[packets];
  }

  var bestSplit = 1;
  var bestScore = 1 << 30;
  final total = _characterCount(packets);
  var leftCharacters = 0;
  for (var split = 1; split < packets.length; split += 1) {
    leftCharacters += packets[split - 1].chinese.runes.length;
    final balance = (leftCharacters * 2 - total).abs();
    final dependentPenalty = _startsWithDependentReference(
      packets[split].chinese,
    )
        ? 1000
        : 0;
    final score = balance + dependentPenalty;
    if (score < bestScore) {
      bestScore = score;
      bestSplit = split;
    }
  }

  return <List<_SpecialStoryPacket>>[
    packets.take(bestSplit).toList(growable: false),
    packets.skip(bestSplit).toList(growable: false),
  ];
}

int _characterCount(Iterable<_SpecialStoryPacket> packets) => packets.fold(
      0,
      (total, packet) => total + packet.chinese.runes.length,
    );

bool _startsWithDependentReference(String value) => RegExp(
      r'^(它|他|她|他们|她们|这|那|因此|于是|所以|然而|但是|但|同时|其中|此时|后来|随后|最后|而且|也|其|这种|这些|这里|那里)',
    ).hasMatch(value.trim());

List<String> _splitChinese(String value) => RegExp(r'[^。！？!?]+[。！？!?]?')
    .allMatches(value.trim())
    .map((match) => match.group(0)?.trim() ?? '')
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

List<String> _splitLatin(String value) => RegExp(r'[^.!?]+[.!?]?')
    .allMatches(value.trim())
    .map((match) => match.group(0)?.trim() ?? '')
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

String _joinChinese(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join(' ');
