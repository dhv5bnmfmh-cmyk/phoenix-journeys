import 'package:pinyin/pinyin.dart';

import '../models/content_pipeline.dart';
import '../models/journey_prepared_bundle.dart';
import 'forbidden_city_content_pipeline_fixture.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const forbiddenCityPrimaryStoryId =
    'story.forbidden_city.two_routes_one_map.v1';
const forbiddenCitySecondStoryId =
    'story.forbidden_city.modern_evidence_handoff.v1';

class ForbiddenCityStoryRuntimeEntry {
  const ForbiddenCityStoryRuntimeEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isPrimary,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool isPrimary;
}

const forbiddenCityStoryCatalog = <ForbiddenCityStoryRuntimeEntry>[
  ForbiddenCityStoryRuntimeEntry(
    id: forbiddenCityPrimaryStoryId,
    title: '两条路，一张图',
    subtitle: '古建学徒 · 空间与路线',
    isPrimary: true,
  ),
  ForbiddenCityStoryRuntimeEntry(
    id: forbiddenCitySecondStoryId,
    title: '交接前的标记',
    subtitle: '现代文保 · 核对与交接',
    isPrimary: false,
  ),
];

ForbiddenCityStoryRuntimeEntry requireForbiddenCityStory(String storyId) =>
    forbiddenCityStoryCatalog.singleWhere(
      (story) => story.id == storyId,
      orElse: () => throw StateError('Unknown Forbidden City Story: $storyId'),
    );

String normalizeForbiddenCityStoryId(String? storyId) {
  if (storyId == forbiddenCitySecondStoryId) return forbiddenCitySecondStoryId;
  return forbiddenCityPrimaryStoryId;
}

bool isForbiddenCitySecondStory(String? storyId) =>
    storyId == forbiddenCitySecondStoryId;

class ForbiddenCityStoryProgress {
  const ForbiddenCityStoryProgress({
    required this.storyId,
    required this.step,
    required this.completed,
    required this.updatedAt,
  });

  final String storyId;
  final int step;
  final bool completed;
  final DateTime? updatedAt;

  bool get hasProgress => completed || step > 0;
  int get percent => completed ? 100 : ((step.clamp(0, 5) / 5) * 100).round();
}

class _ContextualPinyinOverride {
  const _ContextualPinyinOverride({
    required this.sourcePhrase,
    required this.generatedPhrase,
    required this.expectedPhrase,
  });

  final String sourcePhrase;
  final String generatedPhrase;
  final String expectedPhrase;
}

const _secondStoryPinyinOverrides = <_ContextualPinyinOverride>[
  _ContextualPinyinOverride(
    sourcePhrase: '空格',
    generatedPhrase: 'kōng gé',
    expectedPhrase: 'kòng gé',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '不确定处',
    generatedPhrase: 'bù què dìng chǔ',
    expectedPhrase: 'bù què dìng chù',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '前面的页码',
    generatedPhrase: 'qián miàn dī yè mǎ',
    expectedPhrase: 'qián miàn de yè mǎ',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '确认的当场',
    generatedPhrase: 'què rèn dí dàng chǎng',
    expectedPhrase: 'què rèn de dāng chǎng',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '指着',
    generatedPhrase: 'zhǐ zhuó',
    expectedPhrase: 'zhǐ zhe',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '地图',
    generatedPhrase: 'de tú',
    expectedPhrase: 'dì tú',
  ),
  _ContextualPinyinOverride(
    sourcePhrase: '背建筑名字',
    generatedPhrase: 'bēi jiàn zhù míng zi',
    expectedPhrase: 'bèi jiàn zhù míng zi',
  ),
];

String _pinyin(String text) {
  var reading = PinyinHelper.getPinyinE(
    text,
    separator: ' ',
    format: PinyinFormat.WITH_TONE_MARK,
  );
  for (final override in _secondStoryPinyinOverrides) {
    if (!text.contains(override.sourcePhrase)) continue;
    reading = reading.replaceAll(
      override.generatedPhrase,
      override.expectedPhrase,
    );
  }
  return reading;
}

const _secondStoryVisibleParagraphs = <String>[
  '交接前，林乔把记录册推到新同事许澄面前。许澄第二天就要接手，问明天是否直接照表使用。林乔已经拔开笔帽，却又把笔放回桌上：“先一起核对一遍。”两人从前面的页码往后看。许澄圈出“中轴”，又在“景运门”旁做了记号。他说这两处还容易弄混。林乔让他先标出不确定处。翻到旧表时，两人发现景运门被标在乾清门前广场西侧。许澄问：“如果我明天照这张表走呢？”林乔的手停在签名栏上。她原本只差签名就能完成交接，现在却不愿把疑问留给接手的人。',
  '两人把图页摊开，核到景运门位于乾清门前广场东侧。许澄圈住旧表的“西”，没有擦掉。林乔也没有只把“西”改成“东”。她让许澄把疑问写在页边，再一起核对。能确认的当场更正，不能确认的先留空。林乔签下更正，把笔递给许澄。“接手以后，也照这个办法往下查。”许澄接过册子，指着两个空格确认要继续核对。最后，他把待核的格子折了角，把签字笔放到两人中间。他问：“下一页一起看完？”林乔把椅子拉近。',
];

const _storyVietnamese = <String>[
  'Trước khi bàn giao, Lâm Kiều đẩy cuốn sổ ghi chép về phía đồng nghiệp mới Hứa Trừng. Ngày hôm sau anh sẽ tiếp nhận công việc và hỏi liệu có thể cứ theo bảng mà làm. Lâm Kiều đã mở nắp bút nhưng lại đặt bút xuống: “Trước tiên cùng đối chiếu một lượt.” Hai người xem lại từng trang. Hứa Trừng khoanh “trục giữa”, đánh dấu “Cảnh Vận Môn” và nói mình vẫn dễ nhầm hai mục này. Lâm Kiều bảo anh đánh dấu trước những chỗ chưa chắc. Khi đến bảng cũ, họ thấy Cảnh Vận Môn bị ghi ở phía tây quảng trường trước Càn Thanh Môn. Hứa Trừng hỏi nếu ngày mai anh đi theo bảng này thì sao. Tay Lâm Kiều dừng trên dòng ký tên; cô không muốn để câu hỏi đó lại cho người tiếp nhận.',
  'Hai người trải trang sơ đồ ra và xác nhận Cảnh Vận Môn nằm ở phía đông quảng trường trước Càn Thanh Môn. Hứa Trừng khoanh chữ “tây” trên bảng cũ và chưa xóa nó. Lâm Kiều cũng không chỉ đổi “tây” thành “đông”. Cô bảo Hứa Trừng ghi câu hỏi bên lề rồi cùng tiếp tục đối chiếu: điều nào xác nhận được thì sửa, điều nào chưa chắc thì để trống. Lâm Kiều ký vào chỗ sửa và đưa bút cho Hứa Trừng, dặn anh tiếp tục kiểm tra theo cách đó. Hứa Trừng nhận sổ, xác nhận hai ô trống mình sẽ tiếp tục đối chiếu. Cuối cùng anh gấp góc ô còn chờ kiểm tra, đặt bút giữa hai người và hỏi có cùng xem nốt trang sau không. Lâm Kiều kéo ghế lại gần.',
];

const _storyEnglish = <String>[
  'Before the handoff, Lin Qiao slides the record book toward her new colleague Xu Cheng. He will take it over the next day and asks whether he should simply follow the sheet. Lin Qiao has already uncapped her pen, but sets it down again: “Let’s check it together first.” They work through the pages. Xu Cheng circles “central axis,” marks “Jingyun Gate,” and says he still mixes the two up. Lin Qiao asks him to mark uncertain points first. On the old sheet they find Jingyun Gate marked on the west side of the square before Qianqing Gate. Xu Cheng asks what happens if he follows the sheet tomorrow. Lin Qiao’s hand stops over the signature line; she does not want to leave that question to the person taking over.',
  'They spread out the map page and verify that Jingyun Gate is on the east side of the square before Qianqing Gate. Xu Cheng circles “west” on the old sheet and leaves it visible. Lin Qiao does not merely change “west” to “east.” She asks Xu Cheng to note the question in the margin and keeps checking with him: confirmed items are corrected, while uncertain ones stay blank. Lin Qiao signs the correction and hands him the pen, telling him to continue checking the same way after the handoff. Xu Cheng takes the book and confirms that he will keep checking the two blank items. Finally he folds the corner of the remaining unchecked box, places the pen between them, and asks whether they should finish the next page together. Lin Qiao pulls her chair closer.',
];

String _vocabularyVietnamese(String id) => switch (id) {
  'vocab.central_axis' => 'trục trung tâm',
  'vocab.jingyun_gate' => 'Cảnh Vận Môn',
  'vocab.verify' => 'đối chiếu; kiểm tra chéo',
  'vocab.handoff' => 'bàn giao',
  _ => '',
};

String _vocabularyEnglish(String id) => switch (id) {
  'vocab.central_axis' => 'central axis',
  'vocab.jingyun_gate' => 'Jingyun Gate',
  'vocab.verify' => 'to cross-check; to verify by comparison',
  'vocab.handoff' => 'handoff; transfer of work or responsibility',
  _ => '',
};

String _vocabularySymbol(String id) => switch (id) {
  'vocab.central_axis' => '↕️',
  'vocab.jingyun_gate' => '🚪',
  'vocab.verify' => '🔎',
  'vocab.handoff' => '🤝',
  _ => '•',
};

String _discoveryVietnamese(String id) => switch (id) {
  'discovery.spatial_types' => 'Khi đọc không gian Tử Cấm Thành, “Ngọ Môn” và “trục giữa” không phải cùng một loại thông tin: Ngọ Môn là một cổng cụ thể, còn trục giữa mô tả chuỗi không gian bắc–nam do các cổng, sân và công trình chính tạo thành. Ngọ Môn nằm trên trục bắc–nam này, vì vậy hiểu tuyến đường đòi hỏi vừa nhận diện công trình vừa hiểu quan hệ không gian tổ chức chúng.',
  'discovery.qianqing_gate_function' => 'Càn Thanh Môn không chỉ là một tên trên bản đồ. Tư liệu đã được xác minh cho biết đây là chính môn của Nội đình và cũng là lối quan trọng nối việc đi lại giữa Nội đình và Ngoại triều. Khi học về Càn Thanh Môn, cần hiểu tên gọi cùng với những không gian mà nó kết nối.',
  'discovery.spatial_relations' => 'Chỉ học thuộc tên công trình không đủ để phán đoán quan hệ không gian. Tư liệu đã xác minh đặt Cảnh Vận Môn ở phía đông quảng trường trước Càn Thanh Môn, đồng thời cho thấy các cổng, sân và công trình chính trên trục giữa tạo thành một chuỗi bắc–nam rõ ràng. Khi nhìn cổng, quảng trường, phương hướng và trục cùng nhau, tên gọi mới trở thành thông tin không gian có thể sử dụng.',
  _ => '',
};

String _discoveryEnglish(String id) => switch (id) {
  'discovery.spatial_types' => 'In the Forbidden City, “Meridian Gate” and “central axis” are different kinds of spatial information. Meridian Gate is a specific gate, while the central axis describes the north–south sequence formed by gates, courtyards, and major buildings. Because Meridian Gate lies on that axis, route understanding requires both recognizing buildings and understanding the spatial relations that organize them.',
  'discovery.qianqing_gate_function' => 'Qianqing Gate is more than a name on a map. Verified material identifies it as the principal gate of the Inner Court and an important passage connecting movement between the Inner and Outer Courts. Learning the gate therefore means understanding both its name and the spaces it connects.',
  'discovery.spatial_relations' => 'Memorizing building names alone is not enough to reason about space. Verified material places Jingyun Gate on the east side of the square before Qianqing Gate and describes the gates, courtyards, and major buildings along the central axis as a clear north–south sequence. Reading gate, square, direction, and axis together turns names into usable spatial information.',
  _ => '',
};

JourneyLevelContent forbiddenCitySecondStoryLevelContent() {
  ensureForbiddenCitySecondStoryRuntimeValid();
  final package = forbiddenCityPipelineFixture;
  const paragraphs = _secondStoryVisibleParagraphs;
  if (package.storyContent.lines.length != 7) {
    throw StateError(
      'Second Story must retain seven internal narrative beats.',
    );
  }
  if (paragraphs.length != _storyVietnamese.length ||
      paragraphs.length != _storyEnglish.length) {
    throw StateError(
      'Second Story annotation count must match visible Story paragraphs.',
    );
  }
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(<ReadingAnnotation>[
      for (var index = 0; index < paragraphs.length; index += 1)
        ReadingAnnotation(
          pinyin: _pinyin(paragraphs[index]),
          vietnamese: _storyVietnamese[index],
          english: _storyEnglish[index],
        ),
    ]),
    words: List<WordEntry>.unmodifiable(
      package.vocabulary.map(
        (item) => WordEntry(
          word: item.word,
          pinyin: item.pinyin,
          partOfSpeech: item.partOfSpeech,
          simpleChinese: item.simpleChinese,
          translation: _vocabularyVietnamese(item.id),
          englishDefinition: _vocabularyEnglish(item.id),
          symbol: _vocabularySymbol(item.id),
        ),
      ),
    ),
    discoveries: List<DiscoveryEntry>.unmodifiable(
      package.discoveries.map(
        (item) => DiscoveryEntry(
          text: item.text,
          pinyin: _pinyin(item.text),
          simpleChinese: item.text,
          vietnamese: _discoveryVietnamese(item.id),
          english: _discoveryEnglish(item.id),
          sourceRefs: item.sourceRefs,
        ),
      ),
    ),
    wonderQuestion: '',
    expressQuestion: '',
  );
}

List<String> get forbiddenCitySecondStoryChallengeSourceMaterial =>
    List<String>.unmodifiable(
      forbiddenCityPipelineFixture.challenges.map(
        (item) => '${item.targetText}。',
      ),
    );

JourneyPreparedBundle forbiddenCitySecondStoryPreparedBundle({
  required int phoenixLevel,
  required String scriptMode,
}) {
  final content = forbiddenCitySecondStoryLevelContent();
  final paragraphs = List<String>.unmodifiable(content.storyParagraphs);
  return JourneyPreparedBundle(
    key: JourneyPreparationKey(
      journeyId: forbiddenCityJourneyId,
      phoenixLevel: phoenixLevel.clamp(1, 10).toInt(),
      scriptMode: scriptMode,
    ),
    levelContent: content,
    narrationItems: paragraphs,
    challengeSourceMaterial: forbiddenCitySecondStoryChallengeSourceMaterial,
    layoutMetadata: JourneyLayoutMetadata(
      storyCharacterCount: paragraphs.fold<int>(
        0,
        (total, value) => total + value.length,
      ),
    ),
  );
}

ForbiddenCityMemoryMoment forbiddenCitySecondStoryMemoryForLevel(int level) {
  final memory = forbiddenCityPipelineFixture.memory;
  return ForbiddenCityMemoryMoment(
    level: level.clamp(1, 10).toInt(),
    anchor: memory.storyAnchor.text,
    recall: memory.vocabularyRecall.text,
    characterShift: memory.characterMoment.text,
    takeaway: memory.knowledgeTakeaway.text,
  );
}

ForbiddenCityCompletionMoment forbiddenCitySecondStoryCompletionForLevel(
  int level,
) {
  final memory = forbiddenCityPipelineFixture.memory;
  final finalStoryLine =
      forbiddenCityPipelineFixture.storyContent.lines.last.text;
  return ForbiddenCityCompletionMoment(
    level: level.clamp(1, 10).toInt(),
    storyClosure: finalStoryLine,
    discovery: memory.knowledgeTakeaway.text,
    learning: memory.vocabularyRecall.text,
    memory: memory.storyAnchor.text,
    relationship: memory.characterMoment.text,
    emotionalClosure: '',
    unlockResult: '',
  );
}

void ensureForbiddenCitySecondStoryRuntimeValid() {
  final package = forbiddenCityPipelineFixture;
  const visibleParagraphs = _secondStoryVisibleParagraphs;
  final visibleCharacterCount = visibleParagraphs.fold<int>(
    0,
    (total, paragraph) => total + paragraph.length,
  );
  final visibleSentenceLengths = visibleParagraphs
      .expand((paragraph) => paragraph.split(RegExp(r'[。！？]')))
      .map((sentence) => sentence.trim().length)
      .where((length) => length > 0);
  if (visibleParagraphs.length != 2 ||
      visibleCharacterCount < 280 ||
      visibleCharacterCount > 400 ||
      visibleSentenceLengths.any((length) => length > 30)) {
    throw StateError('Second Story Lv5 visible reading contract drifted.');
  }
  if (package.storyContent.title != '交接前的标记' ||
      package.status != ContentCandidateStatus.validated ||
      !package.validationReport.automatedValidation ||
      !package.validationReport.passed(ContentQualityCheckKind.factTrace) ||
      !package.validationReport.passed(
        ContentQualityCheckKind.knowledgeProvenance,
      ) ||
      !package.validationReport.passed(
        ContentQualityCheckKind.challengeAlignment,
      ) ||
      !package.validationReport.passed(
        ContentQualityCheckKind.memoryAlignment,
      ) ||
      !package.validationReport.passed(
        ContentQualityCheckKind.deterministicStructure,
      ) ||
      !package.validationReport.passed(ContentQualityCheckKind.duplication) ||
      !package.validationReport.passed(
        ContentQualityCheckKind.antiAiSlopSignals,
      )) {
    throw StateError('Approved Second Story runtime lost pipeline validation.');
  }
}
