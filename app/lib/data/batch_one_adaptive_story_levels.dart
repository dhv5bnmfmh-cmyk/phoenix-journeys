import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import 'all_journey_language_level_catalog.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const batchOneGoldJourneyIds = <String>{
  'beijing-forbidden-city',
  'shanghai-bund',
};

bool isBatchOneGoldJourney(String journeyId) =>
    batchOneGoldJourneyIds.contains(journeyId);

class BatchOneJourneyMemorySpec {
  const BatchOneJourneyMemorySpec({
    required this.storyResult,
    required this.culturalPoint,
    required this.longTermAnchor,
    required this.completionSummary,
  });

  final String storyResult;
  final String culturalPoint;
  final String longTermAnchor;
  final String completionSummary;
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(String journeyId) {
  return switch (journeyId) {
    'beijing-forbidden-city' => const BatchOneJourneyMemorySpec(
        storyResult:
            '梁砚放弃按时交出漂亮结论，改为提交标明不确定性的复核单；修缮判断因此延后，却避免了不必要的拆检。',
        culturalPoint:
            '紫禁城的中轴空间、长期修缮档案与测量基准共同让古建保护可定位、可核对、可追溯。',
        longTermAnchor: '工牌夹进写着“同长度”的记录夹：先确认尺度，再下判断。',
        completionSummary: '从“用速度证明独立”，走到“用证据承担判断”。',
      ),
    'shanghai-bund' => const BatchOneJourneyMemorySpec(
        storyResult:
            '周玥错过第一次上传窗口，并删掉自己最喜欢的天际线句子，换来一份事实可以逐项核对的九十秒导览。',
        culturalPoint:
            '外滩不是一个单一标签：滨水历史街区、金融与贸易、多样建筑用途以及对岸浦东共同形成上海的城市层次。',
        longTermAnchor: '红笔校样上的一句话：“别让一条街只讲一个故事”。',
        completionSummary: '从“漂亮的老城／新城对照”，走到“在有限时间里守住复杂而准确的城市记忆”。',
      ),
    _ => null,
  };
}

class _DepthDetail {
  const _DepthDetail({
    required this.fromLevel,
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final int fromLevel;
  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
}

class _StoryEvent {
  const _StoryEvent({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
    this.details = const <_DepthDetail>[],
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
  final List<_DepthDetail> details;

  String chineseAt(int level) =>
      '$chinese${details.where((item) => level >= item.fromLevel).map((item) => item.chinese).join()}';

  String pinyinAt(int level) => <String>[
        pinyin,
        ...details
            .where((item) => level >= item.fromLevel)
            .map((item) => item.pinyin),
      ].where((item) => item.trim().isNotEmpty).join(' ');

  String vietnameseAt(int level) => <String>[
        vietnamese,
        ...details
            .where((item) => level >= item.fromLevel)
            .map((item) => item.vietnamese),
      ].where((item) => item.trim().isNotEmpty).join(' ');

  String englishAt(int level) => <String>[
        english,
        ...details
            .where((item) => level >= item.fromLevel)
            .map((item) => item.english),
      ].where((item) => item.trim().isNotEmpty).join(' ');
}

class _StoryBlueprint {
  const _StoryBlueprint({
    required this.opening,
    required this.closing,
  });

  final List<_StoryEvent> opening;
  final List<_StoryEvent> closing;
}

class _BuiltStory {
  const _BuiltStory({
    required this.paragraphs,
    required this.annotations,
  });

  final List<String> paragraphs;
  final List<ReadingAnnotation> annotations;
}

const _forbiddenCityBlueprint = _StoryBlueprint(
  opening: <_StoryEvent>[
    _StoryEvent(
      chinese: '十九岁的梁砚在午门前接到独立测绘任务。',
      pinyin: 'Shíjiǔ suì de Liáng Yàn zài Wǔmén qián jiēdào dúlì cèhuì rènwù.',
      vietnamese:
          'Lương Nghiễn, mười chín tuổi, nhận nhiệm vụ đo vẽ độc lập trước Ngọ Môn.',
      english:
          'Nineteen-year-old Liang Yan receives his first independent survey assignment before the Meridian Gate.',
    ),
    _StoryEvent(
      chinese: '师父沈岚要他闭馆前复核太和殿屋脊。',
      pinyin: 'Shīfu Shěn Lán yào tā bìguǎn qián fùhé Tàihédiàn wūjǐ.',
      vietnamese:
          'Người hướng dẫn Thẩm Lam yêu cầu anh kiểm tra lại sống mái Điện Thái Hòa trước giờ đóng cửa.',
      english:
          'His mentor Shen Lan asks him to recheck the Hall of Supreme Harmony roof ridge before closing.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 2,
          chinese:
              '任务单要求写清构件位置、测量方向、拍摄角度和现场保护标记。沈岚提醒他，任何一项含糊都可能把后续修缮判断带到错误方向。',
          pinyin:
              'Rènwùdān yāoqiú xiěqīng gòujiàn wèizhì, cèliáng fāngxiàng, pāishè jiǎodù hé xiànchǎng bǎohù biāojì. Shěn Lán tíxǐng tā, rènhé yí xiàng hánhú dōu kěnéng bǎ hòuxù xiūshàn pànduàn dài dào cuòwù fāngxiàng.',
          vietnamese:
              'Phiếu nhiệm vụ yêu cầu ghi rõ vị trí cấu kiện, hướng đo, góc chụp và dấu bảo tồn tại hiện trường. Thẩm Lam nhắc rằng một mục mơ hồ cũng có thể dẫn quyết định tu bổ đi sai hướng.',
          english:
              'The task sheet requires the component location, measuring direction, camera angle, and conservation marks. Shen Lan warns that any ambiguity can misdirect later conservation decisions.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '梁砚想用速度证明自己能独立。',
      pinyin: 'Liáng Yàn xiǎng yòng sùdù zhèngmíng zìjǐ néng dúlì.',
      vietnamese:
          'Lương Nghiễn muốn dùng tốc độ để chứng minh mình có thể làm việc độc lập.',
      english: 'Liang Yan wants speed to prove that he can work independently.',
    ),
    _StoryEvent(
      chinese: '新数据与旧图冲突，苏禾让他先查修缮记录。',
      pinyin: 'Xīn shùjù yǔ jiù tú chōngtū, Sū Hé ràng tā xiān chá xiūshàn jìlù.',
      vietnamese:
          'Dữ liệu mới mâu thuẫn với bản vẽ cũ, nên kỹ thuật viên Tô Hòa bảo anh kiểm tra hồ sơ tu bổ trước.',
      english:
          'The new measurements conflict with an older drawing, and technician Su He tells him to check the conservation records first.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 3,
          chinese:
              '苏禾提醒他，故宫木构与屋面经历长期维修，同一处位置可能留下不同年代的图纸、编号和表达方式。只有把年代、位置和记录目的放在一起，数字才真正可比。',
          pinyin:
              'Sū Hé tíxǐng tā, Gùgōng mùgòu yǔ wūmiàn jīnglì chángqī wéixiū, tóng yí chù wèizhì kěnéng liúxià bùtóng niándài de túzhǐ, biānhào hé biǎodá fāngshì. Zhǐyǒu bǎ niándài, wèizhì hé jìlù mùdì fàng zài yìqǐ, shùzì cái zhēnzhèng kěbǐ.',
          vietnamese:
              'Tô Hòa nhắc rằng kết cấu gỗ và mái trong Cố Cung đã được sửa chữa qua thời gian dài; cùng một vị trí có thể có bản vẽ, mã số và cách biểu đạt từ những thời kỳ khác nhau. Chỉ khi đặt niên đại, vị trí và mục đích ghi chép cạnh nhau thì các con số mới thực sự so sánh được.',
          english:
              'Su He explains that the Palace Museum’s timber structures and roofs have undergone long-term maintenance, so one location may have drawings, identifiers, and conventions from different periods. Numbers become comparable only when date, location, and recording purpose are considered together.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '他必须在准时上报和返回核对之间选择。',
      pinyin: 'Tā bìxū zài zhǔnshí shàngbào hé fǎnhuí héduì zhījiān xuǎnzé.',
      vietnamese:
          'Anh phải chọn giữa báo cáo đúng giờ và quay lại kiểm tra bằng chứng.',
      english:
          'He must choose between reporting on time and going back to verify the evidence.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 4,
          chinese:
              '若直接上报，差异可能被当成新的结构位移，修缮组甚至会准备进一步拆检；若返回档案室核对，他就会错过当日交件窗口，也失去用速度证明自己的机会。',
          pinyin:
              'Ruò zhíjiē shàngbào, chāyì kěnéng bèi dàngchéng xīn de jiégòu wèiyí, xiūshànzǔ shènzhì huì zhǔnbèi jìnyíbù chāijiǎn; ruò fǎnhuí dàng’ànshì héduì, tā jiù huì cuòguò dāngrì jiāojiàn chuāngkǒu, yě shīqù yòng sùdù zhèngmíng zìjǐ de jīhuì.',
          vietnamese:
              'Nếu báo cáo ngay, chênh lệch có thể bị hiểu là dịch chuyển kết cấu mới và đội tu bổ thậm chí có thể chuẩn bị tháo kiểm tra. Nếu quay lại phòng hồ sơ, anh sẽ lỡ khung giờ nộp trong ngày và mất cơ hội chứng minh mình bằng tốc độ.',
          english:
              'If he reports immediately, the difference may be treated as new structural movement and trigger further inspection. If he returns to the archive, he will miss the day’s submission window and his chance to prove himself through speed.',
        ),
      ],
    ),
  ],
  closing: <_StoryEvent>[
    _StoryEvent(
      chinese: '梁砚选择核对，却在途中丢了工牌。',
      pinyin: 'Liáng Yàn xuǎnzé héduì, què zài túzhōng diū le gōngpái.',
      vietnamese:
          'Lương Nghiễn chọn kiểm tra lại, nhưng trên đường anh làm rơi thẻ công tác.',
      english:
          'Liang Yan chooses verification, but loses his work badge on the way.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 5,
          chinese:
              '工牌不见后，他无法再次进入作业区，只能承认自己一路只顾赶时间，没有按交接规范检查文件夹。于是他根据午门安检、太和门照片和东庑时间戳，一段一段重建自己的行动路线。',
          pinyin:
              'Gōngpái bú jiàn hòu, tā wúfǎ zàicì jìnrù zuòyèqū, zhǐnéng chéngrèn zìjǐ yílù zhǐ gù gǎn shíjiān, méiyǒu àn jiāojiē guīfàn jiǎnchá wénjiànjiā. Yúshì tā gēnjù Wǔmén ānjiǎn, Tàihémén zhàopiàn hé dōngwǔ shíjiānchuō, yí duàn yí duàn chóngjiàn zìjǐ de xíngdòng lùxiàn.',
          vietnamese:
              'Mất thẻ khiến anh không thể vào lại khu làm việc. Anh phải thừa nhận mình chỉ lo chạy cho kịp giờ và không kiểm tra tập hồ sơ theo quy trình bàn giao. Anh dùng dấu kiểm tra ở Ngọ Môn, ảnh tại Thái Hòa Môn và mốc thời gian ở dãy nhà phía đông để dựng lại từng đoạn hành trình.',
          english:
              'Without the badge he cannot re-enter the work zone. He admits that rushing made him skip the handover check, then reconstructs his route from Meridian Gate security, photographs at the Gate of Supreme Harmony, and timestamps near the eastern side halls.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '他找回工牌，也查明两图测量口径不同。',
      pinyin: 'Tā zhǎohuí gōngpái, yě chámíng liǎng tú cèliáng kǒujìng bùtóng.',
      vietnamese:
          'Anh tìm lại được thẻ và xác định rằng hai bản ghi dùng hai quy ước đo khác nhau.',
      english:
          'He recovers the badge and discovers that the two records use different measurement conventions.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 6,
          chinese:
              '工牌找回后，他把旧图和新记录并排摊开：旧图写的是构件投影长度，新仪器记录的是屋面斜长。两组数字都可能正确，真正的错误来自把不同测量基准当成同一尺度，也来自他先入为主地把差异叫作“异常”。',
          pinyin:
              'Gōngpái zhǎohuí hòu, tā bǎ jiù tú hé xīn jìlù bìngpái tānkāi: jiù tú xiě de shì gòujiàn tóuyǐng chángdù, xīn yíqì jìlù de shì wūmiàn xiécháng. Liǎng zǔ shùzì dōu kěnéng zhèngquè, zhēnzhèng de cuòwù láizì bǎ bùtóng cèliáng jīzhǔn dàngchéng tóng yí chǐdù, yě láizì tā xiānrùwéizhǔ de bǎ chāyì jiàozuò “yìcháng”.',
          vietnamese:
              'Sau khi tìm lại thẻ, anh đặt bản vẽ cũ cạnh bản ghi mới: bản cũ ghi chiều dài hình chiếu, còn thiết bị mới ghi chiều dài theo độ dốc mái. Cả hai con số đều có thể đúng; sai lầm nằm ở việc coi hai chuẩn đo là cùng một thước đo và vội gọi chênh lệch là “bất thường”.',
          english:
              'With the badge recovered, he lays the records side by side: the older drawing gives projected length, while the new instrument records length along the roof slope. Both numbers can be correct; the mistake is treating different measurement bases as one scale and prematurely calling the difference an anomaly.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '闭馆前，他提交标明不确定性的复核单。',
      pinyin: 'Bìguǎn qián, tā tíjiāo biāomíng bù quèdìngxìng de fùhédān.',
      vietnamese:
          'Trước giờ đóng cửa, anh nộp phiếu kiểm tra ghi rõ những điểm chưa chắc chắn.',
      english:
          'Before closing, he submits a review sheet that explicitly marks what remains uncertain.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 7,
          chinese:
              '闭馆广播响起时，梁砚没有把两组数字硬合成一个漂亮结论。他在复核单上写清测量基准、图纸年代、维修编号、现场保护标记和仍需二次复测的位置，并注明当天无法确认是否存在新位移。',
          pinyin:
              'Bìguǎn guǎngbō xiǎngqǐ shí, Liáng Yàn méiyǒu bǎ liǎng zǔ shùzì yìng héchéng yí gè piàoliang jiélùn. Tā zài fùhédān shàng xiěqīng cèliáng jīzhǔn, túzhǐ niándài, wéixiū biānhào, xiànchǎng bǎohù biāojì hé réng xū èrcì fùcè de wèizhì, bìng zhùmíng dāngtiān wúfǎ quèrèn shìfǒu cúnzài xīn wèiyí.',
          vietnamese:
              'Khi loa báo đóng cửa vang lên, Lương Nghiễn không ép hai nhóm số liệu thành một kết luận đẹp. Anh ghi rõ chuẩn đo, niên đại bản vẽ, mã sửa chữa, dấu bảo tồn và vị trí cần đo lại, đồng thời nói rõ hôm đó chưa thể xác nhận có dịch chuyển mới hay không.',
          english:
              'As the closing announcement sounds, Liang Yan refuses to force the two datasets into a neat conclusion. He records the measurement basis, drawing date, maintenance identifier, conservation marks, and locations requiring a second check, stating that new movement cannot yet be confirmed.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '修缮组延后判断，避免了不必要的拆检。',
      pinyin: 'Xiūshànzǔ yánhòu pànduàn, bìmiǎn le bù bìyào de chāijiǎn.',
      vietnamese:
          'Đội tu bổ hoãn kết luận và tránh được việc tháo kiểm tra không cần thiết.',
      english:
          'The conservation team postpones its judgment and avoids unnecessary dismantling for inspection.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 8,
          chinese:
              '第二天复测说明构件稳定，差异来自表达方法而不是新的损坏。较慢的复核避免了依据错误口径进行不必要处置，也保住了后续记录的可信度。',
          pinyin:
              'Dì èr tiān fùcè shuōmíng gòujiàn wěndìng, chāyì láizì biǎodá fāngfǎ ér bú shì xīn de sǔnhuài. Jiào màn de fùhé bìmiǎn le yījù cuòwù kǒujìng jìnxíng bù bìyào chǔzhì, yě bǎozhù le hòuxù jìlù de kěxìndù.',
          vietnamese:
              'Đo lại ngày hôm sau cho thấy cấu kiện ổn định; khác biệt đến từ cách biểu đạt chứ không phải hư hại mới. Việc kiểm tra chậm hơn đã tránh xử lý không cần thiết dựa trên quy ước sai và giữ độ tin cậy cho hồ sơ tiếp theo.',
          english:
              'The next day’s remeasurement shows the component is stable and that the difference came from recording method, not new damage. The slower review prevents unnecessary intervention and preserves the credibility of later records.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '复核确认没有新位移。梁砚获得新任务，把工牌夹进“同长度”记录夹。',
      pinyin:
          'Fùhé quèrèn méiyǒu xīn wèiyí. Liáng Yàn huòdé xīn rènwù, bǎ gōngpái jiā jìn “tóng chángdù” jìlùjiā.',
      vietnamese:
          'Kiểm tra xác nhận không có dịch chuyển mới. Lương Nghiễn nhận nhiệm vụ tiếp theo và kẹp thẻ vào tập hồ sơ ghi “cùng một chiều dài”.',
      english:
          'The review confirms no new movement. Liang Yan receives another independent assignment and clips his badge into a folder marked “same length.”',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 9,
          chinese:
              '沈岚没有替他擦掉工牌丢失和误判的过程，而是让他把失误、证据冲突与修正步骤留进班组记录。梁砚开始把“别人能重新检查我的判断”视为能力的一部分，而不再把复核当成对独立的否定。',
          pinyin:
              'Shěn Lán méiyǒu tì tā cādiào gōngpái diūshī hé wùpàn de guòchéng, ér shì ràng tā bǎ shīwù, zhèngjù chōngtū yǔ xiūzhèng bùzhòu liú jìn bānzǔ jìlù. Liáng Yàn kāishǐ bǎ “biérén néng chóngxīn jiǎnchá wǒ de pànduàn” shìwéi nénglì de yí bùfen, ér bú zài bǎ fùhé dàngchéng duì dúlì de fǒudìng.',
          vietnamese:
              'Thẩm Lam không xóa khỏi hồ sơ chuyện mất thẻ hay phán đoán sai, mà yêu cầu anh giữ lại sai sót, xung đột bằng chứng và các bước sửa. Lương Nghiễn bắt đầu xem việc người khác có thể kiểm tra lại phán đoán của mình là một phần năng lực, không còn coi rà soát là phủ nhận tính độc lập.',
          english:
              'Shen Lan does not erase the lost badge or mistaken assumption. He asks Liang Yan to preserve the error, the conflicting evidence, and the correction steps in the team record. Liang Yan begins to see reviewability as part of competence rather than a denial of independence.',
        ),
        _DepthDetail(
          fromLevel: 10,
          chinese:
              '他进一步理解，紫禁城的中轴线不只塑造礼仪空间，也为今天的定位、巡查、构件编号和档案对应提供连续参照。面对彼此冲突的证据，公开不确定性、说明尺度与来源，本身就是保护遗产的专业责任。',
          pinyin:
              'Tā jìnyíbù lǐjiě, Zǐjìnchéng de zhōngzhóuxiàn bù zhǐ sùzào lǐyí kōngjiān, yě wèi jīntiān de dìngwèi, xúnchá, gòujiàn biānhào hé dàng’àn duìyìng tígōng liánxù cānzhào. Miànduì bǐcǐ chōngtū de zhèngjù, gōngkāi bù quèdìngxìng, shuōmíng chǐdù yǔ láiyuán, běnshēn jiù shì bǎohù yíchǎn de zhuānyè zérèn.',
          vietnamese:
              'Anh hiểu sâu hơn rằng trục trung tâm của Tử Cấm Thành không chỉ định hình không gian nghi lễ mà còn cung cấp mốc liên tục cho định vị, tuần tra, đánh số cấu kiện và đối chiếu hồ sơ hôm nay. Khi bằng chứng xung đột, công khai điều chưa chắc chắn và nêu rõ thước đo cùng nguồn gốc chính là trách nhiệm nghề nghiệp trong bảo tồn di sản.',
          english:
              'He further understands that the Forbidden City’s central axis not only shapes ritual space but also provides a continuous reference for modern positioning, inspection, component numbering, and archival matching. When evidence conflicts, stating uncertainty, scale, and provenance is itself a professional duty of conservation.',
        ),
      ],
    ),
  ],
);

const _shanghaiBundBlueprint = _StoryBlueprint(
  opening: <_StoryEvent>[
    _StoryEvent(
      chinese: '二十二岁的周玥在外滩录制城市声音导览。',
      pinyin: 'Èrshí’èr suì de Zhōu Yuè zài Wàitān lùzhì chéngshì shēngyīn dǎolǎn.',
      vietnamese:
          'Chu Nguyệt, hai mươi hai tuổi, đang thu một bài hướng dẫn âm thanh đô thị tại Bến Thượng Hải.',
      english:
          'Twenty-two-year-old Zhou Yue is recording an urban audio guide on the Bund.',
    ),
    _StoryEvent(
      chinese: '导师韩澈要她六点前交出九十秒双语成片。',
      pinyin: 'Dǎoshī Hán Chè yào tā liù diǎn qián jiāochū jiǔshí miǎo shuāngyǔ chéngpiàn.',
      vietnamese:
          'Người hướng dẫn Hàn Triệt yêu cầu cô nộp bản âm thanh song ngữ chín mươi giây trước sáu giờ.',
      english:
          'Her mentor Han Che asks her to deliver a ninety-second bilingual final cut before six o’clock.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 2,
          chinese:
              '任务要求中文主叙事、英文辅助，并且每个事实都能追到已审核来源。韩澈只给她一个原则：声音可以有节奏，事实不能为了节奏变形。',
          pinyin:
              'Rènwù yāoqiú Zhōngwén zhǔ xùshì, Yīngwén fǔzhù, bìngqiě měi gè shìshí dōu néng zhuī dào yǐ shěnhé láiyuán. Hán Chè zhǐ gěi tā yí gè yuánzé: shēngyīn kěyǐ yǒu jiézòu, shìshí bùnéng wèile jiézòu biànxíng.',
          vietnamese:
              'Bài phải dùng tiếng Trung làm lời kể chính, tiếng Anh hỗ trợ, và mỗi dữ kiện phải truy được về nguồn đã duyệt. Hàn Triệt chỉ đưa một nguyên tắc: âm thanh có thể có nhịp, nhưng sự thật không được biến dạng vì nhịp.',
          english:
              'The piece must use Chinese as the main narration, English as support, and trace every factual claim to reviewed sources. Han Che gives one rule: sound may have rhythm, but facts must not bend for rhythm.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '周玥想用“老外滩对新浦东”做漂亮开场。',
      pinyin: 'Zhōu Yuè xiǎng yòng “lǎo Wàitān duì xīn Pǔdōng” zuò piàoliang kāichǎng.',
      vietnamese:
          'Chu Nguyệt muốn mở đầu thật đẹp bằng đối lập “Bến Thượng Hải cũ với Phố Đông mới”.',
      english:
          'Zhou Yue wants a polished opening built around “old Bund versus new Pudong.”',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 3,
          chinese:
              '周玥沿黄浦江西岸走一遍。历史街区、不同风格建筑与对岸浦东同时进入视野，她意识到“两个时代”只是观看角度，不是完整解释。',
          pinyin:
              'Zhōu Yuè yán Huángpǔ Jiāng xī’àn zǒu yí biàn. Lìshǐ jiēqū, bùtóng fēnggé jiànzhù yǔ duì’àn Pǔdōng tóngshí jìnrù shìyě, tā yìshí dào “liǎng gè shídài” zhǐ shì guānkàn jiǎodù, bú shì wánzhěng jiěshì.',
          vietnamese:
              'Chu Nguyệt đi dọc bờ tây sông Hoàng Phố. Khu phố lịch sử, các công trình nhiều phong cách và Phố Đông bên kia sông cùng xuất hiện trong tầm mắt; cô nhận ra “hai thời đại” chỉ là một góc nhìn chứ không phải lời giải thích đầy đủ.',
          english:
              'Zhou Yue walks the west bank of the Huangpu. The historic district, buildings in varied styles, and Pudong across the river enter the same view, and she realizes that “two eras” is only a viewing angle, not a complete explanation.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '核对资料时，她发现稿子把历史建筑都写成了银行。',
      pinyin: 'Héduì zīliào shí, tā fāxiàn gǎozi bǎ lìshǐ jiànzhù dōu xiě chéng le yínháng.',
      vietnamese:
          'Khi kiểm tra tài liệu, cô phát hiện bản thảo đã viết tất cả các công trình lịch sử thành ngân hàng.',
      english:
          'While checking the sources, she discovers that the script has described all the historic buildings as banks.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 4,
          chinese:
              '旧稿为了好记，把银行、贸易机构和其他城市功能压成同一种建筑身份。若继续使用，听众会得到清楚却错误的印象；若重查，她准备好的节奏和提交时间都会被打乱。',
          pinyin:
              'Jiù gǎo wèile hǎojì, bǎ yínháng, màoyì jīgòu hé qítā chéngshì gōngnéng yā chéng tóng yì zhǒng jiànzhù shēnfèn. Ruò jìxù shǐyòng, tīngzhòng huì dédào qīngchu què cuòwù de yìnxiàng; ruò chóngchá, tā zhǔnbèi hǎo de jiézòu hé tíjiāo shíjiān dōu huì bèi dǎluàn.',
          vietnamese:
              'Để dễ nhớ, bản cũ đã ép ngân hàng, cơ sở thương mại và các chức năng đô thị khác thành một bản sắc công trình duy nhất. Giữ lại thì người nghe sẽ có ấn tượng rõ ràng nhưng sai; kiểm tra lại thì nhịp dựng và hạn nộp đều bị phá vỡ.',
          english:
              'For memorability, the old draft compresses banks, trading institutions, and other urban functions into one building identity. Keeping it gives listeners a clear but false impression; checking it again disrupts both her prepared rhythm and deadline.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '韩澈提醒她，外滩建筑的用途并不相同。',
      pinyin: 'Hán Chè tíxǐng tā, Wàitān jiànzhù de yòngtú bìng bù xiāngtóng.',
      vietnamese:
          'Hàn Triệt nhắc rằng các công trình trên Bến Thượng Hải không có cùng một công năng.',
      english:
          'Han Che reminds her that the Bund’s historic buildings did not all serve the same purpose.',
    ),
  ],
  closing: <_StoryEvent>[
    _StoryEvent(
      chinese: '她必须在按时上传和重新核对之间选择。',
      pinyin: 'Tā bìxū zài ànshí shàngchuán hé chóngxīn héduì zhījiān xuǎnzé.',
      vietnamese:
          'Cô phải chọn giữa tải lên đúng giờ và kiểm tra lại nguồn.',
      english:
          'She must choose between uploading on time and verifying the sources again.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 5,
          chinese:
              '她选择打开政府资料、历史街区说明和自己的建筑卡片逐项核对，还把不确定的句子先从录音轨道静音。第一次上传窗口因此关闭，制作表上出现了醒目的逾期标记。',
          pinyin:
              'Tā xuǎnzé dǎkāi zhèngfǔ zīliào, lìshǐ jiēqū shuōmíng hé zìjǐ de jiànzhù kǎpiàn zhúxiàng héduì, hái bǎ bù quèdìng de jùzi xiān cóng lùyīn guǐdào jìngyīn. Dì yī cì shàngchuán chuāngkǒu yīncǐ guānbì, zhìzuò biǎo shàng chūxiàn le xǐngmù de yúqī biāojì.',
          vietnamese:
              'Cô mở tài liệu chính quyền, phần giới thiệu khu lịch sử và thẻ công trình của mình để kiểm tra từng mục, đồng thời tạm tắt tiếng những câu chưa chắc chắn trên đường âm thanh. Cửa sổ tải lên đầu tiên vì thế đóng lại và bảng sản xuất hiện dấu quá hạn rõ ràng.',
          english:
              'She opens government material, historic-district descriptions, and her own building cards to verify each item, muting uncertain lines on the audio track. The first upload window closes, leaving a conspicuous late mark on the production sheet.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '周玥选择核对资料，错过第一次上传窗口。',
      pinyin: 'Zhōu Yuè xuǎnzé héduì zīliào, cuòguò dì yī cì shàngchuán chuāngkǒu.',
      vietnamese:
          'Chu Nguyệt chọn kiểm tra tài liệu và bỏ lỡ cửa sổ tải lên đầu tiên.',
      english:
          'Zhou Yue chooses verification and misses the first upload window.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 6,
          chinese:
              '核对结果让她重新组织内容：金融与贸易确实深刻影响外滩，但建筑群的价值也来自多样风格、不同用途、滨水位置以及城市持续变化的关系。',
          pinyin:
              'Héduì jiéguǒ ràng tā chóngxīn zǔzhī nèiróng: jīnróng yǔ màoyì quèshí shēnkè yǐngxiǎng Wàitān, dàn jiànzhùqún de jiàzhí yě láizì duōyàng fēnggé, bùtóng yòngtú, bīnshuǐ wèizhì yǐjí chéngshì chíxù biànhuà de guānxì.',
          vietnamese:
              'Kết quả kiểm tra khiến cô tổ chức lại nội dung: tài chính và thương mại quả thật ảnh hưởng sâu sắc đến Bến Thượng Hải, nhưng giá trị của quần thể còn đến từ phong cách đa dạng, công năng khác nhau, vị trí ven sông và quan hệ với một thành phố luôn biến đổi.',
          english:
              'The verification reshapes her script: finance and trade deeply influenced the Bund, but its value also comes from varied styles, different uses, its waterfront setting, and its relationship with a changing city.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '她确认金融和贸易重要，却不能把整条街压成一个标签。',
      pinyin: 'Tā quèrèn jīnróng hé màoyì zhòngyào, què bùnéng bǎ zhěng tiáo jiē yā chéng yí gè biāoqiān.',
      vietnamese:
          'Cô xác nhận tài chính và thương mại rất quan trọng, nhưng không thể ép cả tuyến phố vào một nhãn duy nhất.',
      english:
          'She confirms that finance and trade matter, but refuses to compress the entire waterfront into one label.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 7,
          chinese:
              '韩澈要求她仍然守住九十秒。周玥没有把事实重新挤成口号，而是删掉自己最喜欢的“浦东灯光像未来扑面而来”，把时间留给一个更准确的转折。',
          pinyin:
              'Hán Chè yāoqiú tā réngrán shǒuzhù jiǔshí miǎo. Zhōu Yuè méiyǒu bǎ shìshí chóngxīn jǐ chéng kǒuhào, ér shì shāndiào zìjǐ zuì xǐhuan de “Pǔdōng dēngguāng xiàng wèilái pūmiàn ér lái”, bǎ shíjiān liú gěi yí gè gèng zhǔnquè de zhuǎnzhé.',
          vietnamese:
              'Hàn Triệt vẫn yêu cầu giữ đúng chín mươi giây. Chu Nguyệt không ép sự thật trở lại thành khẩu hiệu, mà cắt câu cô thích nhất, “ánh sáng Phố Đông như tương lai tràn tới”, để dành thời lượng cho một bước chuyển chính xác hơn.',
          english:
              'Han Che still holds her to ninety seconds. Zhou Yue does not squeeze the facts back into a slogan; she cuts her favorite line, “Pudong’s lights rush toward you like the future,” to make room for a more accurate turn.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '为守住九十秒，她删掉最喜欢的天际线句子，重写导览。',
      pinyin: 'Wèi shǒuzhù jiǔshí miǎo, tā shāndiào zuì xǐhuan de tiānjìxiàn jùzi, chóngxiě dǎolǎn.',
      vietnamese:
          'Để giữ đúng chín mươi giây, cô cắt câu đường chân trời mình thích nhất và viết lại phần hướng dẫn.',
      english:
          'To keep the ninety-second limit, she removes her favorite skyline line and rewrites the guide.',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 8,
          chinese:
              '新版导览先让听众听见江风和轮船声，再指出西岸历史建筑与东岸现代天际线可以同时被看见；这种并置不是胜负，而是上海不同阶段在同一条河边持续叠加。',
          pinyin:
              'Xīnbǎn dǎolǎn xiān ràng tīngzhòng tīngjiàn jiāngfēng hé lúnchuán shēng, zài zhǐchū xī’àn lìshǐ jiànzhù yǔ dōng’àn xiàndài tiānjìxiàn kěyǐ tóngshí bèi kànjiàn; zhè zhǒng bìngzhì bú shì shèngfù, ér shì Shànghǎi bùtóng jiēduàn zài tóng yì tiáo hébiān chíxù diéjiā.',
          vietnamese:
              'Bản mới cho người nghe nghe gió sông và tiếng tàu trước, rồi chỉ ra rằng các công trình lịch sử bờ tây và đường chân trời hiện đại bờ đông có thể được nhìn cùng lúc. Sự đặt cạnh nhau ấy không phải cuộc thắng thua, mà là các giai đoạn của Thượng Hải tiếp tục chồng lớp bên cùng một dòng sông.',
          english:
              'The new guide begins with river wind and vessel sounds, then points out that west-bank historic buildings and the east-bank modern skyline can be seen at the same time. Their juxtaposition is not a contest, but layers of Shanghai continuing beside one river.',
        ),
      ],
    ),
    _StoryEvent(
      chinese: '成片上线后，韩澈把红笔校样交给她；批注写着“别让一条街只讲一个故事”。',
      pinyin:
          'Chéngpiàn shàngxiàn hòu, Hán Chè bǎ hóngbǐ jiàoyàng jiāogěi tā; pīzhù xiězhe “bié ràng yì tiáo jiē zhǐ jiǎng yí gè gùshi”.',
      vietnamese:
          'Sau khi bản âm thanh lên sóng, Hàn Triệt đưa cô bản hiệu đính bút đỏ; lời ghi chú viết: “Đừng để một con phố chỉ kể một câu chuyện.”',
      english:
          'After the final cut goes live, Han Che gives her the red-pencil proof. The note reads: “Do not let one street tell only one story.”',
      details: <_DepthDetail>[
        _DepthDetail(
          fromLevel: 9,
          chinese:
              '上线前最后一次校听时，她主动标出一句仍可能让人误解的“露天建筑博物馆”，补上“常被这样形容”并解释它指向建筑多样性，而不是一条停止生活的展柜。',
          pinyin:
              'Shàngxiàn qián zuìhòu yí cì jiàotīng shí, tā zhǔdòng biāochū yí jù réng kěnéng ràng rén wùjiě de “lùtiān jiànzhù bówùguǎn”, bǔshàng “cháng bèi zhèyàng xíngróng” bìng jiěshì tā zhǐxiàng jiànzhù duōyàngxìng, ér bú shì yì tiáo tíngzhǐ shēnghuó de zhǎnguì.',
          vietnamese:
              'Trong lần nghe kiểm cuối trước khi đăng, cô chủ động đánh dấu cụm “bảo tàng kiến trúc ngoài trời” vì vẫn có thể gây hiểu lầm, thêm “thường được mô tả như vậy” và giải thích rằng cách nói này nhấn mạnh sự đa dạng kiến trúc chứ không biến khu phố thành một tủ trưng bày đã ngừng sống.',
          english:
              'During the final proof-listen, she flags “outdoor museum of architecture” as potentially misleading, adds “often described this way,” and explains that the phrase points to architectural diversity rather than a street frozen as a display case.',
        ),
        _DepthDetail(
          fromLevel: 10,
          chinese:
              '周玥终于明白，编辑不是把复杂城市压成最顺口的句子，而是在有限时间里决定哪些事实绝不能丢。红笔校样上的修改痕迹成为她的记忆锚点，也让她第一次以自己的名字承担导览内容。',
          pinyin:
              'Zhōu Yuè zhōngyú míngbai, biānjí bú shì bǎ fùzá chéngshì yā chéng zuì shùnkǒu de jùzi, ér shì zài yǒuxiàn shíjiān lǐ juédìng nǎxiē shìshí jué bùnéng diū. Hóngbǐ jiàoyàng shàng de xiūgǎi hénjì chéngwéi tā de jìyì máodiǎn, yě ràng tā dì yí cì yǐ zìjǐ de míngzi chéngdān dǎolǎn nèiróng.',
          vietnamese:
              'Chu Nguyệt cuối cùng hiểu rằng biên tập không phải ép một thành phố phức tạp thành câu dễ nghe nhất, mà là quyết định trong thời lượng hữu hạn những sự thật nào tuyệt đối không được mất. Dấu sửa trên bản hiệu đính bút đỏ trở thành mỏ neo ký ức và lần đầu tiên cô chịu trách nhiệm cho nội dung hướng dẫn dưới tên mình.',
          english:
              'Zhou Yue finally understands that editing is not compressing a complex city into the smoothest sentence, but deciding which facts cannot be lost within limited time. The red-pencil corrections become her memory anchor and mark the first guide she carries under her own name.',
        ),
      ],
    ),
  ],
);

const _languageLevelAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent buildBatchOneGoldLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (!isBatchOneGoldJourney(experience.id)) {
    throw ArgumentError.value(experience.id, 'experience.id');
  }

  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final blueprint = experience.id == 'beijing-forbidden-city'
      ? _forbiddenCityBlueprint
      : _shanghaiBundBlueprint;
  final story = _buildStory(blueprint, level);
  final base = buildAdaptiveLevelForJourney(
    experience,
    profile: profile,
    knownWords: knownWords,
  );
  final context = <String>[
    ...story.paragraphs,
    ...base.discoveries.map((item) => item.text),
  ].join();
  final words = _selectWords(
    experience.words,
    context: context,
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: story.paragraphs,
    storyAnnotations: story.annotations,
    words: words,
    discoveries: base.discoveries,
    wonderQuestion: _unusedUnderstandingPrompt(experience.id, level),
    expressQuestion: _unusedExpressionPrompt(experience.id, level),
  );
}

_BuiltStory _buildStory(_StoryBlueprint blueprint, int level) {
  final groups = level <= 2
      ? <List<_StoryEvent>>[
          <_StoryEvent>[...blueprint.opening, ...blueprint.closing],
        ]
      : <List<_StoryEvent>>[
          blueprint.opening,
          blueprint.closing,
        ];

  return _BuiltStory(
    paragraphs: groups
        .map((events) => events.map((event) => event.chineseAt(level)).join())
        .toList(growable: false),
    annotations: groups
        .map(
          (events) => ReadingAnnotation(
            pinyin: events.map((event) => event.pinyinAt(level)).join(' '),
            vietnamese:
                events.map((event) => event.vietnameseAt(level)).join(' '),
            english: events.map((event) => event.englishAt(level)).join(' '),
          ),
        )
        .toList(growable: false),
  );
}

List<WordEntry> _selectWords(
  List<WordEntry> source, {
  required String context,
  required ChineseProficiencyProfile profile,
  required Set<String> knownWords,
}) {
  final plan = _languageLevelAgent.planFor(profile);
  final contextual = source
      .where((entry) => context.contains(entry.word))
      .toList(growable: false);
  final unseen = contextual
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final pool = unseen.isNotEmpty ? unseen : contextual;
  final target = plan.targetVocabularyCount
      .clamp(1, plan.maximumVocabularyCount)
      .toInt();
  return pool.take(target).toList(growable: false);
}

String _unusedUnderstandingPrompt(String journeyId, int level) {
  return switch (journeyId) {
    'beijing-forbidden-city' => level <= 3
        ? '梁砚为什么没有直接上报新旧数据的差异？'
        : '梁砚的两次选择怎样把“独立”从速度改成了可追溯的责任？',
    'shanghai-bund' => level <= 3
        ? '周玥为什么不能继续说“外滩历史建筑都是银行”？'
        : '周玥怎样在九十秒限制里保住外滩的复杂性与事实准确性？',
    _ => '',
  };
}

String _unusedExpressionPrompt(String journeyId, int level) {
  return switch (journeyId) {
    'beijing-forbidden-city' => level <= 3
        ? '请按顺序说明数据冲突、返回核对、复核单和最终结果。'
        : '请说明测量基准、修缮记录与“不确定性”为什么会改变梁砚的专业判断。',
    'shanghai-bund' => level <= 3
        ? '请按顺序说明错误稿件、重新核对、错过上传和最终改稿。'
        : '请说明外滩的建筑多样性、金融贸易历史与黄浦江两岸视野怎样共同改变周玥的编辑选择。',
    _ => '',
  };
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
