import '../models/knowledge_universe.dart';
import '../models/story_engine.dart';
import 'forbidden_city_knowledge_universe.dart';

const forbiddenCityStoryEngineKnowledgeSnapshotVersion =
    'forbidden-city-knowledge-universe-v1';

const forbiddenCitySecondStorySeed = StorySeed(
  id: 'seed.forbidden_city.modern_evidence_handoff',
  placeRef: knowledgePlaceForbiddenCity,
  periodRef: knowledgePeriodModern,
  characterRoleRef: knowledgeRoleRestorationWorker,
  professionRef: knowledgeProfessionHeritageConservation,
  goal: '在交接学习记录前，核对午门、中轴、乾清门与景运门的地点标记是否符合已验证资料。',
  conflict: '一张学习记录把景运门的位置写反；照旧表抄最快，但角色必须选择熟悉印象还是可追溯证据。',
  knowledgeUnitRefs: <String>[
    kuMeridianGateAxis,
    kuCentralAxisSequence,
    kuQianqingGateCourts,
    kuJingyunGateEast,
  ],
  languageLevel: 5,
  learningFocus: <String>['地点关系', '中轴', '宫门功能', '证据与记录'],
);

const forbiddenCitySecondStoryBlueprint = StoryBlueprint(
  id: 'story.forbidden_city.modern_evidence_handoff.v1',
  title: '交接前的标记',
  characters: <StoryCharacter>[
    StoryCharacter(
      name: '林乔',
      roleRef: knowledgeRoleRestorationWorker,
      professionRef: knowledgeProfessionHeritageConservation,
      status: StoryCharacterStatus.fictional,
    ),
  ],
  storyBeats: <StoryBeat>[
    StoryBeat(
      type: StoryBeatType.setup,
      text: '林乔接过一张待交接的地点标记表。纸上四个名字都很熟，她却决定先逐项核对，再签自己的名字。',
    ),
    StoryBeat(
      type: StoryBeatType.observation,
      text: '第一条写着午门。资料确认午门是紫禁城正门，也位于南北轴线上，她在这一项旁边打了勾。',
      knowledgeUnitRefs: <String>[kuMeridianGateAxis],
    ),
    StoryBeat(
      type: StoryBeatType.conflict,
      text: '看到景运门时，她停住了：旧表把它标在乾清门前广场西侧。照着旧表抄最快，但她没有落笔。',
    ),
    StoryBeat(
      type: StoryBeatType.evidence,
      text: '她把已核过的资料并排打开：景运门在乾清门前广场东侧；乾清门是内廷正宫门，也是连接内廷与外朝往来的重要通道；中轴上的宫门、院落和主要建筑形成清楚的南北空间序列。',
      knowledgeUnitRefs: <String>[
        kuJingyunGateEast,
        kuQianqingGateCourts,
        kuCentralAxisSequence,
      ],
    ),
    StoryBeat(
      type: StoryBeatType.decision,
      text: '林乔改正了方向，把每一处改动只绑定到能追到来源的记录；没有资料支持的细节，她宁可留空。',
    ),
    StoryBeat(
      type: StoryBeatType.resolution,
      text: '交接时，表上少了一条想当然的注释，多了四个能追到出处的标记。她把旧表夹在后面，保留修改痕迹。',
    ),
    StoryBeat(
      type: StoryBeatType.takeaway,
      text: '林乔扣上笔帽：熟悉一个地方，不等于可以替事实补空白。',
    ),
  ],
  requiredFacts: <String>[
    kuMeridianGateAxis,
    kuCentralAxisSequence,
    kuQianqingGateCourts,
    kuJingyunGateEast,
  ],
  narrativeClaims: <NarrativeClaim>[
    NarrativeClaim(
      id: 'fact.meridian_gate_axis',
      text: '午门是紫禁城正门，位于紫禁城南北轴线上。',
      type: NarrativeClaimType.fact,
      knowledgeUnitRefs: <String>[kuMeridianGateAxis],
    ),
    NarrativeClaim(
      id: 'fact.central_axis_sequence',
      text: '紫禁城中轴上的宫门、院落与主要建筑形成清晰的南北空间序列。',
      type: NarrativeClaimType.fact,
      knowledgeUnitRefs: <String>[kuCentralAxisSequence],
    ),
    NarrativeClaim(
      id: 'fact.qianqing_gate_courts',
      text: '乾清门为内廷正宫门，也是连接内廷与外朝往来的重要通道。',
      type: NarrativeClaimType.fact,
      knowledgeUnitRefs: <String>[kuQianqingGateCourts],
    ),
    NarrativeClaim(
      id: 'fact.jingyun_gate_east',
      text: '景运门位于乾清门前广场东侧，是进入这一广场的重要门户之一。',
      type: NarrativeClaimType.fact,
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
    NarrativeClaim(
      id: 'fiction.marker_sheet_error',
      text: '虚构的地点标记表把景运门方向写反。',
      type: NarrativeClaimType.fictionalNarrative,
    ),
    NarrativeClaim(
      id: 'fiction.lin_qiao_decision',
      text: '虚构角色林乔选择回到证据，不凭熟悉印象补写事实。',
      type: NarrativeClaimType.fictionalNarrative,
    ),
  ],
  vocabularyTargets: <VocabularyTarget>[
    VocabularyTarget(
      id: 'vocab.meridian_gate',
      term: '午门',
      knowledgeUnitRefs: <String>[kuMeridianGateAxis],
    ),
    VocabularyTarget(
      id: 'vocab.central_axis',
      term: '中轴',
      knowledgeUnitRefs: <String>[kuCentralAxisSequence],
    ),
    VocabularyTarget(
      id: 'vocab.qianqing_gate',
      term: '乾清门',
      knowledgeUnitRefs: <String>[kuQianqingGateCourts],
    ),
    VocabularyTarget(
      id: 'vocab.jingyun_gate',
      term: '景运门',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
  ],
  discoveryTargets: <DiscoveryTarget>[
    DiscoveryTarget(
      id: 'discovery.entry_axis',
      concept: '午门与紫禁城南北中轴的关系',
      knowledgeUnitRefs: <String>[
        kuMeridianGateAxis,
        kuCentralAxisSequence,
      ],
    ),
    DiscoveryTarget(
      id: 'discovery.qianqing_gate_function',
      concept: '乾清门与外朝、内廷往来的关系',
      knowledgeUnitRefs: <String>[kuQianqingGateCourts],
    ),
    DiscoveryTarget(
      id: 'discovery.jingyun_gate_position',
      concept: '景运门位于乾清门前广场东侧',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
  ],
  challengeTargets: <ChallengeTarget>[
    ChallengeTarget(
      id: 'challenge.meridian_axis',
      concept: '判断午门与中轴的正确空间关系',
      knowledgeUnitRefs: <String>[kuMeridianGateAxis],
    ),
    ChallengeTarget(
      id: 'challenge.qianqing_connection',
      concept: '识别乾清门连接外朝与内廷往来的功能关系',
      knowledgeUnitRefs: <String>[kuQianqingGateCourts],
    ),
    ChallengeTarget(
      id: 'challenge.jingyun_east',
      concept: '判断景运门相对乾清门前广场的方位',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
  ],
);

final forbiddenCityStoryEngineV1 = StoryEngine(forbiddenCityKnowledgeUniverse);

final forbiddenCitySecondStoryPlan = forbiddenCityStoryEngineV1.compose(
  seed: forbiddenCitySecondStorySeed,
  blueprint: forbiddenCitySecondStoryBlueprint,
  knowledgeSnapshotVersion: forbiddenCityStoryEngineKnowledgeSnapshotVersion,
);

final forbiddenCitySecondStoryKnowledgeCoverage =
    forbiddenCityStoryEngineV1.audit(forbiddenCitySecondStoryPlan);

final forbiddenCitySecondStoryLearningAlignment =
    forbiddenCityStoryEngineV1.alignment(forbiddenCitySecondStoryPlan);

const forbiddenCitySecondStorySummary =
    '虚构的现代文保学习角色林乔在交接前发现地点标记冲突，并依据午门、中轴、乾清门与景运门的可追溯空间事实完成核对。';
