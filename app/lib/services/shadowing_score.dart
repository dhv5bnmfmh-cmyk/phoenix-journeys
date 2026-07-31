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

  double get recommendedPracticeRate {
    if (omittedCharacters >= 2 || completeness < 80) return .7;
    if (extraCharacters > 0 || accuracy < 88 || fluency < 90) return .9;
    return 1;
  }

  String get recommendedPracticeSpeed {
    if (recommendedPracticeRate == .7) return '慢速 0.7×';
    if (recommendedPracticeRate == .9) return '清晰 0.9×';
    return '原速 1.0×';
  }

  String get primaryWeakness {
    if (overall >= 90 &&
        accuracy >= 90 &&
        completeness >= 90 &&
        fluency >= 90 &&
        omittedCharacters == 0 &&
        extraCharacters == 0) {
      return '稳定自然度';
    }
    if (omittedCharacters > extraCharacters ||
        completeness <= math.min(accuracy, fluency)) {
      return '完整度';
    }
    if (extraCharacters > omittedCharacters ||
        accuracy <= math.min(completeness, fluency)) {
      return '准确度';
    }
    return '流利度';
  }

  String get retryPlan {
    switch (primaryWeakness) {
      case '完整度':
        return '先看红色提示逐字补齐，再分成短语完整朗读，最后合句跟读。';
      case '准确度':
        return '重新听示范，定位多读或错读位置，逐字修正后再完整跟读。';
      case '流利度':
        return '先跟随清晰节奏连续读两遍，减少停顿后再回到原速。';
      default:
        return '保持原速，继续注意自然停顿、重音和连读。';
    }
  }

  String get coaching {
    final metrics = '$diagnosisSummary。';
    final recommendation =
        '建议使用$recommendedPracticeSpeed，重点练习$primaryWeakness：$retryPlan';
    if (overall >= 90 && omittedCharacters == 0 && extraCharacters == 0) {
      return '$metrics $recommendation';
    }
    if (omittedCharacters > extraCharacters) {
      return '$metrics 漏读 $omittedCharacters 个字。$recommendation';
    }
    if (extraCharacters > omittedCharacters) {
      return '$metrics 多读或错读 $extraCharacters 个字。$recommendation';
    }
    return '$metrics $recommendation';
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
