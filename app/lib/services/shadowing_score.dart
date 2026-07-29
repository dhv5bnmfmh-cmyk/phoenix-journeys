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
