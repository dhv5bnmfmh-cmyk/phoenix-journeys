import 'special_journey_story_enrichment.dart';

const storySystemSpecialJourneyIds = <String>{
  'literary-roaming',
  'myth-tracing',
  'strange-night-talks',
  'folk-secret-land',
  'changan-last-bus',
  'tide-letter',
  'arcade-lost-property',
  'tea-horse-echo',
  'ice-city-star-map',
};

List<SpecialJourneyEnrichmentText> specialJourneyStoryEnrichmentForStorySystem(
  String journeyId,
) {
  return switch (journeyId) {
    'changan-last-bus' => _changanLastBus,
    'tide-letter' => _tideLetter,
    'arcade-lost-property' => _arcadeLostProperty,
    'tea-horse-echo' => _teaHorseEcho,
    'ice-city-star-map' => _iceCityStarMap,
    _ => specialJourneyStoryEnrichmentFor(journeyId),
  };
}

const _changanLastBus = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '小墨先核对车门、监控和乘客人数，旧票却在打孔机下留下一个现代线路图里没有的坊名。',
    pinyin: 'Xiǎo Mò xiān héduì chēmén, jiānkòng hé chéngkè rénshù, jiùpiào què zài dǎkǒngjī xià liúxià yí gè xiàndài xiànlùtú lǐ méiyǒu de fāngmíng.',
    vietnamese: 'Tiểu Mặc kiểm tra cửa xe, camera và số hành khách, nhưng vé cũ lại in ra tên một phường không có trên bản đồ tuyến hiện đại.',
    english: 'Xiaomo checks the doors, cameras, and passenger count, yet the old ticket prints a ward name absent from the modern route map.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '铜镜映出的不是车厢，而是一条灯火稀疏的长街；老人每说出一个城门，车窗外就短暂重叠另一层夜色。',
    pinyin: 'Tóngjìng yìngchū de bú shì chēxiāng, ér shì yì tiáo dēnghuǒ xīshū de chángjiē; lǎorén měi shuōchū yí gè chéngmén, chēchuāng wài jiù duǎnzàn chóngdié lìng yì céng yèsè.',
    vietnamese: 'Gương đồng không phản chiếu khoang xe mà là con phố thưa đèn; mỗi khi ông lão gọi tên một cổng thành, ngoài cửa kính lại chồng lên một lớp đêm khác.',
    english: 'The bronze mirror reflects a dim old avenue instead of the bus, and each gate the elder names briefly overlays another night beyond the windows.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '小墨没有把异常当作表演，他请司机保持原路线，又逐站记录镜面变化，避免一车乘客跟着未知方向冒险。',
    pinyin: 'Xiǎo Mò méiyǒu bǎ yìcháng dàngzuò biǎoyǎn, tā qǐng sījī bǎochí yuán lùxiàn, yòu zhúzhàn jìlù jìngmiàn biànhuà, bìmiǎn yì chē chéngkè gēnzhe wèizhī fāngxiàng màoxiǎn.',
    vietnamese: 'Tiểu Mặc không biến hiện tượng lạ thành trò diễn; cậu giữ nguyên tuyến xe và ghi lại thay đổi ở từng trạm để không kéo cả xe vào hướng chưa biết.',
    english: 'Xiaomo refuses to turn the anomaly into a show, keeps the scheduled route, and logs each change so the whole bus is not drawn into an unknown direction.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '老人记不起现代站名，却准确说出哪条旧街通向家门。小墨把“无票乘车”改记为“身份待核、需要协助返程”。',
    pinyin: 'Lǎorén jìbuqǐ xiàndài zhànmíng, què zhǔnquè shuōchū nǎ tiáo jiùjiē tōngxiàng jiāmén. Xiǎo Mò bǎ “wúpiào chéngchē” gǎijì wéi “shēnfèn dài hé, xūyào xiézhù fǎnchéng”.',
    vietnamese: 'Ông lão không nhớ tên trạm hiện đại nhưng biết rõ phố cũ nào dẫn về nhà. Tiểu Mặc đổi ghi chú “đi xe không vé” thành “chờ xác minh danh tính, cần hỗ trợ trở về”.',
    english: 'The elder cannot name modern stops but knows which old street leads home. Xiaomo changes “fare evasion” to “identity pending, return assistance required.”',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '末站将到时，镜中的灯影与现实路灯短暂对齐，半张旧票终于补出另一半，却没有写明老人来自哪个年代。',
    pinyin: 'Mòzhàn jiāng dào shí, jìng zhōng de dēngyǐng yǔ xiànshí lùdēng duǎnzàn duìqí, bàn zhāng jiùpiào zhōngyú bǔchū lìng yí bàn, què méiyǒu xiěmíng lǎorén láizì nǎ gè niándài.',
    vietnamese: 'Khi gần đến bến cuối, ánh đèn trong gương trùng với đèn đường và nửa vé còn lại hiện ra, nhưng không ghi ông lão đến từ thời nào.',
    english: 'Near the terminus, mirror lights align with streetlamps and the missing half of the ticket appears, without naming the elder’s era.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '小墨把当夜记录封进运营档案，保留无法解释的空格。下一班车照常发出，责任没有因为谜团而暂停。',
    pinyin: 'Xiǎo Mò bǎ dāngyè jìlù fēng jìn yùnyíng dàng’àn, bǎoliú wúfǎ jiěshì de kònggé. Xià yì bān chē zhàocháng fāchū, zérèn méiyǒu yīnwèi mítuán ér zàntíng.',
    vietnamese: 'Tiểu Mặc niêm phong biên bản đêm đó và giữ nguyên phần chưa thể giải thích. Chuyến sau vẫn chạy, vì trách nhiệm không dừng lại trước bí ẩn.',
    english: 'Xiaomo seals the night report with its unexplained blank. The next bus departs on time, because responsibility does not pause for a mystery.',
  ),
];

const _tideLetter = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '安声把收音机拆开，发现磁带没有断，只是海潮般的底噪一次次盖住母亲最后半句。',
    pinyin: 'Ān Shēng bǎ shōuyīnjī chāikāi, fāxiàn cídài méiyǒu duàn, zhǐshì hǎicháo bān de dǐzào yí cì cì gàizhù mǔqīn zuìhòu bàn jù.',
    vietnamese: 'An Thanh tháo chiếc radio và thấy băng không đứt; chỉ có lớp nhiễu như thủy triều liên tục phủ lên nửa câu cuối của mẹ.',
    english: 'Ansheng opens the radio and finds the tape intact, while tide-like noise repeatedly covers his mother’s final half-sentence.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '他把天气预报的时间、风向和潮位抄下来，想用精确数据证明录音对应哪一天，却发现家人记得的是不同夜晚。',
    pinyin: 'Tā bǎ tiānqì yùbào de shíjiān, fēngxiàng hé cháowèi chāo xiàlai, xiǎng yòng jīngquè shùjù zhèngmíng lùyīn duìyìng nǎ yì tiān, què fāxiàn jiārén jìde de shì bùtóng yèwǎn.',
    vietnamese: 'Cậu chép giờ, hướng gió và mực triều để xác định ngày ghi âm, nhưng mỗi người trong nhà lại nhớ một đêm khác.',
    english: 'He copies the time, wind, and tide level to identify the date, only to find that each relative remembers a different night.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '姨妈说母亲希望他勇敢，外婆说她只盼他平安，父亲却承认当年谁也没有听完整那句话。',
    pinyin: 'Yímā shuō mǔqīn xīwàng tā yǒnggǎn, wàipó shuō tā zhǐ pàn tā píng’ān, fùqīn què chéngrèn dāngnián shéi yě méiyǒu tīng wánzhěng nà jù huà.',
    vietnamese: 'Dì nói mẹ mong cậu can đảm, bà ngoại nói bà chỉ mong cậu bình an, còn cha thừa nhận năm ấy không ai nghe trọn câu.',
    english: 'An aunt remembers courage, a grandmother remembers safety, and his father admits that nobody heard the sentence in full.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '安声差点把自己最想听的答案补进空白，手指停在录音键上时，窗外潮声正好退去。',
    pinyin: 'Ān Shēng chàdiǎn bǎ zìjǐ zuì xiǎng tīng de dá’àn bǔ jìn kòngbái, shǒuzhǐ tíng zài lùyīnjiàn shàng shí, chuāngwài cháoshēng zhènghǎo tuìqù.',
    vietnamese: 'An Thanh suýt điền câu trả lời mình mong nhất vào chỗ trống; khi ngón tay dừng trên nút thu, tiếng triều ngoài cửa vừa rút.',
    english: 'Ansheng nearly fills the blank with the answer he most wants, but pauses over Record as the tide withdraws outside.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '家人依次录下“我记得”“我不确定”和“我现在想对你说”，没有一句冒充母亲遗失的原话。',
    pinyin: 'Jiārén yīcì lùxià “wǒ jìde”, “wǒ bù quèdìng” hé “wǒ xiànzài xiǎng duì nǐ shuō”, méiyǒu yí jù màochōng mǔqīn yíshī de yuánhuà.',
    vietnamese: 'Mỗi người lần lượt ghi “tôi nhớ”, “tôi không chắc” và “bây giờ tôi muốn nói”, không câu nào giả làm lời đã mất của mẹ.',
    english: 'The family records “I remember,” “I am unsure,” and “what I want to say now,” with none pretending to be the lost original.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '新录音保留那段潮声和空白。安声明白，爱可以继续说下去，却不能替一个不在场的人完成句子。',
    pinyin: 'Xīn lùyīn bǎoliú nà duàn cháoshēng hé kòngbái. Ān Shēng míngbai, ài kěyǐ jìxù shuō xiàqù, què bùnéng tì yí gè bú zàichǎng de rén wánchéng jùzi.',
    vietnamese: 'Bản ghi mới giữ lại tiếng triều và khoảng trống. An Thanh hiểu tình yêu có thể tiếp lời, nhưng không thể nói thay người vắng mặt.',
    english: 'The new recording keeps the tide and the blank. Ansheng learns that love may continue speaking without completing a sentence for someone absent.',
  ),
];

const _arcadeLostProperty = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '阿芷把红伞撑开晾在骑楼下，伞骨间掉出一张茶楼座位票，日期却比铜牌晚了整整十年。',
    pinyin: 'Ā Zhǐ bǎ hóngsǎn chēngkāi liàng zài qílóu xià, sǎngǔ jiān diàochū yì zhāng chálóu zuòwèipiào, rìqī què bǐ tóngpái wǎn le zhěngzhěng shí nián.',
    vietnamese: 'A Chỉ mở chiếc ô đỏ dưới hành lang; từ nan ô rơi ra vé chỗ ngồi quán trà có ngày muộn hơn tấm thẻ đồng đúng mười năm.',
    english: 'Azhi opens the red umbrella beneath the arcade, and a teahouse seat ticket falls out dated exactly ten years after the brass plaque.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '茶客说伞属于一位歌女，修伞匠说主人是送报童，旧照片里两个人却都握过同一把伞。',
    pinyin: 'Chákè shuō sǎn shǔyú yí wèi gēnǚ, xiūsǎnjiàng shuō zhǔrén shì sòngbàotóng, jiù zhàopiàn lǐ liǎng gè rén què dōu wòguo tóng yì bǎ sǎn.',
    vietnamese: 'Khách trà nói ô của ca nữ, thợ sửa ô nói của cậu bé giao báo, còn ảnh cũ cho thấy cả hai từng cầm cùng một chiếc ô.',
    english: 'A patron names a singer, a repairer names a newsboy, and an old photograph shows both holding the same umbrella.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '阿芷原想找出谁说谎，却发现每份证词只记住不同年份。骑楼替人遮过许多场雨，也让物件在不同关系之间流动。',
    pinyin: 'Ā Zhǐ yuán xiǎng zhǎochū shéi shuōhuǎng, què fāxiàn měi fèn zhèngcí zhǐ jìzhù bùtóng niánfèn. Qílóu tì rén zhēguo xǔduō chǎng yǔ, yě ràng wùjiàn zài bùtóng guānxì zhījiān liúdòng.',
    vietnamese: 'A Chỉ định tìm người nói dối, rồi nhận ra mỗi lời khai chỉ giữ một năm khác nhau. Hành lang đã che nhiều trận mưa và để đồ vật đi qua nhiều mối quan hệ.',
    english: 'Azhi hunts for a liar, then sees that each witness remembers a different year. The arcade sheltered many rains and let objects move through different relationships.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '登记册背面藏着一句褪色留言：“借伞的人不用归还给我，只要下一场雨有人不淋湿。”',
    pinyin: 'Dēngjìcè bèimiàn cángzhe yí jù tuìsè liúyán: “Jiè sǎn de rén búyòng guīhuán gěi wǒ, zhǐyào xià yì chǎng yǔ yǒurén bù línshī.”',
    vietnamese: 'Mặt sau sổ đăng ký có lời nhắn phai: “Người mượn không cần trả tôi, chỉ cần trận mưa sau có người không bị ướt.”',
    english: 'A faded note on the register says, “Do not return the umbrella to me, only keep someone dry in the next rain.”',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '阿芷没有宣布唯一主人，而是联系两家后人，把照片、票根和铜牌并列展示，让彼此补充缺失部分。',
    pinyin: 'Ā Zhǐ méiyǒu xuānbù wéiyī zhǔrén, ér shì liánxì liǎng jiā hòurén, bǎ zhàopiàn, piàogēn hé tóngpái bìngliè zhǎnshì, ràng bǐcǐ bǔchōng quēshī bùfen.',
    vietnamese: 'A Chỉ không tuyên bố một chủ duy nhất; cô liên hệ hậu duệ hai nhà và trưng ảnh, cuống vé, thẻ đồng cạnh nhau để bổ sung phần thiếu.',
    english: 'Azhi names no sole owner. She brings both families together and displays the photo, ticket stub, and plaque so each can fill gaps.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '红伞最后回到失物局门口，成为雨天可以借用的公伞。真相没有抓住罪人，却让一件旧物重新服务关系。',
    pinyin: 'Hóngsǎn zuìhòu huídào shīwùjú ménkǒu, chéngwéi yǔtiān kěyǐ jièyòng de gōngsǎn. Zhēnxiàng méiyǒu zhuāzhù zuìrén, què ràng yí jiàn jiùwù chóngxīn fúwù guānxì.',
    vietnamese: 'Chiếc ô đỏ trở thành ô công cộng trước phòng thất lạc. Sự thật không bắt được kẻ có tội, nhưng giúp đồ vật cũ lại phục vụ mối quan hệ.',
    english: 'The red umbrella becomes a public loan umbrella at the lost-property office. The truth catches no culprit, but restores an old object to relationship.',
  ),
];

const _teaHorseEcho = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '索朗把录音放大后，听见马铃之外还有赶马人的口令、孩子的歌和远处磨坊转动的低声。',
    pinyin: 'Suǒlǎng bǎ lùyīn fàngdà hòu, tīngjiàn mǎlíng zhīwài hái yǒu gǎnmǎrén de kǒulìng, háizi de gē hé yuǎnchù mòfáng zhuǎndòng de dīshēng.',
    vietnamese: 'Khi phóng lớn bản ghi, Sách Lãng nghe ngoài chuông ngựa còn có khẩu lệnh, bài hát trẻ em và tiếng cối xay xa.',
    english: 'When Solang amplifies the recording, mule bells reveal calls, children’s songs, and a distant mill beneath them.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '村民指出其中一段祭路歌只在特定场合唱，清楚录到并不等于可以剪进公开节目。',
    pinyin: 'Cūnmín zhǐchū qízhōng yí duàn jìlùgē zhǐ zài tèdìng chǎnghé chàng, qīngchu lùdào bìng bù děngyú kěyǐ jiǎn jìn gōngkāi jiémù.',
    vietnamese: 'Dân làng nói một đoạn hát lễ đường chỉ dùng trong dịp nhất định; ghi rõ không có nghĩa được phép phát công khai.',
    english: 'Villagers explain that one road-ritual song belongs to a specific occasion; recording it clearly does not grant permission to broadcast it.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '索朗起初担心删掉声音会失去独家价值，后来发现节目真正缺少的是谁有权讲述、谁承担公开后的后果。',
    pinyin: 'Suǒlǎng qǐchū dānxīn shāndiào shēngyīn huì shīqù dújiā jiàzhí, hòulái fāxiàn jiémù zhēnzhèng quēshǎo de shì shéi yǒu quán jiǎngshù, shéi chéngdān gōngkāi hòu de hòuguǒ.',
    vietnamese: 'Ban đầu cậu sợ xóa âm thanh sẽ mất tính độc quyền, rồi hiểu chương trình thiếu câu trả lời về quyền kể và trách nhiệm sau công bố.',
    english: 'He fears losing an exclusive, then realizes the program lacks answers about who may tell the story and who bears the consequences.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '孩子们带他重走一段古道，说明哪些铃声属于运输记忆，哪些歌仍属于今天活着的社区。',
    pinyin: 'Háizimen dài tā chóng zǒu yí duàn gǔdào, shuōmíng nǎxiē língshēng shǔyú yùnshū jìyì, nǎxiē gē réng shǔyú jīntiān huózhe de shèqū.',
    vietnamese: 'Trẻ em dẫn cậu đi lại đường cổ, phân biệt chuông thuộc ký ức vận chuyển với những bài hát vẫn thuộc cộng đồng sống hôm nay.',
    english: 'Children retrace the trail with him, separating transport memory from songs that still belong to a living community.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '最终版本逐段写明录音者、讲述者、许可范围和不能公开的部分，村里保存母档，索朗只带走副本。',
    pinyin: 'Zuìzhōng bǎnběn zhúduàn xiěmíng lùyīnzhě, jiǎngshùzhě, xǔkě fànwéi hé bùnéng gōngkāi de bùfen, cūn lǐ bǎocún mǔdàng, Suǒlǎng zhǐ dàizǒu fùběn.',
    vietnamese: 'Bản cuối ghi người thu, người kể, phạm vi cho phép và phần không công khai; làng giữ bản gốc, Sách Lãng chỉ mang bản sao.',
    english: 'The final version credits recorders and narrators, states permissions and exclusions, leaves the master in the village, and lets Solang take a copy.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '节目播出时，最安静的一段没有马铃，只有脚步停下和一句说明：“这里的沉默也由社区决定。”',
    pinyin: 'Jiémù bōchū shí, zuì ānjìng de yí duàn méiyǒu mǎlíng, zhǐyǒu jiǎobù tíngxià hé yí jù shuōmíng: “Zhèlǐ de chénmò yě yóu shèqū juédìng.”',
    vietnamese: 'Trong chương trình, đoạn yên nhất không có chuông, chỉ có bước chân dừng và câu: “Sự im lặng ở đây cũng do cộng đồng quyết định.”',
    english: 'The quietest broadcast segment has no bells, only stopped footsteps and the line, “The community also decides what remains silent.”',
  ),
];

const _iceCityStarMap = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '娜娜沿星图走进旧厂房，发现每颗“星”其实对应一台机器、一次夜班交接或一条紧急疏散路线。',
    pinyin: 'Nànà yán xīngtú zǒujìn jiù chǎngfáng, fāxiàn měi kē “xīng” qíshí duìyìng yì tái jīqì, yí cì yèbān jiāojiē huò yì tiáo jǐnjí shūsàn lùxiàn.',
    vietnamese: 'Na Na đi theo bản đồ sao vào xưởng cũ và thấy mỗi “ngôi sao” là một máy, một lần giao ca hoặc tuyến sơ tán.',
    english: 'Nana follows the star map through the old factory and finds that each “star” marks a machine, shift handover, or evacuation route.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '父亲被批评的停机记录旁，还有同事补写的一句：那次停机避免了更大的故障，却也让全班少拿奖金。',
    pinyin: 'Fùqīn bèi pīpíng de tíngjī jìlù páng, hái yǒu tóngshì bǔxiě de yí jù: nà cì tíngjī bìmiǎn le gèng dà de gùzhàng, què yě ràng quánbān shǎo ná jiǎngjīn.',
    vietnamese: 'Bên biên bản dừng máy bị phê bình có ghi chú rằng quyết định ấy tránh lỗi lớn hơn nhưng khiến cả ca mất một phần thưởng.',
    english: 'Beside the criticized shutdown, a coworker notes that it prevented a larger failure while costing the whole shift a bonus.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '娜娜采访不同工人，有人记得父亲谨慎，有人记得他固执，还有人只记得他总把热水留给最后下班的人。',
    pinyin: 'Nànà cǎifǎng bùtóng gōngrén, yǒurén jìde fùqīn jǐnshèn, yǒurén jìde tā gùzhí, hái yǒurén zhǐ jìde tā zǒng bǎ rèshuǐ liú gěi zuìhòu xiàbān de rén.',
    vietnamese: 'Người nhớ cha cô thận trọng, người nhớ ông cố chấp, người chỉ nhớ ông luôn để nước nóng cho người tan ca cuối.',
    english: 'Some workers remember caution, some stubbornness, and one only remembers that her father saved hot water for the last person off shift.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '她删掉“英雄一生”的展板标题，改成“一个夜班工人的选择”，让赞扬、批评和普通生活同时出现。',
    pinyin: 'Tā shāndiào “yīngxióng yìshēng” de zhǎnbǎn biāotí, gǎi chéng “yí gè yèbān gōngrén de xuǎnzé”, ràng zànyáng, pīpíng hé pǔtōng shēnghuó tóngshí chūxiàn.',
    vietnamese: 'Cô bỏ tiêu đề “đời anh hùng”, đổi thành “lựa chọn của một công nhân ca đêm”, để lời khen, phê bình và đời thường cùng xuất hiện.',
    english: 'She replaces “A Hero’s Life” with “Choices of a Night-Shift Worker,” allowing praise, criticism, and ordinary life to coexist.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '旧同事把自己的工牌、误操作记录和一张食堂欠条放进展柜，星图从父亲个人故事变成多人共同的工业记忆。',
    pinyin: 'Jiù tóngshì bǎ zìjǐ de gōngpái, wùcāozuò jìlù hé yì zhāng shítáng qiàntiáo fàng jìn zhǎnguì, xīngtú cóng fùqīn gèrén gùshi biàn chéng duōrén gòngtóng de gōngyè jìyì.',
    vietnamese: 'Đồng nghiệp cũ thêm thẻ công, biên bản thao tác sai và giấy nợ căng tin, biến bản đồ từ chuyện riêng của cha thành ký ức công nghiệp chung.',
    english: 'Coworkers add badges, error reports, and a canteen debt note, turning the map from one father’s story into shared industrial memory.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '展览最后留下一颗没有名字的空星，旁边写着“请补上一段你愿意负责的记忆”，没有人再需要一个完美英雄。',
    pinyin: 'Zhǎnlǎn zuìhòu liúxià yì kē méiyǒu míngzi de kōngxīng, pángbiān xiězhe “qǐng bǔshàng yí duàn nǐ yuànyì fùzé de jìyì”, méiyǒu rén zài xūyào yí gè wánměi yīngxióng.',
    vietnamese: 'Triển lãm để lại một ngôi sao trống với lời mời “hãy thêm ký ức mà bạn sẵn sàng chịu trách nhiệm”; không ai còn cần người hùng hoàn hảo.',
    english: 'The exhibition leaves one unnamed star asking visitors to add a memory they can stand behind. Nobody needs a perfect hero anymore.',
  ),
];
