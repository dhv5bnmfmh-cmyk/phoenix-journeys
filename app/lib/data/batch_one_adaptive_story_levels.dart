import '../models/language_proficiency.dart';
import 'batch_one_journey_remediation.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

bool isBatchOneGoldJourney(String journeyId) =>
    journeyId == 'shanghai-bund';

/// Thin adaptive adapter over the canonical remediation records.
/// It does not own Story, Words, Discovery, Challenge, Memory, or Completion
/// content; those remain in batch_one_journey_remediation.dart.
JourneyLevelContent buildBatchOneGoldLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final base = batchOneJourneyLevelContentFor(experience.id, level);
  if (base == null) {
    throw ArgumentError.value(experience.id, 'experience.id');
  }

  final storyParagraphs = List<String>.of(base.storyParagraphs);
  final storyAnnotations = List<ReadingAnnotation>.of(base.storyAnnotations);
  if (storyParagraphs.length > 1 && storyAnnotations.length > 1) {
    final bridge = switch (experience.id) {
      'beijing-forbidden-city' => (
          chinese: '纪衡再次核对记录。',
          pinyin: 'Jì Héng zàicì héduì jìlù.',
          vietnamese: 'Kỷ Hành kiểm tra lại hồ sơ.',
          english: 'Ji Heng checks the record again.',
        ),
      'shanghai-bund' => (
          chinese: '陆潮看向断线屏幕。',
          pinyin: 'Lù Cháo kàn xiàng duànxiàn píngmù.',
          vietnamese: 'Lục Triều nhìn về màn hình đang mất kết nối.',
          english: 'Lu Chao looks at the disconnected screen.',
        ),
      _ => (chinese: '', pinyin: '', vietnamese: '', english: ''),
    };
    if (bridge.chinese.isNotEmpty) {
      storyParagraphs[1] = '${bridge.chinese}${storyParagraphs[1]}';
      final annotation = storyAnnotations[1];
      storyAnnotations[1] = ReadingAnnotation(
        pinyin: '${bridge.pinyin} ${annotation.pinyin}',
        vietnamese: '${bridge.vietnamese} ${annotation.vietnamese}',
        english: '${bridge.english} ${annotation.english}',
      );
    }
  }

  if (experience.id == 'shanghai-bund' && level == 10) {
    const epilogueChinese = '次日，新讲义入库。';
    const epiloguePinyin = 'Cìrì, xīn jiǎngyì rùkù.';
    const epilogueVietnamese = 'Ngày hôm sau, giáo án mới được lưu vào kho khóa học.';
    const epilogueEnglish = 'The next day, the revised lesson enters the course library.';
    final last = storyParagraphs.length - 1;
    storyParagraphs[last] = '${storyParagraphs[last]}$epilogueChinese';
    final annotation = storyAnnotations[last];
    storyAnnotations[last] = ReadingAnnotation(
      pinyin: '${annotation.pinyin} $epiloguePinyin',
      vietnamese: '${annotation.vietnamese} $epilogueVietnamese',
      english: '${annotation.english} $epilogueEnglish',
    );
  }

  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final words = unseenWords.isEmpty ? base.words : unseenWords;
  final prompts = switch (experience.id) {
    'beijing-forbidden-city' => (
        understanding: '纪衡为什么在雷雨前没有直接疏通不出水的石雕龙头？',
        expression: '请说明丹陛排水、旧修缮层、可逆临时导排与最终最小清理之间的关系。',
      ),
    'shanghai-bund' => (
        understanding: '陆潮为什么宁可错过九点半的同步画面，也不播放现成的赞助动画？',
        expression: '请说明黄浦江、1843年开埠、外滩商业金融历史与现代浦东怎样进入同一场模拟。',
      ),
    _ => (understanding: '', expression: ''),
  };

  return JourneyLevelContent(
    storyParagraphs: storyParagraphs,
    storyAnnotations: storyAnnotations,
    words: words,
    discoveries: base.discoveries,
    wonderQuestion: prompts.understanding,
    expressQuestion: prompts.expression,
  );
}

/// UI compatibility view over the canonical Batch 1 remediation record.
///
/// [reviews] deliberately keeps the canonical six-part Memory review intact so
/// the Memory and Completion surfaces do not collapse historically important
/// protagonist, event, history, culture, architecture, or vocabulary recall.
class BatchOneJourneyMemorySpec {
  const BatchOneJourneyMemorySpec({
    required this.storyResult,
    required this.culturalPoint,
    required this.reviews,
    required this.longTermAnchor,
    required this.completionSummary,
  });

  final String storyResult;
  final String culturalPoint;
  final List<RemediatedMemoryReview> reviews;
  final String longTermAnchor;
  final String completionSummary;
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(String journeyId) {
  if (journeyId != 'shanghai-bund') return null;
  final journey = batchOneRemediationFor(journeyId);
  if (journey == null) return null;

  String memoryAnswer(String category) => journey.memory
      .firstWhere((item) => item.category == category)
      .answer;

  return BatchOneJourneyMemorySpec(
    storyResult: journey.completion.journeySummary,
    culturalPoint:
        '${memoryAnswer('culture')} ${memoryAnswer('architecture')}',
    reviews: List<RemediatedMemoryReview>.unmodifiable(journey.memory),
    longTermAnchor: journey.completion.memoryAnchor,
    completionSummary:
        '${journey.completion.achievement} ${journey.completion.challengeReward}',
  );
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
