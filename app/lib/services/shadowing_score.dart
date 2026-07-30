import 'dart:math' as math;

class ShadowingScore {
  const ShadowingScore({
    required this.overall,
    required this.completeness,
    required this.confidence,
    required this.matchedCharacters,
    required this.referenceCharacters,
  });

  final int overall;
  final int completeness;
  final int confidence;
  final int matchedCharacters;
  final int referenceCharacters;

  String get label {
    if (overall >= 90) return '非常自然';
    if (overall >= 75) return '完成得很好';
    if (overall >= 60) return '基本清楚';
    return '再跟读一次';
  }

  String get coaching {
    if (completeness >= 90) return '句子很完整，下一次可以更自然地连读。';
    if (completeness >= 70) return '再听一次示范，注意红色文字后重新跟读。';
    return '先放慢速度，分成短语读清楚，再尝试完整句子。';
  }
}

class ShadowingReferenceUnit {
  const ShadowingReferenceUnit({required this.text, required this.matched});

  final String text;
  final bool matched;
}

String normalizeShadowingText(String value) {
  return value
      .replaceAll(RegExp(r'[\s，。！？、；：“”‘’,.!?;:\-—（）()]'), '')
      .toLowerCase();
}

int _longestCommonSubsequence(List<int> left, List<int> right) {
  if (left.isEmpty || right.isEmpty) return 0;
  var previous = List<int>.filled(right.length + 1, 0);
  for (var i = 0; i < left.length; i++) {
    final current = List<int>.filled(right.length + 1, 0);
    for (var j = 0; j < right.length; j++) {
      current[j + 1] = left[i] == right[j]
          ? previous[j] + 1
          : math.max(previous[j + 1], current[j]);
    }
    previous = current;
  }
  return previous.last;
}

List<ShadowingReferenceUnit> buildShadowingReferenceFeedback({
  required String reference,
  required String recognized,
}) {
  final normalizedRecognized = normalizeShadowingText(recognized);
  final recognizedRunes = normalizedRecognized.runes.toList();
  final referenceUnits = reference.runes
      .map((rune) => String.fromCharCode(rune))
      .where(
        (unit) => normalizeShadowingText(unit).isNotEmpty,
      )
      .toList(growable: false);
  final referenceRunes = referenceUnits
      .map((unit) => normalizeShadowingText(unit).runes.single)
      .toList(growable: false);
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

  final matchedIndexes = <int>{};
  var i = referenceRunes.length;
  var j = recognizedRunes.length;
  while (i > 0 && j > 0) {
    if (referenceRunes[i - 1] == recognizedRunes[j - 1]) {
      matchedIndexes.add(i - 1);
      i -= 1;
      j -= 1;
    } else if (table[i - 1][j] >= table[i][j - 1]) {
      i -= 1;
    } else {
      j -= 1;
    }
  }

  return List.generate(
    referenceUnits.length,
    (index) => ShadowingReferenceUnit(
      text: referenceUnits[index],
      matched: matchedIndexes.contains(index),
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
      completeness: 0,
      confidence: 0,
      matchedCharacters: 0,
      referenceCharacters: 0,
    );
  }

  final matched = _longestCommonSubsequence(referenceRunes, recognizedRunes);
  final completeness = ((matched / referenceRunes.length) * 100).round();
  final safeConfidence = recognitionConfidence <= 0
      ? completeness
      : (recognitionConfidence.clamp(0.0, 1.0) * 100).round();
  final overall = (completeness * .78 + safeConfidence * .22).round();
  return ShadowingScore(
    overall: overall.clamp(0, 100),
    completeness: completeness.clamp(0, 100),
    confidence: safeConfidence.clamp(0, 100),
    matchedCharacters: matched,
    referenceCharacters: referenceRunes.length,
  );
}
