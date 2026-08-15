import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
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

WordEntry _longmenStoryWord({
  required String word,
  required String pinyin,
  required String partOfSpeech,
  required String simpleChinese,
  required String vietnamese,
  required String english,
  required String symbol,
  required String sourceSentence,
  required String sourceVietnamese,
  required String sourceEnglish,
}) {
  String canonicalPinyin(String text) => PinyinHelper.getPinyinE(
        text,
        separator: ' ',
        format: PinyinFormat.WITH_TONE_MARK,
      );

  return WordEntry(
    word: word,
    pinyin: pinyin,
    partOfSpeech: partOfSpeech,
    simpleChinese: simpleChinese,
    translation: vietnamese,
    englishDefinition: english,
    symbol: symbol,
    examples: <WordExample>[
      WordExample(
        chinese: sourceSentence,
        pinyin: canonicalPinyin(sourceSentence),
        vietnamese: sourceVietnamese,
        english: sourceEnglish,
      ),
      WordExample(
        chinese: sourceSentence,
        pinyin: canonicalPinyin(sourceSentence),
        vietnamese: sourceVietnamese,
        english: sourceEnglish,
      ),
      WordExample(
        chinese: sourceSentence,
        pinyin: canonicalPinyin(sourceSentence),
        vietnamese: sourceVietnamese,
        english: sourceEnglish,
      ),
    ],
  );
}

final _longmenStorySupplementWords = <WordEntry>[
  _longmenStoryWord(
    word: '模型',
    pinyin: 'móxíng',
    partOfSpeech: '名词',
    simpleChinese: '用来表现物体形态或结构的数字或实体形式。',
    vietnamese: 'mô hình dùng để thể hiện hình dạng hoặc cấu trúc',
    english: 'a model representing form or structure',
    symbol: '🧱',
    sourceSentence: '林砚为了让转场完整，另做了一层“补全脸部”的模型。',
    sourceVietnamese: 'Để đoạn chuyển cảnh trông hoàn chỉnh, Lâm Nghiên làm thêm một lớp mô hình “bù lại khuôn mặt”.',
    sourceEnglish: 'To make the transition feel complete, Lin Yan adds a “completed face” model layer.',
  ),
  _longmenStoryWord(
    word: '照片',
    pinyin: 'zhàopiàn',
    partOfSpeech: '名词',
    simpleChinese: '用摄影方式留下的图像。',
    vietnamese: 'ảnh chụp',
    english: 'photograph',
    symbol: '📷',
    sourceSentence: '官方复原以历史老照片为基础，她这一层却只是按自己理解的唐代造像风格补的。',
    sourceVietnamese: 'Phục dựng chính thức dựa trên ảnh lịch sử cũ; lớp của cô chỉ được bổ theo cách cô tự hiểu về phong cách tạo tượng đời Đường.',
    sourceEnglish: 'The official virtual restoration is based on historical photographs; her layer is filled in only from her own interpretation of Tang sculptural style.',
  ),
  _longmenStoryWord(
    word: '渲染',
    pinyin: 'xuànrǎn',
    partOfSpeech: '动词',
    simpleChinese: '把数字模型计算并生成最终画面。',
    vietnamese: 'kết xuất hình ảnh từ mô hình số',
    english: 'to render a digital image',
    symbol: '🖥️',
    sourceSentence: '她看着已渲染三天的画面，最后关掉那一层。',
    sourceVietnamese: 'Cô nhìn cảnh đã kết xuất suốt ba ngày rồi tắt lớp đó.',
    sourceEnglish: 'She looks at the image she has spent three days rendering and turns the layer off.',
  ),
  _longmenStoryWord(
    word: '画面',
    pinyin: 'huàmiàn',
    partOfSpeech: '名词',
    simpleChinese: '影像或屏幕中呈现出来的视觉内容。',
    vietnamese: 'hình ảnh hoặc khung hình được trình bày',
    english: 'visual image or frame',
    symbol: '🎞️',
    sourceSentence: '她看着已渲染三天的画面，最后关掉那一层。',
    sourceVietnamese: 'Cô nhìn cảnh đã kết xuất suốt ba ngày rồi tắt lớp đó.',
    sourceEnglish: 'She looks at the image she has spent three days rendering and turns the layer off.',
  ),
  _longmenStoryWord(
    word: '短片',
    pinyin: 'duǎnpiàn',
    partOfSpeech: '名词',
    simpleChinese: '时间较短的影片或视频作品。',
    vietnamese: 'phim ngắn hoặc video ngắn',
    english: 'short film or video',
    symbol: '🎬',
    sourceSentence: '二十九岁的林砚和周澄合做一段龙门石窟数字短片，林砚做三维画面，周澄核对史料。',
    sourceVietnamese: 'Lâm Nghiên, hai mươi chín tuổi, cùng Chu Trừng làm một phim ngắn kỹ thuật số về Long Môn. Lâm Nghiên phụ trách hình ảnh 3D, còn Chu Trừng kiểm tra tư liệu lịch sử.',
    sourceEnglish: 'Twenty-nine-year-old Lin Yan and Zhou Cheng are making a digital short about the Longmen Grottoes. Lin Yan builds the 3D visuals, while Zhou Cheng checks the historical sources.',
  ),
  _longmenStoryWord(
    word: '导出',
    pinyin: 'dǎochū',
    partOfSpeech: '动词',
    simpleChinese: '把编辑中的数字内容生成可使用的文件。',
    vietnamese: 'xuất nội dung số thành tệp có thể sử dụng',
    english: 'to export digital content as a usable file',
    symbol: '📤',
    sourceSentence: '导出前，周澄留下两人的并列署名。林砚把那一层改名为“无依据，不使用”，按下导出。',
    sourceVietnamese: 'Trước khi xuất bản, Chu Trừng giữ nguyên tên hai người đặt cạnh nhau. Lâm Nghiên đổi tên lớp đó thành “không có căn cứ, không sử dụng” rồi bấm xuất file.',
    sourceEnglish: 'Before export, Zhou Cheng keeps their names side by side in the credits. Lin Yan renames the layer “unsupported, do not use” and presses Export.',
  ),
  _longmenStoryWord(
    word: '完整',
    pinyin: 'wánzhěng',
    partOfSpeech: '形容词',
    simpleChinese: '没有明显缺少部分，整体保持齐全。',
    vietnamese: 'hoàn chỉnh, không thiếu phần rõ rệt',
    english: 'complete or intact',
    symbol: '🧩',
    sourceSentence: '林砚为了让转场完整，另做了一层“补全脸部”的模型。',
    sourceVietnamese: 'Để đoạn chuyển cảnh trông hoàn chỉnh, Lâm Nghiên làm thêm một lớp mô hình “bù lại khuôn mặt”.',
    sourceEnglish: 'To make the transition feel complete, Lin Yan adds a “completed face” model layer.',
  ),
  _longmenStoryWord(
    word: '转场',
    pinyin: 'zhuǎnchǎng',
    partOfSpeech: '名词/动词',
    simpleChinese: '影像从一个画面过渡到另一个画面的连接。',
    vietnamese: 'chuyển cảnh giữa hai hình ảnh',
    english: 'a transition between shots or scenes',
    symbol: '🔄',
    sourceSentence: '林砚为了让转场完整，另做了一层“补全脸部”的模型。',
    sourceVietnamese: 'Để đoạn chuyển cảnh trông hoàn chỉnh, Lâm Nghiên làm thêm một lớp mô hình “bù lại khuôn mặt”.',
    sourceEnglish: 'To make the transition feel complete, Lin Yan adds a “completed face” model layer.',
  ),
];

List<DiscoveryEntry> _approvedLongmenDiscoveries(
  int level,
  List<DiscoveryEntry> discoveries,
) {
  final target = level <= 4 ? 2 : 3;
  return List<DiscoveryEntry>.unmodifiable(discoveries.take(target));
}

JourneyLevelContent luoyangLongmenGoldLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = luoyangLongmenOnePassLevelContent(level);
  final supplements = _longmenMasterySupplements
      .where((item) => level >= item.fromLevel)
      .toList(growable: false);

  final paragraphs = List<String>.of(base.storyParagraphs);
  final annotations = List<ReadingAnnotation>.of(base.storyAnnotations);
  if (supplements.isNotEmpty) {
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
  }

  final discoveries = _approvedLongmenDiscoveries(level, base.discoveries);
  final visible = '${paragraphs.join()}${discoveries.map((entry) => entry.text).join()}';
  final profile = const PhoenixLanguageLevelAgent().profileForPhoenixLevel(level);
  final plan = const PhoenixLanguageLevelAgent().planFor(profile);
  final words = <WordEntry>[
    ...luoyangLongmenWords,
    ..._longmenStorySupplementWords,
  ]
      .where((entry) => visible.contains(entry.word))
      .take(plan.targetVocabularyCount)
      .toList(growable: false);

  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: List<WordEntry>.unmodifiable(words),
    discoveries: discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}
