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
    required this.wrongCharacters,
    required this.extraCharacters,
    this.attemptDelta,
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
  final int wrongCharacters;
  final int extraCharacters;
  final ShadowingAttemptDelta? attemptDelta;

  String get label {
    if (overall >= 90) return '非常自然';
    if (overall >= 75) return '完成得很好';
    if (overall >= 60) return '基本清楚';
    return '再跟读一次';
  }

  String get diagnosisSummary =>
      '准确度 $accuracy% · 完整度 $completeness% · 流利度 $fluency%';

  String get issueSummary =>
      '漏读 $omittedCharacters · 错读 $wrongCharacters · 多读 $extraCharacters';

  String get weakestMetric {
    final metrics = <(String, int)>[
      ('准确度', accuracy),
      ('完整度', completeness),
      ('流利度', fluency),
    ]..sort((left, right) => left.$2.compareTo(right.$2));
    return metrics.first.$1;
  }

  double get recommendedPracticeRate {
    switch (weakestMetric) {
      case '准确度':
        return .7;
      case '完整度':
        return .9;
      case '流利度':
        return 1;
    }
    return .9;
  }

  String get recommendedPracticeRateLabel {
    switch (weakestMetric) {
      case '准确度':
        return '慢速 0.7×';
      case '完整度':
        return '清晰 0.9×';
      case '流利度':
        return '原速 1.0×';
    }
    return '清晰 0.9×';
  }

  String get focusedPracticePlan {
    switch (weakestMetric) {
      case '准确度':
        return '$recommendedPracticeRateLabel，先逐字修正红色文字，再把整句自然连起来。';
      case '完整度':
        return '$recommendedPracticeRateLabel，按短语完整读完，句末不要提前停。';
      case '流利度':
        return '$recommendedPracticeRateLabel，跟随示范连续朗读，减少中途停顿。';
    }
    return '$recommendedPracticeRateLabel，听一句、跟一句，再完整复读。';
  }

  String _withAttemptProgress(String message) {
    final delta = attemptDelta;
    return delta == null ? message : '$message ${delta.summary}';
  }

  String get coaching {
    final metrics = '$diagnosisSummary。';
    final adaptivePlan = '智能复练：$focusedPracticePlan';
    if (overall >= 90 &&
        accuracy >= 90 &&
        completeness >= 90 &&
        fluency >= 90 &&
        omittedCharacters == 0 &&
        wrongCharacters == 0 &&
        extraCharacters == 0) {
      return _withAttemptProgress(
        '$metrics 三项表现稳定，保持原速 1.0×，继续练自然停顿和连读。',
      );
    }
    if (omittedCharacters >= wrongCharacters &&
        omittedCharacters >= extraCharacters &&
        omittedCharacters > 0) {
      return _withAttemptProgress(
        '$metrics 漏读 $omittedCharacters 个字，注意红色文字。$adaptivePlan',
      );
    }
    if (wrongCharacters >= extraCharacters && wrongCharacters > 0) {
      return _withAttemptProgress(
        '$metrics 错读 $wrongCharacters 个字，逐字对照红色提示。$adaptivePlan',
      );
    }
    if (extraCharacters > 0) {
      return _withAttemptProgress(
        '$metrics 多读 $extraCharacters 个字，避免重复或加入多余内容。$adaptivePlan',
      );
    }
    if (fluency < 70) {
      return _withAttemptProgress(
        '$metrics 内容基本到位，但停顿较多。$adaptivePlan',
      );
    }
    if (accuracy < 80) {
      return _withAttemptProgress(
        '$metrics 注意红色文字，先修正发音。$adaptivePlan',
      );
    }
    return _withAttemptProgress('$metrics 已接近示范。$adaptivePlan');
  }

  ShadowingScore withAttemptDelta(ShadowingAttemptDelta? delta) {
    return ShadowingScore(
      overall: overall,
      accuracy: accuracy,
      completeness: completeness,
      fluency: fluency,
      confidence: confidence,
      matchedCharacters: matchedCharacters,
      referenceCharacters: referenceCharacters,
      recognizedCharacters: recognizedCharacters,
      omittedCharacters: omittedCharacters,
      wrongCharacters: wrongCharacters,
      extraCharacters: extraCharacters,
      attemptDelta: delta,
    );
  }
}

class ShadowingAttemptDelta {
  const ShadowingAttemptDelta({
    required this.overall,
    required this.accuracy,
    required this.completeness,
    required this.fluency,
  });

  final int overall;
  final int accuracy;
  final int completeness;
  final int fluency;

  bool get improved => overall > 0;
  bool get unchanged =>
      overall == 0 && accuracy == 0 && completeness == 0 && fluency == 0;

  String get strongestImprovement {
    final metrics = <(String, int)>[
      ('准确度', accuracy),
      ('完整度', completeness),
      ('流利度', fluency),
    ]..sort((left, right) => right.$2.compareTo(left.$2));
    return metrics.first.$1;
  }

  String get summary {
    if (unchanged) return '与上次表现持平。';
    if (overall > 0) {
      return '比上次提升 $overall 分，本次进步最大的是$strongestImprovement。';
    }
    return '比上次下降 ${overall.abs()} 分，先稳住节奏再试一次。';
  }
}

ShadowingAttemptDelta compareShadowingAttempts({
  required ShadowingScore previous,
  required ShadowingScore current,
}) {
  return ShadowingAttemptDelta(
    overall: current.overall - previous.overall,
    accuracy: current.accuracy - previous.accuracy,
    completeness: current.completeness - previous.completeness,
    fluency: current.fluency - previous.fluency,
  );
}

String? _previousShadowingReference;
ShadowingScore? _previousShadowingScore;

void resetShadowingAttemptProgress() {
  _previousShadowingReference = null;
  _previousShadowingScore = null;
}

ShadowingScore _recordShadowingAttempt({
  required String reference,
  required ShadowingScore score,
}) {
  final referenceKey = normalizeShadowingText(reference);
  final previous = _previousShadowingReference == referenceKey
      ? _previousShadowingScore
      : null;
  final delta = previous == null
      ? null
      : compareShadowingAttempts(previous: previous, current: score);
  _previousShadowingReference = referenceKey;
  _previousShadowingScore = score;
  return score.withAttemptDelta(delta);
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
    required this.omittedCharacters,
    required this.wrongCharacters,
    required this.extraCharacters,
  });

  final Set<int> matchedReferenceIndexes;
  final Set<int> matchedRecognizedIndexes;
  final int longestContinuousRun;
  final int omittedCharacters;
  final int wrongCharacters;
  final int extraCharacters;

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
    (row) => List<int>.generate(
      recognizedRunes.length + 1,
      (column) => row == 0 ? column : column == 0 ? row : 0,
    ),
  );

  for (var i = 1; i <= referenceRunes.length; i += 1) {
    for (var j = 1; j <= recognizedRunes.length; j += 1) {
      final substitutionCost =
          referenceRunes[i - 1] == recognizedRunes[j - 1] ? 0 : 1;
      table[i][j] = math.min(
        table[i - 1][j - 1] + substitutionCost,
        math.min(table[i - 1][j] + 1, table[i][j - 1] + 1),
      );
    }
  }

  final matchedPairs = <(int, int)>[];
  var omittedCharacters = 0;
  var wrongCharacters = 0;
  var extraCharacters = 0;
  var i = referenceRunes.length;
  var j = recognizedRunes.length;

  while (i > 0 || j > 0) {
    if (i > 0 &&
        j > 0 &&
        referenceRunes[i - 1] == recognizedRunes[j - 1] &&
        table[i][j] == table[i - 1][j - 1]) {
      matchedPairs.add((i - 1, j - 1));
      i -= 1;
      j -= 1;
      continue;
    }

    if (i > 0 &&
        j > 0 &&
        table[i][j] == table[i - 1][j - 1] + 1) {
      wrongCharacters += 1;
      i -= 1;
      j -= 1;
      continue;
    }

    if (i > 0 && table[i][j] == table[i - 1][j] + 1) {
      omittedCharacters += 1;
      i -= 1;
      continue;
    }

    if (j > 0) {
      extraCharacters += 1;
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
    omittedCharacters: omittedCharacters,
    wrongCharacters: wrongCharacters,
    extraCharacters: extraCharacters,
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
      wrongCharacters: 0,
      extraCharacters: 0,
    );
  }

  final alignment = _alignShadowingText(referenceRunes, recognizedRunes);
  final matched = alignment.matchedCharacters;
  final attemptedReferenceCharacters = matched + alignment.wrongCharacters;
  final accuracyDenominator =
      matched + alignment.wrongCharacters + alignment.extraCharacters;
  final completeness =
      ((attemptedReferenceCharacters / referenceRunes.length) * 100).round();
  final accuracy = accuracyDenominator == 0
      ? 0
      : ((matched / accuracyDenominator) * 100).round();
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

  final score = ShadowingScore(
    overall: overall.clamp(0, 100),
    accuracy: accuracy.clamp(0, 100),
    completeness: completeness.clamp(0, 100),
    fluency: fluency.clamp(0, 100),
    confidence: safeConfidence.clamp(0, 100),
    matchedCharacters: matched,
    referenceCharacters: referenceRunes.length,
    recognizedCharacters: recognizedRunes.length,
    omittedCharacters: alignment.omittedCharacters,
    wrongCharacters: alignment.wrongCharacters,
    extraCharacters: alignment.extraCharacters,
  );
  return _recordShadowingAttempt(reference: reference, score: score);
}
