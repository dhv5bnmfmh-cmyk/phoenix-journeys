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
  'vocab.meridian_gate': VocabularyMetadata(
    pinyin: 'wǔmén',
    partOfSpeech: '专名',
    simpleChinese: '紫禁城的正门。',
    usage: '核对午门与中轴的空间关系。',
    semanticContrast: '午门是具体宫门；中轴是组织空间的轴线。',
  ),
  'vocab.central_axis': VocabularyMetadata(
    pinyin: 'zhōngzhóu',
    partOfSpeech: '名词',
    simpleChinese: '建筑或城市空间中的中心轴线。',
    usage: '午门位于紫禁城南北中轴线上。',
    semanticContrast: '中轴表示空间关系，不是某一座宫门。',
  ),
  'vocab.qianqing_gate': VocabularyMetadata(
    pinyin: 'qiánqīngmén',
    partOfSpeech: '专名',
    simpleChinese: '紫禁城内廷正宫门。',
    usage: '乾清门连接内廷与外朝往来。',
    semanticContrast: '乾清门的学习重点包含门的功能关系，不只看方向。',
  ),
  'vocab.jingyun_gate': VocabularyMetadata(
    pinyin: 'jǐngyùnmén',
    partOfSpeech: '专名',
    simpleChinese: '乾清门前广场东侧的重要门户之一。',
    usage: '核对景运门在广场东侧的标记。',
    semanticContrast: '景运门是东侧门户；不要把虚构旧表中的西侧标记当事实。',
  ),
};

const _fixtureDiscoveryText = <String, String>{
  'discovery.entry_axis':
      '午门与中轴要分成两个概念学习：一个是具体宫门，一个是空间轴线。核对位置时，两条已验证资料共同支撑它们的关系。',
  'discovery.qianqing_gate_function':
      '乾清门这一知识点同时包含“内廷正宫门”和“连接内廷、外朝往来”两层信息。学习重点是区分名称、位置与功能关系。',
  'discovery.jingyun_gate_position':
      '景运门的方位必须回到来源核对。已验证知识把它放在乾清门前广场东侧；虚构旧表的西侧写法不进入事实层。',
};

const _fixtureChallengeSpecs = <ChallengeGenerationSpec>[
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.sentence_rebuild',
    kind: GeneratedChallengeKind.sentenceRebuild,
    targetText: '午门在中轴线上',
    teachingSourceRefs: <String>[
      'vocab.meridian_gate',
      'vocab.central_axis',
      'discovery.entry_axis',
    ],
    knowledgeUnitRefs: <String>[kuMeridianGateAxis],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.grammar',
    kind: GeneratedChallengeKind.grammar,
    targetText: '她决定先逐项核对',
    teachingSourceRefs: <String>['story.setup'],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.knowledge_mcq',
    kind: GeneratedChallengeKind.knowledgeMcq,
    targetText: '乾清门连接外朝与内廷往来',
    teachingSourceRefs: <String>[
      'vocab.qianqing_gate',
      'discovery.qianqing_gate_function',
    ],
    knowledgeUnitRefs: <String>[kuQianqingGateCourts],
  ),
  ChallengeGenerationSpec(
    id: 'pipeline.challenge.completion',
    kind: GeneratedChallengeKind.completion,
    targetText: '景运门位于乾清门前广场东侧',
    teachingSourceRefs: <String>[
      'vocab.jingyun_gate',
      'discovery.jingyun_gate_position',
    ],
    knowledgeUnitRefs: <String>[kuJingyunGateEast],
  ),
];

const _fixtureMemory = GeneratedMemory(
  storyAnchor: GeneratedMemoryItem(
    id: 'memory.story_anchor',
    text: '林乔在交接前停笔核对景运门方向。',
    teachingSourceRefs: <String>['story.conflict', 'story.decision'],
  ),
  knowledgeTakeaway: GeneratedMemoryItem(
    id: 'memory.knowledge_takeaway',
    text: '午门在中轴线上；景运门在乾清门前广场东侧。',
    teachingSourceRefs: <String>[
      'discovery.entry_axis',
      'discovery.jingyun_gate_position',
    ],
    knowledgeUnitRefs: <String>[kuMeridianGateAxis, kuJingyunGateEast],
  ),
  vocabularyRecall: GeneratedMemoryItem(
    id: 'memory.vocabulary_recall',
    text: '午门 / 中轴 / 乾清门 / 景运门',
    teachingSourceRefs: <String>[
      'vocab.meridian_gate',
      'vocab.central_axis',
      'vocab.qianqing_gate',
      'vocab.jingyun_gate',
    ],
  ),
  characterMoment: GeneratedMemoryItem(
    id: 'memory.character_moment',
    text: '林乔没有照抄旧表，而是只保留能追到来源的记录。',
    teachingSourceRefs: <String>['story.decision', 'story.resolution'],
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
