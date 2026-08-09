from pathlib import Path

path = Path('app/lib/data/extended_journey_catalog.dart')
text = path.read_text()
start = text.index('final chengduStoryParagraphs =')
end = text.index('const nanjingStoryParagraphs', start)
replacement = '''final chengduStoryParagraphs = chengduKuanzhaiOnePassLevels[4].storyParagraphs;
final chengduStoryAnnotations = chengduKuanzhaiOnePassLevels[4].storyAnnotations;
final chengduDiscoveries = chengduKuanzhaiOnePassDiscoveries;
final chengduWords = List<WordEntry>.unmodifiable(
  chengduKuanzhaiOnePassWords.where((entry) {
    final context = <String>[
      ...chengduStoryParagraphs,
      ...chengduDiscoveries.map((discovery) => discovery.text),
    ].join();
    return context.contains(entry.word);
  }),
);

'''
path.write_text(text[:start] + replacement + text[end:])

for helper in [
    '.github/workflows/chengdu-lv5-adapter-repair.yml',
    '.github/scripts/chengdu_lv5_adapter_repair.py',
]:
    helper_path = Path(helper)
    if helper_path.exists():
        helper_path.unlink()
