import 'daily_journey_experience.dart';
import 'editorial_story_revision.dart';

const ordinaryEditorialRevisionsD = <String, EditorialStoryRevision>{
  'kaifeng-song-capital': EditorialStoryRevision(
    id: 'kaifeng-song-capital',
    protagonist: '若若',
    narrativeMode: '真假遗迹新闻核查',
    emotionalArc: '追求热度 → 发现混淆 → 求证 → 公开更正',
    endingMode: '把“好看”改成“有证据”',
    sections: [
      '少年记者若若拍了一段短视频，标题是“我摸到了北宋城墙原砖”。视频刚获得很多点赞，博物馆老师却问：“你确定那是原砖吗？”若若指着景区新建的墙说大家都这么介绍，不愿删掉已经走红的内容。',
      '你们从开封街巷走向铁塔和水系。北宋东京曾有密集街市、河道、桥梁、寺院与官署，黄河洪水和泥沙又让旧城遗址层层叠压。今天的城市同时拥有原有遗存、考古证据、重建空间和持续生活，不能只凭外观判断年代。',
      '若若查到那段墙是现代展示工程，使用传统外观帮助游客想象城市格局，却不是北宋原物。她担心更正会丢脸，直到看见评论里已有孩子把“摸原砖”写进作业。她把原视频保留，在开头加上醒目说明，并拍摄自己怎样找到证据。',
      '新视频的点赞少了一些，讨论却更认真。若若在镜头前说：“复原场景不是假的，它的任务不同；错误的是我没有说明边界。”古城没有因为更正变得无趣，反而从漂亮背景变成一座需要证据、比较和诚实讲述的城市。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Shàonián jìzhě Ruòruo pāi le yí duàn duǎnshìpín, biāotí shì “Wǒ mōdào le Běisòng chéngqiáng yuánzhuān”. Shìpín gāng huòdé hěn duō diǎnzàn, bówùguǎn lǎoshī què wèn: “Nǐ quèdìng nà shì yuánzhuān ma?” Ruòruo zhǐzhe jǐngqū xīnjiàn de qiáng shuō dàjiā dōu zhème jièshào, bù yuàn shāndiào yǐjīng zǒuhóng de nèiróng.',
        vietnamese: 'Nhược Nhược đăng video “chạm gạch thành Bắc Tống nguyên bản” và được nhiều lượt thích. Khi giáo viên bảo tường là công trình mới, cô bé không muốn xóa nội dung đang nổi.',
        english: 'Ruoruo posts a popular video claiming she touched an original Northern Song brick. When a museum teacher questions the newly built wall, she resists correcting a viral post.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐmen cóng Kāifēng jiēxiàng zǒuxiàng Tiětǎ hé shuǐxì. Běisòng Dōngjīng céng yǒu mìjí jiēshì, hédào, qiáoliáng, sìyuàn yǔ guānshǔ, Huánghé hóngshuǐ hé níshā yòu ràng jiùchéng yízhǐ céngcéng diéyā. Jīntiān de chéngshì tóngshí yǒu yuányǒu yícún, kǎogǔ zhèngjù, chóngjiàn kōngjiān hé chíxù shēnghuó, bùnéng zhǐ píng wàiguān pànduàn niándài.',
        vietnamese: 'Khai Phong có di tích, chứng cứ khảo cổ, không gian phục dựng và đời sống hiện đại chồng lên các thành bị lũ Hoàng Hà vùi. Hình dáng không đủ để xác định niên đại.',
        english: 'Kaifeng contains remains, archaeology, reconstructions, and present life above cities layered by Yellow River floods. Appearance alone cannot establish age.',
      ),
      ReadingAnnotation(
        pinyin: 'Ruòruo chádào nà duàn qiáng shì xiàndài zhǎnshì gōngchéng, shǐyòng chuántǒng wàiguān bāngzhù yóukè xiǎngxiàng chéngshì géjú, què bú shì Běisòng yuánwù. Tā dānxīn gēngzhèng huì diūliǎn, zhídào kànjiàn pínglùn lǐ yǐ yǒu háizi bǎ “mō yuánzhuān” xiě jìn zuòyè. Tā bǎ yuán shìpín bǎoliú, zài kāitóu jiāshàng xǐngmù shuōmíng, bìng pāishè zìjǐ zěnyàng zhǎodào zhèngjù.',
        vietnamese: 'Cô xác minh tường là phục dựng giúp hình dung bố cục, không phải nguyên vật. Thấy trẻ khác ghi sai vào bài, cô thêm đính chính và quay quá trình tìm bằng chứng.',
        english: 'She verifies that the wall is a reconstruction used to explain urban form. Seeing children repeat her error, she adds a correction and records how she found the evidence.',
      ),
      ReadingAnnotation(
        pinyin: 'Xīn shìpín de diǎnzàn shǎo le yìxiē, tǎolùn què gèng rènzhēn. Ruòruo zài jìngtóu qián shuō: “Fùyuán chǎngjǐng bú shì jiǎ de, tā de rènwu bùtóng; cuòwù de shì wǒ méiyǒu shuōmíng biānjiè.” Gǔchéng méiyǒu yīnwèi gēngzhèng biàn de wúqù, fǎn’ér cóng piàoliang bèijǐng biàn chéng yí zuò xūyào zhèngjù, bǐjiào hé chéngshí jiǎngshù de chéngshì.',
        vietnamese: 'Video mới ít lượt thích hơn nhưng thảo luận tốt hơn. Cô nói phục dựng không giả, chỉ có nhiệm vụ khác; lỗi là không nói rõ ranh giới.',
        english: 'The corrected video earns fewer likes but better discussion. Ruoruo explains that reconstruction has a different role and that her mistake was failing to state the boundary.',
      ),
    ],
    wonderQuestion: '历史遗存、考古证据和现代复原之间应该怎样清楚说明关系？',
    expressQuestion: '请为一条发现错误的短视频写三句公开更正。',
  ),
  'dali-cangshan-erhai': EditorialStoryRevision(
    id: 'dali-cangshan-erhai',
    protagonist: '诺诺',
    narrativeMode: '校庆舞台设计争执',
    emotionalArc: '追求华丽 → 被质疑 → 进入生活 → 重新设计',
    endingMode: '让传统由人讲述而非被当装饰',
    sections: [
      '诺诺负责校庆舞台，打算把白墙灰瓦、扎染花纹、苍山和洱海全部印成巨大背景。白族奶奶看了设计只问：“台上的人要做什么？”诺诺回答不出，只觉得元素越多越像大理。',
      '你们从古城石板路走到湖岸。大理曾是南诏和大理国的重要中心，多民族往来留下古城格局、三塔、白族建筑与手工艺；洱海又是高原湖泊生态系统，村落生活、湿地、河流和旅游都会影响水质。',
      '诺诺拜访扎染作坊，发现每块布要经过折叠、捆扎、浸染和晾晒，花纹不是随手贴上的符号。她又听湖边志愿者讲水质监测，意识到把洱海画得永远湛蓝，却不让任何真实行动进入舞台，也是在把地方简化成装饰。',
      '新舞台只保留一面可移动白墙和一块正在滴水的扎染布。学生在表演中讲家族技艺、湖泊治理和今天的选择，背景随着故事变化。谢幕时，诺诺没有说“我们展示了大理”，而说“我们邀请大理人讲述自己”。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Nuònuo fùzé xiàoqìng wǔtái, dǎsuàn bǎ báiqiáng huīwǎ, zhārǎn huāwén, Cāngshān hé Ěrhǎi quánbù yìn chéng jùdà bèijǐng. Báizú nǎinai kàn le shèjì zhǐ wèn: “Táishàng de rén yào zuò shénme?” Nuònuo huídábuchū, zhǐ juéde yuánsù yuè duō yuè xiàng Dàlǐ.',
        vietnamese: 'Nặc Nặc muốn dồn tường trắng, mái xám, hoa nhuộm, Thương Sơn và Nhĩ Hải vào phông sân khấu. Bà người Bạch hỏi người trên sân khấu sẽ làm gì, còn cô bé không trả lời được.',
        english: 'Nuonuo fills a stage backdrop with white walls, grey roofs, tie-dye, Cangshan, and Erhai. A Bai grandmother asks what the people on stage will do, and she has no answer.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐmen cóng gǔchéng shíbǎnlù zǒu dào hú’àn. Dàlǐ céng shì Nánzhào hé Dàlǐ Guó de zhòngyào zhōngxīn, duō mínzú wǎnglái liúxià gǔchéng géjú, Sāntǎ, Báizú jiànzhù yǔ shǒugōngyì; Ěrhǎi yòu shì gāoyuán húpō shēngtài xìtǒng, cūnluò shēnghuó, shīdì, héliú hé lǚyóu dōu huì yǐngxiǎng shuǐzhì.',
        vietnamese: 'Lịch sử Nam Chiếu, Đại Lý và giao lưu dân tộc để lại kiến trúc và nghề thủ công; Nhĩ Hải là hệ sinh thái chịu tác động từ làng, đất ngập, sông và du lịch.',
        english: 'Nanzhao, the Dali Kingdom, and ethnic exchange shaped architecture and crafts, while Erhai is an ecosystem affected by settlements, wetlands, rivers, and tourism.',
      ),
      ReadingAnnotation(
        pinyin: 'Nuònuo bàifǎng zhārǎn zuōfáng, fāxiàn měi kuài bù yào jīngguò zhédié, kǔnzā, jìnrǎn hé liàngshài, huāwén bú shì suíshǒu tiē shàng de fúhào. Tā yòu tīng húbiān zhìyuànzhě jiǎng shuǐzhì jiāncè, yìshí dào bǎ Ěrhǎi huà de yǒngyuǎn zhànlán, què bù ràng rènhé zhēnshí xíngdòng jìnrù wǔtái, yě shì zài bǎ dìfāng jiǎnhuà chéng zhuāngshì.',
        vietnamese: 'Cô học vải nhuộm cần gấp, buộc, ngâm và phơi, không chỉ là họa tiết. Nghe quan trắc hồ, cô hiểu hình ảnh xanh đẹp mà thiếu hành động thật cũng biến địa phương thành trang trí.',
        english: 'She learns that tie-dye requires folding, binding, dyeing, and drying. Hearing about lake monitoring, she sees that a permanently blue backdrop without real action also reduces place to decoration.',
      ),
      ReadingAnnotation(
        pinyin: 'Xīn wǔtái zhǐ bǎoliú yí miàn kě yídòng báiqiáng hé yí kuài zhèngzài dīshuǐ de zhārǎnbù. Xuésheng zài biǎoyǎn zhōng jiǎng jiāzú jìyì, húpō zhìlǐ hé jīntiān de xuǎnzé, bèijǐng suízhe gùshi biànhuà. Xièmù shí, Nuònuo méiyǒu shuō “wǒmen zhǎnshì le Dàlǐ”, ér shuō “wǒmen yāoqǐng Dàlǐ rén jiǎngshù zìjǐ”.',
        vietnamese: 'Sân khấu mới để người biểu diễn kể kỹ nghệ gia đình, quản lý hồ và lựa chọn hôm nay. Nặc Nặc nói họ mời người Đại Lý tự kể thay vì trưng bày Đại Lý.',
        english: 'The new stage lets performers tell family craft, lake care, and present choices. Nuonuo says they invited Dali people to speak rather than displaying Dali.',
      ),
    ],
    wonderQuestion: '为什么把文化元素画得很漂亮，仍然可能把真实传统简化成装饰？',
    expressQuestion: '请用“不是为了……而是为了……”说明一个舞台元素的真实用途。',
  ),
  'harbin-central-street': EditorialStoryRevision(
    id: 'harbin-central-street',
    protagonist: '米莎',
    narrativeMode: '老店招牌修复选择',
    emotionalArc: '想换新 → 发现多层记忆 → 权衡 → 保留可读痕迹',
    endingMode: '新招牌承认自己不是第一层',
    sections: [
      '面包店学徒米莎要为中央大街老店换招牌。旧木牌褪色、裂开，还叠着三层不同年代的字，她嫌它难看，画了一块闪亮的新牌。外婆只说：“先找出每一层是谁写的，再决定扔不扔。”',
      '冬日冷雾散开，面包石路、砖墙和圆拱窗展现哈尔滨不长却复杂的现代史。铁路建设和人口迁移带来建筑、商业、宗教、音乐与饮食交流，多种风格进入东北气候、材料和城市生活。',
      '米莎在档案中找到第一层俄文字母属于早期面包师，第二层中文来自接手店铺的本地家庭，第三层数字则是物资紧张时期的价格记号。新牌最清楚，却把三段生活一次遮没；旧牌最真实，又无法继续安全悬挂。',
      '她把旧牌送去稳定保存，并在新牌背面刻出三层文字的轮廓与来源。挂起时，正面服务今天，背面承认过去。外婆买下第一只面包，没有说“和从前一样”，只说：“这回它知道自己不是第一层。”',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Miànbāodiàn xuétú Mǐshā yào wèi Zhōngyāng Dàjiē lǎodiàn huàn zhāopái. Jiù mùpái tuìsè, lièkāi, hái diézhe sān céng bùtóng niándài de zì, tā xián tā nánkàn, huà le yí kuài shǎnliàng xīnpái. Wàipó zhǐ shuō: “Xiān zhǎochū měi yì céng shì shéi xiě de, zài juédìng rēng bu rēng.”',
        vietnamese: 'Mi Sa muốn bỏ biển gỗ cũ có ba lớp chữ và thay bằng biển sáng mới. Bà ngoại yêu cầu tìm người viết từng lớp trước khi quyết định.',
        english: 'Misha wants to replace a cracked sign bearing three layers of writing with a bright new one. Her grandmother asks her to identify each layer before discarding it.',
      ),
      ReadingAnnotation(
        pinyin: 'Dōngrì lěngwù sànkāi, miànbāoshí lù, zhuānqiáng hé yuángǒngchuāng zhǎnxiàn Hā’ěrbīn bù cháng què fùzá de xiàndài shǐ. Tiělù jiànshè hé rénkǒu qiānyí dàilái jiànzhù, shāngyè, zōngjiào, yīnyuè yǔ yǐnshí jiāoliú, duō zhǒng fēnggé jìnrù Dōngběi qìhòu, cáiliào hé chéngshì shēnghuó.',
        vietnamese: 'Đá lát, tường gạch và cửa vòm ghi lịch sử hiện đại phức tạp; đường sắt và di cư đưa nhiều phong cách vào khí hậu và đời sống Đông Bắc.',
        english: 'Paving stones, brick walls, and arches record a complex modern history shaped by railway construction, migration, and adaptation to Northeast life.',
      ),
      ReadingAnnotation(
        pinyin: 'Mǐshā zài dàng’àn zhōng zhǎodào dì yì céng Éwén zìmǔ shǔyú zǎoqī miànbāoshī, dì èr céng Zhōngwén láizì jiēshǒu diànpù de běndì jiātíng, dì sān céng shùzì zé shì wùzī jǐnzhāng shíqī de jiàgé jìhào. Xīnpái zuì qīngchu, què bǎ sān duàn shēnghuó yí cì zhēmò; jiùpái zuì zhēnshí, yòu wúfǎ jìxù ānquán xuánguà.',
        vietnamese: 'Ba lớp thuộc thợ bánh sớm, gia đình địa phương và dấu giá thời thiếu thốn. Biển mới rõ nhưng che mất đời sống, biển cũ thật nhưng không còn an toàn để treo.',
        english: 'The layers belong to an early baker, a local family, and prices from a time of shortage. The new sign is clear but erases lives; the old is authentic but unsafe to hang.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā bǎ jiùpái sòng qù wěndìng bǎocún, bìng zài xīnpái bèimiàn kèchū sān céng wénzì de lúnkuò yǔ láiyuán. Guàqǐ shí, zhèngmiàn fúwù jīntiān, bèimiàn chéngrèn guòqù. Wàipó mǎixià dì yì zhī miànbāo, méiyǒu shuō “hé cóngqián yíyàng”, zhǐ shuō: “Zhè huí tā zhīdào zìjǐ bú shì dì yì céng.”',
        vietnamese: 'Cô bảo quản biển cũ và khắc nguồn ba lớp ở mặt sau biển mới. Mặt trước phục vụ hôm nay, mặt sau thừa nhận quá khứ.',
        english: 'She conserves the old sign and carves the three layers and sources on the back of the new one. The front serves today while the back acknowledges the past.',
      ),
    ],
    wonderQuestion: '历史街区更新时，怎样同时满足安全使用和真实信息保存？',
    expressQuestion: '请用“保留什么、改变什么、为什么”写一个招牌修复决定。',
  ),
  'dujiangyan-irrigation-system': EditorialStoryRevision(
    id: 'dujiangyan-irrigation-system',
    protagonist: '沈渝',
    narrativeMode: '季节分水判断',
    emotionalArc: '套用旧答案 → 发现河势变化 → 听取多方 → 作出可调整决定',
    endingMode: '把正确答案改写为持续观察',
    sections: [
      '沈渝参加少年水利员体验，抽到任务：“今天该让多少岷江水进入内江？”他立刻背出去年雨季答案，准备调整模拟闸板。老河工按住他的手：“河每天都在变，昨天的正确数字今天可能会伤田。”',
      '你们先到鱼嘴看内江与外江分流，再观察飞沙堰排洪排沙、宝瓶口控制进入成都平原的水量。三部分没有高坝截断河流，而是借河势、季节和泥沙变化互相配合。工程智慧不在一个固定开关，而在持续判断。',
      '上游传来降雨信息，农户又报告部分田地仍缺水。沈渝原本只想选“多”或“少”，现在必须同时考虑洪水、泥沙、灌溉和下游安全。他请河工、农户与监测员分别说明证据，先做小幅调整，再等待水位回应。',
      '模拟结束，老师没有公布唯一标准答案，只给他的记录盖章：观察完整、决定可逆、理由清楚。沈渝在答案栏写下“继续看河”。都江堰运行两千多年，并不是因为古人留下一条永远不变的命令，而是因为后来的人愿意年年维护、次次重新判断。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Shěn Yú cānjiā shàonián shuǐlìyuán tǐyàn, chōudào rènwu: “Jīntiān gāi ràng duōshao Mínjiāng shuǐ jìnrù Nèijiāng?” Tā lìkè bèichū qùnián yǔjì dá’àn, zhǔnbèi tiáozhěng mónǐ zhábǎn. Lǎo hégōng ànzhù tā de shǒu: “Hé měitiān dōu zài biàn, zuótiān de zhèngquè shùzì jīntiān kěnéng huì shāng tián.”',
        vietnamese: 'Thẩm Du dùng ngay đáp án mùa mưa năm trước để chia nước. Người thợ sông ngăn lại vì con sông thay đổi mỗi ngày và số đúng hôm qua có thể hại ruộng hôm nay.',
        english: 'Shen Yu reaches for last rainy season’s answer when deciding today’s diversion. A river worker stops him because yesterday’s correct number may harm fields today.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐmen xiān dào Yúzuǐ kàn Nèijiāng yǔ Wàijiāng fēnliú, zài guānchá Fēishāyàn páihóng páishā, Bǎopíngkǒu kòngzhì jìnrù Chéngdū Píngyuán de shuǐliàng. Sān bùfen méiyǒu gāobà jiéduàn héliú, ér shì jiè héshì, jìjié hé níshā biànhuà hùxiāng pèihé. Gōngchéng zhìhuì bú zài yí gè gùdìng kāiguān, ér zài chíxù pànduàn.',
        vietnamese: 'Ngư Chủy chia dòng, Phi Sa Yển xả lũ cát, Bảo Bình Khẩu kiểm soát nước. Ba phần làm việc theo thế sông, mùa và bùn cát thay vì một đập cao.',
        english: 'Yuzui divides flow, Feishayan releases flood and sediment, and Baopingkou regulates intake. The parts work with river, season, and sediment rather than one high dam.',
      ),
      ReadingAnnotation(
        pinyin: 'Shàngyóu chuánlái jiàngyǔ xìnxī, nónghù yòu bàogào bùfen tiándì réng quēshuǐ. Shěn Yú yuánběn zhǐ xiǎng xuǎn “duō” huò “shǎo”, xiànzài bìxū tóngshí kǎolǜ hóngshuǐ, níshā, guàngài hé xiàyóu ānquán. Tā qǐng hégōng, nónghù yǔ jiāncèyuán fēnbié shuōmíng zhèngjù, xiān zuò xiǎofú tiáozhěng, zài děngdài shuǐwèi huíyìng.',
        vietnamese: 'Mưa thượng nguồn và ruộng thiếu nước đòi hỏi cân nhắc lũ, bùn, tưới và an toàn hạ lưu. Cậu nghe nhiều bằng chứng, điều chỉnh nhỏ rồi chờ mực nước phản hồi.',
        english: 'Upstream rain and thirsty fields require balancing flood, sediment, irrigation, and downstream safety. He gathers evidence, makes a small adjustment, and waits for the river’s response.',
      ),
      ReadingAnnotation(
        pinyin: 'Mónǐ jiéshù, lǎoshī méiyǒu gōngbù wéiyī biāozhǔn dá’àn, zhǐ gěi tā de jìlù gàizhāng: guānchá wánzhěng, juédìng kěnì, lǐyóu qīngchu. Shěn Yú zài dá’ànlán xiěxià “jìxù kàn hé”. Dūjiāngyàn yùnxíng liǎngqiān duō nián, bìng bú shì yīnwèi gǔrén liúxià yì tiáo yǒngyuǎn bú biàn de mìnglìng, ér shì yīnwèi hòulái de rén yuànyì niánnián wéihù, cìcì chóngxīn pànduàn.',
        vietnamese: 'Giáo viên đóng dấu vì quan sát đủ, quyết định có thể đảo và lý do rõ. Thẩm Du viết “tiếp tục nhìn sông”, hiểu hệ thống sống nhờ bảo trì và phán đoán lại.',
        english: 'The teacher approves his complete observation, reversible decision, and clear reasoning. Shen Yu writes “keep watching the river,” understanding that the system survives through maintenance and renewed judgment.',
      ),
    ],
    wonderQuestion: '为什么运行中的古代工程不能只依靠固定答案，而要根据实时河势调整？',
    expressQuestion: '请用“证据—决定—等待什么反馈”写一份分水记录。',
  ),
  'chongqing-dazu-rock-carvings': EditorialStoryRevision(
    id: 'chongqing-dazu-rock-carvings',
    protagonist: '小灯',
    narrativeMode: '石刻人物排演',
    emotionalArc: '只想演神仙 → 发现普通人物 → 发生争执 → 重写主角',
    endingMode: '让无名劳动者站到舞台中央',
    sections: [
      '学校要在大足石刻前排一场小戏，小灯抢着演最显眼的神仙，却把“牧牛人、父母和劳作者”卡片塞给别人：“这些角色没法飞，也不会发光。”负责剧本的同学不服，两人在宝顶山石壁前吵起来。',
      '造像、题记和洞窟沿岩壁形成连续视觉叙事，佛教、道教和儒家思想与牧牛、孝亲、劳作等日常主题彼此靠近。小灯本来寻找宏大奇迹，却发现一组牧牛图用人的动作、牛的性情和道路变化讲出完整成长过程。',
      '排练时，他的神仙台词只有一句正确答案，反而无法推动剧情；扮牧童的同学却必须从急躁、追赶到理解和安定。小灯不甘心，仔细观察题记和人物关系，终于承认“普通生活”并不普通，它能承载信仰如何进入人的选择。',
      '正式演出中，小灯换成牧童，把最亮的灯留给全体人物最后共同出现。谢幕后，他在角色卡背面写：“没有无关紧要的人。”山崖上的思想图像没有被缩成一堂说教课，而是在孩子的争执、行动和改变中重新获得声音。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Xuéxiào yào zài Dàzú Shíkè qián pái yì chǎng xiǎoxì, Xiǎodēng qiǎngzhe yǎn zuì xiǎnyǎn de shénxiān, què bǎ “mùniúrén, fùmǔ hé láodòngzhě” kǎpiàn sāi gěi biérén: “Zhèxiē juésè méi fǎ fēi, yě bú huì fāguāng.” Fùzé jùběn de tóngxué bù fú, liǎng rén zài Bǎodǐng Shān shíbì qián chǎo qǐlái.',
        vietnamese: 'Tiểu Đăng giành vai thần tiên sáng nhất và chê người chăn bò, cha mẹ, người lao động không biết bay. Bạn viết kịch phản đối và hai em cãi nhau trước vách đá.',
        english: 'Xiaodeng grabs the brightest immortal role and dismisses herders, parents, and workers as unable to fly. The scriptwriter objects, and they argue before the carvings.',
      ),
      ReadingAnnotation(
        pinyin: 'Zàoxiàng, tíjì hé dòngkū yán yánbì xíngchéng liánxù shìjué xùshì, Fójiào, Dàojiào hé Rújiā sīxiǎng yǔ mùniú, xiàoqīn, láozuò děng rìcháng zhǔtí bǐcǐ kàojìn. Xiǎodēng běnlái xúnzhǎo hóngdà qíjì, què fāxiàn yì zǔ Mùniú Tú yòng rén de dòngzuò, niú de xìngqíng hé dàolù biànhuà jiǎngchū wánzhěng chéngzhǎng guòchéng.',
        vietnamese: 'Phật, Đạo, Nho đứng cạnh cảnh chăn bò, hiếu thảo và lao động. Tiểu Đăng thấy bộ Mục Ngưu kể quá trình trưởng thành qua động tác người, tính con bò và đường đi.',
        english: 'Buddhist, Daoist, and Confucian ideas stand beside herding, family, and labour. Xiaodeng discovers a complete growth story in the actions of a herder and an ox.',
      ),
      ReadingAnnotation(
        pinyin: 'Páiliàn shí, tā de shénxiān táicí zhǐyǒu yí jù zhèngquè dá’àn, fǎn’ér wúfǎ tuīdòng jùqíng; yǎn mùtóng de tóngxué què bìxū cóng jízào, zhuīgǎn dào lǐjiě hé āndìng. Xiǎodēng bù gānxīn, zǐxì guānchá tíjì hé rénwù guānxì, zhōngyú chéngrèn “pǔtōng shēnghuó” bìng bù pǔtōng, tā néng chéngzài xìnyǎng rúhé jìnrù rén de xuǎnzé.',
        vietnamese: 'Vai thần tiên chỉ có đáp án đúng nên không phát triển, còn mục đồng thay đổi từ nóng vội đến hiểu biết. Cậu nhận ra đời thường có thể mang tư tưởng vào lựa chọn.',
        english: 'His immortal has only a correct answer, while the herder changes from impatience to understanding. He sees that ordinary life can carry belief into human choices.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhèngshì yǎnchū zhōng, Xiǎodēng huàn chéng mùtóng, bǎ zuì liàng de dēng liúgěi quántǐ rénwù zuìhòu gòngtóng chūxiàn. Xièmù hòu, tā zài juésèkǎ bèimiàn xiě: “Méiyǒu wúguānjǐnyào de rén.” Shānyá shàng de sīxiǎng túxiàng méiyǒu bèi suō chéng yì táng shuōjiàokè, ér shì zài háizi de zhēngzhí, xíngdòng hé gǎibiàn zhōng chóngxīn huòdé shēngyīn.',
        vietnamese: 'Cậu đổi sang vai mục đồng và để ánh đèn sáng nhất cho toàn bộ nhân vật. Tấm thẻ ghi “không ai là không quan trọng”.',
        english: 'He switches to the herder and gives the brightest light to the whole cast. On his card he writes, “No person is unimportant.”',
      ),
    ],
    wonderQuestion: '为什么日常劳动和家庭关系也能成为宗教与思想艺术的重要主题？',
    expressQuestion: '请选择一个原本被忽略的角色，为他写一句推动剧情的台词。',
  ),
  'shiyan-wudang-mountains': EditorialStoryRevision(
    id: 'shiyan-wudang-mountains',
    protagonist: '林飞',
    narrativeMode: '朝山捷径考验',
    emotionalArc: '急于证明 → 选择捷径 → 失去线索 → 尊重路线',
    endingMode: '把“最快到达”改成“完整经过”',
    sections: [
      '武术社的林飞认定上武当山越快越厉害，偷偷在地图上画了一条穿林捷径，想抢在大家前到金殿。他对你说：“真正的高手不会绕远路。”可离开石阶后，宫观和山门很快被树林遮住，手机方向也不断漂移。',
      '武当山古建筑群顺峰谷和山势安排视线、礼仪空间与朝山路径，金殿、紫霄宫等并不是可以随意交换顺序的景点。木构、石质台基、排水和山路长期维护，也依赖人们使用清楚路线而不踩出新的坡面。',
      '一场短雨让林地变滑，林飞不得不停下。远处钟声从正规路线传来，他循声回到石阶，却发现同伴并没有比赛，而是在一座山门前等他讲“为什么这里要转身看山”。他第一次意识到，自己省掉的不是距离，而是建筑与自然安排好的理解过程。',
      '到达金殿时，林飞不是第一名。他把捷径从地图上擦掉，旁边写：“有些路的意义在经过，不在抢先。”下山途中，他主动走在最后，提醒后面的孩子看排水、石阶和山门怎样共同保护每一步。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Wǔshùshè de Lín Fēi rèndìng shàng Wǔdāng Shān yuè kuài yuè lìhai, tōutōu zài dìtú shàng huà le yì tiáo chuānlín jiéjìng, xiǎng qiǎng zài dàjiā qián dào Jīndiàn. Tā duì nǐ shuō: “Zhēnzhèng de gāoshǒu bú huì rào yuǎnlù.” Kě líkāi shíjiē hòu, gōngguàn hé shānmén hěn kuài bèi shùlín zhēzhù, shǒujī fāngxiàng yě bùduàn piāoyí.',
        vietnamese: 'Lâm Phi tin lên núi càng nhanh càng giỏi và đi tắt qua rừng. Rời bậc đá, cung quán bị cây che và phương hướng điện thoại liên tục lệch.',
        english: 'Lin Fei believes speed proves skill and takes a forest shortcut. Away from the stone steps, buildings disappear behind trees and his phone direction drifts.',
      ),
      ReadingAnnotation(
        pinyin: 'Wǔdāng Shān gǔjiànzhùqún shùn fēnggǔ hé shānshì ānpái shìxiàn, lǐyí kōngjiān yǔ cháoshān lùjìng, Jīndiàn, Zǐxiāo Gōng děng bìng bú shì kěyǐ suíyì jiāohuàn shùnxù de jǐngdiǎn. Mùgòu, shízhì táijī, páishuǐ hé shānlù chángqī wéihù, yě yīlài rénmen shǐyòng qīngchu lùxiàn ér bù cǎichū xīn de pōmiàn.',
        vietnamese: 'Công trình Võ Đang sắp xếp đường hành hương, nghi lễ và tầm nhìn theo núi. Lối rõ giúp bảo vệ kết cấu, thoát nước và sườn dốc.',
        english: 'Wudang architecture arranges ritual, views, and pilgrimage through the terrain. Clear routes also protect structures, drainage, and slopes.',
      ),
      ReadingAnnotation(
        pinyin: 'Yì chǎng duǎnyǔ ràng líndì biàn huá, Lín Fēi bùdébù tíngxià. Yuǎnchù zhōngshēng cóng zhèngguī lùxiàn chuánlái, tā xúnshēng huídào shíjiē, què fāxiàn tóngbàn bìng méiyǒu bǐsài, ér shì zài yí zuò shānmén qián děng tā jiǎng “wèishénme zhèlǐ yào zhuǎnshēn kàn shān”. Tā dì yí cì yìshí dào, zìjǐ shěngdiào de bú shì jùlí, ér shì jiànzhù yǔ zìrán ānpái hǎo de lǐjiě guòchéng.',
        vietnamese: 'Mưa làm đường trơn và tiếng chuông dẫn cậu trở lại. Bạn bè đang chờ ở cổng núi để hiểu vì sao phải quay nhìn, không hề đua; cậu đã bỏ qua cả quá trình nhận thức.',
        english: 'Rain and a bell lead him back. His friends are waiting at a gate to understand a designed view, not racing, and he sees that the shortcut removed the experience itself.',
      ),
      ReadingAnnotation(
        pinyin: 'Dàodá Jīndiàn shí, Lín Fēi bú shì dì yì míng. Tā bǎ jiéjìng cóng dìtú shàng cādiào, pángbiān xiě: “Yǒuxiē lù de yìyì zài jīngguò, bú zài qiǎngxiān.” Xiàshān túzhōng, tā zhǔdòng zǒu zài zuìhòu, tíxǐng hòumiàn de háizi kàn páishuǐ, shíjiē hé shānmén zěnyàng gòngtóng bǎohù měi yí bù.',
        vietnamese: 'Không đến đầu tiên, cậu xóa đường tắt và viết có con đường mang ý nghĩa ở việc đi qua. Khi xuống, cậu đi cuối để giúp người khác quan sát.',
        english: 'He arrives without winning, erases the shortcut, and writes that some roads matter through the passage itself. On the descent he walks last to guide others.',
      ),
    ],
    wonderQuestion: '为什么武当山的路线顺序也是建筑和文化意义的一部分？',
    expressQuestion: '请用“我省下了……却错过了……”写林飞对捷径的反思。',
  ),
  'longyan-fujian-tulou': EditorialStoryRevision(
    id: 'longyan-fujian-tulou',
    protagonist: '阿圆与阿方',
    narrativeMode: '共同院落宴席冲突',
    emotionalArc: '争抢空间 → 互相指责 → 理解公共结构 → 共同布置',
    endingMode: '圆桌和方桌同时容纳差异',
    sections: [
      '土楼丰收宴前，阿圆想把中央院落全部摆成圆桌，阿方却坚持方桌更整齐。两人各自用粉笔画线，圆圈和方格挤在一起，把通往水井和祖堂的路都堵住了。长辈没有替他们擦掉，只让全楼居民照常走一遍。',
      '厚重夯土墙包围中央院落，木构房间沿内侧层层展开。入口、防护墙、祖堂、水井和公共空间服务大型家族共同生活；土料配比、分层夯筑、木结构连接和屋檐排水又让建筑长期稳定。院落不是一张空白舞台。',
      '提水的奶奶绕不过去，送菜的孩子撞上桌角，行动不便的叔叔更无法到祖堂。阿圆与阿方才发现，争论圆或方之前，应先保留每个人都能使用的路线。他们请居民用脚步标出真正需要的通道，再在剩余空间混合两种桌形。',
      '宴席开始，圆桌方便分享大盘菜，方桌让作业和手工展示更稳。两人没有选出赢家，却把粉笔线留下一小段，提醒明年先听谁要经过。土楼之所以像一个家，不是所有人都一样，而是公共空间愿意为差异重新安排。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Tǔlóu fēngshōuyàn qián, Ā Yuán xiǎng bǎ zhōngyāng yuànluò quánbù bǎi chéng yuánzhuō, Ā Fāng què jiānchí fāngzhuō gèng zhěngqí. Liǎng rén gèzì yòng fěnbǐ huàxiàn, yuánquān hé fānggé jǐ zài yìqǐ, bǎ tōngwǎng shuǐjǐng hé zǔtáng de lù dōu dǔzhù le. Zhǎngbèi méiyǒu tì tāmen cādiào, zhǐ ràng quán lóu jūmín zhàocháng zǒu yí biàn.',
        vietnamese: 'A Viên muốn toàn bàn tròn, A Phương muốn bàn vuông. Đường phấn chặn lối đến giếng và từ đường, nên người lớn bảo cư dân cứ thử đi như thường.',
        english: 'Ayuan wants round tables and Afang wants square ones. Their chalk layout blocks the well and ancestral hall, so elders ask residents to try moving through it.',
      ),
      ReadingAnnotation(
        pinyin: 'Hòuzhòng hāngtǔqiáng bāowéi zhōngyāng yuànluò, mùgòu fángjiān yán nèicè céngcéng zhǎnkāi. Rùkǒu, fánghùqiáng, zǔtáng, shuǐjǐng hé gōnggòng kōngjiān fúwù dàxíng jiāzú gòngtóng shēnghuó; tǔliào pèibǐ, fēncéng hāngzhù, mùjiégòu liánjiē hé wūyán páishuǐ yòu ràng jiànzhù chángqī wěndìng. Yuànluò bú shì yì zhāng kòngbái wǔtái.',
        vietnamese: 'Tường đất nện, phòng gỗ, giếng, từ đường và không gian chung phục vụ đời sống đại gia đình. Sân không phải một sân khấu trống để sắp tùy ý.',
        english: 'Rammed-earth walls, timber rooms, well, hall, and shared space serve a large family. The courtyard is not an empty stage to arrange without consequence.',
      ),
      ReadingAnnotation(
        pinyin: 'Tíshuǐ de nǎinai ràobuguòqù, sòngcài de háizi zhuàngshàng zhuōjiǎo, xíngdòng bùbiàn de shūshu gèng wúfǎ dào zǔtáng. Ā Yuán yǔ Ā Fāng cái fāxiàn, zhēnglùn yuán huò fāng zhīqián, yīng xiān bǎoliú měi gè rén dōu néng shǐyòng de lùxiàn. Tāmen qǐng jūmín yòng jiǎobù biāochū zhēnzhèng xūyào de tōngdào, zài zài shèngyú kōngjiān hùnhé liǎng zhǒng zhuōxíng.',
        vietnamese: 'Người lấy nước, trẻ giao thức ăn và chú khó đi đều bị cản. Hai em đánh dấu lối theo bước chân cư dân rồi mới trộn bàn tròn và vuông.',
        english: 'Water carriers, food runners, and a relative with limited mobility cannot pass. The children mark real paths first, then mix round and square tables in the remaining space.',
      ),
      ReadingAnnotation(
        pinyin: 'Yànxí kāishǐ, yuánzhuō fāngbiàn fēnxiǎng dàpáncài, fāngzhuō ràng zuòyè hé shǒugōng zhǎnshì gèng wěn. Liǎng rén méiyǒu xuǎnchū yíngjiā, què bǎ fěnbǐxiàn liúxià yí xiǎo duàn, tíxǐng míngnián xiān tīng shéi yào jīngguò. Tǔlóu zhīsuǒyǐ xiàng yí gè jiā, bú shì suǒyǒu rén dōu yíyàng, ér shì gōnggòng kōngjiān yuànyì wèi chāyì chóngxīn ānpái.',
        vietnamese: 'Bàn tròn chia món, bàn vuông giữ đồ học và thủ công. Không ai thắng; đoạn phấn còn lại nhắc năm sau phải nghe ai cần đi qua trước.',
        english: 'Round tables share dishes and square tables support schoolwork and crafts. No one wins; a chalk mark reminds them to ask who needs passage first.',
      ),
    ],
    wonderQuestion: '共同生活的建筑为什么必须先考虑不同人的通行和使用需要？',
    expressQuestion: '请写一段两个人意见不同、最后保留双方优点的对话。',
  ),
  'shenyang-imperial-palace': EditorialStoryRevision(
    id: 'shenyang-imperial-palace',
    protagonist: '小北',
    narrativeMode: '建筑卡片归类失败',
    emotionalArc: '急于分类 → 发现混合 → 放弃硬标签 → 建立关系图',
    endingMode: '从“属于谁”转向“怎样相遇”',
    sections: [
      '小北参加宫殿建筑比赛，要把大政殿、十王亭和宫院卡片分成“满族、汉族、蒙古族”三堆。他信心十足，认为每张卡只能有一个答案。走进沈阳故宫后，第一张卡就让他和同伴争了起来。',
      '宫殿见证清朝早期在盛京的发展，建筑尺度比北京故宫紧凑，空间秩序却清晰。大政殿与十王亭的组合、宫院布局和装饰同时反映不同传统的交流，单个元素进入整体后也会获得新的用途。',
      '小北试图给每根柱子和屋顶贴上单一标签，卡片越分越乱。老师让他改画箭头：哪些形式彼此影响，哪些适应寒冷气候，哪些服务礼仪与政治活动。三堆卡逐渐变成一张交错关系图。',
      '比赛评委问哪一种传统最重要，小北没有选。他举起关系图说：“如果只留下一个颜色，这座宫殿就不再是现在的沈阳故宫。”离开时，他把空白卡留在图中央，准备以后补上城市居民怎样继续理解盛京与今天的连接。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Xiǎoběi cānjiā gōngdiàn jiànzhù bǐsài, yào bǎ Dàzhèng Diàn, Shíwáng Tíng hé gōngyuàn kǎpiàn fēn chéng “Mǎnzú, Hànzú, Měnggǔzú” sān duī. Tā xìnxīn shízú, rènwéi měi zhāng kǎ zhǐ néng yǒu yí gè dá’àn. Zǒujìn Shěnyáng Gùgōng hòu, dì yì zhāng kǎ jiù ràng tā hé tóngbàn zhēng le qǐlái.',
        vietnamese: 'Tiểu Bắc định chia thẻ Đại Chính Điện, Thập Vương Đình và cung viện thành ba nhóm Mãn, Hán, Mông. Cậu tin mỗi thẻ chỉ có một đáp án, nhưng thẻ đầu đã gây tranh luận.',
        english: 'Xiaobei plans to sort palace cards into Manchu, Han, and Mongol piles, believing each has one answer. The first card immediately causes disagreement.',
      ),
      ReadingAnnotation(
        pinyin: 'Gōngdiàn jiànzhèng Qīngcháo zǎoqī zài Shèngjīng de fāzhǎn, jiànzhù chǐdù bǐ Běijīng Gùgōng jǐncòu, kōngjiān zhìxù què qīngxī. Dàzhèng Diàn yǔ Shíwáng Tíng de zǔhé, gōngyuàn bùjú hé zhuāngshì tóngshí fǎnyìng bùtóng chuántǒng de jiāoliú, dāngè yuánsù jìnrù zhěngtǐ hòu yě huì huòdé xīn de yòngtú.',
        vietnamese: 'Cung điện Thịnh Kinh có quy mô gọn và trật tự rõ, với bố cục, trang trí phản ánh nhiều truyền thống giao lưu và đổi công dụng trong tổng thể.',
        english: 'The compact but ordered Shengjing palace combines layouts and decoration from several traditions, whose elements gain new roles in the whole.',
      ),
      ReadingAnnotation(
        pinyin: 'Xiǎoběi shìtú gěi měi gēn zhùzi hé wūdǐng tiēshàng dānyī biāoqiān, kǎpiàn yuè fēn yuè luàn. Lǎoshī ràng tā gǎi huà jiàntóu: nǎxiē xíngshì bǐcǐ yǐngxiǎng, nǎxiē shìyìng hánlěng qìhòu, nǎxiē fúwù lǐyí yǔ zhèngzhì huódòng. Sān duī kǎ zhújiàn biàn chéng yì zhāng jiāocuò guānxì tú.',
        vietnamese: 'Dán nhãn đơn làm thẻ càng rối. Giáo viên yêu cầu vẽ mũi tên giữa ảnh hưởng, khí hậu, nghi lễ và chính trị, biến ba đống thành mạng quan hệ.',
        english: 'Single labels make the cards more confused. Arrows showing influence, climate, ritual, and politics turn three piles into a network.',
      ),
      ReadingAnnotation(
        pinyin: 'Bǐsài píngwěi wèn nǎ yì zhǒng chuántǒng zuì zhòngyào, Xiǎoběi méiyǒu xuǎn. Tā jǔqǐ guānxì tú shuō: “Rúguǒ zhǐ liúxià yí gè yánsè, zhè zuò gōngdiàn jiù bú zài shì xiànzài de Shěnyáng Gùgōng.” Líkāi shí, tā bǎ kòngbái kǎ liú zài tú zhōngyāng, zhǔnbèi yǐhòu bǔshàng chéngshì jūmín zěnyàng jìxù lǐjiě Shèngjīng yǔ jīntiān de liánjiē.',
        vietnamese: 'Cậu không chọn truyền thống quan trọng nhất, vì chỉ giữ một màu sẽ không còn là cung điện hiện tại. Thẻ trống dành cho cách cư dân tiếp tục hiểu mối nối Thịnh Kinh và hôm nay.',
        english: 'He refuses to name one most important tradition, because one colour alone would no longer be the present palace. A blank card remains for how residents continue connecting Shengjing and today.',
      ),
    ],
    wonderQuestion: '为什么建筑中的文化交流更适合用关系图，而不是用单一标签归类？',
    expressQuestion: '请用“来自……进入……以后……”说明一个文化元素怎样获得新意义。',
  ),
};
