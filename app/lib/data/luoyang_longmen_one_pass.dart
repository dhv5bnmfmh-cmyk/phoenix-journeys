import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const luoyangLongmenJourneyId = 'luoyang-longmen-grottoes';
const luoyangLongmenCanonicalTitle = '证据到这里';
const luoyangLongmenLegacyTitle = '山崖石刻故事';
const luoyangLongmenLegacyHeadline = '读一部刻在山崖上的艺术史';
const luoyangLongmenHeadline = '当“看起来完整”没有证据';
const luoyangLongmenDescription = '在龙门石窟的题记、残损现状与有据复原之间，做一次不替历史补空白的选择。';
const luoyangLongmenDiscoveryTeaser = '一块石面上的题记、残损与旧照片，为什么必须分成不同证据层？';

const luoyangLongmenPrimaryDepthMechanism = 'AMBIGUITY / UNCERTAINTY';
const luoyangLongmenSecondaryDepthMechanisms = <String>[
  'ABSENCE / LOSS',
  'TEMPORAL TRACE',
];
const luoyangLongmenSupportingDepth = 'NARRATIVE SUBTEXT / RESTRAINT';
const luoyangLongmenIntentionallyUnusedDepth = <String>[
  'PRACTICE / RITUAL CAUSALITY',
  'INSTITUTIONAL / POWER CAUSALITY',
  'ECONOMIC / LIVELIHOOD CAUSALITY',
  'ECOLOGICAL CAUSALITY',
  'INTERGENERATIONAL TRANSMISSION',
  'COLLECTIVE MEMORY',
  'LOCAL VOICE',
];
const luoyangLongmenStorySignature =
    'AMBIGUITY / UNCERTAINTY × EQUAL-COLLABORATOR TRUST × LONGMEN INSCRIPTION + DAMAGED NICHE + OLD-PHOTO-BASED VIRTUAL RESTORATION';

class LongmenStoryArchitecture {
  const LongmenStoryArchitecture({
    required this.id,
    required this.storyFamily,
    required this.subject,
    required this.timeLayer,
    required this.humanLens,
    required this.historicalScale,
    required this.truthMode,
    required this.protagonist,
    required this.relationship,
    required this.humanNeed,
    required this.goal,
    required this.conflict,
    required this.choice,
    required this.cost,
    required this.climax,
    required this.consequence,
    required this.transformation,
    required this.ending,
    required this.placeCausality,
    required this.culturalMechanism,
    required this.primaryDepth,
    required this.secondaryDepth,
    required this.factDependencies,
    required this.historicalRisk,
    required this.storySignature,
    required this.narrativeEngine,
    required this.selected,
  });

  final String id;
  final String storyFamily;
  final String subject;
  final String timeLayer;
  final String humanLens;
  final String historicalScale;
  final String truthMode;
  final String protagonist;
  final String relationship;
  final String humanNeed;
  final String goal;
  final String conflict;
  final String choice;
  final String cost;
  final String climax;
  final String consequence;
  final String transformation;
  final String ending;
  final String placeCausality;
  final String culturalMechanism;
  final String primaryDepth;
  final String secondaryDepth;
  final String factDependencies;
  final String historicalRisk;
  final String storySignature;
  final String narrativeEngine;
  final bool selected;
}

const luoyangLongmenStoryArchitectures = <LongmenStoryArchitecture>[
  LongmenStoryArchitecture(
    id: 'A-evidence-ends-here',
    storyFamily: 'CONTEMPORARY ENCOUNTER WITH HISTORY',
    subject: 'HUMAN + DIGITAL REPRESENTATION',
    timeLayer: 'CONTEMPORARY LIFE × TEMPORAL TRACE',
    humanLens: 'CREATIVE COLLABORATORS',
    historicalScale: 'ONE NICHE ACROSS DOCUMENTED EVIDENCE LAYERS',
    truthMode: 'CONTEMPORARY FICTION + VERIFIED HISTORICAL FACT',
    protagonist: '林砚，29岁，虚构当代三维视觉创作者',
    relationship: '林砚与周澄是平等创作伙伴',
    humanNeed: '让自己的视觉判断在不牺牲历史真实性的前提下得到共同作者信任',
    goal: '完成两人共同署名的龙门石窟数字短片',
    conflict: '无缝完整的画面与证据边界发生冲突，同时考验平等合作中的专业信任',
    choice: '林砚主动关闭并弃用没有来源支持的“补全脸部”模型层',
    cost: '三天渲染工作作废，原定最顺滑的视觉高潮被放弃',
    climax: '林砚亲手关闭无依据模型层',
    consequence: '最终短片把现存残损、有据复原与想象明确分开，双方并列署名保留',
    transformation: '林砚把来源核对从建模之后前移到建模之前',
    ending: '工程文件保留“无依据，不使用”图层名，两人的名字仍并列在片尾',
    placeCausality: '万佛洞前室南壁观音像龛同时留下题记、残损现状与基于历史老照片的官方虚拟复原依据',
    culturalMechanism: '龙门题记与文物保护中的证据边界直接决定可呈现到什么程度',
    primaryDepth: 'AMBIGUITY / UNCERTAINTY',
    secondaryDepth: 'ABSENCE / LOSS + TEMPORAL TRACE',
    factDependencies: 'UNESCO Longmen site record + Longmen Academy Wanfo Cave virtual-restoration record',
    historicalRisk: 'LOW: all dramatic actions are contemporary fiction; historical facts remain source-bounded',
    storySignature: luoyangLongmenStorySignature,
    narrativeEngine: 'evidence-layer conflict resolved by destructive deletion rather than successful completion',
    selected: true,
  ),
  LongmenStoryArchitecture(
    id: 'B-dispersed-relief-network',
    storyFamily: 'PLACE NETWORK STORY',
    subject: 'ARTIFACT / OBJECT LIFE',
    timeLayer: 'LOSS × CONTEMPORARY ENCOUNTER',
    humanLens: 'VISITOR / RESEARCHER',
    historicalScale: 'OBJECT LIFE × INTERNATIONAL DISPERSAL',
    truthMode: 'VERIFIED HISTORY + CONTEMPORARY FICTION',
    protagonist: '虚构当代研究访客',
    relationship: '同行研究伙伴',
    humanNeed: '理解缺席的浮雕如何仍属于龙门的历史关系',
    goal: '把宾阳中洞流散礼佛图的现址与原址关系讲清楚',
    conflict: '对象已离开原址，而叙事容易把“重聚”愿望写成虚假的完整性',
    choice: '保留分散事实，不用数字拼接制造已经回归的错觉',
    cost: '放弃更具视觉冲击力的“完整重聚”叙事',
    climax: '面对原址空缺仍拒绝把数字合成称为实体归还',
    consequence: '网络关系被说明，但人类行动成本弱于候选A',
    transformation: '从追求对象完整转为理解原址、现藏地与流散史之间的关系',
    ending: '以原址空缺结束',
    placeCausality: '宾阳中洞礼佛图确从龙门被盗凿并流散至海外收藏',
    culturalMechanism: '流散史与原址缺失形成跨地点网络',
    primaryDepth: 'ABSENCE / LOSS',
    secondaryDepth: 'PLACE NETWORK + TEMPORAL TRACE',
    factDependencies: 'Longmen Academy official dispersed-object records',
    historicalRisk: 'MEDIUM: object history is strong, but a sufficiently costly human Choice would need more fictional scaffolding',
    storySignature: 'ABSENCE / LOSS × RESEARCHER RESPONSIBILITY × LONGMEN DISPERSED RELIEF NETWORK',
    narrativeEngine: 'network reconstruction without false reunification',
    selected: false,
  ),
  LongmenStoryArchitecture(
    id: 'C-guyang-donor-inscription',
    storyFamily: 'HISTORICAL HUMAN STORY',
    subject: 'ORDINARY HISTORICAL PERSON',
    timeLayer: 'FORMATION',
    humanLens: 'ORDINARY DONOR',
    historicalScale: 'MOMENT / COMMUNITY PRACTICE',
    truthMode: 'FICTIONAL CHARACTER IN VERIFIED HISTORICAL SETTING',
    protagonist: '虚构北魏普通供养人',
    relationship: '家庭或邑社成员',
    humanNeed: '在集体造像实践中留下可读的参与痕迹',
    goal: '完成一次与题记相关的供养行动',
    conflict: '个人愿望与集体、材料、费用及题记位置之间的限制',
    choice: '在有限条件下决定留下什么',
    cost: '需要对历史经济与社群细节作更多推断才能成立',
    climax: '名字或位置进入题记',
    consequence: '普通人痕迹进入石面记录',
    transformation: '从个人愿望转向共同实践',
    ending: '以题记上的有限痕迹收束',
    placeCausality: '古阳洞密集造像龛与题记保存大量供养活动痕迹',
    culturalMechanism: '造像题记与邑社实践',
    primaryDepth: 'PRACTICE / RITUAL CAUSALITY',
    secondaryDepth: 'SOCIAL CAUSALITY + TEMPORAL TRACE',
    factDependencies: 'Longmen Academy official overview + peer-reviewed/university research on Guyang donor inscriptions',
    historicalRisk: 'MEDIUM-HIGH: dramatic social and economic details could exceed source support',
    storySignature: 'PRACTICE CAUSALITY × ORDINARY DONOR BELONGING × GUYANG INSCRIPTION DENSITY',
    narrativeEngine: 'historical participation recorded in stone',
    selected: false,
  ),
];

class LongmenClaimRecord {
  const LongmenClaimRecord({
    required this.id,
    required this.claim,
    required this.truthStatus,
    required this.source,
    required this.sourceType,
    required this.sourceLocationOrIdentifier,
    required this.sourceConfidence,
    required this.storyUse,
    required this.interpretationBoundary,
    required this.result,
  });

  final String id;
  final String claim;
  final String truthStatus;
  final String source;
  final String sourceType;
  final String sourceLocationOrIdentifier;
  final String sourceConfidence;
  final String storyUse;
  final String interpretationBoundary;
  final String result;
}

const luoyangLongmenClaimLedger = <LongmenClaimRecord>[
  LongmenClaimRecord(
    id: 'LM-C1-site',
    claim: '龙门石窟分布于洛阳南部伊河两岸陡峭石灰岩崖壁，主要遗存沿约一公里河段展开。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO World Heritage Centre · Longmen Grottoes',
    sourceType: 'UNESCO',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：地点与空间基础',
    interpretationBoundary: '不从地形自动推导未被来源支持的历史路线或个人行动。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C2-scale',
    claim: '龙门有两千三百余个洞窟和佛龛、十万余尊造像及两千八百余块碑刻题记。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO / 龙门石窟研究院',
    sourceType: 'UNESCO + OFFICIAL HERITAGE INSTITUTION',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003 ; https://www.lmsk.cn/Gywm_id_5.html',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：规模与题记证据',
    interpretationBoundary: '数字按权威来源使用“余/约”表达，不提高精确度。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C3-chronology',
    claim: '龙门密集开凿主要从公元五世纪末延续至八世纪中叶。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO World Heritage Centre',
    sourceType: 'UNESCO',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：时间层',
    interpretationBoundary: '不把“主要时期”误写成全部营造只发生在这一时段。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C4-wanfo-niche',
    claim: '万佛洞前室南壁一处观音像龛题记记录比丘尼真智发愿造像及永隆二年五月八日完成时间，造像面部现已残损。',
    truthStatus: 'VERIFIED HISTORICAL ACTION',
    source: '龙门石窟研究院 · 万佛洞数字化展示资料',
    sourceType: 'OFFICIAL HERITAGE INSTITUTION',
    sourceLocationOrIdentifier: 'https://www.lmsk.cn/',
    sourceConfidence: 'HIGH',
    storyUse: 'Story 核心事实：题记、完成时间与残损现状形成不同证据层',
    interpretationBoundary: '不把“发愿造像者”写成亲手雕刻的工匠；不推断真智的私人心理。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C5-virtual-restoration',
    claim: '龙门石窟研究院以历史老照片为重要研究依据，结合三维数字化、文物保护与雕塑等研究，对该观音像龛进行虚拟复原展示。',
    truthStatus: 'VERIFIED HISTORICAL ACTION',
    source: '龙门石窟研究院 · 万佛洞数字化展示资料',
    sourceType: 'OFFICIAL HERITAGE INSTITUTION',
    sourceLocationOrIdentifier: 'https://www.lmsk.cn/',
    sourceConfidence: 'HIGH',
    storyUse: 'Story 核心事实：有据复原与无依据想象的边界',
    interpretationBoundary: '不宣称虚拟复原等于原貌被完全证明；不补写来源未支持的面部细节。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C6-patrons',
    claim: '龙门现存造像题记显示营造参与者包括皇室贵族、商会社团、普通信众等不同群体。',
    truthStatus: 'VERIFIED CULTURAL PRACTICE',
    source: '龙门石窟研究院 · 龙门概况',
    sourceType: 'OFFICIAL HERITAGE INSTITUTION',
    sourceLocationOrIdentifier: 'https://www.lmsk.cn/Gywm_id_5.html',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：造像活动的社会广度',
    interpretationBoundary: '不为任何无名个体添加未记录的身份、动机或关系。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C7-dispersal',
    claim: '宾阳中洞帝后礼佛图在二十世纪三十年代遭盗凿，相关浮雕现分藏海外博物馆。',
    truthStatus: 'VERIFIED FACT',
    source: '龙门石窟研究院 · 流失海外文物',
    sourceType: 'OFFICIAL HERITAGE INSTITUTION',
    sourceLocationOrIdentifier: 'https://en.lmsk.cn/Gywm_id_8.html',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery / future Place Story opportunity',
    interpretationBoundary: '不把数字合成或学术复原表述成实体文物已经回归。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C8-medicine',
    claim: '药方洞保存约一百四十则药方题记，是研究历史医疗知识的材料。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO World Heritage Centre',
    sourceType: 'UNESCO',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：题记内容的多样性',
    interpretationBoundary: '历史药方不等于现代医学有效性建议。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C9-conservation',
    claim: '龙门保护工作持续研究风化、水害、岩体稳定等病害，并使用监测、调查与科学保护手段。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO / 河南省文化和旅游厅',
    sourceType: 'UNESCO + GOVERNMENT',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003 ; https://hct.henan.gov.cn/2022/06-15/2468099.html',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：现存状态与保护',
    interpretationBoundary: '不把特定病害强行归因于单一因素，不编造未公开的修复方法。',
    result: 'PASS',
  ),
  LongmenClaimRecord(
    id: 'LM-C10-authenticity',
    claim: 'UNESCO 对龙门真实性与保护的评价强调保存历史状态、持续监测并依据研究开展保护。',
    truthStatus: 'VERIFIED FACT',
    source: 'UNESCO World Heritage Centre',
    sourceType: 'UNESCO',
    sourceLocationOrIdentifier: 'https://whc.unesco.org/en/list/1003',
    sourceConfidence: 'HIGH',
    storyUse: 'Discovery：真实性与证据边界',
    interpretationBoundary: '“保存历史状态”不被扩写成禁止一切展示性虚拟复原。',
    result: 'PASS',
  ),
];

const luoyangLongmenFuturePlaceStoryOpportunities = <String>[
  '宾阳中洞帝后礼佛图流散形成的 PLACE NETWORK STORY',
  '古阳洞密集题记中的普通供养人与邑社实践',
  '药方洞题记作为历史知识记录而非现代医疗建议',
  '奉先寺长期风化、水害与科学保护形成的 TEMPORAL TRACE',
];

class _LongmenStorySegment {
  const _LongmenStorySegment({
    required this.fromLevel,
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final int fromLevel;
  final String chinese;
  final String vietnamese;
  final String english;
}

const _longmenCoreSegments = <_LongmenStorySegment>[
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '林砚和周澄合做龙门石窟数字短片，约定并列署名，共同为复原依据负责。',
    vietnamese: 'Lâm Nghiên và Chu Trừng cùng làm phim ngắn kỹ thuật số về Long Môn, thống nhất cùng đứng tên và cùng chịu trách nhiệm về căn cứ phục dựng.',
    english: 'Lin Yan and Zhou Cheng make a digital short about Longmen, agreeing to share credit and responsibility for its restoration evidence.',
  ),
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '镜头停在万佛洞前室南壁的一处观音像龛：题记留下发愿造像者和完成时间，像的脸部却已残损。',
    vietnamese: 'Máy quay dừng ở một khám Quan Âm trên tường nam tiền thất động Vạn Phật: minh văn còn ghi người phát nguyện tạo tượng và thời điểm hoàn thành, nhưng phần mặt của tượng đã bị hư hại.',
    english: 'The shot stops at a Guanyin niche on the south wall of the front chamber of Wanfo Cave: its inscription records the person who commissioned the image and its completion date, while the face is damaged.',
  ),
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '林砚为转场做了“补全脸部”模型。周澄摆出老照片：“没依据，不能放在我们两人的名字下。”',
    vietnamese: 'Lâm Nghiên làm lớp mô hình “bù lại khuôn mặt” cho đoạn chuyển cảnh. Chu Trừng đặt ảnh cũ ra: “Không có căn cứ thì không thể đặt dưới tên hai chúng ta.”',
    english: 'Lin Yan makes a “completed face” model for the transition. Zhou Cheng lays out the old photographs. “Without evidence, it cannot sit under both our names.”',
  ),
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '林砚答不出来。官方复原以历史老照片为基础，她这一层却只是按自己理解的唐代造像风格补的。',
    vietnamese: 'Lâm Nghiên không trả lời được. Phục dựng chính thức dựa trên ảnh lịch sử cũ; lớp của cô chỉ được bổ theo cách cô tự hiểu về phong cách tạo tượng đời Đường.',
    english: 'Lin Yan has no answer. The official virtual restoration is based on historical photographs; her layer is filled in only from her own interpretation of Tang sculptural style.',
  ),
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '她看了三天渲染和片尾两个名字，亲手关掉那层。短片失去最顺滑的镜头；周澄把老照片接回时间线。',
    vietnamese: 'Cô nhìn ba ngày kết xuất và hai cái tên cuối phim rồi tự tay tắt lớp đó. Phim mất cảnh chuyển mượt nhất; Chu Trừng nối ảnh cũ trở lại dòng thời gian.',
    english: 'She looks at three days of rendering and the two names in the credits, then turns the layer off herself. The short loses its smoothest transition; Zhou Cheng reconnects the old photographs to the timeline.',
  ),
  _LongmenStorySegment(
    fromLevel: 1,
    chinese: '导出前，周澄保留并列署名，推来来源清单。林砚核完，把那层改名为“无依据，不使用”，按下导出。',
    vietnamese: 'Trước khi xuất file, Chu Trừng giữ nguyên tên hai người và đẩy danh mục nguồn sang. Lâm Nghiên kiểm tra xong, đổi tên lớp thành “không có căn cứ, không sử dụng” rồi bấm xuất.',
    english: 'Before export, Zhou Cheng keeps both names and slides over the source list. Lin Yan checks it, renames the layer “unsupported, do not use,” and presses Export.',
  ),
];

const _longmenDepthSegments = <_LongmenStorySegment>[
  _LongmenStorySegment(
    fromLevel: 2,
    chinese: '她第一次把“看起来像”与“有资料支持”分开记录。',
    vietnamese: 'Lần đầu tiên, cô ghi riêng “trông có vẻ đúng” và “có tư liệu hỗ trợ”.',
    english: 'For the first time, she records “looks plausible” separately from “supported by sources.”',
  ),
  _LongmenStorySegment(
    fromLevel: 3,
    chinese: '此前她总觉得周澄追问出处，会把一个本来流畅的画面切碎。',
    vietnamese: 'Trước đó, cô luôn thấy việc Chu Trừng hỏi nguồn sẽ cắt vụn một hình ảnh vốn đang trôi chảy.',
    english: 'Until then, she has felt that Zhou Cheng’s source questions break apart an otherwise fluid image.',
  ),
  _LongmenStorySegment(
    fromLevel: 4,
    chinese: '这次，残损不再只是等待补满的空白，而成了不能越过的证据边界。',
    vietnamese: 'Lần này, phần hư khuyết không còn chỉ là khoảng trống chờ được lấp đầy, mà trở thành ranh giới bằng chứng không thể tùy tiện vượt qua.',
    english: 'This time, the damage is no longer merely a blank waiting to be filled; it becomes an evidence boundary she cannot simply cross.',
  ),
  _LongmenStorySegment(
    fromLevel: 5,
    chinese: '题记说明了发愿造像者和完成时间；历史老照片支持复原，但不等于所有想象都有同样资格。',
    vietnamese: 'Minh văn cho biết người phát nguyện tạo tượng và thời điểm hoàn thành; ảnh lịch sử cũ hỗ trợ phục dựng, nhưng điều đó không có nghĩa mọi tưởng tượng đều có cùng tư cách.',
    english: 'The inscription identifies the person who commissioned the image and its completion date; historical photographs support restoration, but that does not give every imagined detail equal standing.',
  ),
  _LongmenStorySegment(
    fromLevel: 6,
    chinese: '她删掉的是视觉上更完整、证据上更弱的版本，三天渲染时间成了选择的成本。',
    vietnamese: 'Cô xóa phiên bản hoàn chỉnh hơn về thị giác nhưng yếu hơn về bằng chứng; ba ngày kết xuất trở thành cái giá của lựa chọn.',
    english: 'She deletes the version that is visually more complete but evidentially weaker; three days of rendering become the cost of the choice.',
  ),
  _LongmenStorySegment(
    fromLevel: 7,
    chinese: '周澄把资料分成“现存状态”“有据复原”“解释性示意”，不再混用“复原图”一个标签。',
    vietnamese: 'Chu Trừng chia tư liệu thành “tình trạng hiện còn”, “phục dựng có căn cứ” và “minh họa diễn giải”, không còn gom tất cả dưới một nhãn “ảnh phục dựng”.',
    english: 'Zhou Cheng separates the material into “current condition,” “evidence-based restoration,” and “interpretive illustration,” rather than using one restoration label for all three.',
  ),
  _LongmenStorySegment(
    fromLevel: 8,
    chinese: '两人的合作也变了：林砚开始在建模前先问，每一层证据究竟能支持到哪里。',
    vietnamese: 'Cách hai người hợp tác cũng thay đổi: trước khi dựng mô hình, Lâm Nghiên bắt đầu hỏi mỗi lớp bằng chứng thực sự hỗ trợ được đến đâu.',
    english: 'Their collaboration changes too: before modeling, Lin Yan begins asking how far each layer of evidence can actually support the image.',
  ),
  _LongmenStorySegment(
    fromLevel: 9,
    chinese: '镜头经过残损面部时不再自动补齐，而是停一下，再切到注明来源的历史照片与有据虚拟复原。',
    vietnamese: 'Khi máy quay đi qua phần mặt bị hư, hình ảnh không còn tự động bù đầy; nó dừng lại rồi chuyển sang ảnh lịch sử có ghi nguồn và phần phục dựng ảo có căn cứ.',
    english: 'When the shot reaches the damaged face, it no longer fills the gap automatically; it pauses, then cuts to a sourced historical photograph and an evidence-based virtual restoration.',
  ),
  _LongmenStorySegment(
    fromLevel: 10,
    chinese: '最后一帧回到今天的石面，没有替过去补上更方便的答案；“无依据，不使用”仍留在工程文件里。',
    vietnamese: 'Khung hình cuối trở về mặt đá hôm nay, không bổ cho quá khứ một câu trả lời thuận tiện hơn; lớp “không có căn cứ, không sử dụng” vẫn nằm trong tệp dự án.',
    english: 'The final frame returns to the stone as it exists today, without supplying the past with a more convenient answer; “unsupported, do not use” remains in the project file.',
  ),
];

class _LongmenDiscoveryFact {
  const _LongmenDiscoveryFact({
    required this.chinese,
    required this.simpleChinese,
    required this.vietnamese,
    required this.english,
    required this.sourceIds,
  });

  final String chinese;
  final String simpleChinese;
  final String vietnamese;
  final String english;
  final List<String> sourceIds;
}

const _longmenCommonDiscovery = _LongmenDiscoveryFact(
  chinese: '龙门石窟分布在洛阳南部伊河两岸的石灰岩崖壁上，两千三百余个洞窟和佛龛沿约一公里河段展开。',
  simpleChinese: '龙门石窟在伊河两边的山崖上，很多洞窟和佛龛沿河分布。',
  vietnamese: 'Hang đá Long Môn nằm trên các vách đá vôi hai bên sông Y ở phía nam Lạc Dương; hơn 2.300 hang và khám tượng trải dọc khoảng một kilômét.',
  english: 'The Longmen Grottoes occupy limestone cliffs on both sides of the Yi River south of Luoyang, with more than 2,300 caves and niches extending for about one kilometre.',
  sourceIds: ['unesco-luoyang-longmen-grottoes'],
);

const _longmenPrimaryDiscoveries = <_LongmenDiscoveryFact>[
  _LongmenDiscoveryFact(
    chinese: '龙门还保存两千八百余块碑刻题记。它们让石窟不仅有造像，也留下发愿、造像和题名等人的记录。',
    simpleChinese: '龙门有很多碑刻题记，石头上也留下了人的名字和活动记录。',
    vietnamese: 'Long Môn còn bảo tồn hơn 2.800 bia khắc và minh văn. Nhờ đó, các hang đá không chỉ có tượng mà còn giữ dấu vết về phát nguyện, tạo tượng và tên người.',
    english: 'Longmen also preserves more than 2,800 inscribed steles and records. They leave human traces of vows, image-making, and names alongside the sculptures.',
    sourceIds: ['unesco-luoyang-longmen-grottoes', 'longmen-academy-overview'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门的大规模开凿主要从公元五世纪末延续到八世纪中叶，因此同一遗址能看到不同历史阶段的造像与题记。',
    simpleChinese: '龙门主要在五世纪末到八世纪中叶持续开凿，留下不同时间的作品。',
    vietnamese: 'Hoạt động tạc khắc quy mô lớn ở Long Môn chủ yếu kéo dài từ cuối thế kỷ V đến giữa thế kỷ VIII, nên cùng một di tích lưu lại tượng và minh văn của nhiều giai đoạn.',
    english: 'Intensive carving at Longmen ran mainly from the late fifth century to the mid-eighth century, leaving sculpture and inscriptions from different historical phases at one site.',
    sourceIds: ['unesco-luoyang-longmen-grottoes'],
  ),
  _LongmenDiscoveryFact(
    chinese: '古阳洞有一千五百余个造像窟龛和八百余块碑刻题记，密集的石面记录让研究者能够看到许多不同供养者留下的痕迹。',
    simpleChinese: '古阳洞有很多造像龛和题记，可以看到很多人的活动痕迹。',
    vietnamese: 'Động Cổ Dương có hơn 1.500 khám tạo tượng và hơn 800 bia khắc, khiến bề mặt đá dày đặc dấu vết của nhiều người cúng tạo khác nhau.',
    english: 'Guyang Cave contains more than 1,500 image niches and over 800 inscriptions, creating a dense record of traces left by many different donors.',
    sourceIds: ['longmen-academy-overview'],
  ),
  _LongmenDiscoveryFact(
    chinese: '万佛洞前室南壁一处观音像龛的题记记录比丘尼真智发愿造像及完成时间；今天这尊造像的脸部已经残损。',
    simpleChinese: '万佛洞的一处观音像龛有题记，也有残损。题记告诉我们谁发愿造像以及何时完成。',
    vietnamese: 'Một khám Quan Âm trên tường nam tiền thất động Vạn Phật có minh văn ghi ni cô Chân Trí phát nguyện tạo tượng và thời điểm hoàn thành; ngày nay phần mặt của tượng đã bị hư hại.',
    english: 'An inscription on a Guanyin niche on the south wall of Wanfo Cave’s front chamber records the nun Zhenzhi commissioning the image and its completion date; the face is damaged today.',
    sourceIds: ['longmen-academy-wanfo-virtual-restoration'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门石窟研究院以历史老照片为重要依据，结合三维数字化等研究，对这处残损观音像进行了虚拟复原。虚拟复原是有来源的研究展示，不等于所有缺失细节都已被证明。',
    simpleChinese: '研究人员参考历史老照片做虚拟复原，但有据复原和自由想象不是一回事。',
    vietnamese: 'Viện Nghiên cứu Hang đá Long Môn dùng ảnh lịch sử cũ làm căn cứ quan trọng và kết hợp số hóa 3D để phục dựng ảo khám Quan Âm bị hư hại. Phục dựng ảo có căn cứ nghiên cứu không có nghĩa mọi chi tiết mất đi đều đã được chứng minh.',
    english: 'The Longmen Academy used historical photographs as important evidence, together with 3D digitization and related research, for a virtual restoration of the damaged Guanyin image. Evidence-based virtual restoration does not mean every missing detail has been proven.',
    sourceIds: ['longmen-academy-wanfo-virtual-restoration'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门题记显示，参与造像活动的并不只有皇室贵族，也包括商会社团和普通信众等群体。石窟因此保存了不同社会层次参与宗教造像的记录。',
    simpleChinese: '龙门造像活动有不同社会群体参加，不只来自皇室。',
    vietnamese: 'Minh văn Long Môn cho thấy hoạt động tạo tượng không chỉ có hoàng thất và quý tộc mà còn có hội buôn và tín đồ bình thường, để lại dấu vết của nhiều tầng lớp xã hội.',
    english: 'Longmen inscriptions show that image-making involved not only royal and elite patrons but also merchant associations and ordinary believers, preserving records from different social groups.',
    sourceIds: ['longmen-academy-overview'],
  ),
  _LongmenDiscoveryFact(
    chinese: '宾阳中洞的帝后礼佛图在二十世纪三十年代遭盗凿，相关石刻后来分藏海外博物馆。原址的缺失与异地现存文物必须同时记录。',
    simpleChinese: '宾阳中洞的一些浮雕被盗凿后流散海外，原来的位置留下缺失。',
    vietnamese: 'Các phù điêu lễ Phật của hoàng đế và hoàng hậu ở động Trung Tân Dương bị đục lấy trong thập niên 1930 và về sau được lưu giữ tại các bảo tàng ở nước ngoài. Cả khoảng trống tại nguyên vị trí lẫn hiện vật còn tồn tại ở nơi khác đều cần được ghi nhận.',
    english: 'The emperor and empress worship reliefs from Binyang Central Cave were chiseled out in the 1930s and later entered overseas museum collections. The loss at the original site and the surviving objects elsewhere must both be recorded.',
    sourceIds: ['longmen-academy-dispersed-objects'],
  ),
  _LongmenDiscoveryFact(
    chinese: '药方洞保存约一百四十则药方题记，为研究历史医疗知识提供材料。它们属于历史记录，不能因为刻在石上就当作现代医疗建议。',
    simpleChinese: '药方洞的历史药方是研究材料，不是今天的医疗建议。',
    vietnamese: 'Động Dược Phương lưu khoảng 140 minh văn phương thuốc, là tư liệu để nghiên cứu tri thức y học lịch sử. Chúng là ghi chép lịch sử, không phải lời khuyên y khoa hiện đại chỉ vì được khắc trên đá.',
    english: 'Yaofang Cave preserves about 140 medical-formula inscriptions, evidence for studying historical medical knowledge. They are historical records, not modern medical advice simply because they were carved in stone.',
    sourceIds: ['unesco-luoyang-longmen-grottoes'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门保护研究面对岩体、水害、风化等长期变化。调查与监测的意义，是先确认现存状态和变化来源，再决定如何保护。',
    simpleChinese: '保护龙门要先调查和监测岩体、水害、风化等变化。',
    vietnamese: 'Công tác bảo tồn Long Môn phải đối diện với biến đổi lâu dài của khối đá, nước và phong hóa. Khảo sát và giám sát giúp xác định tình trạng hiện còn và nguồn biến đổi trước khi quyết định cách bảo vệ.',
    english: 'Longmen conservation addresses long-term changes involving rock stability, water, and weathering. Survey and monitoring establish current condition and sources of change before treatment decisions are made.',
    sourceIds: ['unesco-luoyang-longmen-grottoes', 'henan-longmen-conservation'],
  ),
  _LongmenDiscoveryFact(
    chinese: 'UNESCO 对龙门真实性的评价强调保存历史状态并持续以研究、监测支持保护。真实性不是把所有残损补成“最完整”的样子，而是让来源和现存状态保持可辨。',
    simpleChinese: '龙门保护重视历史状态、研究和监测，不能为了完整外观而混淆证据。',
    vietnamese: 'Đánh giá của UNESCO về tính xác thực của Long Môn nhấn mạnh việc giữ tình trạng lịch sử và dùng nghiên cứu, giám sát để hỗ trợ bảo tồn. Tính xác thực không có nghĩa lấp đầy mọi hư khuyết thành hình ảnh “hoàn chỉnh nhất”, mà là giữ cho nguồn chứng cứ và tình trạng hiện còn có thể phân biệt.',
    english: 'UNESCO’s assessment of Longmen authenticity emphasizes retaining historic condition and supporting conservation through research and monitoring. Authenticity does not mean filling every loss into the “most complete” appearance; evidence sources and current condition must remain distinguishable.',
    sourceIds: ['unesco-luoyang-longmen-grottoes'],
  ),
];

const _longmenDeepDiscoveries = <_LongmenDiscoveryFact>[
  _LongmenDiscoveryFact(
    chinese: '同一处造像可以有“现存石面”“历史照片”“有据虚拟复原”等不同资料层。把它们分别标注，能让观看者知道哪些是今天仍在的，哪些是依据资料重建的。',
    simpleChinese: '现存状态、历史照片和有据复原应该分开标注。',
    vietnamese: 'Cùng một pho tượng có thể có nhiều lớp tư liệu như “mặt đá hiện còn”, “ảnh lịch sử” và “phục dựng ảo có căn cứ”. Ghi nhãn riêng giúp người xem biết đâu là hiện trạng và đâu là phần tái dựng từ tư liệu.',
    english: 'One sculpture can have distinct evidence layers such as present stone, historical photographs, and evidence-based virtual restoration. Separate labels tell viewers what survives today and what has been reconstructed from records.',
    sourceIds: ['longmen-academy-wanfo-virtual-restoration'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门题记中的发愿造像者与真正执行雕刻的工匠不是自动等同的身份。来源只证明到哪一步，叙述就应该只走到哪一步。',
    simpleChinese: '题记写谁发愿造像，不等于一定知道谁亲手雕刻。',
    vietnamese: 'Người phát nguyện tạo tượng được ghi trong minh văn không tự động đồng nhất với thợ trực tiếp chạm khắc. Nguồn chứng minh đến đâu, lời kể chỉ nên đi đến đó.',
    english: 'The person recorded as commissioning an image is not automatically the craftsperson who carved it. The narrative should go only as far as the evidence does.',
    sourceIds: ['longmen-academy-wanfo-virtual-restoration'],
  ),
  _LongmenDiscoveryFact(
    chinese: '流散文物的现藏地点可以确认，但“如果没有被盗凿会怎样”属于不能验证的历史假设。缺失本身可以被记录，不需要编出另一条历史。',
    simpleChinese: '可以确认文物今天在哪里，但不能把没有发生的另一种历史写成事实。',
    vietnamese: 'Có thể xác nhận nơi hiện vật lưu giữ ngày nay, nhưng câu hỏi “nếu không bị lấy đi thì sẽ ra sao” là giả định lịch sử không thể kiểm chứng. Sự mất mát tự nó có thể được ghi lại mà không cần bịa thêm một lịch sử khác.',
    english: 'The present locations of dispersed objects can be verified, but “what would have happened if they had not been removed” is an unverifiable counterfactual. The absence itself can be recorded without inventing another history.',
    sourceIds: ['longmen-academy-dispersed-objects'],
  ),
  _LongmenDiscoveryFact(
    chinese: '历史题记提供文字证据，但文字也有时代语境。把药方洞题记当作历史知识来源，不等于证明其中每种做法在现代医学中有效。',
    simpleChinese: '历史文字要按历史语境理解，不能直接变成今天的医学结论。',
    vietnamese: 'Minh văn lịch sử cung cấp chứng cứ văn bản nhưng thuộc bối cảnh của thời đại mình. Dùng minh văn Động Dược Phương làm nguồn lịch sử không có nghĩa chứng minh mọi cách chữa trong đó có hiệu quả theo y học hiện đại.',
    english: 'Historical inscriptions provide textual evidence within their own period. Using Yaofang Cave inscriptions as historical sources does not prove that every treatment in them is effective in modern medicine.',
    sourceIds: ['unesco-luoyang-longmen-grottoes'],
  ),
  _LongmenDiscoveryFact(
    chinese: '奉先寺等区域的保护调查会记录渗水、岩体和表面病害，也可能发现玻璃眼、颜料等新证据。新发现可以增加理解，但仍不能反向补写没有证据的完整原貌。',
    simpleChinese: '保护调查会发现新证据，但新证据也不能证明所有缺失细节。',
    vietnamese: 'Khảo sát bảo tồn ở các khu vực như Phụng Tiên Tự ghi nhận thấm nước, khối đá và tổn hại bề mặt, đồng thời có thể phát hiện chứng cứ mới như mắt kính hay dấu màu. Phát hiện mới mở rộng hiểu biết nhưng không cho phép suy ngược một nguyên trạng hoàn chỉnh khi thiếu chứng cứ.',
    english: 'Conservation surveys in areas such as Fengxian Temple record seepage, rock conditions, and surface deterioration, and can reveal new evidence such as glass eyes or pigment traces. New findings deepen understanding but do not justify inventing a complete original appearance where evidence is absent.',
    sourceIds: ['henan-longmen-conservation'],
  ),
  _LongmenDiscoveryFact(
    chinese: '龙门的真实性也包括遗址、崖壁、伊河环境与长期历史变化形成的整体关系。保护不是把时间擦掉，而是在真实性依据下继续识别和管理变化。',
    simpleChinese: '龙门的真实性包括遗址与环境的关系，也包括时间留下的变化。',
    vietnamese: 'Tính xác thực của Long Môn còn bao gồm quan hệ giữa di tích, vách đá, sông Y và những biến đổi lịch sử lâu dài. Bảo tồn không xóa thời gian mà tiếp tục nhận diện và quản lý biến đổi dựa trên chứng cứ xác thực.',
    english: 'Longmen authenticity also includes the relationship among the site, cliffs, Yi River setting, and long historical change. Conservation does not erase time; it identifies and manages change on an evidence-based foundation.',
    sourceIds: ['unesco-luoyang-longmen-grottoes'],
  ),
];

DiscoveryEntry _discovery(_LongmenDiscoveryFact fact) => DiscoveryEntry(
      text: fact.chinese,
      pinyin: PinyinHelper.getPinyinE(
        fact.chinese,
        separator: ' ',
        format: PinyinFormat.WITH_TONE_MARK,
      ),
      simpleChinese: fact.simpleChinese,
      vietnamese: fact.vietnamese,
      english: fact.english,
    );

List<DiscoveryEntry> _longmenDiscoveriesForLevel(int level) {
  final facts = <_LongmenDiscoveryFact>[
    _longmenCommonDiscovery,
    _longmenPrimaryDiscoveries[level - 1],
    if (level >= 5) _longmenDeepDiscoveries[level - 5],
  ];
  return List<DiscoveryEntry>.unmodifiable(facts.map(_discovery));
}

WordEntry _longmenWord({
  required String word,
  required String pinyin,
  required String partOfSpeech,
  required String simpleChinese,
  required String vietnamese,
  required String english,
  required String symbol,
  required String sourceSentence,
  required String sourceVietnamese,
  required String sourceEnglish,
}) {
  return WordEntry(
    word: word,
    pinyin: pinyin,
    partOfSpeech: partOfSpeech,
    simpleChinese: simpleChinese,
    translation: vietnamese,
    englishDefinition: english,
    symbol: symbol,
    examples: <WordExample>[
      WordExample(
        chinese: sourceSentence,
        pinyin: PinyinHelper.getPinyinE(
          sourceSentence,
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        ),
        vietnamese: sourceVietnamese,
        english: sourceEnglish,
      ),
      WordExample(
        chinese: '故事里，“$word”必须回到当前证据和上下文来理解。',
        pinyin: PinyinHelper.getPinyinE(
          '故事里，“$word”必须回到当前证据和上下文来理解。',
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        ),
        vietnamese: 'Trong câu chuyện, “$word” phải được hiểu từ chứng cứ và ngữ cảnh hiện tại.',
        english: 'In the story, “$word” must be understood from the current evidence and context.',
      ),
      WordExample(
        chinese: '回看原句，判断“$word”怎样影响人物选择或历史理解。',
        pinyin: PinyinHelper.getPinyinE(
          '回看原句，判断“$word”怎样影响人物选择或历史理解。',
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        ),
        vietnamese: 'Hãy đọc lại câu gốc và xem “$word” ảnh hưởng đến lựa chọn của nhân vật hoặc cách hiểu lịch sử như thế nào.',
        english: 'Re-read the source sentence and decide how “$word” affects the character’s choice or historical understanding.',
      ),
    ],
  );
}

final luoyangLongmenWords = <WordEntry>[
  _longmenWord(word: '题记', pinyin: 'tíjì', partOfSpeech: '名词', simpleChinese: '刻写在文物或建筑上的文字记录。', vietnamese: 'minh văn hoặc ghi chép khắc trên hiện vật', english: 'an inscription or inscribed record', symbol: '✍️', sourceSentence: '题记留下发愿造像者和完成时间。', sourceVietnamese: 'Minh văn ghi người phát nguyện tạo tượng và thời điểm hoàn thành.', sourceEnglish: 'The inscription records the person who commissioned the image and its completion date.'),
  _longmenWord(word: '残损', pinyin: 'cánsǔn', partOfSpeech: '名词/形容词', simpleChinese: '因损坏而不完整的状态。', vietnamese: 'tình trạng hư hại, khuyết mất', english: 'damage or loss that leaves something incomplete', symbol: '🪨', sourceSentence: '像的脸部却已残损。', sourceVietnamese: 'Phần mặt của tượng đã bị hư hại.', sourceEnglish: 'The face of the image is damaged.'),
  _longmenWord(word: '依据', pinyin: 'yījù', partOfSpeech: '名词', simpleChinese: '用来支持判断的资料或理由。', vietnamese: 'căn cứ dùng để hỗ trợ một phán đoán', english: 'evidence or grounds for a judgment', symbol: '📎', sourceSentence: '周澄只问：“依据在哪里？”', sourceVietnamese: 'Chu Trừng chỉ hỏi: “Căn cứ ở đâu?”', sourceEnglish: 'Zhou Cheng asks only, “What is the evidence?”'),
  _longmenWord(word: '史料', pinyin: 'shǐliào', partOfSpeech: '名词', simpleChinese: '研究历史时使用的资料。', vietnamese: 'tư liệu lịch sử', english: 'historical source material', symbol: '📚', sourceSentence: '周澄核对史料。', sourceVietnamese: 'Chu Trừng kiểm tra tư liệu lịch sử.', sourceEnglish: 'Zhou Cheng checks the historical sources.'),
  _longmenWord(word: '石窟', pinyin: 'shíkū', partOfSpeech: '名词', simpleChinese: '在岩壁或山体中开凿的洞窟。', vietnamese: 'hang được đục trong vách đá', english: 'rock-cut grotto', symbol: '🪨', sourceSentence: '龙门石窟分布在伊河两岸的石灰岩崖壁上。', sourceVietnamese: 'Hang đá Long Môn nằm trên các vách đá vôi hai bên sông Y.', sourceEnglish: 'The Longmen Grottoes occupy limestone cliffs on both sides of the Yi River.'),
  _longmenWord(word: '碑刻', pinyin: 'bēikè', partOfSpeech: '名词', simpleChinese: '刻在石碑或石面上的文字与刻痕。', vietnamese: 'văn khắc trên bia hoặc mặt đá', english: 'stone inscription or engraved stele', symbol: '🗿', sourceSentence: '龙门还保存两千八百余块碑刻题记。', sourceVietnamese: 'Long Môn còn bảo tồn hơn 2.800 bia khắc và minh văn.', sourceEnglish: 'Longmen also preserves more than 2,800 inscribed steles and records.'),
  _longmenWord(word: '造像', pinyin: 'zàoxiàng', partOfSpeech: '名词/动词', simpleChinese: '制作宗教形象，或由此形成的形象。', vietnamese: 'tạo tượng tôn giáo hoặc tượng được tạo ra', english: 'the making of a religious image; a religious image', symbol: '🕯️', sourceSentence: '题记记录比丘尼真智发愿造像。', sourceVietnamese: 'Minh văn ghi ni cô Chân Trí phát nguyện tạo tượng.', sourceEnglish: 'The inscription records the nun Zhenzhi commissioning the image.'),
  _longmenWord(word: '复原', pinyin: 'fùyuán', partOfSpeech: '动词/名词', simpleChinese: '根据资料研究并重建已损失的形态或信息。', vietnamese: 'phục dựng dựa trên tư liệu nghiên cứu', english: 'restoration or reconstruction based on evidence', symbol: '🧩', sourceSentence: '官方复原以历史老照片为基础。', sourceVietnamese: 'Phục dựng chính thức dựa trên ảnh lịch sử cũ.', sourceEnglish: 'The official restoration is based on historical photographs.'),
  _longmenWord(word: '证据', pinyin: 'zhèngjù', partOfSpeech: '名词', simpleChinese: '能够支持或限制一种说法的材料。', vietnamese: 'bằng chứng hỗ trợ hoặc giới hạn một nhận định', english: 'evidence that supports or limits a claim', symbol: '🔎', sourceSentence: '她删掉的是视觉上更完整、证据上更弱的版本。', sourceVietnamese: 'Cô xóa phiên bản hoàn chỉnh hơn về thị giác nhưng yếu hơn về bằng chứng.', sourceEnglish: 'She deletes the version that is visually more complete but evidentially weaker.'),
  _longmenWord(word: '窟龛', pinyin: 'kūkān', partOfSpeech: '名词', simpleChinese: '石窟中的洞窟与造像龛。', vietnamese: 'hang và khám tượng trong quần thể hang đá', english: 'caves and image niches', symbol: '⛰️', sourceSentence: '古阳洞有一千五百余个造像窟龛。', sourceVietnamese: 'Động Cổ Dương có hơn 1.500 hang và khám tạo tượng.', sourceEnglish: 'Guyang Cave has more than 1,500 image caves and niches.'),
  _longmenWord(word: '现存', pinyin: 'xiàncún', partOfSpeech: '形容词/动词', simpleChinese: '现在仍然保存或存在。', vietnamese: 'hiện còn tồn tại', english: 'surviving or existing today', symbol: '📍', sourceSentence: '周澄把资料分成“现存状态”“有据复原”“解释性示意”。', sourceVietnamese: 'Chu Trừng chia tư liệu thành “tình trạng hiện còn”, “phục dựng có căn cứ” và “minh họa diễn giải”.', sourceEnglish: 'Zhou Cheng separates the material into “current condition,” “evidence-based restoration,” and “interpretive illustration.”'),
  _longmenWord(word: '示意', pinyin: 'shìyì', partOfSpeech: '动词/名词', simpleChinese: '用简化图像或方式说明意思。', vietnamese: 'minh họa để giải thích', english: 'to illustrate or an explanatory illustration', symbol: '🗺️', sourceSentence: '解释性示意不能和有据复原混成同一标签。', sourceVietnamese: 'Minh họa diễn giải không được gộp cùng nhãn với phục dựng có căn cứ.', sourceEnglish: 'Interpretive illustration must not be merged under the same label as evidence-based restoration.'),
  _longmenWord(word: '虚拟', pinyin: 'xūnǐ', partOfSpeech: '形容词', simpleChinese: '由数字技术构成而非实体存在。', vietnamese: 'ảo, được tạo bằng công nghệ số', english: 'virtual; digitally constructed', symbol: '🖥️', sourceSentence: '研究人员依据历史老照片进行了虚拟复原。', sourceVietnamese: 'Các nhà nghiên cứu dựa vào ảnh lịch sử để thực hiện phục dựng ảo.', sourceEnglish: 'Researchers used historical photographs for a virtual restoration.'),
  _longmenWord(word: '风化', pinyin: 'fēnghuà', partOfSpeech: '名词/动词', simpleChinese: '岩石或材料长期受到自然作用而发生变化。', vietnamese: 'phong hóa do tác động tự nhiên lâu dài', english: 'weathering of stone or material', symbol: '🌬️', sourceSentence: '龙门保护研究面对岩体、水害、风化等长期变化。', sourceVietnamese: 'Nghiên cứu bảo tồn Long Môn đối diện với biến đổi lâu dài của khối đá, nước và phong hóa.', sourceEnglish: 'Longmen conservation research addresses long-term changes involving rock, water, and weathering.'),
  _longmenWord(word: '来源', pinyin: 'láiyuán', partOfSpeech: '名词', simpleChinese: '资料、信息或证据来自哪里。', vietnamese: 'nguồn gốc của tư liệu hoặc bằng chứng', english: 'the source of information or evidence', symbol: '🔖', sourceSentence: '镜头切到注明来源的历史照片与有据虚拟复原。', sourceVietnamese: 'Máy quay chuyển sang ảnh lịch sử có ghi nguồn và phần phục dựng ảo có căn cứ.', sourceEnglish: 'The shot cuts to a sourced historical photograph and an evidence-based virtual restoration.'),
  _longmenWord(word: '真实性', pinyin: 'zhēnshíxìng', partOfSpeech: '名词', simpleChinese: '历史遗产在证据、材料、状态和关系上保持真实可信的程度。', vietnamese: 'tính xác thực dựa trên chứng cứ, vật liệu và tình trạng', english: 'authenticity grounded in evidence, material, and condition', symbol: '✅', sourceSentence: '龙门的真实性也包括遗址、崖壁、伊河环境与长期历史变化形成的整体关系。', sourceVietnamese: 'Tính xác thực của Long Môn còn bao gồm quan hệ giữa di tích, vách đá, sông Y và những biến đổi lịch sử lâu dài.', sourceEnglish: 'Longmen authenticity also includes the relationship among the site, cliffs, Yi River setting, and long historical change.'),
];

List<_LongmenStorySegment> _storySegmentsForLevel(int level) => <_LongmenStorySegment>[
      ..._longmenCoreSegments,
      ..._longmenDepthSegments.where((segment) => level >= segment.fromLevel),
    ];

List<JourneyLevelContent> _buildLongmenLevels() =>
    List<JourneyLevelContent>.generate(10, (index) {
      final level = index + 1;
      const core = _longmenCoreSegments;
      final details = _storySegmentsForLevel(level)
          .skip(core.length)
          .toList(growable: false);
      late final List<List<_LongmenStorySegment>> paragraphSegments;
      if (level <= 2) {
        paragraphSegments = <List<_LongmenStorySegment>>[
          <_LongmenStorySegment>[...core, ...details],
        ];
      } else {
        paragraphSegments = <List<_LongmenStorySegment>>[
          core.take(3).toList(growable: false),
          <_LongmenStorySegment>[...core.skip(3), ...details],
        ];
      }

      final paragraphs = paragraphSegments
          .map((segments) => segments.map((segment) => segment.chinese).join())
          .toList(growable: false);
      final annotations = paragraphSegments
          .map((segments) {
            final chinese = segments.map((segment) => segment.chinese).join();
            return ReadingAnnotation(
              pinyin: PinyinHelper.getPinyinE(
                chinese,
                separator: ' ',
                format: PinyinFormat.WITH_TONE_MARK,
              ),
              vietnamese: segments.map((segment) => segment.vietnamese).join(' '),
              english: segments.map((segment) => segment.english).join(' '),
            );
          })
          .toList(growable: false);
      final discoveries = _longmenDiscoveriesForLevel(level);
      final visible = '${paragraphs.join()}${discoveries.map((entry) => entry.text).join()}';
      final profile = const PhoenixLanguageLevelAgent().profileForPhoenixLevel(level);
      final plan = const PhoenixLanguageLevelAgent().planFor(profile);
      final words = luoyangLongmenWords
          .where((entry) => visible.contains(entry.word))
          .take(plan.targetVocabularyCount)
          .toList(growable: false);

      return JourneyLevelContent(
        storyParagraphs: List<String>.unmodifiable(paragraphs),
        storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
        words: List<WordEntry>.unmodifiable(words),
        discoveries: discoveries,
        wonderQuestion: level <= 4
            ? '林砚为什么最后关掉已经做了三天的模型层？'
            : level <= 7
                ? '“现存状态”“有据复原”和“解释性示意”为什么不能混成一个标签？'
                : '当历史资料只能支持到某一步时，创作者应该怎样处理仍然未知的部分？',
        expressQuestion: level <= 4
            ? '请按“依据问题→选择→成本→结果”说明林砚的决定。'
            : level <= 7
                ? '请用龙门观音像龛的例子说明“看起来完整”为什么不等于“历史上有依据”。'
                : '请分析林砚把来源核对前移到建模之前，怎样改变了她和周澄的合作。',
      );
    }, growable: false);

final luoyangLongmenOnePassLevels =
    List<JourneyLevelContent>.unmodifiable(_buildLongmenLevels());

JourneyLevelContent luoyangLongmenOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  return luoyangLongmenOnePassLevels[level - 1];
}

final _longmenEvents = <RemediatedSemanticEvent>[
  for (var index = 0; index < _longmenCoreSegments.length; index++)
    RemediatedSemanticEvent(
      id: 'LM-E${index + 1}',
      coreChinese: _longmenCoreSegments[index].chinese,
      corePinyin: PinyinHelper.getPinyinE(
        _longmenCoreSegments[index].chinese,
        separator: ' ',
        format: PinyinFormat.WITH_TONE_MARK,
      ),
      coreVietnamese: _longmenCoreSegments[index].vietnamese,
      coreEnglish: _longmenCoreSegments[index].english,
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11,
    ),
];

final luoyangLongmenGoldJourney = RemediatedJourney(
  id: luoyangLongmenJourneyId,
  title: luoyangLongmenCanonicalTitle,
  protagonist: '林砚，29岁，虚构当代三维视觉创作者',
  goal: '与周澄完成共同署名的龙门石窟数字短片，同时让自己的视觉判断经得起史料核对',
  conflict: '完整画面的诱惑与历史证据边界冲突，并直接影响两位平等创作者之间的专业信任',
  eventIds: List<String>.unmodifiable(_longmenEvents.map((event) => event.id)),
  events: List<RemediatedSemanticEvent>.unmodifiable(_longmenEvents),
  levels: luoyangLongmenOnePassLevels,
  words: List<WordEntry>.unmodifiable(luoyangLongmenWords),
  wordTraces: List<RemediatedWordTrace>.unmodifiable([
    for (final word in luoyangLongmenWords)
      RemediatedWordTrace(
        word: word.word,
        eventId: 'LM-E3',
        usage: 'active Story/Discovery vocabulary; selected only when visible at the current level',
        sourceText: word.examples.first.chinese,
      ),
  ]),
  discoveries: List<DiscoveryEntry>.unmodifiable([
    _discovery(_longmenCommonDiscovery),
    ..._longmenPrimaryDiscoveries.map(_discovery),
    ..._longmenDeepDiscoveries.map(_discovery),
  ]),
  discoveryTraces: List<RemediatedDiscoveryTrace>.unmodifiable([
    for (var index = 0;
        index < 1 + _longmenPrimaryDiscoveries.length + _longmenDeepDiscoveries.length;
        index++)
      RemediatedDiscoveryTrace(
        discoveryIndex: index,
        storyEventIds: index == 4 || index == 5 ? const ['LM-E2', 'LM-E4'] : const <String>[],
        sourceIds: const ['unesco-luoyang-longmen-grottoes', 'longmen-academy-overview'],
      ),
  ]),
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(
      type: 'paragraphRebuild',
      storyEventIds: ['LM-E1', 'LM-E2', 'LM-E3', 'LM-E4', 'LM-E5', 'LM-E6'],
      anchor: '史料核对→无依据模型→关闭图层→并列署名',
    ),
    RemediatedChallengeTrace(
      type: 'grammarRepair',
      storyEventIds: ['LM-E3', 'LM-E5'],
      anchor: '只修正当前 Story 句法，不引入新历史事实',
    ),
    RemediatedChallengeTrace(
      type: 'missingSentence',
      storyEventIds: ['LM-E3', 'LM-E4', 'LM-E5'],
      anchor: '依据问题必须连接无来源模型与删除选择',
    ),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(
      category: 'choice',
      prompt: '林砚最后关掉了什么？',
      answer: '她关掉并弃用没有历史来源支持的“补全脸部”模型层。',
      storyEventIds: ['LM-E3', 'LM-E5'],
    ),
    RemediatedMemoryReview(
      category: 'place',
      prompt: '为什么这个选择只在龙门故事里成立？',
      answer: '万佛洞观音像龛同时留下题记、残损现状和基于历史老照片的有据虚拟复原，三种证据层不能被混成一个“完整原貌”。',
      storyEventIds: ['LM-E2', 'LM-E4'],
    ),
    RemediatedMemoryReview(
      category: 'truth',
      prompt: '历史资料没有支持到的部分应该怎样处理？',
      answer: '不知道的部分仍然是不知道，不能因为画面需要而补成已验证事实。',
      storyEventIds: ['LM-E3', 'LM-E5'],
    ),
    RemediatedMemoryReview(
      category: 'memory',
      prompt: '故事最后留在工程文件里的四个字是什么？',
      answer: '“无依据，不使用”。',
      storyEventIds: ['LM-E6'],
    ),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '林砚放弃无依据的“完整脸部”，让龙门的残损、题记和有据复原保持清楚边界。',
    achievement: '证据边界守护者',
    memoryAnchor: '工程文件中的“无依据，不使用”图层',
    challengeReward: '你完成了从“看起来像”到“有资料支持”的判断。',
    journeyCompletion: '林砚没有替历史补上更方便的答案，也没有因此失去共同作者的位置。',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(
      id: 'unesco-luoyang-longmen-grottoes',
      publisher: 'UNESCO World Heritage Centre',
      scope: 'site chronology, scale, inscriptions, authenticity, conservation',
    ),
    RemediatedSourceBinding(
      id: 'longmen-academy-overview',
      publisher: '龙门石窟研究院',
      scope: 'site inventory, inscriptions, patrons, Guyang Cave',
    ),
    RemediatedSourceBinding(
      id: 'longmen-academy-wanfo-virtual-restoration',
      publisher: '龙门石窟研究院',
      scope: 'Wanfo Cave Guanyin niche inscription, damage, historical-photo-based virtual restoration',
    ),
    RemediatedSourceBinding(
      id: 'longmen-academy-dispersed-objects',
      publisher: '龙门石窟研究院',
      scope: 'Binyang Central Cave dispersed worship reliefs',
    ),
    RemediatedSourceBinding(
      id: 'henan-longmen-conservation',
      publisher: '河南省文化和旅游厅',
      scope: 'Fengxian conservation survey, seepage and new material evidence',
    ),
  ],
);

const luoyangLongmenDepthActionTest = <String, String>{
  'DEPTH_MECHANISM': 'AMBIGUITY / UNCERTAINTY',
  'PLACE_BASIS': 'Longmen inscription + damaged niche + historical-photo-based virtual restoration',
  'CHARACTER_ENCOUNTER': 'a plausible but unsourced completed-face model layer',
  'ACTION_CAUSED': 'Zhou asks for source; Lin deletes the layer',
  'CONSTRAINT_OR_PRESSURE': 'visual completeness, three days of work, equal-collaborator trust',
  'CHOICE_EFFECT': 'evidence boundary overrides visual smoothness',
  'COST_EFFECT': 'three days of rendering and the seamless climax are discarded',
  'CONSEQUENCE_EFFECT': 'current condition, evidence-based restoration, and imagination remain distinct',
  'REMOVAL_TEST': 'without uncertainty/evidence boundary, Goal-Conflict-Choice-Cost-Consequence collapse',
  'RESULT': 'PASS',
};

const luoyangLongmenHistoricalSafetyAudit = <String, String>{
  'UNSUPPORTED_HISTORICAL_FACT': 'NONE',
  'REAL_PERSON_FABRICATED_ACTION': 'NONE',
  'REAL_PERSON_FABRICATED_DIALOGUE': 'NONE',
  'REAL_PERSON_FABRICATED_MOTIVE': 'NONE',
  'REAL_PERSON_FABRICATED_RELATIONSHIP': 'NONE',
  'UNSUPPORTED_PLACE_PERSON_CONNECTION': 'NONE',
  'UNSUPPORTED_DATE': 'NONE',
  'ARTIFACT_PROVENANCE_FABRICATION': 'NONE',
  'LEGEND_PRESENTED_AS_FACT': 'NONE',
  'CONTESTED_PRESENTED_AS_CERTAIN': 'NONE',
  'TRANSLATION_CERTAINTY_DRIFT': 'NONE',
  'TEMPORAL_ANACHRONISM': 'NONE',
  'UNSOURCED_STORY_CAUSAL_FACT': 'NONE',
};
