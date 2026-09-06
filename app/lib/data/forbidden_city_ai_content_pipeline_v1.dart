import '../models/content_pipeline.dart';
import 'forbidden_city_knowledge_universe.dart';
import 'forbidden_city_story_engine_v1.dart';

const forbiddenCityAiContentPipelineVersion = 'ai-content-pipeline-v1';
const forbiddenCityAiContentPackageVersion = 'forbidden-city-second-journey-v1';

const forbiddenCityPipelineKnowledgeSelection = KnowledgeSelectionRequest(
  placeRefs: <String>[knowledgePlaceForbiddenCity],
  professionRefs: <String>[knowledgeProfessionArchitecture],
  cultureRefs: <String>[knowledgeCultureArchitecture],
  requiredKnowledgeUnitRefs: <String>[
    kuMeridianGateAxis,
    kuCentralAxisSequence,
    kuQianqingGateCourts,
    kuJingyunGateEast,
  ],
);

const forbiddenCityPipelineSeedRequest = StorySeedRequest(
  id: 'seed.forbidden_city.modern_evidence_handoff',
  placeRef: knowledgePlaceForbiddenCity,
  periodRef: knowledgePeriodModern,
  characterRoleRef: knowledgeRoleRestorationWorker,
  professionRef: knowledgeProfessionHeritageConservation,
  goal: '在交接学习记录前，核对午门、中轴、乾清门与景运门的地点标记是否符合已验证资料。',
  conflict: '一张学习记录把景运门的位置写反；照旧表抄最快，但角色必须选择熟悉印象还是可追溯证据。',
  languageLevel: 5,
  learningFocus: <String>['地点关系', '中轴', '宫门功能', '证据与记录'],
);

const forbiddenCityPipelineVocabularyLexicon = <String, VocabularyLexeme>{
  '午门': VocabularyLexeme(
    word: '午门',
    pinyin: 'Wǔmén',
    partOfSpeech: '专名',
    simpleChinese: '地点名：午门。',
    semanticContrast: '“午门”作为地点专名整体使用，不把“午”和普通“门”拆开理解。',
  ),
  '中轴': VocabularyLexeme(
    word: '中轴',
    pinyin: 'zhōngzhóu',
    partOfSpeech: '名词',
    simpleChinese: '表示空间中的中心轴线。',
    semanticContrast: '“中轴”强调一条空间轴线，不等于一般的“中心”。',
  ),
  '乾清门': VocabularyLexeme(
    word: '乾清门',
    pinyin: 'Qiánqīngmén',
    partOfSpeech: '专名',
    simpleChinese: '地点名：乾清门。',
    semanticContrast: '“乾清门”是完整地点专名，不能只用“门”代替其具体指向。',
  ),
  '景运门': VocabularyLexeme(
    word: '景运门',
    pinyin: 'Jǐngyùnmén',
    partOfSpeech: '专名',
    simpleChinese: '地点名：景运门。',
    semanticContrast: '“景运门”是完整地点专名，与“乾清门”是不同地点。',
  ),
};

final forbiddenCityAiContentPipelineV1 = AiContentPipeline(
  knowledgeUniverse: forbiddenCityKnowledgeUniverse,
  storyEngine: forbiddenCityStoryEngineV1,
  storyWriter: const DeterministicStoryWriter(),
  pipelineVersion: forbiddenCityAiContentPipelineVersion,
);

final forbiddenCitySecondJourneyContentPackage =
    forbiddenCityAiContentPipelineV1.build(
  packageId: 'journey.candidate.forbidden_city.modern_evidence_handoff',
  packageVersion: forbiddenCityAiContentPackageVersion,
  knowledgeSnapshotVersion: forbiddenCityStoryEngineKnowledgeSnapshotVersion,
  knowledgeSelection: forbiddenCityPipelineKnowledgeSelection,
  seedRequest: forbiddenCityPipelineSeedRequest,
  storyBlueprint: forbiddenCitySecondStoryBlueprint,
  vocabularyLexicon: forbiddenCityPipelineVocabularyLexicon,
);

const forbiddenCitySecondJourneyCandidateName = '交接前的标记';
