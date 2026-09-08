import 'journey_data.dart';
import 'journey_level_catalog.dart';

const _wordPlan = <List<String>>[
  <String>['交接', '核对', '中轴', '景运门', '页码'],
  <String>['交接', '核对', '中轴', '景运门', '不确定处', '签名'],
  <String>['核对', '中轴', '景运门', '乾清门', '西侧', '疑问', '页边'],
  <String>['交接', '记录册', '接手', '更正', '留空', '空格', '签名'],
  <String>['中轴', '景运门', '乾清门', '广场', '东侧', '西侧', '核对', '交接'],
  <String>['核对', '确认', '更正', '留空', '不确定处', '待核', '交接', '记录册'],
  <String>['乾清门', '景运门', '广场', '东侧', '中轴', '记录', '核对', '图页'],
  <String>['交接', '接手', '记录册', '疑问', '页边', '更正', '待核', '签名'],
  <String>['中轴', '乾清门', '景运门', '东侧', '西侧', '核对', '旧表', '记录'],
  <String>['核对', '交接', '不确定处', '确认', '更正', '留空', '待核', '格子'],
];

const _simpleChinese = <String, String>{
  '页码': '书页或表页上的编号。',
  '不确定处': '还没有确认、需要继续检查的地方。',
  '签名': '写下自己的姓名，表示确认或负责。',
  '乾清门': '紫禁城内廷正宫门，也是内外廷往来的重要通道。',
  '西侧': '一个位置的西边。',
  '疑问': '还没有得到明确答案的问题。',
  '页边': '页面靠边的位置。',
  '记录册': '用来连续记下事项和结果的册子。',
  '接手': '从别人那里继续负责一项工作。',
  '更正': '发现错误后改成正确内容。',
  '留空': '暂时不填写，保留空白。',
  '空格': '表格或记录中等待填写的空位。',
  '广场': '建筑之间较开阔的公共空间。',
  '东侧': '一个位置的东边。',
  '确认': '检查后得到明确结果。',
  '待核': '仍在等待核对。',
  '记录': '把事实、位置或处理结果写下来。',
  '图页': '带有图或地图信息的一页。',
  '旧表': '先前使用、需要重新核对的表格。',
  '格子': '表格中独立的小方格。',
};

const _english = <String, String>{
  '页码': 'page number',
  '不确定处': 'an uncertain point that still needs verification',
  '签名': 'signature; to sign',
  '乾清门': 'Qianqing Gate, the principal gate of the Inner Court',
  '西侧': 'the west side',
  '疑问': 'a question or unresolved doubt',
  '页边': 'the margin or edge of a page',
  '记录册': 'a record book or log',
  '接手': 'to take over responsibility',
  '更正': 'to correct an error',
  '留空': 'to leave blank until confirmed',
  '空格': 'a blank cell or space',
  '广场': 'a square or open court',
  '东侧': 'the east side',
  '确认': 'to confirm after checking',
  '待核': 'pending verification',
  '记录': 'to record; a record',
  '图页': 'a map or diagram page',
  '旧表': 'an earlier or old reference sheet',
  '格子': 'a cell in a table or form',
};

const _vietnamese = <String, String>{
  '页码': 'số trang',
  '不确定处': 'chỗ chưa chắc chắn, cần kiểm tra tiếp',
  '签名': 'chữ ký; ký tên',
  '乾清门': 'Càn Thanh Môn, chính môn của Nội đình',
  '西侧': 'phía tây',
  '疑问': 'điểm nghi vấn, câu hỏi chưa được giải đáp',
  '页边': 'lề trang',
  '记录册': 'sổ ghi chép',
  '接手': 'tiếp nhận và tiếp tục phụ trách',
  '更正': 'sửa lại cho đúng',
  '留空': 'để trống cho đến khi xác nhận',
  '空格': 'ô trống',
  '广场': 'quảng trường, khoảng sân rộng',
  '东侧': 'phía đông',
  '确认': 'xác nhận sau khi kiểm tra',
  '待核': 'đang chờ đối chiếu',
  '记录': 'ghi chép; bản ghi',
  '图页': 'trang sơ đồ hoặc bản đồ',
  '旧表': 'bảng cũ cần đối chiếu lại',
  '格子': 'ô trong bảng',
};

const _levelFocusZh = <String>[
  '本级先分清具体宫门和中轴这两类空间信息。',
  '本级把乾清门当作连接外朝与内廷的空间节点来读。',
  '本级用“东侧 / 西侧”核对景运门在乾清门前广场的位置。',
  '本级把建筑名称、方向和广场关系放进同一次核对。',
  '本级比较中轴骨架与侧向门户，判断两种信息怎样互相补充。',
  '本级先区分“空间可以连接”与“记录已经确认”两个判断。',
  '本级要求用至少两条空间证据解释景运门为什么标在东侧。',
  '本级把交接记录看成证据链：原记录、疑问、核对和更正都要留下。',
  '本级同时检查名称、方向、节点和来源，避免只凭熟悉路线下结论。',
  '本级综合中轴、乾清门、景运门与记录过程，形成可复核的空间判断。',
];

const _levelFocusVi = <String>[
  'Cấp này trước hết phân biệt cổng cung điện cụ thể với trục không gian trung tâm.',
  'Cấp này đọc Càn Thanh Môn như một nút nối Ngoại triều và Nội đình.',
  'Cấp này dùng quan hệ đông / tây để kiểm tra vị trí Cảnh Vận Môn trước Càn Thanh Môn.',
  'Cấp này đặt tên công trình, phương hướng và quan hệ quảng trường vào cùng một lần đối chiếu.',
  'Cấp này so sánh khung trục giữa với các cổng bên để xem hai loại thông tin bổ sung nhau thế nào.',
  'Cấp này phân biệt “không gian có thể nối” với “bản ghi đã được xác nhận”.',
  'Cấp này yêu cầu ít nhất hai bằng chứng không gian để giải thích vì sao Cảnh Vận Môn ở phía đông.',
  'Cấp này xem bàn giao như một chuỗi bằng chứng gồm bản ghi cũ, nghi vấn, đối chiếu và sửa.',
  'Cấp này kiểm tra đồng thời tên gọi, phương hướng, nút không gian và nguồn chứng cứ.',
  'Cấp này tổng hợp trục giữa, Càn Thanh Môn, Cảnh Vận Môn và quy trình ghi chép thành một phán đoán có thể kiểm tra lại.',
];

const _levelFocusEn = <String>[
  'This level first separates a specific palace gate from the central-axis concept.',
  'This level reads Qianqing Gate as a spatial node linking the Outer and Inner Courts.',
  'This level uses east/west relations to verify Jingyun Gate beside the square before Qianqing Gate.',
  'This level checks building names, direction, and square relationships together.',
  'This level compares the central-axis framework with side gates and asks how the two kinds of evidence complement each other.',
  'This level separates spatial connectivity from whether a record has actually been verified.',
  'This level requires at least two spatial clues to justify why Jingyun Gate is marked on the east side.',
  'This level treats the handoff record as an evidence chain: old entry, doubt, verification, and correction.',
  'This level checks name, direction, node, and source together instead of trusting a familiar route.',
  'This level combines the central axis, Qianqing Gate, Jingyun Gate, and the record process into a reviewable spatial judgment.',
];

JourneyLevelContent completeForbiddenCitySecondStoryExercises({
  required int phoenixLevel,
  required JourneyLevelContent base,
  required String Function(String) pinyinFor,
}) {
  final level = phoenixLevel.clamp(1, 10).toInt();
  final original = <String, WordEntry>{
    for (final entry in base.words) entry.word: entry,
  };
  final words = <WordEntry>[
    for (final word in _wordPlan[level - 1])
      original[word] ??
          WordEntry(
            word: word,
            pinyin: pinyinFor(word).replaceAll(' ', ''),
            simpleChinese:
                _simpleChinese[word] ?? '当前 Story 中需要理解和核对的词语。',
            translation: _vietnamese[word] ?? word,
            symbol: '•',
            partOfSpeech: word.endsWith('门') ? '专名' : '词语',
            englishDefinition: _english[word] ?? word,
          ),
  ];

  final discoveries = <DiscoveryEntry>[];
  for (var index = 0; index < base.discoveries.length; index += 1) {
    final source = base.discoveries[index];
    final focusZh = index == 0 ? '${_levelFocusZh[level - 1]}\n' : '';
    final focusVi = index == 0 ? '${_levelFocusVi[level - 1]}\n' : '';
    final focusEn = index == 0 ? '${_levelFocusEn[level - 1]}\n' : '';
    final text = '$focusZh${source.text}';
    discoveries.add(
      DiscoveryEntry(
        text: text,
        pinyin: pinyinFor(text),
        simpleChinese: text,
        vietnamese: '$focusVi${source.vietnamese}',
        english: '$focusEn${source.english}',
        sourceRefs: source.sourceRefs,
      ),
    );
  }

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(words),
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}
