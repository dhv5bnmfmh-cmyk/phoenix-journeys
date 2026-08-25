import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';

class ShanghaiBundParagraphSupport {
  const ShanghaiBundParagraphSupport({
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String vietnamese;
  final String english;
}

const _paragraphSupport = <int, List<ShanghaiBundParagraphSupport>>{
  1: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。这个晚上，他要去浦东陆家嘴，为第二天的新工作做准备。母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。林岸说，过了黄浦江，就是离开旧上海，进入新上海。母亲没有劝他留下，只把提单递过去。两人沿江向南走，灯光落在历史建筑和水面上，船只从眼前经过。到金陵东路轮渡站时，林岸一度想把提单还给母亲，最后还是把它放进包里。轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。他忽然觉得，江没有把上海分成过去和未来。船靠东岸后，他继续走向新的工作，也把那张旧单据带过了江。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên ở Ngoại Than và thường giúp gia đình sắp xếp chứng từ vận tải, khai báo hải quan. Tối nay anh chuẩn bị sang Lục Gia Chủy cho công việc mới ngày mai. Mẹ đợi gần Tòa nhà Hải quan, mang theo bản sao vận đơn đường biển cũ của ông ngoại. Anh nói qua Hoàng Phố là rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không giữ anh lại, chỉ đưa vận đơn. Hai người đi về phía nam dọc bờ sông. Đến bến phà đường Đông Kim Lăng, anh từng muốn trả tờ giấy nhưng cuối cùng vẫn cất vào túi. Khi phà rời bờ tây, Ngoại Than lùi xa và các tòa nhà Lục Gia Chủy tiến gần. Anh chợt thấy con sông không chia Thượng Hải thành quá khứ và tương lai; lên bờ đông, anh tiếp tục đi tới công việc mới cùng tờ chứng từ cũ.",
      english:
          "Lin An is twenty-four, grew up on the Bund, and often helped his family sort freight and customs documents. Tonight he is preparing to cross to Lujiazui for a new job the next day. His mother waits near the Customs House with a copy of an old maritime bill of lading left by his maternal grandfather. Lin says crossing the Huangpu will mean leaving old Shanghai and entering new Shanghai. His mother does not ask him to stay; she simply hands him the bill. They walk south along the river. At the East Jinling Road ferry, he briefly wants to return the document but finally puts it in his bag. As the ferry leaves the west bank, the Bund recedes and Lujiazui draws nearer. He suddenly feels that the river does not divide Shanghai into past and future; after landing on the east bank, he continues toward his new work with the old document still with him.",
    ),
  ],
  2: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，熟悉家里的货代和报关生意。第二天，他将到陆家嘴一家金融科技公司的结算团队上班。这个晚上，他先到外滩和母亲见面。她处理货运、海关和单据，约他在海关大楼附近碰头，并带来一张外祖父留下的旧海运提单副本。林岸笑着说，自己终于要过江了，像是从旧上海走进新上海。母亲没有反驳，只问他要不要把这张提单带走。两人沿黄浦江西岸向南走，身后是外滩历史建筑，江上船只拖着灯影，东岸的陆家嘴已经亮起来。林岸几次想把旧纸还给母亲。到金陵东路轮渡站，他还是把提单放进包里。轮渡离岸后，海关大楼和沿岸建筑逐渐变小，浦东高楼越来越近。他忽然明白，江没有把上海分成过去和未来；人、货物、信息和钱一直在两岸之间换着方式流动。到东岸后，他没有改变工作选择，却带着旧单据继续走向陆家嘴。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, quen thuộc việc giao nhận và khai báo hải quan của gia đình. Ngày mai anh sẽ vào đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Tối nay anh gặp mẹ ở Ngoại Than, gần Tòa nhà Hải quan; bà mang theo bản sao vận đơn đường biển cũ của ông ngoại. Anh đùa rằng cuối cùng mình cũng qua sông, như đi từ Thượng Hải cũ sang Thượng Hải mới. Mẹ chỉ hỏi anh có muốn mang tờ vận đơn đi không. Họ đi về phía nam dọc bờ tây Hoàng Phố, giữa các tòa nhà lịch sử, ánh đèn tàu và Lục Gia Chủy sáng lên ở bờ đông. Anh nhiều lần muốn trả tờ giấy, nhưng tại bến phà đường Đông Kim Lăng vẫn cất nó vào túi. Khi phà rời bờ, anh hiểu rằng con sông không chia thành phố thành quá khứ và tương lai: người, hàng hóa, thông tin và tiền vẫn đổi cách thức để lưu chuyển giữa hai bờ. Anh không đổi lựa chọn nghề nghiệp, nhưng mang tờ chứng từ cũ tiếp tục đi Lục Gia Chủy.",
      english:
          "Lin An, twenty-four, knows his family freight-forwarding and customs business well. The next day he will join a fintech settlement team in Lujiazui. That evening he meets his mother on the Bund near the Customs House; she brings a copy of an old maritime bill of lading left by his maternal grandfather. He jokes that he is finally crossing the river, as if moving from old Shanghai into new Shanghai. His mother only asks whether he wants to take the bill with him. They walk south along the west bank of the Huangpu, with historic Bund buildings behind them, vessel lights on the river, and Lujiazui lit across the water. He repeatedly considers returning the old paper, yet at the East Jinling Road ferry he puts it in his bag. Once the ferry leaves, he understands that the river does not divide the city into past and future: people, goods, information, and money keep moving between the banks through changing means. He keeps his new career choice and carries the old document toward Lujiazui.",
    ),
  ],
  3: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，从小熟悉家里的货代和报关单。第二天，他要到浦东陆家嘴一家金融科技公司的结算团队上班。傍晚，他先到外滩见母亲。她约他在海关大楼附近碰头，递来一张外祖父留下的旧海运提单副本。林岸望着对岸说，过了黄浦江，就是离开旧上海、进入新上海。母亲没有劝他留下，只问他要不要把提单带走。两人沿江向南走，历史建筑的灯光落在水面，船只从眼前经过。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, từ nhỏ đã quen với việc giao nhận và tờ khai hải quan của gia đình. Ngày mai anh sẽ làm trong đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Chiều tối, anh gặp mẹ ở Ngoại Than gần Tòa nhà Hải quan. Bà đưa anh bản sao vận đơn đường biển cũ của ông ngoại. Nhìn sang bờ đối diện, anh nói qua Hoàng Phố là rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không giữ anh lại, chỉ hỏi anh có muốn mang vận đơn đi không. Hai người đi về phía nam, ánh đèn các công trình lịch sử phản xuống mặt nước và tàu thuyền đi qua trước mắt.",
      english:
          "Lin An is twenty-four and has known his family freight-forwarding and customs paperwork since childhood. The next day he will join a fintech settlement team in Lujiazui. At dusk he first meets his mother on the Bund near the Customs House. She hands him a copy of an old maritime bill of lading left by his maternal grandfather. Looking across the river, he says that crossing the Huangpu means leaving old Shanghai and entering new Shanghai. His mother does not ask him to stay; she only asks whether he wants to take the bill. They walk south as lights from the historic buildings fall across the water and vessels pass in front of them.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "到金陵东路轮渡站前，林岸几次想把提单还给母亲。她只提起他小时候拿作废报关单折纸船，没有讲大道理。临上船，他还是把提单放进包里。轮渡离开西岸，外滩慢慢退远，陆家嘴越来越近。林岸忽然觉得，江没有把上海分成过去和未来。货物、文件、信用、信息和资金只是换了工具继续流动。到东岸后，他没有回去接家业，也没有放弃新工作，只带着那张普通旧单据继续走向陆家嘴。",
      vietnamese:
          "Trước khi đến bến phà đường Đông Kim Lăng, Lâm Ngạn nhiều lần muốn trả vận đơn cho mẹ. Bà chỉ nhắc chuyện hồi nhỏ anh từng gấp thuyền giấy bằng tờ khai hải quan bỏ đi. Trước khi lên phà, anh vẫn cất vận đơn vào túi. Khi phà rời bờ tây, Ngoại Than lùi xa và Lục Gia Chủy tiến gần. Anh nhận ra con sông không chia Thượng Hải thành quá khứ và tương lai; hàng hóa, giấy tờ, tín dụng, thông tin và vốn chỉ đổi công cụ để tiếp tục lưu chuyển. Sang bờ đông, anh không quay về tiếp quản việc nhà cũng không từ bỏ công việc mới, mà mang tờ chứng từ bình thường ấy tiếp tục tới Lục Gia Chủy.",
      english:
          "Before reaching the East Jinling Road ferry, Lin An repeatedly wants to return the bill to his mother. She only recalls how he used discarded customs forms to fold paper boats as a child. Before boarding, he still puts the bill in his bag. As the ferry leaves the west bank, the Bund recedes and Lujiazui approaches. He realizes that the river does not divide Shanghai into past and future; goods, documents, credit, information, and capital simply change tools as they continue to move. On the east bank, he neither returns to take over the family business nor abandons his new job. He carries the ordinary old document onward to Lujiazui.",
    ),
  ],
  4: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，家里多年做货代与报关文件。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到。他把这份工作想成一次彻底转身：从船、货物和纸张，进入账户与数字结算。傍晚，他来到外滩，在海关大楼附近见母亲。母亲刚结束一天的文件工作，递给他一张外祖父留下的旧海运提单副本。那只是一张普通商业文件。林岸望向黄浦江对岸，说自己终于要“离开旧上海，进入新上海”。母亲没有反对，只问这张纸要不要带走。两人沿滨水空间向南走，外滩历史建筑、江上船灯和东岸高楼同时进入视野。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, gia đình nhiều năm làm giao nhận và chứng từ hải quan. Ngày mai anh sẽ trình diện tại đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Anh xem công việc này là một bước ngoặt dứt khoát: từ tàu, hàng hóa và giấy tờ sang tài khoản và thanh toán số. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan ở Ngoại Than. Bà vừa xong một ngày làm chứng từ và đưa anh bản sao vận đơn đường biển cũ của ông ngoại, chỉ là một giấy tờ thương mại bình thường. Nhìn sang bờ bên kia, anh nói mình cuối cùng cũng sắp rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không phản đối, chỉ hỏi có mang tờ giấy theo không. Khi họ đi về phía nam, các tòa nhà lịch sử, đèn tàu và cao ốc bờ đông cùng xuất hiện trong tầm mắt.",
      english:
          "Lin An is twenty-four, and his family has worked for years with freight forwarding and customs documents. The next day he will report to a fintech settlement team in Lujiazui. He imagines the job as a complete turn: from ships, cargo, and paper into accounts and digital settlement. At dusk he meets his mother near the Bund Customs House. She has just finished a day of document work and gives him a copy of an old maritime bill of lading left by his maternal grandfather, an ordinary commercial document. Looking across the Huangpu, he says he is finally about to leave old Shanghai and enter new Shanghai. His mother does not object; she simply asks whether he wants to take the paper. As they walk south, historic Bund buildings, vessel lights, and towers on the east bank share the same view.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "临近金陵东路轮渡站，林岸反复摸到包里的提单，觉得新公司的系统与这张旧纸毫不相干。母亲没有讲历史，只笑他小时候爱拿作废报关单折纸船。检票前，林岸最终把提单放进电脑包，独自上船。轮渡推开西岸，海关大楼和外滩灯光逐渐缩小，货船仍沿江移动，浦东天际线迎面升高。他忽然明白，江没有把上海分成过去和未来。旧单据记录货物、信用和付款责任，新系统处理更快的数据与结算，但两者都在组织流动。到东岸后，他仍选择新职业，只是不再把旧单据当成必须丢下的过去。",
      vietnamese:
          "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn liên tục chạm vào vận đơn trong túi và cho rằng hệ thống của công ty mới chẳng liên quan gì đến tờ giấy cũ. Mẹ không giảng lịch sử, chỉ cười nhắc chuyện anh từng gấp thuyền bằng tờ khai hải quan bỏ đi. Trước cửa soát vé, anh cất vận đơn vào túi máy tính và lên phà một mình. Tòa nhà Hải quan và ánh đèn Ngoại Than nhỏ dần, tàu hàng vẫn chạy trên sông và đường chân trời Phố Đông dâng lên trước mặt. Anh hiểu con sông không chia Thượng Hải thành quá khứ và tương lai: giấy tờ cũ ghi hàng hóa, tín dụng và trách nhiệm thanh toán, còn hệ thống mới xử lý dữ liệu và thanh toán nhanh hơn, nhưng cả hai đều tổ chức sự lưu chuyển. Sang bờ đông, anh vẫn chọn nghề mới nhưng không còn xem tờ chứng từ cũ là quá khứ bắt buộc phải bỏ lại.",
      english:
          "Near the East Jinling Road ferry, Lin An keeps touching the bill in his bag and thinks the new company’s system has nothing to do with the old paper. His mother gives no history lecture; she only laughs about how he folded discarded customs forms into paper boats as a child. Before the ticket gate, he puts the bill into his computer bag and boards alone. The Customs House and Bund lights shrink behind him, cargo vessels continue along the river, and the Pudong skyline rises ahead. He understands that the river does not divide Shanghai into past and future: old documents record goods, credit, and payment responsibilities, while new systems process faster data and settlement, but both organize flows. On the east bank he still chooses the new career, yet no longer treats the old document as a past that must be discarded.",
    ),
  ],
  5: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。家里的货代生意不大，桌上却常有订舱资料、报关文件、提单副本和结算凭证。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队上班。他把这份工作想成一次干净的切割：西岸属于船、海关和纸张，东岸属于数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她刚结束文件工作，递给他一张外祖父留下的旧海运提单副本。那不是古董，只记录过一票普通货物的承运、交付和责任。林岸看着江对岸说：“过了江，我就算离开旧上海了。”母亲没有纠正，只问：“那这张纸呢？”两人沿滨水空间向南走，历史建筑、船灯和陆家嘴的高楼一起亮起来。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong một gia đình gắn với thương mại cảng Thượng Hải. Việc giao nhận của gia đình nhỏ nhưng bàn làm việc luôn có tài liệu đặt chỗ, khai báo hải quan, bản sao vận đơn và chứng từ thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy. Anh coi đó là một đường cắt sạch: bờ tây thuộc về tàu, hải quan và giấy tờ; bờ đông thuộc về dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan. Bà đưa anh bản sao vận đơn cũ của ông ngoại, không phải đồ cổ mà chỉ ghi việc vận chuyển, giao hàng và trách nhiệm của một lô hàng bình thường. Anh nói qua sông là rời Thượng Hải cũ. Mẹ chỉ hỏi: Vậy tờ giấy này thì sao? Khi họ đi về phía nam, công trình lịch sử, đèn tàu và cao ốc Lục Gia Chủy cùng sáng lên.",
      english:
          "Lin An is twenty-four and grew up in a family connected to Shanghai port trade. The family freight business is small, but booking records, customs documents, bill-of-lading copies, and settlement vouchers often cover the desk. The next day he will join a fintech settlement team in Lujiazui. He imagines a clean cut: the west bank belongs to ships, customs, and paper; the east bank to data, accounts, and new financial infrastructure. At dusk he meets his mother near the Bund Customs House. She gives him an old bill-of-lading copy left by his maternal grandfather, not an antique but a record of carriage, delivery, and responsibility for an ordinary shipment. He says crossing the river will mean leaving old Shanghai. His mother only asks what that means for the paper. As they walk south, historic buildings, vessel lights, and Lujiazui towers all light up together.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "走到金陵东路轮渡站前，林岸几次想把旧提单还给母亲。他觉得数字结算与这张纸没有关系。母亲没有劝他接班，只提起他小时候常拿作废报关单折纸船。检票前，他们在闸口分开，林岸最后把提单塞进电脑包，独自上船。轮渡离开浦西，外滩与海关钟楼渐渐退后，货船沿主航道穿行，浦东天际线越来越近。就在两岸同时进入视野的几分钟里，他忽然觉得，江没有把上海分成过去和未来。货物、文件、信用、信息、结算和资本从来不是停在一岸的东西，只是载体不断变化。抵达东昌路一侧后，他继续向陆家嘴走，仍然选择新职业，却把那张旧单据一起带了过去。",
      vietnamese:
          "Trước bến phà đường Đông Kim Lăng, Lâm Ngạn nhiều lần muốn trả vận đơn vì nghĩ thanh toán số không liên quan tới tờ giấy. Mẹ không bảo anh nối nghiệp, chỉ kể chuyện anh từng gấp thuyền bằng tờ khai hải quan bỏ đi. Ở cửa soát vé họ chia tay; anh cất vận đơn vào túi máy tính và lên phà một mình. Ngoại Than và tháp đồng hồ Hải quan lùi lại, tàu hàng chạy theo luồng chính và đường chân trời Phố Đông tiến gần. Trong vài phút nhìn thấy hai bờ cùng lúc, anh nhận ra sông không chia thành phố thành quá khứ và tương lai. Hàng hóa, giấy tờ, tín dụng, thông tin, thanh toán và vốn không đứng yên ở một bờ; chỉ vật mang chúng thay đổi. Đến phía Đông Xương, anh tiếp tục tới Lục Gia Chủy, vẫn chọn nghề mới nhưng mang tờ chứng từ cũ sang cùng mình.",
      english:
          "Before the East Jinling Road ferry, Lin An repeatedly considers returning the bill because he thinks digital settlement has nothing to do with the paper. His mother does not ask him to inherit the business; she only recalls his childhood paper boats made from discarded customs forms. They part at the gate, and he puts the bill in his computer bag before boarding alone. The Bund and Customs House clock tower fall behind, cargo ships move along the main channel, and the Pudong skyline approaches. During the few minutes when both banks are visible together, he realizes that the river does not divide the city into past and future. Goods, documents, credit, information, settlement, and capital do not stay on one bank; their carriers keep changing. Reaching the Dongchang Road side, he continues toward Lujiazui, still choosing the new career but carrying the old document across.",
    ),
  ],
  6: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母做货代与单证业务，他从小见惯订舱确认、报关资料、提单副本和结算凭证。第二天，他要到浦东陆家嘴一家金融科技公司的结算团队报到，参与更快的跨机构支付与资金交收。他把这份新工作想成一次切割：西岸留下船舶、海关和纸张，东岸属于数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。母亲递给他一张外祖父留下的旧海运提单副本，纸面只记录一票普通货物的承运、交付与责任。林岸望向对岸，说：“明天开始，我就从旧上海走进新上海。”母亲没有阻止，只问：“换了工具，就一定要把以前的东西留在这边吗？”两人沿黄浦江西岸向南走，历史建筑、钟声、江上船灯与浦东玻璃幕墙在暮色中并列。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Cha mẹ làm giao nhận và chứng từ; anh quen nhìn xác nhận đặt chỗ, hồ sơ khai quan, bản sao vận đơn và chứng từ thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia thanh toán và giao nhận vốn giữa các tổ chức nhanh hơn. Anh xem đó là một sự cắt đứt: bờ tây để lại tàu, hải quan và giấy tờ; bờ đông thuộc về dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan. Bà đưa bản sao vận đơn cũ của ông ngoại, chỉ ghi việc vận chuyển, giao hàng và trách nhiệm của một lô hàng bình thường. Anh nói ngày mai sẽ đi từ Thượng Hải cũ sang Thượng Hải mới. Mẹ hỏi liệu đổi công cụ có nhất thiết phải bỏ lại những thứ trước kia ở bờ này không. Họ đi về phía nam, giữa công trình lịch sử, tiếng chuông, đèn tàu và mặt kính Phố Đông trong hoàng hôn.",
      english:
          "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents handle freight forwarding and trade documents, so he has long seen booking confirmations, customs materials, bill-of-lading copies, and settlement vouchers. The next day he will join a fintech settlement team in Lujiazui working on faster inter-institutional payments and fund settlement. He imagines a break: ships, customs, and paper remain on the west bank, while data, accounts, and new financial infrastructure belong to the east. At dusk he meets his mother near the Bund Customs House. She gives him an old bill-of-lading copy from his maternal grandfather, recording only the carriage, delivery, and responsibility for an ordinary shipment. He says tomorrow he will move from old Shanghai into new Shanghai. His mother asks whether changing tools really means leaving everything earlier on this bank. They walk south among historic buildings, clock sounds, vessel lights, and Pudong glass facades in the dusk.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。但这些知识一直只是背景。包里的旧提单碰着电脑边角，他几次想还给母亲。母亲没有讲历史，只说他小时候拿作废报关单折纸船。检票前，他们在闸口告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开西岸，外滩与海关大楼慢慢后退，货船继续移动，浦东天际线逐渐抬高。他忽然意识到，江没有把上海分成过去和未来。旧提单把货物、信用、责任和付款写在纸上，新系统把关系变成数据与实时指令；城市改变的是组织流动的方式。到东岸后，他继续走向陆家嘴，旧工作留在身后，旧单据却跟着他过了江。",
      vietnamese:
          "Khi gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ rằng việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; các chức năng thương mại, vận tải biển, hải quan, ngân hàng và kinh doanh ở Ngoại Than hình thành qua một quá trình dài, không phải trong một đêm. Nhưng với anh, kiến thức ấy vẫn chỉ là bối cảnh. Vận đơn cũ chạm vào cạnh máy tính trong túi; anh nhiều lần muốn trả lại. Mẹ không giảng sử, chỉ nhắc chuyện anh từng gấp thuyền bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé và anh mang vận đơn lên phà. Khi Ngoại Than và Tòa nhà Hải quan lùi xa, tàu hàng vẫn chuyển động và đường chân trời Phố Đông dâng lên. Anh nhận ra con sông không chia Thượng Hải thành quá khứ và tương lai: vận đơn viết hàng hóa, tín dụng, trách nhiệm và thanh toán trên giấy, còn hệ thống mới biến quan hệ đó thành dữ liệu và chỉ thị thời gian thực. Sang bờ đông, anh tiếp tục tới Lục Gia Chủy; công việc cũ ở lại nhưng tờ chứng từ cũ đi cùng anh.",
      english:
          "Near the East Jinling Road ferry, Lin An remembers that Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system, and that trade, shipping, customs, banking, and commercial functions on the Bund developed over a long period rather than overnight. Yet he has treated that knowledge as background. The old bill touches the edge of his computer in the bag, and he repeatedly considers returning it. His mother does not lecture him on history; she only mentions his childhood paper boats made from discarded customs forms. They part at the gate and he takes the bill onto the ferry. As the Bund and Customs House fall behind, cargo ships keep moving and the Pudong skyline rises. He realizes that the river does not divide Shanghai into past and future: the old bill records goods, credit, responsibility, and payment on paper, while the new system turns those relationships into data and real-time instructions. On the east bank he continues to Lujiazui; the old work remains behind, but the old document has crossed with him.",
    ),
  ],
  7: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营货代与单证业务，办公室里没有传奇，只有订舱确认、报关资料、提单副本和反复核对的结算数字。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收。他喜欢那种即时、清晰、几乎看不见纸张的方式，也把它理解成与家庭旧行业的决裂：西岸是船、海关和纸面凭证，东岸是数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本，只记录一票普通货物的承运、交付和责任。林岸望着黄浦江对岸亮起的陆家嘴，说：“过了江，我就算离开旧上海，进入新上海。”母亲没有反驳，只问：“你真觉得一条江能切得这么开？”两人沿滨水空间向南走，历史建筑、海关钟声、江上船灯和对岸玻璃幕墙叠在暮色里。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Văn phòng giao nhận và chứng từ của cha mẹ không có huyền thoại, chỉ có xác nhận đặt chỗ, hồ sơ khai quan, bản sao vận đơn và những con số thanh toán phải kiểm tra nhiều lần. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia thanh toán và giao nhận vốn giữa các tổ chức. Anh thích sự tức thời, rõ ràng và gần như không giấy tờ ấy, nên xem đó là đoạn tuyệt với ngành cũ của gia đình: bờ tây là tàu, hải quan và chứng từ giấy; bờ đông là dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối, mẹ đưa anh bản sao vận đơn cũ của ông ngoại gần Tòa nhà Hải quan. Anh nói qua sông là rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ hỏi anh có thật tin một con sông có thể chia cắt rạch ròi như vậy không. Họ đi về phía nam, với kiến trúc lịch sử, tiếng chuông Hải quan, đèn tàu và mặt kính bờ đông chồng lên nhau trong hoàng hôn.",
      english:
          "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight-forwarding and document office has no legends, only booking confirmations, customs materials, bill copies, and settlement figures checked again and again. The next day he will join a fintech settlement team in Lujiazui for inter-institutional payments and fund settlement. He likes its immediate, clear, nearly paperless method and treats it as a break with the family’s old industry: the west bank is ships, customs, and paper credentials; the east bank is data, accounts, and new financial infrastructure. At dusk near the Customs House, his mother gives him an old bill-of-lading copy from his maternal grandfather. He says crossing the river will mean leaving old Shanghai for new Shanghai. His mother asks whether he truly thinks one river can divide things so cleanly. They walk south as historic architecture, the Customs House clock, vessel lights, and glass facades across the river overlap in the dusk.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "走向金陵东路轮渡站时，林岸想起1843年的开埠发生在十九世纪不平等条约体系下，此后贸易、航运、海关、银行与商业功能经过数十年发展，不是某一夜突然完成。他懂这些，却仍觉得它们只属于过去。包里的提单碰着电脑边角，他几次想还回去。母亲没有讲课，只说他小时候会拿作废报关单折纸船。到闸口，两人分开。林岸把提单塞进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑与海关钟楼慢慢后退，货船沿主航道穿行，陆家嘴天际线越来越高。距离反而让两岸同时清楚起来。他忽然觉得，江没有把上海分成过去和未来。旧单据把货物、信用、责任与付款写在纸上，新系统把这些关系变成数据、消息和实时结算；形式更新了，城市仍在重新组织人、货物、信息与资本的流动。到东岸后，他继续向陆家嘴走，不再需要先否定一岸，才能走向另一岸。",
      vietnamese:
          "Trên đường tới bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 nằm trong hệ thống điều ước bất bình đẳng thế kỷ XIX, và các chức năng thương mại, vận tải, hải quan, ngân hàng, kinh doanh hình thành qua nhiều thập kỷ chứ không bỗng xuất hiện trong một đêm. Anh hiểu điều đó nhưng vẫn xem là chuyện quá khứ. Vận đơn chạm cạnh máy tính và anh nhiều lần muốn trả lại. Mẹ không lên lớp, chỉ nhắc chuyện thuyền giấy bằng tờ khai bỏ đi. Hai người chia tay ở cửa soát vé; anh cất vận đơn vào túi máy tính và lên phà. Ngoại Than và tháp đồng hồ Hải quan lùi lại, tàu hàng đi theo luồng chính, Lục Gia Chủy cao dần phía trước. Khoảng cách trên sông khiến hai bờ cùng rõ hơn. Anh hiểu giấy tờ cũ viết hàng hóa, tín dụng, trách nhiệm và thanh toán trên giấy, hệ thống mới biến các quan hệ đó thành dữ liệu, thông điệp và thanh toán thời gian thực; hình thức đổi nhưng thành phố vẫn tổ chức lại dòng người, hàng hóa, thông tin và vốn. Sang bờ đông, anh không cần phủ định một bờ mới có thể đi tới bờ kia.",
      english:
          "Walking toward the East Jinling Road ferry, Lin An recalls that the 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system and that trade, shipping, customs, banking, and commercial functions developed over decades rather than appearing overnight. He knows this but has still treated it as belonging only to the past. The bill touches the edge of his computer and he repeatedly wants to return it. His mother gives no lecture, only the paper-boat memory. They part at the gate; he slips the bill into the computer compartment and boards. The Bund and Customs House clock tower recede, cargo ships follow the main channel, and Lujiazui rises ahead. Distance makes both banks clearer at once. He sees that old documents put goods, credit, responsibility, and payment on paper, while the new system turns those relationships into data, messages, and real-time settlement; forms change, but the city still reorganizes flows of people, goods, information, and capital. On the east bank, he no longer needs to deny one side in order to move toward the other.",
    ),
  ],
  8: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母的货代和单证业务从来不浪漫：改船期、核对报关资料、追提单副本、确认运费和结算条件，都是日常。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收。对他而言，这份工作意味着速度、自动化和一种不必再被纸张拖住的生活。他甚至把两岸分成两个时代：西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸代表数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父保存下来的旧海运提单副本。纸已经发黄，却没有秘密，只记录过一票货物的承运、交付与责任。林岸望向黄浦江对岸亮起的陆家嘴，说：“明天我就算离开旧上海，进入新上海。”母亲没有阻止，只问：“你换的是工作，还是要把来路也留在这边？”两人沿滨水空间向南走，外滩历史建筑、海关钟声、船只和对岸玻璃幕墙一起被晚风推到身边。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Công việc giao nhận và chứng từ của cha mẹ rất đời thường: đổi lịch tàu, kiểm tra hồ sơ khai quan, đuổi theo bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy. Với anh, công việc mới tượng trưng cho tốc độ, tự động hóa và một cuộc sống không còn bị giấy tờ kéo chậm. Anh thậm chí chia hai bờ thành hai thời đại: bờ tây giữ tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ của cha mẹ; bờ đông đại diện dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối gần Tòa nhà Hải quan, mẹ đưa anh bản sao vận đơn cũ đã ngả vàng của ông ngoại, chỉ ghi một lô hàng bình thường. Anh nói ngày mai mình sẽ rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ hỏi anh đổi công việc hay muốn bỏ cả nguồn gốc ở bờ này. Họ đi về phía nam giữa kiến trúc Ngoại Than, tiếng chuông Hải quan, tàu thuyền và mặt kính bờ đông.",
      english:
          "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight and document work is thoroughly ordinary: changing sailing dates, checking customs materials, chasing bill copies, and confirming freight and settlement terms. The next day he will join a fintech settlement team in Lujiazui. To him, the job means speed, automation, and a life no longer slowed by paper. He even divides the banks into two eras: the west bank keeps ships, customs, old bank buildings, and his parents’ filing cabinets; the east represents data, accounts, and new financial infrastructure. At dusk near the Customs House, his mother gives him a yellowing old bill copy from his maternal grandfather, recording nothing secret, only an ordinary shipment. He says tomorrow he will leave old Shanghai and enter new Shanghai. His mother asks whether he is changing jobs or trying to leave his own origins on this bank. They walk south among Bund architecture, the Customs House clock, river traffic, and glass facades across the water.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系中，之后贸易、航运、海关、银行和商业机构在黄浦江西岸经历了长期聚集与变化，不是一条可以被“现代化”三个字抹平的直线。包里的旧提单碰着电脑边角，他几次准备递回去。母亲没讲历史，只笑他说小时候爱拿作废报关单折纸船。到了闸口，他们在人流里告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑和海关钟楼退成发亮的岸线，货船继续移动；浦东天际线从前方抬高。水面距离让两岸同时进入他的视野。他忽然觉得，江没有把上海分成过去和未来。旧提单以纸面记录货物、信用、责任和付款，新系统用数据、消息与实时指令组织结算；工具和速度改变，城市仍在重新安排人、货物、信息与资本怎样抵达彼此。船到东昌路一侧后，他继续向陆家嘴走，仍离开家里的旧工作，也仍期待新职业，只是回望外滩时，西岸不再是必须删除的背景。",
      vietnamese:
          "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng; sau đó các cơ quan thương mại, vận tải, hải quan, ngân hàng và kinh doanh ở bờ tây Hoàng Phố trải qua quá trình tập trung và biến đổi lâu dài, không phải một đường thẳng có thể xóa bằng ba chữ hiện đại hóa. Anh nhiều lần định trả vận đơn. Mẹ không giảng sử, chỉ cười nhắc chuyện anh từng gấp thuyền bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé, và anh mang tờ giấy lên phà. Khi bờ sáng của Ngoại Than lùi lại và đường chân trời Phố Đông dâng lên, khoảng cách mặt nước cho anh thấy hai bờ cùng lúc. Anh hiểu con sông không chia thành phố thành quá khứ và tương lai: vận đơn giấy ghi hàng hóa, tín dụng, trách nhiệm và thanh toán; hệ thống mới dùng dữ liệu, thông điệp và chỉ thị thời gian thực. Công cụ và tốc độ đổi, nhưng thành phố vẫn sắp xếp lại cách người, hàng, thông tin và vốn đến với nhau. Tới phía Đông Xương, anh vẫn rời công việc cũ và mong đợi nghề mới, chỉ không còn xem bờ tây là nền cũ phải xóa.",
      english:
          "Near the East Jinling Road ferry, Lin An recalls that the 1843 opening occurred within the unequal-treaty system and that trade, shipping, customs, banking, and commercial institutions on the west bank of the Huangpu went through long processes of concentration and change, not a straight line that can be flattened into the word modernization. He repeatedly prepares to return the old bill. His mother gives no history lesson; she only laughs about the paper boats he folded from discarded customs forms. They part at the gate and he takes the document onto the ferry. As the bright Bund shoreline recedes and the Pudong skyline rises, the water lets him see both banks at once. He realizes that the river does not divide the city into past and future: paper bills record goods, credit, responsibility, and payment, while new systems use data, messages, and real-time instructions. Tools and speed change, but the city still reorganizes how people, goods, information, and capital reach one another. At Dongchang Road, he still leaves the family’s old work and looks forward to the new career, but no longer treats the west bank as a background that must be erased.",
    ),
  ],
  9: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营货代与单证业务，日常是更改船期、核对报关资料、追提单副本、确认运费与结算条件。小时候，他只觉得文件占满餐桌；长大后，他选择了另一条路。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收系统。自动化的账户连接，让他相信自己终于摆脱了纸张和港口的迟缓。他把黄浦江两岸划成两个时代：西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸属于数据、算法、实时结算和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本。那张纸没有收藏价值，也没有秘密，只记录过一票普通货物的承运、交付和责任。林岸望着对岸亮起的陆家嘴，说：“明天开始，我就算离开旧上海，进入新上海。”母亲没有劝他接班，只问：“你换的是工作，还是要把来路也留在这一岸？”他们沿外滩滨水空间向南走，历史建筑、海关钟声、江上船只与浦东玻璃幕墙，被黄浦江同时收进暮色。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Cha mẹ làm giao nhận và chứng từ, hằng ngày đổi lịch tàu, kiểm tra hồ sơ khai quan, đuổi theo bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Khi nhỏ anh chỉ thấy giấy tờ chiếm bàn ăn; lớn lên anh chọn con đường khác. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia hệ thống thanh toán và giao nhận vốn giữa các tổ chức. Kết nối tài khoản tự động khiến anh tin mình cuối cùng thoát khỏi sự chậm chạp của giấy tờ và cảng. Anh chia hai bờ thành hai thời đại: bờ tây là tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ; bờ đông là dữ liệu, thuật toán, thanh toán thời gian thực và hạ tầng tài chính mới. Chiều tối, mẹ đưa anh bản sao vận đơn cũ của ông ngoại gần Tòa nhà Hải quan. Tờ giấy không có giá trị sưu tầm, chỉ ghi một lô hàng bình thường. Anh nói ngày mai mình sẽ rời Thượng Hải cũ. Mẹ không bảo anh nối nghiệp, chỉ hỏi anh đổi công việc hay định để cả nguồn gốc lại ở bờ này. Họ đi về phía nam, để Hoàng Phố cùng lúc thu kiến trúc lịch sử, tiếng chuông Hải quan, tàu thuyền và mặt kính Phố Đông vào hoàng hôn.",
      english:
          "Lin An is twenty-four and grew up in a family connected to Shanghai port trade. His parents’ freight and document work means changing sailing dates, checking customs files, chasing bill copies, and confirming freight and settlement terms. As a child he only saw paperwork taking over the dining table; as an adult he chose another path. The next day he will join a fintech settlement team in Lujiazui working on inter-institutional payment and fund-settlement systems. Automated account connections make him believe he has finally escaped the slowness of paper and port work. He divides the banks into two eras: ships, customs, old bank buildings, and filing cabinets on the west; data, algorithms, real-time settlement, and new financial infrastructure on the east. At dusk his mother gives him an old bill-of-lading copy from his maternal grandfather near the Customs House. The paper has no collectible value and records only an ordinary shipment. He says tomorrow he will leave old Shanghai. His mother does not ask him to inherit the business; she asks whether he is changing jobs or leaving his origins on this bank as well. Walking south, they see the Huangpu hold historic architecture, the Customs House clock, river traffic, and Pudong glass together in the dusk.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后贸易、航运、海关、银行与商业机构在外滩及周边经过数十年发展与重组，绝不是“旧城市忽然变成现代城市”的轻快故事。可他一直把这些知识留在课本里。包里的旧提单碰着电脑边角，他几次想还给母亲。母亲没有趁机讲课，只提到他小时候拿她作废的报关单折纸船。到了闸口，他们在人流中告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑和海关钟楼退成发亮的岸线，货船沿主航道继续向前；浦东天际线从前方抬高。水面距离把两岸同时展开，他觉得自己过去那条“旧到新”的直线太窄。江没有把上海分成过去和未来。旧提单把货物、信用、责任、信息与付款写在纸上，今天的系统把它们变成数据、消息、规则和实时结算；工具改变，组织流动的需要不断重组。船到东昌路一侧后，他走向陆家嘴，没有回去接手家业，也没有怀疑新工作。他只是回头看了一眼：外滩不再是被新天际线淘汰的旧背景，陆家嘴也不再是从零开始的未来。",
      vietnamese:
          "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 nằm trong hệ thống điều ước bất bình đẳng, sau đó các cơ quan thương mại, vận tải, hải quan, ngân hàng và kinh doanh ở Ngoại Than cùng vùng lân cận phát triển và tái tổ chức qua nhiều thập kỷ; đó tuyệt nhiên không phải câu chuyện nhẹ nhàng thành phố cũ bỗng thành hiện đại. Trước đây anh để kiến thức ấy trong sách giáo khoa. Anh nhiều lần muốn trả vận đơn nhưng mẹ chỉ nhắc chuyện thuyền giấy. Họ chia tay ở cửa soát vé và anh lên phà với tờ giấy trong túi máy tính. Ngoại Than lùi thành một dải sáng, tàu hàng tiếp tục trên luồng chính và Phố Đông dâng lên trước mặt. Khoảng cách mở hai bờ cùng lúc, khiến đường thẳng cũ đến mới anh từng tin trở nên quá hẹp. Vận đơn viết hàng hóa, tín dụng, trách nhiệm, thông tin và thanh toán trên giấy; hệ thống hôm nay biến chúng thành dữ liệu, thông điệp, quy tắc và thanh toán thời gian thực. Công cụ thay đổi nhưng nhu cầu tổ chức lưu chuyển liên tục tái cấu trúc. Sang phía Đông Xương, anh đi Lục Gia Chủy, không tiếp quản việc nhà nhưng cũng không nghi ngờ nghề mới; anh chỉ thấy Ngoại Than không phải nền cũ bị đường chân trời mới đào thải và Lục Gia Chủy không phải tương lai bắt đầu từ số không.",
      english:
          "Near the East Jinling Road ferry, Lin An recalls that the 1843 treaty-port opening belonged to the unequal-treaty system and that trade, shipping, customs, banking, and commercial institutions around the Bund developed and reorganized over decades; this was never a light story of an old city suddenly becoming modern. He had kept that knowledge in textbooks. He repeatedly considers returning the bill, but his mother only mentions the paper boats. They part at the gate and he boards with the document in his computer bag. The Bund recedes into a bright line, cargo ships continue along the main channel, and Pudong rises ahead. The water opens both banks at once and makes his old straight line from old to new seem too narrow. The bill writes goods, credit, responsibility, information, and payment on paper; today’s system turns them into data, messages, rules, and real-time settlement. Tools change while the need to organize flows keeps being restructured. At Dongchang Road he walks toward Lujiazui, neither taking over the family business nor doubting the new career; he simply sees that the Bund is not an old background eliminated by a new skyline and Lujiazui is not a future that began from zero.",
    ),
  ],
  10: <ShanghaiBundParagraphSupport>[
    ShanghaiBundParagraphSupport(
      chinese:
          "林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营的货代与单证业务，日常是临时更改船期、反复核对报关资料、追一份提单副本、确认运费与结算条件。小时候，他嫌文件占满餐桌；读大学后，他更愿意相信“新”意味着摆脱纸面流程。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收系统。自动化的账户连接，让他把新职业理解成一次彻底切割：黄浦江西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸属于数据、算法、实时结算和新的金融基础设施。傍晚，他来到外滩，在海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本。纸面泛黄，却没有秘密，只记录过一票普通货物的承运、交付和责任。林岸望着对岸陆家嘴亮起的楼群，说：“明天开始，我就算离开旧上海，进入新上海。”母亲既没有劝他接班，也没有替旧行业辩护，只问：“你换的是工作，还是要把来路也留在这一岸？”他们沿外滩滨水空间向南走，历史建筑、海关钟声、游船和工作船的声音，以及对岸玻璃幕墙反射的夕光，被黄浦江同时收进一个移动的画面。",
      vietnamese:
          "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Công việc giao nhận và chứng từ của cha mẹ hằng ngày là đổi lịch tàu gấp, kiểm tra đi kiểm tra lại hồ sơ khai quan, tìm bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Khi nhỏ anh khó chịu vì giấy tờ chiếm bàn ăn; lên đại học anh càng tin rằng mới nghĩa là thoát khỏi quy trình giấy. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia hệ thống thanh toán và giao nhận vốn giữa các tổ chức. Kết nối tài khoản tự động khiến anh xem nghề mới như một sự cắt đứt: bờ tây Hoàng Phố giữ tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ của cha mẹ; bờ đông thuộc về dữ liệu, thuật toán, thanh toán thời gian thực và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan ở Ngoại Than. Bà đưa bản sao vận đơn cũ đã ngả vàng của ông ngoại, chỉ ghi một lô hàng bình thường. Anh nói ngày mai sẽ rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ không yêu cầu anh nối nghiệp cũng không biện hộ cho ngành cũ, chỉ hỏi anh đổi công việc hay muốn bỏ cả nguồn gốc ở bờ này. Khi họ đi về phía nam, kiến trúc lịch sử, tiếng chuông Hải quan, du thuyền, tàu công vụ và ánh chiều phản trên mặt kính bờ đông cùng nằm trong một hình ảnh chuyển động của Hoàng Phố.",
      english:
          "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight and document work is the daily routine of last-minute sailing changes, repeated customs checks, chasing a bill copy, and confirming freight and settlement terms. As a child he resented paperwork covering the dining table; at university he became more willing to believe that new meant escaping paper processes. The next day he will join a fintech settlement team in Lujiazui working on inter-institutional payment and fund-settlement systems. Automated account connections make him interpret the new career as a complete cut: ships, customs, old bank buildings, and his parents’ filing cabinets remain on the west bank of the Huangpu; data, algorithms, real-time settlement, and new financial infrastructure belong to the east. At dusk he meets his mother on the Bund near the Customs House. She gives him a yellowing old bill-of-lading copy left by his maternal grandfather, recording only an ordinary shipment. He says tomorrow he will leave old Shanghai for new Shanghai. His mother neither asks him to inherit the business nor defends the old industry; she asks whether he is changing jobs or leaving his origins on this bank. As they walk south, historic architecture, the Customs House clock, tour boats, working vessels, and sunset reflected from glass across the river share one moving Huangpu scene.",
    ),
    ShanghaiBundParagraphSupport(
      chinese:
          "接近金陵东路轮渡站时，林岸想起自己并非不了解脚下的城市。上海1843年的开埠发生在十九世纪不平等条约体系下，随后贸易、航运、海关、银行与商业机构在外滩及周边经历长期聚集与重组；近代城市经济不是某一天突然启动，现代浦东也没有把西岸的金融与航运历史一键清空。只是这些历史以前属于课本和展板，与他自己的未来隔着一层玻璃。包里的旧提单碰到电脑边角，他几次想把它还给母亲。母亲没有趁机讲历史，只笑着提起他小时候会拿她作废的报关单折纸船。到了闸口，他们在人流里告别。林岸最终把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑与海关钟楼退成一条发亮的岸线，主航道上的货船继续前进；浦东天际线从前方抬高。水面距离让两岸同时清楚。他忽然觉得，江没有把上海分成过去和未来。旧提单把货物、信用、责任、信息与付款写在纸上，今天的系统把相似关系变成数据、消息、规则和实时结算；工具、速度和天际线改变了，城市仍在重新组织人、货物、信息与资本如何抵达彼此。船到东昌路一侧后，他继续向陆家嘴走，没有回去接手家业，也仍期待新职业。回头时，外滩不再是等待被淘汰的旧背景，陆家嘴也不再需要独占“未来”这个词。那张旧单据已经跟他一起过了江。",
      vietnamese:
          "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ mình không hề thiếu kiến thức về thành phố dưới chân. Việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; sau đó thương mại, vận tải, hải quan, ngân hàng và các cơ quan kinh doanh ở Ngoại Than cùng vùng lân cận tập trung và tái tổ chức trong thời gian dài. Kinh tế đô thị cận đại không khởi động trong một ngày, và Phố Đông hiện đại cũng không xóa sạch lịch sử tài chính, vận tải của bờ tây. Trước kia, lịch sử ấy chỉ nằm trong sách và bảng trưng bày. Vận đơn cũ chạm cạnh máy tính và anh nhiều lần muốn trả lại; mẹ chỉ cười nhắc chuyện thuyền giấy bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé, anh đặt vận đơn vào ngăn máy tính và lên phà một mình. Khi Ngoại Than và tháp đồng hồ Hải quan lùi thành dải sáng, tàu hàng vẫn chạy trên luồng chính và đường chân trời Phố Đông dâng lên. Hai bờ cùng rõ làm anh thấy con sông không chia Thượng Hải thành quá khứ và tương lai. Vận đơn viết hàng hóa, tín dụng, trách nhiệm, thông tin và thanh toán trên giấy; hệ thống hôm nay biến các quan hệ tương tự thành dữ liệu, thông điệp, quy tắc và thanh toán thời gian thực. Công cụ, tốc độ và đường chân trời thay đổi, nhưng thành phố vẫn tổ chức lại cách người, hàng, thông tin và vốn đến với nhau. Sang phía Đông Xương, anh vẫn đi Lục Gia Chủy, không tiếp quản việc nhà và vẫn mong đợi nghề mới; khi ngoái lại, Ngoại Than không còn là nền cũ chờ bị đào thải và Lục Gia Chủy cũng không cần độc chiếm chữ tương lai. Tờ chứng từ cũ đã cùng anh qua sông.",
      english:
          "Near the East Jinling Road ferry, Lin An remembers that he is not ignorant of the city beneath his feet. Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system; trade, shipping, customs, banking, and commercial institutions around the Bund then underwent long processes of concentration and reorganization. The modern urban economy did not start on a single day, and modern Pudong did not erase the west bank’s financial and shipping history. Previously, that history had stayed behind the glass of textbooks and displays. The old bill touches the edge of his computer and he repeatedly wants to return it; his mother only laughs about paper boats made from discarded customs forms. They part at the gate, and he puts the bill in the computer compartment before boarding alone. As the Bund and Customs House clock tower recede into a bright line, cargo ships continue along the main channel and the Pudong skyline rises. Seeing both banks clearly at once, he realizes that the river does not divide Shanghai into past and future. The old bill writes goods, credit, responsibility, information, and payment on paper; today’s system turns similar relationships into data, messages, rules, and real-time settlement. Tools, speed, and skylines change, but the city keeps reorganizing how people, goods, information, and capital reach one another. At Dongchang Road he still walks toward Lujiazui, does not take over the family business, and still looks forward to the new career; when he looks back, the Bund is no longer an old background waiting to be eliminated, and Lujiazui no longer needs to monopolize the word future. The old document has crossed the river with him.",
    ),
  ],
};

const _sourceSupport = <String, ShanghaiBundParagraphSupport>{
  "这个晚上，他先到外滩和母亲见面。": ShanghaiBundParagraphSupport(
    chinese: "这个晚上，他先到外滩和母亲见面。",
    vietnamese: "Tối hôm đó, trước tiên anh đến Ngoại Than gặp mẹ.",
    english: "That evening, he first goes to the Bund to meet his mother.",
  ),
  "林岸说，过了黄浦江，就是离开旧上海，进入新上海。": ShanghaiBundParagraphSupport(
    chinese: "林岸说，过了黄浦江，就是离开旧上海，进入新上海。",
    vietnamese:
        "Lâm Ngạn nói rằng qua Hoàng Phố nghĩa là rời Thượng Hải cũ và bước vào Thượng Hải mới.",
    english:
        "Lin An says that crossing the Huangpu means leaving old Shanghai and entering new Shanghai.",
  ),
  "第二天，他将到陆家嘴一家金融科技公司的结算团队上班。": ShanghaiBundParagraphSupport(
    chinese: "第二天，他将到陆家嘴一家金融科技公司的结算团队上班。",
    vietnamese:
        "Ngày hôm sau, anh sẽ làm việc trong đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy.",
    english:
        "The next day, he will work on the settlement team of a fintech company in Lujiazui.",
  ),
  "母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。": ShanghaiBundParagraphSupport(
    chinese: "母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。",
    vietnamese:
        "Mẹ đợi anh gần Tòa nhà Hải quan, cầm một bản sao vận đơn đường biển cũ do ông ngoại để lại.",
    english:
        "His mother waits near the Customs House holding a copy of an old maritime bill of lading left by his maternal grandfather.",
  ),
  "轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。": ShanghaiBundParagraphSupport(
    chinese: "轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。",
    vietnamese:
        "Khi phà rời bờ tây, anh thấy Ngoại Than dần lùi xa và những tòa nhà cao tầng của Lục Gia Chủy ngày càng gần.",
    english:
        "As the ferry leaves the west bank, he sees the Bund recede while Lujiazui’s towers draw closer.",
  ),
  "林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。": ShanghaiBundParagraphSupport(
    chinese: "林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。",
    vietnamese:
        "Lâm Ngạn 24 tuổi, lớn lên ở Ngoại Than và thường giúp gia đình sắp xếp chứng từ vận tải và tờ khai hải quan.",
    english:
        "Lin An is twenty-four, grew up on the Bund, and often helps his family organize freight documents and customs declarations.",
  ),
  "货物、文件、信用、信息和资金只是换了工具继续流动。": ShanghaiBundParagraphSupport(
    chinese: "货物、文件、信用、信息和资金只是换了工具继续流动。",
    vietnamese:
        "Hàng hóa, giấy tờ, tín dụng, thông tin và vốn chỉ thay đổi công cụ rồi tiếp tục lưu chuyển.",
    english:
        "Goods, documents, credit, information, and capital simply change tools and continue to flow.",
  ),
  "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。":
      ShanghaiBundParagraphSupport(
    chinese:
        "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。",
    vietnamese:
        "Khi gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ rằng việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; sau đó các chức năng thương mại, vận tải, hải quan, ngân hàng và kinh doanh của Ngoại Than phát triển trong thời gian dài chứ không hình thành chỉ trong một đêm.",
    english:
        "Near the East Jinling Road ferry, Lin An recalls that Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system and that the Bund’s trade, shipping, customs, banking, and commercial functions developed over a long period rather than overnight.",
  ),
};

String _pinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

int shanghaiBundLevelForParagraphs(List<String> paragraphs) {
  for (final entry in _paragraphSupport.entries) {
    final expected = entry.value;
    if (expected.length != paragraphs.length) continue;
    var matches = true;
    for (var index = 0; index < expected.length; index++) {
      if (expected[index].chinese != paragraphs[index]) {
        matches = false;
        break;
      }
    }
    if (matches) return entry.key;
  }
  throw StateError(
      'Shanghai Bund Story paragraphs do not match any canonical level');
}

ReadingAnnotation shanghaiBundReadingAnnotationFor(
  int level,
  int paragraphIndex,
  String chinese,
) {
  final supports = _paragraphSupport[level];
  if (supports == null || paragraphIndex >= supports.length) {
    throw StateError(
      'Missing Shanghai Bund paragraph support for Lv$level paragraph ${paragraphIndex + 1}',
    );
  }
  final support = supports[paragraphIndex];
  if (support.chinese != chinese) {
    throw StateError(
      'Stale Shanghai Bund paragraph support at Lv$level paragraph ${paragraphIndex + 1}',
    );
  }
  return ReadingAnnotation(
    pinyin: _pinyin(chinese),
    vietnamese: support.vietnamese,
    english: support.english,
  );
}

List<WordExample> shanghaiBundWordExamples(String source) {
  final support = _sourceSupport[source];
  if (support == null || support.chinese != source) {
    throw StateError(
        'Missing Shanghai Bund vocabulary source support: $source');
  }
  return List<WordExample>.unmodifiable(<WordExample>[
    WordExample(
      chinese: source,
      pinyin: _pinyin(source),
      vietnamese: support.vietnamese,
      english: support.english,
    ),
    WordExample(
      chinese: '故事原句：$source',
      pinyin: _pinyin('故事原句：$source'),
      vietnamese: 'Câu trong truyện: ${support.vietnamese}',
      english: 'Story sentence: ${support.english}',
    ),
    WordExample(
      chinese: '回看故事原句：$source',
      pinyin: _pinyin('回看故事原句：$source'),
      vietnamese: 'Đọc lại câu trong truyện: ${support.vietnamese}',
      english: 'Review the story sentence: ${support.english}',
    ),
  ]);
}
