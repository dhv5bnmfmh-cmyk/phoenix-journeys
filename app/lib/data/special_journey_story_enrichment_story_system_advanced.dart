import 'special_journey_story_enrichment.dart';

List<SpecialJourneyEnrichmentText>
    additionalSpecialJourneyStoryEnrichmentFor(String journeyId) {
  return switch (journeyId) {
    'changan-last-bus' => _changanLastBusAdvanced,
    'tide-letter' => _tideLetterAdvanced,
    'arcade-lost-property' => _arcadeLostPropertyAdvanced,
    'tea-horse-echo' => _teaHorseEchoAdvanced,
    'ice-city-star-map' => _iceCityStarMapAdvanced,
    _ => const <SpecialJourneyEnrichmentText>[],
  };
}

const _changanLastBusAdvanced = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '车上有人催小墨把老人赶下去，也有人举起手机直播。小墨先关掉车内广播，请所有人说清自己担心的究竟是安全、时间还是猎奇。',
    pinyin: 'Chē shàng yǒurén cuī Xiǎo Mò bǎ lǎorén gǎn xiàqù, yě yǒurén jǔqǐ shǒujī zhíbō. Xiǎo Mò xiān guāndiào chēnèi guǎngbō, qǐng suǒyǒu rén shuōqīng zìjǐ dānxīn de jiūjìng shì ānquán, shíjiān háishi lièqí.',
    vietnamese: 'Có người giục Tiểu Mặc đuổi ông lão xuống, người khác giơ điện thoại phát trực tiếp. Cậu tắt loa và yêu cầu mọi người nói rõ họ lo về an toàn, thời gian hay chỉ tò mò.',
    english: 'Some passengers demand that the elder be removed while others livestream him. Xiaomo turns off the announcement and asks whether they fear danger, delay, or merely crave spectacle.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '司机发现导航每到旧城门附近就慢半拍，但车辆里程没有异常。小墨把机械数据和老人记忆分开记录，不让任何一种证据吞掉另一种。',
    pinyin: 'Sījī fāxiàn dǎoháng měi dào jiù chéngmén fùjìn jiù màn bàn pāi, dàn chēliàng lǐchéng méiyǒu yìcháng. Xiǎo Mò bǎ jīxiè shùjù hé lǎorén jìyì fēnkāi jìlù, bù ràng rènhé yì zhǒng zhèngjù tūndiào lìng yì zhǒng.',
    vietnamese: 'Tài xế thấy định vị chậm nửa nhịp gần các cổng thành cũ dù quãng đường xe bình thường. Tiểu Mặc ghi dữ liệu máy và ký ức của ông lão riêng biệt để không bên nào nuốt mất bên kia.',
    english: 'The navigation lags near old gates although the mileage stays normal. Xiaomo records machine data and the elder’s memory separately so neither kind of evidence erases the other.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '一名学生在地图上找到消失坊名对应的大致区域，却提醒大家那里如今是医院，不能为了验证传说让整车乘客闯入。',
    pinyin: 'Yì míng xuéshēng zài dìtú shàng zhǎodào xiāoshī fāngmíng duìyìng de dàzhì qūyù, què tíxǐng dàjiā nàlǐ rújīn shì yīyuàn, bùnéng wèile yànzhèng chuánshuō ràng zhěng chē chéngkè chuǎngrù.',
    vietnamese: 'Một học sinh xác định khu vực gần đúng của phường cũ nhưng nhắc rằng nơi ấy nay là bệnh viện, không thể để cả xe xông vào chỉ để kiểm chứng truyền thuyết.',
    english: 'A student locates the vanished ward, then notes that it is now a hospital and cannot be invaded merely to test a legend.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '小墨让老人从几个熟悉的气味和声音中辨认归途：药铺的苦香、河桥下的水声、清晨第一辆货车的铃。答案仍不完整，却比追逐幻影更接近照顾。',
    pinyin: 'Xiǎo Mò ràng lǎorén cóng jǐ gè shúxī de qìwèi hé shēngyīn zhōng biànrèn guītú: yàopù de kǔxiāng, héqiáo xià de shuǐshēng, qīngchén dì yí liàng huòchē de líng. Dá’àn réng bù wánzhěng, què bǐ zhuīzhú huànyǐng gèng jiējìn zhàogù.',
    vietnamese: 'Tiểu Mặc giúp ông nhận đường bằng mùi thuốc đắng, tiếng nước dưới cầu và chuông xe hàng đầu ngày. Câu trả lời chưa trọn nhưng gần với sự chăm sóc hơn việc đuổi theo ảo ảnh.',
    english: 'Xiaomo asks the elder to recognize home through bitter medicine, water under a bridge, and the first freight bell at dawn. The answer remains incomplete but is closer to care than chasing apparitions.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '到站后，老人没有消失，只在座位上睡着了。救助人员接手时，铜镜已经恢复普通倒影，给小墨留下的不是奇迹证明，而是一份需要继续追踪的交接单。',
    pinyin: 'Dào zhàn hòu, lǎorén méiyǒu xiāoshī, zhǐ zài zuòwèi shàng shuìzháo le. Jiùzhù rényuán jiēshǒu shí, tóngjìng yǐjīng huīfù pǔtōng dàoyǐng, gěi Xiǎo Mò liúxià de bú shì qíjì zhèngmíng, ér shì yí fèn xūyào jìxù zhuīzōng de jiāojiēdān.',
    vietnamese: 'Đến bến, ông lão không biến mất mà chỉ ngủ thiếp đi. Khi nhân viên hỗ trợ tiếp nhận, gương đã phản chiếu bình thường; thứ còn lại không phải bằng chứng phép lạ mà là phiếu bàn giao cần tiếp tục theo dõi.',
    english: 'At the terminus the elder does not vanish, but falls asleep. By the time support workers arrive, the mirror is ordinary, leaving Xiaomo not proof of a miracle but a handover that still requires follow-up.',
  ),
];

const _tideLetterAdvanced = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '安声把三份回忆排在同一时间线上，发现它们并非互相否定：有人记得母亲说话前的争吵，有人只记得她离开录音机后的沉默。',
    pinyin: 'Ān Shēng bǎ sān fèn huíyì pái zài tóng yì shíjiānxiàn shàng, fāxiàn tāmen bìngfēi hùxiāng fǒudìng: yǒurén jìde mǔqīn shuōhuà qián de zhēngchǎo, yǒurén zhǐ jìde tā líkāi lùyīnjī hòu de chénmò.',
    vietnamese: 'An Thanh đặt ba ký ức trên cùng dòng thời gian và nhận ra chúng không phủ định nhau: có người nhớ cuộc cãi vã trước lời nói, người khác chỉ nhớ sự im lặng sau khi mẹ rời máy ghi.',
    english: 'Ansheng places three memories on one timeline and sees that they need not cancel each other: one recalls the argument before the sentence, another the silence after his mother left the recorder.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '修复师可以削弱底噪，却警告每次处理都会同时削掉一部分人声。安声选择保存原带，只在副本上尝试，并把每一步修改写进记录。',
    pinyin: 'Xiūfùshī kěyǐ xuēruò dǐzào, què jǐnggào měi cì chǔlǐ dōu huì tóngshí xuēdiào yí bùfen rénshēng. Ān Shēng xuǎnzé bǎocún yuándài, zhǐ zài fùběn shàng chángshì, bìng bǎ měi yí bù xiūgǎi xiě jìn jìlù.',
    vietnamese: 'Chuyên gia có thể giảm nhiễu nhưng cảnh báo mỗi lần xử lý cũng xóa bớt giọng người. An Thanh giữ băng gốc, chỉ thử trên bản sao và ghi lại từng chỉnh sửa.',
    english: 'A restorer can reduce noise but warns that each pass also removes part of the voice. Ansheng preserves the original, experiments only on a copy, and logs every alteration.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '父亲终于承认，多年来他把自己的歉意想象成母亲的遗言，因为那样比较容易原谅自己。这个承认没有补出原句，却改变了全家的谈话方向。',
    pinyin: 'Fùqīn zhōngyú chéngrèn, duōnián lái tā bǎ zìjǐ de qiànyì xiǎngxiàng chéng mǔqīn de yíyán, yīnwèi nàyàng bǐjiào róngyì yuánliàng zìjǐ. Zhège chéngrèn méiyǒu bǔchū yuánjù, què gǎibiàn le quánjiā de tánhuà fāngxiàng.',
    vietnamese: 'Cha thừa nhận nhiều năm qua ông đã tưởng tượng lời xin lỗi của mình thành di ngôn của mẹ để dễ tha thứ cho bản thân. Lời thú nhận không khôi phục câu cũ nhưng đổi hướng cuộc trò chuyện gia đình.',
    english: 'His father admits that he had turned his own apology into her imagined last words because that made self-forgiveness easier. The confession restores no sentence, but changes the family conversation.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '安声邀请每个人标记“听见的”“推测的”和“现在想说的”，同一段录音因此不再被迫承担一个确定答案。',
    pinyin: 'Ān Shēng yāoqǐng měi gè rén biāojì “tīngjiàn de”, “tuīcè de” hé “xiànzài xiǎng shuō de”, tóng yí duàn lùyīn yīncǐ bú zài bèi pò chéngdān yí gè quèdìng dá’àn.',
    vietnamese: 'An Thanh mời mọi người đánh dấu phần “đã nghe”, “suy đoán” và “muốn nói bây giờ”, để bản ghi không còn bị ép mang một câu trả lời duy nhất.',
    english: 'Ansheng labels what was heard, inferred, and wished to be said now, freeing the recording from carrying one forced answer.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '他们把副本交给地方声音档案馆，说明其中包含家庭记忆而非完整事实。潮声每次漫过空白，都提醒听者：保存证据和承认不知道可以同时发生。',
    pinyin: 'Tāmen bǎ fùběn jiāo gěi dìfāng shēngyīn dàng’ànguǎn, shuōmíng qízhōng bāohán jiātíng jìyì ér fēi wánzhěng shìshí. Cháoshēng měi cì mànguò kòngbái, dōu tíxǐng tīngzhě: bǎocún zhèngjù hé chéngrèn bù zhīdào kěyǐ tóngshí fāshēng.',
    vietnamese: 'Họ gửi bản sao cho kho âm thanh địa phương và ghi rõ đây là ký ức gia đình, không phải sự thật hoàn chỉnh. Mỗi lần tiếng triều phủ khoảng trống, người nghe được nhắc rằng lưu bằng chứng và thừa nhận không biết có thể cùng tồn tại.',
    english: 'They deposit a copy with a local sound archive, labeling it family memory rather than complete fact. Each tide across the blank reminds listeners that preserving evidence and admitting uncertainty can coexist.',
  ),
];

const _arcadeLostPropertyAdvanced = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '阿芷给每位证人一张空白时间卡，只准写自己亲眼见过的部分。茶楼老板删掉了“肯定”，修伞匠也把“主人”改成“曾经使用的人”。',
    pinyin: 'Ā Zhǐ gěi měi wèi zhèngrén yì zhāng kòngbái shíjiānkǎ, zhǐ zhǔn xiě zìjǐ qīnyǎn jiànguo de bùfen. Chálóu lǎobǎn shāndiào le “kěndìng”, xiūsǎnjiàng yě bǎ “zhǔrén” gǎi chéng “céngjīng shǐyòng de rén”.',
    vietnamese: 'A Chỉ phát thẻ thời gian và chỉ cho nhân chứng ghi điều tận mắt thấy. Chủ quán xóa chữ “chắc chắn”, thợ sửa ô đổi “chủ nhân” thành “người từng dùng”.',
    english: 'Azhi gives each witness a timeline card limited to firsthand knowledge. The teahouse owner deletes “certain,” and the repairer changes “owner” to “a person who once used it.”',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '旧报纸上的照片经过裁切，原版边缘其实还站着第三个人。阿芷因此暂停结案，因为一张被剪过的证据不能承担完整故事。',
    pinyin: 'Jiù bàozhǐ shàng de zhàopiàn jīngguo cáiqiē, yuánbǎn biānyuán qíshí hái zhànzhe dì sān gè rén. Ā Zhǐ yīncǐ zàntíng jié’àn, yīnwèi yì zhāng bèi jiǎnguò de zhèngjù bùnéng chéngdān wánzhěng gùshi.',
    vietnamese: 'Ảnh báo cũ đã bị cắt; bản gốc còn một người thứ ba ở mép. A Chỉ dừng kết luận vì chứng cứ bị cắt không thể mang cả câu chuyện.',
    english: 'The newspaper photograph was cropped; its original edge contains a third person. Azhi postpones closure because edited evidence cannot carry a whole story.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '两家后人起初都想把红伞带回家，直到暴雨困住一名送餐员。阿芷把伞递出去，争论中的人第一次看见物件原本的用途。',
    pinyin: 'Liǎng jiā hòurén qǐchū dōu xiǎng bǎ hóngsǎn dài huí jiā, zhídào bàoyǔ kùnzhù yì míng sòngcānyuán. Ā Zhǐ bǎ sǎn dì chūqù, zhēnglùn zhōng de rén dì yí cì kànjiàn wùjiàn yuánběn de yòngtú.',
    vietnamese: 'Ban đầu hậu duệ hai nhà đều muốn mang ô về, cho đến khi mưa lớn giữ chân người giao đồ ăn. A Chỉ đưa ô cho anh, khiến mọi người lần đầu nhìn lại công dụng ban đầu của nó.',
    english: 'Both families want the umbrella until a downpour traps a delivery rider. Azhi lends it out, making the disputants see the object’s original purpose.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '失物局的记录最后采用“共同流转物”而不是“归属不明”。这个词没有取消个人记忆，却承认一件东西可以先后属于不同关系。',
    pinyin: 'Shīwùjú de jìlù zuìhòu cǎiyòng “gòngtóng liúzhuǎnwù” ér bú shì “guīshǔ bùmíng”. Zhège cí méiyǒu qǔxiāo gèrén jìyì, què chéngrèn yí jiàn dōngxi kěyǐ xiānhòu shǔyú bùtóng guānxì.',
    vietnamese: 'Hồ sơ cuối dùng “vật lưu chuyển chung” thay vì “không rõ sở hữu”. Cách gọi không xóa ký ức cá nhân mà thừa nhận một đồ vật có thể lần lượt thuộc nhiều mối quan hệ.',
    english: 'The file records a “shared circulating object” rather than “ownership unknown,” preserving personal memory while recognizing successive relationships.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '阿芷在伞柄系上可拆的小牌，每位借用者只写日期和雨势，不写自己是第几个主人。新的痕迹继续增加，旧证词也没有被擦掉。',
    pinyin: 'Ā Zhǐ zài sǎnbǐng jìshàng kěchāi de xiǎopái, měi wèi jièyòngzhě zhǐ xiě rìqī hé yǔshì, bù xiě zìjǐ shì dì jǐ gè zhǔrén. Xīn de hénjì jìxù zēngjiā, jiù zhèngcí yě méiyǒu bèi cādiào.',
    vietnamese: 'A Chỉ buộc thẻ tháo được vào cán ô; người mượn chỉ ghi ngày và mưa, không tự nhận là chủ thứ mấy. Dấu mới tăng lên mà lời cũ vẫn còn.',
    english: 'Azhi ties a removable tag to the handle. Borrowers record only date and rain, never a claim to ownership, allowing new traces without erasing old testimony.',
  ),
];

const _teaHorseEchoAdvanced = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '索朗把节目脚本逐句念给村民听，大家在“古老”“消失”和“最后传人”旁画叉，因为这些词把仍在生活的传统写成了展品。',
    pinyin: 'Suǒlǎng bǎ jiémù jiǎoběn zhújù niàn gěi cūnmín tīng, dàjiā zài “gǔlǎo”, “xiāoshī” hé “zuìhòu chuánrén” páng huà chā, yīnwèi zhèxiē cí bǎ réng zài shēnghuó de chuántǒng xiě chéng le zhǎnpǐn.',
    vietnamese: 'Sách Lãng đọc từng câu kịch bản cho dân làng; họ gạch “cổ xưa”, “biến mất”, “truyền nhân cuối” vì các từ ấy biến truyền thống đang sống thành vật trưng bày.',
    english: 'Solang reads the script aloud. Villagers cross out “ancient,” “vanishing,” and “last inheritor” because those words turn a living practice into an exhibit.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '一位赶马老人同意公开铃声，却不愿公开孙女的歌。索朗第一次明白，同一段录音里可以同时存在不同的许可边界。',
    pinyin: 'Yí wèi gǎnmǎ lǎorén tóngyì gōngkāi língshēng, què bù yuànyì gōngkāi sūnnǚ de gē. Suǒlǎng dì yí cì míngbai, tóng yí duàn lùyīn lǐ kěyǐ tóngshí cúnzài bùtóng de xǔkě biānjiè.',
    vietnamese: 'Một người dẫn ngựa đồng ý công bố tiếng chuông nhưng không cho phát bài hát của cháu gái. Sách Lãng hiểu cùng một bản ghi có thể chứa nhiều ranh giới cho phép.',
    english: 'An elder permits the bells but not his granddaughter’s song. Solang learns that one recording can contain several different boundaries of consent.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '孩子们提出自己录一段今天的上学路，把古道从“过去的回声”变成仍会改变的路线。新录音由他们决定标题和使用期限。',
    pinyin: 'Háizimen tíchū zìjǐ lù yí duàn jīntiān de shàngxuélù, bǎ gǔdào cóng “guòqù de huíshēng” biàn chéng réng huì gǎibiàn de lùxiàn. Xīn lùyīn yóu tāmen juédìng biāotí hé shǐyòng qīxiàn.',
    vietnamese: 'Trẻ em đề nghị thu đường đi học hôm nay, biến đường cổ từ “tiếng vọng quá khứ” thành tuyến vẫn đổi thay. Chính các em đặt tên và thời hạn sử dụng.',
    english: 'Children record today’s school route, turning the trail from a past echo into a changing path. They choose the title and duration of use.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '制作团队原想用最响的马铃作片头，村民却选了一段整理缰绳的轻声，因为那更接近日常劳动，而不是游客想象的传奇。',
    pinyin: 'Zhìzuò tuánduì yuán xiǎng yòng zuì xiǎng de mǎlíng zuò piàntóu, cūnmín què xuǎn le yí duàn zhěnglǐ jiāngshéng de qīngshēng, yīnwèi nà gèng jiējìn rìcháng láodòng, ér bú shì yóukè xiǎngxiàng de chuánqí.',
    vietnamese: 'Đội sản xuất muốn mở bằng chuông ngựa lớn nhất, còn dân làng chọn tiếng chỉnh dây cương vì nó gần lao động thường ngày hơn huyền thoại du khách tưởng tượng.',
    english: 'The crew wants the loudest bell for the opening, but villagers choose quiet reins being arranged because it reflects daily labor rather than a visitor’s legend.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '节目上线后，页面保留撤回许可的入口。索朗知道共同署名不是一次仪式，而是作品流通以后仍要继续履行的关系。',
    pinyin: 'Jiémù shàngxiàn hòu, yèmiàn bǎoliú chèhuí xǔkě de rùkǒu. Suǒlǎng zhīdào gòngtóng shǔmíng bú shì yí cì yíshì, ér shì zuòpǐn liútōng yǐhòu réng yào jìxù lǚxíng de guānxì.',
    vietnamese: 'Sau khi chương trình phát hành, trang vẫn có lối rút lại đồng ý. Sách Lãng hiểu đồng tác giả không phải nghi thức một lần mà là quan hệ phải tiếp tục sau khi tác phẩm lưu hành.',
    english: 'The published page retains a way to withdraw consent. Solang understands that shared credit is not a ceremony but an ongoing relationship after circulation.',
  ),
];

const _iceCityStarMapAdvanced = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '娜娜把父亲的奖状和处分单放在同一张桌上，请旧同事分别说明当时知道什么、后来才知道什么，避免用今天的答案改写昨天的处境。',
    pinyin: 'Nànà bǎ fùqīn de jiǎngzhuàng hé chǔfèndān fàng zài tóng yì zhāng zhuō shàng, qǐng jiù tóngshì fēnbié shuōmíng dāngshí zhīdào shénme, hòulái cái zhīdào shénme, bìmiǎn yòng jīntiān de dá’àn gǎixiě zuótiān de chǔjìng.',
    vietnamese: 'Na Na đặt giấy khen và quyết định kỷ luật cạnh nhau, yêu cầu đồng nghiệp phân biệt điều biết lúc ấy và điều biết về sau, tránh dùng đáp án hôm nay viết lại hoàn cảnh hôm qua.',
    english: 'Nana places awards and discipline notices together, asking coworkers to separate what they knew then from what they learned later so today’s answer does not rewrite yesterday’s situation.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '一名退休工人拒绝录音，只愿意匿名写下“我不同意那次停机”。娜娜保留这句反对，没有逼他提供更适合展览的和解。',
    pinyin: 'Yì míng tuìxiū gōngrén jùjué lùyīn, zhǐ yuànyì nìmíng xiěxià “wǒ bù tóngyì nà cì tíngjī”. Nànà bǎoliú zhè jù fǎnduì, méiyǒu bī tā tígōng gèng shìhé zhǎnlǎn de héjiě.',
    vietnamese: 'Một công nhân nghỉ hưu từ chối ghi âm và chỉ ẩn danh viết “tôi không đồng ý lần dừng máy ấy”. Na Na giữ lời phản đối, không ép ông tạo một hòa giải đẹp hơn cho triển lãm.',
    english: 'A retired worker refuses recording and anonymously writes, “I disagreed with that shutdown.” Nana keeps the dissent instead of forcing a more exhibit-friendly reconciliation.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '厂房平面图显示，父亲常去的锅炉间并不在参观路线。策展组决定不开放危险区域，而用工人的口述和温度记录说明那里发生过什么。',
    pinyin: 'Chǎngfáng píngmiàntú xiǎnshì, fùqīn cháng qù de guōlújiān bìng bú zài cānguān lùxiàn. Cèzhǎn zǔ juédìng bù kāifàng wēixiǎn qūyù, ér yòng gōngrén de kǒushù hé wēndù jìlù shuōmíng nàlǐ fāshēngguo shénme.',
    vietnamese: 'Sơ đồ cho thấy phòng nồi hơi cha thường đến không nằm trên tuyến tham quan. Nhóm không mở khu nguy hiểm mà dùng lời kể và số liệu nhiệt để trình bày.',
    english: 'The boiler room lies outside the visitor route. The team keeps the dangerous area closed and uses worker testimony and temperature records to explain it.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '娜娜发现“星图”原是夜班工人标记互助位置的俗称，并非父亲一人创造。她把设计署名改成集体来源，也写明自己只是重新整理。',
    pinyin: 'Nànà fāxiàn “xīngtú” yuán shì yèbān gōngrén biāojì hùzhù wèizhì de súchēng, bìngfēi fùqīn yì rén chuàngzào. Tā bǎ shèjì shǔmíng gǎi chéng jítǐ láiyuán, yě xiěmíng zìjǐ zhǐshì chóngxīn zhěnglǐ.',
    vietnamese: 'Na Na phát hiện “bản đồ sao” là tên gọi chung của công nhân ca đêm cho các điểm hỗ trợ, không phải sáng tạo riêng của cha. Cô đổi ghi công thành nguồn tập thể và nói rõ mình chỉ biên tập lại.',
    english: 'Nana learns that “star map” was a shared night-shift name for mutual-aid points, not her father’s invention. She credits the collective source and names herself only as an editor.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '开幕那天，第一位参观者没有在父亲照片前停留，而把自己的旧手套放到空坐标旁。娜娜没有失望，因为展览终于允许别人的记忆改变它。',
    pinyin: 'Kāimù nà tiān, dì yí wèi cānguānzhě méiyǒu zài fùqīn zhàopiàn qián tíngliú, ér bǎ zìjǐ de jiù shǒutào fàng dào kōng zuòbiāo páng. Nànà méiyǒu shīwàng, yīnwèi zhǎnlǎn zhōngyú yǔnxǔ biérén de jìyì gǎibiàn tā.',
    vietnamese: 'Ngày khai mạc, khách đầu tiên không dừng trước ảnh cha cô mà đặt đôi găng cũ bên tọa độ trống. Na Na không thất vọng vì triển lãm cuối cùng cho phép ký ức người khác thay đổi nó.',
    english: 'On opening day, the first visitor passes her father’s photograph and places old gloves beside the empty coordinate. Nana is not disappointed; the exhibition can finally be changed by other memories.',
  ),
];
