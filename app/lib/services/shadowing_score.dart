import 'dart:math' as math;

class ShadowingScore {
  const ShadowingScore({
    required this.overall,
    required this.accuracy,
    required this.completeness,
    required this.fluency,
    required this.confidence,
    required this.matchedCharacters,
    required this.referenceCharacters,
    required this.recognizedCharacters,
    required this.omittedCharacters,
    required this.extraCharacters,
  });

  final int overall;
  final int accuracy;
  final int completeness;
  final int fluency;
  final int confidence;
  final int matchedCharacters;
  final int referenceCharacters;
  final int recognizedCharacters;
  final int omittedCharacters;
  final int extraCharacters;

  String get label {
    if (overall >= 90) return '非常自然';
    if (overall >= 75) return '完成得很好';
    if (overall >= 60) return '基本清楚';
    return '再跟读一次';
  }

  String get diagnosisSummary =>
      '准确度 $accuracy% · 完整度 $completeness% · 流利度 $fluency%';

  String get coaching {
    final metrics = '$diagnosisSummary。';
    if (overall >= 90 && omittedCharacters == 0 && extraCharacters == 0) {
      return '$metrics 三项表现稳定，下一次保持自然停顿和连读。';
    }
    if (omittedCharacters > extraCharacters) {
      return '$metrics 漏读 $omittedCharacters 个字，注意红色文字，先分短语读清楚再完整跟读。';
    }
    if (extraCharacters > omittedCharacters) {
      return '$metrics 多读或错读 $extraCharacters 个字，重新听本句后放慢速度对照练习。';
    }
    if (fluency < 70) {
      return '$metrics 内容基本到位，建议使用清晰语速，减少停顿后再读一次。';
    }
    if (accuracy < 80) {
      return '$metrics 注意红色文字，逐字修正后再尝试自然连读。';
    }
    return '$metrics 已接近示范，下一次把节奏读得更连贯。';
  }
}

class ShadowingReferenceUnit {
  const ShadowingReferenceUnit({required this.text, required this.matched});

  final String text;
  final bool matched;
}

class _ShadowingAlignment {
  const _ShadowingAlignment({
    required this.matchedReferenceIndexes,
    required this.matchedRecognizedIndexes,
    required this.longestContinuousRun,
  });

  final Set<int> matchedReferenceIndexes;
  final Set<int> matchedRecognizedIndexes;
  final int longestContinuousRun;

  int get matchedCharacters => matchedReferenceIndexes.length;
}

String normalizeShadowingText(String value) {
  return value
      .replaceAll(RegExp(r'[\s，。！？、；：“”‘’,.!?;:\-—（）()]'), '')
      .toLowerCase();
}

_ShadowingAlignment _alignShadowingText(
  List<int> referenceRunes,
  List<int> recognizedRunes,
) {
  final table = List.generate(
    referenceRunes.length + 1,
    (_) => List<int>.filled(recognizedRunes.length + 1, 0),
  );

  for (var i = 1; i <= referenceRunes.length; i += 1) {
    for (var j = 1; j <= recognizedRunes.length; j += 1) {
      table[i][j] = referenceRunes[i - 1] == recognizedRunes[j - 1]
          ? table[i - 1][j - 1] + 1
          : math.max(table[i - 1][j], table[i][j - 1]);
    }
  }

  final matchedPairs = <(int, int)>[];
  var i = referenceRunes.length;
  var j = recognizedRunes.length;
  while (i > 0 && j > 0) {
    if (referenceRunes[i - 1] == recognizedRunes[j - 1]) {
      matchedPairs.add((i - 1, j - 1));
      i -= 1;
      j -= 1;
    } else if (table[i - 1][j] >= table[i][j - 1]) {
      i -= 1;
    } else {
      j -= 1;
    }
  }

  final orderedPairs = matchedPairs.reversed.toList(growable: false);
  var longestRun = 0;
  var currentRun = 0;
  (int, int)? previous;
  for (final pair in orderedPairs) {
    if (previous != null &&
        pair.$1 == previous.$1 + 1 &&
        pair.$2 == previous.$2 + 1) {
      currentRun += 1;
    } else {
      currentRun = 1;
    }
    longestRun = math.max(longestRun, currentRun);
    previous = pair;
  }

  return _ShadowingAlignment(
    matchedReferenceIndexes: orderedPairs.map((pair) => pair.$1).toSet(),
    matchedRecognizedIndexes: orderedPairs.map((pair) => pair.$2).toSet(),
    longestContinuousRun: longestRun,
  );
}

List<ShadowingReferenceUnit> buildShadowingReferenceFeedback({
  required String reference,
  required String recognized,
}) {
  final normalizedRecognized = normalizeShadowingText(recognized);
  final recognizedRunes = normalizedRecognized.runes.toList();
  final referenceUnits = reference.runes
      .map((rune) => String.fromCharCode(rune))
      .where((unit) => normalizeShadowingText(unit).isNotEmpty)
      .toList(growable: false);
  final referenceRunes = referenceUnits
      .map((unit) => normalizeShadowingText(unit).runes.single)
      .toList(growable: false);
  final alignment = _alignShadowingText(referenceRunes, recognizedRunes);

  return List.generate(
    referenceUnits.length,
    (index) => ShadowingReferenceUnit(
      text: referenceUnits[index],
      matched: alignment.matchedReferenceIndexes.contains(index),
    ),
    growable: false,
  );
}

int averageShadowingSessionScore({
  required Iterable<int> sentenceScores,
  required int sentenceCount,
}) {
  if (sentenceCount <= 0) return 0;
  final scores = sentenceScores.toList(growable: false);
  final total = scores.fold<int>(
    0,
    (sum, score) => sum + score.clamp(0, 100),
  );
  return (total / sentenceCount).round().clamp(0, 100);
}

ShadowingScore scoreShadowing({
  required String reference,
  required String recognized,
  double recognitionConfidence = 0,
}) {
  final referenceRunes = normalizeShadowingText(reference).runes.toList();
  final recognizedRunes = normalizeShadowingText(recognized).runes.toList();
  if (referenceRunes.isEmpty) {
    return const ShadowingScore(
      overall: 0,
      accuracy: 0,
      completeness: 0,
      fluency: 0,
      confidence: 0,
      matchedCharacters: 0,
      referenceCharacters: 0,
      recognizedCharacters: 0,
      omittedCharacters: 0,
      extraCharacters: 0,
    );
  }

  final alignment = _alignShadowingText(referenceRunes, recognizedRunes);
  final matched = alignment.matchedCharacters;
  final completeness = ((matched / referenceRunes.length) * 100).round();
  final accuracy = recognizedRunes.isEmpty
      ? 0
      : ((matched / recognizedRunes.length) * 100).round();
  final fallbackConfidence = ((accuracy + completeness) / 2).round();
  final safeConfidence = recognitionConfidence <= 0
      ? fallbackConfidence
      : (recognitionConfidence.clamp(0.0, 1.0) * 100).round();
  final longestLength = math.max(referenceRunes.length, recognizedRunes.length);
  final shortestLength = math.min(referenceRunes.length, recognizedRunes.length);
  final lengthBalance = longestLength == 0
      ? 0
      : ((shortestLength / longestLength) * 100).round();
  final continuity = matched == 0
      ? 0
      : ((alignment.longestContinuousRun / matched) * 100).round();
  final fluency = (
    lengthBalance * .45 +
    continuity * .30 +
    safeConfidence * .25
  ).round();
  final overall = (
    accuracy * .40 +
    completeness * .35 +
    fluency * .25
  ).round();

  return ShadowingScore(
    overall: overall.clamp(0, 100),
    accuracy: accuracy.clamp(0, 100),
    completeness: completeness.clamp(0, 100),
    fluency: fluency.clamp(0, 100),
    confidence: safeConfidence.clamp(0, 100),
    matchedCharacters: matched,
    referenceCharacters: referenceRunes.length,
    recognizedCharacters: recognizedRunes.length,
    omittedCharacters: (referenceRunes.length - matched).clamp(0, 1000000),
    extraCharacters: (recognizedRunes.length - matched).clamp(0, 1000000),
  );
}
