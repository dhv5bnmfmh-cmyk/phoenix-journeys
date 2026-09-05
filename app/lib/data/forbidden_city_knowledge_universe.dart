import '../models/knowledge_universe.dart';
import 'beijing_city_standard.dart';

const knowledgePlaceChina = 'place.china';
const knowledgePlaceBeijing = 'place.beijing';
const knowledgePlaceForbiddenCity = 'place.beijing.forbidden_city';
const knowledgePlaceMeridianGate = 'place.beijing.forbidden_city.meridian_gate';
const knowledgePlaceQianqingGate = 'place.beijing.forbidden_city.qianqing_gate';
const knowledgePlaceJingyunGate = 'place.beijing.forbidden_city.jingyun_gate';
const knowledgePlaceCentralAxis = 'place.beijing.central_axis';
const knowledgePlaceOuterCourt = 'place.beijing.forbidden_city.outer_court';
const knowledgePlaceInnerCourt = 'place.beijing.forbidden_city.inner_court';

const knowledgePeriodMing = 'period.ming';
const knowledgePeriodQing = 'period.qing';
const knowledgePeriodModern = 'period.modern_china';

const knowledgeProfessionArchitecture = 'profession.architecture';
const knowledgeProfessionHeritageConservation =
    'profession.heritage_conservation';
const knowledgeProfessionMedicine = 'profession.medicine';
const knowledgeProfessionManufacturing = 'profession.manufacturing';
const knowledgeProfessionEducation = 'profession.education';
const knowledgeProfessionTechnology = 'profession.technology';

const knowledgeCultureArchitecture = 'culture.architecture';
const knowledgeCultureRitual = 'culture.ritual';
const knowledgeCultureSocialPractice = 'culture.social_practice';

const knowledgeRoleEmperor = 'role.emperor';
const knowledgeRoleOfficial = 'role.official';
const knowledgeRoleArtisan = 'role.artisan';
const knowledgeRoleDoctor = 'role.doctor';
const knowledgeRoleStudent = 'role.student';
const knowledgeRoleGuard = 'role.guard';
const knowledgeRoleRestorationWorker = 'role.restoration_worker';
const knowledgeRoleEngineer = 'role.engineer';
const knowledgeRoleOrdinaryResident = 'role.ordinary_resident';

const knowledgePracticeOuterCourtUse =
    'practice.outer_court_ceremonial_government';

const kuForbiddenCityMingQing = 'ku.forbidden_city.ming_qing_palace';
const kuMeridianGateAxis = 'ku.forbidden_city.meridian_gate_axis';
const kuQianqingGateCourts = 'ku.forbidden_city.qianqing_gate_courts';
const kuJingyunGateEast = 'ku.forbidden_city.jingyun_gate_east';
const kuCentralAxisSequence = 'ku.forbidden_city.central_axis_sequence';
const kuOuterInnerCourtFunctions =
    'ku.forbidden_city.outer_inner_court_functions';

const forbiddenCityKnowledgeSources = <KnowledgeSource>[
  KnowledgeSource(
    sourceRef: forbiddenCityDpmSourceRef,
    label: '故宫博物院',
    publisher: '故宫博物院',
    url: forbiddenCityDpmSourceRef,
    authorityType: KnowledgeAuthorityType.museum,
  ),
  KnowledgeSource(
    sourceRef: forbiddenCityMeridianGateSourceRef,
    label: '故宫博物院 · 午门',
    publisher: '故宫博物院',
    url: forbiddenCityMeridianGateSourceRef,
    authorityType: KnowledgeAuthorityType.museum,
  ),
  KnowledgeSource(
    sourceRef: forbiddenCityQianqingGateSourceRef,
    label: '故宫博物院 · 乾清门',
    publisher: '故宫博物院',
    url: forbiddenCityQianqingGateSourceRef,
    authorityType: KnowledgeAuthorityType.museum,
  ),
  KnowledgeSource(
    sourceRef: forbiddenCityJingyunGateSourceRef,
    label: '故宫博物院 · 景运门',
    publisher: '故宫博物院',
    url: forbiddenCityJingyunGateSourceRef,
    authorityType: KnowledgeAuthorityType.museum,
  ),
  KnowledgeSource(
    sourceRef: forbiddenCityAxisPlanSourceRef,
    label: '北京市官方中轴资料',
    publisher: '北京市人民政府',
    url: forbiddenCityAxisPlanSourceRef,
    authorityType: KnowledgeAuthorityType.government,
  ),
  KnowledgeSource(
    sourceRef: forbiddenCityUnescoSourceRef,
    label: 'UNESCO',
    publisher: 'UNESCO World Heritage Centre',
    url: forbiddenCityUnescoSourceRef,
    authorityType: KnowledgeAuthorityType.unesco,
  ),
];

const forbiddenCityKnowledgePeriods = <HistoricalPeriod>[
  HistoricalPeriod(
    id: knowledgePeriodMing,
    name: '明代',
    description: '明代历史时期。V1 不要求所有时期都绑定精确起止年份。',
    chronologyNote:
        'Exact chronology may be added when a canonical chronology source is bound.',
  ),
  HistoricalPeriod(
    id: knowledgePeriodQing,
    name: '清代',
    description: '清代历史时期。V1 不要求所有时期都绑定精确起止年份。',
    chronologyNote:
        'Exact chronology may be added when a canonical chronology source is bound.',
  ),
  HistoricalPeriod(
    id: knowledgePeriodModern,
    name: '现代中国',
    description: '用于当代职业、保护、学习与社会生活语境。',
  ),
];

const forbiddenCityKnowledgePlaces = <PlaceNode>[
  PlaceNode(
    id: knowledgePlaceChina,
    nameZh: '中国',
    nameEn: 'China',
    type: PlaceNodeType.country,
  ),
  PlaceNode(
    id: knowledgePlaceBeijing,
    nameZh: '北京',
    nameEn: 'Beijing',
    type: PlaceNodeType.city,
    parentId: knowledgePlaceChina,
    sourceRefs: <String>[forbiddenCityAxisPlanSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceForbiddenCity,
    nameZh: '紫禁城',
    nameEn: 'Forbidden City',
    type: PlaceNodeType.site,
    parentId: knowledgePlaceBeijing,
    aliases: <String>['故宫'],
    periodRefs: <String>[knowledgePeriodMing, knowledgePeriodQing],
    sourceRefs: <String>[
      forbiddenCityDpmSourceRef,
      forbiddenCityUnescoSourceRef,
    ],
  ),
  PlaceNode(
    id: knowledgePlaceMeridianGate,
    nameZh: '午门',
    nameEn: 'Meridian Gate',
    type: PlaceNodeType.gate,
    parentId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityMeridianGateSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceQianqingGate,
    nameZh: '乾清门',
    nameEn: 'Gate of Heavenly Purity',
    type: PlaceNodeType.gate,
    parentId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceJingyunGate,
    nameZh: '景运门',
    nameEn: 'Jingyun Gate',
    type: PlaceNodeType.gate,
    parentId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityJingyunGateSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceCentralAxis,
    nameZh: '北京中轴线',
    nameEn: 'Beijing Central Axis',
    type: PlaceNodeType.spatialFeature,
    parentId: knowledgePlaceBeijing,
    sourceRefs: <String>[forbiddenCityAxisPlanSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceOuterCourt,
    nameZh: '外朝',
    nameEn: 'Outer Court',
    type: PlaceNodeType.area,
    parentId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
  PlaceNode(
    id: knowledgePlaceInnerCourt,
    nameZh: '内廷',
    nameEn: 'Inner Court',
    type: PlaceNodeType.area,
    parentId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
];

const forbiddenCityKnowledgeProfessions = <Profession>[
  Profession(
    id: knowledgeProfessionArchitecture,
    nameZh: '建筑',
    nameEn: 'Architecture',
    industry: 'architecture',
  ),
  Profession(
    id: knowledgeProfessionHeritageConservation,
    nameZh: '遗产保护',
    nameEn: 'Heritage conservation',
    industry: 'heritage conservation',
  ),
  Profession(
    id: knowledgeProfessionMedicine,
    nameZh: '医药',
    nameEn: 'Medicine',
    industry: 'medicine',
  ),
  Profession(
    id: knowledgeProfessionManufacturing,
    nameZh: '制造业',
    nameEn: 'Manufacturing',
    industry: 'manufacturing',
  ),
  Profession(
    id: knowledgeProfessionEducation,
    nameZh: '教育',
    nameEn: 'Education',
    industry: 'education',
  ),
  Profession(
    id: knowledgeProfessionTechnology,
    nameZh: '科技',
    nameEn: 'Technology',
    industry: 'technology',
  ),
];

const forbiddenCityKnowledgeCultureTopics = <CultureTopic>[
  CultureTopic(
    id: knowledgeCultureArchitecture,
    nameZh: '建筑文化',
    nameEn: 'Architecture',
    type: 'architecture',
  ),
  CultureTopic(
    id: knowledgeCultureRitual,
    nameZh: '礼仪',
    nameEn: 'Ritual',
    type: 'ritual',
  ),
  CultureTopic(
    id: knowledgeCultureSocialPractice,
    nameZh: '社会实践',
    nameEn: 'Social practice',
    type: 'social practice',
  ),
];

const forbiddenCityKnowledgePersonRoles = <PersonRole>[
  PersonRole(
    id: knowledgeRoleEmperor,
    nameZh: '皇帝',
    nameEn: 'Emperor',
    role: 'emperor',
    socialContext: '历史人物角色，可与具体时期、地点和制度知识组合。',
    periodRefs: <String>[knowledgePeriodMing, knowledgePeriodQing],
    placeRefs: <String>[knowledgePlaceForbiddenCity],
  ),
  PersonRole(
    id: knowledgeRoleOfficial,
    nameZh: '官员',
    nameEn: 'Official',
    role: 'official',
    socialContext: '历史社会角色，具体职责必须由 KnowledgeUnit 与来源约束。',
  ),
  PersonRole(
    id: knowledgeRoleArtisan,
    nameZh: '工匠',
    nameEn: 'Artisan',
    role: 'artisan',
    socialContext: '工艺与建造角色；V1 不假定具体人物。',
    professionRefs: <String>[knowledgeProfessionArchitecture],
  ),
  PersonRole(
    id: knowledgeRoleDoctor,
    nameZh: '医生',
    nameEn: 'Doctor',
    role: 'doctor',
    socialContext: '古今医疗角色，可由时期与地点进一步限定。',
    professionRefs: <String>[knowledgeProfessionMedicine],
  ),
  PersonRole(
    id: knowledgeRoleStudent,
    nameZh: '学生',
    nameEn: 'Student',
    role: 'student',
    socialContext: '学习者角色。',
    professionRefs: <String>[knowledgeProfessionEducation],
  ),
  PersonRole(
    id: knowledgeRoleGuard,
    nameZh: '守卫',
    nameEn: 'Guard',
    role: 'guard',
    socialContext: '安保或历史守卫角色，具体制度事实需另有来源。',
  ),
  PersonRole(
    id: knowledgeRoleRestorationWorker,
    nameZh: '文物建筑修缮人员',
    nameEn: 'Heritage restoration worker',
    role: 'restoration worker',
    socialContext: '现代遗产保护职业角色。',
    periodRefs: <String>[knowledgePeriodModern],
    placeRefs: <String>[knowledgePlaceForbiddenCity],
    professionRefs: <String>[knowledgeProfessionHeritageConservation],
  ),
  PersonRole(
    id: knowledgeRoleEngineer,
    nameZh: '工程师',
    nameEn: 'Engineer',
    role: 'engineer',
    socialContext: '现代技术与工程职业角色。',
    professionRefs: <String>[knowledgeProfessionTechnology],
  ),
  PersonRole(
    id: knowledgeRoleOrdinaryResident,
    nameZh: '普通居民',
    nameEn: 'Ordinary resident',
    role: 'ordinary resident',
    socialContext: '用于真实社会生活 Journey 的普通人物角色。',
  ),
];

const forbiddenCityKnowledgeEvents = <EventPractice>[
  EventPractice(
    id: knowledgePracticeOuterCourtUse,
    nameZh: '外朝典礼与政务使用',
    nameEn: 'Outer Court ceremonial and government use',
    type: 'historical social practice',
    placeRefs: <String>[knowledgePlaceOuterCourt],
    periodRefs: <String>[knowledgePeriodMing, knowledgePeriodQing],
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
];

const forbiddenCityKnowledgeUnits = <KnowledgeUnit>[
  KnowledgeUnit(
    id: kuForbiddenCityMingQing,
    claim: '紫禁城位于北京，是明清两代皇宫建筑群。',
    simpleChinese: '紫禁城在北京，是明清皇宫。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
    ],
    periodRefs: <String>[knowledgePeriodMing, knowledgePeriodQing],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[knowledgeCultureArchitecture],
    sourceRefs: <String>[
      forbiddenCityDpmSourceRef,
      forbiddenCityUnescoSourceRef,
    ],
    tags: <String>['palace', 'heritage', 'beijing'],
  ),
  KnowledgeUnit(
    id: kuMeridianGateAxis,
    claim: '午门是紫禁城正门，位于紫禁城南北轴线上。',
    simpleChinese: '午门是紫禁城正门，也在中轴线上。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
      knowledgePlaceMeridianGate,
      knowledgePlaceCentralAxis,
    ],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[knowledgeCultureArchitecture],
    sourceRefs: <String>[
      forbiddenCityMeridianGateSourceRef,
      forbiddenCityAxisPlanSourceRef,
    ],
    tags: <String>['gate', 'central-axis', 'entrance'],
  ),
  KnowledgeUnit(
    id: kuQianqingGateCourts,
    claim: '乾清门为内廷正宫门，也是连接内廷与外朝往来的重要通道。',
    simpleChinese: '乾清门是内廷正门，也是外朝和内廷的重要通道。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
      knowledgePlaceQianqingGate,
      knowledgePlaceOuterCourt,
      knowledgePlaceInnerCourt,
    ],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[
      knowledgeCultureArchitecture,
      knowledgeCultureSocialPractice,
    ],
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
    tags: <String>['gate', 'outer-court', 'inner-court', 'connection'],
  ),
  KnowledgeUnit(
    id: kuJingyunGateEast,
    claim: '景运门位于乾清门前广场东侧，是进入这一广场的重要门户之一。',
    simpleChinese: '景运门在乾清门前广场东侧。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
      knowledgePlaceQianqingGate,
      knowledgePlaceJingyunGate,
    ],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[knowledgeCultureArchitecture],
    sourceRefs: <String>[forbiddenCityJingyunGateSourceRef],
    tags: <String>['gate', 'east', 'spatial-connection'],
  ),
  KnowledgeUnit(
    id: kuCentralAxisSequence,
    claim: '紫禁城中轴上的宫门、院落与主要建筑形成清晰的南北空间序列。',
    simpleChinese: '紫禁城中轴上的门、院落和建筑有清楚的南北顺序。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
      knowledgePlaceCentralAxis,
    ],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[knowledgeCultureArchitecture],
    sourceRefs: <String>[forbiddenCityAxisPlanSourceRef],
    tags: <String>['central-axis', 'spatial-order'],
  ),
  KnowledgeUnit(
    id: kuOuterInnerCourtFunctions,
    claim: '紫禁城通常以外朝与内廷作为重要功能框架；外朝与重大典礼、政务关系密切，内廷与帝后生活关系更密切。',
    simpleChinese: '外朝和内廷功能不同：外朝更接近典礼政务，内廷更接近帝后生活。',
    status: KnowledgeStatus.verified,
    placeRefs: <String>[
      knowledgePlaceBeijing,
      knowledgePlaceForbiddenCity,
      knowledgePlaceOuterCourt,
      knowledgePlaceInnerCourt,
    ],
    periodRefs: <String>[knowledgePeriodMing, knowledgePeriodQing],
    professionRefs: <String>[knowledgeProfessionArchitecture],
    cultureRefs: <String>[
      knowledgeCultureArchitecture,
      knowledgeCultureRitual,
      knowledgeCultureSocialPractice,
    ],
    eventRefs: <String>[knowledgePracticeOuterCourtUse],
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
    tags: <String>['outer-court', 'inner-court', 'function'],
  ),
];

const forbiddenCityKnowledgeRelations = <KnowledgeRelation>[
  KnowledgeRelation(
    fromId: knowledgePlaceBeijing,
    type: KnowledgeRelationTypes.locatedIn,
    toId: knowledgePlaceChina,
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceForbiddenCity,
    type: KnowledgeRelationTypes.locatedIn,
    toId: knowledgePlaceBeijing,
    sourceRefs: <String>[forbiddenCityDpmSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceMeridianGate,
    type: KnowledgeRelationTypes.locatedIn,
    toId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityMeridianGateSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceQianqingGate,
    type: KnowledgeRelationTypes.locatedIn,
    toId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceJingyunGate,
    type: KnowledgeRelationTypes.locatedIn,
    toId: knowledgePlaceForbiddenCity,
    sourceRefs: <String>[forbiddenCityJingyunGateSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceForbiddenCity,
    type: KnowledgeRelationTypes.alignedWith,
    toId: knowledgePlaceCentralAxis,
    sourceRefs: <String>[forbiddenCityAxisPlanSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceQianqingGate,
    type: KnowledgeRelationTypes.connects,
    toId: knowledgePlaceOuterCourt,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgePlaceQianqingGate,
    type: KnowledgeRelationTypes.connects,
    toId: knowledgePlaceInnerCourt,
    sourceRefs: <String>[forbiddenCityQianqingGateSourceRef],
  ),
  KnowledgeRelation(
    fromId: knowledgeRoleArtisan,
    type: KnowledgeRelationTypes.worksIn,
    toId: knowledgeProfessionArchitecture,
  ),
  KnowledgeRelation(
    fromId: knowledgeRoleRestorationWorker,
    type: KnowledgeRelationTypes.worksIn,
    toId: knowledgeProfessionHeritageConservation,
  ),
];

const forbiddenCityStorySeeds = <StorySeed>[
  StorySeed(
    id: 'seed.forbidden_city.modern_restoration_route',
    placeRef: knowledgePlaceForbiddenCity,
    periodRef: knowledgePeriodModern,
    characterRoleRef: knowledgeRoleRestorationWorker,
    professionRef: knowledgeProfessionHeritageConservation,
    goal: '核对宫门与空间关系，为修缮记录准备一张可追溯的现场路线图。',
    conflict: '常用观察路线与任务路线不同，需要用可验证知识决定记录顺序。',
    knowledgeUnitRefs: <String>[
      kuMeridianGateAxis,
      kuQianqingGateCourts,
      kuJingyunGateEast,
      kuCentralAxisSequence,
    ],
    languageLevel: 5,
    learningFocus: <String>['空间关系', '宫门', '中轴', '证据与判断'],
  ),
];

final forbiddenCityKnowledgeUniverse = KnowledgeUniverseRepository(
  sources: forbiddenCityKnowledgeSources,
  places: forbiddenCityKnowledgePlaces,
  periods: forbiddenCityKnowledgePeriods,
  personRoles: forbiddenCityKnowledgePersonRoles,
  professions: forbiddenCityKnowledgeProfessions,
  cultureTopics: forbiddenCityKnowledgeCultureTopics,
  events: forbiddenCityKnowledgeEvents,
  knowledgeUnits: forbiddenCityKnowledgeUnits,
  relations: forbiddenCityKnowledgeRelations,
  storySeeds: forbiddenCityStorySeeds,
);
