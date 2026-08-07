from pathlib import Path

path = Path('app/lib/data/forbidden_city_journey_runtime.dart')
text = path.read_text()
old = '''JourneyLevelContent forbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10);
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final discoveryStart = safeLevel <= 1 ? 0 : safeLevel - 2;
  final discoveryEnd = safeLevel.clamp(1, forbiddenCityDiscoveries.length);
  final selectedDiscoveries = forbiddenCityDiscoveries
      .sublist(discoveryStart, discoveryEnd)
      .take(2)
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: <String>[story],
    storyAnnotations: const <ReadingAnnotation>[
      ReadingAnnotation(pinyin: '', vietnamese: '', english: ''),
    ],
    words: forbiddenCityWordsForLevel(safeLevel),
    discoveries: selectedDiscoveries,
    wonderQuestion: '',
    expressQuestion: '',
  );
}
'''
new = '''List<String> forbiddenCityStoryReadingSegments(String story, int level) {
  final blocks = story.split('\\n\\n').where((block) => block.isNotEmpty).toList(growable: false);
  if (blocks.length <= 1) return blocks;

  final safeLevel = level.clamp(1, 10);
  final targetCharacters = (180 + safeLevel * 20).clamp(200, 380);
  final minimumBeforeBreak = (targetCharacters * .58).round();
  final segments = <String>[];
  var current = '';

  for (final block in blocks) {
    if (current.isEmpty) {
      current = block;
      continue;
    }
    final candidate = '$current\\n\\n$block';
    if (current.length >= minimumBeforeBreak && candidate.length > targetCharacters) {
      segments.add(current);
      current = block;
    } else {
      current = candidate;
    }
  }
  if (current.isNotEmpty) segments.add(current);
  return segments;
}

JourneyLevelContent forbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10);
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final storySegments = forbiddenCityStoryReadingSegments(story, safeLevel);
  final discoveryStart = safeLevel <= 1 ? 0 : safeLevel - 2;
  final discoveryEnd = safeLevel.clamp(1, forbiddenCityDiscoveries.length);
  final selectedDiscoveries = forbiddenCityDiscoveries
      .sublist(discoveryStart, discoveryEnd)
      .take(2)
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: storySegments,
    storyAnnotations: List<ReadingAnnotation>.filled(
      storySegments.length,
      const ReadingAnnotation(pinyin: '', vietnamese: '', english: ''),
      growable: false,
    ),
    words: forbiddenCityWordsForLevel(safeLevel),
    discoveries: selectedDiscoveries,
    wonderQuestion: '',
    expressQuestion: '',
  );
}
'''
if old not in text:
    raise SystemExit('target function not found')
text = text.replace(old, new, 1)
path.write_text(text)
print('Forbidden City reading segment binding patched')
