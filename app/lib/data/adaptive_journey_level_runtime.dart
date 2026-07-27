import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import 'all_journey_language_level_catalog.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'summer_palace_language_level_catalog.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent resolveAdaptiveJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (experience.id != 'beijing-summer-palace') {
    return buildAdaptiveLevelForJourney(
      experience,
      profile: profile,
      knownWords: knownWords,
    );
  }

  final base = switch (profile.band) {
    PhoenixReadingBand.beginner => summerPalaceBeginnerLevel,
    PhoenixReadingBand.elementary => summerPalaceElementaryLevel,
    PhoenixReadingBand.intermediate => summerPalaceIntermediateLevel,
    PhoenixReadingBand.upperIntermediate => JourneyLevelContent.fromExperience(
        experience,
      ),
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      JourneyLevelContent(
        storyParagraphs: experience.content.storyParagraphs,
        storyAnnotations: experience.storyAnnotations,
        words: experience.words,
        discoveries: experience.discoveries,
        wonderQuestion: summerPalaceChallengeLevel.wonderQuestion,
        expressQuestion: summerPalaceChallengeLevel.expressQuestion,
      ),
  };

  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: summerPalaceAdaptiveWords,
    levelCatalog: summerPalaceVocabularyLevels,
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: selectedWords,
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

const summerPalaceBeginnerLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '清晨，你来到颐和园。昆明湖很安静，万寿山倒映在水里。你沿着长廊慢慢走，看见树、桥和古老的建筑。',
    '颐和园以前是皇家园林。它受过破坏，也经过修复。十七孔桥连接湖岸和小岛，湖、山、桥组成一幅美丽的画。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Qīngchén, nǐ láidào Yíhéyuán. Kūnmíng Hú hěn ānjìng, Wànshòu Shān dàoyìng zài shuǐ lǐ. Nǐ yánzhe Chángláng mànman zǒu, kànjiàn shù, qiáo hé gǔlǎo de jiànzhù.',
      vietnamese:
          'Sáng sớm, bạn đến Di Hòa Viên. Hồ Côn Minh rất yên tĩnh, núi Vạn Thọ phản chiếu trên mặt nước. Bạn chậm rãi đi dọc Trường Lang và nhìn thấy cây, cầu cùng các công trình cổ.',
      english:
          'In the early morning, you arrive at the Summer Palace. Kunming Lake is quiet and Longevity Hill is reflected in the water. You walk slowly along the Long Corridor and see trees, bridges, and old buildings.',
    ),
    ReadingAnnotation(
      pinyin:
          'Yíhéyuán yǐqián shì huángjiā yuánlín. Tā shòuguò pòhuài, yě jīngguò xiūfù. Shíqīkǒng Qiáo liánjiē hú àn hé xiǎodǎo, hú, shān hé qiáo zǔchéng yì fú měilì de huà.',
      vietnamese:
          'Di Hòa Viên trước đây là vườn hoàng gia. Nơi này từng bị hư hại và đã được phục hồi. Cầu Thập Thất Khổng nối bờ hồ với đảo nhỏ, tạo nên bức tranh gồm hồ, núi và cầu.',
      english:
          'The Summer Palace was once an imperial garden. It was damaged and later restored. The Seventeen-Arch Bridge connects the shore and an island, forming a picture of lake, hill, and bridge.',
    ),
  ],
  words: <WordEntry>[],
  discoveries: <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园在北京，昆明湖和万寿山是这里最重要的景色。园里大部分面积是水，所以湖面一直出现在人的视线中。',
      pinyin:
          'Yíhéyuán zài Běijīng, Kūnmíng Hú hé Wànshòu Shān shì zhèlǐ zuì zhòngyào de jǐngsè. Yuán lǐ dà bùfen miànjī shì shuǐ, suǒyǐ húmiàn yìzhí chūxiàn zài rén de shìxiàn zhōng.',
      simpleChinese: '颐和园主要有湖和山，园里大部分面积是水。',
      vietnamese:
          'Di Hòa Viên nằm ở Bắc Kinh. Hồ Côn Minh và núi Vạn Thọ là hai cảnh quan chính, và phần lớn khu vườn là mặt nước.',
      english:
          'The Summer Palace is in Beijing. Kunming Lake and Longevity Hill are its main sights, and most of the garden is water.',
    ),
    DiscoveryEntry(
      text: '十七孔桥有十七个桥孔，连接湖岸和小岛。它不只是让人通过，也让湖面和远山看起来更完整。',
      pinyin:
          'Shíqīkǒng Qiáo yǒu shíqī gè qiáokǒng, liánjiē hú àn hé xiǎodǎo. Tā bù zhǐ shì ràng rén tōngguò, yě ràng húmiàn hé yuǎnshān kàn qǐlái gèng wánzhěng.',
      simpleChinese: '十七孔桥连接两地，也让风景更完整。',
      vietnamese:
          'Cầu Thập Thất Khổng có mười bảy vòm và nối bờ hồ với đảo. Cây cầu vừa là lối đi vừa làm cảnh quan trở nên hoàn chỉnh hơn.',
      english:
          'The Seventeen-Arch Bridge has seventeen arches and connects the shore with an island. It is both a route and part of the view.',
    ),
  ],
  wonderQuestion: '你最想先看昆明湖、万寿山，还是十七孔桥？为什么？',
  expressQuestion: '请用一到两句话介绍你看到的颐和园。',
);

const summerPalaceElementaryLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '清晨，你沿着昆明湖慢慢前行。水面很安静，万寿山和佛香阁从薄雾里出现。走进长廊以后，你会发现景色一直在变化：有时湖面出现在柱子之间，有时树木挡住远山，有时屋顶又把视线带回近处。',
    '颐和园以前是皇家园林，后来受到破坏并经过重建和修复。园中大约四分之三的面积是水，昆明湖把天空、桥梁和建筑放进倒影里。十七孔桥连接湖岸与小岛，也让远山、湖面和建筑组成完整的风景。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Qīngchén, nǐ yánzhe Kūnmíng Hú mànman qiánxíng. Shuǐmiàn hěn ānjìng, Wànshòu Shān hé Fóxiāng Gé cóng báowù lǐ chūxiàn. Zǒujìn Chángláng yǐhòu, nǐ huì fāxiàn jǐngsè yìzhí zài biànhuà.',
      vietnamese:
          'Sáng sớm, bạn chậm rãi đi dọc hồ Côn Minh. Mặt nước yên tĩnh, núi Vạn Thọ và Phật Hương Các hiện ra trong sương. Khi bước vào Trường Lang, bạn nhận ra cảnh vật liên tục thay đổi.',
      english:
          'In the early morning, you walk slowly beside Kunming Lake. Longevity Hill and the Tower of Buddhist Incense emerge from the mist, and the view keeps changing inside the Long Corridor.',
    ),
    ReadingAnnotation(
      pinyin:
          'Yíhéyuán yǐqián shì huángjiā yuánlín, hòulái shòudào pòhuài bìng jīngguò chóngjiàn hé xiūfù. Yuán zhōng dàyuē sì fēn zhī sān de miànjī shì shuǐ. Shíqīkǒng Qiáo ràng yuǎnshān, húmiàn hé jiànzhù zǔchéng wánzhěng de fēngjǐng.',
      vietnamese:
          'Di Hòa Viên từng là vườn hoàng gia, sau đó bị hư hại rồi được xây dựng và phục hồi. Khoảng ba phần tư diện tích là mặt nước. Cầu Thập Thất Khổng giúp núi xa, mặt hồ và kiến trúc tạo thành một cảnh quan hoàn chỉnh.',
      english:
          'The Summer Palace was an imperial garden that was damaged and later rebuilt. Water covers roughly three quarters of the site, and the Seventeen-Arch Bridge joins the lake, distant hills, and architecture into one view.',
    ),
  ],
  words: <WordEntry>[],
  discoveries: <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园先用万寿山和昆明湖安排整体空间，再把长廊、亭台、桥梁和岛屿放进风景里。人在园中行走时，视线会随着位置变化。',
      pinyin:
          'Yíhéyuán xiān yòng Wànshòu Shān hé Kūnmíng Hú ānpái zhěngtǐ kōngjiān, zài bǎ Chángláng, tíngtái, qiáoliáng hé dǎoyǔ fàng jìn fēngjǐng lǐ.',
      simpleChinese: '颐和园用山和湖安排空间，再加入建筑和桥。',
      vietnamese:
          'Di Hòa Viên dùng núi Vạn Thọ và hồ Côn Minh để tổ chức không gian, sau đó đưa hành lang, đình đài, cầu và đảo vào cảnh quan.',
      english:
          'The garden uses Longevity Hill and Kunming Lake to organize the space, then places corridors, pavilions, bridges, and islands within it.',
    ),
    DiscoveryEntry(
      text: '十七孔桥既是一条通道，也是风景的一部分。阳光穿过桥孔时，石桥、水面和倒影会形成特别的光影。',
      pinyin:
          'Shíqīkǒng Qiáo jì shì yì tiáo tōngdào, yě shì fēngjǐng de yí bùfen. Yángguāng chuānguò qiáokǒng shí, shíqiáo, shuǐmiàn hé dàoyǐng huì xíngchéng tèbié de guāngyǐng.',
      simpleChinese: '桥可以通行，也会和阳光、水面组成风景。',
      vietnamese:
          'Cầu Thập Thất Khổng vừa là lối đi vừa là một phần của phong cảnh. Ánh nắng xuyên qua các vòm tạo nên ánh sáng và phản chiếu đặc biệt.',
      english:
          'The bridge is both a route and part of the scenery. Sunlight passing through its arches creates distinctive light and reflections.',
    ),
  ],
  wonderQuestion: '为什么人在长廊里走动时，会看到不断变化的风景？',
  expressQuestion: '请用两句话说明昆明湖为什么重要。',
);

const summerPalaceIntermediateLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '清晨，你沿着昆明湖岸前行，万寿山与佛香阁从薄雾中慢慢显出轮廓。远处亭台看起来像自然长在山水之间，但随着脚步移动，树木、桥梁、屋顶和廊柱会不断改变视线。走进长廊，湖光从柱子之间闪过，彩画和屋檐让一次普通散步变成缓慢展开的观看。同一座山会因为角度不同而显得更近、更高或更安静，人在行走中也逐渐理解园林怎样组织风景。',
    '颐和园最早建成于一七五〇年，后来受到严重破坏，并在一八八六年按照原有基础重建。园中大约四分之三的面积是水，昆明湖不是建筑旁边的空白，而是把天空、桥梁、岛屿和屋顶收入倒影的重要空间。十七孔桥连接湖岸与小岛，也把近处石栏、开阔水面和远处万寿山组成有层次的画面。所谓借景，就是利用方向、距离和路线，把园外与园内的景色放进同一个视野。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Qīngchén, nǐ yánzhe Kūnmíng Hú àn qiánxíng, Wànshòu Shān yǔ Fóxiāng Gé cóng báowù zhōng mànman xiǎnchū lúnkuò. Suízhe jiǎobù yídòng, shùmù, qiáoliáng, wūdǐng hé lángzhù huì bùduàn gǎibiàn shìxiàn.',
      vietnamese:
          'Buổi sớm, bạn đi dọc bờ hồ Côn Minh, núi Vạn Thọ và Phật Hương Các dần hiện ra trong sương. Khi bước chân thay đổi, cây, cầu, mái nhà và cột hành lang liên tục điều chỉnh tầm nhìn.',
      english:
          'At dawn, you walk beside Kunming Lake as Longevity Hill and the Tower of Buddhist Incense emerge from the mist. Trees, bridges, roofs, and columns keep reshaping the view as you move.',
    ),
    ReadingAnnotation(
      pinyin:
          'Yíhéyuán zuìzǎo jiànchéng yú yī qī wǔ líng nián, hòulái shòudào yánzhòng pòhuài, bìng zài yī bā bā liù nián ànzhào yuányǒu jīchǔ chóngjiàn. Suǒwèi jièjǐng, jiù shì lìyòng fāngxiàng, jùlí hé lùxiàn, bǎ yuánwài yǔ yuánnèi de jǐngsè fàng jìn tóng yí gè shìyě.',
      vietnamese:
          'Di Hòa Viên được xây dựng lần đầu năm 1750, bị hư hại nặng và được tái thiết trên nền cũ vào năm 1886. “Mượn cảnh” là dùng phương hướng, khoảng cách và lộ trình để đưa cảnh ngoài và trong vườn vào cùng một tầm nhìn.',
      english:
          'The Summer Palace was first completed in 1750, badly damaged, and rebuilt on its earlier foundations in 1886. Borrowed scenery uses direction, distance, and routes to place views inside and outside the garden within one frame.',
    ),
  ],
  words: <WordEntry>[],
  discoveries: <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园不是把建筑独立摆放，而是以万寿山和昆明湖为骨架，再让长廊、亭台、桥梁和岛屿进入同一套空间秩序。湖面扩大了视觉距离，也用倒影改变建筑在不同时间的气氛。',
      pinyin:
          'Yíhéyuán bú shì bǎ jiànzhù dúlì bǎifàng, ér shì yǐ Wànshòu Shān hé Kūnmíng Hú wéi gǔjià, zài ràng Chángláng, tíngtái, qiáoliáng hé dǎoyǔ jìnrù tóng yí tào kōngjiān zhìxù.',
      simpleChinese: '颐和园先安排山和湖，再让建筑进入整体风景。',
      vietnamese:
          'Di Hòa Viên không đặt từng công trình riêng lẻ mà dùng núi Vạn Thọ và hồ Côn Minh làm khung, rồi đưa hành lang, đình đài, cầu và đảo vào cùng một trật tự không gian.',
      english:
          'The garden does not isolate its buildings. It uses Longevity Hill and Kunming Lake as a framework, then brings corridors, pavilions, bridges, and islands into one spatial order.',
    ),
    DiscoveryEntry(
      text: '十七孔桥既连接湖岸与南湖岛，也在构图上形成一条水平线。它把近处石栏、宽阔水面和远处山景分成前后层次，因此实用功能和观景功能同时存在。',
      pinyin:
          'Shíqīkǒng Qiáo jì liánjiē hú àn yǔ Nánhú Dǎo, yě zài gòutú shàng xíngchéng yì tiáo shuǐpíngxiàn. Tā bǎ jìnchù shílán, kuānkuò shuǐmiàn hé yuǎnchù shānjǐng fēnchéng qiánhòu céngcì.',
      simpleChinese: '桥既能通行，也能让湖、山和建筑形成层次。',
      vietnamese:
          'Cầu Thập Thất Khổng vừa nối bờ hồ với đảo Nam Hồ vừa tạo một đường ngang trong bố cục, chia lan can gần, mặt nước rộng và núi xa thành nhiều lớp.',
      english:
          'The bridge connects the shore and Nanhu Island while forming a horizontal line that layers nearby railings, open water, and distant hills.',
    ),
  ],
  wonderQuestion: '你认为颐和园的风景更依靠自然，还是更依靠人的设计？为什么？',
  expressQuestion: '请用三句话说明长廊或十七孔桥怎样改变人的视线。',
);
