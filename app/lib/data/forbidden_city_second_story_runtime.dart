import 'package:pinyin/pinyin.dart';

import '../models/journey_challenge.dart';
import '../models/journey_prepared_bundle.dart';
import '../services/journey_challenge_engine.dart';
import 'forbidden_city_content_pipeline_fixture.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const forbiddenCitySecondStoryPilotTitle = '交接前的标记';
const forbiddenCitySecondStoryPilotQueryValue = 'handoff-v1';
const forbiddenCitySecondStoryPilotChallengeRuntimeId =
    'runtime.forbidden_city.second_story.handoff_v1';

bool get forbiddenCitySecondStoryPilotRequested =>
    Uri.base.queryParameters['story'] == forbiddenCitySecondStoryPilotQueryValue;

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

const _storySupport = <(String vietnamese, String english)>[
  (
    'Trước lúc bàn giao, Lâm Kiều đẩy cuốn sổ ghi chép địa điểm đến trước mặt đồng nghiệp mới Hứa Trừng. Ngày hôm sau Hứa Trừng sẽ tiếp nhận cuốn sổ này. Anh lật đến trang ký tên và hỏi: “Ngày mai tôi cứ làm theo những gì ghi ở đây sao?” Lâm Kiều vốn đã mở nắp bút, nhưng lại đặt bút xuống bàn: “Trước tiên cùng đối chiếu một lượt.”',
    'Before the handoff, Lin Qiao slides the location record book toward her new colleague Xu Cheng. He will take over the record the next day. Turning to the signature page, he asks, “Tomorrow, do I just follow what is written here?” Lin Qiao has already uncapped her pen, but sets it back on the desk. “Let’s check it together first.”',
  ),
  (
    'Hai người xem từ những trang trước về sau. Hứa Trừng khoanh “trục giữa”, rồi đánh dấu bên cạnh “Cảnh Vận Môn”: “Hai cái này tôi vẫn dễ nhầm.” Lâm Kiều không đọc đáp án thay anh, chỉ bảo anh đánh dấu trước những chỗ chưa chắc chắn.',
    'They work through the earlier pages. Xu Cheng circles “central axis” and marks “Jingyun Gate.” “I still mix these two up.” Lin Qiao does not recite the answers for him. She asks him to mark the uncertain points first.',
  ),
  (
    'Khi lật đến bảng cũ, họ thấy Cảnh Vận Môn được đánh dấu ở phía tây quảng trường trước Càn Thanh Môn. Hứa Trừng ngẩng lên: “Nếu ngày mai tôi đi theo bảng này thì sao?” Tay Lâm Kiều dừng trên ô ký tên. Vốn chỉ còn thiếu một chữ ký là xong bàn giao, nhưng giờ cô không thể để nghi vấn này lại cho người tiếp nhận.',
    'On the old sheet they find Jingyun Gate marked on the west side of the square before Qianqing Gate. Xu Cheng looks up. “What if I follow this sheet tomorrow?” Lin Qiao’s hand stops over the signature line. She had been one signature away from finishing the handoff, but now she cannot leave the question to the person taking over.',
  ),
  (
    'Hai người trải trang sơ đồ trên bàn và kiểm tra cùng một vị trí: Cảnh Vận Môn nằm ở phía đông quảng trường trước Càn Thanh Môn. Hứa Trừng dùng bút chì khoanh chữ “tây” trên bảng cũ, chưa xóa ngay, chờ Lâm Kiều quyết định trang này nên được bàn giao thế nào.',
    'They spread the diagram on the desk and verify the same point: Jingyun Gate lies on the east side of the square before Qianqing Gate. Xu Cheng circles the old sheet’s “west” in pencil without erasing it yet, waiting for Lin Qiao to decide how the page should be handed over.',
  ),
  (
    'Lâm Kiều không chỉ đổi “tây” thành “đông”. Cô bảo Hứa Trừng ghi lại câu hỏi vừa rồi ở lề trang, rồi hai người tiếp tục kiểm tra trang bàn giao: điều gì xác nhận được thì sửa ngay, điều gì chưa xác nhận được thì để trống trước. Lâm Kiều ký vào chỗ sửa rồi đưa bút cho Hứa Trừng: “Sau khi tiếp nhận, cậu cũng cứ theo cách này mà kiểm tra tiếp.”',
    'Lin Qiao does more than change “west” to “east.” She asks Xu Cheng to write his question in the margin, and they keep checking the handoff page: correct what they can confirm now, and leave unsupported items blank. Lin Qiao signs beside the correction and hands him the pen. “After you take over, keep checking it this way.”',
  ),
  (
    'Cuốn sổ sẽ được bàn giao vào ngày hôm sau không còn giả vờ rằng ô nào cũng có đáp án. Hứa Trừng nhận sổ rồi chỉ vào hai ô trống: “Hai mục này tôi tiếp tục kiểm tra, đúng không?” Lâm Kiều gật đầu. Một lần bàn giao vốn chỉ cần chữ ký của cô giờ đã thành việc cả hai người đều biết bước tiếp theo phải làm gì.',
    'The record going out the next day no longer pretends that every box has an answer. Xu Cheng takes the book and points to two blanks. “I continue checking these two, right?” Lin Qiao nods. A handoff that once needed only her signature has become one in which both people know what comes next.',
  ),
  (
    'Hứa Trừng chưa vội cất cuốn sổ. Anh gấp góc ô cuối cùng còn chờ kiểm tra rồi đặt bút ký giữa hai người: “Xem nốt trang sau cùng nhau nhé?” Lâm Kiều kéo ghế lại gần.',
    'Xu Cheng does not put the book away. He folds the corner beside the last unchecked box and sets the pen between them. “Shall we finish the next page together?” Lin Qiao pulls her chair closer.',
  ),
];

const _vocabularyVietnamese = <String, String>{
  '中轴': 'Trục trung tâm trong không gian kiến trúc hoặc đô thị.',
  '景运门': 'Cảnh Vận Môn, một cổng quan trọng ở phía đông quảng trường trước Càn Thanh Môn.',
  '核对': 'Đối chiếu thông tin để kiểm tra xem có thống nhất hay không.',
  '交接': 'Bàn giao công việc, tài liệu hoặc trách nhiệm cho người tiếp nhận.',
};

const _vocabularyEnglish = <String, String>{
  '中轴': 'central axis in an architectural or urban space',
  '景运门': 'Jingyun Gate, an important gate on the east side of the square before Qianqing Gate',
  '核对': 'to cross-check information for consistency',
  '交接': 'to hand over work, records, or responsibility to the next person',
};

const _vocabularySymbols = <String, String>{
  '中轴': '↕️',
  '景运门': '🚪',
  '核对': '✓',
  '交接': '🤝',
};

const _discoverySupport = <(String vietnamese, String english)>[
  (
    'Khi đọc không gian Tử Cấm Thành, “Ngọ Môn” và “trục giữa” không phải cùng một loại thông tin: Ngọ Môn là một cổng cụ thể; trục giữa mô tả chuỗi không gian bắc-nam do cổng, sân và các công trình chính tạo thành. Ngọ Môn nằm trên trục bắc-nam này, nên hiểu tuyến đường cần vừa nhận biết công trình vừa nhận biết quan hệ không gian tổ chức chúng.',
    'In the Forbidden City, “Meridian Gate” and “central axis” are different kinds of spatial information. Meridian Gate is a specific gate; the central axis describes the north-south spatial sequence formed by gates, courtyards, and principal buildings. Because Meridian Gate lies on this axis, reading a route requires recognizing both buildings and the spatial relations that organize them.',
  ),
  (
    'Càn Thanh Môn không chỉ là một cái tên trên bản đồ. Tư liệu đã kiểm chứng cho biết đây là chính môn của Nội đình và cũng là lối đi quan trọng nối việc qua lại giữa Nội đình và Ngoại triều. Vì vậy khi học về Càn Thanh Môn, cần hiểu cả tên gọi lẫn những không gian mà cổng kết nối.',
    'Qianqing Gate is more than a name on a map. Verified material identifies it as the principal gate of the Inner Court and an important passage connecting movement between the Inner and Outer Courts. Learning the gate therefore means understanding both its name and the spaces it connects.',
  ),
  (
    'Chỉ ghi nhớ tên công trình riêng lẻ chưa đủ để phán đoán quan hệ không gian. Tư liệu đã kiểm chứng đặt Cảnh Vận Môn ở phía đông quảng trường trước Càn Thanh Môn, đồng thời cho thấy các cổng, sân và công trình chính trên trục giữa Tử Cấm Thành tạo thành một chuỗi bắc-nam rõ ràng. Khi nhìn đồng thời cổng, quảng trường, phương hướng và trục, tên gọi mới trở thành thông tin không gian có thể sử dụng.',
    'Memorizing isolated building names is not enough to judge spatial relations. Verified sources place Jingyun Gate on the east side of the square before Qianqing Gate and describe the gates, courtyards, and principal buildings on the Forbidden City’s central axis as a clear north-south sequence. Reading gates, squares, directions, and the axis together turns names into usable spatial information.',
  ),
];

List<String> get forbiddenCitySecondStoryPilotStoryParagraphs =>
    List<String>.unmodifiable(
      forbiddenCityPipelineFixture.storyContent.lines.map((line) => line.text),
    );

List<ReadingAnnotation> _storyAnnotations() {
  final paragraphs = forbiddenCitySecondStoryPilotStoryParagraphs;
  if (paragraphs.length != _storySupport.length) {
    throw StateError('Second Story support must align with canonical Story lines.');
  }
  return List<ReadingAnnotation>.generate(
    paragraphs.length,
    (index) => ReadingAnnotation(
      pinyin: _pinyin(paragraphs[index]),
      vietnamese: _storySupport[index].$1,
      english: _storySupport[index].$2,
    ),
    growable: false,
  );
}

List<WordEntry> _words() => List<WordEntry>.unmodifiable(
      forbiddenCityPipelineFixture.vocabulary.map(
        (item) => WordEntry(
          word: item.word,
          pinyin: item.pinyin,
          partOfSpeech: item.partOfSpeech,
          simpleChinese: item.simpleChinese,
          translation: _vocabularyVietnamese[item.word] ?? item.simpleChinese,
          englishDefinition: _vocabularyEnglish[item.word] ?? item.simpleChinese,
          symbol: _vocabularySymbols[item.word] ?? '•',
        ),
      ),
    );

List<DiscoveryEntry> _discoveries() {
  final discoveries = forbiddenCityPipelineFixture.discoveries;
  if (discoveries.length != _discoverySupport.length) {
    throw StateError('Second Story Discovery support must align with fixture.');
  }
  return List<DiscoveryEntry>.generate(
    discoveries.length,
    (index) {
      final item = discoveries[index];
      return DiscoveryEntry(
        text: item.text,
        pinyin: _pinyin(item.text),
        simpleChinese: item.text,
        vietnamese: _discoverySupport[index].$1,
        english: _discoverySupport[index].$2,
        sourceRefs: item.sourceRefs,
      );
    },
    growable: false,
  );
}

JourneyLevelContent forbiddenCitySecondStoryPilotLevelContent() =>
    JourneyLevelContent(
      storyParagraphs: forbiddenCitySecondStoryPilotStoryParagraphs,
      storyAnnotations: _storyAnnotations(),
      words: _words(),
      discoveries: _discoveries(),
      wonderQuestion: '',
      expressQuestion: '',
    );

List<String> get forbiddenCitySecondStoryPilotChallengeSourceMaterial =>
    List<String>.unmodifiable(
      forbiddenCityPipelineFixture.challenges
          .map((item) => '${item.targetText}。'),
    );

JourneyPreparedBundle forbiddenCitySecondStoryPilotPreparedBundle({
  required int phoenixLevel,
  required String scriptMode,
}) {
  final content = forbiddenCitySecondStoryPilotLevelContent();
  return JourneyPreparedBundle(
    key: JourneyPreparationKey(
      journeyId: forbiddenCityJourneyId,
      phoenixLevel: phoenixLevel,
      scriptMode: scriptMode,
    ),
    levelContent: content,
    narrationItems: content.storyParagraphs,
    challengeSourceMaterial: forbiddenCitySecondStoryPilotChallengeSourceMaterial,
    layoutMetadata: JourneyLayoutMetadata(
      storyCharacterCount: content.storyParagraphs.fold<int>(
        0,
        (total, paragraph) => total + paragraph.length,
      ),
    ),
  );
}

StoryChallengeSet forbiddenCitySecondStoryPilotChallengeSet(int phoenixLevel) {
  final generated = const JourneyChallengeEngine().build(
    journeyId: forbiddenCitySecondStoryPilotChallengeRuntimeId,
    sessionLevel: phoenixLevel,
    storyParagraphs: forbiddenCitySecondStoryPilotChallengeSourceMaterial,
  );
  return StoryChallengeSet(
    journeyId: forbiddenCityJourneyId,
    sessionLevel: generated.sessionLevel,
    questions: generated.questions,
  );
}

ForbiddenCityMemoryMoment forbiddenCitySecondStoryPilotMemoryForLevel(
  int level,
) {
  final safeLevel = level.clamp(1, 10).toInt();
  final memory = forbiddenCityPipelineFixture.memory;
  return ForbiddenCityMemoryMoment(
    level: safeLevel,
    anchor: memory.storyAnchor.text,
    recall: memory.knowledgeTakeaway.text,
    characterShift: memory.characterMoment.text,
    takeaway: memory.vocabularyRecall.text,
  );
}

ForbiddenCityCompletionMoment forbiddenCitySecondStoryPilotCompletionForLevel(
  int level,
) {
  final memory = forbiddenCityPipelineFixture.memory;
  final storyEnding = forbiddenCityPipelineFixture.storyContent.lines.last.text;
  return ForbiddenCityCompletionMoment(
    level: level.clamp(1, 10).toInt(),
    storyClosure: memory.characterMoment.text,
    discovery: memory.knowledgeTakeaway.text,
    learning: '交接 / 核对 / 中轴 / 景运门',
    memory: memory.storyAnchor.text,
    relationship: memory.characterMoment.text,
    emotionalClosure: storyEnding,
    unlockResult: '《交接前的标记》Pilot 已完成。',
  );
}
