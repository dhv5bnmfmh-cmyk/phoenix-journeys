class JourneyStartupMetadata {
  const JourneyStartupMetadata({
    required this.id,
    required this.city,
    required this.cityCode,
    required this.place,
    required this.distanceLabel,
    required this.geoNodeId,
    required this.stampSymbol,
    required this.headline,
    required this.discoveryTeaser,
  });

  final String id;
  final String city;
  final String cityCode;
  final String place;
  final String distanceLabel;
  final String geoNodeId;
  final String stampSymbol;
  final String headline;
  final String discoveryTeaser;

  String get description => _journeyStartupDescriptions[id] ?? '';

  String get cityId {
    final separator = id.indexOf('-');
    return separator <= 0 ? id : id.substring(0, separator);
  }

  String get destinationId {
    if (id == 'guangzhou-chen-clan-academy') {
      return 'chen-clan-ancestral-hall';
    }
    final separator = id.indexOf('-');
    return separator < 0 || separator == id.length - 1
        ? id
        : id.substring(separator + 1);
  }

  String get locationPath => '$cityId/$destinationId';
}

const Map<String, String> _journeyStartupDescriptions = <String, String>{
  'beijing-forbidden-city': '跟随沈砚与阿宁对照两条不同路线，在共同节点看见宫殿空间怎样因身份与目的而改变。',
  'beijing-summer-palace': '冬至前后的十七孔桥光线和一张旧照片，把许澄与外婆周岚推入一次不可兼得的选择。',
  'shanghai-bund': '母亲在外滩把外祖父的旧提单交给林岸；过江以后，他不再把上海分成互不相干的过去与未来。',
  'xian-city-wall': '搬家前，周遥想用最后一圈告别城内生活；跑表越过永宁门后，他把老家与新家留在同一条路线上。',
  'hangzhou-west-lake': '结婚四十三年后，方毓带周绍庭重走断桥；湿石阶上的一个旧动作，让两个人终于拿出藏着的医院预约。',
  'chengdu-kuanzhai-alley': '一把竹椅在茶桌、墙边与门槛之间反复让位；当周叔自己把它移开，共享节奏不再只靠林夏维持。',
  'nanjing-qinhuai-river': '秦淮灯会开场前发生故障，魏舟拒绝未经确认的临时改线，让主要路线安全亮起，也让一段装饰灯继续黑着。',
  'guangzhou-chen-clan-academy': '陈秀仪第一次单独见到如今叫刘嘉禾的亲生女儿；亲戚的视频打来后，她必须决定这次见面属于谁。',
  'jiangmen-kaiping-diaolou': '人物、家书与具体建楼选择为虚构；碉楼类型、侨乡联系与建筑融合机制依据 UNESCO 与开平官方资料。',
  'suzhou-humble-administrators-garden': '外婆第一次让十二岁的外孙走在前面，在拙政园一次次消失又重现的视线里学着不再把他喊回来。',
  'luoyang-longmen-grottoes': '在龙门石窟的题记、残损现状与有据复原之间，做一次不替历史补空白的选择。',
  'quanzhou-kaiyuan-temple': '从开元寺双塔出发，寻找宋元泉州连接世界的城市痕迹。',
  'datong-yungang-grottoes': '迁都后的云冈，一位虚构女石工割开父亲留下的长墨绳，也割开“唯一传人”的安排。',
  'lijiang-old-town': '清末丽江，虚构商贩和清在四方街散市后的火情里割断姐弟共同货物的捆绳，让桥下古城水系真正进入人的选择与代价。',
  'dunhuang-mogao-caves': '沿宕泉河与崖壁理解洞窟艺术、丝路交流和现代保护。',
  'chengde-mountain-resort': '沿湖泊与山峦观察皇家园林如何连接自然、多民族文化和保护。',
  'xiamen-kulangsu': '穿过榕树与石阶，读懂海岛建筑、国际交往和生活社区。',
  'pingyao-ancient-city': '跟随程砚在票号、银箱与两本账之间，看异地汇兑怎样改变人的在场与责任。',
  'qufu-confucius-sites': '观察孔庙、孔府与孔林如何连接思想、教育和家族记忆。',
  'leshan-giant-buddha': '从江面观察七十一米石刻、隐蔽排水和现代保护。',
  'wuyishan-nine-bend-stream': '沿九曲溪认识丹霞森林、生物多样性与朱子文化。',
  'honghe-hani-rice-terraces': '当代元阳春灌前夕，虚构赶沟人罗秋发现朋友私自削宽木刻分水槽。她恢复共同议定的水份额，也承担朋友收回水牛、自己的最后一块田当天无法犁完的私人代价。',
  'huangshan-cloud-peaks': '穿过花岗岩峰、黄山松与云海，理解壮阔景观背后的脆弱生态。',
  'zhangjiajie-wulingyuan': '在石英砂岩峰柱、峡谷和森林之间，阅读亿万年的地貌变化。',
  'kaifeng-song-capital': '从街市、河道、考古与现代演绎之间，理解北宋都城。',
  'dali-cangshan-erhai': '连接白族古城、苍山与洱海，理解文化生活和湖泊生态。',
  'harbin-central-street': '沿面包石和历史建筑，理解铁路、迁移与东北城市文化交融。',
};

const List<JourneyStartupMetadata> journeyStartupMetadata =
    <JourneyStartupMetadata>[
  JourneyStartupMetadata(
    id: 'beijing-forbidden-city', city: '北京', cityCode: 'PEK', place: '紫禁城',
    distanceLabel: '1,670 km', geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
    stampSymbol: '宫', headline: '沈砚要让两条都走得通的路留在同一张图上',
    discoveryTeaser: '中轴、宫门与内外朝怎样共同组织紫禁城里的不同路线？',
  ),
  JourneyStartupMetadata(
    id: 'beijing-summer-palace', city: '北京', cityCode: 'PEK', place: '颐和园',
    distanceLabel: '1,670 km', geoNodeId: 'cn-beijing-haidian-summer-palace',
    stampSymbol: '园', headline: '许澄必须决定镜头里要留下什么',
    discoveryTeaser: '十七孔桥的季节光线、湖桥关系与修复历史为什么不能分开看？',
  ),
  JourneyStartupMetadata(
    id: 'shanghai-bund', city: '上海', cityCode: 'SHA', place: '外滩',
    distanceLabel: '1,900 km', geoNodeId: 'cn-shanghai-huangpu-bund',
    stampSymbol: '滩', headline: '林岸带着一张旧提单走向新职业',
    discoveryTeaser: '外滩、黄浦江航运与浦东金融活动怎样延续上海组织流动的方式？',
  ),
  JourneyStartupMetadata(
    id: 'xian-city-wall', city: '西安', cityCode: 'XIY', place: '城墙',
    distanceLabel: '1,490 km', geoNodeId: 'cn-shaanxi-xian-city-wall',
    stampSymbol: '城', headline: '周遥跑完整圈，却没有在永宁门停下',
    discoveryTeaser: '城墙的闭合防御环线怎样在今天连接保护、运动与城内外生活？',
  ),
  JourneyStartupMetadata(
    id: 'hangzhou-west-lake', city: '杭州', cityCode: 'HGH', place: '西湖',
    distanceLabel: '1,760 km', geoNodeId: 'cn-zhejiang-hangzhou-west-lake',
    stampSymbol: '湖', headline: '方毓把一次西湖散步变成了不敢说破的记忆测试',
    discoveryTeaser: '“断桥残雪”这类题名景观，怎样把地点、季节与观看条件连在一起？',
  ),
  JourneyStartupMetadata(
    id: 'chengdu-kuanzhai-alley', city: '成都', cityCode: 'CTU', place: '宽窄巷子',
    distanceLabel: '1,020 km', geoNodeId: 'cn-sichuan-chengdu-kuanzhai',
    stampSymbol: '巷', headline: '林夏要让停留与通行都在院落里有位置',
    discoveryTeaser: '为什么这里既是古街，也是现代生活空间？',
  ),
  JourneyStartupMetadata(
    id: 'nanjing-qinhuai-river', city: '南京', cityCode: 'NKG', place: '秦淮河',
    distanceLabel: '1,860 km', geoNodeId: 'cn-jiangsu-nanjing-qinhuai',
    stampSymbol: '淮', headline: '七分钟里，魏舟必须决定什么不能抢着修好',
    discoveryTeaser: '秦淮河岸、古桥与灯会照明为什么同时受到风貌保护和安全管理约束？',
  ),
  JourneyStartupMetadata(
    id: 'guangzhou-chen-clan-academy', city: '广州', cityCode: 'CAN', place: '陈家祠',
    distanceLabel: '820 km', geoNodeId: 'cn-guangdong-guangzhou-chen-clan',
    stampSymbol: '艺', headline: '一张迟到三十四年的合照，要不要拍',
    discoveryTeaser: '为什么“陈氏书院”由广东各地陈姓宗族共同兴建，又同时具有合族祠与书院功能？',
  ),
  JourneyStartupMetadata(
    id: 'jiangmen-kaiping-diaolou', city: '江门', cityCode: 'JMN', place: '开平碉楼与村落',
    distanceLabel: '', geoNodeId: 'cn-guangdong-jiangmen-kaiping-zili-village',
    stampSymbol: '碉', headline: '一张从海外寄回的图，要不要原样盖进村里？',
    discoveryTeaser: '众楼、居楼、更楼为什么不能混成一种“华侨豪宅”？海外经验又怎样在开平被重新组合？',
  ),
  JourneyStartupMetadata(
    id: 'suzhou-humble-administrators-garden', city: '苏州', cityCode: 'SZV', place: '拙政园',
    distanceLabel: '1,820 km', geoNodeId: 'cn-jiangsu-suzhou-gusu-humble-administrators-garden',
    stampSymbol: '园', headline: '下一处等我',
    discoveryTeaser: '长廊、建筑转折与池水开合怎样让园中视线时而隐藏、时而重新出现？',
  ),
  JourneyStartupMetadata(
    id: 'luoyang-longmen-grottoes', city: '洛阳', cityCode: 'LYA', place: '龙门石窟',
    distanceLabel: '1,470 km', geoNodeId: 'cn-henan-luoyang-luolong-longmen-grottoes',
    stampSymbol: '石', headline: '当“看起来完整”没有证据',
    discoveryTeaser: '一块石面上的题记、残损与旧照片，为什么必须分成不同证据层？',
  ),
  JourneyStartupMetadata(
    id: 'quanzhou-kaiyuan-temple', city: '泉州', cityCode: 'JJN', place: '开元寺',
    distanceLabel: '1,250 km', geoNodeId: 'cn-fujian-quanzhou-licheng-kaiyuan-temple',
    stampSymbol: '海', headline: '从双塔读懂海洋商贸之城',
    discoveryTeaser: '为什么一座寺院能讲述古代国际港口的故事？',
  ),
  JourneyStartupMetadata(
    id: 'datong-yungang-grottoes', city: '大同', cityCode: 'DAT', place: '云冈石窟',
    distanceLabel: '1,620 km', geoNodeId: 'cn-shanxi-datong-yungang-yungang-grottoes',
    stampSymbol: '云', headline: '巨像停下以后，谁还能继续',
    discoveryTeaser: '迁都洛阳以后，云冈为什么没有立刻停止开窟造像？',
  ),
  JourneyStartupMetadata(
    id: 'lijiang-old-town', city: '丽江', cityCode: 'LJG', place: '大研古城',
    distanceLabel: '1,460 km', geoNodeId: 'cn-yunnan-lijiang-gucheng-dayan-old-town',
    stampSymbol: '水', headline: '一驮茶堵住桥时，他割掉了两个人的本钱',
    discoveryTeaser: '丽江古城为什么让街、桥、市场和水同时成为一套生活系统？',
  ),
  JourneyStartupMetadata(
    id: 'dunhuang-mogao-caves', city: '敦煌', cityCode: 'DNH', place: '莫高窟',
    distanceLabel: '2,100 km', geoNodeId: 'cn-gansu-jiuquan-dunhuang-mogao-caves',
    stampSymbol: '敦', headline: '在沙漠崖壁读一千年',
    discoveryTeaser: '为什么莫高窟多用泥塑与壁画，而不是直接雕刻？',
  ),
  JourneyStartupMetadata(
    id: 'chengde-mountain-resort', city: '承德', cityCode: 'CDE', place: '避暑山庄',
    distanceLabel: '1,770 km', geoNodeId: 'cn-hebei-chengde-shuangqiao-mountain-resort',
    stampSymbol: '山', headline: '让建筑藏进山水',
    discoveryTeaser: '为什么山庄的宫殿没有压过山水？',
  ),
  JourneyStartupMetadata(
    id: 'xiamen-kulangsu', city: '厦门', cityCode: 'XMN', place: '鼓浪屿',
    distanceLabel: '390 km', geoNodeId: 'cn-fujian-xiamen-siming-kulangsu',
    stampSymbol: '岛', headline: '沿海风阅读国际社区',
    discoveryTeaser: '为什么鼓浪屿的建筑很难归入单一风格？',
  ),
  JourneyStartupMetadata(
    id: 'pingyao-ancient-city', city: '平遥', cityCode: 'PYG', place: '平遥古城',
    distanceLabel: '1,660 km', geoNodeId: 'cn-shanxi-jinzhong-pingyao-ancient-city',
    stampSymbol: '票', headline: '一张汇票让谁留下',
    discoveryTeaser: '银子没有上路，远方为什么仍能兑付？',
  ),
  JourneyStartupMetadata(
    id: 'qufu-confucius-sites', city: '曲阜', cityCode: 'JNG', place: '孔庙',
    distanceLabel: '1,690 km', geoNodeId: 'cn-shandong-jining-qufu-confucius-temple',
    stampSymbol: '礼', headline: '沿中轴读懂礼与学',
    discoveryTeaser: '为什么思想需要建筑和礼仪来传播？',
  ),
  JourneyStartupMetadata(
    id: 'leshan-giant-buddha', city: '乐山', cityCode: 'LSS', place: '乐山大佛',
    distanceLabel: '1,210 km', geoNodeId: 'cn-sichuan-leshan-shizhong-giant-buddha',
    stampSymbol: '佛', headline: '三江与石刻的千年守望',
    discoveryTeaser: '大佛的发髻和衣纹为什么也参与排水？',
  ),
  JourneyStartupMetadata(
    id: 'wuyishan-nine-bend-stream', city: '武夷山', cityCode: 'WUS', place: '九曲溪',
    distanceLabel: '650 km', geoNodeId: 'cn-fujian-nanping-wuyishan-nine-bend-stream',
    stampSymbol: '曲', headline: '山水之间的理学回声',
    discoveryTeaser: '为什么一条溪流能同时承载自然与思想史？',
  ),
  JourneyStartupMetadata(
    id: 'honghe-hani-rice-terraces', city: '红河', cityCode: 'HHE', place: '哈尼梯田',
    distanceLabel: '680 km', geoNodeId: 'cn-yunnan-honghe-yuanyang-hani-terraces',
    stampSymbol: '田', headline: '她把水分回原来的宽度，也失去了今天借来的牛',
    discoveryTeaser: '森林、村寨、沟渠和梯田为什么必须作为一套水系统一起理解？',
  ),
  JourneyStartupMetadata(
    id: 'huangshan-cloud-peaks', city: '黄山', cityCode: 'HSG', place: '黄山风景区',
    distanceLabel: '1,120 km', geoNodeId: 'cn-anhui-huangshan-scenic-area',
    stampSymbol: '云', headline: '在岩缝与云层之间',
    discoveryTeaser: '为什么离开一步步道，也可能伤害百年古松？',
  ),
  JourneyStartupMetadata(
    id: 'zhangjiajie-wulingyuan', city: '张家界', cityCode: 'DYG', place: '武陵源',
    distanceLabel: '860 km', geoNodeId: 'cn-hunan-zhangjiajie-wulingyuan-scenic-area',
    stampSymbol: '峰', headline: '穿过三千峰柱',
    discoveryTeaser: '笔直峰柱是怎样从完整岩层中分离出来的？',
  ),
  JourneyStartupMetadata(
    id: 'kaifeng-song-capital', city: '开封', cityCode: 'KFS', place: '宋都古城',
    distanceLabel: '1,620 km', geoNodeId: 'cn-henan-kaifeng-song-capital',
    stampSymbol: '宋', headline: '在叠城中寻找东京',
    discoveryTeaser: '为什么开封的旧城会一层一层埋在地下？',
  ),
  JourneyStartupMetadata(
    id: 'dali-cangshan-erhai', city: '大理', cityCode: 'DLU', place: '苍山洱海古城',
    distanceLabel: '590 km', geoNodeId: 'cn-yunnan-dali-ancient-city',
    stampSymbol: '洱', headline: '山城湖的共同呼吸',
    discoveryTeaser: '为什么洱海不能只被当作旅行背景？',
  ),
  JourneyStartupMetadata(
    id: 'harbin-central-street', city: '哈尔滨', cityCode: 'HRB', place: '中央大街',
    distanceLabel: '2,760 km', geoNodeId: 'cn-heilongjiang-harbin-daoli-central-street',
    stampSymbol: '冰', headline: '冰雪里的建筑记忆',
    discoveryTeaser: '为什么修好一面外墙，还不等于保护一座建筑？',
  ),
];

final Map<String, JourneyStartupMetadata> _journeyStartupMetadataById =
    <String, JourneyStartupMetadata>{
  for (final metadata in journeyStartupMetadata) metadata.id: metadata,
};

JourneyStartupMetadata? journeyStartupMetadataById(String journeyId) =>
    _journeyStartupMetadataById[journeyId];

JourneyStartupMetadata requireJourneyStartupMetadata(String journeyId) {
  final metadata = journeyStartupMetadataById(journeyId);
  if (metadata == null) {
    throw StateError('Journey startup metadata is not registered: "$journeyId".');
  }
  return metadata;
}

class JourneyStartupCityMetadata {
  const JourneyStartupCityMetadata({
    required this.id,
    required this.name,
    required this.cityCode,
    required this.destinations,
  });

  final String id;
  final String name;
  final String cityCode;
  final List<JourneyStartupMetadata> destinations;

  int get destinationCount => destinations.length;
  JourneyStartupMetadata get primaryDestination => destinations.first;
}

final List<JourneyStartupCityMetadata> journeyStartupCityCatalog =
    _buildJourneyStartupCityCatalog();

List<JourneyStartupCityMetadata> _buildJourneyStartupCityCatalog() {
  final cityOrder = <String>[];
  final grouped = <String, List<JourneyStartupMetadata>>{};
  for (final metadata in journeyStartupMetadata) {
    grouped.putIfAbsent(metadata.cityId, () {
      cityOrder.add(metadata.cityId);
      return <JourneyStartupMetadata>[];
    }).add(metadata);
  }
  return List<JourneyStartupCityMetadata>.unmodifiable(
    cityOrder.map((cityId) {
      final destinations = List<JourneyStartupMetadata>.unmodifiable(
        grouped[cityId]!,
      );
      final primary = destinations.first;
      return JourneyStartupCityMetadata(
        id: cityId,
        name: primary.city,
        cityCode: primary.cityCode,
        destinations: destinations,
      );
    }),
  );
}

JourneyStartupCityMetadata requireJourneyStartupCity(String cityId) {
  for (final city in journeyStartupCityCatalog) {
    if (city.id == cityId) return city;
  }
  throw StateError('Journey startup city is not registered: "$cityId".');
}
