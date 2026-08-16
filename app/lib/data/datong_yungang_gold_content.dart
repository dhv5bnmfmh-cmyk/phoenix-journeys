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
  _Segment('石粉落在三个人的鞋面上。谁先弹线、谁校正偏差，他们第一次必须当面商量，而不是抬头等父亲开口。', 'Bụi đá rơi trên giày của cả ba. Lần đầu họ phải bàn ai bật dây trước và ai sửa sai lệch.', 'Stone dust settles on all three pairs of shoes. For the first time they must decide who snaps first and who corrects a deviation.', from: 8),
  _Segment('魏岚把“留下”从一句挽留改成一份责任：弟弟若把线弹歪，不能再说那是姐姐或父亲的命令；她自己也失去了替别人收回绳子的权利。', 'Ngụy Lam biến “ở lại” từ lời níu kéo thành trách nhiệm; mỗi người phải nhận sai lệch của mình.', 'Wei Lan turns “staying” from a plea into responsibility; each person must own a deviation.', from: 9),
  _Segment('她看见父亲停步，却没有把沉默误认成同意。三段绳保住的不是一团和气，而是三个人从此都要承认自己的线、自己的偏差和自己的后果。', 'Cô thấy cha dừng bước nhưng không nhầm im lặng với đồng ý. Mỗi người phải nhận đường kẻ và hậu quả của mình.', 'She sees her father stop but does not mistake silence for agreement. Each person must own a line and its consequence.', from: 10),
];

class _Fact {
  const _Fact(this.zh, this.simple, this.vi, this.en);
  final String zh;
  final String simple;
  final String vi;
  final String en;
}

const _commonDiscovery = _Fact('云冈石窟位于今天的大同，主要营造于北魏以平城为都城的五至六世纪。它既是皇室支持的佛教石窟工程，也是观察北魏政治、宗教与艺术交流的重要遗存。', '云冈主要形成于北魏平城时代，是皇室支持的佛教石窟工程。', 'Hang đá Vân Cương ở Đại Đồng ngày nay, chủ yếu được kiến tạo trong thế kỷ V–VI khi Bình Thành là kinh đô Bắc Ngụy. Đây vừa là công trình hang đá Phật giáo được hoàng gia bảo trợ, vừa là di sản quan trọng để quan sát chính trị, tôn giáo và giao lưu nghệ thuật thời Bắc Ngụy.', 'The Yungang Grottoes in present-day Datong were created mainly in the fifth and sixth centuries while Pingcheng was the Northern Wei capital. They were both an imperially supported Buddhist cave project and an important record of Northern Wei politics, religion, and artistic exchange.');

const _levelFacts = <_Fact>[
  _Fact('398年北魏定都平城，也就是今天的大同一带。云冈靠近这个政治中心，后来才有条件集中资源进行大规模开凿。', '北魏定都平城后，云冈靠近国家政治中心。', 'Năm 398, Bắc Ngụy định đô ở Bình Thành, khu vực Đại Đồng ngày nay. Vân Cương ở gần trung tâm chính trị này nên về sau mới có điều kiện tập trung nguồn lực để khai tạc quy mô lớn.', 'In 398 the Northern Wei established its capital at Pingcheng, in the area of present-day Datong. Yungang’s proximity to this political center later made large-scale, resource-intensive carving possible.'),
  _Fact('460年，文成帝支持昙曜主持开凿五所大像窟，今天称为昙曜五窟，即第16至20窟。它们把皇室支持与云冈早期的巨型造像直接联系起来。', '460年开凿的昙曜五窟是云冈早期大型营造的核心。', 'Năm 460, Văn Thành Đế ủng hộ Đàm Diệu chủ trì khai tạc năm hang tượng lớn, ngày nay gọi là Ngũ động Đàm Diệu, tức hang 16 đến 20. Chúng liên kết trực tiếp sự bảo trợ của hoàng gia với tượng khổng lồ thời kỳ đầu Vân Cương.', 'In 460, with Emperor Wencheng’s support, Tanyao directed the carving of five great image caves, now known as the Five Caves of Tanyao, Caves 16 through 20. They directly connect imperial support with Yungang’s early colossal imagery.'),
  _Fact('云冈早期大型开凿不是孤立的宗教活动。文成帝时期，朝廷对佛教的支持转化为由国家资源推动的石窟营造，说明宗教政策会改变开窟的规模与条件。', '文成帝时期的佛教支持推动了云冈早期大型开凿。', 'Việc khai tạc quy mô lớn thời kỳ đầu Vân Cương không phải hoạt động tôn giáo tách biệt. Dưới thời Văn Thành Đế, sự ủng hộ Phật giáo của triều đình được chuyển thành công trình hang đá do nguồn lực nhà nước thúc đẩy, cho thấy chính sách tôn giáo có thể thay đổi quy mô và điều kiện khai tạc.', 'Yungang’s early monumental carving was not an isolated religious activity. Under Emperor Wencheng, court support for Buddhism became a cave-building program backed by state resources, showing how religious policy could change the scale and conditions of carving.'),
  _Fact('按洞窟形制、造像内容和艺术样式，云冈通常分为早、中、晚三个主要阶段：早期以昙曜五窟为代表，中期进入大规模营造高峰，494年迁都洛阳以后转入以中小型窟龛为主的晚期。', '云冈可分早、中、晚三期，494年迁都是重要转折。', 'Theo hình thức hang, nội dung tượng và phong cách nghệ thuật, Vân Cương thường được chia thành ba giai đoạn chính: thời kỳ đầu tiêu biểu là Ngũ động Đàm Diệu, thời kỳ giữa đạt đỉnh kiến tạo quy mô lớn, và sau khi dời đô đến Lạc Dương năm 494 bước vào thời kỳ muộn với các hang và khám cỡ vừa, nhỏ là chủ yếu.', 'By cave form, iconographic content, and artistic style, Yungang is commonly divided into three main phases: an early phase represented by the Five Caves of Tanyao, a middle peak of large-scale construction, and a late phase after the 494 move to Luoyang dominated by smaller caves and niches.'),
  _Fact('云冈中期在孝文帝时期达到营造高峰。洞窟布局与雕饰更加复杂，也出现更多中国宫殿建筑式样和本土化表达，显示佛教石窟艺术正在北魏社会中继续转化。', '中期云冈更复杂，也出现更多中国式建筑与本土化表达。', 'Thời kỳ giữa Vân Cương đạt đỉnh kiến tạo dưới thời Hiếu Văn Đế. Bố cục hang và trang trí trở nên phức tạp hơn, đồng thời xuất hiện nhiều mô thức kiến trúc cung điện Trung Hoa và cách biểu đạt bản địa hóa hơn, cho thấy nghệ thuật hang đá Phật giáo tiếp tục biến đổi trong xã hội Bắc Ngụy.', 'Yungang’s middle phase reached a construction peak under Emperor Xiaowen. Cave layouts and decoration became more complex, with more Chinese palace-architectural forms and localized expression, showing Buddhist cave art continuing to transform within Northern Wei society.'),
  _Fact('494年北魏迁都洛阳后，云冈大规模开凿随之停止，但造像活动没有同时消失。政治中心的移动改变了大型皇家工程的条件，却没有让这处石窟在同一天失去所有营造者。', '494年迁都使大规模开凿停止，但造像活动没有立刻结束。', 'Sau khi Bắc Ngụy dời đô đến Lạc Dương năm 494, việc khai tạc quy mô lớn ở Vân Cương chấm dứt, nhưng hoạt động tạo tượng không biến mất cùng lúc. Sự chuyển dịch trung tâm chính trị làm thay đổi điều kiện của công trình hoàng gia lớn, chứ không khiến nơi này mất toàn bộ người tiếp tục kiến tạo ngay trong một ngày.', 'After the Northern Wei moved its capital to Luoyang in 494, large-scale carving at Yungang ceased, but image-making did not vanish at the same moment. The political shift changed the conditions for major royal projects without instantly ending all carving at the site.'),
  _Fact('迁都以后，贵族、中下层官吏与普通信众继续利用平城留下的技术，在云冈开凿许多中小型洞窟和龛像。赞助者范围的变化，也解释了为什么晚期规模变小而活动仍能延续。', '迁都后，更多社会群体继续开凿中小型窟龛。', 'Sau khi dời đô, quý tộc, quan lại cấp trung và thấp cùng tín đồ bình dân tiếp tục sử dụng kỹ thuật còn lại ở Bình Thành để khai tạc nhiều hang và khám cỡ vừa, nhỏ tại Vân Cương. Sự thay đổi phạm vi người bảo trợ cũng giải thích vì sao quy mô thời kỳ muộn nhỏ đi nhưng hoạt động vẫn tiếp tục.', 'After the capital move, nobles, middle- and lower-ranking officials, and lay believers continued using skills retained at Pingcheng to carve many smaller caves and niches at Yungang. The broadened range of patrons helps explain why late works became smaller while activity continued.'),
  _Fact('云冈艺术并不是把一种外来样式原样搬进中国。它吸收南亚、中亚佛教艺术因素，又与中国文化传统结合，在五世纪形成具有本地特色的石窟艺术语言。', '云冈融合南亚、中亚佛教艺术与中国文化传统。', 'Nghệ thuật Vân Cương không đơn thuần sao chép một phong cách ngoại lai. Nó tiếp nhận các yếu tố nghệ thuật Phật giáo từ Nam Á và Trung Á rồi kết hợp với truyền thống văn hóa Trung Hoa, hình thành ngôn ngữ nghệ thuật hang đá mang đặc sắc địa phương trong thế kỷ V.', 'Yungang art did not simply copy a foreign style. It absorbed Buddhist artistic elements from South and Central Asia and combined them with Chinese cultural traditions, forming a distinctive local cave-art language in the fifth century.'),
  _Fact('把云冈的早、中、晚三期放在一起看，可以看到政治、赞助者和艺术语言同步变化：从皇室支持的巨像，到更复杂的中期洞窟，再到迁都后的中小窟龛，石窟群本身就是一条历史时间线。', '云冈各期的规模、赞助与艺术变化组成一条历史时间线。', 'Khi đặt ba giai đoạn đầu, giữa và muộn của Vân Cương cạnh nhau, có thể thấy chính trị, người bảo trợ và ngôn ngữ nghệ thuật thay đổi đồng thời: từ tượng khổng lồ được hoàng gia hỗ trợ, đến hang thời giữa phức tạp hơn, rồi các hang và khám nhỏ sau dời đô. Chính quần thể hang đá tạo thành một dòng thời gian lịch sử.', 'Viewed together, Yungang’s early, middle, and late phases show politics, patronage, and artistic language changing in tandem: from imperially backed colossal images, to more complex middle-period caves, to smaller post-capital-move caves and niches. The cave complex itself becomes a historical timeline.'),
  _Fact('云冈的重要性不只在规模。联合国教科文组织认为，它让佛教石窟艺术在中国形成鲜明的自身特征，并对后来中国乃至东亚的佛教石窟艺术产生深远影响，因此也是理解佛教艺术在中国发展与转化的重要节点。', '云冈形成鲜明艺术特征，并深刻影响后来中国和东亚的佛教石窟艺术。', 'Tầm quan trọng của Vân Cương không chỉ nằm ở quy mô. UNESCO cho rằng nơi đây giúp nghệ thuật hang đá Phật giáo hình thành đặc trưng riêng rõ nét tại Trung Quốc và tạo ảnh hưởng sâu rộng đến nghệ thuật hang đá Phật giáo về sau ở Trung Quốc và Đông Á, vì vậy đây là một nút quan trọng để hiểu quá trình phát triển và biến đổi của nghệ thuật Phật giáo tại Trung Quốc.', 'Yungang matters for more than its scale. UNESCO identifies it as a place where Buddhist cave art developed a distinct character in China and exerted far-reaching influence on later Buddhist cave art in China and East Asia, making it a key point for understanding the development and transformation of Buddhist art in China.'),
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
  const WordEntry(word: '小龛', pinyin: 'xiǎokān', partOfSpeech: '名词', simpleChinese: '石壁上安置造像的小空间。', translation: 'khám đá nhỏ', englishDefinition: 'a small stone niche', symbol: '⛰️'),
  const WordEntry(word: '开凿', pinyin: 'kāizáo', partOfSpeech: '动词', simpleChinese: '用工具凿出洞窟或形状。', translation: 'khai tạc', englishDefinition: 'to excavate or carve', symbol: '⛏️'),
  const WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'vách đá', englishDefinition: 'cliff face', symbol: '🏔️'),
  const WordEntry(word: '分期', pinyin: 'fēnqī', partOfSpeech: '名词/动词', simpleChinese: '按时间和特点分成阶段。', translation: 'phân kỳ', englishDefinition: 'periodization', symbol: '🕰️'),
  const WordEntry(word: '营造', pinyin: 'yíngzào', partOfSpeech: '动词', simpleChinese: '规划并建造大型工程。', translation: 'kiến tạo', englishDefinition: 'to plan and construct', symbol: '🏗️'),
];

List<JourneyLevelContent> _buildLevels() => List<JourneyLevelContent>.generate(10, (index) {
  final level = index + 1;
  String renderChinese(Iterable<_Segment> items) => items.map((item) => item.zh).join().replaceFirst(level == 1 ? '虚构石工' : '__never__', '石工').replaceFirst(level == 1 ? '不再像从前那样' : '__never2__', '不再');
  final segments = <_Segment>[..._core, ..._depth.where((item) => level >= item.from)];
  final groups = level <= 2 ? <List<_Segment>>[segments] : <List<_Segment>>[segments.take(4).toList(), segments.skip(4).toList()];
  final paragraphs = groups.map(renderChinese).toList(growable: false);
  final annotations = groups.map((group) {
    final zh = renderChinese(group);
    return ReadingAnnotation(pinyin: PinyinHelper.getPinyinE(zh, separator: ' ', format: PinyinFormat.WITH_TONE_MARK), vietnamese: group.map((item) => item.vi).join(' '), english: group.map((item) => item.en).join(' '));
  }).toList(growable: false);
  final discoveries = <DiscoveryEntry>[_discovery(_commonDiscovery), if (level >= 5) _discovery(_levelFacts[level - 2]), _discovery(_levelFacts[level - 1])];
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
  discoveryTraces: [for (var i = 0; i < 11; i++) RemediatedDiscoveryTrace(discoveryIndex: i, storyEventIds: i == 5 || i == 6 ? const ['DY-E1', 'DY-E5'] : const <String>[], sourceIds: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes', 'neac-datong-yungang-context'])],
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
    RemediatedSourceBinding(id: 'neac-datong-yungang-context', publisher: '国家民族事务委员会', scope: 'Pingcheng capital context, imperial support, Tanyao Five Caves and cultural interaction'),
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
