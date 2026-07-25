import '../models/language_proficiency.dart';
import 'journey_data.dart';
import 'summer_palace_journey.dart';

final summerPalaceAdaptiveWords = <WordEntry>[
  ...summerPalaceWords.where((entry) => entry.word != '融合'),
  const WordEntry(
    word: '构图',
    pinyin: 'gòutú',
    partOfSpeech: '动词／名词',
    simpleChinese: '安排画面中各部分的位置和关系。',
    translation: 'Sắp xếp bố cục và quan hệ giữa các phần trong một hình ảnh.',
    englishDefinition: 'to compose a view; visual composition',
    symbol: '🖼️',
  ),
  const WordEntry(
    word: '对景',
    pinyin: 'duìjǐng',
    partOfSpeech: '名词／动词',
    simpleChinese: '在一个位置安排正面可见的景物，使视线有明确目标。',
    translation: 'Bố trí cảnh vật đối diện để tạo điểm nhìn rõ ràng.',
    englishDefinition: 'a framed or opposite view in garden design',
    symbol: '🎯',
  ),
  const WordEntry(
    word: '痕迹',
    pinyin: 'hénjì',
    partOfSpeech: '名词',
    simpleChinese: '事物发生或经过以后留下的迹象。',
    translation: 'Dấu vết còn lại sau khi một việc đã xảy ra.',
    englishDefinition: 'a trace, mark, or sign left behind',
    symbol: '🪶',
  ),
  const WordEntry(
    word: '规划',
    pinyin: 'guīhuà',
    partOfSpeech: '动词／名词',
    simpleChinese: '对未来的空间、任务或发展作系统安排。',
    translation: 'Quy hoạch hoặc sắp xếp có hệ thống cho không gian và phát triển.',
    englishDefinition: 'to plan systematically; planning',
    symbol: '📐',
  ),
  const WordEntry(
    word: '层次',
    pinyin: 'céngcì',
    partOfSpeech: '名词',
    simpleChinese: '事物按照前后、高低或深浅形成的不同层级。',
    translation: 'Các lớp hoặc cấp độ tạo nên chiều sâu và trật tự.',
    englishDefinition: 'layers, levels, or visual depth',
    symbol: '🪜',
  ),
];

const summerPalaceVocabularyLevels = <String, VocabularyLevelTag>{
  '颐和园': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '昆明湖': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '万寿山': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '长廊': VocabularyLevelTag(
    hskLevel: 6,
    tocflLevel: 4,
    kind: VocabularyKind.cultural,
  ),
  '倒影': VocabularyLevelTag(hskLevel: 6, tocflLevel: 4),
  '亭台': VocabularyLevelTag(
    hskLevel: 7,
    tocflLevel: 6,
    kind: VocabularyKind.cultural,
  ),
  '皇家园林': VocabularyLevelTag(
    kind: VocabularyKind.cultural,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '修复': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
  '借景': VocabularyLevelTag(
    hskLevel: 7,
    tocflLevel: 6,
    kind: VocabularyKind.cultural,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '湖光山色': VocabularyLevelTag(
    hskLevel: 7,
    tocflLevel: 6,
    kind: VocabularyKind.idiom,
  ),
  '十七孔桥': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '构图': VocabularyLevelTag(hskLevel: 6, tocflLevel: 5),
  '对景': VocabularyLevelTag(
    hskLevel: 7,
    tocflLevel: 6,
    kind: VocabularyKind.cultural,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '痕迹': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
  '规划': VocabularyLevelTag(hskLevel: 4, tocflLevel: 3),
  '层次': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
};
