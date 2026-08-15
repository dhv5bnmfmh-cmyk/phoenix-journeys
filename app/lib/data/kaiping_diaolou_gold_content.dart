import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/story_content.dart';
import 'batch_one_journey_remediation.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const kaipingDiaolouJourneyId = 'jiangmen-kaiping-diaolou';
const kaipingDiaolouCanonicalTitle = '回来，不等于照搬';
const kaipingDiaolouHeadline = '一张从海外寄回的图，要不要原样盖进村里？';
const kaipingDiaolouDescription =
    '人物、家书与具体建楼选择为虚构；碉楼类型、侨乡联系与建筑融合机制依据 UNESCO 与开平官方资料。';
const kaipingDiaolouDiscoveryTeaser =
    '众楼、居楼、更楼为什么不能混成一种“华侨豪宅”？海外经验又怎样在开平被重新组合？';
const kaipingDiaolouGeoNodeId =
    'cn-guangdong-jiangmen-kaiping-diaolou-villages';

const kaipingPrimaryDepthMechanism = 'SOCIAL CAUSALITY';
const kaipingSecondaryDepthMechanisms = <String>[
  'CULTURAL VALUE TENSION',
  'PLACE / SPATIAL CAUSALITY',
];
const kaipingSupportingDepth = 'NARRATIVE SUBTEXT / RESTRAINT';
const kaipingIntentionallyUnusedDepth = <String>[
  'MATERIAL CAUSALITY',
  'INSTITUTIONAL / POWER CAUSALITY',
  'ECOLOGICAL CAUSALITY',
  'INTERGENERATIONAL TRANSMISSION',
  'COLLECTIVE MEMORY',
  'AMBIGUITY / UNCERTAINTY',
  'ABSENCE / LOSS',
];
const kaipingStorySignature =
    'SOCIAL CAUSALITY × BROTHERLY RECOGNITION × KAIPING COMMUNAL-TOWER FUNCTION + TRANSNATIONAL ARCHITECTURAL FUSION';

const kaipingDiaolouSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-kaiping-diaolou-villages',
    title: 'Kaiping Diaolou and Villages',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1112/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: [kaipingDiaolouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'kaiping-government-diaolou-types',
    title: '开平碉楼按功能可分为哪几种形式？',
    publisher: '开平市人民政府',
    url:
        'https://www.kaiping.gov.cn/kpszfw/zmhd/cjwy/lywh/content/post_3492765.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [kaipingDiaolouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'kaiping-government-zili-village',
    title: '塘口镇 · 自力村碉楼群',
    publisher: '开平市人民政府',
    url:
        'https://www.kaiping.gov.cn/tkzrmzf/tkgk/dlly/content/post_553104.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [kaipingDiaolouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'jiangmen-government-kaiping-heritage',
    title: '18年前，中国首个华侨文化世界遗产诞生！',
    publisher: '江门市文化广电旅游体育局',
    url:
        'https://www.jiangmen.gov.cn/jmwgj/gkmlpt/content/3/3323/post_3323136.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [kaipingDiaolouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
];

const kaipingStoryArchitectures = <Map<String, String>>[
  {
    'ID': 'A-return-is-not-copying',
    'STORY_FAMILY': 'HISTORICAL HUMAN STORY / PLACE NETWORK STORY',
    'SUBJECT': 'FAMILY CHOICE × COMMUNAL BUILDING',
    'TIME_LAYER': '1920s FICTION INSIDE VERIFIED KAIPING BUILDING BOOM',
    'HUMAN_LENS': 'FICTIONAL BROTHERS ACROSS HOME VILLAGE AND OVERSEAS',
    'HISTORICAL_SCALE': 'ONE FICTIONAL FAMILY CHOICE, NO REAL BUILDING BIOGRAPHY',
    'TRUTH_MODE': 'FICTIONAL CHARACTERS + VERIFIED CULTURAL MECHANISMS',
    'PROTAGONIST': '梁川，虚构留乡青年',
    'REAL_OR_FICTIONAL': 'FICTIONAL',
    'RELATIONSHIP': '留乡弟弟梁川 ↔ 海外哥哥梁海',
    'HUMAN_NEED': '尊重哥哥的远方经历，同时保有对家乡实际需要的判断',
    'GOAL': '决定家里如何参与一次建楼选择',
    'CONFLICT': '私家独建方案与多户合建众楼的共同使用关系冲突',
    'CHOICE': '放弃独建，把投入转向合建众楼，并只选择性保留外来形式',
    'COST': '失去只属于自家的建楼方案，也承担哥哥可能把改图理解为否定的关系成本',
    'CLIMAX': '梁川收起原图，请工匠把方案改成共同使用的众楼',
    'CONSEQUENCE': '合建继续；梁海改写自己对这座楼的称呼，并接受退回独建款的承诺',
    'TRANSFORMATION': '兄弟从“带回来就该照着做”转向共同判断远方经验如何进入村落需要',
    'ENDING': '原图与两封回信留在箱底，改过的称呼已经褪色',
    'PLACE_CAUSALITY': 'Kaiping communal/private/watch-tower distinction + transnational architectural fusion',
    'CULTURAL_MECHANISM': '海外联系进入地方建造，但功能由村落社会关系重新组织',
    'PRIMARY_DEPTH': 'SOCIAL CAUSALITY',
    'SECONDARY_DEPTH': 'CULTURAL VALUE TENSION + PLACE / SPATIAL CAUSALITY',
    'FACT_DEPENDENCIES': 'UNESCO OUV + official Kaiping functional-type record + official Zili construction context',
    'HISTORICAL_RISK': 'LOW-MEDIUM: all people, letter, sketch and family decision are explicitly fictional; no real building is claimed',
    'STORY_SIGNATURE': kaipingStorySignature,
    'NARRATIVE_ENGINE': 'a transnational design returns home and is changed by the social function of a communal tower',
    'SELECTED': 'YES',
  },
  {
    'ID': 'B-four-components-one-property',
    'STORY_FAMILY': 'CONTEMPORARY PLACE THROUGH TIME STORY',
    'SUBJECT': 'SERIAL HERITAGE PROPERTY',
    'TIME_LAYER': 'PRESENT',
    'HUMAN_LENS': 'TWO FICTIONAL VISITORS',
    'HISTORICAL_SCALE': 'FOUR WORLD HERITAGE COMPONENTS',
    'TRUTH_MODE': 'CONTEMPORARY FICTION + VERIFIED PROPERTY GEOGRAPHY',
    'PROTAGONIST': '虚构本地青年',
    'REAL_OR_FICTIONAL': 'FICTIONAL',
    'RELATIONSHIP': '本地朋友 ↔ 外地朋友',
    'HUMAN_NEED': '不把一个世界遗产误缩成一栋最上镜的楼',
    'GOAL': '在有限时间里理解四个遗产片区为何属于同一遗产',
    'CONFLICT': '拍摄单栋名楼的效率与理解村落/田野关系冲突',
    'CHOICE': '放弃只追一栋楼的路线',
    'COST': '失去最直接的打卡画面',
    'CLIMAX': '把路线从单楼改为村落关系',
    'CONSEQUENCE': '理解 serial property',
    'TRANSFORMATION': '从 landmark thinking 转向 landscape thinking',
    'ENDING': '地图留下四个组成部分',
    'PLACE_CAUSALITY': 'serial UNESCO property',
    'CULTURAL_MECHANISM': 'tower + village + farmland relationship',
    'PRIMARY_DEPTH': 'PLACE / SPATIAL CAUSALITY',
    'SECONDARY_DEPTH': 'TEMPORAL TRACE',
    'FACT_DEPENDENCIES': 'UNESCO serial property map',
    'HISTORICAL_RISK': 'LOW',
    'STORY_SIGNATURE': 'SPATIAL CAUSALITY × FRIENDSHIP × FOUR-COMPONENT SERIAL PROPERTY',
    'NARRATIVE_ENGINE': 'route expansion',
    'SELECTED': 'NO',
  },
  {
    'ID': 'C-tianlu-29-households',
    'STORY_FAMILY': 'OBJECT / BUILDING LIFE STORY',
    'SUBJECT': 'TIANLU LOU',
    'TIME_LAYER': '1925 → LATER FLOOD USE → PRESENT',
    'HUMAN_LENS': 'COMMUNAL BUILDING USERS',
    'HISTORICAL_SCALE': 'ONE DOCUMENTED COMMUNAL TOWER',
    'TRUTH_MODE': 'VERIFIED BUILDING HISTORY',
    'PROTAGONIST': '天禄楼与使用它的群体',
    'REAL_OR_FICTIONAL': 'OBJECT BIOGRAPHY',
    'RELATIONSHIP': '29户共同建造与使用关系',
    'HUMAN_NEED': '共同安全',
    'GOAL': '追踪一座众楼为何能跨时期改变用途',
    'CONFLICT': '单栋建筑的固定标签与实际多时段使用冲突',
    'CHOICE': '以建筑生命史而非个人传奇组织叙事',
    'COST': '人类主角与决定性选择较弱',
    'CLIMAX': '后期洪水中再次作为避难空间',
    'CONSEQUENCE': '显出功能延续与变化',
    'TRANSFORMATION': 'object meaning changes over time',
    'ENDING': 'present heritage interpretation',
    'PLACE_CAUSALITY': 'documented communal tower room structure and refuge use',
    'CULTURAL_MECHANISM': 'multi-household collective building',
    'PRIMARY_DEPTH': 'TEMPORAL TRACE',
    'SECONDARY_DEPTH': 'SOCIAL CAUSALITY',
    'FACT_DEPENDENCIES': 'official Majianglong/Tianlu Lou record',
    'HISTORICAL_RISK': 'MEDIUM: strong building facts but weaker human Choice without adding biography',
    'STORY_SIGNATURE': 'TEMPORAL TRACE × COLLECTIVE SAFETY × TIANLU COMMUNAL TOWER',
    'NARRATIVE_ENGINE': 'building function across time',
    'SELECTED': 'NO',
  },
];

const kaipingClaimLedger = <Map<String, String>>[
  {
    'CLAIM_ID': 'KP-C1-property',
    'CLAIM': '开平碉楼与村落是由四个组成部分构成的系列世界遗产。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/maps/',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Discovery / future-story boundary',
    'INTERPRETATION_BOUNDARY': '不把一个村、一座楼的细节扩大成整个遗产地。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C2-types',
    'CLAIM': '碉楼按功能可分为众楼、居楼和更楼；众楼由多户合建作临时避难，居楼为个人家庭的设防住宅，更楼用于守望预警。',
    'TRUTH_STATUS': 'VERIFIED CULTURAL PRACTICE',
    'SOURCE': 'UNESCO + 开平市人民政府',
    'SOURCE_TYPE': 'UNESCO + GOVERNMENT',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/ ; https://www.kaiping.gov.cn/kpszfw/zmhd/cjwy/lywh/content/post_3492765.html',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Story causal mechanism + Discovery',
    'INTERPRETATION_BOUNDARY': '不把任一功能说成所有碉楼的唯一功能。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C3-diaspora',
    'CLAIM': '十九世纪末至二十世纪初的海外开平人与故乡保持重要联系，碉楼反映了这种跨国联系。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Story historical world + Discovery',
    'INTERPRETATION_BOUNDARY': '虚构哥哥不绑定真实国家、职业、收入或真实家族。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C4-fusion',
    'CLAIM': '开平碉楼把中国与西方的结构和装饰形式进行复杂融合，而非单一建筑样式。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Story choice + Discovery',
    'INTERPRETATION_BOUNDARY': '不说所有楼都复制同一国家或同一风格。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C5-building-elements',
    'CLAIM': '官方开平资料记录灰塑、壁画、柱廊、拱券、山花等多种建筑元素，许多碉楼由民间工匠建造。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': '开平市文化广电旅游体育局',
    'SOURCE_TYPE': 'GOVERNMENT',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://www.kaiping.gov.cn/kpswhgdlytyj/whzl/whycbh/content/post_654202.html',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Story fictional sketch vocabulary + Discovery',
    'INTERPRETATION_BOUNDARY': '不把拱券、柱廊写成每座碉楼都有的标准配置。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C6-defence',
    'CLAIM': '开平地方建造防御性塔楼的传统可追溯至明代并与当地匪患有关，晚期碉楼是这一传统的集中发展。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Discovery; Story only uses temporary-refuge function',
    'INTERPRETATION_BOUNDARY': '不虚构某次具体匪袭，也不把防匪说成每座楼唯一目的。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C7-peak',
    'CLAIM': '开平碉楼在二十世纪二三十年代进入建设高峰。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': '开平市人民政府',
    'SOURCE_TYPE': 'GOVERNMENT',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://www.kaiping.gov.cn/kpszfw/xwdt/zjdt/content/post_3341893.html',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Story time frame',
    'INTERPRETATION_BOUNDARY': '不把虚构家庭选择连接到任何真实建筑年份。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'KP-C8-landscape',
    'CLAIM': '世界遗产价值包括碉楼、周边村屋与农业景观之间的整体关系。',
    'TRUTH_STATUS': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'https://whc.unesco.org/en/list/1112/',
    'SOURCE_CONFIDENCE': 'HIGH',
    'STORY_USE': 'Lv8 depth + Discovery',
    'INTERPRETATION_BOUNDARY': '不把景观整体性写成每一栋楼都有相同视野或布局。',
    'RESULT': 'PASS',
  },
];

const kaipingFuturePlaceStoryOpportunities = <String>[
  '天禄楼 29 户众楼的 OBJECT / BUILDING LIFE STORY',
  '四个世界遗产组成部分之间的 PLACE THROUGH TIME STORY',
  '自力村具体居楼的经核实家庭建筑史',
  '当代村落生活、农业景观与遗产管理之间的连续与变化',
];

class _KaipingStorySegment {
  const _KaipingStorySegment({
    required this.fromLevel,
    required this.paragraph,
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final int fromLevel;
  final int paragraph;
  final String chinese;
  final String vietnamese;
  final String english;
}

const _kaipingStorySegments = <_KaipingStorySegment>[
  _KaipingStorySegment(
    fromLevel: 1,
    paragraph: 0,
    chinese: '20世纪20年代，开平。虚构青年梁川留在家乡，哥哥梁海在海外谋生，寄回带拱券和柱廊的建筑图样。他在信里说，这份投入只用于家里的独楼；若要改作别用，就寄还给他。',
    vietnamese: 'Vào thập niên 1920 ở Khai Bình, chàng trai hư cấu Lương Xuyên ở lại quê nhà, còn anh trai Lương Hải mưu sinh ở nước ngoài. Người anh gửi về một bản vẽ có vòm cuốn và hàng cột. Trong thư, anh nói phần đóng góp ấy chỉ dành cho tòa nhà riêng của gia đình; nếu dùng vào việc khác thì hãy gửi trả.',
    english: 'In 1920s Kaiping, the fictional young man Liang Chuan stays in his home village while his older brother Liang Hai works overseas. His brother sends a building sketch with arches and colonnades. The letter says his contribution is only for the family’s private tower; if it is used otherwise, it should be returned.',
  ),
  _KaipingStorySegment(
    fromLevel: 2,
    paragraph: 0,
    chinese: '哥哥把图样看作多年海外生活留下的东西。梁川明白，改图也可能让哥哥觉得自己的经历被否定。',
    vietnamese: 'Người anh xem bản vẽ như dấu vết của nhiều năm sống ở nước ngoài. Lương Xuyên hiểu rằng sửa bản vẽ có thể khiến anh mình cảm thấy trải nghiệm ấy bị phủ nhận.',
    english: 'His brother treats the sketch as something carried out of years abroad. Liang Chuan understands that changing it might feel like rejecting his brother’s experience.',
  ),
  _KaipingStorySegment(
    fromLevel: 1,
    paragraph: 0,
    chinese: '村里几户人家正合建一座众楼，遇到危险时可临时避难。梁川原想守住哥哥的私家方案，却发现合建还缺一份投入。',
    vietnamese: 'Vài hộ trong làng đang cùng xây một chúng lâu để tạm lánh khi gặp nguy hiểm. Lương Xuyên vốn muốn giữ phương án riêng của anh trai, nhưng nhận ra công trình chung vẫn thiếu một phần đóng góp.',
    english: 'Several households in the village are jointly building a communal tower for temporary refuge in danger. Liang Chuan wants to preserve his brother’s private plan, but the shared project is still short one contribution.',
  ),
  _KaipingStorySegment(
    fromLevel: 3,
    paragraph: 0,
    chinese: '他第一次认真分清众楼、居楼和更楼：共同避难、兼顾居住、联防预警，并不是同一种用途。',
    vietnamese: 'Lần đầu, anh nghiêm túc phân biệt chúng lâu, cư lâu và canh lâu: nơi trú ẩn chung, nhà ở có phòng thủ và tháp canh cảnh giới không phải cùng một chức năng.',
    english: 'For the first time, he clearly distinguishes communal towers, fortified residential towers, and watch towers: shared refuge, residence with defence, and collective warning are not the same function.',
  ),
  _KaipingStorySegment(
    fromLevel: 4,
    paragraph: 0,
    chinese: '他也明白，开平碉楼的外来元素并非整套建筑照搬回来，而是在本地传统、生活需要和新审美之间重新组合。',
    vietnamese: 'Anh cũng hiểu rằng những yếu tố từ bên ngoài trong điêu lâu Khai Bình không phải là cả tòa nhà được sao chép nguyên xi về, mà được kết hợp lại giữa truyền thống địa phương, nhu cầu sống và thẩm mỹ mới.',
    english: 'He also understands that Kaiping’s imported architectural elements were not entire buildings copied home unchanged, but were recombined with local traditions, practical needs, and new tastes.',
  ),
  _KaipingStorySegment(
    fromLevel: 5,
    paragraph: 0,
    chinese: '梁川重读哥哥的信，不再把“从海外带回来的”理解成“不能改的”。兄弟真正难谈的，是远方经验回到村里后还要接受本地需要。',
    vietnamese: 'Lương Xuyên đọc lại lá thư của anh và không còn hiểu “mang từ nước ngoài về” là “không được sửa”. Điều khó nói giữa hai anh em là kinh nghiệm từ phương xa khi về làng vẫn phải thích ứng với nhu cầu địa phương.',
    english: 'Liang Chuan rereads his brother’s letter and stops treating “brought back from overseas” as “must not be changed.” The hard truth between the brothers is that distant experience still has to meet local needs once it returns to the village.',
  ),
  _KaipingStorySegment(
    fromLevel: 1,
    paragraph: 1,
    chinese: '梁川最后把原图折起，对工匠说：“外面的样子可以带回来，里面得让大家一起用。”家里放弃独建；梁川把改过的众楼图和退还投入的承诺一起寄给哥哥。',
    vietnamese: 'Cuối cùng Lương Xuyên gấp bản vẽ lại và nói với người thợ: “Dáng vẻ bên ngoài có thể mang về, nhưng bên trong phải để mọi người cùng dùng.” Gia đình từ bỏ kế hoạch xây riêng; Lương Xuyên gửi cho anh bản vẽ chúng lâu đã sửa cùng lời hứa hoàn lại phần đóng góp.',
    english: 'At last Liang Chuan folds the original sketch and tells the craftsperson, “The outside forms can come home, but the inside has to work for everyone.” The family gives up its private tower; Liang Chuan sends his brother the revised communal-tower plan together with a promise to return the contribution.',
  ),
  _KaipingStorySegment(
    fromLevel: 6,
    paragraph: 1,
    chinese: '家里加入合建，失去的是只为自己安排的独立方案；得到的也不是更豪华的楼，而是与其他家庭共同承担、共同使用的临时避难空间。',
    vietnamese: 'Gia đình tham gia xây chung, mất đi phương án riêng chỉ dành cho mình; thứ họ nhận được cũng không phải một tòa nhà xa hoa hơn, mà là không gian trú ẩn tạm thời cùng các gia đình khác góp sức và sử dụng.',
    english: 'By joining the shared project, the family loses a plan arranged only for itself. What it gains is not a grander tower, but a temporary refuge jointly funded, carried, and used with other households.',
  ),
  _KaipingStorySegment(
    fromLevel: 1,
    paragraph: 1,
    chinese: '回信到了。梁海没有称赞改图，只在“我家的楼”旁划了一道线，改写成“我们家在众楼里的一份”，并让梁川保留一道拱券。众楼继续施工；原图留在箱底。',
    vietnamese: 'Thư hồi âm đến. Lương Hải không khen bản vẽ sửa; anh gạch bên cạnh cụm “tòa nhà của nhà ta”, đổi thành “phần của nhà ta trong chúng lâu”, và nhờ Lương Xuyên giữ lại một vòm cuốn. Chúng lâu tiếp tục được xây; bản vẽ gốc nằm dưới đáy hòm.',
    english: 'The reply arrives. Liang Hai does not praise the revision; beside “our family’s tower,” he draws a line and rewrites it as “our family’s share in the communal tower,” asking Liang Chuan to keep one arch. Construction continues; the original sketch stays at the bottom of the trunk.',
  ),
  _KaipingStorySegment(
    fromLevel: 7,
    paragraph: 1,
    chinese: '梁川把哥哥改过的那行字拿给工匠看。工匠量过众楼共用的空间，只把拱券留在入口，没有让柱廊占掉多户避难的位置。',
    vietnamese: 'Lương Xuyên đưa dòng chữ anh trai đã sửa cho người thợ xem. Sau khi đo không gian dùng chung của chúng lâu, người thợ chỉ giữ vòm cuốn ở lối vào và không để hàng cột chiếm chỗ trú ẩn của nhiều hộ.',
    english: 'Liang Chuan shows the craftsperson the line his brother revised. After measuring the shared space, the craftsperson keeps an arch at the entrance but does not let a colonnade take space needed for several households to shelter.',
  ),
  _KaipingStorySegment(
    fromLevel: 8,
    paragraph: 1,
    chinese: '开工后，梁川沿村路看运料的位置，又和几户人家核对进出路线。图样不再只回答楼顶怎样好看，也要回答这座众楼怎样被共同使用。',
    vietnamese: 'Sau khi khởi công, Lương Xuyên đi dọc đường làng xem chỗ chuyển vật liệu rồi cùng vài hộ kiểm tra lối ra vào. Bản vẽ không còn chỉ trả lời phần mái trông đẹp thế nào mà còn phải trả lời chúng lâu sẽ được dùng chung ra sao.',
    english: 'After work begins, Liang Chuan walks the village paths to check material access and confirms entry routes with several households. The plan must now answer not only how the roof will look, but how the communal tower will be used together.',
  ),
  _KaipingStorySegment(
    fromLevel: 9,
    paragraph: 1,
    chinese: '第一道拱券砌好时，梁川把照片寄给哥哥，背面只写了各户共同使用的位置。梁海下一封信问的不是“像不像原图”，而是哪一层给老人和孩子临时避难。',
    vietnamese: 'Khi vòm cuốn đầu tiên xây xong, Lương Xuyên gửi ảnh cho anh, mặt sau chỉ ghi vị trí các hộ sẽ cùng sử dụng. Trong thư kế tiếp, Lương Hải không hỏi “có giống bản vẽ gốc không” mà hỏi tầng nào dành cho người già và trẻ em trú tạm.',
    english: 'When the first arch is built, Liang Chuan sends his brother a photograph, noting only where the households will share the space. Liang Hai’s next letter does not ask whether it resembles the original; he asks which floor will shelter elders and children.',
  ),
  _KaipingStorySegment(
    fromLevel: 10,
    paragraph: 1,
    chinese: '多年后，梁川仍把原图和两封回信收在一起。纸上的柱廊没有盖成，入口那道拱券却通向多户共同使用的空间；梁海改过的那行字已经褪色。',
    vietnamese: 'Nhiều năm sau, Lương Xuyên vẫn giữ bản vẽ gốc cùng hai lá thư hồi âm. Hàng cột trên giấy không được xây, nhưng vòm cuốn ở lối vào dẫn vào không gian nhiều hộ cùng sử dụng; dòng chữ Lương Hải sửa đã phai màu.',
    english: 'Years later, Liang Chuan still keeps the original sketch with the two replies. The paper colonnade was never built, but the entrance arch leads into space shared by several households; the line Liang Hai revised has faded.',
  ),
];

String _kaipingPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

List<String> _kaipingStoryParagraphs(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final active = _kaipingStorySegments.where((item) => item.fromLevel <= level);
  if (level <= 2) {
    return <String>[active.map((item) => item.chinese).join()];
  }
  return <String>[
    active.where((item) => item.paragraph == 0).map((item) => item.chinese).join(),
    active.where((item) => item.paragraph == 1).map((item) => item.chinese).join(),
  ];
}

List<ReadingAnnotation> _kaipingStoryAnnotations(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final active = _kaipingStorySegments.where((item) => item.fromLevel <= level);
  ReadingAnnotation merge(Iterable<_KaipingStorySegment> items) {
    final list = items.toList(growable: false);
    final chinese = list.map((item) => item.chinese).join();
    return ReadingAnnotation(
      pinyin: _kaipingPinyin(chinese),
      vietnamese: list.map((item) => item.vietnamese).join(' '),
      english: list.map((item) => item.english).join(' '),
    );
  }

  if (level <= 2) return <ReadingAnnotation>[merge(active)];
  return <ReadingAnnotation>[
    merge(active.where((item) => item.paragraph == 0)),
    merge(active.where((item) => item.paragraph == 1)),
  ];
}

DiscoveryEntry _kaipingDiscovery({
  required String chinese,
  required String simple,
  required String vietnamese,
  required String english,
}) =>
    DiscoveryEntry(
      text: chinese,
      pinyin: _kaipingPinyin(chinese),
      simpleChinese: simple,
      vietnamese: vietnamese,
      english: english,
    );

final kaipingDiaolouDiscoveryPool = <DiscoveryEntry>[
  _kaipingDiscovery(
    chinese: '开平碉楼按主要功能可分为众楼、居楼和更楼。众楼由多户共同兴建作临时避难；居楼是设防住宅；更楼主要承担守望和联防预警。',
    simple: '碉楼有不同类型，不能都理解成同一种住宅。',
    vietnamese: 'Theo chức năng chính, điêu lâu Khai Bình gồm chúng lâu, cư lâu và canh lâu. Chúng lâu do nhiều hộ cùng xây để trú ẩn tạm thời; cư lâu là nhà ở có phòng thủ; canh lâu chủ yếu để quan sát và cảnh báo liên phòng.',
    english: 'By primary function, Kaiping diaolou include communal towers, fortified residential towers, and watch towers. Communal towers were jointly built for temporary refuge, residential towers combined dwelling and defence, and watch towers supported lookout and warning.',
  ),
  _kaipingDiscovery(
    chinese: '“开平碉楼与村落”是系列世界遗产，由三门里迎龙楼、自力村与方氏灯楼、马降龙村落群、锦江里村落四个组成部分共同表达遗产价值。',
    simple: '这个世界遗产不是一栋楼，而由四个遗产片区共同组成。',
    vietnamese: '“Điêu lâu và làng cổ Khai Bình” là di sản thế giới dạng chuỗi, gồm bốn thành phần: Nghênh Long Lâu ở Tam Môn Lý, làng Tự Lực cùng Phương Thị Đăng Lâu, cụm làng Mã Giáng Long và làng Cẩm Giang Lý.',
    english: 'Kaiping Diaolou and Villages is a serial World Heritage property composed of four components: Yinglong Lou at Sanmenli, Zili Village and the Fang Clan Watch Tower, the Majianlong Village Cluster, and Jinjiangli Village.',
  ),
  _kaipingDiscovery(
    chinese: 'UNESCO 把开平碉楼的重要价值概括为中国与西方结构、装饰形式的复杂融合；这种融合发生在开平乡村传统与海外文化接触的共同背景中。',
    simple: '碉楼不是简单复制西式建筑，而是把不同建筑文化重新组合。',
    vietnamese: 'UNESCO xem sự hòa trộn phức hợp giữa kết cấu và trang trí Trung Hoa với phương Tây là một giá trị quan trọng của điêu lâu Khai Bình; sự hòa trộn ấy diễn ra giữa truyền thống nông thôn địa phương và tiếp xúc văn hóa hải ngoại.',
    english: 'UNESCO identifies the complex fusion of Chinese and Western structural and decorative forms as a key value of Kaiping diaolou, shaped by both local rural traditions and overseas cultural contact.',
  ),
  _kaipingDiscovery(
    chinese: '十九世纪末至二十世纪初，大量海外开平人与故乡保持联系。世界遗产评价特别强调这种跨国联系及其带回的建筑影响，但并不意味着每个侨户拥有同样的迁移经历。',
    simple: '海外联系影响了开平，但每个侨户的经历并不相同。',
    vietnamese: 'Cuối thế kỷ XIX và đầu thế kỷ XX, nhiều người Khai Bình ở hải ngoại vẫn duy trì liên hệ với quê nhà. Đánh giá di sản nhấn mạnh các liên hệ xuyên quốc gia và ảnh hưởng kiến trúc được mang về, nhưng điều đó không có nghĩa mọi hộ gia đình có liên hệ hải ngoại đều có cùng một lịch sử di cư.',
    english: 'In the late nineteenth and early twentieth centuries, many Kaiping emigrants remained connected to their home area. World Heritage assessments emphasize these transnational links and architectural influences without implying that every overseas-linked household shared the same migration history.',
  ),
  _kaipingDiscovery(
    chinese: '开平地方建造防御性塔楼的传统可追溯到明代并与当地匪患有关。后来的碉楼把防御传统、居住需要和侨乡资源结合起来，但不同类型的碉楼承担的功能并不完全一样。',
    simple: '防御是重要背景，但不是所有碉楼都只有一种功能。',
    vietnamese: 'Truyền thống xây tháp phòng thủ ở Khai Bình có thể truy về thời Minh và gắn với nạn cướp bóc địa phương. Các điêu lâu về sau kết hợp truyền thống phòng thủ, nhu cầu cư trú và nguồn lực kiều hương, nhưng các loại điêu lâu không hoàn toàn có cùng chức năng.',
    english: 'Kaiping’s tradition of defensive towers reaches back to the Ming period and is associated with local banditry. Later diaolou combined defensive tradition, residential needs, and qiaoxiang resources, but different tower types did not all serve the same function.',
  ),
  _kaipingDiscovery(
    chinese: '官方开平资料记录，碉楼可见灰塑、壁画、柱廊、拱券、山花等多种元素，很多建筑由民间工匠完成。外来形式进入乡村后仍要经过本地建造者的选择和组合。',
    simple: '碉楼的建筑元素很多，外来样式进入开平后会被重新组合。',
    vietnamese: 'Tư liệu chính thức Khai Bình ghi nhận nhiều yếu tố như phù điêu vữa, bích họa, hàng cột, vòm cuốn và đầu hồi trang trí; nhiều công trình do thợ dân gian thực hiện. Hình thức từ bên ngoài khi vào làng vẫn được người xây dựng địa phương lựa chọn và kết hợp.',
    english: 'Official Kaiping sources record elements including plaster relief, murals, colonnades, arches, and decorative gables, with many buildings made by local craftspeople. Imported forms still passed through local selection and recombination.',
  ),
  _kaipingDiscovery(
    chinese: '世界遗产价值不仅在碉楼本身，也包括周边民居和农业景观。理解开平碉楼，需要同时看塔楼怎样与村落、田地和道路共同存在。',
    simple: '碉楼要放在民居、村落和田野环境中一起理解。',
    vietnamese: 'Giá trị di sản không chỉ nằm ở bản thân điêu lâu mà còn ở nhà làng và cảnh quan nông nghiệp xung quanh. Hiểu điêu lâu Khai Bình cần nhìn cách tháp, làng, ruộng và đường cùng tồn tại.',
    english: 'The World Heritage value lies not only in the towers but also in surrounding village houses and agricultural landscape. Kaiping diaolou are understood together with villages, fields, and paths.',
  ),
  _kaipingDiscovery(
    chinese: '“开平碉楼与村落”于2007年列入《世界遗产名录》。遗产保护要求保留碉楼、村屋及其环境的真实性和完整性，并通过持续管理保护这些关系。',
    simple: '2007年列入世界遗产后，保护对象包括建筑和周边环境。',
    vietnamese: '“Điêu lâu và làng cổ Khai Bình” được ghi vào Danh sách Di sản Thế giới năm 2007. Bảo tồn hướng tới tính xác thực và toàn vẹn của điêu lâu, nhà làng và môi trường liên quan thông qua quản lý liên tục.',
    english: 'Kaiping Diaolou and Villages was inscribed on the World Heritage List in 2007. Conservation protects the authenticity and integrity of the towers, village houses, and their setting through continuing management.',
  ),
];

class _KaipingWordSpec {
  const _KaipingWordSpec(
    this.word,
    this.pinyin,
    this.partOfSpeech,
    this.simple,
    this.vietnamese,
    this.english,
    this.symbol,
    this.exampleChinese,
    this.exampleVietnamese,
    this.exampleEnglish,
  );

  final String word;
  final String pinyin;
  final String partOfSpeech;
  final String simple;
  final String vietnamese;
  final String english;
  final String symbol;
  final String exampleChinese;
  final String exampleVietnamese;
  final String exampleEnglish;
}

const _kaipingWordSpecs = <_KaipingWordSpec>[
  _KaipingWordSpec('开平', 'Kāipíng', '名词（专名）', '广东江门下辖的县级市。', 'Khai Bình, thành phố cấp huyện thuộc Giang Môn, Quảng Đông.', 'Kaiping, a county-level city under Jiangmen in Guangdong.', '🏘️', '故事发生在20世纪20年代的开平。', 'Câu chuyện diễn ra ở Khai Bình vào thập niên 1920.', 'The story takes place in 1920s Kaiping.'),
  _KaipingWordSpec('海外', 'hǎiwài', '名词', '本国以外的地方。', 'Hải ngoại; nơi ở ngoài nước.', 'overseas; places outside one’s country', '🌏', '梁海在海外谋生。', 'Lương Hải mưu sinh ở nước ngoài.', 'Liang Hai works overseas.'),
  _KaipingWordSpec('图样', 'túyàng', '名词', '表示建筑或物品样式的图。', 'Bản vẽ thể hiện hình thức công trình hoặc đồ vật.', 'a drawing or pattern showing a design', '📐', '哥哥寄回一张建筑图样。', 'Người anh gửi về một bản vẽ kiến trúc.', 'The older brother sends home a building sketch.'),
  _KaipingWordSpec('众楼', 'zhònglóu', '名词', '由多户合建、用于临时避难的一类开平碉楼。', 'Loại điêu lâu do nhiều hộ cùng xây để trú ẩn tạm thời.', 'a Kaiping communal tower jointly built by households for temporary refuge', '🏢', '村里几户人家合建一座众楼。', 'Vài hộ trong làng cùng xây một chúng lâu.', 'Several village households jointly build a communal tower.'),
  _KaipingWordSpec('合建', 'héjiàn', '动词', '几方共同出力建设。', 'Cùng góp sức xây dựng.', 'to build jointly', '🤝', '合建改变了这座楼的使用关系。', 'Việc cùng xây thay đổi quan hệ sử dụng tòa nhà.', 'Joint construction changes how the tower is used.'),
  _KaipingWordSpec('避难', 'bìnàn', '动词', '暂时到安全处躲避危险。', 'Tạm lánh đến nơi an toàn khi có nguy hiểm.', 'to take refuge from danger', '🛡️', '众楼可以让多户人家临时避难。', 'Chúng lâu có thể cho nhiều hộ trú ẩn tạm thời.', 'A communal tower could provide temporary refuge for several households.'),
  _KaipingWordSpec('工匠', 'gōngjiàng', '名词', '有专门手艺的建造者。', 'Thợ thủ công có kỹ năng chuyên môn.', 'a skilled craftsperson', '🧰', '梁川请工匠修改方案。', 'Lương Xuyên nhờ người thợ sửa phương án.', 'Liang Chuan asks the craftsperson to revise the plan.'),
  _KaipingWordSpec('照搬', 'zhàobān', '动词', '完全按原样复制，不作调整。', 'Sao chép nguyên xi mà không điều chỉnh.', 'to copy unchanged', '📋', '回来，不等于照搬。', 'Trở về không có nghĩa là sao chép nguyên xi.', 'Coming home does not mean copying unchanged.'),
  _KaipingWordSpec('居楼', 'jūlóu', '名词', '兼有居住和防卫功能的一类碉楼。', 'Loại điêu lâu vừa để ở vừa có chức năng phòng thủ.', 'a fortified residential diaolou', '🏠', '居楼和众楼的主要使用关系不同。', 'Cư lâu và chúng lâu có quan hệ sử dụng chính khác nhau.', 'Residential and communal towers have different primary patterns of use.'),
  _KaipingWordSpec('更楼', 'gēnglóu', '名词', '主要用于守望和预警的一类碉楼。', 'Loại tháp chủ yếu dùng để quan sát và cảnh báo.', 'a watch tower used mainly for lookout and warning', '🔭', '更楼承担守望和预警。', 'Canh lâu đảm nhiệm quan sát và cảnh báo.', 'Watch towers support lookout and warning.'),
  _KaipingWordSpec('联防', 'liánfáng', '动词/名词', '多个家庭或地点共同防护。', 'Nhiều hộ hoặc địa điểm cùng phối hợp phòng vệ.', 'coordinated collective defence', '🧱', '更楼可以服务村落联防。', 'Canh lâu có thể phục vụ liên phòng của làng.', 'Watch towers could support coordinated village defence.'),
  _KaipingWordSpec('拱券', 'gǒngquàn', '名词', '拱形承重或装饰构件。', 'Cấu kiện dạng vòm dùng chịu lực hoặc trang trí.', 'an architectural arch or arched structural element', '🌉', '虚构图样上画着拱券。', 'Bản vẽ hư cấu có vẽ các vòm cuốn.', 'The fictional sketch includes arches.'),
  _KaipingWordSpec('柱廊', 'zhùláng', '名词', '由一列柱子形成的廊道。', 'Hành lang được tạo bởi một hàng cột.', 'a colonnade', '🏛️', '官方资料记录部分碉楼使用柱廊等元素。', 'Tư liệu chính thức ghi nhận một số điêu lâu dùng hàng cột và các yếu tố khác.', 'Official sources record colonnades among elements used in some diaolou.'),
  _KaipingWordSpec('民居', 'mínjū', '名词', '普通居民生活使用的住宅。', 'Nhà ở dân cư thông thường.', 'ordinary residential houses', '🏡', '碉楼与民居、田地共同构成村落环境。', 'Điêu lâu, nhà dân và ruộng cùng tạo nên môi trường làng.', 'Diaolou, houses, and fields form the village setting together.'),
  _KaipingWordSpec('侨户', 'qiáohù', '名词', '与海外华侨有家庭联系的住户。', 'Hộ gia đình có quan hệ với Hoa kiều ở nước ngoài.', 'a household with overseas Chinese family connections', '🧳', '故事没有把所有侨户写成同一种经历。', 'Câu chuyện không coi mọi hộ kiều dân có cùng một lịch sử.', 'The story does not give every overseas-linked household the same history.'),
  _KaipingWordSpec('跨国联系', 'kuàguó liánxì', '名词', '跨越国家形成的人际、经济或文化联系。', 'Liên hệ con người, kinh tế hoặc văn hóa vượt qua biên giới quốc gia.', 'transnational human, economic, or cultural connections', '🌐', '开平碉楼反映了跨国联系与本地需要的交织。', 'Điêu lâu Khai Bình phản ánh sự đan xen giữa liên hệ xuyên quốc gia và nhu cầu địa phương.', 'Kaiping diaolou reflect the entanglement of transnational ties and local needs.'),
];

WordEntry _kaipingWord(_KaipingWordSpec spec) {
  return WordEntry(
    word: spec.word,
    pinyin: spec.pinyin,
    partOfSpeech: spec.partOfSpeech,
    simpleChinese: spec.simple,
    translation: spec.vietnamese,
    englishDefinition: spec.english,
    symbol: spec.symbol,
    examples: <WordExample>[
      WordExample(
        chinese: spec.exampleChinese,
        pinyin: _kaipingPinyin(spec.exampleChinese),
        vietnamese: spec.exampleVietnamese,
        english: spec.exampleEnglish,
      ),
      WordExample(
        chinese: spec.exampleChinese,
        pinyin: _kaipingPinyin(spec.exampleChinese),
        vietnamese: spec.exampleVietnamese,
        english: spec.exampleEnglish,
      ),
      WordExample(
        chinese: spec.exampleChinese,
        pinyin: _kaipingPinyin(spec.exampleChinese),
        vietnamese: spec.exampleVietnamese,
        english: spec.exampleEnglish,
      ),
    ],
  );
}

final kaipingDiaolouWords =
    List<WordEntry>.unmodifiable(_kaipingWordSpecs.map(_kaipingWord));

const _kaipingDiscoveryIndexes = <List<int>>[
  [0, 2],
  [1, 3],
  [0, 2],
  [2, 5],
  [0, 3, 5],
  [0, 4, 6],
  [3, 5, 6],
  [2, 3, 6],
  [3, 5, 6],
  [3, 6, 7],
];

const _kaipingAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent _buildKaipingDiaolouLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final storyParagraphs = _kaipingStoryParagraphs(level);
  final storyAnnotations = _kaipingStoryAnnotations(level);
  final discoveries = <DiscoveryEntry>[
    for (final index in _kaipingDiscoveryIndexes[level - 1])
      kaipingDiaolouDiscoveryPool[index],
  ];
  final profile = _kaipingAgent.profileForPhoenixLevel(level);
  final targetVocabularyCount = _kaipingAgent.planFor(profile).targetVocabularyCount;
  final visibleText = '${storyParagraphs.join()}${discoveries.map((item) => item.text).join()}';
  final candidates = kaipingDiaolouWords
      .where((entry) => visibleText.contains(entry.word))
      .toList(growable: false);
  if (candidates.length < targetVocabularyCount) {
    throw StateError(
      'Kaiping Lv$level has ${candidates.length} source-bound words; requires $targetVocabularyCount.',
    );
  }
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(storyParagraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(storyAnnotations),
    words: List<WordEntry>.unmodifiable(candidates.take(targetVocabularyCount)),
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: '梁川为什么没有把哥哥寄回的图样原样盖进村里？',
    expressQuestion: '众楼的共同使用关系与海外带回的建筑影响，怎样一起改变梁川的选择？',
  );
}

final kaipingDiaolouOnePassLevels = List<JourneyLevelContent>.unmodifiable(
  List<JourneyLevelContent>.generate(
    10,
    (index) => _buildKaipingDiaolouLevel(index + 1),
    growable: false,
  ),
);

JourneyLevelContent kaipingDiaolouGoldLevelContent(int requestedLevel) =>
    kaipingDiaolouOnePassLevels[requestedLevel.clamp(1, 10).toInt() - 1];

final _kaipingEvents = <RemediatedSemanticEvent>[
  for (var index = 0; index < _kaipingStorySegments.where((item) => item.fromLevel == 1).length; index++)
    RemediatedSemanticEvent(
      id: 'KP-E${index + 1}',
      coreChinese: _kaipingStorySegments.where((item) => item.fromLevel == 1).elementAt(index).chinese,
      corePinyin: _kaipingPinyin(_kaipingStorySegments.where((item) => item.fromLevel == 1).elementAt(index).chinese),
      coreVietnamese: _kaipingStorySegments.where((item) => item.fromLevel == 1).elementAt(index).vietnamese,
      coreEnglish: _kaipingStorySegments.where((item) => item.fromLevel == 1).elementAt(index).english,
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11,
    ),
];

final kaipingDiaolouGoldJourney = RemediatedJourney(
  id: kaipingDiaolouJourneyId,
  title: kaipingDiaolouCanonicalTitle,
  protagonist: '梁川，虚构的20世纪20年代开平留乡青年',
  goal: '决定家里如何参与建楼，同时不把哥哥的远方经历变成不可修改的命令',
  conflict: '私家独建方案与多户合建众楼的共同使用关系发生冲突',
  eventIds: List<String>.unmodifiable(_kaipingEvents.map((event) => event.id)),
  events: List<RemediatedSemanticEvent>.unmodifiable(_kaipingEvents),
  levels: kaipingDiaolouOnePassLevels,
  words: kaipingDiaolouWords,
  wordTraces: List<RemediatedWordTrace>.unmodifiable([
    for (final word in kaipingDiaolouWords)
      RemediatedWordTrace(
        word: word.word,
        eventId: 'KP-E1',
        usage: 'source-bound Story/Discovery vocabulary',
        sourceText: word.examples.first.chinese,
      ),
  ]),
  discoveries: List<DiscoveryEntry>.unmodifiable(kaipingDiaolouDiscoveryPool),
  discoveryTraces: List<RemediatedDiscoveryTrace>.unmodifiable([
    for (var index = 0; index < kaipingDiaolouDiscoveryPool.length; index++)
      RemediatedDiscoveryTrace(
        discoveryIndex: index,
        storyEventIds: index == 0 || index == 2 ? const ['KP-E1', 'KP-E2', 'KP-E3'] : const <String>[],
        sourceIds: const ['unesco-kaiping-diaolou-villages', 'kaiping-government-diaolou-types'],
      ),
  ]),
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(
      type: 'paragraphRebuild',
      storyEventIds: ['KP-E1', 'KP-E2', 'KP-E3', 'KP-E4'],
      anchor: '海外图样→众楼共同使用→寄回改图→哥哥改写“我们家在众楼里的一份”',
    ),
    RemediatedChallengeTrace(
      type: 'grammarRepair',
      storyEventIds: ['KP-E2', 'KP-E3'],
      anchor: '只使用当前 Story / Discovery 语言，不引入新的历史主张',
    ),
    RemediatedChallengeTrace(
      type: 'missingSentence',
      storyEventIds: ['KP-E2', 'KP-E3', 'KP-E4'],
      anchor: '共同使用关系必须连接私家方案与改图选择',
    ),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(
      category: 'choice',
      prompt: '梁川最后放弃了什么？',
      answer: '他放弃把哥哥寄回的图样原样变成一座只属于家里的楼，转而加入多户合建众楼。',
      storyEventIds: ['KP-E2', 'KP-E3'],
    ),
    RemediatedMemoryReview(
      category: 'place',
      prompt: '为什么这个选择特别属于开平碉楼？',
      answer: '开平同时存在众楼、居楼、更楼等不同社会功能，并把海外建筑影响与本地乡村需要重新组合。',
      storyEventIds: ['KP-E2', 'KP-E3'],
    ),
    RemediatedMemoryReview(
      category: 'truth',
      prompt: '故事中的梁川、梁海和家书是真实历史人物与档案吗？',
      answer: '不是。人物、家书、图样和具体家庭选择全部是虚构；碉楼类型、时期与侨乡建筑机制来自权威资料。',
      storyEventIds: ['KP-E1'],
    ),
    RemediatedMemoryReview(
      category: 'memory',
      prompt: '梁川在箱底留下了什么？',
      answer: '没被原样照搬的图，以及哥哥把“我家的楼”改成“我们家在众楼里的一份”的回信。',
      storyEventIds: ['KP-E4'],
    ),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '梁川把独建图改成众楼方案；梁海也改写了自己对这座楼的称呼，兄弟共同承担新的选择。',
    achievement: '侨乡重组者',
    memoryAnchor: '箱底的原图和哥哥改过的那行字',
    challengeReward: '你分清了海外影响、建筑形式与村落社会功能不是同一件事。',
    journeyCompletion: '故事没有把侨乡写成单纯的成功返乡，也没有把一种碉楼功能扩大成全部碉楼。',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(
      id: 'unesco-kaiping-diaolou-villages',
      publisher: 'UNESCO World Heritage Centre',
      scope: 'OUV, three tower forms, diaspora connections, architectural fusion, landscape, protection',
    ),
    RemediatedSourceBinding(
      id: 'kaiping-government-diaolou-types',
      publisher: '开平市人民政府',
      scope: 'communal/residential/watch tower functional classification',
    ),
    RemediatedSourceBinding(
      id: 'kaiping-government-zili-village',
      publisher: '开平市人民政府',
      scope: 'verified local construction context and some use of overseas drawings/materials at Zili Village only',
    ),
    RemediatedSourceBinding(
      id: 'jiangmen-government-kaiping-heritage',
      publisher: '江门市文化广电旅游体育局',
      scope: '2007 inscription and continuing heritage management',
    ),
  ],
);

final _kaipingBaseLevel = kaipingDiaolouGoldLevelContent(5);

final kaipingDiaolouJourney = JourneyContentRecord(
  id: kaipingDiaolouJourneyId,
  title: kaipingDiaolouCanonicalTitle,
  geoNodeId: kaipingDiaolouGeoNodeId,
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['开平碉楼', '侨乡', '众楼', '中西建筑文化交流'],
  sections: <JourneyStorySection>[
    for (var index = 0; index < _kaipingBaseLevel.storyParagraphs.length; index++)
      JourneyStorySection(
        id: 'story-$index',
        text: _kaipingBaseLevel.storyParagraphs[index],
        sourceIds: const [
          'unesco-kaiping-diaolou-villages',
          'kaiping-government-diaolou-types',
        ],
      ),
  ],
);

final kaipingDiaolouExperience = DailyJourneyExperience(
  id: kaipingDiaolouJourneyId,
  city: '江门',
  cityCode: 'JMN',
  place: '开平碉楼与村落',
  appBarTitle: '江门 · 开平碉楼与村落',
  storyTitle: kaipingDiaolouCanonicalTitle,
  headline: kaipingDiaolouHeadline,
  description: kaipingDiaolouDescription,
  discoveryTeaser: kaipingDiaolouDiscoveryTeaser,
  distanceLabel: '800 km',
  stampSymbol: '碉',
  content: kaipingDiaolouJourney,
  storyAnnotations: _kaipingBaseLevel.storyAnnotations,
  words: _kaipingBaseLevel.words,
  discoveries: _kaipingBaseLevel.discoveries,
  wonderQuestion: _kaipingBaseLevel.wonderQuestion,
  expressQuestion: _kaipingBaseLevel.expressQuestion,
);

const kaipingDepthActionTest = <String, String>{
  'DEPTH': 'SOCIAL CAUSALITY',
  'SOURCE': 'UNESCO / official Kaiping classification of communal, residential and watch towers',
  'CHARACTER_ENCOUNTER': 'family-private design meets a multi-household communal-tower project',
  'ACTION_CAUSED': 'Liang Chuan changes where the family puts its building effort and revises the returned sketch',
  'CONSTRAINT': 'shared refuge use conflicts with a purely private building plan',
  'CHOICE_EFFECT': 'the plan is adapted instead of copied',
  'COST_EFFECT': 'the family gives up a separate private plan; brotherly recognition is at risk',
  'CONSEQUENCE_EFFECT': 'overseas form remains partial while village social function governs the building choice',
  'REMOVAL_TEST': 'without communal-tower social organization, Goal-Conflict-Choice-Cost-Consequence collapse into a generic design disagreement',
  'RESULT': 'PASS',
};

const kaipingHistoricalSafetyAudit = <String, String>{
  'UNSUPPORTED_HISTORICAL_FACT': 'NONE',
  'REAL_PERSON_FABRICATED_ACTION': 'NONE',
  'REAL_PERSON_FABRICATED_DIALOGUE': 'NONE',
  'REAL_PERSON_FABRICATED_MOTIVE': 'NONE',
  'FAKE_FAMILY_HISTORY': 'NONE — fictional family explicitly identified as fiction',
  'FAKE_MIGRATION_ROUTE': 'NONE — no country or route assigned to fictional brother',
  'FAKE_REMITTANCE_RECORD': 'NONE — no amount or archival remittance record claimed',
  'FAKE_BUILDING_OWNER': 'NONE — Story is not attached to a real diaolou',
  'BUILDING_IDENTITY_MERGE': 'NONE',
  'UNSUPPORTED_FUNCTION_GENERALIZATION': 'NONE',
  'LEGEND_PRESENTED_AS_FACT': 'NONE',
  'CONTESTED_PRESENTED_AS_CERTAIN': 'NONE',
  'TEMPORAL_ANACHRONISM': 'NONE',
  'TRANSLATION_TRUTH_DRIFT': 'NONE',
  'UNSOURCED_STORY_CAUSAL_FACT': 'NONE',
};
