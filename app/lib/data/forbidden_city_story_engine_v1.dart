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
  goal: '在把地点记录交给新同事许澄前，和他一起核对关键标记，让接手的人知道哪些信息已经确认、哪些还要继续查。',
  conflict: '旧表把景运门写在乾清门前广场西侧；许澄第二天就要接手使用，林乔必须决定是照旧签名交出去，还是停下例行交接并承担更正责任。',
  knowledgeUnitRefs: <String>[
    kuMeridianGateAxis,
    kuCentralAxisSequence,
    kuQianqingGateCourts,
    kuJingyunGateEast,
  ],
  languageLevel: 5,
  learningFocus: <String>['空间关系', '中轴', '核对与交接', '证据意识'],
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
    StoryCharacter(
      name: '许澄',
      roleRef: knowledgeRoleRestorationWorker,
      professionRef: knowledgeProfessionHeritageConservation,
      status: StoryCharacterStatus.fictional,
    ),
  ],
  storyBeats: <StoryBeat>[
    StoryBeat(
      type: StoryBeatType.setup,
      text: '交接前，林乔把地点记录册推到新同事许澄面前。许澄第二天要接手这份记录，他翻到签名页问：“我明天就按这里写的走吗？”林乔本来已经拔开笔帽，又把笔放回桌上：“先一起核对一遍。”',
    ),
    StoryBeat(
      type: StoryBeatType.observation,
      text: '两人从前面的页码往后看。许澄把“中轴”圈了一下，又在“景运门”旁做了记号：“这两个我还容易弄混。”林乔没有替他背答案，只让他把不确定的地方先标出来。',
    ),
    StoryBeat(
      type: StoryBeatType.conflict,
      text: '翻到旧表时，他们看到景运门被标在乾清门前广场西侧。许澄抬头：“如果我明天照这张表走呢？”林乔的手停在签名栏上。她原本只差一个名字就能完成交接，现在却不能把这个疑问留给接手的人。',
    ),
    StoryBeat(
      type: StoryBeatType.evidence,
      text: '两人把图页摊在桌上，核到同一处：景运门位于乾清门前广场东侧。许澄用铅笔把旧表的“西”圈起来，没有马上擦掉，等林乔决定这页该怎么交。',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
    StoryBeat(
      type: StoryBeatType.decision,
      text: '林乔没有只把“西”改成“东”。她让许澄把刚才的疑问写在页边，两人继续核对交接页：能确认的当场更正，不能确认的先留空。林乔在更正处签名，又把笔递给许澄：“你接手以后，也照这个办法往下查。”',
    ),
    StoryBeat(
      type: StoryBeatType.resolution,
      text: '第二天要交出去的记录不再假装每一格都有答案。许澄接过册子，先指着两个空格问：“这两项我接着核，对吗？”林乔点头。原来只需要她签一个名字的交接，变成了两个人都知道下一步该做什么。',
    ),
    StoryBeat(
      type: StoryBeatType.takeaway,
      text: '许澄没有立刻收起册子。他把最后一个待核的格子折了角，再把签字笔放到两人中间：“下一页一起看完？”林乔把椅子拉近。',
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
      id: 'fact.jingyun_gate_east',
      text: '景运门位于乾清门前广场东侧。',
      type: NarrativeClaimType.fact,
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
    NarrativeClaim(
      id: 'fiction.marker_sheet_error',
      text: '虚构的旧地点记录把景运门标在乾清门前广场西侧。',
      type: NarrativeClaimType.fictionalNarrative,
    ),
    NarrativeClaim(
      id: 'fiction.handoff_relationship',
      text: '虚构角色许澄是即将接手地点记录的新同事，林乔负责与他完成交接。',
      type: NarrativeClaimType.fictionalNarrative,
    ),
    NarrativeClaim(
      id: 'fiction.lin_qiao_decision',
      text: '虚构角色林乔停下例行签名，与许澄共同核对记录并改变交接方式。',
      type: NarrativeClaimType.fictionalNarrative,
    ),
  ],
  vocabularyTargets: <VocabularyTarget>[
    VocabularyTarget(
      id: 'vocab.central_axis',
      term: '中轴',
      knowledgeUnitRefs: <String>[kuCentralAxisSequence],
    ),
    VocabularyTarget(
      id: 'vocab.jingyun_gate',
      term: '景运门',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
    VocabularyTarget(
      id: 'vocab.verify',
      term: '核对',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
    VocabularyTarget(
      id: 'vocab.handoff',
      term: '交接',
      knowledgeUnitRefs: <String>[kuJingyunGateEast],
    ),
  ],
  discoveryTargets: <DiscoveryTarget>[
    DiscoveryTarget(
      id: 'discovery.spatial_types',
      concept: '区分具体宫门与组织建筑关系的中轴',
      knowledgeUnitRefs: <String>[
        kuMeridianGateAxis,
        kuCentralAxisSequence,
      ],
    ),
    DiscoveryTarget(
      id: 'discovery.qianqing_gate_function',
      concept: '乾清门与外朝、内廷往来的空间功能关系',
      knowledgeUnitRefs: <String>[kuQianqingGateCourts],
    ),
    DiscoveryTarget(
      id: 'discovery.spatial_relations',
      concept: '用门、广场、方向与中轴关系理解紫禁城空间',
      knowledgeUnitRefs: <String>[
        kuJingyunGateEast,
        kuCentralAxisSequence,
      ],
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
    '虚构的现代文保角色林乔在把地点记录交给新同事许澄前发现景运门方向错误，两人由一次例行签名改成共同核对并明确后续待查事项。';
