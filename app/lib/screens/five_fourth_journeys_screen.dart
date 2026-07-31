import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class FiveFourthJourneysScreen extends StatefulWidget {
  const FiveFourthJourneysScreen({super.key});

  @override
  State<FiveFourthJourneysScreen> createState() => _FiveFourthJourneysScreenState();
}

class _FiveFourthJourneysScreenState extends State<FiveFourthJourneysScreen> {
  static const _key = 'phoenix.journeys4.completed.v1';
  Set<String> _completed = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _completed = (prefs.getStringList(_key) ?? const <String>[]).toSet());
  }

  Future<void> _open(_Journey journey) async {
    final done = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _JourneyScreen(journey: journey)),
    );
    if (done != true) return;
    final next = <String>{..._completed, journey.id};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList()..sort());
    if (mounted) setState(() => _completed = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('Phoenix · 江海远境'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF16324F), Color(0xFF8A3B2E)]),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('第四卷 · 江海远境', style: TextStyle(color: Color(0xFFFFD879), fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('从石城海岸，走进山谷与古寨', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text('完整旅程 ${_completed.length} / 5', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < journeys4.length; i++) ...[
            _Tile(journey: journeys4[i], number: i + 16, done: _completed.contains(journeys4[i].id), onTap: () => _open(journeys4[i])),
            if (i != journeys4.length - 1) const SizedBox(height: 11),
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.journey, required this.number, required this.done, required this.onTap});
  final _Journey journey;
  final int number;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: .9),
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(gradient: LinearGradient(colors: journey.colors), borderRadius: BorderRadius.circular(18)), child: Icon(journey.icon, color: Colors.white)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('旅程 $number · ${journey.city}', style: const TextStyle(color: PhoenixTheme.red, fontSize: 12, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(journey.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(journey.subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ])),
          Icon(done ? Icons.verified_rounded : Icons.chevron_right_rounded, color: done ? const Color(0xFFB8860B) : Colors.black38),
        ]),
      ),
    ),
  );
}

class _JourneyScreen extends StatefulWidget {
  const _JourneyScreen({required this.journey});
  final _Journey journey;
  @override
  State<_JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<_JourneyScreen> {
  int step = 0;
  int attempts = 0;
  int? answer;
  bool solved = false;
  int? impression;

  void next() {
    if (step == 5) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => step++);
    }
  }

  void check() {
    if (answer == null || solved) return;
    final nextAttempts = attempts + 1;
    setState(() {
      attempts = nextAttempts;
      if (answer == widget.journey.correct || nextAttempts >= 3) {
        solved = true;
        answer = widget.journey.correct;
      } else {
        answer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const labels = ['故事', '生词', '发现', '挑战', '印象', '盖章'];
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: Text(widget.journey.title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [for (var i = 0; i < labels.length; i++) Expanded(child: Column(children: [CircleAvatar(radius: 11, backgroundColor: i <= step ? PhoenixTheme.red : Colors.black12, child: Text('${i + 1}', style: const TextStyle(fontSize: 9, color: Colors.white))), Text(labels[i], style: const TextStyle(fontSize: 9))]))]),
        ),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 30), child: _content())),
      ]),
    );
  }

  Widget _card(String eyebrow, String title, IconData icon, List<Widget> children) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), borderRadius: BorderRadius.circular(24)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Icon(icon, color: PhoenixTheme.red), const SizedBox(width: 8), Text(eyebrow, style: const TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900))]), const SizedBox(height: 8), Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), const SizedBox(height: 18), ...children]),
  );

  Widget _button(String label, VoidCallback? action) => SizedBox(width: double.infinity, child: FilledButton(onPressed: action, child: Text(label)));

  Widget _content() {
    final j = widget.journey;
    switch (step) {
      case 0:
        return _card(j.city, j.title, j.icon, [Text(j.story, style: const TextStyle(fontSize: 16, height: 1.8)), const SizedBox(height: 18), _button('进入生词', next)]);
      case 1:
        return _card('生词', '旅程词袋', Icons.translate_rounded, [for (final w in j.words) Padding(padding: const EdgeInsets.only(bottom: 10), child: ListTile(tileColor: const Color(0xFFFFF8E8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), title: Text(w.$1, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text('${w.$2} · ${w.$3}'))), _button('继续发现', next)]);
      case 2:
        return _card('旅途发现', j.discoveryTitle, Icons.travel_explore_rounded, [Text(j.discovery, style: const TextStyle(fontSize: 16, height: 1.7)), const SizedBox(height: 14), Text('隐藏发现：${j.hidden}', style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 18), _button('接受挑战', next)]);
      case 3:
        return _card('挑战', '三次机会', Icons.bolt_rounded, [Text(j.question, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)), const SizedBox(height: 12), RadioGroup<int>(groupValue: answer, onChanged: solved ? (_) {} : (value) => setState(() => answer = value), child: Column(children: [for (var i = 0; i < j.options.length; i++) RadioListTile<int>(value: i, title: Text(j.options[i]))])), if (attempts > 0) Text(solved ? j.explanation : j.hint, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 12), _button(solved ? '留下印象' : '提交答案 · 第 ${attempts + 1} 次', solved ? next : (answer == null ? null : check))]);
      case 4:
        return _card('留下印象', '你会带走什么？', Icons.bookmark_rounded, [for (var i = 0; i < j.impressions.length; i++) ChoiceChip(label: SizedBox(width: double.infinity, child: Text(j.impressions[i])), selected: impression == i, onSelected: (_) => setState(() => impression = i)), const SizedBox(height: 14), _button('去盖章', impression == null ? null : next)]);
      default:
        final reward = attempts <= 1 ? '金币' : attempts == 2 ? '银币' : '铜币';
        return _card('旅程完成', j.stamp, Icons.workspace_premium_rounded, [Center(child: CircleAvatar(radius: 70, backgroundColor: PhoenixTheme.red.withValues(alpha: .08), child: Padding(padding: const EdgeInsets.all(16), child: Text(j.stamp, textAlign: TextAlign.center, style: const TextStyle(color: PhoenixTheme.red, fontSize: 20, fontWeight: FontWeight.w900))))), const SizedBox(height: 18), Text('获得 $reward · ${j.finalMessage}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w800)), const SizedBox(height: 18), _button('收进护照', next)]);
    }
  }
}

class _Journey {
  const _Journey({required this.id, required this.city, required this.title, required this.subtitle, required this.icon, required this.colors, required this.story, required this.words, required this.discoveryTitle, required this.discovery, required this.hidden, required this.question, required this.options, required this.correct, required this.hint, required this.explanation, required this.impressions, required this.stamp, required this.finalMessage});
  final String id, city, title, subtitle, story, discoveryTitle, discovery, hidden, question, hint, explanation, stamp, finalMessage;
  final IconData icon;
  final List<Color> colors;
  final List<(String, String, String)> words;
  final List<String> options, impressions;
  final int correct;
}

const journeys4 = <_Journey>[
  _Journey(id: 'xiamen-tide-piano', city: '厦门', title: '潮声里的旧钢琴', subtitle: '沿着海岸琴声，寻找一段未完成的合奏。', icon: Icons.piano_rounded, colors: [Color(0xFF0369A1), Color(0xFFF59E0B)], story: '清晨的鼓浪屿还没有完全醒来，林夏在一栋老屋里发现一架缺少高音键的旧钢琴。琴盖内侧写着一串日期，那是祖父年轻时与邻居约定合奏的日子。她循着谱页和海风找到对方的孙女，两人在潮声中补完了最后八小节。琴音并不完美，却让两户人家迟到了几十年的问候终于抵达。', words: [('合奏', '动词', '共同演奏音乐'), ('谱页', '名词', '写有乐谱的纸页'), ('抵达', '动词', '到达某处')], discoveryTitle: '岛屿建筑为什么装着多种声音', discovery: '港口城市长期连接不同地区，建筑、音乐与生活习惯会在交流中互相影响。老屋不仅保存外观，也保存居民的家庭记忆。', hidden: '鼓浪屿的音乐传统与家庭教育、教堂和公共文化空间长期交织。', question: '两位女孩补完合奏的主要意义是什么？', options: ['修好钢琴全部零件', '完成跨代未尽的问候', '证明旧乐谱没有价值', '准备参加商业比赛'], correct: 1, hint: '注意祖父辈的约定与最后一句。', explanation: '合奏让上一代未完成的约定在下一代得到回应。', impressions: ['音乐能替时间保存未说完的话。', '城市交流会留下多层文化声音。', '不完美的完成也有珍贵意义。'], stamp: '厦门 · 潮声合奏章', finalMessage: '海浪反复抵岸，迟到的琴声也终于抵达。'),
  _Journey(id: 'datong-statue-light', city: '大同', title: '石窟晨光中的微笑', subtitle: '在石壁与晨光之间，辨认一张跨越千年的面孔。', icon: Icons.temple_buddhist_rounded, colors: [Color(0xFF92400E), Color(0xFFEAB308)], story: '修学旅行的阿岚在石窟中注意到一尊小像嘴角微微上扬。随着阳光移动，那道微笑时隐时现。讲解员告诉她，石雕的神情并不是单靠嘴角完成，眉眼、面部转折和光影共同塑造观看感受。阿岚在速写本上连续画了四次，才明白文物不会主动变化，变化的是光线与观看者。', words: [('石窟', '名词', '开凿在岩壁中的洞室'), ('转折', '名词', '形体或意义发生变化的地方'), ('速写', '名词', '快速记录形态的绘画')], discoveryTitle: '光线如何改变石雕表情', discovery: '雕塑依靠凹凸表面接收光线。观看时间、角度与自然光变化，会让同一件作品显现不同层次。', hidden: '古代工匠会综合洞窟朝向、造像位置和观看距离安排细节。', question: '阿岚最后理解了什么？', options: ['石像每天会更换表情', '光线与视角改变观看感受', '速写能够替代文物保护', '讲解员移动了石像位置'], correct: 1, hint: '故事最后直接比较了文物与观看者。', explanation: '文物本身不动，但光线和观看角度会改变人们感受到的神情。', impressions: ['观看本身也是理解艺术的一部分。', '光影能让沉静石面产生时间感。', '细节需要在不同角度中反复确认。'], stamp: '大同 · 石光微笑章', finalMessage: '石头保持沉默，晨光替它说出不同的表情。'),
  _Journey(id: 'zhangjiajie-cloud-path', city: '张家界', title: '云海中消失的山路', subtitle: '跟随护林员，在云雾里找回一条旧巡山线。', icon: Icons.forest_rounded, colors: [Color(0xFF166534), Color(0xFF64748B)], story: '少年森森跟随护林员寻找被落叶覆盖的旧巡山路。云雾压低后，远处山峰失去轮廓，他们只能依靠岩壁水痕、树干标记和溪流方向前进。途中森森发现一处新踩出的捷径，护林员却带他绕回旧路，因为捷径穿过脆弱植被。森森这才懂得，找到道路不只是为了更快抵达，也要让山林承受得起人的脚步。', words: [('巡山', '动词', '沿山路检查环境与安全'), ('水痕', '名词', '水流长期留下的痕迹'), ('植被', '名词', '地表生长的植物群体')], discoveryTitle: '为什么自然景区需要固定步道', discovery: '固定步道可集中游客活动范围，减少对土壤、植物和野生动物栖息地的干扰。路线设计也需要兼顾安全与生态承载。', hidden: '看似更短的野路可能造成土壤侵蚀，并逐渐扩大为难以恢复的裸地。', question: '护林员为什么放弃捷径？', options: ['捷径距离反而更远', '捷径会伤害脆弱植被', '旧路旁有更多商店', '云雾只覆盖了捷径'], correct: 1, hint: '注意捷径穿过了什么。', explanation: '固定路线保护脆弱环境，速度不能凌驾于生态承载之上。', impressions: ['抵达自然，也要尊重自然的边界。', '真正的近路未必是最负责任的路。', '环境线索能帮助人在雾中辨路。'], stamp: '张家界 · 云径守护章', finalMessage: '好道路不仅带人向前，也让山林安稳留下。'),
  _Journey(id: 'kaifeng-river-map', city: '开封', title: '城门下的河图残页', subtitle: '沿古城水系，拼回一张被雨水打散的地图。', icon: Icons.map_rounded, colors: [Color(0xFF7F1D1D), Color(0xFF2563EB)], story: '暴雨后，小满在城门附近捡到几片旧地图残页。图上河道与今天街巷并不完全重合，她便请教修城史的老师。两人沿着低洼地、桥名和旧井位置比对，发现许多消失的水道仍在影响城市排水。小满把残页重新拼好，却没有把新街道强行画成旧河，她在旁边加了一层透明纸，让过去与现在同时被看见。', words: [('残页', '名词', '残缺的书页或图页'), ('低洼', '形容词', '地势比周围低'), ('排水', '动词', '把积水引导排出')], discoveryTitle: '消失的河道为什么仍影响城市', discovery: '城市扩展可能覆盖旧水系，但地形高低和地下通道仍会影响积水方向。历史地图可帮助理解城市空间变化。', hidden: '桥名、街名和井的位置常保存已经消失的地理记忆。', question: '小满为什么使用透明纸？', options: ['让地图看起来更昂贵', '同时呈现过去与现在', '隐藏所有旧河道位置', '方便把地图折得更小'], correct: 1, hint: '她没有强行把新街道画成旧河。', explanation: '透明叠图让两个时代并置，避免用一个时代覆盖另一个时代。', impressions: ['城市表面之下还藏着旧地理。', '理解变化不等于抹去差异。', '地图也可以讲述时间。'], stamp: '开封 · 河图叠影章', finalMessage: '河道会改变方向，城市仍记得水曾经走过哪里。'),
  _Journey(id: 'guiyang-silver-bell', city: '贵阳', title: '山寨夜雨中的银铃', subtitle: '穿过雨夜与木楼，送回一枚属于节庆的旧银铃。', icon: Icons.notifications_active_rounded, colors: [Color(0xFF0F766E), Color(0xFF9F1239)], story: '夜雨落在木楼屋檐上，阿苗在石阶边捡到一枚旧银铃。铃身刻着细小旋纹，却没有挂绳。寨中老人认出它来自一套多年未穿的节庆服饰。阿苗原以为只要把铃擦亮就算修好，银匠却先询问原来的排列和佩戴方式。重新缝回衣饰后，银铃在步伐中发出轻响，老人说，物件的声音只有回到生活里才算完整。', words: [('银铃', '名词', '用银制成的小铃'), ('旋纹', '名词', '旋转或连续弯曲的纹样'), ('佩戴', '动词', '把饰物穿戴在身上')], discoveryTitle: '传统饰物为什么不能只看外观', discovery: '服饰与银饰的排列、用途、制作方法和使用场景共同构成文化意义。脱离原有关系，只恢复光亮可能仍不完整。', hidden: '银饰的声音、重量与动作节奏，也可能是整体设计的一部分。', question: '银匠为什么先问排列和佩戴方式？', options: ['为了提高银铃售价', '为了恢复它在服饰中的关系', '因为银铃不能被擦亮', '为了改成现代项链'], correct: 1, hint: '故事最后强调声音要回到生活。', explanation: '修复不仅处理单件物品，也要尊重它与服饰、动作和节庆的原有关系。', impressions: ['文化意义常存在于物件之间的关系里。', '光亮不是修复的唯一标准。', '声音也能保存生活记忆。'], stamp: '贵阳 · 夜雨银铃章', finalMessage: '银铃重新响起时，旧日生活也轻轻回到人群中。'),
];
