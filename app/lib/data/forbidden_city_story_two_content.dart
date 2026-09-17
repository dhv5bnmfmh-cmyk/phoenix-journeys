import 'package:pinyin/pinyin.dart';

import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'journey_story_identity.dart';

const String forbiddenCityStoryTwoTitle = '亮到这里，就够了';
const String forbiddenCityStoryTwoMemoryAnchor = '一束停在旧纸边缘的光';

class ForbiddenCityStoryTwoDna {
  const ForbiddenCityStoryTwoDna({
    required this.centralTheme,
    required this.centralQuestion,
    required this.narrativePremise,
    required this.coreConflict,
    required this.characterAGoal,
    required this.characterBGoal,
    required this.characterAMotivation,
    required this.characterBMotivation,
    required this.characterAFear,
    required this.characterBFear,
    required this.evidence,
    required this.historicalSubstrate,
    required this.turningPoint,
    required this.decision,
    required this.consequence,
    required this.relationshipChange,
    required this.beginningToEndingChange,
    required this.memoryAnchor,
    required this.whyForbiddenCity,
    required this.whyCannotMove,
  });

  final String centralTheme;
  final String centralQuestion;
  final String narrativePremise;
  final String coreConflict;
  final String characterAGoal;
  final String characterBGoal;
  final String characterAMotivation;
  final String characterBMotivation;
  final String characterAFear;
  final String characterBFear;
  final String evidence;
  final String historicalSubstrate;
  final String turningPoint;
  final String decision;
  final String consequence;
  final String relationshipChange;
  final String beginningToEndingChange;
  final String memoryAnchor;
  final String whyForbiddenCity;
  final String whyCannotMove;
}

const forbiddenCityStoryTwoDna = ForbiddenCityStoryTwoDna(
  centralTheme: '保护不是把创作关掉，而是让创作者知道自己的控制应该停在哪里。',
  centralQuestion: '为了让历史被看见，我们可以把承载历史的现场改变到什么程度？',
  narrativePremise: '闭馆后的武英殿里，一名第一次独立负责主镜头的摄影助理，为了拍清与宫廷刊书史有关的复制书页，想不断增加照明；负责预防性保护的同事要求她把画面欲望、现场条件与风险证据分开。',
  coreConflict: '白昀追求一个均匀、明亮、按时交付的主镜头；杜衡坚持任何临时变化都必须尊重武英殿作为木构宫殿遗产本体的边界。',
  characterAGoal: '白昀要在截止时间前交出足够漂亮的第一支独立主镜头。',
  characterBGoal: '杜衡要让拍摄在既定保护与安全条件内完成，同时不把自己变成只会说“不”的阻碍者。',
  characterAMotivation: '白昀想证明自己已经能独立承担复杂拍摄，而不是永远只做执行助理。',
  characterBMotivation: '杜衡相信预防性保护的价值在于风险发生之前让团队看见代价，而不是出事以后补救。',
  characterAFear: '白昀害怕第一次主镜头因为“不够亮”而被认为没有能力。',
  characterBFear: '杜衡害怕保护工作被团队理解成外部命令，最后大家只在他在场时遵守。',
  evidence: '原照明方案、线缆与人员路线、两版测试镜头、武英殿刊书资料、建筑修缮与重建资料。',
  historicalSubstrate: '武英殿与清代宫廷修书刊书活动、武英殿本传统、木构宫殿防火、武英殿损毁修缮与重建历史。',
  turningPoint: '白昀读到武英殿的重建资料，意识到自己想拍“书页上的过去”，却差点把“建筑经历过的过去”挤出画面。',
  decision: '她拒绝继续增加临时灯位，改用既有光、反光板、相机参数与更长的观看时间，并主动保留一条暗边。',
  consequence: '主镜头不再追求均匀明亮，白昀承担被制片人否定的创作风险，但最终得到一个同时看得见书页与武英殿的画面。',
  relationshipChange: '杜衡从“阻止加灯的人”退到监视器后面；白昀从等待许可的人变成能自己说明边界与代价的决策者。',
  beginningToEndingChange: '白昀从认为旧宫殿拖慢拍摄，转为把宫殿自身的历史与限度纳入作品。',
  memoryAnchor: forbiddenCityStoryTwoMemoryAnchor,
  whyForbiddenCity: '武英殿同时是与宫廷刊书史相关的具体历史空间，也是必须被保护的紫禁城宫殿建筑；故事的“被拍对象”和“保护对象”在同一地点重合。',
  whyCannotMove: '换到普通博物馆，复制书页仍能被拍，但“武英殿刊书史发生地 + 武英殿自身损毁重建记忆 + 木构宫殿保护边界”的因果链会消失，核心选择不再成立。',
);

String _storyTwoPinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

final List<List<String>> _storyParagraphsByLevel = <List<String>>[
  <String>[
      '闭馆后的武英殿比白天安静。二十五岁的摄影助理白昀把一页复制的清代书页放进镜头，想为短片拍出纸纹和墨色。监视器里，字能看清，纸边却沉在阴影里。她把备用灯往前挪了半步，说：“再亮一点，两分钟就够。”负责预防性保护的杜衡按住灯架，没有说“不许”，只问：“这盏灯原来在方案里吗？”',
      '白昀摇头。武英殿的木柱、门槛和暗红墙面都在镜头外缘。她原本只把它们当背景。杜衡让她先把灯退回标记线内，再看线缆有没有跨过通道。第一遍拍摄按原方案开始，书页安全留在光里，但右下角仍然暗。白昀盯着那一小块阴影，觉得自己的第一个独立镜头正在被一间旧宫殿拖慢。'
    ],
  <String>[
      '白昀说，备用灯是低温 LED，不会像旧灯那样发烫，而且只开两分钟。杜衡没有和她争“热不热”，而是把地上的胶带指给她看：电源、线缆和人员移动都按拍摄前的安全方案排过。多一盏灯，改变的不只是亮度，也改变现场怎样走、怎样撤、怎样照看武英殿这座木构宫殿。',
      '她把灯移到方案允许的位置，重新取景。画面亮了一点，纸纹还是不完整。杜衡建议先用反光板，不增加新的电源点。白昀照做，却忍不住说：“如果每一步都这么慢，今晚交不了片。”杜衡把反光板递给她：“慢不是目的。能说明为什么这样做，才是。”两人的分歧从一盏灯，变成了谁有资格决定“够亮”。'
    ],
  <String>[
      '等镜头重新布置时，白昀在拍摄资料里看到一行说明：清代武英殿曾与宫廷刊书、修书活动密切相关，“武英殿本”也因此成为重要的版本名称。她第一次意识到，眼前这页复制书页不是随便放进一座古建筑里，而是故意回到与刊书历史有关的空间。',
      '杜衡又给她看重建资料。武英殿的建筑历史里有损毁、修复和重建的痕迹。白昀抬头看梁架，再看监视器里那块阴影。她忽然有点不确定：如果为了把“刊书史”拍得更清楚，却把承载这段历史的建筑只当成可以无限加灯的摄影棚，镜头是不是已经把最重要的一层关系删掉了？'
    ],
  <String>[
      '制片人的消息在这时跳出来：“主镜头太灰，今晚必须给我一版更亮的。”白昀没有把手机给杜衡看。她回了一句“能解决”，然后从箱子里拿出第二只小灯。她怕的不是重拍，而是第一次负责主镜头就被认为没有能力。',
      '杜衡看见她在门槛边重新量距离，没有立刻阻止。他问：“你准备把它放哪儿？如果临时加灯，哪一项风险没有改变？”白昀答得很快：灯不热、功率不大、时间很短。说到线缆、人员通道和建筑表面时，她停住了。她第一次发现，“我觉得没事”并不是一个完整的拍摄依据。'
    ],
  <String>[
      '两人把原来的照明方案、相机位置和人员路线重新摊开。杜衡要求白昀把判断分开：什么是她为了画面想要的，什么是现场已经核定的条件，什么变化需要重新评估。白昀不喜欢这种拆法，因为每写下一项，她那句“只加两分钟”就显得更像愿望，而不是证据。',
      '她最终把第二只灯收回箱子，但代价马上出现：主镜头仍不够“干净”。制片人打来电话，问为什么不能把纸面照到完全均匀。白昀没有再说“马上解决”。她看着武英殿昏暗的木构空间，第一次回答：“我需要重新设计，不是继续加亮。”杜衡没替她解释，只把现场决定权留给她。'
    ],
  <String>[
      '白昀把复制页移到原有灯光能够稳定覆盖的位置，又让反光板把余光送回纸面。她调高相机感光度，缩小取景范围，再慢慢找回纸纹。画面终于有了层次，但书页右侧仍留着一条窄窄的暗边。那条暗边像一道没有被修掉的缝。',
      '她试了三次。每一次，只要把暗边完全消掉，就需要把光推得更强或把灯位改得更近。杜衡没有给答案，只提醒她：“你可以让相机适应现场，也可以让现场服从相机。两种选择都要付代价。”白昀把手从灯架上放下来。她开始把问题从“怎样变亮”改成“什么必须看清，什么可以留在暗处”。'
    ],
  <String>[
      '休息时，杜衡指着资料里的旧照片说，武英殿今天能继续被使用和观看，不代表它从未受过损毁。建筑本身经历的修缮与重建，也是历史的一部分。白昀忽然明白，自己一直想拍的是“书页上的过去”，却差点用最强的控制把“建筑经历过的过去”挤出画面。',
      '她重新看刚才的测试镜头：暗处仍能辨认柱脚和门槛，亮处只落在复制页与手指上。原来那条阴影并不是失败，它让观众知道这页纸处在一座真实的宫殿里。白昀把原来的镜头说明删掉，重新写：“先看见殿，再看见书。”这不是杜衡替她做的决定，而是她第一次主动给自己的画面设限。'
    ],
  <String>[
      '制片人再次催片。白昀这次把两版测试都发过去：一版纸面均匀明亮，却几乎看不见武英殿；另一版保留殿内暗部，书页只被一束侧光切开。她没有写哪一版“更安全”，只解释第二版为什么更接近这支短片真正要讲的关系。',
      '对方回了一句：“字不够亮，能不能再推一点？”白昀站在灯架旁，知道自己只要向前一步，就能得到更讨喜的画面。她没有动灯，而是改用更长的镜头停留和更稳的机位，让观众有时间适应暗部。她第一次为一个不那么漂亮、却更诚实的选择承担被否定的风险。'
    ],
  <String>[
      '正式拍摄开始。镜头先停在武英殿的暗红木构上，脚步声从远处收进来，随后复制书页被放进已有的光区。纸纹一点点浮出来，光只到纸边，没有追进后面的暗处。白昀听见制片人通过耳机说：“还是有点暗。”她没有解释，只让镜头多停了三秒。',
      '那三秒里，杜衡没有再站在灯旁，而是站到监视器后面。画面里的阴影没有吞掉信息，反而把书页、手和殿内空间分成了前后层次。杜衡说：“现在不是我在替你踩刹车。”白昀点头：“我知道。我是在决定哪里该停。”两人的关系从“保护人员阻止拍摄”变成了共同判断画面代价。'
    ],
  <String>[
      '最后一遍拍完时，武英殿外已经完全黑了。白昀把素材回放给制片人看：书页没有被照成一张平整的白纸，墨色从亮处进入暗处，后面的木构仍然留在画面里。制片人沉默了一会儿，只说：“用这版。标题别解释太多。”',
      '白昀收线时，把拍摄记录最后一栏写成：“亮到这里，就够了。”她没有把这句话当成保护规定，也没有把阴影浪漫化。它只是这次选择留下的证据：为了让武英殿的刊书历史被看见，她必须同时承认，承载历史的建筑也有自己的限度。杜衡把那张记录折好递回给她。门外的工作灯一盏盏熄掉，最后剩下的不是更亮的画面，而是她终于知道什么时候不再加光。'
    ],
];

final List<List<ReadingAnnotation>> _storyAnnotationsByLevel =
    <List<ReadingAnnotation>>[
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[0][0]),
        vietnamese: 'Sau giờ đóng cửa, điện Vũ Anh yên hơn ban ngày. Trợ lý quay phim 25 tuổi Bạch Quân đặt một trang sách thời Thanh bản sao vào khung hình để quay rõ thớ giấy và sắc mực. Trên màn hình, chữ nhìn rõ nhưng mép giấy chìm trong bóng. Cô đẩy chiếc đèn dự phòng lên nửa bước: “Sáng thêm một chút, hai phút là đủ.” Đỗ Hành, phụ trách bảo tồn phòng ngừa, giữ chân đèn lại và chỉ hỏi: “Đèn này có nằm trong phương án ban đầu không?”',
        english: 'After closing time, Wuying Hall is quieter than it is by day. Twenty-five-year-old camera assistant Bai Yun places a replica Qing-era book page in frame, hoping to capture the paper texture and ink. The text is readable on the monitor, but the edge of the page sinks into shadow. She moves a spare light half a step forward. “A little brighter. Two minutes is enough.” Du Heng, responsible for preventive conservation, steadies the stand and asks only, “Was this light in the approved plan?”',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[0][1]),
        vietnamese: 'Bạch Quân lắc đầu. Cột gỗ, ngưỡng cửa và tường đỏ sẫm của điện Vũ Anh nằm ở rìa khung hình; cô vốn chỉ coi chúng là phông nền. Đỗ Hành yêu cầu đưa đèn về trong vạch đánh dấu rồi kiểm tra dây điện có cắt ngang lối đi không. Lần quay đầu bắt đầu theo phương án cũ. Trang sách an toàn trong vùng sáng nhưng góc phải dưới vẫn tối. Bạch Quân nhìn chằm chằm vào mảng tối nhỏ, cảm thấy cảnh quay độc lập đầu tiên của mình đang bị một cung điện cũ làm chậm lại.',
        english: 'Bai Yun shakes her head. Wuying Hall’s timber columns, thresholds, and dark red walls sit at the edge of the frame; she had treated them as background. Du Heng asks her to return the light inside the marked line and check whether any cable crosses the circulation path. The first take starts under the original plan. The page stays safely in the lit zone, but its lower-right corner remains dark. Bai Yun stares at the small shadow and feels her first independent shot being slowed by an old palace hall.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[1][0]),
        vietnamese: 'Bạch Quân nói đèn dự phòng là LED nhiệt thấp, không nóng như đèn cũ và chỉ bật hai phút. Đỗ Hành không tranh luận về chuyện “nóng hay không” mà chỉ vào băng đánh dấu trên sàn: nguồn điện, dây điện và lối di chuyển của nhân viên đều đã được sắp xếp trong phương án an toàn trước buổi quay. Thêm một đèn không chỉ đổi độ sáng mà còn đổi cách đi lại, thoát ra và trông nom một cung điện kết cấu gỗ.',
        english: 'Bai Yun says the spare fixture is a low-heat LED, nothing like older hot lamps, and it would be on for only two minutes. Du Heng does not argue about whether it is “hot.” He points to the tape on the floor: power, cables, and crew movement were all arranged in the pre-shoot safety plan. One extra light changes not only brightness, but also how people move, exit, and protect a timber palace building.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[1][1]),
        vietnamese: 'Cô chuyển đèn đến vị trí được phép rồi quay lại. Hình sáng hơn chút nhưng thớ giấy vẫn chưa đầy đủ. Đỗ Hành đề nghị dùng tấm phản quang trước, không thêm điểm cấp điện mới. Bạch Quân làm theo nhưng vẫn nói: “Nếu bước nào cũng chậm thế này, tối nay sẽ không giao kịp.” Đỗ Hành đưa tấm phản quang cho cô: “Chậm không phải mục tiêu. Quan trọng là nói rõ vì sao phải làm vậy.” Bất đồng của họ từ một chiếc đèn chuyển thành câu hỏi ai có quyền quyết định thế nào là “đủ sáng”.',
        english: 'She shifts the light to an allowed position and reframes. The image is brighter, but the paper texture is still incomplete. Du Heng suggests using a reflector first, without adding another power point. Bai Yun does it, then says, “If every step is this slow, we won’t deliver tonight.” He hands her the reflector. “Slow is not the goal. Being able to explain why is.” Their disagreement moves from one lamp to the question of who gets to decide what counts as “bright enough.”',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[2][0]),
        vietnamese: 'Trong lúc sắp lại máy, Bạch Quân thấy một dòng trong tài liệu quay: thời Thanh, điện Vũ Anh gắn chặt với hoạt động biên soạn và in sách của cung đình; “bản điện Vũ Anh” vì thế trở thành một tên gọi quan trọng trong lịch sử phiên bản. Lần đầu cô hiểu trang sách bản sao này không phải được đặt tùy tiện vào một công trình cổ, mà được đưa trở lại không gian có liên hệ thật với lịch sử in sách.',
        english: 'While the camera is reset, Bai Yun notices a line in the research packet: in the Qing dynasty, Wuying Hall was closely connected with imperial book editing and printing, and “Wuying Hall editions” became an important term in bibliographic history. For the first time she sees that the replica page has not been placed in just any old building. It has been brought back to a space genuinely tied to the history of printing.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[2][1]),
        vietnamese: 'Đỗ Hành còn cho cô xem tư liệu trùng tu và tái dựng. Lịch sử kiến trúc điện Vũ Anh có dấu vết tổn hại, sửa chữa và dựng lại. Bạch Quân ngẩng nhìn kết cấu gỗ rồi nhìn mảng tối trên màn hình. Cô bỗng không chắc nữa: nếu để quay “lịch sử in sách” rõ hơn mà coi chính kiến trúc mang lịch sử đó như một phim trường có thể thêm đèn vô hạn, liệu ống kính đã xóa mất tầng quan trọng nhất hay chưa?',
        english: 'Du Heng also shows her reconstruction records. The architectural history of Wuying Hall carries traces of damage, repair, and rebuilding. Bai Yun looks up at the timber structure and then at the shadow on the monitor. She suddenly wonders: if she makes “printing history” clearer by treating the building that carries that history as a studio where lights can be added without limit, has the camera already removed the most important relationship?',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[3][0]),
        vietnamese: 'Tin nhắn của nhà sản xuất xuất hiện: “Cảnh chính quá xám, tối nay phải có một bản sáng hơn.” Bạch Quân không cho Đỗ Hành xem điện thoại. Cô trả lời “sẽ xử lý được”, rồi lấy chiếc đèn nhỏ thứ hai khỏi hộp. Điều cô sợ không phải quay lại, mà là ngay lần đầu chịu trách nhiệm cảnh chính đã bị xem là không đủ năng lực.',
        english: 'A message from the producer appears: “The hero shot is too gray. I need a brighter version tonight.” Bai Yun does not show the phone to Du Heng. She replies, “I can fix it,” then takes a second small light from the case. What she fears is not a reshoot, but being judged incapable on the first shot she has been trusted to lead.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[3][1]),
        vietnamese: 'Đỗ Hành thấy cô đo lại khoảng cách bên ngưỡng cửa nhưng không lập tức ngăn. Anh hỏi: “Cô định đặt nó ở đâu? Nếu thêm đèn tạm thời, rủi ro nào là không thay đổi?” Bạch Quân trả lời rất nhanh: đèn không nóng, công suất nhỏ, thời gian ngắn. Nhưng khi nói đến dây điện, lối đi và bề mặt kiến trúc, cô dừng lại. Lần đầu cô nhận ra “tôi thấy không sao” không phải một căn cứ quay phim hoàn chỉnh.',
        english: 'Du Heng sees her measuring again beside the threshold and does not stop her immediately. He asks, “Where will you put it? If you add a light temporarily, which risks do not change?” Bai Yun answers quickly: the fixture is cool, the power is low, the time is short. When she reaches cables, circulation, and architectural surfaces, she stops. For the first time, “I think it’s fine” no longer sounds like a complete basis for a production decision.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[4][0]),
        vietnamese: 'Hai người trải lại phương án chiếu sáng, vị trí máy và tuyến đi của nhân viên. Đỗ Hành yêu cầu Bạch Quân tách phán đoán thành ba phần: điều cô muốn vì hình ảnh, điều kiện hiện trường đã được phê duyệt, và thay đổi nào cần đánh giá lại. Bạch Quân không thích cách tách này, vì mỗi mục được viết ra khiến câu “chỉ thêm hai phút” của cô giống một mong muốn hơn là bằng chứng.',
        english: 'They spread out the original lighting plan, camera positions, and crew routes. Du Heng asks Bai Yun to separate three things: what she wants for the image, what conditions have already been approved on site, and what changes require fresh assessment. She dislikes the exercise because with every item she writes down, “only two minutes” looks more like a wish than evidence.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[4][1]),
        vietnamese: 'Cuối cùng cô cất chiếc đèn thứ hai vào hộp, nhưng cái giá xuất hiện ngay: cảnh chính vẫn không đủ “sạch”. Nhà sản xuất gọi hỏi tại sao không thể chiếu mặt giấy sáng đều hoàn toàn. Bạch Quân không còn nói “sẽ giải quyết ngay”. Cô nhìn không gian gỗ tối của điện Vũ Anh và lần đầu đáp: “Tôi cần thiết kế lại, không phải tiếp tục tăng sáng.” Đỗ Hành không giải thích thay cô, mà để quyền quyết định tại hiện trường cho cô.',
        english: 'She finally puts the second light back in its case, and the cost appears immediately: the hero shot still does not look “clean” enough. The producer calls and asks why the page cannot be lit completely evenly. Bai Yun no longer says, “I’ll fix it right away.” Looking into the dim timber space of Wuying Hall, she answers for the first time, “I need to redesign the shot, not keep adding light.” Du Heng does not explain for her. He leaves the on-site decision with her.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[5][0]),
        vietnamese: 'Bạch Quân chuyển trang bản sao đến vị trí được ánh sáng hiện có bao phủ ổn định, rồi dùng tấm phản quang đưa phần ánh sáng còn lại trở về mặt giấy. Cô tăng độ nhạy máy, thu hẹp khung hình và dần tìm lại thớ giấy. Hình ảnh cuối cùng có chiều sâu, nhưng bên phải trang vẫn còn một dải tối hẹp, giống một đường nối không bị xóa.',
        english: 'Bai Yun moves the replica page into a position already covered by the approved light, then uses a reflector to return spill light to the paper. She raises the camera sensitivity, tightens the frame, and slowly recovers the texture. The image finally has depth, but a narrow dark edge remains on the right side of the page, like a seam that has not been erased.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[5][1]),
        vietnamese: 'Cô thử ba lần. Mỗi lần muốn xóa hẳn dải tối, cô đều phải tăng sáng hoặc đưa đèn gần hơn. Đỗ Hành không cho đáp án, chỉ nhắc: “Cô có thể để máy thích nghi với hiện trường, hoặc bắt hiện trường phục tùng máy. Cả hai đều có giá.” Bạch Quân buông tay khỏi chân đèn. Cô bắt đầu đổi câu hỏi từ “làm sao sáng hơn” thành “điều gì phải nhìn rõ, điều gì có thể ở trong tối”.',
        english: 'She tries three times. Every time she eliminates the dark edge completely, she has to push the light harder or move it closer. Du Heng gives no answer. He only says, “You can let the camera adapt to the site, or make the site obey the camera. Both choices have a cost.” Bai Yun takes her hand off the stand. Her question begins to change from “How do I make it brighter?” to “What must be visible, and what can remain in shadow?”',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[6][0]),
        vietnamese: 'Lúc nghỉ, Đỗ Hành chỉ vào ảnh cũ trong tư liệu và nói việc điện Vũ Anh hôm nay vẫn được sử dụng, tham quan không có nghĩa nó chưa từng bị tổn hại. Những lần sửa chữa và tái dựng cũng là một phần lịch sử. Bạch Quân bỗng hiểu rằng mình luôn muốn quay “quá khứ trên trang sách”, nhưng suýt dùng sự kiểm soát mạnh nhất để đẩy “quá khứ mà kiến trúc đã trải qua” ra khỏi khung hình.',
        english: 'During the break, Du Heng points to an old photograph in the records and says that the fact Wuying Hall can still be used and seen today does not mean it was never damaged. Repair and rebuilding are also part of its history. Bai Yun suddenly understands that she has been trying to film “the past on the page,” while nearly using total visual control to push “the past experienced by the building” out of frame.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[6][1]),
        vietnamese: 'Cô xem lại cảnh thử: trong tối vẫn nhận ra chân cột và ngưỡng cửa, còn vùng sáng chỉ rơi lên trang sách và các ngón tay. Mảng tối không còn là thất bại; nó cho khán giả biết trang giấy này đang ở trong một cung điện có thật. Bạch Quân xóa mô tả cảnh cũ và viết lại: “Nhìn thấy điện trước, rồi mới nhìn thấy sách.” Đây không phải quyết định do Đỗ Hành làm thay, mà là lần đầu cô chủ động đặt giới hạn cho chính hình ảnh của mình.',
        english: 'She watches the test again. The column base and threshold remain legible in shadow, while the light falls only on the replica page and a hand. The shadow is no longer a failure; it tells the viewer that this page sits inside a real palace hall. Bai Yun deletes her original shot note and writes: “See the hall first, then the book.” It is not a decision Du Heng makes for her. It is the first limit she chooses for her own image.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[7][0]),
        vietnamese: 'Nhà sản xuất lại thúc giục. Lần này Bạch Quân gửi cả hai bản thử: một bản mặt giấy sáng đều nhưng gần như không còn thấy điện Vũ Anh; bản kia giữ phần tối của điện, trang sách chỉ được cắt bởi một luồng sáng bên. Cô không viết bản nào “an toàn hơn”, mà giải thích tại sao bản thứ hai gần với mối quan hệ mà phim muốn kể hơn.',
        english: 'The producer pushes again. This time Bai Yun sends both tests: one with an evenly bright page where Wuying Hall almost disappears, and another that keeps the hall’s dark zones while a single sidelight cuts across the page. She does not label one “safer.” She explains why the second is closer to the relationship the film is actually trying to tell.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[7][1]),
        vietnamese: 'Phản hồi đến: “Chữ vẫn tối, đẩy thêm chút nữa được không?” Bạch Quân đứng cạnh chân đèn, biết chỉ cần tiến một bước sẽ có hình ảnh dễ thích hơn. Cô không dịch đèn, mà dùng thời lượng khung hình dài hơn và vị trí máy ổn định hơn để người xem có thời gian thích nghi với phần tối. Lần đầu cô tự chịu rủi ro bị từ chối vì một lựa chọn kém bóng bẩy nhưng trung thực hơn.',
        english: 'The reply comes back: “The text is still dark. Can you push it a little more?” Bai Yun stands beside the light stand, knowing that one step forward would give her a more immediately attractive image. She does not move the light. Instead she extends the shot and stabilizes the camera so the viewer has time to adjust to the darker areas. For the first time, she accepts the risk of rejection for a choice that is less polished but more honest.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[8][0]),
        vietnamese: 'Buổi quay chính thức bắt đầu. Máy dừng trước kết cấu gỗ đỏ sẫm của điện Vũ Anh, thu tiếng bước chân từ xa, rồi trang sách bản sao được đưa vào vùng sáng sẵn có. Thớ giấy dần hiện lên; ánh sáng chỉ dừng ở mép giấy, không đuổi sâu vào bóng tối phía sau. Qua tai nghe, Bạch Quân nghe nhà sản xuất nói: “Vẫn hơi tối.” Cô không giải thích, chỉ để máy dừng thêm ba giây.',
        english: 'The final shoot begins. The camera first rests on the dark red timber structure of Wuying Hall, taking in distant footsteps, then the replica page enters the existing pool of light. The paper texture slowly appears. The light stops at the page edge and does not chase into the darkness behind it. Through the headset Bai Yun hears the producer say, “Still a little dark.” She does not explain. She simply holds the shot three seconds longer.',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[8][1]),
        vietnamese: 'Trong ba giây ấy, Đỗ Hành không đứng cạnh đèn nữa mà đứng sau màn hình. Bóng tối không nuốt mất thông tin, ngược lại chia trang sách, bàn tay và không gian điện thành các lớp trước sau. Đỗ Hành nói: “Bây giờ không phải tôi đang phanh cô nữa.” Bạch Quân gật đầu: “Tôi biết. Tôi đang quyết định chỗ nào phải dừng.” Quan hệ của họ chuyển từ “người bảo tồn ngăn quay” sang cùng nhau đánh giá cái giá của hình ảnh.',
        english: 'In those three seconds, Du Heng is no longer standing beside the lamp. He stands behind the monitor. The shadows do not swallow information; they separate page, hand, and hall into layers. Du Heng says, “I’m not the one braking you now.” Bai Yun nods. “I know. I’m deciding where to stop.” Their relationship has changed from “conservator blocks the shoot” to two people judging the cost of an image together.',
      )
    ],
  <ReadingAnnotation>[
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[9][0]),
        vietnamese: 'Khi lần quay cuối kết thúc, bên ngoài điện Vũ Anh đã tối hẳn. Bạch Quân phát lại tư liệu cho nhà sản xuất: trang sách không bị chiếu thành một tờ giấy trắng phẳng; sắc mực đi từ sáng vào tối, và kết cấu gỗ phía sau vẫn ở trong hình. Nhà sản xuất im lặng một lúc rồi nói: “Dùng bản này. Tiêu đề đừng giải thích nhiều.”',
        english: 'When the last take ends, it is completely dark outside Wuying Hall. Bai Yun plays the footage for the producer: the page has not been flattened into a sheet of white; the ink moves from light into shadow, and the timber structure behind it remains in frame. The producer is silent for a moment, then says only, “Use this version. Don’t over-explain the title.”',
      ),
      ReadingAnnotation(
        pinyin: _storyTwoPinyin(_storyParagraphsByLevel[9][1]),
        vietnamese: 'Khi thu dây, Bạch Quân viết vào dòng cuối nhật ký quay: “Sáng đến đây là đủ.” Cô không coi câu đó là quy định bảo tồn, cũng không lãng mạn hóa bóng tối. Nó chỉ là bằng chứng cho lựa chọn lần này: để lịch sử in sách của điện Vũ Anh được nhìn thấy, cô phải đồng thời thừa nhận kiến trúc mang lịch sử cũng có giới hạn riêng. Đỗ Hành gấp tờ ghi chép và đưa lại cho cô. Những đèn công việc ngoài cửa lần lượt tắt; thứ còn lại không phải một hình ảnh sáng hơn, mà là việc cô cuối cùng biết khi nào không thêm sáng nữa.',
        english: 'While coiling cables, Bai Yun writes in the final line of the shot log: “Bright to here is enough.” She does not treat it as a conservation rule, and she does not romanticize darkness. It is simply evidence of the choice she made: to make Wuying Hall’s printing history visible, she must also accept that the building carrying that history has limits of its own. Du Heng folds the note and returns it to her. Work lights outside the door go out one by one. What remains is not a brighter image, but her new ability to know when not to add more light.',
      )
    ],
];

final Map<String, WordEntry> _storyTwoWordBank = <String, WordEntry>{
    '补光': WordEntry(
      word: '补光',
      pinyin: 'bǔguāng',
      partOfSpeech: '动词',
      simpleChinese: '在原有光线之外增加或反射光线，让画面更清楚。',
      translation: 'Bổ sung ánh sáng hoặc phản xạ ánh sáng để hình ảnh rõ hơn.',
      englishDefinition: 'to add or redirect light to improve a shot',
      symbol: '💡',
      examples: <WordExample>[
        WordExample(
          chinese: '白昀想给书页补光，但先检查了原来的照明方案。',
          pinyin: _storyTwoPinyin('白昀想给书页补光，但先检查了原来的照明方案。'),
          vietnamese: 'Bạch Quân muốn bổ sung ánh sáng cho trang sách nhưng trước hết kiểm tra phương án chiếu sáng ban đầu.',
          english: 'Bai Yun wants to add fill light to the page, but first checks the original lighting plan.',
        ),
        WordExample(
          chinese: '反光板也能补光，不一定要再增加一盏灯。',
          pinyin: _storyTwoPinyin('反光板也能补光，不一定要再增加一盏灯。'),
          vietnamese: 'Tấm phản quang cũng có thể bổ sung ánh sáng, không nhất thiết phải thêm một đèn mới.',
          english: 'A reflector can provide fill light without adding another lamp.',
        ),
        WordExample(
          chinese: '最后一遍拍摄没有继续补光，暗处被保留了下来。',
          pinyin: _storyTwoPinyin('最后一遍拍摄没有继续补光，暗处被保留了下来。'),
          vietnamese: 'Ở lần quay cuối, họ không tiếp tục tăng sáng và giữ lại vùng tối.',
          english: 'In the final take they stop adding fill light and keep the darker areas.',
        )
      ],
    ),
    '方案': WordEntry(
      word: '方案',
      pinyin: 'fāng\'àn',
      partOfSpeech: '名词',
      simpleChinese: '为完成一项工作事先确定的方法和安排。',
      translation: 'Phương án hoặc kế hoạch được xác định trước để hoàn thành công việc.',
      englishDefinition: 'a planned method or arrangement',
      symbol: '📋',
      examples: <WordExample>[
        WordExample(chinese: '这盏备用灯不在拍摄方案里。', pinyin: _storyTwoPinyin('这盏备用灯不在拍摄方案里。'), vietnamese: 'Chiếc đèn dự phòng này không nằm trong phương án quay.', english: 'The spare light is not part of the shooting plan.'),
        WordExample(chinese: '两人把照明方案和人员路线重新摊开检查。', pinyin: _storyTwoPinyin('两人把照明方案和人员路线重新摊开检查。'), vietnamese: 'Hai người trải lại phương án chiếu sáng và tuyến di chuyển để kiểm tra.', english: 'They spread out the lighting plan and crew route to review them.'),
        WordExample(chinese: '新的镜头设计没有改变安全方案，只改变了相机的选择。', pinyin: _storyTwoPinyin('新的镜头设计没有改变安全方案，只改变了相机的选择。'), vietnamese: 'Thiết kế cảnh quay mới không thay đổi phương án an toàn, chỉ thay đổi lựa chọn của máy quay.', english: 'The revised shot does not change the safety plan, only the camera choices.'),
      ],
    ),
    '层次': WordEntry(
      word: '层次',
      pinyin: 'céngcì',
      partOfSpeech: '名词',
      simpleChinese: '画面或事物中前后、轻重、明暗等不同关系。',
      translation: 'Các lớp hoặc quan hệ trước sau, sáng tối trong hình ảnh hay sự việc.',
      englishDefinition: 'layers or depth within an image or idea',
      symbol: '🪜',
      examples: <WordExample>[
        WordExample(chinese: '书页、手和殿内空间在画面里形成了前后层次。', pinyin: _storyTwoPinyin('书页、手和殿内空间在画面里形成了前后层次。'), vietnamese: 'Trang sách, bàn tay và không gian trong điện tạo thành các lớp trước sau trong hình.', english: 'The page, hand, and hall form foreground and background layers.'),
        WordExample(chinese: '完全均匀的亮度反而削弱了画面的层次。', pinyin: _storyTwoPinyin('完全均匀的亮度反而削弱了画面的层次。'), vietnamese: 'Độ sáng hoàn toàn đồng đều lại làm giảm chiều sâu của hình ảnh.', english: 'Perfectly even brightness actually weakens the image\'s depth.'),
        WordExample(chinese: '白昀最后保留了明暗层次，而不是把所有地方照得一样亮。', pinyin: _storyTwoPinyin('白昀最后保留了明暗层次，而不是把所有地方照得一样亮。'), vietnamese: 'Cuối cùng Bạch Quân giữ lại các lớp sáng tối thay vì chiếu mọi nơi sáng như nhau.', english: 'Bai Yun keeps light-dark layers instead of making everything equally bright.'),
      ],
    ),
    '线缆': WordEntry(
      word: '线缆',
      pinyin: 'xiànlǎn',
      partOfSpeech: '名词',
      simpleChinese: '传输电力或信号的电线和电缆。',
      translation: 'Dây điện và cáp dùng để truyền điện hoặc tín hiệu.',
      englishDefinition: 'electrical or signal cables',
      symbol: '🔌',
      examples: <WordExample>[
        WordExample(chinese: '新增一盏灯会让现场多出一组线缆。', pinyin: _storyTwoPinyin('新增一盏灯会让现场多出一组线缆。'), vietnamese: 'Thêm một đèn sẽ tạo thêm một bộ dây cáp tại hiện trường.', english: 'Adding a lamp introduces another set of cables on site.'),
        WordExample(chinese: '杜衡先检查线缆有没有跨过人员通道。', pinyin: _storyTwoPinyin('杜衡先检查线缆有没有跨过人员通道。'), vietnamese: 'Đỗ Hành kiểm tra trước xem dây cáp có cắt ngang lối đi của nhân viên không.', english: 'Du Heng first checks whether any cables cross the crew path.'),
        WordExample(chinese: '收工时，白昀把线缆一圈圈收回箱子。', pinyin: _storyTwoPinyin('收工时，白昀把线缆一圈圈收回箱子。'), vietnamese: 'Khi kết thúc, Bạch Quân cuộn dây cáp và cất lại vào hộp.', english: 'At wrap, Bai Yun coils the cables back into the case.'),
      ],
    ),
    '木构': WordEntry(
      word: '木构',
      pinyin: 'mùgòu',
      partOfSpeech: '名词',
      simpleChinese: '以木材作为主要结构材料的建筑或构造。',
      translation: 'Kết cấu kiến trúc chủ yếu làm bằng gỗ.',
      englishDefinition: 'timber construction or timber structure',
      symbol: '🪵',
      examples: <WordExample>[
        WordExample(chinese: '武英殿的木构不是拍摄背景，而是需要保护的建筑本体。', pinyin: _storyTwoPinyin('武英殿的木构不是拍摄背景，而是需要保护的建筑本体。'), vietnamese: 'Kết cấu gỗ của điện Vũ Anh không chỉ là phông nền mà là chính công trình cần được bảo vệ.', english: 'Wuying Hall\'s timber structure is not mere background but part of the heritage itself.'),
        WordExample(chinese: '镜头先停在暗红色的木构上，再让书页进入光区。', pinyin: _storyTwoPinyin('镜头先停在暗红色的木构上，再让书页进入光区。'), vietnamese: 'Máy quay dừng trước kết cấu gỗ đỏ sẫm rồi mới để trang sách đi vào vùng sáng.', english: 'The shot begins on the dark red timber structure before the page enters the light.'),
        WordExample(chinese: '木构空间让白昀重新考虑灯位和人员路线。', pinyin: _storyTwoPinyin('木构空间让白昀重新考虑灯位和人员路线。'), vietnamese: 'Không gian kết cấu gỗ khiến Bạch Quân phải xem lại vị trí đèn và tuyến di chuyển.', english: 'The timber setting makes Bai Yun reconsider light placement and crew circulation.'),
      ],
    ),
    '反光板': WordEntry(
      word: '反光板',
      pinyin: 'fǎnguāngbǎn',
      partOfSpeech: '名词',
      simpleChinese: '把已有光线反射到需要位置的摄影工具。',
      translation: 'Tấm phản quang dùng để đưa ánh sáng có sẵn đến vị trí cần thiết.',
      englishDefinition: 'a reflector used to redirect existing light',
      symbol: '🪞',
      examples: <WordExample>[
        WordExample(chinese: '杜衡建议先用反光板，不增加新的电源点。', pinyin: _storyTwoPinyin('杜衡建议先用反光板，不增加新的电源点。'), vietnamese: 'Đỗ Hành đề nghị dùng tấm phản quang trước, không thêm điểm cấp điện mới.', english: 'Du Heng suggests a reflector before adding another powered light.'),
        WordExample(chinese: '白昀转动反光板，让余光落到纸面右侧。', pinyin: _storyTwoPinyin('白昀转动反光板，让余光落到纸面右侧。'), vietnamese: 'Bạch Quân xoay tấm phản quang để ánh sáng còn lại rơi vào bên phải trang giấy.', english: 'Bai Yun turns the reflector to send spill light to the right side of the page.'),
        WordExample(chinese: '反光板没有消灭所有阴影，却让纸纹更清楚。', pinyin: _storyTwoPinyin('反光板没有消灭所有阴影，却让纸纹更清楚。'), vietnamese: 'Tấm phản quang không xóa hết bóng tối nhưng làm thớ giấy rõ hơn.', english: 'The reflector does not erase every shadow, but it makes the paper texture clearer.'),
      ],
    ),
    '刊书': WordEntry(
      word: '刊书',
      pinyin: 'kānshū',
      partOfSpeech: '动词',
      simpleChinese: '编校、刻印并出版书籍。',
      translation: 'Biên soạn, khắc in và xuất bản sách.',
      englishDefinition: 'to edit, print, and publish books',
      symbol: '📚',
      examples: <WordExample>[
        WordExample(chinese: '清代武英殿与宫廷刊书活动关系密切。', pinyin: _storyTwoPinyin('清代武英殿与宫廷刊书活动关系密切。'), vietnamese: 'Thời Thanh, điện Vũ Anh có quan hệ chặt chẽ với hoạt động in sách của cung đình.', english: 'In the Qing dynasty, Wuying Hall was closely tied to imperial book production.'),
        WordExample(chinese: '短片要讲刊书史，却不能把宫殿本身拍成无关背景。', pinyin: _storyTwoPinyin('短片要讲刊书史，却不能把宫殿本身拍成无关背景。'), vietnamese: 'Bộ phim muốn kể lịch sử in sách nhưng không thể biến chính cung điện thành phông nền vô nghĩa.', english: 'The film is about printing history, but the hall itself cannot become irrelevant background.'),
        WordExample(chinese: '白昀最后让刊书的书页和武英殿同时留在画面里。', pinyin: _storyTwoPinyin('白昀最后让刊书的书页和武英殿同时留在画面里。'), vietnamese: 'Cuối cùng Bạch Quân giữ cả trang sách và điện Vũ Anh trong cùng một khung hình.', english: 'Bai Yun ultimately keeps both the printed page and Wuying Hall in the frame.'),
      ],
    ),
    '版本': WordEntry(
      word: '版本',
      pinyin: 'bǎnběn',
      partOfSpeech: '名词',
      simpleChinese: '同一种书在不同刻印、编辑或流传过程中形成的具体形式。',
      translation: 'Phiên bản cụ thể của một cuốn sách do khác nhau về khắc in, biên tập hoặc lưu truyền.',
      englishDefinition: 'a particular edition or version of a text',
      symbol: '📖',
      examples: <WordExample>[
        WordExample(chinese: '“武英殿本”是与宫廷刊刻历史有关的版本名称。', pinyin: _storyTwoPinyin('“武英殿本”是与宫廷刊刻历史有关的版本名称。'), vietnamese: '“Bản điện Vũ Anh” là tên một loại phiên bản gắn với lịch sử khắc in cung đình.', english: '“Wuying Hall edition” is a bibliographic term tied to imperial printing history.'),
        WordExample(chinese: '白昀拍的是复制页，不把它误说成原始版本。', pinyin: _storyTwoPinyin('白昀拍的是复制页，不把它误说成原始版本。'), vietnamese: 'Bạch Quân quay trang bản sao và không mô tả nhầm nó là phiên bản gốc.', english: 'Bai Yun films a replica page and does not misrepresent it as an original edition.'),
        WordExample(chinese: '理解版本差异以后，她不再只盯着纸面的清晰度。', pinyin: _storyTwoPinyin('理解版本差异以后，她不再只盯着纸面的清晰度。'), vietnamese: 'Sau khi hiểu sự khác biệt giữa các phiên bản, cô không còn chỉ nhìn vào độ rõ của mặt giấy.', english: 'After understanding editions, she stops focusing only on surface clarity.'),
      ],
    ),
    '重建': WordEntry(
      word: '重建',
      pinyin: 'chóngjiàn',
      partOfSpeech: '动词',
      simpleChinese: '在损毁之后重新建造。',
      translation: 'Xây dựng lại sau khi công trình bị hư hại.',
      englishDefinition: 'to rebuild after damage or destruction',
      symbol: '🏗️',
      examples: <WordExample>[
        WordExample(chinese: '武英殿的历史资料里有修缮与重建的记录。', pinyin: _storyTwoPinyin('武英殿的历史资料里有修缮与重建的记录。'), vietnamese: 'Tư liệu lịch sử của điện Vũ Anh có ghi chép về tu bổ và tái dựng.', english: 'Records of Wuying Hall include repair and rebuilding.'),
        WordExample(chinese: '重建并不让过去的损失消失，反而留下新的历史层。', pinyin: _storyTwoPinyin('重建并不让过去的损失消失，反而留下新的历史层。'), vietnamese: 'Tái dựng không làm mất đi tổn thất trong quá khứ mà tạo thêm một lớp lịch sử mới.', english: 'Rebuilding does not erase past loss; it adds another historical layer.'),
        WordExample(chinese: '白昀从重建资料里意识到，建筑本身也是故事证据。', pinyin: _storyTwoPinyin('白昀从重建资料里意识到，建筑本身也是故事证据。'), vietnamese: 'Từ tư liệu tái dựng, Bạch Quân nhận ra chính kiến trúc cũng là bằng chứng của câu chuyện.', english: 'The rebuilding records help Bai Yun see the building itself as evidence.'),
      ],
    ),
    '风险': WordEntry(
      word: '风险',
      pinyin: 'fēngxiǎn',
      partOfSpeech: '名词',
      simpleChinese: '可能造成损害或不良后果的因素。',
      translation: 'Yếu tố có thể gây thiệt hại hoặc hậu quả không tốt.',
      englishDefinition: 'a factor that may cause harm or loss',
      symbol: '⚠️',
      examples: <WordExample>[
        WordExample(chinese: '临时加灯会改变现场的风险条件。', pinyin: _storyTwoPinyin('临时加灯会改变现场的风险条件。'), vietnamese: 'Thêm đèn tạm thời sẽ làm thay đổi điều kiện rủi ro tại hiện trường.', english: 'Adding a temporary light changes the site\'s risk conditions.'),
        WordExample(chinese: '杜衡要求她把亮度需求和风险判断分开。', pinyin: _storyTwoPinyin('杜衡要求她把亮度需求和风险判断分开。'), vietnamese: 'Đỗ Hành yêu cầu cô tách nhu cầu về độ sáng khỏi đánh giá rủi ro.', english: 'Du Heng asks her to separate visual desire from risk assessment.'),
        WordExample(chinese: '白昀最后承担的是被否定的创作风险，而不是把风险转嫁给建筑。', pinyin: _storyTwoPinyin('白昀最后承担的是被否定的创作风险，而不是把风险转嫁给建筑。'), vietnamese: 'Cuối cùng Bạch Quân chấp nhận rủi ro sáng tạo bị từ chối thay vì đẩy rủi ro sang công trình.', english: 'Bai Yun accepts creative rejection rather than shifting risk onto the building.'),
      ],
    ),
    '依据': WordEntry(
      word: '依据',
      pinyin: 'yījù',
      partOfSpeech: '名词',
      simpleChinese: '用来支持判断或决定的事实、规则或证据。',
      translation: 'Sự thật, quy tắc hoặc bằng chứng dùng để hỗ trợ một phán đoán hay quyết định.',
      englishDefinition: 'grounds or evidence supporting a decision',
      symbol: '🧾',
      examples: <WordExample>[
        WordExample(chinese: '“我觉得没事”不能成为增加灯位的完整依据。', pinyin: _storyTwoPinyin('“我觉得没事”不能成为增加灯位的完整依据。'), vietnamese: '“Tôi thấy không sao” không thể là căn cứ đầy đủ để thêm vị trí đèn.', english: '“I think it\'s fine” is not sufficient grounds for adding a light.'),
        WordExample(chinese: '她开始把方案、现场条件和历史资料都当作判断依据。', pinyin: _storyTwoPinyin('她开始把方案、现场条件和历史资料都当作判断依据。'), vietnamese: 'Cô bắt đầu dùng phương án, điều kiện hiện trường và tư liệu lịch sử làm căn cứ phán đoán.', english: 'She begins using the plan, site conditions, and historical records as evidence.'),
        WordExample(chinese: '最终的镜头选择有明确依据，而不是服从谁的身份。', pinyin: _storyTwoPinyin('最终的镜头选择有明确依据，而不是服从谁的身份。'), vietnamese: 'Lựa chọn cảnh quay cuối có căn cứ rõ ràng, không phải phục tùng địa vị của ai.', english: 'The final shot has clear grounds rather than following someone\'s authority.'),
      ],
    ),
    '评估': WordEntry(
      word: '评估',
      pinyin: 'pínggū',
      partOfSpeech: '动词',
      simpleChinese: '根据事实和条件判断影响、价值或风险。',
      translation: 'Đánh giá ảnh hưởng, giá trị hoặc rủi ro dựa trên sự thật và điều kiện.',
      englishDefinition: 'to assess impact, value, or risk',
      symbol: '🧠',
      examples: <WordExample>[
        WordExample(chinese: '临时改变灯位之前，需要重新评估现场条件。', pinyin: _storyTwoPinyin('临时改变灯位之前，需要重新评估现场条件。'), vietnamese: 'Trước khi thay đổi vị trí đèn tạm thời, cần đánh giá lại điều kiện hiện trường.', english: 'A temporary lighting change requires reassessing site conditions.'),
        WordExample(chinese: '白昀开始评估的不只是画面，也包括选择造成的后果。', pinyin: _storyTwoPinyin('白昀开始评估的不只是画面，也包括选择造成的后果。'), vietnamese: 'Bạch Quân bắt đầu đánh giá không chỉ hình ảnh mà cả hậu quả của lựa chọn.', english: 'Bai Yun starts assessing not only the image but also the consequences of her choice.'),
        WordExample(chinese: '两人最后一起评估阴影有没有遮住关键信息。', pinyin: _storyTwoPinyin('两人最后一起评估阴影有没有遮住关键信息。'), vietnamese: 'Cuối cùng hai người cùng đánh giá xem bóng tối có che mất thông tin quan trọng hay không.', english: 'They ultimately assess together whether the shadows hide essential information.'),
      ],
    ),
    '代价': WordEntry(
      word: '代价',
      pinyin: 'dàijià',
      partOfSpeech: '名词',
      simpleChinese: '为了得到某种结果而必须承担的损失或放弃。',
      translation: 'Điều phải chịu hoặc từ bỏ để đạt được một kết quả.',
      englishDefinition: 'a cost, sacrifice, or trade-off',
      symbol: '⚖️',
      examples: <WordExample>[
        WordExample(chinese: '不加第二盏灯的代价，是主镜头不再完全均匀。', pinyin: _storyTwoPinyin('不加第二盏灯的代价，是主镜头不再完全均匀。'), vietnamese: 'Cái giá của việc không thêm đèn thứ hai là cảnh chính không còn sáng hoàn toàn đồng đều.', english: 'The cost of not adding the second light is a less uniformly lit hero shot.'),
        WordExample(chinese: '更漂亮的画面也可能有现场代价。', pinyin: _storyTwoPinyin('更漂亮的画面也可能有现场代价。'), vietnamese: 'Một hình ảnh đẹp hơn cũng có thể tạo ra cái giá tại hiện trường.', english: 'A prettier image can carry on-site costs.'),
        WordExample(chinese: '白昀最后选择自己承担被否定的代价。', pinyin: _storyTwoPinyin('白昀最后选择自己承担被否定的代价。'), vietnamese: 'Cuối cùng Bạch Quân chọn tự chịu cái giá có thể bị từ chối.', english: 'Bai Yun ultimately chooses to bear the cost of possible rejection herself.'),
      ],
    ),
    '承载': WordEntry(
      word: '承载',
      pinyin: 'chéngzài',
      partOfSpeech: '动词',
      simpleChinese: '承担并保存某种内容、意义或重量。',
      translation: 'Mang, chứa và gìn giữ một nội dung, ý nghĩa hoặc trọng lượng nào đó.',
      englishDefinition: 'to carry, hold, or embody',
      symbol: '🏛️',
      examples: <WordExample>[
        WordExample(chinese: '武英殿不仅展示历史，也承载自己的建筑历史。', pinyin: _storyTwoPinyin('武英殿不仅展示历史，也承载自己的建筑历史。'), vietnamese: 'Điện Vũ Anh không chỉ trưng bày lịch sử mà còn mang lịch sử kiến trúc của chính nó.', english: 'Wuying Hall not only presents history; it carries its own architectural history.'),
        WordExample(chinese: '建筑承载的记忆不能被镜头当成无关背景。', pinyin: _storyTwoPinyin('建筑承载的记忆不能被镜头当成无关背景。'), vietnamese: 'Ký ức mà công trình mang theo không thể bị máy quay coi là phông nền vô nghĩa.', english: 'The memory carried by the building cannot be treated as irrelevant background.'),
        WordExample(chinese: '最后的画面同时承载书页、空间和人物的选择。', pinyin: _storyTwoPinyin('最后的画面同时承载书页、空间和人物的选择。'), vietnamese: 'Khung hình cuối cùng đồng thời mang trang sách, không gian và lựa chọn của nhân vật.', english: 'The final image carries the page, the space, and the character\'s choice.'),
      ],
    ),
    '限度': WordEntry(
      word: '限度',
      pinyin: 'xiàndù',
      partOfSpeech: '名词',
      simpleChinese: '允许或能够达到的边界。',
      translation: 'Ranh giới của điều được phép hoặc có thể đạt tới.',
      englishDefinition: 'a limit or boundary',
      symbol: '🛑',
      examples: <WordExample>[
        WordExample(chinese: '白昀开始承认这座宫殿有自己的限度。', pinyin: _storyTwoPinyin('白昀开始承认这座宫殿有自己的限度。'), vietnamese: 'Bạch Quân bắt đầu thừa nhận cung điện này có giới hạn riêng.', english: 'Bai Yun begins to accept that the hall has limits of its own.'),
        WordExample(chinese: '设限不是把画面做差，而是知道控制应该停在哪里。', pinyin: _storyTwoPinyin('设限不是把画面做差，而是知道控制应该停在哪里。'), vietnamese: 'Đặt giới hạn không có nghĩa làm hình ảnh tệ đi mà là biết sự kiểm soát nên dừng ở đâu.', english: 'Setting limits is not making the image worse; it is knowing where control should stop.'),
        WordExample(chinese: '“亮到这里，就够了”记录的是一次主动选择的限度。', pinyin: _storyTwoPinyin('“亮到这里，就够了”记录的是一次主动选择的限度。'), vietnamese: '“Sáng đến đây là đủ” ghi lại giới hạn của một lựa chọn chủ động.', english: '“Bright to here is enough” records a deliberately chosen limit.'),
      ],
    ),
};

const List<List<String>> _storyTwoWordsByLevel = <List<String>>[
  <String>['补光', '方案', '层次'],
  <String>['线缆', '木构', '风险'],
  <String>['刊书', '版本', '重建'],
  <String>['依据', '风险', '方案'],
  <String>['评估', '代价', '依据'],
  <String>['反光板', '层次', '限度'],
  <String>['承载', '重建', '限度'],
  <String>['代价', '承载', '层次'],
  <String>['限度', '方案', '风险'],
  <String>['承载', '代价', '限度']
];

final List<List<DiscoveryEntry>> _storyTwoDiscoveriesByLevel = <List<DiscoveryEntry>>[
  <DiscoveryEntry>[
      DiscoveryEntry(text: '武英殿是紫禁城内的重要宫殿建筑，今天理解它时，建筑空间本身和其中发生过的历史活动都不能被拆开。', pinyin: _storyTwoPinyin('武英殿是紫禁城内的重要宫殿建筑，今天理解它时，建筑空间本身和其中发生过的历史活动都不能被拆开。'), simpleChinese: '武英殿是紫禁城的一部分，建筑和这里发生过的事情要一起理解。', vietnamese: 'Điện Vũ Anh là một công trình quan trọng trong Tử Cấm Thành; khi tìm hiểu nó ngày nay, không thể tách không gian kiến trúc khỏi những hoạt động lịch sử từng diễn ra tại đây.', english: 'Wuying Hall is an important building within the Forbidden City; understanding it requires keeping the architecture and the historical activities that took place there together.', sourceRefs: <String>['palace-museum-wuying-hall', 'unesco-imperial-palaces-beijing-shenyang']),
      DiscoveryEntry(text: '故宫的宫殿建筑以木构为重要特征，现场防火与用电管理因此不是附加规则，而是保护建筑本体的一部分。', pinyin: _storyTwoPinyin('故宫的宫殿建筑以木构为重要特征，现场防火与用电管理因此不是附加规则，而是保护建筑本体的一部分。'), simpleChinese: '故宫有大量木构建筑，所以防火和用电安全也是保护建筑。', vietnamese: 'Kiến trúc cung điện của Cố Cung có đặc trưng kết cấu gỗ; vì vậy quản lý phòng cháy và sử dụng điện tại hiện trường là một phần của việc bảo vệ chính công trình.', english: 'Timber construction is central to the palace complex, so fire and electrical safety are part of protecting the buildings themselves.', sourceRefs: <String>['palace-museum-fire-safety'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '对木构遗产来说，风险判断不能只看灯具是否发热，还要看电源、线缆、人员通行和现场变化是否仍在可控范围。', pinyin: _storyTwoPinyin('对木构遗产来说，风险判断不能只看灯具是否发热，还要看电源、线缆、人员通行和现场变化是否仍在可控范围。'), simpleChinese: '判断风险要一起看灯、电、线缆和人员路线。', vietnamese: 'Với di sản kết cấu gỗ, đánh giá rủi ro không thể chỉ dựa vào việc đèn có nóng hay không; nguồn điện, dây cáp, lối đi và thay đổi tại hiện trường cũng phải được kiểm soát.', english: 'For timber heritage, risk assessment is not only about whether a lamp gets hot; power, cables, circulation, and changes to the site also matter.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '保护要求把“拍得到”与“适不适合这样拍”分开判断：技术上可行，不等于在遗产现场就应该采用。', pinyin: _storyTwoPinyin('保护要求把“拍得到”与“适不适合这样拍”分开判断：技术上可行，不等于在遗产现场就应该采用。'), simpleChinese: '能做到，不等于在遗产现场就应该这样做。', vietnamese: 'Yêu cầu bảo tồn tách câu hỏi “có quay được không” khỏi “có nên quay như vậy ở đây không”; khả thi về kỹ thuật không đồng nghĩa phù hợp tại một địa điểm di sản.', english: 'Conservation separates “can it be filmed?” from “should it be filmed this way here?” Technical feasibility is not the same as appropriateness at a heritage site.', sourceRefs: <String>['palace-museum-fire-safety', 'unesco-imperial-palaces-beijing-shenyang'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '清代武英殿与宫廷修书、刊书活动关系密切，后世常用“武英殿本”指称与这里的官刻传统相关的书籍版本。', pinyin: _storyTwoPinyin('清代武英殿与宫廷修书、刊书活动关系密切，后世常用“武英殿本”指称与这里的官刻传统相关的书籍版本。'), simpleChinese: '清代武英殿和宫廷修书、刊书关系很密切。', vietnamese: 'Thời Thanh, điện Vũ Anh gắn chặt với việc biên soạn và in sách của cung đình; “bản điện Vũ Anh” thường dùng để chỉ các ấn bản liên quan đến truyền thống quan khắc tại đây.', english: 'In the Qing dynasty, Wuying Hall was closely associated with imperial editing and printing, and “Wuying Hall editions” became a term linked to that official printing tradition.', sourceRefs: <String>['palace-museum-wuying-hall']),
      DiscoveryEntry(text: '因此，在武英殿讲刊书史时，地点不是装饰性的背景；同一段知识离开这一地点，会失去“书从哪里被组织、刻印和传播”的空间关系。', pinyin: _storyTwoPinyin('因此，在武英殿讲刊书史时，地点不是装饰性的背景；同一段知识离开这一地点，会失去“书从哪里被组织、刻印和传播”的空间关系。'), simpleChinese: '在武英殿讲刊书史，地点本身就是知识的一部分。', vietnamese: 'Vì vậy khi kể lịch sử in sách tại điện Vũ Anh, địa điểm không chỉ là phông nền trang trí; rời khỏi nơi này sẽ làm mất quan hệ không gian về nơi sách được tổ chức, khắc in và lưu truyền.', english: 'When telling printing history in Wuying Hall, the site is not decorative background; moving the story elsewhere would erase the spatial relationship of where books were organized, printed, and circulated.', sourceRefs: <String>['palace-museum-wuying-hall'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '紫禁城作为世界遗产的价值来自完整宫殿建筑群及其历史功能，而不是只来自可移动文物。', pinyin: _storyTwoPinyin('紫禁城作为世界遗产的价值来自完整宫殿建筑群及其历史功能，而不是只来自可移动文物。'), simpleChinese: '紫禁城的价值也来自建筑群和历史功能，不只是文物。', vietnamese: 'Giá trị di sản thế giới của Tử Cấm Thành đến từ quần thể cung điện và chức năng lịch sử của nó, không chỉ từ hiện vật có thể di chuyển.', english: 'The Forbidden City’s World Heritage value lies in the palace ensemble and its historical functions, not only in movable objects.', sourceRefs: <String>['unesco-imperial-palaces-beijing-shenyang']),
      DiscoveryEntry(text: '拍摄一页书时，如果画面把武英殿完全抹成无差别的背景，就会削弱“书页与这座殿为什么在一起”的历史信息。', pinyin: _storyTwoPinyin('拍摄一页书时，如果画面把武英殿完全抹成无差别的背景，就会削弱“书页与这座殿为什么在一起”的历史信息。'), simpleChinese: '如果看不出武英殿，书页和地点的历史关系也会变弱。', vietnamese: 'Khi quay một trang sách, nếu hình ảnh làm điện Vũ Anh trở thành một phông nền không phân biệt, nó sẽ làm yếu thông tin lịch sử về lý do trang sách và tòa điện này thuộc cùng một câu chuyện.', english: 'If a shot turns Wuying Hall into generic background, it weakens the historical meaning of why the page and this hall belong in the same story.', sourceRefs: <String>['palace-museum-wuying-hall', 'unesco-imperial-palaces-beijing-shenyang'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '故宫的保护工作强调预防风险。临时改变现场条件时，重新评估比事后补救更符合预防性保护的逻辑。', pinyin: _storyTwoPinyin('故宫的保护工作强调预防风险。临时改变现场条件时，重新评估比事后补救更符合预防性保护的逻辑。'), simpleChinese: '现场条件变了，就先重新评估，不等出问题以后再补救。', vietnamese: 'Công tác bảo tồn của Cố Cung nhấn mạnh phòng ngừa rủi ro; khi điều kiện hiện trường thay đổi tạm thời, đánh giá lại phù hợp với logic bảo tồn phòng ngừa hơn là khắc phục sau sự cố.', english: 'Palace conservation emphasizes risk prevention; reassessing a temporary site change fits preventive conservation better than repairing harm afterward.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '“已经核定的条件”不是为了让创作停止，而是给创作一个明确边界，帮助团队知道哪些变化需要重新讨论。', pinyin: _storyTwoPinyin('“已经核定的条件”不是为了让创作停止，而是给创作一个明确边界，帮助团队知道哪些变化需要重新讨论。'), simpleChinese: '核定条件给创作边界，也告诉团队什么变化要重新讨论。', vietnamese: '“Điều kiện đã được phê duyệt” không nhằm dừng sáng tạo mà tạo ra ranh giới rõ ràng để biết thay đổi nào cần được thảo luận lại.', english: 'Approved conditions do not stop creative work; they define a boundary that tells the team which changes require renewed discussion.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '这让白昀的判断从“杜衡同不同意”变成“我的选择有没有足够依据”。', pinyin: _storyTwoPinyin('这让白昀的判断从“杜衡同不同意”变成“我的选择有没有足够依据”。'), simpleChinese: '白昀开始自己判断依据，而不是只等杜衡批准。', vietnamese: 'Điều này chuyển phán đoán của Bạch Quân từ “Đỗ Hành có đồng ý không” sang “lựa chọn của tôi có đủ căn cứ không”.', english: 'This changes Bai Yun’s question from “Will Du Heng allow it?” to “Do I have enough grounds for this choice?”', sourceRefs: <String>['palace-museum-fire-safety'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '武英殿的历史价值并不要求现代影像把每一处都照得同样明亮；真正需要保持的是建筑、功能与叙事关系可被辨认。', pinyin: _storyTwoPinyin('武英殿的历史价值并不要求现代影像把每一处都照得同样明亮；真正需要保持的是建筑、功能与叙事关系可被辨认。'), simpleChinese: '画面不必每处一样亮，但建筑和故事关系要看得出来。', vietnamese: 'Giá trị lịch sử của điện Vũ Anh không đòi hỏi hình ảnh hiện đại phải chiếu mọi nơi sáng như nhau; điều cần giữ là mối quan hệ giữa kiến trúc, chức năng và câu chuyện vẫn có thể nhận ra.', english: 'Wuying Hall’s value does not require modern images to make every surface equally bright; what matters is keeping the relationship between architecture, function, and story legible.', sourceRefs: <String>['palace-museum-wuying-hall', 'unesco-imperial-palaces-beijing-shenyang']),
      DiscoveryEntry(text: '反射已有光线、调整相机和改变构图，都是在不增加现场条件的前提下解决视觉问题的方法。', pinyin: _storyTwoPinyin('反射已有光线、调整相机和改变构图，都是在不增加现场条件的前提下解决视觉问题的方法。'), simpleChinese: '可以先改相机和反光方式，不一定先改现场。', vietnamese: 'Phản xạ ánh sáng sẵn có, điều chỉnh máy quay và thay đổi bố cục đều là cách giải quyết vấn đề hình ảnh mà không làm tăng điều kiện tại hiện trường.', english: 'Redirecting existing light, adjusting the camera, and reframing can solve visual problems without adding new site conditions.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '当白昀接受暗边以后，学习重点从“消灭所有阴影”转向“判断阴影是否遮住必要信息”。', pinyin: _storyTwoPinyin('当白昀接受暗边以后，学习重点从“消灭所有阴影”转向“判断阴影是否遮住必要信息”。'), simpleChinese: '重点不是消灭阴影，而是判断阴影有没有遮住必要信息。', vietnamese: 'Khi Bạch Quân chấp nhận dải tối, trọng tâm chuyển từ “xóa mọi bóng tối” sang “đánh giá bóng tối có che mất thông tin cần thiết hay không”.', english: 'Once Bai Yun accepts the dark edge, the question shifts from eliminating every shadow to judging whether shadow hides essential information.', sourceRefs: <String>['palace-museum-fire-safety'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '武英殿的现存状态包含历代修缮和重建留下的时间层次。保护并不是把建筑恢复成一个从未受损的想象状态。', pinyin: _storyTwoPinyin('武英殿的现存状态包含历代修缮和重建留下的时间层次。保护并不是把建筑恢复成一个从未受损的想象状态。'), simpleChinese: '修缮和重建也是武英殿历史的一部分。', vietnamese: 'Trạng thái hiện nay của điện Vũ Anh bao gồm nhiều lớp thời gian do các lần tu bổ và tái dựng để lại; bảo tồn không phải đưa công trình về một trạng thái tưởng tượng chưa từng hư hại.', english: 'Wuying Hall’s present condition includes layers created by repair and rebuilding; conservation is not the creation of an imaginary never-damaged past.', sourceRefs: <String>['palace-museum-wuying-rebuild']),
      DiscoveryEntry(text: '建筑经历过的损毁与重建，会改变我们理解“原样”“完整”和“真实”的方式。', pinyin: _storyTwoPinyin('建筑经历过的损毁与重建，会改变我们理解“原样”“完整”和“真实”的方式。'), simpleChinese: '损毁和重建会让“原样”和“真实”变得更复杂。', vietnamese: 'Những lần hư hại và tái dựng của công trình làm thay đổi cách ta hiểu các khái niệm “nguyên trạng”, “toàn vẹn” và “chân thực”.', english: 'Damage and rebuilding change how we understand ideas such as original condition, completeness, and authenticity.', sourceRefs: <String>['palace-museum-wuying-rebuild', 'unesco-imperial-palaces-beijing-shenyang']),
      DiscoveryEntry(text: '因此，阴影在故事里不再只是摄影缺陷，而成为提醒：有些历史信息来自建筑没有被抹平的时间感。', pinyin: _storyTwoPinyin('因此，阴影在故事里不再只是摄影缺陷，而成为提醒：有些历史信息来自建筑没有被抹平的时间感。'), simpleChinese: '阴影开始提醒白昀：建筑自己的时间不能被画面抹掉。', vietnamese: 'Vì vậy bóng tối trong câu chuyện không còn chỉ là lỗi quay phim mà trở thành lời nhắc rằng một phần thông tin lịch sử đến từ cảm giác thời gian chưa bị xóa phẳng trong kiến trúc.', english: 'Shadow is no longer merely a filming defect; it becomes a reminder that some historical information comes from the building’s unflattened sense of time.', sourceRefs: <String>['palace-museum-wuying-rebuild'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '文化遗产现场的创作选择可以有多种解法，但共同底线是不能把遗产本体当作可无限调整的摄影器材。', pinyin: _storyTwoPinyin('文化遗产现场的创作选择可以有多种解法，但共同底线是不能把遗产本体当作可无限调整的摄影器材。'), simpleChinese: '创作方法可以不同，但不能无限改变遗产本体。', vietnamese: 'Sáng tạo tại địa điểm di sản có thể có nhiều cách giải, nhưng giới hạn chung là không được coi chính di sản như một thiết bị quay có thể điều chỉnh vô hạn.', english: 'Creative work at a heritage site can have many solutions, but the heritage itself cannot be treated as infinitely adjustable production equipment.', sourceRefs: <String>['palace-museum-fire-safety', 'unesco-imperial-palaces-beijing-shenyang']),
      DiscoveryEntry(text: '当白昀把两版测试同时交给制片人时，她开始把“为什么这样拍”也当成作品的一部分，而不是只交付一个结果。', pinyin: _storyTwoPinyin('当白昀把两版测试同时交给制片人时，她开始把“为什么这样拍”也当成作品的一部分，而不是只交付一个结果。'), simpleChinese: '白昀不仅交结果，也说明为什么这样拍。', vietnamese: 'Khi Bạch Quân gửi cả hai bản thử cho nhà sản xuất, cô bắt đầu coi “vì sao quay như vậy” là một phần của tác phẩm chứ không chỉ giao một kết quả.', english: 'By sending both tests and explaining the choice, Bai Yun treats the reasoning behind the shot as part of the work rather than delivering only an outcome.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '地点必要性在这里变得明确：只有武英殿同时承担“刊书历史发生地”和“需要被保护的宫殿建筑”这两个角色，冲突才完整。', pinyin: _storyTwoPinyin('地点必要性在这里变得明确：只有武英殿同时承担“刊书历史发生地”和“需要被保护的宫殿建筑”这两个角色，冲突才完整。'), simpleChinese: '武英殿同时是故事发生地和保护对象，所以不能换成普通博物馆。', vietnamese: 'Tính không thể thay thế của địa điểm trở nên rõ ràng: chỉ khi điện Vũ Anh đồng thời là nơi gắn với lịch sử in sách và là chính công trình cung điện cần được bảo vệ thì xung đột mới trọn vẹn.', english: 'Place necessity becomes explicit here: the conflict works because Wuying Hall is both a site tied to imperial printing history and a palace building that must itself be protected.', sourceRefs: <String>['palace-museum-wuying-hall', 'palace-museum-fire-safety'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '真正的预防性保护并不要求所有视觉表达都变暗，而是要求变化可说明、风险可控制、责任归属清楚。', pinyin: _storyTwoPinyin('真正的预防性保护并不要求所有视觉表达都变暗，而是要求变化可说明、风险可控制、责任归属清楚。'), simpleChinese: '保护不是要求画面变暗，而是要求变化有依据、风险可控。', vietnamese: 'Bảo tồn phòng ngừa không yêu cầu mọi biểu đạt hình ảnh đều tối đi; nó yêu cầu thay đổi có thể giải thích, rủi ro được kiểm soát và trách nhiệm rõ ràng.', english: 'Preventive conservation does not require every image to be dark; it requires explainable changes, controlled risk, and clear responsibility.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '白昀把相机停留时间拉长，是把问题从“改变建筑现场”转到“改变观看方式”。', pinyin: _storyTwoPinyin('白昀把相机停留时间拉长，是把问题从“改变建筑现场”转到“改变观看方式”。'), simpleChinese: '她不改建筑，而是让观众多看三秒。', vietnamese: 'Việc Bạch Quân kéo dài thời gian giữ khung hình chuyển vấn đề từ “thay đổi hiện trường kiến trúc” sang “thay đổi cách người xem nhìn”.', english: 'Holding the shot longer shifts the solution from changing the heritage site to changing how the viewer looks.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: '杜衡退到监视器后面，说明关系也发生变化：保护判断不再是外部命令，而进入了创作选择本身。', pinyin: _storyTwoPinyin('杜衡退到监视器后面，说明关系也发生变化：保护判断不再是外部命令，而进入了创作选择本身。'), simpleChinese: '白昀已经能自己做保护判断，杜衡不再只负责阻止。', vietnamese: 'Việc Đỗ Hành lùi về sau màn hình cho thấy quan hệ đã đổi: phán đoán bảo tồn không còn là mệnh lệnh bên ngoài mà đã đi vào chính lựa chọn sáng tạo.', english: 'Du Heng stepping behind the monitor marks a relationship shift: conservation judgment is no longer an outside command but part of the creative decision itself.', sourceRefs: <String>['palace-museum-fire-safety'])
    ],
  <DiscoveryEntry>[
      DiscoveryEntry(text: '武英殿的故事把“可见性”与“保护”放在同一地点里讨论：让历史被看见，不等于把现场改到最容易被拍摄的状态。', pinyin: _storyTwoPinyin('武英殿的故事把“可见性”与“保护”放在同一地点里讨论：让历史被看见，不等于把现场改到最容易被拍摄的状态。'), simpleChinese: '让历史看得见，不等于把遗产现场改成最容易拍的样子。', vietnamese: 'Câu chuyện điện Vũ Anh đặt “khả năng nhìn thấy” và “bảo tồn” trong cùng một địa điểm: làm lịch sử được nhìn thấy không có nghĩa biến hiện trường thành trạng thái dễ quay nhất.', english: 'The Wuying Hall story places visibility and protection in the same site: making history visible does not mean altering the site into the easiest possible filming condition.', sourceRefs: <String>['palace-museum-wuying-hall', 'palace-museum-fire-safety']),
      DiscoveryEntry(text: '“亮到这里，就够了”不是一个通用照明标准，而是白昀在具体建筑、具体任务和具体风险条件下形成的判断。', pinyin: _storyTwoPinyin('“亮到这里，就够了”不是一个通用照明标准，而是白昀在具体建筑、具体任务和具体风险条件下形成的判断。'), simpleChinese: '这句话只属于这次具体条件，不是所有地方都适用的规则。', vietnamese: '“Sáng đến đây là đủ” không phải tiêu chuẩn chiếu sáng chung mà là phán đoán của Bạch Quân trong điều kiện kiến trúc, nhiệm vụ và rủi ro cụ thể.', english: '“Bright to here is enough” is not a universal lighting standard; it is Bai Yun’s judgment under this specific building, task, and risk context.', sourceRefs: <String>['palace-museum-fire-safety']),
      DiscoveryEntry(text: 'Memory Anchor 不是“黑暗很美”，而是一束停在纸边的光：它记录了人物终于愿意让建筑的限度进入自己的作品。', pinyin: _storyTwoPinyin('Memory Anchor 不是“黑暗很美”，而是一束停在纸边的光：它记录了人物终于愿意让建筑的限度进入自己的作品。'), simpleChinese: '记忆点是一束停在纸边的光，它代表白昀主动接受边界。', vietnamese: 'Memory Anchor không phải “bóng tối đẹp” mà là luồng sáng dừng ở mép giấy; nó ghi lại khoảnh khắc nhân vật chấp nhận đưa giới hạn của kiến trúc vào chính tác phẩm.', english: 'The Memory Anchor is not “darkness is beautiful,” but a beam stopping at the edge of the page, recording the moment the character lets the building’s limits enter the work.', sourceRefs: <String>['palace-museum-wuying-hall', 'palace-museum-wuying-rebuild'])
    ],
];

const List<String> _storyTwoWonderQuestions = <String>[
  '白昀为什么不能把“只加两分钟”当成一个完整决定？',
  '多一盏灯为什么改变的不只是亮度？',
  '知道武英殿的刊书历史后，白昀对“背景”产生了什么新判断？',
  '制片人的催促怎样把白昀的技术问题变成人物选择？',
  '白昀为什么把第二只灯收回去，却仍然没有“解决问题”？',
  '她什么时候从“怎样更亮”转向“什么必须看清”？',
  '重建资料为什么让阴影不再只是画面缺陷？',
  '白昀为什么愿意承担一个不那么漂亮的镜头被否定的风险？',
  '杜衡站到监视器后面，说明两人的关系发生了什么变化？',
  '“亮到这里，就够了”为什么不是一条通用照明规则？'
];

const List<String> _storyTwoExpressQuestions = <String>[
  '请按顺序写出白昀想补光、杜衡提问、第一遍拍摄留下暗角的过程。',
  '请说明线缆、人员路线和木构建筑为什么让临时加灯成为现场问题。',
  '请用自己的话解释“武英殿本”与这次拍摄地点之间的关系。',
  '请写出白昀面对截止时间时列出的三项理由，并指出哪一项最薄弱。',
  '请比较“想要的画面”“已核定条件”和“需要重新评估的变化”。',
  '请描述白昀怎样用相机与反光板改变画面，而不是改变建筑现场。',
  '请解释为什么“先看见殿，再看见书”改变了故事的判断方向。',
  '请比较两版测试镜头，并说明白昀为什么选择保留暗部。',
  '请说明那三秒停留怎样同时改变画面、人物关系和责任归属。',
  '请用条件句说明：如果地点不是武英殿，这个故事会失去哪些关键因果。'
];

JourneyLevelContent forbiddenCityStoryTwoLevelContent(
  int level, {
  Set<String> knownWords = const <String>{},
}) {
  if (level < 1 || level > 10) {
    throw RangeError.range(level, 1, 10, 'level');
  }
  final index = level - 1;
  final activeWords = <WordEntry>[
    for (final word in _storyTwoWordsByLevel[index]) _storyTwoWordBank[word]!,
  ];
  final unseen = activeWords
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);

  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(_storyParagraphsByLevel[index]),
    storyAnnotations:
        List<ReadingAnnotation>.unmodifiable(_storyAnnotationsByLevel[index]),
    words: List<WordEntry>.unmodifiable(unseen.isEmpty ? activeWords : unseen),
    discoveries:
        List<DiscoveryEntry>.unmodifiable(_storyTwoDiscoveriesByLevel[index]),
    wonderQuestion: _storyTwoWonderQuestions[index],
    expressQuestion: _storyTwoExpressQuestions[index],
  );
}

final JourneyContentRecord forbiddenCityStoryTwoContent = JourneyContentRecord(
  id: forbiddenCityStoryTwoJourneyId,
  title: '北京 · 紫禁城：$forbiddenCityStoryTwoTitle',
  geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const <String>[
    '北京',
    '紫禁城',
    '武英殿',
    '刊书',
    '木构',
    '保护',
    '摄影',
  ],
  sections: <JourneyStorySection>[
    for (var index = 0; index < _storyParagraphsByLevel[4].length; index += 1)
      JourneyStorySection(
        id: 'story-$index',
        text: _storyParagraphsByLevel[4][index],
        sourceIds: const <String>[
          'palace-museum-wuying-hall',
          'palace-museum-wuying-rebuild',
          'palace-museum-fire-safety',
          'unesco-imperial-palaces-beijing-shenyang',
        ],
      ),
  ],
);

final DailyJourneyExperience forbiddenCityStoryTwoExperience =
    DailyJourneyExperience(
  id: forbiddenCityStoryTwoJourneyId,
  city: '北京',
  cityCode: 'PEK',
  place: '紫禁城',
  appBarTitle: '北京 · 紫禁城',
  storyTitle: forbiddenCityStoryTwoTitle,
  headline: '白昀必须决定：为了让历史更清楚，光可以推到哪里为止',
  description: '闭馆后的武英殿里，一次拍摄把画面、保护、截止时间和建筑自己的历史压到同一束光里。',
  discoveryTeaser: '武英殿的刊书史、木构保护与重建记忆，为什么会改变一盏灯的意义？',
  distanceLabel: '1,670 km',
  stampSymbol: '宫',
  content: forbiddenCityStoryTwoContent,
  storyAnnotations: _storyAnnotationsByLevel[4],
  words: <WordEntry>[
    for (final word in _storyTwoWordsByLevel[4]) _storyTwoWordBank[word]!,
  ],
  discoveries: _storyTwoDiscoveriesByLevel[4],
  wonderQuestion: _storyTwoWonderQuestions[4],
  expressQuestion: _storyTwoExpressQuestions[4],
);

class ForbiddenCityStoryTwoMemory {
  const ForbiddenCityStoryTwoMemory({
    required this.prompt,
    required this.anchor,
    required this.closure,
    required this.learning,
  });

  final String prompt;
  final String anchor;
  final String closure;
  final String learning;
}

ForbiddenCityStoryTwoMemory forbiddenCityStoryTwoMemoryForLevel(int level) {
  if (level < 1 || level > 10) {
    throw RangeError.range(level, 1, 10, 'level');
  }
  return ForbiddenCityStoryTwoMemory(
    prompt: level <= 3
        ? '你会把哪一处光留下来？为什么？'
        : level <= 7
            ? '如果你是白昀，哪一个证据会让你改变拍摄决定？'
            : '当“更清楚”和“更诚实”发生冲突时，你愿意承担什么代价？',
    anchor: forbiddenCityStoryTwoMemoryAnchor,
    closure: '门外的工作灯一盏盏熄掉，最后留下的不是更亮的画面，而是白昀终于知道什么时候不再加光。',
    learning: '地点、任务、证据与风险共同决定“够不够”，而不是单靠个人偏好或一句规定。',
  );
}
