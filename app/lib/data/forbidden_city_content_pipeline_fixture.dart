import '../models/content_pipeline.dart';
import '../services/ai_content_pipeline_v1.dart';
import 'forbidden_city_knowledge_universe.dart';
import 'forbidden_city_story_engine_v1.dart';

const aiContentPipelineV1Version = 'ai-content-pipeline-v1';
const forbiddenCityPipelineFixturePackageId =
    'fixture.forbidden_city.modern_evidence_handoff.v1';

const forbiddenCityPipelineFixtureSelection = KnowledgeSelectionRequest(
  placeRefs: <String>[knowledgePlaceForbiddenCity],
  requiredKnowledgeUnitRefs: <String>[
    kuMeridianGateAxis,
    kuCentralAxisSequence,
    kuQianqingGateCourts,
    kuJingyunGateEast,
  ],
);

const _fixtureVocabularyMetadata = <String, VocabularyMetadata>{
  'vocab.central_axis': VocabularyMetadata(
    pinyin: 'zhōngzhóu',
    partOfSpeech: '名词',
    simpleChinese: '建筑或城市空间中的中心轴线。',
    usage: '看紫禁城空间时，不只记宫门，也要理解中轴关系。',
    semanticContrast: '中轴表示组织空间的轴线；宫门是具体建筑。',
  ),
  'vocab.jingyun_gate': VocabularyMetadata(
    pinyin: 'jǐngyùnmén',
    partOfSpeech: '专名',
    simpleChinese: '乾清门前广场东侧的重要门户之一。',
    usage: '核对景运门在乾清门前广场东侧的方位。',
    semanticContrast: '景运门是具体宫门；“东侧”描述它与广场的空间关系。',
  ),
  'vocab.verify': VocabularyMetadata(
    pinyin: 'héduì',
    partOfSpeech: '动词',
    simpleChinese: '把信息放在一起检查，看是不是一致。',
    usage: '交接前，两个人一起核对地点记录。',
    semanticContrast: '核对强调对照检查；确认强调得到明确结果。',
  ),
  'vocab.handoff': VocabularyMetadata(
    pinyin: 'jiāojiē',
    partOfSpeech: '动词 / 名词',
    simpleChinese: '把工作、资料或责任从一个人交给另一个人继续负责。',
    usage: '林乔和许澄在下班前完成记录交接。',
    semanticContrast: '交接包含责任继续转移；交给只表示把东西给别人。',
  ),
};

const _fixtureDiscoveryText = <String, String>{
  'discovery.spatial_types':
      '看紫禁城空间时，“午门”和“中轴”不是同一类信息：午门是具体宫门；中轴描述宫门、院落和主要建筑形成的南北空间序列。午门位于这条南北轴线上，所以理解路线既要认建筑，也要认组织建筑的空间关系。',
  'discovery.qianqing_gate_function':
      '乾清门不只是地图上的一个名称。已验证资料说明它是内廷正宫门，也是连接内廷与外朝往来的重要通道。学习乾清门时，名称和“它连接哪些空间”应一起理解。',
  'discovery.spatial_relations':
      '单独背建筑名字不足以判断空间关系。已验证资料把景运门放在乾清门前广场东侧，同时把紫禁城中轴上的宫门、院落和主要建筑组织成清晰的南北序列。把门、广场、方向和轴线一起看，名称才会变成可使用的空间信息。',
};

const _fixtureChallengeSpecs = <ChallengeGenerationSpec>[
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.sentence_rebuild',
    kind: GeneratedChallengeKind.sentenceRebuild,
    targetText: '午门在中轴线上',
    teachingSourceRefs: <String>[
      'vocab.central_axis',
      'discovery.spatial_types',
    ],
    knowledgeUnitRefs: <String>[kuMeridianGateAxis],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.grammar',
    kind: GeneratedChallengeKind.grammar,
    targetText: '交接前先核对记录',
    teachingSourceRefs: <String>[
      'story.setup',
      'vocab.handoff',
      'vocab.verify',
    ],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.knowledge_mcq',
    kind: GeneratedChallengeKind.knowledgeMcq,
    targetText: '乾清门连接外朝与内廷往来',
    teachingSourceRefs: <String>['discovery.qianqing_gate_function'],
    knowledgeUnitRefs: <String>[kuQianqingGateCourts],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.completion',
    kind: GeneratedChallengeKind.completion,
    targetText: '景运门位于乾清门前广场东侧',
    teachingSourceRefs: <String>[
      'story.evidence',
      'vocab.jingyun_gate',
      'discovery.spatial_relations',
    ],
    knowledgeUnitRefs: <String>[kuJingyunGateEast],
  ),
];

const _fixtureMemory = GeneratedMemory(
  storyAnchor: GeneratedMemoryItem(
    id: 'memory.story_anchor',
    text: '林乔在签名栏前停下，把许澄留下来一起核对那一页。',
    teachingSourceRefs: <String>['story.conflict', 'story.decision'],
  ),
  knowledgeTakeaway: GeneratedMemoryItem(
    id: 'memory.knowledge_takeaway',
    text: '午门是具体宫门，中轴是空间轴线；景运门在乾清门前广场东侧。',
    teachingSourceRefs: <String>[
      'discovery.spatial_types',
      'discovery.spatial_relations',
    ],
    knowledgeUnitRefs: <String>[
      kuMeridianGateAxis,
      kuCentralAxisSequence,
      kuJingyunGateEast,
    ],
  ),
  vocabularyRecall: GeneratedMemoryItem(
    id: 'memory.vocabulary_recall',
    text: '交接 / 核对 / 中轴 / 景运门',
    teachingSourceRefs: <String>[
      'vocab.handoff',
      'vocab.verify',
      'vocab.central_axis',
      'vocab.jingyun_gate',
    ],
  ),
  characterMoment: GeneratedMemoryItem(
    id: 'memory.character_moment',
    text: '许澄接过记录后先问哪一项还没核，林乔把下一页和他一起继续看。',
    teachingSourceRefs: <String>['story.resolution', 'story.takeaway'],
  ),
);

final forbiddenCityContentPipelineV1 = AiContentPipelineV1(
  knowledgeUniverse: forbiddenCityKnowledgeUniverse,
  storyEngine: forbiddenCityStoryEngineV1,
  storyWriter: const DeterministicStoryWriter(),
  contentGenerator: DeterministicContentGenerator(
    vocabularyMetadataByTargetId: _fixtureVocabularyMetadata,
    discoveryTextByTargetId: _fixtureDiscoveryText,
    challengeSpecs: _fixtureChallengeSpecs,
    memoryTemplate: _fixtureMemory,
    knowledgeUniverse: forbiddenCityKnowledgeUniverse,
  ),
  validator: ContentQualityValidator(forbiddenCityKnowledgeUniverse),
);

JourneyContentPackage buildForbiddenCityPipelineFixture() {
  return forbiddenCityContentPipelineV1.generate(
    packageId: forbiddenCityPipelineFixturePackageId,
    pipelineVersion: aiContentPipelineV1Version,
    knowledgeSnapshotVersion: forbiddenCityStoryEngineKnowledgeSnapshotVersion,
    selection: forbiddenCityPipelineFixtureSelection,
    seedTemplate: forbiddenCitySecondStorySeed,
    blueprint: forbiddenCitySecondStoryBlueprint,
  );
}

final forbiddenCityPipelineFixture = buildForbiddenCityPipelineFixture();
