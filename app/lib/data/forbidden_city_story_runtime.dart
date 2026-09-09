import 'package:pinyin/pinyin.dart';

import '../models/content_pipeline.dart';
import '../models/journey_prepared_bundle.dart';
import 'forbidden_city_content_pipeline_fixture.dart';
import 'forbidden_city_second_story_levels.dart';
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
  if (storyId == null || storyId.trim().isEmpty) {
    return forbiddenCityPrimaryStoryId;
  }
  if (storyId == forbiddenCityPrimaryStoryId ||
      storyId == forbiddenCitySecondStoryId) {
    return storyId;
  }
  throw StateError('Unknown Forbidden City Story: $storyId');
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

class _SecondStoryLevelSpec {
  const _SecondStoryLevelSpec({
    required this.story,
    required this.vietnamese,
    required this.english,
  });

  final List<String> story;
  final List<String> vietnamese;
  final List<String> english;
}

const _secondStoryLevels = <_SecondStoryLevelSpec>[
  _SecondStoryLevelSpec(
    story: [
      '交接前，林乔把记录册推给许澄。许澄明天要接手，问能不能照表使用。林乔说：“先核对。”两人先看中轴和记录里的宫门名称。',
      '他们发现有一处还没看清。林乔没有急着签字，只让许澄把问题圈出来。她说，交接不是把记录册递过去就结束，而是要让接手的人知道哪些内容已经核对。',
    ],
    vietnamese: [
      'Trước khi bàn giao, Lâm Kiều đưa sổ ghi chép cho Hứa Trừng. Ngày mai anh sẽ tiếp nhận công việc và hỏi có thể dùng bảng ngay không. Lâm Kiều nói: “Đối chiếu trước.” Hai người bắt đầu từ trục giữa và tên các cổng trong ghi chép.',
      'Họ thấy một chỗ vẫn chưa rõ. Lâm Kiều không vội ký, chỉ bảo Hứa Trừng khoanh vấn đề. Cô giải thích rằng bàn giao không kết thúc ở việc trao sổ, mà phải để người tiếp nhận biết nội dung nào đã được đối chiếu.',
    ],
    english: [
      'Before the handoff, Lin Qiao gives the record book to Xu Cheng. He will take over tomorrow and asks whether he can simply follow the sheet. Lin Qiao says, “Check it first.” They begin with the central axis and the gate names in the record.',
      'They find one point that is still unclear. Lin Qiao does not rush to sign; she asks Xu Cheng to circle the question. A handoff is not complete when the book changes hands. The next person must know what has actually been checked.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '交接前，林乔和许澄按页码核对记录。许澄先看中轴，又看到“景运门”这个名称。他问：“名称写对了，就能直接照表走吗？”',
      '林乔让他继续查位置。两人确认景运门要结合具体方位判断，不能只靠中轴这个整体框架。许澄在页码旁做了记号，准备把核对结果留给下一步交接。',
    ],
    vietnamese: [
      'Trước khi bàn giao, Lâm Kiều và Hứa Trừng đối chiếu theo số trang. Hứa Trừng xem trục giữa rồi thấy tên Cảnh Vận Môn. Anh hỏi liệu tên đúng có nghĩa là có thể đi theo bảng ngay không.',
      'Lâm Kiều bảo anh kiểm tra vị trí. Hai người xác nhận Cảnh Vận Môn phải được xác định bằng phương vị cụ thể, không thể chỉ dựa vào khung trục giữa. Hứa Trừng đánh dấu bên số trang để lưu kết quả cho bước bàn giao tiếp theo.',
    ],
    english: [
      'Before the handoff, Lin Qiao and Xu Cheng check the record by page number. Xu Cheng reviews the central axis and then sees the name Jingyun Gate. He asks whether a correct name is enough to trust the sheet.',
      'Lin Qiao asks him to verify the location. They confirm that Jingyun Gate requires concrete directional evidence, not just the overall axis framework. Xu Cheng marks the page so the result can travel with the handoff.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '林乔把记录册摊在桌上，许澄一边核对中轴，一边看景运门和乾清门。他把两种信息混在一起，遇到不确定处就想先猜一个答案。',
      '林乔让他停下来区分：中轴是整体空间序列，景运门和乾清门是具体宫门。两人重新核对后，许澄把不确定处标出来，不再用一个名称代替另一类空间信息。',
    ],
    vietnamese: [
      'Lâm Kiều trải sổ ra, Hứa Trừng vừa đối chiếu trục giữa vừa xem Cảnh Vận Môn và Càn Thanh Môn. Anh trộn lẫn hai loại thông tin và định đoán trước ở chỗ chưa chắc.',
      'Lâm Kiều yêu cầu phân biệt: trục giữa là chuỗi không gian tổng thể, còn Cảnh Vận Môn và Càn Thanh Môn là cổng cụ thể. Sau khi đối chiếu lại, Hứa Trừng đánh dấu chỗ chưa chắc thay vì dùng một tên thay cho một loại thông tin khác.',
    ],
    english: [
      'Lin Qiao opens the record book while Xu Cheng checks the central axis, Jingyun Gate, and Qianqing Gate. He mixes the two kinds of information and wants to guess at an uncertain point.',
      'Lin Qiao makes him separate them: the axis describes an overall spatial sequence, while Jingyun Gate and Qianqing Gate are specific gates. After checking again, Xu Cheng marks the uncertain point instead of substituting one category of information for another.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '翻到一个旧页码时，许澄发现乾清门前的景运门被写在西侧。他在不确定处提出疑问：“如果旧表错了，我现在直接改吗？”林乔让他先保留原记录。',
      '两人用图页核对后，确认景运门位于乾清门前广场东侧。许澄把疑问写在页边，并保留旧页码和原来的“西”字。这样后来的人能看见错误从哪里来，也能看见东侧结论依据什么成立。',
    ],
    vietnamese: [
      'Ở một trang cũ, Hứa Trừng thấy Cảnh Vận Môn trước Càn Thanh Môn bị ghi ở phía tây. Tại chỗ chưa chắc anh hỏi liệu có nên sửa ngay. Lâm Kiều yêu cầu giữ lại bản ghi gốc trước.',
      'Họ đối chiếu bản đồ và xác nhận Cảnh Vận Môn nằm ở phía đông quảng trường trước Càn Thanh Môn. Hứa Trừng ghi nghi vấn bên lề, giữ số trang cũ và chữ “tây” ban đầu để người sau thấy nguồn lỗi và căn cứ cho kết luận phía đông.',
    ],
    english: [
      'On an old page, Xu Cheng finds Jingyun Gate recorded on the west side before Qianqing Gate. At the uncertain point he asks whether he should correct it immediately. Lin Qiao tells him to preserve the original entry first.',
      'They verify on the map that Jingyun Gate is on the east side of the square before Qianqing Gate. Xu Cheng records the question in the margin and keeps the old page number and original “west” mark so a later reader can trace both the error and the evidence for the correction.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '交接前，林乔把记录册推到许澄面前。许澄第二天就要接手，先圈出“中轴”和“景运门”。他问能不能把看起来不对的地方全部改掉，林乔回答：“先核对，再分清已确认和待核。”',
      '两人确认景运门位于乾清门前广场东侧，也确认中轴只是整体空间框架。能确认的当场更正，不能确认的保留待核标记。林乔最后才签下交接，让许澄知道每一处改动都要能说明依据。',
    ],
    vietnamese: [
      'Trước khi bàn giao, Lâm Kiều đưa sổ cho Hứa Trừng. Anh sẽ tiếp nhận vào ngày hôm sau, khoanh “trục giữa” và “Cảnh Vận Môn”, rồi hỏi có nên sửa hết những gì trông có vẻ sai không. Lâm Kiều nói: “Đối chiếu trước, rồi tách phần đã xác nhận và phần chờ kiểm tra.”',
      'Họ xác nhận Cảnh Vận Môn ở phía đông quảng trường trước Càn Thanh Môn và trục giữa chỉ là khung không gian tổng thể. Điều đã xác nhận được sửa ngay, điều chưa chắc được giữ trạng thái chờ kiểm tra. Lâm Kiều chỉ ký bàn giao khi mỗi thay đổi đều có căn cứ.',
    ],
    english: [
      'Before the handoff, Lin Qiao pushes the record book to Xu Cheng. He will take over the next day, circles “central axis” and “Jingyun Gate,” and asks whether he should correct everything that looks wrong. Lin Qiao replies, “Verify first, then separate confirmed items from pending ones.”',
      'They confirm Jingyun Gate on the east side of the square before Qianqing Gate and confirm that the axis is only an overall spatial framework. Confirmed items are corrected; uncertain items remain pending. Lin Qiao signs only after every change has an explainable basis.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '林乔和许澄把中轴、景运门、乾清门放在同一张图页上核对。许澄发现，中轴说明整体南北秩序，具体宫门和东西方位却需要另一层证据。交接时如果把这些信息混成一类，接手者很容易误判。',
      '两人把确认项写清，把暂时不能确认的空格保留下来。景运门位于乾清门前广场东侧的结论单独记录，乾清门连接外朝与内廷的关系也单独记录。林乔说：“好的交接不是填满所有空格，而是让下一位知道怎样继续核对。”',
    ],
    vietnamese: [
      'Lâm Kiều và Hứa Trừng đặt trục giữa, Cảnh Vận Môn và Càn Thanh Môn trên cùng một trang để đối chiếu. Hứa Trừng nhận ra trục giữa mô tả trật tự bắc–nam tổng thể, còn cổng cụ thể và phương hướng đông–tây cần một lớp bằng chứng khác.',
      'Họ ghi rõ phần đã xác nhận và giữ ô trống cho phần chưa chắc. Vị trí phía đông của Cảnh Vận Môn và quan hệ Càn Thanh Môn nối Ngoại triều với Nội đình được ghi riêng. Lâm Kiều nói bàn giao tốt không phải là lấp mọi ô, mà là để người sau biết cách tiếp tục kiểm tra.',
    ],
    english: [
      'Lin Qiao and Xu Cheng place the central axis, Jingyun Gate, and Qianqing Gate on the same page for comparison. Xu Cheng sees that the axis describes the overall north-south order, while named gates and east-west positions require a different layer of evidence.',
      'They write confirmed items clearly and leave a blank where evidence is incomplete. Jingyun Gate’s east-side position and Qianqing Gate’s connection between the Outer and Inner Courts are recorded separately. Lin Qiao says a good handoff does not fill every blank; it tells the next person how to keep checking.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '许澄想把旧页上可疑的内容一次更正。林乔指着乾清门前广场的记录问：“有证据确认了吗？”许澄发现，有些疑问已经能回答，有些仍然待核。',
      '他们先确认景运门的东侧位置，再决定哪些地方可以更正、哪些地方应该留空。许澄把确认依据和疑问写在旁边，没有为了让表格完整而猜答案。林乔说，可追溯的交接要把“确认”和“待核”分开。',
    ],
    vietnamese: [
      'Hứa Trừng muốn đính chính toàn bộ nội dung đáng ngờ trên trang cũ. Lâm Kiều chỉ vào ghi chép trước Càn Thanh Môn và hỏi liệu đã có bằng chứng xác nhận chưa. Anh nhận ra có nghi vấn đã giải quyết được và có mục vẫn chờ kiểm tra.',
      'Họ xác nhận vị trí phía đông của Cảnh Vận Môn trước, rồi quyết định phần nào có thể đính chính và phần nào nên để trống. Hứa Trừng ghi căn cứ xác nhận và nghi vấn bên cạnh, không đoán chỉ để bảng trông đầy đủ. Lâm Kiều nhấn mạnh phải tách phần “đã xác nhận” khỏi “chờ kiểm tra”.',
    ],
    english: [
      'Xu Cheng wants to correct every suspicious item on the old page at once. Lin Qiao points to the record before Qianqing Gate and asks whether the evidence is confirmed. He realizes some questions are resolved while others are still pending.',
      'They confirm Jingyun Gate’s east-side position first, then decide which entries can be corrected and which should remain blank. Xu Cheng records both the evidence and the unresolved question instead of guessing for completeness. Lin Qiao says traceable handoff records must separate confirmed from pending.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '第二天就要接手的许澄重新检查记录册。他从景运门、乾清门和东侧方位开始，不只问“最后答案是什么”，还追问“这个更正根据哪一页、哪一种空间事实”。',
      '林乔让他保留原标记，再写更正和核对依据。许澄发现，接手不是复制上一人的结论，而是能够沿同一证据重新检查。他把景运门位于乾清门前广场东侧的依据写清，也把仍未完成的项目留给自己继续追查。',
    ],
    vietnamese: [
      'Sắp tiếp nhận công việc, Hứa Trừng kiểm tra lại sổ. Anh bắt đầu từ Cảnh Vận Môn, Càn Thanh Môn và phương vị phía đông, không chỉ hỏi đáp án cuối mà còn hỏi mỗi đính chính dựa vào trang nào và sự kiện không gian nào.',
      'Lâm Kiều yêu cầu giữ dấu cũ rồi mới ghi đính chính và căn cứ. Hứa Trừng hiểu rằng tiếp nhận không phải sao chép kết luận của người trước, mà phải có thể kiểm lại cùng một bằng chứng. Anh ghi rõ căn cứ vị trí Cảnh Vận Môn và để những mục chưa xong cho mình tiếp tục truy xét.',
    ],
    english: [
      'About to take over, Xu Cheng reviews the record book again. Starting with Jingyun Gate, Qianqing Gate, and the east-side position, he asks not only for the final answer but also which page and which spatial fact support each correction.',
      'Lin Qiao has him preserve the original mark before adding a correction and its evidence. Xu Cheng learns that taking over is not copying someone else’s conclusion; it is being able to recheck the same evidence. He writes the basis for Jingyun Gate’s location and keeps unfinished items for further work.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '交接前最后一轮复核中，许澄把每个不确定处分成几类：可以确认的更正，证据不足的留空，仍需追查的标为待核。他同时记录页码、原标记、核对依据和确认结果。',
      '林乔检查完没有只看最后答案，而是看整条记录链是否能追溯。许澄在已确认的更正旁签名，在待核项目旁保留问题。这样下一位接手者不用相信某个人的记忆，也能从页码和证据独立复核。',
    ],
    vietnamese: [
      'Trong vòng kiểm tra cuối trước bàn giao, Hứa Trừng chia các chỗ chưa chắc thành: có thể xác nhận và đính chính, chưa đủ bằng chứng nên để trống, hoặc vẫn phải đánh dấu chờ kiểm tra. Anh ghi số trang, dấu gốc, căn cứ và kết quả xác nhận.',
      'Lâm Kiều không chỉ xem đáp án cuối mà kiểm tra xem toàn bộ chuỗi ghi chép có truy vết được không. Hứa Trừng ký cạnh phần đã xác nhận và giữ câu hỏi cạnh mục chờ kiểm tra. Nhờ vậy người tiếp nhận sau có thể kiểm độc lập từ số trang và bằng chứng.',
    ],
    english: [
      'In the final review before handoff, Xu Cheng classifies every uncertain point: confirmed and correctable, insufficiently supported and left blank, or still marked pending. He records the page number, original mark, evidence, and confirmation result.',
      'Lin Qiao checks not just the final answers but whether the whole record chain is traceable. Xu Cheng signs beside confirmed corrections and preserves questions beside pending items. The next person can therefore verify independently from the page references and evidence.',
    ],
  ),
  _SecondStoryLevelSpec(
    story: [
      '林乔把最后一册交给许澄前，请他独立说明整套核对方法。许澄先区分中轴的整体框架、景运门和乾清门的具体空间事实，再把每个不确定处按证据状态分成已确认、更正和待核。',
      '他说明景运门位于乾清门前广场东侧需要具体位置证据，乾清门连接外朝与内廷属于另一类空间关系；交接记录还必须保留页码、原标记、核对依据和责任状态。林乔最后签字，因为许澄已经能让另一位接手者不靠猜测就复核同一结论。',
    ],
    vietnamese: [
      'Trước khi trao cuốn sổ cuối cùng, Lâm Kiều yêu cầu Hứa Trừng tự giải thích toàn bộ phương pháp. Anh phân biệt khung trục giữa với các sự kiện cụ thể về Cảnh Vận Môn và Càn Thanh Môn, rồi phân loại từng chỗ chưa chắc theo trạng thái bằng chứng: đã xác nhận, đính chính hoặc chờ kiểm tra.',
      'Anh giải thích vị trí phía đông của Cảnh Vận Môn cần bằng chứng vị trí cụ thể, còn Càn Thanh Môn nối Ngoại triều và Nội đình là một quan hệ không gian khác. Hồ sơ bàn giao còn phải giữ số trang, dấu gốc, căn cứ và trạng thái trách nhiệm. Lâm Kiều ký vì Hứa Trừng đã có thể giúp người sau kiểm lại cùng kết luận mà không cần đoán.',
    ],
    english: [
      'Before handing over the final book, Lin Qiao asks Xu Cheng to explain the complete verification method independently. He separates the overall central-axis framework from specific facts about Jingyun Gate and Qianqing Gate, then classifies each uncertain point by evidence status: confirmed, corrected, or pending.',
      'He explains that Jingyun Gate’s east-side position needs concrete location evidence, while Qianqing Gate’s connection between the Outer and Inner Courts is a different spatial relation. The handoff record must also preserve page references, original marks, evidence, and responsibility status. Lin Qiao signs because Xu Cheng can now make the same conclusion independently reviewable by the next person.',
    ],
  ),
];

const _secondStoryMemoryMoments = <ForbiddenCityMemoryMoment>[
  ForbiddenCityMemoryMoment(
    level: 1,
    anchor: '先核对再交接',
    recall: '林乔让许澄先核对记录册，而不是直接照表使用。',
    characterShift: '许澄开始接受“先检查再接手”的工作方式。',
    takeaway: '交接的第一步是知道哪些信息已经核对。',
  ),
  ForbiddenCityMemoryMoment(
    level: 2,
    anchor: '名称不等于方位',
    recall: '许澄用页码追到景运门，并发现中轴不能替代具体位置证据。',
    characterShift: '两人从看名称转向一起核方位。',
    takeaway: '整体框架不能替代具体宫门的位置证据。',
  ),
  ForbiddenCityMemoryMoment(
    level: 3,
    anchor: '先区分信息类型',
    recall: '许澄分清中轴、景运门和乾清门不是同一类信息。',
    characterShift: '他不再在不确定处直接猜答案。',
    takeaway: '核对前先分清整体结构与具体节点。',
  ),
  ForbiddenCityMemoryMoment(
    level: 4,
    anchor: '保留错误的来路',
    recall: '两人保留旧页码和原来的“西”字，再记录东侧结论。',
    characterShift: '林乔把更正变成可追溯的共同工作。',
    takeaway: '好的更正既留下新答案，也留下旧错误和依据。',
  ),
  ForbiddenCityMemoryMoment(
    level: 5,
    anchor: '已确认与待核',
    recall: '能确认的当场更正，不能确认的保留待核。',
    characterShift: '林乔最后才签下交接，许澄开始承担后续核对。',
    takeaway: '交接质量取决于确认状态是否清楚。',
  ),
  ForbiddenCityMemoryMoment(
    level: 6,
    anchor: '空格也可以是证据状态',
    recall: '两人把中轴、宫门、方位和空格分别记录。',
    characterShift: '许澄理解不填满不等于没完成工作。',
    takeaway: '证据不足时，明确留空比猜测更可靠。',
  ),
  ForbiddenCityMemoryMoment(
    level: 7,
    anchor: '更正之前先问证据',
    recall: '许澄先确认景运门方位，再决定更正或留空。',
    characterShift: '他开始用证据状态管理疑问。',
    takeaway: '确认、待核和留空必须由证据决定。',
  ),
  ForbiddenCityMemoryMoment(
    level: 8,
    anchor: '接手意味着能复核',
    recall: '许澄追问每个更正对应的页码和空间事实。',
    characterShift: '他从接收结论转向能够独立复核。',
    takeaway: '可复核性比复制上一人的答案更重要。',
  ),
  ForbiddenCityMemoryMoment(
    level: 9,
    anchor: '一条可追溯的记录链',
    recall: '页码、原标记、核对依据、确认结果和签名连成一条链。',
    characterShift: '林乔开始按可追溯性检查许澄的交接。',
    takeaway: '不同接手者应能沿同一证据复核同一结论。',
  ),
  ForbiddenCityMemoryMoment(
    level: 10,
    anchor: '让下一位不靠猜测',
    recall: '许澄独立说明中轴、宫门、方位和证据状态的关系。',
    characterShift: '林乔在确认他能把方法继续传下去后才签字。',
    takeaway: '高质量交接让结论、依据和未决状态都可独立复核。',
  ),
];

const _secondStoryCompletionMoments = <ForbiddenCityCompletionMoment>[
  ForbiddenCityCompletionMoment(
    level: 1,
    storyClosure: '林乔没有直接签字，而是让许澄先核对记录册。',
    discovery: '你分清了中轴和记录中的基础信息。',
    learning: '你能说明交接前为什么要先核对。',
    memory: '先核对再交接',
    relationship: '许澄开始从被动接手转向主动检查。',
    emotionalClosure: '这次交接从一个问题开始变得可靠。',
    unlockResult: 'Lv1 Story 已按基础核对规则完成。',
  ),
  ForbiddenCityCompletionMoment(
    level: 2,
    storyClosure: '许澄把景运门和页码一起留下，准备继续核对位置。',
    discovery: '你理解名称与方位证据不是一回事。',
    learning: '你能用页码和具体位置说明信息来源。',
    memory: '名称不等于方位',
    relationship: '林乔开始让许澄自己追证据。',
    emotionalClosure: '记录不再只是答案，也带上了来路。',
    unlockResult: 'Lv2 Story 已完成具体方位核对。',
  ),
  ForbiddenCityCompletionMoment(
    level: 3,
    storyClosure: '许澄不再用中轴替代具体宫门，也不在不确定处猜答案。',
    discovery: '你能区分整体空间序列与具体宫门。',
    learning: '你能按信息类型组织核对。',
    memory: '先区分信息类型',
    relationship: '两人的合作从纠正名称升级为分类证据。',
    emotionalClosure: '问题被分清以后，核对才真正开始。',
    unlockResult: 'Lv3 Story 已完成信息分类。',
  ),
  ForbiddenCityCompletionMoment(
    level: 4,
    storyClosure: '两人保留旧页码和原来的“西”，再记录景运门东侧的依据。',
    discovery: '你看见更正必须保留错误来源。',
    learning: '你能解释为什么追溯比直接擦改更可靠。',
    memory: '保留错误的来路',
    relationship: '许澄开始为后来接手者留下证据链。',
    emotionalClosure: '一个改正的字，终于有了可以回看的过程。',
    unlockResult: 'Lv4 Story 已完成可追溯更正。',
  ),
  ForbiddenCityCompletionMoment(
    level: 5,
    storyClosure: '林乔把已确认项与待核项分开后才签下交接。',
    discovery: '你把中轴、景运门和确认状态放在同一核对过程里。',
    learning: '你能区分“已确认”和“待核”。',
    memory: '已确认与待核',
    relationship: '许澄开始承担下一步核对责任。',
    emotionalClosure: '交接不再追求表格看起来完整，而追求状态真实。',
    unlockResult: 'Lv5 Story 已完成确认状态管理。',
  ),
  ForbiddenCityCompletionMoment(
    level: 6,
    storyClosure: '两人让空格保留证据不足的状态，并分别记录宫门与空间关系。',
    discovery: '你能同时使用中轴、景运门、乾清门和方位证据。',
    learning: '你能解释为什么空格有时比猜答案更专业。',
    memory: '空格也可以是证据状态',
    relationship: '林乔把方法交给许澄，而不是只把结论交给他。',
    emotionalClosure: '未填的一格反而让记录更诚实。',
    unlockResult: 'Lv6 Story 已完成多类证据核对。',
  ),
  ForbiddenCityCompletionMoment(
    level: 7,
    storyClosure: '许澄用证据决定更正、留空或继续待核。',
    discovery: '你理解不同处理动作必须对应不同证据状态。',
    learning: '你能为更正决定说明依据。',
    memory: '更正之前先问证据',
    relationship: '许澄从执行者变成了判断证据是否足够的人。',
    emotionalClosure: '完整不再是填满，而是每个决定都有理由。',
    unlockResult: 'Lv7 Story 已完成证据驱动更正。',
  ),
  ForbiddenCityCompletionMoment(
    level: 8,
    storyClosure: '许澄能够从页码和空间事实重新检查上一人的结论。',
    discovery: '你理解接手的核心是可复核，而不是复制。',
    learning: '你能把东侧方位、更正和接手过程连接起来。',
    memory: '接手意味着能复核',
    relationship: '林乔开始把复核权真正交给许澄。',
    emotionalClosure: '一份记录开始经得起第二个人重新检查。',
    unlockResult: 'Lv8 Story 已完成独立复核。',
  ),
  ForbiddenCityCompletionMoment(
    level: 9,
    storyClosure: '页码、原标记、依据、确认结果和签名形成完整追溯链。',
    discovery: '你能区分记录版本、证据状态和责任信息。',
    learning: '你能检查一项结论是否真正可追溯。',
    memory: '一条可追溯的记录链',
    relationship: '许澄开始为下一位接手者设计证据路径。',
    emotionalClosure: '交接的重点从“我确认过”变成“你也能确认”。',
    unlockResult: 'Lv9 Story 已完成证据链管理。',
  ),
  ForbiddenCityCompletionMoment(
    level: 10,
    storyClosure: '许澄独立说明空间事实与交接证据，并让下一位能够复核同一结论。',
    discovery: '你把中轴框架、具体宫门、空间关系和记录过程放进同一判断。',
    learning: '你能权衡证据充分性、责任状态和可复核性。',
    memory: '让下一位不靠猜测',
    relationship: '林乔最后签字，因为方法已经能被继续传递。',
    emotionalClosure: '最可靠的交接，不要求相信某个人，而允许别人沿证据得到同一结论。',
    unlockResult: 'Lv10 Story 已完成独立可复核交接。',
  ),
];

int _secondStoryLevelIndex(int level) {
  if (level < 1 || level > 10) {
    throw StateError('Second Story requires an explicit Lv1-Lv10 level, got $level');
  }
  return level - 1;
}

JourneyLevelContent forbiddenCitySecondStoryLevelContent({
  required int phoenixLevel,
}) {
  ensureForbiddenCitySecondStoryRuntimeValid();
  final index = _secondStoryLevelIndex(phoenixLevel);
  final spec = _secondStoryLevels[index];
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(spec.story),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(
      <ReadingAnnotation>[
        for (var paragraph = 0; paragraph < spec.story.length; paragraph += 1)
          ReadingAnnotation(
            pinyin: _pinyin(spec.story[paragraph]),
            vietnamese: spec.vietnamese[paragraph],
            english: spec.english[paragraph],
          ),
      ],
    ),
    words: forbiddenCitySecondStoryWordsForLevel(phoenixLevel),
    discoveries: forbiddenCitySecondStoryDiscoveriesForLevel(
      phoenixLevel,
      sourceRefs: List<String>.unmodifiable(
        forbiddenCityPipelineFixture.discoveries
            .expand((item) => item.sourceRefs)
            .toSet(),
      ),
    ),
    wonderQuestion: '',
    expressQuestion: '',
  );
}

List<String> forbiddenCitySecondStoryChallengeSourceMaterialForLevel(int level) {
  final index = _secondStoryLevelIndex(level);
  return List<String>.unmodifiable(_secondStoryLevels[index].story);
}

JourneyPreparedBundle forbiddenCitySecondStoryPreparedBundle({
  required int phoenixLevel,
  required String scriptMode,
}) {
  final content = forbiddenCitySecondStoryLevelContent(
    phoenixLevel: phoenixLevel,
  );
  final paragraphs = List<String>.unmodifiable(content.storyParagraphs);
  return JourneyPreparedBundle(
    key: JourneyPreparationKey(
      journeyId: forbiddenCityJourneyId,
      phoenixLevel: phoenixLevel,
      scriptMode: scriptMode,
    ),
    levelContent: content,
    narrationItems: paragraphs,
    challengeSourceMaterial:
        forbiddenCitySecondStoryChallengeSourceMaterialForLevel(phoenixLevel),
    layoutMetadata: JourneyLayoutMetadata(
      storyCharacterCount: paragraphs.fold<int>(
        0,
        (total, value) => total + value.length,
      ),
    ),
  );
}

ForbiddenCityMemoryMoment forbiddenCitySecondStoryMemoryForLevel(int level) =>
    _secondStoryMemoryMoments[_secondStoryLevelIndex(level)];

ForbiddenCityCompletionMoment forbiddenCitySecondStoryCompletionForLevel(
  int level,
) =>
    _secondStoryCompletionMoments[_secondStoryLevelIndex(level)];

void ensureForbiddenCitySecondStoryRuntimeValid() {
  final package = forbiddenCityPipelineFixture;
  if (_secondStoryLevels.length != 10 ||
      _secondStoryMemoryMoments.length != 10 ||
      _secondStoryCompletionMoments.length != 10) {
    throw StateError('Second Story must provide exactly ten complete level packages.');
  }

  final storyFingerprints = <String>{};
  final vocabularyFingerprints = <String>{};
  final discoveryFingerprints = <String>{};
  final memoryFingerprints = <String>{};
  final completionFingerprints = <String>{};

  for (var level = 1; level <= 10; level += 1) {
    final spec = _secondStoryLevels[level - 1];
    if (spec.story.isEmpty ||
        spec.story.length != spec.vietnamese.length ||
        spec.story.length != spec.english.length ||
        spec.story.any((paragraph) => paragraph.trim().isEmpty) ||
        spec.vietnamese.any((paragraph) => paragraph.trim().isEmpty) ||
        spec.english.any((paragraph) => paragraph.trim().isEmpty)) {
      throw StateError('Second Story Lv$level Story/annotation package is incomplete.');
    }

    final storyText = spec.story.join('\n');
    final words = forbiddenCitySecondStoryWordsForLevel(level);
    final discoveries = forbiddenCitySecondStoryDiscoveriesForLevel(
      level,
      sourceRefs: const <String>['preflight'],
    );
    if (words.isEmpty || discoveries.isEmpty) {
      throw StateError('Second Story Lv$level learning stages are incomplete.');
    }
    for (final word in words) {
      if (!storyText.contains(word.word)) {
        throw StateError(
          'Second Story Lv$level vocabulary "${word.word}" is orphaned from Story.',
        );
      }
    }

    final memory = _secondStoryMemoryMoments[level - 1];
    final completion = _secondStoryCompletionMoments[level - 1];
    if (memory.anchor.trim().isEmpty ||
        memory.recall.trim().isEmpty ||
        memory.characterShift.trim().isEmpty ||
        memory.takeaway.trim().isEmpty ||
        completion.storyClosure.trim().isEmpty ||
        completion.discovery.trim().isEmpty ||
        completion.learning.trim().isEmpty ||
        completion.memory.trim().isEmpty ||
        completion.relationship.trim().isEmpty ||
        completion.emotionalClosure.trim().isEmpty ||
        completion.unlockResult.trim().isEmpty) {
      throw StateError('Second Story Lv$level Memory/Completion is incomplete.');
    }

    storyFingerprints.add(storyText);
    vocabularyFingerprints.add(words.map((word) => word.word).join('|'));
    discoveryFingerprints.add(discoveries.map((item) => item.text).join('|'));
    memoryFingerprints.add(
      '${memory.anchor}|${memory.recall}|${memory.takeaway}',
    );
    completionFingerprints.add(
      '${completion.storyClosure}|${completion.discovery}|${completion.learning}',
    );
  }

  if (storyFingerprints.length != 10 ||
      vocabularyFingerprints.length != 10 ||
      discoveryFingerprints.length != 10 ||
      memoryFingerprints.length != 10 ||
      completionFingerprints.length != 10) {
    throw StateError(
      'Second Story Lv1-Lv10 must have meaningful level-specific content in every learning package.',
    );
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
