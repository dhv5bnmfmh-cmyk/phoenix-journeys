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
      final leftDelta = (challengeTextLength(left.value) - targetLength).abs();
      final rightDelta = (challengeTextLength(right.value) - targetLength).abs();
      final byLength = leftDelta.compareTo(rightDelta);
      return byLength != 0 ? byLength : left.key.compareTo(right.key);
    });
  return ranked
      .take(count)
      .map((entry) => entry.value)
      .toList(growable: false);
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
