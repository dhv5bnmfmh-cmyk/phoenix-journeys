import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

class EditorialStoryRevision {
  const EditorialStoryRevision({
    required this.id,
    required this.protagonist,
    required this.narrativeMode,
    required this.emotionalArc,
    required this.endingMode,
    required this.sections,
    required this.annotations,
    required this.wonderQuestion,
    required this.expressQuestion,
  });

  final String id;
  final String protagonist;
  final String narrativeMode;
  final String emotionalArc;
  final String endingMode;
  final List<String> sections;
  final List<ReadingAnnotation> annotations;
  final String wonderQuestion;
  final String expressQuestion;
}

DailyJourneyExperience applyEditorialStoryRevision(
  DailyJourneyExperience journey,
  Map<String, EditorialStoryRevision> revisions,
) {
  final revision = revisions[journey.id];
  if (revision == null) return journey;

  final originalSections = journey.content.sections;
  if (originalSections.isEmpty) return journey;
  final revisedSections = List<JourneyStorySection>.generate(
    revision.sections.length,
    (index) {
      final originalIndex = index < originalSections.length
          ? index
          : originalSections.length - 1;
      final original = originalSections[originalIndex];
      return JourneyStorySection(
        id: index < originalSections.length ? original.id : 'story-$index',
        text: revision.sections[index],
        sourceIds: original.sourceIds,
      );
    },
    growable: false,
  );

  return DailyJourneyExperience(
    id: journey.id,
    city: journey.city,
    cityCode: journey.cityCode,
    place: journey.place,
    appBarTitle: journey.appBarTitle,
    storyTitle: journey.storyTitle,
    headline: journey.headline,
    description: journey.description,
    discoveryTeaser: journey.discoveryTeaser,
    distanceLabel: journey.distanceLabel,
    stampSymbol: journey.stampSymbol,
    content: JourneyContentRecord(
      id: journey.content.id,
      title: journey.content.title,
      geoNodeId: journey.content.geoNodeId,
      languageCode: journey.content.languageCode,
      sections: revisedSections,
      verificationStatus: journey.content.verificationStatus,
      tags: journey.content.tags,
    ),
    storyAnnotations: revision.annotations,
    words: journey.words
        .map((entry) => _preserveNaturalVocabularyContext(entry, journey))
        .toList(growable: false),
    discoveries: journey.discoveries,
    wonderQuestion: revision.wonderQuestion,
    expressQuestion: revision.expressQuestion,
  );
}

JourneyContentRecord applyEditorialContentRevision(
  JourneyContentRecord content,
  Map<String, EditorialStoryRevision> revisions,
) {
  final revision = revisions[content.id];
  if (revision == null || content.sections.isEmpty) return content;
  final originalSections = content.sections;
  return JourneyContentRecord(
    id: content.id,
    title: content.title,
    geoNodeId: content.geoNodeId,
    languageCode: content.languageCode,
    verificationStatus: content.verificationStatus,
    tags: content.tags,
    sections: List<JourneyStorySection>.generate(
      revision.sections.length,
      (index) {
        final originalIndex = index < originalSections.length
            ? index
            : originalSections.length - 1;
        final original = originalSections[originalIndex];
        return JourneyStorySection(
          id: index < originalSections.length ? original.id : 'story-$index',
          text: revision.sections[index],
          sourceIds: original.sourceIds,
        );
      },
      growable: false,
    ),
  );
}

WordEntry _preserveNaturalVocabularyContext(
  WordEntry entry,
  DailyJourneyExperience originalJourney,
) {
  final correctedPart = _partOfSpeechCorrections[entry.word] ?? entry.partOfSpeech;
  if (entry.examples.isNotEmpty) {
    return _copyWord(entry, partOfSpeech: correctedPart);
  }

  for (var index = 0; index < originalJourney.content.sections.length; index += 1) {
    final section = originalJourney.content.sections[index];
    if (!section.text.contains(entry.word) ||
        index >= originalJourney.storyAnnotations.length) {
      continue;
    }
    final annotation = originalJourney.storyAnnotations[index];
    return _copyWord(
      entry,
      partOfSpeech: correctedPart,
      examples: [
        WordExample(
          chinese: section.text,
          pinyin: annotation.pinyin,
          vietnamese: annotation.vietnamese,
          english: annotation.english,
        ),
      ],
    );
  }

  return _copyWord(entry, partOfSpeech: correctedPart);
}

WordEntry _copyWord(
  WordEntry entry, {
  required String partOfSpeech,
  List<WordExample>? examples,
}) {
  return WordEntry(
    word: entry.word,
    pinyin: entry.pinyin,
    partOfSpeech: partOfSpeech,
    simpleChinese: entry.simpleChinese,
    translation: entry.translation,
    englishDefinition: entry.englishDefinition,
    symbol: entry.symbol,
    examples: examples ?? entry.examples,
  );
}

const _partOfSpeechCorrections = <String, String>{
  '灌溉': '动词',
  '截断': '动词',
  '排沙': '动词',
  '配合': '动词',
  '引导': '动词',
  '维护': '动词',
  '监测': '动词',
  '控制': '动词',
  '修复': '动词',
  '影响': '动词',
  '融合': '动词',
  '适应': '动词',
  '夯筑': '动词',
  '多元': '形容词',
  '紧凑': '形容词',
  '庄严': '形容词',
  '持续': '副词／动词',
};
