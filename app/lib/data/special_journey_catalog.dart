import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'special_journey_expansion_batch_one.dart';

const _literaryStory = <String>[
  '你在一棵老树下醒来，手背停着一只蓝色蝴蝶。梦里，你曾拥有它的翅膀，也曾从高处看见自己仍睡在树下。',
  '风穿过竹林，蝴蝶向一条没有脚印的小路飞去。你越想分辨梦与现实，周围的景物就越像水中的倒影。',
  '山路忽然分成两条。一条通往熟悉的人间，另一条跟随蝴蝶进入更深的梦境。两块路牌上却都写着“醒来”。',
  '你终于明白，这段旅程并不要求证明谁梦见了谁。真正的问题是，醒来后的你是否已经被这场梦改变。',
];

const _literaryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Nǐ zài yì kē lǎoshù xià xǐng lái, shǒubèi tíngzhe yì zhī lánsè húdié. Mèng lǐ, nǐ céng yǒngyǒu tā de chìbǎng, yě céng cóng gāochù kànjiàn zìjǐ réng shuì zài shù xià.',
    vietnamese:
        'Bạn tỉnh dậy dưới một gốc cây cổ, một con bướm xanh đậu trên mu bàn tay. Trong mơ, bạn từng có đôi cánh của nó và nhìn thấy chính mình vẫn ngủ dưới cây.',
    english:
        'You wake beneath an old tree with a blue butterfly resting on your hand. In the dream, you had its wings and saw yourself still sleeping below.',
  ),
  ReadingAnnotation(
    pinyin:
        'Fēng chuānguò zhúlín, húdié xiàng yì tiáo méiyǒu jiǎoyìn de xiǎolù fēi qù. Nǐ yuè xiǎng fēnbiàn mèng yǔ xiànshí, zhōuwéi de jǐngwù jiù yuè xiàng shuǐ zhōng de dàoyǐng.',
    vietnamese:
        'Gió lướt qua rừng trúc, con bướm bay về phía con đường không có dấu chân. Càng cố phân biệt mơ và thực, cảnh vật càng giống bóng phản chiếu trên nước.',
    english:
        'Wind passes through the bamboo as the butterfly follows a path without footprints. The harder you separate dream from reality, the more the world resembles a reflection.',
  ),
  ReadingAnnotation(
    pinyin:
        'Shānlù hūrán fēn chéng liǎng tiáo. Yì tiáo tōngwǎng shúxī de rénjiān, lìng yì tiáo gēnsuí húdié jìnrù gèng shēn de mèngjìng. Liǎng kuài lùpái shàng què dōu xiězhe “xǐng lái”.',
    vietnamese:
        'Đường núi bỗng chia đôi. Một đường trở về thế giới quen thuộc, đường kia theo bướm vào giấc mơ sâu hơn. Nhưng cả hai biển chỉ đường đều ghi “tỉnh dậy”.',
    english:
        'The mountain path splits. One road returns to the familiar world, the other follows the butterfly deeper into the dream, yet both signs read “wake up.”',
  ),
  ReadingAnnotation(
    pinyin:
        'Nǐ zhōngyú míngbai, zhè duàn lǚchéng bìng bù yāoqiú zhèngmíng shéi mèngjiàn le shéi. Zhēnzhèng de wèntí shì, xǐng lái hòu de nǐ shìfǒu yǐjīng bèi zhè chǎng mèng gǎibiàn.',
    vietnamese:
        'Cuối cùng bạn hiểu rằng chuyến đi không yêu cầu chứng minh ai mơ thấy ai. Câu hỏi thật sự là sau khi tỉnh dậy, bạn đã bị giấc mơ này thay đổi hay chưa.',
    english:
        'At last you understand that the journey does not ask who dreamed whom. It asks whether the person who woke has already been changed by the dream.',
  ),
];

const _literaryWords = <WordEntry>[
  WordEntry(
    word: '梦境',
    pinyin: 'mèngjìng',
    partOfSpeech: '名词',
    simpleChinese: '梦中出现的环境和经历。',
    translation: 'Cảnh giới và trải nghiệm xuất hiện trong giấc mơ.',
    englishDefinition: 'a dream world or dreamscape',
    symbol: '🦋',
  ),
  WordEntry(
    word: '恍惚',
    pinyin: 'huǎnghū',
    partOfSpeech: '形容词',
    simpleChinese: '精神不集中，感觉事情不太真实。',
    translation: 'Mơ hồ, không tỉnh táo, cảm giác không thật.',
    englishDefinition: 'dazed; indistinct; dreamlike',
    symbol: '🌫️',
  ),
  WordEntry(
    word: '分辨',
    pinyin: 'fēnbiàn',
    partOfSpeech: '动词',
    simpleChinese: '把相似的事物区别开来。',
    translation: 'Phân biệt những sự vật giống nhau.',
    englishDefinition: 'to distinguish or tell apart',
    symbol: '◐',
  ),
  WordEntry(
    word: '化作',
    pinyin: 'huàzuò',
    partOfSpeech: '动词',
    simpleChinese: '变化成为另一种形态。',
    translation: 'Hóa thành một hình thái khác.',
    englishDefinition: 'to transform into',
    symbol: '✨',
  ),
  WordEntry(
    word: '边界',
    pinyin: 'biānjiè',
    partOfSpeech: '名词',
    simpleChinese: '两个范围之间的分界。',
    translation: 'Ranh giới giữa hai phạm vi.',
    englishDefinition: 'boundary or dividing line',
    symbol: '〰️',
  ),
  WordEntry(
    word: '追随',
    pinyin: 'zhuīsuí',
    partOfSpeech: '动词',
    simpleChinese: '跟在后面一起前进。',
    translation: 'Đi theo và cùng tiến về phía trước.',
    englishDefinition: 'to follow or pursue',
    symbol: '👣',
  ),
];

const _literaryDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '“庄周梦蝶”见于《庄子·齐物论》，故事借梦与醒讨论自我和变化的界限。',
    pinyin:
        '“Zhuāng Zhōu mèng dié” jiànyú “Zhuāngzǐ · Qíwùlùn”, gùshì jiè mèng yǔ xǐng tǎolùn zìwǒ hé biànhuà de jièxiàn.',
    simpleChinese: '这个寓言让人思考：梦里的我和醒来的我，哪一个更真实？',
    vietnamese:
        '“Trang Chu mộng điệp” xuất hiện trong Trang Tử, dùng mơ và tỉnh để suy ngẫm về bản thân và sự biến đổi.',
    english:
        'The butterfly dream appears in the Zhuangzi and uses dreaming and waking to question identity and transformation.',
  ),
  DiscoveryEntry(
    text: '蝴蝶在后世文学和艺术中常与变化、自由和短暂之美联系在一起。',
    pinyin:
        'Húdié zài hòushì wénxué hé yìshù zhōng cháng yǔ biànhuà, zìyóu hé duǎnzàn zhī měi liánxì zài yìqǐ.',
    simpleChinese: '蝴蝶常代表变化、自由，也提醒人们美好可能很短暂。',
    vietnamese:
        'Trong văn học nghệ thuật về sau, bướm thường gắn với biến đổi, tự do và vẻ đẹp ngắn ngủi.',
    english:
        'In later literature and art, butterflies often evoke transformation, freedom, and fleeting beauty.',
  ),
  DiscoveryEntry(
    text: '本旅程是 Phoenix 根据“庄周梦蝶”意象创作的幻想故事，不是古籍原文。',
    pinyin:
        'Běn lǚchéng shì Phoenix gēnjù “Zhuāng Zhōu mèng dié” yìxiàng chuàngzuò de huànxiǎng gùshì, bú shì gǔjí yuánwén.',
    simpleChinese: '文化灵感来自古代寓言，具体情节是 Phoenix 原创。',
    vietnamese:
        'Hành trình này là truyện tưởng tượng nguyên tác của Phoenix, lấy cảm hứng từ hình tượng Trang Chu mộng điệp.',
    english:
        'This is an original Phoenix fantasy inspired by the butterfly dream, not a retelling of the classical text.',
  ),
];

const _mythStory = <String>[
  '满月升起时，一页残缺的竹简落在你的窗前。上面只剩“归去”二字，边缘还带着刚刚折下的桂花香。',
  '你循着香气走进山中。每当月光被云遮住，玉白色的脚印便在石阶上出现，引你走向一扇悬在半空的门。',
  '门后没有宫殿，只有一片安静的桂树林。树下的白兔守着一只空匣子，仿佛已经等待这页遗简很多年。',
  '天亮以前，你必须决定把遗简放回匣中，还是留下它。月光没有给出答案，只照亮你伸出去的手。',
];

const _mythAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Mǎnyuè shēngqǐ shí, yí yè cánquē de zhújiǎn luò zài nǐ de chuāng qián. Shàngmiàn zhǐ shèng “guīqù” èr zì, biānyuán hái dàizhe gānggāng zhé xià de guìhuā xiāng.',
    vietnamese:
        'Khi trăng tròn lên, một mảnh thẻ tre không trọn vẹn rơi trước cửa sổ. Trên đó chỉ còn hai chữ “trở về” và mùi hoa quế mới hái.',
    english:
        'As the full moon rises, a broken bamboo slip falls before your window. Only the words “return” remain, edged with fresh osmanthus fragrance.',
  ),
  ReadingAnnotation(
    pinyin:
        'Nǐ xúnzhe xiāngqì zǒujìn shān zhōng. Měidāng yuèguāng bèi yún zhēzhù, yùbáisè de jiǎoyìn biàn zài shíjiē shàng chūxiàn, yǐn nǐ zǒuxiàng yí shàn xuán zài bànkōng de mén.',
    vietnamese:
        'Bạn lần theo hương thơm vào núi. Mỗi khi mây che trăng, dấu chân trắng như ngọc hiện trên bậc đá, dẫn đến cánh cửa lơ lửng.',
    english:
        'You follow the scent into the mountain. Whenever clouds cover the moon, pale footprints appear on the steps and lead toward a suspended door.',
  ),
  ReadingAnnotation(
    pinyin:
        'Mén hòu méiyǒu gōngdiàn, zhǐyǒu yí piàn ānjìng de guìhuā shùlín. Shù xià de báitù shǒuzhe yì zhī kōng xiázi, fǎngfú yǐjīng děngdài zhè yè yíjiǎn hěn duō nián.',
    vietnamese:
        'Sau cửa không có cung điện, chỉ có rừng quế tĩnh lặng. Con thỏ trắng dưới cây canh chiếc hộp rỗng như đã đợi mảnh thẻ này nhiều năm.',
    english:
        'Beyond the door lies no palace, only a silent osmanthus grove. A white rabbit guards an empty box as though it has awaited the slip for years.',
  ),
  ReadingAnnotation(
    pinyin:
        'Tiānliàng yǐqián, nǐ bìxū juédìng bǎ yíjiǎn fàng huí xiá zhōng, háishì liúxià tā. Yuèguāng méiyǒu gěichū dá’àn, zhǐ zhàoliàng nǐ shēn chūqù de shǒu.',
    vietnamese:
        'Trước bình minh, bạn phải quyết định trả mảnh thẻ vào hộp hay giữ lại. Ánh trăng không cho đáp án, chỉ soi sáng bàn tay bạn.',
    english:
        'Before dawn, you must return the slip to the box or keep it. Moonlight offers no answer, only illumination for your outstretched hand.',
  ),
];

const _mythWords = <WordEntry>[
  WordEntry(
    word: '遗简',
    pinyin: 'yíjiǎn',
    partOfSpeech: '名词',
    simpleChinese: '遗留下来的竹简或书信。',
    translation: 'Thẻ tre hoặc thư từ được lưu lại.',
    englishDefinition: 'a surviving bamboo slip or ancient letter',
    symbol: '📜',
  ),
  WordEntry(
    word: '残缺',
    pinyin: 'cánquē',
    partOfSpeech: '形容词',
    simpleChinese: '不完整，有一部分缺失。',
    translation: 'Không trọn vẹn, bị thiếu một phần.',
    englishDefinition: 'incomplete or damaged',
    symbol: '◒',
  ),
  WordEntry(
    word: '循迹',
    pinyin: 'xúnjì',
    partOfSpeech: '动词',
    simpleChinese: '按照留下的痕迹寻找。',
    translation: 'Lần theo dấu vết để tìm kiếm.',
    englishDefinition: 'to follow traces',
    symbol: '🐇',
  ),
  WordEntry(
    word: '悬空',
    pinyin: 'xuánkōng',
    partOfSpeech: '动词／形容词',
    simpleChinese: '离开地面停在空中。',
    translation: 'Lơ lửng, không chạm mặt đất.',
    englishDefinition: 'suspended in midair',
    symbol: '🚪',
  ),
  WordEntry(
    word: '归还',
    pinyin: 'guīhuán',
    partOfSpeech: '动词',
    simpleChinese: '把借来或拿走的东西送回去。',
    translation: 'Trả lại vật đã mượn hoặc lấy đi.',
    englishDefinition: 'to return something',
    symbol: '↩️',
  ),
  WordEntry(
    word: '相传',
    pinyin: 'xiāngchuán',
    partOfSpeech: '动词',
    simpleChinese: '表示一个说法长期流传，但不一定已经证实。',
    translation:
        'Tương truyền, một lời kể được lưu truyền nhưng chưa chắc đã được chứng thực.',
    englishDefinition: 'it is traditionally said or passed down',
    symbol: '🌙',
  ),
];

const _mythDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '嫦娥奔月在不同古代文献中有不同版本，人物动机和故事细节并不完全相同。',
    pinyin:
        'Cháng’é bēn yuè zài bùtóng gǔdài wénxiàn zhōng yǒu bùtóng bǎnběn, rénwù dòngjī hé gùshì xìjié bìng bù wánquán xiāngtóng.',
    simpleChinese: '同一个神话可能有多个版本，不能只把一个版本当成唯一答案。',
    vietnamese:
        'Truyền thuyết Hằng Nga lên trăng có nhiều phiên bản cổ, với động cơ và chi tiết khác nhau.',
    english:
        'The myth of Chang’e has several ancient versions with differing motives and details.',
  ),
  DiscoveryEntry(
    text: '玉兔、月桂和广寒宫等月宫意象在后世文学、节日和艺术中不断丰富。',
    pinyin:
        'Yùtù, yuèguì hé Guǎnghán Gōng děng yuègōng yìxiàng zài hòushì wénxué, jiérì hé yìshù zhōng bùduàn fēngfù.',
    simpleChinese: '今天熟悉的月宫世界，是很多时代共同想象出来的。',
    vietnamese:
        'Ngọc Thố, cây quế và cung Quảng Hàn được bồi đắp qua văn học, lễ hội và nghệ thuật nhiều thời đại.',
    english:
        'The moon rabbit, osmanthus tree, and lunar palace were enriched through later literature, festivals, and art.',
  ),
  DiscoveryEntry(
    text: '“月宫遗简”是 Phoenix 以月宫文化意象创作的原创幻想，不对应某一篇古代神话原文。',
    pinyin:
        '“Yuègōng yíjiǎn” shì Phoenix yǐ yuègōng wénhuà yìxiàng chuàngzuò de yuánchuàng huànxiǎng, bù duìyìng mǒu yì piān gǔdài shénhuà yuánwén.',
    simpleChinese: '文化元素有传统来源，遗简和选择情节是 Phoenix 原创。',
    vietnamese:
        '“Di giản cung trăng” là truyện tưởng tượng nguyên tác của Phoenix, không phải nguyên văn một thần thoại cổ cụ thể.',
    english:
        'Moon Palace Letter is an original Phoenix fantasy using lunar mythology, not a retelling of one classical source.',
  ),
];

const _strangeStory = <String>[
  '子夜，一名没有影子的客人敲响客栈木门。他站在大雨里，衣角却没有沾上一滴水。',
  '客人把一枚冰冷的铜钱放在柜上：“鸡鸣以前，无论听见谁叫你的名字，都不要开门。”说完，他走进最里面的空房。',
  '三更过后，门外传来你最熟悉的声音。它先轻声请求，随后用力拍门，最后准确说出只有你知道的一段往事。',
  '掌心里的铜钱慢慢变成一片湿叶。第一声鸡鸣将至，而门缝下出现了一双朝屋内生长的脚印。',
];

const _strangeAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Zǐyè, yì míng méiyǒu yǐngzi de kèrén qiāoxiǎng kèzhàn mùmén. Tā zhàn zài dàyǔ lǐ, yījiǎo què méiyǒu zhān shàng yì dī shuǐ.',
    vietnamese:
        'Nửa đêm, một vị khách không có bóng gõ cửa quán trọ. Ông đứng trong mưa lớn nhưng vạt áo không dính một giọt nước.',
    english:
        'At midnight, a guest without a shadow knocks on the inn door. He stands in heavy rain, yet not one drop touches his clothes.',
  ),
  ReadingAnnotation(
    pinyin:
        'Kèrén bǎ yì méi bīnglěng de tóngqián fàng zài guì shàng: “Jīmíng yǐqián, wúlùn tīngjiàn shéi jiào nǐ de míngzi, dōu bú yào kāimén.” Shuōwán, tā zǒujìn zuì lǐmiàn de kōngfáng.',
    vietnamese:
        'Vị khách đặt đồng tiền lạnh trên quầy: “Trước tiếng gà gáy, dù nghe ai gọi tên cũng đừng mở cửa.” Nói xong ông vào căn phòng trống sâu nhất.',
    english:
        'The guest sets a cold coin on the counter: “Before the rooster calls, open the door for no voice that speaks your name.” Then he enters the innermost empty room.',
  ),
  ReadingAnnotation(
    pinyin:
        'Sāngēng guòhòu, ménwài chuánlái nǐ zuì shúxī de shēngyīn. Tā xiān qīngshēng qǐngqiú, suíhòu yònglì pāimén, zuìhòu zhǔnquè shuōchū zhǐyǒu nǐ zhīdào de yí duàn wǎngshì.',
    vietnamese:
        'Sau canh ba, bên ngoài vang lên giọng quen thuộc nhất. Nó khẩn cầu, đập cửa rồi kể chính xác một chuyện cũ chỉ bạn biết.',
    english:
        'After the third watch, the voice you know best begs, pounds the door, and finally recounts a memory known only to you.',
  ),
  ReadingAnnotation(
    pinyin:
        'Zhǎngxīn lǐ de tóngqián mànmàn biàn chéng yí piàn shīyè. Dì yì shēng jīmíng jiāng zhì, ér ménfèng xià chūxiàn le yì shuāng cháo wūnèi shēngzhǎng de jiǎoyìn.',
    vietnamese:
        'Đồng tiền trong tay dần hóa thành chiếc lá ướt. Tiếng gà đầu tiên sắp vang lên, còn dưới khe cửa xuất hiện dấu chân mọc về phía trong phòng.',
    english:
        'The coin becomes a wet leaf. The first rooster call approaches, while footprints begin growing inward beneath the door.',
  ),
];

const _strangeWords = <WordEntry>[
  WordEntry(
    word: '子夜',
    pinyin: 'zǐyè',
    partOfSpeech: '名词',
    simpleChinese: '半夜十二点前后。',
    translation: 'Nửa đêm, khoảng mười hai giờ đêm.',
    englishDefinition: 'midnight',
    symbol: '🌑',
  ),
  WordEntry(
    word: '鸡鸣',
    pinyin: 'jīmíng',
    partOfSpeech: '名词／动词',
    simpleChinese: '公鸡叫，也常表示天快亮了。',
    translation: 'Tiếng gà gáy, thường báo trời sắp sáng.',
    englishDefinition: 'a rooster call; the approach of dawn',
    symbol: '🐓',
  ),
  WordEntry(
    word: '承诺',
    pinyin: 'chéngnuò',
    partOfSpeech: '名词／动词',
    simpleChinese: '答应别人并准备做到的事情。',
    translation: 'Lời hứa và trách nhiệm thực hiện điều đã hứa.',
    englishDefinition: 'a promise or commitment',
    symbol: '🤝',
  ),
  WordEntry(
    word: '门缝',
    pinyin: 'ménfèng',
    partOfSpeech: '名词',
    simpleChinese: '门和门框之间很窄的空隙。',
    translation: 'Khe hẹp giữa cánh cửa và khung cửa.',
    englishDefinition: 'a crack or gap beneath a door',
    symbol: '🚪',
  ),
  WordEntry(
    word: '诡异',
    pinyin: 'guǐyì',
    partOfSpeech: '形容词',
    simpleChinese: '奇怪而让人不安。',
    translation: 'Kỳ lạ và khiến người ta bất an.',
    englishDefinition: 'eerie or uncanny',
    symbol: '🕯️',
  ),
  WordEntry(
    word: '往事',
    pinyin: 'wǎngshì',
    partOfSpeech: '名词',
    simpleChinese: '过去发生过的事情。',
    translation: 'Chuyện đã xảy ra trong quá khứ.',
    englishDefinition: 'past events or memories',
    symbol: '🍂',
  ),
];

const _strangeDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '“志怪”是中国古代记录神异、鬼怪和非常事件的一类叙事传统。',
    pinyin:
        '“Zhìguài” shì Zhōngguó gǔdài jìlù shényì, guǐguài hé fēicháng shìjiàn de yí lèi xùshì chuántǒng.',
    simpleChinese: '志怪故事常把日常生活和异常事件放在一起。',
    vietnamese:
        '“Chí quái” là truyền thống tự sự cổ Trung Hoa ghi chép hiện tượng thần dị, ma quái và sự kiện khác thường.',
    english:
        'Zhiguai is an ancient Chinese narrative tradition recording supernatural beings and extraordinary events.',
  ),
  DiscoveryEntry(
    text: '《聊斋志异》是清代蒲松龄创作的文言短篇小说集，常借异类故事观察人情与社会。',
    pinyin:
        '“Liáozhāi Zhìyì” shì Qīngdài Pú Sōnglíng chuàngzuò de wényán duǎnpiān xiǎoshuō jí, cháng jiè yìlèi gùshì guānchá rénqíng yǔ shèhuì.',
    simpleChinese: '聊斋不只是讲鬼，也常借奇异人物写现实中的人。',
    vietnamese:
        'Liêu Trai Chí Dị là tập truyện văn ngôn thời Thanh của Bồ Tùng Linh, thường dùng chuyện kỳ dị để quan sát con người và xã hội.',
    english:
        'Strange Tales from a Chinese Studio is Pu Songling’s Qing-era collection, often using the uncanny to examine people and society.',
  ),
  DiscoveryEntry(
    text: '“无影客栈”是 Phoenix 受志怪气氛启发的原创故事，并不是《聊斋志异》中的原篇。',
    pinyin:
        '“Wúyǐng kèzhàn” shì Phoenix shòu zhìguài qìfēn qǐfā de yuánchuàng gùshì, bìng bú shì “Liáozhāi Zhìyì” zhōng de yuánpiān.',
    simpleChinese: '故事气氛来自志怪传统，夜客和铜钱情节是 Phoenix 原创。',
    vietnamese:
        '“Quán trọ không bóng” là truyện nguyên tác của Phoenix lấy cảm hứng từ không khí chí quái, không phải truyện gốc trong Liêu Trai.',
    english:
        'The Shadowless Inn is an original Phoenix story inspired by zhiguai atmosphere, not a tale from Liaozhai.',
  ),
];

const _folkStory = <String>[
  '入夜后，河面漂满纸灯。老人提醒你，今晚不要捞起任何逆流而上的灯，除非灯纸上写着你的名字。',
  '午夜将近，成百上千盏灯顺流远去，只有一盏停在你面前。它没有被风吹动，却缓慢地向上游退去。',
  '你俯身看见灯纸内侧写着自己的名字。水中的倒影却不是现在的你，而是一张苍老许多、正想开口说话的脸。',
  '灯火即将熄灭。你可以伸手接住未来的留言，也可以让它继续逆流，回到它真正属于的那一年。',
];

const _folkAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Rùyè hòu, hémiàn piāomǎn zhǐdēng. Lǎorén tíxǐng nǐ, jīnwǎn bú yào lāoqǐ rènhé nìliú ér shàng de dēng, chúfēi dēngzhǐ shàng xiězhe nǐ de míngzi.',
    vietnamese:
        'Khi đêm xuống, mặt sông đầy đèn giấy. Ông lão dặn đừng vớt chiếc đèn nào trôi ngược dòng, trừ khi trên giấy có tên bạn.',
    english:
        'At night the river fills with paper lanterns. An elder warns you never to lift one moving upstream unless it bears your name.',
  ),
  ReadingAnnotation(
    pinyin:
        'Wǔyè jiāngjìn, chéngbǎi shàngqiān zhǎn dēng shùnliú yuǎnqù, zhǐyǒu yì zhǎn tíng zài nǐ miànqián. Tā méiyǒu bèi fēng chuīdòng, què huǎnmàn de xiàng shàngyóu tuì qù.',
    vietnamese:
        'Gần nửa đêm, hàng trăm ngọn đèn trôi xuôi, chỉ một chiếc dừng trước mặt rồi chậm rãi lùi ngược dòng, không hề bị gió đẩy.',
    english:
        'Near midnight, hundreds of lanterns drift away downstream. One pauses before you and slowly retreats upstream without wind.',
  ),
  ReadingAnnotation(
    pinyin:
        'Nǐ fǔshēn kànjiàn dēngzhǐ nèicè xiězhe zìjǐ de míngzi. Shuǐ zhōng de dàoyǐng què bú shì xiànzài de nǐ, ér shì yì zhāng cānglǎo xǔduō, zhèng xiǎng kāikǒu shuōhuà de liǎn.',
    vietnamese:
        'Bạn cúi xuống thấy tên mình trong đèn. Nhưng bóng dưới nước không phải bạn hiện tại mà là khuôn mặt già hơn nhiều đang muốn nói.',
    english:
        'Your name is written inside the lantern, but the reflection below is an older face preparing to speak.',
  ),
  ReadingAnnotation(
    pinyin:
        'Dēnghuǒ jíjiāng xīmiè. Nǐ kěyǐ shēnshǒu jiēzhù wèilái de liúyán, yě kěyǐ ràng tā jìxù nìliú, huídào tā zhēnzhèng shǔyú de nà yì nián.',
    vietnamese:
        'Ngọn lửa sắp tắt. Bạn có thể nhận lời nhắn từ tương lai hoặc để chiếc đèn tiếp tục ngược dòng, trở về năm thật sự thuộc về nó.',
    english:
        'The flame is fading. You may receive the message from the future or let the lantern continue upstream toward the year where it belongs.',
  ),
];

const _folkWords = <WordEntry>[
  WordEntry(
    word: '河灯',
    pinyin: 'hédēng',
    partOfSpeech: '名词',
    simpleChinese: '放在河面漂流的灯。',
    translation: 'Đèn được thả trôi trên sông.',
    englishDefinition: 'a floating river lantern',
    symbol: '🏮',
  ),
  WordEntry(
    word: '逆流',
    pinyin: 'nìliú',
    partOfSpeech: '动词／名词',
    simpleChinese: '朝水流相反的方向移动。',
    translation: 'Di chuyển ngược hướng dòng nước.',
    englishDefinition: 'to move against the current',
    symbol: '↙️',
  ),
  WordEntry(
    word: '祈愿',
    pinyin: 'qíyuàn',
    partOfSpeech: '动词',
    simpleChinese: '希望某个愿望能够实现。',
    translation: 'Cầu mong một nguyện vọng thành hiện thực.',
    englishDefinition: 'to make a wish or pray for something',
    symbol: '🙏',
  ),
  WordEntry(
    word: '倒影',
    pinyin: 'dàoyǐng',
    partOfSpeech: '名词',
    simpleChinese: '物体映在水面或镜子里的影像。',
    translation: 'Hình ảnh phản chiếu trên nước hoặc gương.',
    englishDefinition: 'a reflection',
    symbol: '🌊',
  ),
  WordEntry(
    word: '留言',
    pinyin: 'liúyán',
    partOfSpeech: '名词／动词',
    simpleChinese: '留下想让别人看到或听到的话。',
    translation: 'Lời nhắn được để lại cho người khác.',
    englishDefinition: 'a message left for someone',
    symbol: '✉️',
  ),
  WordEntry(
    word: '熄灭',
    pinyin: 'xīmiè',
    partOfSpeech: '动词',
    simpleChinese: '火或灯停止燃烧发光。',
    translation: 'Tắt, ngừng cháy hoặc phát sáng.',
    englishDefinition: 'to go out or be extinguished',
    symbol: '🕯️',
  ),
];

const _folkDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '放河灯在不同地区可能与祈愿、纪念、祭祀或节庆有关，形式和含义并不完全相同。',
    pinyin:
        'Fàng hédēng zài bùtóng dìqū kěnéng yǔ qíyuàn, jìniàn, jìsì huò jiéqìng yǒuguān, xíngshì hé hányì bìng bù wánquán xiāngtóng.',
    simpleChinese: '河灯不是只有一种固定意义，各地习俗可能不同。',
    vietnamese:
        'Thả đèn sông ở các vùng có thể liên quan đến cầu nguyện, tưởng niệm, tế lễ hoặc lễ hội, với ý nghĩa khác nhau.',
    english:
        'River lantern customs vary by region and may involve wishes, remembrance, ritual, or celebration.',
  ),
  DiscoveryEntry(
    text: '了解民俗时，需要说明具体地区和时间，不能把一种地方做法当成所有人的共同习惯。',
    pinyin:
        'Liǎojiě mínsú shí, xūyào shuōmíng jùtǐ dìqū hé shíjiān, bùnéng bǎ yì zhǒng dìfāng zuòfǎ dàngchéng suǒyǒu rén de gòngtóng xíguàn.',
    simpleChinese: '谈民俗要说清楚“哪里、什么时候”，避免过度概括。',
    vietnamese:
        'Khi tìm hiểu phong tục, cần nói rõ địa phương và thời điểm, không nên coi một cách làm địa phương là thói quen chung.',
    english:
        'Folk customs should be tied to a specific place and time rather than generalized as universal practice.',
  ),
  DiscoveryEntry(
    text: '“逆流河灯”是 Phoenix 使用河灯意象创作的原创幻想，不描述某一地区真实存在的固定仪式。',
    pinyin:
        '“Nìliú hédēng” shì Phoenix shǐyòng hédēng yìxiàng chuàngzuò de yuánchuàng huànxiǎng, bù miáoshù mǒu yì dìqū zhēnshí cúnzài de gùdìng yíshì.',
    simpleChinese: '河灯是文化灵感，逆流和未来倒影是原创故事。',
    vietnamese:
        '“Đèn sông ngược dòng” là truyện tưởng tượng nguyên tác của Phoenix, không mô tả một nghi lễ cố định có thật ở địa phương cụ thể.',
    english:
        'The Upstream Lantern is an original Phoenix fantasy and does not represent one fixed real-world ritual.',
  ),
];

JourneyContentRecord _record(
  String id,
  String title,
  String geoNodeId,
  List<String> paragraphs,
) {
  return JourneyContentRecord(
    id: id,
    title: title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.reviewed,
    tags: const ['万象奇旅', '原创幻想', '中文学习'],
    sections: List<JourneyStorySection>.generate(
      paragraphs.length,
      (index) => JourneyStorySection(
        id: 'story-$index',
        text: paragraphs[index],
        sourceIds: const <String>[],
      ),
    ),
  );
}

final literaryRoamingRecord = _record(
  'literary-roaming',
  '文学漫游 · 庄周梦蝶',
  'phoenix-realms-dream-butterfly',
  _literaryStory,
);

final mythTracingRecord = _record(
  'myth-tracing',
  '神话寻踪 · 月宫遗简',
  'phoenix-realms-moon-letter',
  _mythStory,
);

final strangeNightRecord = _record(
  'strange-night-talks',
  '志怪夜话 · 无影客栈',
  'phoenix-realms-shadowless-inn',
  _strangeStory,
);

final folkSecretRecord = _record(
  'folk-secret-land',
  '民俗秘境 · 逆流河灯',
  'phoenix-realms-upstream-lantern',
  _folkStory,
);

final specialJourneyRecords = <JourneyContentRecord>[
  literaryRoamingRecord,
  mythTracingRecord,
  strangeNightRecord,
  folkSecretRecord,
  ...specialJourneyExpansionBatchOneRecords,
];

final specialJourneyExperiences = LazyJourneyList(<DailyJourneyExperienceBuilder>[
  () => DailyJourneyExperience(
    id: literaryRoamingRecord.id,
    city: '梦境',
    cityCode: 'DRM',
    place: '梦蝶竹林',
    appBarTitle: '文学漫游 · 庄周梦蝶',
    storyTitle: '梦与醒之间',
    headline: '追随一只不确定是谁梦见的蝴蝶',
    description: '进入竹林深处，在梦、现实、自我与变化之间寻找出口。',
    discoveryTeaser: '醒来以后，梦里发生的变化还算真实吗？',
    distanceLabel: '梦外一步',
    stampSymbol: '蝶',
    content: literaryRoamingRecord,
    storyAnnotations: _literaryAnnotations,
    words: _literaryWords,
    discoveries: _literaryDiscoveries,
    wonderQuestion: '如果一场梦真正改变了醒来后的你，那场梦算不算真实？',
    expressQuestion: '请写下你会选择回到人间，还是继续追随蝴蝶，并说明原因。',
  ),
  () => DailyJourneyExperience(
    id: mythTracingRecord.id,
    city: '月境',
    cityCode: 'LUN',
    place: '桂影山径',
    appBarTitle: '神话寻踪 · 月宫遗简',
    storyTitle: '月落以前的遗简',
    headline: '沿着桂香寻找一封不属于人间的信',
    description: '穿过悬空之门，把月宫意象、神话版本和自己的选择放进同一段旅程。',
    discoveryTeaser: '同一个神话为什么会拥有多个不同版本？',
    distanceLabel: '月光一程',
    stampSymbol: '月',
    content: mythTracingRecord,
    storyAnnotations: _mythAnnotations,
    words: _mythWords,
    discoveries: _mythDiscoveries,
    wonderQuestion: '有些东西留下才能记住，有些东西归还才算完整。你会怎样选择？',
    expressQuestion: '请用两到三句话写出你如何处理月宫遗简，以及你的理由。',
  ),
  () => DailyJourneyExperience(
    id: strangeNightRecord.id,
    city: '夜境',
    cityCode: 'NGT',
    place: '无影客栈',
    appBarTitle: '志怪夜话 · 无影客栈',
    storyTitle: '鸡鸣以前不要开门',
    headline: '守住夜客留下的最后一个承诺',
    description: '在暴雨、旧客栈和熟悉的声音之间，分辨承诺、诱惑与异常线索。',
    discoveryTeaser: '志怪故事为什么常把最异常的事放进最日常的地方？',
    distanceLabel: '三更之后',
    stampSymbol: '夜',
    content: strangeNightRecord,
    storyAnnotations: _strangeAnnotations,
    words: _strangeWords,
    discoveries: _strangeDiscoveries,
    wonderQuestion: '门外传来你最想念的声音时，你会守住承诺吗？为什么？',
    expressQuestion: '请写下你在鸡鸣以前会做什么，并使用一个表示推测或怀疑的词。',
  ),
  () => DailyJourneyExperience(
    id: folkSecretRecord.id,
    city: '灯河',
    cityCode: 'LMP',
    place: '逆流渡口',
    appBarTitle: '民俗秘境 · 逆流河灯',
    storyTitle: '写着你名字的灯',
    headline: '接住一盏从未来逆流而来的河灯',
    description: '让河灯、祈愿和地方民俗进入一段关于未来留言的原创夜行故事。',
    discoveryTeaser: '为什么谈民俗时必须说明具体地区和时间？',
    distanceLabel: '一河灯火',
    stampSymbol: '灯',
    content: folkSecretRecord,
    storyAnnotations: _folkAnnotations,
    words: _folkWords,
    discoveries: _folkDiscoveries,
    wonderQuestion: '如果未来的你只能留下一句话，你最希望现在的自己听见什么？',
    expressQuestion: '请写下你会接住河灯还是让它继续逆流，并说明你的理由。',
  ),
  ...specialJourneyExpansionBatchOneExperiences,
]);
