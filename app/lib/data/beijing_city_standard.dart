import '../models/city_standard.dart';

const beijingCityId = 'beijing';
const chinaCountryId = 'china';
const forbiddenCityPlaceId = 'beijing-forbidden-city';
const forbiddenCityJourney01Id = 'beijing-forbidden-city-journey-01';
const forbiddenCityRuntimeId = 'beijing-forbidden-city';

const _dpm = 'https://www.dpm.org.cn/';
const _meridianGate =
    'https://www.dpm.org.cn/explore/building/236454.html';
const _qianqingGate =
    'https://www.dpm.org.cn/explore/building/236473.html';
const _axisPlan =
    'https://www.beijing.gov.cn/zhengce/zhengcefagui/202309/W020230921615858870431.pdf';
const _unesco = 'https://whc.unesco.org/en/list/439/';

const beijingKnowledgeMap = <CityKnowledgeDomain>[
  CityKnowledgeDomain(
      id: 'beijing.history',
      cityId: beijingCityId,
      title: '历史',
      description: '北京城市形成、都城演变与历史层累。',
      sourceRefs: [_axisPlan],
      placeIds: [forbiddenCityPlaceId],
      journeyIds: [forbiddenCityJourney01Id],
      tags: ['都城', '时间']),
  CityKnowledgeDomain(
      id: 'beijing.geography',
      cityId: beijingCityId,
      title: '地理',
      description: '山水形势、城市区位与空间尺度。',
      sourceRefs: [_axisPlan],
      placeIds: [],
      journeyIds: [],
      tags: ['区位', '空间']),
  CityKnowledgeDomain(
      id: 'beijing.architecture',
      cityId: beijingCityId,
      title: '建筑',
      description: '城市建筑类型、秩序、材料与建造。',
      sourceRefs: [_dpm, _unesco],
      placeIds: [forbiddenCityPlaceId],
      journeyIds: [forbiddenCityJourney01Id],
      tags: ['宫殿', '中轴']),
  CityKnowledgeDomain(
      id: 'beijing.food',
      cityId: beijingCityId,
      title: '饮食',
      description: '北京饮食传统与当代生活。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['饮食']),
  CityKnowledgeDomain(
      id: 'beijing.folk_customs',
      cityId: beijingCityId,
      title: '民俗',
      description: '节令、社区与日常礼俗。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['民俗']),
  CityKnowledgeDomain(
      id: 'beijing.language',
      cityId: beijingCityId,
      title: '语言',
      description: '北京语言使用与表达传统。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['语言']),
  CityKnowledgeDomain(
      id: 'beijing.arts',
      cityId: beijingCityId,
      title: '艺术',
      description: '表演、书画与城市艺术生活。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['艺术']),
  CityKnowledgeDomain(
      id: 'beijing.craft',
      cityId: beijingCityId,
      title: '工艺',
      description: '营造、修复与手工技艺。',
      sourceRefs: [_dpm],
      placeIds: [forbiddenCityPlaceId],
      journeyIds: [forbiddenCityJourney01Id],
      tags: ['营造', '保护']),
  CityKnowledgeDomain(
      id: 'beijing.education',
      cityId: beijingCityId,
      title: '教育',
      description: '教育机构、知识传播与学习生活。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['教育']),
  CityKnowledgeDomain(
      id: 'beijing.technology',
      cityId: beijingCityId,
      title: '科技',
      description: '科研、创新与技术产业。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['科技']),
  CityKnowledgeDomain(
      id: 'beijing.commerce',
      cityId: beijingCityId,
      title: '商业',
      description: '市场、商圈与城市经济。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['商业']),
  CityKnowledgeDomain(
      id: 'beijing.transport',
      cityId: beijingCityId,
      title: '交通',
      description: '道路、公共交通与城市流动。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['交通']),
  CityKnowledgeDomain(
      id: 'beijing.modern_life',
      cityId: beijingCityId,
      title: '现代生活',
      description: '社区、工作与当代城市经验。',
      sourceRefs: [],
      placeIds: [],
      journeyIds: [],
      tags: ['当代']),
];

const chinaReferenceCountry = CountryDefinition(
  countryId: chinaCountryId,
  title: '中国',
  cityIds: [beijingCityId],
  publicationState: PublicationState.reference,
);

const beijingReferenceCity = CityDefinition(
  cityId: beijingCityId,
  countryId: chinaCountryId,
  title: '北京',
  placeIds: [forbiddenCityPlaceId],
  knowledgeDomainIds: [
    'beijing.history',
    'beijing.geography',
    'beijing.architecture',
    'beijing.food',
    'beijing.folk_customs',
    'beijing.language',
    'beijing.arts',
    'beijing.craft',
    'beijing.education',
    'beijing.technology',
    'beijing.commerce',
    'beijing.transport',
    'beijing.modern_life',
  ],
  publicationState: PublicationState.reference,
);

const forbiddenCityPlace = PlaceDefinition(
  placeId: forbiddenCityPlaceId,
  cityId: beijingCityId,
  title: '紫禁城',
  knowledgeDomainIds: [
    'beijing.history',
    'beijing.architecture',
    'beijing.craft'
  ],
  knowledgeAnchors: [
    'history',
    'architecture',
    'imperial_palace',
    'central_axis',
    'court_life',
    'craft',
    'conservation',
    'museum',
    'spatial_reasoning',
  ],
  sourceRefs: [_dpm, _axisPlan, _unesco],
  publicationState: PublicationState.reference,
);

const forbiddenCityJourney01 = JourneyDefinition(
  journeyId: forbiddenCityJourney01Id,
  runtimeId: forbiddenCityRuntimeId,
  cityId: beijingCityId,
  placeId: forbiddenCityPlaceId,
  title: '两条路，一张图',
  theme: '同一真实空间可因任务不同形成不同有效路线；个人视角不能替代空间事实。',
  learningObjective: '区分共同空间证据、人物任务与路线选择。',
  knowledgeDomainIds: [
    'beijing.history',
    'beijing.architecture',
    'beijing.craft'
  ],
  sourceRefs: [_dpm, _axisPlan, _unesco],
  storyIdentity: '沈砚、阿宁、周师傅在午门—中轴—东侧—乾清门前比较两条路线。',
  sceneIds: ['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D'],
  levelPolicy:
      'Lv1-Lv10 share one canonical Journey; only language and reasoning depth change.',
  publicationState: PublicationState.reference,
);

const _assetRoot =
    'assets/journeys/china/beijing/forbidden_city/journey_01/runtime';

const forbiddenCityJourney01Scenes = <JourneySceneDefinition>[
  JourneySceneDefinition(
      sceneId: 'FC01-A',
      cityId: beijingCityId,
      placeId: forbiddenCityPlaceId,
      journeyId: forbiddenCityJourney01Id,
      title: '午门进入',
      storyAnchor: '沈砚第一次进入并形成中轴是标准路线的初步判断。',
      knowledgeAnchors: ['午门', '中轴', '宫城入口'],
      storyBinding: 'semantic-anchor:entry-through-first-observation',
      levelBands: ['Lv1-Lv10'],
      stageBindings: ['story.opening'],
      landscapeAsset: '$_assetRoot/fc01_a_entry_landscape.webp',
      portraitAsset: '$_assetRoot/fc01_a_entry_portrait.webp',
      mobileFocalPoint: (.50, .34),
      desktopFocalPoint: (.64, .42),
      mobileSafeZone:
          SceneSafeZone(left: .08, top: .56, right: .92, bottom: .94),
      desktopSafeZone:
          SceneSafeZone(left: .04, top: .38, right: .48, bottom: .94),
      altText: '晨光中从午门空间进入紫禁城，中央轴线向院落深处延伸。',
      historicalNotes: ['午门是紫禁城南面正门。', '中轴建筑序列向北组织宫门、院落与主要殿宇。'],
      sourceRefs: [_meridianGate, _axisPlan],
      visualVerification: [
        'Meridian Gate spatial threshold',
        'central-axis depth',
        'no readable signage'
      ],
      promptVersion: 'fc01-v1',
      assetVersion: '2026-09-02-v2'),
  JourneySceneDefinition(
      sceneId: 'FC01-B',
      cityId: beijingCityId,
      placeId: forbiddenCityPlaceId,
      journeyId: forbiddenCityJourney01Id,
      title: '中轴与院落',
      storyAnchor: '沈砚沿宫门与院落理解空间层级，并把自己的路线误当标准。',
      knowledgeAnchors: ['宫门序列', '院落', '空间层级'],
      storyBinding: 'semantic-anchor:axis-judgment-before-east-task',
      levelBands: ['Lv1-Lv10'],
      stageBindings: ['story.axis', 'vocabulary'],
      landscapeAsset: '$_assetRoot/fc01_b_axis_landscape.webp',
      portraitAsset: '$_assetRoot/fc01_b_axis_portrait.webp',
      mobileFocalPoint: (.55, .38),
      desktopFocalPoint: (.66, .42),
      mobileSafeZone:
          SceneSafeZone(left: .08, top: .58, right: .92, bottom: .95),
      desktopSafeZone:
          SceneSafeZone(left: .03, top: .38, right: .46, bottom: .94),
      altText: '紫禁城中轴上的宫门与院落逐层向远处展开。',
      historicalNotes: ['中轴由连续门、殿、院落形成可读的建筑序列。'],
      sourceRefs: [_axisPlan],
      visualVerification: [
        'credible gate sequence',
        'human-eye perspective',
        'no palace collage'
      ],
      promptVersion: 'fc01-v1',
      assetVersion: '2026-09-02-v1'),
  JourneySceneDefinition(
      sceneId: 'FC01-C',
      cityId: beijingCityId,
      placeId: forbiddenCityPlaceId,
      journeyId: forbiddenCityJourney01Id,
      title: '东侧任务',
      storyAnchor: '阿宁因东侧记录任务转向侧廊与院落连接，空间开始分流。',
      knowledgeAnchors: ['东路', '侧向连接', '任务路线'],
      storyBinding: 'semantic-anchor:east-task-through-route-conflict',
      levelBands: ['Lv1-Lv10'],
      stageBindings: ['story.east_route', 'discovery'],
      landscapeAsset: '$_assetRoot/fc01_c_east_route_landscape.webp',
      portraitAsset: '$_assetRoot/fc01_c_east_route_portrait.webp',
      mobileFocalPoint: (.60, .42),
      desktopFocalPoint: (.68, .46),
      mobileSafeZone:
          SceneSafeZone(left: .07, top: .58, right: .90, bottom: .95),
      desktopSafeZone:
          SceneSafeZone(left: .03, top: .36, right: .45, bottom: .94),
      altText: '中轴院落旁的侧廊与门洞形成向东转折的真实空间连接。',
      historicalNotes: ['故宫由中路、东路、西路等空间系统共同构成。'],
      sourceRefs: [_axisPlan],
      visualVerification: [
        'axis plus lateral connection',
        'no route overlays',
        'credible turn'
      ],
      promptVersion: 'fc01-v1',
      assetVersion: '2026-09-02-v1'),
  JourneySceneDefinition(
      sceneId: 'FC01-D',
      cityId: beijingCityId,
      placeId: forbiddenCityPlaceId,
      journeyId: forbiddenCityJourney01Id,
      title: '共同节点',
      storyAnchor: '两人以乾清门前的共同空间事实校正判断，同时保留不同路线。',
      knowledgeAnchors: ['乾清门前', '外朝与内廷', '共同节点'],
      storyBinding: 'semantic-anchor:shared-evidence-through-closure',
      levelBands: ['Lv1-Lv10'],
      stageBindings: ['story.closure', 'challenge', 'memory', 'completion'],
      landscapeAsset: '$_assetRoot/fc01_d_shared_node_landscape_v2.webp',
      portraitAsset: '$_assetRoot/fc01_d_shared_node_portrait_v2.webp',
      mobileFocalPoint: (.57, .38),
      desktopFocalPoint: (.65, .43),
      mobileSafeZone:
          SceneSafeZone(left: .08, top: .57, right: .92, bottom: .95),
      desktopSafeZone:
          SceneSafeZone(left: .03, top: .37, right: .47, bottom: .94),
      altText: '暖色夕光中的乾清门前空间，中轴与侧向连接在共同节点汇合。',
      historicalNotes: ['乾清门是内廷正门。', '乾清门前空间位于外朝与内廷关系的重要界面。'],
      sourceRefs: [_qianqingGate, _axisPlan],
      visualVerification: [
        'shared node legible',
        'axis and lateral relation',
        'warm closure'
      ],
      promptVersion: 'fc01-d-v2',
      assetVersion: '2026-09-02-v2'),
];

JourneySceneDefinition forbiddenCitySceneById(String sceneId) =>
    forbiddenCityJourney01Scenes
        .singleWhere((scene) => scene.sceneId == sceneId);

const _storySceneIds = ['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D'];
const _sharedEvidenceAnchorByLevel = <int, String>{
  1: '沈砚看清后',
  2: '两条线都能到',
  3: '两人重新对照',
  4: '两人比较',
  5: '沈砚发现',
  6: '两人逐项比较后',
  7: '证据改变了争论',
  8: '他们重新检查后发现',
  9: '比较结果没有',
  10: '沈砚逐项重画后发现',
};

List<JourneyStorySceneSpan> forbiddenCityStorySceneSpans({
  required int level,
  required List<String> paragraphs,
}) {
  if (level < 1 || level > 10) {
    throw RangeError.range(level, 1, 10, 'level');
  }
  if (paragraphs.isEmpty || paragraphs.any((paragraph) => paragraph.isEmpty)) {
    throw ArgumentError.value(
      paragraphs,
      'paragraphs',
      'must contain non-empty Story paragraphs',
    );
  }

  final story = paragraphs.join();
  final total = story.length;
  final axisStart = story.indexOf('。') + 1;
  final eastRouteStart = story.indexOf('阿宁', axisStart);
  final sharedEvidenceAnchor = _sharedEvidenceAnchorByLevel[level]!;
  final sharedNodeStart = story.indexOf(sharedEvidenceAnchor, eastRouteStart);
  final boundaries = <int>[
    0,
    axisStart,
    eastRouteStart,
    sharedNodeStart,
    total,
  ];
  if (boundaries.any((value) => value < 0) ||
      List<int>.generate(boundaries.length - 1, (index) => index)
          .any((index) => boundaries[index] >= boundaries[index + 1])) {
    throw StateError(
      'Forbidden City Lv.$level Story does not satisfy canonical scene anchors.',
    );
  }
  final spans = <JourneyStorySceneSpan>[];
  var globalParagraphStart = 0;
  for (var paragraphIndex = 0;
      paragraphIndex < paragraphs.length;
      paragraphIndex += 1) {
    final paragraphLength = paragraphs[paragraphIndex].length;
    for (var sceneIndex = 0;
        sceneIndex < _storySceneIds.length;
        sceneIndex += 1) {
      final globalStart = boundaries[sceneIndex];
      final globalEnd = boundaries[sceneIndex + 1];
      final localStart = (globalStart - globalParagraphStart)
          .clamp(0, paragraphLength)
          .toInt();
      final localEnd =
          (globalEnd - globalParagraphStart).clamp(0, paragraphLength).toInt();
      if (localEnd <= localStart) continue;
      spans.add(JourneyStorySceneSpan(
        level: level,
        paragraphIndex: paragraphIndex,
        start: localStart,
        end: localEnd,
        sceneId: _storySceneIds[sceneIndex],
      ));
    }
    globalParagraphStart += paragraphLength;
  }
  return List<JourneyStorySceneSpan>.unmodifiable(spans);
}

JourneySceneDefinition forbiddenCitySceneForStoryOffset({
  required int level,
  required List<String> paragraphs,
  required int paragraphIndex,
  required int characterOffset,
}) {
  if (paragraphIndex < 0 || paragraphIndex >= paragraphs.length) {
    throw RangeError.index(paragraphIndex, paragraphs, 'paragraphIndex');
  }
  final safeOffset =
      characterOffset.clamp(0, paragraphs[paragraphIndex].length - 1).toInt();
  final span = forbiddenCityStorySceneSpans(
    level: level,
    paragraphs: paragraphs,
  ).firstWhere(
    (binding) =>
        binding.paragraphIndex == paragraphIndex &&
        binding.contains(safeOffset),
  );
  return forbiddenCitySceneById(span.sceneId);
}

JourneySceneDefinition forbiddenCitySceneForStage(String stage) {
  return switch (stage) {
    'vocabulary' => forbiddenCitySceneById('FC01-B'),
    'discovery' || 'challenge' => forbiddenCitySceneById('FC01-C'),
    'memory' || 'completion' => forbiddenCitySceneById('FC01-D'),
    _ => forbiddenCitySceneById('FC01-A'),
  };
}
