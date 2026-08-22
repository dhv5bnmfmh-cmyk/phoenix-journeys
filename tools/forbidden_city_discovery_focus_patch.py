from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNTIME = ROOT / 'app/lib/data/forbidden_city_journey_runtime.dart'
SELF = Path(__file__).resolve()

text = RUNTIME.read_text(encoding='utf-8')
old = '''List<DiscoveryEntry> _discoveriesForLevel(int level) {
  if (level <= 2) return <DiscoveryEntry>[forbiddenCityDiscoveries[0]];
  if (level <= 4) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[0],
      forbiddenCityDiscoveries[1],
    ];
  }
  if (level <= 6) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[1],
      forbiddenCityDiscoveries[2],
    ];
  }
  if (level <= 8) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[2],
      forbiddenCityDiscoveries[3],
    ];
  }
  return <DiscoveryEntry>[
    forbiddenCityDiscoveries[3],
    forbiddenCityDiscoveries[4],
  ];
}
'''
new = r'''final forbiddenCityDiscoveryFocusByLevel = <DiscoveryEntry>[
  _discovery(
    'Lv1 先认清三个 Story 地点：午门在紫禁城南端并位于中轴线上；沿中轴向北，沈砚把乾清门前当作自己的到达点。阿宁从不同方向来到同一位置，所以“到同一个地方”不自动等于“走同一条路”。',
    '先认午门、中轴和乾清门。两个人可以从不同方向到同一个地方。',
    'Lv1: Hãy nhận ra Ngọ Môn, trục giữa và Càn Thanh Môn. Hai người có thể đến cùng một nơi từ những hướng khác nhau.',
    'Lv1: First identify the Meridian Gate, the central axis, and the Gate of Heavenly Purity. Two people can reach the same place from different directions.',
  ),
  _discovery(
    'Lv2 的关键不是背“另一条路”，而是看任务。中轴是一条非常清楚、常用的观察框架；阿宁却要把记录送回东边。乾清门前成为共同节点后，两人的下一步任务仍然不同，因此路线选择也可以不同。',
    '共同地点不等于共同任务。任务不同，合理路线也可能不同。',
    'Lv2: Cùng một điểm đến không có nghĩa là cùng một nhiệm vụ. Khi nhiệm vụ khác nhau, tuyến hợp lý cũng có thể khác.',
    'Lv2: A shared destination does not mean a shared task. Different tasks can justify different routes.',
  ),
  _discovery(
    'Lv3 要把“为什么能汇合”放回建筑里理解。紫禁城由连续的宫门、院落和方向关系组织，人物不是在空白地图上画线。两条路线能在乾清门前汇合，是因为它们都要遵守真实的空间连接。',
    '路线必须经过真实的门、院落和连接；汇合不是随便画出来的。',
    'Lv3: Tuyến đi phải dựa trên cổng, sân và kết nối có thật. Điểm hội tụ không phải là một nét vẽ tùy ý.',
    'Lv3: Routes must follow real gates, courtyards, and connections. A convergence point is not something that can be drawn arbitrarily.',
  ),
  _discovery(
    'Lv4 开始区分“空间结构”和“人物目标”。外朝的宫门、院落与中轴形成强烈秩序，乾清门又处在理解外朝与内廷关系的重要位置。建筑告诉人物哪些连接成立，却不会替沈砚和阿宁决定同一个任务。',
    '建筑决定哪些连接可能成立；人物目标决定为什么选择其中一条。',
    'Lv4: Kiến trúc cho biết kết nối nào có thể tồn tại; mục tiêu của nhân vật giải thích vì sao họ chọn một tuyến cụ thể.',
    'Lv4: Architecture determines which connections are possible; a character’s goal explains why one of those routes is chosen.',
  ),
  _discovery(
    'Lv5 可以用一个具体证据检查阿宁的东侧路线。故宫博物院资料显示，景运门位于乾清门前广场东侧，是进入这一广场的重要门户之一。这说明乾清门前不只属于南北中轴，它也与东侧空间发生真实连接。',
    '景运门在乾清门前广场东侧，证明这个共同节点也和东边空间相连。',
    'Lv5: Cảnh Vận Môn nằm phía đông quảng trường trước Càn Thanh Môn, cho thấy điểm chung này thật sự kết nối với không gian phía đông.',
    'Lv5: Jingyun Gate stands on the east side of the forecourt before the Gate of Heavenly Purity, showing that this shared node genuinely connects eastward.',
  ),
  _discovery(
    'Lv6 要把两个判断拆开：一条路线“能不能走通”，取决于门、院落、方向与功能分区等空间连接；它“适不适合任务”，还要看人物接下来必须完成什么。可行性和任务适配不是同一个问题。',
    '先判断空间是否可行，再判断是否适合任务；这两个问题不能混在一起。',
    'Lv6: Trước hết xét tuyến có khả thi trong không gian hay không, sau đó xét nó có phù hợp nhiệm vụ hay không. Hai phán đoán này khác nhau.',
    'Lv6: First test whether a route is spatially feasible, then whether it fits the task. These are two different judgments.',
  ),
  _discovery(
    'Lv7 的“证据”至少有两层。第一层是共同空间事实，例如中轴、宫门、院落和乾清门前的连接；第二层是人物任务与视角。只有同时检查这两层，才能解释为什么同一组建筑约束之内仍可能出现不同的合理选择。',
    '共同空间事实限制选择，任务和视角解释不同选择为什么仍然合理。',
    'Lv7: Sự thật không gian chung giới hạn lựa chọn; nhiệm vụ và góc nhìn giải thích vì sao các lựa chọn khác nhau vẫn có thể hợp lý.',
    'Lv7: Shared spatial facts constrain choices, while tasks and perspectives explain why different choices can still be reasonable.',
  ),
  _discovery(
    'Lv8 不把“不同视角”理解成“各说各话”。沈砚和阿宁都必须接受同一批建筑事实检验：路线是否真的连接、共同节点是否存在、任务是否被满足。视角可以不同，但证据标准不能随人物改变。',
    '视角可以不同，事实标准不能不同。两条路线都要接受同一组空间证据检查。',
    'Lv8: Góc nhìn có thể khác, nhưng tiêu chuẩn sự thật không thể thay đổi theo người. Cả hai tuyến phải chịu cùng một phép kiểm tra bằng chứng không gian.',
    'Lv8: Perspectives may differ, but the factual standard cannot change by person. Both routes must pass the same spatial-evidence test.',
  ),
  _discovery(
    'Lv9 可以把路线图分成两层来读：底层是紫禁城共同的空间骨架，包括中轴、门、院落、功能分区和东西连接；上层才是人物因任务形成的路线偏好。这样既不会把个人路线冒充整座宫城，也不会把真实任务差异抹掉。',
    '先画共同空间骨架，再叠加人物任务路线，可以区分事实与路线偏好。',
    'Lv9: Hãy dựng khung không gian chung trước rồi chồng tuyến nhiệm vụ của từng người lên trên để phân biệt sự thật không gian với ưu tiên tuyến.',
    'Lv9: Build the shared spatial framework first, then layer each person’s task route on top to distinguish spatial facts from route preferences.',
  ),
  _discovery(
    'Lv10 的迁移标准不是“保留所有路线”，而是写清每条路线成立的条件。面对一个新任务，应同时检验建筑连接、人物目标与行动后果：空间上走不通的路线应排除；能走通但不服务任务的路线也不能自动成为最佳选择。',
    '新情境要同时看空间连接、人物目标和行动后果，并说明每条路线凭什么成立。',
    'Lv10: Trong tình huống mới, cần xét đồng thời kết nối kiến trúc, mục tiêu nhân vật và hệ quả hành động, rồi nêu rõ điều kiện khiến mỗi tuyến đứng vững.',
    'Lv10: In a new situation, test architectural connections, character goals, and action consequences together, and state the conditions under which each route is justified.',
  ),
];

List<DiscoveryEntry> _discoveriesForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final focus = forbiddenCityDiscoveryFocusByLevel[safeLevel - 1];
  final grounding = switch (safeLevel) {
    1 || 2 => forbiddenCityDiscoveries[0],
    3 || 4 => forbiddenCityDiscoveries[1],
    5 || 6 => forbiddenCityDiscoveries[2],
    7 || 8 => forbiddenCityDiscoveries[3],
    _ => forbiddenCityDiscoveries[4],
  };
  return <DiscoveryEntry>[focus, grounding];
}
'''
count = text.count(old)
if count != 1:
    raise SystemExit(f'discovery function: expected one match, got {count}')
RUNTIME.write_text(text.replace(old, new, 1), encoding='utf-8')
SELF.unlink()
print('FORBIDDEN CITY TEN-LEVEL DISCOVERY PATCH APPLIED')
