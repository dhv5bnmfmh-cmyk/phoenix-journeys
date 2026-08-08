import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const xianCityWallJourneyId = 'xian-city-wall';

class XianNarrativeDna {
  const XianNarrativeDna({
    required this.narrativeIdentity,
    required this.protagonistArchetype,
    required this.storyGoal,
    required this.conflictType,
    required this.climaxType,
    required this.resolutionType,
    required this.memoryAnchorType,
    required this.movementPattern,
    required this.temporalPattern,
    required this.supportingStructure,
    required this.endingMechanism,
    required this.centralMetaphor,
  });
  final String narrativeIdentity;
  final String protagonistArchetype;
  final String storyGoal;
  final String conflictType;
  final String climaxType;
  final String resolutionType;
  final String memoryAnchorType;
  final String movementPattern;
  final String temporalPattern;
  final String supportingStructure;
  final String endingMechanism;
  final String centralMetaphor;
}

const xianCityWallNarrativeDna = XianNarrativeDna(
  narrativeIdentity: 'last-wall-lap-becomes-continuing-home-route',
  protagonistArchetype: 'local-young-mover-and-distance-runner',
  storyGoal: 'complete-one-final-wall-circuit-before-family-relocation',
  conflictType: 'relocation-belonging-vs-address-change',
  climaxType: 'completed-lap-but-running-watch-deliberately-keeps-going',
  resolutionType: 'closed-circuit-extends-into-new-home-route',
  memoryAnchorType: 'unpaused-running-record-at-yongning-gate',
  movementPattern: 'closed-wall-circuit-then-outbound-street-continuation',
  temporalPattern: 'late-afternoon-to-sunset-to-evening-to-city-lights',
  supportingStructure: 'family-messages-without-mentor-or-explainer',
  endingMechanism: 'route-record-saved-and-named-home-next-morning',
  centralMetaphor: 'a-closed-fortification-can-contain-an-open-lived-route',
);

class XianDiscoverySpec {
  const XianDiscoverySpec({
    required this.level,
    required this.title,
    required this.storyLink,
    required this.entry,
    required this.keyTerms,
    required this.learnerInsight,
    required this.check,
    required this.answer,
    required this.sourceIds,
  });
  final int level;
  final String title;
  final String storyLink;
  final DiscoveryEntry entry;
  final List<String> keyTerms;
  final String learnerInsight;
  final String check;
  final String answer;
  final List<String> sourceIds;
}

class XianChallengeSpec {
  const XianChallengeSpec({
    required this.level,
    required this.type,
    required this.anchor,
    required this.answer,
  });
  final int level;
  final String type;
  final String anchor;
  final String answer;
}

class XianCompleteSpec {
  const XianCompleteSpec({
    required this.journeySummary,
    required this.achievement,
    required this.memoryAnchor,
    required this.anchorMeaning,
    required this.challengeReward,
    required this.rewardMeaning,
    required this.rewardUnlockText,
    required this.journeyCompletion,
  });
  final String journeySummary;
  final String achievement;
  final String memoryAnchor;
  final String anchorMeaning;
  final String challengeReward;
  final String rewardMeaning;
  final String rewardUnlockText;
  final String journeyCompletion;
}

JourneyLevelContent _xianLevel(List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++)
          ReadingAnnotation(
            pinyin: i == 0
                ? 'Zhōu Yáo èrshí’èr suì, cóng Xī’ān chéngqiáng nèi de lǎojiē chūfā, zài Yǒngníngmén kāishǐ zuìhòu yí cì rào chéng pǎobù.'
                : 'Yèsè luòxià, tā huídào Yǒngníngmén, què méiyǒu àn tíng pǎobiǎo, ér shì xià chéng jìxù pǎo xiàng xīn jiā.',
            vietnamese: i == 0
                ? 'Chu Dao, 22 tuổi, lớn lên trong khu phố cũ bên trong tường thành Tây An. Trước khi gia đình chuyển ra ngoài thành, cậu bắt đầu một vòng chạy từ cổng Vĩnh Ninh và định biến nó thành lời chia tay cuối cùng.'
                : 'Khi đêm xuống và cậu trở lại cổng Vĩnh Ninh, đồng hồ báo hoàn thành vòng thành. Cậu không dừng đồng hồ mà xuống thành, tiếp tục chạy về ngôi nhà mới; tuyến đường khép kín trở thành một hành trình tiếp nối.',
            english: i == 0
                ? 'Zhou Yao, 22, grew up in the old neighborhoods inside Xi’an City Wall. Before his family moves outside the wall, he starts a full circuit from Yongning Gate and intends it as a final farewell.'
                : 'When night falls and he returns to Yongning Gate, his watch marks the completed circuit. Instead of stopping it, he descends and keeps running toward the new home, turning a closed lap into a continuing route.',
          ),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final xianCityWallOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _xianLevel(['周遥二十二岁，从小住在西安城墙里。这个周末，全家要搬到城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。夕阳照着砖石，城内的街巷和城外的道路同时亮着。母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。周遥经过转角和城门时，一直想：搬出去以后，自己还算不算“城里人”。夜色落下来，他又回到永宁门，跑表刚好记下一整圈。他没有按停，而是下城继续往南跑。身后的城墙亮起灯，他的距离还在增加。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，决定完整跑一圈，把它当作搬家前最后一次“绕城”。夕阳把砖石拉出长影，向内能看见老城街巷，向外是车流和更远的新城区。母亲发来语音，说搬家车已经到新家，饭也快好了。周遥继续沿墙跑，经过城门和转角，心里却越来越别扭：如果住址变了，自己和这座老城的关系是不是也结束了？天色变深，他再次看见永宁门，跑表完成一整圈。原本这里应是终点。周遥抬手看了一眼，没有按停计时，直接下城，沿南边的街道继续向新家跑去。城墙灯光在身后连成一圈，而跑表上的数字越过了那一圈。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，想完整跑一圈，把这次“绕城”当成搬家前的告别。夕阳把砖石拉出长影，墙内是熟悉的街巷，墙外是车流和新住宅。母亲发来语音，说搬家车已经到了，新家的第一顿饭等他回来。周遥继续跑，心里却认定：住址一变，旧生活也会在城门处结束。', '天色渐暗，他经过转角和城门，又回到永宁门。跑表完成一整圈，屏幕亮起提示。原本这里应是终点，母亲却发来一张新家阳台的照片，远处正能看见城墙的灯。周遥抬手看了看跑表，没有按停。他下城后继续向南跑，穿过晚高峰的路口。身后的城墙连成一圈亮线，跑表上的距离却继续增加。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈，把十三公里多的环线当作搬家前最后一次正式告别。夕阳压低，砖石和城楼投下长影。向内是他熟悉的街巷、院落和晚饭香，向外是车流、地铁口与不断延伸的新住宅。母亲发来语音，说搬家车已经到达，新家的第一顿饭等他回来。周遥只回了一个“好”，继续沿墙跑。他一直觉得，搬出城墙就等于离开老城，自己的生活会在某座城门处被切成两段。', '天色从橙色变成深蓝，他经过转角、城门和宽阔的墙顶。现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。周遥小时候在墙下骑车，上学后又常来跑步，这些记忆并不只在墙内。回到永宁门时，跑表完成一整圈，屏幕亮起提示。原本这里应是终点，母亲却发来新家阳台的照片，远处正能看见亮起的城墙。周遥没有按停计时。他下城后继续向南跑，穿过晚高峰的路口。城墙灯光在身后合成一圈，而跑表上的距离越过那一圈。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他把这十三公里多的环线当成一场私人告别：跑表归零，绕城一周，再在永宁门结束，好像这样就能把“城内生活”整齐收好。夕阳从南墙斜过去，砖石、垛口和城楼留下长影。向内是熟悉的街巷、院落与钟楼方向，向外是车流、地铁口和不断延伸的现代城区。母亲发来语音，说搬家车已到，新家的第一顿饭等他。周遥只回了一个“好”。他继续跑，却反复想：住址一旦越过城墙，自己和老城的关系是不是也会在城门处结束。', '天色由金黄转成深蓝，他沿封闭的长方形城墙经过转角与城门。现存城墙在明洪武年间形成今天的主要尺度，并在后世持续修缮；墙体、城门、护城河等共同构成需要长期保护的遗产。周遥并没有把这些当成讲解词。他记得小时候在护城河边学骑车，也记得高考前沿南门附近慢跑，生活早就不断进出城门。再次看见永宁门时，跑表完成一整圈，震动提醒他“目标完成”。原本这就是终点。母亲此时发来一张新家阳台的照片，夜色里远远能看见城墙灯光。周遥停了半步，没有按停计时，而是直接下城，沿南边街道继续跑向新家。身后灯线围住老城，跑表的数字却越过了完整的一圈。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他故意把这条十三点七四公里左右的环线设成“最后一次绕城”：从南门出发，沿墙跑完封闭的一周，再回到原点，把城内生活像训练记录一样保存起来。夕阳落到城楼一侧，砖石、女儿墙和垛口被拉出长影。向内是熟悉的街巷与院落，向外是车流、地铁线和更远的新住宅。母亲发来语音，说搬家车已经卸完，新家的第一顿饭等他回来。周遥只回了一个“好”。他继续跑，心里却固执地把住址变化理解成身份变化：搬出城墙以后，自己是不是就不再属于老城？', '暮色逐渐压下来，他沿城墙经过不同方向的城门与转角。现存西安城墙主要形成于明洪武七年至十一年，建立在更早城市墙体基础上；墙体、城门、附属建筑和护城河属于整体保护对象。过去，宽阔墙顶服务防御、巡查和人员物资调动；今天，这条环线又承载保护、展示与公共活动。周遥没有停下来背年代。他想起小时候在环城公园骑车，想起中学时从城内坐车去城外补课，也想起近几年常把城墙当跑步坐标。那些生活从来没有在门洞前断开。夜色完全落下，他回到永宁门，跑表震动，显示一整圈完成。母亲恰好发来新家阳台的照片，远处城墙刚亮灯。周遥抬手，本可以按下停止，却把手指移开。他下城后继续向南跑，穿过晚高峰的路口。身后的灯线封成一圈，跑表的距离却继续向前。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他故意把十三点七四公里左右的环线设成一场私人告别：从南门出发，沿封闭城墙跑完一周，再回到原点，让“住在城里”的日子像一次训练记录那样有清楚的起点和终点。夕阳贴着城楼下降，砖石、女儿墙和垛口的影子被拉长。墙内是熟悉的街巷、院落和钟楼方向，墙外是车流、地铁口与继续生长的住宅区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥只回了一个“好”。他没有舍不得新家；房间更亮，通勤也方便。他真正不安的是另一件事：如果地址离开城墙以内，自己从小建立的“西安人”感觉会不会也跟着变薄？', '暮色由金黄转成蓝黑，他沿城墙经过不同方向的城门和转角。现存西安城墙的主体在明洪武年间扩建形成，南墙和西墙部分利用更早的城市墙体基础；今天，城墙墙体、城门、附属建筑和护城河受到整体保护。过去宽阔墙顶服务防御、巡查与调动，如今同一条环线又进入日常公共生活。周遥并没有停下来读讲解牌。他只是不断遇见自己的路线：小学时在环城公园学骑车，中学时每天穿过城门去上课，大学后回家常沿南墙跑步。所谓“城内”和“城外”，在地图上清楚，在生活里却被公交、亲友、学校和习惯反复连接。夜色完全落下，他再次看见永宁门。跑表震动，显示整圈完成。他本来应该在这里按停，让告别成立。母亲恰好发来新家阳台的照片，远处一段城墙刚亮灯。周遥停了半步，把已经抬起的手放下，没有结束计时。他下城，沿南边街道继续跑向新家。城墙灯光在身后围成闭合的一圈，跑表上的数字却越过了那条闭环。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的生活也得到一个干净的句号。夕阳贴着城楼下降，砖石、女儿墙和垛口被拉出长影。墙内是熟悉的街巷、院落与钟楼轮廓，墙外是车流、地铁线和扩展的住宅区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥并不排斥新家：房间更亮，父母上下班也方便。他介意的是“搬出去”这三个字，仿佛住址越过城墙以后，童年路线和归属也必须改名。为了让这种不安显得可以控制，他才给今天安排了一个明确的圆周和终点。', '太阳落下以后，他沿长方形城墙继续向前。现存西安城墙的主体在明洪武七年至十一年形成今天的主要尺度，部分墙段承接更早的城市墙体基础；墙体、城门、附属建筑和护城河被整体保护。过去，宽阔的墙顶属于城市防御体系，也服务巡查和调动；今天，它又被保护、监测并进入市民运动与公共文化生活。周遥没有把跑步变成历史课。他只是发现自己的生活早就不断穿过这套空间：小时候在环城公园学骑车，中学每天从城内坐车到城外，大学以后又把南墙当作返乡跑步的坐标。城门在军事体系里曾控制出入，现代生活却用日常路线把内外缝在一起。夜色完全落下，他再次看见永宁门。跑表震动，整圈完成。他原本准备按停，让这里成为告别的句点；母亲却恰好发来新家阳台的照片，远处城墙灯光刚亮，弟弟还在照片角落举着两只没拆封的纸箱。周遥笑了，把手指从停止键上移开。他下城后继续向南跑，穿过晚高峰路口。城墙在身后围成清楚的闭环，跑表上的距离却继续增长。那一晚，他带到新家的不是城墙里的一块东西，而是一条没有在永宁门结束的路线。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的日子也得到一个干净的句号。夕阳沿城楼一侧下降，砖石、女儿墙、垛口和墙顶路面被拉出长影。墙内是熟悉的街巷、院落与钟楼轮廓，墙外是车流、地铁线和扩展的现代城区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥并不反感新家：房间更亮，父母通勤更方便，弟弟也离学校更近。他真正不安的是“搬出城墙”被自己偷偷解释成“搬出老西安”。如果住址改变，童年路线和归属感，会不会也在门洞里被截断？于是他给这次跑步规定了闭合的一圈，希望用一个可测量的终点处理一件无法测量的变化。', '太阳落下以后，他沿长方形城墙经过不同方向的城门和转角。现存西安城墙主体在明洪武年间扩建形成，部分南、西墙段利用更早的城市墙体基础；1961年，西安城墙被列入第一批全国重点文物保护单位。今天，墙体、城门、附属建筑和护城河被持续保护，现代监测也进入维护。对周遥来说，这些事实并没有替他回答“属于哪里”。真正改变他的，是一路不断出现的私人路线：小时候在环城公园学骑车，中学每天穿城门去上课，周末跟家人去城外办事，大学后回家又沿南墙跑步。军事防御体系曾经需要清楚的出入口，但现代生活把同一座城市的内外用公交、学校、亲友与习惯反复缝合。夜色完全落下，他再次看见永宁门。跑表震动，整圈完成。他原本准备按停，让“最后一次绕城”成立；母亲却恰好发来新家阳台的照片，城墙灯光在远处横着一段，弟弟站在纸箱旁催他吃饭。周遥抬起手，停了半步，又把手指从停止键上移开。他下城，沿南边街道继续跑向新家。身后的城墙围成完整亮环，跑表上的距离却越过十三点七四公里继续增加。到新家楼下时，计时还在走。他这才按停，把这条记录保存成一条从老家门口经过城墙、再抵达新家的连续路线。']),
  _xianLevel(['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的生活得到一个干净句号。夕阳沿城楼下降，砖石、女儿墙、垛口和宽阔墙顶拉出长影。墙内是熟悉的街巷、院落与钟楼方向，墙外是车流、地铁线和扩展的新城区。母亲发来语音，说搬家车已卸完，新家的第一顿饭等他。周遥并不排斥新生活：新家更亮，父母通勤更方便，弟弟离学校也近。他真正介意的是“搬出去”被自己解释成身份变化。城墙在地图上清楚画出内外，他便把记忆、关系和归属也塞进这条几何线里，想用一次可量化的闭环证明某段生活已经结束。', '太阳落下以后，他沿长方形城墙经过城门、转角和不同墙段。现存西安城墙主体在明洪武七年至十一年形成今天的主要尺度，南墙、西墙部分承接更早城市墙体基础；古代防御体系用墙体、城门、附属建筑与护城河组织防守、出入、巡查和调动。1961年，西安城墙被列入第一批全国重点文物保护单位，今天仍通过法规、监测和修缮持续保护。周遥没有因此突然“理解历史”。真正改写终点线的，是一路撞上的私人路线：小时候在环城公园学骑车，中学每天穿城门上课，亲友和日常活动一直分布在墙内墙外，大学以后他又把南墙当返乡跑步坐标。夜色完全落下，他回到永宁门，跑表震动，整圈完成。母亲恰好发来新家阳台的照片：远处城墙亮灯，弟弟站在纸箱旁催他吃饭。周遥抬手，手指碰到停止键又移开。他直接下城，沿南边街道继续跑。跑表越过十三点七四公里继续增加。到新家楼下，他才按停并保存路线。图上，城墙是闭合长方形，轨迹却从永宁门伸到新住址。第二天，他把这条记录命名为“回家”。']),
]);

WordEntry _word(String word, String pinyin, String part, String simple, String vi, String en, String symbol) => WordEntry(
  word: word,
  pinyin: pinyin,
  partOfSpeech: part,
  simpleChinese: simple,
  translation: vi,
  englishDefinition: en,
  symbol: symbol,
);

final xianCityWallOnePassWords = List<WordEntry>.unmodifiable([
  _word('城墙', 'chéngqiáng', '名词', '围绕城市、具有防护功能的墙体。', 'Tường thành bao quanh đô thị.', 'city wall', '🧱'),
  _word('永宁门', 'Yǒngníngmén', '专有名词', '西安城墙南面的重要城门。', 'Cổng Vĩnh Ninh ở phía nam tường thành Tây An.', 'Yongning Gate', '🚪'),
  _word('跑表', 'pǎobiǎo', '名词', '跑步时记录时间和距离的计时设备。', 'Đồng hồ chạy bộ.', 'running watch', '⌚'),
  _word('搬家', 'bānjiā', '动词', '把家庭用品搬到新的住处。', 'Chuyển nhà.', 'to move house', '📦'),
  _word('城内', 'chéngnèi', '名词', '城墙以内的城市空间。', 'Bên trong tường thành.', 'inside the walled city', '🏘️'),
  _word('城外', 'chéngwài', '名词', '城墙以外的城市空间。', 'Bên ngoài tường thành.', 'outside the walled city', '🏙️'),
  _word('城门', 'chéngmén', '名词', '城墙上供人员和交通出入的门。', 'Cổng thành.', 'city gate', '🏯'),
  _word('住址', 'zhùzhǐ', '名词', '居住地点的地址。', 'Địa chỉ nơi ở.', 'residential address', '📍'),
  _word('环线', 'huánxiàn', '名词', '首尾相接形成一圈的路线。', 'Tuyến vòng khép kín.', 'circular route', '🔄'),
  _word('修缮', 'xiūshàn', '动词', '修理并维护历史建筑。', 'Tu bổ công trình lịch sử.', 'to repair and conserve', '🔧'),
  _word('防御', 'fángyù', '名词/动词', '抵挡攻击、保护城市。', 'Phòng thủ.', 'defence; to defend', '🛡️'),
  _word('护城河', 'hùchénghé', '名词', '城墙外与防御体系相关的河沟。', 'Hào nước.', 'moat', '🌊'),
  _word('归属感', 'guīshǔgǎn', '名词', '觉得自己与一个地方有稳定联系的感受。', 'Cảm giác thuộc về.', 'sense of belonging', '🧭'),
  _word('闭环', 'bìhuán', '名词', '首尾连接、形成完整一圈的结构。', 'Vòng khép kín.', 'closed loop', '⭕'),
  _word('全国重点文物保护单位', 'quánguó zhòngdiǎn wénwù bǎohù dānwèi', '名词短语', '由国家公布的重要文物保护单位。', 'Di tích trọng điểm cấp quốc gia.', 'national key cultural relic protection unit', '🏛️'),
  _word('监测', 'jiāncè', '动词', '持续观察并记录状态变化。', 'Theo dõi trạng thái.', 'to monitor', '📡'),
]);

final xianCityWallWordTraces = List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '城墙', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '周遥二十二岁，从小住在西安城墙里。'),
  const RemediatedWordTrace(word: '永宁门', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。'),
  const RemediatedWordTrace(word: '跑表', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。'),
  const RemediatedWordTrace(word: '搬家', eventId: 'XIAN-E3-doubt', usage: 'Lv1 首次出现。', sourceText: '母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。'),
  const RemediatedWordTrace(word: '城内', eventId: 'XIAN-E2-view', usage: 'Lv1 首次出现。', sourceText: '夕阳照着砖石，城内的街巷和城外的道路同时亮着。'),
  const RemediatedWordTrace(word: '城外', eventId: 'XIAN-E2-view', usage: 'Lv1 首次出现。', sourceText: '这个周末，全家要搬到城外的新家。'),
  const RemediatedWordTrace(word: '城门', eventId: 'XIAN-E3-doubt', usage: 'Lv1 首次出现。', sourceText: '周遥经过转角和城门时，一直想：搬出去以后，自己还算不算“城里人”。'),
  const RemediatedWordTrace(word: '住址', eventId: 'XIAN-E3-doubt', usage: 'Lv2 首次出现。', sourceText: '周遥继续沿墙跑，经过城门和转角，心里却越来越别扭：如果住址变了，自己和这座老城的关系是不是也结束了？'),
  const RemediatedWordTrace(word: '环线', eventId: 'XIAN-E1-start', usage: 'Lv4 首次出现。', sourceText: '傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈，把十三公里多的环线当作搬家前最后一次正式告别。'),
  const RemediatedWordTrace(word: '修缮', eventId: 'XIAN-E4-history', usage: 'Lv4 首次出现。', sourceText: '现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。'),
  const RemediatedWordTrace(word: '防御', eventId: 'XIAN-E4-history', usage: 'Lv4 首次出现。', sourceText: '现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。'),
  const RemediatedWordTrace(word: '护城河', eventId: 'XIAN-E4-history', usage: 'Lv5 首次出现。', sourceText: '现存城墙在明洪武年间形成今天的主要尺度，并在后世持续修缮；墙体、城门、护城河等共同构成需要长期保护的遗产。'),
  const RemediatedWordTrace(word: '归属感', eventId: 'XIAN-E3-doubt', usage: 'Lv9 首次出现。', sourceText: '如果住址改变，童年路线和归属感，会不会也在门洞里被截断？'),
  const RemediatedWordTrace(word: '闭环', eventId: 'XIAN-E6-climax', usage: 'Lv7 首次出现。', sourceText: '城墙灯光在身后围成闭合的一圈，跑表上的数字却越过了那条闭环。'),
  const RemediatedWordTrace(word: '全国重点文物保护单位', eventId: 'XIAN-E4-history', usage: 'Lv9 首次出现。', sourceText: '现存西安城墙主体在明洪武年间扩建形成，部分南、西墙段利用更早的城市墙体基础；1961年，西安城墙被列入第一批全国重点文物保护单位。'),
  const RemediatedWordTrace(word: '监测', eventId: 'XIAN-E4-history', usage: 'Lv8 首次出现。', sourceText: '过去，宽阔的墙顶属于城市防御体系，也服务巡查和调动；今天，它又被保护、监测并进入市民运动与公共文化生活。'),
]);

const xianCityWallWordFirstAppears = <String, int>{
  '城墙': 1, '永宁门': 1, '跑表': 1, '搬家': 1, '城内': 1, '城外': 1, '城门': 1,
  '住址': 2, '环线': 4, '修缮': 4, '防御': 4, '护城河': 5, '闭环': 7, '监测': 8,
  '归属感': 9, '全国重点文物保护单位': 9,
};

DiscoveryEntry _discovery(String text) => DiscoveryEntry(
  text: text,
  pinyin: 'Xī’ān Chéngqiáng de lìshǐ jiégòu yǔ jīntiān de chéngshì shēnghuó zài gùshì lǐ liánjiē qǐlái.',
  simpleChinese: text,
  vietnamese: 'Khám phá về tường thành Tây An: $text',
  english: 'Xi’an City Wall discovery: $text',
);

final xianCityWallDiscoverySpecs = List<XianDiscoverySpec>.unmodifiable([
  XianDiscoverySpec(level: 1, title: '一圈有多长', storyLink: '周遥把完整一圈设成告别路线。', entry: _discovery('西安城墙周长约13.74公里，今天仍形成封闭的长方形环线。'), keyTerms: const ['13.74公里', '环线'], learnerInsight: '城墙的几何闭合解释了周遥为何误把它当成生活的终点。', check: '周遥为什么能用“一整圈”给自己设终点？', answer: '因为城墙本身形成封闭环线。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'xian-planning-photogrammetry']),
  XianDiscoverySpec(level: 2, title: '永宁门与四门传统', storyLink: '周遥从永宁门起跑并返回这里。', entry: _discovery('明清时期西安城墙传统四门分别为东长乐、南永宁、西安定、北安远；永宁门是南门。'), keyTerms: const ['永宁门', '南门'], learnerInsight: '城门既是防御体系的一部分，也成为现代城市方向坐标。', check: '永宁门位于城墙哪一面？', answer: '南面。', sourceIds: const ['shaanxi-gov-city-wall-2020']),
  XianDiscoverySpec(level: 3, title: '墙顶为何宽', storyLink: '周遥在宽阔墙顶持续跑步。', entry: _discovery('官方资料记载城墙顶宽约12至14米；历史上宽阔墙顶有利于防御、巡查和人员物资调动。'), keyTerms: const ['墙顶', '防御', '巡查'], learnerInsight: '今天能形成连续运动空间，与历史结构尺度有关。', check: '宽阔墙顶过去主要服务什么？', answer: '防御、巡查和调动。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'qujiang-city-wall']),
  XianDiscoverySpec(level: 4, title: '明代主体怎样形成', storyLink: '暮色中周遥经过不同墙段。', entry: _discovery('现存西安城墙主体在明洪武七年至十一年（1374—1378）形成今天的主要尺度，并承接更早城市墙体基础。'), keyTerms: const ['明洪武', '墙体基础'], learnerInsight: '“现存明城墙”并不等于城市历史从明代才开始。', check: '现存城墙主体主要形成于哪个时期？', answer: '明洪武年间。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'shaanxi-heritage-city-wall']),
  XianDiscoverySpec(level: 5, title: '保护对象不只是一堵墙', storyLink: '故事把城门、护城河与墙体一起写入路线。', entry: _discovery('《西安城墙保护条例》把明代城墙墙体、城门、附属建筑、护城河及其遗址遗迹作为西安城墙保护对象。'), keyTerms: const ['墙体', '城门', '护城河'], learnerInsight: '文化遗产保护关注的是相互关联的整体系统。', check: '条例中的保护对象是否只有墙体？', answer: '不是，还包括城门、附属建筑、护城河及遗址遗迹。', sourceIds: const ['shaanxi-city-wall-regulation']),
  XianDiscoverySpec(level: 6, title: '从防御到公共生活', storyLink: '周遥的私人跑步与古代防御空间叠在同一路线上。', entry: _discovery('城墙曾属于城市防御体系，今天在保护前提下也承载参观、运动等公共活动。'), keyTerms: const ['防御', '公共生活'], learnerInsight: '历史空间的功能可以改变，但保护责任不会因此消失。', check: '今天的城墙是否只保留古代军事功能？', answer: '不是，它在保护中进入现代公共生活。', sourceIds: const ['shaanxi-gov-city-wall-2024', 'xian-city-wall-marathon']),
  XianDiscoverySpec(level: 7, title: '为什么要持续修缮', storyLink: '周遥看到的完整环线并非自然保持不变。', entry: _discovery('1983年西安启动环城建设与大规模城墙修复工程，此后保护进入更系统、持续的阶段。'), keyTerms: const ['修缮', '保护'], learnerInsight: '“保存下来”是一项长期工作，不是一次修完就结束。', check: '1983年前后西安对城墙做了什么重要工作？', answer: '启动大规模修复和环城建设。', sourceIds: const ['xian-municipal-conservation']),
  XianDiscoverySpec(level: 8, title: '现代监测怎样进入古墙', storyLink: '故事把新城区与老城放在同一晚景中。', entry: _discovery('现代保护采用监测点、无损检测和数字化技术跟踪沉降、位移等风险，让传统城墙进入持续的科学管理。'), keyTerms: const ['监测', '无损检测', '数字化'], learnerInsight: '保护历史建筑也需要现代工程与数据能力。', check: '监测的目的是什么？', answer: '及时发现结构变化和保护风险。', sourceIds: const ['xian-municipal-conservation', 'xian-planning-photogrammetry']),
  XianDiscoverySpec(level: 9, title: '城墙为何是国家级文物', storyLink: '周遥的个人记忆发生在被国家保护的历史空间上。', entry: _discovery('西安城墙于1961年被列入第一批全国重点文物保护单位；它也是“中国明清城墙”世界文化遗产预备名录组成部分之一。'), keyTerms: const ['全国重点文物保护单位', '预备名录'], learnerInsight: '国家级保护身份与世界遗产预备名录不是同一概念，不能混同。', check: '西安城墙已经是世界文化遗产吗？', answer: '不能这样表述；它属于相关世界文化遗产预备名录。', sourceIds: const ['shaanxi-heritage-register', 'shaanxi-heritage-data-2024']),
  XianDiscoverySpec(level: 10, title: '活着的历史城区', storyLink: '周遥最后把跑步记录命名为“回家”。', entry: _discovery('城墙内仍是西安历史城区，包含历史文化街区和大量各级文物资源；城墙与当代交通、居住、工作和公共生活并存。'), keyTerms: const ['历史城区', '城市生活', '归属'], learnerInsight: '历史城市不是静止展品，而是保护与日常生活持续协商的空间。', check: '为什么故事不把城内写成“过去”？', answer: '因为历史城区今天仍有人生活，并与现代城市持续连接。', sourceIds: const ['shaanxi-old-city-heritage', 'shaanxi-city-wall-regulation']),
]);

final xianCityWallOnePassDiscoveries = List<DiscoveryEntry>.unmodifiable([
  for (final spec in xianCityWallDiscoverySpecs) spec.entry,
]);

final xianCityWallDiscoveryTraces = List<RemediatedDiscoveryTrace>.unmodifiable([
  for (final spec in xianCityWallDiscoverySpecs)
    RemediatedDiscoveryTrace(
      discoveryIndex: spec.level - 1,
      storyEventIds: const ['XIAN-E4-history', 'XIAN-E5-recognition'],
      sourceIds: spec.sourceIds,
    ),
]);

final xianCityWallChallenges = List<XianChallengeSpec>.unmodifiable([
  for (var level = 1; level <= 10; level++) ...<XianChallengeSpec>[
    XianChallengeSpec(level: level, type: 'paragraphRebuild', anchor: xianCityWallOnePassLevels[level - 1].storyParagraphs.first, answer: '按当前等级故事顺序重建周遥从起跑到继续向新家的路线。'),
    XianChallengeSpec(level: level, type: 'grammarRepair', anchor: xianCityWallOnePassLevels[level - 1].storyParagraphs.first, answer: xianCityWallOnePassLevels[level - 1].storyParagraphs.first),
    XianChallengeSpec(level: level, type: 'missingSentence', anchor: _xianMissingSentenceAnswers[level - 1], answer: _xianMissingSentenceAnswers[level - 1]),
  ],
]);

const _xianMissingSentenceAnswers = <String>[
  '他没有按停，而是下城继续往南跑。',
  '周遥抬手看了一眼，没有按停计时，直接下城，沿南边的街道继续向新家跑去。',
  '周遥抬手看了看跑表，没有按停。',
  '周遥没有按停计时。',
  '周遥停了半步，没有按停计时，而是直接下城，沿南边街道继续跑向新家。',
  '周遥抬手，本可以按下停止，却把手指移开。',
  '周遥停了半步，把已经抬起的手放下，没有结束计时。',
  '周遥笑了，把手指从停止键上移开。',
  '周遥抬起手，停了半步，又把手指从停止键上移开。',
  '周遥抬手，手指碰到停止键又移开。',
];

final xianCityWallMemory = List<RemediatedMemoryReview>.unmodifiable([
  const RemediatedMemoryReview(category: 'protagonist', prompt: '谁把最后一次绕城跑设成搬家前的告别？', answer: '周遥，一个在西安城墙内老街长大的二十二岁年轻人。', storyEventIds: ['XIAN-E1-start']),
  const RemediatedMemoryReview(category: 'support', prompt: '谁用新家消息推动故事继续，而不是充当历史导师？', answer: '周遥的母亲；弟弟在高等级故事的新家照片中出现。', storyEventIds: ['XIAN-E3-doubt', 'XIAN-E6-climax']),
  const RemediatedMemoryReview(category: 'route', prompt: '周遥的路线如何变化？', answer: '从永宁门登城，沿城墙完整绕行回到永宁门，再下城向南继续跑到新家。', storyEventIds: ['XIAN-E1-start', 'XIAN-E6-climax', 'XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'history', prompt: '城墙的历史理解是什么？', answer: '现存主体主要在明洪武年间形成，并承接更早城市墙体基础；1961年列入第一批全国重点文物保护单位。', storyEventIds: ['XIAN-E4-history']),
  const RemediatedMemoryReview(category: 'culture', prompt: '故事怎样理解城墙今天的意义？', answer: '它既是受保护的古代防御遗产，也处在当代交通、运动、居住与公共生活中。', storyEventIds: ['XIAN-E4-history', 'XIAN-E5-recognition']),
  const RemediatedMemoryReview(category: 'conflict', prompt: '周遥真正担心的是什么？', answer: '他担心搬到城外会让自己与老城的归属一起结束。', storyEventIds: ['XIAN-E3-doubt']),
  const RemediatedMemoryReview(category: 'turningPoint', prompt: '什么让他怀疑“城门就是生活终点”？', answer: '跑步一路撞上自己过去不断穿城门的上学、骑车、亲友和日常路线。', storyEventIds: ['XIAN-E5-recognition']),
  const RemediatedMemoryReview(category: 'climax', prompt: '整圈完成时周遥做了什么？', answer: '他没有按停跑表，而是从永宁门下城继续向新家跑。', storyEventIds: ['XIAN-E6-climax']),
  const RemediatedMemoryReview(category: 'anchor', prompt: 'Memory Anchor是什么？', answer: '永宁门后没有按停的跑表。', storyEventIds: ['XIAN-E6-climax', 'XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'growth', prompt: '最后的跑步记录说明了什么？', answer: '城墙仍是完整历史空间，但周遥的归属可以沿生活轨迹穿过城门继续生长。', storyEventIds: ['XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'vocabulary', prompt: '“闭环”和“归属感”在故事里怎样相遇？', answer: '城墙形成物理闭环；归属感却没有被那条闭环限制。', storyEventIds: ['XIAN-E5-recognition', 'XIAN-E6-climax']),
]);

const xianCityWallCompletion = XianCompleteSpec(
  journeySummary: '周遥把搬家前的一整圈城墙跑当成告别，却在回到永宁门后让跑表继续，把闭合环线接到城外的新家。',
  achievement: '续程跑者',
  memoryAnchor: '永宁门后没有按停的跑表',
  anchorMeaning: '跑表在完整一圈之后继续计时，把城墙的闭合形状与周遥不断延伸的生活路线同时保存下来。',
  challengeReward: '长安续程牌',
  rewardMeaning: '不是通行许可或历史复制品，而是一枚记录“完成一圈仍继续前进”的路线徽记。',
  rewardUnlockText: '你已完成西安城墙三种故事挑战，解锁「长安续程牌」。',
  journeyCompletion: '第二天，周遥把从永宁门延伸到新住址的跑步记录命名为“回家”。',
);

const xianCityWallSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2020', publisher: '陕西省人民政府', scope: '13.74公里周长、传统四门与城墙概况'),
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2021', publisher: '陕西省人民政府', scope: '明洪武七年至十一年、墙体尺度与13.74公里周长'),
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2024', publisher: '陕西省人民政府', scope: '古代军事防御体系与城墙概况'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-city-wall', publisher: '陕西省文物局', scope: '西安城墙为明代古建筑、第一批全国重点文物保护单位'),
  RemediatedSourceBinding(id: 'shaanxi-city-wall-regulation', publisher: '陕西省文物局 / 西安市地方性法规', scope: '墙体、城门、附属建筑、护城河及遗址遗迹整体保护'),
  RemediatedSourceBinding(id: 'xian-municipal-conservation', publisher: '西安市人民政府', scope: '1983年以来修复、管理机构与现代监测保护'),
  RemediatedSourceBinding(id: 'xian-planning-photogrammetry', publisher: '西安市自然资源和规划局', scope: '13.74公里、数字化测绘与保护'),
  RemediatedSourceBinding(id: 'xian-city-wall-marathon', publisher: '西安市人民政府', scope: '13.7公里绕城跑赛事与城墙运动使用'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-register', publisher: '陕西省文物局', scope: '西安城墙明代、全国重点文物保护单位登记'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-data-2024', publisher: '陕西省文物局', scope: '中国明清城墙世界文化遗产预备名录组成信息'),
  RemediatedSourceBinding(id: 'shaanxi-old-city-heritage', publisher: '陕西省文物局', scope: '城墙内历史城区、历史文化街区与文物资源'),
  RemediatedSourceBinding(id: 'qujiang-city-wall', publisher: '西安曲江新区管理委员会', scope: '明代城墙、防御体系与修缮信息'),
];

const xianCityWallSemanticEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(id: 'XIAN-E1-start', coreChinese: '周遥从永宁门开始最后一圈跑步。', corePinyin: 'Zhōu Yáo cóng Yǒngníngmén kāishǐ zuìhòu yì quān pǎobù.', coreVietnamese: 'Chu Dao bắt đầu vòng chạy cuối từ cổng Vĩnh Ninh.', coreEnglish: 'Zhou Yao starts his final circuit from Yongning Gate.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E2-view', coreChinese: '夕阳里，他同时看见城内旧街与城外新城区。', corePinyin: 'Xīyáng lǐ tā tóngshí kànjiàn chéngnèi yǔ chéngwài.', coreVietnamese: 'Trong hoàng hôn cậu nhìn thấy cả trong và ngoài thành.', coreEnglish: 'At sunset he sees both inside and outside the wall.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E3-doubt', coreChinese: '搬家消息让他把住址变化误认成归属终止。', corePinyin: 'Bānjiā xiāoxi ràng tā bǎ zhùzhǐ biànhuà wùrèn chéng guīshǔ zhōngzhǐ.', coreVietnamese: 'Tin chuyển nhà khiến cậu nhầm thay đổi địa chỉ với mất cảm giác thuộc về.', coreEnglish: 'The move makes him confuse an address change with the end of belonging.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E4-history', coreChinese: '城墙的防御、明代形成与持续保护进入他的路线。', corePinyin: 'Chéngqiáng de lìshǐ yǔ bǎohù jìnrù tā de lùxiàn.', coreVietnamese: 'Lịch sử và bảo tồn thành đi vào tuyến chạy của cậu.', coreEnglish: 'The wall’s history and conservation enter his route.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E5-recognition', coreChinese: '个人生活路线反复穿过城门，使内外二分失效。', corePinyin: 'Shēnghuó lùxiàn fǎnfù chuānguò chéngmén.', coreVietnamese: 'Các tuyến đời sống nhiều lần đi qua cổng thành.', coreEnglish: 'His lived routes repeatedly pass through the gates.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E6-climax', coreChinese: '回到永宁门后，他让跑表继续并下城向新家跑。', corePinyin: 'Huídào Yǒngníngmén hòu, tā ràng pǎobiǎo jìxù.', coreVietnamese: 'Trở lại Vĩnh Ninh Môn, cậu để đồng hồ tiếp tục chạy.', coreEnglish: 'Back at Yongning Gate, he leaves the watch running.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E7-ending', coreChinese: '他到新家才停表，并把连续路线命名为“回家”。', corePinyin: 'Tā dào xīn jiā cái tíng biǎo, bǎ lùxiàn mìngmíng wéi huíjiā.', coreVietnamese: 'Cậu chỉ dừng đồng hồ ở nhà mới và đặt tên tuyến là “về nhà”.', coreEnglish: 'He stops the watch at the new home and names the route “Home”.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
];

final xianCityWallOnePassRemediation = RemediatedJourney(
  id: xianCityWallJourneyId,
  title: '西安 · 城墙：跑完一圈以后',
  protagonist: '周遥',
  goal: '在全家迁居城外前跑完一整圈城墙，把它当作一次明确的告别。',
  conflict: '周遥把搬出城墙误认为归属结束；完整环线给了他一个虚假的生活终点。',
  eventIds: List<String>.unmodifiable([for (final event in xianCityWallSemanticEvents) event.id]),
  events: xianCityWallSemanticEvents,
  levels: xianCityWallOnePassLevels,
  words: xianCityWallOnePassWords,
  wordTraces: xianCityWallWordTraces,
  discoveries: xianCityWallOnePassDiscoveries,
  discoveryTraces: xianCityWallDiscoveryTraces,
  challenges: List<RemediatedChallengeTrace>.unmodifiable([
    for (final challenge in xianCityWallChallenges)
      RemediatedChallengeTrace(type: challenge.type, storyEventIds: const ['XIAN-E1-start', 'XIAN-E6-climax'], anchor: challenge.anchor),
  ]),
  memory: xianCityWallMemory,
  completion: const RemediatedCompletion(
    journeySummary: '周遥把搬家前的一整圈城墙跑当成告别，却在回到永宁门后让跑表继续，把闭合环线接到城外的新家。',
    achievement: '续程跑者',
    memoryAnchor: '永宁门后没有按停的跑表',
    challengeReward: '长安续程牌：完成一圈仍继续前进的路线徽记。',
    journeyCompletion: '第二天，周遥把从永宁门延伸到新住址的跑步记录命名为“回家”。',
  ),
  sources: xianCityWallSources,
);

JourneyLevelContent xianCityWallOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = xianCityWallOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final visibleWords = xianCityWallOnePassWords
      .where((entry) => story.contains(entry.word))
      .take((4 + level).clamp(5, 12))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(visibleWords),
    discoveries: List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
      xianCityWallDiscoverySpecs[level - 1].entry,
    ]),
    wonderQuestion: '周遥为什么在跑完一整圈后故意不按停跑表？',
    expressQuestion: '城墙的闭合形状与周遥连续的生活路线怎样形成对照？',
  );
}
