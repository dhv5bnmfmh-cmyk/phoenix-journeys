import 'daily_journey_experience.dart';
import 'editorial_story_revision.dart';

const specialEditorialRevisions = <String, EditorialStoryRevision>{
  'literary-roaming': EditorialStoryRevision(
    id: 'literary-roaming',
    protagonist: '阿遥',
    narrativeMode: '双重日记',
    emotionalArc: '确信自己清醒 → 发现矛盾 → 接受不确定 → 主动改变',
    endingMode: '两本日记留下不同答案',
    sections: [
      '阿遥在老树下醒来，手背停着一只蓝色蝴蝶，口袋里却多出一本小日记。第一页写着：“今天，我梦见自己变成阿遥。”字迹不是他的。阿遥立刻补上一句：“不对，是我梦见了蝴蝶。”',
      '他跟着蝴蝶穿过竹林，每到一处便在日记左页记录现实：风、石阶、树影；右页却自动出现另一段文字，描述翅膀如何感受气流和花香。两种记录都准确，又都无法证明谁才是观察者。',
      '山路分成两条，一条写“回到人间”，另一条写“继续做梦”。阿遥本想选择看起来更安全的第一条，却发现蝴蝶落在第二块路牌上，而日记同时翻到空白页。没有声音替他决定，也没有谜底等在终点。',
      '阿遥最后没有选路，而是坐下来把两本日记的句子抄在同一页：醒着的他愿意相信蝴蝶的感受，梦中的蝴蝶也愿意承认阿遥的疑问。路牌上的字慢慢消失。故事没有证明谁梦见谁，却让他在回家后不再把自己的眼睛当成唯一世界。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Ā Yáo zài lǎoshù xià xǐnglái, shǒubèi tíngzhe yì zhī lánsè húdié, kǒudài lǐ què duō chū yì běn xiǎo rìjì. Dì yí yè xiězhe: “Jīntiān, wǒ mèngjiàn zìjǐ biàn chéng Ā Yáo.” Zìjì bú shì tā de. Ā Yáo lìkè bǔshàng yí jù: “Bú duì, shì wǒ mèngjiàn le húdié.”',
        vietnamese: 'A Dao tỉnh dưới cây với bướm xanh trên tay và cuốn nhật ký lạ viết “tôi mơ mình thành A Dao”. Cậu lập tức sửa rằng chính mình đã mơ thấy bướm.',
        english: 'Ayao wakes beneath a tree with a blue butterfly and a strange diary saying, “I dreamed I became Ayao.” He immediately writes that he was the one who dreamed the butterfly.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā gēnzhe húdié chuānguò zhúlín, měi dào yí chù biàn zài rìjì zuǒyè jìlù xiànshí: fēng, shíjiē, shùyǐng; yòuyè què zìdòng chūxiàn lìng yí duàn wénzì, miáoshù chìbǎng rúhé gǎnshòu qìliú hé huāxiāng. Liǎng zhǒng jìlù dōu zhǔnquè, yòu dōu wúfǎ zhèngmíng shéi cái shì guāncházhě.',
        vietnamese: 'Trang trái ghi gió, bậc đá và bóng cây của A Dao, trang phải tự viết cảm giác luồng khí và hương hoa của cánh bướm. Cả hai đều đúng mà không chứng minh được ai quan sát.',
        english: 'The left page records Ayao’s wind, steps, and shadows, while the right writes the butterfly’s air currents and fragrance. Both accounts are accurate, yet neither proves who observes whom.',
      ),
      ReadingAnnotation(
        pinyin: 'Shānlù fēn chéng liǎng tiáo, yì tiáo xiě “huídào rénjiān”, lìng yì tiáo xiě “jìxù zuòmèng”. Ā Yáo běn xiǎng xuǎnzé kàn qǐlái gèng ānquán de dì yì tiáo, què fāxiàn húdié luò zài dì èr kuài lùpái shàng, ér rìjì tóngshí fān dào kòngbái yè. Méiyǒu shēngyīn tì tā juédìng, yě méiyǒu mídǐ děng zài zhōngdiǎn.',
        vietnamese: 'Hai đường ghi “về nhân gian” và “tiếp tục mơ”. Bướm đậu ở đường thứ hai, nhật ký mở trang trắng; không ai quyết định thay cậu và không có đáp án sẵn.',
        english: 'The paths read “return to the human world” and “continue dreaming.” The butterfly chooses the second while the diary opens to a blank page, leaving Ayao without an assigned answer.',
      ),
      ReadingAnnotation(
        pinyin: 'Ā Yáo zuìhòu méiyǒu xuǎnlù, ér shì zuòxiàlái bǎ liǎng běn rìjì de jùzi chāo zài tóng yí yè: xǐngzhe de tā yuànyì xiāngxìn húdié de gǎnshòu, mèng zhōng de húdié yě yuànyì chéngrèn Ā Yáo de yíwèn. Lùpái shàng de zì mànmàn xiāoshī. Gùshi méiyǒu zhèngmíng shéi mèngjiàn shéi, què ràng tā zài huíjiā hòu bú zài bǎ zìjǐ de yǎnjing dàng chéng wéiyī shìjiè.',
        vietnamese: 'A Dao chép hai lời kể lên cùng trang và chấp nhận cảm giác của cả người lẫn bướm. Cậu trở về mà không còn coi đôi mắt mình là thế giới duy nhất.',
        english: 'Ayao copies both accounts onto one page and accepts the perception of both child and butterfly. He returns home no longer treating his own eyes as the only world.',
      ),
    ],
    wonderQuestion: '当两个互相矛盾的体验都很真实时，人还可以怎样理解“自我”？',
    expressQuestion: '请用左右两栏，分别从人和动物视角写同一个瞬间。',
  ),
  'myth-tracing': EditorialStoryRevision(
    id: 'myth-tracing',
    protagonist: '桂生与白兔阿皎',
    narrativeMode: '神话档案听证会',
    emotionalArc: '想占有秘密 → 听见多种传说 → 面对代价 → 选择公开边界',
    endingMode: '遗简进入可质疑的公共档案',
    sections: [
      '桂生在村校整理旧物时发现一页残缺竹简，只剩“归去”二字和淡淡桂花香。他正想偷偷收藏，一只会说话的白兔阿皎从窗台跳下：“这页遗简每隔很多年就寻找一个新主人，但主人必须先回答，它究竟属于谁。”',
      '阿皎带他来到月光下的桂树林。树中没有宫殿，只有三位讲述者：老人说它来自月宫，木匠说它是祖辈祭月道具，老师则指出竹简年代和文字仍需研究。三个解释互不相同，却都和地方记忆有关。',
      '桂生若把遗简藏起来，就能保留神秘感；若把它交给学校，传说可能被检验，也可能失去一部分美丽。阿皎没有催促，只问：“一个故事被证明不是史实以后，还能不能继续有意义？”',
      '桂生把遗简放进透明档案盒，旁边同时写上“已确认事实、民间说法、Phoenix幻想”三栏。阿皎没有消失，而是留下来当第一个挑错者。月光从盒面移过去，秘密没有被夺走，只是不再要求所有人用同一种方式相信。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Guìshēng zài cūnxiào zhěnglǐ jiùwù shí fāxiàn yí yè cánquē zhújiǎn, zhǐ shèng “guīqù” èr zì hé dàndàn guìhuāxiāng. Tā zhèng xiǎng tōutōu shōucáng, yì zhī huì shuōhuà de báitù Ā Jiǎo cóng chuāngtái tiàoxià: “Zhè yè yíjiǎn měi gé hěn duō nián jiù xúnzhǎo yí gè xīn zhǔrén, dàn zhǔrén bìxū xiān huídá, tā jiūjìng shǔyú shéi.”',
        vietnamese: 'Quế Sinh tìm thấy thẻ tre chỉ còn hai chữ “trở về” và muốn giấu. Thỏ trắng A Kiểu biết nói bảo vật này chỉ nhận chủ mới sau khi người đó trả lời nó thuộc về ai.',
        english: 'Guisheng finds a bamboo slip marked only “return” and wants to hide it. A talking white rabbit says it accepts a new keeper only after the child decides whom it belongs to.',
      ),
      ReadingAnnotation(
        pinyin: 'Ā Jiǎo dài tā láidào yuèguāng xià de guìshùlín. Shùzhōng méiyǒu gōngdiàn, zhǐyǒu sān wèi jiǎngshùzhě: lǎorén shuō tā láizì Yuègōng, mùjiàng shuō tā shì zǔbèi jìyuè dàojù, lǎoshī zé zhǐchū zhújiǎn niándài hé wénzì réng xū yánjiū. Sān gè jiěshì hù bù xiāngtóng, què dōu hé dìfāng jìyì yǒuguān.',
        vietnamese: 'Trong rừng quế, người già nói thẻ từ cung trăng, thợ mộc nói là đạo cụ tế trăng, giáo viên nói cần nghiên cứu niên đại. Ba cách khác nhau đều gắn với ký ức địa phương.',
        english: 'In the osmanthus grove, an elder calls it lunar, a carpenter calls it a festival prop, and a teacher asks for research. Three incompatible accounts still belong to local memory.',
      ),
      ReadingAnnotation(
        pinyin: 'Guìshēng ruò bǎ yíjiǎn cáng qǐlái, jiù néng bǎoliú shénmìgǎn; ruò bǎ tā jiāogěi xuéxiào, chuánshuō kěnéng bèi jiǎnyàn, yě kěnéng shīqù yí bùfen měilì. Ā Jiǎo méiyǒu cuīcù, zhǐ wèn: “Yí gè gùshi bèi zhèngmíng bú shì shǐshí yǐhòu, hái néng bu néng jìxù yǒu yìyì?”',
        vietnamese: 'Giấu sẽ giữ bí mật, công khai sẽ khiến truyền thuyết bị kiểm chứng. A Kiểu hỏi một chuyện không phải sử thật có còn ý nghĩa không.',
        english: 'Hiding preserves mystery, while sharing invites examination. Ajiao asks whether a story can remain meaningful after it is shown not to be historical fact.',
      ),
      ReadingAnnotation(
        pinyin: 'Guìshēng bǎ yíjiǎn fàng jìn tòumíng dàng’ànhé, pángbiān tóngshí xiěshàng “yǐ quèrèn shìshí, mínjiān shuōfǎ, Phoenix huànxiǎng” sān lán. Ā Jiǎo méiyǒu xiāoshī, ér shì liúxiàlái dāng dì yí gè tiāocuòzhě. Yuèguāng cóng hémiàn yí guòqù, mìmì méiyǒu bèi duózǒu, zhǐshì bú zài yāoqiú suǒyǒu rén yòng tóng yì zhǒng fāngshì xiāngxìn.',
        vietnamese: 'Cậu đặt thẻ vào hộp với ba cột sự thật, dân gian và tưởng tượng Phoenix. Bí mật vẫn còn nhưng không buộc mọi người tin cùng cách.',
        english: 'He places the slip in a box labelled fact, folk account, and Phoenix fantasy. The mystery remains without demanding one form of belief.',
      ),
    ],
    wonderQuestion: '传说不是历史事实时，为什么仍可能拥有文化和情感价值？',
    expressQuestion: '请把一个故事信息分成“事实、传说、想象”三栏。',
  ),
  'strange-night-talks': EditorialStoryRevision(
    id: 'strange-night-talks',
    protagonist: '客栈学徒阿年',
    narrativeMode: '禁令与信任困局',
    emotionalArc: '害怕 → 怀疑规则 → 识别操纵 → 主动求证',
    endingMode: '危险被揭开但未完全解释',
    sections: [
      '子夜，无影客人敲响客栈木门。他站在大雨里，衣角却没有一滴水。学徒阿年让他进屋，客人放下一枚冰冷铜钱：“鸡鸣以前，无论听见谁叫你的名字，都不要独自开门。”',
      '三更后，门外传来阿年姐姐的声音。她先说母亲生病，随后指责阿年胆小，最后准确讲出兄妹小时候埋在井边的木盒。阿年几乎拉开门闩，却注意到声音每次都只要求他独自出去，从不回答姐姐才知道的一个新问题。',
      '阿年没有盲从无影客人的禁令，也没有相信门外声音。他叫醒掌柜和住客，让所有人一起核对消息，再从二楼窗户观察院门。门外没有姐姐，只有一串脚印从门缝向屋内生长；掌心铜钱也变成湿叶。',
      '鸡鸣后，脚印停在门槛前。无影客人留下的房间空着，桌上却多了一行字：“真正安全的规则，不怕被共同检查。”阿年当天便给姐姐写信确认平安。客栈仍有未解之谜，但恐惧再也不能只靠喊出一个名字命令他。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Zǐyè, wúyǐng kèrén qiāoxiǎng kèzhàn mùmén. Tā zhàn zài dàyǔ lǐ, yījiǎo què méiyǒu yì dī shuǐ. Xuétú Ā Nián ràng tā jìn wū, kèrén fàngxià yí méi bīnglěng tóngqián: “Jīmíng yǐqián, wúlùn tīngjiàn shéi jiào nǐ de míngzi, dōu bú yào dúzì kāimén.”',
        vietnamese: 'Nửa đêm, vị khách không bóng đứng trong mưa mà áo khô. Ông trao đồng tiền lạnh và dặn A Niên trước tiếng gà không được một mình mở cửa khi ai gọi tên.',
        english: 'At midnight, a shadowless guest stands dry in heavy rain. He gives apprentice Anian a cold coin and warns him never to open the door alone before the rooster calls.',
      ),
      ReadingAnnotation(
        pinyin: 'Sāngēng hòu, ménwài chuánlái Ā Nián jiějie de shēngyīn. Tā xiān shuō mǔqin shēngbìng, suíhòu zhǐzé Ā Nián dǎnxiǎo, zuìhòu zhǔnquè jiǎngchū xiōngmèi xiǎoshíhou mái zài jǐngbiān de mùhé. Ā Nián jīhū lākāi ménshuān, què zhùyì dào shēngyīn měi cì dōu zhǐ yāoqiú tā dúzì chūqù, cóng bù huídá jiějie cái zhīdào de yí gè xīn wèntí.',
        vietnamese: 'Giọng chị nói mẹ bệnh, chê cậu hèn và nhắc hộp gỗ cũ. A Niên sắp mở nhưng nhận ra giọng luôn đòi cậu ra một mình và không trả lời câu hỏi mới.',
        english: 'His sister’s voice reports illness, insults him, and names an old box. Anian almost opens the door, then notices it always demands he come alone and cannot answer a new question.',
      ),
      ReadingAnnotation(
        pinyin: 'Ā Nián méiyǒu mángcóng wúyǐng kèrén de jìnlìng, yě méiyǒu xiāngxìn ménwài shēngyīn. Tā jiàoxǐng zhǎngguì hé zhùkè, ràng suǒyǒu rén yìqǐ héduì xiāoxi, zài cóng èrlóu chuānghu guānchá yuànmén. Ménwài méiyǒu jiějie, zhǐyǒu yí chuàn jiǎoyìn cóng ménfèng xiàng wūnèi shēngzhǎng; zhǎngxīn tóngqián yě biàn chéng shīyè.',
        vietnamese: 'Cậu không mù quáng theo lệnh cũng không tin giọng. Cậu đánh thức mọi người cùng kiểm tra; ngoài cửa không có chị, chỉ có dấu chân mọc vào trong và đồng tiền thành lá ướt.',
        english: 'He neither obeys blindly nor trusts the voice. Everyone verifies together; no sister waits outside, only footprints growing inward and a coin turning to a wet leaf.',
      ),
      ReadingAnnotation(
        pinyin: 'Jīmíng hòu, jiǎoyìn tíng zài ménkǎn qián. Wúyǐng kèrén liúxià de fángjiān kōngzhe, zhuōshàng què duō le yì háng zì: “Zhēnzhèng ānquán de guīzé, bù pà bèi gòngtóng jiǎnchá.” Ā Nián dāngtiān biàn gěi jiějie xiěxìn quèrèn píng’ān. Kèzhàn réng yǒu wèi jiě zhī mí, dàn kǒngjù zài yě bùnéng zhǐ kào hǎnchū yí gè míngzi mìnglìng tā.',
        vietnamese: 'Sau tiếng gà, phòng khách trống nhưng để câu “quy tắc an toàn thật không sợ kiểm tra chung”. A Niên viết thư xác nhận chị bình an; nỗi sợ không còn ra lệnh chỉ bằng tên.',
        english: 'After the rooster, the room is empty except for “A truly safe rule can survive shared examination.” Anian writes to confirm his sister is safe, and fear can no longer command him by name alone.',
      ),
    ],
    wonderQuestion: '面对恐惧中的命令时，怎样同时避免盲从和冲动违抗？',
    expressQuestion: '请写一个可以验证熟人身份、又不会泄露秘密的问题。',
  ),
  'folk-secret-land': EditorialStoryRevision(
    id: 'folk-secret-land',
    protagonist: '灯船女孩秋禾',
    narrativeMode: '未来留言伦理选择',
    emotionalArc: '好奇 → 诱惑 → 想控制未来 → 尊重未知',
    endingMode: '不读取留言，而改变今天的行动',
    sections: [
      '河灯节上，秋禾负责把破损纸灯捞回岸边。老人提醒她不要碰逆流而上的灯，可一盏写着她名字的灯偏偏停在船侧。灯纸内没有鬼影，只有一行来自四十年后的字：“别让弟弟参加明天的比赛。”',
      '秋禾的弟弟正在准备第一次划船赛。她若相信留言，就能立刻阻止；若不相信，又担心未来真的发生事故。河面上其他灯顺流远去，只有这一盏不断退向上游，仿佛未来正把责任推回今天。',
      '她没有偷偷毁掉弟弟的船，也没有把可怕预言直接告诉他。秋禾先检查天气、船体和救生装备，又请教练重新评估路线。结果发现一条固定绳已经磨损，比赛因此延后维修，却没人能证明这就是未来留言所指的危险。',
      '秋禾把纸灯折成新的安全检查表，没有读取灯底剩下的文字。她让河灯继续逆流，自己则把今天能够确认的风险一项项处理。未来没有被她占有，弟弟也没有被恐惧控制；一条神秘留言最终变成了更谨慎的现在。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Hédēngjié shàng, Qiūhé fùzé bǎ pòsǔn zhǐdēng lāo huí ànbiān. Lǎorén tíxǐng tā bú yào pèng nìliú ér shàng de dēng, kě yì zhǎn xiězhe tā míngzi de dēng piānpiān tíng zài chuáncè. Dēngzhǐ nèi méiyǒu guǐyǐng, zhǐyǒu yì háng láizì sìshí nián hòu de zì: “Bié ràng dìdi cānjiā míngtiān de bǐsài.”',
        vietnamese: 'Trong hội đèn, Thu Hòa gặp chiếc đèn ngược dòng ghi tên mình và lời từ bốn mươi năm sau: đừng để em trai thi ngày mai.',
        english: 'At the lantern festival, Qiuhe finds an upstream lantern bearing her name and a message from forty years ahead: do not let her brother race tomorrow.',
      ),
      ReadingAnnotation(
        pinyin: 'Qiūhé de dìdi zhèngzài zhǔnbèi dì yí cì huáchuán sài. Tā ruò xiāngxìn liúyán, jiù néng lìkè zǔzhǐ; ruò bù xiāngxìn, yòu dānxīn wèilái zhēn de fāshēng shìgù. Hémiàn shàng qítā dēng shùnliú yuǎnqù, zhǐyǒu zhè yì zhǎn bùduàn tuì xiàng shàngyóu, fǎngfú wèilái zhèng bǎ zérèn tuī huí jīntiān.',
        vietnamese: 'Tin thì phải ngăn cuộc đua, không tin lại sợ tai nạn. Chiếc đèn như đẩy trách nhiệm từ tương lai về hiện tại.',
        english: 'Believing means stopping the race; disbelief risks an accident. The lantern seems to push responsibility from the future into the present.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā méiyǒu tōutōu huǐdiào dìdi de chuán, yě méiyǒu bǎ kěpà yùyán zhíjiē gàosu tā. Qiūhé xiān jiǎnchá tiānqì, chuántǐ hé jiùshēng zhuāngbèi, yòu qǐng jiàoliàn chóngxīn pínggū lùxiàn. Jiéguǒ fāxiàn yì tiáo gùdìngshéng yǐjīng mósǔn, bǐsài yīncǐ yánqī wéixiū, què méi rén néng zhèngmíng zhè jiù shì wèilái liúyán suǒ zhǐ de wēixiǎn.',
        vietnamese: 'Cô không phá thuyền hay dọa em, mà kiểm tra thời tiết, thân thuyền, cứu sinh và tuyến. Một dây mòn khiến cuộc đua hoãn, nhưng không ai biết có đúng lời tiên đoán không.',
        english: 'She neither destroys the boat nor frightens her brother. Checking weather, hull, safety gear, and route reveals a worn rope, although nobody can prove it was the predicted danger.',
      ),
      ReadingAnnotation(
        pinyin: 'Qiūhé bǎ zhǐdēng zhé chéng xīn de ānquán jiǎnchábiǎo, méiyǒu dúqǔ dēngdǐ shèngxià de wénzì. Tā ràng hédēng jìxù nìliú, zìjǐ zé bǎ jīntiān nénggòu quèrèn de fēngxiǎn yí xiàng xiàng chǔlǐ. Wèilái méiyǒu bèi tā zhànyǒu, dìdi yě méiyǒu bèi kǒngjù kòngzhì; yì tiáo shénmì liúyán zuìzhōng biàn chéng le gèng jǐnshèn de xiànzài.',
        vietnamese: 'Cô gấp đèn thành bảng kiểm và không đọc phần còn lại. Tương lai không bị chiếm giữ, còn hiện tại trở nên cẩn trọng hơn.',
        english: 'She folds the lantern into a checklist and leaves the remaining message unread. The future is not possessed, while the present becomes more careful.',
      ),
    ],
    wonderQuestion: '知道一个可能的未来以后，怎样避免让恐惧替别人决定人生？',
    expressQuestion: '请把一条模糊预言改写成三项可以在今天检查的行动。',
  ),
  'changan-last-bus': EditorialStoryRevision(
    id: 'changan-last-bus',
    protagonist: '夜班售票员小墨',
    narrativeMode: '跨时代乘客调解',
    emotionalArc: '按规则工作 → 遇到不可能乘客 → 理解归途 → 主动承担见证',
    endingMode: '车继续运行，记录留下而非异常消失',
    sections: [
      '雨夜，售票员小墨发现末班车上多出一位抱铜镜的老人。老人没有手机，也没有现金，只递来半张写着“长安坊市”的旧票。按照规定，小墨应请他下车，可车每经过一座城门，镜面便多出一条不属于现代街道的灯影。',
      '老人说自己每隔百年乘一次这班车，寻找另一半归家票。司机认为他在捣乱，乘客却有人想拍视频。小墨收起大家的手机，先核对票上的城门顺序和今天路线，发现旧坊市灯影并非随机，而是在重走一条已经消失的归途。',
      '终点没有站名，雨中只有一座候车亭。地上躺着另一半车票，背面却印着小墨自己的座位号。老人若拿走票就能回到过去，小墨则可能永远失去这个座位。她没有替老人决定，只把完整车票放在两人之间。',
      '老人最终撕下一小角留作证明，把其余投入铜镜。古城灯影没有全部退去，其中一盏留在车窗上，成为夜班司机识别路线的新标记。小墨在运营日志中如实写下无法解释的乘客。末班车继续驶向现代街道，而过去不再只是一次无人作证的幻觉。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Yǔyè, shòupiàoyuán Xiǎo Mò fāxiàn mòbānchē shàng duō chū yí wèi bào tóngjìng de lǎorén. Lǎorén méiyǒu shǒujī, yě méiyǒu xiànjīn, zhǐ dìlái bàn zhāng xiězhe “Cháng’ān fāngshì” de jiùpiào. Ànzhào guīdìng, Xiǎo Mò yīng qǐng tā xiàchē, kě chē měi jīngguò yí zuò chéngmén, jìngmiàn biàn duō chū yì tiáo bù shǔyú xiàndài jiēdào de dēngyǐng.',
        vietnamese: 'Trong chuyến xe cuối, cô bán vé Tiểu Mặc gặp ông già chỉ có nửa vé “phường chợ Trường An”. Mỗi cổng thành xe đi qua lại thêm một con phố đèn cổ trong gương.',
        english: 'On the last bus, conductor Xiao Mo meets an old man carrying half a ticket marked “Changan wards.” Each city gate adds an ancient lantern street to his mirror.',
      ),
      ReadingAnnotation(
        pinyin: 'Lǎorén shuō zìjǐ měi gé bǎinián chéng yí cì zhè bān chē, xúnzhǎo lìng yí bàn guījiāpiào. Sījī rènwéi tā zài dǎoluàn, chéngkè què yǒurén xiǎng pāi shìpín. Xiǎo Mò shōuqǐ dàjiā de shǒujī, xiān héduì piào shàng de chéngmén shùnxù hé jīntiān lùxiàn, fāxiàn jiù fāngshì dēngyǐng bìngfēi suíjī, ér shì zài chóngzǒu yì tiáo yǐjīng xiāoshī de guītú.',
        vietnamese: 'Ông nói trăm năm đi một lần để tìm nửa vé. Tiểu Mặc ngăn quay phim và đối chiếu thứ tự cổng, nhận ra ánh đèn đang tái hiện đường về đã mất.',
        english: 'He rides once a century to find the other half. Xiao Mo stops filming and checks the gate order, discovering that the lights retrace a vanished journey home.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhōngdiǎn méiyǒu zhànmíng, yǔzhōng zhǐyǒu yí zuò hòuchētíng. Dìshàng tǎngzhe lìng yí bàn chēpiào, bèimiàn què yìnzhe Xiǎo Mò zìjǐ de zuòwèihào. Lǎorén ruò názǒu piào jiù néng huídào guòqù, Xiǎo Mò zé kěnéng yǒngyuǎn shīqù zhège zuòwèi. Tā méiyǒu tì lǎorén juédìng, zhǐ bǎ wánzhěng chēpiào fàng zài liǎng rén zhījiān.',
        vietnamese: 'Nửa vé còn lại mang số ghế của Tiểu Mặc. Ông có thể về quá khứ, còn cô có thể mất ghế; cô đặt vé giữa hai người thay vì quyết định hộ.',
        english: 'The other half bears Xiao Mo’s seat number. The old man may return while she may lose the seat, so she places the complete ticket between them without choosing for him.',
      ),
      ReadingAnnotation(
        pinyin: 'Lǎorén zuìzhōng sīxià yì xiǎo jiǎo liú zuò zhèngmíng, bǎ qíyú tóurù tóngjìng. Gǔchéng dēngyǐng méiyǒu quánbù tuìqù, qízhōng yì zhǎn liú zài chēchuāng shàng, chéngwéi yèbān sījī shíbié lùxiàn de xīn biāojì. Xiǎo Mò zài yùnyíng rìzhì zhōng rúshí xiěxià wúfǎ jiěshì de chéngkè. Mòbānchē jìxù shǐxiàng xiàndài jiēdào, ér guòqù bú zài zhǐ shì yí cì wúrén zuòzhèng de huànjué.',
        vietnamese: 'Ông giữ một góc vé và đưa phần còn lại vào gương. Một ngọn đèn ở lại cửa sổ; Tiểu Mặc ghi trung thực hành khách không thể giải thích.',
        english: 'He keeps one corner and sends the rest through the mirror. One lantern remains on the window, and Xiao Mo records the unexplained passenger honestly.',
      ),
    ],
    wonderQuestion: '当规则遇到无法解释但可能真实的情况时，工作人员应该怎样兼顾安全与尊重？',
    expressQuestion: '请用运营日志语气记录一件无法解释、但不能夸大的事件。',
  ),
  'tide-letter': EditorialStoryRevision(
    id: 'tide-letter',
    protagonist: '安声',
    narrativeMode: '家庭录音补白',
    emotionalArc: '执着寻找原话 → 害怕误解 → 与家人对话 → 接受共同续写',
    endingMode: '缺失句子保留，新的声音加入',
    sections: [
      '海边小城停电后，安声在旧收音机里听见母亲二十年前录下的天气预报。录音每次都在一句“等你长大以后，我希望……”前中断。安声认定只要找到原磁带，就能知道母亲真正期待自己成为什么人。',
      '他沿湿巷走到渡口，又进入废弃剧场寻找录音来源。船笛、潮声、幕布和母亲年轻时的哼唱把两个时代连在一起，却没有补出最后一句。舅舅说母亲当年换过许多工作，也常常改变想法，不该把一次录音当成终身命令。',
      '安声生气，觉得家人只是害怕他说出真相。直到外婆拿出几封年份不同的信，每封都写着不一样的愿望：平安、自由、愿意回来、也敢走远。缺失句子不是唯一答案的入口，而是一个人尚未说完、后来仍会变化的生命。',
      '安声没有模仿母亲补完那句话。他录下自己、外婆、舅舅和海边孩子的声音，接在中断处以后，却保留那一秒空白。渡船鸣笛时，旧录音没有被修成完美遗言，而成为一家人可以继续回应的开放信件。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Hǎibiān xiǎochéng tíngdiàn hòu, Ān Shēng zài jiù shōuyīnjī lǐ tīngjiàn mǔqin èrshí nián qián lùxià de tiānqì yùbào. Lùyīn měi cì dōu zài yí jù “děng nǐ zhǎngdà yǐhòu, wǒ xīwàng…” qián zhōngduàn. Ān Shēng rèndìng zhǐyào zhǎodào yuán cídài, jiù néng zhīdào mǔqin zhēnzhèng qīdài zìjǐ chéngwéi shénme rén.',
        vietnamese: 'Sau mất điện, An Thanh nghe dự báo mẹ ghi hai mươi năm trước, luôn ngắt trước câu “khi con lớn, mẹ mong…”. Cậu tin băng gốc sẽ cho biết mẹ muốn mình thành người thế nào.',
        english: 'After a blackout, An Sheng hears his mother’s twenty-year-old forecast, always cutting off before “When you grow up, I hope…” He believes the original tape contains her true expectation.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā yán shīxiàng zǒu dào dùkǒu, yòu jìnrù fèiqì jùchǎng xúnzhǎo lùyīn láiyuán. Chuándí, cháoshēng, mùbù hé mǔqin niánqīng shí de hēngchàng bǎ liǎng gè shídài lián zài yìqǐ, què méiyǒu bǔchū zuìhòu yí jù. Jiùjiu shuō mǔqin dāngnián huànguò xǔduō gōngzuò, yě chángcháng gǎibiàn xiǎngfǎ, bù gāi bǎ yí cì lùyīn dàng chéng zhōngshēn mìnglìng.',
        vietnamese: 'Bến đò, nhà hát, còi tàu và tiếng hát nối hai thời đại nhưng không bổ sung câu cuối. Cậu được nhắc một bản ghi không nên thành mệnh lệnh suốt đời.',
        english: 'Ferry, theatre, horn, tide, and humming connect two eras without completing the line. His uncle warns that one recording should not become a lifelong command.',
      ),
      ReadingAnnotation(
        pinyin: 'Ān Shēng shēngqì, juéde jiārén zhǐ shì hàipà tā shuōchū zhēnxiàng. Zhídào wàipó náchū jǐ fēng niánfèn bùtóng de xìn, měi fēng dōu xiězhe bù yíyàng de yuànwàng: píng’ān, zìyóu, yuànyì huílái, yě gǎn zǒuyuǎn. Quēshī jùzi bú shì wéiyī dá’àn de rùkǒu, ér shì yí gè rén shàngwèi shuōwán, hòulái réng huì biànhuà de shēngmìng.',
        vietnamese: 'Các thư năm khác nhau ghi mong muốn khác nhau: bình an, tự do, về nhà và dám đi xa. Câu thiếu không dẫn tới đáp án duy nhất mà tới một đời người còn thay đổi.',
        english: 'Letters from different years wish for safety, freedom, return, and distance. The missing line does not lead to one answer, but to a life still changing.',
      ),
      ReadingAnnotation(
        pinyin: 'Ān Shēng méiyǒu mófǎng mǔqin bǔwán nà jù huà. Tā lùxià zìjǐ, wàipó, jiùjiu hé hǎibiān háizi de shēngyīn, jiē zài zhōngduàn chù yǐhòu, què bǎoliú nà yì miǎo kòngbái. Dùchuán míngdí shí, jiù lùyīn méiyǒu bèi xiū chéng wánměi yíyán, ér chéngwéi yì jiārén kěyǐ jìxù huíyìng de kāifàng xìnjiàn.',
        vietnamese: 'Cậu thêm tiếng của gia đình và trẻ ven biển nhưng giữ một giây trống. Bản ghi không thành di ngôn hoàn hảo mà thành lá thư mở để mọi người tiếp tục đáp.',
        english: 'He adds family and coastal voices while preserving one second of silence. The recording becomes an open letter rather than a perfected final statement.',
      ),
    ],
    wonderQuestion: '为什么一句没有说完的话不应该被后来的人随意当成唯一遗愿？',
    expressQuestion: '请写一段保留一处空白、邀请家人继续回答的声音留言。',
  ),
  'arcade-lost-property': EditorialStoryRevision(
    id: 'arcade-lost-property',
    protagonist: '失物员阿芷',
    narrativeMode: '多证人公案',
    emotionalArc: '急于破案 → 证词冲突 → 放弃找罪人 → 帮助归还',
    endingMode: '真相不是抓到谁，而是恢复关系',
    sections: [
      '岭南雨季，一把红伞被送进骑楼失物局。伞面全湿，地上却没有水迹；登记册里还夹着三十年前的茶楼铜牌。失物员阿芷立即宣布这是大案，决心在下班前找出“偷走记忆的人”。',
      '修表师记得伞，却说主人是年轻女人；老茶客记得铜牌，却坚持主人是男孩；照相馆底片里，两人又站在同一把伞下。证词互相冲突，阿芷越想选出一个正确版本，越发现每个人只保存了关系中的一小段。',
      '暴雨冲洗花砖时，伞影指向封闭多年的院门。门后没有罪案现场，只有无人认领的生活物件和一封迟到道歉：当年的姐弟因搬迁失散，都以为对方故意不告而别。阿芷终于放下“抓人”的表格，改做物件联系图。',
      '物件逐一归还，红伞却留在失物局门口，供重新见面的姐弟一起取走。第二天阳光穿过骑楼，伞下出现两道正常影子。阿芷的结案报告没有写“犯人”，只写：“同一件往事可以有冲突证词，调查的责任是让人有机会重新说话。”',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Lǐngnán yǔjì, yì bǎ hóngsǎn bèi sòng jìn qílóu shīwùjú. Sǎnmiàn quán shī, dìshàng què méiyǒu shuǐjì; dēngjìcè lǐ hái jiāzhe sānshí nián qián de chálóu tóngpái. Shīwùyuán Ā Zhǐ lìjí xuānbù zhè shì dà’àn, juéxīn zài xiàbān qián zhǎochū “tōuzǒu jìyì de rén”.',
        vietnamese: 'Mùa mưa Lĩnh Nam, chiếc ô đỏ ướt nhưng không để nước, kèm thẻ trà lâu ba mươi năm. A Chỉ coi đây là vụ lớn và muốn tìm kẻ trộm ký ức.',
        english: 'In the Lingnan rains, a wet red umbrella leaves no water and arrives with a thirty-year-old tea-house token. Lost-property clerk Azhi vows to find the thief of memory.',
      ),
      ReadingAnnotation(
        pinyin: 'Xiūbiǎoshī jìde sǎn, què shuō zhǔrén shì niánqīng nǚrén; lǎo chákè jìde tóngpái, què jiānchí zhǔrén shì nánhái; zhàoxiàngguǎn dǐpiàn lǐ, liǎng rén yòu zhàn zài tóng yì bǎ sǎn xià. Zhèngcí hùxiāng chōngtū, Ā Zhǐ yuè xiǎng xuǎnchū yí gè zhèngquè bǎnběn, yuè fāxiàn měi gè rén zhǐ bǎocún le guānxì zhōng de yì xiǎo duàn.',
        vietnamese: 'Thợ đồng hồ nhớ phụ nữ, khách trà nhớ cậu bé, còn phim ảnh cho thấy cả hai dưới một ô. Mỗi chứng nhân chỉ giữ một phần quan hệ.',
        english: 'A watchmaker remembers a woman, a tea drinker remembers a boy, and film shows both under the umbrella. Each witness holds only part of the relationship.',
      ),
      ReadingAnnotation(
        pinyin: 'Bàoyǔ chōngxǐ huāzhuān shí, sǎnyǐng zhǐxiàng fēngbì duōnián de yuànmén. Ménhòu méiyǒu zuì’àn xiànchǎng, zhǐyǒu wúrén rènlǐng de shēnghuó wùjiàn hé yì fēng chídào dàoqiàn: dāngnián de jiědì yīn bānqiān shīsàn, dōu yǐwéi duìfāng gùyì bù gào ér bié. Ā Zhǐ zhōngyú fàngxià “zhuā rén” de biǎogé, gǎi zuò wùjiàn liánxìtú.',
        vietnamese: 'Sau cửa là đồ thất lạc và thư xin lỗi của chị em bị chia lìa, mỗi người tưởng người kia bỏ đi. A Chỉ bỏ bảng tìm tội phạm và vẽ sơ đồ liên hệ đồ vật.',
        english: 'Behind the door are lost objects and an apology between siblings separated by relocation. Azhi abandons the suspect form and maps relationships among objects.',
      ),
      ReadingAnnotation(
        pinyin: 'Wùjiàn zhúyī guīhuán, hóngsǎn què liú zài shīwùjú ménkǒu, gōng chóngxīn jiànmiàn de jiědì yìqǐ qǔzǒu. Dì èr tiān yángguāng chuānguò qílóu, sǎnxià chūxiàn liǎng dào zhèngcháng yǐngzi. Ā Zhǐ de jié’àn bàogào méiyǒu xiě “fànrén”, zhǐ xiě: “Tóng yí jiàn wǎngshì kěyǐ yǒu chōngtū zhèngcí, diàochá de zérèn shì ràng rén yǒu jīhuì chóngxīn shuōhuà.”',
        vietnamese: 'Chị em cùng lấy ô và hai bóng hiện ra. Báo cáo của A Chỉ không ghi thủ phạm mà ghi điều tra phải cho người cơ hội nói lại.',
        english: 'The siblings collect the umbrella together and two shadows appear. Azhi reports no culprit, only that investigation should give people a chance to speak again.',
      ),
    ],
    wonderQuestion: '当证人的记忆互相冲突时，为什么不能急着选一个人当作唯一真相？',
    expressQuestion: '请用“证词一、证词二、共同证据”写一段公案记录。',
  ),
  'tea-horse-echo': EditorialStoryRevision(
    id: 'tea-horse-echo',
    protagonist: '索朗',
    narrativeMode: '社区声音版权争议',
    emotionalArc: '想独占素材 → 被拒绝 → 理解共同记忆 → 共同署名',
    endingMode: '档案留在社区并允许带走副本',
    sections: [
      '索朗带着录音机走上茶马古道，想制作一档能获奖的声音节目。第一段录音回放时，多出看不见的马帮铃声。他兴奋地说这是自己的独家发现，却被村里的孩子拦住：“路记得的是大家，为什么只署你的名字？”',
      '雨落进旧茶仓，马鞍、茶饼和石阶依次发出回声。老人讲道路连接交换、迁徙和普通人的脚步，村民也正用护坡植物修复滑坡支线。索朗原以为录音只要声音清楚就属于录音者，却发现每一段都来自别人生活的空间。',
      '他准备剪辑时，神秘马铃总在村民姓名被删掉的地方响得刺耳，在保留共同讲述的地方变得清晰。索朗没有把它当诅咒，而是召开试听会，让居民决定哪些声音可以公开、哪些只能留在社区档案。',
      '节目最后以“索朗录音、全村共同讲述”署名，母带留给村校，索朗只带走获许可的副本。古道恢复安静，远处回声却不再像过去追赶今天，而像未来的人正在练习先询问，再把故事带上路。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Suǒlǎng dàizhe lùyīnjī zǒushàng Chámǎ Gǔdào, xiǎng zhìzuò yì dàng néng huòjiǎng de shēngyīn jiémù. Dì yí duàn lùyīn huífàng shí, duō chū kànbujiàn de mǎbāng língshēng. Tā xīngfèn de shuō zhè shì zìjǐ de dújiā fāxiàn, què bèi cūn lǐ de háizi lánzhù: “Lù jìde de shì dàjiā, wèishénme zhǐ shǔ nǐ de míngzi?”',
        vietnamese: 'Tác Lãng ghi được tiếng chuông đoàn ngựa vô hình và gọi đó là phát hiện độc quyền. Trẻ trong làng hỏi con đường nhớ mọi người, sao chỉ ghi tên cậu.',
        english: 'Suolang records invisible caravan bells and calls them his exclusive discovery. Village children ask why a road remembering everyone should carry only his name.',
      ),
      ReadingAnnotation(
        pinyin: 'Yǔ luò jìn jiù chácāng, mǎ’ān, chábǐng hé shíjiē yīcì fāchū huíshēng. Lǎorén jiǎng dàolù liánjiē jiāohuàn, qiānyí hé pǔtōngrén de jiǎobù, cūnmín yě zhèng yòng hùpō zhíwù xiūfù huápō zhīxiàn. Suǒlǎng yuán yǐwéi lùyīn zhǐyào shēngyīn qīngchu jiù shǔyú lùyīnzhě, què fāxiàn měi yí duàn dōu láizì biérén shēnghuó de kōngjiān.',
        vietnamese: 'Kho trà, yên ngựa và bậc đá vang cùng chuyện trao đổi, di cư và sửa đường. Cậu hiểu âm thanh rõ không tự động thuộc người bấm máy.',
        english: 'Tea warehouse, saddle, and steps echo exchange, migration, and road repair. He learns that a clear recording does not automatically belong to the recorder.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā zhǔnbèi jiǎnjí shí, shénmì mǎlíng zǒng zài cūnmín xìngmíng bèi shāndiào de dìfang xiǎng de cì’ěr, zài bǎoliú gòngtóng jiǎngshù de dìfang biàn de qīngxī. Suǒlǎng méiyǒu bǎ tā dàng zǔzhòu, ér shì zhàokāi shìtīnghuì, ràng jūmín juédìng nǎxiē shēngyīn kěyǐ gōngkāi, nǎxiē zhǐ néng liú zài shèqū dàng’àn.',
        vietnamese: 'Chuông chói khi tên cư dân bị xóa và rõ khi lời kể chung được giữ. Cậu tổ chức nghe thử để cộng đồng quyết định âm nào được công khai.',
        english: 'The bells turn harsh when names are removed and clear when shared narration remains. Suolang holds a listening meeting so residents decide what may be public.',
      ),
      ReadingAnnotation(
        pinyin: 'Jiémù zuìhòu yǐ “Suǒlǎng lùyīn, quáncūn gòngtóng jiǎngshù” shǔmíng, mǔdài liúgěi cūnxiào, Suǒlǎng zhǐ dàizǒu huò xǔkě de fùběn. Gǔdào huīfù ānjìng, yuǎnchù huíshēng què bú zài xiàng guòqù zhuīgǎn jīntiān, ér xiàng wèilái de rén zhèngzài liànxí xiān xúnwèn, zài bǎ gùshi dài shàng lù.',
        vietnamese: 'Chương trình ghi “Tác Lãng thu âm, cả làng cùng kể”, băng gốc ở trường làng. Tương lai học cách hỏi trước khi mang chuyện đi.',
        english: 'The program credits “recorded by Suolang, told by the whole village,” with the master kept at school. Future travellers learn to ask before carrying stories away.',
      ),
    ],
    wonderQuestion: '记录社区声音时，为什么清楚录到并不等于可以独自拥有和公开？',
    expressQuestion: '请为一段共同完成的录音写署名、用途和许可说明。',
  ),
  'ice-city-star-map': EditorialStoryRevision(
    id: 'ice-city-star-map',
    protagonist: '娜娜',
    narrativeMode: '工业记忆公共策展',
    emotionalArc: '把父辈想成英雄 → 发现普通与矛盾 → 接受复杂记忆 → 共同策展',
    endingMode: '展览留下可继续添加的空坐标',
    sections: [
      '旧厂停产后的第十二个冬天，娜娜在父亲更衣柜里发现一张由管道、车床和夜班路线组成的星图。她立刻想把父亲写成“拯救工厂的英雄”，却在值班记录中发现他曾因一次错误停机受到批评。',
      '娜娜启动模拟控制台，厂房天窗依次亮起，高处管线与真实星空重合。老工人指出，每个坐标并非英雄事迹，而是焊工、清洁员、食堂师傅、质检员和维修员普通岗位曾经发光的位置。工厂的记忆没有单一主角。',
      '是否展示父亲的错误让娜娜和母亲发生争执。母亲担心孩子只记住失败，娜娜却不愿用漂亮故事盖住真实。她们最后把停机记录、改进措施和同事评价放在一起，让观众看见错误怎样被发现、承担和修正。',
      '春天前，旧厂改成社区档案馆。孩子们在涡轮大厅仰望星图，也能为家人的普通岗位增加新坐标。娜娜没有把父亲放在最亮的星，而把他放在一组互相连接的点中。展览从“话说当年”开始，却没有替未来写完最后一章。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Jiùchǎng tíngchǎn hòu de dì shí’èr gè dōngtiān, Nànà zài fùqin gēngyīguì lǐ fāxiàn yì zhāng yóu guǎndào, chēchuáng hé yèbān lùxiàn zǔchéng de xīngtú. Tā lìkè xiǎng bǎ fùqin xiě chéng “zhěngjiù gōngchǎng de yīngxióng”, què zài zhíbān jìlù zhōng fāxiàn tā céng yīn yí cì cuòwù tíngjī shòudào pīpíng.',
        vietnamese: 'Mùa đông thứ mười hai sau khi nhà máy dừng, Na Na tìm bản đồ sao từ đường ống và ca đêm. Cô muốn viết cha thành anh hùng nhưng thấy hồ sơ từng phê bình lỗi dừng máy.',
        english: 'Twelve winters after closure, Nana finds a star map made of pipes and shifts. She wants to cast her father as a hero, then finds a record of a shutdown caused by his mistake.',
      ),
      ReadingAnnotation(
        pinyin: 'Nànà qǐdòng mónǐ kòngzhìtái, chǎngfáng tiānchuāng yīcì liàngqǐ, gāochù guǎnxiàn yǔ zhēnshí xīngkōng chónghé. Lǎo gōngrén zhǐchū, měi gè zuòbiāo bìngfēi yīngxióng shìjì, ér shì hàngōng, qīngjiéyuán, shítáng shīfu, zhìjiǎnyuán hé wéixiūyuán pǔtōng gǎngwèi céngjīng fāguāng de wèizhi. Gōngchǎng de jìyì méiyǒu dānyī zhǔjiǎo.',
        vietnamese: 'Mỗi tọa độ thuộc thợ hàn, vệ sinh, bếp, chất lượng và bảo trì, không phải chiến công anh hùng. Ký ức nhà máy không có một nhân vật chính.',
        english: 'Each coordinate belongs to welders, cleaners, cooks, inspectors, and repair workers rather than one heroic deed. Factory memory has no single protagonist.',
      ),
      ReadingAnnotation(
        pinyin: 'Shìfǒu zhǎnshì fùqin de cuòwù ràng Nànà hé mǔqin fāshēng zhēngzhí. Mǔqin dānxīn háizi zhǐ jìzhù shībài, Nànà què bù yuàn yòng piàoliang gùshi gàizhù zhēnshí. Tāmen zuìhòu bǎ tíngjī jìlù, gǎijìn cuòshī hé tóngshì píngjià fàng zài yìqǐ, ràng guānzhòng kànjiàn cuòwù zěnyàng bèi fāxiàn, chéngdān hé xiūzhèng.',
        vietnamese: 'Mẹ sợ trẻ chỉ nhớ thất bại, Na Na không muốn che sự thật. Họ trưng hồ sơ lỗi, biện pháp và đánh giá để cho thấy cách chịu trách nhiệm và sửa.',
        english: 'Her mother fears children will remember failure, while Nana refuses to hide truth. They display the error, response, and colleague accounts together.',
      ),
      ReadingAnnotation(
        pinyin: 'Chūntiān qián, jiùchǎng gǎi chéng shèqū dàng’ànguǎn. Háizimen zài wōlún dàtīng yǎngwàng xīngtú, yě néng wèi jiārén de pǔtōng gǎngwèi zēngjiā xīn zuòbiāo. Nànà méiyǒu bǎ fùqin fàng zài zuì liàng de xīng, ér bǎ tā fàng zài yì zǔ hùxiāng liánjiē de diǎn zhōng. Zhǎnlǎn cóng “huàshuō dāngnián” kāishǐ, què méiyǒu tì wèilái xiěwán zuìhòu yì zhāng.',
        vietnamese: 'Kho lưu trữ cho trẻ thêm tọa độ của các công việc bình thường. Na Na đặt cha giữa mạng điểm liên kết chứ không ở ngôi sao sáng nhất.',
        english: 'The archive lets children add ordinary jobs. Nana places her father among connected points rather than at the brightest star.',
      ),
    ],
    wonderQuestion: '公共记忆为什么应该同时记录贡献、错误和改进，而不是只塑造英雄？',
    expressQuestion: '请为一个普通岗位写三句展签：做什么、遇到什么问题、怎样改进。',
  ),
};
