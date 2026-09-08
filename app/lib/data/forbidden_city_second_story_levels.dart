import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';

class _SecondStoryWordSpec {
  const _SecondStoryWordSpec({
    required this.id,
    required this.word,
    required this.pinyin,
    required this.partOfSpeech,
    required this.simpleChinese,
    required this.vietnamese,
    required this.english,
    required this.symbol,
  });

  final String id;
  final String word;
  final String pinyin;
  final String partOfSpeech;
  final String simpleChinese;
  final String vietnamese;
  final String english;
  final String symbol;
}

const _wordSpecs = <String, _SecondStoryWordSpec>{
  'recordBook': _SecondStoryWordSpec(
    id: 'recordBook',
    word: '记录册',
    pinyin: 'jìlùcè',
    partOfSpeech: '名词',
    simpleChinese: '用来连续记录事实、核对结果和待办事项的册子。',
    vietnamese: 'sổ ghi chép',
    english: 'record book; logbook',
    symbol: '📒',
  ),
  'verify': _SecondStoryWordSpec(
    id: 'verify',
    word: '核对',
    pinyin: 'héduì',
    partOfSpeech: '动词',
    simpleChinese: '把两份信息放在一起检查是否一致。',
    vietnamese: 'đối chiếu; kiểm tra chéo',
    english: 'to cross-check; to verify by comparison',
    symbol: '🔎',
  ),
  'handoff': _SecondStoryWordSpec(
    id: 'handoff',
    word: '交接',
    pinyin: 'jiāojiē',
    partOfSpeech: '动词',
    simpleChinese: '把工作、资料或责任清楚地交给下一位接手者。',
    vietnamese: 'bàn giao',
    english: 'handoff; transfer of work or responsibility',
    symbol: '🤝',
  ),
  'axis': _SecondStoryWordSpec(
    id: 'axis',
    word: '中轴',
    pinyin: 'zhōngzhóu',
    partOfSpeech: '名词',
    simpleChinese: '组织紫禁城主要宫殿南北空间秩序的中心轴线。',
    vietnamese: 'trục trung tâm',
    english: 'central axis',
    symbol: '↕️',
  ),
  'jingyun': _SecondStoryWordSpec(
    id: 'jingyun',
    word: '景运门',
    pinyin: 'jǐngyùnmén',
    partOfSpeech: '专名',
    simpleChinese: '位于乾清门前广场东侧的一座宫门。',
    vietnamese: 'Cảnh Vận Môn',
    english: 'Jingyun Gate',
    symbol: '🚪',
  ),
  'qianqing': _SecondStoryWordSpec(
    id: 'qianqing',
    word: '乾清门',
    pinyin: 'qiánqīngmén',
    partOfSpeech: '专名',
    simpleChinese: '内廷正门，也是连接外朝与内廷的重要空间节点。',
    vietnamese: 'Càn Thanh Môn',
    english: 'Qianqing Gate',
    symbol: '🏛️',
  ),
  'uncertain': _SecondStoryWordSpec(
    id: 'uncertain',
    word: '不确定处',
    pinyin: 'bùquèdìngchù',
    partOfSpeech: '名词短语',
    simpleChinese: '目前证据还不足、需要继续核对的位置或信息。',
    vietnamese: 'chỗ chưa chắc chắn',
    english: 'an uncertain point requiring verification',
    symbol: '❓',
  ),
  'doubt': _SecondStoryWordSpec(
    id: 'doubt',
    word: '疑问',
    pinyin: 'yíwèn',
    partOfSpeech: '名词',
    simpleChinese: '还没有得到可靠答案的问题。',
    vietnamese: 'điểm nghi vấn; câu hỏi',
    english: 'question; point of doubt',
    symbol: '💭',
  ),
  'correction': _SecondStoryWordSpec(
    id: 'correction',
    word: '更正',
    pinyin: 'gēngzhèng',
    partOfSpeech: '动词',
    simpleChinese: '有证据确认原记录错误后，把它改成正确内容。',
    vietnamese: 'đính chính; sửa lại',
    english: 'to correct; to amend',
    symbol: '✍️',
  ),
  'leaveBlank': _SecondStoryWordSpec(
    id: 'leaveBlank',
    word: '留空',
    pinyin: 'liúkòng',
    partOfSpeech: '动词',
    simpleChinese: '暂时不填写，等证据确认后再补上。',
    vietnamese: 'để trống',
    english: 'to leave blank pending confirmation',
    symbol: '⬜',
  ),
  'pending': _SecondStoryWordSpec(
    id: 'pending',
    word: '待核',
    pinyin: 'dàihé',
    partOfSpeech: '动词短语',
    simpleChinese: '等待后续核对确认。',
    vietnamese: 'chờ đối chiếu',
    english: 'pending verification',
    symbol: '⏳',
  ),
  'blank': _SecondStoryWordSpec(
    id: 'blank',
    word: '空格',
    pinyin: 'kònggé',
    partOfSpeech: '名词',
    simpleChinese: '记录中暂时没有填写内容的位置。',
    vietnamese: 'ô trống',
    english: 'blank field; empty box',
    symbol: '▢',
  ),
  'east': _SecondStoryWordSpec(
    id: 'east',
    word: '东侧',
    pinyin: 'dōngcè',
    partOfSpeech: '方位词',
    simpleChinese: '一个位置的东边一侧。',
    vietnamese: 'phía đông',
    english: 'east side',
    symbol: '➡️',
  ),
  'confirm': _SecondStoryWordSpec(
    id: 'confirm',
    word: '确认',
    pinyin: 'quèrèn',
    partOfSpeech: '动词',
    simpleChinese: '经过核对后确定信息可靠。',
    vietnamese: 'xác nhận',
    english: 'to confirm; to verify',
    symbol: '✅',
  ),
  'page': _SecondStoryWordSpec(
    id: 'page',
    word: '页码',
    pinyin: 'yèmǎ',
    partOfSpeech: '名词',
    simpleChinese: '标明资料页次的号码。',
    vietnamese: 'số trang',
    english: 'page number',
    symbol: '🔢',
  ),
  'signature': _SecondStoryWordSpec(
    id: 'signature',
    word: '签名',
    pinyin: 'qiānmíng',
    partOfSpeech: '名词',
    simpleChinese: '用姓名确认责任或处理结果的记录。',
    vietnamese: 'chữ ký',
    english: 'signature',
    symbol: '🖊️',
  ),
  'takeOver': _SecondStoryWordSpec(
    id: 'takeOver',
    word: '接手',
    pinyin: 'jiēshǒu',
    partOfSpeech: '动词',
    simpleChinese: '从别人那里接过工作并继续负责。',
    vietnamese: 'tiếp nhận công việc',
    english: 'to take over work or responsibility',
    symbol: '🧭',
  ),
};

const _levelWordIds = <List<String>>[
  ['recordBook', 'verify', 'handoff', 'axis'],
  ['axis', 'jingyun', 'verify', 'page'],
  ['jingyun', 'qianqing', 'uncertain', 'verify', 'axis'],
  ['qianqing', 'uncertain', 'doubt', 'east', 'page'],
  ['axis', 'jingyun', 'verify', 'handoff', 'pending'],
  ['axis', 'jingyun', 'qianqing', 'verify', 'handoff', 'blank'],
  ['qianqing', 'correction', 'leaveBlank', 'pending', 'confirm', 'doubt'],
  ['jingyun', 'qianqing', 'east', 'correction', 'recordBook', 'takeOver'],
  [
    'uncertain',
    'correction',
    'leaveBlank',
    'pending',
    'page',
    'signature',
    'confirm'
  ],
  [
    'axis',
    'jingyun',
    'qianqing',
    'verify',
    'handoff',
    'uncertain',
    'correction',
    'pending'
  ],
];

WordEntry _entry(String id) {
  final spec = _wordSpecs[id];
  if (spec == null) throw StateError('Unknown Second Story vocabulary id: $id');
  return WordEntry(
    word: spec.word,
    pinyin: spec.pinyin,
    partOfSpeech: spec.partOfSpeech,
    simpleChinese: spec.simpleChinese,
    translation: spec.vietnamese,
    englishDefinition: spec.english,
    symbol: spec.symbol,
  );
}

List<WordEntry> forbiddenCitySecondStoryWordsForLevel(int level) {
  final index = level.clamp(1, 10).toInt() - 1;
  return List<WordEntry>.unmodifiable(_levelWordIds[index].map(_entry));
}

class _DiscoveryPair {
  const _DiscoveryPair(this.first, this.second, this.vietnamese, this.english);

  final String first;
  final String second;
  final String vietnamese;
  final String english;
}

const _discoveries = <_DiscoveryPair>[
  _DiscoveryPair(
    '中轴与景运门不是同类信息：中轴描述紫禁城南北空间序列，景运门是具体宫门。',
    '故事核对出的基础空间事实是：景运门位于乾清门前广场东侧。',
    'Trục giữa mô tả trật tự không gian bắc–nam, còn Cảnh Vận Môn là một cổng cụ thể. Câu chuyện xác nhận Cảnh Vận Môn ở phía đông quảng trường trước Càn Thanh Môn.',
    'The central axis describes a north-south spatial order, while Jingyun Gate is a specific gate. The story verifies Jingyun Gate on the east side of the square before Qianqing Gate.',
  ),
  _DiscoveryPair(
    '乾清门前广场可以用东西方向定位具体宫门；只背名称，不能替代方位核对。',
    '记录册把建筑名称和方位写在一起，下一位接手者才能沿同一证据继续检查。',
    'Quảng trường trước Càn Thanh Môn có thể dùng hướng đông–tây để định vị cổng. Sổ bàn giao cần ghi cả tên công trình và phương hướng để người tiếp nhận tiếp tục kiểm tra.',
    'East-west orientation helps locate gates around the square before Qianqing Gate. A handoff record should preserve both the building name and direction so the next person can verify the same evidence.',
  ),
  _DiscoveryPair(
    '乾清门是连接外朝与内廷的重要节点；景运门则提供乾清门前广场东侧的具体方位信息。',
    '同一张记录里，建筑名称、空间关系和方向属于不同类型的证据，核对时不能混成一个标签。',
    'Càn Thanh Môn là nút nối Ngoại triều và Nội đình; Cảnh Vận Môn cung cấp thông tin phương vị cụ thể ở phía đông quảng trường. Tên, quan hệ không gian và phương hướng là các loại bằng chứng khác nhau.',
    'Qianqing Gate is an important node between the Outer and Inner Courts, while Jingyun Gate provides a concrete east-side location. Names, spatial relations, and directions are different evidence types.',
  ),
  _DiscoveryPair(
    '把紫禁城旧表的“西”直接擦成“东”会丢失景运门错误从哪里来的信息；保留旧标记再写更正，更容易追溯。',
    '故事中的核对不是机械改字，而是先记录疑问、再用紫禁城空间事实确认方位。',
    'Xóa ngay “tây” thành “đông” sẽ làm mất dấu nguồn gốc lỗi. Giữ dấu cũ rồi ghi đính chính giúp truy vết; việc đối chiếu phải dựa trên dữ kiện không gian của Tử Cấm Thành.',
    'Simply erasing west and writing east loses the history of the error. Keeping the old mark and recording a correction preserves traceability and ties the check to Forbidden City spatial evidence.',
  ),
  _DiscoveryPair(
    '能确认的当场更正，不能确认的先留空，是把“已证实事实”和“待核项目”分开的记录方法。',
    '对紫禁城方位资料来说，暂时留空比填入未经核对的答案更可靠。',
    'Sửa ngay điều đã xác nhận và để trống điều chưa chắc giúp tách dữ kiện đã chứng minh khỏi mục chờ kiểm tra. Với dữ liệu phương vị, để trống đáng tin cậy hơn là đoán.',
    'Correcting confirmed facts while leaving uncertain fields blank separates verified evidence from pending items. For spatial records, an explicit blank is safer than an unverified guess.',
  ),
  _DiscoveryPair(
    '读乾清门前广场时，可以同时使用中轴、具体宫门和东西方位，但三者承担的判断作用不同。',
    '景运门位于乾清门前广场东侧这一事实，需要具体位置证据，不能只靠“中轴”这个整体框架推出。',
    'Khi đọc quảng trường trước Càn Thanh Môn có thể dùng trục giữa, cổng cụ thể và phương hướng, nhưng mỗi loại thông tin có chức năng khác nhau. Vị trí Cảnh Vận Môn cần bằng chứng cụ thể.',
    'The square before Qianqing Gate can be read through the axis, named gates, and directions, but each plays a different role. Jingyun Gate’s east-side position requires specific location evidence.',
  ),
  _DiscoveryPair(
    '紫禁城景运门方位的交接质量不只看最后答案，还要看下一位接手者能不能知道哪些项目已核、哪些仍待核。',
    '把乾清门前广场的疑问、页码和更正一起保留，会形成一条可以继续复查的证据链。',
    'Chất lượng bàn giao còn phụ thuộc vào việc người tiếp nhận biết mục nào đã kiểm tra và mục nào còn chờ. Giữ nghi vấn, số trang và đính chính tạo thành chuỗi bằng chứng có thể rà soát.',
    'A good handoff shows not only the final answer but also what is verified and what remains pending. Preserving questions, page references, and corrections creates a reviewable evidence chain.',
  ),
  _DiscoveryPair(
    '紫禁城的空间事实和记录工作的操作事实不能互相替代：建筑关系回答“在哪里”，交接记录回答“如何确认”。',
    '把两类事实放在一起，接手者既能理解乾清门、景运门的空间关系，也能复核更正过程。',
    'Dữ kiện không gian trả lời “ở đâu”, còn hồ sơ bàn giao trả lời “đã xác nhận thế nào”. Kết hợp hai loại giúp người tiếp nhận vừa hiểu quan hệ cổng vừa kiểm tra quá trình sửa.',
    'Spatial evidence answers where things are, while handoff evidence answers how a claim was verified. Together they let the next person understand the gate relationship and audit the correction process.',
  ),
  _DiscoveryPair(
    '一次可靠更正应能追到原页码、原标记、核对依据和最终结论，而不只留下一个改后的字。',
    '对于景运门方位这样的空间事实，可追溯记录能让不同接手者独立复核同一结论。',
    'Một đính chính đáng tin cậy cần truy về số trang, dấu cũ, căn cứ đối chiếu và kết luận cuối. Với vị trí Cảnh Vận Môn, khả năng truy vết cho phép người khác kiểm tra độc lập.',
    'A reliable correction should trace back to the page, original mark, evidence, and conclusion. For a spatial fact such as Jingyun Gate’s location, traceability enables independent verification.',
  ),
  _DiscoveryPair(
    '高质量交接把紫禁城空间证据、记录版本和待核状态连接起来，使结论既正确又能被下一位接手者复查。',
    '中轴提供整体结构，乾清门和景运门提供具体节点与方位；记录册则保存这些判断是怎样被核对出来的。',
    'Bàn giao chất lượng cao nối bằng chứng không gian, phiên bản ghi chép và trạng thái chờ kiểm tra. Trục giữa cho khung tổng thể; các cổng cho vị trí cụ thể; sổ ghi lại quá trình xác minh.',
    'A high-quality handoff connects Forbidden City spatial evidence, record versions, and pending status. The axis supplies structure, gates supply concrete locations, and the record preserves how claims were verified.',
  ),
];

String _reading(String text) {
  var value = PinyinHelper.getPinyinE(
    text,
    separator: ' ',
    format: PinyinFormat.WITH_TONE_MARK,
  );
  const replacements = <String, String>{
    'kōng gé': 'kòng gé',
    'bù què dìng chǔ': 'bù què dìng chù',
    'qián miàn dī yè mǎ': 'qián miàn de yè mǎ',
    'què rèn dí dàng chǎng': 'què rèn de dāng chǎng',
    'zhǐ zhuó': 'zhǐ zhe',
    'de tú': 'dì tú',
    'bēi jiàn zhù míng zi': 'bèi jiàn zhù míng zi',
  };
  for (final entry in replacements.entries) {
    value = value.replaceAll(entry.key, entry.value);
  }
  return value;
}

List<DiscoveryEntry> forbiddenCitySecondStoryDiscoveriesForLevel(
  int level, {
  required List<String> sourceRefs,
}) {
  final item = _discoveries[level.clamp(1, 10).toInt() - 1];
  return List<DiscoveryEntry>.unmodifiable([
    DiscoveryEntry(
      text: item.first,
      pinyin: _reading(item.first),
      simpleChinese: item.first,
      vietnamese: item.vietnamese,
      english: item.english,
      sourceRefs: sourceRefs,
    ),
    DiscoveryEntry(
      text: item.second,
      pinyin: _reading(item.second),
      simpleChinese: item.second,
      vietnamese: item.vietnamese,
      english: item.english,
      sourceRefs: sourceRefs,
    ),
  ]);
}
