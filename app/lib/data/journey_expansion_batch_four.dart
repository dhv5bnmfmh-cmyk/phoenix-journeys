import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchFourSources = <StorySourceRecord>[
  StorySourceRecord(id: 'unesco-pingyao', title: 'Ancient City of Ping Yao', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/812', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'shanxi-pingyao', title: '平遥古城：2800岁正青春', publisher: '山西省文化和旅游厅', url: 'https://wlt.shanxi.gov.cn/xwzx/wlxx/202305/t20230517_8565714.shtml', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-qufu', title: 'Temple and Cemetery of Confucius and the Kong Family Mansion in Qufu', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/704', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shandong-jining-qufu-confucius-temple'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'shandong-qufu', title: '活起来的文化遗产，火起来的旅游市场', publisher: '山东省文化和旅游厅', url: 'https://whhly.shandong.gov.cn/art/2023/4/21/art_68375_10320513.html', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shandong-jining-qufu-confucius-temple'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-leshan', title: 'Mount Emei Scenic Area, including Leshan Giant Buddha Scenic Area', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/779', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-sichuan-leshan-shizhong-giant-buddha'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'leshan-government-buddha', title: '乐山大佛千年石刻该如何保护', publisher: '乐山市人民政府', url: 'https://www.leshan.gov.cn/lsswszf/bmdt/92337825/cc6fc9bf3b254248ac70abcd0f0f748c.html', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-sichuan-leshan-shizhong-giant-buddha'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-wuyishan', title: 'Mount Wuyi', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/911', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-fujian-nanping-wuyishan-nine-bend-stream'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'fujian-wuyishan', title: '福建日报：一溪贯群山', publisher: '福建省水利厅', url: 'https://slt.fujian.gov.cn/wzsy/mtjj/202501/t20250106_6608039.htm', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-fujian-nanping-wuyishan-nine-bend-stream'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-honghe', title: 'Cultural Landscape of Honghe Hani Rice Terraces', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/1111', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-yunnan-honghe-yuanyang-hani-terraces'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'yunnan-honghe', title: '千年古梯田焕发新生机', publisher: '云南省农业农村厅', url: 'https://nync.yn.gov.cn/html/2021/yunnongkuanxun-new_0129/376446.html?cid=3016', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-yunnan-honghe-yuanyang-hani-terraces'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
];

JourneyContentRecord _record(String id, String title, String geo, List<String> paragraphs, List<String> sources, List<String> tags) => JourneyContentRecord(
  id: id, title: title, geoNodeId: geo, languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published, tags: tags,
  sections: List.generate(paragraphs.length, (i) => JourneyStorySection(id: 'story-$i', text: paragraphs[i], sourceIds: sources)),
);

const _pingyaoP = <String>[
  '平遥雨季将至，社区会计赵禾发现巷口排水沟被新摊位挡住。摊主是刚回乡的表弟，指望在票号旧街卖点心还债；她若上报，摊位当天就得拆。',
  '赵禾带着旧汇兑账册穿过灰砖街巷核对门牌，才看清城墙、院落、店铺与排水并非各自孤立。消防员又提醒，木构密集的巷子不能留下任何堵点。',
  '她没有替表弟隐瞒，也没有只贴一张整改单，而是请邻里把摊位移进闲置院落，以一笔真实的票号汇兑故事设计菜单。雨落下时，水顺利穿过原来的沟口。',
  '表弟少了街面客流，却有了长久屋檐。赵禾在账册末页补上衙署、金融与古城格局：活态修缮不是赶走居民，而是让生活服从共同安全后继续发生。',
];
const _pingyaoA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'píng yáo yǔ jì jiāng zhì ， shè qū kuài jì zhào hé fā xiàn xiàng kǒu pái shuǐ gōu bèi xīn tān wèi dǎng zhù 。 tān zhǔ shì gāng huí xiāng de biǎo dì ， zhǐ wàng zài piào hào jiù jiē mài diǎn xīn huán zhài ； tā ruò shàng bào ， tān wèi dāng tiān jiù dé chāi 。', vietnamese: 'Trước mùa mưa ở Bình Dao, kế toán cộng đồng Triệu Hòa phát hiện quầy mới chặn rãnh thoát nước. Chủ quầy là em họ mới về quê bán bánh ở phố phiếu hiệu để trả nợ; nếu báo, quầy phải tháo ngay.', english: 'Before Pingyao\'s rainy season, community accountant Zhao He finds a new stall blocking a drain. The owner is her cousin, recently returned to sell pastries on the draft-bank street and repay debts; reporting it means immediate removal.'),
  ReadingAnnotation(pinyin: 'zhào hé dài zhe jiù huì duì zhàng cè chuān guò huī zhuān jiē xiàng hé duì mén pái ， cái kàn qīng chéng qiáng 、 yuàn luò 、 diàn pù yǔ pái shuǐ bìng fēi gè zì gū lì 。 xiāo fáng yuán yòu tí xǐng ， mù gòu mì jí de xiàng zi bù néng liú xià rèn hé dǔ diǎn 。', vietnamese: 'Triệu Hòa cầm sổ chuyển tiền cũ đi qua ngõ gạch xám kiểm số nhà và nhận ra tường thành, sân, cửa hiệu cùng thoát nước không tách rời. Lính cứu hỏa nhắc rằng ngõ nhà gỗ dày đặc không thể có điểm nghẽn.', english: 'Zhao He checks addresses through grey-brick lanes with an old remittance ledger and sees that walls, courtyards, shops, and drainage form one system. A firefighter warns that dense timber lanes cannot tolerate a blockage.'),
  ReadingAnnotation(pinyin: 'tā méi yǒu tì biǎo dì yǐn mán ， yě méi yǒu zhī tiē yì zhāng zhěng gǎi dān ， ér shì qǐng lín lǐ bǎ tān wèi yí jìn xián zhì yuàn luò ， yǐ yì bǐ zhēn shí de piào hào huì duì gù shì shè jì cài dān 。 yǔ luò xià shí ， shuǐ shùn lì chuān guò yuán lái de gōu kǒu 。', vietnamese: 'Cô không che giấu cho em cũng không chỉ dán lệnh sửa, mà nhờ hàng xóm chuyển quầy vào sân trống và dùng câu chuyện chuyển tiền thật của phiếu hiệu làm thực đơn. Khi mưa xuống, nước chảy qua miệng rãnh cũ.', english: 'She neither hides the problem nor simply posts an order. Neighbors move the stall into an unused courtyard and build its menu around a real draft-bank remittance story. When rain falls, water passes through the old drain.'),
  ReadingAnnotation(pinyin: 'biǎo dì shǎo le jiē miàn kè liú ， què yǒu le cháng jiǔ wū yán 。 zhào hé zài zhàng cè mò yè bǔ shàng yá shǔ 、 jīn róng yǔ gǔ chéng gé jú ： huó tài xiū shàn bú shì gǎn zǒu jū mín ， ér shì ràng shēng huó fú cóng gòng tóng ān quán hòu jì xù fā shēng 。', vietnamese: 'Em họ mất khách mặt phố nhưng lần đầu có mái che bền vững. Triệu Hòa ghi thêm nha môn, tài chính và bố cục thành cổ: bảo tồn sống không đuổi cư dân đi mà cho đời sống tiếp tục sau khi tuân thủ an toàn chung.', english: 'Her cousin loses street traffic but gains a lasting roof. Zhao He adds offices, finance, and urban layout to the ledger: living conservation does not expel residents; it lets life continue after shared safety comes first.'),
];
const _pingyaoW = <WordEntry>[
  WordEntry(word:'城墙',pinyin:'chéngqiáng',partOfSpeech:'名词',simpleChinese:'围绕古城的高墙。',translation:'Tường bao quanh thành cổ.',englishDefinition:'city wall',symbol:'🧱'),
  WordEntry(word:'街巷',pinyin:'jiēxiàng',partOfSpeech:'名词',simpleChinese:'街道和小巷。',translation:'Đường và ngõ.',englishDefinition:'streets and lanes',symbol:'🏘️'),
  WordEntry(word:'格局',pinyin:'géjú',partOfSpeech:'名词',simpleChinese:'整体结构和安排。',translation:'Bố cục tổng thể.',englishDefinition:'urban layout',symbol:'▦'),
  WordEntry(word:'衙署',pinyin:'yáshǔ',partOfSpeech:'名词',simpleChinese:'古代官员办公处。',translation:'Nha môn cổ.',englishDefinition:'historic government office',symbol:'🏛️'),
  WordEntry(word:'院落',pinyin:'yuànluò',partOfSpeech:'名词',simpleChinese:'房屋围成的院子。',translation:'Sân nhà truyền thống.',englishDefinition:'courtyard compound',symbol:'🏡'),
  WordEntry(word:'金融',pinyin:'jīnróng',partOfSpeech:'名词',simpleChinese:'资金流通活动。',translation:'Hoạt động tài chính.',englishDefinition:'finance',symbol:'💰'),
  WordEntry(word:'票号',pinyin:'piàohào',partOfSpeech:'名词',simpleChinese:'旧时经营汇兑的商号。',translation:'Hiệu ngân phiếu cổ.',englishDefinition:'draft bank',symbol:'📜'),
  WordEntry(word:'汇兑',pinyin:'huìduì',partOfSpeech:'名词',simpleChinese:'把钱转到异地。',translation:'Chuyển tiền liên vùng.',englishDefinition:'remittance exchange',symbol:'🔁'),
  WordEntry(word:'修缮',pinyin:'xiūshàn',partOfSpeech:'动词',simpleChinese:'修理并保护旧建筑。',translation:'Tu bổ công trình cũ.',englishDefinition:'to conserve',symbol:'🧰'),
];
const _pingyaoD = <DiscoveryEntry>[
  DiscoveryEntry(text:'平遥古城完整保存城墙、街巷、店铺、民居与寺庙组成的县城格局。',pinyin:'Píngyáo Gǔchéng wánzhěng bǎocún xiànchéng géjú.',simpleChinese:'古城的整体结构保存完整。',vietnamese:'Bố cục huyện thành được bảo tồn hoàn chỉnh.',english:'The county-town layout survives as an integrated whole.'),
  DiscoveryEntry(text:'古城与双林寺、镇国寺共同构成世界遗产。',pinyin:'Gǔchéng yǔ Shuānglín Sì, Zhènguó Sì gòngtóng gòuchéng Shìjiè Yíchǎn.',simpleChinese:'遗产包括古城和两座寺庙。',vietnamese:'Di sản gồm thành cổ và hai ngôi chùa.',english:'The property includes the city, Shuanglin Temple, and Zhenguo Temple.'),
  DiscoveryEntry(text:'票号与汇兑业务让平遥成为近代重要金融中心。',pinyin:'Piàohào yǔ huìduì yèwù ràng Píngyáo chéngwéi jīnróng zhōngxīn.',simpleChinese:'票号连接远方资金。',vietnamese:'Phiếu hiệu và chuyển tiền tạo nên trung tâm tài chính.',english:'Draft banks and remittance made Pingyao a financial hub.'),
  DiscoveryEntry(text:'活态保护同时关注居民、消防、排水与古建筑修缮。',pinyin:'Huótài bǎohù tóngshí guānzhù jūmín, xiāofáng, páishuǐ yǔ xiūshàn.',simpleChinese:'保护也要照顾日常生活。',vietnamese:'Bảo tồn sống quan tâm cư dân và hạ tầng.',english:'Living conservation includes residents and infrastructure.'),
];

const _qufuP = <String>[
  '曲阜学生孔言要在孔庙主持成年礼彩排，却发现同伴把礼辞背得一字不差，却不肯让行动不便的同学进入中轴旁唯一平缓的通道。仪式准时开始与所有人参加发生了冲突。',
  '老师说门坊、碑亭和院落有既定秩序，临时改线会打乱队伍。孔言想到孔府、孔林保存的不只是礼制，也是后裔与家族的生活，于是拒绝独自站上主位。',
  '他带全班重新丈量侧廊，把领诵改成接力：每个人在不同院落读一句，并为同学留出转身空间。彩排晚了，原本整齐的中轴画面却变成彼此等待的队伍。',
  '正式仪式那天，古柏下的孔言没有讲大道理，只在石碑的碑刻前说“礼也要看见人”。他从背诵者变成安排者，也懂得传统传播不靠动作永远不变。',
];
const _qufuA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'qū fù xué shēng kǒng yán yào zài kǒng miào zhǔ chí chéng nián lǐ cǎi pái ， què fā xiàn tóng bàn bǎ lǐ cí bèi dé yí zì bú chà ， què bù kěn ràng xíng dòng bú biàn de tóng xué jìn rù zhōng zhóu páng wéi yì píng huǎn de tōng dào 。 yí shì zhǔn shí kāi shǐ yǔ suǒ yǒu rén shēn jiā fā shēng le chōng tū 。',vietnamese:'Học sinh Khổng Ngôn ở Khúc Phụ chuẩn bị dẫn lễ trưởng thành tại Khổng Miếu, nhưng các bạn thuộc lời lễ lại không muốn nhường lối bằng phẳng duy nhất cho bạn đi lại khó khăn. Bắt đầu đúng giờ xung đột với việc để mọi người cùng tham gia.',english:'Qufu student Kong Yan is preparing to lead a coming-of-age ceremony at the Confucius Temple, but classmates who know every ritual line refuse to share the only level route with a student who has limited mobility. Starting on time conflicts with including everyone.'),
  ReadingAnnotation(pinyin:'lǎo shī shuō mén fāng 、 bēi tíng hé yuàn luò yǒu jì dìng zhì xù ， lín shí gǎi xiàn huì dǎ luàn duì wu 。 kǒng yán xiǎng dào kǒng fǔ 、 kǒng lín bǎo cún de bù zhǐ shì lǐ zhì ， yě shì hòu yì yǔ jiā zú de shēng huó ， yú shì jù jué dú zì zhàn shàng zhǔ wèi 。',vietnamese:'Giáo viên nói cổng, đình bia và sân có trật tự cố định, đổi tuyến sẽ làm rối đội hình. Nghĩ rằng Khổng Phủ và Khổng Lâm lưu cả lễ chế lẫn đời sống gia đình, Khổng Ngôn từ chối đứng một mình ở vị trí chính.',english:'The teacher says the gateways, stele pavilions, and courtyards follow an established order. Remembering that the Kong Mansion and Cemetery preserve family life as well as ritual, Kong Yan refuses to stand alone in the leading position.'),
  ReadingAnnotation(pinyin:'tā dài quán bān chóng xīn zhàng liáng cè láng ， bǎ lǐng sòng gǎi chéng jiē lì ： měi gè rén zài bù tóng yuàn luò dú yí jù ， bìng wèi tóng xué liú chū zhuǎn shēn kōng jiān 。 cǎi pái wǎn le ， yuán běn zhěng qí de zhōng zhóu huà miàn què biàn chéng bǐ cǐ děng dài de duì wu 。',vietnamese:'Cậu cùng lớp đo lại hành lang bên, biến phần lĩnh xướng thành tiếp sức và chừa chỗ quay xe. Buổi tập bị muộn, nhưng đội hình thẳng tắp trở thành một đoàn người biết chờ nhau.',english:'He helps the class measure the side corridor, turns the recitation into a relay, and leaves turning space. Rehearsal runs late, but the formerly rigid line becomes a group that waits for one another.'),
  ReadingAnnotation(pinyin:'zhèng shì yí shì nà tiān ， gǔ bǎi xià de kǒng yán méi yǒu jiǎng dà dào lǐ ， zhī zài shí bēi de bēi kè qián shuō “ lǐ yě yào kàn jiàn rén ”。 tā cóng bèi sòng zhě biàn chéng ān pái zhě ， yě dǒng de chuán tǒng chuán bō bú kào dòng zuò yǒng yuǎn bú biàn 。',vietnamese:'Ngày chính lễ, dưới cây bách cổ, Khổng Ngôn chỉ nói trước bia đá rằng ‘lễ cũng phải nhìn thấy con người’. Cậu chuyển từ người đọc thuộc sang người biết sắp xếp, hiểu rằng truyền thống không sống nhờ động tác bất biến.',english:'On the ceremony day beneath ancient cypresses, Kong Yan says only, ‘Ritual must also see people.’ He changes from a reciter into an organizer and learns that tradition does not endure through unchanging motions.'),
];
const _qufuW = <WordEntry>[
  WordEntry(word:'中轴',pinyin:'zhōngzhóu',partOfSpeech:'名词',simpleChinese:'建筑群中央的主要线。',translation:'Trục chính giữa.',englishDefinition:'central axis',symbol:'↕️'),
  WordEntry(word:'古柏',pinyin:'gǔbǎi',partOfSpeech:'名词',simpleChinese:'年代久远的柏树。',translation:'Cây bách cổ.',englishDefinition:'ancient cypress',symbol:'🌲'),
  WordEntry(word:'门坊',pinyin:'ménfāng',partOfSpeech:'名词',simpleChinese:'入口处的门和牌坊。',translation:'Cổng và phường môn.',englishDefinition:'ceremonial gateway',symbol:'⛩️'),
  WordEntry(word:'碑亭',pinyin:'bēitíng',partOfSpeech:'名词',simpleChinese:'保护石碑的亭子。',translation:'Đình che bia.',englishDefinition:'stele pavilion',symbol:'🪨'),
  WordEntry(word:'石碑',pinyin:'shíbēi',partOfSpeech:'名词',simpleChinese:'刻有文字的石头。',translation:'Bia đá.',englishDefinition:'stone stele',symbol:'📜'),
  WordEntry(word:'后裔',pinyin:'hòuyì',partOfSpeech:'名词',simpleChinese:'一个人的后代。',translation:'Hậu duệ.',englishDefinition:'descendant',symbol:'🌿'),
  WordEntry(word:'礼制',pinyin:'lǐzhì',partOfSpeech:'名词',simpleChinese:'传统礼仪制度。',translation:'Chế độ lễ nghi.',englishDefinition:'ritual system',symbol:'🎓'),
  WordEntry(word:'碑刻',pinyin:'bēikè',partOfSpeech:'名词',simpleChinese:'石碑上的刻字。',translation:'Văn khắc trên bia.',englishDefinition:'stele inscription',symbol:'✒️'),
  WordEntry(word:'传播',pinyin:'chuánbō',partOfSpeech:'动词',simpleChinese:'向更多地方传开。',translation:'Truyền bá.',englishDefinition:'to transmit',symbol:'📖'),
];
const _qufuD = <DiscoveryEntry>[
  DiscoveryEntry(text:'孔庙为纪念孔子而建，始建于公元前四百七十八年。',pinyin:'Kǒngmiào shǐjiàn yú gōngyuánqián sìbǎi qīshíbā nián.',simpleChinese:'孔庙历史超过两千年。',vietnamese:'Khổng Miếu bắt đầu năm 478 TCN.',english:'The temple was founded in 478 BCE.'),
  DiscoveryEntry(text:'孔庙保存一百多座建筑、一千多通石碑和大量古柏。',pinyin:'Kǒngmiào bǎocún yìbǎi duō zuò jiànzhù hé yìqiān duō tōng shíbēi.',simpleChinese:'建筑、石碑和古树都很丰富。',vietnamese:'Di tích lưu hơn trăm công trình và hơn nghìn bia.',english:'It preserves over a hundred buildings and more than a thousand stelae.'),
  DiscoveryEntry(text:'孔府记录孔子后裔的生活，孔林保存家族墓地。',pinyin:'Kǒngfǔ jìlù Kǒngzǐ hòuyì de shēnghuó, Kǒnglín bǎocún jiāzú mùdì.',simpleChinese:'孔府和孔林保存家族记忆。',vietnamese:'Khổng Phủ và Khổng Lâm lưu ký ức gia tộc.',english:'The mansion and cemetery preserve family history.'),
  DiscoveryEntry(text:'三孔的中轴、礼制空间与碑刻共同传播儒家文化。',pinyin:'Sānkǒng de zhōngzhóu, lǐzhì kōngjiān yǔ bēikè gòngtóng chuánbō Rújiā wénhuà.',simpleChinese:'建筑也是思想的载体。',vietnamese:'Kiến trúc và bia khắc truyền văn hóa Nho gia.',english:'Architecture and inscriptions transmit Confucian culture.'),
];

const _leshanP = <String>[
  '青年船工何川在三江交汇处练习掌舵，父亲却因病把第一次夜航交给了他。水位上涨，游客催着靠近崖壁看乐山大佛，何川必须证明自己，却发现航线已偏向急流。',
  '七十一米坐像从红砂岩间显现时，他想起父亲教的不是贴得越近越好，而是读懂岷江、青衣江和大渡河相遇后的水纹。靠近能赢得掌声，转向则会错过最佳位置。',
  '何川选择提前掉头，让船在安全水域停稳，并用发髻与衣纹里隐藏的排水沟解释工匠怎样让石刻抵抗侵蚀。抱怨声渐渐停下，一场急雨正好越过崖壁。',
  '返航后，父亲问他有没有让人平安回岸。何川想到八世纪开凿的石像仍受风化，明白勇敢不是逼近风险，而是在三江催促时仍肯改变方向。',
];
const _leshanA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'qīng nián chuán gōng hé chuān zài sān jiāng jiāo huì chù liàn xí zhǎng duò ， fù qīn què yīn bìng bǎ dì yí cì yè háng jiāo gěi le tā 。 shuǐ wèi shàng zhǎng ， yóu kè cuī zhe kào jìn yá bì kàn lè shān dà fó ， hé chuān bì xū zhèng míng zì jǐ ， què fā xiàn háng xiàn yǐ piān xiàng jí liú 。',vietnamese:'Thủy thủ trẻ Hà Xuyên lần đầu tự cầm lái ở nơi ba sông gặp nhau vì cha bị ốm. Nước lên, du khách thúc tàu đến gần vách để ngắm Đại Phật; muốn chứng tỏ mình, cậu lại thấy tuyến tàu lệch về dòng xiết.',english:'Young boatman He Chuan takes the helm alone for the first time at the three-river confluence because his father is ill. As water rises, passengers demand a closer Buddha view, but the route is drifting toward the current.'),
  ReadingAnnotation(pinyin:'qī shí yī mǐ zuò xiàng cóng hóng shā yán jiān xiǎn xiàn shí ， tā xiǎng qǐ fù qīn jiào de bú shì tiē dé yuè jìn yuè hǎo ， ér shì dú dǒng mín jiāng 、 qīng yī jiāng hé dà dù hé xiāng yù hòu de shuǐ wén 。 kào jìn néng yíng dé zhǎng shēng ， zhuǎn xiàng zé huì cuò guò zuì jiā wèi zhì 。',vietnamese:'Khi tượng ngồi 71 mét hiện ra trong sa thạch đỏ, cậu nhớ cha dạy đọc đường nước nơi Mân Giang, Thanh Y Giang và Đại Độ Hà gặp nhau, không phải áp sát. Đến gần được vỗ tay; đổi hướng sẽ mất vị trí đẹp.',english:'As the seventy-one-metre seated figure appears in red sandstone, he recalls that his father taught him to read the currents where the Min, Qingyi, and Dadu rivers meet—not to get as close as possible. Nearness wins applause; turning loses the view.'),
  ReadingAnnotation(pinyin:'hé chuān xuǎn zé tí qián diào tóu ， ràng chuán zài ān quán shuǐ yù tíng wěn ， bìng yòng fà jì yǔ yī wén lǐ yǐn cáng de pái shuǐ gōu jiě shì gōng jiàng zěn yàng ràng shí kè dǐ kàng qīn shí 。 bào yuàn shēng jiàn jiàn tíng xià ， yì chǎng jí yǔ zhèng hǎo yuè guò yá bì 。',vietnamese:'Hà Xuyên quay đầu sớm, dừng ở vùng nước an toàn và giải thích cách rãnh thoát ẩn trong tóc cùng nếp áo giảm xói mòn. Lời phàn nàn lắng xuống khi một trận mưa gấp tràn qua vách.',english:'He Chuan turns early, steadies the boat in safe water, and explains how drainage hidden in hair and robe folds limits erosion. Complaints fade as a sudden shower crosses the cliff.'),
  ReadingAnnotation(pinyin:'fǎn háng hòu ， fù qīn wèn tā yǒu méi yǒu ràng rén píng ān huí àn 。 hé chuān xiǎng dào bā shì jì kāi záo de shí xiàng réng shòu fēng huà ， míng bái yǒng gǎn bú shì bī jìn fēng xiǎn ， ér shì zài sān jiāng cuī cù shí réng kěn gǎi biàn fāng xiàng 。',vietnamese:'Về bến, cha chỉ hỏi mọi người có an toàn không. Nghĩ tới tượng thế kỷ VIII vẫn chịu phong hóa, Hà Xuyên hiểu dũng cảm là đổi hướng khi ba dòng sông đang thúc ép, không phải tiến sát nguy hiểm.',english:'Back ashore, his father asks only whether everyone returned safely. Thinking of the eighth-century carving still weathering, He Chuan learns that courage means changing course when three rivers press forward, not approaching danger.'),
];
const _leshanW = <WordEntry>[
  WordEntry(word:'交汇',pinyin:'jiāohuì',partOfSpeech:'动词',simpleChinese:'不同水流相遇。',translation:'Các dòng nước gặp nhau.',englishDefinition:'to converge',symbol:'🌊'),
  WordEntry(word:'崖壁',pinyin:'yábì',partOfSpeech:'名词',simpleChinese:'陡直的山崖。',translation:'Vách núi.',englishDefinition:'cliff face',symbol:'⛰️'),
  WordEntry(word:'坐像',pinyin:'zuòxiàng',partOfSpeech:'名词',simpleChinese:'坐着姿态的造像。',translation:'Tượng ngồi.',englishDefinition:'seated statue',symbol:'🗿'),
  WordEntry(word:'开凿',pinyin:'kāizáo',partOfSpeech:'动词',simpleChinese:'在岩石中雕刻挖掘。',translation:'Đục tạc đá.',englishDefinition:'to carve',symbol:'⛏️'),
  WordEntry(word:'红砂岩',pinyin:'hóngshāyán',partOfSpeech:'名词',simpleChinese:'红色的砂岩。',translation:'Sa thạch đỏ.',englishDefinition:'red sandstone',symbol:'🟤'),
  WordEntry(word:'排水沟',pinyin:'páishuǐgōu',partOfSpeech:'名词',simpleChinese:'引走雨水的沟。',translation:'Rãnh thoát nước.',englishDefinition:'drainage channel',symbol:'💧'),
  WordEntry(word:'发髻',pinyin:'fàjì',partOfSpeech:'名词',simpleChinese:'盘在头上的头发。',translation:'Búi tóc.',englishDefinition:'hair bun',symbol:'〰️'),
  WordEntry(word:'侵蚀',pinyin:'qīnshí',partOfSpeech:'动词',simpleChinese:'水和风慢慢损坏表面。',translation:'Xói mòn.',englishDefinition:'to erode',symbol:'🌧️'),
  WordEntry(word:'风化',pinyin:'fēnghuà',partOfSpeech:'名词',simpleChinese:'岩石受环境影响变坏。',translation:'Phong hóa.',englishDefinition:'weathering',symbol:'🍃'),
];
const _leshanD = <DiscoveryEntry>[
  DiscoveryEntry(text:'乐山大佛是八世纪在红砂岩崖壁开凿的七十一米坐像。',pinyin:'Lèshān Dàfó shì bā shìjì kāizáo de qīshíyī mǐ zuòxiàng.',simpleChinese:'大佛高七十一米。',vietnamese:'Tượng cao 71 mét, tạc vào thế kỷ VIII.',english:'The 71-metre seated figure was carved in the eighth century.'),
  DiscoveryEntry(text:'大佛面对岷江、青衣江与大渡河交汇处。',pinyin:'Dàfó miànduì sān jiāng jiāohuìchù.',simpleChinese:'大佛面对三江。',vietnamese:'Tượng nhìn ra nơi ba sông gặp nhau.',english:'The Buddha faces the three-river confluence.'),
  DiscoveryEntry(text:'隐藏排水沟利用发髻与衣纹引走雨水，减缓侵蚀。',pinyin:'Yǐncáng páishuǐgōu lìyòng fàjì yǔ yīwén yǐnzǒu yǔshuǐ.',simpleChinese:'排水设计保护石刻。',vietnamese:'Rãnh ẩn dẫn nước qua tóc và nếp áo.',english:'Hidden drains move rainwater through hair and robe patterns.'),
  DiscoveryEntry(text:'监测、排水与修复共同应对红砂岩风化。',pinyin:'Jiāncè, páishuǐ yǔ xiūfù gòngtóng yìngduì hóngshāyán fēnghuà.',simpleChinese:'保护需要多种方法。',vietnamese:'Quan trắc, thoát nước và tu bổ chống phong hóa.',english:'Monitoring, drainage, and repair address sandstone weathering.'),
];

const _wuyiP = <String>[
  '武夷山筏工叶岚准备陪母亲完成退休前最后一趟九曲溪。母亲听力渐弱，却仍坚持亲自执篙；第一曲刚过，前方浅滩的水声就与往日不同。',
  '游客催着加速追赶日照下的丹霞崖壁，母亲也不愿被人看作老去。叶岚在急弯前必须选择：让母亲继续证明自己，还是接过长篙、承受她的责怪。',
  '她先请母亲用手势判断流速，再在最窄处接篙转向。竹筏擦过倒影而没有撞上浅石，岸边昆虫声重新清晰；游客也安静下来，留意森林与溪水。',
  '第九曲后，母亲把长篙交给她。峡谷、特有物种的栖息地、书院与摩崖石刻都有承载量；叶岚没有夺走告别，而让旧经验继续领航。',
];
const _wuyiA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'wǔ yí shān fá gōng yè lán zhǔn bèi péi mǔ qīn wán chéng tuì xiū qián zuì hòu yí tàng jiǔ qū xī 。 mǔ qīn tīng lì jiàn ruò ， què réng jiān chí qīn zì zhí gāo ； dì yī qǔ gāng guò ， qián fāng qiǎn tān de shuǐ shēng jiù yǔ wǎng rì bù tóng 。',vietnamese:'Người chèo bè Diệp Lam đi cùng mẹ trong chuyến Cửu Khúc cuối trước khi bà nghỉ việc. Mẹ nghe kém nhưng vẫn muốn tự chống sào; ngay sau khúc đầu, tiếng nước ở bãi cạn đã khác thường.',english:'Raft guide Ye Lan accompanies her mother on her final Nine Bend journey before retirement. Her mother\'s hearing has weakened, yet she insists on poling; just beyond the first bend, the shoal sounds different.'),
  ReadingAnnotation(pinyin:'yóu kè cuī zhe jiā sù zhuī gǎn rì zhào xià de dān xiá yá bì ， mǔ qīn yě bú yuàn bèi rén kàn zuò lǎo qù 。 yè lán zài jí wān qián bì xū xuǎn zé ： ràng mǔ qīn jì xù zhèng míng zì jǐ ， hái shì jiē guò cháng gāo 、 chéng shòu tā de zé guài 。',vietnamese:'Du khách giục tăng tốc để đuổi ánh nắng trên vách Đan Hà, còn mẹ không muốn bị coi là già. Trước khúc gấp, Diệp Lam phải chọn để mẹ tiếp tục chứng minh mình hay cầm sào và chịu lời trách.',english:'Passengers urge them to chase sunlight on the Danxia cliffs, while her mother refuses to appear old. Before the sharp turn, Ye Lan must let her mother keep proving herself or take the pole and accept her anger.'),
  ReadingAnnotation(pinyin:'tā xiān qǐng mǔ qīn yòng shǒu shì pàn duàn liú sù ， zài zài zuì zhǎi chù jiē gāo zhuǎn xiàng 。 zhú fá cā guò dǎo yǐng ér méi yǒu zhuàng shàng qiǎn shí ， àn biān kūn chóng shēng chóng xīn qīng xī ； yóu kè yě ān jìng xià lái ， liú yì sēn lín yǔ xī shuǐ 。',vietnamese:'Cô để mẹ dùng tay ra hiệu tốc độ nước rồi nhận sào ở chỗ hẹp nhất. Bè lướt qua bóng nước mà không va đá; tiếng côn trùng rõ lại và du khách bắt đầu chú ý rừng cùng dòng suối.',english:'She first asks her mother to signal the current by hand, then takes the pole at the narrowest point. The raft clears the submerged rock, insects become audible again, and passengers notice forest and stream.'),
  ReadingAnnotation(pinyin:'dì jiǔ qū hòu ， mǔ qīn bǎ cháng gāo jiāo gěi tā 。 xiá gǔ 、 tè yǒu wù zhǒng de qī xī dì 、 shū yuàn yǔ mó yá shí kè dōu yǒu chéng zài liáng ； yè lán méi yǒu duó zǒu gào bié ， ér ràng jiù jīng yàn jì xù lǐng háng 。',vietnamese:'Sau khúc thứ chín, mẹ trao hẳn cây sào và nói: ‘Con đã nghe thấy nước.’ Hẻm núi, sinh cảnh loài đặc hữu, thư viện và bia vách đều có sức chịu tải; Diệp Lam để kinh nghiệm cũ tiếp tục dẫn đường theo cách mới.',english:'After the ninth bend, her mother hands over the pole and says, ‘You heard the water.’ Gorges, endemic habitats, academies, and cliff inscriptions all have limits; Ye Lan lets old experience continue guiding in a new form.'),
];
const _wuyiW = <WordEntry>[
  WordEntry(word:'竹筏',pinyin:'zhúfá',partOfSpeech:'名词',simpleChinese:'竹子做的水上工具。',translation:'Bè tre.',englishDefinition:'bamboo raft',symbol:'🛶'),
  WordEntry(word:'九曲溪',pinyin:'Jiǔqǔ Xī',partOfSpeech:'名词',simpleChinese:'武夷山弯曲的河流。',translation:'Suối Cửu Khúc.',englishDefinition:'Nine Bend River',symbol:'🌊'),
  WordEntry(word:'丹霞',pinyin:'dānxiá',partOfSpeech:'名词',simpleChinese:'红色岩石形成的地貌。',translation:'Địa mạo Đan Hà.',englishDefinition:'Danxia landform',symbol:'⛰️'),
  WordEntry(word:'峡谷',pinyin:'xiágǔ',partOfSpeech:'名词',simpleChinese:'山间深长的谷地。',translation:'Hẻm núi.',englishDefinition:'gorge',symbol:'🏞️'),
  WordEntry(word:'栖息地',pinyin:'qīxīdì',partOfSpeech:'名词',simpleChinese:'生物生活的地方。',translation:'Môi trường sống.',englishDefinition:'habitat',symbol:'🌿'),
  WordEntry(word:'特有',pinyin:'tèyǒu',partOfSpeech:'形容词',simpleChinese:'某地独有。',translation:'Đặc hữu.',englishDefinition:'endemic',symbol:'🦋'),
  WordEntry(word:'书院',pinyin:'shūyuàn',partOfSpeech:'名词',simpleChinese:'古代讲学读书场所。',translation:'Thư viện học thuật cổ.',englishDefinition:'academy',symbol:'📚'),
  WordEntry(word:'摩崖石刻',pinyin:'móyá shíkè',partOfSpeech:'名词',simpleChinese:'刻在山崖上的文字图案。',translation:'Khắc đá trên vách.',englishDefinition:'cliff inscription',symbol:'✒️'),
  WordEntry(word:'承载量',pinyin:'chéngzàiliàng',partOfSpeech:'名词',simpleChinese:'环境可以承受的数量。',translation:'Sức chứa môi trường.',englishDefinition:'carrying capacity',symbol:'⚖️'),
];
const _wuyiD = <DiscoveryEntry>[
  DiscoveryEntry(text:'武夷山是保存亚热带森林多样性的重要栖息地。',pinyin:'Wǔyí Shān shì bǎocún yàrèdài sēnlín duōyàngxìng de zhòngyào qīxīdì.',simpleChinese:'这里保护很多动植物。',vietnamese:'Đây là sinh cảnh quan trọng của rừng cận nhiệt.',english:'Mount Wuyi is an important refuge for subtropical biodiversity.'),
  DiscoveryEntry(text:'九曲溪与丹霞峡谷共同形成武夷山代表性景观。',pinyin:'Jiǔqǔ Xī yǔ dānxiá xiágǔ gòngtóng xíngchéng dàibiǎoxìng jǐngguān.',simpleChinese:'河流和红色山峰相互连接。',vietnamese:'Dòng Cửu Khúc và hẻm Đan Hà tạo cảnh quan đặc trưng.',english:'The river and Danxia gorges form the signature landscape.'),
  DiscoveryEntry(text:'书院与摩崖石刻记录朱子理学在此发展传播。',pinyin:'Shūyuàn yǔ móyá shíkè jìlù Zhūzǐ Lǐxué de fāzhǎn.',simpleChinese:'山水中保存思想文化。',vietnamese:'Thư viện và khắc đá ghi lại sự phát triển Tân Nho học.',english:'Academies and inscriptions record Neo-Confucian learning.'),
  DiscoveryEntry(text:'旅游承载量管理同时保护九曲溪、森林和文化遗迹。',pinyin:'Lǚyóu chéngzàiliàng guǎnlǐ tóngshí bǎohù héliú, sēnlín hé wénhuà yíjì.',simpleChinese:'游客数量也影响保护。',vietnamese:'Quản lý sức chứa bảo vệ sông, rừng và di tích.',english:'Visitor capacity management protects nature and heritage.'),
];

const _hongheP = <String>[
  '红河雾季，年轻稻农白索回村接管家里最高的一片梯田。插秧前夜，木刻分水记录显示今年水少，叔父却让他悄悄多开一道沟，否则新苗可能全部枯死。',
  '白索沿森林、村寨到田地查看水路，发现下游寡妇家的田埂已经开裂。多取一夜能救自家，代价却是把缺水推给看不见的人；祖父留下的木刻在他手里沉得像石头。',
  '他选择敲响分水会议的木板，当众承认自家风险，并提出先修漏水沟渠、错开灌溉。村民忙到天亮，第一股水经过他的田却没有停留，继续流向下游。',
  '几周后，新苗没有最齐，却都活了。森林蓄水、涵养水源，蘑菇房与农耕循环彼此相连；白索补刻一线，记住梯田依靠共同承担。',
];
const _hongheA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'hóng hé wù jì ， nián qīng dào nóng bái suǒ huí cūn jiē guǎn jiā lǐ zuì gāo de yí piàn tī tián 。 chā yāng qián yè ， mù kè fēn shuǐ jì lù xiǎn shì jīn nián shuǐ shǎo ， shū fù què ràng tā qiāo qiāo duō kāi yí dào gōu ， fǒu zé xīn miáo kě néng quán bù kū sǐ 。',vietnamese:'Trong mùa sương Hồng Hà, nông dân trẻ Bạch Tác về nhận thửa ruộng bậc thang cao nhất của gia đình. Trước đêm cấy, bản khắc chia nước báo năm nay thiếu, nhưng chú bảo cậu lén mở thêm rãnh để cứu mạ.',english:'During Honghe\'s mist season, young farmer Bai Suo returns to manage his family\'s highest terrace. On the eve of planting, the water-allocation carving shows a shortage, but his uncle urges him to open an extra channel in secret to save the seedlings.'),
  ReadingAnnotation(pinyin:'bái suǒ yán sēn lín 、 cūn zhài dào tián dì chá kàn shuǐ lù ， fā xiàn xià yóu guǎ fù jiā de tián gěng yǐ jīng kāi liè 。 duō qǔ yí yè néng jiù zì jiā ， dài jià què shì bǎ quē shuǐ tuī gěi kàn bú jiàn de rén ； zǔ fù liú xià de mù kè zài tā shǒu lǐ chén dé xiàng shí tou 。',vietnamese:'Cậu theo đường nước từ rừng qua làng đến ruộng và thấy bờ của một góa phụ phía dưới đã nứt. Lấy thêm một đêm có thể cứu nhà mình nhưng đẩy thiếu nước cho người khuất tầm mắt; tấm khắc của ông nặng như đá trong tay.',english:'He follows the water from forest through village to field and finds a downstream widow\'s bund cracked. One extra night may save his crop but pass the shortage to someone unseen; his grandfather\'s carving feels heavy as stone.'),
  ReadingAnnotation(pinyin:'tā xuǎn zé qiāo xiǎng fēn shuǐ huì yì de mù bǎn ， dāng zhòng chéng rèn zì jiā fēng xiǎn ， bìng tí chū xiān xiū lòu shuǐ gōu qú 、 cuò kāi guàn gài 。 cūn mín máng dào tiān liàng ， dì yī gǔ shuǐ jīng guò tā de tián què méi yǒu tíng liú ， jì xù liú xiàng xià yóu 。',vietnamese:'Cậu gõ bảng gọi họp chia nước, công khai rủi ro nhà mình và đề nghị sửa kênh rò rồi tưới luân phiên. Mọi người làm đến sáng; dòng đầu đi qua ruộng cậu mà không dừng, tiếp tục xuống dưới.',english:'He sounds the water-meeting board, admits his family\'s risk, and proposes repairing leaks and staggering irrigation. The village works until dawn; the first flow passes his field without stopping and continues downstream.'),
  ReadingAnnotation(pinyin:'jǐ zhōu hòu ， xīn miáo méi yǒu zuì qí ， què dōu huó le 。 sēn lín xù shuǐ 、 hán yǎng shuǐ yuán ， mó gu fáng yǔ nóng gēng xún huán bǐ cǐ xiāng lián ； bái suǒ bǔ kè yí xiàn ， jì zhù tī tián yī kào gòng tóng chéng dān 。',vietnamese:'Vài tuần sau, mạ không đều nhất nhưng đều sống. Rừng tích và giữ nguồn nước, nhà nấm cùng canh tác tạo vòng tuần hoàn; Bạch Tác khắc thêm một nét để nhớ rằng ruộng bậc thang tồn tại nhờ cùng gánh trách nhiệm.',english:'Weeks later, the seedlings are uneven but alive. Forests retain water, while mushroom houses and farming form a cycle; Bai Suo adds one mark to remember that the terraces depend on shared responsibility.'),
];
const _hongheW = <WordEntry>[
  WordEntry(word:'梯田',pinyin:'tītián',partOfSpeech:'名词',simpleChinese:'山坡上的阶梯状农田。',translation:'Ruộng bậc thang.',englishDefinition:'rice terrace',symbol:'🌾'),
  WordEntry(word:'蓄水',pinyin:'xùshuǐ',partOfSpeech:'动词',simpleChinese:'保存水。',translation:'Tích nước.',englishDefinition:'to retain water',symbol:'💧'),
  WordEntry(word:'蘑菇房',pinyin:'mógufáng',partOfSpeech:'名词',simpleChinese:'哈尼传统房屋。',translation:'Nhà nấm truyền thống Hani.',englishDefinition:'mushroom-shaped house',symbol:'🏠'),
  WordEntry(word:'村寨',pinyin:'cūnzhài',partOfSpeech:'名词',simpleChinese:'乡村聚居地。',translation:'Bản làng.',englishDefinition:'village settlement',symbol:'🏘️'),
  WordEntry(word:'农耕',pinyin:'nónggēng',partOfSpeech:'名词',simpleChinese:'种田生产活动。',translation:'Canh tác nông nghiệp.',englishDefinition:'farming',symbol:'🌱'),
  WordEntry(word:'沟渠',pinyin:'gōuqú',partOfSpeech:'名词',simpleChinese:'引水的小河道。',translation:'Kênh dẫn nước.',englishDefinition:'irrigation channel',symbol:'〰️'),
  WordEntry(word:'水源',pinyin:'shuǐyuán',partOfSpeech:'名词',simpleChinese:'水的来源。',translation:'Nguồn nước.',englishDefinition:'water source',symbol:'🏔️'),
  WordEntry(word:'涵养',pinyin:'hányǎng',partOfSpeech:'动词',simpleChinese:'保存并补充水分。',translation:'Nuôi dưỡng và giữ nước.',englishDefinition:'to conserve water',symbol:'🌳'),
  WordEntry(word:'循环',pinyin:'xúnhuán',partOfSpeech:'名词',simpleChinese:'不断回到系统中使用。',translation:'Vòng tuần hoàn.',englishDefinition:'cycle',symbol:'♻️'),
];
const _hongheD = <DiscoveryEntry>[
  DiscoveryEntry(text:'哈尼梯田是延续一千三百多年的活态农耕文化景观。',pinyin:'Hāní Tītián shì yánxù yìqiān sānbǎi duō nián de huótài nónggēng jǐngguān.',simpleChinese:'梯田有一千三百多年历史。',vietnamese:'Cảnh quan canh tác sống đã kéo dài hơn 1.300 năm.',english:'The living farming landscape has developed for over 1,300 years.'),
  DiscoveryEntry(text:'森林蓄水，沟渠把水源引过村寨并送入梯田。',pinyin:'Sēnlín xùshuǐ, gōuqú bǎ shuǐyuán yǐnguò cūnzhài bìng sòngrù tītián.',simpleChinese:'水从森林流向梯田。',vietnamese:'Rừng giữ nước, kênh dẫn qua làng tới ruộng.',english:'Forests retain water and channels deliver it through villages to fields.'),
  DiscoveryEntry(text:'蘑菇房村寨位于上方森林与下方梯田之间。',pinyin:'Mógufáng cūnzhài wèiyú sēnlín yǔ tītián zhījiān.',simpleChinese:'村寨连接森林和农田。',vietnamese:'Làng nhà nấm nằm giữa rừng và ruộng.',english:'Mushroom-house villages sit between forest and terraces.'),
  DiscoveryEntry(text:'水、肥料、作物与动物循环维持完整农耕生态。',pinyin:'Shuǐ, féiliào, zuòwù yǔ dòngwù xúnhuán wéichí nónggēng shēngtài.',simpleChinese:'多种资源在系统里循环。',vietnamese:'Nước, phân, cây trồng và vật nuôi tuần hoàn trong hệ thống.',english:'Water, nutrients, crops, and animals cycle through the farming system.'),
];

final pingyaoJourney = _record('pingyao-ancient-city','平遥 · 古城：在灰砖街巷读懂晋商','cn-shanxi-jinzhong-pingyao-ancient-city',_pingyaoP,const ['unesco-pingyao','shanxi-pingyao'],const ['平遥','古城','晋商','票号','世界遗产']);
final qufuJourney = _record('qufu-confucius-sites','曲阜 · 三孔：沿中轴读懂礼与学','cn-shandong-jining-qufu-confucius-temple',_qufuP,const ['unesco-qufu','shandong-qufu'],const ['曲阜','三孔','孔子','儒家','世界遗产']);
final leshanJourney = _record('leshan-giant-buddha','乐山 · 大佛：三江与石刻的千年守望','cn-sichuan-leshan-shizhong-giant-buddha',_leshanP,const ['unesco-leshan','leshan-government-buddha'],const ['乐山','大佛','石刻','三江','世界遗产']);
final wuyishanJourney = _record('wuyishan-nine-bend-stream','武夷山 · 九曲溪：山水之间的理学回声','cn-fujian-nanping-wuyishan-nine-bend-stream',_wuyiP,const ['unesco-wuyishan','fujian-wuyishan'],const ['武夷山','九曲溪','生态','朱子理学','世界遗产']);
final hongheJourney = _record('honghe-hani-rice-terraces','红河 · 哈尼梯田：让森林的水流进稻田','cn-yunnan-honghe-yuanyang-hani-terraces',_hongheP,const ['unesco-honghe','yunnan-honghe'],const ['红河','元阳','哈尼梯田','农耕','世界遗产']);

final journeyExpansionBatchFourRecords=<JourneyContentRecord>[pingyaoJourney,qufuJourney,leshanJourney,wuyishanJourney,hongheJourney];
final journeyExpansionBatchFourExperiences=<DailyJourneyExperience>[
  DailyJourneyExperience(id:pingyaoJourney.id,city:'平遥',cityCode:'PYG',place:'平遥古城',appBarTitle:'平遥 · 古城',storyTitle:'晋商古城故事',headline:'在灰砖街巷读懂晋商',description:'穿过城墙、票号与院落，理解古代县城和金融网络。',discoveryTeaser:'没有现代银行，平遥票号怎样连接远方？',distanceLabel:'1,660 km',stampSymbol:'票',content:pingyaoJourney,storyAnnotations:_pingyaoA,words:_pingyaoW,discoveries:_pingyaoD,wonderQuestion:'如果你经营一家古代票号，最重要的是信用、速度还是安全？为什么？',expressQuestion:'请用两到三句话描写晨光中的城墙、灰砖街巷与市楼。'),
  DailyJourneyExperience(id:qufuJourney.id,city:'曲阜',cityCode:'JNG',place:'孔庙',appBarTitle:'曲阜 · 三孔',storyTitle:'儒家文化故事',headline:'沿中轴读懂礼与学',description:'观察孔庙、孔府与孔林如何连接思想、教育和家族记忆。',discoveryTeaser:'为什么思想需要建筑和礼仪来传播？',distanceLabel:'1,690 km',stampSymbol:'礼',content:qufuJourney,storyAnnotations:_qufuA,words:_qufuW,discoveries:_qufuD,wonderQuestion:'你认为学习空间应该强调秩序、自由还是交流？',expressQuestion:'请用两到三句话描写古柏、石碑和层层院落形成的氛围。'),
  DailyJourneyExperience(id:leshanJourney.id,city:'乐山',cityCode:'LSS',place:'乐山大佛',appBarTitle:'乐山 · 大佛',storyTitle:'三江石刻故事',headline:'三江与石刻的千年守望',description:'从江面观察七十一米石刻、隐蔽排水和现代保护。',discoveryTeaser:'大佛的发髻和衣纹为什么也参与排水？',distanceLabel:'1,210 km',stampSymbol:'佛',content:leshanJourney,storyAnnotations:_leshanA,words:_leshanW,discoveries:_leshanD,wonderQuestion:'面对巨大的山体石刻，你会先观察尺度、表情还是工程细节？',expressQuestion:'请用两到三句话描写三江、红砂岩崖壁与大佛的尺度。'),
  DailyJourneyExperience(id:wuyishanJourney.id,city:'武夷山',cityCode:'WUS',place:'九曲溪',appBarTitle:'武夷山 · 九曲溪',storyTitle:'山水理学故事',headline:'山水之间的理学回声',description:'沿九曲溪认识丹霞森林、生物多样性与朱子文化。',discoveryTeaser:'为什么一条溪流能同时承载自然与思想史？',distanceLabel:'650 km',stampSymbol:'曲',content:wuyishanJourney,storyAnnotations:_wuyiA,words:_wuyiW,discoveries:_wuyiD,wonderQuestion:'如果在九曲溪边设一座现代书院，你希望学生怎样观察自然？',expressQuestion:'请用两到三句话描写竹筏、碧水、丹霞峰林与云雾。'),
  DailyJourneyExperience(id:hongheJourney.id,city:'红河',cityCode:'HHE',place:'哈尼梯田',appBarTitle:'红河 · 哈尼梯田',storyTitle:'山地农耕故事',headline:'让森林的水流进稻田',description:'理解森林、村寨、梯田与水系如何组成活态农耕生态。',discoveryTeaser:'山顶森林为什么决定山下梯田的收成？',distanceLabel:'680 km',stampSymbol:'田',content:hongheJourney,storyAnnotations:_hongheA,words:_hongheW,discoveries:_hongheD,wonderQuestion:'如果只能保护森林、沟渠、村寨或梯田中的一项，你会怎样解释它们不能分开？',expressQuestion:'请用两到三句话描写日出、云海与层层水田的颜色变化。'),
];
