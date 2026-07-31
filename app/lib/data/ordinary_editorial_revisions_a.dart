import 'daily_journey_experience.dart';
import 'editorial_story_revision.dart';

const ordinaryEditorialRevisionsA = <String, EditorialStoryRevision>{
  'beijing-forbidden-city': EditorialStoryRevision(
    id: 'beijing-forbidden-city',
    protagonist: '宁宁',
    narrativeMode: '寻物任务',
    emotionalArc: '着急 → 观察 → 理解 → 承担',
    endingMode: '把发现交还给下一位读者',
    sections: [
      '宫门刚开，修复师的女儿宁宁就发现纸鹤不见了。那只纸鹤夹着她外公画的宫门草图，风却把它吹进红墙之间。她拉住你说：“别追着影子跑，先看屋顶和门的方向。”',
      '你们沿宽阔石路寻找。金色屋顶在不同院落里有高有低，宫门、台阶和中轴把人一步步引向深处。宁宁起初只想快点找回纸鹤，后来却发现草图上的每一条线都对应真实建筑。',
      '纸鹤最后停在一块介绍旧木构修复的展板旁。宁宁看见工匠留下的编号，忽然明白外公画图不是为了把故宫画得漂亮，而是为了让受损部件能够被认出、记录和修复。',
      '她没有把纸鹤收进口袋，而是在背面写下今天找到的路线，交给下一位小游客。离开时，红墙仍然安静，可你们已经知道，一座宫殿保存国家记忆，也靠许多人把细小线索认真传下去。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Gōngmén gāng kāi, xiūfùshī de nǚ’ér Níngning jiù fāxiàn zhǐhè bú jiàn le. Nà zhī zhǐhè jiāzhe tā wàigōng huà de gōngmén cǎotú, fēng què bǎ tā chuī jìn hóngqiáng zhījiān. Tā lāzhù nǐ shuō: “Bié zhuīzhe yǐngzi pǎo, xiān kàn wūdǐng hé mén de fāngxiàng.”',
        vietnamese: 'Vừa mở cổng cung, Ninh Ninh phát hiện con hạc giấy kẹp bản phác thảo của ông ngoại đã bị gió cuốn vào giữa những bức tường đỏ. Cô bé bảo bạn đừng chạy theo bóng mà hãy nhìn hướng mái và cổng.',
        english: 'As the palace gates open, Ningning discovers that the paper crane holding her grandfather’s gate sketch has blown between the red walls. She tells you to read the roofs and gates instead of chasing shadows.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐmen yán kuānkuò shílù xúnzhǎo. Jīnsè wūdǐng zài bùtóng yuànluò lǐ yǒu gāo yǒu dī, gōngmén, táijiē hé zhōngzhóu bǎ rén yí bù bù yǐnxiàng shēnchù. Níngning qǐchū zhǐ xiǎng kuài diǎn zhǎohuí zhǐhè, hòulái què fāxiàn cǎotú shàng de měi yì tiáo xiàn dōu duìyìng zhēnshí jiànzhù.',
        vietnamese: 'Hai bạn tìm dọc con đường đá rộng. Mái vàng, cổng, bậc thềm và trục giữa dẫn người vào sâu hơn; Ninh Ninh nhận ra từng nét trên bản phác đều ứng với kiến trúc thật.',
        english: 'You search along the broad stone route. Roof heights, gates, steps, and the central axis lead inward, and Ningning realizes that every line in the sketch corresponds to real architecture.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhǐhè zuìhòu tíng zài yí kuài jièshào jiù mùgòu xiūfù de zhǎnbǎn páng. Níngning kànjiàn gōngjiàng liúxià de biānhào, hūrán míngbai wàigōng huàtú bú shì wèile bǎ Gùgōng huà de piàoliang, ér shì wèile ràng shòusǔn bùjiàn nénggòu bèi rènchū, jìlù hé xiūfù.',
        vietnamese: 'Con hạc dừng cạnh bảng về tu bổ kết cấu gỗ. Nhìn các mã số của thợ, Ninh Ninh hiểu ông ngoại vẽ không chỉ để đẹp mà để nhận diện, ghi chép và phục hồi bộ phận hư hại.',
        english: 'The crane lands beside a display on timber conservation. Seeing the artisans’ numbers, Ningning understands that her grandfather drew to identify, document, and repair damaged parts, not merely to make a pretty picture.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā méiyǒu bǎ zhǐhè shōu jìn kǒudài, ér shì zài bèimiàn xiěxià jīntiān zhǎodào de lùxiàn, jiāogěi xià yí wèi xiǎo yóukè. Líkāi shí, hóngqiáng réngrán ānjìng, kě nǐmen yǐjīng zhīdào, yí zuò gōngdiàn bǎocún guójiā jìyì, yě kào xǔduō rén bǎ xìxiǎo xiànsuǒ rènzhēn chuán xiàqù.',
        vietnamese: 'Cô bé viết tuyến đường tìm được lên mặt sau hạc giấy rồi trao cho một du khách nhỏ khác. Hai bạn hiểu ký ức của cung điện được truyền tiếp nhờ nhiều người chăm chút từng dấu vết nhỏ.',
        english: 'She writes the route on the crane and passes it to another young visitor. You leave knowing that a palace preserves national memory because many people carefully carry small clues forward.',
      ),
    ],
    wonderQuestion: '如果你只能替未来保存故宫里的一个细节，你会选择什么，为什么？',
    expressQuestion: '请用“起初……后来……”写宁宁对那张草图的认识变化。',
  ),
  'beijing-summer-palace': EditorialStoryRevision(
    id: 'beijing-summer-palace',
    protagonist: '阿真',
    narrativeMode: '移动取景挑战',
    emotionalArc: '急于完成 → 困惑 → 放慢 → 看见',
    endingMode: '同一景物获得新的观看方式',
    sections: [
      '阿真参加少年绘景比赛，题目是“只画一次，却让人看见三种颐和园”。他在昆明湖边急得直跺脚：“湖就是湖，怎么会有三种？”你们决定先不落笔，沿长廊慢慢走。',
      '廊柱一次次切开湖光，树木遮住半座万寿山，下一步又把佛香阁送回视线。阿真画下近处彩画、柱间远山和水中倒影，却发现三幅小画彼此争抢，没有形成一个完整画面。',
      '走到十七孔桥时，一阵风把画纸掀起。阿真追纸的路线恰好经过开敞、遮蔽和对景三个位置。他停下来，把刚才移动中的视线连成一条线，终于懂得园林不是把美景堆在一起，而是安排人怎样遇见它。',
      '比赛结束，他没有交出最华丽的画，而是交出一张带脚印的小地图。评语只有一句：“这张画会走路。”回头看时，湖山没有改变，改变的是你们学会让眼睛在山、水和建筑之间旅行。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Ā Zhēn cānjiā shàonián huìjǐng bǐsài, tímù shì “zhǐ huà yí cì, què ràng rén kànjiàn sān zhǒng Yíhéyuán”. Tā zài Kūnmíng Hú biān jí de zhí duòjiǎo: “Hú jiù shì hú, zěnme huì yǒu sān zhǒng?” Nǐmen juédìng xiān bú luòbǐ, yán Chángláng mànmàn zǒu.',
        vietnamese: 'A Chân dự cuộc thi vẽ cảnh với đề bài chỉ vẽ một lần mà cho thấy ba Di Hòa Viên. Không hiểu làm sao một hồ lại thành ba cảnh, cậu cùng bạn đi chậm qua Trường Lang trước khi đặt bút.',
        english: 'Azhen enters a young artists’ challenge to show three Summer Palaces in one drawing. Unable to imagine how one lake can become three views, he walks the Long Corridor with you before drawing.',
      ),
      ReadingAnnotation(
        pinyin: 'Lángzhù yí cì cì qiēkāi húguāng, shùmù zhēzhù bàn zuò Wànshòu Shān, xià yí bù yòu bǎ Fóxiāng Gé sòng huí shìxiàn. Ā Zhēn huàxià jìnchù cǎihuà, zhùjiān yuǎnshān hé shuǐzhōng dàoyǐng, què fāxiàn sān fú xiǎohuà bǐcǐ zhēngqiǎng, méiyǒu xíngchéng yí gè wánzhěng huàmiàn.',
        vietnamese: 'Cột hành lang chia ánh hồ, cây che nửa núi rồi Phật Hương Các lại hiện ra. A Chân vẽ tranh màu gần, núi xa giữa cột và bóng nước, nhưng ba hình vẫn rời rạc.',
        english: 'Columns divide the lake light, trees hide half the hill, and the tower returns with the next step. Azhen sketches painted beams, distant hills, and reflections, but the three images still compete.',
      ),
      ReadingAnnotation(
        pinyin: 'Zǒudào Shíqīkǒng Qiáo shí, yí zhèn fēng bǎ huàzhǐ xiānqǐ. Ā Zhēn zhuī zhǐ de lùxiàn qiàhǎo jīngguò kāichǎng, zhēbì hé duìjǐng sān gè wèizhi. Tā tíng xiàlái, bǎ gāngcái yídòng zhōng de shìxiàn lián chéng yì tiáo xiàn, zhōngyú dǒngde yuánlín bú shì bǎ měijǐng duī zài yìqǐ, ér shì ānpái rén zěnyàng yùjiàn tā.',
        vietnamese: 'Gió cuốn giấy ở cầu Thập Thất Khổng. Đường đuổi theo giấy đi qua ba vị trí mở, che và đối cảnh, giúp A Chân nối các góc nhìn thành một tuyến.',
        english: 'A gust lifts the paper at the Seventeen-Arch Bridge. Chasing it through open, screened, and paired views helps Azhen connect the moving viewpoints into one route.',
      ),
      ReadingAnnotation(
        pinyin: 'Bǐsài jiéshù, tā méiyǒu jiāochū zuì huálì de huà, ér shì jiāochū yì zhāng dài jiǎoyìn de xiǎo dìtú. Píngyǔ zhǐyǒu yí jù: “Zhè zhāng huà huì zǒulù.” Huítóu kàn shí, húshān méiyǒu gǎibiàn, gǎibiàn de shì nǐmen xuéhuì ràng yǎnjing zài shān, shuǐ hé jiànzhù zhījiān lǚxíng.',
        vietnamese: 'Cậu nộp một bản đồ có dấu chân thay vì bức tranh lộng lẫy. Lời nhận xét là “bức tranh này biết đi”, vì điều thay đổi chính là cách mắt các bạn di chuyển giữa núi, nước và kiến trúc.',
        english: 'He submits a footprint map rather than the most ornate picture. The judge writes, “This drawing can walk,” because the true change is how your eyes travel among hill, water, and architecture.',
      ),
    ],
    wonderQuestion: '为什么同一个景物会因为路线和遮挡而产生不同感受？',
    expressQuestion: '请用“刚才还……下一步却……”描写一次移动中的景色变化。',
  ),
  'shanghai-bund': EditorialStoryRevision(
    id: 'shanghai-bund',
    protagonist: '乐乐',
    narrativeMode: '旧照片定位谜题',
    emotionalArc: '自信 → 失误 → 比较 → 重新定位',
    endingMode: '在新旧城市之间找到自己的坐标',
    sections: [
      '建筑社团的乐乐带来一张旧照片，断定照片里的钟楼在浦东。老摄影师摇头：“别被高楼骗了，先找江风吹来的方向。”你们站在黄浦江边，把照片、外滩老建筑和现代天际线放在同一条视线上。',
      '乐乐沿滨水步道寻找相同轮廓。照片里的银行、贸易公司旧址和石材立面仍在西岸，江的另一边却已升起浦东高楼。他发现自己把“看起来更新”误当成了“照片拍摄的位置”。',
      '一艘船经过，短暂挡住两岸。船离开时，旧建筑与新城市再次隔江相望。老摄影师让乐乐在照片背面画一条河，说：“城市不是把旧的擦掉再画新的，它常常让两个时代同时留在画面里。”',
      '乐乐把钟楼标回正确位置，又在空白处画上今天的自己。照片从历史证据变成一张能够继续生长的城市图。夜灯亮起时，他记住的不是哪一岸更耀眼，而是怎样先观察，再判断自己的坐标。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Jiànzhù shètuán de Lèlè dàilái yì zhāng jiù zhàopiàn, duàndìng zhàopiàn lǐ de zhōnglóu zài Pǔdōng. Lǎo shèyǐngshī yáotóu: “Bié bèi gāolóu piàn le, xiān zhǎo jiāngfēng chuī lái de fāngxiàng.” Nǐmen zhàn zài Huángpǔ Jiāng biān, bǎ zhàopiàn, Wàitān lǎo jiànzhù hé xiàndài tiānjìxiàn fàng zài tóng yì tiáo shìxiàn shàng.',
        vietnamese: 'Lạc Lạc khẳng định tháp đồng hồ trong ảnh cũ ở Phố Đông. Nhiếp ảnh gia già bảo đừng để cao ốc đánh lừa mà hãy xác định hướng gió sông, rồi cùng bạn đặt ảnh, kiến trúc Bến Thượng Hải và đường chân trời hiện đại trên một trục nhìn.',
        english: 'Lele insists that the clock tower in an old photograph stands in Pudong. An elderly photographer tells him to use the river wind rather than the towers, and you align the photograph, the Bund, and the modern skyline.',
      ),
      ReadingAnnotation(
        pinyin: 'Lèlè yán bīnshuǐ bùdào xúnzhǎo xiāngtóng lúnkuò. Zhàopiàn lǐ de yínháng, màoyì gōngsī jiùzhǐ hé shícái lìmiàn réng zài xī’àn, jiāng de lìng yì biān què yǐ shēngqǐ Pǔdōng gāolóu. Tā fāxiàn zìjǐ bǎ “kàn qǐlái gèng xīn” wùdàng chéng le “zhàopiàn pāishè de wèizhi”.',
        vietnamese: 'Đi dọc bờ sông, cậu nhận ra ngân hàng và trụ sở thương mại cũ vẫn ở bờ tây, còn cao ốc Phố Đông ở bờ kia. Cậu đã nhầm nơi trông mới hơn với nơi bức ảnh được chụp.',
        english: 'Along the waterfront he finds the old banks and trading buildings on the west bank, while Pudong rises across the river. He realizes that he confused the newer-looking side with the photograph’s location.',
      ),
      ReadingAnnotation(
        pinyin: 'Yì sōu chuán jīngguò, duǎnzàn dǎngzhù liǎng’àn. Chuán líkāi shí, jiù jiànzhù yǔ xīn chéngshì zàicì gé jiāng xiāngwàng. Lǎo shèyǐngshī ràng Lèlè zài zhàopiàn bèimiàn huà yì tiáo hé, shuō: “Chéngshì bú shì bǎ jiù de cādiào zài huà xīn de, tā chángcháng ràng liǎng gè shídài tóngshí liú zài huàmiàn lǐ.”',
        vietnamese: 'Một con tàu che hai bờ rồi để chúng hiện lại đối diện nhau. Nhiếp ảnh gia bảo Lạc Lạc vẽ con sông sau ảnh và giải thích rằng thành phố thường giữ hai thời đại trong cùng một khung hình.',
        english: 'A passing ship briefly hides both banks, then reveals old and new Shanghai facing each other again. The photographer asks Lele to draw the river and explains that cities often keep two eras in one frame.',
      ),
      ReadingAnnotation(
        pinyin: 'Lèlè bǎ zhōnglóu biāo huí zhèngquè wèizhi, yòu zài kòngbái chù huàshàng jīntiān de zìjǐ. Zhàopiàn cóng lìshǐ zhèngjù biàn chéng yì zhāng nénggòu jìxù shēngzhǎng de chéngshì tú. Yèdēng liàngqǐ shí, tā jìzhù de bú shì nǎ yí àn gèng yàoyǎn, ér shì zěnyàng xiān guānchá, zài pànduàn zìjǐ de zuòbiāo.',
        vietnamese: 'Cậu đánh dấu lại tháp và vẽ thêm mình vào khoảng trống, biến ảnh lịch sử thành bản đồ thành phố còn tiếp tục lớn lên. Điều cậu nhớ là phải quan sát trước khi xác định vị trí.',
        english: 'He restores the tower to its correct place and draws himself into the blank space, turning evidence from the past into a city map that can keep growing. He remembers to observe before fixing his own coordinates.',
      ),
    ],
    wonderQuestion: '一张旧照片怎样帮助人判断城市哪些地方改变了，哪些仍然存在？',
    expressQuestion: '请用“我原以为……比较以后……”写乐乐纠正判断的过程。',
  ),
  'xian-city-wall': EditorialStoryRevision(
    id: 'xian-city-wall',
    protagonist: '小羽',
    narrativeMode: '夜间送信任务',
    emotionalArc: '逞强 → 迷路 → 合作 → 找到方向',
    endingMode: '用城墙结构完成真实行动',
    sections: [
      '傍晚，骑行队的小羽接到一封急信，要在城门关闭前送到南门附近的老书店。他不肯看地图，拍着车铃说：“沿城墙一直骑，怎么可能迷路？”可第一座角楼过去后，四面的砖墙看起来几乎一样。',
      '你提醒他观察城门、角楼和护城河的位置。宽阔墙顶曾方便守城人员巡查，如今也让你们从高处辨认老城街巷和现代道路。小羽终于承认，直线很长，并不代表方向永远简单。',
      '风把信封吹进女墙边的排水口旁。你们停下捡信，也发现远处永宁门灯光正对着南北中轴。小羽把城墙结构画成四边形，用角楼作转折点，重新算出最短路线。',
      '书店关门前，急信送到了。店主在回信上盖了一枚小城门章，笑说：“会认路的人，不是从不迷路，而是知道怎样重新判断。”回程时，小羽把车铃按得很轻，开始留意脚下每一块指路的砖。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Bàngwǎn, qíxíngduì de Xiǎoyǔ jiēdào yì fēng jíxìn, yào zài chéngmén guānbì qián sòngdào Nánmén fùjìn de lǎo shūdiàn. Tā bù kěn kàn dìtú, pāizhe chēlíng shuō: “Yán chéngqiáng yìzhí qí, zěnme kěnéng mílù?” Kě dì yí zuò jiǎolóu guòqù hòu, sìmiàn de zhuānqiáng kàn qǐlái jīhū yíyàng.',
        vietnamese: 'Chiều tối, Tiểu Vũ phải giao thư gấp trước khi cổng đóng nhưng không chịu xem bản đồ. Qua tháp góc đầu tiên, bốn phía tường gạch gần như giống hệt nhau và cậu bắt đầu lạc.',
        english: 'At dusk, Xiaoyu must deliver an urgent letter before the gates close, but refuses to use a map. After the first corner tower, every brick wall looks alike and he loses his bearings.',
      ),
      ReadingAnnotation(
        pinyin: 'Nǐ tíxǐng tā guānchá chéngmén, jiǎolóu hé hùchénghé de wèizhi. Kuānkuò qiángdǐng céng fāngbiàn shǒuchéng rényuán xúnchá, rújīn yě ràng nǐmen cóng gāochù biànrèn lǎochéng jiēxiàng hé xiàndài dàolù. Xiǎoyǔ zhōngyú chéngrèn, zhíxiàn hěn cháng, bìng bù dàibiǎo fāngxiàng yǒngyuǎn jiǎndān.',
        vietnamese: 'Bạn nhắc cậu dùng vị trí cổng, tháp góc và hào nước. Mặt thành rộng từng phục vụ tuần tra, nay giúp hai bạn phân biệt phố cổ và đường hiện đại từ trên cao.',
        english: 'You use the gates, corner towers, and moat as anchors. The broad wall top once supported patrols and now lets you distinguish old lanes from modern roads above the city.',
      ),
      ReadingAnnotation(
        pinyin: 'Fēng bǎ xìnfēng chuī jìn nǚqiáng biān de páishuǐkǒu páng. Nǐmen tíng xià jiǎn xìn, yě fāxiàn yuǎnchù Yǒngníng Mén dēngguāng zhèng duìzhe nánběi zhōngzhóu. Xiǎoyǔ bǎ chéngqiáng jiégòu huà chéng sìbiānxíng, yòng jiǎolóu zuò zhuǎnzhédiǎn, chóngxīn suànchū zuìduǎn lùxiàn.',
        vietnamese: 'Gió thổi thư đến cửa thoát nước cạnh tường chắn. Khi nhặt thư, hai bạn thấy ánh đèn Vĩnh Ninh Môn thẳng với trục bắc nam; Tiểu Vũ vẽ thành thành hình bốn cạnh và tính lại đường ngắn nhất.',
        english: 'The wind blows the letter beside a drainage opening. While retrieving it, you spot Yongning Gate on the north-south axis, and Xiaoyu redraws the wall as a four-sided route with towers as turning points.',
      ),
      ReadingAnnotation(
        pinyin: 'Shūdiàn guānmén qián, jíxìn sòngdào le. Diànzhǔ zài huíxìn shàng gài le yì méi xiǎo chéngmén zhāng, xiàozhe shuō: “Huì rènlù de rén, bú shì cóng bù mílù, ér shì zhīdào zěnyàng chóngxīn pànduàn.” Huíchéng shí, Xiǎoyǔ bǎ chēlíng àn de hěn qīng, kāishǐ liúyì jiǎoxià měi yí kuài zhǐlù de zhuān.',
        vietnamese: 'Thư đến trước giờ đóng cửa. Chủ tiệm đóng dấu cổng thành và nói người biết đường không phải không bao giờ lạc, mà biết đánh giá lại. Trên đường về, Tiểu Vũ bắt đầu chú ý từng viên gạch chỉ hướng.',
        english: 'The letter arrives before closing. The bookseller stamps the reply and says that good navigators are not people who never get lost, but people who know how to judge again. Xiaoyu rides home watching every guiding brick.',
      ),
    ],
    wonderQuestion: '为什么城墙上的角楼、城门和中轴都可以成为判断方向的线索？',
    expressQuestion: '请用“虽然……但是……”写小羽从逞强到合作的变化。',
  ),
  'hangzhou-west-lake': EditorialStoryRevision(
    id: 'hangzhou-west-lake',
    protagonist: '小满',
    narrativeMode: '寻找唯一最佳照片',
    emotionalArc: '执着 → 失望 → 倾听 → 接受变化',
    endingMode: '放弃唯一答案，留下过程',
    sections: [
      '小满带着相机来到苏堤，宣布今天只拍一张“最像西湖”的照片。她等湖面完全安静，却总有人走上桥、柳条落进画面，连远山也被云遮住。她抱怨：“风景为什么不能配合一下？”',
      '扫湖的周师傅听见了，递给她一把长柄网兜：“你先帮我捞起这片枯枝，再决定什么该留、什么该去。”两人沿堤岸前行，亭台、宝塔、园林和倒映不断改变位置，西湖像一幅被脚步慢慢翻动的画。',
      '小满正准备按下快门，一只白鹭突然掠过水面。她本想等它飞走，却看见桥上孩子同时抬头，周师傅也停下网兜。那一刻，自然、城市生活和人的设计不再争抢画面，而是在同一秒彼此回应。',
      '她最终交出的不是一张完美风景照，而是三张连拍：白鹭来前、掠过时、离开后。照片下面写着：“西湖没有唯一的样子。”周师傅笑了，因为她终于拍到的不是静止背景，而是山水与生活一起呼吸。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Xiǎomǎn dàizhe xiàngjī láidào Sūdī, xuānbù jīntiān zhǐ pāi yì zhāng “zuì xiàng Xīhú” de zhàopiàn. Tā děng húmiàn wánquán ānjìng, què zǒng yǒu rén zǒushàng qiáo, liǔtiáo luò jìn huàmiàn, lián yuǎnshān yě bèi yún zhēzhù. Tā bàoyuàn: “Fēngjǐng wèishénme bùnéng pèihé yíxià?”',
        vietnamese: 'Tiểu Mãn muốn chỉ chụp một tấm “giống Tây Hồ nhất”, nhưng người qua cầu, cành liễu và mây luôn làm khung hình thay đổi. Cô bé than sao phong cảnh không chịu phối hợp.',
        english: 'Xiaoman plans to take one photograph that looks most like West Lake, but walkers, willows, and clouds keep changing the frame. She complains that the scenery will not cooperate.',
      ),
      ReadingAnnotation(
        pinyin: 'Sǎohú de Zhōu shīfu tīngjiàn le, dìgěi tā yì bǎ chángbǐng wǎngdōu: “Nǐ xiān bāng wǒ lāoqǐ zhè piàn kūzhī, zài juédìng shénme gāi liú, shénme gāi qù.” Liǎng rén yán dī’àn qiánxíng, tíngtái, bǎotǎ, yuánlín hé dàoyìng bùduàn gǎibiàn wèizhi, Xīhú xiàng yì fú bèi jiǎobù mànmàn fāndòng de huà.',
        vietnamese: 'Chú Châu quét hồ nhờ cô vớt cành khô rồi mới quyết định thứ gì nên giữ trong ảnh. Dọc bờ, đình, tháp, vườn và bóng nước đổi chỗ như một bức tranh được bước chân lật dần.',
        english: 'Mr. Zhou, who cleans the lake, asks her to retrieve a branch before deciding what belongs in the frame. Along the causeway, pavilions, pagodas, gardens, and reflections shift like a painting turned by footsteps.',
      ),
      ReadingAnnotation(
        pinyin: 'Xiǎomǎn zhèng zhǔnbèi ànxià kuàimén, yì zhī báilù tūrán lüèguò shuǐmiàn. Tā běn xiǎng děng tā fēizǒu, què kànjiàn qiáoshàng háizi tóngshí táitóu, Zhōu shīfu yě tíngxià wǎngdōu. Nà yí kè, zìrán, chéngshì shēnghuó hé rén de shèjì bú zài zhēngqiǎng huàmiàn, ér shì zài tóng yì miǎo bǐcǐ huíyìng.',
        vietnamese: 'Một con cò trắng lướt qua khi cô sắp chụp. Trẻ trên cầu cùng ngẩng đầu và chú Châu dừng vợt; thiên nhiên, đời sống và thiết kế con người bất ngờ đáp lại nhau.',
        english: 'A white egret crosses the water just as she is ready to shoot. Children look up and Mr. Zhou pauses, allowing nature, city life, and human design to answer one another in the same second.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā zuìzhōng jiāochū de bú shì yì zhāng wánměi fēngjǐngzhào, ér shì sān zhāng liánpāi: báilù lái qián, lüèguò shí, líkāi hòu. Zhàopiàn xiàmiàn xiězhe: “Xīhú méiyǒu wéiyī de yàngzi.” Zhōu shīfu xiào le, yīnwèi tā zhōngyú pāidào de bú shì jìngzhǐ bèijǐng, ér shì shānshuǐ yǔ shēnghuó yìqǐ hūxī.',
        vietnamese: 'Cô nộp ba ảnh liên tiếp trước, trong và sau khi cò bay qua, ghi rằng Tây Hồ không có một hình dáng duy nhất. Cô đã chụp được cảnh quan cùng đời sống đang thở.',
        english: 'She submits three frames from before, during, and after the egret’s flight, writing that West Lake has no single form. She has photographed landscape and life breathing together.',
      ),
    ],
    wonderQuestion: '一处文化景观为什么可以同时包含自然变化和人的日常活动？',
    expressQuestion: '请用三个连续动作描写同一处景色怎样发生变化。',
  ),
  'chengdu-kuanzhai-alley': EditorialStoryRevision(
    id: 'chengdu-kuanzhai-alley',
    protagonist: '安安',
    narrativeMode: '茶馆送茶轻喜剧',
    emotionalArc: '慌乱 → 逞快 → 出错 → 找到自己的节奏',
    endingMode: '用一声杯盖收束城市性格',
    sections: [
      '茶馆学徒安安第一次独自送盖碗茶，偏偏三位客人分别坐在宽巷子、窄巷子和井巷子。他把托盘举得像冠军奖杯，催你快跑：“茶凉了，我师父会把我泡进茶壶里！”',
      '宽巷子人多，安安侧身避开游客；窄巷子转弯急，他又差点撞上木门；到了井巷子，小店老板叫住他问路。青砖墙、院落、茶馆和餐厅把三条街装进不同节奏，越急越容易走错。',
      '第二碗茶果然送错了。安安脸涨得通红，老茶客却没有生气，只用杯盖轻轻碰碗：“听见没有？先停一下。”安安照着声音重新分单，发现宽、窄、井不是快慢排名，而是三种空间和生活方式。',
      '最后一碗送到时，茶仍然温热。师父没有夸他跑得快，只夸托盘一滴没洒。安安回店途中故意慢了半步，让杯盖的清响跟街巷声音合在一起，也第一次明白成都的慢生活不是拖延，而是知道什么时候不必赶。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Cháguǎn xuétú Ān’ān dì yí cì dúzì sòng gàiwǎnchá, piānpiān sān wèi kèrén fēnbié zuò zài Kuān Xiàngzi, Zhǎi Xiàngzi hé Jǐng Xiàngzi. Tā bǎ tuōpán jǔ de xiàng guànjūn jiǎngbēi, cuī nǐ kuài pǎo: “Chá liáng le, wǒ shīfu huì bǎ wǒ pào jìn cháhú lǐ!”',
        vietnamese: 'Học việc An An lần đầu tự giao trà đến ba ngõ. Cậu nâng khay như cúp vô địch và đùa rằng nếu trà nguội, sư phụ sẽ ngâm cậu vào ấm trà.',
        english: 'Tea apprentice Anan must deliver covered-bowl tea to three alleys. Holding the tray like a trophy, he jokes that his master will steep him in the teapot if the tea cools.',
      ),
      ReadingAnnotation(
        pinyin: 'Kuān Xiàngzi rén duō, Ān’ān cèshēn bìkāi yóukè; Zhǎi Xiàngzi zhuǎnwān jí, tā yòu chàdiǎn zhuàngshàng mùmén; dàole Jǐng Xiàngzi, xiǎodiàn lǎobǎn jiàozhù tā wènlù. Qīngzhuānqiáng, yuànluò, cháguǎn hé cāntīng bǎ sān tiáo jiē zhuāng jìn bùtóng jiézòu, yuè jí yuè róngyì zǒucuò.',
        vietnamese: 'Ngõ Rộng đông, Ngõ Hẹp cua gấp, còn Ngõ Giếng có chủ tiệm hỏi đường. Tường gạch, sân nhà, trà quán và nhà hàng tạo ba nhịp khác nhau; càng vội càng dễ nhầm.',
        english: 'Wide Alley is crowded, Narrow Alley bends sharply, and a shopkeeper stops him in Well Alley. Courtyards, tea houses, and shops give each lane a different rhythm, and haste makes mistakes more likely.',
      ),
      ReadingAnnotation(
        pinyin: 'Dì èr wǎn chá guǒrán sòngcuò le. Ān’ān liǎn zhàng de tōnghóng, lǎo chákè què méiyǒu shēngqì, zhǐ yòng bēigài qīngqīng pèng wǎn: “Tīngjiàn méiyǒu? Xiān tíng yíxià.” Ān’ān zhàozhe shēngyīn chóngxīn fēndān, fāxiàn kuān, zhǎi, jǐng bú shì kuàimàn páimíng, ér shì sān zhǒng kōngjiān hé shēnghuó fāngshì.',
        vietnamese: 'An An giao nhầm bát thứ hai. Khách già chỉ gõ nhẹ nắp chén, bảo cậu dừng lại; cậu hiểu ba ngõ không xếp hạng nhanh chậm mà có ba không gian sống riêng.',
        english: 'Anan delivers the second bowl incorrectly. An elderly customer taps the lid and tells him to pause, helping him see that the alleys are not a speed ranking but three kinds of space and life.',
      ),
      ReadingAnnotation(
        pinyin: 'Zuìhòu yì wǎn sòngdào shí, chá réngrán wēnrè. Shīfu méiyǒu kuā tā pǎo de kuài, zhǐ kuā tuōpán yì dī méi sǎ. Ān’ān huídiàn túzhōng gùyì màn le bàn bù, ràng bēigài de qīngxiǎng gēn jiēxiàng shēngyīn hé zài yìqǐ, yě dì yí cì míngbai Chéngdū de màn shēnghuó bú shì tuōyán, ér shì zhīdào shénme shíhou búbì gǎn.',
        vietnamese: 'Bát cuối vẫn ấm và không giọt nào đổ. Trên đường về, An An chậm nửa bước để tiếng nắp chén hòa vào phố, hiểu sống chậm là biết lúc nào không cần vội.',
        english: 'The last bowl arrives warm without a spill. Anan slows half a step on the way back, letting the lid join the street sounds and learning that slow living means knowing when not to rush.',
      ),
    ],
    wonderQuestion: '空间的宽窄和街道用途为什么会改变人的行走节奏？',
    expressQuestion: '请写一段带声音的轻松对话，让人物因为误会而改变做法。',
  ),
  'nanjing-qinhuai-river': EditorialStoryRevision(
    id: 'nanjing-qinhuai-river',
    protagonist: '月月',
    narrativeMode: '灯谜寻签',
    emotionalArc: '期待 → 丢失 → 追索 → 分享',
    endingMode: '谜底变成送给陌生人的灯',
    sections: [
      '灯会前夜，小灯匠月月把最后一张谜签系在莲花灯下，转身却发现绳结空了。那道谜写着“没有脚，却带整座城向前”，是她准备送给外婆的。你们沿秦淮河追着被风卷走的纸签。',
      '纸签先落在石桥边，又被游船带起。夫子庙、江南贡院、牌坊和街巷沿河展开，考试、商业与民俗的旧故事被灯光重新照亮。月月一边追，一边听见卖小吃的人、剪纸师傅和曲艺演员喊她的名字。',
      '纸签最后卡在一盏陌生孩子的破灯上。月月本想立刻取回，却看见那孩子正为没有谜语而难过。她忽然猜到自己的谜底是“河流”，因为河没有脚，却连接桥、街、记忆和今天的人。',
      '她把谜签留在破灯上，自己重新写了一张：“什么东西越分享越亮？”外婆读完没有回答，只把两盏灯并排放进河边灯阵。游船从桥下经过时，月月明白，城市记忆不是只属于最早写下它的人。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Dēnghuì qiányè, xiǎo dēngjiàng Yuèyuè bǎ zuìhòu yì zhāng míqiān jì zài liánhuādēng xià, zhuǎnshēn què fāxiàn shéngjié kōng le. Nà dào mí xiězhe “méiyǒu jiǎo, què dài zhěng zuò chéng xiàng qián”, shì tā zhǔnbèi sònggěi wàipó de. Nǐmen yán Qínhuái Hé zhuīzhe bèi fēng juǎnzǒu de zhǐqiān.',
        vietnamese: 'Đêm trước hội đèn, Nguyệt Nguyệt mất tờ câu đố dành tặng bà ngoại: “không có chân mà đưa cả thành phố đi tới”. Hai bạn đuổi theo tờ giấy dọc sông Tần Hoài.',
        english: 'On the eve of the lantern fair, Yueyue loses the riddle tag meant for her grandmother: “It has no feet, yet carries the whole city forward.” You chase it along the Qinhuai River.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhǐqiān xiān luò zài shíqiáo biān, yòu bèi yóuchuán dài qǐ. Fūzǐmiào, Jiāngnán Gòngyuàn, páifāng hé jiēxiàng yán hé zhǎnkāi, kǎoshì, shāngyè yǔ mínsú de jiù gùshi bèi dēngguāng chóngxīn zhàoliàng. Yuèyuè yìbiān zhuī, yìbiān tīngjiàn mài xiǎochī de rén, jiǎnzhǐ shīfu hé qǔyì yǎnyuán hǎn tā de míngzi.',
        vietnamese: 'Tờ giấy bay qua cầu và thuyền. Phu Tử Miếu, trường thi, cổng bài và phố ven sông sáng lên cùng chuyện thi cử, buôn bán và dân tục; người bán hàng, nghệ nhân cắt giấy và diễn viên cùng gọi cô.',
        english: 'The tag skips from bridge to boat as the temple, examination hall, archways, and lanes light up stories of education, trade, and custom. Vendors, paper-cutters, and performers call to Yueyue as she runs.',
      ),
      ReadingAnnotation(
        pinyin: 'Zhǐqiān zuìhòu kǎ zài yì zhǎn mòshēng háizi de pòdēng shàng. Yuèyuè běn xiǎng lìkè qǔhuí, què kànjiàn nà háizi zhèng wèi méiyǒu míyǔ ér nánguò. Tā hūrán cāidào zìjǐ de mídǐ shì “héliú”, yīnwèi hé méiyǒu jiǎo, què liánjiē qiáo, jiē, jìyì hé jīntiān de rén.',
        vietnamese: 'Tờ đố mắc vào chiếc đèn rách của một đứa trẻ không có câu đố. Nguyệt Nguyệt nhận ra đáp án là dòng sông, vì nó nối cầu, phố, ký ức và con người hôm nay.',
        english: 'The tag catches on another child’s broken lantern. Yueyue realizes that the answer is the river, which links bridges, streets, memories, and people without having feet.',
      ),
      ReadingAnnotation(
        pinyin: 'Tā bǎ míqiān liú zài pòdēng shàng, zìjǐ chóngxīn xiě le yì zhāng: “Shénme dōngxi yuè fēnxiǎng yuè liàng?” Wàipó dúwán méiyǒu huídá, zhǐ bǎ liǎng zhǎn dēng bìngpái fàng jìn hébiān dēngzhèn. Yóuchuán cóng qiáoxià jīngguò shí, Yuèyuè míngbai, chéngshì jìyì bú shì zhǐ shǔyú zuìzǎo xiěxià tā de rén.',
        vietnamese: 'Cô để câu đố trên chiếc đèn kia và viết câu mới: “thứ gì càng chia sẻ càng sáng?” Bà ngoại đặt hai đèn cạnh nhau, giúp cô hiểu ký ức đô thị không chỉ thuộc người viết đầu tiên.',
        english: 'She leaves the tag and writes a new riddle: “What grows brighter when shared?” Her grandmother places both lanterns together, and Yueyue understands that city memory does not belong only to its first writer.',
      ),
    ],
    wonderQuestion: '为什么河流、节日和手艺能够一起保存一座城市的生活记忆？',
    expressQuestion: '请设计一个与秦淮河有关的灯谜，并用两句话解释谜底。',
  ),
  'guangzhou-chen-clan-academy': EditorialStoryRevision(
    id: 'guangzhou-chen-clan-academy',
    protagonist: '阿巧',
    narrativeMode: '细节侦察游戏',
    emotionalArc: '轻视 → 好胜 → 专注 → 敬佩',
    endingMode: '从寻找答案转为留下问题',
    sections: [
      '阿巧跟着木雕师傅走进陈家祠，第一句话却是：“装饰太多了，看久会眼花。”师傅没有反驳，只给他一张小卡片：在木雕、砖雕、石雕、陶塑和灰塑里，找出五条不同的鱼。',
      '第一条鱼藏在梁架故事里，第二条游过砖墙花纹，第三条变成石刻鳞片。阿巧越找越快，却把陶塑里的龙尾认成鱼。你提醒他靠近一点，看材料、工具痕迹和所在位置，而不是只看轮廓。',
      '最后一条鱼最小，藏在窗边一片叶子下面。阿巧发现同一个形象被不同工匠用木、砖、石和泥表达，每种材料都有自己的限制和声音。那些人物、花鸟与故事并非随意堆满建筑，而是在梁、屋脊和墙面上各司其职。',
      '离开前，师傅问第五条鱼在哪里。阿巧把空卡片还给他：“我找到了六条，第六条是别人还没看见的。”他开始在卡片背面画新的寻找题。陈家祠像一本不能快翻的立体图书，也终于有了下一位小读者。',
    ],
    annotations: [
      ReadingAnnotation(
        pinyin: 'Ā Qiǎo gēnzhe mùdiāo shīfu zǒujìn Chénjiācí, dì yí jù huà què shì: “Zhuāngshì tài duō le, kàn jiǔ huì yǎnhuā.” Shīfu méiyǒu fǎnbó, zhǐ gěi tā yì zhāng xiǎo kǎpiàn: zài mùdiāo, zhuāndiāo, shídiāo, táosù hé huīsù lǐ, zhǎochū wǔ tiáo bùtóng de yú.',
        vietnamese: 'A Xảo chê trang trí ở Trần Gia Từ quá nhiều. Sư phụ không tranh luận mà giao cậu tìm năm con cá khác nhau trong chạm gỗ, gạch, đá, gốm và phù điêu vữa.',
        english: 'Aqiao says the decoration at the Chen Clan Academy is overwhelming. His carving master simply challenges him to find five different fish across wood, brick, stone, ceramic, and plaster work.',
      ),
      ReadingAnnotation(
        pinyin: 'Dì yì tiáo yú cáng zài liángjià gùshi lǐ, dì èr tiáo yóuguò zhuānqiáng huāwén, dì sān tiáo biàn chéng shíkè línpiàn. Ā Qiǎo yuè zhǎo yuè kuài, què bǎ táosù lǐ de lóngwěi rèn chéng yú. Nǐ tíxǐng tā kàojìn yìdiǎn, kàn cáiliào, gōngjù hénjì hé suǒzài wèizhi, ér bú shì zhǐ kàn lúnkuò.',
        vietnamese: 'Cá ẩn trong xà, hoa văn gạch và vảy đá. A Xảo nhầm đuôi rồng gốm là cá, nên bạn nhắc cậu xem vật liệu, dấu dụng cụ và vị trí chứ không chỉ nhìn đường nét.',
        english: 'Fish appear in beams, brick patterns, and stone scales. When Aqiao mistakes a ceramic dragon tail for one, you remind him to read material, tool marks, and placement rather than outline alone.',
      ),
      ReadingAnnotation(
        pinyin: 'Zuìhòu yì tiáo yú zuì xiǎo, cáng zài chuāngbiān yí piàn yèzi xiàmiàn. Ā Qiǎo fāxiàn tóng yí gè xíngxiàng bèi bùtóng gōngjiàng yòng mù, zhuān, shí hé ní biǎodá, měi zhǒng cáiliào dōu yǒu zìjǐ de xiànzhì hé shēngyīn. Nàxiē rénwù, huāniǎo yǔ gùshi bìngfēi suíyì duīmǎn jiànzhù, ér shì zài liáng, wūjǐ hé qiángmiàn shàng gèsīqízhí.',
        vietnamese: 'Con cá cuối nằm dưới chiếc lá bên cửa. Cậu nhận ra cùng một hình tượng được thể hiện khác nhau bằng gỗ, gạch, đá và đất; mỗi vật liệu có giới hạn và tiếng nói riêng.',
        english: 'The last fish hides beneath a leaf by the window. Aqiao sees one image expressed through wood, brick, stone, and clay, each material with its own limits and voice.',
      ),
      ReadingAnnotation(
        pinyin: 'Líkāi qián, shīfu wèn dì wǔ tiáo yú zài nǎli. Ā Qiǎo bǎ kōng kǎpiàn huángěi tā: “Wǒ zhǎodào le liù tiáo, dì liù tiáo shì biérén hái méi kànjiàn de.” Tā kāishǐ zài kǎpiàn bèimiàn huà xīn de xúnzhǎotí. Chénjiācí xiàng yì běn bùnéng kuài fān de lìtǐ túshū, yě zhōngyú yǒu le xià yí wèi xiǎo dúzhě.',
        vietnamese: 'Khi sư phụ hỏi con cá thứ năm, A Xảo nói đã tìm sáu, trong đó con thứ sáu là thứ người khác chưa thấy. Cậu bắt đầu vẽ câu đố mới cho độc giả nhỏ tiếp theo.',
        english: 'When the master asks about the fifth fish, Aqiao says he found six, including one that others have not yet noticed. He begins drawing a new search card for the next young reader.',
      ),
    ],
    wonderQuestion: '为什么同一种图案用木、砖、石和陶来表现时会产生不同效果？',
    expressQuestion: '请选择一个建筑细节，用“远看……近看……”写出两层发现。',
  ),
};
