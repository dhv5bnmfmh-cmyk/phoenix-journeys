import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';
import 'journey_level_catalog.dart';

const forbiddenCityJourneyId = 'beijing-forbidden-city';
const forbiddenCityReferenceLocationId = 'PHOENIX_REFERENCE_LOCATION_001';
const forbiddenCityCanonicalPlaceId = 'cn-beijing-dongcheng-forbidden-city';
const forbiddenCityMemoryAnchor = '两条都能走通的路线';
const forbiddenCityCoreTakeaway = '一条常用路线，并不等于唯一正确的路线。';

class ForbiddenCityWordRecord {
  const ForbiddenCityWordRecord({
    required this.entry,
    required this.usageNote,
    required this.storySource,
    required this.firstAppearsAt,
    required this.contrastNote,
    required this.narrativeNote,
  });

  final WordEntry entry;
  final String usageNote;
  final String storySource;
  final int firstAppearsAt;
  final String contrastNote;
  final String narrativeNote;
}

class ForbiddenCityMemoryReview {
  const ForbiddenCityMemoryReview({required this.prompt, required this.answer});

  final String prompt;
  final String answer;
}

class ForbiddenCityMemoryMoment {
  const ForbiddenCityMemoryMoment({
    required this.level,
    required this.anchor,
    required this.recall,
    required this.characterShift,
    required this.takeaway,
  });

  final int level;
  final String anchor;
  final String recall;
  final String characterShift;
  final String takeaway;
}

class ForbiddenCityCompletionMoment {
  const ForbiddenCityCompletionMoment({
    required this.level,
    required this.storyClosure,
    required this.discovery,
    required this.learning,
    required this.memory,
    required this.relationship,
    required this.emotionalClosure,
    required this.unlockResult,
  });

  final int level;
  final String storyClosure;
  final String discovery;
  final String learning;
  final String memory;
  final String relationship;
  final String emotionalClosure;
  final String unlockResult;

  String get narration => <String>[
        storyClosure,
        discovery,
        learning,
        '记住：$memory',
        relationship,
        emotionalClosure,
        unlockResult,
      ].join(' ');
}

final forbiddenCityStoryParagraphsByLevel = <List<String>>[
  <String>[
    '十七岁的古建学徒沈砚跟周师傅走进紫禁城。他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。阿宁却从东侧来到乾清门前。她要把一份记录送到东边，目标和沈砚不同。沈砚说她走错了。阿宁没有争，她请沈砚一起看两条路怎样到达同一个地方。沈砚看清后没有擦掉阿宁的线，而是把两条路线都留下。临走时，他请阿宁把自己的路线再画清楚；阿宁也愿意听他说明中轴。',
  ],
  <String>[
    '十七岁的古建学徒沈砚跟周师傅进入紫禁城。他从午门沿中轴向北做空间记录，一直走到乾清门前。他把这条常用路线画得很直，觉得同一个地方只该有一种正确走法。阿宁从东侧来到这里，她的任务是把记录送回东边，所以没有沿沈砚的路线移动。沈砚马上说：“你的线和我的不一样。”阿宁回答：“先别删。跟我看一次，再决定。”她主动带沈砚比较两条路线的方向和终点。两条线都能到乾清门前，却服务不同任务。沈砚把阿宁的线保留下来，并在旁边写出两人的目标。阿宁原以为他只相信纸上的主线，看到这个改变后，也请他帮自己标出中轴的位置。',
  ],
  <String>[
    '十七岁的古建学徒沈砚随周师傅从午门进入紫禁城。他沿中轴记录宫门和院落，把自己的学习路线一路画到乾清门前。因为这条路线清楚、常用，他认定它应该成为图上的唯一答案。阿宁却从东侧来到同一个地方。她今天的任务是送回一份东边的记录，路线先贴着东侧空间移动，再在乾清门前与沈砚汇合。沈砚看到两条线不同，立刻判断阿宁走错了。',
    '阿宁没有让他改口，而是做了一个选择：她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。两人重新对照宫门、院落、方向和共同终点，发现两条路线都能走通，只是目标不同。沈砚把两条线同时画进一张图，并请阿宁亲手标出她的路线。阿宁也补上一笔中轴，让自己的线能和沈砚的观察发生关系。周师傅看完只问：“现在这张图说明了什么？”沈砚答：“常走的一条路，不等于只有这一条路是对的。”',
  ],
  <String>[
    '十七岁的古建学徒沈砚随周师傅从午门进入紫禁城。他沿中轴观察外朝的宫门与院落，再向乾清门前移动。中轴让他的记录很容易组织，他因此把自己的路线当成整张图的标准。阿宁从东侧来到乾清门前，她的任务与东边的记录点相连，随后还要回到东侧。沈砚认为，如果两人都理解建筑，他们的线就应该完全相同。阿宁却指出：“建筑相同，不代表我们的目标相同。”',
    '她主动请沈砚把图放在一边，先看空间连接。两人比较午门、中轴、外朝、乾清门前和东侧入口的关系，发现建筑提供了可行的连接条件，却没有替他们决定同一个目标。沈砚重新画图，不再用一条线覆盖另一条，而是标出两人的任务与共同到达点。阿宁看到他愿意根据空间和任务修改判断，也把自己原先只顾赶路的记录补完整。周师傅说，这张图终于既能看见建筑，也能看见人在建筑里为什么这样走。',
  ],
  <String>[
    '沈砚的任务是把紫禁城的一段空间关系画得让别人能读懂。他从午门进入，沿中轴观察外朝的宫门、院落与方向，再到乾清门前。他把这条常用路线画成粗线，认定“清楚”就应该意味着只有一条主线。阿宁从东侧来到乾清门前。她负责核对东边几个记录点，路线因此围绕自己的任务展开。沈砚看见她的线偏离中轴，判断她的方法不够准确；阿宁没有接受这个判断，也没有要求他删掉自己的线。',
    '阿宁选择先让证据说话。她请沈砚和她逐点核对：哪里由院落相连，哪里通过宫门转向，哪里两条线在乾清门前会合。沈砚发现，自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。于是他在图上分别标注“中轴观察”和“东侧记录”，把两条路线都保留。这个选择也改变了两人的合作方式：沈砚开始先问阿宁看到了什么，阿宁则愿意把自己的局部记录交给他一起整理。',
  ],
  <String>[
    '沈砚想做一张能解释紫禁城空间组织的学习图。他从午门进入，沿中轴穿过外朝的连续院落与宫门，把路线连接到乾清门前；从这里再向北，空间进入与内廷关系更密切的区域。中轴给了他稳定的观察顺序，他便误把“最容易组织的路线”当成“所有人都应采用的路线”。阿宁的任务不同：她从东侧空间来到乾清门前，核对记录后还要回到东边。她的路线没有复制沈砚的线，却同样利用真实的宫门和连接关系。到乾清门前，阿宁没有急着证明自己，而是先把东侧经过的宫门和院落一一指给沈砚看，问他哪些连接是两个人共同面对的。',
    '阿宁主动提出把“路线对不对”拆成两个问题：空间能不能连接，路线是不是适合这个人的任务。两人逐项比较后，沈砚承认自己的图只表达了一个观察顺序。他把外朝、内廷、共同节点和两人的任务一起标注在图上，不再把阿宁的路线降成次要旁线。阿宁也改变了对沈砚的看法：她原以为他只会守着自己的图，现在愿意让他把中轴关系补进她的记录。两张路线因此不再互相排斥，而是共同解释同一座宫城。周师傅让他们把理由写在路线旁。沈砚第一次发现，图上多一条线并不会让关系变乱，反而能看清每条线为什么出现。',
  ],
  <String>[
    '沈砚从午门沿中轴记录外朝的宫门和院落，到乾清门前时，他已经形成一个判断：这条连续、清楚、常用的线最能代表紫禁城的空间组织。阿宁从东侧来到乾清门前，她要完成东边的记录任务，所以路线从一开始就服从另一个目标。沈砚把差异当成错误，阿宁却要求他先检查证据。她没有只说“我也对”，而是带他回看两条线分别经过的连接点，并让他区分“建筑允许怎样连接”和“任务要求我去哪里”。阿宁把自己的任务记录递给沈砚，让他先指出其中与宫门、院落不相符的地方；若找不到，就不能只因为路线不同判她错。',
    '证据改变了争论。中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。两人面对的是同一组建筑约束，却从不同任务与视角作出选择。沈砚因此撤回“只有一条正确路线”的判断，在图上标出共同节点、不同目标和各自路线。阿宁看到他愿意让证据改变结论，也不再把他当成只相信图纸的人。周师傅让他们交换图笔：沈砚请阿宁画她的线，阿宁请沈砚补上中轴与外朝的关系。沈砚重新检查后，在两条路线旁分别写下“空间连接”“任务目标”“下一步行动”。阿宁看到他真正改了判断，也把自己原先只顾赶路的几处记录补成别人能读懂的说明。',
  ],
  <String>[
    '沈砚在午门进入紫禁城后，沿中轴观察外朝。他记录连续的宫门、院落与方向，到乾清门前时，把这条清晰的观察路线当成理解宫城的首选框架。阿宁却从东侧空间抵达同一位置。她负责核对东边的记录点，选择的路线优先满足任务效率。沈砚最初用自己的图评价她，认为偏离中轴就削弱了路线的解释力。阿宁没有把冲突变成输赢，她主动提出三个问题：两条线各自有哪些空间证据？各自服务谁的任务？哪些建筑条件是两人都不能忽略的？她把东侧记录摊开，请沈砚先删掉任何不符合建筑连接的部分；沈砚检查后只能指出两处表达不清，却找不到“这条线不成立”的空间证据。阿宁因此要求他把“常用”与“唯一”分开。',
    '他们重新检查后发现，中轴、宫门与院落构成共同的空间条件，乾清门前又是两条路线可以相遇的位置；真正不同的是人物的目标、视角和下一步行动。沈砚据此改变判断：一条路线可以是常用框架，却不能自动取得排他的地位。他让阿宁决定怎样呈现自己的路线，自己只补充两条线之间的连接说明。阿宁则主动把原先只为完成任务而画的线改成别人也能读懂的记录。两人的合作从“谁纠正谁”变成“谁提供哪一种证据”。周师傅没有给答案，只让两人各自为对方补一条证据。沈砚补上中轴与外朝的关系，阿宁补上东侧门户与共同节点的关系。图上出现了相同条件下的不同优先次序，也出现了两人新的分工：谁提出判断，谁就要说明依据。',
  ],
  <String>[
    '沈砚从午门沿中轴进入紫禁城，外朝连续的宫门与院落让他的观察形成稳定的空间骨架。到乾清门前，他把这条常用路线视为最有解释力的路线偏好，并进一步误认为其他路线都应向它靠拢。阿宁从东侧抵达，她的任务要求她在东边几个记录点之间移动，再到乾清门前与周师傅会合。她不否认中轴的重要性，却指出：如果只用沈砚的视角评价所有行动，图会隐藏任务差异。为了证明这一点，她主动放慢自己的进度，和沈砚逐点检查两条路线的空间证据。沈砚起初还想把阿宁的路线画成细线，表示“次要”。阿宁没有争线条粗细，她把自己的记录折到他面前，让他逐项检查：东侧节点是否真实相连，乾清门前是否能会合，任务是否要求她返回东边。三项都成立后，她只问：“如果条件成立，为什么一定要降级？”',
    '比较结果没有把任何一条线变成错误。建筑的中轴、宫门、院落、外朝与内廷关系构成共同条件，但这些条件并不会取消人物目标。沈砚意识到，自己的路线偏好来自学习任务，而不是来自一条支配所有行动的答案。他于是把图改成多层表示：共同空间骨架放在底层，两人的目标和路线分别标在上面。更重要的是，他把解释阿宁路线的笔交给阿宁本人。阿宁也不再把沈砚看作只守主线的人，她请他指出自己的记录在哪些地方缺少整体空间关系。两人的图因为保留差异而变得更完整。周师傅让两人交换图笔。沈砚不能替阿宁解释她的动机，只能标出共同空间骨架；阿宁不能否定中轴的重要性，只能说明自己的任务怎样改变优先次序。最后两层路线仍然分开，但每一层都能看到另一层的条件。沈砚把原先的粗细等级擦掉，改用同样清楚的线条。',
  ],
  <String>[
    '沈砚想把紫禁城画成一张“任何人一看就知道怎样走”的图。他从午门沿中轴进入，外朝连续的宫门与院落提供强烈的南北秩序；到乾清门前，外朝与内廷的关系又让这里成为理解空间转换的重要位置。于是他把自己的学习路线设为默认答案。阿宁从东侧抵达，她负责东边记录点，必须在任务效率、可连接的宫门与会合地点之间权衡。她承认沈砚的路线适合读中轴，却拒绝把“适合一种任务”偷换成“适合所有任务”。她主动让沈砚用三类证据检验两条线：建筑连接、人物目标、行动后果。阿宁先把自己的路线交给沈砚，让他按三类证据逐项挑错。沈砚发现东侧节点与乾清门前的连接成立，却质疑她只顾任务效率，可能忽略整体空间关系。阿宁接受这一点，主动在记录上补出中轴和外朝；随后她反过来问沈砚：若他的路线适合学习观察，却让东侧任务多绕一段，他凭什么把它称作所有人的默认答案？',
    '沈砚逐项重画后发现，两条路线共享午门以后所读到的宫城结构，也在乾清门前发生关系，但它们的空间偏好由不同任务塑造。若删掉阿宁的线，图会失去东侧任务的行动逻辑；若否认中轴，阿宁的局部记录又难以放回整体。沈砚因此不再裁定谁服从谁，而是保留两条路线并写下各自成立的条件。阿宁看到他愿意让别人的证据改变图的结构，也把自己的记录交给他补充整体关系。周师傅最后没有选“标准答案”，只让他们共同署名。沈砚在图角写下一句：一条常用路线，并不等于唯一正确的路线。周师傅把两张草图并排放下，要求他们各自说出删掉对方路线会失去什么。沈砚说会失去东侧任务的行动逻辑；阿宁说会失去中轴把局部放回整体的能力。两人于是把“可连接”“适合任务”“能解释整体”分成三栏，在每条路线旁写明成立条件。共同署名前，沈砚把最后一处“标准路线”改成“常用观察路线”，阿宁也把“最快”改成“对本次任务更直接”。',
  ],
];

final forbiddenCityLockedStories = forbiddenCityStoryParagraphsByLevel
    .map((paragraphs) => paragraphs.join('\n\n'))
    .toList(growable: false);

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

const _support = <List<(String, String)>>[
  <(String, String)>[
    (
      'Thẩm Nghiên đi từ Ngọ Môn theo trục giữa đến Càn Thanh Môn và cho rằng đó là tuyến đúng duy nhất. A Ninh đến từ phía đông vì có mục tiêu khác. Cô chủ động đề nghị so sánh hai tuyến; cuối cùng cả hai giữ lại hai đường và bắt đầu tôn trọng cách quan sát của nhau.',
      'Shen Yan walks from the Meridian Gate along the central axis to the Gate of Heavenly Purity and assumes it is the only correct route. A Ning arrives from the east for a different goal. She actively asks him to compare the two routes; they keep both lines and begin respecting each other’s observations.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên xem tuyến quen thuộc dọc trục giữa là cách đi đúng duy nhất. A Ninh có nhiệm vụ ở phía đông, nên cô mời anh đi kiểm tra thay vì tranh cãi. Hai tuyến cùng đến Càn Thanh Môn và phục vụ hai nhiệm vụ khác nhau; cả hai cũng thay đổi cách nhìn về nhau.',
      'Shen Yan treats the familiar central-axis route as the only correct way. A Ning has an east-side task, so she invites him to check rather than argue. Both routes reach the Gate of Heavenly Purity for different tasks, and both characters revise how they see each other.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên ghi cổng và sân dọc trục giữa rồi coi tuyến của mình là đáp án duy nhất. A Ninh đến từ phía đông để hoàn thành một nhiệm vụ khác, nên hai người xung đột về cách đọc cùng một không gian.',
      'Shen Yan records gates and courtyards along the central axis and treats his route as the single answer. A Ning approaches from the east for a different task, creating a conflict over how to read the same space.',
    ),
    (
      'A Ninh chủ động hy sinh thời gian để dẫn Thẩm Nghiên kiểm tra lại các điểm nối. Anh giữ cả hai tuyến và mời cô tự đánh dấu đường của mình; cô cũng thêm trục giữa để hai bản ghi liên hệ được với nhau.',
      'A Ning deliberately gives up time to lead Shen Yan back through the connections. He keeps both routes and asks her to mark her own line; she adds the central axis so the two records can relate to each other.',
    ),
  ],
  <(String, String)>[
    (
      'Trục giữa giúp Thẩm Nghiên tổ chức quan sát Ngoại triều, nhưng nhiệm vụ phía đông khiến A Ninh tiếp cận Càn Thanh Môn theo cách khác.',
      'The central axis helps Shen Yan organize his view of the Outer Court, while A Ning’s east-side task brings her to the Gate of Heavenly Purity by another approach.',
    ),
    (
      'Họ tách câu hỏi “không gian nối được hay không” khỏi “tuyến nào phù hợp với mục tiêu”. Thẩm Nghiên sửa phán đoán, còn A Ninh bổ sung bản ghi của mình để hợp tác tốt hơn.',
      'They separate “can the spaces connect?” from “which route fits the goal?” Shen Yan revises his judgment, while A Ning improves her own record for better collaboration.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên coi sự rõ ràng của tuyến trục giữa là lý do để chọn một đường chính. A Ninh có nhiệm vụ riêng ở phía đông và không chấp nhận việc tuyến của mình bị xem là kém chính xác.',
      'Shen Yan treats the clarity of the central-axis route as a reason to choose one main line. A Ning has her own east-side task and rejects the claim that her route is less accurate.',
    ),
    (
      'A Ninh yêu cầu kiểm tra bằng chứng tại các cổng, sân và điểm gặp. Thẩm Nghiên ghi rõ hai nhiệm vụ và hai tuyến; quan hệ của họ chuyển từ phán xét sang trao đổi quan sát.',
      'A Ning asks them to check evidence at gates, courtyards, and the meeting point. Shen Yan labels both tasks and routes; their relationship moves from judgment toward exchanging observations.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên nhận ra mình đã nhầm tuyến dễ tổ chức nhất với tuyến mà mọi người phải dùng. A Ninh phân biệt khả năng kết nối của kiến trúc với sự phù hợp của tuyến đối với nhiệm vụ.',
      'Shen Yan realizes he confused the easiest route to organize with a route everyone must use. A Ning distinguishes architectural connectivity from a route’s fitness for a task.',
    ),
    (
      'Anh ghi Ngoại triều, Nội đình, điểm chung và nhiệm vụ thay vì hạ tuyến của A Ninh xuống thành đường phụ. Cả hai cũng thay đổi đánh giá về khả năng hợp tác của người kia.',
      'He labels the Outer Court, Inner Court, shared point, and tasks instead of demoting A Ning’s route to a side line. Both also revise their judgment of the other as a collaborator.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên coi tuyến trục giữa liên tục là cách đại diện tốt nhất cho không gian. A Ninh yêu cầu anh kiểm tra bằng chứng và tách điều kiến trúc cho phép khỏi điều nhiệm vụ yêu cầu.',
      'Shen Yan treats the continuous central-axis route as the best representation of space. A Ning asks him to inspect evidence and separate what architecture permits from what a task requires.',
    ),
    (
      'Cùng một ràng buộc kiến trúc có thể dẫn đến lựa chọn khác khi nhiệm vụ và góc nhìn khác nhau. Thẩm Nghiên rút lại phán đoán độc nhất; A Ninh cũng thay đổi cách nhìn về anh.',
      'The same architectural constraints can produce different choices when tasks and perspectives differ. Shen Yan withdraws his exclusive judgment; A Ning also changes how she sees him.',
    ),
  ],
  <(String, String)>[
    (
      'A Ninh biến xung đột thành ba câu hỏi về bằng chứng không gian, nhiệm vụ và những điều kiện kiến trúc không thể bỏ qua. Điều đó buộc Thẩm Nghiên kiểm tra góc nhìn của chính mình.',
      'A Ning turns the conflict into three questions about spatial evidence, tasks, and architectural conditions that neither route can ignore. This forces Shen Yan to examine his own perspective.',
    ),
    (
      'Họ thấy trục, cổng và sân là điều kiện chung, nhưng mục tiêu tạo ra lựa chọn khác. Quan hệ chuyển từ “ai sửa ai” thành “ai cung cấp loại bằng chứng nào”.',
      'They find that axes, gates, and courtyards are shared conditions, while goals produce different choices. Their relationship shifts from “who corrects whom” to “who contributes which evidence.”',
    ),
  ],
  <(String, String)>[
    (
      'Tuyến dọc trục giữa là một ưu tiên có sức giải thích đối với nhiệm vụ học của Thẩm Nghiên, còn A Ninh cần một tuyến phù hợp với các điểm ghi chép phía đông.',
      'The central-axis route is an explanatory preference for Shen Yan’s study task, while A Ning needs a route suited to east-side recording points.',
    ),
    (
      'Họ tách khung không gian chung khỏi mục tiêu riêng, rồi vẽ chúng thành nhiều lớp. Thẩm Nghiên trao quyền giải thích tuyến của A Ninh cho chính cô; cô nhờ anh bổ sung quan hệ tổng thể.',
      'They separate the shared spatial framework from individual goals and map them in layers. Shen Yan gives A Ning authority over explaining her route; she asks him to add the broader spatial relation.',
    ),
  ],
  <(String, String)>[
    (
      'Thẩm Nghiên dùng tuyến dọc trục giữa như đáp án mặc định. A Ninh phải cân nhắc nhiệm vụ, kết nối kiến trúc và điểm gặp, nên cô yêu cầu kiểm tra hai tuyến bằng ba loại bằng chứng.',
      'Shen Yan treats the central-axis route as the default answer. A Ning must balance task, architectural connections, and meeting point, so she asks that both routes be tested against three kinds of evidence.',
    ),
    (
      'Xóa tuyến A Ninh sẽ làm mất logic của nhiệm vụ phía đông; bỏ trục giữa lại làm mất quan hệ tổng thể. Họ giữ cả hai tuyến, cùng ký tên, và kết luận rằng tuyến thường dùng không đồng nghĩa với tuyến đúng duy nhất.',
      'Erasing A Ning’s route would lose the logic of the east-side task; ignoring the central axis would lose the larger relation. They keep both routes, sign together, and conclude that a common route is not the only correct route.',
    ),
  ],
];

List<ReadingAnnotation> _storyAnnotationsForLevel(int level) {
  final paragraphs = forbiddenCityStoryParagraphsByLevel[level - 1];
  final support = _support[level - 1];
  return List<ReadingAnnotation>.generate(
    paragraphs.length,
    (index) => ReadingAnnotation(
      pinyin: _pinyin(paragraphs[index]),
      vietnamese: support[index].$1,
      english: support[index].$2,
    ),
    growable: false,
  );
}

const forbiddenCityWordRecords = <ForbiddenCityWordRecord>[
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '路线',
      pinyin: 'lùxiàn',
      partOfSpeech: '名词',
      simpleChinese: '从一个地方到另一个地方所经过的方向和路径。',
      translation: 'tuyến đường; lộ trình',
      englishDefinition: 'route; path of travel',
      symbol: '🗺️',
    ),
    usageNote: '常用搭配：路线图、选择路线、比较路线。',
    storySource: '他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。',
    firstAppearsAt: 1,
    contrastNote: '“路线”强调移动路径；“方向”只说明朝向，不一定包含完整经过。',
    narrativeNote: 'Story 用“路线”承载人物判断，所以换成“方向”会削弱“整条行动方案”的意味。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '中轴',
      pinyin: 'zhōngzhóu',
      partOfSpeech: '名词',
      simpleChinese: '组织建筑群的重要中心轴线。',
      translation: 'trục trung tâm',
      englishDefinition: 'central axis',
      symbol: '↕️',
    ),
    usageNote: '常用搭配：沿中轴、中轴关系、中轴空间。',
    storySource: '他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。',
    firstAppearsAt: 1,
    contrastNote: '“中轴”是空间组织概念，不等于“唯一路线”。',
    narrativeNote: '它在 Story 中既是可靠空间证据，也制造了沈砚把“重要”误读成“排他”的冲突。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '午门',
      pinyin: 'Wǔmén',
      partOfSpeech: '专有名词',
      simpleChinese: '紫禁城正门，位于南北轴线上。',
      translation: 'Ngọ Môn',
      englishDefinition: 'the Meridian Gate',
      symbol: '🚪',
    ),
    usageNote: 'Story 把午门作为沈砚中轴观察的起点。',
    storySource: '他从午门沿中轴走向乾清门，把这条常用的学习路线画在纸上，认定这就是唯一正确的路线。',
    firstAppearsAt: 1,
    contrastNote: '这是具体建筑名称，不是泛指任何“宫门”。',
    narrativeNote: '如果换成普通“入口”，Story 会失去紫禁城中轴空间的具体锚点。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '乾清门',
      pinyin: 'Qiánqīngmén',
      partOfSpeech: '专有名词',
      simpleChinese: '紫禁城内廷正宫门，也是连接内廷与外朝往来的重要通道。',
      translation: 'Càn Thanh Môn',
      englishDefinition: 'the Gate of Heavenly Purity',
      symbol: '🏯',
    ),
    usageNote: 'Story 中它是两条路线发生关系的共同位置。',
    storySource: '阿宁却从东侧来到乾清门前。',
    firstAppearsAt: 1,
    contrastNote: '它不是抽象“终点”，而是具有真实空间关系的建筑节点。',
    narrativeNote: '换成普通地名会削弱两条路线为何能在同一宫城结构里比较的机制。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '目标',
      pinyin: 'mùbiāo',
      partOfSpeech: '名词',
      simpleChinese: '想要到达的结果或要完成的事情。',
      translation: 'mục tiêu',
      englishDefinition: 'goal; objective',
      symbol: '🎯',
    ),
    usageNote: '常用搭配：任务目标、共同目标、目标不同。',
    storySource: '她要把一份记录送到东边，目标和沈砚不同。',
    firstAppearsAt: 1,
    contrastNote: '“目标”回答为什么行动；“路线”回答怎样移动。',
    narrativeNote: 'Story 用它把空间差异变成人物动机差异，避免“两条线”只剩地图技巧。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '东侧',
      pinyin: 'dōngcè',
      partOfSpeech: '方位名词',
      simpleChinese: '一个空间的东边部分。',
      translation: 'phía đông',
      englishDefinition: 'the eastern side',
      symbol: '➡️',
    ),
    usageNote: '常用搭配：东侧空间、东侧入口、东侧路线。',
    storySource: '阿宁却从东侧来到乾清门前。',
    firstAppearsAt: 1,
    contrastNote: '“东侧”是相对方位；它需要和具体空间节点一起理解。',
    narrativeNote: '它让阿宁的路线与紫禁城空间方向发生具体关系。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '任务',
      pinyin: 'rènwù',
      partOfSpeech: '名词',
      simpleChinese: '需要完成的工作或事情。',
      translation: 'nhiệm vụ',
      englishDefinition: 'task; assignment',
      symbol: '📋',
    ),
    usageNote: '常用搭配：完成任务、任务不同、服务任务。',
    storySource: '两条线都能到乾清门前，却服务不同任务。',
    firstAppearsAt: 2,
    contrastNote: '“任务”比“目标”更具体，通常包含必须完成的行动。',
    narrativeNote: '它解释阿宁为什么主动坚持自己的路线，使她不是只用来证明沈砚错误的人。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '院落',
      pinyin: 'yuànluò',
      partOfSpeech: '名词',
      simpleChinese: '由建筑围合或组织起来的院子空间。',
      translation: 'sân trong; khu sân',
      englishDefinition: 'courtyard; courtyard compound',
      symbol: '🏛️',
    ),
    usageNote: '常用搭配：连续院落、经过院落、院落关系。',
    storySource: '他沿中轴记录宫门和院落，把自己的学习路线一路画到乾清门前。',
    firstAppearsAt: 3,
    contrastNote: '“院落”强调由建筑形成的空间单元，不只是普通“空地”。',
    narrativeNote: '它把路线冲突固定在紫禁城真实的门与院落序列中。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '汇合',
      pinyin: 'huìhé',
      partOfSpeech: '动词',
      simpleChinese: '从不同方向来到一起。',
      translation: 'hội tụ; gặp nhau',
      englishDefinition: 'converge; meet',
      symbol: '🔀',
    ),
    usageNote: '常用搭配：两路汇合、在某处汇合。',
    storySource: '路线先贴着东侧空间移动，再在乾清门前与沈砚汇合。',
    firstAppearsAt: 3,
    contrastNote: '“汇合”强调不同来源在一点相遇；“到达”只强调抵达。',
    narrativeNote: '它把乾清门前从普通终点变成两种行动逻辑可比较的关系节点。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '外朝',
      pinyin: 'wàicháo',
      partOfSpeech: '名词',
      simpleChinese: '紫禁城中与重大典礼和政务关系密切的主要区域。',
      translation: 'Ngoại triều',
      englishDefinition: 'Outer Court',
      symbol: '🏛️',
    ),
    usageNote: '常用搭配：外朝建筑、外朝空间、外朝区域。',
    storySource: '他沿中轴观察外朝的宫门与院落，再向乾清门前移动。',
    firstAppearsAt: 4,
    contrastNote: '“外朝”与“内廷”是功能空间框架，不是两条人物路线的名称。',
    narrativeNote: '它把沈砚的中轴观察与紫禁城真实功能分区连接起来。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '连接',
      pinyin: 'liánjiē',
      partOfSpeech: '动词/名词',
      simpleChinese: '使两个空间、位置或关系相通。',
      translation: 'kết nối',
      englishDefinition: 'connect; connection',
      symbol: '🔗',
    ),
    usageNote: '常用搭配：空间连接、连接条件、彼此连接。',
    storySource: '她主动请沈砚把图放在一边，先看空间连接。',
    firstAppearsAt: 4,
    contrastNote: '“连接”说明空间之间可发生关系，不等于每个人都必须按同一路径移动。',
    narrativeNote: '它是 Story 从“谁对谁错”转向“先检查空间条件”的关键动词。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '内廷',
      pinyin: 'nèitíng',
      partOfSpeech: '名词',
      simpleChinese: '紫禁城中与帝后生活关系更密切的主要区域。',
      translation: 'Nội đình',
      englishDefinition: 'Inner Court',
      symbol: '🏯',
    ),
    usageNote: '常用搭配：内廷建筑、内廷空间、进入内廷。',
    storySource: '从这里再向北，空间进入与内廷关系更密切的区域。',
    firstAppearsAt: 6,
    contrastNote: '与“外朝”相对时强调功能关系，不应简单理解成前后两个普通房间。',
    narrativeNote: '它让乾清门前的空间转换获得真实建筑背景。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '标注',
      pinyin: 'biāozhù',
      partOfSpeech: '动词',
      simpleChinese: '在图、文字或物件上加上说明。',
      translation: 'đánh dấu; ghi chú',
      englishDefinition: 'label; annotate',
      symbol: '✍️',
    ),
    usageNote: '常用搭配：标注路线、标注任务、图上标注。',
    storySource: '于是他在图上分别标注“中轴观察”和“东侧记录”，把两条路线都保留。',
    firstAppearsAt: 5,
    contrastNote: '“标注”比“写”更强调说明信息与对象之间的对应。',
    narrativeNote: '它把沈砚的心理变化变成可见行动，而不只让旁白宣布他“明白了”。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '判断',
      pinyin: 'pànduàn',
      partOfSpeech: '名词/动词',
      simpleChinese: '根据所见信息形成结论。',
      translation: 'phán đoán',
      englishDefinition: 'judgment; assess',
      symbol: '⚖️',
    ),
    usageNote: '常用搭配：作出判断、修改判断、判断依据。',
    storySource: '沈砚看见她的线偏离中轴，判断她的方法不够准确；阿宁没有接受这个判断，也没有要求他删掉自己的线。',
    firstAppearsAt: 5,
    contrastNote: '“判断”可以被证据修正；“事实”不是个人下结论本身。',
    narrativeNote: '高等级 Story 用它把人物成长变成“证据改变判断”的过程。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '证据',
      pinyin: 'zhèngjù',
      partOfSpeech: '名词',
      simpleChinese: '用来支持或检验一个判断的信息。',
      translation: 'bằng chứng',
      englishDefinition: 'evidence',
      symbol: '🔎',
    ),
    usageNote: '常用搭配：检查证据、空间证据、证据改变结论。',
    storySource: '沈砚把差异当成错误，阿宁却要求他先检查证据。',
    firstAppearsAt: 7,
    contrastNote: '“证据”支持判断；“例子”未必足以证明判断。',
    narrativeNote: '它让 Lv7 以后从立场冲突升级为可检验的推理冲突。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '视角',
      pinyin: 'shìjiǎo',
      partOfSpeech: '名词',
      simpleChinese: '观察或理解事情的位置和方式。',
      translation: 'góc nhìn',
      englishDefinition: 'perspective; viewpoint',
      symbol: '👁️',
    ),
    usageNote: '常用搭配：人物视角、不同视角、从某种视角。',
    storySource: '两人面对的是同一组建筑约束，却从不同任务与视角作出选择。',
    firstAppearsAt: 7,
    contrastNote: '“视角”不是任意意见，它仍要受同一空间事实约束。',
    narrativeNote: '换成“看法”会弱化 Story 中观察位置、任务和空间证据共同作用的意味。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '约束',
      pinyin: 'yuēshù',
      partOfSpeech: '名词/动词',
      simpleChinese: '限制选择范围的条件。',
      translation: 'ràng buộc',
      englishDefinition: 'constraint; restrict',
      symbol: '🧭',
    ),
    usageNote: '常用搭配：空间约束、受到约束、共同约束。',
    storySource: '两人面对的是同一组建筑约束，却从不同任务与视角作出选择。',
    firstAppearsAt: 7,
    contrastNote: '“约束”限制可行范围，但不自动指定唯一选择。',
    narrativeNote: '这是高等级路线推理的核心关系词：建筑限制行动，却不替人物决定全部行动。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '空间骨架',
      pinyin: 'kōngjiān gǔjià',
      partOfSpeech: '名词短语',
      simpleChinese: '组织多个空间关系的基础结构。',
      translation: 'khung không gian',
      englishDefinition: 'spatial framework',
      symbol: '🏗️',
    ),
    usageNote: '常用搭配：共同空间骨架、形成空间骨架。',
    storySource: '沈砚从午门沿中轴进入紫禁城，外朝连续的宫门与院落让他的观察形成稳定的空间骨架。',
    firstAppearsAt: 9,
    contrastNote: '“骨架”在这里是比喻性专业表达，强调结构基础，不是实际骨骼。',
    narrativeNote: '它把多处建筑关系压缩为可推理的整体，同时保留人物路线可以不同的余地。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '偏好',
      pinyin: 'piānhào',
      partOfSpeech: '名词/动词',
      simpleChinese: '在多个可行选择中更倾向某一种。',
      translation: 'sự ưu tiên; thiên hướng',
      englishDefinition: 'preference',
      symbol: '🧠',
    ),
    usageNote: '常用搭配：路线偏好、个人偏好、形成偏好。',
    storySource: '到乾清门前，他把这条常用路线视为最有解释力的路线偏好，并进一步误认为其他路线都应向它靠拢。',
    firstAppearsAt: 9,
    contrastNote: '“偏好”不等于“事实”或“规则”，它允许存在其他可行选项。',
    narrativeNote: '这个词揭示沈砚错误的层级：他把适合自己任务的偏好升级成了普遍答案。',
  ),
  ForbiddenCityWordRecord(
    entry: WordEntry(
      word: '权衡',
      pinyin: 'quánhéng',
      partOfSpeech: '动词',
      simpleChinese: '比较多个条件后决定怎样选择。',
      translation: 'cân nhắc; đánh đổi',
      englishDefinition: 'weigh; balance trade-offs',
      symbol: '⚖️',
    ),
    usageNote: '常用搭配：权衡条件、权衡利弊、在……之间权衡。',
    storySource: '阿宁从东侧抵达，她负责东边记录点，必须在任务效率、可连接的宫门与会合地点之间权衡。',
    firstAppearsAt: 10,
    contrastNote: '“选择”可以很直接；“权衡”强调多个条件同时存在。',
    narrativeNote: 'Lv10 用它说明阿宁不是“另一条线”的工具人，而是根据多项条件主动决策的人。',
  ),
];

WordEntry _wordEntryForLevel(ForbiddenCityWordRecord record, int level) {
  final base = record.entry;
  final band = level <= 3
      ? 1
      : level <= 6
          ? 2
          : level <= 8
              ? 3
              : 4;
  final notes = <WordExample>[
    WordExample(
      chinese: 'Story 原句：${record.storySource}',
      pinyin: _pinyin(record.storySource),
      vietnamese: 'Câu gốc trong Story: ${record.storySource}',
      english: 'Story source: ${record.storySource}',
    ),
    WordExample(
      chinese:
          band == 1 ? '意思：${base.simpleChinese}' : '搭配与语境：${record.usageNote}',
      pinyin: _pinyin(
        band == 1 ? '意思：${base.simpleChinese}' : '搭配与语境：${record.usageNote}',
      ),
      vietnamese: band == 1
          ? 'Nghĩa: ${base.translation}'
          : 'Ngữ cảnh: ${record.usageNote}',
      english: band == 1
          ? 'Meaning: ${base.englishDefinition}'
          : 'Collocation/context: ${record.usageNote}',
    ),
    WordExample(
      chinese: band <= 2
          ? '在这段 Story 里：${record.usageNote}'
          : '对比：${record.contrastNote}',
      pinyin: _pinyin(
        band <= 2 ? '在这段故事里：${record.usageNote}' : '对比：${record.contrastNote}',
      ),
      vietnamese: band <= 2
          ? 'Trong Story: ${record.usageNote}'
          : 'So sánh ngữ nghĩa: ${record.contrastNote}',
      english: band <= 2
          ? 'In this Story: ${record.usageNote}'
          : 'Semantic contrast: ${record.contrastNote}',
    ),
    if (band == 4)
      WordExample(
        chinese: '叙事功能：${record.narrativeNote}',
        pinyin: _pinyin('叙事功能：${record.narrativeNote}'),
        vietnamese: 'Chức năng tự sự: ${record.narrativeNote}',
        english: 'Narrative function: ${record.narrativeNote}',
      ),
  ];
  return WordEntry(
    word: base.word,
    pinyin: base.pinyin,
    partOfSpeech: base.partOfSpeech,
    simpleChinese: base.simpleChinese,
    translation: base.translation,
    englishDefinition: base.englishDefinition,
    symbol: base.symbol,
    examples: notes,
  );
}

DiscoveryEntry _discovery(
  String text,
  String simpleChinese,
  String vietnamese,
  String english,
) =>
    DiscoveryEntry(
      text: text,
      pinyin: _pinyin(text),
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

final forbiddenCityDiscoveries = <DiscoveryEntry>[
  _discovery(
    '午门是紫禁城正门，位于紫禁城南北轴线上。沿中轴继续观察时，宫门、院落与主要建筑会形成强烈的前后次序，因此沈砚很容易把中轴路线当成理解宫城的首选框架。',
    '午门是紫禁城正门，也在南北中轴线上。门和院落让中轴关系很清楚。',
    'Ngọ Môn là chính môn của Tử Cấm Thành và nằm trên trục bắc-nam. Chuỗi cổng và sân làm quan hệ theo trục giữa rất rõ.',
    'The Meridian Gate is the principal gate of the Forbidden City and lies on its north-south axis. Gates and courtyards make the axial sequence especially legible.',
  ),
  _discovery(
    '紫禁城建筑通常以外朝与内廷作为重要功能框架。外朝核心与重大典礼、政务关系密切；内廷与帝后生活关系更密切。乾清门为内廷正宫门，也是连接内廷与外朝往来的重要通道。功能分区因此会影响人怎样理解“要去哪里”和“经过什么空间”。',
    '外朝和内廷有不同功能；乾清门是两部分往来的重要通道。',
    'Ngoại triều và Nội đình có chức năng khác nhau; Càn Thanh Môn là lối giao thông quan trọng giữa hai phần.',
    'The Outer Court and Inner Court had different functions; the Gate of Heavenly Purity was an important passage connecting movement between them.',
  ),
  _discovery(
    '乾清门前的空间并不只和南北中轴发生关系。故宫博物院资料显示，景运门位于乾清门前广场东侧，是进入这一广场的重要门户之一。这个真实建筑关系说明：中轴是重要骨架，但东、西方向的门户也会把同一节点接入更大的空间网络。',
    '乾清门前广场东侧有景运门，所以这个地方也和东边空间相连。',
    'Phía đông quảng trường trước Càn Thanh Môn có Cảnh Vận Môn, cho thấy điểm này còn kết nối với không gian phía đông chứ không chỉ với trục bắc-nam.',
    'Jingyun Gate stands on the east side of the forecourt before the Gate of Heavenly Purity, showing that this node connects eastward as well as to the north-south axis.',
  ),
  _discovery(
    '把午门、中轴、连续院落、外朝与内廷的功能关系、乾清门及其东西侧门户一起看，可以发现紫禁城的空间秩序不是一条孤立的线，而是由轴线、门、院落、建筑与功能分区共同组织的连接系统。路线必须服从这些真实空间条件。',
    '紫禁城的空间由轴线、门、院落、建筑和功能分区共同组织，不只是一条线。',
    'Không gian Tử Cấm Thành được tổ chức bởi trục, cổng, sân, công trình và phân khu chức năng; tuyến đi phải phù hợp với các điều kiện không gian thật này.',
    'The Forbidden City is organized by axes, gates, courtyards, buildings, and functional zones rather than by a single isolated line; any route must respect those real spatial conditions.',
  ),
  _discovery(
    '同一组建筑条件可以支持不止一种可行移动关系，但“可行”不等于“随便”。人物的身份、职责、目标和下一步行动会改变哪条路线更合理；建筑负责限定可能性，任务负责改变选择的优先次序。这个关系正是沈砚需要从两条路线中自己推出的概念。',
    '建筑先限制哪些路可能走通；人的任务和目标再影响怎样选择。',
    'Cùng một điều kiện kiến trúc có thể hỗ trợ nhiều quan hệ di chuyển khả thi. Kiến trúc giới hạn khả năng, còn nhiệm vụ, vai trò và mục tiêu làm thay đổi ưu tiên lựa chọn.',
    'The same architectural conditions can support more than one feasible movement relation. Architecture constrains possibilities, while role, duty, goal, and next action change which choice is most reasonable.',
  ),
];

List<DiscoveryEntry> _discoveriesForLevel(int level) {
  if (level <= 2) return <DiscoveryEntry>[forbiddenCityDiscoveries[0]];
  if (level <= 4) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[0],
      forbiddenCityDiscoveries[1],
    ];
  }
  if (level <= 6) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[1],
      forbiddenCityDiscoveries[2],
    ];
  }
  if (level <= 8) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[2],
      forbiddenCityDiscoveries[3],
    ];
  }
  return <DiscoveryEntry>[
    forbiddenCityDiscoveries[3],
    forbiddenCityDiscoveries[4],
  ];
}

const forbiddenCityMemoryMoments = <ForbiddenCityMemoryMoment>[
  ForbiddenCityMemoryMoment(
    level: 1,
    anchor: '两条都走到乾清门前的线',
    recall: '想起沈砚先说阿宁走错，后来却把她的线留下。',
    characterShift: '沈砚开始听阿宁说明；阿宁也愿意听他讲中轴。',
    takeaway: '同一个地方可以有不同走法。',
  ),
  ForbiddenCityMemoryMoment(
    level: 2,
    anchor: '两条都能走通的路线',
    recall: '阿宁先请沈砚去看，再决定要不要删线。',
    characterShift: '沈砚把两人的目标写上图；阿宁不再觉得他只相信自己的主线。',
    takeaway: '先看目标和实际路线，再判断。',
  ),
  ForbiddenCityMemoryMoment(
    level: 3,
    anchor: '一张留下两个目标的路线图',
    recall: '阿宁宁可晚一点交记录，也带沈砚回看宫门和院落。',
    characterShift: '沈砚让阿宁亲手画她的线；阿宁补上中轴，让两种观察能连接。',
    takeaway: '常走的路不等于只有它正确。',
  ),
  ForbiddenCityMemoryMoment(
    level: 4,
    anchor: '建筑相同，目标可以不同',
    recall: '两人先检查空间怎样连接，再讨论路线是否适合任务。',
    characterShift: '沈砚愿意改判断；阿宁也补完整自己的记录。',
    takeaway: '建筑提供条件，目标影响路线。',
  ),
  ForbiddenCityMemoryMoment(
    level: 5,
    anchor: '标着任务的两条路线',
    recall: '阿宁让证据说话，沈砚把“中轴观察”和“东侧记录”分别标出。',
    characterShift: '两人从互相判断变成交换观察。',
    takeaway: '路线要和任务、空间证据一起读。',
  ),
  ForbiddenCityMemoryMoment(
    level: 6,
    anchor: '空间连接与任务选择是两个问题',
    recall: '阿宁把“能不能连通”和“适不适合任务”分开。',
    characterShift: '沈砚不再把阿宁的线当次要旁线；阿宁也愿意让他补整体关系。',
    takeaway: '一条路线成立，需要空间条件与任务理由同时说得通。',
  ),
  ForbiddenCityMemoryMoment(
    level: 7,
    anchor: '证据改变判断的那张图',
    recall: '两人用建筑连接、任务和视角检查原先的结论。',
    characterShift: '沈砚撤回排他判断；阿宁看到他愿意被证据说服。',
    takeaway: '共同约束之内仍可能有不同合理选择。',
  ),
  ForbiddenCityMemoryMoment(
    level: 8,
    anchor: '谁提供哪一种证据',
    recall: '阿宁提出空间证据、任务和共同条件三个问题。',
    characterShift: '合作从“谁纠正谁”变成“谁贡献哪一种证据”。',
    takeaway: '常用框架有解释力，但不能自动排除其他视角。',
  ),
  ForbiddenCityMemoryMoment(
    level: 9,
    anchor: '共同空间骨架上的两层路线',
    recall: '沈砚把空间骨架放底层，把两人的目标与路线分别放上去。',
    characterShift: '他让阿宁解释自己的路线；阿宁请他补整体关系。',
    takeaway: '路线偏好来自任务，不应冒充普遍答案。',
  ),
  ForbiddenCityMemoryMoment(
    level: 10,
    anchor: '一条常用路线，并不等于唯一正确的路线。',
    recall: '两人用建筑连接、人物目标和行动后果检验路线，并保留各自成立的条件。',
    characterShift: '他们不再争谁服从谁，而是共同署名一张保留差异的图。',
    takeaway: '空间事实限定可能性，身份与任务改变优先次序；好的判断要说明自己凭什么成立。',
  ),
];

ForbiddenCityMemoryMoment forbiddenCityMemoryForLevel(int level) =>
    forbiddenCityMemoryMoments[level.clamp(1, 10).toInt() - 1];

const forbiddenCityMemoryReviews = <ForbiddenCityMemoryReview>[
  ForbiddenCityMemoryReview(
    prompt: '离开紫禁城前，先记住哪幅画面？',
    answer: '沈砚和阿宁把两条都能走通的路线留在同一张图上。',
  ),
  ForbiddenCityMemoryReview(
    prompt: '人物关系真正改变在哪里？',
    answer: '沈砚开始让阿宁解释自己的路线；阿宁也愿意让沈砚补充整体空间关系。',
  ),
  ForbiddenCityMemoryReview(
    prompt: '这次 Journey 最值得带走的一句话是什么？',
    answer: forbiddenCityCoreTakeaway,
  ),
];

const forbiddenCityCompletionMoments = <ForbiddenCityCompletionMoment>[
  ForbiddenCityCompletionMoment(
    level: 1,
    storyClosure: '沈砚没有擦掉阿宁的线，两人从乾清门前带着两条路线继续走。',
    discovery: '你看见午门、中轴和乾清门把故事真正放进紫禁城。',
    learning: '你能分清人物、地点、目标和结果。',
    memory: '两条都走到乾清门前的线',
    relationship: '沈砚开始听阿宁说明，阿宁也愿意听他讲中轴。',
    emotionalClosure: '这张图不再只属于一个人的答案。',
    unlockResult: 'Lv1 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 2,
    storyClosure: '阿宁先带沈砚去看路线，再让他决定；沈砚最后保留两条线。',
    discovery: '你发现中轴很重要，但人物还会因为任务不同而选择不同路线。',
    learning: '你能解释“为什么这样走”。',
    memory: '两条都能走通的路线',
    relationship: '沈砚写下两人的目标，阿宁也开始信任他的观察。',
    emotionalClosure: '争论第一次变成了共同检查。',
    unlockResult: 'Lv2 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 3,
    storyClosure: '阿宁牺牲一点时间带沈砚回看空间，最后两人共同完成路线图。',
    discovery: '你把宫门、院落、方向和共同终点连成了空间线索。',
    learning: '你能用原因和结果说明两条路线为何都成立。',
    memory: '一张留下两个目标的路线图',
    relationship: '沈砚让阿宁亲手画线，阿宁也主动补上中轴。',
    emotionalClosure: '他们没有赢过对方，却得到一张更好的图。',
    unlockResult: 'Lv3 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 4,
    storyClosure: '两人先看建筑怎样连接，再讨论路线怎样服务目标。',
    discovery: '你认识外朝、乾清门前与东侧连接如何参与路线判断。',
    learning: '你能把建筑关系与人物行动联系起来。',
    memory: '建筑相同，目标可以不同',
    relationship: '沈砚改了判断，阿宁也改进了自己的记录。',
    emotionalClosure: '一张路线图开始同时看见建筑和人。',
    unlockResult: 'Lv4 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 5,
    storyClosure: '沈砚把“中轴观察”和“东侧记录”分别标注，两条路线都有了理由。',
    discovery: '你看见真实宫门和院落怎样限制并组织移动。',
    learning: '你能比较路线、任务与共同节点。',
    memory: '标着任务的两条路线',
    relationship: '两人从互相判断转向交换观察。',
    emotionalClosure: '图上的两种线终于不再争夺同一个位置。',
    unlockResult: 'Lv5 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 6,
    storyClosure: '阿宁把空间连通与任务适配分开，沈砚据此重做整张图。',
    discovery: '你把外朝、内廷、乾清门和东侧门户放进同一个空间关系里。',
    learning: '你能说明“可行”与“适合”不是同一判断。',
    memory: '空间连接与任务选择是两个问题',
    relationship: '沈砚不再把阿宁的路线降级，阿宁也让他参与自己的记录。',
    emotionalClosure: '他们开始把差异当作信息，而不是麻烦。',
    unlockResult: 'Lv6 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 7,
    storyClosure: '证据让沈砚撤回“只有一条正确路线”的结论。',
    discovery: '你理解建筑约束会限定路线，但不会替每个任务选出同一答案。',
    learning: '你能用证据、因果和视角解释人物判断。',
    memory: '证据改变判断的那张图',
    relationship: '阿宁看到沈砚会被证据说服，沈砚也开始尊重她的判断。',
    emotionalClosure: '两条线被保留，是因为它们经得起同一组条件检查。',
    unlockResult: 'Lv7 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 8,
    storyClosure: '两人用空间证据、任务和共同条件重做判断，不再争谁纠正谁。',
    discovery: '你把中轴、门、院落与东西方向连接读成一个空间系统。',
    learning: '你能比较多种证据，并说明一条常用框架为什么不能自动排除其他路线。',
    memory: '谁提供哪一种证据',
    relationship: '他们的合作方式变成互相补足证据。',
    emotionalClosure: '这次旅程留下的不是折中，而是一种更严格的理解。',
    unlockResult: 'Lv8 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 9,
    storyClosure: '沈砚把共同空间骨架与人物路线分层表示，并让阿宁解释她自己的线。',
    discovery: '你理解路线偏好如何由任务形成，又如何受共同建筑条件约束。',
    learning: '你能区分空间事实、局部视角和路线偏好。',
    memory: '共同空间骨架上的两层路线',
    relationship: '沈砚交出解释权，阿宁则主动向他索取整体关系。',
    emotionalClosure: '他们不再把完整理解误认成只有一个声音。',
    unlockResult: 'Lv9 Journey 完成，紫禁城进度已记录。',
  ),
  ForbiddenCityCompletionMoment(
    level: 10,
    storyClosure: '三类证据检验后，两条路线都写明成立条件，沈砚与阿宁共同署名。',
    discovery: '你把中轴与功能分区、门与院落、东西连接、人物身份与任务放进同一套空间推理。',
    learning: '你能在新情境里权衡空间约束、目标与行动后果，而不是套用默认路线。',
    memory: '一条常用路线，并不等于唯一正确的路线。',
    relationship: '沈砚允许别人的证据改变自己的图，阿宁也允许整体关系改变自己的局部记录。',
    emotionalClosure: '紫禁城没有给他们一条万能答案，却教会他们怎样让不同答案接受同一组事实检验。',
    unlockResult: 'Lv10 Journey 完成，Reference Journey 进度已记录。',
  ),
];

ForbiddenCityCompletionMoment forbiddenCityCompletionForLevel(int level) =>
    forbiddenCityCompletionMoments[level.clamp(1, 10).toInt() - 1];

const forbiddenCityJourneySummary =
    '沈砚把从午门沿中轴到乾清门的常用学习路线当成唯一正确路线；阿宁因东侧任务带来另一条可行路线，并主动要求用建筑连接、人物目标和行动结果检查两种判断。沈砚最终保留两条路线并让阿宁解释自己的线，阿宁也让沈砚补充整体空间关系。';
const forbiddenCityAchievementName = '双路共图 · Read the Routes';
const forbiddenCityChallengeRewardName = '空间证据 · Spatial Evidence';
const forbiddenCityChallengeRewardMeaning =
    '你不是靠记住一句总结过关，而是用 Story、建筑关系与人物目标判断一条路线为什么成立。';
const forbiddenCityJourneyCompletion =
    '沈砚与阿宁共同留下两条写明条件的路线。中轴仍然重要，阿宁的东侧任务也没有被抹去：一条常用路线，并不等于唯一正确的路线。';

List<String> validateForbiddenCityWordTrace() {
  final invalid = <String>[];
  for (final record in forbiddenCityWordRecords) {
    final levels = <int>[];
    for (var index = 0; index < forbiddenCityLockedStories.length; index += 1) {
      if (forbiddenCityLockedStories[index].contains(record.entry.word)) {
        levels.add(index + 1);
      }
    }
    if (levels.isEmpty ||
        levels.first != record.firstAppearsAt ||
        !record.storySource.contains(record.entry.word) ||
        !forbiddenCityLockedStories.any(
          (story) => story.contains(record.storySource),
        )) {
      invalid.add(record.entry.word);
    }
  }
  return invalid;
}

List<WordEntry> forbiddenCityWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = forbiddenCityLockedStories[safeLevel - 1];
  final maximum = <int>[5, 6, 7, 7, 8, 8, 8, 8, 8, 8][safeLevel - 1];
  return forbiddenCityWordRecords
      .where(
        (record) =>
            record.firstAppearsAt <= safeLevel &&
            story.contains(record.entry.word),
      )
      .take(maximum)
      .map((record) => _wordEntryForLevel(record, safeLevel))
      .toList(growable: false);
}

List<String> forbiddenCityStoryReadingSegments(String story, int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final paragraphs = story
      .split('\n\n')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
  final expected = safeLevel <= 2 ? 1 : 2;
  if (paragraphs.length != expected) {
    throw StateError(
      'Forbidden City Lv.$safeLevel must contain exactly $expected Story paragraph(s).',
    );
  }
  return paragraphs;
}

JourneyLevelContent forbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final paragraphs = List<String>.unmodifiable(
    forbiddenCityStoryParagraphsByLevel[safeLevel - 1],
  );
  return JourneyLevelContent(
    storyParagraphs: paragraphs,
    storyAnnotations: _storyAnnotationsForLevel(safeLevel),
    words: forbiddenCityWordsForLevel(safeLevel),
    discoveries: _discoveriesForLevel(safeLevel),
    wonderQuestion: safeLevel <= 3
        ? '阿宁为什么能从另一条路线来到乾清门前？'
        : safeLevel <= 6
            ? '建筑连接、人物目标和任务怎样共同影响两条路线？'
            : safeLevel <= 8
                ? '哪些证据让沈砚改变“只有一条正确路线”的判断？'
                : '如果换一个人物和任务，怎样用空间约束、目标与后果判断一条新路线是否合理？',
    expressQuestion: safeLevel <= 3
        ? '请用自己的话说出沈砚最后为什么留下两条路线。'
        : safeLevel <= 6
            ? '请比较沈砚与阿宁的目标、路线和共同空间节点。'
            : safeLevel <= 8
                ? '请选择至少两条 Story 或 Discovery 证据，说明两条路线为什么可以同时成立。'
                : '请把“一条常用路线，并不等于唯一正确的路线”迁移到一个新的紫禁城任务情境，并说明判断条件。',
  );
}
