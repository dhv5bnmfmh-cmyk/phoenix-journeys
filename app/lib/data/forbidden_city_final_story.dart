import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

/// Final Gold Standard correction for the locked Forbidden City adaptive Story.
///
/// Lv1-Lv8 and Lv10 remain byte-for-byte identical to the approved runtime.
/// Lv9 receives one small narrative sentence so it satisfies the normal Phoenix
/// length gate without padding or a journey-specific validation exception.
const forbiddenCityLv9FinalBridge =
    '这种分辨也让沈砚明白，理解空间首先要承认自己所处的位置。';

const _forbiddenCityLv9BridgePinyin =
    'Zhè zhǒng fēnbiàn yě ràng Shěn Yàn míngbai, lǐjiě kōngjiān shǒuxiān yào chéngrèn zìjǐ suǒ chǔ de wèizhì.';
const _forbiddenCityLv9BridgeVietnamese =
    'Sự phân biệt này cũng khiến Thẩm Nghiên hiểu rằng muốn hiểu không gian, trước hết phải thừa nhận vị trí của chính mình.';
const _forbiddenCityLv9BridgeEnglish =
    'This distinction also makes Shen Yan realize that understanding space begins with acknowledging one’s own position within it.';

List<String> forbiddenCityFinalStoryParagraphsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final paragraphs = List<String>.of(
    forbiddenCityStoryParagraphsByLevel[safeLevel - 1],
  );
  if (safeLevel == 9) {
    paragraphs[0] = '${paragraphs[0]}$forbiddenCityLv9FinalBridge';
  }
  return List<String>.unmodifiable(paragraphs);
}

String forbiddenCityFinalStoryForLevel(int level) =>
    forbiddenCityFinalStoryParagraphsForLevel(level).join('\n\n');

JourneyLevelContent forbiddenCityFinalLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final base = forbiddenCityLevelContent(safeLevel);
  if (safeLevel != 9) return base;

  final paragraphs = forbiddenCityFinalStoryParagraphsForLevel(safeLevel);
  final annotations = List<ReadingAnnotation>.of(base.storyAnnotations);
  final first = annotations.first;
  annotations[0] = ReadingAnnotation(
    pinyin: '${first.pinyin} $_forbiddenCityLv9BridgePinyin',
    vietnamese: '${first.vietnamese} $_forbiddenCityLv9BridgeVietnamese',
    english: '${first.english} $_forbiddenCityLv9BridgeEnglish',
  );

  return JourneyLevelContent(
    storyParagraphs: paragraphs,
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: base.words,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}
