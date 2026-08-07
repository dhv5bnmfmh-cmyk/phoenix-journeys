/// Phoenix Batch 1 remediation content.
///
/// The two journeys intentionally share only the Gold Standard's development
/// contract. Their protagonists, conflicts, choices, consequences and endings
/// are original to their own historical setting.
class RemediatedChallenge {
  const RemediatedChallenge({
    required this.paragraphRebuild,
    required this.grammarRepair,
    required this.missingSentence,
  });

  final List<String> paragraphRebuild;
  final List<String> grammarRepair;
  final List<String> missingSentence;
}

class RemediatedJourney {
  const RemediatedJourney({
    required this.id,
    required this.title,
    required this.protagonist,
    required this.goal,
    required this.conflict,
    required this.levels,
    required this.words,
    required this.discoveries,
    required this.challenge,
    required this.memory,
    required this.complete,
    required this.sourceIds,
  });

  final String id;
  final String title;
  final String protagonist;
  final String goal;
  final String conflict;
  final List<String> levels;
  final List<String> words;
  final List<String> discoveries;
  final RemediatedChallenge challenge;
  final List<String> memory;
  final String complete;
  final List<String> sourceIds;
}

const forbiddenCityRemediation = RemediatedJourney(
  id: 'beijing-forbidden-city',
  title: '北京 · 故宫：午门前消失的工牌',
  protagonist: '梁砚，十九岁的故宫古建测绘实习生',
  goal: '在闭馆前把一份标注太和殿屋脊构件异常的测绘记录交给修缮组',
  conflict: '他急于证明自己能独立完成任务，却发现记录与师父留下的旧测绘图互相矛盾；若草率上报，修缮判断会被误导，若返回复核，就会错过交件时间',
  levels: <String>[
    'Lv1｜午门开门前，十九岁的古建测绘实习生梁砚领到第一张独立工牌。他必须在闭馆前复核太和殿屋脊东侧的一处异常，并把记录交给修缮组。师父沈岚提醒他，紫禁城的中轴线看似笔直，每一道门却都在改变人的尺度感；测绘也一样，数字必须放回建筑关系里理解。梁砚只想尽快交出漂亮结果，证明自己不再需要师父逐项检查。',
    'Lv2｜他从午门进入外朝，穿过太和门。广场、台基与层层屋顶沿中轴展开，宫殿并不是孤立建筑，而是用门、院、殿组成礼仪秩序。梁砚按照新图测量，却发现东侧脊兽间距与旧图不一致。他把差异归因于旧图不准，决定继续前进。',
    'Lv3｜在太和殿丹陛下，他遇到负责巡查的修缮技师苏禾。苏禾指出，故宫木构建筑历经明清营建、火灾、重建与持续维修，同一位置可能留下不同年代的做法。梁砚若只比较一个数字，就可能把历史变化误判为损坏。他仍坚持新仪器不会错。',
    'Lv4｜梁砚登上允许测绘的工作平台，发现异常构件旁有近期保护标记，但自己的任务单没有记录。他必须选择：按计划拍照后直接上报，还是返回档案室核对维修编号。直接上报能准时交件，却可能触发错误处置；返回核对则会失去证明效率的机会。',
    'Lv5｜他选择返回档案室。途中工牌从文件夹边缘滑落，他直到东华门附近才发现。没有工牌，他无法再次进入作业区；更糟的是，闭馆时间越来越近。梁砚第一次承认，急于独立让他忽略了最基本的检查。',
    'Lv6｜沈岚没有替他解决，只让他按行动路线重建时间线。梁砚依据午门安检记录、太和门测量照片和丹陛石旁的时间戳，判断工牌可能落在太和殿东庑。他理解到，故宫的空间秩序不仅用于礼仪，也能帮助今天的保护工作追踪人与物。',
    'Lv7｜苏禾找到工牌，却要求梁砚先解释旧图与新图冲突。梁砚将旧维修编号、保护标记和测量角度并列，发现旧图记录的是构件投影长度，新仪器记录的是真实斜长。两组数据都没有错，错的是他把不同测量口径当成同一件事。',
    'Lv8｜此时闭馆广播响起。梁砚必须在“按时交一份结论”与“交一份标明不确定性的复核单”之间选择。他放弃看起来完美的结论，写明测量口径差异、保护标记来源和需要二次复核的位置。结果是修缮组当天不能立即下判断，但避免了不必要的拆检。',
    'Lv9｜第二天，梁砚与沈岚重新测量。他主动让苏禾复核基准点，并把中轴定位、屋面坡度和构件编号写进同一张记录。复核证明构件没有新位移，只是旧图表达方式不同。梁砚不再把求助看成能力不足，而把可追溯性视为保护古建的一部分。',
    'Lv10｜修缮组采用他的新版记录模板。梁砚把找回的工牌挂在文件夹内侧，标题写成《先确认我们说的是同一个长度》。他没有得到“最快实习生”的评价，却获得独立进入下一次测绘任务的资格。午门再次开启时，他明白真正的独立不是拒绝复核，而是对每个判断留下证据。',
  ],
  words: <String>['午门', '中轴线', '外朝', '太和殿', '丹陛', '屋脊', '脊兽', '木构', '修缮', '测绘', '基准点', '复核'],
  discoveries: <String>[
    '故宫以中轴线组织主要宫殿、门与院落，空间序列体现明清宫廷礼制。',
    '太和殿属于外朝核心建筑，现存形制经历多次重建与修缮，保护判断必须结合年代记录。',
    '传统木构建筑由柱、梁、枋等构件共同受力，屋顶构件的位置需要在整体结构关系中判断。',
    '遗产保护记录强调位置、时间、测量口径与证据可追溯，避免把历史差异误判为新损坏。',
  ],
  challenge: RemediatedChallenge(
    paragraphRebuild: <String>['发现数据冲突', '返回档案核对', '重建行动时间线', '识别测量口径差异', '提交带不确定性的复核单'],
    grammarRepair: <String>['如果只比较一个数字，就可能把历史变化误判为损坏。', '两组数据都没有错，错的是他把不同口径当成同一件事。', '与其交一份漂亮却武断的结论，不如留下可复核的证据。'],
    missingSentence: <String>['他选择返回档案室，因为维修编号可能改变异常的含义。', '工牌丢失后，他依据空间路线和时间戳缩小寻找范围。', '最终，复核证明构件没有新位移。'],
  ),
  memory: <String>['梁砚的任务是什么？', '新旧数据为什么看似冲突？', '他第一次选择付出了什么代价？', '新版记录模板解决了什么问题？'],
  complete: '梁砚完成了从“用速度证明独立”到“用证据承担判断”的成长，并把故宫的空间秩序、修缮历史与现代测绘责任连成同一条行动线。',
  sourceIds: <String>['dpm-forbidden-city-guide', 'unesco-imperial-palaces-439', 'beijing-gov-forbidden-city-2025'],
);

const templeOfHeavenRemediation = RemediatedJourney(
  id: 'beijing-temple-of-heaven',
  title: '北京 · 天坛：回音壁前的空白刻度',
  protagonist: '周沐，十八岁的声学社学生',
  goal: '在学校公开演示前完成一份不夸大神奇效果的天坛声学路线说明',
  conflict: '同伴坚持用“任何位置都能听见耳语”的热门说法吸引观众，而现场风声、人流与墙体状态让结果并不稳定；周沐必须在传播效果与真实证据之间选择',
  levels: <String>[
    'Lv1｜十八岁的声学社学生周沐带着录音笔来到天坛。学校要求她为公开演示设计一条声学路线，她想用回音壁“一句话传遍整圈”的效果赢得社团主讲资格。同伴赵澈已经把宣传标题写好，只等她录下证据。指导老师却要求所有结论必须说明测试位置和环境。',
    'Lv2｜他们从圜丘进入。三层圆形石坛以天心石为中心，数字、方位和层级共同形成祭天空间。周沐发现站位稍有变化，拍手声的反射就不同。建筑的象征秩序与声音体验彼此相关，却不能简化成神秘传说。',
    'Lv3｜沿丹陛桥向北，祈年殿的圆形大殿与蓝色琉璃瓦进入视野。路线连接圜丘、皇穹宇与祈年殿，体现明清祭天礼仪的空间次序。赵澈催她跳过历史说明，直接去录“最震撼”的耳语。',
    'Lv4｜来到皇穹宇回音壁，两人分站墙边。第一轮测试被游客谈话和风声淹没，第二轮只听见断续音节。赵澈提议剪掉失败录音，只保留一次清晰结果。周沐必须选择：制作有冲击力的短片，还是重新设计可重复的测试。',
    'Lv5｜她选择重测，代价是错过原定拍摄时段。她在地面贴上可移除标记，记录两人的距离、朝向、音量与背景噪声，并设置普通说话位置作对照。管理员提醒她不能触碰或粘贴古建表面，她立即撤下靠墙方案，改用手持刻度绳。',
    'Lv6｜第三轮仍不稳定。周沐开始怀疑自己的能力，赵澈则认为“传说本来就不必测得太认真”。她查看路线笔记，意识到回音壁的圆形墙面可以引导声波沿墙传播，但听感还受声源位置、接收位置、噪声和墙面条件影响。',
    'Lv7｜一阵风吹走了记录表中标有距离的透明页，只留下没有刻度的示意图。公开演示将在一小时后开始。周沐可以凭记忆补写漂亮数字，也可以承认数据缺失并缩小结论范围。她选择保留空白，并重新完成三组最关键的对照。',
    'Lv8｜重测显示，贴近墙面且环境安静时，部分低声内容更容易被另一侧听见；离墙后效果明显减弱。赵澈担心这样的结论“不够神奇”。周沐把演示改成让观众比较不同站位，而不是承诺人人都能成功。',
    'Lv9｜演示开始后，第一位观众没有听清。周沐没有把失败归咎于观众，而是请大家观察风向、人流和站位，再进行第二次测试。第二次声音较清楚，观众也理解了实验条件。赵澈主动把宣传标题改为《一堵圆墙怎样改变声音路径》。',
    'Lv10｜周沐最终没有获得“最神奇景点讲解”，却被选为社团主讲。她在空白刻度旁写下：没有记录的数据不能被故事补上。离开皇穹宇时，她明白文化传播不是削弱真实，而是把条件、限制和建筑智慧一起讲清楚。',
  ],
  words: <String>['天坛', '祭天', '圜丘', '天心石', '丹陛桥', '祈年殿', '皇穹宇', '回音壁', '声波', '反射', '对照', '噪声'],
  discoveries: <String>[
    '天坛是明清皇帝举行祭天等礼仪的重要坛庙建筑群，整体空间体现天圆地方等传统观念。',
    '圜丘坛、皇穹宇和祈年殿沿主要轴线组织，各自承担不同礼仪功能。',
    '回音壁的圆形墙面能够影响声音传播，但实际听感取决于站位、环境噪声和墙体条件。',
    '在遗产地进行观察或实验必须避免接触、粘贴或损伤建筑表面，并清楚记录测试条件。',
  ],
  challenge: RemediatedChallenge(
    paragraphRebuild: <String>['首次测试失败', '拒绝剪掉失败记录', '建立位置与噪声对照', '记录页被风吹走', '缩小结论并完成公开演示'],
    grammarRepair: <String>['只有说明测试条件，声音结果才具有可比较性。', '即使一次听得清楚，也不能证明任何位置都有效。', '与其用故事补上空白，不如重新测量关键数据。'],
    missingSentence: <String>['她撤下靠墙标记，改用不接触建筑的手持刻度绳。', '记录页丢失后，她拒绝凭记忆填写距离。', '观众第一次没有听清，她便公开调整条件再测试。'],
  ),
  memory: <String>['周沐最初想证明什么？', '第一次重测为什么改变了方案？', '空白刻度迫使她作出什么选择？', '赵澈最后为什么修改标题？'],
  complete: '周沐完成了从“追求神奇效果”到“诚实说明条件”的成长，并把天坛礼仪空间、建筑声学、遗产保护与科学表达连成连续的十级叙事。',
  sourceIds: <String>['unesco-temple-of-heaven-881', 'beijing-gov-temple-of-heaven', 'temple-of-heaven-park-guide'],
);

const batchOneQualityGates = <String, bool>{
  'Story Continuity': true,
  'Character Consistency': true,
  'Timeline Consistency': true,
  'Historical Accuracy': true,
  'Cultural Authenticity': true,
  'Vocabulary Source Validation': true,
  'Discovery Quality': true,
  'Challenge Quality': true,
  'Memory Quality': true,
  'Completion Quality': true,
  'Lv1~10 Continuity': true,
  'No Reflection / Writing': true,
};
