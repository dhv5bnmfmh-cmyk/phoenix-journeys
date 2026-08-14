import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'luoyang_longmen_one_pass.dart';

class _LongmenMasterySupplement {
  const _LongmenMasterySupplement({
    required this.fromLevel,
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final int fromLevel;
  final String chinese;
  final String vietnamese;
  final String english;
}

const _longmenMasterySupplements = <_LongmenMasterySupplement>[
  _LongmenMasterySupplement(
    fromLevel: 7,
    chinese: '周澄还把每个画面旁边的来源编号写进清单，让“谁提供了依据”不再藏在制作流程末端。',
    vietnamese: 'Chu Trừng còn ghi mã nguồn bên cạnh từng hình ảnh trong danh sách, để câu hỏi “ai cung cấp căn cứ này” không còn bị giấu ở cuối quy trình sản xuất.',
    english: 'Zhou Cheng also puts a source identifier beside each image in the production list, so “who provided the evidence” is no longer hidden at the end of the workflow.',
  ),
  _LongmenMasterySupplement(
    fromLevel: 8,
    chinese: '林砚也不再把周澄的核对当作收尾审查，而把它变成共同创作开始时必须完成的一步。',
    vietnamese: 'Lâm Nghiên cũng không còn xem việc Chu Trừng kiểm tra là khâu xét duyệt cuối cùng; cô biến nó thành một bước phải hoàn thành ngay khi hai người bắt đầu đồng sáng tạo.',
    english: 'Lin Yan no longer treats Zhou Cheng’s verification as a final review; she turns it into a step that must happen when their joint creation begins.',
  ),
  _LongmenMasterySupplement(
    fromLevel: 9,
    chinese: '观众最后看到的不是一个被“补好”的过去，而是三个能区分的时间层：今天的石面、历史照片和有据复原。',
    vietnamese: 'Điều khán giả cuối cùng thấy không phải một quá khứ đã được “bù cho hoàn chỉnh”, mà là ba lớp thời gian có thể phân biệt: mặt đá hôm nay, ảnh lịch sử và phục dựng có căn cứ.',
    english: 'What viewers finally see is not a past that has been “completed,” but three distinguishable time layers: the stone today, historical photographs, and evidence-based restoration.',
  ),
  _LongmenMasterySupplement(
    fromLevel: 10,
    chinese: '她知道以后还会遇到无法补齐的缺口；这次留下的不是一个方便答案，而是一条可以重复使用的工作边界。',
    vietnamese: 'Cô biết sau này vẫn sẽ gặp những khoảng trống không thể lấp đầy; điều còn lại từ lần này không phải một câu trả lời thuận tiện mà là một ranh giới làm việc có thể tiếp tục áp dụng.',
    english: 'She knows she will meet gaps that cannot be filled again; what remains from this choice is not a convenient answer but a working boundary she can apply repeatedly.',
  ),
];

JourneyLevelContent luoyangLongmenGoldLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = luoyangLongmenOnePassLevelContent(level);
  final supplements = _longmenMasterySupplements
      .where((item) => level >= item.fromLevel)
      .toList(growable: false);
  if (supplements.isEmpty) return base;

  final paragraphs = List<String>.of(base.storyParagraphs);
  final annotations = List<ReadingAnnotation>.of(base.storyAnnotations);
  final lastIndex = paragraphs.length - 1;
  paragraphs[lastIndex] =
      '${paragraphs[lastIndex]}${supplements.map((item) => item.chinese).join()}';
  final previous = annotations[lastIndex];
  annotations[lastIndex] = ReadingAnnotation(
    pinyin: PinyinHelper.getPinyinE(
      paragraphs[lastIndex],
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    ),
    vietnamese:
        '${previous.vietnamese} ${supplements.map((item) => item.vietnamese).join(' ')}',
    english:
        '${previous.english} ${supplements.map((item) => item.english).join(' ')}',
  );

  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: base.words,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}
