import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';
import 'journey_level_catalog.dart';

const forbiddenCityJourneyId = 'beijing-forbidden-city';
const forbiddenCityMemoryAnchor = '一道没有跨过的门槛';

class ForbiddenCityWordRecord {
  const ForbiddenCityWordRecord({
    required this.entry,
    required this.usageNote,
    required this.storySource,
    required this.firstAppearsAt,
  });

  final WordEntry entry;
  final String usageNote;
  final String storySource;
  final int firstAppearsAt;
}

class ForbiddenCityMemoryReview {
  const ForbiddenCityMemoryReview({required this.prompt, required this.answer});

  final String prompt;
  final String answer;
}

final forbiddenCityStoryParagraphsByLevel = <List<String>>[
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想看太和殿，也想把路线画满。走到一处宫门时，顾文澜和周师傅正在看记录，一道本来不该进的门忽然开了。门后正是地图上的空白，沈砚很想进去。一个年幼侍役从规定的路匆匆走过。沈砚走到门槛前，却停下了。他明白门开着，不等于自己应该进去。门关上后，他在第二张地图上写下“界”，留下那块空白。周师傅把旧木尺交给他。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他一心想看太和殿，把自己的路线图画得完整。周师傅却总提醒他哪些路能走、哪些门不能过，沈砚觉得这些规矩妨碍了学习。后来，顾文澜和周师傅在一旁核对记录，一道通往更深宫院的门暂时打开。门后正好是地图上的空白。沈砚走到门槛前，一个年幼侍役从规定路线匆匆经过。他忽然想到：侍役天天在宫里，也不能想去哪里就去哪里。于是沈砚没有跨过去。门关上后，他有些遗憾，却在第二张地图上写下“界”，保留那块空白。周师傅把旧木尺交给他。沈砚明白，知道为什么停下，也是在理解建筑。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他原以为学习建筑，就是看清太和殿、宫门和院落，再把路线图画满。到了外朝，周师傅告诉他，这里的中轴和开阔庭院与重要礼仪、政务有关；走近乾清门后，空间转入更接近日常宫廷生活的内廷。沈砚第一次发现，外朝与内廷不只是建筑不同，人的行动方式也不同。',
    '顾文澜和周师傅核对记录时，一道通往更深宫院的门暂时打开。门后正是沈砚地图上的空白。他走到门槛前，看见一个年幼侍役沿规定路线匆匆经过，突然明白同在宫中，不同身份的人也有不同的路。沈砚最终没有跨过去。门关上后，他在第二张地图上写下“界”，有意留下空白。周师傅把旧木尺交给他。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他带着纸和尺，想把太和殿、宫门与院落一一画进地图。外朝的中轴、宽阔庭院和高大殿宇让他感到庄严；靠近乾清门以后，进入内廷的空间更细密，也更接近宫廷生活。周师傅提醒他，建筑不仅有形状，还安排礼仪、位置与行动。沈砚却仍觉得，看得越多，自己的图才越完整。',
    '顾文澜和周师傅核对记录时，一道平日不该进入的宫门暂时打开。门后的院落正是地图上的空白。沈砚走到门槛前，心里既兴奋又不安。一个年幼侍役从规定路线匆匆经过，他忽然看见身份与空间之间的边界：有人必须经过某些地方，也有人即使门开着也不应进入。沈砚没有跨过去。门关上后，他虽然遗憾，却在第二张地图上写下“界”，保留空白。周师傅把旧木尺交给他。沈砚明白，真正的测量也包括知道自己该在哪里停下。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他带着纸、墨和尺，暗暗想证明自己能看懂这座宫城。外朝沿中轴展开，太和殿前的尺度与秩序让他震动；到了乾清门附近，空间渐渐转入内廷，宫院和门道更密，人的位置也更具体。周师傅告诉他，建筑不只是梁柱与屋顶，还会规定谁从哪里接近、在哪里等待。沈砚听懂了，却仍执着于把路线图上的每一块空白填满。',
    '顾文澜与周师傅核对记录时，一道通往更深宫院的门意外敞开。沈砚知道自己不该进去，可门后恰好是那块最刺眼的空白。他向前走到门槛，甚至为自己找好理由：只是学习，只看一眼。就在这时，年幼侍役沿规定路线匆匆经过。沈砚突然意识到，别人每天生活在这里，也被身份和职责限定，而自己没有职责，却想把好奇解释成资格。他最终没有跨过去。门关上后，遗憾真实存在，但第二张地图也因此改变。他写下“界”，留下空白。周师傅把旧木尺交给他。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他原想用纸、墨和旧习惯记录梁柱、屋顶与尺度，证明自己能把宫城看懂。沿中轴进入外朝时，太和殿前的巨大庭院让人自然放慢脚步；走到乾清门附近，空间逐渐转向内廷，宫院、门与廊道更细密。周师傅说，礼仪并不只发生在典礼那一刻，轴线、门序和距离本身就在组织人的接近、等待与转向。沈砚开始理解这种空间秩序，却仍把“完整”想成地图上没有空白。',
    '顾文澜与周师傅核对记录时，一道通往更深宫院的门暂时敞开。门后正是沈砚没有画到的区域。他走到门槛前，没有人阻止，于是选择第一次真正落到自己手里。他想进去，却看见年幼侍役沿规定路线匆匆经过。两个人都在紫禁城中，但身份、职责和行动范围并不相同。沈砚忽然明白，门既连接空间，也界定谁能够进入。于是他没有跨过门槛。门后来关上，地图仍不完整。傍晚，他画第二张地图，把中轴、外朝、内廷、几道门和那片空白都留下，并写下“界”。周师傅把旧木尺交给他。沈砚终于知道，理解空间不只靠进入，也靠承认边界。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他熟悉梁柱、屋面和尺度，因此早晨的他相信：只要看见更多建筑，就能得到更完整的理解。沿中轴进入外朝，太和殿前的开阔庭院与层层门序让人的身体自然进入一种庄重节奏；到乾清门附近，空间转向内廷，宫院与廊道更密，日常生活的尺度也更明显。周师傅提醒他，宫城的秩序不仅写在建筑形制里，也写在人如何接近、等待、转向和停留。沈砚开始重画自己的空间认知，却仍舍不得地图上的空白。',
    '顾文澜与周师傅核对记录时，一道通往更深宫院的门暂时打开。那片未画区域近在眼前，沈砚甚至能把越界解释成求知。他走到门槛前，没有人命令他停。恰在此时，年幼侍役沿规定路线匆匆经过。沈砚忽然看见，同一座宫城并不会以同一种方式向所有身份开放：侍役有必须履行的职责，也有不能任意跨越的行动边界；自己有机会，却没有进入的理由。于是他没有跨过去。门关上后，他承受了错失，也得到另一种完整。第二张地图不再追求占满，而标出中轴、礼仪空间、生活空间、门与空白，并在门旁写下“界”。周师傅把旧木尺郑重交给他。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想看清太和殿，把所有经过的宫门和院落填进路线图。外朝却先让他意识到另一层结构：中轴、庭院尺度与门序共同制造庄严的礼仪距离；到乾清门附近进入内廷后，空间变得更细密，宫廷生活、身份和行动范围也更直接地交织在一起。周师傅说，空间不只是容纳人，它还安排人。沈砚开始明白，建筑的意义不仅存在于形制，也存在于谁能接近、谁须等待、谁在何处转向。顾文澜还提醒他，今天看到的安静院落，曾经承担具体的宫廷功能，不能只当作风景。他也开始注意，今日参观者看到的是作为博物院与世界遗产开放的宫殿，而故事所讨论的历史边界来自过去的宫廷制度，两者不能混为一谈。',
    '顾文澜与周师傅核对记录时，一道平日不属于沈砚行动范围的门暂时打开。门后正是地图上最诱人的空白。他走到门槛前，发现最危险的理由并不是“我想违规”，而是“我是来学习，所以多看一点也合理”。年幼侍役恰好沿规定路线匆匆经过，让沈砚看见空间与身份的双向关系：同一扇门对不同的人意味着不同的许可、职责与限制。若他跨过去，地图会更满，却可能把“理解”变成对空间的占有。于是沈砚没有跨过门槛。门关上后，他重新画第二张地图，保留那片空白，并在旁边写下“界”。周师傅把旧木尺交给他。那道没有跨过的门槛没有削弱他的理解，反而使他第一次承认历史空间有自己的边界。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。沿中轴进入外朝后，他发现太和殿前的宏阔并非单纯追求壮观。轴线、庭院、宫门次序和距离共同构成礼制的空间表达，使人的接近、停留和视线都被组织起来。到乾清门附近转入内廷，空间尺度更细密，宫廷生活也使身份与行动边界变得具体。周师傅提醒他，建筑既塑造秩序，也让秩序通过人的身体被体验。沈砚开始理解这句话，却仍把地图的空白视为知识的缺口。顾文澜提醒他，今天作为博物院开放的路线，与明清宫廷真实使用空间并不相同。学习者既要读懂建筑保存的制度痕迹，也要避免把历史秩序简单复制到当代价值判断中。',
    '顾文澜与周师傅核对记录时，一道通往更深宫院的门暂时敞开。门后就是那块缺口。没有人看着他，沈砚甚至可以把越界包装成勤学。他走到门槛前，看见年幼侍役沿规定路线匆匆经过，忽然意识到所谓空间等级并非图纸上的抽象概念，而是不同身份的人每天以行走、等待、转向和禁止进入不断实现的历史现实。对侍役而言，某些路线是职责；对沈砚而言，这扇开着的门却只是机会。若把机会误认成资格，他得到的只会是更多景象，而不是更准确的理解。于是他没有跨过去。门关上后，遗憾与领悟同时留下。第二张地图舍弃了“占满”和占有的冲动，只标出中轴、礼仪与生活空间、关键门序和那片空白，并写下“界”。周师傅把旧木尺交给他。那道没有跨过的门槛成为地图最有意义的一处。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想亲眼确认太和殿的形制，也想把宫城尽可能填进自己的图。进入外朝后，宏阔的庭院、中轴与层层门序却让他意识到，建筑从来不是静止的物件集合。礼制借由尺度、方向、接近次序和停留位置成为空间经验；到了乾清门附近，内廷更密集的宫院、廊道与生活空间又把身份、职责和行动范围写进日常。周师傅告诉他，真正的营造不仅处理结构，也要读懂人与空间之间的关系。沈砚开始动摇，却仍本能地厌恶地图上的空白，因为空白像在提醒他还有一部分宫城没有被自己的目光掌握。顾文澜进一步提醒他，今天的故宫是博物院，也是世界文化遗产；参观者所能进入的路线，与明清宫廷中真实的功能分区和身份边界并不相同。理解历史空间，既需要承认过去制度留下的结构，也不能把那套等级秩序当成今天应当延续的规则。',
    '顾文澜与周师傅核对记录时，一道通往更深宫院的门临时敞开。没有守卫催促，也没有师父提醒，门后恰是那片未完成的区域。沈砚走到门槛前，发现诱惑最强的地方恰恰在于它可以被包装成求知：我是学徒，多看一点有什么错？就在这时，年幼侍役沿规定路线匆匆经过。那道身影让沈砚突然看清，紫禁城的空间并非同质地向所有人开放。宫门既连接也区分，行动既受建筑引导，也受身份与职责限定；历史中的宏伟秩序与个人限制，往往属于同一个空间系统。若他只因为门开着就跨过去，便会把“可以进入”误成“有理由进入”，也把理解偷偷变成占有。于是沈砚停下，没有跨过门槛。门后来关上，地图仍留下空白。傍晚，他画出第二张图，不再追求填满，而用中轴、礼仪空间、生活空间、门序和留白记录关系，并在那扇门旁写下“界”。周师傅把用了多年的旧木尺交给他。沈砚终于懂得，一把尺能量出距离，却量不出一个人为何应该停下。那道没有跨过的门槛因此成为整张地图最清楚的一笔。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。',
  ],
];

final forbiddenCityLockedStories = forbiddenCityStoryParagraphsByLevel
    .map((paragraphs) => paragraphs.join('\n\n'))
    .toList(growable: false);

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

const _support = <List<(String, String)>>[
  [('Thẩm Nghiên muốn vẽ kín lộ trình, nhưng dừng trước một cánh cổng mở và giữ lại khoảng trống trên bản đồ thứ hai.', 'Shen Yan wants to fill his route map, but stops at an open gate and preserves the blank on his second map.')],
  [('Thẩm Nghiên thấy các quy tắc cản trở việc học, rồi hiểu rằng ngay cả người sống trong cung cũng có những tuyến đường không thể tùy ý vượt qua.', 'Shen Yan first sees rules as obstacles to learning, then realizes that even people living in the palace cannot move wherever they wish.')],
  [('Ở Ngoại triều và Nội đình, Thẩm Nghiên bắt đầu thấy kiến trúc gắn với nghi lễ, đời sống và cách con người di chuyển.', 'Across the Outer and Inner Courts, Shen Yan begins to see architecture as connected to ritual, daily life, and movement.'), ('Một cánh cổng mở đặt cậu trước lựa chọn; nhìn thấy tiểu thị dịch, cậu nhận ra những thân phận khác nhau có những con đường khác nhau và không bước qua.', 'An open gate gives him a choice; seeing the young attendant, he realizes different identities have different routes and does not cross.')],
  [('Thẩm Nghiên quan sát sự khác biệt về quy mô giữa Ngoại triều và Nội đình, nhưng vẫn nghĩ bản đồ càng đầy thì càng hoàn chỉnh.', 'Shen Yan notices the spatial contrast between the Outer and Inner Courts, yet still thinks a fuller map means fuller understanding.'), ('Trước cánh cổng mở, cậu thấy ranh giới giữa thân phận và không gian, giữ lại khoảng trống và hiểu rằng đo đạc cũng bao gồm biết nơi nên dừng.', 'At the open gate he sees the boundary between identity and space, keeps the blank, and learns that measurement also includes knowing where to stop.')],
  [('Thẩm Nghiên muốn chứng minh mình hiểu cung thành, nhưng dần thấy kiến trúc còn tổ chức việc tiếp cận và chờ đợi của con người.', 'Shen Yan wants to prove he understands the palace, but gradually sees that architecture also organizes approach and waiting.'), ('Cậu nhận ra mình đang biến tò mò thành một thứ quyền tự cho phép, nên không bước qua và để chữ “giới” thay đổi ý nghĩa của bản đồ thứ hai.', 'He realizes he is turning curiosity into self-granted permission, so he does not cross and lets “boundary” reshape the meaning of the second map.')],
  [('Trục, cửa và khoảng cách của Ngoại triều và Nội đình khiến Thẩm Nghiên hiểu nghi lễ có thể được tổ chức thành trải nghiệm không gian.', 'Axis, gates, and distance across the Outer and Inner Courts show Shen Yan how ritual can be organized as spatial experience.'), ('Không ai ngăn cậu, nên lựa chọn trở thành phán đoán của chính mình. Cậu hiểu cửa vừa kết nối vừa giới hạn và vẽ lại bản đồ quanh các quan hệ ấy.', 'With no one stopping him, the choice becomes his own judgment. He learns that gates both connect and delimit, and redraws the map around those relations.')],
  [('Thẩm Nghiên bắt đầu đọc kiến trúc qua nhịp đi, chờ, đổi hướng và dừng lại, thay vì chỉ qua hình thức và kích thước.', 'Shen Yan begins reading architecture through patterns of walking, waiting, turning, and stopping rather than only form and scale.'), ('Cậu thấy cơ hội không đồng nghĩa với lý do chính đáng để vào. Bản đồ thứ hai vì thế ghi lại cả không gian lẫn giới hạn của hành động.', 'He sees that opportunity is not the same as justification to enter. The second map therefore records both space and limits on action.')],
  [('Thẩm Nghiên liên hệ trục, nghi lễ, đời sống cung đình, thân phận và phạm vi hành động, đồng thời phân biệt di sản mở cửa hôm nay với ranh giới lịch sử.', 'Shen Yan connects axis, ritual, court life, identity, and movement while distinguishing today’s open heritage site from historical boundaries.'), ('Cậu nhận ra việc bước qua chỉ để lấp đầy bản đồ có thể biến “hiểu” thành “chiếm hữu”, nên giữ lại khoảng trống như một phần của hiểu biết lịch sử.', 'He realizes crossing merely to fill the map could turn understanding into possession, so he preserves the blank as part of historical understanding.')],
  [('Ở cấp độ sâu hơn, Thẩm Nghiên đọc lễ chế qua trục, quy mô, thứ tự cổng và chuyển động của cơ thể, nhưng vẫn bị ám ảnh bởi khoảng trống kiến thức.', 'At a deeper level, Shen Yan reads ritual order through axis, scale, gate sequence, and embodied movement, yet remains troubled by gaps in knowledge.'), ('Cậu phân biệt cơ hội với tư cách, từ chối vượt ranh giới và biến khoảng trống trên bản đồ thành bằng chứng trung thực thay vì một thất bại.', 'He distinguishes opportunity from entitlement, refuses to cross, and turns the map’s blank into honest evidence rather than failure.')],
  [('Thẩm Nghiên hiểu Tử Cấm Thành như một hệ thống nơi kiến trúc, nghi lễ, chức năng, thân phận và hành động cùng tạo nên lịch sử không gian.', 'Shen Yan comes to understand the Forbidden City as a system where architecture, ritual, function, identity, and action jointly form spatial history.'), ('Khi cánh cổng mở, cậu từ chối biến khả năng thành quyền chiếm hữu, để “giới”, bản đồ thứ hai và chiếc thước gỗ cũ trở thành dấu mốc của cách nhìn mới.', 'When the gate opens, he refuses to turn possibility into possession, allowing “boundary,” the second map, and the old wooden ruler to mark his new way of seeing.')],
];

List<ReadingAnnotation> _storyAnnotationsForLevel(int level) {
  final paragraphs = forbiddenCityStoryParagraphsByLevel[level - 1];
  final support = _support[level - 1];
  return List<ReadingAnnotation>.generate(
    paragraphs.length,
    (index) => ReadingAnnotation(
      pinyin: _pinyin(paragraphs[index]),
      vietnamese: support[index].$1,
      english: support[index].$2,
    ),
    growable: false,
  );
}

const forbiddenCityWordRecords = <ForbiddenCityWordRecord>[
  ForbiddenCityWordRecord(entry: WordEntry(word: '营造学徒', pinyin: 'yíngzào xuétú', partOfSpeech: '名词', simpleChinese: '学习传统建筑营造工作的年轻学徒。', translation: 'học việc xây dựng truyền thống', englishDefinition: 'construction apprentice', symbol: '🪚'), usageNote: '主人公的职业身份。', storySource: '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '宫门', pinyin: 'gōngmén', partOfSpeech: '名词', simpleChinese: '宫城或宫殿中的门。', translation: 'cổng cung điện', englishDefinition: 'palace gate', symbol: '🚪'), usageNote: '连接空间，也形成边界。', storySource: '走到一处宫门时，顾文澜和周师傅正在看记录，一道本来不该进的门忽然开了。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '侍役', pinyin: 'shìyì', partOfSpeech: '名词', simpleChinese: '在宫廷中从事服务或杂务的人。', translation: 'người phục dịch', englishDefinition: 'attendant', symbol: '👤'), usageNote: '虚构角色，用来表现身份与路线。', storySource: '一个年幼侍役从规定的路匆匆走过。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '门槛', pinyin: 'ménkǎn', partOfSpeech: '名词', simpleChinese: '门下方需要跨过的部分，也可表示界线。', translation: 'ngưỡng cửa', englishDefinition: 'threshold', symbol: '🚧'), usageNote: '核心选择发生的位置。', storySource: '沈砚走到门槛前，却停下了。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '空白', pinyin: 'kòngbái', partOfSpeech: '名词', simpleChinese: '没有写、画或填入内容的地方。', translation: 'khoảng trống', englishDefinition: 'blank space', symbol: '⬜'), usageNote: '从地图缺口变成有意义的留白。', storySource: '门后正是地图上的空白，沈砚很想进去。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '旧木尺', pinyin: 'jiù mùchǐ', partOfSpeech: '名词', simpleChinese: '周师傅使用多年的木制尺。', translation: 'thước gỗ cũ', englishDefinition: 'old wooden ruler', symbol: '📏'), usageNote: '师徒传承的奖励意象。', storySource: '周师傅把旧木尺交给他。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '界', pinyin: 'jiè', partOfSpeech: '名词', simpleChinese: '分开不同范围的边界。', translation: 'ranh giới', englishDefinition: 'boundary', symbol: '〰️'), usageNote: '第二张地图的核心字。', storySource: '门关上后，他在第二张地图上写下“界”，留下那块空白。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '外朝', pinyin: 'wàicháo', partOfSpeech: '名词', simpleChinese: '与重大典礼和政务活动关系密切的宫廷区域。', translation: 'Ngoại triều', englishDefinition: 'Outer Court', symbol: '🏛️'), usageNote: '与内廷形成空间功能对照。', storySource: '到了外朝，周师傅告诉他，这里的中轴和开阔庭院与重要礼仪、政务有关；', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '内廷', pinyin: 'nèitíng', partOfSpeech: '名词', simpleChinese: '与皇帝、后妃等宫廷成员生活联系更密切的区域。', translation: 'Nội đình', englishDefinition: 'Inner Court', symbol: '🏯'), usageNote: '表现宫廷生活空间。', storySource: '走近乾清门后，空间转入更接近日常宫廷生活的内廷。', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '中轴', pinyin: 'zhōngzhóu', partOfSpeech: '名词', simpleChinese: '组织建筑群的重要中心轴线。', translation: 'trục trung tâm', englishDefinition: 'central axis', symbol: '↕️'), usageNote: '组织空间与路线。', storySource: '到了外朝，周师傅告诉他，这里的中轴和开阔庭院与重要礼仪、政务有关；', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '礼仪', pinyin: 'lǐyí', partOfSpeech: '名词', simpleChinese: '正式活动中的仪式与行为规范。', translation: 'nghi lễ', englishDefinition: 'ritual; ceremony', symbol: '📜'), usageNote: '连接外朝空间与典礼。', storySource: '到了外朝，周师傅告诉他，这里的中轴和开阔庭院与重要礼仪、政务有关；', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '身份', pinyin: 'shēnfèn', partOfSpeech: '名词', simpleChinese: '一个人在制度或社会关系中的位置。', translation: 'thân phận; địa vị', englishDefinition: 'identity; status', symbol: '🪪'), usageNote: '解释不同人物的行动范围。', storySource: '突然明白同在宫中，不同身份的人也有不同的路。', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '占有', pinyin: 'zhànyǒu', partOfSpeech: '动词', simpleChinese: '把某物或某范围看成自己拥有。', translation: 'chiếm hữu', englishDefinition: 'possess; appropriate', symbol: '✋'), usageNote: '反省把求知变成占有的冲动。', storySource: '若他跨过去，地图会更满，却可能把“理解”变成对空间的占有。', firstAppearsAt: 8),
  ForbiddenCityWordRecord(entry: WordEntry(word: '礼制', pinyin: 'lǐzhì', partOfSpeech: '名词', simpleChinese: '由礼仪、等级和制度规范形成的体系。', translation: 'lễ chế', englishDefinition: 'ritual system', symbol: '📚'), usageNote: '说明建筑如何表达历史制度。', storySource: '轴线、庭院、宫门次序和距离共同构成礼制的空间表达，使人的接近、停留和视线都被组织起来。', firstAppearsAt: 9),
  ForbiddenCityWordRecord(entry: WordEntry(word: '空间系统', pinyin: 'kōngjiān xìtǒng', partOfSpeech: '名词短语', simpleChinese: '由建筑、功能、边界与人的行动共同组成的空间关系整体。', translation: 'hệ thống không gian', englishDefinition: 'spatial system', symbol: '🧩'), usageNote: '最高阶的整体空间理解。', storySource: '历史中的宏伟秩序与个人限制，往往属于同一个空间系统。', firstAppearsAt: 10),
];

DiscoveryEntry _discovery(String text, String simpleChinese, String vietnamese, String english) => DiscoveryEntry(text: text, pinyin: _pinyin(text), simpleChinese: simpleChinese, vietnamese: vietnamese, english: english);

final forbiddenCityDiscoveries = <DiscoveryEntry>[
  _discovery('紫禁城的宫殿总体沿南北中轴展开，重要宫门、庭院和殿宇通过连续的空间次序形成强烈的方向感。今天这里是故宫博物院，也是世界文化遗产；学习历史空间时，需要把今天的参观体验与过去的宫廷使用方式区分开。', '紫禁城有明显的南北中轴。今天它是博物院和世界文化遗产，历史上的使用方式与今天参观路线不同。', 'Tử Cấm Thành được tổ chức mạnh theo trục bắc-nam. Ngày nay đây là Bảo tàng Cố Cung và Di sản Thế giới, vì vậy cần phân biệt tuyến tham quan hiện đại với cách sử dụng cung đình trong lịch sử.', 'The Forbidden City is strongly organized along a north-south axis. Today it is the Palace Museum and a World Heritage site, so modern visitor routes should be distinguished from historical court use.'),
  _discovery('外朝与内廷是理解紫禁城空间功能的重要框架。外朝核心区域与重大典礼、政务关系密切；内廷则与皇帝、后妃等宫廷成员的生活联系更紧。乾清门附近是前后空间转换的重要节点，但历史使用并不能被理解成一条绝对、机械的分界线。', '外朝更接近重要典礼和政务，内廷更接近宫廷生活；乾清门附近是重要转换节点。', 'Ngoại triều gắn chặt với nghi lễ lớn và chính vụ, còn Nội đình gần hơn với đời sống cung đình. Khu vực gần Càn Thanh Môn là một nút chuyển tiếp quan trọng.', 'The Outer Court was closely tied to major ceremonies and state affairs, while the Inner Court was more closely connected to imperial household life. The Gate of Heavenly Purity area is an important transition.'),
  _discovery('紫禁城的礼仪秩序不只存在于典礼举行的瞬间。中轴、院落尺度、宫门位置和接近次序会持续影响人的视线、等待与行走，因此建筑本身能够保存制度曾经如何被体验的线索。理解这种关系，不等于赞美过去的等级制度。', '中轴、院落、宫门和距离会影响人怎样走和看。理解历史不等于赞美旧等级。', 'Trật tự nghi lễ còn được lưu trong trục, quy mô sân, vị trí cổng và thứ tự tiếp cận. Hiểu mối quan hệ này không có nghĩa là ca ngợi hệ thống thứ bậc cũ.', 'Ritual order is also preserved in axis, courtyard scale, gate positions, and sequences of approach. Understanding that relationship does not mean praising historical hierarchy.'),
  _discovery('故事中的年幼侍役是虚构人物，用来帮助学习者理解一个真实的历史问题：宫廷空间并不会以同一种方式向所有身份开放。不同职责、等级与制度位置会影响人的活动范围。今天讨论这种边界时，应把它视为理解历史社会结构的线索，而不是现代行为规范。', '侍役是虚构角色，但不同身份在历史宫廷中拥有不同活动范围这一点有真实制度背景。', 'Tiểu thị dịch là nhân vật hư cấu, nhưng sự khác biệt về phạm vi hoạt động theo thân phận có nền tảng lịch sử có thật. Đây là manh mối lịch sử, không phải chuẩn mực hiện đại.', 'The young attendant is fictional, but historically different statuses did have different ranges of movement. This is evidence for understanding historical society, not a modern behavioral rule.'),
  _discovery('沈砚的第二张地图把“没有进入”也记录下来，这接近历史研究中的一个重要态度：证据不足时，不应为了制造完整感而随意补齐未知。建筑史、考古与文物研究都需要区分已经确认的材料、合理推测和仍然未知的部分。', '研究历史时，未知就是未知。不能为了让答案看起来完整，就把没有证据的部分补出来。', 'Bản đồ thứ hai ghi cả phần không đi vào. Trong nghiên cứu lịch sử, khi bằng chứng chưa đủ, không nên lấp phần chưa biết chỉ để tạo cảm giác hoàn chỉnh.', 'The second map records what was not entered. In historical research, insufficient evidence should not be filled merely to create a sense of completeness.'),
];

List<DiscoveryEntry> _discoveriesForLevel(int level) {
  if (level <= 2) return <DiscoveryEntry>[forbiddenCityDiscoveries[0]];
  if (level <= 4) return <DiscoveryEntry>[forbiddenCityDiscoveries[1], forbiddenCityDiscoveries[0]];
  if (level <= 7) return <DiscoveryEntry>[forbiddenCityDiscoveries[1], forbiddenCityDiscoveries[2]];
  return <DiscoveryEntry>[forbiddenCityDiscoveries[3], forbiddenCityDiscoveries[4]];
}

const forbiddenCityMemoryReviews = <ForbiddenCityMemoryReview>[
  ForbiddenCityMemoryReview(prompt: '故事的主人公是谁？', answer: '沈砚，十七岁的营造学徒。'),
  ForbiddenCityMemoryReview(prompt: '周师傅怎样改变沈砚看建筑的方法？', answer: '他让沈砚不只看建筑形状，也观察人怎样接近、等待、转向和停下。'),
  ForbiddenCityMemoryReview(prompt: '顾文澜在故事里承担什么作用？', answer: '她和周师傅核对记录，并在高等级版本中提醒沈砚区分历史使用方式与今天的参观视角。'),
  ForbiddenCityMemoryReview(prompt: '年幼侍役让沈砚看见什么？', answer: '同在宫城中，不同身份和职责的人也可能拥有不同的行动范围。'),
  ForbiddenCityMemoryReview(prompt: '真正的冲突是什么？', answer: '一道通往更深宫院的门暂时打开，沈砚有机会进入一个本来不该进入的空间。'),
  ForbiddenCityMemoryReview(prompt: '沈砚做了什么选择？', answer: '他主动停在门槛前，没有跨过去。'),
  ForbiddenCityMemoryReview(prompt: '这个选择带来什么后果？', answer: '门后来关闭，地图仍有空白，但那块空白变得更有意义。'),
  ForbiddenCityMemoryReview(prompt: '“界”为什么重要？', answer: '它把宫门从建筑构件变成空间、身份、职责与自我判断之间的边界。'),
  ForbiddenCityMemoryReview(prompt: '第二张地图与第一张有什么不同？', answer: '第二张地图不再追求填满，而用中轴、空间关系、宫门和留白记录理解。'),
  ForbiddenCityMemoryReview(prompt: '周师傅最后给沈砚什么？', answer: '一把使用多年的旧木尺。'),
  ForbiddenCityMemoryReview(prompt: 'Journey 的 Memory Anchor 是什么？', answer: forbiddenCityMemoryAnchor),
];

const forbiddenCityJourneySummary = '沈砚第一次随周师傅进入紫禁城，从只想看更多、把地图填满，逐渐学会观察中轴、外朝与内廷、礼仪、身份和行动边界。当一道不该进入的宫门暂时打开时，他选择停在门槛前。第二张地图因此留下空白，并写下“界”。';
const forbiddenCityAchievementName = '识界 · Read the Boundary';
const forbiddenCityChallengeRewardName = '旧木尺 · The Old Wooden Ruler';
const forbiddenCityChallengeRewardMeaning = '旧木尺提醒学习者：测量建筑之前，还要理解自己站在哪里，以及人与空间之间有哪些关系和边界。';
const forbiddenCityJourneyCompletion = '那道没有跨过的门槛没有让地图残缺，反而让第二张地图第一次拥有真正的意义。那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。';

List<String> validateForbiddenCityWordTrace() {
  final invalid = <String>[];
  for (final record in forbiddenCityWordRecords) {
    final levels = <int>[];
    for (var index = 0; index < forbiddenCityLockedStories.length; index += 1) {
      if (forbiddenCityLockedStories[index].contains(record.entry.word)) {
        levels.add(index + 1);
      }
    }
    if (levels.isEmpty ||
        levels.first != record.firstAppearsAt ||
        !record.storySource.contains(record.entry.word) ||
        !forbiddenCityLockedStories.any((story) => story.contains(record.storySource))) {
      invalid.add(record.entry.word);
    }
  }
  return invalid;
}

List<WordEntry> forbiddenCityWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final maximum = <int>[5, 6, 7, 8, 9, 10, 11, 13, 14, 15][safeLevel - 1];
  return forbiddenCityWordRecords
      .where((record) => record.firstAppearsAt <= safeLevel && story.contains(record.entry.word))
      .take(maximum)
      .map((record) => record.entry)
      .toList(growable: false);
}

List<String> forbiddenCityStoryReadingSegments(String story, int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final paragraphs = story.split('\n\n').map((item) => item.trim()).where((item) => item.isNotEmpty).toList(growable: false);
  final expected = safeLevel <= 2 ? 1 : 2;
  if (paragraphs.length != expected) {
    throw StateError('Forbidden City Lv.$safeLevel must contain exactly $expected Story paragraph(s).');
  }
  return paragraphs;
}

JourneyLevelContent forbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final paragraphs = List<String>.unmodifiable(forbiddenCityStoryParagraphsByLevel[safeLevel - 1]);
  return JourneyLevelContent(
    storyParagraphs: paragraphs,
    storyAnnotations: _storyAnnotationsForLevel(safeLevel),
    words: forbiddenCityWordsForLevel(safeLevel),
    discoveries: _discoveriesForLevel(safeLevel),
    wonderQuestion: '沈砚在 Lv.$safeLevel 为什么没有跨过那道门槛？',
    expressQuestion: '请用 Lv.$safeLevel 的语言说明“界”怎样改变了第二张地图的意义。',
  );
}
