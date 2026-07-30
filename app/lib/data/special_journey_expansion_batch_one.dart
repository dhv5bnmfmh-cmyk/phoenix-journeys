import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

JourneyContentRecord _record(
  String id,
  String title,
  String geoNodeId,
  List<String> paragraphs,
) =>
    JourneyContentRecord(
      id: id,
      title: title,
      geoNodeId: geoNodeId,
      languageCode: 'zh-CN',
      verificationStatus: StoryVerificationStatus.reviewed,
      tags: const ['万象奇旅', '原创文学', '古今融合', '中文学习'],
      sections: List.generate(
        paragraphs.length,
        (index) => JourneyStorySection(
          id: 'story-$index',
          text: paragraphs[index],
          sourceIds: const [],
        ),
      ),
    );

ReadingAnnotation _note(
  String pinyin,
  String vietnamese,
  String english,
) =>
    ReadingAnnotation(
      pinyin: pinyin,
      vietnamese: vietnamese,
      english: english,
    );

WordEntry _word(
  String word,
  String pinyin,
  String part,
  String simple,
  String vietnamese,
  String english,
  String symbol,
) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: part,
      simpleChinese: simple,
      translation: vietnamese,
      englishDefinition: english,
      symbol: symbol,
    );

DiscoveryEntry _discovery(
  String text,
  String pinyin,
  String simple,
  String vietnamese,
  String english,
) =>
    DiscoveryEntry(
      text: text,
      pinyin: pinyin,
      simpleChinese: simple,
      vietnamese: vietnamese,
      english: english,
    );

const _changanStory = <String>[
  '雨夜，你赶上穿过西安城墙的末班车。车里只坐着一位抱铜镜的乘客；每经过一座城门，镜面便多出一条不属于现代街道的灯影。',
  '车驶入隧道，窗外忽然变成坊市深夜。那位乘客说，他每隔百年乘一次这班车，寻找一张没有写完的归家车票。',
  '终点站没有站名，只有一座雨中的候车亭。你在地上拾到半张旧票，背面映出自己的座位，而车厢里已经空无一人。',
  '天将亮时，你把车票投入铜镜。古城灯影退回雨水，末班车重新驶向现代街道；座位上留下了一束温暖晨光。',
];

final _changanRecord = _record(
  'changan-last-bus',
  '传奇夜行 · 长安末班车',
  'phoenix-realms-changan-last-bus',
  _changanStory,
);

final _changanExperience = DailyJourneyExperience(
  id: _changanRecord.id,
  city: '雨长安',
  cityCode: 'CLB',
  place: '城门夜线',
  appBarTitle: '传奇夜行 · 长安末班车',
  storyTitle: '没有站名的终点',
  headline: '在一班跨越古今的夜车上归还旧票',
  description: '用唐传奇的奇遇结构进入当代城市悬疑，辨认铜镜、车票与归途。',
  discoveryTeaser: '古代传奇怎样把日常旅途变成命运转折？',
  distanceLabel: '城门一夜',
  stampSymbol: '车',
  content: _changanRecord,
  storyAnnotations: [
    _note('Yǔyè, nǐ gǎnshàng chuānguò Xī’ān chéngqiáng de mòbānchē.', 'Trong đêm mưa, bạn kịp chuyến xe cuối đi qua tường thành Tây An.', 'On a rainy night, you catch the last bus through Xi’an’s city wall.'),
    _note('Měi jīngguò yí zuò chéngmén, jìngmiàn biàn duō chū yì tiáo dēngyǐng.', 'Mỗi khi qua cổng thành, gương lại hiện thêm một dải đèn cổ.', 'Each city gate adds another old lantern street to the mirror.'),
    _note('Zhōngdiǎnzhàn méiyǒu zhànmíng, zhǐyǒu yí zuò yǔzhōng hòuchētíng.', 'Bến cuối không tên, chỉ có trạm chờ trong mưa.', 'The terminus has no name, only a shelter in the rain.'),
    _note('Gǔchéng dēngyǐng tuìhuí yǔshuǐ, mòbānchē shǐxiàng xiàndài jiēdào.', 'Ánh đèn cổ tan vào mưa, xe trở lại phố hiện đại.', 'The old lights recede into rain as the bus returns to the modern city.'),
  ],
  words: [
    _word('末班车', 'mòbānchē', '名词', '当天最后一班公共交通。', 'Chuyến xe cuối ngày.', 'last bus or train', '🚌'),
    _word('铜镜', 'tóngjìng', '名词', '古代用铜制作的镜子。', 'Gương đồng.', 'bronze mirror', '🪞'),
    _word('坊市', 'fāngshì', '名词', '古代城市中的街坊和市场。', 'Phường chợ cổ.', 'historic wards and markets', '🏮'),
    _word('归途', 'guītú', '名词', '回去的路。', 'Đường trở về.', 'the journey home', '↩️'),
    _word('映出', 'yìngchū', '动词', '通过光线显出影像。', 'Phản chiếu.', 'to reflect or reveal', '◐'),
    _word('退回', 'tuìhuí', '动词', '向后回到原处。', 'Lùi trở lại.', 'to recede or return', '🌧️'),
  ],
  discoveries: [
    _discovery('唐传奇常让普通人因一次旅途、相遇或异物进入超常世界。', 'Táng chuánqí cháng ràng pǔtōngrén yīn yí cì lǚtú jìnrù chāocháng shìjiè.', '传奇常从日常突然进入奇遇。', 'Truyền kỳ đời Đường thường mở thế giới kỳ lạ từ một chuyến đi bình thường.', 'Tang chuanqi often turns an ordinary journey or encounter into a supernatural passage.'),
    _discovery('现代城市悬疑重视交通、监控、夜班与陌生人相遇等本土日常空间。', 'Xiàndài chéngshì xuányí zhòngshì běntǔ rìcháng kōngjiān.', '现代悬疑会使用熟悉的城市空间。', 'Trinh thám đô thị hiện đại thường dùng không gian giao thông và ca đêm quen thuộc.', 'Modern urban suspense often draws tension from familiar transit and night-work spaces.'),
    _discovery('《长安末班车》是 Phoenix 原创故事，不改写任何现成小说、影视或游戏。', '“Cháng’ān mòbānchē” shì Phoenix yuánchuàng gùshì.', '体裁元素有传统来源，人物和情节完全原创。', 'Đây là truyện nguyên tác Phoenix, không chuyển thể tác phẩm có sẵn.', 'The story is wholly original, combining genre traditions without adapting an existing work.'),
  ],
  wonderQuestion: '如果车票只能送一个人回到最想念的年代，你会把它交给谁？',
  expressQuestion: '请用“原来……却……”写出你发现末班车秘密的一刻。',
);

const _tideStory = <String>[
  '海边小城停电的清晨，你在旧收音机里听见一段没有播完的天气预报。播音员念出二十年前的日期，又说今天会有一封信随潮水回来。',
  '你沿湿漉漉的巷子走到渡口。雾里的船没有靠岸，只有一只没有写字的信封被浪推到绳桩旁，里面传出熟悉的哼唱。',
  '月升以后，废弃剧场的幕布被海风吹开。收音机播放母亲年轻时留下的录音，却在最重要的一句话前再次中断。',
  '你没有追问缺失的句子，而是录下此刻的潮声放进信封。日出时，渡船重新鸣笛，旧信带着两个时代的声音驶向海面。',
];

final _tideRecord = _record(
  'tide-letter',
  '词境回声 · 潮声旧信',
  'phoenix-realms-tide-letter',
  _tideStory,
);

final _tideExperience = DailyJourneyExperience(
  id: _tideRecord.id,
  city: '潮城',
  cityCode: 'TDL',
  place: '回声渡口',
  appBarTitle: '词境回声 · 潮声旧信',
  storyTitle: '没有播完的天气预报',
  headline: '把宋词般的离愁放进当代海岸记忆',
  description: '从旧收音机、渡船与家庭录音中，寻找潮水带回的未完成句子。',
  discoveryTeaser: '宋词的景物如何在现代本土故事里继续表达离别？',
  distanceLabel: '一潮旧声',
  stampSymbol: '潮',
  content: _tideRecord,
  storyAnnotations: [
    _note('Hǎibiān xiǎochéng tíngdiàn de qīngchén, nǐ tīngjiàn èrshí nián qián de tiānqì yùbào.', 'Sáng mất điện ở thị trấn biển, bạn nghe dự báo thời tiết từ hai mươi năm trước.', 'During a coastal blackout, you hear a weather report from twenty years ago.'),
    _note('Yì zhī méiyǒu xiězì de xìnfēng bèi làng tuī dào shéngzhuāng páng.', 'Một phong thư trống bị sóng đẩy tới cọc dây.', 'An unmarked envelope washes against a mooring post.'),
    _note('Shōuyīnjī bōfàng mǔqīn niánqīng shí liúxià de lùyīn.', 'Radio phát bản ghi mẹ để lại khi còn trẻ.', 'The radio plays a recording your mother made when she was young.'),
    _note('Jiùxìn dàizhe liǎng gè shídài de shēngyīn shǐxiàng hǎimiàn.', 'Lá thư cũ mang âm thanh hai thời đại ra biển.', 'The old letter carries the voices of two eras out to sea.'),
  ],
  words: [
    _word('潮声', 'cháoshēng', '名词', '潮水运动产生的声音。', 'Tiếng thủy triều.', 'sound of the tide', '🌊'),
    _word('渡口', 'dùkǒu', '名词', '乘船过水的地点。', 'Bến đò.', 'ferry crossing', '⛴️'),
    _word('中断', 'zhōngduàn', '动词', '进行中的事情突然停止。', 'Bị gián đoạn.', 'to be interrupted', '📻'),
    _word('哼唱', 'hēngchàng', '动词', '小声唱出曲调。', 'Ngâm nga.', 'to hum a tune', '🎵'),
    _word('离愁', 'líchóu', '名词', '离别产生的忧愁。', 'Nỗi buồn ly biệt.', 'sorrow of parting', '🌙'),
    _word('录下', 'lùxià', '动词', '把声音保存下来。', 'Ghi âm lại.', 'to record', '🎙️'),
  ],
  discoveries: [
    _discovery('宋词常用月、雁、江水、风雨等景物承载离别与时间感。', 'Sòngcí cháng yòng yuè, jiāngshuǐ hé fēngyǔ chéngzài líbié.', '景物可以表达人的感情。', 'Từ đời Tống thường gửi nỗi ly biệt vào trăng, nước và mưa gió.', 'Song ci often lets moonlight, water, wind, and rain carry emotion and time.'),
    _discovery('现代本土文学会把方言声音、迁移经历和家庭物件写进具体社区。', 'Xiàndài běntǔ wénxué huì bǎ fāngyán hé jiātíng wùjiàn xiějìn shèqū.', '本土故事重视地方声音和生活细节。', 'Văn học bản địa hiện đại ghi lại giọng nói, di cư và đồ vật gia đình.', 'Modern local literature anchors migration and memory in voices, objects, and neighborhoods.'),
    _discovery('《潮声旧信》为 Phoenix 原创，不引用任何现代歌曲歌词或小说情节。', '“Cháoshēng jiùxìn” wéi Phoenix yuánchuàng.', '故事没有使用受版权保护的歌词或情节。', 'Truyện không sử dụng ca từ hay cốt truyện có bản quyền.', 'The story is original and contains no borrowed modern lyrics or plots.'),
  ],
  wonderQuestion: '一句没有说完的话，应该由后来的人补完吗？',
  expressQuestion: '请写一段三句短文，让“潮水”同时表示真实景物和一种感情。',
);

const _arcadeStory = <String>[
  '岭南雨季，一把红伞被送进骑楼下的失物局。伞面全湿，地上却没有水迹；登记册里还夹着一枚三十年前的茶楼铜牌。',
  '你按公案笔记的方法查问街坊：修表师记得伞，茶客记得铜牌，只有伞的主人像从所有人的记忆里被擦掉。',
  '暴雨冲洗花砖时，伞的影子指向一扇封闭多年的院门。门后没有罪案，只有一屋无人认领的生活物件和迟到的道歉。',
  '你把物件逐一归还，却把红伞留在失物局门口。第二天阳光穿过骑楼，伞下第一次出现了一小片正常的影子。',
];

final _arcadeRecord = _record(
  'arcade-lost-property',
  '公案新编 · 骑楼失物局',
  'phoenix-realms-arcade-lost-property',
  _arcadeStory,
);

final _arcadeExperience = DailyJourneyExperience(
  id: _arcadeRecord.id,
  city: '雨骑楼',
  cityCode: 'ALP',
  place: '花砖失物局',
  appBarTitle: '公案新编 · 骑楼失物局',
  storyTitle: '没有水迹的红伞',
  headline: '调查一件被整条街遗忘的失物',
  description: '把古代公案的查问与笔记结构，放进当代岭南社区的人情悬疑。',
  discoveryTeaser: '公案故事除了抓凶手，还能怎样理解人情与秩序？',
  distanceLabel: '一街雨影',
  stampSymbol: '案',
  content: _arcadeRecord,
  storyAnnotations: [
    _note('Lǐngnán yǔjì, yì bǎ hóngsǎn bèi sòngjìn qílóu xià de shīwùjú.', 'Mùa mưa Lĩnh Nam, một chiếc ô đỏ được đưa tới phòng đồ thất lạc dưới kỵ lâu.', 'In the Lingnan rains, a red umbrella arrives at an arcade lost-property office.'),
    _note('Nǐ àn gōng’àn bǐjì de fāngfǎ cháwèn jiēfāng.', 'Bạn hỏi dân phố theo cách ghi án cổ.', 'You question the neighborhood in the manner of an old case record.'),
    _note('Mén hòu zhǐyǒu yì wū wúrén rènlǐng de shēnghuó wùjiàn.', 'Sau cửa chỉ là căn phòng đầy đồ vật không người nhận.', 'Behind the door is a room of unclaimed everyday objects.'),
    _note('Yángguāng chuānguò qílóu, sǎnxià chūxiàn zhèngcháng de yǐngzi.', 'Nắng xuyên qua kỵ lâu và chiếc ô có bóng bình thường.', 'Sunlight crosses the arcade and the umbrella finally casts a normal shadow.'),
  ],
  words: [
    _word('失物', 'shīwù', '名词', '丢失的东西。', 'Đồ thất lạc.', 'lost property', '🧳'),
    _word('骑楼', 'qílóu', '名词', '楼下留有连续公共走廊的建筑。', 'Nhà kỵ lâu có hành lang.', 'arcade building', '🏘️'),
    _word('查问', 'cháwèn', '动词', '调查并询问。', 'Điều tra và hỏi.', 'to investigate by questioning', '🔎'),
    _word('认领', 'rènlǐng', '动词', '确认并取回属于自己的东西。', 'Nhận lại đồ của mình.', 'to claim an item', '✋'),
    _word('水迹', 'shuǐjì', '名词', '水留下的痕迹。', 'Vết nước.', 'water mark or trace', '💧'),
    _word('归还', 'guīhuán', '动词', '把东西送回原主。', 'Trả lại chủ cũ.', 'to return to its owner', '↩️'),
  ],
  discoveries: [
    _discovery('公案小说以案件和判断组织故事，也常讨论伦理、权力和社会秩序。', 'Gōng’àn xiǎoshuō yǐ ànjiàn hé pànduàn zǔzhī gùshì.', '公案不只是破案，也写社会关系。', 'Truyện công án không chỉ phá án mà còn bàn về đạo lý và trật tự.', 'Gong’an fiction uses cases and judgments to examine ethics, authority, and social order.'),
    _discovery('岭南骑楼适应炎热多雨气候，也形成连续的商业与社区公共空间。', 'Lǐngnán qílóu shìyì yánrè duōyǔ qìhòu.', '骑楼既遮阳避雨，也是社区空间。', 'Kỵ lâu thích ứng khí hậu nóng mưa và tạo không gian cộng đồng.', 'Lingnan arcades answer a hot rainy climate while supporting commerce and community life.'),
    _discovery('本故事关注修复关系而非猎奇犯罪，人物、案件与失物均为 Phoenix 原创。', 'Běn gùshì guānzhù xiūfù guānxì, rénwù hé ànjiàn jūn wéi yuánchuàng.', '悬疑最后回到社区关系。', 'Câu chuyện tập trung hàn gắn quan hệ; mọi nhân vật và vụ việc đều nguyên tác.', 'The mystery centers on repairing relationships; all characters and events are original.'),
  ],
  wonderQuestion: '如果归还物品会重新打开一段痛苦记忆，你还应该归还吗？',
  expressQuestion: '请像记录公案一样，用“线索—推测—判断”写三句话。',
);

const _teaHorseStory = <String>[
  '你带着录音机走上茶马古道，准备收集沿途村落的声音。第一段录音里只有风；回放时，却多出一队看不见的马帮和清脆铃声。',
  '雨落进旧茶仓，马鞍、茶饼和石阶依次发出回声。老人说，道路记住的不是英雄姓名，而是无数普通人的脚步与交换。',
  '山体滑坡封住前路，录音里的马铃却引你找到一条正在修复的支线。村民种下护坡植物，也把旧路故事录入共同档案。',
  '日出时，你没有带走最后一段录音，而把它留给村里的孩子。古道重新安静，远处的回声像未来正在练习怎样回答过去。',
];

final _teaHorseRecord = _record(
  'tea-horse-echo',
  '山川笔记 · 茶马回声档案',
  'phoenix-realms-tea-horse-echo',
  _teaHorseStory,
);

final _teaHorseExperience = DailyJourneyExperience(
  id: _teaHorseRecord.id,
  city: '云岭',
  cityCode: 'THE',
  place: '回声古道',
  appBarTitle: '山川笔记 · 茶马回声档案',
  storyTitle: '录音里多出一队马帮',
  headline: '用古代游记眼光记录正在变化的地方',
  description: '结合笔记游记、云南口述史与生态文学，保存道路和普通人的声音。',
  discoveryTeaser: '记录一条古道时，风景、劳动与生态应怎样同时出现？',
  distanceLabel: '一岭回声',
  stampSymbol: '驿',
  content: _teaHorseRecord,
  storyAnnotations: [
    _note('Nǐ dàizhe lùyīnjī zǒushàng Chámǎ Gǔdào, shōují yántú shēngyīn.', 'Bạn mang máy ghi âm lên Trà Mã Cổ Đạo để thu âm thanh dọc đường.', 'You carry a recorder onto the Tea Horse Road to collect its sounds.'),
    _note('Dàolù jìzhù de shì wúshù pǔtōngrén de jiǎobù yǔ jiāohuàn.', 'Con đường nhớ bước chân và trao đổi của vô số người bình thường.', 'The road remembers the footsteps and exchanges of ordinary people.'),
    _note('Cūnmín zhòngxià hùpō zhíwù, yě bǎ jiùlù gùshì lùrù dàng’àn.', 'Dân làng trồng cây giữ dốc và ghi chuyện đường cũ vào hồ sơ chung.', 'Villagers stabilize the slope and record the old road’s stories.'),
    _note('Yuǎnchù de huíshēng xiàng wèilái zài liànxí huídá guòqù.', 'Tiếng vọng xa như tương lai tập trả lời quá khứ.', 'The distant echo sounds like the future practicing an answer to the past.'),
  ],
  words: [
    _word('古道', 'gǔdào', '名词', '历史上长期使用的道路。', 'Đường cổ.', 'historic route', '🥾'),
    _word('马帮', 'mǎbāng', '名词', '用马运输货物的队伍。', 'Đoàn ngựa thồ.', 'packhorse caravan', '🐎'),
    _word('回放', 'huífàng', '动词', '再次播放录音或影像。', 'Phát lại.', 'to play back', '🎙️'),
    _word('护坡', 'hùpō', '动词／名词', '保护坡面稳定。', 'Bảo vệ sườn dốc.', 'slope stabilization', '🌱'),
    _word('口述史', 'kǒushùshǐ', '名词', '通过访谈保存个人经历的历史记录。', 'Lịch sử truyền miệng.', 'oral history', '🗣️'),
    _word('档案', 'dàng’àn', '名词', '系统保存的记录材料。', 'Hồ sơ lưu trữ.', 'archive', '🗂️'),
  ],
  discoveries: [
    _discovery('古代游记与地理笔记常把路线、物产、风俗和个人感受写在一起。', 'Gǔdài yóujì cháng bǎ lùxiàn, wùchǎn hé gǎnshòu xiězài yìqǐ.', '游记不只有风景，也记录地方生活。', 'Du ký cổ ghi cả tuyến đường, sản vật, phong tục và cảm nhận.', 'Classical travel writing combines routes, local products, customs, and personal response.'),
    _discovery('现代生态文学关注景观背后的劳动、环境变化与地方知识。', 'Xiàndài shēngtài wénxué guānzhù láodòng, huánjìng biànhuà hé dìfāng zhīshi.', '生态文学把人和环境放在同一故事里。', 'Văn học sinh thái hiện đại đặt lao động, biến đổi môi trường và tri thức địa phương cùng nhau.', 'Modern eco-literature connects landscape with labor, environmental change, and local knowledge.'),
    _discovery('故事借用茶马古道这一历史文化背景，所有录音与人物情节均为原创。', 'Gùshì jièyòng Chámǎ Gǔdào bèijǐng, suǒyǒu qíngjié jūn wéi yuánchuàng.', '真实背景与原创幻想已经清楚区分。', 'Bối cảnh lịch sử là thật; mọi bản ghi và nhân vật đều hư cấu nguyên tác.', 'The historic setting is real, while every recording, character, and event is original.'),
  ],
  wonderQuestion: '当一条路仍被当地人使用时，它应该首先成为景点还是生活空间？',
  expressQuestion: '请用“我听见……也看见……”记录一段包含人与环境的旅途。',
);

const _iceCityStory = <String>[
  '冰城旧厂停产后的第十二个冬天，你在工人更衣柜里发现一张星图。图上没有星名，只有管道、车床和夜班路线组成的坐标。',
  '你启动最后一台模拟控制台，厂房天窗依次亮起。高处管线与真实星空重合，像一部以机器为山河的现代赋。',
  '暴雪进入破窗，星图却指向父辈用过的保温杯和手套。你终于明白，所谓坐标不是宝藏，而是每个普通岗位曾经发光的位置。',
  '春天到来前，旧厂被改成社区档案馆。孩子们在涡轮大厅仰望星图，新的章节从“话说当年”之后慢慢展开。',
];

final _iceCityRecord = _record(
  'ice-city-star-map',
  '章回新声 · 冰城旧厂星图',
  'phoenix-realms-ice-city-star-map',
  _iceCityStory,
);

final _iceCityExperience = DailyJourneyExperience(
  id: _iceCityRecord.id,
  city: '冰城',
  cityCode: 'ICM',
  place: '星图旧厂',
  appBarTitle: '章回新声 · 冰城旧厂星图',
  storyTitle: '机器组成的星座',
  headline: '在旧工业空间里打开下一回未来',
  description: '用章回体推进、赋体铺陈与东北工业文学记住普通劳动者。',
  discoveryTeaser: '工业遗产怎样从生产空间变成共同记忆？',
  distanceLabel: '一厂星光',
  stampSymbol: '星',
  content: _iceCityRecord,
  storyAnnotations: [
    _note('Nǐ zài gōngrén gēngyīguì lǐ fāxiàn yì zhāng xīngtú.', 'Bạn tìm thấy bản đồ sao trong tủ thay đồ công nhân.', 'You find a star map in a worker’s locker.'),
    _note('Guǎndào yǔ zhēnshí xīngkōng chónghé, xiàng yí bù yǐ jīqì wéi shānhé de fù.', 'Đường ống trùng bầu sao như bài phú lấy máy móc làm sơn hà.', 'The pipes align with the stars like a fu rhapsody made of machines.'),
    _note('Zuòbiāo shì měi gè pǔtōng gǎngwèi céngjīng fāguāng de wèizhì.', 'Tọa độ là nơi từng vị trí bình thường đã tỏa sáng.', 'The coordinates mark where ordinary jobs once shone.'),
    _note('Xīn de zhāngjié cóng “huàshuō dāngnián” zhīhòu mànmàn zhǎnkāi.', 'Chương mới mở ra sau câu “chuyện kể năm xưa”.', 'A new chapter opens after the words “the story goes, long ago.”'),
  ],
  words: [
    _word('旧厂', 'jiùchǎng', '名词', '停止或改变生产用途的老工厂。', 'Nhà máy cũ.', 'former factory', '🏭'),
    _word('星图', 'xīngtú', '名词', '表示星星位置的图。', 'Bản đồ sao.', 'star map', '✨'),
    _word('车床', 'chēchuáng', '名词', '加工旋转工件的机器。', 'Máy tiện.', 'lathe', '⚙️'),
    _word('夜班', 'yèbān', '名词', '夜间工作的班次。', 'Ca đêm.', 'night shift', '🌙'),
    _word('坐标', 'zuòbiāo', '名词', '表示位置的一组数或参照。', 'Tọa độ.', 'coordinates', '📍'),
    _word('档案馆', 'dàng’ànguǎn', '名词', '保存和提供档案的机构。', 'Kho lưu trữ.', 'archive center', '🏛️'),
  ],
  discoveries: [
    _discovery('章回体用回目、悬念和“下回分解”组织连续故事，强调推进与期待。', 'Zhānghuítǐ yòng huímù hé xuánniàn zǔzhī liánxù gùshì.', '章回体让读者期待下一回。', 'Tiểu thuyết chương hồi dùng hồi mục và nút thắt để dẫn tới phần sau.', 'Zhanghui fiction structures serial narrative through chapters, suspense, and anticipation.'),
    _discovery('赋体擅长铺陈事物的形态、声音与空间，本故事把这种方法转向工业设备。', 'Fùtǐ shàncháng pūchén shìwù de xíngtài, shēngyīn yǔ kōngjiān.', '赋可以细致铺写一个空间。', 'Thể phú giỏi phô bày hình dạng, âm thanh và không gian; ở đây nó hướng vào máy móc.', 'Fu rhapsody excels at cataloguing form, sound, and space; here that method turns toward machinery.'),
    _discovery('东北工业题材常关注集体劳动、家庭记忆、城市转型与人的尊严。', 'Dōngběi gōngyè tícái guānzhù láodòng, jiātíng jìyì hé chéngshì zhuǎnxíng.', '工业文学也在记录普通人的生活。', 'Văn học công nghiệp Đông Bắc quan tâm lao động, ký ức gia đình và chuyển đổi đô thị.', 'Northeast industrial literature often explores collective labor, family memory, urban transition, and dignity.'),
  ],
  wonderQuestion: '一座工厂停止生产以后，什么仍值得被保存？',
  expressQuestion: '请用章回体口吻写一个两句结尾，并留下下一回的悬念。',
);

final specialJourneyExpansionBatchOneRecords = <JourneyContentRecord>[
  _changanRecord,
  _tideRecord,
  _arcadeRecord,
  _teaHorseRecord,
  _iceCityRecord,
];

final specialJourneyExpansionBatchOneExperiences = <DailyJourneyExperience>[
  _changanExperience,
  _tideExperience,
  _arcadeExperience,
  _teaHorseExperience,
  _iceCityExperience,
];
