import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';

const luoyangLongmenGoldJourneyId = 'luoyang-longmen-grottoes';
const luoyangLongmenGoldStoryTitle = '签字页';
const luoyangLongmenGoldHeadline = '她只差弟弟一个签字，却在奉先寺前撕掉了那一页';
const luoyangLongmenGoldDescription =
    '一对成年姐弟带着房屋出售合同来到龙门石窟。沿伊河与山崖不断改变的观看距离，把一次当天签字逼成了是否继续共同决定家庭事务的选择。';
const luoyangLongmenGoldDiscoveryTeaser =
    '为什么龙门必须同时从小龛细节、奉先寺大型造像群和整段伊河山崖来理解？';
const luoyangLongmenGoldWonderQuestion =
    '如果你是周岚，在周屿提出“签完以后别再叫我回来”时，你会接受签字还是停下交易？为什么？';
const luoyangLongmenGoldExpressQuestion =
    '请用两到三句话写出周岚撕开签字页时，她失去了什么，又拒绝用什么去交换。';
const luoyangLongmenGoldMemoryMoment = '奉先寺前沿折痕被撕成两半、又被收回包里的签字页';
const luoyangLongmenGoldEndingAction = '周岚摸到包里的两半签字页，没有再拿出来';

class LongmenStoryLevelSpec {
  const LongmenStoryLevelSpec({
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final List<String> chinese;
  final List<String> vietnamese;
  final List<String> english;
}

const longmenGoldStoryLevels = <LongmenStoryLevelSpec>[
  LongmenStoryLevelSpec(
    chinese: <String>[
      '周岚四十二岁，带弟弟周屿来到龙门石窟。两人沿伊河走在山崖下。她包里有一份卖房合同，今天必须签字。周屿一路停下看石窟。到奉先寺前，他说：“我可以签，但以后家里的事你自己决定。”周岚把签字页撕成两半，说：“定金我赔。今天不签。”',
    ],
    vietnamese: <String>[
      'Chu Lam, 42 tuổi, đưa em trai Chu Dữ đến hang động Long Môn. Hai người đi dưới vách núi dọc sông Y. Trong túi cô có hợp đồng bán nhà phải ký hôm nay. Chu Dữ cứ dừng lại xem các hang đá. Trước Phụng Tiên Tự, anh nói: “Em có thể ký, nhưng sau này việc gia đình chị tự quyết.” Chu Lam xé đôi trang chữ ký: “Tiền đặt cọc chị chịu. Hôm nay không ký.”',
    ],
    english: <String>[
      'Zhou Lan, forty-two, brings her younger brother Zhou Yu to the Longmen Grottoes. They walk beneath the cliffs along the Yi River. She carries a house-sale contract that must be signed today. Zhou Yu keeps stopping to look at the grottoes. Before Fengxian Temple he says, “I can sign, but from now on you decide family matters yourself.” Zhou Lan tears the signature page in half. “I’ll take the deposit loss. We are not signing today.”',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '周岚四十二岁，和三十七岁的弟弟周屿来到龙门石窟。两人沿伊河走在山崖下，洞窟和佛龛一处接一处。周岚包里有卖掉父母旧房的合同，约好今天签字。她已经为新房交了不能退的定金，所以不断催弟弟快走。到奉先寺前，周屿说：“我可以签。签完以后，家里的事你自己决定，别再叫我回来。”周岚把签字页撕成两半：“定金我赔。今天不签。”',
    ],
    vietnamese: <String>[
      'Chu Lam, 42 tuổi, cùng em trai Chu Dữ, 37 tuổi, đến hang động Long Môn. Họ đi dọc sông Y dưới vách núi, nơi hang động và hốc thờ nối tiếp nhau. Chu Lam mang hợp đồng bán căn nhà cũ của cha mẹ và đã hẹn ký hôm nay. Vì cô đã đặt cọc không hoàn lại cho nhà mới, cô liên tục giục em đi nhanh. Trước Phụng Tiên Tự, Chu Dữ nói: “Em có thể ký. Ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam xé đôi trang chữ ký: “Tiền đặt cọc chị chịu. Hôm nay không ký.”',
    ],
    english: <String>[
      'Zhou Lan, forty-two, comes to the Longmen Grottoes with her thirty-seven-year-old brother Zhou Yu. They walk beneath the cliffs along the Yi River as caves and niches continue one after another. Zhou Lan carries the contract to sell their parents’ old home, scheduled to be signed today. Because she has already paid a non-refundable deposit on a new home, she keeps hurrying him. Before Fengxian Temple, Zhou Yu says, “I can sign. After I do, decide family matters yourself and don’t call me back again.” Zhou Lan tears the signature page in half. “I’ll take the deposit loss. We are not signing today.”',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '父母搬走后，四十二岁的周岚和弟弟周屿共同拥有一套空房。周岚找到买家，又先为自己的新房交了不能退的定金。今天只差周屿签字。他却把见面地点选在龙门石窟。两人沿伊河走在山崖下，周屿总在洞窟和佛龛前停下，周岚一直催他，因为签约时间越来越近。',
      '到奉先寺前，周屿拿出笔：“我可以签，但签完以后，家里的事你自己决定，别再叫我回来。”周岚本来只要一个名字，现在却听见了这个名字的代价。她把合同抽回来，沿折痕撕开签字页，把两半都收进包里：“定金我赔。今天不签。”',
    ],
    vietnamese: <String>[
      'Sau khi cha mẹ chuyển đi, Chu Lam, 42 tuổi, và em trai Chu Dữ cùng sở hữu một căn nhà để trống. Chu Lam tìm được người mua và còn tự đặt cọc không hoàn lại cho nhà mới. Hôm nay chỉ còn thiếu chữ ký của Chu Dữ. Anh đồng ý gặp nhưng chọn Long Môn. Họ đi dưới vách núi dọc sông Y; Chu Dữ liên tục dừng ở các hang và hốc thờ, còn Chu Lam cứ giục vì giờ ký hợp đồng đang tới gần.',
      'Trước Phụng Tiên Tự, Chu Dữ lấy bút ra: “Em có thể ký, nhưng ký xong thì việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam vốn chỉ cần một cái tên, giờ nghe thấy cái giá phía sau cái tên ấy. Cô rút hợp đồng lại, xé trang chữ ký theo nếp gấp, cất cả hai nửa vào túi: “Tiền đặt cọc chị chịu. Hôm nay không ký.”',
    ],
    english: <String>[
      'After their parents move away, forty-two-year-old Zhou Lan and her brother Zhou Yu jointly own an empty apartment. Zhou Lan finds a buyer and has already paid a non-refundable deposit on a new home of her own. Today she needs only Zhou Yu’s signature. He agrees to meet but chooses the Longmen Grottoes. They walk under the cliffs along the Yi River; Zhou Yu repeatedly stops at caves and niches while Zhou Lan keeps hurrying him because the signing time is getting closer.',
      'Before Fengxian Temple, Zhou Yu takes out a pen. “I can sign, but after I do, decide family matters yourself and don’t call me back again.” Zhou Lan had wanted only a name, but now hears the cost attached to that name. She pulls the contract back, tears the signature page along its fold, puts both halves in her bag, and says, “I’ll take the deposit loss. We are not signing today.”',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '父母搬离洛阳后，周岚和弟弟周屿共同拥有的旧房空了两年。水电、维修和中介电话大多由周岚处理，她渐渐习惯先决定，再通知弟弟。这个月她找到买家，又看中一套离公司更近的小房，没等周屿答应就交了不能退的定金。只要今天两个人签字，她就能把事情一次解决。周屿同意见面，却坚持先去龙门石窟。他说：“先走完这一段，再谈签字。”',
      '沿伊河走到山崖下，洞窟和佛龛接连出现。周屿一会儿靠近看细节，一会儿停下来，周岚不断看时间。到奉先寺大型造像群前，周屿拿出笔：“我可以签。可是签完以后，家里的事你自己决定，别再叫我回来。”周岚把合同抽回来，沿折痕撕开签字页：“定金我自己赔。今天不签。”',
    ],
    vietnamese: <String>[
      'Sau khi cha mẹ rời Lạc Dương, căn nhà cũ đồng sở hữu của Chu Lam và em trai Chu Dữ bị bỏ trống hai năm. Tiền điện nước, sửa chữa và các cuộc gọi môi giới phần lớn do Chu Lam xử lý, nên cô dần quen quyết định trước rồi mới báo cho em. Tháng này cô tìm được người mua và một căn hộ nhỏ gần công ty hơn, rồi đặt cọc không hoàn lại trước khi Chu Dữ đồng ý. Chỉ cần hai người ký hôm nay, cô có thể giải quyết mọi việc một lần. Chu Dữ đồng ý gặp nhưng nhất quyết đi Long Môn trước. Anh nói: “Đi hết đoạn này trước, rồi hãy nói chuyện ký.”',
      'Dọc sông Y dưới vách núi, các hang động và hốc thờ nối tiếp nhau. Chu Dữ lúc thì tiến gần để xem chi tiết, lúc lại dừng, còn Chu Lam liên tục xem giờ. Trước quần thể tượng lớn ở Phụng Tiên Tự, Chu Dữ lấy bút ra: “Em có thể ký. Nhưng ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam rút hợp đồng lại và xé trang chữ ký theo nếp gấp: “Tiền đặt cọc chị tự chịu. Hôm nay không ký.”',
    ],
    english: <String>[
      'After their parents leave Luoyang, the old home jointly owned by Zhou Lan and her brother Zhou Yu sits empty for two years. Zhou Lan handles most utilities, repairs, and calls from agents, and gradually gets used to deciding first and informing her brother afterward. This month she finds a buyer and a smaller apartment closer to work, then pays a non-refundable deposit before Zhou Yu agrees. If both sign today, she can settle everything at once. Zhou Yu agrees to meet but insists on visiting Longmen first. He says, “Walk this stretch with me first, then we can talk about signing.”',
      'Along the Yi River beneath the cliffs, caves and niches appear one after another. Zhou Yu sometimes moves close to study details and sometimes simply stops, while Zhou Lan keeps checking the time. Before Fengxian Temple’s monumental sculpture group, Zhou Yu takes out a pen. “I can sign. But afterward, decide family matters yourself and don’t call me back again.” Zhou Lan pulls the contract away and tears the signature page along the fold. “I’ll take the deposit loss myself. We are not signing today.”',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '周岚四十二岁，弟弟周屿三十七岁。父母搬离洛阳后，两人共同拥有的旧房空了两年。修漏水、交物业费、接中介电话，大多是周岚在处理。她觉得自己承担得多，就该把事情推进得快。这个月她找到愿意成交的买家，又看中一套离公司更近的小房。为了锁定新房，她没等周屿答应就先交了不能退的定金。今天只要两个人在合同上签字，买卖就能继续。',
      '周屿把见面地点定在龙门石窟。两人沿伊河和山崖向前，洞窟与佛龛密集分布。小处他靠近看细节，到了奉先寺大型造像群，又停下来找能看清整体的距离。周岚连着催他。签约时间快到时，周屿拿出笔：“我可以签。你不会丢定金。但签完以后，家里的事你自己决定，别再叫我回来。”周岚看着打开的笔，忽然把合同抽回来。她沿折痕撕开签字页，把两半都收进包里：“定金我赔。房子今天不卖。”',
    ],
    vietnamese: <String>[
      'Chu Lam 42 tuổi, em trai Chu Dữ 37 tuổi. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ họ cùng sở hữu bị bỏ trống hai năm. Sửa chỗ dột, đóng phí quản lý, nghe điện thoại môi giới phần lớn do Chu Lam làm. Cô nghĩ mình gánh nhiều hơn thì có quyền đẩy mọi việc nhanh hơn. Tháng này cô tìm được người mua sẵn sàng giao dịch và một căn hộ nhỏ gần công ty hơn. Để giữ căn mới, cô đặt cọc không hoàn lại trước khi Chu Dữ đồng ý. Hôm nay chỉ cần cả hai ký hợp đồng thì giao dịch có thể tiếp tục.',
      'Chu Dữ chọn Long Môn làm nơi gặp. Họ đi dọc sông Y và vách núi, nơi hang động và hốc thờ phân bố dày. Ở chỗ nhỏ anh tiến gần xem chi tiết; đến quần thể tượng lớn Phụng Tiên Tự anh lại dừng để tìm khoảng cách nhìn toàn thể. Chu Lam liên tục giục. Khi sắp tới giờ ký, Chu Dữ lấy bút: “Em có thể ký. Chị sẽ không mất tiền cọc. Nhưng ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam nhìn cây bút đã mở rồi bất ngờ rút hợp đồng lại. Cô xé trang chữ ký theo nếp gấp, cất cả hai nửa vào túi: “Tiền cọc chị chịu. Hôm nay không bán nhà.”',
    ],
    english: <String>[
      'Zhou Lan is forty-two and her brother Zhou Yu is thirty-seven. After their parents leave Luoyang, the old home they jointly own sits empty for two years. Zhou Lan handles most leaks, property fees, and calls from agents. She believes that because she carries more of the burden, she should be able to move things faster. This month she finds a willing buyer and a smaller apartment closer to work. To secure the new place, she pays a non-refundable deposit before Zhou Yu agrees. If both sign the contract today, the sale can proceed.',
      'Zhou Yu chooses the Longmen Grottoes for their meeting. They walk along the Yi River and cliffs, where caves and niches are densely distributed. At smaller places he moves close to see details; at Fengxian Temple’s monumental sculpture group he stops again to find a distance from which he can see the whole. Zhou Lan keeps urging him. As the signing time approaches, Zhou Yu takes out a pen. “I can sign. You won’t lose your deposit. But afterward, decide family matters yourself and don’t call me back again.” Zhou Lan looks at the uncapped pen, then suddenly takes back the contract. She tears the signature page along the fold, puts both halves in her bag, and says, “I’ll take the deposit loss. The house is not being sold today.”',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '四十二岁的周岚和三十七岁的周屿是一对多年各过各的姐弟。父母搬离洛阳后，两人共同拥有的旧房空了两年。修漏水、换门锁、交物业费、接中介电话，几乎都是周岚在处理。周屿在外地工作，转钱很快，回来很少。周岚越来越觉得，承担责任的人就应该拥有更快的决定权。这个月她找到愿意当天成交的买家，又看中一套离公司更近的小房。为了锁定新房，她先交了一笔不能退的定金，然后才把卖房合同发给周屿。',
      '周屿没有直接拒绝，只说“龙门见”。两人沿伊河走在石灰岩山崖旁。洞窟和佛龛沿崖展开，小的地方周屿会靠近看细节，到了奉先寺大型造像群，他又停下来寻找看清整体的距离。周岚不断计算离签约还有多久，第三次催他时，周屿问：“你今天是想和我谈，还是只想把我带到能签字的地方？”到奉先寺前，他拿出笔：“我可以签，但从今天起，家里的事你自己决定，别再叫我回来。”周岚把合同抽回，沿折痕把签字页撕成两半，纸都收进包里：“定金我自己赔。今天不签。”原定签约时间在他们离开前过去了。',
    ],
    vietnamese: <String>[
      'Chu Lam 42 tuổi và Chu Dữ 37 tuổi là hai chị em đã sống cuộc đời riêng nhiều năm. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ họ cùng sở hữu bị bỏ trống hai năm. Sửa chỗ dột, thay khóa, đóng phí quản lý và trả lời môi giới gần như đều do Chu Lam xử lý. Chu Dữ làm việc xa, chuyển tiền nhanh nhưng hiếm khi về. Chu Lam ngày càng tin rằng người gánh trách nhiệm nên có quyền quyết định nhanh hơn. Tháng này cô tìm được người mua muốn giao dịch ngay và một căn hộ nhỏ gần công ty hơn. Để giữ căn mới, cô đặt cọc không hoàn lại rồi mới gửi hợp đồng bán nhà cho em.',
      'Chu Dữ không từ chối thẳng, chỉ nói “Gặp ở Long Môn.” Họ đi dọc sông Y cạnh vách đá vôi. Hang động và hốc thờ trải dọc vách; ở chỗ nhỏ Chu Dữ tiến gần xem chi tiết, đến quần thể tượng lớn Phụng Tiên Tự anh lại dừng để tìm khoảng cách nhìn được toàn thể. Chu Lam liên tục tính thời gian còn lại. Lần giục thứ ba, Chu Dữ hỏi: “Hôm nay chị muốn nói chuyện với em, hay chỉ muốn đưa em đến chỗ ký tên?” Trước Phụng Tiên Tự anh lấy bút: “Em có thể ký, nhưng từ hôm nay việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam rút hợp đồng lại, xé đôi trang chữ ký theo nếp gấp và cất giấy vào túi: “Tiền cọc chị tự chịu. Hôm nay không ký.” Giờ ký đã trôi qua trước khi họ rời đi.',
    ],
    english: <String>[
      'Forty-two-year-old Zhou Lan and thirty-seven-year-old Zhou Yu are siblings who have lived largely separate lives for years. After their parents leave Luoyang, the home they jointly own sits empty for two years. Zhou Lan handles nearly every leak, lock replacement, property fee, and call from agents. Zhou Yu works away from home, sends money promptly, but rarely returns. Zhou Lan increasingly believes that the person carrying the responsibility should have the right to decide faster. This month she finds a buyer ready to close immediately and a smaller apartment closer to work. She pays a non-refundable deposit to secure the new place and only then sends Zhou Yu the sale contract.',
      'Zhou Yu does not refuse outright; he says only, “Meet me at Longmen.” They walk along the Yi River beside limestone cliffs. Caves and niches spread along the rock face. At small ones Zhou Yu moves close to see details; at Fengxian Temple’s monumental sculpture group he stops to find a distance that reveals the whole. Zhou Lan keeps calculating the time left before signing. The third time she urges him on, he asks, “Did you come to talk to me today, or only to bring me somewhere I can sign?” Before Fengxian Temple he takes out a pen. “I can sign, but from today on decide family matters yourself and don’t call me back again.” Zhou Lan takes the contract back, tears the signature page in half along the fold, and puts the paper in her bag. “I’ll take the deposit loss myself. We are not signing today.” Their scheduled signing time passes before they leave.',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '周岚四十二岁，周屿三十七岁。父母搬离洛阳后，姐弟共同拥有的旧房空了两年。周岚留在本地，漏水、门锁、物业和中介几乎都由她处理；周屿在外地工作，只在需要签文件时出现。周岚没有和他大吵，她只是越来越习惯先把方案定好，再把最后一页发给弟弟。这个月，她找到一个愿意很快成交的买家，同时看中一套离公司更近的小房。她没等周屿明确答应，就先交了不能退的定金。只要两人今天签字，旧房出售和新房付款就能接上。',
      '周屿把见面地点选在龙门石窟。两人沿伊河和山崖向前。洞窟、佛龛与造像沿崖连续出现，小处要靠近看细节，大型造像群则要拉开距离才能看清整体安排。周屿一路停停走走，周岚却只看签约时间。她第三次说“后面别停了”，周屿问：“你是来和我谈，还是只要我的名字？”到奉先寺前，他把笔尖停在签名框上方：“我可以签，你也不会丢定金。条件是，签完以后家里的事你自己决定，别再叫我回来。”周岚原本以为签字就是解决问题，此刻才看见它会换走什么。她把合同抽回，沿中间折痕撕开签字页，把两半都收进包里：“定金我赔。房子今天不卖。”周屿没有道谢。签约时间过去，旧房仍属于两个人，他们也还没有新的答案。',
    ],
    vietnamese: <String>[
      'Chu Lam 42 tuổi, Chu Dữ 37 tuổi. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ hai chị em cùng sở hữu bị bỏ trống hai năm. Chu Lam ở lại địa phương, gần như tự xử lý chỗ dột, khóa cửa, phí quản lý và môi giới; Chu Dữ làm việc xa, chỉ xuất hiện khi cần ký giấy. Chu Lam không cãi nhau lớn với em, cô chỉ dần quen quyết định xong phương án rồi gửi trang cuối cho em trai. Tháng này cô tìm được người mua muốn giao dịch nhanh và một căn hộ nhỏ gần công ty. Cô đặt cọc không hoàn lại trước khi Chu Dữ đồng ý rõ ràng. Nếu hai người ký hôm nay, tiền bán nhà cũ có thể nối vào khoản thanh toán nhà mới.',
      'Chu Dữ chọn Long Môn làm nơi gặp. Họ đi dọc sông Y và vách núi. Hang động, hốc thờ và tượng nối tiếp nhau; chỗ nhỏ cần tiến gần để xem chi tiết, còn quần thể lớn cần lùi ra mới thấy bố cục toàn thể. Chu Dữ cứ dừng, Chu Lam chỉ nhìn giờ ký. Lần thứ ba cô nói “đừng dừng nữa”, Chu Dữ hỏi: “Chị đến nói chuyện với em, hay chỉ cần tên em?” Trước Phụng Tiên Tự, anh giữ ngòi bút trên ô chữ ký: “Em có thể ký, chị cũng không mất tiền cọc. Điều kiện là sau đó việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam vốn nghĩ chữ ký sẽ giải quyết vấn đề, giờ mới thấy nó sẽ đổi lấy điều gì. Cô rút hợp đồng lại, xé trang chữ ký theo nếp gấp giữa, cất cả hai nửa vào túi: “Tiền cọc chị chịu. Hôm nay không bán nhà.” Chu Dữ không cảm ơn. Giờ ký qua đi; căn nhà vẫn thuộc cả hai và họ vẫn chưa có câu trả lời mới.',
    ],
    english: <String>[
      'Zhou Lan is forty-two and Zhou Yu thirty-seven. After their parents leave Luoyang, the old home the siblings jointly own sits empty for two years. Zhou Lan stays local and handles nearly all leaks, locks, property fees, and agents; Zhou Yu works elsewhere and appears mainly when a document needs signing. They do not have one great fight. Instead, Zhou Lan gradually gets used to choosing a plan first and sending her brother the last page. This month she finds a buyer who wants a quick deal and a smaller apartment closer to work. She pays a non-refundable deposit before Zhou Yu clearly agrees. If they sign today, the proceeds from the old home can connect directly to payment for the new one.',
      'Zhou Yu chooses Longmen for the meeting. They move along the Yi River and cliffs. Caves, niches, and sculptures continue across the rock face; small details require moving close, while monumental groups require more distance to see the whole arrangement. Zhou Yu keeps stopping, while Zhou Lan watches only the signing time. The third time she says, “Don’t stop again,” he asks, “Did you come to talk to me, or do you only need my name?” Before Fengxian Temple he holds the pen above the signature box. “I can sign, and you won’t lose your deposit. The condition is that afterward you decide family matters yourself and don’t call me back again.” Zhou Lan had thought a signature would solve the problem; now she sees what it would purchase. She pulls the contract back, tears the signature page along its center fold, and puts both halves in her bag. “I’ll take the deposit loss. The house is not being sold today.” Zhou Yu does not thank her. The signing time passes; the house still belongs to both of them, and they still have no new answer.',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '四十二岁的周岚和三十七岁的周屿已经很多年没有一起走完一个下午。父母搬离洛阳后，姐弟共同拥有的旧房空了两年。周岚留在本地，漏水、门锁、物业、中介，几乎所有琐事都落到她身上；周屿在外地工作，转钱很快，回来很少。她没有和他大吵，只是越来越习惯先把方案定好，再把需要签字的那一页发给弟弟。这个月，她找到一个愿意当天成交的买家，又看中一套离公司更近的小房。为了不让新房被别人订走，她先交了不能退的定金，然后告诉周屿：“今天回来把字签了就行。”周屿没有说行，也没有说不行，只回：“龙门见。”小时候一家人来龙门石窟，周岚总想赶快往前，周屿却会在一个又一个小龛前停很久。',
      '两人这次沿伊河走到石灰岩山崖下，洞窟、佛龛和造像沿崖连续出现。小处周屿靠近辨认细节，到了奉先寺这样的大型造像群，他又拉开距离看整体。周岚的注意力却只剩签约时间。她第一次催，周屿说“马上”；第二次催，他沉默；第三次她说“后面别停了”，周屿终于问：“你是想和我谈卖房，还是只要我按时出现，把名字交给你？”周岚说自己处理了两年的麻烦，也已经交了定金。周屿听到“已经”，只说：“又是你先决定。”到奉先寺前，他拿出笔：“我可以签。你拿到房款，也不会丢定金。但签完以后，家里的事你自己决定，别再叫我回来。”周岚看着笔尖停在签名框上方。她可以得到签字，却会让弟弟把今后的共同决定一起交出去。她把合同抽回，沿旧折痕把签字页撕成两半，纸都收进自己的包：“定金我赔。房子今天不卖。”周屿没有道谢。原定签约时间在他们离开龙门前过去了。',
    ],
    vietnamese: <String>[
      'Chu Lam, 42 tuổi, và Chu Dữ, 37 tuổi, đã nhiều năm không cùng nhau đi hết một buổi chiều. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ hai chị em cùng sở hữu bị bỏ trống hai năm. Chu Lam ở lại địa phương, gần như gánh hết chuyện dột nước, khóa cửa, phí quản lý và môi giới; Chu Dữ làm việc xa, chuyển tiền nhanh nhưng ít về. Cô không cãi lớn, chỉ ngày càng quen chốt phương án trước rồi gửi trang cần ký cho em. Tháng này cô tìm được người mua muốn giao dịch trong ngày và một căn hộ nhỏ gần công ty hơn. Để giữ căn mới, cô đặt cọc không hoàn lại rồi mới nói với Chu Dữ: “Hôm nay về ký là xong.” Anh chỉ đáp: “Gặp ở Long Môn.” Khi nhỏ, ở Long Môn, Chu Lam luôn muốn đi nhanh còn Chu Dữ dừng lâu trước những hốc nhỏ.',
      'Lần này họ đi dọc sông Y dưới vách đá vôi, nơi hang động, hốc thờ và tượng nối tiếp nhau. Ở chỗ nhỏ Chu Dữ tiến gần xem chi tiết; đến quần thể lớn như Phụng Tiên Tự anh lại lùi ra nhìn toàn thể. Chu Lam chỉ còn chú ý tới giờ ký. Sau ba lần bị giục, Chu Dữ hỏi: “Chị muốn nói chuyện bán nhà hay chỉ cần em xuất hiện đúng giờ để giao cái tên cho chị?” Chu Lam nói cô đã xử lý rắc rối hai năm và tiền cọc cũng đã trả. Nghe chữ “đã”, anh nói: “Lại là chị quyết trước.” Trước Phụng Tiên Tự, anh cầm bút: “Em có thể ký. Chị có tiền bán nhà và không mất cọc. Nhưng ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Ngòi bút dừng trên ô chữ ký. Chu Lam có thể lấy được chữ ký, nhưng sẽ để em trai giao luôn quyền tham gia các quyết định tương lai. Cô rút hợp đồng, xé đôi trang chữ ký theo nếp gấp cũ, cất giấy vào túi: “Tiền cọc chị chịu. Hôm nay không bán nhà.” Chu Dữ không cảm ơn. Giờ ký đã trôi qua trước khi họ rời Long Môn.',
    ],
    english: <String>[
      'Forty-two-year-old Zhou Lan and thirty-seven-year-old Zhou Yu have not spent an entire afternoon together in years. After their parents leave Luoyang, the old home the siblings jointly own sits empty for two years. Zhou Lan stays local and carries nearly all the leaks, locks, property fees, and dealings with agents; Zhou Yu works away, sends money quickly, but returns rarely. She does not stage a major fight. She simply becomes used to deciding the plan first and sending him the page that needs a signature. This month she finds a buyer willing to close that day and a smaller apartment closer to work. To hold the new place, she pays a non-refundable deposit and only then tells Zhou Yu, “Come back today and sign.” He answers only, “Meet me at Longmen.” As children at the Longmen Grottoes, Zhou Lan always wanted to move quickly while Zhou Yu lingered at small niches.',
      'This time they walk beneath the limestone cliffs along the Yi River, where caves, niches, and sculptures continue one after another. At small places Zhou Yu moves close to study details; at monumental groups such as Fengxian Temple he steps back to see the whole. Zhou Lan, however, is watching only the signing time. After she urges him on three times, Zhou Yu asks, “Do you want to discuss the sale, or do you only need me to appear on time and hand you my name?” Zhou Lan says she has handled two years of problems and that the deposit is already paid. Hearing “already,” he says, “You decided first again.” Before Fengxian Temple he takes out a pen. “I can sign. You get the sale money and keep your deposit. But after I sign, decide family matters yourself and don’t call me back again.” The pen stops above the signature box. Zhou Lan can obtain the signature, but only by letting her brother surrender his place in future shared decisions. She pulls the contract back, tears the signature page along its old fold, puts both halves in her bag, and says, “I’ll take the deposit loss. The house is not being sold today.” Zhou Yu does not thank her. Their scheduled signing time passes before they leave Longmen.',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '四十二岁的周岚和三十七岁的周屿已经很多年没有一起走完一个下午。父母搬离洛阳后，姐弟共同拥有的旧房空了两年。周岚留在本地，漏水、门锁、物业、中介，所有琐事几乎都由她处理；周屿在外地工作，转钱很快，回来很少。责任积得越久，周岚越相信自己有资格把决定也一起做完。这个月，她找到一个愿意当天成交的买家，又看中一套离公司更近的小房。为了锁定新房，她先交了不能退的定金，然后才把卖房合同发给周屿：“回来签字就行。”周屿只回：“龙门见。”小时候一家四口去龙门石窟，周岚总想赶到最大的地方，周屿却会在山崖上不起眼的小龛前看很久。那条沿伊河与山崖展开的路线，成了姐弟少数都还记得的共同经验。',
      '这次他们仍从一个又一个洞窟和佛龛旁走过。小处需要靠近才看得见细节，到了奉先寺的大型造像群，又要拉开距离才能看出整体的尺度和安排。周屿的停留因此忽近忽远，周岚的节奏却只由签约时间决定。她第一次催，他说“快了”；第二次催，他没有回答；第三次她说“后面别停”，周屿问：“你到底是来和我谈，还是只需要我的名字？”周岚列出自己两年来处理的事情，又说定金已经交了。周屿听见“已经”，笑了一下：“所以我又是在最后一页才出现。”到奉先寺前，他从口袋里拿出笔，把合同翻到签名处：“我可以签。你不会丢定金，房子也能卖。条件只有一个，签完以后家里的事你自己决定，别再叫我回来。”他把笔尖停在签名框上方。周岚最想得到的东西只差一个动作，而代价突然变得清楚：钱可以保住，弟弟却准备退出以后所有共同决定。她把合同抽回来，沿中间那道旧折痕把签字页撕成两半。纸裂开的声音很轻，她没有把纸扔在山崖下，而是把两半都放进自己的包：“定金我自己赔。房子今天不卖。”周屿没有道谢，也没有立刻改口。离开时，原定签约时间已经过去，旧房仍属于两个人，谁承担多少、卖不卖、什么时候再谈，都没有解决。',
    ],
    vietnamese: <String>[
      'Chu Lam, 42 tuổi, và Chu Dữ, 37 tuổi, đã nhiều năm không cùng nhau đi hết một buổi chiều. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ hai chị em cùng sở hữu bị bỏ trống hai năm. Chu Lam ở lại địa phương, gần như tự xử lý mọi chuyện từ dột nước, khóa cửa, phí quản lý đến môi giới; Chu Dữ làm việc xa, chuyển tiền nhanh nhưng ít về. Trách nhiệm càng tích tụ, Chu Lam càng tin mình có quyền quyết định luôn. Tháng này cô tìm được người mua sẵn sàng giao dịch trong ngày và một căn hộ nhỏ gần công ty hơn. Cô đặt cọc không hoàn lại trước, sau đó mới gửi hợp đồng bán nhà cho Chu Dữ: “Về ký là được.” Anh chỉ đáp: “Gặp ở Long Môn.” Khi nhỏ, Chu Lam luôn muốn đi tới chỗ lớn nhất của Long Môn, còn Chu Dữ có thể đứng rất lâu trước một hốc nhỏ không nổi bật. Tuyến đường dọc sông Y và vách núi là một trong số ít ký ức chung cả hai vẫn còn.',
      'Lần này họ lại đi qua hết hang động và hốc thờ này tới chỗ khác. Chi tiết nhỏ cần tiến gần, còn quần thể tượng lớn ở Phụng Tiên Tự cần lùi ra mới thấy quy mô và bố cục. Nhịp dừng của Chu Dữ khi gần khi xa, trong khi nhịp của Chu Lam chỉ do giờ ký quyết định. Sau lần giục thứ ba, anh hỏi: “Chị đến nói chuyện hay chỉ cần tên em?” Chu Lam liệt kê hai năm công việc mình đã làm và nói tiền cọc cũng đã trả. Chu Dữ nghe chữ “đã” rồi cười: “Vậy em lại chỉ xuất hiện ở trang cuối.” Trước Phụng Tiên Tự, anh mở hợp đồng ở phần ký: “Em có thể ký. Chị không mất cọc, nhà cũng bán được. Chỉ có một điều, ký xong thì việc gia đình chị tự quyết, đừng gọi em về nữa.” Ngòi bút dừng trên ô ký. Điều Chu Lam muốn nhất chỉ còn cách một động tác, nhưng cái giá bỗng rõ ràng: tiền có thể giữ, còn em trai chuẩn bị rời khỏi mọi quyết định chung sau này. Cô rút hợp đồng lại, xé đôi trang ký theo nếp gấp giữa. Tiếng giấy rất khẽ; cô không vứt xuống vách núi mà cất cả hai nửa vào túi: “Tiền cọc chị tự chịu. Hôm nay không bán.” Chu Dữ không cảm ơn và cũng không đổi lời ngay. Khi họ rời đi, giờ ký đã qua; căn nhà vẫn thuộc hai người, còn chuyện ai gánh bao nhiêu, có bán hay không và khi nào nói lại vẫn chưa giải quyết.',
    ],
    english: <String>[
      'Forty-two-year-old Zhou Lan and thirty-seven-year-old Zhou Yu have not spent an entire afternoon together in years. After their parents leave Luoyang, the old home they jointly own sits empty for two years. Zhou Lan stays local and handles nearly everything from leaks and locks to property fees and agents; Zhou Yu works away, sends money promptly, but returns rarely. The longer the responsibilities accumulate, the more Zhou Lan believes she has earned the right to make the decisions too. This month she finds a buyer ready to close that day and a smaller apartment closer to work. She pays a non-refundable deposit first, then sends Zhou Yu the sale contract: “Just come back and sign.” He replies only, “Meet me at Longmen.” As children, Zhou Lan always wanted to reach Longmen’s largest sights, while Zhou Yu could remain a long time before an inconspicuous niche. The route along the Yi River and cliffs is one of the few shared memories they both still hold.',
      'This time they again pass cave after cave and niche after niche. Small details require moving close, while the monumental sculpture group at Fengxian Temple requires more distance to see its scale and arrangement. Zhou Yu’s stops shift between near and far, while Zhou Lan’s pace is controlled only by the signing time. After her third attempt to hurry him, he asks, “Did you come to talk, or do you only need my name?” Zhou Lan lists the work she has handled for two years and says the deposit is already paid. Zhou Yu hears “already” and smiles. “So I appear only on the last page again.” Before Fengxian Temple he opens the contract to the signature section. “I can sign. You keep your deposit and the house is sold. One condition: afterward decide family matters yourself and don’t call me back again.” The pen stops above the signature box. What Zhou Lan wants is only one movement away, but the price suddenly becomes clear: she can preserve the money while her brother prepares to leave all future shared decisions. She pulls the contract back and tears the signature page in half along the center fold. The sound is soft. She does not leave the paper by the cliff; she puts both halves in her bag. “I’ll take the deposit loss myself. The house is not being sold today.” Zhou Yu does not thank her or immediately take back his words. When they leave, the signing time has passed. The home still belongs to both of them, and questions of responsibility, sale, and when to talk again remain unresolved.',
    ],
  ),
  LongmenStoryLevelSpec(
    chinese: <String>[
      '四十二岁的周岚和三十七岁的周屿已经很多年没有一起走完一个下午。父母搬离洛阳后，姐弟共同拥有的旧房空了两年。周岚留在本地，漏水、门锁、物业、中介几乎都由她处理；周屿在外地工作，转钱很快，回来很少。责任积得越久，周岚越习惯把责任和决定权当成同一件事。这个月，她找到愿意当天成交的买家，又看中一套离公司更近的小房。为了锁定新房，她先交了不能退的定金，然后才把合同发给周屿：“回来签字就行。”周屿只回：“龙门见。”小时候一家人常去龙门石窟，周岚总想赶到最大的地方，周屿却会在山崖上不起眼的小龛前看很久。那条沿伊河与石灰岩山崖展开的路，是姐弟少数都还记得的共同路线。',
      '多年后，他们再次从密集的洞窟、佛龛和造像旁走过。周屿仍不肯用一个速度看完：小处他靠近辨认细节，遇到更大的造像又退开寻找整体。到了奉先寺大型造像群前，尺度改变，中央大像与周围造像需要拉开距离才能看出安排。周岚没有给弟弟讲年代，她只不断看签约时间。第一次催，周屿说“马上”；第二次催，他沉默；第三次她说“后面别停了”，周屿问：“你到底是来和我谈，还是只需要我的名字？”周岚列出自己两年来处理的麻烦，又说定金已经交了。周屿听见“已经”，只说：“所以你还是决定完了才来问我。”到奉先寺前，他拿出签字笔，把合同翻到最后一页：“我可以签。你拿到房款，不丢定金。可是签完以后，家里的事你自己决定，别再叫我回来。”笔尖停在签名框上方。周岚终于看清，她最想得到的签字只差一个动作，代价却是弟弟准备退出今后的共同决定。她把合同抽回来，沿中间那道旧折痕把签字页撕成两半。纸裂开的声音很轻，她没有把纸留在山崖下，而是把两半都收进包里：“定金我自己赔。房子今天不卖。”周屿没有说谢谢，只把笔帽重新扣上。两人离开时，原定签约时间已经过去，旧房仍属于两个人，责任怎么分、房子卖不卖，都没有答案。回到伊河边，周屿问：“下次谈房子，你能不能先把所有方案都发给我？”周岚没有保证自己从此会变成另一个人。她只说：“能。”然后摸到包里的两半签字页，没有再拿出来。',
    ],
    vietnamese: <String>[
      'Chu Lam, 42 tuổi, và Chu Dữ, 37 tuổi, đã nhiều năm không cùng nhau đi hết một buổi chiều. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ hai chị em cùng sở hữu bị bỏ trống hai năm. Chu Lam ở lại địa phương, gần như tự xử lý chuyện dột nước, khóa cửa, phí quản lý và môi giới; Chu Dữ làm việc xa, chuyển tiền nhanh nhưng ít về. Trách nhiệm càng tích tụ, Chu Lam càng quen xem trách nhiệm và quyền quyết định là một. Tháng này cô tìm được người mua muốn giao dịch trong ngày và một căn hộ nhỏ gần công ty hơn. Cô đặt cọc không hoàn lại rồi mới gửi hợp đồng cho Chu Dữ: “Về ký là được.” Anh chỉ đáp: “Gặp ở Long Môn.” Khi còn nhỏ, ở hang động Long Môn, Chu Lam luôn muốn đi tới chỗ lớn nhất, còn Chu Dữ đứng lâu trước những hốc nhỏ trên vách. Tuyến đường dọc sông Y và vách đá vôi là một trong số ít ký ức chung cả hai còn nhớ.',
      'Nhiều năm sau, họ lại đi qua những hang động, hốc thờ và tượng dày đặc. Chu Dữ vẫn không dùng một tốc độ: anh tiến gần để xem chi tiết nhỏ, rồi lùi ra trước các tượng lớn. Ở quần thể tượng lớn Phụng Tiên Tự, cần lùi ra mới thấy bố cục của tượng trung tâm và các tượng xung quanh. Chu Lam không giảng cho em về niên đại; cô chỉ liên tục nhìn giờ ký. Sau ba lần bị giục, Chu Dữ hỏi: “Chị đến để nói chuyện với em hay chỉ cần tên em?” Chu Lam kể các rắc rối mình đã xử lý hai năm và nói tiền cọc đã trả. Anh chỉ nói: “Vậy chị vẫn quyết xong rồi mới hỏi em.” Trước Phụng Tiên Tự, Chu Dữ mở hợp đồng ở trang cuối: “Em có thể ký. Chị có tiền bán nhà, không mất cọc. Nhưng ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Ngòi bút dừng trên ô ký. Chu Lam hiểu chữ ký mình muốn chỉ còn cách một động tác, nhưng cái giá là em trai chuẩn bị rời khỏi các quyết định chung trong tương lai. Cô rút hợp đồng, xé đôi trang chữ ký theo nếp gấp cũ. Tiếng giấy rất khẽ; cô cất cả hai nửa vào túi: “Tiền cọc chị tự chịu. Hôm nay không bán nhà.” Chu Dữ không cảm ơn, chỉ đậy nắp bút lại. Khi họ rời đi, giờ ký đã qua, căn nhà vẫn thuộc hai người và chuyện trách nhiệm, bán hay không vẫn chưa có đáp án. Về tới bờ sông Y, Chu Dữ hỏi: “Lần sau nói chuyện căn nhà, chị có thể gửi em tất cả phương án trước không?” Chu Lam không hứa sẽ biến thành một người khác. Cô chỉ nói: “Có.” Rồi cô chạm vào hai nửa trang chữ ký trong túi và không lấy chúng ra nữa.',
    ],
    english: <String>[
      'Forty-two-year-old Zhou Lan and thirty-seven-year-old Zhou Yu have not spent an entire afternoon together in years. After their parents leave Luoyang, the old home they jointly own sits empty for two years. Zhou Lan stays local and handles nearly all leaks, locks, property fees, and agents; Zhou Yu works away, sends money quickly, but seldom returns. As the responsibilities accumulate, Zhou Lan grows used to treating responsibility and decision-making as the same right. This month she finds a buyer ready to close that day and a smaller apartment closer to work. She pays a non-refundable deposit and only then sends Zhou Yu the contract: “Just come back and sign.” He answers only, “Meet me at Longmen.” As children at the Longmen Grottoes, Zhou Lan always wanted to reach the largest place, while Zhou Yu lingered before small niches on the cliffs. The route along the Yi River and limestone cliffs is one of the few shared memories both still hold.',
      'Years later they again pass dense caves, niches, and sculptures. Zhou Yu still refuses to look at everything at one speed: he moves close for small details, then steps back before larger sculpture groups. At Fengxian Temple’s monumental group, more distance is needed to see the arrangement of the central giant figure and surrounding sculptures. Zhou Lan does not lecture her brother about historical periods; she keeps checking the signing time. After being hurried three times, Zhou Yu asks, “Did you come to talk to me, or do you only need my name?” Zhou Lan recounts the problems she has handled for two years and says the deposit is already paid. He says only, “So you still decide first and ask me afterward.” Before Fengxian Temple, Zhou Yu opens the contract to the last page. “I can sign. You get the sale money and keep your deposit. But afterward decide family matters yourself and don’t call me back again.” The pen stops over the signature box. Zhou Lan understands that the signature she wants is only one movement away, but the price is her brother preparing to leave their future shared decisions. She pulls the contract back and tears the signature page in half along its old fold. The sound is soft. She puts both halves in her bag. “I’ll take the deposit loss myself. The house is not being sold today.” Zhou Yu does not thank her; he only caps the pen. When they leave, the scheduled signing time has passed. The home still belongs to both of them, and responsibility and whether to sell remain unresolved. Back beside the Yi River, Zhou Yu asks, “Next time we discuss the house, can you send me all the options first?” Zhou Lan does not promise to become a different person. She says only, “Yes.” Then she touches the two halves of the signature page in her bag and does not take them out again.',
    ],
  ),
];


const longmenGoldPublicationParagraphs = <String>[
  '周岚四十二岁，弟弟周屿三十七岁。父母搬离洛阳后，两人共同拥有的旧房空了两年。修漏水、交物业费、接中介电话，大多是周岚在处理。',
  '她觉得自己承担得多，就该把事情推进得快。这个月她找到愿意成交的买家，又看中一套离公司更近的小房。为了锁定新房，她没等周屿答应就先交了不能退的定金。今天只要两个人在合同上签字，买卖就能继续。',
  '周屿把见面地点定在龙门石窟。两人沿伊河和山崖向前，洞窟与佛龛密集分布。小处他靠近看细节，到了奉先寺大型造像群，又停下来找能看清整体的距离。周岚连着催他。',
  '签约时间快到时，周屿拿出笔：“我可以签。你不会丢定金。但签完以后，家里的事你自己决定，别再叫我回来。”周岚看着打开的笔，忽然把合同抽回来。她沿折痕撕开签字页，把两半都收进包里：“定金我赔。房子今天不卖。”',
];

const _longmenGoldPublicationVietnamese = <String>[
  'Chu Lam 42 tuổi, em trai Chu Dữ 37 tuổi. Sau khi cha mẹ rời Lạc Dương, căn nhà cũ hai người cùng sở hữu bị bỏ trống hai năm. Chu Lam xử lý phần lớn chuyện sửa dột, phí quản lý và các cuộc gọi của môi giới.',
  'Vì cho rằng mình gánh nhiều hơn, cô cũng muốn đẩy mọi việc đi nhanh hơn. Tháng này cô tìm được người mua và một căn hộ nhỏ gần công ty hơn. Để giữ căn mới, cô đặt cọc không hoàn lại trước khi Chu Dữ đồng ý. Chỉ cần hai người ký hôm nay, giao dịch có thể tiếp tục.',
  'Chu Dữ chọn hang động Long Môn làm nơi gặp. Hai người đi dọc sông Y và vách núi, nơi hang động và hốc thờ phân bố dày đặc. Ở chỗ nhỏ anh tiến gần xem chi tiết; tới quần thể tượng lớn Phụng Tiên Tự, anh lại lùi ra tìm khoảng cách để thấy toàn thể. Chu Lam liên tục giục anh.',
  'Khi giờ ký đã gần, Chu Dữ lấy bút ra: “Em có thể ký. Chị sẽ không mất tiền cọc. Nhưng ký xong, việc gia đình chị tự quyết, đừng gọi em về nữa.” Chu Lam nhìn cây bút đang mở rồi bất ngờ rút hợp đồng lại. Cô xé trang chữ ký theo nếp gấp, cất cả hai nửa vào túi: “Tiền cọc chị chịu. Hôm nay không bán nhà.”',
];

const _longmenGoldPublicationEnglish = <String>[
  'Zhou Lan is forty-two and her younger brother Zhou Yu is thirty-seven. After their parents leave Luoyang, the old home they jointly own sits empty for two years. Zhou Lan handles most repairs, property fees, and calls from agents.',
  'Because she carries more of the work, she also believes the process should move faster. This month she finds a buyer and a smaller apartment closer to work. To hold the new place, she pays a non-refundable deposit before Zhou Yu agrees. If both sign today, the sale can continue.',
  'Zhou Yu chooses the Longmen Grottoes as their meeting place. They move along the Yi River and cliffs, where caves and niches are densely distributed. He moves close for small details; at Fengxian Temple’s monumental sculpture group he steps back to find a distance that reveals the whole. Zhou Lan keeps hurrying him.',
  'As the signing time approaches, Zhou Yu takes out a pen. “I can sign. You will not lose your deposit. But afterward, decide family matters yourself and do not call me back again.” Zhou Lan looks at the open pen and suddenly pulls the contract back. She tears the signature page along its fold, puts both halves in her bag, and says, “I’ll take the deposit loss. The house is not being sold today.”',
];

List<ReadingAnnotation> get longmenGoldPublicationAnnotations =>
    List<ReadingAnnotation>.unmodifiable([
      for (var index = 0; index < longmenGoldPublicationParagraphs.length; index++)
        ReadingAnnotation(
          pinyin: PinyinHelper.getPinyinE(
            longmenGoldPublicationParagraphs[index],
            separator: ' ',
            format: PinyinFormat.WITH_TONE_MARK,
          ),
          vietnamese: _longmenGoldPublicationVietnamese[index],
          english: _longmenGoldPublicationEnglish[index],
        ),
    ]);

List<DiscoveryEntry> get longmenGoldPublicationDiscoveries =>
    List<DiscoveryEntry>.unmodifiable(longmenGoldDiscoveries.take(4));

LongmenStoryLevelSpec longmenGoldStoryForLevel(int requestedLevel) =>
    longmenGoldStoryLevels[requestedLevel.clamp(1, 10).toInt() - 1];

List<ReadingAnnotation> longmenGoldStoryAnnotations(int requestedLevel) {
  final spec = longmenGoldStoryForLevel(requestedLevel);
  return List<ReadingAnnotation>.unmodifiable([
    for (var index = 0; index < spec.chinese.length; index++)
      ReadingAnnotation(
        pinyin: PinyinHelper.getPinyinE(
          spec.chinese[index],
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        ),
        vietnamese: spec.vietnamese[index],
        english: spec.english[index],
      ),
  ]);
}

DiscoveryEntry _longmenDiscovery(
  String chinese,
  String vietnamese,
  String english,
) =>
    DiscoveryEntry(
      text: chinese,
      pinyin: PinyinHelper.getPinyinE(
        chinese,
        separator: ' ',
        format: PinyinFormat.WITH_TONE_MARK,
      ),
      simpleChinese: chinese,
      vietnamese: vietnamese,
      english: english,
    );

final longmenGoldDiscoveries = List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
  _longmenDiscovery('龙门石窟分布在伊河两岸的石灰岩山崖上，洞窟和佛龛沿崖展开。', 'Long Môn nằm trên các vách đá vôi ở hai bờ sông Y, với các hang động và hốc thờ trải dọc vách núi.', 'The Longmen Grottoes occupy limestone cliffs on both sides of the Yi River, with caves and niches extending along the rock faces.'),
  _longmenDiscovery('龙门石窟遗产地在伊河两岸约一公里范围内保存两千三百多个洞窟和佛龛，形成连续的崖壁遗产。', 'Trong phạm vi khoảng một kilômét dọc hai bờ sông Y, di sản Long Môn bảo tồn hơn 2.300 hang động và hốc thờ, tạo thành một dải di sản vách đá liên tục.', 'Across roughly one kilometre on both sides of the Yi River, Longmen preserves more than 2,300 caves and niches, forming a continuous cliff-side heritage landscape.'),
  _longmenDiscovery('龙门石窟的重要营造期从北魏晚期延续到唐代，雕刻活动最集中在五世纪末至八世纪中叶。', 'Giai đoạn tạo tác quan trọng của Long Môn kéo dài từ cuối Bắc Ngụy đến đời Đường, với hoạt động chạm khắc tập trung nhất từ cuối thế kỷ 5 đến giữa thế kỷ 8.', 'Longmen’s major period of creation extends from the late Northern Wei through the Tang dynasty, with carving most concentrated from the late fifth to the mid-eighth century.'),
  _longmenDiscovery('不同时期的造像在面容、衣纹、比例和雕刻处理上出现变化，因此龙门保存了佛教石刻艺术风格长期演变的证据。', 'Tượng ở các thời kỳ khác nhau thay đổi về khuôn mặt, nếp áo, tỷ lệ và cách chạm khắc, vì vậy Long Môn lưu giữ bằng chứng về sự phát triển lâu dài của phong cách điêu khắc Phật giáo trên đá.', 'Sculptures from different periods change in facial treatment, drapery, proportion, and carving, so Longmen preserves evidence of the long development of Buddhist stone-carving styles.'),
  _longmenDiscovery('奉先寺的大型造像群以中央大像和周围多尊造像共同组织空间；它的视觉力量来自整组的尺度与安排，而不只是一尊造像。', 'Quần thể tượng lớn Phụng Tiên Tự tổ chức không gian bằng tượng lớn trung tâm cùng nhiều tượng xung quanh; sức mạnh thị giác đến từ quy mô và bố cục của cả nhóm, không chỉ một pho tượng.', 'Fengxian Temple’s monumental group organizes space around a central giant figure and surrounding sculptures; its visual force comes from the scale and arrangement of the group, not from a single figure alone.'),
  _longmenDiscovery('龙门同时包含小型佛龛、洞窟和大型造像群，观看者需要在近距离细节与较远的整体尺度之间不断切换。', 'Long Môn đồng thời có hốc thờ nhỏ, hang động và quần thể tượng lớn, nên người xem phải liên tục chuyển giữa chi tiết ở khoảng cách gần và quy mô tổng thể ở khoảng cách xa hơn.', 'Longmen contains small niches, caves, and monumental sculpture groups, so viewers must adjust their viewing distance, shifting between close-up detail and the larger scale visible from farther away.'),
  _longmenDiscovery('龙门石窟展示了北魏晚期和唐代石刻艺术的发展，也反映佛教文化进入中国后与本土艺术持续互动形成的变化。', 'Long Môn cho thấy sự phát triển của nghệ thuật chạm khắc đá cuối Bắc Ngụy và đời Đường, đồng thời phản ánh những thay đổi hình thành qua sự tương tác lâu dài giữa văn hóa Phật giáo và nghệ thuật bản địa Trung Quốc.', 'Longmen shows the development of stone carving in the late Northern Wei and Tang periods and reflects changes formed through sustained interaction between Buddhist culture and Chinese artistic traditions.'),
  _longmenDiscovery('单个洞窟、佛龛以及奉先寺等大型造像群并不是孤立遗物；它们与伊河、两岸山崖共同组成一个整体遗产景观。', 'Các hang động, hốc thờ riêng lẻ và quần thể lớn như Phụng Tiên Tự không phải di tích cô lập; cùng sông Y và vách núi hai bờ, chúng tạo thành một cảnh quan di sản thống nhất.', 'Individual caves, niches, and monumental groups such as Fengxian Temple are not isolated remains; together with the Yi River and the cliffs on both banks, they form one integrated heritage landscape.'),
  _longmenDiscovery('龙门石窟以数量、规模和跨时代的石刻作品记录中国佛教艺术与石雕发展的重要阶段，并对亚洲其他地区产生影响。', 'Với số lượng, quy mô và tác phẩm đá trải qua nhiều thời kỳ, Long Môn ghi lại những giai đoạn quan trọng của nghệ thuật Phật giáo và điêu khắc đá Trung Quốc, đồng thời có ảnh hưởng tới các khu vực khác ở châu Á.', 'Through its quantity, scale, and stone works across different periods, Longmen records important stages in Chinese Buddhist art and stone carving and influenced other parts of Asia.'),
  _longmenDiscovery('龙门石窟的世界遗产价值依赖完整的洞窟、佛龛、造像及其山崖与河谷环境；真实性和保护因此不能只针对少数著名大像，而要维护整个遗产地。', 'Giá trị Di sản Thế giới của Long Môn phụ thuộc vào tính toàn vẹn của hang động, hốc thờ, tượng cùng môi trường vách núi và thung lũng sông; vì vậy tính xác thực và bảo tồn không thể chỉ tập trung vào vài tượng lớn nổi tiếng mà phải gìn giữ toàn bộ di sản.', 'Longmen’s World Heritage value depends on the integrity of its caves, niches, sculptures, cliffs, and river-valley setting; authenticity and conservation therefore cannot focus only on a few famous monumental figures but must protect the heritage property as a whole.'),
]);


final longmenGoldDiscoveryLevels =
    List<List<DiscoveryEntry>>.unmodifiable(<List<DiscoveryEntry>>[
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门石窟分布在伊河两岸的石灰岩山崖上，洞窟和佛龛沿崖展开。',
      'Long Môn phân bố trên các vách đá vôi ở hai bờ sông Y, với các hang động và hốc thờ trải dọc vách núi.',
      'The Longmen Grottoes occupy limestone cliffs on both sides of the Yi River, with caves and niches extending along the rock faces.',
    ),
    _longmenDiscovery(
      '伊河从两侧山崖之间穿过，洞窟和佛龛直接开凿在石灰岩崖壁中，因此河流、山崖和石窟属于同一遗址空间。',
      'Sông Y chảy giữa các vách núi hai bên; hang động và hốc thờ được đục trực tiếp vào vách đá vôi, nên sông, vách núi và hang động cùng thuộc một không gian di sản.',
      'The Yi River runs between the cliffs on both sides; caves and niches are cut directly into the limestone faces, so the river, cliffs, and grottoes belong to one heritage setting.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门石窟遗产地在伊河两岸约一公里范围内保存两千三百多个洞窟和佛龛，形成连续的崖壁遗产。',
      'Trong phạm vi khoảng một kilômét dọc hai bờ sông Y, di sản Long Môn bảo tồn hơn 2.300 hang động và hốc thờ, tạo thành một dải di sản vách đá liên tục.',
      'Across roughly one kilometre on both sides of the Yi River, Longmen preserves more than 2,300 caves and niches, forming a continuous cliff-side heritage landscape.',
    ),
    _longmenDiscovery(
      '这两千三百多个洞窟和佛龛并非集中在一个点，而是沿约一公里的崖壁连续分布；数量与整段崖壁的范围要一起理解。',
      'Hơn 2.300 hang động và hốc thờ này không tập trung tại một điểm mà phân bố liên tục dọc khoảng một kilômét vách núi; số lượng cần được hiểu cùng với quy mô của cả dải vách đá.',
      'These more than 2,300 caves and niches are not concentrated at one point but extend continuously along roughly one kilometre of cliff; the count belongs to the scale of the whole stretch.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门石窟的重要营造期从北魏晚期延续到唐代，最密集的雕刻集中在五世纪末至八世纪中叶。',
      'Giai đoạn tạo tác quan trọng của Long Môn kéo dài từ cuối Bắc Ngụy đến đời Đường, với hoạt động chạm khắc tập trung nhất từ cuối thế kỷ 5 đến giữa thế kỷ 8.',
      'Longmen’s major period of creation extends from the late Northern Wei through the Tang dynasty, with carving most concentrated from the late fifth to the mid-eighth century.',
    ),
    _longmenDiscovery(
      '北魏晚期和初唐时期，洛阳都曾具有都城地位；龙门最密集的营造时间也落在这一长时段内。',
      'Vào cuối Bắc Ngụy và đầu đời Đường, Lạc Dương đều từng giữ vị thế kinh đô; giai đoạn tạo tác dày đặc nhất ở Long Môn cũng nằm trong khoảng thời gian dài này.',
      'Luoyang held capital status in the late Northern Wei and early Tang periods, and the most intensive phase of carving at Longmen also falls within this long span.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '不同时期的造像在面容、衣纹、比例和雕刻处理上出现变化，因此龙门保存了佛教石刻艺术风格长期演变的证据。',
      'Tượng ở các thời kỳ khác nhau thay đổi về khuôn mặt, nếp áo, tỷ lệ và cách chạm khắc, vì vậy Long Môn lưu giữ bằng chứng về sự phát triển lâu dài của phong cách điêu khắc Phật giáo trên đá.',
      'Sculptures from different periods change in facial treatment, drapery, proportion, and carving, so Longmen preserves evidence of the long development of Buddhist stone-carving styles.',
    ),
    _longmenDiscovery(
      '龙门同时保存较早的“中原风格”和后来的“盛唐风格”，把不同时期的雕塑放在同一遗址中对照，可以看见石刻艺术并非固定不变。',
      'Long Môn cùng bảo tồn phong cách Trung Nguyên sớm hơn và phong cách Thịnh Đường muộn hơn; đặt tác phẩm các thời kỳ cạnh nhau trong cùng di sản cho thấy nghệ thuật chạm khắc đá không hề bất biến.',
      'Longmen preserves both the earlier Central China Style and the later Great Tang Style; comparing works from different periods at one site shows that stone-carving style was not fixed.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '奉先寺的巨型造像是唐代皇家石窟艺术最具代表性的实例之一，说明龙门不仅有小型佛龛，也有大型造像群。',
      'Những tượng khổng lồ ở Phụng Tiên Tự là một trong những ví dụ tiêu biểu nhất của nghệ thuật hang động hoàng gia đời Đường, cho thấy Long Môn không chỉ có hốc thờ nhỏ mà còn có các quần thể tượng quy mô lớn.',
      'The giant sculptures at Fengxian Temple are among the most representative examples of Tang royal cave-temple art, showing that Longmen contains not only small niches but also monumental sculpture groups.',
    ),
    _longmenDiscovery(
      '奉先寺的大型造像群以中央大像和周围多尊造像共同组织空间；它的视觉力量来自整组的尺度与安排，而不只是一尊造像。',
      'Quần thể tượng lớn Phụng Tiên Tự tổ chức không gian bằng tượng lớn trung tâm cùng nhiều tượng xung quanh; sức mạnh thị giác đến từ quy mô và bố cục của cả nhóm, không chỉ một pho tượng.',
      'Fengxian Temple’s monumental group organizes space around a central giant figure and surrounding sculptures; its visual force comes from the scale and arrangement of the group, not from a single figure alone.',
    ),
    _longmenDiscovery(
      '阅读奉先寺时，既要看单尊造像，也要把中央与周围造像放回同一布局；否则会失去大型造像群的整体安排。',
      'Khi đọc Phụng Tiên Tự, cần nhìn từng tượng nhưng cũng phải đặt tượng trung tâm và các tượng xung quanh trở lại trong cùng một bố cục; nếu không sẽ mất cách tổ chức tổng thể của quần thể tượng lớn.',
      'To read Fengxian, a viewer needs to study individual figures while also placing the central and surrounding sculptures within one layout; otherwise the organization of the monumental group is lost.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门同时包含小型佛龛、洞窟和大型造像群，观看对象本身就存在明显的尺度差异。',
      'Long Môn đồng thời có hốc thờ nhỏ, hang động và các quần thể tượng lớn, vì vậy bản thân đối tượng quan sát đã có khác biệt rõ rệt về quy mô.',
      'Longmen contains small niches, caves, and monumental sculpture groups, so the objects themselves differ clearly in scale.',
    ),
    _longmenDiscovery(
      '靠近小型佛龛或洞窟时，观看重点可以落在较小造像和局部雕刻细节；近距离帮助辨认这些小尺度信息。',
      'Khi đến gần hốc thờ nhỏ hoặc hang động, trọng tâm có thể đặt vào các tượng nhỏ hơn và chi tiết chạm khắc cục bộ; khoảng cách gần giúp nhận ra thông tin ở quy mô nhỏ này.',
      'Near a small niche or cave, attention can focus on smaller figures and local carving details; close viewing helps reveal information at that small scale.',
    ),
    _longmenDiscovery(
      '面对奉先寺等大型造像群，拉开距离更容易把中央与周围造像纳入同一视野；对象尺度改变，合适的观看距离也随之改变。',
      'Với quần thể tượng lớn như Phụng Tiên Tự, lùi xa giúp đưa tượng trung tâm và các tượng xung quanh vào cùng một tầm nhìn; khi quy mô đối tượng thay đổi, khoảng cách xem phù hợp cũng thay đổi.',
      'For a monumental group such as Fengxian, stepping farther back makes it easier to hold the central and surrounding figures in one view; as the scale of the object changes, the useful viewing distance changes too.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门石窟的造像都以佛教为题材，但这些作品是在中国石刻传统中持续发展的。',
      'Các tượng ở Long Môn đều lấy Phật giáo làm đề tài, nhưng các tác phẩm này tiếp tục phát triển trong truyền thống chạm khắc đá của Trung Quốc.',
      'The sculptures at Longmen are devoted to Buddhist subjects, but these works continued to develop within Chinese stone-carving traditions.',
    ),
    _longmenDiscovery(
      '从北魏晚期到唐代，雕塑风格不断变化，说明佛教题材在中国并没有保持单一固定的表现方式。',
      'Từ cuối Bắc Ngụy đến đời Đường, phong cách điêu khắc liên tục thay đổi, cho thấy đề tài Phật giáo ở Trung Quốc không giữ một cách thể hiện cố định duy nhất.',
      'From the late Northern Wei through the Tang, sculptural styles kept changing, showing that Buddhist subjects in China did not remain in a single fixed form.',
    ),
    _longmenDiscovery(
      '龙门把佛教宗教内容与中国本土雕塑风格的长期演变放在同一遗址中，因此能观察两者如何持续互动。',
      'Long Môn đặt nội dung tôn giáo Phật giáo cùng với sự phát triển lâu dài của phong cách điêu khắc bản địa Trung Quốc trong một di sản, vì thế có thể quan sát cách hai yếu tố này tương tác liên tục.',
      'Longmen places Buddhist religious content and the long development of local Chinese sculptural styles within one site, making their continued interaction visible.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '单个洞窟、佛龛以及奉先寺等大型造像群并不是孤立遗物；它们与伊河、两岸山崖共同组成一个整体遗产景观。',
      'Các hang động, hốc thờ riêng lẻ và quần thể lớn như Phụng Tiên Tự không phải di tích cô lập; cùng sông Y và vách núi hai bờ, chúng tạo thành một cảnh quan di sản thống nhất.',
      'Individual caves, niches, and monumental groups such as Fengxian Temple are not isolated remains; together with the Yi River and the cliffs on both banks, they form one integrated heritage landscape.',
    ),
    _longmenDiscovery(
      '世界遗产的完整性不仅看洞窟和造像，也看东山、西山及河谷环境是否被整体保存；人工开凿与自然地貌共同构成遗产。',
      'Tính toàn vẹn của Di sản Thế giới không chỉ xét các hang động và tượng mà còn xem Đông Sơn, Tây Sơn và môi trường thung lũng có được bảo tồn như một tổng thể hay không; công trình do con người tạo ra và địa hình tự nhiên cùng cấu thành di sản.',
      'World Heritage integrity concerns not only caves and sculptures but also whether East Hill, West Hill, and the river-valley setting are preserved as a whole; human carving and natural landforms together form the heritage property.',
    ),
    _longmenDiscovery(
      '因此理解龙门可以依次连接三个尺度：单个洞窟或佛龛、大型造像群、以及伊河与两岸山崖组成的整体环境。',
      'Vì vậy, có thể hiểu Long Môn bằng cách nối ba quy mô: một hang động hoặc hốc thờ riêng lẻ, một quần thể tượng lớn, và toàn bộ môi trường do sông Y cùng các vách núi hai bờ tạo nên.',
      'Longmen can therefore be read across three connected scales: an individual cave or niche, a monumental sculpture group, and the larger setting formed by the Yi River and cliffs on both banks.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门数量众多、尺度多样、跨越多个时期的石刻作品，记录了中国佛教艺术和石雕发展的重要阶段。',
      'Các tác phẩm chạm khắc đá ở Long Môn với số lượng lớn, quy mô đa dạng và trải qua nhiều thời kỳ ghi lại những giai đoạn quan trọng của nghệ thuật Phật giáo và điêu khắc đá Trung Quốc.',
      'The many stone works at Longmen, varied in scale and spanning multiple periods, record important stages in the development of Chinese Buddhist art and stone carving.',
    ),
    _longmenDiscovery(
      '龙门较早和较晚的代表性雕塑风格不仅影响中国其他地区，也对亚洲其他地区的雕塑艺术发展产生重要影响。',
      'Các phong cách điêu khắc tiêu biểu sớm và muộn ở Long Môn không chỉ ảnh hưởng đến những vùng khác của Trung Quốc mà còn tác động quan trọng đến sự phát triển điêu khắc ở các khu vực khác của châu Á.',
      'The representative earlier and later sculptural styles at Longmen influenced other parts of China and also made an important contribution to the development of sculpture in other parts of Asia.',
    ),
    _longmenDiscovery(
      '因此龙门的意义不只在作品数量，还在于它把中国石刻风格的长期发展与更广泛的亚洲艺术传播联系起来。',
      'Vì vậy, ý nghĩa của Long Môn không chỉ nằm ở số lượng tác phẩm mà còn ở việc kết nối sự phát triển lâu dài của phong cách chạm khắc đá Trung Quốc với sự lan truyền nghệ thuật rộng hơn ở châu Á.',
      'Longmen matters not only for the number of works but also because it connects the long development of Chinese stone-carving styles with wider artistic transmission across Asia.',
    ),
  ]),
  List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
    _longmenDiscovery(
      '龙门作为世界遗产，其价值依赖洞窟、佛龛、造像、山崖和河谷环境作为整体被理解和保存。',
      'Là một Di sản Thế giới, giá trị của Long Môn phụ thuộc vào việc các hang động, hốc thờ, tượng, vách núi và môi trường thung lũng được hiểu và bảo tồn như một tổng thể.',
      'As a World Heritage property, the value of Longmen depends on its caves, niches, sculptures, cliffs, and river-valley setting being understood and preserved as a whole.',
    ),
    _longmenDiscovery(
      '完整性关注遗产要素与自然环境是否整体保存；真实性还包括布局、材料、传统技术、位置以及各要素之间的内在联系。',
      'Tính toàn vẹn xem các yếu tố di sản và môi trường tự nhiên có được bảo tồn như một tổng thể hay không; tính xác thực còn bao gồm bố cục, vật liệu, kỹ thuật truyền thống, vị trí và mối liên hệ nội tại giữa các yếu tố.',
      'Integrity concerns whether heritage elements and the natural setting are preserved as a whole; authenticity also includes layout, material, traditional technique, location, and the intrinsic links among those elements.',
    ),
    _longmenDiscovery(
      '保护不能只围绕少数著名大像，而要覆盖整个遗产地及其环境，并通过长期管理减少损害。',
      'Bảo tồn không thể chỉ xoay quanh một vài tượng lớn nổi tiếng mà phải bao phủ toàn bộ khu di sản và môi trường của nó, đồng thời giảm tổn hại bằng quản lý lâu dài.',
      'Conservation cannot focus only on a few famous monumental figures; it must cover the whole heritage property and its setting and reduce harm through long-term management.',
    ),
  ]),
]);

List<DiscoveryEntry> longmenGoldDiscoveriesForLevel(int requestedLevel) =>
    longmenGoldDiscoveryLevels[requestedLevel.clamp(1, 10).toInt() - 1];


const longmenGoldWords = <WordEntry>[
  WordEntry(word: '签字', pinyin: 'qiānzì', simpleChinese: '在文件上写下名字表示同意。', translation: 'ký tên', englishDefinition: 'to sign a document', symbol: '✍️'),
  WordEntry(word: '定金', pinyin: 'dìngjīn', simpleChinese: '为了确认交易先支付的一笔钱。', translation: 'tiền đặt cọc', englishDefinition: 'a deposit paid to secure a transaction', symbol: '💰'),
  WordEntry(word: '伊河', pinyin: 'Yī Hé', simpleChinese: '流经龙门石窟之间的河流。', translation: 'sông Y', englishDefinition: 'the Yi River', symbol: '🌊'),
  WordEntry(word: '山崖', pinyin: 'shānyá', simpleChinese: '陡峭的山壁。', translation: 'vách núi', englishDefinition: 'cliff', symbol: '⛰️'),
  WordEntry(word: '石窟', pinyin: 'shíkū', simpleChinese: '在岩石山体中开凿出的洞窟。', translation: 'hang đá', englishDefinition: 'rock-cut grotto', symbol: '🪨'),
  WordEntry(word: '洞窟', pinyin: 'dòngkū', simpleChinese: '开在岩壁中的洞穴空间。', translation: 'hang động', englishDefinition: 'cave or grotto', symbol: '🕳️'),
  WordEntry(word: '佛龛', pinyin: 'fókān', simpleChinese: '安置佛教造像的小型龛室。', translation: 'hốc thờ Phật', englishDefinition: 'Buddhist image niche', symbol: '🙏'),
  WordEntry(word: '奉先寺', pinyin: 'Fèngxiān Sì', simpleChinese: '龙门石窟著名的大型造像群区域。', translation: 'Phụng Tiên Tự', englishDefinition: 'Fengxian Temple', symbol: '🏛️'),
  WordEntry(word: '造像', pinyin: 'zàoxiàng', simpleChinese: '制作出来的宗教人物形象。', translation: 'tượng tạo tác', englishDefinition: 'sculpted religious image', symbol: '🗿'),
  WordEntry(word: '整体', pinyin: 'zhěngtǐ', simpleChinese: '由多个部分组成的完整对象。', translation: 'toàn thể', englishDefinition: 'the whole; overall form', symbol: '🧩'),
  WordEntry(word: '细节', pinyin: 'xìjié', simpleChinese: '较小但能影响理解的部分。', translation: 'chi tiết', englishDefinition: 'detail', symbol: '🔎'),
  WordEntry(word: '合同', pinyin: 'hétong', simpleChinese: '规定双方权利和义务的书面约定。', translation: 'hợp đồng', englishDefinition: 'contract', symbol: '📄'),
  WordEntry(word: '决定', pinyin: 'juédìng', simpleChinese: '在多个可能中作出选择。', translation: 'quyết định', englishDefinition: 'decision; to decide', symbol: '⚖️'),
  WordEntry(word: '代价', pinyin: 'dàijià', simpleChinese: '为了得到某种结果必须承担的损失。', translation: 'cái giá', englishDefinition: 'cost or price of a choice', symbol: '🪙', examples: <WordExample>[WordExample(chinese: '周岚明白，拿到签字的代价可能是弟弟退出今后的共同决定。', pinyin: 'Zhōu Lán míngbai, ná dào qiānzì de dàijià kěnéng shì dìdi tuìchū jīnhòu de gòngtóng juédìng.', vietnamese: 'Chu Lam hiểu rằng cái giá của việc có được chữ ký có thể là em trai rút khỏi những quyết định chung sau này.', english: 'Zhou Lan understands that the cost of getting the signature may be her brother withdrawing from future shared decisions.')]),
  WordEntry(word: '折痕', pinyin: 'zhéhén', simpleChinese: '纸被折过后留下的线。', translation: 'nếp gấp', englishDefinition: 'crease left by folding', symbol: '📃'),
  WordEntry(word: '共同', pinyin: 'gòngtóng', simpleChinese: '由两个人或更多人一起拥有或承担。', translation: 'chung; cùng nhau', englishDefinition: 'shared; jointly', symbol: '🤝'),
  WordEntry(word: '石灰岩', pinyin: 'shíhuīyán', simpleChinese: '一种常见的沉积岩，龙门山崖的重要岩性。', translation: 'đá vôi', englishDefinition: 'limestone', symbol: '🪨'),
  WordEntry(word: '风格', pinyin: 'fēnggé', simpleChinese: '艺术作品稳定而可辨认的表现特点。', translation: 'phong cách', englishDefinition: 'artistic style', symbol: '🎨'),
  WordEntry(word: '世界遗产', pinyin: 'Shìjiè Yíchǎn', simpleChinese: '被列入联合国教科文组织世界遗产名录的遗产。', translation: 'Di sản Thế giới', englishDefinition: 'World Heritage', symbol: '🌏'),
  WordEntry(word: '保护', pinyin: 'bǎohù', simpleChinese: '采取措施避免遗产受到损害。', translation: 'bảo tồn; bảo vệ', englishDefinition: 'to protect or conserve', symbol: '🛡️'),
];

const longmenGoldVocabularyTargets = <int>[4, 5, 6, 7, 9, 10, 11, 14, 15, 16];

List<WordEntry> longmenGoldVocabularyForLevel(
  int requestedLevel, {
  Set<String> knownWords = const <String>{},
}) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final story = longmenGoldStoryForLevel(level).chinese.join();
  final discovery = longmenGoldDiscoveriesForLevel(level)
      .map((entry) => entry.text)
      .join();
  final visible = longmenGoldWords
      .where((entry) => story.contains(entry.word) || discovery.contains(entry.word))
      .toList(growable: false);
  final target = longmenGoldVocabularyTargets[level - 1];
  if (visible.length < target) {
    throw StateError(
      'Longmen Lv$level has only ${visible.length} visible vocabulary items for target $target.',
    );
  }

  final unknown = visible.where((entry) => !knownWords.contains(entry.word)).toList();
  final review = visible.where((entry) => knownWords.contains(entry.word)).toList();
  final selected = <WordEntry>[];

  for (final entry in unknown) {
    if (selected.length >= target) break;
    selected.add(entry);
  }

  if (review.isNotEmpty) {
    final reviewSlots = ((target * .25).round()).clamp(1, target);
    final reviewItems = review.take(reviewSlots).toList(growable: false);
    while (selected.length + reviewItems.length > target && selected.isNotEmpty) {
      selected.removeLast();
    }
    for (final entry in reviewItems) {
      if (!selected.any((item) => item.word == entry.word)) selected.add(entry);
    }
  }

  for (final entry in visible) {
    if (selected.length >= target) break;
    if (!selected.any((item) => item.word == entry.word)) selected.add(entry);
  }
  return List<WordEntry>.unmodifiable(selected.take(target));
}
