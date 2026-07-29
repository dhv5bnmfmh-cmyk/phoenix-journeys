import 'package:flutter/foundation.dart';

List<String> selectBalancedChallengeDistractors({
  required Iterable<String> correctAnswers,
  required Iterable<String> candidates,
  required int count,
}) {
  final correct = correctAnswers
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);
  if (correct.isEmpty) {
    throw StateError('Challenge requires at least one correct answer.');
  }

  final correctSet = correct.toSet();
  final targetLength =
      (correct.fold<int>(0, (sum, value) => sum + challengeTextLength(value)) /
              correct.length)
          .round();
  final uniqueCandidates = <String>[];
  for (final candidate in candidates) {
    final value = candidate.trim();
    if (value.isEmpty ||
        correctSet.contains(value) ||
        uniqueCandidates.contains(value)) {
      continue;
    }
    uniqueCandidates.add(value);
  }
  if (uniqueCandidates.length < count) {
    throw StateError('Challenge requires $count unique distractors.');
  }

  final ranked = uniqueCandidates.asMap().entries.toList()
    ..sort((left, right) {
      final leftScore = _distractorPlausibilityScore(
        left.value,
        correct: correct,
        targetLength: targetLength,
      );
      final rightScore = _distractorPlausibilityScore(
        right.value,
        correct: correct,
        targetLength: targetLength,
      );
      final byPlausibility = leftScore.compareTo(rightScore);
      return byPlausibility != 0
          ? byPlausibility
          : left.key.compareTo(right.key);
    });
  return ranked
      .take(count)
      .map((entry) => entry.value)
      .toList(growable: false);
}

int _distractorPlausibilityScore(
  String candidate, {
  required List<String> correct,
  required int targetLength,
}) {
  final lengthDelta = (challengeTextLength(candidate) - targetLength).abs();
  final similarity = correct
      .map((answer) => challengeKeywordOverlap(candidate, answer))
      .fold<double>(0, (best, value) => value > best ? value : best);
  const idealOverlap = .5;
  final overlapDelta = (similarity - idealOverlap).abs();
  return (lengthDelta * 12 + overlapDelta * 100).round();
}

@visibleForTesting
double challengeKeywordOverlap(String left, String right) {
  final leftKeywords = _challengeKeywords(left);
  final rightKeywords = _challengeKeywords(right);
  if (leftKeywords.isEmpty || rightKeywords.isEmpty) return 0;
  final shared = leftKeywords.intersection(rightKeywords).length;
  final union = leftKeywords.union(rightKeywords).length;
  return union == 0 ? 0 : shared / union;
}

Set<int> _challengeKeywords(String value) {
  const ignored = <int>{
    0x3002,
    0xff0c,
    0xff1a,
    0xff1b,
    0xff01,
    0xff1f,
    0x201c,
    0x201d,
    0x2018,
    0x2019,
  };
  return value.runes
      .where((rune) => !ignored.contains(rune) && rune > 0x20)
      .toSet();
}

@visibleForTesting
int challengeOptionLengthSpread(Iterable<String> values) {
  final lengths = values
      .map(challengeTextLength)
      .where((length) => length > 0)
      .toList(growable: false);
  if (lengths.length < 2) return 0;
  lengths.sort();
  return lengths.last - lengths.first;
}

@visibleForTesting
int challengeTextLength(String value) =>
    value.replaceAll(RegExp(r'\s+'), '').runes.length;
