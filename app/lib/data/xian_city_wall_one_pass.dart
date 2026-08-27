import 'package:pinyin/pinyin.dart';

import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const xianCityWallJourneyId = 'xian-city-wall';

class XianNarrativeDna {
  const XianNarrativeDna({
    required this.narrativeIdentity,
    required this.protagonistArchetype,
    required this.storyGoal,
    required this.conflictType,
    required this.climaxType,
    required this.resolutionType,
    required this.memoryAnchorType,
    required this.movementPattern,
    required this.temporalPattern,
    required this.supportingStructure,
    required this.endingMechanism,
    required this.centralMetaphor,
  });
  final String narrativeIdentity;
  final String protagonistArchetype;
  final String storyGoal;
  final String conflictType;
  final String climaxType;
  final String resolutionType;
  final String memoryAnchorType;
  final String movementPattern;
  final String temporalPattern;
  final String supportingStructure;
  final String endingMechanism;
  final String centralMetaphor;
}

const xianCityWallNarrativeDna = XianNarrativeDna(
  narrativeIdentity: 'last-wall-lap-becomes-continuing-home-route',
  protagonistArchetype: 'local-young-mover-and-distance-runner',
  storyGoal: 'complete-one-final-wall-circuit-before-family-relocation',
  conflictType: 'relocation-belonging-vs-address-change',
  climaxType: 'completed-lap-but-running-watch-deliberately-keeps-going',
  resolutionType: 'closed-circuit-extends-into-new-home-route',
  memoryAnchorType: 'unpaused-running-record-at-yongning-gate',
  movementPattern: 'closed-wall-circuit-then-outbound-street-continuation',
  temporalPattern: 'late-afternoon-to-sunset-to-evening-to-city-lights',
  supportingStructure: 'family-messages-without-mentor-or-explainer',
  endingMechanism: 'route-record-saved-and-named-home-next-morning',
  centralMetaphor: 'a-closed-fortification-can-contain-an-open-lived-route',
);

class XianDiscoverySpec {
  const XianDiscoverySpec({
    required this.level,
    required this.title,
    required this.storyLink,
    required this.entry,
    required this.keyTerms,
    required this.learnerInsight,
    required this.check,
    required this.answer,
    required this.sourceIds,
  });
  final int level;
  final String title;
  final String storyLink;
  final DiscoveryEntry entry;
  final List<String> keyTerms;
  final String learnerInsight;
  final String check;
  final String answer;
  final List<String> sourceIds;
}

class XianChallengeSpec {
  const XianChallengeSpec({
    required this.level,
    required this.type,
    required this.anchor,
    required this.answer,
  });
  final int level;
  final String type;
  final String anchor;
  final String answer;
}

class XianCompleteSpec {
  const XianCompleteSpec({
    required this.journeySummary,
    required this.achievement,
    required this.memoryAnchor,
    required this.anchorMeaning,
    required this.challengeReward,
    required this.rewardMeaning,
    required this.rewardUnlockText,
    required this.journeyCompletion,
  });
  final String journeySummary;
  final String achievement;
  final String memoryAnchor;
  final String anchorMeaning;
  final String challengeReward;
  final String rewardMeaning;
  final String rewardUnlockText;
  final String journeyCompletion;
}

const _xianStoryVietnamese = <List<String>>[
  <String>['Chu Dao, 22 tuổi, lớn lên trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu trên đồng hồ chạy bộ và muốn chạy trọn một vòng, coi con đường quen thuộc này là lời chia tay cuối cùng. Hoàng hôn chiếu lên gạch đá; những con phố bên trong thành và những con đường bên ngoài cùng sáng lên. Mẹ nhắn rằng xe chuyển nhà đã tới và bảo cậu chạy xong thì đến nhà mới ăn cơm. Mỗi khi qua một góc tường hay cổng thành, Chu Dao cứ nghĩ: sau khi chuyển ra ngoài, mình còn được xem là “người trong thành” nữa không? Đêm xuống, cậu trở lại cổng Vĩnh Ninh, đồng hồ vừa ghi đủ một vòng. Cậu không bấm dừng mà xuống thành, tiếp tục chạy về phía nam. Tường thành phía sau bật sáng, còn quãng đường trên đồng hồ vẫn tăng.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu trên đồng hồ chạy bộ và quyết định chạy trọn một vòng, coi đó là lần “chạy quanh thành” cuối cùng trước khi chuyển nhà. Hoàng hôn kéo dài bóng trên gạch đá; nhìn vào trong là phố cũ, nhìn ra ngoài là dòng xe và khu đô thị mới xa hơn. Mẹ gửi tin nhắn thoại rằng xe chuyển nhà đã tới nhà mới và cơm cũng sắp xong. Chu Dao tiếp tục chạy, đi qua các cổng và góc tường, nhưng trong lòng càng lúc càng vướng: nếu địa chỉ thay đổi, quan hệ giữa cậu và khu thành cũ có phải cũng kết thúc không? Trời tối dần, cậu lại nhìn thấy cổng Vĩnh Ninh và đồng hồ hoàn thành một vòng. Lẽ ra đây phải là điểm cuối. Chu Dao giơ tay nhìn một chút nhưng không bấm dừng; cậu xuống thành và chạy tiếp theo con đường phía nam tới nhà mới. Ánh đèn tường thành phía sau nối thành một vòng, còn con số trên đồng hồ vượt qua vòng ấy.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu trên đồng hồ và muốn chạy trọn một vòng để làm lời chia tay trước khi chuyển nhà. Hoàng hôn kéo dài bóng trên gạch đá; bên trong là những con phố quen thuộc, bên ngoài là dòng xe và khu nhà mới. Mẹ nhắn thoại rằng xe chuyển nhà đã tới và bữa cơm đầu tiên ở nhà mới đang chờ cậu. Chu Dao tiếp tục chạy nhưng lại tin chắc rằng một khi địa chỉ đổi, cuộc sống cũ cũng sẽ kết thúc ngay tại cổng thành.', 'Trời tối dần. Cậu qua các góc tường và cổng thành rồi trở lại cổng Vĩnh Ninh. Đồng hồ ghi đủ một vòng và màn hình bật thông báo. Lẽ ra đây phải là điểm cuối, nhưng mẹ gửi một bức ảnh từ ban công nhà mới, trong đó từ xa vẫn thấy ánh đèn tường thành. Chu Dao nhìn đồng hồ nhưng không bấm dừng. Cậu xuống thành, tiếp tục chạy về phía nam và băng qua những nút giao đông đúc giờ cao điểm. Tường thành phía sau nối thành một vòng sáng, còn quãng đường trên đồng hồ vẫn tiếp tục tăng.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành Tây An từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng, coi tuyến vòng dài hơn mười ba kilômét này là lời chia tay chính thức cuối cùng trước khi chuyển nhà. Mặt trời hạ thấp, gạch đá và lầu cổng đổ bóng dài. Nhìn vào trong là những phố ngõ, sân nhà và mùi cơm tối quen thuộc; nhìn ra ngoài là dòng xe, lối vào tàu điện ngầm và các khu nhà mới tiếp tục mở rộng. Mẹ nhắn thoại rằng xe chuyển nhà đã tới và bữa cơm đầu tiên ở nhà mới đang đợi cậu. Chu Dao chỉ trả lời “được” rồi tiếp tục chạy. Cậu vẫn luôn nghĩ rằng rời khỏi bên trong tường thành đồng nghĩa với rời khu thành cũ, và cuộc sống của mình sẽ bị cắt làm hai ở một cổng thành nào đó.', 'Bầu trời từ cam chuyển sang xanh thẫm. Cậu chạy qua các góc tường, cổng thành và mặt tường rộng. Phần tường thành Tây An còn lại hiện nay chủ yếu hình thành vào thời Minh và về sau tiếp tục được tu bổ; những công trình phòng thủ trước kia hôm nay vẫn được bảo vệ và đi vào đời sống công cộng của thành phố. Chu Dao nhớ hồi nhỏ từng đạp xe dưới chân thành và sau này thường tới chạy bộ; những ký ức ấy vốn không chỉ nằm ở bên trong tường. Khi trở lại cổng Vĩnh Ninh, đồng hồ hoàn thành một vòng và màn hình sáng lên báo hiệu. Lẽ ra đây phải là điểm cuối, nhưng mẹ lại gửi ảnh từ ban công nhà mới, nơi từ xa có thể nhìn thấy tường thành đang sáng đèn. Chu Dao không bấm dừng. Cậu xuống thành, tiếp tục chạy về phía nam và băng qua những nút giao đông đúc. Ánh đèn tường thành phía sau khép thành một vòng, còn quãng đường trên đồng hồ vượt ra ngoài vòng ấy.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu biến tuyến vòng dài hơn mười ba kilômét thành một nghi thức chia tay riêng: đưa đồng hồ về số không, chạy quanh thành một vòng rồi kết thúc ở cổng Vĩnh Ninh, như thể nhờ vậy có thể cất gọn “cuộc sống trong thành”. Hoàng hôn nghiêng qua tường phía nam, để lại bóng dài của gạch đá, lỗ châu mai và lầu cổng. Bên trong là phố ngõ, sân nhà và hướng Tháp Chuông quen thuộc; bên ngoài là dòng xe, lối vào tàu điện ngầm và đô thị hiện đại đang mở rộng. Mẹ nhắn rằng xe chuyển nhà đã tới và bữa cơm đầu tiên ở nhà mới đang chờ. Chu Dao chỉ trả lời “được”. Cậu tiếp tục chạy nhưng cứ nghĩ mãi: một khi địa chỉ vượt qua tường thành, liệu mối quan hệ giữa mình và khu thành cũ có kết thúc ngay tại cổng thành không?', 'Trời từ vàng chuyển sang xanh thẫm. Cậu chạy theo tuyến tường thành hình chữ nhật khép kín, qua các góc và cổng. Phần tường thành còn lại đạt quy mô chủ yếu hiện nay vào thời Hồng Vũ nhà Minh và sau đó tiếp tục được tu bổ; thân tường, cổng và hào là những bộ phận của một di sản cần được bảo vệ lâu dài. Chu Dao không coi những điều ấy là lời thuyết minh. Cậu nhớ hồi nhỏ học đạp xe bên hào, và trước kỳ thi đại học từng chạy chậm gần Nam Môn; cuộc sống của cậu từ lâu đã liên tục đi qua các cổng thành. Khi lại nhìn thấy cổng Vĩnh Ninh, đồng hồ rung báo “hoàn thành mục tiêu” sau đủ một vòng. Lẽ ra đây là điểm cuối. Đúng lúc ấy mẹ gửi ảnh ban công nhà mới, trong đêm vẫn thấy ánh đèn tường thành ở xa. Chu Dao dừng nửa bước nhưng không bấm dừng; cậu xuống thành và chạy tiếp theo đường phía nam về nhà mới. Những dải đèn phía sau bao quanh khu thành cũ, còn con số trên đồng hồ vượt qua một vòng hoàn chỉnh.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu cố ý đặt tuyến vòng khoảng 13,74 kilômét này thành “lần chạy quanh thành cuối cùng”: xuất phát từ Nam Môn, chạy hết một vòng khép kín theo tường rồi trở về điểm đầu, cất cuộc sống trong thành như một bản ghi tập luyện. Hoàng hôn hạ xuống bên lầu cổng, kéo dài bóng gạch đá, nữ tường và lỗ châu mai. Bên trong là phố ngõ và sân nhà quen thuộc; bên ngoài là dòng xe, tuyến tàu điện ngầm và những khu nhà mới xa hơn. Mẹ nhắn rằng xe chuyển nhà đã dỡ xong và bữa cơm đầu tiên ở nhà mới đang chờ cậu. Chu Dao chỉ trả lời “được”. Cậu tiếp tục chạy nhưng trong lòng vẫn cố chấp biến thay đổi địa chỉ thành thay đổi thân phận: sau khi chuyển ra ngoài tường, liệu mình có còn thuộc về khu thành cũ không?', 'Bóng tối dần phủ xuống. Cậu chạy qua những cổng và góc tường ở các hướng khác nhau. Phần tường thành Tây An còn lại chủ yếu hình thành từ năm Hồng Vũ thứ bảy đến thứ mười một trên nền tường đô thị sớm hơn; thân tường, cổng, công trình phụ và hào thuộc đối tượng được bảo vệ như một chỉnh thể. Trước kia, mặt tường rộng phục vụ phòng thủ, tuần tra và điều động người cùng vật tư; ngày nay tuyến vòng này còn phục vụ bảo tồn, trưng bày và hoạt động công cộng. Chu Dao không dừng lại để học thuộc niên đại. Cậu nhớ hồi nhỏ đạp xe trong công viên vành đai, thời trung học ngồi xe từ trong thành ra ngoài học thêm, rồi những năm gần đây thường lấy tường thành làm mốc chạy bộ. Những tuyến đời sống ấy chưa bao giờ đứt ở cổng thành. Khi đêm hẳn, cậu trở lại cổng Vĩnh Ninh; đồng hồ rung báo đã đủ một vòng. Mẹ vừa lúc gửi ảnh ban công nhà mới, xa xa tường thành vừa lên đèn. Chu Dao giơ tay, vốn có thể bấm dừng nhưng lại rời ngón tay khỏi nút. Cậu xuống thành, tiếp tục chạy về phía nam và băng qua giờ cao điểm. Dải đèn phía sau khép thành một vòng, còn quãng đường trên đồng hồ vẫn kéo dài về phía trước.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu cố ý biến tuyến vòng khoảng 13,74 kilômét thành một nghi thức chia tay riêng: xuất phát từ Nam Môn, chạy hết một vòng khép kín rồi trở về điểm đầu, để những năm “sống trong thành” có một điểm đầu và điểm cuối rõ ràng như một bản ghi tập luyện. Hoàng hôn hạ sát lầu cổng, kéo dài bóng gạch đá, nữ tường và lỗ châu mai. Bên trong là phố ngõ, sân nhà và hướng Tháp Chuông quen thuộc; bên ngoài là dòng xe, lối vào tàu điện ngầm và các khu dân cư tiếp tục mở rộng. Mẹ nhắn rằng xe chuyển nhà đã dỡ xong, bếp ở nhà mới lần đầu nổi lửa và bảo cậu chạy xong thì tới thẳng. Chu Dao chỉ trả lời “được”. Cậu không tiếc ngôi nhà mới; phòng sáng hơn và đi làm cũng tiện. Điều khiến cậu thực sự bất an là nếu địa chỉ rời khỏi bên trong tường thành, cảm giác “mình là người Tây An” đã hình thành từ nhỏ có trở nên mỏng đi không?', 'Ánh chiều từ vàng chuyển sang xanh đen. Cậu chạy qua các cổng và góc tường ở nhiều hướng. Phần chính của tường thành Tây An còn lại được mở rộng, định hình vào thời Hồng Vũ nhà Minh; một số đoạn tường phía nam và phía tây sử dụng nền tường đô thị sớm hơn. Ngày nay thân tường, cổng, công trình phụ và hào được bảo vệ như một chỉnh thể. Mặt tường rộng trước kia phục vụ phòng thủ, tuần tra và điều động, nay cũng đi vào đời sống công cộng hằng ngày. Chu Dao không dừng lại đọc bảng thuyết minh. Cậu liên tục gặp lại các tuyến đường của chính mình: hồi tiểu học học đạp xe ở công viên vành đai, thời trung học mỗi ngày qua cổng thành đi học, sau đại học về nhà lại thường chạy dọc tường phía nam. “Trong thành” và “ngoài thành” rất rõ trên bản đồ, nhưng trong đời sống lại bị xe buýt, người thân, trường học và thói quen nối qua nối lại. Đêm hẳn, cậu lại thấy cổng Vĩnh Ninh. Đồng hồ rung báo đủ một vòng. Lẽ ra cậu phải bấm dừng ở đây để lời chia tay thành sự thật. Đúng lúc ấy mẹ gửi ảnh ban công nhà mới, xa xa một đoạn tường vừa bật đèn. Chu Dao dừng nửa bước, hạ bàn tay đã giơ lên và không kết thúc thời gian. Cậu xuống thành, chạy tiếp theo con đường phía nam về nhà mới. Ánh đèn tường thành phía sau khép thành một vòng kín, còn con số trên đồng hồ vượt qua vòng ấy.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu chủ ý đặt tuyến vòng khoảng 13,74 kilômét thành một nghi thức chia tay riêng: xuất phát từ Nam Môn, chạy theo tường thành khép kín trở về điểm đầu rồi dừng đồng hồ, để hơn hai mươi năm “sống trong thành” cũng có một dấu chấm hết sạch sẽ. Hoàng hôn hạ sát lầu cổng, gạch đá, nữ tường và lỗ châu mai kéo bóng dài. Bên trong là phố ngõ, sân nhà và bóng Tháp Chuông; bên ngoài là dòng xe, tuyến tàu điện ngầm và các khu dân cư mở rộng. Mẹ nhắn rằng xe chuyển nhà đã dỡ xong, bếp nhà mới lần đầu nổi lửa và bảo cậu chạy xong thì tới thẳng. Chu Dao không phản đối nhà mới: phòng sáng hơn, cha mẹ đi làm cũng tiện hơn. Cậu chỉ vướng ba chữ “chuyển ra ngoài”, như thể sau khi địa chỉ vượt qua tường thành, ký ức tuổi thơ và cảm giác thuộc về cũng phải đổi tên. Để nỗi bất an ấy có vẻ kiểm soát được, cậu mới tự đặt cho hôm nay một vòng tròn và một điểm cuối rõ ràng.', 'Sau khi mặt trời lặn, cậu tiếp tục chạy dọc tường thành hình chữ nhật. Phần chính của tường thành Tây An còn lại hình thành quy mô chủ yếu hiện nay từ năm Hồng Vũ thứ bảy đến thứ mười một, một số đoạn kế thừa nền tường đô thị sớm hơn; thân tường, cổng, công trình phụ và hào được bảo vệ như một chỉnh thể. Mặt tường rộng trước kia thuộc hệ thống phòng thủ, phục vụ tuần tra và điều động; ngày nay nó còn được bảo vệ, quan trắc và đi vào hoạt động thể thao, văn hóa công cộng. Chu Dao không biến cuộc chạy thành bài học lịch sử. Cậu chỉ nhận ra cuộc sống của mình từ lâu đã liên tục xuyên qua không gian ấy: hồi nhỏ học đạp xe ở công viên vành đai, thời trung học mỗi ngày đi xe từ trong thành ra ngoài, sau đại học lại lấy tường phía nam làm mốc chạy khi về quê. Cổng thành từng kiểm soát ra vào trong hệ thống quân sự, còn đời sống hiện đại lại dùng những tuyến đường hằng ngày nối trong và ngoài. Đêm hẳn, cậu lại thấy cổng Vĩnh Ninh. Đồng hồ rung báo đủ một vòng. Cậu vốn định bấm dừng để biến nơi đây thành dấu chấm của lời chia tay; đúng lúc ấy mẹ gửi ảnh ban công nhà mới, xa xa tường thành vừa lên đèn, còn em trai đứng ở góc ảnh giơ hai thùng giấy chưa mở. Chu Dao cười và rời ngón tay khỏi nút dừng. Cậu xuống thành, tiếp tục chạy về phía nam qua những nút giao đông đúc. Tường thành phía sau khép thành một vòng rõ ràng, còn quãng đường trên đồng hồ vẫn tăng. Tối hôm ấy, thứ cậu mang tới nhà mới không phải một mảnh vật chất từ bên trong tường, mà là một tuyến đường không kết thúc ở cổng Vĩnh Ninh.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu chủ ý biến tuyến vòng khoảng 13,74 kilômét thành một nghi thức chia tay riêng: xuất phát từ Nam Môn, chạy theo tường thành khép kín trở về điểm đầu rồi dừng đồng hồ, để hơn hai mươi năm “sống trong thành” cũng có một dấu chấm hết sạch sẽ. Hoàng hôn hạ xuống bên lầu cổng; gạch đá, nữ tường, lỗ châu mai và mặt tường kéo bóng dài. Bên trong là phố ngõ, sân nhà và bóng Tháp Chuông quen thuộc; bên ngoài là dòng xe, tuyến tàu điện ngầm và đô thị hiện đại đang mở rộng. Mẹ nhắn rằng xe chuyển nhà đã dỡ xong, bếp nhà mới lần đầu nổi lửa và bảo cậu chạy xong thì tới thẳng. Chu Dao không phản đối nhà mới: phòng sáng hơn, cha mẹ đi làm thuận tiện hơn, em trai cũng gần trường hơn. Điều thực sự khiến cậu bất an là cậu đã lén diễn giải “chuyển ra ngoài tường thành” thành “rời khỏi Tây An cũ”. Nếu địa chỉ thay đổi, liệu những tuyến đường tuổi thơ và cảm giác thuộc về có bị chặn lại trong vòm cổng không? Vì thế cậu quy định một vòng khép kín cho cuộc chạy, hy vọng dùng một điểm cuối đo được để xử lý một thay đổi không thể đo.', 'Sau khi mặt trời lặn, cậu chạy dọc tường thành hình chữ nhật qua các cổng và góc ở nhiều hướng. Phần chính của tường thành Tây An còn lại được mở rộng, định hình vào thời Hồng Vũ nhà Minh; một số đoạn phía nam và phía tây sử dụng nền tường đô thị sớm hơn. Năm 1961, tường thành Tây An được xếp vào đợt đầu Đơn vị bảo hộ di tích văn vật trọng điểm toàn quốc. Ngày nay thân tường, cổng, công trình phụ và hào tiếp tục được bảo vệ, và công nghệ quan trắc hiện đại cũng tham gia công tác bảo trì. Với Chu Dao, những sự thật ấy không tự trả lời câu hỏi “mình thuộc về đâu”. Điều thực sự thay đổi cậu là những tuyến đường riêng liên tục xuất hiện trên đường chạy: hồi nhỏ học đạp xe ở công viên vành đai, thời trung học mỗi ngày qua cổng thành đi học, cuối tuần theo gia đình ra ngoài thành làm việc, rồi sau đại học về nhà lại chạy dọc tường phía nam. Hệ thống phòng thủ quân sự từng cần những lối ra vào rõ ràng, nhưng đời sống hiện đại dùng xe buýt, trường học, người thân và thói quen nối hai phía lại với nhau. Đêm hẳn, cậu lại thấy cổng Vĩnh Ninh. Đồng hồ rung báo đủ một vòng. Cậu vốn định bấm dừng để “lần chạy quanh thành cuối cùng” thành sự thật; đúng lúc ấy mẹ gửi ảnh ban công nhà mới, một đoạn tường thành sáng ở xa còn em trai đứng bên thùng giấy gọi cậu về ăn. Chu Dao giơ tay, dừng nửa bước rồi rời ngón tay khỏi nút dừng. Cậu xuống thành và chạy tiếp theo đường phía nam về nhà mới. Tường thành phía sau khép thành một vòng sáng hoàn chỉnh, còn quãng đường trên đồng hồ vượt 13,74 kilômét và tiếp tục tăng. Khi đến dưới nhà mới, đồng hồ vẫn chạy. Lúc đó cậu mới bấm dừng và lưu bản ghi thành một tuyến liên tục từ cửa nhà cũ, qua tường thành rồi tới nhà mới.'],
  <String>['Chu Dao, 22 tuổi, từ nhỏ sống cùng cha mẹ trong khu phố cũ bên trong tường thành Tây An. Cuối tuần này cả nhà sẽ chuyển tới ngôi nhà mới ở phía nam ngoài thành. Chiều tối, cậu lên tường thành từ cổng Vĩnh Ninh, bấm bắt đầu và quyết định chạy trọn một vòng. Cậu chủ ý đặt tuyến vòng khoảng 13,74 kilômét thành một nghi thức chia tay riêng: xuất phát từ Nam Môn, chạy theo tường thành khép kín trở về điểm đầu rồi dừng đồng hồ, để hơn hai mươi năm “sống trong thành” có một dấu chấm hết sạch sẽ. Hoàng hôn hạ xuống bên lầu cổng, gạch đá, nữ tường, lỗ châu mai và mặt tường rộng kéo bóng dài. Bên trong là phố ngõ, sân nhà và hướng Tháp Chuông quen thuộc; bên ngoài là dòng xe, tuyến tàu điện ngầm và khu đô thị mới đang mở rộng. Mẹ nhắn rằng xe chuyển nhà đã dỡ xong và bữa cơm đầu tiên ở nhà mới đang chờ. Chu Dao không phản đối cuộc sống mới: nhà sáng hơn, cha mẹ đi làm thuận tiện hơn, em trai cũng gần trường hơn. Điều cậu thực sự vướng là tự diễn giải “chuyển ra ngoài” thành thay đổi thân phận. Tường thành vạch rất rõ trong và ngoài trên bản đồ, nên cậu cũng nhét ký ức, quan hệ và cảm giác thuộc về vào đường biên hình học ấy, muốn dùng một vòng khép kín có thể đo để chứng minh rằng một giai đoạn sống đã kết thúc.', 'Sau khi mặt trời lặn, cậu chạy dọc tường thành hình chữ nhật qua các cổng, góc tường và nhiều đoạn khác nhau. Phần chính của tường thành Tây An còn lại hình thành quy mô chủ yếu hiện nay từ năm Hồng Vũ thứ bảy đến thứ mười một; một số đoạn phía nam và phía tây kế thừa nền tường đô thị sớm hơn. Hệ thống phòng thủ cổ dùng thân tường, cổng, công trình phụ và hào để tổ chức phòng thủ, ra vào, tuần tra và điều động. Năm 1961, tường thành Tây An được xếp vào đợt đầu Đơn vị bảo hộ di tích văn vật trọng điểm toàn quốc; ngày nay nó vẫn được bảo vệ liên tục bằng quy định, quan trắc và tu bổ. Chu Dao không vì thế mà đột nhiên “hiểu lịch sử”. Điều thực sự viết lại vạch đích là những tuyến đời tư cậu liên tục gặp trên đường chạy: hồi nhỏ học đạp xe ở công viên vành đai, thời trung học mỗi ngày qua cổng thành đi học, người thân và các hoạt động thường ngày vẫn phân bố cả trong lẫn ngoài thành, sau đại học cậu lại lấy tường phía nam làm mốc chạy mỗi lần về quê. Đêm hẳn, cậu trở lại cổng Vĩnh Ninh; đồng hồ rung báo đủ một vòng. Đúng lúc ấy mẹ gửi ảnh ban công nhà mới: tường thành sáng ở xa, còn em trai đứng cạnh các thùng giấy gọi cậu về ăn. Chu Dao giơ tay, ngón tay chạm nút dừng rồi lại rời ra. Cậu xuống thành ngay và tiếp tục chạy về phía nam. Quãng đường trên đồng hồ vượt 13,74 kilômét và tiếp tục tăng. Đến dưới nhà mới cậu mới bấm dừng và lưu tuyến. Trên bản đồ, tường thành là một hình chữ nhật khép kín, còn dấu vết chạy lại kéo từ cổng Vĩnh Ninh tới địa chỉ mới. Ngày hôm sau, cậu đặt tên bản ghi ấy là “Về nhà”.'],
];

const _xianStoryEnglish = <List<String>>[
  <String>['Zhou Yao, twenty-two, grew up in the old streets inside Xi’an City Wall. His family is moving to a new home outside the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and plans to complete one full circuit as a final farewell to the familiar route. Sunset lights the bricks and stones, while streets inside the wall and roads outside brighten at the same time. His mother messages that the moving truck has arrived and tells him to come to the new home for dinner after his run. As Zhou Yao passes corners and gates, he keeps wondering: after moving out, will he still count as someone “from inside the wall”? Night falls. He returns to Yongning Gate just as the watch records a full circuit. He does not stop it. Instead, he descends and keeps running south. The wall lights up behind him, and the distance on his watch continues to grow.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home outside the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete one full circuit as his last “run around the city” before the move. Sunset stretches long shadows across the brickwork; inside are old streets, while outside are traffic and newer districts farther away. His mother sends a voice message saying the moving truck has reached the new home and dinner is almost ready. Zhou Yao keeps running past gates and corners, but a question bothers him more and more: if his address changes, does his relationship with the old city end too? As the sky darkens, he sees Yongning Gate again and the watch completes a full lap. This was supposed to be the finish. Zhou Yao raises his hand, looks once, and does not stop the timer. He descends and continues along the streets to the south toward the new home. Behind him, the wall lights join into a ring, while the numbers on the watch move beyond it.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and plans to complete one circuit as a farewell before the move. Sunset stretches shadows across the bricks; familiar streets lie inside, while traffic and new housing lie outside. His mother sends a voice message saying the moving truck has arrived and the first dinner in the new home is waiting for him. Zhou Yao keeps running, convinced that once his address changes, his old life will end at the city gate too.', 'The sky darkens. He passes corners and gates and returns to Yongning Gate. The watch records a full lap and the screen lights with a completion notice. This was supposed to be the finish, but his mother sends a photo from the new balcony, with the wall lights visible in the distance. Zhou Yao looks at the watch and does not stop it. He descends, keeps running south, and crosses intersections in the evening rush. Behind him, the wall becomes a bright ring while the distance on his watch continues to increase.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto Xi’an City Wall from Yongning Gate, starts his running watch, and decides to complete a full circuit, treating the route of more than thirteen kilometres as his last formal farewell before moving. The sun sinks, casting long shadows from the brickwork and gate towers. Inside are familiar lanes, courtyards, and the smell of dinner; outside are traffic, metro entrances, and expanding new housing. His mother sends a voice message saying the moving truck has arrived and the first dinner in the new home is waiting. Zhou Yao replies only, “Okay,” and keeps running. He has always felt that moving beyond the wall means leaving the old city, as though his life will be cut into two parts at one of its gates.', 'The sky shifts from orange to deep blue as he passes corners, gates, and the broad wall top. The surviving Xi’an City Wall was formed principally in the Ming period and was continually repaired afterward; former defensive structures remain protected today and have also entered public urban life. Zhou Yao remembers cycling below the wall as a child and later coming here to run; those memories were never confined to the inside. When he returns to Yongning Gate, the watch completes a full circuit and the screen lights with an alert. This was supposed to be the finish, but his mother sends a photo from the new balcony, where the illuminated wall is visible in the distance. Zhou Yao does not stop the timer. He descends, keeps running south, and crosses busy evening intersections. Behind him, the wall lights close into a ring, while the distance on his watch moves beyond that ring.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He turns the route of more than thirteen kilometres into a private farewell ritual: reset the watch, run once around the city, and finish again at Yongning Gate, as though that could neatly pack away his “life inside the wall.” Sunset slants across the southern wall, leaving long shadows from brickwork, battlements, and gate towers. Inside are familiar lanes, courtyards, and the direction of the Bell Tower; outside are traffic, metro entrances, and an expanding modern city. His mother sends a voice message saying the moving truck has arrived and the first dinner in the new home is waiting. Zhou Yao replies only, “Okay.” He keeps running, but the same thought returns: once his address crosses the wall, will his relationship with the old city end at the gate too?', 'The sky shifts from gold to deep blue as he follows the closed rectangular wall past corners and gates. The surviving wall reached its principal present scale in the Hongwu years of the Ming dynasty and was continually repaired afterward; the wall body, gates, and moat form parts of a heritage system that requires long-term conservation. Zhou Yao does not treat this as a lecture. He remembers learning to ride a bicycle beside the moat and slow runs near the South Gate before the college entrance examination; his life had long been moving through the gates. When Yongning Gate appears again, the watch vibrates: “Goal complete.” A full circuit is done. This was supposed to be the finish. At that moment his mother sends a photo from the new balcony, with the wall lights visible far away in the night. Zhou Yao pauses for half a step and does not stop the timer. He descends and continues south toward the new home. The lights behind him enclose the old city, while the numbers on his watch pass beyond one complete circuit.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He deliberately labels the roughly 13.74-kilometre route his “last run around the city”: start at the South Gate, follow the closed wall for one circuit, return to the starting point, and save his life inside the wall like a training record. Sunset drops beside the gate tower, stretching the shadows of brickwork, parapets, and battlements. Inside are familiar lanes and courtyards; outside are traffic, metro lines, and newer housing farther away. His mother sends a voice message saying the moving truck has been unloaded and the first dinner in the new home is waiting. Zhou Yao replies only, “Okay.” He keeps running, stubbornly turning an address change into an identity change: once he lives beyond the wall, will he still belong to the old city?', 'Dusk deepens as he passes gates and corners in different directions. The surviving Xi’an City Wall was formed principally from the seventh to eleventh Hongwu years on earlier urban-wall foundations; the wall body, gates, associated structures, and moat are protected as a connected whole. In the past, the broad wall top served defence, patrol, and the movement of people and supplies; today the circuit also supports conservation, display, and public activity. Zhou Yao does not stop to memorize dates. He remembers cycling in the ring park as a child, travelling from inside the wall to lessons outside it in middle school, and more recently using the wall as a running landmark. Those lived routes never stopped at the gates. When night fully arrives, he returns to Yongning Gate and the watch vibrates to show a complete circuit. His mother sends a photo from the new balcony just as the wall lights come on in the distance. Zhou Yao raises his hand. He could press stop, but moves his finger away. He descends and keeps running south through the evening rush. Behind him, the line of lights closes into a ring; the distance on his watch keeps moving forward.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He deliberately turns the roughly 13.74-kilometre loop into a private farewell: start at the South Gate, follow the closed wall for one circuit, return to the same point, and give his years “inside the wall” a clear beginning and end like a training record. Sunset drops beside the gate tower, lengthening the shadows of brickwork, parapets, and battlements. Inside are familiar lanes, courtyards, and the direction of the Bell Tower; outside are traffic, metro entrances, and expanding residential districts. His mother sends a voice message saying the moving truck has been unloaded and the new kitchen is being used for the first time, telling him to come straight over after the run. Zhou Yao replies only, “Okay.” He is not reluctant about the new home; the room is brighter and the commute is easier. What truly unsettles him is whether moving his address outside the wall will thin the sense of “being from Xi’an” that he has carried since childhood.', 'Dusk shifts from gold to blue-black as he passes gates and corners in different directions. The surviving wall was principally expanded and formed in the Hongwu years of the Ming dynasty, while parts of the southern and western walls use earlier urban-wall foundations. Today the wall body, gates, associated structures, and moat are protected as a whole. The broad wall top once served defence, patrol, and movement; now the same circuit also belongs to everyday public life. Zhou Yao does not stop to read interpretation boards. Instead he keeps encountering his own routes: learning to cycle in the ring park in primary school, passing through the gates every day for school, and running along the southern wall after university when he came home. “Inside” and “outside” are clear on a map, but buses, relatives, schools, and habits repeatedly connect them in lived experience. Night falls completely and Yongning Gate appears again. The watch vibrates: one full circuit. He was supposed to stop here so the farewell would become real. At that moment his mother sends a photo from the new balcony, with a section of the wall newly lit in the distance. Zhou Yao pauses, lowers the hand he had raised, and does not end the timer. He descends and keeps running south toward the new home. Behind him, the wall lights form a closed ring, while the numbers on his watch pass beyond that loop.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He deliberately makes the roughly 13.74-kilometre loop a private farewell: start at the South Gate, follow the closed wall back to the same point, then stop the timer so that more than twenty years “inside the wall” can also receive a clean full stop. Sunset drops beside the gate tower, casting long shadows from brickwork, parapets, and battlements. Inside are familiar lanes, courtyards, and the outline of the Bell Tower; outside are traffic, metro lines, and expanding residential areas. His mother sends a voice message saying the moving truck has been unloaded and the new kitchen is being used for the first time, telling him to come straight over after the run. Zhou Yao does not dislike the new home: the room is brighter, and his parents’ commutes are easier. What bothers him are the words “moving outside,” as though once his address crosses the wall, his childhood routes and sense of belonging must be renamed too. To make that unease feel controllable, he gives the day a precise circle and a finish line.', 'After sunset he keeps running along the rectangular wall. The surviving Xi’an City Wall reached its principal present scale from the seventh to eleventh Hongwu years, with some sections carrying earlier urban-wall foundations; the wall body, gates, associated structures, and moat are protected as a whole. The broad wall top once belonged to the defensive system and served patrol and movement; today it is also conserved, monitored, and used for public exercise and cultural life. Zhou Yao does not turn the run into a history lesson. He simply realizes that his own life has always crossed this space: learning to cycle in the ring park, travelling from inside the wall to school outside it, and later using the southern wall as a running landmark whenever he returned home. Gates once controlled passage in a military system, while modern life stitches inside and outside together through everyday routes. Night falls completely and he sees Yongning Gate again. The watch vibrates: the circuit is complete. He had planned to press stop and make this the punctuation mark of his farewell, but his mother sends a photo from the new balcony at that exact moment. The wall lights glow in the distance, and his younger brother is in the corner holding up two unopened boxes. Zhou Yao smiles and moves his finger away from the stop button. He descends and keeps running south through busy intersections. The wall behind him forms a clear closed loop, while the distance on his watch keeps growing. What he carries to the new home that night is not a piece of the old city, but a route that did not end at Yongning Gate.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He deliberately makes the roughly 13.74-kilometre loop a private farewell: start at the South Gate, follow the closed wall back to the same point, then stop the timer so that more than twenty years “inside the wall” can receive a clean full stop. Sunset drops beside the gate tower, stretching shadows across the brickwork, parapets, battlements, and wall-top path. Inside are familiar lanes, courtyards, and the outline of the Bell Tower; outside are traffic, metro lines, and the expanding modern city. His mother sends a voice message saying the moving truck has been unloaded and the new kitchen is being used for the first time, telling him to come straight over after the run. Zhou Yao does not dislike the new home: the room is brighter, his parents’ commutes are easier, and his younger brother will be closer to school. What truly unsettles him is that he has quietly translated “moving outside the wall” into “leaving old Xi’an.” If his address changes, will his childhood routes and sense of belonging be cut off in the gate passage? He therefore gives this run a closed circuit, hoping to use a measurable finish line to handle an immeasurable change.', 'After sunset he runs along the rectangular wall through gates and corners in different directions. The surviving Xi’an City Wall was principally expanded and formed in the Hongwu years of the Ming dynasty, with some southern and western sections using earlier urban-wall foundations. In 1961 it was included in the first group of National Key Cultural Relic Protection Units. Today the wall body, gates, associated structures, and moat remain under conservation, and modern monitoring also supports maintenance. For Zhou Yao, those facts do not answer the question “Where do I belong?” What actually changes his judgment are the private routes that keep appearing during the run: learning to cycle in the ring park, crossing gates every day for school, going outside the wall with his family on weekends, and later returning to run along the southern wall. A military defensive system once required clear entrances and exits, but modern life repeatedly stitches the same city together through buses, schools, relatives, and habits. Night falls completely and Yongning Gate appears again. The watch vibrates: one full circuit. He had planned to press stop and make the “last run around the city” real, but his mother sends a photo from the new balcony at that moment. A stretch of wall glows in the distance, and his younger brother stands beside the boxes calling him to dinner. Zhou Yao raises his hand, pauses, and moves his finger away from the stop button. He descends and keeps running south toward the new home. Behind him, the wall forms a complete bright ring; the watch passes 13.74 kilometres and continues upward. When he reaches the new building, the timer is still running. Only then does he stop it and save the record as one continuous route from the old front door, around the wall, and on to the new home.'],
  <String>['Zhou Yao, twenty-two, grew up with his parents in the old streets inside Xi’an City Wall. His family is moving to a new home south of the wall this weekend. At dusk, he climbs onto the wall from Yongning Gate, starts his running watch, and decides to complete a full circuit. He deliberately makes the roughly 13.74-kilometre loop a private farewell: start at the South Gate, follow the closed wall back to the same point, then stop the timer so that more than twenty years “inside the wall” can receive a clean full stop. Sunset drops beside the gate tower, stretching shadows across the brickwork, parapets, battlements, and broad wall top. Inside are familiar lanes, courtyards, and the direction of the Bell Tower; outside are traffic, metro lines, and expanding new districts. His mother sends a voice message saying the moving truck has been unloaded and the first dinner in the new home is waiting. Zhou Yao does not reject the new life: the home is brighter, his parents’ commutes are easier, and his younger brother will be closer to school. What bothers him is that he has interpreted “moving outside” as an identity change. The wall draws a clear inside and outside on the map, and he has pushed memory, relationships, and belonging into that geometric boundary too, hoping that one measurable closed loop can prove a stage of life is over.', 'After sunset he runs along the rectangular wall through gates, corners, and different sections. The surviving Xi’an City Wall reached its principal present scale from the seventh to eleventh Hongwu years, while parts of the southern and western walls carry earlier urban-wall foundations. The historical defensive system used the wall body, gates, associated structures, and moat to organize defence, access, patrol, and movement. In 1961 Xi’an City Wall was included in the first group of National Key Cultural Relic Protection Units, and today it remains under continuing conservation through regulation, monitoring, and repair. Zhou Yao does not suddenly “understand history” because of that. What actually redraws his finish line are the private routes he keeps encountering: learning to cycle in the ring park, crossing the gates every day for school, relatives and daily activities spread on both sides of the wall, and later using the southern wall as a running landmark whenever he returned home after university. Night falls completely. He returns to Yongning Gate and the watch vibrates: the circuit is complete. At that moment his mother sends a photo from the new balcony: the wall glows in the distance, and his younger brother stands beside boxes calling him to dinner. Zhou Yao raises his hand; his finger touches the stop button and moves away. He descends immediately and keeps running south. The watch passes 13.74 kilometres and continues to increase. He stops only when he reaches the new home and saves the route. On the map, the wall is a closed rectangle, but his track extends from Yongning Gate to the new address. The next day he names the record “Home.”'],
];

String _xianPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

JourneyLevelContent _xianLevel(int level, List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++)
          ReadingAnnotation(
            pinyin: _xianPinyin(paragraphs[i]),
            vietnamese: _xianStoryVietnamese[level - 1][i],
            english: _xianStoryEnglish[level - 1][i],
          ),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final xianCityWallOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _xianLevel(1, ['周遥二十二岁，从小住在西安城墙里。这个周末，全家要搬到城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。夕阳照着砖石，城内的街巷和城外的道路同时亮着。母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。周遥经过转角和城门时，一直想：搬出去以后，自己还算不算“城里人”。夜色落下来，他又回到永宁门，跑表刚好记下一整圈。他没有按停，而是下城继续往南跑。身后的城墙亮起灯，他的距离还在增加。']),
  _xianLevel(2, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，决定完整跑一圈，把它当作搬家前最后一次“绕城”。夕阳把砖石拉出长影，向内能看见老城街巷，向外是车流和更远的新城区。母亲发来语音，说搬家车已经到新家，饭也快好了。周遥继续沿墙跑，经过城门和转角，心里却越来越别扭：如果住址变了，自己和这座老城的关系是不是也结束了？天色变深，他再次看见永宁门，跑表完成一整圈。原本这里应是终点。周遥抬手看了一眼，没有按停计时，直接下城，沿南边的街道继续向新家跑去。城墙灯光在身后连成一圈，而跑表上的数字越过了那一圈。']),
  _xianLevel(3, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上城墙，给跑表按下开始，想完整跑一圈，把这次“绕城”当成搬家前的告别。夕阳把砖石拉出长影，墙内是熟悉的街巷，墙外是车流和新住宅。母亲发来语音，说搬家车已经到了，新家的第一顿饭等他回来。周遥继续跑，心里却认定：住址一变，旧生活也会在城门处结束。', '天色渐暗，他经过转角和城门，又回到永宁门。跑表完成一整圈，屏幕亮起提示。原本这里应是终点，母亲却发来一张新家阳台的照片，远处正能看见城墙的灯。周遥抬手看了看跑表，没有按停。他下城后继续向南跑，穿过晚高峰的路口。身后的城墙连成一圈亮线，跑表上的距离却继续增加。']),
  _xianLevel(4, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈，把十三公里多的环线当作搬家前最后一次正式告别。夕阳压低，砖石和城楼投下长影。向内是他熟悉的街巷、院落和晚饭香，向外是车流、地铁口与不断延伸的新住宅。母亲发来语音，说搬家车已经到达，新家的第一顿饭等他回来。周遥只回了一个“好”，继续沿墙跑。他一直觉得，搬出城墙就等于离开老城，自己的生活会在某座城门处被切成两段。', '天色从橙色变成深蓝，他经过转角、城门和宽阔的墙顶。现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。周遥小时候在墙下骑车，上学后又常来跑步，这些记忆并不只在墙内。回到永宁门时，跑表完成一整圈，屏幕亮起提示。原本这里应是终点，母亲却发来新家阳台的照片，远处正能看见亮起的城墙。周遥没有按停计时。他下城后继续向南跑，穿过晚高峰的路口。城墙灯光在身后合成一圈，而跑表上的距离越过那一圈。']),
  _xianLevel(5, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他把这十三公里多的环线当成一场私人告别：跑表归零，绕城一周，再在永宁门结束，好像这样就能把“城内生活”整齐收好。夕阳从南墙斜过去，砖石、垛口和城楼留下长影。向内是熟悉的街巷、院落与钟楼方向，向外是车流、地铁口和不断延伸的现代城区。母亲发来语音，说搬家车已到，新家的第一顿饭等他。周遥只回了一个“好”。他继续跑，却反复想：住址一旦越过城墙，自己和老城的关系是不是也会在城门处结束。', '天色由金黄转成深蓝，他沿封闭的长方形城墙经过转角与城门。现存城墙在明洪武年间形成今天的主要尺度，并在后世持续修缮；墙体、城门、护城河等共同构成需要长期保护的遗产。周遥并没有把这些当成讲解词。他记得小时候在护城河边学骑车，也记得高考前沿南门附近慢跑，生活早就不断进出城门。再次看见永宁门时，跑表完成一整圈，震动提醒他“目标完成”。原本这就是终点。母亲此时发来一张新家阳台的照片，夜色里远远能看见城墙灯光。周遥停了半步，没有按停计时，而是直接下城，沿南边街道继续跑向新家。身后灯线围住老城，跑表的数字却越过了完整的一圈。']),
  _xianLevel(6, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他故意把这条十三点七四公里左右的环线设成“最后一次绕城”：从南门出发，沿墙跑完封闭的一周，再回到原点，把城内生活像训练记录一样保存起来。夕阳落到城楼一侧，砖石、女儿墙和垛口被拉出长影。向内是熟悉的街巷与院落，向外是车流、地铁线和更远的新住宅。母亲发来语音，说搬家车已经卸完，新家的第一顿饭等他回来。周遥只回了一个“好”。他继续跑，心里却固执地把住址变化理解成身份变化：搬出城墙以后，自己是不是就不再属于老城？', '暮色逐渐压下来，他沿城墙经过不同方向的城门与转角。现存西安城墙主要形成于明洪武七年至十一年，建立在更早城市墙体基础上；墙体、城门、附属建筑和护城河属于整体保护对象。过去，宽阔墙顶服务防御、巡查和人员物资调动；今天，这条环线又承载保护、展示与公共活动。周遥没有停下来背年代。他想起小时候在环城公园骑车，想起中学时从城内坐车去城外补课，也想起近几年常把城墙当跑步坐标。那些生活从来没有在门洞前断开。夜色完全落下，他回到永宁门，跑表震动，显示一整圈完成。母亲恰好发来新家阳台的照片，远处城墙刚亮灯。周遥抬手，本可以按下停止，却把手指移开。他下城后继续向南跑，穿过晚高峰的路口。身后的灯线封成一圈，跑表的距离却继续向前。']),
  _xianLevel(7, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他故意把十三点七四公里左右的环线设成一场私人告别：从南门出发，沿封闭城墙跑完一周，再回到原点，让“住在城里”的日子像一次训练记录那样有清楚的起点和终点。夕阳贴着城楼下降，砖石、女儿墙和垛口的影子被拉长。墙内是熟悉的街巷、院落和钟楼方向，墙外是车流、地铁口与继续生长的住宅区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥只回了一个“好”。他没有舍不得新家；房间更亮，通勤也方便。他真正不安的是另一件事：如果地址离开城墙以内，自己从小建立的“西安人”感觉会不会也跟着变薄？', '暮色由金黄转成蓝黑，他沿城墙经过不同方向的城门和转角。现存西安城墙的主体在明洪武年间扩建形成，南墙和西墙部分利用更早的城市墙体基础；今天，城墙墙体、城门、附属建筑和护城河受到整体保护。过去宽阔墙顶服务防御、巡查与调动，如今同一条环线又进入日常公共生活。周遥并没有停下来读讲解牌。他只是不断遇见自己的路线：小学时在环城公园学骑车，中学时每天穿过城门去上课，大学后回家常沿南墙跑步。所谓“城内”和“城外”，在地图上清楚，在生活里却被公交、亲友、学校和习惯反复连接。夜色完全落下，他再次看见永宁门。跑表震动，显示整圈完成。他本来应该在这里按停，让告别成立。母亲恰好发来新家阳台的照片，远处一段城墙刚亮灯。周遥停了半步，把已经抬起的手放下，没有结束计时。他下城，沿南边街道继续跑向新家。城墙灯光在身后围成闭合的一圈，跑表上的数字却越过了那条闭环。']),
  _xianLevel(8, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的生活也得到一个干净的句号。夕阳贴着城楼下降，砖石、女儿墙和垛口被拉出长影。墙内是熟悉的街巷、院落与钟楼轮廓，墙外是车流、地铁线和扩展的住宅区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥并不排斥新家：房间更亮，父母上下班也方便。他介意的是“搬出去”这三个字，仿佛住址越过城墙以后，童年路线和归属也必须改名。为了让这种不安显得可以控制，他才给今天安排了一个明确的圆周和终点。', '太阳落下以后，他沿长方形城墙继续向前。现存西安城墙的主体在明洪武七年至十一年形成今天的主要尺度，部分墙段承接更早的城市墙体基础；墙体、城门、附属建筑和护城河被整体保护。过去，宽阔的墙顶属于城市防御体系，也服务巡查和调动；今天，它又被保护、监测并进入市民运动与公共文化生活。周遥没有把跑步变成历史课。他只是发现自己的生活早就不断穿过这套空间：小时候在环城公园学骑车，中学每天从城内坐车到城外，大学以后又把南墙当作返乡跑步的坐标。城门在军事体系里曾控制出入，现代生活却用日常路线把内外缝在一起。夜色完全落下，他再次看见永宁门。跑表震动，整圈完成。他原本准备按停，让这里成为告别的句点；母亲却恰好发来新家阳台的照片，远处城墙灯光刚亮，弟弟还在照片角落举着两只没拆封的纸箱。周遥笑了，把手指从停止键上移开。他下城后继续向南跑，穿过晚高峰路口。城墙在身后围成清楚的闭环，跑表上的距离却继续增长。那一晚，他带到新家的不是城墙里的一块东西，而是一条没有在永宁门结束的路线。']),
  _xianLevel(9, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的日子也得到一个干净的句号。夕阳沿城楼一侧下降，砖石、女儿墙、垛口和墙顶路面被拉出长影。墙内是熟悉的街巷、院落与钟楼轮廓，墙外是车流、地铁线和扩展的现代城区。母亲发来语音，说搬家车已经卸完，新家的厨房第一次开火，让他跑完直接过去。周遥并不反感新家：房间更亮，父母通勤更方便，弟弟也离学校更近。他真正不安的是“搬出城墙”被自己偷偷解释成“搬出老西安”。如果住址改变，童年路线和归属感，会不会也在门洞里被截断？于是他给这次跑步规定了闭合的一圈，希望用一个可测量的终点处理一件无法测量的变化。', '太阳落下以后，他沿长方形城墙经过不同方向的城门和转角。现存西安城墙主体在明洪武年间扩建形成，部分南、西墙段利用更早的城市墙体基础；1961年，西安城墙被列入第一批全国重点文物保护单位。今天，墙体、城门、附属建筑和护城河被持续保护，现代监测也进入维护。对周遥来说，这些事实并没有替他回答“属于哪里”。真正改变他的，是一路不断出现的私人路线：小时候在环城公园学骑车，中学每天穿城门去上课，周末跟家人去城外办事，大学后回家又沿南墙跑步。军事防御体系曾经需要清楚的出入口，但现代生活把同一座城市的内外用公交、学校、亲友与习惯反复缝合。夜色完全落下，他再次看见永宁门。跑表震动，整圈完成。他原本准备按停，让“最后一次绕城”成立；母亲却恰好发来新家阳台的照片，城墙灯光在远处横着一段，弟弟站在纸箱旁催他吃饭。周遥抬起手，停了半步，又把手指从停止键上移开。他下城，沿南边街道继续跑向新家。身后的城墙围成完整亮环，跑表上的距离却越过十三点七四公里继续增加。到新家楼下时，计时还在走。他这才按停，把这条记录保存成一条从老家门口经过城墙、再抵达新家的连续路线。']),
  _xianLevel(10, ['周遥二十二岁，从小跟父母住在西安城墙内的老街。这个周末，全家要搬到南边城外的新家。傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈。他刻意把十三点七四公里左右的环线设成一场私人告别：从南门起跑，沿封闭城墙绕回原点，再停止计时，让二十多年“住在城里”的生活得到一个干净句号。夕阳沿城楼下降，砖石、女儿墙、垛口和宽阔墙顶拉出长影。墙内是熟悉的街巷、院落与钟楼方向，墙外是车流、地铁线和扩展的新城区。母亲发来语音，说搬家车已卸完，新家的第一顿饭等他。周遥并不排斥新生活：新家更亮，父母通勤更方便，弟弟离学校也近。他真正介意的是“搬出去”被自己解释成身份变化。城墙在地图上清楚画出内外，他便把记忆、关系和归属也塞进这条几何线里，想用一次可量化的闭环证明某段生活已经结束。', '太阳落下以后，他沿长方形城墙经过城门、转角和不同墙段。现存西安城墙主体在明洪武七年至十一年形成今天的主要尺度，南墙、西墙部分承接更早城市墙体基础；古代防御体系用墙体、城门、附属建筑与护城河组织防守、出入、巡查和调动。1961年，西安城墙被列入第一批全国重点文物保护单位，今天仍通过法规、监测和修缮持续保护。周遥没有因此突然“理解历史”。真正改写终点线的，是一路撞上的私人路线：小时候在环城公园学骑车，中学每天穿城门上课，亲友和日常活动一直分布在墙内墙外，大学以后他又把南墙当返乡跑步坐标。夜色完全落下，他回到永宁门，跑表震动，整圈完成。母亲恰好发来新家阳台的照片：远处城墙亮灯，弟弟站在纸箱旁催他吃饭。周遥抬手，手指碰到停止键又移开。他直接下城，沿南边街道继续跑。跑表越过十三点七四公里继续增加。到新家楼下，他才按停并保存路线。图上，城墙是闭合长方形，轨迹却从永宁门伸到新住址。第二天，他把这条记录命名为“回家”。']),
]);

WordEntry _word(String word, String pinyin, String part, String simple, String vi, String en, String symbol) => WordEntry(
  word: word,
  pinyin: pinyin,
  partOfSpeech: part,
  simpleChinese: simple,
  translation: vi,
  englishDefinition: en,
  symbol: symbol,
);

final xianCityWallOnePassWords = List<WordEntry>.unmodifiable([
  _word('城墙', 'chéngqiáng', '名词', '围绕城市、具有防护功能的墙体。', 'Tường thành bao quanh đô thị.', 'city wall', '🧱'),
  _word('永宁门', 'Yǒngníngmén', '专有名词', '西安城墙南面的重要城门。', 'Cổng Vĩnh Ninh ở phía nam tường thành Tây An.', 'Yongning Gate', '🚪'),
  _word('跑表', 'pǎobiǎo', '名词', '跑步时记录时间和距离的计时设备。', 'Đồng hồ chạy bộ.', 'running watch', '⌚'),
  _word('搬家', 'bānjiā', '动词', '把家庭用品搬到新的住处。', 'Chuyển nhà.', 'to move house', '📦'),
  _word('城内', 'chéngnèi', '名词', '城墙以内的城市空间。', 'Bên trong tường thành.', 'inside the walled city', '🏘️'),
  _word('城外', 'chéngwài', '名词', '城墙以外的城市空间。', 'Bên ngoài tường thành.', 'outside the walled city', '🏙️'),
  _word('城门', 'chéngmén', '名词', '城墙上供人员和交通出入的门。', 'Cổng thành.', 'city gate', '🏯'),
  _word('住址', 'zhùzhǐ', '名词', '居住地点的地址。', 'Địa chỉ nơi ở.', 'residential address', '📍'),
  _word('环线', 'huánxiàn', '名词', '首尾相接形成一圈的路线。', 'Tuyến vòng khép kín.', 'circular route', '🔄'),
  _word('修缮', 'xiūshàn', '动词', '修理并维护历史建筑。', 'Tu bổ công trình lịch sử.', 'to repair and conserve', '🔧'),
  _word('防御', 'fángyù', '名词/动词', '抵挡攻击、保护城市。', 'Phòng thủ.', 'defence; to defend', '🛡️'),
  _word('护城河', 'hùchénghé', '名词', '城墙外与防御体系相关的河沟。', 'Hào nước.', 'moat', '🌊'),
  _word('归属感', 'guīshǔgǎn', '名词', '觉得自己与一个地方有稳定联系的感受。', 'Cảm giác thuộc về.', 'sense of belonging', '🧭'),
  _word('闭环', 'bìhuán', '名词', '首尾连接、形成完整一圈的结构。', 'Vòng khép kín.', 'closed loop', '⭕'),
  _word('全国重点文物保护单位', 'quánguó zhòngdiǎn wénwù bǎohù dānwèi', '名词短语', '由国家公布的重要文物保护单位。', 'Di tích trọng điểm cấp quốc gia.', 'national key cultural relic protection unit', '🏛️'),
  _word('监测', 'jiāncè', '动词', '持续观察并记录状态变化。', 'Theo dõi trạng thái.', 'to monitor', '📡'),
]);

final xianCityWallWordTraces = List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '城墙', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '周遥二十二岁，从小住在西安城墙里。'),
  const RemediatedWordTrace(word: '永宁门', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。'),
  const RemediatedWordTrace(word: '跑表', eventId: 'XIAN-E1-start', usage: 'Lv1 首次出现。', sourceText: '傍晚，他从永宁门登上城墙，给跑表按下开始，想跑完一圈，把这条熟悉的路当成最后一次告别。'),
  const RemediatedWordTrace(word: '搬家', eventId: 'XIAN-E3-doubt', usage: 'Lv1 首次出现。', sourceText: '母亲发来消息，说搬家车已经到了，让他跑完就去新家吃饭。'),
  const RemediatedWordTrace(word: '城内', eventId: 'XIAN-E2-view', usage: 'Lv1 首次出现。', sourceText: '夕阳照着砖石，城内的街巷和城外的道路同时亮着。'),
  const RemediatedWordTrace(word: '城外', eventId: 'XIAN-E2-view', usage: 'Lv1 首次出现。', sourceText: '这个周末，全家要搬到城外的新家。'),
  const RemediatedWordTrace(word: '城门', eventId: 'XIAN-E3-doubt', usage: 'Lv1 首次出现。', sourceText: '周遥经过转角和城门时，一直想：搬出去以后，自己还算不算“城里人”。'),
  const RemediatedWordTrace(word: '住址', eventId: 'XIAN-E3-doubt', usage: 'Lv2 首次出现。', sourceText: '周遥继续沿墙跑，经过城门和转角，心里却越来越别扭：如果住址变了，自己和这座老城的关系是不是也结束了？'),
  const RemediatedWordTrace(word: '环线', eventId: 'XIAN-E1-start', usage: 'Lv4 首次出现。', sourceText: '傍晚，他从永宁门登上西安城墙，给跑表按下开始，决定完整跑一圈，把十三公里多的环线当作搬家前最后一次正式告别。'),
  const RemediatedWordTrace(word: '修缮', eventId: 'XIAN-E4-history', usage: 'Lv4 首次出现。', sourceText: '现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。'),
  const RemediatedWordTrace(word: '防御', eventId: 'XIAN-E4-history', usage: 'Lv4 首次出现。', sourceText: '现存西安城墙主要形成于明代，后来持续修缮；过去的防御设施今天仍被保护，也进入城市公共生活。'),
  const RemediatedWordTrace(word: '护城河', eventId: 'XIAN-E4-history', usage: 'Lv5 首次出现。', sourceText: '现存城墙在明洪武年间形成今天的主要尺度，并在后世持续修缮；墙体、城门、护城河等共同构成需要长期保护的遗产。'),
  const RemediatedWordTrace(word: '归属感', eventId: 'XIAN-E3-doubt', usage: 'Lv9 首次出现。', sourceText: '如果住址改变，童年路线和归属感，会不会也在门洞里被截断？'),
  const RemediatedWordTrace(word: '闭环', eventId: 'XIAN-E6-climax', usage: 'Lv7 首次出现。', sourceText: '城墙灯光在身后围成闭合的一圈，跑表上的数字却越过了那条闭环。'),
  const RemediatedWordTrace(word: '全国重点文物保护单位', eventId: 'XIAN-E4-history', usage: 'Lv9 首次出现。', sourceText: '现存西安城墙主体在明洪武年间扩建形成，部分南、西墙段利用更早的城市墙体基础；1961年，西安城墙被列入第一批全国重点文物保护单位。'),
  const RemediatedWordTrace(word: '监测', eventId: 'XIAN-E4-history', usage: 'Lv8 首次出现。', sourceText: '过去，宽阔的墙顶属于城市防御体系，也服务巡查和调动；今天，它又被保护、监测并进入市民运动与公共文化生活。'),
]);

const xianCityWallWordFirstAppears = <String, int>{
  '城墙': 1, '永宁门': 1, '跑表': 1, '搬家': 1, '城内': 1, '城外': 1, '城门': 1,
  '住址': 2, '环线': 4, '修缮': 4, '防御': 4, '护城河': 5, '闭环': 7, '监测': 8,
  '归属感': 9, '全国重点文物保护单位': 9,
};

const xianCityWallSourceLedger = <Map<String, String>>[
  {
    'id': 'xian-local-gazetteer-wall',
    'publisher': '陕西省地方志办公室',
    'url': 'https://dfz.shaanxi.gov.cn/zslm/zjyd/fzsy/200611/t20061123_2621352.html',
    'supports': '明洪武七年起修筑；西、南墙沿用更早城垣；1983年起大规模修缮与环城建设。',
  },
  {
    'id': 'unesco-ming-qing-walls-5324',
    'publisher': 'UNESCO World Heritage Centre',
    'url': 'https://whc.unesco.org/en/tentativelists/5324/',
    'supports': '西安城墙明代扩建、西南墙基时间层、1961年首批国保、1983年综合修缮，以及“中国明清城墙”预备名录身份。',
  },
  {
    'id': 'mofcom-xian-historic-city-regulation-2025',
    'publisher': '商务部全球法规网（西安市地方性法规）',
    'url': 'https://policy.mofcom.gov.cn/claw/clawContent.shtml?id=104518',
    'supports': '历史城区包括西安城墙区域及其以内完整片区；城墙、城门、护城河外沿与历史文化街区属系统保护范围。',
  },
  {
    'id': 'xinhua-xian-digital-conservation-2026',
    'publisher': '新华社',
    'url': 'https://www.news.cn/culture/20260108/221ab2e65a65494b8e994ca76e591896/c.html',
    'supports': '13.74公里长度；无损检测、裂缝位移测量、数字孪生与持续监测管理。',
  },
];

const xianCityWallClaimLedger = <Map<String, String>>[
  {'claim': '现存西安城墙主体于明代形成今日主要规模，西、南墙段承接更早城垣基础。', 'source': 'xian-local-gazetteer-wall + unesco-ming-qing-walls-5324', 'status': 'ALLOWED'},
  {'claim': '西安城墙全长约13.74公里。', 'source': 'xinhua-xian-digital-conservation-2026', 'status': 'ALLOWED'},
  {'claim': '西安城墙于1961年列入第一批全国重点文物保护单位。', 'source': 'unesco-ming-qing-walls-5324', 'status': 'ALLOWED'},
  {'claim': '西安城墙是“中国明清城墙”世界遗产预备名录组成部分，不等于已列入世界遗产名录。', 'source': 'unesco-ming-qing-walls-5324', 'status': 'ALLOWED'},
  {'claim': '今日保护包括无损检测、裂缝和位移测量、数字化数据管理。', 'source': 'xinhua-xian-digital-conservation-2026', 'status': 'ALLOWED'},
  {'claim': '历史城区、城墙、城门、护城河与历史文化街区需要整体保护。', 'source': 'mofcom-xian-historic-city-regulation-2025', 'status': 'ALLOWED'},
  {'claim': '周遥、其家人、搬家、跑步记录、对话与“回家”命名。', 'source': 'FICTION-GOVERNANCE', 'status': 'ALLOWED FICTION'},
];

const xianCityWallFactFictionLedger = <Map<String, String>>[
  {'item': '城墙长度、明代主体、更早城垣基础、1961年国保身份、预备名录与当代监测。', 'category': 'VERIFIED WORLD', 'status': 'ALLOWED'},
  {'item': '周遥、父母、弟弟、新旧住所与个人生活路线。', 'category': 'FICTIONAL ORDINARY PEOPLE / BACKSTORY / RELATIONSHIP', 'status': 'ALLOWED'},
  {'item': '告别跑、母亲消息、不按停跑表、继续跑到新家与路线命名。', 'category': 'FICTIONAL PRIVATE ACTION / CHOICE / CONSEQUENCE', 'status': 'ALLOWED'},
  {'item': '把周遥的选择写成真实新闻或纪录事件。', 'category': 'FICTION PRESENTED AS DOCUMENTED HISTORY', 'status': 'BLOCKED / NOT USED'},
  {'item': '把世界遗产预备名录写成已列入世界遗产，或把西安城墙时间层压成单一朝代。', 'category': 'UNSUPPORTED / FALSE FACTUAL CLAIM', 'status': 'BLOCKED / NOT USED'},
  {'item': '真实历史人物的私人动机、对话或未载行动。', 'category': 'REAL PERSON HIGH-PROTECTION', 'status': 'NOT USED'},
];

WordEntry _xianWordWithStoryExamples(
  int level,
  List<String> paragraphs,
  WordEntry word,
) {
  final paragraphIndex = paragraphs.indexWhere(
    (paragraph) => paragraph.contains(word.word),
  );
  if (paragraphIndex < 0) {
    throw StateError(
      'Missing Xi\'an current Story source for Lv$level ${word.word}',
    );
  }
  final source = paragraphs[paragraphIndex];
  final vietnamese = _xianStoryVietnamese[level - 1][paragraphIndex];
  final english = _xianStoryEnglish[level - 1][paragraphIndex];
  return WordEntry(
    word: word.word,
    pinyin: word.pinyin,
    partOfSpeech: word.partOfSpeech,
    simpleChinese: word.simpleChinese,
    translation: word.translation,
    englishDefinition: word.englishDefinition,
    symbol: word.symbol,
    examples: List<WordExample>.unmodifiable(<WordExample>[
      WordExample(
        chinese: source,
        pinyin: _xianPinyin(source),
        vietnamese: vietnamese,
        english: english,
      ),
      WordExample(
        chinese: '故事原句：$source',
        pinyin: _xianPinyin('故事原句：$source'),
        vietnamese: 'Câu trong truyện: $vietnamese',
        english: 'Story sentence: $english',
      ),
      WordExample(
        chinese: '回看故事原句：$source',
        pinyin: _xianPinyin('回看故事原句：$source'),
        vietnamese: 'Đọc lại câu trong truyện: $vietnamese',
        english: 'Review the story sentence: $english',
      ),
    ]),
  );
}

DiscoveryEntry _discovery(String text) {
  final support = switch (text) {
    '西安城墙周长约13.74公里，今天仍形成封闭的长方形环线。' => ('Tường thành Tây An dài khoảng 13,74 km và ngày nay vẫn tạo thành một tuyến vòng hình chữ nhật khép kín.', 'Xi’an City Wall is about 13.74 kilometres long and still forms a closed rectangular circuit.'),
    '明清时期西安城墙传统四门分别为东长乐、南永宁、西安定、北安远；永宁门是南门。' => ('Bốn cổng truyền thống thời Minh–Thanh là Trường Lạc phía đông, Vĩnh Ninh phía nam, An Định phía tây và An Viễn phía bắc; Vĩnh Ninh là cổng nam.', 'The four traditional Ming–Qing gates were Changle in the east, Yongning in the south, Anding in the west, and Anyuan in the north; Yongning is the southern gate.'),
    '官方资料记载城墙顶宽约12至14米；历史上宽阔墙顶有利于防御、巡查和人员物资调动。' => ('Tư liệu chính thức ghi mặt tường rộng khoảng 12–14 m; trong lịch sử, bề rộng này hỗ trợ phòng thủ, tuần tra và điều động người, vật tư.', 'Official material records a wall-top width of about 12–14 metres; historically, that width supported defence, patrol, and movement of people and supplies.'),
    '现存西安城墙主体在明洪武七年至十一年（1374—1378）形成今天的主要尺度，并承接更早城市墙体基础。' => ('Phần chủ thể còn lại của tường thành đạt quy mô chính ngày nay vào năm Hồng Vũ thứ 7–11 (1374–1378), đồng thời tiếp nối nền tường đô thị sớm hơn.', 'The surviving wall reached its principal present scale in the seventh to eleventh Hongwu years (1374–1378), while carrying forward earlier urban-wall foundations.'),
    '《西安城墙保护条例》把明代城墙墙体、城门、附属建筑、护城河及其遗址遗迹作为西安城墙保护对象。' => ('Quy định bảo vệ tường thành Tây An bao gồm thân tường thời Minh, cổng, công trình phụ, hào cùng các di chỉ và dấu tích liên quan.', 'The Xi’an City Wall conservation regulation protects the Ming wall body, gates, associated structures, moat, and related sites and remains.'),
    '城墙曾属于城市防御体系，今天在保护前提下也承载参观、运动等公共活动。' => ('Tường thành từng thuộc hệ thống phòng thủ đô thị; ngày nay, trong điều kiện được bảo vệ, nó còn phục vụ tham quan, vận động và hoạt động công cộng.', 'The wall once belonged to the urban defence system; today, under conservation, it also supports visiting, exercise, and public activity.'),
    '1983年西安启动环城建设与大规模城墙修复工程，此后保护进入更系统、持续的阶段。' => ('Năm 1983, Tây An khởi động xây dựng vành đai cùng công trình tu sửa tường thành quy mô lớn; từ đó việc bảo vệ trở nên hệ thống và liên tục hơn.', 'In 1983 Xi’an began ring-city construction and large-scale wall restoration, after which conservation entered a more systematic and continuous phase.'),
    '现代保护采用监测点、无损检测和数字化技术跟踪沉降、位移等风险，让传统城墙进入持续的科学管理。' => ('Bảo tồn hiện đại dùng điểm quan trắc, kiểm tra không phá hủy và công nghệ số để theo dõi lún, dịch chuyển và các rủi ro khác.', 'Modern conservation uses monitoring points, non-destructive testing, and digital methods to track settlement, displacement, and other risks.'),
    '西安城墙于1961年被列入第一批全国重点文物保护单位；它也是“中国明清城墙”世界文化遗产预备名录组成部分之一。' => ('Năm 1961, tường thành Tây An được xếp vào đợt đầu di tích trọng điểm cấp quốc gia; nó cũng là một thành phần của hồ sơ dự kiến “Tường thành Minh–Thanh Trung Quốc”.', 'Xi’an City Wall entered the first group of National Key Cultural Relic Protection Units in 1961 and is also one component of the “City Walls of the Ming and Qing Dynasties” World Heritage tentative-list property.'),
    '城墙内仍是西安历史城区，包含历史文化街区和大量各级文物资源；城墙与当代交通、居住、工作和公共生活并存。' => ('Bên trong tường thành vẫn là khu đô thị lịch sử Tây An, có các khu phố lịch sử–văn hóa và nhiều tài nguyên di tích; tường thành cùng tồn tại với giao thông, cư trú, công việc và đời sống công cộng hiện đại.', 'Inside the wall remains Xi’an’s historic urban area, with historic-cultural districts and many heritage resources; the wall coexists with contemporary transport, housing, work, and public life.'),
    _ => throw StateError('Missing Xi\'an Discovery language support: $text'),
  };
  return DiscoveryEntry(
    text: text,
    pinyin: _xianPinyin(text),
    simpleChinese: text,
    vietnamese: support.$1,
    english: support.$2,
  );
}

const _xianDiscoveryIndexesByLevel = <List<int>>[
  <int>[0, 1],
  <int>[1, 0],
  <int>[2, 1],
  <int>[3, 2],
  <int>[4, 3, 2],
  <int>[5, 4, 3],
  <int>[6, 5, 4],
  <int>[7, 6, 5],
  <int>[8, 7, 4],
  <int>[9, 8, 7],
];

final xianCityWallDiscoverySpecs = List<XianDiscoverySpec>.unmodifiable([
  XianDiscoverySpec(level: 1, title: '一圈有多长', storyLink: '周遥把完整一圈设成告别路线。', entry: _discovery('西安城墙周长约13.74公里，今天仍形成封闭的长方形环线。'), keyTerms: const ['13.74公里', '环线'], learnerInsight: '城墙的几何闭合解释了周遥为何误把它当成生活的终点。', check: '周遥为什么能用“一整圈”给自己设终点？', answer: '因为城墙本身形成封闭环线。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'xian-planning-photogrammetry']),
  XianDiscoverySpec(level: 2, title: '永宁门与四门传统', storyLink: '周遥从永宁门起跑并返回这里。', entry: _discovery('明清时期西安城墙传统四门分别为东长乐、南永宁、西安定、北安远；永宁门是南门。'), keyTerms: const ['永宁门', '南门'], learnerInsight: '城门既是防御体系的一部分，也成为现代城市方向坐标。', check: '永宁门位于城墙哪一面？', answer: '南面。', sourceIds: const ['shaanxi-gov-city-wall-2020']),
  XianDiscoverySpec(level: 3, title: '墙顶为何宽', storyLink: '周遥在宽阔墙顶持续跑步。', entry: _discovery('官方资料记载城墙顶宽约12至14米；历史上宽阔墙顶有利于防御、巡查和人员物资调动。'), keyTerms: const ['墙顶', '防御', '巡查'], learnerInsight: '今天能形成连续运动空间，与历史结构尺度有关。', check: '宽阔墙顶过去主要服务什么？', answer: '防御、巡查和调动。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'qujiang-city-wall']),
  XianDiscoverySpec(level: 4, title: '明代主体怎样形成', storyLink: '暮色中周遥经过不同墙段。', entry: _discovery('现存西安城墙主体在明洪武七年至十一年（1374—1378）形成今天的主要尺度，并承接更早城市墙体基础。'), keyTerms: const ['明洪武', '墙体基础'], learnerInsight: '“现存明城墙”并不等于城市历史从明代才开始。', check: '现存城墙主体主要形成于哪个时期？', answer: '明洪武年间。', sourceIds: const ['shaanxi-gov-city-wall-2021', 'shaanxi-heritage-city-wall']),
  XianDiscoverySpec(level: 5, title: '保护对象不只是一堵墙', storyLink: '故事把城门、护城河与墙体一起写入路线。', entry: _discovery('《西安城墙保护条例》把明代城墙墙体、城门、附属建筑、护城河及其遗址遗迹作为西安城墙保护对象。'), keyTerms: const ['墙体', '城门', '护城河'], learnerInsight: '文化遗产保护关注的是相互关联的整体系统。', check: '条例中的保护对象是否只有墙体？', answer: '不是，还包括城门、附属建筑、护城河及遗址遗迹。', sourceIds: const ['shaanxi-city-wall-regulation']),
  XianDiscoverySpec(level: 6, title: '从防御到公共生活', storyLink: '周遥的私人跑步与古代防御空间叠在同一路线上。', entry: _discovery('城墙曾属于城市防御体系，今天在保护前提下也承载参观、运动等公共活动。'), keyTerms: const ['防御', '公共生活'], learnerInsight: '历史空间的功能可以改变，但保护责任不会因此消失。', check: '今天的城墙是否只保留古代军事功能？', answer: '不是，它在保护中进入现代公共生活。', sourceIds: const ['shaanxi-gov-city-wall-2024', 'xian-city-wall-marathon']),
  XianDiscoverySpec(level: 7, title: '为什么要持续修缮', storyLink: '周遥看到的完整环线并非自然保持不变。', entry: _discovery('1983年西安启动环城建设与大规模城墙修复工程，此后保护进入更系统、持续的阶段。'), keyTerms: const ['修缮', '保护'], learnerInsight: '“保存下来”是一项长期工作，不是一次修完就结束。', check: '1983年前后西安对城墙做了什么重要工作？', answer: '启动大规模修复和环城建设。', sourceIds: const ['xian-municipal-conservation']),
  XianDiscoverySpec(level: 8, title: '现代监测怎样进入古墙', storyLink: '故事把新城区与老城放在同一晚景中。', entry: _discovery('现代保护采用监测点、无损检测和数字化技术跟踪沉降、位移等风险，让传统城墙进入持续的科学管理。'), keyTerms: const ['监测', '无损检测', '数字化'], learnerInsight: '保护历史建筑也需要现代工程与数据能力。', check: '监测的目的是什么？', answer: '及时发现结构变化和保护风险。', sourceIds: const ['xian-municipal-conservation', 'xian-planning-photogrammetry']),
  XianDiscoverySpec(level: 9, title: '城墙为何是国家级文物', storyLink: '周遥的个人记忆发生在被国家保护的历史空间上。', entry: _discovery('西安城墙于1961年被列入第一批全国重点文物保护单位；它也是“中国明清城墙”世界文化遗产预备名录组成部分之一。'), keyTerms: const ['全国重点文物保护单位', '预备名录'], learnerInsight: '国家级保护身份与世界遗产预备名录不是同一概念，不能混同。', check: '西安城墙已经是世界文化遗产吗？', answer: '不能这样表述；它属于相关世界文化遗产预备名录。', sourceIds: const ['shaanxi-heritage-register', 'shaanxi-heritage-data-2024']),
  XianDiscoverySpec(level: 10, title: '活着的历史城区', storyLink: '周遥最后把跑步记录命名为“回家”。', entry: _discovery('城墙内仍是西安历史城区，包含历史文化街区和大量各级文物资源；城墙与当代交通、居住、工作和公共生活并存。'), keyTerms: const ['历史城区', '城市生活', '归属'], learnerInsight: '历史城市不是静止展品，而是保护与日常生活持续协商的空间。', check: '为什么故事不把城内写成“过去”？', answer: '因为历史城区今天仍有人生活，并与现代城市持续连接。', sourceIds: const ['shaanxi-old-city-heritage', 'shaanxi-city-wall-regulation']),
]);

final xianCityWallOnePassDiscoveries = List<DiscoveryEntry>.unmodifiable([
  for (final spec in xianCityWallDiscoverySpecs) spec.entry,
]);

final xianCityWallDiscoveryTraces = List<RemediatedDiscoveryTrace>.unmodifiable([
  for (final spec in xianCityWallDiscoverySpecs)
    RemediatedDiscoveryTrace(
      discoveryIndex: spec.level - 1,
      storyEventIds: const ['XIAN-E4-history', 'XIAN-E5-recognition'],
      sourceIds: spec.sourceIds,
    ),
]);

final xianCityWallChallenges = List<XianChallengeSpec>.unmodifiable([
  for (var level = 1; level <= 10; level++) ...<XianChallengeSpec>[
    XianChallengeSpec(level: level, type: 'paragraphRebuild', anchor: xianCityWallOnePassLevels[level - 1].storyParagraphs.first, answer: '按当前等级故事顺序重建周遥从起跑到继续向新家的路线。'),
    XianChallengeSpec(level: level, type: 'grammarRepair', anchor: xianCityWallOnePassLevels[level - 1].storyParagraphs.first, answer: xianCityWallOnePassLevels[level - 1].storyParagraphs.first),
    XianChallengeSpec(level: level, type: 'missingSentence', anchor: _xianMissingSentenceAnswers[level - 1], answer: _xianMissingSentenceAnswers[level - 1]),
  ],
]);

const _xianMissingSentenceAnswers = <String>[
  '他没有按停，而是下城继续往南跑。',
  '周遥抬手看了一眼，没有按停计时，直接下城，沿南边的街道继续向新家跑去。',
  '周遥抬手看了看跑表，没有按停。',
  '周遥没有按停计时。',
  '周遥停了半步，没有按停计时，而是直接下城，沿南边街道继续跑向新家。',
  '周遥抬手，本可以按下停止，却把手指移开。',
  '周遥停了半步，把已经抬起的手放下，没有结束计时。',
  '周遥笑了，把手指从停止键上移开。',
  '周遥抬起手，停了半步，又把手指从停止键上移开。',
  '周遥抬手，手指碰到停止键又移开。',
];

final xianCityWallMemory = List<RemediatedMemoryReview>.unmodifiable([
  const RemediatedMemoryReview(category: 'protagonist', prompt: '谁把最后一次绕城跑设成搬家前的告别？', answer: '周遥，一个在西安城墙内老街长大的二十二岁年轻人。', storyEventIds: ['XIAN-E1-start']),
  const RemediatedMemoryReview(category: 'support', prompt: '谁用新家消息推动故事继续，而不是充当历史导师？', answer: '周遥的母亲；弟弟在高等级故事的新家照片中出现。', storyEventIds: ['XIAN-E3-doubt', 'XIAN-E6-climax']),
  const RemediatedMemoryReview(category: 'route', prompt: '周遥的路线如何变化？', answer: '从永宁门登城，沿城墙完整绕行回到永宁门，再下城向南继续跑到新家。', storyEventIds: ['XIAN-E1-start', 'XIAN-E6-climax', 'XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'history', prompt: '城墙的历史理解是什么？', answer: '现存主体主要在明洪武年间形成，并承接更早城市墙体基础；1961年列入第一批全国重点文物保护单位。', storyEventIds: ['XIAN-E4-history']),
  const RemediatedMemoryReview(category: 'culture', prompt: '故事怎样理解城墙今天的意义？', answer: '它既是受保护的古代防御遗产，也处在当代交通、运动、居住与公共生活中。', storyEventIds: ['XIAN-E4-history', 'XIAN-E5-recognition']),
  const RemediatedMemoryReview(category: 'conflict', prompt: '周遥真正担心的是什么？', answer: '他担心搬到城外会让自己与老城的归属一起结束。', storyEventIds: ['XIAN-E3-doubt']),
  const RemediatedMemoryReview(category: 'turningPoint', prompt: '什么让他怀疑“城门就是生活终点”？', answer: '跑步一路撞上自己过去不断穿城门的上学、骑车、亲友和日常路线。', storyEventIds: ['XIAN-E5-recognition']),
  const RemediatedMemoryReview(category: 'climax', prompt: '整圈完成时周遥做了什么？', answer: '他没有按停跑表，而是从永宁门下城继续向新家跑。', storyEventIds: ['XIAN-E6-climax']),
  const RemediatedMemoryReview(category: 'anchor', prompt: 'Memory Anchor是什么？', answer: '永宁门后没有按停的跑表。', storyEventIds: ['XIAN-E6-climax', 'XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'growth', prompt: '最后的跑步记录说明了什么？', answer: '城墙仍是完整历史空间，但周遥的归属可以沿生活轨迹穿过城门继续生长。', storyEventIds: ['XIAN-E7-ending']),
  const RemediatedMemoryReview(category: 'vocabulary', prompt: '“闭环”和“归属感”在故事里怎样相遇？', answer: '城墙形成物理闭环；归属感却没有被那条闭环限制。', storyEventIds: ['XIAN-E5-recognition', 'XIAN-E6-climax']),
]);

const xianCityWallCompletion = XianCompleteSpec(
  journeySummary: '周遥把搬家前的一整圈城墙跑当成告别，却在回到永宁门后让跑表继续，把闭合环线接到城外的新家。',
  achievement: '续程跑者',
  memoryAnchor: '永宁门后没有按停的跑表',
  anchorMeaning: '跑表在完整一圈之后继续计时，把城墙的闭合形状与周遥不断延伸的生活路线同时保存下来。',
  challengeReward: '长安续程牌',
  rewardMeaning: '不是通行许可或历史复制品，而是一枚记录“完成一圈仍继续前进”的路线徽记。',
  rewardUnlockText: '你已完成西安城墙三种故事挑战，解锁「长安续程牌」。',
  journeyCompletion: '第二天，周遥把从永宁门延伸到新住址的跑步记录命名为“回家”。',
);

const xianCityWallSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2020', publisher: '陕西省人民政府', scope: '13.74公里周长、传统四门与城墙概况'),
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2021', publisher: '陕西省人民政府', scope: '明洪武七年至十一年、墙体尺度与13.74公里周长'),
  RemediatedSourceBinding(id: 'shaanxi-gov-city-wall-2024', publisher: '陕西省人民政府', scope: '古代军事防御体系与城墙概况'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-city-wall', publisher: '陕西省文物局', scope: '西安城墙为明代古建筑、第一批全国重点文物保护单位'),
  RemediatedSourceBinding(id: 'shaanxi-city-wall-regulation', publisher: '陕西省文物局 / 西安市地方性法规', scope: '墙体、城门、附属建筑、护城河及遗址遗迹整体保护'),
  RemediatedSourceBinding(id: 'xian-municipal-conservation', publisher: '西安市人民政府', scope: '1983年以来修复、管理机构与现代监测保护'),
  RemediatedSourceBinding(id: 'xian-planning-photogrammetry', publisher: '西安市自然资源和规划局', scope: '13.74公里、数字化测绘与保护'),
  RemediatedSourceBinding(id: 'xian-city-wall-marathon', publisher: '西安市人民政府', scope: '13.7公里绕城跑赛事与城墙运动使用'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-register', publisher: '陕西省文物局', scope: '西安城墙明代、全国重点文物保护单位登记'),
  RemediatedSourceBinding(id: 'shaanxi-heritage-data-2024', publisher: '陕西省文物局', scope: '中国明清城墙世界文化遗产预备名录组成信息'),
  RemediatedSourceBinding(id: 'shaanxi-old-city-heritage', publisher: '陕西省文物局', scope: '城墙内历史城区、历史文化街区与文物资源'),
  RemediatedSourceBinding(id: 'qujiang-city-wall', publisher: '西安曲江新区管理委员会', scope: '明代城墙、防御体系与修缮信息'),
];

const xianCityWallSemanticEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(id: 'XIAN-E1-start', coreChinese: '周遥从永宁门开始最后一圈跑步。', corePinyin: 'Zhōu Yáo cóng Yǒngníngmén kāishǐ zuìhòu yì quān pǎobù.', coreVietnamese: 'Chu Dao bắt đầu vòng chạy cuối từ cổng Vĩnh Ninh.', coreEnglish: 'Zhou Yao starts his final circuit from Yongning Gate.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E2-view', coreChinese: '夕阳里，他同时看见城内旧街与城外新城区。', corePinyin: 'Xīyáng lǐ tā tóngshí kànjiàn chéngnèi yǔ chéngwài.', coreVietnamese: 'Trong hoàng hôn cậu nhìn thấy cả trong và ngoài thành.', coreEnglish: 'At sunset he sees both inside and outside the wall.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E3-doubt', coreChinese: '搬家消息让他把住址变化误认成归属终止。', corePinyin: 'Bānjiā xiāoxi ràng tā bǎ zhùzhǐ biànhuà wùrèn chéng guīshǔ zhōngzhǐ.', coreVietnamese: 'Tin chuyển nhà khiến cậu nhầm thay đổi địa chỉ với mất cảm giác thuộc về.', coreEnglish: 'The move makes him confuse an address change with the end of belonging.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E4-history', coreChinese: '城墙的防御、明代形成与持续保护进入他的路线。', corePinyin: 'Chéngqiáng de lìshǐ yǔ bǎohù jìnrù tā de lùxiàn.', coreVietnamese: 'Lịch sử và bảo tồn thành đi vào tuyến chạy của cậu.', coreEnglish: 'The wall’s history and conservation enter his route.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E5-recognition', coreChinese: '个人生活路线反复穿过城门，使内外二分失效。', corePinyin: 'Shēnghuó lùxiàn fǎnfù chuānguò chéngmén.', coreVietnamese: 'Các tuyến đời sống nhiều lần đi qua cổng thành.', coreEnglish: 'His lived routes repeatedly pass through the gates.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E6-climax', coreChinese: '回到永宁门后，他让跑表继续并下城向新家跑。', corePinyin: 'Huídào Yǒngníngmén hòu, tā ràng pǎobiǎo jìxù.', coreVietnamese: 'Trở lại Vĩnh Ninh Môn, cậu để đồng hồ tiếp tục chạy.', coreEnglish: 'Back at Yongning Gate, he leaves the watch running.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'XIAN-E7-ending', coreChinese: '他到新家才停表，并把连续路线命名为“回家”。', corePinyin: 'Tā dào xīn jiā cái tíng biǎo, bǎ lùxiàn mìngmíng wéi huíjiā.', coreVietnamese: 'Cậu chỉ dừng đồng hồ ở nhà mới và đặt tên tuyến là “về nhà”.', coreEnglish: 'He stops the watch at the new home and names the route “Home”.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
];

final xianCityWallOnePassRemediation = RemediatedJourney(
  id: xianCityWallJourneyId,
  title: '西安 · 城墙：跑完一圈以后',
  protagonist: '周遥',
  goal: '在全家迁居城外前跑完一整圈城墙，把它当作一次明确的告别。',
  conflict: '周遥把搬出城墙误认为归属结束；完整环线给了他一个虚假的生活终点。',
  eventIds: List<String>.unmodifiable([for (final event in xianCityWallSemanticEvents) event.id]),
  events: xianCityWallSemanticEvents,
  levels: xianCityWallOnePassLevels,
  words: xianCityWallOnePassWords,
  wordTraces: xianCityWallWordTraces,
  discoveries: xianCityWallOnePassDiscoveries,
  discoveryTraces: xianCityWallDiscoveryTraces,
  challenges: List<RemediatedChallengeTrace>.unmodifiable([
    for (final challenge in xianCityWallChallenges)
      RemediatedChallengeTrace(type: challenge.type, storyEventIds: const ['XIAN-E1-start', 'XIAN-E6-climax'], anchor: challenge.anchor),
  ]),
  memory: xianCityWallMemory,
  completion: const RemediatedCompletion(
    journeySummary: '周遥把搬家前的一整圈城墙跑当成告别，却在回到永宁门后让跑表继续，把闭合环线接到城外的新家。',
    achievement: '续程跑者',
    memoryAnchor: '永宁门后没有按停的跑表',
    challengeReward: '长安续程牌：完成一圈仍继续前进的路线徽记。',
    journeyCompletion: '第二天，周遥把从永宁门延伸到新住址的跑步记录命名为“回家”。',
  ),
  sources: xianCityWallSources,
);

JourneyLevelContent xianCityWallOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = xianCityWallOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final visibleWords = xianCityWallOnePassWords
      .where((entry) => story.contains(entry.word))
      .take((4 + level).clamp(5, 12))
      .map((word) => _xianWordWithStoryExamples(level, base.storyParagraphs, word))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(visibleWords),
    discoveries: List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
      for (final index in _xianDiscoveryIndexesByLevel[level - 1])
        xianCityWallDiscoverySpecs[index].entry,
    ]),
    wonderQuestion: '周遥为什么在跑完一整圈后故意不按停跑表？',
    expressQuestion: '城墙的闭合形状与周遥连续的生活路线怎样形成对照？',
  );
}
