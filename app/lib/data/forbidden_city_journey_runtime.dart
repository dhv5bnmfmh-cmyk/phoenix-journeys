import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';
import 'journey_level_catalog.dart';

const forbiddenCityJourneyId = 'beijing-forbidden-city';
const forbiddenCityMemoryAnchor = '一张叠着两条路线的图';

class ForbiddenCityWordRecord {
  const ForbiddenCityWordRecord({
    required this.entry,
    required this.usageNote,
    required this.storySource,
    required this.firstAppearsAt,
  });

  final WordEntry entry;
  final String usageNote;
  final String storySource;
  final int firstAppearsAt;
}

class ForbiddenCityMemoryReview {
  const ForbiddenCityMemoryReview({required this.prompt, required this.answer});

  final String prompt;
  final String answer;
}

final forbiddenCityStoryParagraphsByLevel = <List<String>>[
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他在纸上画自己从午门沿中轴走到乾清门的学习路线，觉得一张路线图应该只有一条最清楚的路。一个年幼侍役阿宁看见后说：“我的路不这样走。”阿宁在纸角画出自己从东侧过来、也到乾清门前的一条线。沈砚问：“怎么会有两条都对的路？”两人把两条线放到同一张纸上，对准乾清门。两条线在这里相遇，又向不同方向分开。沈砚没有擦掉任何一条，而是把两条都描清楚。最后，他们从同一个门前继续走向各自要去的方向。纸上留下两条路线。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他画下自己从午门沿中轴到乾清门的学习路线，认为正确的路线图应该选出一条最清楚的路。年幼侍役阿宁看见后摇头：“我到这里不是这样走。”他在纸上画出自己从东侧过来的一条路线，也到乾清门前。沈砚先觉得两张图互相矛盾：同一座宫城，怎么会有两条都正确的路？阿宁说，他们来这里的事情不同，所以经过的地方也不同。两人把两条线叠到同一张图上，用乾清门作共同位置。两条线短暂重合，又向不同方向分开。沈砚决定不删掉任何一条，而是用两种线把它们都保留下来。图不再只回答“哪条路才对”，而开始说明“谁为什么这样走”。最后，两人从同一个位置继续走向各自的方向，那张图上仍清楚留着两条路线。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他把当天的学习路线画在纸上：从午门进入，沿中轴经过外朝的层层空间，再到乾清门附近。他习惯把图画成一条主线，觉得这样最清楚。年幼侍役阿宁看见图后却说，自己的走法不同。他从东侧过来，也会到乾清门前，但不是沿着沈砚的线走。沈砚起初把这看成错误：同一个地方，为什么会出现两条不同路线？',
    '阿宁没有改沈砚的图，只在另一张纸上画出自己记得的走法。两人把纸对在一起，以乾清门前这个共同位置为参照。两条路线在那里相遇，随后因为两人的事情不同而分开。沈砚这才发现，两张图各自只说明了一种移动关系，任何一张单独留下都会少掉另一种信息。他选择把两条线叠在同一张图上，并用不同线型保留它们。新的图没有判定谁错，而让“同一空间、不同角色、不同走法”同时变得可见。分别时，两人从共同的门前向不同方向走去。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想练习把宫城的空间关系画清楚，便从午门开始，沿中轴记录外朝的庭院、宫门和方向，最后把自己的路线连到乾清门附近。他认为一张好图应该有一条明确主线，否则看起来会乱。年幼侍役阿宁看到后却说：“如果按我今天要做的事，我不会沿你这条线来。”阿宁在纸上画出从东侧空间接近乾清门前的另一条线。两张路线都能指到同一个地方，却没有相同的过程，沈砚一时不知道该相信哪一张。',
    '两人没有争着证明对方错误，而是逐点比较方向和共同参照。沈砚发现，午门和中轴让自己的学习路线容易组织；阿宁的路线则由他要去的地方和所做的事情决定。到了乾清门前，两条线终于对齐，随后又分向不同方向。沈砚作出决定：不选一条覆盖另一条，而在同一张纸上用实线和点线保留两种走法。重叠后的图比任何一张原图都多出一种关系：建筑相同，角色与目的不同，路线也可以不同。最后，他们在同一个空间节点分开，各走各的路。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想练习一种能解释宫城空间关系的图，于是从午门进入后，沿南北中轴观察外朝的院落和宫门，再把自己的学习路线画到乾清门附近。外朝的开阔庭院和层层门序让他的线条很自然地顺着中轴向前。沈砚因此相信，一张真正清楚的路线图应该找出唯一的主路线。年幼侍役阿宁看见后却说，他今天经过的空间不是这样组织的。阿宁在另一张纸上画出自己从东侧接近乾清门前的走法。他没有说沈砚画错，只问：“如果我们做的事不同，为什么一定要走成一条线？”',
    '这个问题让两张图的矛盾变得更难处理，因为两条路线都来自真实的行动。沈砚和阿宁把图放在一起，对齐几个共同位置。到乾清门前，两条线短暂重合；再往后，一条继续服务沈砚的学习观察，另一条随阿宁的事情转向别处。沈砚没有删掉阿宁的线，也没有让自己的线变成标准答案。他把两种线型叠在一张图上，并在交会处标出共同节点。新的图显示的不是“谁走对了”，而是同一组宫门、庭院和连接关系怎样因角色与目的产生不同路径。分别时，两人从共同节点转向各自的方向，图上的两条线也一起留下。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他准备做一张学习用的空间图，希望别人能看懂宫门、庭院怎样连接。进入午门后，他沿中轴观察外朝，开阔庭院、层层门序与轴线让他的记录形成一条强烈的纵向路线；到乾清门附近，外朝与内廷的空间关系又让这个位置成为重要的连接点。沈砚把自己的路线画得很确定，甚至觉得图上只应保留一条“正确路线”。年幼侍役阿宁看完却提出异议。他说自己今天从东侧空间过来，经过的方向不同，却同样会到乾清门前。随后，他在另一张纸上画出自己的走法。两条线看起来互相冲突，但谁也没有编造自己没走过的地方。',
    '沈砚没有急着把其中一张改成另一张。他和阿宁先找共同参照，再比较每一段线为什么出现。沈砚的路线跟着学习观察的顺序展开，阿宁的路线跟着自己的事情和目的展开。两人在乾清门前把两张图对齐时，路线短暂合在一起，随后再次分开。这个交会点让沈砚看清：矛盾并不一定意味着一真一假，有时是两种局部视角同时成立。他选择把两条路线叠进同一张图，用不同线型保存各自的完整路径，而不是删掉一条。复合图因此多出任何单张图都没有的信息：同一建筑系统能组织不同角色的移动关系。最后，两人在共同节点分别，继续各自的事情；纸上的两条线也从同一点伸向不同方向。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想做一张能解释宫城空间的学习图，于是从午门进入，沿南北中轴观察外朝。午门位于紫禁城南北轴线上，外朝的庭院与门序使他的观察自然形成一条连续路线；到乾清门附近，空间进入外朝与内廷相接的重要位置。沈砚把这条线画得很清楚，于是产生了一个简单判断：既然建筑关系明确，一张好图就应该把移动也归成一条主线。年幼侍役阿宁看到图后说，自己的路线并不沿着沈砚的线展开。他从东侧空间接近同一个节点，随后又因为自己的事情转向别处。阿宁把这条路线画在自己的纸上。两张图都来自各自实际走过的路，却无法在沈砚的“一条主线”规则里同时成立。',
    '沈砚没有把阿宁当成反例，也没有把自己的路线改成错误答案。他们把两张纸叠看，从共同的宫门和方向关系开始校准。乾清门前成为关键：两条路线在这里接近、重合，再向不同方向展开。沈砚终于看到，建筑提供共同的空间骨架，却不会让每个角色拥有相同的目的和移动关系。他作出决定，在同一张图上用实线与点线完整保留两条路线，并把交会处标为共享节点。图的意义因此改变，不是旧图被新证据推翻，而是两个都有效的局部视角经过合成后，显出彼此之间的关系。傍晚，两人在那个共同节点分开。阿宁去做自己的事，沈砚继续学习观察；一张叠着两条路线的图留在沈砚手里，两条线都没有被擦掉。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他要练习把“建筑怎样组织人的移动”画成一张可读的图。进入午门后，他沿南北中轴观察外朝，庭院尺度、门序和方向关系让自己的学习路径呈现出清晰的纵向逻辑；接近乾清门时，他又注意到这里是连接外朝与内廷往来的重要通道。沈砚因此把自己的路线当作整张图的骨架，认为其他路线只要足够准确，最后都应当被整理进这条主线。年幼侍役阿宁看见图后却指出，他今天从东侧空间接近乾清门前，随后仍要向另一方向去。阿宁在纸上画出自己的实际走法，没有把它称作制度规定或官方路线，只说这是自己今天怎样走。两张图都对应真实行动，却在沈砚的单一路线模型里互相排斥。',
    '沈砚和阿宁开始逐段比较。他们先对准共同的门、院落方向和乾清门前的位置，再追问每一段线服务什么目的。沈砚的线记录学习建筑的观察次序，阿宁的线记录一次具体行动。两条路线在共享节点短暂叠合，随后因目的不同而分开。这不是谁被纠正的时刻，而是两张局部图第一次能够彼此说明。沈砚选择保留差异：他用两种线型叠画路线，让共同节点、重合段和分岔同时可见。复合图因此显示出一层新的空间关系：宫门和庭院构成共同结构，而角色、目的与行动使同一结构产生不同但可同时成立的路径。两人最后从共享节点分别。沈砚没有得到一条更“唯一”的路线，却得到一张信息更多的图，一张叠着两条路线、能解释它们为何相遇又分开的图。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他给自己定下一个具体任务：做一张让别人既能看懂建筑连接，也能看懂不同人为何走出不同路线的学习图。进入午门后，他沿中轴观察外朝。午门位于紫禁城南北轴线上，外朝以大尺度庭院、宫门与核心殿宇形成强烈的空间次序；接近乾清门后，外朝与内廷之间的连接关系更加明显。沈砚先把自己的观察路线画成一条连续主线，并把“清楚”理解成“只有一个正确顺序”。年幼侍役阿宁看图时却说，他今天从东侧空间接近乾清门前，路线与沈砚不同，随后还要转向另一处。阿宁把自己的走法画出来。两条路线都能准确对应各自的行动，却无法同时服从沈砚原先的单线规则。',
    '真正困难的不是判断谁错，而是如何让两个有效视角同时进入一张图。沈砚和阿宁把纸并在一起，以共同宫门、院落方向和乾清门前的位置校准。比较后，他们发现两条路线在这个重要连接节点短暂重合，随后因为角色和目的不同而分岔。沈砚没有用阿宁的图替换自己的图，也没有把阿宁的线降成旁注；他主动选择用不同线型完整保存两条路径，再画出共同节点与分岔关系。新的复合表示出现了任何单张路线图都不能单独给出的信息：同一建筑系统提供共同结构，而不同角色的行动目的决定他们怎样使用这些连接。这个变化不是“旧分类被证据推翻”，而是两个同时有效的局部视角经过比较后形成更高一层的关系表示。傍晚，两人在乾清门前的共同节点各自转向。图上两条线同处一页、互不抹去，也清楚解释了它们为何相遇、为何分开。',
  ],
  <String>[
    '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。他想把“宫城空间怎样连接、不同角色又怎样使用这些连接”做成一张能被别人读懂的学习图。进入午门后，他沿紫禁城南北中轴观察外朝。午门是紫禁城正门，位于南北轴线上；外朝的核心殿宇、开阔庭院和层层门序共同形成强烈的轴线秩序。接近乾清门时，他又看到另一种关键关系：乾清门既是内廷正宫门，也是连接内廷与外朝往来的重要通道。沈砚把自己的观察顺序连成一条清楚的线，直觉上认为“正确的空间图”应当收束为一个最权威的路线。年幼侍役阿宁看后却说，自己今天从东侧空间接近乾清门前，随后还要转向另一处，因此不会沿沈砚的整条线移动。阿宁在纸上画下这次具体行动的路线，明确只是自己的走法，不是官方历史路线。两张图都忠实于各自行动，却在“只有一条正确路径”的假设下彼此冲突。',
    '沈砚没有把问题解决成谁对谁错。他与阿宁把两张纸按共同宫门、庭院方向和乾清门前的位置逐点对齐，并追问每段路线在做什么。沈砚的线服务于营造学习和建筑观察，阿宁的线服务于他当下的行动。路线在乾清门前短暂重合，又因角色和目的不同向不同方向延伸。这个重合与分岔同时出现的瞬间成为关键：如果擦掉任何一条，图都会失去真实关系。沈砚于是选择合成，而不是裁决。他用实线与点线在同一张纸上保留两条完整路线，标出共享节点、重合段与分岔，使建筑结构和人的目的同时可读。复合图揭示了两张原图单独都没有表达出的关系：同一宫城并不是一张“人人同路”的平面，建筑的轴线、宫门、庭院与功能分区提供共同空间骨架，不同角色则因行动目的而形成不同的合法叙事视角。傍晚，沈砚与阿宁从共同节点分别，继续各自要做的事。一张叠着两条路线的图留在纸上，两条线都清楚、都完整，也彼此说明。',
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
  [('Thẩm Nghiên và A Ninh vẽ hai tuyến khác nhau qua cùng cung thành rồi chồng chúng lên nhau tại Càn Thanh Môn.', 'Shen Yan and A Ning draw two different routes through the same palace and overlay them at the Gate of Heavenly Purity.')],
  [('Hai tuyến đều đúng với việc mỗi người đang làm; Thẩm Nghiên giữ cả hai thay vì chọn một tuyến duy nhất.', 'Both routes are valid for what each person is doing; Shen Yan preserves both instead of choosing a single route.')],
  [('Thẩm Nghiên xem tuyến của mình là đường chính, còn A Ninh đưa ra một lộ trình khác đến cùng điểm.', 'Shen Yan treats his route as the main line, while A Ning contributes another route to the same point.'), ('Hai người căn chỉnh hai bản vẽ tại một vị trí chung và giữ cả hai góc nhìn.', 'They align the drawings at a shared location and preserve both perspectives.')],
  [('Hai tuyến cùng dẫn tới Càn Thanh Môn nhưng có logic di chuyển khác nhau.', 'Both routes reach the Gate of Heavenly Purity but follow different movement logics.'), ('Sự chồng tuyến cho thấy kiến trúc giống nhau có thể hỗ trợ những đường đi khác nhau theo vai trò và mục đích.', 'The overlay shows that the same architecture can support different paths according to role and purpose.')],
  [('Trục giữa tổ chức đường học của Thẩm Nghiên, còn A Ninh mô tả một đường khác từ phía đông.', 'The central axis organizes Shen Yan’s learning route while A Ning describes another approach from the east.'), ('Thẩm Nghiên giữ hai kiểu nét và điểm giao chung thay vì biến một tuyến thành đáp án chuẩn.', 'Shen Yan keeps two line styles and a shared junction rather than turning one route into the standard answer.')],
  [('Ngoại triều, trục giữa và Càn Thanh Môn tạo bộ khung không gian chung cho hai tuyến.', 'The Outer Court, central axis, and Gate of Heavenly Purity provide a shared spatial frame for both routes.'), ('Hai góc nhìn cục bộ hợp lại thành một bản đồ có nhiều thông tin quan hệ hơn.', 'Two valid local perspectives combine into a map with more relational information.')],
  [('Thẩm Nghiên muốn giải thích các kết nối của cung thành chứ không chỉ vẽ một đường đi.', 'Shen Yan wants to explain palace connections rather than merely draw one path.'), ('Hai tuyến gặp nhau, tách ra và cùng được giữ lại trong một sơ đồ tổng hợp.', 'The routes meet, diverge, and are both preserved in one composite representation.')],
  [('Thông tin chính thức về trục và sự chuyển tiếp Ngoại triều–Nội đình tạo nền kiến trúc cho hành động hư cấu.', 'Verified axis and Outer/Inner Court transition facts provide the architectural scaffold for the fictional actions.'), ('Bản đồ tổng hợp không sửa một tuyến thành sai; nó làm quan hệ giữa hai tuyến trở nên có thể đọc được.', 'The composite map does not correct one route into error; it makes the relation between two routes legible.')],
  [('A Ninh chỉ mô tả đường mình đi hôm đó, không tuyên bố đó là tuyến lịch sử chính thức.', 'A Ning describes only the path he takes that day and does not claim it is an official historical route.'), ('Thẩm Nghiên dùng điểm chung, đoạn trùng và chỗ rẽ để biểu diễn nhiều quan hệ không gian cùng lúc.', 'Shen Yan uses shared points, overlap, and divergence to represent multiple spatial relations at once.')],
  [('Nhiệm vụ trở thành làm cho cả kết nối kiến trúc lẫn mục đích của con người đều có thể đọc được.', 'The task becomes making both architectural connections and human purposes legible.'), ('Hai góc nhìn hợp lệ tạo thành một biểu diễn quan hệ cao hơn mà không xóa góc nhìn nào.', 'Two valid perspectives form a higher-order relational representation without erasing either one.')],
  [('Các sự kiện về Ngọ Môn, trục giữa, Ngoại triều, Nội đình và Càn Thanh Môn được tách khỏi các tuyến nhân vật hư cấu.', 'Facts about the Meridian Gate, central axis, Outer Court, Inner Court, and Gate of Heavenly Purity are kept distinct from fictional character routes.'), ('Tại điểm chung, hai tuyến cùng hiện diện rồi phân nhánh; bản đồ cuối cùng giữ cả hai logic di chuyển.', 'At the shared node the routes coexist and then diverge; the final map preserves both movement logics.')],
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
  ForbiddenCityWordRecord(entry: WordEntry(word: '营造学徒', pinyin: 'yíngzào xuétú', partOfSpeech: '名词', simpleChinese: '学习传统建筑营造工作的年轻学徒。', translation: 'học việc xây dựng truyền thống', englishDefinition: 'construction apprentice', symbol: '🪚'), usageNote: '主人公的职业身份。', storySource: '十七岁的营造学徒沈砚第一次随周师傅进入紫禁城。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '路线图', pinyin: 'lùxiàntú', partOfSpeech: '名词', simpleChinese: '表示行走路线与连接关系的图。', translation: 'sơ đồ tuyến đường', englishDefinition: 'route map', symbol: '🗺️'), usageNote: '新故事的核心学习表示。', storySource: '他在纸上画自己从午门沿中轴走到乾清门的学习路线，觉得一张路线图应该只有一条最清楚的路。', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '侍役', pinyin: 'shìyì', partOfSpeech: '名词', simpleChinese: '故事中在宫廷空间行动的虚构服务角色。', translation: 'người phục dịch', englishDefinition: 'attendant', symbol: '👤'), usageNote: '阿宁是虚构角色，不代表官方历史路线。', storySource: '一个年幼侍役阿宁看见后说：“我的路不这样走。”', firstAppearsAt: 1),
  ForbiddenCityWordRecord(entry: WordEntry(word: '叠', pinyin: 'dié', partOfSpeech: '动词', simpleChinese: '把两个东西放在一起重合比较。', translation: 'chồng lên', englishDefinition: 'overlay; stack', symbol: '🗂️'), usageNote: '核心行动是把两条路线叠在一起。', storySource: '两人把两条线叠到同一张图上，用乾清门作共同位置。', firstAppearsAt: 2),
  ForbiddenCityWordRecord(entry: WordEntry(word: '矛盾', pinyin: 'máodùn', partOfSpeech: '名词/形容词', simpleChinese: '两个说法或现象看起来不能同时成立。', translation: 'mâu thuẫn', englishDefinition: 'contradiction', symbol: '↔️'), usageNote: '两条有效路线最初看似互相排斥。', storySource: '沈砚先觉得两张图互相矛盾：同一座宫城，怎么会有两条都正确的路？', firstAppearsAt: 2),
  ForbiddenCityWordRecord(entry: WordEntry(word: '外朝', pinyin: 'wàicháo', partOfSpeech: '名词', simpleChinese: '与重大典礼和政务关系密切的宫廷区域。', translation: 'Ngoại triều', englishDefinition: 'Outer Court', symbol: '🏛️'), usageNote: '官方建筑资料支持的空间功能框架。', storySource: '他把当天的学习路线画在纸上：从午门进入，沿中轴经过外朝的层层空间，再到乾清门附近。', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '参照', pinyin: 'cānzhào', partOfSpeech: '名词/动词', simpleChinese: '用来对比、定位或判断的共同依据。', translation: 'mốc tham chiếu', englishDefinition: 'reference point', symbol: '📍'), usageNote: '两张路线图通过共同位置进行比较。', storySource: '两人把纸对在一起，以乾清门前这个共同位置为参照。', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '线型', pinyin: 'xiànxíng', partOfSpeech: '名词', simpleChinese: '线条的不同样式。', translation: 'kiểu đường nét', englishDefinition: 'line style', symbol: '➖'), usageNote: '用于同时保留两条路线。', storySource: '他选择把两条线叠在同一张图上，并用不同线型保留它们。', firstAppearsAt: 3),
  ForbiddenCityWordRecord(entry: WordEntry(word: '节点', pinyin: 'jiédiǎn', partOfSpeech: '名词', simpleChinese: '连接多条关系或路线的重要位置。', translation: 'nút giao', englishDefinition: 'node; junction', symbol: '🔘'), usageNote: '共享节点使两条路线的关系可见。', storySource: '最后，他们在同一个空间节点分开，各走各的路。', firstAppearsAt: 4),
  ForbiddenCityWordRecord(entry: WordEntry(word: '中轴', pinyin: 'zhōngzhóu', partOfSpeech: '名词', simpleChinese: '组织建筑群的重要中心轴线。', translation: 'trục trung tâm', englishDefinition: 'central axis', symbol: '↕️'), usageNote: '紫禁城空间组织的重要事实。', storySource: '进入午门后，他沿中轴观察外朝，开阔庭院、层层门序与轴线让他的记录形成一条强烈的纵向路线；到乾清门附近，外朝与内廷的空间关系又让这个位置成为重要的连接点。', firstAppearsAt: 6),
  ForbiddenCityWordRecord(entry: WordEntry(word: '内廷', pinyin: 'nèitíng', partOfSpeech: '名词', simpleChinese: '与帝后生活联系更紧密的宫廷后部区域。', translation: 'Nội đình', englishDefinition: 'Inner Court', symbol: '🏯'), usageNote: '与外朝共同构成重要空间功能框架。', storySource: '进入午门后，他沿中轴观察外朝，开阔庭院、层层门序与轴线让他的记录形成一条强烈的纵向路线；到乾清门附近，外朝与内廷的空间关系又让这个位置成为重要的连接点。', firstAppearsAt: 6),
  ForbiddenCityWordRecord(entry: WordEntry(word: '局部视角', pinyin: 'júbù shìjiǎo', partOfSpeech: '名词短语', simpleChinese: '只能说明整体其中一部分的观察位置或理解方式。', translation: 'góc nhìn cục bộ', englishDefinition: 'partial perspective', symbol: '🔎'), usageNote: '两种视角都有效但都不等于全部。', storySource: '这个交会点让沈砚看清：矛盾并不一定意味着一真一假，有时是两种局部视角同时成立。', firstAppearsAt: 6),
  ForbiddenCityWordRecord(entry: WordEntry(word: '复合图', pinyin: 'fùhétú', partOfSpeech: '名词', simpleChinese: '把多个相关表示合在一起的图。', translation: 'sơ đồ tổng hợp', englishDefinition: 'composite map', symbol: '🧩'), usageNote: '复合图保存两种路线逻辑。', storySource: '复合图因此多出任何单张图都没有的信息：同一建筑系统能组织不同角色的移动关系。', firstAppearsAt: 6),
  ForbiddenCityWordRecord(entry: WordEntry(word: '校准', pinyin: 'jiàozhǔn', partOfSpeech: '动词', simpleChinese: '依据共同标准对齐位置或数值。', translation: 'căn chỉnh', englishDefinition: 'align; calibrate', symbol: '🎯'), usageNote: '两张图先对齐共同空间参照。', storySource: '他们把两张纸叠看，从共同的宫门和方向关系开始校准。', firstAppearsAt: 7),
  ForbiddenCityWordRecord(entry: WordEntry(word: '分岔', pinyin: 'fēnchà', partOfSpeech: '动词/名词', simpleChinese: '从共同方向分成不同方向。', translation: 'phân nhánh', englishDefinition: 'diverge; fork', symbol: '⑂'), usageNote: '共享节点后的分开是高潮信息。', storySource: '比较后，他们发现两条路线在这个重要连接节点短暂重合，随后因为角色和目的不同而分岔。', firstAppearsAt: 9),
  ForbiddenCityWordRecord(entry: WordEntry(word: '空间骨架', pinyin: 'kōngjiān gǔjià', partOfSpeech: '名词短语', simpleChinese: '组织多个空间关系的共同基础结构。', translation: 'khung không gian', englishDefinition: 'spatial framework', symbol: '🏗️'), usageNote: '共同建筑结构与不同路径并存。', storySource: '建筑的轴线、宫门、庭院与功能分区提供共同空间骨架，不同角色则因行动目的而形成不同的合法叙事视角。', firstAppearsAt: 10),
];

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
    '午门是紫禁城的正门，位于紫禁城南北轴线上。门、廊庑和广场层层递进，使中轴上的接近次序成为宫城空间组织的重要部分。',
    '午门是紫禁城正门，也在南北中轴线上。',
    'Ngọ Môn là chính môn của Tử Cấm Thành và nằm trên trục bắc-nam.',
    'The Meridian Gate is the principal gate of the Forbidden City and stands on its north-south axis.',
  ),
  _discovery(
    '紫禁城建筑通常以外朝与内廷作为重要功能框架。外朝核心区域与重大典礼、政务关系密切；内廷后部与帝后生活联系更紧。乾清门是内廷正宫门，也是连接内廷与外朝往来的重要通道。',
    '外朝更接近重大典礼和政务，内廷更接近宫廷生活；乾清门是重要连接通道。',
    'Ngoại triều gắn với đại lễ và chính vụ; Nội đình gắn hơn với đời sống cung đình. Càn Thanh Môn là một lối kết nối quan trọng.',
    'The Outer Court was closely tied to major ceremonies and state affairs, while the Inner Court was more closely tied to court life; the Gate of Heavenly Purity was an important connection between them.',
  ),
  _discovery(
    '轴线、庭院尺度、宫门位置和功能分区共同组织紫禁城的空间关系。建筑因此不仅是孤立的殿宇，也是一套让方向、接近和不同用途彼此发生关系的空间结构。',
    '轴线、庭院、宫门和功能分区一起组织空间。',
    'Trục, sân, cổng và phân khu chức năng cùng tổ chức quan hệ không gian.',
    'Axes, courtyards, gates, and functional zones work together to organize spatial relationships.',
  ),
  _discovery(
    '今天的故宫博物院导览提供多种推荐参观路线，也按宫廷建筑功能展示不同区域。这些现代路线属于博物院参观组织，不能被直接当成明清宫廷中的官方行动路线。',
    '今天有多种参观路线，但现代导览不能直接代表历史宫廷路线。',
    'Ngày nay bảo tàng có nhiều tuyến tham quan, nhưng chúng không phải là tuyến chính thức của cung đình lịch sử.',
    'The Palace Museum offers multiple visitor routes today, but modern visitor routes must not be treated as official historical court routes.',
  ),
  _discovery(
    '本 Journey 中沈砚与阿宁画出的路线都是虚构的学习表示，不是历史官方地图、许可记录或制度路线。故事只借用已经核实的建筑节点与空间关系，让学习者思考：同一建筑结构怎样因角色与目的不同而产生不同的移动视角。',
    '故事里的两条路线是虚构学习表示，不是官方历史路线。',
    'Hai tuyến trong câu chuyện là biểu diễn học tập hư cấu, không phải tuyến lịch sử chính thức.',
    'The two routes in the Story are fictional learning representations, not official historical routes.',
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
  if (level <= 7) {
    return <DiscoveryEntry>[
      forbiddenCityDiscoveries[1],
      forbiddenCityDiscoveries[2],
    ];
  }
  return <DiscoveryEntry>[
    forbiddenCityDiscoveries[3],
    forbiddenCityDiscoveries[4],
  ];
}

const forbiddenCityMemoryReviews = <ForbiddenCityMemoryReview>[
  ForbiddenCityMemoryReview(prompt: '故事的主人公是谁？', answer: '沈砚，十七岁的营造学徒。'),
  ForbiddenCityMemoryReview(prompt: '第二个关键角色是谁？', answer: '年幼侍役阿宁；他带来一条与沈砚不同但同样有效的行动路线。'),
  ForbiddenCityMemoryReview(prompt: '开头的矛盾是什么？', answer: '沈砚认为一张清楚的图应只有一条主路线，但阿宁从不同方向到达同一个空间节点。'),
  ForbiddenCityMemoryReview(prompt: '为什么不能简单判定其中一条路线错误？', answer: '两条路线都来自各自真实行动，只服务于不同角色与目的。'),
  ForbiddenCityMemoryReview(prompt: '两人怎样比较路线？', answer: '他们用共同宫门、方向和乾清门前的位置作参照，把两张图对齐。'),
  ForbiddenCityMemoryReview(prompt: '沈砚做了什么决定？', answer: '他不用一条路线覆盖另一条，而用不同线型把两条都保留在同一张图上。'),
  ForbiddenCityMemoryReview(prompt: '高潮怎样发生？', answer: '两条路线在共享节点短暂重合，随后因角色与目的不同而分岔。'),
  ForbiddenCityMemoryReview(prompt: '这个选择带来什么结果？', answer: '复合图增加了共同节点、重合与分岔的关系信息，而不是留下缺口。'),
  ForbiddenCityMemoryReview(prompt: '沈砚的空间理解怎样改变？', answer: '他从“一张图只有一条正确路线”转向理解同一建筑系统可以支持多个同时有效的角色视角。'),
  ForbiddenCityMemoryReview(prompt: 'Journey 的 Memory Anchor 是什么？', answer: forbiddenCityMemoryAnchor),
];

const forbiddenCityJourneySummary =
    '沈砚想把紫禁城画成一条唯一清楚的学习路线，年幼侍役阿宁却带来另一条同样有效的走法。两人以乾清门前等共同空间参照对齐路线，发现两条线会相遇、重合并因角色与目的不同而分开。沈砚选择把两种路线都保留在复合图上，让同一宫城中的多种空间关系同时可读。';
const forbiddenCityAchievementName = '合路 · Read the Routes';
const forbiddenCityChallengeRewardName = '双线节点 · Shared Junction';
const forbiddenCityChallengeRewardMeaning =
    '双线节点提醒学习者：同一建筑结构可以成为多种行动路线的共同参照，理解空间有时需要保存并比较多个有效视角。';
const forbiddenCityJourneyCompletion =
    '两条路线在同一张图上相遇、重合，又从共享节点分开。沈砚与阿宁继续各自的方向，纸上没有谁覆盖谁：一张叠着两条路线的图把同一宫城中的两种移动逻辑同时留下。';

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
  final maximum = <int>[5, 6, 7, 8, 9, 10, 11, 13, 14, 15][safeLevel - 1];
  return forbiddenCityWordRecords
      .where(
        (record) =>
            record.firstAppearsAt <= safeLevel &&
            story.contains(record.entry.word),
      )
      .take(maximum)
      .map((record) => record.entry)
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
    wonderQuestion:
        '沈砚和阿宁在 Lv.$safeLevel 为什么能拥有两条不同却同时有效的路线？',
    expressQuestion:
        '请用 Lv.$safeLevel 的语言说明两条路线叠在一起后，多出了什么空间关系信息。',
  );
}
