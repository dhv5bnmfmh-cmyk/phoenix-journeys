import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';

/// Canonical Forbidden City Discovery depth for the current Phoenix curriculum.
const forbiddenCityDiscoveryDepthByLevel = <int>[
  2,
  2,
  2,
  2,
  3,
  3,
  3,
  3,
  3,
  3,
];

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

DiscoveryEntry _fact(
  String text,
  String simpleChinese,
  String vietnamese,
  String english,
) =>
    DiscoveryEntry(
      text: text,
      pinyin: _pinyin(text),
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

// Fact sources are intentionally limited to the Palace Museum (故宫博物院):
// 午门: https://www.dpm.org.cn/explore/building/236454.html
// 乾清门: https://www.dpm.org.cn/explore/building/236473.html
// 景运门: https://www.dpm.org.cn/explore/building/236497.html
// 隆宗门: https://www.dpm.org.cn/explore/building/236496.html
// 外朝/内廷 overview: https://www.dpm.org.cn/forum_detail/99719.html
//
// Discovery deliberately avoids Story character names. Each unit adds an
// independently checkable architectural, functional, or historical-access fact
// instead of retelling the 沈砚 / 阿宁 route conflict.
final List<List<DiscoveryEntry>> _forbiddenCityDiscoveryCurriculum =
    <List<DiscoveryEntry>>[
  <DiscoveryEntry>[
    _fact(
      '午门是紫禁城的正门，位于南北轴线上。午门之后是太和门，门与广场层层递进，所以中轴首先表现为一组连续的真实空间，而不只是一条画在图上的直线。',
      '午门是紫禁城正门，在南北中轴线上；午门后还有太和门和连续空间。',
      'Ngọ Môn là chính môn của Tử Cấm Thành và nằm trên trục bắc-nam. Phía sau còn có Thái Hòa Môn và các lớp không gian nối tiếp.',
      'The Meridian Gate is the principal gate of the Forbidden City on the north-south axis. Beyond it, the Gate of Supreme Harmony and successive spaces make the axis a real sequence of places, not just a line on a map.',
    ),
    _fact(
      '乾清门是紫禁城内廷的正宫门，也是内廷与外朝往来的重要通道。把它当作一个空间节点时，要同时记住它的建筑身份和连接作用。',
      '乾清门是内廷正宫门，也是连接内廷与外朝的重要通道。',
      'Càn Thanh Môn là chính môn của Nội đình và là lối giao thông quan trọng giữa Nội đình với Ngoại triều.',
      'The Gate of Heavenly Purity is the principal gate of the Inner Court and an important passage between the Inner and Outer Courts.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '午门共有五个门洞，明清时期不同门洞有不同的出入规则：中门主要供皇帝使用，东侧门供文武官员出入，西侧门供宗室王公出入。真实宫城里的“从哪里通过”会受到身份与礼制影响。',
      '午门不同门洞过去有不同使用规则，身份会影响从哪里通过。',
      'Ngọ Môn có năm lối qua; trong thời Minh-Thanh, các lối khác nhau phục vụ những nhóm người khác nhau, nên thân phận có thể ảnh hưởng đường đi.',
      'The Meridian Gate has five openings. In the Ming and Qing periods, different openings served different users, so identity and ritual rules could affect where a person passed.',
    ),
    _fact(
      '乾清门前广场的东侧是景运门，西侧是隆宗门，两门相对而立。这个事实说明乾清门前不仅有南北方向关系，也有明确的东西向连接。',
      '乾清门前广场东有景运门，西有隆宗门，所以这里也有东西向连接。',
      'Phía đông quảng trường trước Càn Thanh Môn là Cảnh Vận Môn, phía tây là Long Tông Môn; vì vậy nút không gian này còn có liên kết đông-tây.',
      'Jingyun Gate stands on the east side of the forecourt before the Gate of Heavenly Purity, with Longzong Gate opposite on the west, creating a clear east-west connection.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '午门前后采用门、廊庑与广场层层递进的组织方式。故宫博物院把这种布局与古代“五门三朝”制度联系起来；理解紫禁城路线时，门与院落的先后关系本身就是空间信息。',
      '紫禁城中门、廊庑和广场有先后层次，空间顺序本身就是重要信息。',
      'Các cổng, hành lang và quảng trường được tổ chức theo lớp; thứ tự không gian tự nó là một thông tin quan trọng khi đọc Tử Cấm Thành.',
      'Gates, covered corridors, and squares are arranged in successive layers. The Palace Museum relates this layout to the traditional “five gates and three courts” system, so spatial sequence itself is evidence.',
    ),
    _fact(
      '景运门与隆宗门都是进入乾清门前广场的重要门户，并可进一步通往外朝中路和内廷中路。不同方向的门户因此可以把行动汇入同一个重要节点。',
      '景运门和隆宗门都能进入乾清门前广场，并继续联系外朝与内廷中路。',
      'Cảnh Vận Môn và Long Tông Môn đều là cửa quan trọng vào quảng trường trước Càn Thanh Môn và còn nối tới trục giữa của Ngoại triều và Nội đình.',
      'Jingyun and Longzong Gates are important entrances to the forecourt before the Gate of Heavenly Purity and connect onward toward the central routes of the Outer and Inner Courts.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '紫禁城通常按“前朝后寝”的格局理解为外朝与内廷两大功能部分。外朝以太和殿、中和殿、保和殿为中心，内廷则以乾清宫、交泰殿、坤宁宫为中心。空间位置和建筑功能并不是同一个概念。',
      '外朝和内廷功能不同：外朝以三大殿为中心，内廷以后面三宫为中心。',
      'Ngoại triều và Nội đình có chức năng khác nhau: Ngoại triều xoay quanh ba đại điện, còn Nội đình xoay quanh Càn Thanh Cung, Giao Thái Điện và Khôn Ninh Cung.',
      'The Forbidden City is commonly understood as Outer and Inner Courts with different functions: the Outer Court centers on the three great halls, while the Inner Court centers on the three rear palaces.',
    ),
    _fact(
      '乾清门既是内廷正宫门，又是连接内廷与外朝的重要通道。它同时具有“建筑入口”和“功能转换节点”两层意义，所以判断空间关系时不能只看方向。',
      '乾清门既是门，也是外朝与内廷之间的重要转换节点。',
      'Càn Thanh Môn vừa là cổng chính của Nội đình, vừa là nút chuyển quan trọng giữa Ngoại triều và Nội đình.',
      'The Gate of Heavenly Purity is both an architectural entrance and a major transition point between the Outer and Inner Courts, so direction alone does not describe its spatial role.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '景运门位于乾清门前广场东侧，东向；隆宗门位于广场西侧，西向，两门相对而立且形制相同。这是一组可以直接核对的东西向空间证据。',
      '景运门在东、隆宗门在西，两门相对，是明确的东西向空间证据。',
      'Cảnh Vận Môn ở phía đông, Long Tông Môn ở phía tây và hai cổng đối nhau; đây là bằng chứng không gian đông-tây có thể kiểm chứng trực tiếp.',
      'Jingyun Gate is on the east and Longzong Gate on the west of the forecourt; they face opposite directions and form a directly checkable east-west spatial relation.',
    ),
    _fact(
      '乾清门东侧还有内左门，西侧有内右门；而门前广场东西两端又分别是景运门与隆宗门。一个重要节点可以同时拥有中轴、侧向门户和内部连接。',
      '乾清门附近既有中轴关系，也有东西两侧的多组门。',
      'Khu vực Càn Thanh Môn vừa nằm trong quan hệ trục giữa, vừa có nhiều cổng kết nối ở hai phía đông-tây.',
      'Around the Gate of Heavenly Purity, the central-axis relation coexists with Inner Left and Inner Right Gates and with Jingyun and Longzong Gates at the east and west ends of the forecourt.',
    ),
    _fact(
      '故宫博物院资料把景运门、隆宗门都列为进入乾清门前广场的重要门户。判断一条路线是否有真实空间依据时，可以先核对“门是否存在、位置是否相接、能否进入共同节点”这类可验证事实。',
      '先核对真实门的位置和连接，再谈路线判断。',
      'Khi kiểm tra một tuyến, trước hết cần xác nhận cổng có thật, vị trí có nối nhau và có thể đi vào nút chung hay không.',
      'The Palace Museum identifies both Jingyun and Longzong Gates as important entrances to the forecourt. Route reasoning can therefore begin with verifiable facts about gates, positions, and shared nodes.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '乾清门连接内廷与外朝，但“空间上相连”不等于“历史上任何人都可随意通行”。紫禁城的宫门长期受身份、职务和礼制约束，空间可行性与实际通行资格是不同问题。',
      '空间能连接，不代表历史上所有人都能同样通行。',
      'Không gian có thể nối với nhau nhưng trong lịch sử không phải ai cũng được đi qua như nhau; khả năng kết nối và quyền đi lại là hai vấn đề khác nhau.',
      'Physical connection did not mean unrestricted historical access. Palace movement was also constrained by identity, office, and ritual, so spatial feasibility and permission were different questions.',
    ),
    _fact(
      '景运门与隆宗门分别位于乾清门前广场东西两侧，并可通往外朝中路与内廷中路。它们说明侧向门户不是中轴的“替代品”，而是同一宫城结构中的另一组连接。',
      '东西侧门户和中轴共同组成宫城连接，不是谁替代谁。',
      'Các cổng đông-tây và trục giữa cùng tạo nên mạng kết nối của cung thành; chúng không thay thế lẫn nhau.',
      'The east-west gateways and the central axis belong to the same palace network. Side gates do not replace the axis; they add other connections to the same structure.',
    ),
    _fact(
      '外朝与内廷的功能分区会改变空间节点的意义。乾清门作为内廷正宫门和往来通道，使“到达乾清门前”与“继续进入哪个功能区域”成为两个不同层次的空间问题。',
      '到达乾清门前和继续进入哪个功能区域，是两个层次的问题。',
      'Đến trước Càn Thanh Môn và tiếp tục vào khu chức năng nào là hai tầng câu hỏi không gian khác nhau.',
      'Reaching the forecourt before the Gate of Heavenly Purity and deciding which functional area to enter next are different levels of spatial reasoning.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '午门五个门洞在明清时期有明确的身份与礼制用途。中门主要供皇帝使用，官员与宗室王公通常使用不同侧门；同一座门的“可通过位置”因此可以用制度资料核对，而不是凭个人感觉判断。',
      '午门不同门洞有制度化用途，这类事实可以作为路线判断的证据。',
      'Các lối qua Ngọ Môn có công năng theo thân phận và lễ chế; đây là loại bằng chứng có thể kiểm tra bằng tư liệu lịch sử.',
      'The Meridian Gate’s openings had institutional uses tied to status and ritual. Such access rules are historical evidence, not a matter of personal preference.',
    ),
    _fact(
      '景运门不仅位于乾清门前广场东侧，故宫博物院还记载它与隆宗门都被称作“禁门”，对进入者有严格限制。建筑位置说明“哪里相连”，制度记录则补充“谁在什么条件下能进入”。',
      '建筑位置说明哪里相连；历史制度还能说明谁能进入。',
      'Vị trí kiến trúc cho biết nơi nào nối nhau; quy định lịch sử bổ sung ai được đi vào trong điều kiện nào.',
      'Jingyun and Longzong Gates were also known as restricted gates. Architecture tells us what connects; historical rules add who could enter under what conditions.',
    ),
    _fact(
      '隆宗门是内廷与外朝西路及西苑的重要通路，故宫博物院同时记载王公大臣也不能无故私入。真实路线判断可以同时依赖“建筑连接证据”和“通行规则证据”。',
      '隆宗门既是重要通路，又有严格通行限制；两类事实需要一起看。',
      'Long Tông Môn vừa là tuyến thông quan trọng vừa có hạn chế ra vào nghiêm ngặt; cần xem cả kết nối kiến trúc lẫn quy định sử dụng.',
      'Longzong Gate was an important passage toward the western routes, yet access was restricted. Route evidence can therefore combine architectural connection with historical access rules.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '故宫博物院资料概括紫禁城宫殿沿中轴排列并左右对称。中轴提供整体秩序，但这种对称并没有取消东西两侧的宫门、宫院和通路；“整体骨架”和“局部连接”需要同时阅读。',
      '紫禁城有明显中轴和左右对称，也有东西两侧的局部连接。',
      'Tử Cấm Thành có trục giữa và tính đối xứng rõ rệt, đồng thời vẫn có các kết nối cục bộ ở hai phía đông-tây.',
      'The Palace Museum describes the palaces as arranged along the central axis with left-right symmetry. That overall order coexists with east-west gates, courtyards, and local connections.',
    ),
    _fact(
      '乾清门前广场东西两端分别是景运门与隆宗门，乾清门本身又连接内廷与外朝。这三个门的关系把南北中轴和东西侧向连接放进了同一个可核对的空间节点。',
      '乾清门、景运门、隆宗门把南北与东西连接放在同一节点。',
      'Càn Thanh Môn, Cảnh Vận Môn và Long Tông Môn đưa quan hệ bắc-nam và đông-tây vào cùng một nút không gian có thể kiểm chứng.',
      'The Gate of Heavenly Purity together with Jingyun and Longzong Gates puts north-south and east-west connections into one verifiable spatial node.',
    ),
    _fact(
      '乾清门在清代不仅是通道，也曾用于御门听政、斋戒等政务与典礼活动。建筑功能会随制度和活动增加层次，因此同一地点不能只用“经过”来理解。',
      '乾清门既是通道，也曾承担政务和典礼功能。',
      'Càn Thanh Môn không chỉ là lối qua mà còn từng là nơi diễn ra hoạt động chính vụ và nghi lễ thời Thanh.',
      'In the Qing period, the Gate of Heavenly Purity was not only a passage but also a setting for government audiences and ceremonies, adding functional layers to the same place.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '把午门、太和门等中轴序列与乾清门前的景运门、隆宗门一起看，可以得到一个更完整的空间骨架：南北轴线组织整体层次，东西门户把重要节点接入侧向区域。',
      '共同空间骨架既有南北中轴，也有东西门户和节点。',
      'Khung không gian chung gồm cả trục bắc-nam lẫn các cổng đông-tây nối vào những nút quan trọng.',
      'A fuller spatial framework combines the north-south sequence of major gates with east-west gateways such as Jingyun and Longzong Gates at key nodes.',
    ),
    _fact(
      '外朝与内廷是功能框架，乾清门又处在两者往来的关键位置。因此“建筑在什么地方”“建筑承担什么功能”“人从哪里能通行”是三种相关但不能互相替代的信息。',
      '位置、功能和通行条件是三种不同信息。',
      'Vị trí, chức năng và điều kiện đi qua là ba loại thông tin khác nhau nhưng liên quan với nhau.',
      'Location, function, and access conditions are three related but non-interchangeable kinds of information in the palace spatial system.',
    ),
    _fact(
      '午门门洞的分工与景运门、隆宗门的禁门制度都说明：路线偏好不能只由几何距离解释。历史上的身份、职责、礼制和活动也会改变哪些通路更合适或甚至是否可用。',
      '路线选择除了空间距离，还会受到身份、职责和礼制影响。',
      'Lựa chọn tuyến không chỉ do khoảng cách không gian mà còn chịu ảnh hưởng của thân phận, chức trách và lễ chế.',
      'Historical route choice cannot be explained by geometry alone. Status, duty, ritual, and occasion could change which passage was appropriate or even available.',
    ),
  ],
  <DiscoveryEntry>[
    _fact(
      '午门提供一个真实的“条件变化”例子：同一建筑有五个门洞，但皇帝、文武官员、宗室王公以及特定典礼中的人员并不遵循完全相同的出入规则。任务相同为“进宫”，成立条件仍可能不同。',
      '同样要进宫，不同身份和场合也可能使用不同门洞。',
      'Cùng mục tiêu vào cung nhưng thân phận và dịp lễ khác nhau vẫn có thể dẫn đến lối qua khác nhau.',
      'The Meridian Gate provides a real conditional case: people entering the same palace did not necessarily use the same opening because status and occasion changed the access rule.',
    ),
    _fact(
      '乾清门前广场同时连接南北中轴、东侧景运门和西侧隆宗门，而景运门、隆宗门又有历史通行限制。一个成熟的路线判断必须把“空间能否连接”和“当时是否允许这样通行”分开检验。',
      '先看空间是否连接，再看历史条件是否允许通行。',
      'Cần kiểm tra riêng hai việc: không gian có nối được không và trong điều kiện lịch sử đó có được phép đi qua không.',
      'The forecourt before the Gate of Heavenly Purity links axial and east-west routes, while Jingyun and Longzong Gates had access restrictions. Spatial connection and historical permission therefore require separate checks.',
    ),
    _fact(
      '把故宫博物院提供的位置、功能与通行资料放在一起，可以形成迁移判断：先确认真实建筑连接，再确认身份、制度与任务条件，最后比较行动后果。这样的判断允许多种路线，但不会把“任何路线都可以”当成结论。',
      '迁移判断要同时检查建筑连接、身份制度、任务和行动后果。',
      'Khi chuyển sang tình huống mới, cần kiểm tra đồng thời kết nối kiến trúc, thân phận-quy định, nhiệm vụ và hệ quả hành động.',
      'For transfer to a new task, combine verified architectural connections with status, institutional rules, task conditions, and action consequences. This permits multiple justified routes without treating every route as valid.',
    ),
  ],
];

List<DiscoveryEntry> forbiddenCityDiscoveryCurriculumForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final entries = _forbiddenCityDiscoveryCurriculum[safeLevel - 1];
  final expected = forbiddenCityDiscoveryDepthByLevel[safeLevel - 1];
  if (entries.length != expected) {
    throw StateError(
      'Forbidden City Lv$safeLevel Discovery depth ${entries.length} != $expected',
    );
  }
  return List<DiscoveryEntry>.unmodifiable(entries);
}
