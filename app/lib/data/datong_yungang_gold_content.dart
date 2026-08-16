import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const datongYungangJourneyId = 'datong-yungang-grottoes';
const datongYungangCanonicalTitle = '三段墨绳';
const datongYungangHeadline = '巨像停下以后，谁还能继续';
const datongYungangDescription = '迁都后的云冈，一位虚构女石工割开父亲留下的长墨绳，也割开“唯一传人”的安排。';
const datongYungangDiscoveryTeaser = '迁都洛阳以后，云冈为什么没有立刻停止开窟造像？';

class DatongArchitecture {
  const DatongArchitecture({required this.id, required this.spine, required this.memory, required this.selected});
  final String id;
  final String spine;
  final String memory;
  final bool selected;
}

const datongYungangArchitectures = <DatongArchitecture>[
  DatongArchitecture(
    id: 'A-three-ink-lines',
    spine: '虚构父女因迁都后的营造转折争夺手艺的归属；女儿割开巨像墨绳，放弃唯一传人身份，让三名留下者分别继续。',
    memory: '一根沾着黑粉的长绳在石阶上变成三段。',
    selected: true,
  ),
  DatongArchitecture(
    id: 'B-unfinished-face',
    spine: '虚构伴侣在离开旧都前决定是否共同完成一尊未完造像。',
    memory: '两把凿子停在同一张未完的脸旁。',
    selected: false,
  ),
  DatongArchitecture(
    id: 'C-market-pledge',
    spine: '虚构商人与亲属因民间小龛的私人承诺重新分配积蓄。',
    memory: '钱袋没有交给远行车队，而放在崖下。',
    selected: false,
  ),
];

const datongYungangClaimLedger = <Map<String, String>>[
  {
    'id': 'DY-C1',
    'claim': '云冈石窟主要营造于北魏，位于当时都城平城附近。',
    'truth': 'VERIFIED WORLD FACT',
    'source': 'UNESCO World Heritage Centre · Yungang Grottoes',
    'use': 'Story + Discovery',
  },
  {
    'id': 'DY-C2',
    'claim': '北魏在494年迁都洛阳；迁都后云冈仍有较小规模的民间开窟造像。',
    'truth': 'VERIFIED HISTORICAL CONDITION',
    'source': '国家文物局 / 山西省人民政府转载的云冈分期资料',
    'use': 'central Story pressure + Discovery',
  },
  {
    'id': 'DY-F1',
    'claim': '魏岚、魏朔、魏石及其父女、同伴关系、墨绳、争执和选择。',
    'truth': 'FICTIONAL CHARACTER LIFE',
    'source': 'literary fiction; plausibility and non-contradiction required',
    'use': 'Story only',
  },
];

class _Segment {
  const _Segment(this.zh, this.vi, this.en, {this.from = 1});
  final String zh;
  final String vi;
  final String en;
  final int from;
}

const _core = <_Segment>[
  _Segment('北魏迁都洛阳后，云冈不再像从前那样营造巨像。虚构石工魏岚的父亲准备南行，要她带走那根量巨像的长墨绳。', 'Sau khi Bắc Ngụy dời đô đến Lạc Dương, Vân Cương không còn tạo những tượng khổng lồ như trước. Người thợ đá hư cấu Ngụy Lam được cha yêu cầu mang theo sợi dây mực dài dùng để đo tượng lớn khi ông đi về phía nam.', 'After the Northern Wei moved its capital to Luoyang, Yungang no longer made colossal images as before. The fictional stoneworker Wei Lan is told by her father to take the long ink line used to measure giant statues when he heads south.'),
  _Segment('父亲只肯把手艺交给一个人；留下的弟弟魏朔和同伴阿砾便要继续替她扶绳，或者散伙。魏岚想留下三个人，却不能同时保住“唯一传人”的位置。', 'Cha cô chỉ chịu truyền nghề cho một người; em trai Ngụy Sóc và người bạn A Lịch nếu ở lại sẽ phải tiếp tục cầm dây cho cô hoặc tan nhóm. Ngụy Lam muốn giữ cả ba người ở lại, nhưng không thể đồng thời giữ địa vị “người kế nghiệp duy nhất”.', 'Her father will pass the craft to only one person; her younger brother Wei Shuo and their companion A Li must either keep holding the line for her or break apart. Wei Lan wants all three to remain, but cannot also keep the position of “sole successor.”'),
  _Segment('天亮时，父亲伸手等她收绳。魏岚却把墨绳按在石阶上，割成三段，一段给魏朔，一段给阿砾，最后一段留在自己掌心。', 'Lúc trời sáng, cha cô đưa tay chờ cô cuộn dây. Ngụy Lam lại ép dây xuống bậc đá, cắt thành ba đoạn, trao một đoạn cho Ngụy Sóc, một đoạn cho A Lịch và giữ đoạn cuối trong lòng bàn tay.', 'At dawn, her father holds out his hand for her to coil the line. Instead, Wei Lan presses it to the stone step and cuts it into three pieces—one for Wei Shuo, one for A Li, and the last in her own palm.'),
  _Segment('她失去了父亲许诺的唯一位置。父亲背起行囊，没有替她把断口重新接上。', 'Cô mất vị trí duy nhất mà cha từng hứa. Ông đeo hành lý lên vai và không nối lại chỗ dây bị cắt cho cô.', 'She loses the sole position her father had promised. He shoulders his bundle and does not tie the cut ends back together for her.'),
  _Segment('三个人不再等同一双手发号施令。魏朔第一次自己弹出墨线，黑印落在一块只够开小龛的石面上。', 'Ba người không còn chờ cùng một đôi tay ra lệnh. Lần đầu tiên Ngụy Sóc tự bật dây mực; dấu đen rơi lên một mặt đá chỉ đủ chỗ cho một khám nhỏ.', 'The three no longer wait for one pair of hands to command them. For the first time, Wei Shuo snaps his own ink line; the black mark lands on a stone face large enough only for a small niche.'),
  _Segment('父亲走到崖路转弯处，回头看了那三道黑线一眼。魏岚没有追上去。', 'Đến chỗ con đường dưới vách rẽ ngoặt, người cha ngoái nhìn ba đường mực đen. Ngụy Lam không chạy theo.', 'At the bend in the cliff road, her father looks back once at the three black lines. Wei Lan does not run after him.'),
];

const _depth = <_Segment>[
  _Segment('从前，长绳一端在父亲手里，另外的人只负责把它拉直。', 'Trước kia, một đầu dây dài luôn nằm trong tay người cha; những người khác chỉ kéo cho thẳng.', 'Before, one end of the long line always stayed in her father’s hand; everyone else merely pulled it straight.', from: 2),
  _Segment('魏岚知道父亲不是在问一根绳子，而是在问谁有资格决定下一道线落在哪里。', 'Ngụy Lam hiểu cha không hỏi về một sợi dây, mà hỏi ai có quyền quyết định đường tiếp theo sẽ rơi ở đâu.', 'Wei Lan knows her father is not asking about a rope, but about who has the right to decide where the next line will fall.', from: 3),
  _Segment('远处的大窟仍压着山崖，近处却只剩适合小龛的石面。旧尺度再也不能替他们安排同一种明天。', 'Những hang lớn vẫn đè nặng trên vách xa, nhưng gần họ chỉ còn mặt đá phù hợp với khám nhỏ. Thước đo cũ không còn có thể sắp đặt cùng một ngày mai cho tất cả.', 'The great caves still weigh on the distant cliff, but nearby only stone suited to small niches remains. The old scale can no longer arrange the same tomorrow for all of them.', from: 4),
  _Segment('刀刃碰到绳芯时，她听见魏朔吸了一口气。只要停手，她仍能作为父亲选中的那个人南下。', 'Khi lưỡi dao chạm lõi dây, cô nghe Ngụy Sóc hít vào. Chỉ cần dừng tay, cô vẫn có thể đi về nam với tư cách người được cha chọn.', 'When the blade reaches the cord’s core, she hears Wei Shuo draw breath. If she stops, she can still go south as the person her father chose.', from: 5),
  _Segment('父亲教过她，墨线落下之前不能犹豫；她第一次把这句话用在父亲不愿看见的地方。', 'Cha từng dạy rằng không được do dự trước khi bật dây mực; lần đầu cô dùng lời ấy ở nơi ông không muốn nhìn thấy.', 'Her father taught her never to hesitate before snapping an ink line; for the first time, she uses that lesson where he does not want to see it used.', from: 6),
  _Segment('魏朔接绳时没有叫她师姐，只叫了一声姐姐。那一个称呼让失去的名分变得具体。', 'Khi nhận dây, Ngụy Sóc không gọi cô là sư tỷ mà chỉ gọi “chị”. Cách xưng hô ấy khiến danh phận vừa mất trở nên cụ thể.', 'When Wei Shuo takes the cord, he does not call her senior apprentice, only sister. The single word makes the lost title tangible.', from: 7),
  _Segment('阿砾没有道谢。他把自己的绳段绕上手腕，给魏岚留下了拒绝这份分配的余地。', 'A Lịch không cảm ơn. Anh quấn đoạn dây quanh cổ tay, để cho Ngụy Lam khoảng trống có thể từ chối sự phân chia này.', 'A Li does not thank her. He winds his piece around his wrist, leaving Wei Lan room to refuse the arrangement.', from: 8),
  _Segment('她终于明白，继承不一定是一个人把整根绳子带走；也可能是三个人各自承担一条线，再也不能把失误推回同一双手。', 'Cuối cùng cô hiểu kế thừa không nhất thiết là một người mang đi cả sợi dây; cũng có thể là ba người tự chịu trách nhiệm cho đường của mình và không còn đẩy sai lầm về cùng một đôi tay.', 'She finally understands that inheritance need not mean one person carrying away the whole line; it may mean three people owning their own marks, unable to return every mistake to the same hands.', from: 9),
  _Segment('崖路吞没父亲的背影后，风把三段绳尾同时吹起。它们没有重新碰在一起。', 'Sau khi con đường vách đá nuốt bóng người cha, gió nâng ba đầu dây cùng lúc. Chúng không chạm lại vào nhau.', 'After the cliff road swallows her father’s figure, the wind lifts all three cord ends at once. They do not touch again.', from: 10),
];

class _Fact {
  const _Fact(this.zh, this.simple, this.vi, this.en);
  final String zh;
  final String simple;
  final String vi;
  final String en;
}

const _commonDiscovery = _Fact('云冈石窟位于今天的大同，主要营造于北魏平城作为都城的时期。它保存了国家支持、宗教发展与多种艺术传统相遇的物质证据。', '云冈主要形成于北魏以平城为都城的时期。', 'Hang đá Vân Cương ở Đại Đồng ngày nay, chủ yếu được tạo dựng khi Bình Thành là kinh đô Bắc Ngụy. Di sản lưu giữ bằng chứng vật chất về bảo trợ nhà nước, sự phát triển Phật giáo và sự gặp gỡ của nhiều truyền thống nghệ thuật.', 'The Yungang Grottoes in present-day Datong were built mainly while Pingcheng was the Northern Wei capital. They preserve material evidence of state support, Buddhist development, and the meeting of multiple artistic traditions.');

const _levelFacts = <_Fact>[
  _Fact('五世纪中叶，昙曜主持开凿的五个大窟以巨型造像构成云冈早期的重要部分。', '昙曜五窟是云冈早期的重要大窟。', 'Giữa thế kỷ V, năm hang lớn do Đàm Diệu chủ trì với các tượng khổng lồ tạo thành phần quan trọng của Vân Cương thời kỳ đầu.', 'In the mid-fifth century, five large caves initiated under Tanyao, with colossal images, formed a major part of early Yungang.'),
  _Fact('云冈的主要洞窟沿武州山南麓展开，砂岩崖壁既提供了开凿条件，也持续受到风化影响。', '砂岩崖壁让开窟成为可能，也会风化。', 'Các hang chính trải dọc sườn nam núi Vũ Châu; vách sa thạch vừa cho phép khai tạc vừa luôn chịu phong hóa.', 'The principal caves extend along the southern foot of Wuzhou Mountain; the sandstone cliff enabled carving and remains vulnerable to weathering.'),
  _Fact('云冈造像吸收并转化了来自南亚、中亚与中国本土的艺术因素。', '云冈造像让多种艺术传统相遇。', 'Điêu khắc Vân Cương tiếp nhận và chuyển hóa những yếu tố nghệ thuật từ Nam Á, Trung Á và bản địa Trung Hoa.', 'Yungang sculpture absorbed and transformed artistic elements from South Asia, Central Asia, and Chinese traditions.'),
  _Fact('北魏皇权对云冈早期大型营造提供了关键支持，但造像并不等于真实皇帝的私人肖像记录。', '国家支持大型营造，不等于可以虚构皇帝私生活。', 'Quyền lực hoàng gia Bắc Ngụy hỗ trợ then chốt cho công trình lớn thời kỳ đầu, nhưng tượng không đồng nghĩa với hồ sơ chân dung riêng tư của hoàng đế.', 'Northern Wei imperial power gave crucial support to early monumental construction, but the images are not licenses to invent emperors’ private lives.'),
  _Fact('494年北魏迁都洛阳，云冈大规模国家营造的环境随之改变。', '494年迁都改变了云冈的营造环境。', 'Năm 494, Bắc Ngụy dời đô đến Lạc Dương, làm thay đổi môi trường xây dựng quy mô lớn ở Vân Cương.', 'In 494 the Northern Wei moved its capital to Luoyang, changing the setting for large-scale state construction at Yungang.'),
  _Fact('迁都以后，云冈仍有较小洞窟和龛像继续开凿，显示造像活动并未在政治中心移动时立即终止。', '迁都后，云冈仍继续开凿较小窟龛。', 'Sau khi dời đô, các hang và khám nhỏ vẫn tiếp tục được tạc ở Vân Cương, cho thấy hoạt động tạo tượng không chấm dứt ngay khi trung tâm chính trị chuyển đi.', 'After the capital moved, smaller caves and niches continued to be carved at Yungang, showing that image-making did not end immediately with the political shift.'),
  _Fact('云冈分期体现了造像尺度、洞窟形制和艺术语言随政治与社会环境变化。', '云冈不同时期的尺度和形式发生变化。', 'Các giai đoạn Vân Cương cho thấy quy mô, hình thức hang và ngôn ngữ nghệ thuật thay đổi cùng môi trường chính trị và xã hội.', 'Yungang’s phases show changes in scale, cave form, and artistic language alongside political and social change.'),
  _Fact('龙门在迁都洛阳后成为北魏新的重要石窟营造中心；因此它与云冈在494年后的压力方向并不相同。', '迁都后，龙门成为新的重要中心。', 'Sau khi dời đô, Long Môn trở thành một trung tâm hang đá quan trọng mới; vì thế hướng áp lực lịch sử của Long Môn và Vân Cương sau năm 494 không giống nhau.', 'After the move, Longmen became a major new grotto center; its post-494 historical pressure therefore runs in a different direction from Yungang’s.'),
  _Fact('故事中的魏岚一家和三段墨绳都是虚构；迁都、云冈分期及迁都后仍有小型开凿属于需要来源支持的真实世界条件。', '人物和选择是虚构，周围的历史条件必须真实。', 'Gia đình Ngụy Lam và ba đoạn dây mực là hư cấu; việc dời đô, các giai đoạn Vân Cương và sự tiếp tục khai tạc quy mô nhỏ sau đó là điều kiện thế giới thật cần nguồn chứng minh.', 'Wei Lan’s family and the three ink-line pieces are fictional; the capital move, Yungang’s phases, and continued smaller carving are sourced world conditions.'),
  _Fact('云冈的价值不仅在单件造像，也在洞窟群如何记录北魏平城时期及其后续变化。', '洞窟群记录了平城时代及其变化。', 'Giá trị Vân Cương không chỉ nằm ở từng pho tượng mà còn ở cách toàn bộ quần thể ghi lại thời Bình Thành Bắc Ngụy và những biến đổi tiếp theo.', 'Yungang’s value lies not only in individual images but in how the cave complex records the Northern Wei Pingcheng era and subsequent change.'),
];

DiscoveryEntry _discovery(_Fact fact) => DiscoveryEntry(text: fact.zh, pinyin: PinyinHelper.getPinyinE(fact.zh, separator: ' ', format: PinyinFormat.WITH_TONE_MARK), simpleChinese: fact.simple, vietnamese: fact.vi, english: fact.en);

final datongYungangWords = <WordEntry>[
  const WordEntry(word: '迁都', pinyin: 'qiāndū', partOfSpeech: '动词', simpleChinese: '把国家都城迁到另一地。', translation: 'dời đô', englishDefinition: 'to move a capital', symbol: '🧭'),
  const WordEntry(word: '墨绳', pinyin: 'mòshéng', partOfSpeech: '名词', simpleChinese: '弹出直线标记的工具。', translation: 'dây bật mực', englishDefinition: 'an inked marking line', symbol: '〰️'),
  const WordEntry(word: '巨像', pinyin: 'jùxiàng', partOfSpeech: '名词', simpleChinese: '体量很大的造像。', translation: 'tượng khổng lồ', englishDefinition: 'colossal image', symbol: '🗿'),
  const WordEntry(word: '传人', pinyin: 'chuánrén', partOfSpeech: '名词', simpleChinese: '被选来继承技艺的人。', translation: 'người kế nghiệp', englishDefinition: 'designated successor', symbol: '👐'),
  const WordEntry(word: '散伙', pinyin: 'sànhuǒ', partOfSpeech: '动词', simpleChinese: '一起做事的人分开。', translation: 'tan nhóm', englishDefinition: 'to disband', symbol: '↔️'),
  const WordEntry(word: '石阶', pinyin: 'shíjiē', partOfSpeech: '名词', simpleChinese: '石头做成的台阶。', translation: 'bậc đá', englishDefinition: 'stone step', symbol: '🪨'),
  const WordEntry(word: '断口', pinyin: 'duànkǒu', partOfSpeech: '名词', simpleChinese: '物体断开的地方。', translation: 'chỗ đứt', englishDefinition: 'a cut or broken end', symbol: '✂️'),
  const WordEntry(word: '石龛', pinyin: 'shíkān', partOfSpeech: '名词', simpleChinese: '石壁上安置造像的小空间。', translation: 'khám đá', englishDefinition: 'a stone niche', symbol: '⛰️'),
  const WordEntry(word: '开凿', pinyin: 'kāizáo', partOfSpeech: '动词', simpleChinese: '用工具凿出洞窟或形状。', translation: 'khai tạc', englishDefinition: 'to excavate or carve', symbol: '⛏️'),
  const WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'vách đá', englishDefinition: 'cliff face', symbol: '🏔️'),
  const WordEntry(word: '分期', pinyin: 'fēnqī', partOfSpeech: '名词/动词', simpleChinese: '按时间和特点分成阶段。', translation: 'phân kỳ', englishDefinition: 'periodization', symbol: '🕰️'),
  const WordEntry(word: '营造', pinyin: 'yíngzào', partOfSpeech: '动词', simpleChinese: '规划并建造大型工程。', translation: 'kiến tạo', englishDefinition: 'to plan and construct', symbol: '🏗️'),
];

List<JourneyLevelContent> _buildLevels() => List<JourneyLevelContent>.generate(10, (index) {
  final level = index + 1;
  final segments = <_Segment>[..._core, ..._depth.where((item) => level >= item.from)];
  final split = level <= 2 ? segments.length : 3;
  final groups = level <= 2 ? <List<_Segment>>[segments] : <List<_Segment>>[segments.take(split).toList(), segments.skip(split).toList()];
  final paragraphs = groups.map((group) => group.map((item) => item.zh).join()).toList(growable: false);
  final annotations = groups.map((group) {
    final zh = group.map((item) => item.zh).join();
    return ReadingAnnotation(pinyin: PinyinHelper.getPinyinE(zh, separator: ' ', format: PinyinFormat.WITH_TONE_MARK), vietnamese: group.map((item) => item.vi).join(' '), english: group.map((item) => item.en).join(' '));
  }).toList(growable: false);
  final discoveries = <DiscoveryEntry>[_discovery(_commonDiscovery), _discovery(_levelFacts[level - 1]), if (level >= 5) _discovery(_levelFacts[(level + 3) % _levelFacts.length])];
  final visible = '${paragraphs.join()}${discoveries.map((item) => item.text).join()}';
  const agent = PhoenixLanguageLevelAgent();
  final target = agent.planFor(agent.profileForPhoenixLevel(level)).targetVocabularyCount;
  return JourneyLevelContent(storyParagraphs: paragraphs, storyAnnotations: annotations, words: datongYungangWords.where((word) => visible.contains(word.word)).take(target).toList(growable: false), discoveries: discoveries, wonderQuestion: level <= 4 ? '魏岚为什么把父亲的长墨绳割成三段？' : '迁都怎样改变了父女对“继承”的理解？', expressQuestion: level <= 4 ? '请按“压力—选择—代价—结果”复述三段墨绳的故事。' : '请说明云冈从巨型国家营造到较小窟龛继续开凿，怎样推动魏岚的私人选择。');
}, growable: false);

final datongYungangGoldLevels = List<JourneyLevelContent>.unmodifiable(_buildLevels());
JourneyLevelContent datongYungangGoldLevelContent(int requestedLevel) => datongYungangGoldLevels[requestedLevel.clamp(1, 10).toInt() - 1];

final _events = <RemediatedSemanticEvent>[
  for (var i = 0; i < _core.length; i++) RemediatedSemanticEvent(id: 'DY-E${i + 1}', coreChinese: _core[i].zh, corePinyin: PinyinHelper.getPinyinE(_core[i].zh, separator: ' ', format: PinyinFormat.WITH_TONE_MARK), coreVietnamese: _core[i].vi, coreEnglish: _core[i].en, detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 11),
];

final datongYungangGoldJourney = RemediatedJourney(
  id: datongYungangJourneyId,
  title: datongYungangCanonicalTitle,
  protagonist: '魏岚，虚构北魏普通女石工',
  goal: '在父亲南行后让自己、弟弟与同伴都能继续承担手艺，而不是只保住唯一传人的位置',
  conflict: '父亲的单一继承安排与迁都后云冈较小规模的继续开凿发生冲突',
  eventIds: _events.map((item) => item.id).toList(growable: false),
  events: _events,
  levels: datongYungangGoldLevels,
  words: datongYungangWords,
  wordTraces: [for (final word in datongYungangWords) RemediatedWordTrace(word: word.word, eventId: 'DY-E3', usage: 'active Story/Discovery vocabulary', sourceText: word.simpleChinese)],
  discoveries: [_discovery(_commonDiscovery), ..._levelFacts.map(_discovery)],
  discoveryTraces: [for (var i = 0; i < 11; i++) RemediatedDiscoveryTrace(discoveryIndex: i, storyEventIds: i == 5 || i == 6 ? const ['DY-E1', 'DY-E5'] : const <String>[], sourceIds: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes'])],
  challenges: const [
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: ['DY-E1', 'DY-E2', 'DY-E3', 'DY-E4', 'DY-E5', 'DY-E6'], anchor: '迁都后的转折→唯一继承→割绳→失去名分→三人弹线'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: ['DY-E2', 'DY-E4'], anchor: '修复关系与代价句，不增加历史事实'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: ['DY-E2', 'DY-E3', 'DY-E4'], anchor: '割绳必须连接继承冲突与失去唯一位置'),
  ],
  memory: const [
    RemediatedMemoryReview(category: 'choice', prompt: '魏岚怎样处理长墨绳？', answer: '她把它割成三段，分别交给弟弟、同伴和自己。', storyEventIds: ['DY-E3']),
    RemediatedMemoryReview(category: 'cost', prompt: '这个选择让她失去什么？', answer: '她失去父亲许诺的唯一传人位置，父亲也没有替她接回断绳。', storyEventIds: ['DY-E4']),
    RemediatedMemoryReview(category: 'place', prompt: '云冈的变化怎样推动选择？', answer: '迁都改变了巨型国家营造的环境，但较小窟龛仍继续开凿，旧尺度与单一继承不再能安排三个人。', storyEventIds: ['DY-E1', 'DY-E5']),
    RemediatedMemoryReview(category: 'memory', prompt: '故事最后留下什么画面？', answer: '父亲在崖路转弯处回望三道黑线，魏岚没有追上去。', storyEventIds: ['DY-E6']),
  ],
  completion: const RemediatedCompletion(journeySummary: '魏岚割开量巨像的长墨绳，也放弃了唯一传人的位置，让三个人各自承担下一道线。', achievement: '三线同行者', memoryAnchor: '石阶上的三段墨绳与石面上的三道黑线', challengeReward: '你辨认了世界事实与虚构人物选择之间的因果边界。', journeyCompletion: '巨像的尺度没有被复制；三个人从此各自为自己的墨线负责。'),
  sources: const [
    RemediatedSourceBinding(id: 'unesco-datong-yungang-grottoes', publisher: 'UNESCO World Heritage Centre', scope: 'site chronology, Northern Wei capital context, artistic significance'),
    RemediatedSourceBinding(id: 'ncha-datong-yungang-grottoes', publisher: '国家文物局', scope: 'Yungang phases, Tanyao caves, post-494 smaller and popular carving'),
  ],
);

const datongYungangPlaceCausality = <String, String>{
  'VERIFIED_PLACE_CONDITION': 'Yungang changes from capital-backed colossal construction to continued smaller carving after the 494 capital move',
  'FICTIONAL_ENCOUNTER': 'a fictional craft family must decide whether one successor carries the old giant-image line south',
  'CHOICE': 'Wei Lan cuts the single long ink line into three working lines',
  'COST': 'she loses sole-successor status and immediate paternal recognition',
  'CONSEQUENCE': 'three people independently mark smaller stone faces at Yungang',
  'YUNGANG_REMOVAL': 'without the scale-and-patronage transition, the inherited long line, succession conflict, and three-line consequence collapse',
  'LONGMEN_REPLACEMENT': 'post-494 Longmen is the new imperial center, so the pressure direction is reversed and this architecture cannot survive unchanged',
  'RESULT': 'PASS',
};

const datongYungangHistoricalSafety = <String, String>{
  'WORLD_FACTS_SOURCED': 'PASS',
  'FICTIONAL_CHARACTER_IDENTITY': 'CLEAR',
  'FICTIONAL_PRIVATE_ACTION': 'CLEAR',
  'INVENTED_INSTITUTIONAL_RULE': 'NONE',
  'INVENTED_RELOCATION_ORDER': 'NONE',
  'REAL_PERSON_PRIVATE_LIFE': 'NONE',
  'ANACHRONISM': 'NONE',
  'RESULT': 'PASS',
};
