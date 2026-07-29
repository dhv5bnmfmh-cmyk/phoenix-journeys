enum NarrationStartupDecision { wait, confirmStarted, fail }

int narrationVoiceScore({
  required String name,
  required String locale,
  required String requestedLanguageCode,
  required bool localService,
}) {
  final normalizedName = name.toLowerCase();
  final normalizedLocale = locale.toLowerCase().replaceAll('_', '-');
  final requested = requestedLanguageCode.toLowerCase().replaceAll('_', '-');
  final requestedPrefix = requested.split('-').first;

  if (!normalizedLocale.startsWith(requestedPrefix)) return -10000;

  var score = 20;
  if (normalizedLocale == requested) {
    score += 140;
  } else if (normalizedLocale.startsWith('$requestedPrefix-')) {
    score += 45;
  }
  if (localService) score += 10;

  const premiumSignals = <String, int>{
    'natural': 100,
    'neural': 95,
    'premium': 85,
    'enhanced': 75,
    'online': 25,
  };
  for (final entry in premiumSignals.entries) {
    if (normalizedName.contains(entry.key)) score += entry.value;
  }

  const lowQualitySignals = <String, int>{
    'compact': 80,
    'novelty': 140,
    'espeak': 120,
    'festival': 100,
    'robot': 100,
  };
  for (final entry in lowQualitySignals.entries) {
    if (normalizedName.contains(entry.key)) score -= entry.value;
  }

  final preferredNames = switch (requested) {
    'zh-cn' => const <String>[
        'xiaoxiao',
        'yunxi',
        'yunyang',
        'huihui',
        'tingting',
        'putonghua',
        '普通话',
        'mandarin',
      ],
    'zh-tw' => const <String>[
        'hsiaochen',
        'hsiaoyu',
        'meijia',
        'sinji',
        '國語',
        '国语',
        'mandarin',
      ],
    'vi-vn' => const <String>['linh', 'mai', 'nam', 'hoai'],
    'en-us' => const <String>[
        'samantha',
        'ava',
        'serena',
        'daniel',
        'jenny',
        'guy',
      ],
    _ => const <String>[],
  };
  for (final preferredName in preferredNames) {
    if (normalizedName.contains(preferredName)) score += 55;
  }

  final requestedParts = requested.split('-');
  final localeParts = normalizedLocale.split('-');
  if (requestedParts.length > 1 &&
      localeParts.length > 1 &&
      requestedParts[1] != localeParts[1]) {
    score -= 35;
  }

  return score;
}

double resolveNaturalNarrationPitch(String languageCode) {
  final prefix = languageCode.toLowerCase().split(RegExp('[-_]')).first;
  return switch (prefix) {
    'zh' => .96,
    'vi' => .98,
    'en' => 1.0,
    _ => .98,
  };
}

double resolveNaturalNarrationRate({
  required String languageCode,
  required double requestedRate,
}) {
  final prefix = languageCode.toLowerCase().split(RegExp('[-_]')).first;
  final bounds = switch (prefix) {
    'zh' => (min: .50, max: 1.35),
    'vi' => (min: .55, max: 1.40),
    'en' => (min: .55, max: 1.45),
    _ => (min: .50, max: 1.45),
  };
  return requestedRate.clamp(bounds.min, bounds.max).toDouble();
}

NarrationStartupDecision resolveNarrationStartupDecision({
  required bool startObserved,
  required bool synthesisSpeaking,
  required bool synthesisPending,
  required bool finalCheck,
}) {
  if (startObserved || synthesisSpeaking) {
    return NarrationStartupDecision.confirmStarted;
  }
  if (synthesisPending && !finalCheck) {
    return NarrationStartupDecision.wait;
  }
  return finalCheck
      ? NarrationStartupDecision.fail
      : NarrationStartupDecision.wait;
}
