import 'special_journey_story_enrichment.dart';

/// Journey-specific expansion material for the five Special Journeys added by
/// the expansion batch. Each packet extends the original literary mechanism,
/// relationship, choice, consequence and memory residue instead of applying
/// generic heritage filler.
List<SpecialJourneyEnrichmentText> specialJourneyExpansionBatchOneEnrichmentFor(
  String journeyId,
) => switch (journeyId) {
      'changan-last-bus' => _changanLastBus,
      'tide-letter' => _tideLetter,
      'arcade-lost-property' => _arcadeLostProperty,
      'tea-horse-echo' => _teaHorseEcho,
      'ice-city-star-map' => _iceCityStarMap,
      _ => const <SpecialJourneyEnrichmentText>[],
    };

const _changanLastBus = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '雨水沿着末班车的车窗往下流，铜镜里却没有车厢的倒影，只有一条比夜色更旧的长安街和一个始终没有下车的人影。你第一次明白，车票不是邀请你去另一个时代，而是在等一个迟到百年的归还。',
    pinyin: 'Yǔshuǐ yánzhe mòbānchē de chēchuāng wǎng xià liú, tóngjìng lǐ què méiyǒu chēxiāng de dàoyǐng, zhǐyǒu yì tiáo bǐ yèsè gèng jiǔ de Chángān jiē hé yí ge shǐzhōng méiyǒu xiàchē de rényǐng. Nǐ dì yí cì míngbai, chēpiào bú shì yāoqǐng nǐ qù lìng yí ge shídài, ér shì zài děng yí ge chídào bǎinián de guīhuán.',
    vietnamese: 'Mưa chảy dọc cửa kính chuyến xe cuối, nhưng trong gương đồng không có bóng khoang xe, chỉ có một con phố Trường An cũ hơn màn đêm và một người mãi chưa xuống xe. Bạn hiểu tấm vé không mời mình sang thời đại khác mà đang chờ một lần hoàn trả muộn một thế kỷ.',
    english: 'Rain runs down the last bus window, yet the bronze mirror reflects no carriage, only an older Changan street and a passenger who never got off. The ticket is not an invitation to another era but a return delayed by a century.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '老人不肯说自己的名字，只反复问“家到了没有”。每经过一个现代路口，镜中的牌坊就少一座；你越想用今天的地图回答，越发现他的“家”并不是可以搜索的地址，而是一段已经被城市改写的关系。',
    pinyin: 'Lǎorén bù kěn shuō zìjǐ de míngzi, zhǐ fǎnfù wèn “jiā dào le méiyǒu”. Měi jīngguò yí ge xiàndài lùkǒu, jìng zhōng de páifāng jiù shǎo yí zuò; nǐ yuè xiǎng yòng jīntiān de dìtú huídá, yuè fāxiàn tā de “jiā” bìng bú shì kěyǐ sōusuǒ de dìzhǐ, ér shì yí duàn yǐjīng bèi chéngshì gǎixiě de guānxì.',
    vietnamese: 'Ông lão không chịu nói tên, chỉ hỏi mãi “đã tới nhà chưa”. Mỗi khi xe qua một ngã tư hiện đại, trong gương lại mất một cổng cổ. Bạn càng dùng bản đồ hôm nay để trả lời càng hiểu “nhà” của ông không phải địa chỉ có thể tìm kiếm mà là một mối quan hệ đã bị thành phố viết lại.',
    english: 'The old passenger refuses his name and keeps asking whether home has arrived. Each modern intersection erases another archway in the mirror, revealing that his home is not a searchable address but a relationship rewritten by the city.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '司机提醒终点站已经到了，你却看见老人把那张旧车票压在掌心，像害怕一松手就会再次错过归途。留下陪他意味着错过自己的换乘，催他下车又等于替一个陌生人决定什么才算回家。',
    pinyin: 'Sījī tíxǐng zhōngdiǎnzhàn yǐjīng dào le, nǐ què kànjiàn lǎorén bǎ nà zhāng jiù chēpiào yā zài zhǎngxīn, xiàng hàipà yì sōngshǒu jiù huì zàicì cuòguò guītú. Liúxià péi tā yìwèizhe cuòguò zìjǐ de huànchéng, cuī tā xiàchē yòu děngyú tì yí ge mòshēngrén juédìng shénme cái suàn huíjiā.',
    vietnamese: 'Tài xế báo đã tới bến cuối, nhưng ông lão ép tấm vé cũ trong lòng bàn tay như sợ buông ra sẽ lỡ đường về lần nữa. Ở lại với ông khiến bạn lỡ chuyến nối, còn thúc ông xuống xe lại là tự quyết định thay một người xa lạ thế nào mới gọi là về nhà.',
    english: 'At the terminus the old man grips the ticket as if releasing it would lose home again. Staying costs your connection, while forcing him off would mean deciding for a stranger what home is supposed to mean.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你没有把老人拉出车门，而是把车票放回铜镜前，让镜中的旧街自己完成最后一段路。铜面像水一样晃动时，老人终于不再问“到了没有”，只向你点了一次头，然后和那条旧长安街一起淡下去。',
    pinyin: 'Nǐ méiyǒu bǎ lǎorén lā chū chēmén, ér shì bǎ chēpiào fàng huí tóngjìng qián, ràng jìng zhōng de jiù jiē zìjǐ wánchéng zuìhòu yí duàn lù. Tóngmiàn xiàng shuǐ yíyàng huàngdòng shí, lǎorén zhōngyú bú zài wèn “dào le méiyǒu”, zhǐ xiàng nǐ diǎn le yí cì tóu, ránhòu hé nà tiáo jiù Chángān jiē yìqǐ dàn xiàqù.',
    vietnamese: 'Bạn không kéo ông lão ra khỏi xe mà đặt tấm vé trở lại trước gương đồng, để con phố cũ trong gương tự hoàn thành quãng đường cuối. Khi mặt đồng lay như nước, ông không hỏi nữa, chỉ gật đầu một lần rồi nhạt dần cùng Trường An cũ.',
    english: 'You do not drag the passenger through the door. You return the ticket to the bronze mirror and let the old street finish the route. As the bronze ripples, he stops asking and fades with old Changan after one nod.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '车厢恢复普通以后，你发现手机上的末班车时刻已经过去，自己必须在雨里走很长一段路。这个代价没有换来答案：你仍不知道老人是谁，却知道真正完成的不是一次灵异解谜，而是一次没有占有对方故事的送还。',
    pinyin: 'Chēxiāng huīfù pǔtōng yǐhòu, nǐ fāxiàn shǒujī shàng de mòbānchē shíkè yǐjīng guòqù, zìjǐ bìxū zài yǔ lǐ zǒu hěn cháng yí duàn lù. Zhège dàijià méiyǒu huànlái dáàn: nǐ réng bù zhīdào lǎorén shì shéi, què zhīdào zhēnzhèng wánchéng de bú shì yí cì língyì jiěmí, ér shì yí cì méiyǒu zhànyǒu duìfāng gùshi de sònghuán.',
    vietnamese: 'Khi khoang xe trở lại bình thường, chuyến nối cuối đã qua và bạn phải đi bộ rất xa trong mưa. Cái giá ấy không đổi lấy danh tính ông lão. Điều hoàn tất không phải một câu đố ma quái mà là một lần trao trả câu chuyện mà không chiếm hữu nó.',
    english: 'When the carriage becomes ordinary, your final connection is gone and you face a long walk in rain. The cost buys no identity. What you completed was not a supernatural puzzle but a return that did not claim ownership of another persons story.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '天快亮时，你回头看见末班车转过街角，铜镜已经没有任何异常。口袋里只剩一张被雨水打湿的新车票，它提醒你：城市可以换路名、换站点、换天际线，但“把未完成的归还交回去”本身也能成为记忆。',
    pinyin: 'Tiān kuài liàng shí, nǐ huítóu kànjiàn mòbānchē zhuǎnguò jiējiǎo, tóngjìng yǐjīng méiyǒu rènhé yìcháng. Kǒudài lǐ zhǐ shèng yì zhāng bèi yǔshuǐ dǎshī de xīn chēpiào, tā tíxǐng nǐ: chéngshì kěyǐ huàn lùmíng, huàn zhàndiǎn, huàn tiānjìxiàn, dàn “bǎ wèi wánchéng de guīhuán jiāo huíqu” běnshēn yě néng chéngwéi jìyì.',
    vietnamese: 'Gần sáng, bạn nhìn chuyến xe cuối khuất ở góc phố, chiếc gương đồng hoàn toàn bình thường. Chỉ còn tấm vé mới ướt mưa trong túi, nhắc rằng thành phố có thể đổi tên đường, bến và đường chân trời, nhưng việc trao trả điều chưa hoàn tất cũng có thể trở thành ký ức.',
    english: 'Near dawn the last bus turns the corner and the mirror is ordinary. A rain-soaked new ticket remains in your pocket, a memory that cities may change names, stops and skylines while the act of returning unfinished things can endure.',
  ),
];

const _tideLetter = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '停电后的海边只有应急灯和收音机的绿点还亮着。二十年前的天气报告从噪声里重新出现，播报的风向、潮位和今天几乎相同，却在提到那艘渡船时突然断掉，像一封故意没有写完的信。',
    pinyin: 'Tíngdiàn hòu de hǎibiān zhǐyǒu yìngjídēng hé shōuyīnjī de lǜdiǎn hái liàngzhe. Èrshí nián qián de tiānqì bàogào cóng zàoshēng lǐ chóngxīn chūxiàn, bōbào de fēngxiàng, cháowèi hé jīntiān jīhū xiāngtóng, què zài tídào nà sōu dùchuán shí tūrán duàndiào, xiàng yì fēng gùyì méiyǒu xiěwán de xìn.',
    vietnamese: 'Sau khi mất điện, bờ biển chỉ còn đèn khẩn cấp và chấm xanh của radio. Bản tin thời tiết hai mươi năm trước trở lại trong nhiễu sóng với gió và thủy triều gần giống hôm nay, rồi đột ngột đứt khi nhắc đến chiếc phà, như một lá thư cố ý bỏ dở.',
    english: 'After the blackout only emergency lamps and the radios green dot remain. A weather report from twenty years ago returns through static, matching todays wind and tide before breaking off at the ferry like a deliberately unfinished letter.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你认出录音里母亲年轻时的声音，却没有立刻告诉她。她站在窗边听潮，先问的也不是“是不是我”，而是“那天有没有人等到船回来”。这个问题把一段私人记忆和整个海湾的等待绑在一起。',
    pinyin: 'Nǐ rènchū lùyīn lǐ mǔqīn niánqīng shí de shēngyīn, què méiyǒu lìkè gàosu tā. Tā zhàn zài chuāngbiān tīng cháo, xiān wèn de yě bú shì “shì bú shì wǒ”, ér shì “nà tiān yǒu méiyǒu rén děng dào chuán huílái”. Zhège wèntí bǎ yí duàn sīrén jìyì hé zhěnggè hǎiwān de děngdài bǎng zài yìqǐ.',
    vietnamese: 'Bạn nhận ra giọng mẹ thời trẻ trong bản ghi nhưng chưa nói ngay. Bà đứng bên cửa sổ nghe thủy triều và hỏi trước tiên không phải “có phải mẹ không” mà là “hôm ấy có ai chờ được phà trở về không”. Câu hỏi nối ký ức riêng với sự chờ đợi của cả vịnh.',
    english: 'You recognize your mothers younger voice but do not announce it. Listening to the tide, she asks not whether the voice is hers but whether anyone waited long enough for the ferry to return, joining private memory to the bays waiting.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '无名信里只写着潮汐时间，没有解释谁寄出、谁失约。你本来可以继续调频，追那句消失的结尾；母亲却把手放在旋钮旁没有动，像在承认有些缺口不是技术故障，而是当年的人主动留下的沉默。',
    pinyin: 'Wúmíng xìn lǐ zhǐ xiězhe cháoxī shíjiān, méiyǒu jiěshì shéi jìchū, shéi shīyuē. Nǐ běnlái kěyǐ jìxù tiáopín, zhuī nà jù xiāoshī de jiéwěi; mǔqīn què bǎ shǒu fàng zài xuánniǔ páng méiyǒu dòng, xiàng zài chéngrèn yǒuxiē quēkǒu bú shì jìshù gùzhàng, ér shì dāngnián de rén zhǔdòng liúxià de chénmò.',
    vietnamese: 'Lá thư vô danh chỉ ghi giờ thủy triều, không nói ai gửi hay ai lỡ hẹn. Bạn có thể tiếp tục dò tần số để săn câu cuối biến mất, nhưng mẹ đặt tay cạnh núm vặn mà không xoay, như thừa nhận một số khoảng trống không phải lỗi kỹ thuật mà là sự im lặng người xưa cố ý để lại.',
    english: 'The unsigned letter lists only tide times, not sender or broken promise. You could keep tuning for the missing ending, but your mother leaves the dial untouched, accepting that some gaps are deliberate silences rather than technical faults.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '当备用电快耗尽，你选择不再追旧频率，而按下录音键，记录此刻的潮声、风声和母亲一句很短的“今天我们在这里”。你失去了继续寻找旧答案的最后几分钟，却把现在从过去的回声里分了出来。',
    pinyin: 'Dāng bèiyòngdiàn kuài hàojìn, nǐ xuǎnzé bú zài zhuī jiù pínlǜ, ér ànxià lùyīnjiàn, jìlù cǐkè de cháoshēng, fēngshēng hé mǔqīn yí jù hěn duǎn de “jīntiān wǒmen zài zhèlǐ”. Nǐ shīqù le jìxù xúnzhǎo jiù dáàn de zuìhòu jǐ fēnzhōng, què bǎ xiànzài cóng guòqù de huíshēng lǐ fēn le chūlái.',
    vietnamese: 'Khi pin dự phòng gần cạn, bạn thôi đuổi tần số cũ và bấm ghi âm, lưu tiếng triều, tiếng gió cùng câu ngắn của mẹ: “hôm nay chúng ta ở đây”. Bạn mất những phút cuối có thể tìm đáp án cũ nhưng tách được hiện tại khỏi tiếng vọng quá khứ.',
    english: 'As backup power fades, you stop chasing the old frequency and record the present tide, wind and your mothers brief words: today we are here. You lose the final minutes for an old answer but separate the present from the echo of the past.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '来电以后，收音机恢复普通节目，那段二十年前的声音再也调不出来。母亲没有要求重放，她把无名信折好放回抽屉，只留下你刚录下的新文件；这让“记住”不再等于把过去补成完整故事。',
    pinyin: 'Láidiàn yǐhòu, shōuyīnjī huīfù pǔtōng jiémù, nà duàn èrshí nián qián de shēngyīn zài yě tiáo bù chūlái. Mǔqīn méiyǒu yāoqiú chóngfàng, tā bǎ wúmíng xìn zhéhǎo fàng huí chōuti, zhǐ liúxià nǐ gāng lùxià de xīn wénjiàn; zhè ràng “jìzhù” bú zài děngyú bǎ guòqù bǔ chéng wánzhěng gùshi.',
    vietnamese: 'Khi điện trở lại, radio chỉ còn chương trình bình thường và giọng nói hai mươi năm trước không thể dò lại. Mẹ không yêu cầu phát lại, gấp thư cất vào ngăn kéo và chỉ giữ bản ghi mới. “Ghi nhớ” từ đó không còn có nghĩa phải vá quá khứ thành một câu chuyện hoàn chỉnh.',
    english: 'When power returns, the old voice cannot be tuned again. Your mother folds the unsigned letter away and keeps only the new recording, making memory something other than forcing the past into a complete story.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '清晨潮水退去，你在新录音的结尾听见远处渡船的汽笛，却没有把它解释成旧故事的证明。它只是今天的船经过今天的海面，而你和母亲终于允许同一片潮声同时保存失去、沉默和仍在继续的生活。',
    pinyin: 'Qīngchén cháoshuǐ tuìqù, nǐ zài xīn lùyīn de jiéwěi tīngjiàn yuǎnchù dùchuán de qìdí, què méiyǒu bǎ tā jiěshì chéng jiù gùshi de zhèngmíng. Tā zhǐ shì jīntiān de chuán jīngguò jīntiān de hǎimiàn, ér nǐ hé mǔqīn zhōngyú yǔnxǔ tóng yí piàn cháoshēng tóngshí bǎocún shīqù, chénmò hé réng zài jìxù de shēnghuó.',
    vietnamese: 'Lúc triều rút vào sáng sớm, cuối bản ghi mới có tiếng còi phà xa xa, nhưng bạn không biến nó thành bằng chứng cho chuyện cũ. Đó chỉ là con phà hôm nay đi qua mặt biển hôm nay, còn bạn và mẹ cho phép cùng một tiếng triều giữ cả mất mát, im lặng và đời sống vẫn tiếp tục.',
    english: 'At low tide a distant ferry horn appears at the end of the new recording, but you do not treat it as proof of the old story. It is todays ferry on todays sea, allowing loss, silence and continuing life to share the same tide.',
  ),
];

const _arcadeLostProperty = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '暴雨把骑楼下的人都挤到同一条干燥的边线上，你在失物架上看见那把红伞时，它的伞骨还滴着水，却没有任何人来认领。伞柄上的旧号码牌指向一间早已换了招牌的店，失物因此先变成了街区记忆的入口。',
    pinyin: 'Bàoyǔ bǎ qílóu xià de rén dōu jǐ dào tóng yì tiáo gānzào de biānxiàn shàng, nǐ zài shīwùjià shàng kànjiàn nà bǎ hóngsǎn shí, tā de sǎngǔ hái dīzhe shuǐ, què méiyǒu rènhé rén lái rènlǐng. Sǎnbǐng shàng de jiù hàomǎpái zhǐxiàng yì jiān zǎoyǐ huàn le zhāopái de diàn, shīwù yīncǐ xiān biànchéng le jiēqū jìyì de rùkǒu.',
    vietnamese: 'Mưa lớn dồn mọi người dưới hành lang kỵ lâu vào cùng một dải khô. Chiếc ô đỏ trên kệ đồ thất lạc vẫn nhỏ nước nhưng không ai tới nhận. Thẻ số cũ ở cán ô dẫn tới một cửa hàng đã đổi biển từ lâu, khiến món đồ thất lạc trở thành lối vào ký ức khu phố.',
    english: 'A storm compresses everyone beneath the arcade onto one dry strip. The red umbrella on the lost-property rack still drips, while its old number points to a shop whose sign has long changed, turning a lost object into an entrance to neighborhood memory.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你沿着连续的骑楼寻找号码对应的位置，老人、店员和送货员给出的答案都不同：有人记得卖布，有人记得修表，还有人只记得每次下雨会把椅子往里搬。没有一个版本足以证明红伞属于谁。',
    pinyin: 'Nǐ yánzhe liánxù de qílóu xúnzhǎo hàomǎ duìyìng de wèizhi, lǎorén, diànyuán hé sònghuòyuán gěichū de dáàn dōu bùtóng: yǒurén jìde mài bù, yǒurén jìde xiū biǎo, hái yǒurén zhǐ jìde měicì xiàyǔ huì bǎ yǐzi wǎng lǐ bān. Méiyǒu yí ge bǎnběn zúyǐ zhèngmíng hóngsǎn shǔyú shéi.',
    vietnamese: 'Bạn đi dọc dãy kỵ lâu tìm vị trí của số cũ, nhưng người già, nhân viên và người giao hàng nhớ khác nhau: người nhớ tiệm vải, người nhớ sửa đồng hồ, người chỉ nhớ mỗi lần mưa phải kéo ghế vào trong. Không phiên bản nào đủ chứng minh ô đỏ thuộc về ai.',
    english: 'Following the arcade, you receive incompatible memories: cloth shop, watch repair, chairs moved inward whenever it rained. No version is enough to prove who owns the red umbrella.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '一名女孩说伞可能属于她已去世的外婆，因为照片里有同样的红色；她却拿不出号码、日期或其他细节。你很想让寻找有一个温暖结局，但把相似当成证明，会让失物制度变成替人制造记忆。',
    pinyin: 'Yì míng nǚhái shuō sǎn kěnéng shǔyú tā yǐ qùshì de wàipó, yīnwèi zhàopiàn lǐ yǒu tóngyàng de hóngsè; tā què ná bù chū hàomǎ, rìqī huò qítā xìjié. Nǐ hěn xiǎng ràng xúnzhǎo yǒu yí ge wēnnuǎn jiéjú, dàn bǎ xiāngsì dàng chéng zhèngmíng, huì ràng shīwù zhìdù biànchéng tì rén zhìzào jìyì.',
    vietnamese: 'Một cô gái nói chiếc ô có thể của bà ngoại đã mất vì trong ảnh có màu đỏ giống vậy, nhưng không có số, ngày hay chi tiết khác. Bạn muốn cuộc tìm kiếm có kết thúc ấm áp, song biến sự giống nhau thành bằng chứng sẽ khiến quy trình đồ thất lạc thành nơi bịa ký ức thay người khác.',
    english: 'A girl thinks the umbrella was her late grandmothers because an old photo shows the same red, but she has no number or date. A warm ending is tempting, yet treating resemblance as proof would make lost-property work manufacture memory for someone else.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你决定不把红伞交给最动人的故事，而把所有不同证词连同“不足以确认”一起记录。这个选择让女孩失望，也让你失去快速结案的机会，却保住了她可以继续怀念外婆而不必把怀念绑在一件未经证实的物品上。',
    pinyin: 'Nǐ juédìng bù bǎ hóngsǎn jiāo gěi zuì dòngrén de gùshi, ér bǎ suǒyǒu bùtóng zhèngcí liántóng “bù zúyǐ quèrèn” yìqǐ jìlù. Zhège xuǎnzé ràng nǚhái shīwàng, yě ràng nǐ shīqù kuàisù jiéàn de jīhuì, què bǎozhù le tā kěyǐ jìxù huáiniàn wàipó ér bú bì bǎ huáiniàn bǎng zài yí jiàn wèijīng zhèngshí de wùpǐn shàng.',
    vietnamese: 'Bạn quyết định không trao ô cho câu chuyện cảm động nhất mà ghi tất cả lời kể cùng kết luận “chưa đủ xác nhận”. Cô gái thất vọng và bạn mất cơ hội khép hồ sơ nhanh, nhưng cô vẫn có thể nhớ bà mà không phải buộc nỗi nhớ vào một vật chưa được chứng minh.',
    english: 'You do not award the umbrella to the most moving story. You record every account with the conclusion not enough to confirm. It disappoints the girl and delays closure, but protects her memory from being bound to an unverified object.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '雨停后，红伞仍留在骑楼失物架上，旁边多了一张写着多种记忆的卡片。路过的人不再只问“是谁的”，也开始辨认旧店铺、旧雨季和共同使用的檐下空间；失物没有被强行解决，却让街区的关系变得更可见。',
    pinyin: 'Yǔ tíng hòu, hóngsǎn réng liú zài qílóu shīwùjià shàng, pángbiān duō le yì zhāng xiězhe duō zhǒng jìyì de kǎpiàn. Lùguò de rén bú zài zhǐ wèn “shì shéi de”, yě kāishǐ biànrèn jiù diànpù, jiù yǔjì hé gòngtóng shǐyòng de yánxià kōngjiān; shīwù méiyǒu bèi qiángxíng jiějué, què ràng jiēqū de guānxì biàn de gèng kějiàn.',
    vietnamese: 'Sau mưa, ô đỏ vẫn trên kệ dưới kỵ lâu, cạnh đó có thẻ ghi nhiều ký ức khác nhau. Người qua đường không chỉ hỏi “của ai” mà còn nhận ra tiệm cũ, mùa mưa cũ và khoảng mái hiên dùng chung. Món thất lạc chưa bị ép giải quyết nhưng quan hệ khu phố trở nên rõ hơn.',
    english: 'After the rain the red umbrella remains on the arcade rack beside a card holding several memories. Passersby begin noticing old shops, rainy seasons and shared shelter. The object stays unresolved, but neighborhood relationships become more visible.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '关门前你把伞的位置拍进当天记录，却没有拍成“团圆照”。照片里最重要的是空着的认领栏和向远处连续伸展的骑楼：一个城市有时不是靠给每件旧物找到主人保存记忆，而是靠诚实标记我们还不知道什么。',
    pinyin: 'Guānmén qián nǐ bǎ sǎn de wèizhi pāi jìn dāngtiān jìlù, què méiyǒu pāi chéng “tuányuán zhào”. Zhàopiàn lǐ zuì zhòngyào de shì kōngzhe de rènlǐnglán hé xiàng yuǎnchù liánxù shēnzhǎn de qílóu: yí ge chéngshì yǒushí bú shì kào gěi měi jiàn jiùwù zhǎodào zhǔrén bǎocún jìyì, ér shì kào chéngshí biāojì wǒmen hái bù zhīdào shénme.',
    vietnamese: 'Trước khi đóng cửa, bạn chụp vị trí chiếc ô vào hồ sơ ngày hôm đó nhưng không biến nó thành “ảnh đoàn tụ”. Quan trọng nhất là ô người nhận còn trống và dãy kỵ lâu kéo dài: đôi khi thành phố giữ ký ức không phải bằng cách tìm chủ cho mọi vật cũ mà bằng cách đánh dấu trung thực điều ta chưa biết.',
    english: 'Before closing you photograph the umbrella without turning it into a reunion portrait. The empty claimant field and continuous arcade matter most: a city can preserve memory by honestly marking what remains unknown rather than assigning every old object an owner.',
  ),
];

const _teaHorseEcho = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '你把录音机带上茶马古道，本来只想收集马铃和脚步声，却在空无一人的转弯处录到一支看不见的马帮。声音不是完整的传说：有人咳嗽、有人争论路况、有人笑着抱怨鞋底进水，普通生活反而比英雄故事更清楚。',
    pinyin: 'Nǐ bǎ lùyīnjī dài shàng Chámǎ Gǔdào, běnlái zhǐ xiǎng shōují mǎlíng hé jiǎobùshēng, què zài kōngwú yì rén de zhuǎnwān chù lù dào yì zhī kànbujiàn de mǎbāng. Shēngyīn bú shì wánzhěng de chuánshuō: yǒurén késou, yǒurén zhēnglùn lùkuàng, yǒurén xiàozhe bàoyuàn xiédǐ jìnshuǐ, pǔtōng shēnghuó fǎn'ér bǐ yīngxióng gùshi gèng qīngchu.',
    vietnamese: 'Bạn mang máy ghi âm lên Trà Mã Cổ Đạo để thu tiếng chuông ngựa và bước chân, nhưng ở một khúc cua vắng lại ghi được một đoàn ngựa vô hình. Đó không phải truyền thuyết trọn vẹn: có tiếng ho, cãi đường, cười vì giày ướt. Đời thường rõ hơn chuyện anh hùng.',
    english: 'You bring a recorder to the Tea Horse Road for bells and footsteps, then capture an invisible caravan at an empty bend. Coughs, route arguments and wet-shoe complaints are clearer than heroic legend, making ordinary lives the roads strongest echo.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '村里的老人听完录音，没有问“鬼是谁”，而指出其中一段铃声对应旧支路的坡度。那条支路后来因落石少有人走，地图上也越来越淡。声音因此从奇闻变成一种空间证据，却仍不能证明每个说话人的身份。',
    pinyin: 'Cūn lǐ de lǎorén tīngwán lùyīn, méiyǒu wèn “guǐ shì shéi”, ér zhǐchū qízhōng yí duàn língshēng duìyìng jiù zhīlù de pōdù. Nà tiáo zhīlù hòulái yīn luòshí shǎo yǒurén zǒu, dìtú shàng yě yuèláiyuè dàn. Shēngyīn yīncǐ cóng qíwén biànchéng yì zhǒng kōngjiān zhèngjù, què réng bù néng zhèngmíng měi ge shuōhuàrén de shēnfèn.',
    vietnamese: 'Người già trong làng nghe bản ghi không hỏi “ma là ai” mà nhận ra nhịp chuông khớp độ dốc của một nhánh đường cũ, sau này ít đi vì đá lở và mờ dần trên bản đồ. Âm thanh từ chuyện lạ thành chứng cứ không gian, nhưng vẫn không chứng minh được danh tính từng người nói.',
    english: 'A village elder does not ask who the ghosts are. He recognizes a bell rhythm matching an old branch road, now faded after rockfalls. The sound becomes spatial evidence without pretending to identify every voice.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第二天山雨引发新的塌方，原计划的采访路线被切断。你可以守着录音等待神秘马帮再次出现，也可以和村民去清理那条仍有人使用的支路。继续追奇声更可能得到独家材料，去修路却会错过最好的录音时间。',
    pinyin: 'Dì èr tiān shānyǔ yǐnfā xīn de tāfāng, yuán jìhuà de cǎifǎng lùxiàn bèi qiēduàn. Nǐ kěyǐ shǒuzhe lùyīn děngdài shénmì mǎbāng zàicì chūxiàn, yě kěyǐ hé cūnmín qù qīnglǐ nà tiáo réng yǒurén shǐyòng de zhīlù. Jìxù zhuī qíshēng gèng kěnéng dédào dújiā cáiliào, qù xiūlù què huì cuòguò zuì hǎo de lùyīn shíjiān.',
    vietnamese: 'Mưa núi ngày hôm sau gây sạt lở, cắt tuyến phỏng vấn. Bạn có thể ôm máy chờ đoàn ngựa bí ẩn trở lại hoặc cùng dân làng dọn nhánh đường vẫn có người dùng. Theo âm thanh lạ có thể được tư liệu độc quyền, còn sửa đường khiến bạn lỡ giờ ghi tốt nhất.',
    english: 'A new landslide cuts your interview route. You can wait for the mysterious caravan and perhaps gain exclusive material, or help clear the branch road people still use, sacrificing the best recording window.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你把录音机装进口袋去搬石头，马铃声没有再出现。傍晚大家停下来时，老人开始讲谁曾在这条路上背茶、运盐、送药，孩子们则把今天清路的声音录进同一个档案。古道的“回声”第一次包括了仍活着的人。',
    pinyin: 'Nǐ bǎ lùyīnjī zhuāng jìn kǒudài qù bān shítou, mǎlíngshēng méiyǒu zài chūxiàn. Bàngwǎn dàjiā tíngxiàlái shí, lǎorén kāishǐ jiǎng shéi céng zài zhè tiáo lù shàng bēi chá, yùn yán, sòng yào, háizimen zé bǎ jīntiān qīnglù de shēngyīn lù jìn tóng yí ge dàng'àn. Gǔdào de “huíshēng” dì yí cì bāokuò le réng huózhe de rén.',
    vietnamese: 'Bạn cất máy vào túi để chuyển đá và tiếng chuông không trở lại. Chiều xuống, người già kể về những người từng gùi trà, chở muối, đưa thuốc, còn trẻ con ghi âm tiếng dọn đường hôm nay vào cùng kho lưu trữ. “Tiếng vọng” của cổ đạo lần đầu gồm cả người đang sống.',
    english: 'You pocket the recorder and move stones; the bells do not return. By evening elders tell of tea carriers, salt haulers and medicine runners while children record todays road clearing into the same archive. The roads echo now includes living people.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '整理文件时，你拒绝给第一段录音加上“幽灵马帮真相”的标题，而标成“来源未明的马铃与口述路线线索”。少了一个吸引人的结论，却让历史事实、地方记忆和文学想象保持边界，也让后来的人知道哪些部分仍需核实。',
    pinyin: 'Zhěnglǐ wénjiàn shí, nǐ jùjué gěi dì yí duàn lùyīn jiāshàng “yōulíng mǎbāng zhēnxiàng” de biāotí, ér biāo chéng “láiyuán wèimíng de mǎlíng yǔ kǒushù lùxiàn xiànsuǒ”. Shǎo le yí ge xīyǐnrén de jiélùn, què ràng lìshǐ shìshí, dìfāng jìyì hé wénxué xiǎngxiàng bǎochí biānjiè, yě ràng hòulái de rén zhīdào nǎxiē bùfen réng xū héshí.',
    vietnamese: 'Khi sắp xếp tệp, bạn từ chối tiêu đề “sự thật đoàn ngựa ma” và ghi “tiếng chuông ngựa chưa rõ nguồn cùng manh mối tuyến đường qua lời kể”. Bớt một kết luận hấp dẫn nhưng giữ ranh giới giữa sự thật lịch sử, ký ức địa phương và tưởng tượng văn học, đồng thời chỉ ra điều còn phải kiểm chứng.',
    english: 'You refuse the title truth of the ghost caravan and archive the sound as bells of unknown origin with oral route clues. The less dramatic label protects the boundary between history, local memory and literary imagination and shows what still needs verification.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '离开前，你把最后一个录音文件交给村里的孩子保管。里面没有鬼声，只有新修支路上的脚步、喘气和一声很普通的自行车铃；正因为普通，它和最初的神秘马铃形成新的记忆锚点：古道不是只被过去使用，也被今天继续选择。',
    pinyin: 'Líkāi qián, nǐ bǎ zuìhòu yí ge lùyīn wénjiàn jiāo gěi cūn lǐ de háizi bǎoguǎn. Lǐmiàn méiyǒu guǐshēng, zhǐyǒu xīn xiū zhīlù shàng de jiǎobù, chuǎnqì hé yì shēng hěn pǔtōng de zìxíngchē líng; zhèng yīnwèi pǔtōng, tā hé zuìchū de shénmì mǎlíng xíngchéng xīn de jìyì máodiǎn: gǔdào bú shì zhǐ bèi guòqù shǐyòng, yě bèi jīntiān jìxù xuǎnzé.',
    vietnamese: 'Trước khi rời đi, bạn giao tệp cuối cho trẻ trong làng. Không có tiếng ma, chỉ bước chân, hơi thở và chuông xe đạp bình thường trên nhánh đường vừa dọn. Chính sự bình thường ấy tạo neo ký ức với tiếng chuông bí ẩn ban đầu: cổ đạo không chỉ được quá khứ sử dụng mà còn được hiện tại tiếp tục lựa chọn.',
    english: 'Before leaving you give children the final recording. It contains no ghost, only footsteps, breathing and an ordinary bicycle bell on the cleared branch. That ordinary sound becomes the memory anchor: the old road is not only used by the past but chosen again in the present.',
  ),
];

const _iceCityStarMap = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '旧厂房停产多年，墙上的星图却把每颗星标成机器编号而不是星座名称。你原以为这是工程师的玩笑，直到退休工人指出一颗最暗的“星”对应锅炉房夜班，另一颗对应冬天负责除冰的人。',
    pinyin: 'Jiù chǎngfáng tíngchǎn duōnián, qiáng shàng de xīngtú què bǎ měi kē xīng biāo chéng jīqì biānhào ér bú shì xīngzuò míngchēng. Nǐ yuányǐwéi zhè shì gōngchéngshī de wánxiào, zhídào tuìxiū gōngrén zhǐchū yì kē zuì àn de “xīng” duìyìng guōlúfáng yèbān, lìng yì kē duìyìng dōngtiān fùzé chúbīng de rén.',
    vietnamese: 'Nhà máy cũ dừng hoạt động nhiều năm nhưng bản đồ sao trên tường ghi số máy thay vì tên chòm sao. Bạn tưởng đó là trò đùa kỹ sư, cho tới khi công nhân nghỉ hưu chỉ ra một “ngôi sao” mờ là ca đêm lò hơi, ngôi khác là người phá băng mùa đông.',
    english: 'The old factory star map labels machine numbers instead of constellations. What looks like an engineers joke becomes a map of ordinary labor when retirees identify a dim star as boiler night shift and another as the winter de-icing crew.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '改造团队想把星图做成漂亮的互动装置，但原始编号太多、太乱，也没有完整名单。删掉无法解释的点会让展示更清楚，却可能再次把最不显眼的工作从厂史里删掉；全部保留又会让访客看不懂。',
    pinyin: 'Gǎizào tuánduì xiǎng bǎ xīngtú zuò chéng piàoliang de hùdòng zhuāngzhì, dàn yuánshǐ biānhào tài duō, tài luàn, yě méiyǒu wánzhěng míngdān. Shāndiào wúfǎ jiěshì de diǎn huì ràng zhǎnshì gèng qīngchu, què kěnéng zàicì bǎ zuì bù xiǎnyǎn de gōngzuò cóng chǎngshǐ lǐ shāndiào; quánbù bǎoliú yòu huì ràng fǎngkè kàn bù dǒng.',
    vietnamese: 'Nhóm cải tạo muốn biến bản đồ sao thành thiết bị tương tác đẹp mắt, nhưng số cũ quá nhiều, lộn xộn và thiếu danh sách đầy đủ. Xóa điểm chưa giải thích sẽ dễ hiểu hơn nhưng có thể xóa tiếp những công việc ít được chú ý; giữ tất cả lại khiến khách khó đọc.',
    english: 'The renovation team wants a clean interactive display, but the old codes are incomplete. Removing unexplained points improves clarity while risking another erasure of invisible work; keeping everything makes the map harder to read.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你和退休工人决定把“未知”也做成一种可见状态：已确认的星点写岗位和姓名，只有岗位没有姓名的单独标记，完全无法解释的则保留编号并注明待考。星图因此不再假装拥有一份完整的工厂记忆。',
    pinyin: 'Nǐ hé tuìxiū gōngrén juédìng bǎ “wèizhī” yě zuò chéng yì zhǒng kějiàn zhuàngtài: yǐ quèrèn de xīngdiǎn xiě gǎngwèi hé xìngmíng, zhǐyǒu gǎngwèi méiyǒu xìngmíng de dāndú biāojì, wánquán wúfǎ jiěshì de zé bǎoliú biānhào bìng zhùmíng dàikǎo. Xīngtú yīncǐ bú zài jiǎzhuāng yǒngyǒu yí fèn wánzhěng de gōngchǎng jìyì.',
    vietnamese: 'Bạn và công nhân nghỉ hưu quyết định làm cả “chưa biết” thành trạng thái nhìn thấy được: điểm đã xác nhận ghi việc và tên, điểm chỉ biết việc thì đánh dấu riêng, điểm chưa giải thích giữ số và ghi chờ khảo chứng. Bản đồ không còn giả vờ nắm ký ức nhà máy hoàn chỉnh.',
    english: 'You and the retirees make unknown a visible status: confirmed stars carry jobs and names, partial ones show jobs only, and unexplained codes remain marked for research. The star map stops pretending the factory memory is complete.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '一位老人发现自己父亲的编号被列在“未知”里，他很想当场补上姓名，却也承认只是凭家庭记忆推测。你没有为了安慰他立刻改档，而是把这条口述证词挂在编号旁，留下可以继续核对的路径。',
    pinyin: 'Yí wèi lǎorén fāxiàn zìjǐ fùqīn de biānhào bèi liè zài “wèizhī” lǐ, tā hěn xiǎng dāngchǎng bǔshàng xìngmíng, què yě chéngrèn zhǐ shì píng jiātíng jìyì tuīcè. Nǐ méiyǒu wèile ānwèi tā lìkè gǎidàng, ér shì bǎ zhè tiáo kǒushù zhèngcí guà zài biānhào páng, liúxià kěyǐ jìxù héduì de lùjìng.',
    vietnamese: 'Một ông lão thấy mã có thể là của cha mình nằm trong mục “chưa biết”. Ông muốn điền tên ngay nhưng thừa nhận chỉ suy từ ký ức gia đình. Bạn không sửa hồ sơ để an ủi mà gắn lời kể cạnh mã số, để lại đường kiểm chứng tiếp.',
    english: 'A retiree finds a code he believes belonged to his father among the unknown stars. Rather than edit the archive for comfort, you attach his oral testimony beside the code and preserve a path for later verification.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '开放那天，孩子们最先触碰的不是最亮的主机星点，而是一颗标着“岗位已知，姓名待考”的小星。屏幕显示清扫、巡检、夜班和除冰如何让整座工厂在严冬运转，星图终于把“重要”从职位高低转向相互依赖。',
    pinyin: 'Kāifàng nà tiān, háizimen zuìxiān chùpèng de bú shì zuì liàng de zhǔjī xīngdiǎn, ér shì yì kē biāozhe “gǎngwèi yǐzhī, xìngmíng dàikǎo” de xiǎo xīng. Píngmù xiǎnshì qīngsǎo, xúnjiǎn, yèbān hé chúbīng rúhé ràng zhěng zuò gōngchǎng zài yándōng yùnzhuǎn, xīngtú zhōngyú bǎ “zhòngyào” cóng zhíwèi gāodī zhuǎnxiàng xiānghù yīlài.',
    vietnamese: 'Ngày mở cửa, trẻ em chạm trước tiên không phải điểm máy chính sáng nhất mà một ngôi sao nhỏ ghi “biết vị trí công việc, tên chờ khảo chứng”. Màn hình cho thấy quét dọn, kiểm tra, ca đêm và phá băng cùng giữ nhà máy chạy qua mùa đông, chuyển ý nghĩa “quan trọng” từ cấp bậc sang phụ thuộc lẫn nhau.',
    english: 'On opening day children choose not the brightest machine star but one marked job known, name pending. The display shows cleaning, inspection, night shifts and de-icing as interdependent work, shifting importance away from rank.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '离开旧厂时，外面的冰面映出真正的夜空，墙上的星图则留在暖光里。你没有把两者解释成谁模仿谁；记忆锚点是那颗仍写着“待考”的小星，因为一个公共档案既可以照亮普通人的劳动，也可以诚实保留尚未解决的黑暗。',
    pinyin: 'Líkāi jiùchǎng shí, wàimiàn de bīngmiàn yìngchū zhēnzhèng de yèkōng, qiáng shàng de xīngtú zé liú zài nuǎnguāng lǐ. Nǐ méiyǒu bǎ liǎngzhě jiěshì chéng shéi mófǎng shéi; jìyì máodiǎn shì nà kē réng xiězhe “dàikǎo” de xiǎo xīng, yīnwèi yí ge gōnggòng dàng'àn jì kěyǐ zhàoliàng pǔtōngrén de láodòng, yě kěyǐ chéngshí bǎoliú shàngwèi jiějué de hēi'àn.',
    vietnamese: 'Rời nhà máy, mặt băng ngoài trời phản chiếu bầu trời thật còn bản đồ sao ở lại trong ánh sáng ấm. Bạn không giải thích cái nào bắt chước cái nào. Neo ký ức là ngôi sao nhỏ vẫn ghi “chờ khảo chứng”: một kho lưu trữ công cộng vừa có thể soi sáng lao động bình thường vừa giữ trung thực vùng tối chưa giải quyết.',
    english: 'Outside, ice reflects the real night while the factory star map stays in warm light. The memory anchor is the small star still marked pending: a public archive can illuminate ordinary labor while honestly preserving what remains unresolved.',
  ),
];
