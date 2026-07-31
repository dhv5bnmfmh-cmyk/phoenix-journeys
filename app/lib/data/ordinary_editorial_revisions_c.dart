import 'daily_journey_experience.dart';
import 'editorial_story_revision.dart';

const ordinaryEditorialRevisionsC = <String, EditorialStoryRevision>{
  'xiamen-kulangsu': EditorialStoryRevision(
    id: 'xiamen-kulangsu',
    protagonist: '林铃',
    narrativeMode: '寻找失落音符',
    emotionalArc: '只相信乐谱 → 听见环境 → 接受混合 → 完成新旋律',
    endingMode: '让社区声音进入演奏',
    sections: [
      '少年调琴师林铃要为社区音乐会修好一架旧钢琴，却发现最高的一个音总是发闷。琴盖内侧贴着一张纸：“缺的音不在琴里，在岛上。”她以为是谁的玩笑，还是和你从码头走进鼓浪屿寻找线索。',
      '石阶沿坡地转弯，红砖、花岗岩和浅色廊柱在榕树影里交替出现。十九世纪中期以后，不同国家和地区的居民在岛上生活，住宅、学校、医院与公共空间形成国际社区，建筑也混合闽南、南洋与西方经验。',
      '林铃先在教堂门口听钟声，又在老宅廊下听雨滴，最后在市场旁听见闽南童谣。三个声音没有一个等于钢琴缺失的音，却共同解释了纸条：岛上的音乐从来不是单独一种传统，而是在本地气候、语言和生活里彼此调整。',
      '音乐会那天，林铃没有强行把闷音调得过亮，而是让它接在钟声、雨点和孩子哼唱的录音之后。旧钢琴终于不再模仿别处的音色。听众散去时，巷道、树木、海岸和居民日常仍在继续为这座可步行的社区伴奏。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Shàonián tiáoqínshī Lín Líng yào wèi shèqū yīnyuèhuì xiūhǎo yí jià jiù gāngqín, què fāxiàn zuì gāo de yí gè yīn zǒng shì fāmèn. Qíngài nèicè tiēzhe yì zhāng zhǐ: “Quē de yīn bú zài qín lǐ, zài dǎo shàng.” Tā yǐwéi shì shéi de wánxiào, háishi hé nǐ cóng mǎtóu zǒujìn Gǔlàngyǔ xúnzhǎo xiànsuǒ.',
        vietnamese: 'Lâm Linh sửa một cây đàn cũ nhưng nốt cao nhất luôn đục. Mảnh giấy trong nắp đàn viết rằng âm còn thiếu không ở trong đàn mà ở trên đảo, nên cô cùng bạn đi tìm.',
        english: 'Young piano tuner Lin Ling finds that the highest note of an old piano remains dull. A note inside says the missing sound is not in the instrument but on the island, so she searches with you.',
      ),
      ReadingAnnotation(
        pinyin: 'Shíjiē yán pōdì zhuǎnwān, hóngzhuān, huāgāngyán hé qiǎnsè lángzhù zài róngshùyǐng lǐ jiāotì chūxiàn. Shíjiǔ shìjì zhōngqī yǐhòu, bùtóng guójiā hé dìqū de jūmín zài dǎo shàng shēnghuó, zhùzhái, xuéxiào, yīyuàn yǔ gōnggòng kōngjiān xíngchéng guójì shèqū, jiànzhù yě hùnhé Mǐnnán, Nányáng yǔ Xīfāng jīngyàn.',
        vietnamese: 'Bậc đá, gạch đỏ, granit và hàng cột hiện dưới bóng đa. Cộng đồng quốc tế trên đảo đã kết hợp kinh nghiệm Mân Nam, Nam Dương và phương Tây trong kiến trúc và đời sống.',
        english: 'Stone steps, red brick, granite, and pale colonnades appear beneath banyans. The island community combined Minnan, Southeast Asian, and Western experience in buildings and daily life.',
      ),
      ReadingAnnotation(
        pinyin: 'Lín Líng xiān zài jiàotáng ménkǒu tīng zhōngshēng, yòu zài lǎozhái lángxià tīng yǔdī, zuìhòu zài shìchǎng páng tīngjiàn Mǐnnán tóngyáo. Sān gè shēngyīn méiyǒu yí gè děngyú gāngqín quēshī de yīn, què gòngtóng jiěshì le zhǐtiáo: dǎo shàng de yīnyuè cónglái bú shì dāndú yì zhǒng chuántǒng, ér shì zài běndì qìhòu, yǔyán hé shēnghuó lǐ bǐcǐ tiáozhěng.',
        vietnamese: 'Cô nghe chuông nhà thờ, mưa dưới hiên và đồng dao Mân Nam. Không âm nào là nốt bị thiếu, nhưng chúng cho thấy âm nhạc đảo được điều chỉnh qua khí hậu, ngôn ngữ và đời sống.',
        english: 'She hears church bells, rain beneath a veranda, and a Minnan children’s song. None is the missing note, but together they show how island music is adjusted by climate, language, and life.',
      ),
      ReadingAnnotation(
        pinyin: 'Yīnyuèhuì nà tiān, Lín Líng méiyǒu qiángxíng bǎ mènyīn tiáo de guò liàng, ér shì ràng tā jiē zài zhōngshēng, yǔdiǎn hé háizi hēngchàng de lùyīn zhīhòu. Jiù gāngqín zhōngyú bú zài mófǎng biéchù de yīnsè. Tīngzhòng sànqù shí, xiàngdào, shùmù, hǎi’àn hé jūmín rìcháng réng zài jìxù wèi zhè zuò kě bùxíng de shèqū bànzòu.',
        vietnamese: 'Trong buổi diễn, cô để nốt đục nối sau chuông, mưa và tiếng trẻ thay vì làm nó quá sáng. Cây đàn tìm được âm sắc của chính cộng đồng.',
        english: 'At the concert, she places the muted note after bells, rain, and children rather than forcing it bright. The piano finds a sound belonging to its own community.',
      ),
    ],
    wonderQuestion: '不同文化传统进入同一社区后，为什么会发生调整而不是简单并排？',
    expressQuestion: '请用三种当地声音写一段四句“声音地图”。',
  ),
  'pingyao-ancient-city': EditorialStoryRevision(
    id: 'pingyao-ancient-city',
    protagonist: '远志',
    narrativeMode: '票号汇兑危机',
    emotionalArc: '自信计算 → 发现错误 → 面对责任 → 公开改正',
    endingMode: '一笔账变成诚信选择',
    sections: [
      '票号体验馆的小掌柜远志刚学会汇兑，就把一张“山西付银、天津取款”的模拟票据算错了十两。他想趁游客没发现偷偷换掉账页，你正好看见墨迹还没干。远志低声说：“只是游戏，改了也没人知道。”',
      '你们沿平遥街巷寻找旧票号的工作方法。城墙、衙署、寺庙、民居和商业街组成完整县城格局，十九世纪的票号则靠书信、密码、印章和异地信用连接远方商路。数字错误很小，经过长路却可能变成别人的巨大损失。',
      '远志在柜台后找到一枚“作废”印章，却迟迟不敢盖。老讲解员没有替他选择，只问：“汇兑最值钱的是纸、银子，还是别人相信这张纸？”远志终于把错误票据贴到公开栏，写清错误位置和重新计算过程。',
      '当天结束，游客没有嘲笑他，反而在旁边留下自己的验算方法。远志把正确票据交给下一组孩子，也把那张作废单收进学习档案。平遥的金融故事因此不只关于聪明买卖，更关于一座城市怎样让看不见的信任走到远方。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Piàohào tǐyànguǎn de xiǎo zhǎngguì Yuǎnzhì gāng xuéhuì huìduì, jiù bǎ yì zhāng “Shānxī fù yín, Tiānjīn qǔkuǎn” de mónǐ piàojù suàncuò le shí liǎng. Tā xiǎng chèn yóukè méi fāxiàn tōutōu huàndiào zhàngyè, nǐ zhènghǎo kànjiàn mòjì hái méi gān. Yuǎnzhì dīshēng shuō: “Zhǐ shì yóuxì, gǎi le yě méi rén zhīdào.”',
        vietnamese: 'Viễn Chí tính sai mười lạng trong phiếu chuyển tiền mô phỏng và muốn lén đổi trang sổ vì cho rằng chỉ là trò chơi.',
        english: 'Yuanzhi miscalculates a simulated remittance by ten taels and wants to replace the ledger page quietly because it is only a game.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐmen yán Píngyáo jiēxiàng xúnzhǎo jiù piàohào de gōngzuò fāngfǎ. Chéngqiáng, yáshǔ, sìmiào, mínjū hé shāngyèjiē zǔchéng wánzhěng xiànchéng géjú, shíjiǔ shìjì de piàohào zé kào shūxìn, mìmǎ, yìnzhāng hé yìdì xìnyòng liánjiē yuǎnfāng shānglù. Shùzì cuòwù hěn xiǎo, jīngguò chánglù què kěnéng biàn chéng biérén de jùdà sǔnshī.',
        vietnamese: 'Hai bạn tìm hiểu phiếu hiệu dùng thư, mật mã, con dấu và tín dụng để nối thương lộ. Sai số nhỏ có thể trở thành thiệt hại lớn ở nơi xa.',
        english: 'You learn how draft banks used letters, codes, seals, and trust across trade routes. A small error can become a large loss far away.',
      ),
      ReadingAnnotation(
        pinyin: 'Yuǎnzhì zài guìtái hòu zhǎodào yí méi “zuòfèi” yìnzhāng, què chíchí bù gǎn gài. Lǎo jiǎngjiěyuán méiyǒu tì tā xuǎnzé, zhǐ wèn: “Huìduì zuì zhíqián de shì zhǐ, yínzi, háishi biérén xiāngxìn zhè zhāng zhǐ?” Yuǎnzhì zhōngyú bǎ cuòwù piàojù tiē dào gōngkāilán, xiěqīng cuòwù wèizhi hé chóngxīn jìsuàn guòchéng.',
        vietnamese: 'Người hướng dẫn hỏi thứ đáng giá nhất là giấy, bạc hay niềm tin vào tờ giấy. Viễn Chí công khai phiếu sai và viết rõ cách tính lại.',
        english: 'A guide asks whether paper, silver, or trust in the paper is most valuable. Yuanzhi posts the incorrect note publicly and explains the corrected calculation.',
      ),
      ReadingAnnotation(
        pinyin: 'Dāngtiān jiéshù, yóukè méiyǒu cháoxiào tā, fǎn’ér zài pángbiān liúxià zìjǐ de yànsuàn fāngfǎ. Yuǎnzhì bǎ zhèngquè piàojù jiāogěi xià yì zǔ háizi, yě bǎ nà zhāng zuòfèidān shōu jìn xuéxí dàng’àn. Píngyáo de jīnróng gùshi yīncǐ bù zhǐ guānyú cōngming mǎimài, gèng guānyú yí zuò chéngshì zěnyàng ràng kànbujiàn de xìnrèn zǒu dào yuǎnfāng.',
        vietnamese: 'Du khách không cười mà thêm cách kiểm tra. Viễn Chí giữ phiếu hủy trong hồ sơ, hiểu tài chính Bình Dao còn là cách đưa niềm tin vô hình đi xa.',
        english: 'Visitors add their own checking methods rather than mocking him. Yuanzhi archives the cancelled note and learns that Pingyao finance carried invisible trust across distance.',
      ),
    ],
    wonderQuestion: '为什么汇兑系统中，一次诚实的改错比假装从未出错更重要？',
    expressQuestion: '请用“错误—影响—改正”三步写一份简短公开说明。',
  ),
  'qufu-confucius-sites': EditorialStoryRevision(
    id: 'qufu-confucius-sites',
    protagonist: '苗苗',
    narrativeMode: '反背诵辩论',
    emotionalArc: '厌烦 → 挑战 → 体验 → 重新定义学习',
    endingMode: '把名句变成可验证行动',
    sections: [
      '学校要求每人到曲阜背一句名言，苗苗却把卡片揉成团：“背得快就算懂吗？”老师没有责备，只让她带一年级的多多走完孔庙、孔府和孔林，并回答多多一路提出的三个问题。',
      '沿中轴进入孔庙，古柏、门坊、碑亭与院落层层展开。多多问为什么走路要慢，苗苗起初照着卡片念“礼仪”，却发现孩子仍不明白。她只好蹲下来，让多多比较跨门槛前后声音、队伍和视线的变化。',
      '在孔府，多多问家族记忆为什么也算文化；到孔林，他又问纪念一个人是否等于同意他说过的每句话。苗苗没有标准答案，只能把建筑、教育、礼制和自己的疑问放在一起讨论。她第一次发现，提问并不会破坏尊重。',
      '回到课堂，苗苗还是背了那句名言，但在后面加了一行：“我今天用三个问题检查自己是否真的理解。”老师把揉皱的旧卡片贴在新卡片旁。曲阜留给她的不是沉默服从，而是让学习、判断和行动彼此负责。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Xuéxiào yāoqiú měi rén dào Qūfù bèi yí jù míngyán, Miáomiao què bǎ kǎpiàn róu chéng tuán: “Bèi de kuài jiù suàn dǒng ma?” Lǎoshī méiyǒu zébèi, zhǐ ràng tā dài yì niánjí de Duōduo zǒuwán Kǒngmiào, Kǒngfǔ hé Kǒnglín, bìng huídá Duōduo yílù tíchū de sān gè wèntí.',
        vietnamese: 'Miêu Miêu không tin học thuộc nhanh là hiểu. Giáo viên giao cô dẫn em Đa Đa qua Tam Khổng và trả lời ba câu hỏi trên đường.',
        english: 'Miaomiao doubts that fast memorization means understanding. Her teacher asks her to guide younger Duoduo through the Confucian sites and answer three questions.',
      ),
      ReadingAnnotation(
        pinyin: 'Yán zhōngzhóu jìnrù Kǒngmiào, gǔbǎi, ménfāng, bēitíng yǔ yuànluò céngcéng zhǎnkāi. Duōduo wèn wèishénme zǒulù yào màn, Miáomiao qǐchū zhàozhe kǎpiàn niàn “lǐyí”, què fāxiàn háizi réng bù míngbai. Tā zhǐhǎo dūn xiàlái, ràng Duōduo bǐjiào kuà ménkǎn qiánhòu shēngyīn, duìwu hé shìxiàn de biànhuà.',
        vietnamese: 'Khi Đa Đa hỏi vì sao phải đi chậm, từ “lễ nghi” trên thẻ không đủ. Miêu Miêu cho em so âm thanh, hàng người và tầm nhìn trước sau ngưỡng cửa.',
        english: 'When Duoduo asks why they must walk slowly, the word “ritual” is not enough. Miaomiao has him compare sound, lines of people, and sight before and after a threshold.',
      ),
      ReadingAnnotation(
        pinyin: 'Zài Kǒngfǔ, Duōduo wèn jiāzú jìyì wèishénme yě suàn wénhuà; dào Kǒnglín, tā yòu wèn jìniàn yí gè rén shìfǒu děngyú tóngyì tā shuōguò de měi yí jù huà. Miáomiao méiyǒu biāozhǔn dá’àn, zhǐnéng bǎ jiànzhù, jiàoyù, lǐzhì hé zìjǐ de yíwèn fàng zài yìqǐ tǎolùn. Tā dì yí cì fāxiàn, tíwèn bìng bú huì pòhuài zūnzhòng.',
        vietnamese: 'Đa Đa hỏi ký ức gia tộc có phải văn hóa và tưởng niệm có nghĩa là đồng ý mọi lời không. Miêu Miêu không có đáp án chuẩn, nhưng hiểu đặt câu hỏi không phá hỏng sự tôn trọng.',
        english: 'Duoduo asks whether family memory is culture and whether commemoration means agreeing with every statement. Miaomiao has no standard answer, but learns that questions do not destroy respect.',
      ),
      ReadingAnnotation(
        pinyin: 'Huídào kètáng, Miáomiao háishi bèi le nà jù míngyán, dàn zài hòumiàn jiā le yì háng: “Wǒ jīntiān yòng sān gè wèntí jiǎnchá zìjǐ shìfǒu zhēn de lǐjiě.” Lǎoshī bǎ róuzhòu de jiù kǎpiàn tiē zài xīn kǎpiàn páng. Qūfù liúgěi tā de bú shì chénmò fúcóng, ér shì ràng xuéxí, pànduàn hé xíngdòng bǐcǐ fùzé.',
        vietnamese: 'Cô vẫn học thuộc câu danh ngôn nhưng thêm rằng ba câu hỏi giúp kiểm tra mình có thật sự hiểu. Bài học là học tập, phán đoán và hành động phải chịu trách nhiệm với nhau.',
        english: 'She memorizes the quotation but adds that three questions tested whether she truly understood. The lesson links learning, judgment, and responsible action.',
      ),
    ],
    wonderQuestion: '尊重传统与提出问题为什么不一定互相冲突？',
    expressQuestion: '请选择一句你熟悉的话，写一个可以检查自己是否理解它的问题。',
  ),
  'leshan-giant-buddha': EditorialStoryRevision(
    id: 'leshan-giant-buddha',
    protagonist: '琪琪',
    narrativeMode: '三江水痕调查',
    emotionalArc: '只想拍全景 → 发现异常 → 求证 → 成为小观察员',
    endingMode: '把微小水痕加入长期记录',
    sections: [
      '船到岷江、青衣江和大渡河交汇处时，琪琪一直退到甲板边，只想把七十一米高的大佛完整拍进镜头。船工爷爷却指着崖壁上一道深色水痕问：“照片先等等，你看它昨天也在这里吗？”',
      '大佛开凿于八世纪，工匠在红砂岩中塑造头部、肩膀与双足，还把排水沟藏进发髻、衣纹和身体结构。琪琪原以为巨大就是全部，直到她发现保护这座坐像，常常要从几厘米宽的水迹开始。',
      '她对照游客中心昨天的监测照片，发现水痕位置略有变化。爷爷没有让她下结论，而是请工作人员复核降雨、渗水和排水数据。结果只是雨后正常变化，不是新的严重损伤，可这次谨慎判断仍被写进记录。',
      '返航时，琪琪拍了两张照片：一张是三江前的宏大坐像，一张是标尺旁的小水痕。她把第二张放在第一页，并写道：“震撼让我抬头，责任让我靠近。”大佛继续面对江水，她也开始懂得宏伟与细节必须一起被看见。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Chuán dào Mínjiāng, Qīngyī Jiāng hé Dàdù Hé jiāohuìchù shí, Qíqi yìzhí tuì dào jiǎbǎn biān, zhǐ xiǎng bǎ qīshíyī mǐ gāo de Dàfó wánzhěng pāi jìn jìngtóu. Chuángōng yéye què zhǐzhe yábì shàng yí dào shēnsè shuǐhén wèn: “Zhàopiàn xiān děngděng, nǐ kàn tā zuótiān yě zài zhèlǐ ma?”',
        vietnamese: 'Khi tàu đến chỗ ba sông gặp nhau, Kỳ Kỳ chỉ muốn chụp trọn tượng lớn. Ông lái tàu lại hỏi vệt nước sẫm trên vách hôm qua có ở đúng chỗ đó không.',
        english: 'At the three-river confluence, Qiqi only wants a complete photograph of the giant figure. The boatman asks whether a dark water mark stood in the same place yesterday.',
      ),
      ReadingAnnotation(
        pinyin: 'Dàfó kāizáo yú bā shìjì, gōngjiàng zài hóngshāyán zhōng sùzào tóubù, jiānbǎng yǔ shuāngzú, hái bǎ páishuǐgōu cáng jìn fàjì, yīwén hé shēntǐ jiégòu. Qíqi yuán yǐwéi jùdà jiù shì quánbù, zhídào tā fāxiàn bǎohù zhè zuò zuòxiàng, chángcháng yào cóng jǐ límǐ kuān de shuǐjì kāishǐ.',
        vietnamese: 'Tượng thế kỷ tám có rãnh thoát nước ẩn trong tóc và nếp áo. Kỳ Kỳ hiểu việc bảo tồn một công trình khổng lồ thường bắt đầu từ vệt nước chỉ vài xăng-ti-mét.',
        english: 'The eighth-century figure hides drainage in hair and robe folds. Qiqi learns that protecting something monumental may begin with a water trace only centimetres wide.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā duìzhào yóukè zhōngxīn zuótiān de jiāncè zhàopiàn, fāxiàn shuǐhén wèizhi lüèyǒu biànhuà. Yéye méiyǒu ràng tā xià jiélùn, ér shì qǐng gōngzuòrényuán fùhé jiàngyǔ, shènshuǐ hé páishuǐ shùjù. Jiéguǒ zhǐ shì yǔhòu zhèngcháng biànhuà, bú shì xīn de yánzhòng sǔnshāng, kě zhè cì jǐnshèn pànduàn réng bèi xiě jìn jìlù.',
        vietnamese: 'Cô so ảnh quan trắc và nhờ nhân viên kiểm tra mưa, thấm và thoát nước. Đó chỉ là biến đổi bình thường sau mưa, nhưng quá trình đánh giá thận trọng vẫn được ghi lại.',
        english: 'She compares monitoring images and asks staff to check rain, seepage, and drainage. The change is normal after rain, yet the careful assessment is still recorded.',
      ),
      ReadingAnnotation(
        pinyin: 'Fǎnháng shí, Qíqi pāi le liǎng zhāng zhàopiàn: yì zhāng shì sān jiāng qián de hóngdà zuòxiàng, yì zhāng shì biāochǐ páng de xiǎo shuǐhén. Tā bǎ dì èr zhāng fàng zài dì yí yè, bìng xiědào: “Zhènhàn ràng wǒ táitóu, zérèn ràng wǒ kàojìn.” Dàfó jìxù miànduì jiāngshuǐ, tā yě kāishǐ dǒngde hóngwěi yǔ xìjié bìxū yìqǐ bèi kànjiàn.',
        vietnamese: 'Cô đặt ảnh vệt nước trước ảnh toàn cảnh và viết: “Kỳ vĩ khiến tôi ngẩng đầu, trách nhiệm khiến tôi đến gần.”',
        english: 'She places the water mark before the grand view and writes, “Awe makes me look up; responsibility makes me move closer.”',
      ),
    ],
    wonderQuestion: '为什么监测文化遗产时，发现变化以后不能立刻下结论？',
    expressQuestion: '请用一大一小两个画面描写同一处遗产。',
  ),
  'wuyishan-nine-bend-stream': EditorialStoryRevision(
    id: 'wuyishan-nine-bend-stream',
    protagonist: '小雨',
    narrativeMode: '竹筏路线分歧',
    emotionalArc: '追求速度 → 忽略同伴 → 面对后果 → 学会协商',
    endingMode: '把最快路线改成共同路线',
    sections: [
      '小雨第一次当九曲溪少年讲解员，提前背好所有景点，却催竹筏师傅划快一点。同行的植物爱好者想看岸边茶树，历史老师想停在摩崖石刻附近，腿脚较慢的奶奶还没坐稳，小雨已经讲到下一曲了。',
      '竹筏穿过丹霞峰林和云雾，溪流、峡谷与森林提供多样栖息地；寺观、书院和石刻又记录朱熹讲学及思想传播。内容越丰富，小雨越想全部塞进一次讲解，声音快得连自己都喘不过气。',
      '转弯处，一只落水的讲解卡漂向下游。师傅没有追，只让竹筏顺水减速。小雨看见奶奶终于抬头看山，植物爱好者指出一株岸边植物，老师则用石刻解释一句她刚才背错的内容。失去卡片后，旅程反而开始真正发生。',
      '靠岸前，小雨把剩下的卡片分给大家，请每个人选一个最想留下的发现。最终路线比计划慢，却没有人被落在讲解后面。她在日志上改掉“完成全部景点”，写成“让不同的人都能进入同一段山水”。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Xiǎoyǔ dì yí cì dāng Jiǔqǔ Xī shàonián jiǎngjiěyuán, tíqián bèihǎo suǒyǒu jǐngdiǎn, què cuī zhúfá shīfu huá kuài yìdiǎn. Tóngxíng de zhíwù àihàozhě xiǎng kàn ànbiān cháshù, lìshǐ lǎoshī xiǎng tíng zài móyá shíkè fùjìn, tuǐjiǎo jiào màn de nǎinai hái méi zuòwěn, Xiǎoyǔ yǐjīng jiǎngdào xià yì qǔ le.',
        vietnamese: 'Tiểu Vũ lần đầu thuyết minh trên Cửu Khúc Khê và thúc bè đi nhanh, dù người thích cây muốn xem trà, giáo viên muốn dừng ở khắc đá và bà chưa ngồi vững.',
        english: 'On her first day as a young guide, Xiaoyu rushes the raft although one traveller wants tea plants, another wants inscriptions, and a grandmother is not yet settled.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhúfá chuānguò dānxiá fēnglín hé yúnwù, xīliú, xiágǔ yǔ sēnlín tígōng duōyàng qīxīdì; sìguàn, shūyuàn hé shíkè yòu jìlù Zhū Xī jiǎngxué jí sīxiǎng chuánbō. Nèiróng yuè fēngfù, Xiǎoyǔ yuè xiǎng quánbù sāi jìn yí cì jiǎngjiě, shēngyīn kuài de lián zìjǐ dōu chuǎnbuguò qì.',
        vietnamese: 'Cảnh quan vừa có sinh thái, vừa có chùa, thư viện và bia khắc. Càng nhiều nội dung, cô càng nói nhanh đến mức chính mình không thở nổi.',
        english: 'The landscape holds ecology, temples, academies, and inscriptions. The more there is to tell, the faster she speaks until even she cannot breathe.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhuǎnwān chù, yì zhāng luòshuǐ de jiǎngjiěkǎ piāo xiàng xiàyóu. Shīfu méiyǒu zhuī, zhǐ ràng zhúfá shùnshuǐ jiǎnsù. Xiǎoyǔ kànjiàn nǎinai zhōngyú táitóu kàn shān, zhíwù àihàozhě zhǐchū yì zhū ànbiān zhíwù, lǎoshī zé yòng shíkè jiěshì yí jù tā gāngcái bèicuò de nèiróng. Shīqù kǎpiàn hòu, lǚchéng fǎn’ér kāishǐ zhēnzhèng fāshēng.',
        vietnamese: 'Một thẻ rơi xuống nước và bè chậm lại. Bà ngẩng nhìn núi, người mê cây chỉ thực vật, giáo viên sửa một câu; mất thẻ lại khiến chuyến đi thật sự bắt đầu.',
        english: 'A guide card falls into the river and the raft slows. The grandmother looks up, the plant lover points, and the teacher corrects a line. Losing the card allows the journey to begin.',
      ),
      ReadingAnnotation(
        pinyin: 'Kào’àn qián, Xiǎoyǔ bǎ shèngxià de kǎpiàn fēngěi dàjiā, qǐng měi gè rén xuǎn yí gè zuì xiǎng liúxià de fāxiàn. Zuìzhōng lùxiàn bǐ jìhuà màn, què méiyǒu rén bèi luò zài jiǎngjiě hòumiàn. Tā zài rìzhì shàng gǎidiào “wánchéng quánbù jǐngdiǎn”, xiě chéng “ràng bùtóng de rén dōu néng jìnrù tóng yí duàn shānshuǐ”.',
        vietnamese: 'Cô chia thẻ còn lại để mỗi người chọn một phát hiện. Tuyến chậm hơn nhưng không ai bị bỏ lại, và mục tiêu đổi thành giúp mọi người cùng bước vào cảnh quan.',
        english: 'She shares the remaining cards so each person chooses one discovery. The route is slower but leaves nobody behind, and her goal becomes shared access to the landscape.',
      ),
    ],
    wonderQuestion: '为什么“讲完所有知识”不一定等于让所有人都获得好的学习体验？',
    expressQuestion: '请为三位兴趣不同的游客安排一句共同路线说明。',
  ),
  'honghe-hani-rice-terraces': EditorialStoryRevision(
    id: 'honghe-hani-rice-terraces',
    protagonist: '阿洛',
    narrativeMode: '清晨分水协作',
    emotionalArc: '想独自解决 → 判断失误 → 请求帮助 → 共同承担',
    endingMode: '水到每块田，功劳不属于一个人',
    sections: [
      '日出前，阿洛发现通往自家梯田的沟渠水量突然变小。他不想惊动大人，独自搬动分水木槽，结果上层田水更多，下层几户却几乎断水。第一束晨光照亮水面时，邻居已经沿坡找来。',
      '森林在山顶涵养水源，蘑菇房村寨位于中部，层层梯田延伸到河谷。沟渠把水经过村寨分入田块，红米、水牛、鱼鸭和居民劳动共同参与生产。阿洛只盯着自家一块田，忽略了整套系统的上下关系。',
      '邻居没有先责怪他，而是让每户派一人站在不同高度，用口哨报告水到达的时间。阿洛在中间调整木槽，老人观察森林来水，孩子清理细小泥沙。几次试流以后，上下田块依次亮起薄薄水光。',
      '阿洛想在维护本上写“我修好了沟渠”，停笔后改成“我们让水重新找到每一块田”。午后，他把错误的第一次调整也画进记录。梯田仍在生产的秘密，不是某个聪明人一次完成，而是社区不断共享水、经验和责任。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Rìchū qián, Ā Luò fāxiàn tōngwǎng zìjiā tītián de gōuqú shuǐliàng tūrán biàn xiǎo. Tā bù xiǎng jīngdòng dàrén, dúzì bāndòng fēnshuǐ mùcáo, jiéguǒ shàngcéng tián shuǐ gèng duō, xiàcéng jǐ hù què jīhū duànshuǐ. Dì yí shù chénguāng zhàoliàng shuǐmiàn shí, línjū yǐjīng yán pō zhǎolái.',
        vietnamese: 'Trước bình minh, A Lạc tự chỉnh máng chia nước cho ruộng nhà, khiến ruộng trên nhiều nước còn vài nhà dưới gần cạn. Hàng xóm tìm đến khi ánh sớm vừa lên.',
        english: 'Before sunrise, Aluo adjusts a divider for his own field and leaves lower neighbours nearly dry. They arrive as the first light reaches the terraces.',
      ),
      ReadingAnnotation(
        pinyin: 'Sēnlín zài shāndǐng hányǎng shuǐyuán, mógu fáng cūnzhài wèiyú zhōngbù, céngcéng tītián yánshēn dào hégǔ. Gōuqú bǎ shuǐ jīngguò cūnzhài fēnrù tiánkuài, hóngmǐ, shuǐniú, yúyā hé jūmín láodòng gòngtóng cānyù shēngchǎn. Ā Luò zhǐ dīngzhe zìjiā yí kuài tián, hūlüè le zhěng tào xìtǒng de shàngxià guānxì.',
        vietnamese: 'Rừng, làng, kênh và ruộng nối thành hệ thống với lúa đỏ, trâu, cá vịt và lao động. A Lạc chỉ nhìn ruộng nhà nên bỏ qua quan hệ trên dưới.',
        english: 'Forest, village, channels, terraces, crops, animals, and labour form one system. Aluo watched only his field and missed the upstream-downstream relationship.',
      ),
      ReadingAnnotation(
        pinyin: 'Línjū méiyǒu xiān zéguài tā, ér shì ràng měi hù pài yì rén zhàn zài bùtóng gāodù, yòng kǒushào bàogào shuǐ dàodá de shíjiān. Ā Luò zài zhōngjiān tiáozhěng mùcáo, lǎorén guānchá sēnlín láishuǐ, háizi qīnglǐ xìxiǎo níshā. Jǐ cì shìliú yǐhòu, shàngxià tiánkuài yīcì liàngqǐ báobáo shuǐguāng.',
        vietnamese: 'Mỗi nhà đứng ở độ cao khác nhau và huýt sáo báo nước. Người già xem nguồn rừng, trẻ dọn bùn, A Lạc chỉnh máng; sau vài lần thử, các thửa lần lượt sáng nước.',
        english: 'Each household stations someone at a different height and whistles when water arrives. Elders watch the source, children clear sediment, and Aluo adjusts the channel until fields light one by one.',
      ),
      ReadingAnnotation(
        pinyin: 'Ā Luò xiǎng zài wéihùběn shàng xiě “wǒ xiūhǎo le gōuqú”, tíngbǐ hòu gǎi chéng “wǒmen ràng shuǐ chóngxīn zhǎodào měi yí kuài tián”. Wǔhòu, tā bǎ cuòwù de dì yí cì tiáozhěng yě huà jìn jìlù. Tītián réng zài shēngchǎn de mìmì, bú shì mǒu gè cōngming rén yí cì wánchéng, ér shì shèqū bùduàn gòngxiǎng shuǐ, jīngyàn hé zérèn.',
        vietnamese: 'Cậu sửa “tôi đã sửa kênh” thành “chúng tôi giúp nước tìm lại mọi thửa” và ghi cả lần làm sai. Hệ thống sống nhờ cộng đồng chia sẻ nước, kinh nghiệm và trách nhiệm.',
        english: 'He changes “I fixed the channel” to “We helped water find every field” and records his mistake. The living system depends on shared water, experience, and responsibility.',
      ),
    ],
    wonderQuestion: '为什么一块梯田的用水决定必须考虑上游、下游和整个社区？',
    expressQuestion: '请用“先……接着……最后……”写一次多人协作分水。',
  ),
  'huangshan-cloud-peaks': EditorialStoryRevision(
    id: 'huangshan-cloud-peaks',
    protagonist: '禾禾',
    narrativeMode: '观景台边界抉择',
    emotionalArc: '羡慕网红照片 → 犹豫 → 承担职责 → 创造新拍法',
    endingMode: '不越界也能得到独特作品',
    sections: [
      '少年护林志愿者禾禾在黄山观景台值班，同学却发来一张站在步道外岩石上的“绝美照片”，催她也拍一张。云海正从谷底升起，花岗岩峰与黄山松在晨光里显出轮廓，那块岩石离她只有三步。',
      '禾禾知道薄土、古树根系和山顶植被经不起反复踩踏，也知道游客容量和步道边界不是为了破坏体验。可同学不断问“你是不是不敢”，她第一次觉得遵守规则像是在错过只出现几分钟的云海。',
      '一位小游客也准备翻过绳栏，理由正是想模仿那张照片。禾禾不再只对自己负责，立刻拦住他，并把手机固定在合法步道低处，让松枝、岩缝和云层在前后景中形成新的角度。小游客帮她按下连拍。',
      '照片没有人站在危险岩石上，却让云海像从松树根部流出。同学看后沉默片刻，删掉了“胆小”的留言。禾禾把拍摄位置做成安全取景卡，留在观景台。边界没有拿走她的创造力，反而逼她找到别人没有复制过的画面。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Shàonián hùlín zhìyuànzhě Héhé zài Huángshān guānjǐngtái zhíbān, tóngxué què fālái yì zhāng zhàn zài bùdào wài yánshí shàng de “juéměi zhàopiàn”, cuī tā yě pāi yì zhāng. Yúnhǎi zhèng cóng gǔdǐ shēngqǐ, huāgāngyán fēng yǔ Huángshānsōng zài chénguāng lǐ xiǎnchū lúnkuò, nà kuài yánshí lí tā zhǐyǒu sān bù.',
        vietnamese: 'Hòa Hòa trực ở điểm ngắm thì bạn học gửi ảnh đứng ngoài đường và thách cô chụp theo. Biển mây đang lên, tảng đá nguy hiểm chỉ cách ba bước.',
        english: 'While volunteering at a Huangshan overlook, Hehe receives a photograph taken beyond the trail and is challenged to copy it. The cloud sea rises, and the risky rock is only three steps away.',
      ),
      ReadingAnnotation(
        pinyin: 'Héhé zhīdào báotǔ, gǔshù gēnxì hé shāndǐng zhíbèi jīngbuqǐ fǎnfù cǎità, yě zhīdào yóukè róngliàng hé bùdào biānjiè bú shì wèile pòhuài tǐyàn. Kě tóngxué bùduàn wèn “nǐ shì bú shì bù gǎn”, tā dì yí cì juéde zūnshǒu guīzé xiàng shì zài cuòguò zhǐ chūxiàn jǐ fēnzhōng de yúnhǎi.',
        vietnamese: 'Cô biết đất mỏng, rễ cổ và cây đỉnh núi dễ bị giẫm, nhưng lời chế giễu khiến việc tuân thủ có vẻ như bỏ lỡ biển mây hiếm.',
        english: 'She knows thin soil, ancient roots, and summit plants cannot withstand trampling, yet teasing makes the rule feel like missing a rare cloud sea.',
      ),
      ReadingAnnotation(
        pinyin: 'Yí wèi xiǎo yóukè yě zhǔnbèi fānguò shénglán, lǐyóu zhèng shì xiǎng mófǎng nà zhāng zhàopiàn. Héhé bú zài zhǐ duì zìjǐ fùzé, lìkè lánzhù tā, bìng bǎ shǒujī gùdìng zài héfǎ bùdào dīchù, ràng sōngzhī, yánfèng hé yúncéng zài qiánhòujǐng zhōng xíngchéng xīn de jiǎodù. Xiǎo yóukè bāng tā ànxià liánpāi.',
        vietnamese: 'Một em nhỏ định trèo dây để bắt chước ảnh. Hòa Hòa ngăn lại rồi đặt điện thoại thấp trên đường hợp lệ, dùng cành thông, khe đá và mây tạo góc mới.',
        english: 'A child prepares to cross the rope to imitate the image. Hehe stops him and places the phone low on the legal trail, using pine, rock crevice, and cloud as a new composition.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhàopiàn méiyǒu rén zhàn zài wēixiǎn yánshí shàng, què ràng yúnhǎi xiàng cóng sōngshù gēnbù liúchū. Tóngxué kàn hòu chénmò piànkè, shāndiào le “dǎnxiǎo” de liúyán. Héhé bǎ pāishè wèizhi zuò chéng ānquán qǔjǐngkǎ, liú zài guānjǐngtái. Biānjiè méiyǒu ná zǒu tā de chuàngzàolì, fǎn’ér bī tā zhǎodào biérén méiyǒu fùzhìguò de huàmiàn.',
        vietnamese: 'Ảnh không có người trên đá nguy hiểm nhưng mây như chảy từ rễ thông. Cô biến vị trí chụp an toàn thành thẻ gợi ý; giới hạn đã thúc đẩy sáng tạo.',
        english: 'No one stands on the dangerous rock, yet clouds seem to flow from pine roots. Hehe turns the safe viewpoint into a photo card, proving that limits can provoke originality.',
      ),
    ],
    wonderQuestion: '为什么保护边界有时能够推动新的创意，而不只是限制行动？',
    expressQuestion: '请写一段劝阻朋友模仿危险照片的对话，语气坚定但不羞辱。',
  ),
  'zhangjiajie-wulingyuan': EditorialStoryRevision(
    id: 'zhangjiajie-wulingyuan',
    protagonist: '知知与真真',
    narrativeMode: '峡谷回声地图',
    emotionalArc: '竞争 → 数据冲突 → 合作验证 → 共享发现',
    endingMode: '两张不完整地图合成可靠记录',
    sections: [
      '双胞胎知知和真真参加“听声音画峡谷”比赛。知知带测距仪，真真只带录音笔，两人都说自己的方法更准。晨雾升起时，武陵源数千根石英砂岩柱逐渐出现，他们却在第一处回声方向上得出相反答案。',
      '峰柱由岩层抬升、流水切割、风化和崩塌长期塑造，峡谷里还有溪流、水潭、洞穴与天然桥。垂直岩壁、谷底水系和不同海拔森林形成复杂微环境，单靠一次距离或一段回声都可能被地形误导。',
      '两人决定交换工具。知知发现录音中的第二次回声来自侧面石柱，真真则用测距确认声音经过水潭反射。游客经过时产生的新噪声又迫使他们暂停，等环境恢复安静再测。竞争没有消失，但谁先承认数据不完整，谁就先接近真相。',
      '终点处，他们把两张地图叠在一起：一张标距离，一张标回声和水声，空白处则写“尚未验证”。评审没有选单独冠军，而让两人共同展示。知知和真真第一次觉得，最可靠的地图不是看起来最完整，而是诚实说明自己还不知道什么。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Shuāngbāotāi Zhīzhi hé Zhēnzhen cānjiā “tīng shēngyīn huà xiágǔ” bǐsài. Zhīzhi dài cèjùyí, Zhēnzhen zhǐ dài lùyīnbǐ, liǎng rén dōu shuō zìjǐ de fāngfǎ gèng zhǔn. Chénwù shēngqǐ shí, Wǔlíngyuán shùqiān gēn shíyīng shāyánzhù zhújiàn chūxiàn, tāmen què zài dì yí chù huíshēng fāngxiàng shàng déchū xiāngfǎn dá’àn.',
        vietnamese: 'Cặp song sinh Tri Tri và Chân Chân thi vẽ hẻm núi bằng âm thanh. Một dùng máy đo, một dùng ghi âm, nhưng ngay tiếng vọng đầu tiên họ cho hai hướng trái ngược.',
        english: 'Twins Zhizhi and Zhenzhen map a gorge by sound, one with a rangefinder and one with a recorder. Their first echo produces opposite directions.',
      ),
      ReadingAnnotation(
        pinyin: 'Fēngzhù yóu yáncéng táishēng, liúshuǐ qiēgē, fēnghuà hé bēngtā chángqī sùzào, xiágǔ lǐ hái yǒu xīliú, shuǐtán, dòngxué yǔ tiānránqiáo. Chuízhí yánbì, gǔdǐ shuǐxì hé bùtóng hǎibá sēnlín xíngchéng fùzá wēihuánjìng, dān kào yí cì jùlí huò yí duàn huíshēng dōu kěnéng bèi dìxíng wùdǎo.',
        vietnamese: 'Cột đá, suối, hồ, hang và cầu tự nhiên tạo địa hình phức tạp. Một lần đo hay một tiếng vọng dễ bị vách, nước và độ cao đánh lừa.',
        english: 'Pillars, streams, pools, caves, and natural bridges create complex terrain. One distance or echo can be distorted by cliff, water, and elevation.',
      ),
      ReadingAnnotation(
        pinyin: 'Liǎng rén juédìng jiāohuàn gōngjù. Zhīzhi fāxiàn lùyīn zhōng de dì èr cì huíshēng láizì cèmiàn shízhù, Zhēnzhen zé yòng cèjù quèrèn shēngyīn jīngguò shuǐtán fǎnshè. Yóukè jīngguò shí chǎnshēng de xīn zàoshēng yòu pòshǐ tāmen zàntíng, děng huánjìng huīfù ānjìng zài cè. Jìngzhēng méiyǒu xiāoshī, dàn shéi xiān chéngrèn shùjù bù wánzhěng, shéi jiù xiān jiējìn zhēnxiàng.',
        vietnamese: 'Đổi dụng cụ, họ phát hiện tiếng vọng phụ từ cột bên và phản xạ qua hồ. Tiếng du khách buộc họ đợi yên rồi đo lại; người thừa nhận dữ liệu thiếu trước sẽ gần sự thật hơn.',
        english: 'After swapping tools, they identify a side-pillar echo and reflection from a pool. Visitor noise forces a pause, and admitting incomplete data becomes part of accuracy.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhōngdiǎn chù, tāmen bǎ liǎng zhāng dìtú dié zài yìqǐ: yì zhāng biāo jùlí, yì zhāng biāo huíshēng hé shuǐshēng, kòngbái chù zé xiě “shàngwèi yànzhèng”. Píngshěn méiyǒu xuǎn dāndú guànjūn, ér ràng liǎng rén gòngtóng zhǎnshì. Zhīzhi hé Zhēnzhen dì yí cì juéde, zuì kěkào de dìtú bú shì kàn qǐlái zuì wánzhěng, ér shì chéngshí shuōmíng zìjǐ hái bù zhīdào shénme.',
        vietnamese: 'Họ chồng bản khoảng cách và bản âm thanh, ghi “chưa xác minh” ở chỗ trống. Bản đồ đáng tin không phải trông đầy nhất mà thành thật về điều chưa biết.',
        english: 'They overlay distance and sound maps and label blanks “not yet verified.” A trustworthy map is not the fullest-looking one, but the one honest about uncertainty.',
      ),
    ],
    wonderQuestion: '为什么在复杂地形中需要用不同工具互相验证，而不能只相信一种数据？',
    expressQuestion: '请用“证据一……证据二……暂时结论……”写一段调查记录。',
  ),
};
