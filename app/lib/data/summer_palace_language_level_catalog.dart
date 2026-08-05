import '../models/language_proficiency.dart';
import 'journey_data.dart';
import 'summer_palace_journey.dart';

final summerPalaceAdaptiveWords = <WordEntry>[
  ...summerPalaceWords.where((entry) => entry.word != '融合'),
  const WordEntry(
    word: '倒影',
    pinyin: 'dàoyǐng',
    partOfSpeech: '名词',
    simpleChinese: '物体映在水面或镜面上的影像。',
    translation: 'Hình phản chiếu của vật thể trên mặt nước hoặc mặt gương.',
    englishDefinition: 'a reflection on water or a mirrored surface',
    examples: [
      WordExample(
        chinese: '昆明湖的倒影随着观看角度改变。',
        pinyin: 'Kūnmíng Hú de dàoyǐng suízhe guānkàn jiǎodù gǎibiàn.',
        vietnamese: 'Hình phản chiếu trên hồ Côn Minh thay đổi theo góc nhìn.',
        english: 'The reflection on Kunming Lake changes with the viewing angle.',
      ),
    ],
    symbol: '🪞',
  ),
  const WordEntry(
    word: '亭台',
    pinyin: 'tíngtái',
    partOfSpeech: '名词',
    simpleChinese: '园林中的亭子和台榭等建筑。',
    translation: 'Các đình và đài trong kiến trúc cảnh quan.',
    englishDefinition: 'pavilions and terraces in a garden',
    examples: [
      WordExample(
        chinese: '亭台、桥梁和岛屿共同组织颐和园的视线。',
        pinyin: 'Tíngtái, qiáoliáng hé dǎoyǔ gòngtóng zǔzhī Yíhéyuán de shìxiàn.',
        vietnamese: 'Đình, cầu và đảo cùng tổ chức đường nhìn trong Di Hòa Viên.',
        english: 'Pavilions, bridges, and islands organize sightlines through the Summer Palace.',
      ),
    ],
    symbol: '🏛️',
  ),
  const WordEntry(
    word: '构图',
    pinyin: 'gòutú',
    partOfSpeech: '动词／名词',
    simpleChinese: '安排画面中各部分的位置和关系。',
    translation: 'Sắp xếp bố cục và quan hệ giữa các phần trong một hình ảnh.',
    englishDefinition: 'to compose a view; visual composition',
    examples: [
      WordExample(
        chinese: '长廊的廊柱把湖面和远山重新构图。',
        pinyin: 'Chángláng de lángzhù bǎ húmiàn hé yuǎnshān chóngxīn gòutú.',
        vietnamese:
            'Các cột của Trường Lang sắp xếp lại mặt hồ và núi xa thành một bố cục mới.',
        english:
            'The Long Corridor columns recompose the lake and distant hills into a new view.',
      ),
    ],
    symbol: '🖼️',
  ),
  const WordEntry(
    word: '对景',
    pinyin: 'duìjǐng',
    partOfSpeech: '名词／动词',
    simpleChinese: '在一个位置安排正面可见的景物，使视线有明确目标。',
    translation: 'Bố trí cảnh vật đối diện để tạo điểm nhìn rõ ràng.',
    englishDefinition: 'a framed or opposite view in garden design',
    examples: [
      WordExample(
        chinese: '站在长廊的开口处，佛香阁正好成为对景。',
        pinyin:
            'Zhàn zài Chángláng de kāikǒu chù, Fóxiāng Gé zhènghǎo chéngwéi duìjǐng.',
        vietnamese:
            'Đứng tại một khoảng mở của Trường Lang, Phật Hương Các vừa khéo trở thành cảnh đối diện.',
        english:
            'From an opening in the Long Corridor, the Tower of Buddhist Incense becomes the framed opposite view.',
      ),
    ],
    symbol: '🎯',
  ),
  const WordEntry(
    word: '痕迹',
    pinyin: 'hénjì',
    partOfSpeech: '名词',
    simpleChinese: '事物发生或经过以后留下的迹象。',
    translation: 'Dấu vết còn lại sau khi một việc đã xảy ra.',
    englishDefinition: 'a trace, mark, or sign left behind',
    examples: [
      WordExample(
        chinese: '修复后的园林仍保留着历史损毁的痕迹。',
        pinyin:
            'Xiūfù hòu de yuánlín réng bǎoliúzhe lìshǐ sǔnhuǐ de hénjì.',
        vietnamese:
            'Khu vườn sau khi phục hồi vẫn lưu giữ dấu vết hư hại trong lịch sử.',
        english:
            'The restored garden still preserves traces of historical damage.',
      ),
    ],
    symbol: '🪶',
  ),
  const WordEntry(
    word: '规划',
    pinyin: 'guīhuà',
    partOfSpeech: '动词／名词',
    simpleChinese: '对未来的空间、任务或发展作系统安排。',
    translation: 'Quy hoạch hoặc sắp xếp có hệ thống cho không gian và phát triển.',
    englishDefinition: 'to plan systematically; planning',
    examples: [
      WordExample(
        chinese: '颐和园的规划以万寿山和昆明湖为中心。',
        pinyin:
            'Yíhéyuán de guīhuà yǐ Wànshòu Shān hé Kūnmíng Hú wéi zhōngxīn.',
        vietnamese:
            'Quy hoạch Di Hòa Viên lấy núi Vạn Thọ và hồ Côn Minh làm trung tâm.',
        english:
            'The Summer Palace plan is organized around Longevity Hill and Kunming Lake.',
      ),
    ],
    symbol: '📐',
  ),
  const WordEntry(
    word: '层次',
    pinyin: 'céngcì',
    partOfSpeech: '名词',
    simpleChinese: '事物按照前后、高低或深浅形成的不同层级。',
    translation: 'Các lớp hoặc cấp độ tạo nên chiều sâu và trật tự.',
    englishDefinition: 'layers, levels, or visual depth',
    examples: [
      WordExample(
        chinese: '十七孔桥把近处湖岸和远处山景组织成丰富的层次。',
        pinyin:
            'Shíqīkǒng Qiáo bǎ jìnchù hú’àn hé yuǎnchù shānjǐng zǔzhī chéng fēngfù de céngcì.',
        vietnamese:
            'Cầu Thập Thất Khổng sắp xếp bờ hồ gần và cảnh núi xa thành nhiều lớp phong phú.',
        english:
            'The Seventeen-Arch Bridge organizes the nearby shore and distant hills into rich visual layers.',
      ),
    ],
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
