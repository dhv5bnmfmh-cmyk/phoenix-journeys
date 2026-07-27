import '../models/story_content.dart';
import 'journey_data.dart';

List<ReadingAnnotation> condenseStoryAnnotations({
  required JourneyNarrativeTone tone,
  required List<ReadingAnnotation> annotations,
}) {
  final source = annotations
      .where((item) =>
          item.pinyin.trim().isNotEmpty ||
          item.vietnamese.trim().isNotEmpty ||
          item.english.trim().isNotEmpty)
      .toList(growable: false);
  if (source.isEmpty) return const <ReadingAnnotation>[];

  final groups = _splitIntoTwo(source);
  return List<ReadingAnnotation>.generate(groups.length, (index) {
    final reflection = _storyReflection(tone, index);
    final group = groups[index];
    return ReadingAnnotation(
      pinyin: _joinText(group.map((item) => item.pinyin), reflection.pinyin),
      vietnamese:
          _joinText(group.map((item) => item.vietnamese), reflection.vietnamese),
      english: _joinText(group.map((item) => item.english), reflection.english),
    );
  }, growable: false);
}

List<DiscoveryEntry> condenseDiscoveries({
  required JourneyNarrativeTone tone,
  required List<DiscoveryEntry> discoveries,
}) {
  final source = discoveries
      .where((item) => item.text.trim().isNotEmpty)
      .toList(growable: false);
  if (source.isEmpty) return const <DiscoveryEntry>[];

  final groups = _splitIntoTwo(source);
  return List<DiscoveryEntry>.generate(groups.length, (index) {
    final reflection = _discoveryReflection(tone, index);
    final group = groups[index];
    return DiscoveryEntry(
      text: _joinChinese(group.map((item) => item.text), reflection.chinese),
      pinyin: _joinText(group.map((item) => item.pinyin), reflection.pinyin),
      simpleChinese: _joinChinese(
        group.map((item) => item.simpleChinese),
        reflection.simpleChinese,
      ),
      vietnamese:
          _joinText(group.map((item) => item.vietnamese), reflection.vietnamese),
      english: _joinText(group.map((item) => item.english), reflection.english),
    );
  }, growable: false);
}

List<List<T>> _splitIntoTwo<T>(List<T> source) {
  if (source.length <= 2) {
    return source.map((item) => <T>[item]).toList(growable: false);
  }
  final split = (source.length + 1) ~/ 2;
  return <List<T>>[
    source.sublist(0, split),
    source.sublist(split),
  ];
}

String _joinChinese(Iterable<String> values, String reflection) {
  final body = values
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .join();
  return '$body$reflection';
}

String _joinText(Iterable<String> values, String reflection) {
  final parts = values
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
  if (reflection.trim().isNotEmpty) parts.add(reflection.trim());
  return parts.join(' ');
}

class _Reflection {
  const _Reflection({
    required this.chinese,
    required this.pinyin,
    required this.simpleChinese,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String simpleChinese;
  final String vietnamese;
  final String english;
}

_Reflection _storyReflection(JourneyNarrativeTone tone, int index) {
  final closing = index > 0;
  return switch (tone) {
    JourneyNarrativeTone.realm => closing
        ? const _Reflection(
            chinese: '故事真正追问的，不是异境是否存在，而是人在梦、欲望、选择与记忆之间，究竟如何认识自己。',
            pinyin: 'Gùshì zhēnzhèng zhuīwèn de, bú shì yìjìng shìfǒu cúnzài, ér shì rén zài mèng, yùwàng, xuǎnzé yǔ jìyì zhījiān, jiūjìng rúhé rènshi zìjǐ.',
            simpleChinese: '故事关心的不是异境真假，而是人怎样在梦、愿望、选择和记忆中认识自己。',
            vietnamese: 'Câu chuyện không chỉ hỏi cõi lạ có thật hay không, mà còn hỏi con người hiểu chính mình thế nào qua giấc mơ, ham muốn, lựa chọn và ký ức.',
            english: 'The story asks not merely whether the otherworld is real, but how people understand themselves through dreams, desire, choice, and memory.',
          )
        : const _Reflection(
            chinese: '这并不是单纯的奇景，而是一道把现实与想象悄悄叠在一起的门。',
            pinyin: 'Zhè bìng bú shì dānchún de qíjǐng, ér shì yí dào bǎ xiànshí yǔ xiǎngxiàng qiāoqiāo dié zài yìqǐ de mén.',
            simpleChinese: '这不只是奇异景色，也像一扇连接现实和想象的门。',
            vietnamese: 'Đây không chỉ là cảnh tượng kỳ lạ, mà còn như cánh cửa âm thầm nối thực tại với tưởng tượng.',
            english: 'This is more than a strange spectacle; it is a doorway where reality and imagination quietly overlap.',
          ),
    JourneyNarrativeTone.heritage => closing
        ? const _Reflection(
            chinese: '当古老秩序与今天的目光相遇，旅程留下的不只是知识，也是一种理解历史如何塑造当下的方式。',
            pinyin: 'Dāng gǔlǎo zhìxù yǔ jīntiān de mùguāng xiāngyù, lǚchéng liúxià de bù zhǐ shì zhīshi, yě shì yì zhǒng lǐjiě lìshǐ rúhé sùzào dāngxià de fāngshì.',
            simpleChinese: '古老历史和今天相遇时，我们学到的不只是知识，也能理解历史怎样影响现在。',
            vietnamese: 'Khi trật tự cổ xưa gặp ánh nhìn hôm nay, hành trình để lại không chỉ kiến thức mà còn cách hiểu lịch sử đã định hình hiện tại.',
            english: 'When an old order meets the present, the journey offers not only knowledge but a way to understand how history shapes today.',
          )
        : const _Reflection(
            chinese: '建筑与景物因此不再只是背景，而成为时代留下的证词。',
            pinyin: 'Jiànzhù yǔ jǐngwù yīncǐ bú zài zhǐ shì bèijǐng, ér chéngwéi shídài liúxià de zhèngcí.',
            simpleChinese: '这些建筑和景物不只是背景，也是时代留下的证据。',
            vietnamese: 'Vì thế, kiến trúc và cảnh vật không còn chỉ là phông nền, mà trở thành chứng tích của thời đại.',
            english: 'Architecture and scenery cease to be mere background and become testimony left by an era.',
          ),
    JourneyNarrativeTone.nature => closing
        ? const _Reflection(
            chinese: '走到这里，人看到的不只是壮阔，也会理解自然如何参与一座城市与一种文化的形成。',
            pinyin: 'Zǒu dào zhèlǐ, rén kàndào de bù zhǐ shì zhuàngkuò, yě huì lǐjiě zìrán rúhé cānyù yí zuò chéngshì yǔ yì zhǒng wénhuà de xíngchéng.',
            simpleChinese: '来到这里，我们看到的不只是美景，也能理解自然怎样影响城市和文化。',
            vietnamese: 'Đến đây, ta không chỉ thấy sự hùng vĩ mà còn hiểu thiên nhiên đã góp phần hình thành thành phố và văn hóa như thế nào.',
            english: 'Here, grandeur becomes more than scenery; it reveals how nature helps shape a city and a culture.',
          )
        : const _Reflection(
            chinese: '山水在这里不只是景色，也塑造了当地人的生活节奏、记忆与审美。',
            pinyin: 'Shānshuǐ zài zhèlǐ bù zhǐ shì jǐngsè, yě sùzào le dāngdì rén de shēnghuó jiézòu, jìyì yǔ shěnměi.',
            simpleChinese: '这里的自然不只是风景，也影响当地人的生活、记忆和审美。',
            vietnamese: 'Thiên nhiên nơi đây không chỉ là phong cảnh mà còn định hình nhịp sống, ký ức và thẩm mỹ địa phương.',
            english: 'The landscape is not merely scenery; it shapes local rhythms of life, memory, and aesthetics.',
          ),
    JourneyNarrativeTone.urban => closing
        ? const _Reflection(
            chinese: '把这些细节放在一起，便能读到地点背后的人、时代与生活，而不只是一张漂亮的风景照。',
            pinyin: 'Bǎ zhèxiē xìjié fàng zài yìqǐ, biàn néng dú dào dìdiǎn bèihòu de rén, shídài yǔ shēnghuó, ér bù zhǐ shì yì zhāng piàoliang de fēngjǐngzhào.',
            simpleChinese: '把细节连起来，我们能看到地点背后的人、时代和生活，而不只是漂亮景色。',
            vietnamese: 'Khi nối các chi tiết lại, ta thấy con người, thời đại và đời sống phía sau địa điểm, chứ không chỉ một bức ảnh đẹp.',
            english: 'Taken together, these details reveal the people, era, and everyday life behind a place, not merely a beautiful view.',
          )
        : const _Reflection(
            chinese: '眼前的景象不只是风景，也让这片土地的记忆变得可以触摸。',
            pinyin: 'Yǎnqián de jǐngxiàng bù zhǐ shì fēngjǐng, yě ràng zhè piàn tǔdì de jìyì biàn de kěyǐ chùmō.',
            simpleChinese: '眼前不只是风景，也让这里的历史记忆变得真实。',
            vietnamese: 'Cảnh tượng trước mắt không chỉ là phong cảnh, mà còn khiến ký ức của vùng đất trở nên có thể chạm tới.',
            english: 'The view becomes more than scenery, making the memory of this land feel tangible.',
          ),
  };
}

_Reflection _discoveryReflection(JourneyNarrativeTone tone, int index) {
  final closing = index > 0;
  return switch (tone) {
    JourneyNarrativeTone.realm => closing
        ? const _Reflection(
            chinese: '当事实与传说并置，重要的不是判断哪一部分更神奇，而是理解故事如何替人们表达难以直说的经验。',
            pinyin: 'Dāng shìshí yǔ chuánshuō bìngzhì, zhòngyào de bú shì pànduàn nǎ yí bùfen gèng shénqí, ér shì lǐjiě gùshì rúhé tì rénmen biǎodá nányǐ zhíshuō de jīngyàn.',
            simpleChinese: '事实和传说放在一起时，重点是故事怎样表达人们不容易直说的感受。',
            vietnamese: 'Khi sự thật và truyền thuyết đứng cạnh nhau, điều quan trọng là hiểu câu chuyện đã nói hộ những trải nghiệm khó diễn đạt ra sao.',
            english: 'When fact and legend stand together, the point is to see how stories express experiences that are difficult to state directly.',
          )
        : const _Reflection(
            chinese: '这些线索把奇异景象与人的愿望、恐惧和选择连在一起，因此传说真正保存的是一代代人对世界的想象。',
            pinyin: 'Zhèxiē xiànsuǒ bǎ qíyì jǐngxiàng yǔ rén de yuànwàng, kǒngjù hé xuǎnzé lián zài yìqǐ, yīncǐ chuánshuō zhēnzhèng bǎocún de shì yí dàidài rén duì shìjiè de xiǎngxiàng.',
            simpleChinese: '这些线索把奇异景象和人的愿望、害怕与选择连起来，传说保存了人们对世界的想象。',
            vietnamese: 'Những manh mối này nối cảnh tượng kỳ lạ với ước muốn, nỗi sợ và lựa chọn của con người, cho thấy truyền thuyết lưu giữ trí tưởng tượng của nhiều thế hệ.',
            english: 'These clues connect strange visions with human hopes, fears, and choices, showing how legends preserve generations of imagination.',
          ),
    JourneyNarrativeTone.heritage => closing
        ? const _Reflection(
            chinese: '把这些事实放在一起，便能看见一处遗产如何连接权力、技术、生活与审美，并持续影响今天。',
            pinyin: 'Bǎ zhèxiē shìshí fàng zài yìqǐ, biàn néng kànjiàn yí chù yíchǎn rúhé liánjiē quánlì, jìshù, shēnghuó yǔ shěnměi, bìng chíxù yǐngxiǎng jīntiān.',
            simpleChinese: '把事实连起来，就能看到文化遗产怎样连接权力、技术、生活和审美，并影响今天。',
            vietnamese: 'Khi ghép các sự kiện lại, ta thấy di sản kết nối quyền lực, kỹ thuật, đời sống và thẩm mỹ, đồng thời tiếp tục ảnh hưởng hiện tại.',
            english: 'Together, these facts show how heritage connects power, technology, daily life, and aesthetics while continuing to influence the present.',
          )
        : const _Reflection(
            chinese: '这些细节说明，历史不只存在于年代里，也藏在空间秩序、材料工艺和日常使用方式之中。',
            pinyin: 'Zhèxiē xìjié shuōmíng, lìshǐ bù zhǐ cúnzài yú niándài lǐ, yě cáng zài kōngjiān zhìxù, cáiliào gōngyì hé rìcháng shǐyòng fāngshì zhīzhōng.',
            simpleChinese: '历史不只在年代里，也藏在空间安排、材料工艺和日常使用中。',
            vietnamese: 'Những chi tiết này cho thấy lịch sử không chỉ nằm trong niên đại mà còn ẩn trong trật tự không gian, kỹ thuật vật liệu và cách sử dụng hằng ngày.',
            english: 'These details show that history lives not only in dates, but also in spatial order, craftsmanship, materials, and everyday use.',
          ),
    JourneyNarrativeTone.nature => closing
        ? const _Reflection(
            chinese: '理解这些联系后，眼前的风景不只是壮观，也成为认识当地生态与生活方式的一把钥匙。',
            pinyin: 'Lǐjiě zhèxiē liánxì hòu, yǎnqián de fēngjǐng bù zhǐ shì zhuàngguān, yě chéngwéi rènshi dāngdì shēngtài yǔ shēnghuó fāngshì de yì bǎ yàoshi.',
            simpleChinese: '理解这些联系后，风景不只是壮观，也能帮助我们认识当地生态和生活。',
            vietnamese: 'Khi hiểu các mối liên hệ này, phong cảnh không chỉ hùng vĩ mà còn trở thành chìa khóa để nhận biết hệ sinh thái và lối sống địa phương.',
            english: 'Once these connections are understood, the landscape becomes not only impressive but also a key to local ecology and ways of life.',
          )
        : const _Reflection(
            chinese: '这些现象说明，自然景观并非静止的背景，而是地理、气候与生命长期共同作用的结果。',
            pinyin: 'Zhèxiē xiànxiàng shuōmíng, zìrán jǐngguān bìng fēi jìngzhǐ de bèijǐng, ér shì dìlǐ, qìhòu yǔ shēngmìng chángqī gòngtóng zuòyòng de jiéguǒ.',
            simpleChinese: '自然景观不是不变的背景，而是地理、气候和生命长期共同形成的。',
            vietnamese: 'Những hiện tượng này cho thấy cảnh quan tự nhiên không phải phông nền đứng yên, mà là kết quả tương tác lâu dài giữa địa lý, khí hậu và sự sống.',
            english: 'These phenomena show that a natural landscape is not a static backdrop, but the result of long interaction among geography, climate, and life.',
          ),
    JourneyNarrativeTone.urban => closing
        ? const _Reflection(
            chinese: '把这些事实连起来，便能看见一座城市怎样在保存记忆的同时不断重新定义自己。',
            pinyin: 'Bǎ zhèxiē shìshí lián qǐlái, biàn néng kànjiàn yí zuò chéngshì zěnyàng zài bǎocún jìyì de tóngshí bùduàn chóngxīn dìngyì zìjǐ.',
            simpleChinese: '把事实连起来，就能看到城市怎样一边保存记忆，一边不断改变自己。',
            vietnamese: 'Khi nối các sự kiện lại, ta thấy một thành phố vừa lưu giữ ký ức vừa không ngừng định nghĩa lại chính mình.',
            english: 'Connecting these facts reveals how a city preserves memory while continually redefining itself.',
          )
        : const _Reflection(
            chinese: '这些细节说明，城市景观从来不是单独形成的，它背后有贸易、人口、技术与日常生活共同推动的变化。',
            pinyin: 'Zhèxiē xìjié shuōmíng, chéngshì jǐngguān cónglái bú shì dāndú xíngchéng de, tā bèihòu yǒu màoyì, rénkǒu, jìshù yǔ rìcháng shēnghuó gòngtóng tuīdòng de biànhuà.',
            simpleChinese: '城市景观不是单独形成的，背后有贸易、人口、技术和日常生活一起推动变化。',
            vietnamese: 'Những chi tiết này cho thấy cảnh quan đô thị không hình thành riêng lẻ; thương mại, dân số, công nghệ và đời sống hằng ngày cùng thúc đẩy biến đổi.',
            english: 'These details show that urban landscapes never form in isolation; trade, population, technology, and everyday life all drive their change.',
          ),
  };
}
