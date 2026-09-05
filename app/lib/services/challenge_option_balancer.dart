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

/// Returns the stable correct-answer positions for one rendered multiple-choice
/// window. Content is authored first; this helper changes presentation position
/// only.
///
/// The returned schedule guarantees:
/// - deterministic output for the same inputs;
/// - per-position counts whose max/min difference is at most one;
/// - no correct position repeated more than [maxStreak] times;
/// - no simple repeated A/B/C/D cycle for windows long enough to expose one.
///
/// [variationOrdinal] lets adjacent levels use different four-item
/// permutations without introducing runtime randomness. [previousPositions]
/// carries the preceding rendered choice positions so streak and simple-cycle
/// limits also hold across a family boundary.
@visibleForTesting
List<int> balancedChallengeAnswerPositions({
  required int itemCount,
  required String seed,
  int optionCount = 4,
  int variationOrdinal = 0,
  int maxStreak = 2,
  List<int> previousPositions = const <int>[],
}) {
  if (itemCount < 0) {
    throw ArgumentError.value(itemCount, 'itemCount', 'must be non-negative');
  }
  if (optionCount < 2) {
    throw ArgumentError.value(optionCount, 'optionCount', 'must be at least 2');
  }
  if (maxStreak < 1) {
    throw ArgumentError.value(maxStreak, 'maxStreak', 'must be at least 1');
  }
  if (itemCount == 0) return const <int>[];
  if (previousPositions.any((position) =>
      position < 0 || position >= optionCount)) {
    throw ArgumentError.value(
      previousPositions,
      'previousPositions',
      'contains an invalid option position',
    );
  }

  if (itemCount == 4 && optionCount == 4) {
    final forbiddenFirst = _forbiddenFirstPosition(
      previousPositions,
      maxStreak: maxStreak,
    );
    final previousFour = previousPositions.length < 4
        ? null
        : previousPositions.sublist(previousPositions.length - 4);
    for (var attempt = 0; attempt < 24; attempt += 1) {
      final candidate = _fourPositionPermutation(
        seed,
        variationOrdinal + attempt,
      );
      if (candidate.first == forbiddenFirst) continue;
      if (previousFour != null && _samePositions(candidate, previousFour)) {
        continue;
      }
      return List<int>.unmodifiable(candidate);
    }
    throw StateError('Unable to build a valid four-position permutation.');
  }

  final baseCount = itemCount ~/ optionCount;
  final remainder = itemCount % optionCount;
  final targetCounts = List<int>.filled(optionCount, baseCount);
  final extraPositions = _stableShuffle<int>(
    List<int>.generate(optionCount, (index) => index),
    '$seed:extras:$variationOrdinal',
  );
  for (final position in extraPositions.take(remainder)) {
    targetCounts[position] += 1;
  }

  final bag = <int>[];
  for (var position = 0; position < optionCount; position += 1) {
    bag.addAll(List<int>.filled(targetCounts[position], position));
  }
  var result = _stableShuffle<int>(
    bag,
    '$seed:order:$variationOrdinal',
  );

  final prefix = previousPositions.length <= maxStreak
      ? List<int>.of(previousPositions)
      : previousPositions.sublist(previousPositions.length - maxStreak);

  for (var index = 0; index < result.length; index += 1) {
    if (_endingRun(<int>[...prefix, ...result.take(index + 1)]) <=
        maxStreak) {
      continue;
    }
    final swapCandidates = <int>[
      for (var candidate = index + 1;
          candidate < result.length;
          candidate += 1)
        if (result[candidate] != result[index]) candidate,
    ];
    final orderedCandidates = _stableShuffle<int>(
      swapCandidates,
      '$seed:streak-repair:$variationOrdinal:$index',
    );
    var repaired = false;
    for (final candidate in orderedCandidates) {
      final trial = List<int>.of(result);
      final value = trial[index];
      trial[index] = trial[candidate];
      trial[candidate] = value;
      if (_endingRun(<int>[...prefix, ...trial.take(index + 1)]) <=
          maxStreak) {
        result = trial;
        repaired = true;
        break;
      }
    }
    if (!repaired) {
      throw StateError('Unable to satisfy multiple-choice streak contract.');
    }
  }

  if (_maxPositionStreak(<int>[...prefix, ...result]) > maxStreak) {
    throw StateError('Multiple-choice streak contract was not satisfied.');
  }

  if (_hasSimplePositionCycle(result, optionCount)) {
    var cycleBroken = false;
    for (var left = optionCount;
        left < result.length && !cycleBroken;
        left += 1) {
      for (var right = left + 1; right < result.length; right += 1) {
        if (result[left] == result[right]) continue;
        final trial = List<int>.of(result);
        final value = trial[left];
        trial[left] = trial[right];
        trial[right] = value;
        if (_maxPositionStreak(<int>[...prefix, ...trial]) <= maxStreak &&
            !_hasSimplePositionCycle(trial, optionCount)) {
          result = trial;
          cycleBroken = true;
          break;
        }
      }
    }
    if (!cycleBroken) {
      throw StateError('Unable to break a mechanical answer-position cycle.');
    }
  }

  final actualCounts = List<int>.filled(optionCount, 0);
  for (final position in result) {
    actualCounts[position] += 1;
  }
  final sortedCounts = List<int>.of(actualCounts)..sort();
  if (sortedCounts.last - sortedCounts.first > 1) {
    throw StateError('Multiple-choice balance contract was not satisfied.');
  }

  return List<int>.unmodifiable(result);
}

int? _forbiddenFirstPosition(
  List<int> previousPositions, {
  required int maxStreak,
}) {
  if (previousPositions.length < maxStreak) return null;
  final tail = previousPositions.sublist(previousPositions.length - maxStreak);
  return tail.every((position) => position == tail.first) ? tail.first : null;
}

bool _samePositions(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

List<int> _fourPositionPermutation(String seed, int variationOrdinal) {
  var rank = (_stableSeedHash(seed) + variationOrdinal * 5) % 24;
  final remaining = <int>[0, 1, 2, 3];
  final result = <int>[];
  const factorials = <int>[6, 2, 1, 1];
  for (var index = 0; index < 4; index += 1) {
    final factorial = factorials[index];
    final selected = rank ~/ factorial;
    rank %= factorial;
    result.add(remaining.removeAt(selected));
  }
  return result;
}

List<T> _stableShuffle<T>(List<T> values, String seed) {
  final result = List<T>.of(values);
  var state = _stableSeedHash(seed);
  for (var index = result.length - 1; index > 0; index -= 1) {
    state = (state * 1664525 + 1013904223) & 0xffffffff;
    final swap = state % (index + 1);
    final value = result[index];
    result[index] = result[swap];
    result[swap] = value;
  }
  return result;
}

int _stableSeedHash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash;
}

int _endingRun(List<int> positions) {
  if (positions.isEmpty) return 0;
  final last = positions.last;
  var run = 0;
  for (var index = positions.length - 1; index >= 0; index -= 1) {
    if (positions[index] != last) break;
    run += 1;
  }
  return run;
}

int _maxPositionStreak(List<int> positions) {
  var longest = 0;
  var current = 0;
  int? previous;
  for (final position in positions) {
    if (position == previous) {
      current += 1;
    } else {
      previous = position;
      current = 1;
    }
    if (current > longest) longest = current;
  }
  return longest;
}

bool _hasSimplePositionCycle(List<int> positions, int period) {
  if (positions.length < period * 2) return false;
  for (var index = period; index < positions.length; index += 1) {
    if (positions[index] != positions[index % period]) return false;
  }
  return true;
}
