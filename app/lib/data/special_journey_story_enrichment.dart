class SpecialJourneyEnrichmentText {
  const SpecialJourneyEnrichmentText({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
}

List<SpecialJourneyEnrichmentText> specialJourneyStoryEnrichmentFor(
  String journeyId,
) {
  final signature = switch (journeyId) {
    'literary-roaming' => _literarySignature,
    'myth-tracing' => _mythSignature,
    'strange-night-talks' => _strangeSignature,
    'folk-secret-land' => _folkSignature,
    _ => const <SpecialJourneyEnrichmentText>[],
  };
  if (signature.isEmpty) return const <SpecialJourneyEnrichmentText>[];
  return <SpecialJourneyEnrichmentText>[...signature, ..._sharedImmersiveArc];
}

const _literarySignature = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '蓝色蝴蝶在竹叶之间忽高忽低，像在试探你是否真的愿意跟上。',
    pinyin: 'Lánsè húdié zài zhúyè zhījiān hū gāo hū dī, xiàng zài shìtàn nǐ shìfǒu zhēnde yuànyì gēnshàng.',
    vietnamese: 'Con bướm xanh chao lên xuống giữa lá trúc như muốn thử xem bạn có thật sự theo nó hay không.',
    english: 'The blue butterfly rises and falls among bamboo leaves, testing whether you truly mean to follow.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你低头寻找自己的影子，却只看见一对正在缓慢合拢的翅膀。',
    pinyin: 'Nǐ dītóu xúnzhǎo zìjǐ de yǐngzi, què zhǐ kànjiàn yí duì zhèngzài huǎnmàn hélǒng de chìbǎng.',
    vietnamese: 'Bạn cúi tìm bóng mình nhưng chỉ thấy một đôi cánh đang từ từ khép lại.',
    english: 'You look down for your shadow and find only a pair of wings slowly folding.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '竹林里的风声一会儿像人说话，一会儿又像你在梦中听见自己的呼吸。',
    pinyin: 'Zhúlín lǐ de fēngshēng yíhuìr xiàng rén shuōhuà, yíhuìr yòu xiàng nǐ zài mèng zhōng tīngjiàn zìjǐ de hūxī.',
    vietnamese: 'Tiếng gió trong rừng trúc lúc giống lời người, lúc lại giống hơi thở của chính bạn trong mơ.',
    english: 'The bamboo wind sounds first like speech, then like your own breathing inside a dream.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '水洼中的倒影比你的动作慢半步，仿佛另一个你还没有决定是否醒来。',
    pinyin: 'Shuǐwā zhōng de dàoyǐng bǐ nǐ de dòngzuò màn bànbù, fǎngfú lìng yí gè nǐ hái méiyǒu juédìng shìfǒu xǐnglái.',
    vietnamese: 'Bóng trong vũng nước chậm hơn bạn nửa nhịp, như một bản thân khác vẫn chưa quyết định có tỉnh dậy hay không.',
    english: 'Your reflection lags half a step behind, as if another you has not decided whether to wake.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '两条山路都留下你的脚印，可你清楚记得自己只走过其中一条。',
    pinyin: 'Liǎng tiáo shānlù dōu liúxià nǐ de jiǎoyìn, kě nǐ qīngchu jìde zìjǐ zhǐ zǒuguo qízhōng yì tiáo.',
    vietnamese: 'Cả hai đường núi đều có dấu chân của bạn, dù bạn nhớ rõ mình chỉ đi một đường.',
    english: 'Both mountain paths carry your footprints, though you clearly remember walking only one.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '蝴蝶停在写着“醒来”的路牌上，翅膀背面却浮出“继续做梦”四个字。',
    pinyin: 'Húdié tíng zài xiězhe “xǐnglái” de lùpái shàng, chìbǎng bèimiàn què fúchū “jìxù zuòmèng” sì gè zì.',
    vietnamese: 'Bướm đậu trên biển “tỉnh dậy”, nhưng mặt sau cánh lại hiện bốn chữ “tiếp tục nằm mơ”.',
    english: 'The butterfly rests on the sign marked “wake,” while its wings reveal the words “keep dreaming.”',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你想起庄周梦蝶并不是一道需要解出的谜，而是一面不断改变角度的镜子。',
    pinyin: 'Nǐ xiǎngqǐ Zhuāng Zhōu mèng dié bìng bú shì yí dào xūyào jiěchū de mí, ér shì yí miàn bùduàn gǎibiàn jiǎodù de jìngzi.',
    vietnamese: 'Bạn hiểu mộng bướm của Trang Chu không phải câu đố cần giải, mà là tấm gương luôn đổi góc nhìn.',
    english: 'The butterfly dream is not a riddle to solve but a mirror that keeps changing its angle.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '梦中的你拥有飞行的自由，树下的你却拥有醒来以后承担选择的责任。',
    pinyin: 'Mèng zhōng de nǐ yǒngyǒu fēixíng de zìyóu, shù xià de nǐ què yǒngyǒu xǐnglái yǐhòu chéngdān xuǎnzé de zérèn.',
    vietnamese: 'Bạn trong mơ có tự do bay, còn bạn dưới gốc cây phải chịu trách nhiệm cho lựa chọn sau khi tỉnh.',
    english: 'The dreaming you has freedom to fly; the waking you bears responsibility for the choice.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '当竹叶落到掌心，它一瞬间变成鳞粉，又在眨眼之间恢复原样。',
    pinyin: 'Dāng zhúyè luò dào zhǎngxīn, tā yí shùnjiān biànchéng línfěn, yòu zài zhǎyǎn zhījiān huīfù yuányàng.',
    vietnamese: 'Lá trúc rơi vào lòng bàn tay, thoáng hóa thành phấn cánh rồi lập tức trở lại như cũ.',
    english: 'A bamboo leaf becomes wing dust in your palm, then returns to itself in a blink.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你越努力证明现实，梦境越能准确说出那些只有你知道的细节。',
    pinyin: 'Nǐ yuè nǔlì zhèngmíng xiànshí, mèngjìng yuè néng zhǔnquè shuōchū nàxiē zhǐyǒu nǐ zhīdào de xìjié.',
    vietnamese: 'Càng cố chứng minh thực tại, giấc mơ càng nói chính xác những chi tiết chỉ bạn biết.',
    english: 'The harder you prove reality, the more precisely the dream names details only you know.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '出口没有门，只是一束晨光；跨过去以前，你必须接受答案可能永远不完整。',
    pinyin: 'Chūkǒu méiyǒu mén, zhǐ shì yí shù chénguāng; kuà guòqù yǐqián, nǐ bìxū jiēshòu dá’àn kěnéng yǒngyuǎn bù wánzhěng.',
    vietnamese: 'Lối ra không có cửa, chỉ có một vệt sáng sớm; trước khi bước qua, bạn phải chấp nhận câu trả lời có thể mãi không trọn vẹn.',
    english: 'The exit is only morning light, and crossing it means accepting that the answer may remain incomplete.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '蝴蝶最后飞回你的手背，像把“我是谁”的问题重新交还给醒来的你。',
    pinyin: 'Húdié zuìhòu fēihuí nǐ de shǒubèi, xiàng bǎ “wǒ shì shéi” de wèntí chóngxīn jiāohuán gěi xǐnglái de nǐ.',
    vietnamese: 'Cuối cùng bướm trở lại mu bàn tay, trao câu hỏi “tôi là ai” cho con người vừa tỉnh.',
    english: 'The butterfly returns to your hand, giving the question “who am I?” back to the waking you.',
  ),
];

const _mythSignature = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '桂花香沿着山径一阵一阵出现，像有人在月光看不见的地方为你引路。',
    pinyin: 'Guìhuā xiāng yánzhe shānjìng yí zhèn yí zhèn chūxiàn, xiàng yǒurén zài yuèguāng kànbujiàn de dìfang wèi nǐ yǐnlù.',
    vietnamese: 'Hương quế từng đợt xuất hiện dọc đường núi như có người dẫn lối từ nơi ánh trăng không chiếu tới.',
    english: 'Osmanthus fragrance arrives in waves, as if someone beyond the moonlight is guiding you.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '竹简上的“归去”在不同角度下变成“归还”，让你的任务忽然有了另一层意义。',
    pinyin: 'Zhújiǎn shàng de “guīqù” zài bùtóng jiǎodù xià biànchéng “guīhuán”, ràng nǐ de rènwu hūrán yǒule lìng yì céng yìyì.',
    vietnamese: 'Hai chữ “trở về” trên thẻ tre đổi thành “hoàn trả” khi nhìn nghiêng, khiến nhiệm vụ có thêm một ý nghĩa.',
    english: 'The words “return home” become “return it” at another angle, changing the meaning of your task.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '玉白脚印只在云遮住月亮时出现，月光恢复以后便像从未存在。',
    pinyin: 'Yùbái jiǎoyìn zhǐ zài yún zhēzhù yuèliang shí chūxiàn, yuèguāng huīfù yǐhòu biàn xiàng cóngwèi cúnzài.',
    vietnamese: 'Dấu chân trắng ngọc chỉ hiện khi mây che trăng, rồi biến mất như chưa từng tồn tại.',
    english: 'Jade-white footprints appear only when clouds cover the moon, then vanish without a trace.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '悬空之门没有门框，也没有墙，却把山风与门后的寂静分得清清楚楚。',
    pinyin: 'Xuánkōng zhī mén méiyǒu ménkuàng, yě méiyǒu qiáng, què bǎ shānfēng yǔ mén hòu de jìjìng fēn de qīngqīngchǔchǔ.',
    vietnamese: 'Cánh cửa lơ lửng không khung không tường nhưng chia rõ gió núi với sự tĩnh lặng phía sau.',
    english: 'The suspended door has no frame or wall, yet clearly divides mountain wind from silence beyond.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '白兔没有催促你，只用前爪轻敲空匣，声音像远处宫门传来的回响。',
    pinyin: 'Báitù méiyǒu cuīcù nǐ, zhǐ yòng qiánzhǎo qīngqiāo kōngxiá, shēngyīn xiàng yuǎnchù gōngmén chuánlái de huíxiǎng.',
    vietnamese: 'Thỏ trắng không thúc giục, chỉ gõ nhẹ chiếc hộp rỗng, âm thanh vọng như từ cổng cung xa.',
    english: 'The white rabbit does not hurry you; it taps the empty box with an echo like a distant palace gate.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '桂树林里每棵树的年轮都朝向月亮，仿佛这里的时间由月相而不是四季计算。',
    pinyin: 'Guìshùlín lǐ měi kē shù de niánlún dōu cháoxiàng yuèliang, fǎngfú zhèlǐ de shíjiān yóu yuèxiàng ér bú shì sìjì jìsuàn.',
    vietnamese: 'Vòng tuổi của mọi cây quế đều hướng về trăng, như thời gian ở đây được tính bằng tuần trăng chứ không phải mùa.',
    english: 'Every tree ring faces the moon, as if time here is measured by lunar phases rather than seasons.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你想起月宫故事从来不只有一个版本，变化本身也是神话能够长久流传的原因。',
    pinyin: 'Nǐ xiǎngqǐ Yuègōng gùshì cónglái bù zhǐ yǒu yí gè bǎnběn, biànhuà běnshēn yě shì shénhuà nénggòu chángjiǔ liúchuán de yuányīn.',
    vietnamese: 'Bạn nhớ chuyện cung trăng luôn có nhiều phiên bản, và chính sự biến đổi giúp thần thoại sống lâu.',
    english: 'Moon-palace stories have never had one version; variation itself helps myth endure.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '遗简边缘的缺口与匣子内壁完全吻合，说明它确实曾经属于这里。',
    pinyin: 'Yíjiǎn biānyuán de quēkǒu yǔ xiázi nèibì wánquán wěnhé, shuōmíng tā quèshí céngjīng shǔyú zhèlǐ.',
    vietnamese: 'Vết khuyết của thẻ tre khớp hoàn toàn với thành hộp, chứng tỏ nó từng thuộc về nơi này.',
    english: 'The broken edge fits the box exactly, proving the slip once belonged there.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '留下遗简可以保存证据，归还遗简却可能让一个中断已久的故事重新完整。',
    pinyin: 'Liúxià yíjiǎn kěyǐ bǎocún zhèngjù, guīhuán yíjiǎn què kěnéng ràng yí gè zhōngduàn yǐjiǔ de gùshì chóngxīn wánzhěng.',
    vietnamese: 'Giữ thẻ tre sẽ lưu bằng chứng, còn trả lại có thể hoàn tất một câu chuyện đã đứt đoạn lâu.',
    english: 'Keeping the slip preserves evidence; returning it may complete a story interrupted long ago.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '月光越接近西边，竹简上的字越淡，你能够作出决定的时间正在缩短。',
    pinyin: 'Yuèguāng yuè jiējìn xībiān, zhújiǎn shàng de zì yuè dàn, nǐ nénggòu zuòchū juédìng de shíjiān zhèngzài suōduǎn.',
    vietnamese: 'Trăng càng nghiêng về tây, chữ trên thẻ càng nhạt và thời gian quyết định càng ngắn.',
    english: 'As the moon moves west, the writing fades and your time to decide grows shorter.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '白兔终于转身走进树影，留下的不是命令，而是让你独自承担的选择。',
    pinyin: 'Báitù zhōngyú zhuǎnshēn zǒujìn shùyǐng, liúxià de bú shì mìnglìng, ér shì ràng nǐ dúzì chéngdān de xuǎnzé.',
    vietnamese: 'Thỏ trắng quay vào bóng cây, để lại không phải mệnh lệnh mà là lựa chọn bạn phải tự gánh.',
    english: 'The rabbit turns into the trees, leaving not an order but a choice you must own.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第一缕晨光出现时，桂林、空匣和悬空之门同时开始变得透明。',
    pinyin: 'Dì yì lǚ chénguāng chūxiàn shí, guìlín, kōngxiá hé xuánkōng zhī mén tóngshí kāishǐ biànde tòumíng.',
    vietnamese: 'Khi tia sáng đầu tiên xuất hiện, rừng quế, chiếc hộp và cánh cửa cùng trở nên trong suốt.',
    english: 'At first light, the grove, empty box, and suspended door all begin to turn transparent.',
  ),
];

const _strangeSignature = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '暴雨把客栈外的道路冲成黑色水沟，屋里每一盏灯却都没有火焰。',
    pinyin: 'Bàoyǔ bǎ kèzhàn wài de dàolù chōngchéng hēisè shuǐgōu, wū lǐ měi yì zhǎn dēng què dōu méiyǒu huǒyàn.',
    vietnamese: 'Mưa lớn biến đường ngoài quán trọ thành rãnh nước đen, nhưng mọi ngọn đèn trong nhà đều không có lửa.',
    english: 'Rain turns the road into black channels, while every lamp inside burns without flame.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '夜客进门以后没有留下湿脚印，墙上也始终照不出他的影子。',
    pinyin: 'Yèkè jìnmén yǐhòu méiyǒu liúxià shī jiǎoyìn, qiáng shàng yě shǐzhōng zhào bù chū tā de yǐngzi.',
    vietnamese: 'Vị khách đêm không để lại dấu chân ướt và trên tường cũng không hiện bóng.',
    english: 'The night guest leaves no wet footprints, and the wall never receives his shadow.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '他把铜钱推到你面前时，桌面结出一圈薄霜，像有什么寒意被封在钱里。',
    pinyin: 'Tā bǎ tóngqián tuī dào nǐ miànqián shí, zhuōmiàn jiéchū yì quān báoshuāng, xiàng yǒu shénme hányì bèi fēng zài qián lǐ.',
    vietnamese: 'Khi ông ta đẩy đồng tiền tới, một vòng sương giá xuất hiện trên bàn như hơi lạnh bị khóa bên trong.',
    english: 'As he slides the coin forward, frost circles it as though cold has been sealed inside.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '承诺只有一句：鸡鸣以前不要开门，无论门外的人说出什么。',
    pinyin: 'Chéngnuò zhǐyǒu yí jù: jīmíng yǐqián bú yào kāimén, wúlùn ménwài de rén shuōchū shénme.',
    vietnamese: 'Lời hứa chỉ có một câu: trước tiếng gà gáy không được mở cửa, bất kể người ngoài nói gì.',
    english: 'The promise is simple: do not open before the rooster calls, whatever the voice outside says.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第一更过后，门外先传来孩子的哭声，随后又变成受伤旅人的求救。',
    pinyin: 'Dì yì gēng guòhòu, ménwài xiān chuánlái háizi de kūshēng, suíhòu yòu biànchéng shòushāng lǚrén de qiújiù.',
    vietnamese: 'Sau canh một, ngoài cửa vang tiếng trẻ khóc rồi đổi thành lời kêu cứu của người bị thương.',
    english: 'After the first watch, a child cries outside, then the sound becomes an injured traveler pleading for help.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第二更时，门缝下滚进一颗雨珠，它逆着倾斜的地板慢慢向上移动。',
    pinyin: 'Dì èr gēng shí, ménfèng xià gǔnjìn yì kē yǔzhū, tā nìzhe qīngxié de dìbǎn mànmàn xiàngshàng yídòng.',
    vietnamese: 'Đến canh hai, một giọt mưa lăn qua khe cửa rồi bò ngược lên nền nhà nghiêng.',
    english: 'At the second watch, a raindrop enters beneath the door and crawls uphill across the floor.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第三更出现的声音最熟悉，它说出一段只有你和已经离开的人知道的往事。',
    pinyin: 'Dì sān gēng chūxiàn de shēngyīn zuì shúxī, tā shuōchū yí duàn zhǐyǒu nǐ hé yǐjīng líkāi de rén zhīdào de wǎngshì.',
    vietnamese: 'Canh ba vang giọng quen thuộc nhất, kể một kỷ niệm chỉ bạn và người đã rời đi biết.',
    english: 'At the third watch, the most familiar voice tells a memory known only to you and someone gone.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你握紧铜钱，发现上面的纹路像一扇很小的门，正一点一点打开。',
    pinyin: 'Nǐ wòjǐn tóngqián, fāxiàn shàngmiàn de wénlù xiàng yí shàn hěn xiǎo de mén, zhèng yìdiǎn yìdiǎn dǎkāi.',
    vietnamese: 'Bạn siết đồng tiền và thấy hoa văn giống cánh cửa nhỏ đang từ từ mở.',
    english: 'You grip the coin and see its pattern opening like a tiny door.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '志怪故事最危险的地方不是鬼怪出现，而是异常总能借用最可信的感情。',
    pinyin: 'Zhìguài gùshì zuì wēixiǎn de dìfang bú shì guǐguài chūxiàn, ér shì yìcháng zǒng néng jièyòng zuì kěxìn de gǎnqíng.',
    vietnamese: 'Điều nguy hiểm trong truyện chí quái không chỉ là ma quái, mà là cái lạ luôn mượn cảm xúc đáng tin nhất.',
    english: 'The danger in a strange tale is not the ghost itself, but the way the uncanny borrows trusted emotion.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '客栈木梁不断发出轻响，像有看不见的脚步绕着屋顶巡行。',
    pinyin: 'Kèzhàn mùliáng bùduàn fāchū qīngxiǎng, xiàng yǒu kànbujiàn de jiǎobù ràozhe wūdǐng xúnxíng.',
    vietnamese: 'Xà gỗ liên tục kêu nhẹ như có bước chân vô hình tuần quanh mái nhà.',
    english: 'The beams creak as though invisible footsteps are circling the roof.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '第一声鸡鸣将近时，铜钱化成湿叶，门外所有声音也突然停止。',
    pinyin: 'Dì yì shēng jīmíng jiāngjìn shí, tóngqián huàchéng shīyè, ménwài suǒyǒu shēngyīn yě tūrán tíngzhǐ.',
    vietnamese: 'Khi tiếng gà đầu tiên sắp vang, đồng tiền hóa lá ướt và mọi âm thanh ngoài cửa dừng lại.',
    english: 'As the first rooster call nears, the coin becomes a wet leaf and every voice outside stops.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '门缝下长出的脚印朝屋内延伸，说明真正需要防备的东西也许早已进来。',
    pinyin: 'Ménfèng xià zhǎngchū de jiǎoyìn cháo wūnèi yánshēn, shuōmíng zhēnzhèng xūyào fángbèi de dōngxi yěxǔ zǎoyǐ jìnlái.',
    vietnamese: 'Dấu chân mọc vào trong cho thấy thứ cần đề phòng có lẽ đã vào từ lâu.',
    english: 'Footprints growing inward suggest that what you feared may already be inside.',
  ),
];

const _folkSignature = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '老人把最后一盏河灯放入水中，再次提醒你不要把幻想当成所有地方共有的习俗。',
    pinyin: 'Lǎorén bǎ zuìhòu yì zhǎn hédēng fàngrù shuǐ zhōng, zàicì tíxǐng nǐ bú yào bǎ huànxiǎng dàngchéng suǒyǒu dìfang gòngyǒu de xísú.',
    vietnamese: 'Ông lão thả chiếc đèn cuối và nhắc đừng coi câu chuyện tưởng tượng là phong tục chung ở mọi nơi.',
    english: 'The elder releases the final lantern and warns you not to treat fantasy as a universal custom.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '顺流而下的灯火越来越远，只有写着你名字的那一盏停在渡口中央。',
    pinyin: 'Shùnliú ér xià de dēnghuǒ yuèláiyuè yuǎn, zhǐyǒu xiězhe nǐ míngzi de nà yì zhǎn tíng zài dùkǒu zhōngyāng.',
    vietnamese: 'Đèn xuôi dòng dần xa, chỉ chiếc mang tên bạn dừng giữa bến.',
    english: 'The downstream lights recede, while the lantern bearing your name waits at the center of the crossing.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '它开始逆流以后，水面没有波纹，仿佛不是灯在移动，而是河水退回过去。',
    pinyin: 'Tā kāishǐ nìliú yǐhòu, shuǐmiàn méiyǒu bōwén, fǎngfú bú shì dēng zài yídòng, ér shì héshuǐ tuìhuí guòqù.',
    vietnamese: 'Khi đèn ngược dòng, mặt nước không gợn như thể không phải đèn đi mà dòng sông đang lùi về quá khứ.',
    english: 'The lantern moves upstream without ripples, as though the river itself is retreating into the past.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '灯纸内侧的名字与你的笔迹完全相同，墨色却像已经干了很多年。',
    pinyin: 'Dēngzhǐ nèicè de míngzi yǔ nǐ de bǐjì wánquán xiāngtóng, mòsè què xiàng yǐjīng gān le hěn duō nián.',
    vietnamese: 'Tên bên trong có đúng nét chữ của bạn nhưng mực dường như đã khô nhiều năm.',
    english: 'The name is in your handwriting, yet the ink appears decades old.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '水中的老年倒影抬起手，你还没有动作，它便先做出一个阻止的姿势。',
    pinyin: 'Shuǐ zhōng de lǎonián dàoyǐng táiqǐ shǒu, nǐ hái méiyǒu dòngzuò, tā biàn xiān zuòchū yí gè zǔzhǐ de zīshì.',
    vietnamese: 'Bóng già trong nước giơ tay ngăn lại trước cả khi bạn cử động.',
    english: 'The older reflection raises a warning hand before you move.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '河灯里没有纸条，火焰本身却一明一暗，像在用某种节奏传递留言。',
    pinyin: 'Hédēng lǐ méiyǒu zhǐtiáo, huǒyàn běnshēn què yì míng yí àn, xiàng zài yòng mǒu zhǒng jiézòu chuándì liúyán.',
    vietnamese: 'Trong đèn không có giấy nhắn, nhưng ngọn lửa chớp theo nhịp như đang gửi thông điệp.',
    english: 'There is no note inside; the flame itself pulses as though carrying a message.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你开始思考，未来的提醒究竟是为了改变现在，还是为了保证某件事一定发生。',
    pinyin: 'Nǐ kāishǐ sīkǎo, wèilái de tíxǐng jiūjìng shì wèile gǎibiàn xiànzài, háishì wèile bǎozhèng mǒu jiàn shì yídìng fāshēng.',
    vietnamese: 'Bạn tự hỏi lời nhắc từ tương lai nhằm thay đổi hiện tại hay bảo đảm một việc nhất định xảy ra.',
    english: 'You wonder whether a warning from the future changes the present or guarantees an event.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '岸边其他人看不见逆流的灯，他们只看见你独自对着黑暗的河面犹豫。',
    pinyin: 'Ànbiān qítā rén kàn bú jiàn nìliú de dēng, tāmen zhǐ kànjiàn nǐ dúzì duìzhe hēi’àn de hémiàn yóuyù.',
    vietnamese: 'Người trên bờ không thấy chiếc đèn ngược dòng, chỉ thấy bạn do dự trước mặt sông tối.',
    english: 'No one else sees the upstream lantern; they see only you hesitating before dark water.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '放河灯在不同地区拥有不同时间、目的和禁忌，真实民俗不能被一句话概括。',
    pinyin: 'Fàng hédēng zài bùtóng dìqū yǒngyǒu bùtóng shíjiān, mùdì hé jìnjì, zhēnshí mínsú bù néng bèi yí jù huà gàikuò.',
    vietnamese: 'Tục thả đèn có thời điểm, mục đích và kiêng kỵ khác nhau theo địa phương, không thể gói trong một câu.',
    english: 'Lantern customs vary by place, time, purpose, and taboo and cannot be reduced to one universal rule.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '这段逆流情节属于 Phoenix 原创，它借用了河灯意象，却不冒充任何地方的固定仪式。',
    pinyin: 'Zhè duàn nìliú qíngjié shǔyú Phoenix yuánchuàng, tā jièyòng le hédēng yìxiàng, què bù màochōng rènhé dìfang de gùdìng yíshì.',
    vietnamese: 'Chi tiết ngược dòng là sáng tác của Phoenix, mượn hình tượng đèn sông nhưng không giả làm nghi lễ thật.',
    english: 'The upstream episode is Phoenix fiction inspired by river lanterns, not a claim about a fixed ritual.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '灯火越来越弱，未来倒影的嘴唇终于动了，却被水声盖住最后一个词。',
    pinyin: 'Dēnghuǒ yuèláiyuè ruò, wèilái dàoyǐng de zuǐchún zhōngyú dòng le, què bèi shuǐshēng gàizhù zuìhòu yí gè cí.',
    vietnamese: 'Lửa yếu dần, môi của bóng tương lai cử động nhưng tiếng nước che mất từ cuối.',
    english: 'The flame weakens; the future reflection speaks, but the river swallows the final word.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你伸手或收手的瞬间，河流都会继续前进，真正改变的是你怎样理解那句没有听清的话。',
    pinyin: 'Nǐ shēnshǒu huò shōushǒu de shùnjiān, héliú dōu huì jìxù qiánjìn, zhēnzhèng gǎibiàn de shì nǐ zěnyàng lǐjiě nà jù méiyǒu tīngqīng de huà.',
    vietnamese: 'Dù bạn đưa hay rút tay, sông vẫn chảy; điều thay đổi là cách bạn hiểu câu nói chưa nghe rõ.',
    english: 'Whether you reach or withdraw, the river continues; what changes is how you interpret the unheard message.',
  ),
];

const _sharedImmersiveArc = <SpecialJourneyEnrichmentText>[
  SpecialJourneyEnrichmentText(
    chinese: '你没有立刻前进，而是先确认光线、声音和脚下的方向。',
    pinyin: 'Nǐ méiyǒu lìkè qiánjìn, ér shì xiān quèrèn guāngxiàn, shēngyīn hé jiǎoxià de fāngxiàng.',
    vietnamese: 'Bạn chưa bước tiếp ngay mà trước hết xác nhận ánh sáng, âm thanh và hướng dưới chân.',
    english: 'You do not move at once; first you check the light, sound, and direction beneath your feet.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '每一次停顿都让场景多出一层，熟悉的东西也开始变得可疑。',
    pinyin: 'Měi yí cì tíngdùn dōu ràng chǎngjǐng duōchū yì céng, shúxī de dōngxi yě kāishǐ biànde kěyí.',
    vietnamese: 'Mỗi lần dừng lại khiến cảnh vật thêm một lớp và điều quen thuộc cũng trở nên đáng ngờ.',
    english: 'Each pause adds another layer, making even familiar things uncertain.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你试着记住来路，却发现身后的景物正在悄悄改变位置。',
    pinyin: 'Nǐ shìzhe jìzhù láilù, què fāxiàn shēnhòu de jǐngwù zhèngzài qiāoqiāo gǎibiàn wèizhi.',
    vietnamese: 'Bạn cố nhớ đường đến nhưng cảnh phía sau đang lặng lẽ đổi vị trí.',
    english: 'You try to remember the route, but the scenery behind you is quietly changing position.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '风带来的气味比路标更可靠，它不断提醒你仍在故事内部。',
    pinyin: 'Fēng dàilái de qìwèi bǐ lùbiāo gèng kěkào, tā bùduàn tíxǐng nǐ réng zài gùshì nèibù.',
    vietnamese: 'Mùi trong gió đáng tin hơn biển chỉ đường, nhắc rằng bạn vẫn ở bên trong câu chuyện.',
    english: 'Scent carried by wind is more reliable than signs, reminding you that you remain inside the story.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '当你伸手触碰某件东西时，温度证明它真实，意义却仍不确定。',
    pinyin: 'Dāng nǐ shēnshǒu chùpèng mǒu jiàn dōngxi shí, wēndù zhèngmíng tā zhēnshí, yìyì què réng bù quèdìng.',
    vietnamese: 'Khi chạm vào một vật, nhiệt độ chứng minh nó có thật nhưng ý nghĩa vẫn chưa chắc chắn.',
    english: 'Temperature proves an object is real, while its meaning remains uncertain.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '远处传来的声音没有说明来源，只把你的注意力引向下一处选择。',
    pinyin: 'Yuǎnchù chuánlái de shēngyīn méiyǒu shuōmíng láiyuán, zhǐ bǎ nǐ de zhùyìlì yǐnxiàng xià yí chù xuǎnzé.',
    vietnamese: 'Âm thanh xa không cho biết nguồn, chỉ kéo sự chú ý của bạn tới lựa chọn tiếp theo.',
    english: 'A distant sound reveals no source and only draws you toward the next choice.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你开始明白，旅程不是等待答案，而是观察自己怎样作出判断。',
    pinyin: 'Nǐ kāishǐ míngbai, lǚchéng bú shì děngdài dá’àn, ér shì guānchá zìjǐ zěnyàng zuòchū pànduàn.',
    vietnamese: 'Bạn hiểu hành trình không phải chờ đáp án mà là quan sát cách mình phán đoán.',
    english: 'The journey is not about waiting for an answer but watching how you form a judgment.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '时间在这里不按钟表前进，有些瞬间被拉长，有些年月一闪而过。',
    pinyin: 'Shíjiān zài zhèlǐ bú àn zhōngbiǎo qiánjìn, yǒuxiē shùnjiān bèi lācháng, yǒuxiē niányuè yì shǎn ér guò.',
    vietnamese: 'Thời gian không chạy theo đồng hồ; có khoảnh khắc kéo dài và có năm tháng vụt qua.',
    english: 'Time does not follow clocks here; moments stretch while years pass in a flash.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '每一条线索都可能解释过去，也可能只是为了改变你接下来的行动。',
    pinyin: 'Měi yì tiáo xiànsuǒ dōu kěnéng jiěshì guòqù, yě kěnéng zhǐ shì wèile gǎibiàn nǐ jiēxiàlái de xíngdòng.',
    vietnamese: 'Mỗi manh mối có thể giải thích quá khứ hoặc chỉ nhằm đổi hành động tiếp theo của bạn.',
    english: 'Each clue may explain the past or merely alter what you do next.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '你把恐惧、好奇和责任放在一起比较，才发现它们常常指向不同方向。',
    pinyin: 'Nǐ bǎ kǒngjù, hàoqí hé zérèn fàng zài yìqǐ bǐjiào, cái fāxiàn tāmen chángcháng zhǐxiàng bùtóng fāngxiàng.',
    vietnamese: 'Khi so sánh sợ hãi, tò mò và trách nhiệm, bạn thấy chúng thường chỉ về những hướng khác nhau.',
    english: 'Fear, curiosity, and responsibility often point in different directions.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '真正困难的不是看见异常，而是决定看见以后是否仍然相信自己。',
    pinyin: 'Zhēnzhèng kùnnan de bú shì kànjiàn yìcháng, ér shì juédìng kànjiàn yǐhòu shìfǒu réngrán xiāngxìn zìjǐ.',
    vietnamese: 'Điều khó không phải nhìn thấy bất thường mà là quyết định sau đó còn tin mình hay không.',
    english: 'The real difficulty is not seeing the impossible, but deciding whether to trust yourself afterward.',
  ),
  SpecialJourneyEnrichmentText(
    chinese: '当出口终于出现时，你已经不能用进入以前的眼光理解这段经历。',
    pinyin: 'Dāng chūkǒu zhōngyú chūxiàn shí, nǐ yǐjīng bù néng yòng jìnrù yǐqián de yǎnguāng lǐjiě zhè duàn jīnglì.',
    vietnamese: 'Khi lối ra xuất hiện, bạn không còn có thể hiểu trải nghiệm bằng cách nhìn trước lúc bước vào.',
    english: 'When the exit appears, you can no longer understand the experience with the eyes you had before entering.',
  ),
];
