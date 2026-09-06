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

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

const _storyVietnamese = <String>[
  'Trước khi bàn giao, Lâm Kiều đẩy cuốn sổ ghi địa điểm về phía đồng nghiệp mới Hứa Trừng. Hứa Trừng sẽ tiếp nhận sổ vào ngày hôm sau. Anh lật đến trang ký tên và hỏi: “Ngày mai tôi cứ làm theo những gì ghi ở đây à?” Lâm Kiều vốn đã mở nắp bút, nhưng đặt bút trở lại bàn: “Trước tiên cùng đối chiếu lại một lượt.”',
  'Hai người xem từ những trang đầu về sau. Hứa Trừng khoanh “trục giữa”, rồi đánh dấu cạnh “Cảnh Vận Môn”: “Hai cái này tôi vẫn dễ nhầm.” Lâm Kiều không bắt anh học thuộc đáp án, chỉ bảo anh đánh dấu trước những chỗ chưa chắc chắn.',
  'Khi lật đến bảng cũ, họ thấy Cảnh Vận Môn bị đánh dấu ở phía tây quảng trường trước Càn Thanh Môn. Hứa Trừng ngẩng lên: “Nếu ngày mai tôi đi theo bảng này thì sao?” Tay Lâm Kiều dừng lại trên ô ký tên. Ban đầu cô chỉ còn thiếu một chữ ký là xong bàn giao, nhưng giờ cô không thể để câu hỏi này lại cho người tiếp nhận.',
  'Hai người trải trang sơ đồ ra bàn và đối chiếu cùng một vị trí: Cảnh Vận Môn nằm ở phía đông quảng trường trước Càn Thanh Môn. Hứa Trừng dùng bút chì khoanh chữ “tây” trên bảng cũ, chưa xóa ngay, chờ Lâm Kiều quyết định trang này sẽ được bàn giao thế nào.',
  'Lâm Kiều không chỉ đổi “tây” thành “đông”. Cô bảo Hứa Trừng ghi câu hỏi vừa rồi bên lề, rồi hai người tiếp tục đối chiếu trang bàn giao: điều nào xác nhận được thì sửa ngay, điều nào chưa xác nhận được thì để trống. Lâm Kiều ký tên tại chỗ sửa rồi đưa bút cho Hứa Trừng: “Sau khi cậu tiếp nhận, cứ dùng cách này mà kiểm tra tiếp.”',
  'Cuốn sổ sẽ được bàn giao ngày hôm sau không còn giả vờ rằng ô nào cũng có đáp án. Hứa Trừng nhận sổ, chỉ vào hai ô trống và hỏi trước: “Hai mục này tôi tiếp tục đối chiếu, đúng không?” Lâm Kiều gật đầu. Việc bàn giao vốn chỉ cần cô ký một cái tên đã trở thành việc cả hai đều biết bước tiếp theo phải làm gì.',
  'Hứa Trừng chưa vội cất sổ. Anh gấp góc ô cuối cùng còn chờ đối chiếu, rồi đặt bút ký giữa hai người: “Xem nốt trang sau cùng nhau nhé?” Lâm Kiều kéo ghế lại gần.',
];

const _storyEnglish = <String>[
  'Before the handoff, Lin Qiao slides the location log toward her new colleague Xu Cheng. He will take over the record the next day. Turning to the signature page, he asks, “Tomorrow, do I just follow what is written here?” Lin Qiao has already uncapped her pen, but she puts it back on the table. “Let’s check it together first.”',
  'They work forward through the earlier pages. Xu Cheng circles “central axis” and marks “Jingyun Gate.” “I still mix these two up.” Lin Qiao does not make him memorize an answer. She asks him to mark every point he is unsure about first.',
  'On an old sheet, they find Jingyun Gate marked on the west side of the square before Qianqing Gate. Xu Cheng looks up. “What if I follow this sheet tomorrow?” Lin Qiao’s hand stops over the signature line. She had been one name away from finishing the handoff, but now she cannot leave that question to the person taking over.',
  'They spread the map page across the desk and verify the same point: Jingyun Gate is on the east side of the square before Qianqing Gate. Xu Cheng circles the word “west” in pencil without erasing it, waiting for Lin Qiao to decide how the page should be handed over.',
  'Lin Qiao does more than replace “west” with “east.” She asks Xu Cheng to write his question in the margin, and they continue checking the handoff pages together: confirm and correct what they can, and leave unconfirmed items blank. Lin Qiao signs beside the correction and hands the pen to Xu Cheng. “When you take over, keep checking in the same way.”',
  'The record that will be handed over the next day no longer pretends every box has an answer. Xu Cheng takes the book and points first to two blanks. “I keep checking these two, right?” Lin Qiao nods. A handoff that had required only her signature has become a shared understanding of what comes next.',
  'Xu Cheng does not put the book away yet. He folds the corner of the final unchecked box and places the signing pen between them. “Shall we finish the next page together?” Lin Qiao pulls her chair closer.',
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
      'discovery.spatial_types' =>
        'Khi đọc không gian Tử Cấm Thành, “Ngọ Môn” và “trục giữa” không phải cùng một loại thông tin: Ngọ Môn là một cổng cụ thể, còn trục giữa mô tả chuỗi không gian bắc–nam do các cổng, sân và công trình chính tạo thành. Ngọ Môn nằm trên trục bắc–nam này, vì vậy hiểu tuyến đường đòi hỏi vừa nhận diện công trình vừa hiểu quan hệ không gian tổ chức chúng.',
      'discovery.qianqing_gate_function' =>
        'Càn Thanh Môn không chỉ là một tên trên bản đồ. Tư liệu đã được xác minh cho biết đây là chính môn của Nội đình và cũng là lối quan trọng nối việc đi lại giữa Nội đình và Ngoại triều. Khi học về Càn Thanh Môn, cần hiểu tên gọi cùng với những không gian mà nó kết nối.',
      'discovery.spatial_relations' =>
        'Chỉ học thuộc tên công trình không đủ để phán đoán quan hệ không gian. Tư liệu đã xác minh đặt Cảnh Vận Môn ở phía đông quảng trường trước Càn Thanh Môn, đồng thời cho thấy các cổng, sân và công trình chính trên trục giữa tạo thành một chuỗi bắc–nam rõ ràng. Khi nhìn cổng, quảng trường, phương hướng và trục cùng nhau, tên gọi mới trở thành thông tin không gian có thể sử dụng.',
      _ => '',
    };

String _discoveryEnglish(String id) => switch (id) {
      'discovery.spatial_types' =>
        'In the Forbidden City, “Meridian Gate” and “central axis” are different kinds of spatial information. Meridian Gate is a specific gate, while the central axis describes the north–south sequence formed by gates, courtyards, and major buildings. Because Meridian Gate lies on that axis, route understanding requires both recognizing buildings and understanding the spatial relations that organize them.',
      'discovery.qianqing_gate_function' =>
        'Qianqing Gate is more than a name on a map. Verified material identifies it as the principal gate of the Inner Court and an important passage connecting movement between the Inner and Outer Courts. Learning the gate therefore means understanding both its name and the spaces it connects.',
      'discovery.spatial_relations' =>
        'Memorizing building names alone is not enough to reason about space. Verified material places Jingyun Gate on the east side of the square before Qianqing Gate and describes the gates, courtyards, and major buildings along the central axis as a clear north–south sequence. Reading gate, square, direction, and axis together turns names into usable spatial information.',
      _ => '',
    };

JourneyLevelContent forbiddenCitySecondStoryLevelContent() {
  ensureForbiddenCitySecondStoryRuntimeValid();
  final package = forbiddenCityPipelineFixture;
  final paragraphs = package.storyContent.lines.map((line) => line.text).toList(
        growable: false,
      );
  if (paragraphs.length != _storyVietnamese.length ||
      paragraphs.length != _storyEnglish.length) {
    throw StateError(
        'Second Story annotation count must match canonical Story.');
  }
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(
      <ReadingAnnotation>[
        for (var index = 0; index < paragraphs.length; index += 1)
          ReadingAnnotation(
            pinyin: _pinyin(paragraphs[index]),
            vietnamese: _storyVietnamese[index],
            english: _storyEnglish[index],
          ),
      ],
    ),
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
      forbiddenCityPipelineFixture.challenges
          .map((item) => '${item.targetText}。'),
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
      storyCharacterCount:
          paragraphs.fold<int>(0, (total, value) => total + value.length),
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
  if (package.storyContent.title != '交接前的标记' ||
      package.status != ContentCandidateStatus.validated ||
      !package.validationReport.automatedValidation ||
      !package.validationReport.passed(ContentQualityCheckKind.factTrace) ||
      !package.validationReport
          .passed(ContentQualityCheckKind.knowledgeProvenance) ||
      !package.validationReport
          .passed(ContentQualityCheckKind.challengeAlignment) ||
      !package.validationReport
          .passed(ContentQualityCheckKind.memoryAlignment) ||
      !package.validationReport
          .passed(ContentQualityCheckKind.deterministicStructure) ||
      !package.validationReport.passed(ContentQualityCheckKind.duplication) ||
      !package.validationReport
          .passed(ContentQualityCheckKind.antiAiSlopSignals)) {
    throw StateError('Approved Second Story runtime lost pipeline validation.');
  }
}
