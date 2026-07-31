import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class FiveMoreJourneysScreen extends StatefulWidget {
  const FiveMoreJourneysScreen({super.key});

  @override
  State<FiveMoreJourneysScreen> createState() => _FiveMoreJourneysScreenState();
}

class _FiveMoreJourneysScreenState extends State<FiveMoreJourneysScreen> {
  static const _completionKey = 'phoenix.fiveMoreJourneys.completed.v1';
  static const _rewardKey = 'phoenix.fiveMoreJourneys.rewards.v1';

  Set<String> _completed = <String>{};
  Map<String, String> _rewards = <String, String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final rewards = <String, String>{};
    for (final item in prefs.getStringList(_rewardKey) ?? const <String>[]) {
      final divider = item.indexOf('|');
      if (divider > 0) rewards[item.substring(0, divider)] = item.substring(divider + 1);
    }
    if (!mounted) return;
    setState(() {
      _completed = (prefs.getStringList(_completionKey) ?? const <String>[]).toSet();
      _rewards = rewards;
      _loading = false;
    });
  }

  Future<void> _open(_Journey journey) async {
    final result = await Navigator.of(context).push<_JourneyResult>(
      MaterialPageRoute<_JourneyResult>(
        builder: (_) => _JourneyFlowScreen(journey: journey),
      ),
    );
    if (result == null) return;
    final completed = <String>{..._completed, journey.id};
    final rewards = <String, String>{..._rewards, journey.id: result.reward};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completionKey, completed.toList()..sort());
    await prefs.setStringList(
      _rewardKey,
      rewards.entries.map((e) => '${e.key}|${e.value}').toList()..sort(),
    );
    if (!mounted) return;
    setState(() {
      _completed = completed;
      _rewards = rewards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Phoenix · 山河新章'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
              children: [
                _CollectionHeader(completed: _completed.length),
                const SizedBox(height: 18),
                for (var index = 0; index < fiveMoreJourneys.length; index++) ...[
                  _JourneyTile(
                    journey: fiveMoreJourneys[index],
                    number: index + 6,
                    completed: _completed.contains(fiveMoreJourneys[index].id),
                    reward: _rewards[fiveMoreJourneys[index].id],
                    onTap: () => _open(fiveMoreJourneys[index]),
                  ),
                  if (index != fiveMoreJourneys.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _CollectionHeader extends StatelessWidget {
  const _CollectionHeader({required this.completed});
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF173B4B), Color(0xFF8E4D2F)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('第二卷 · 五地风物', style: TextStyle(color: Color(0xFFFFD879), fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('从海丝旧港，走到雪域屋顶', style: TextStyle(color: Colors.white, fontSize: 24, height: 1.25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text('五个新旅程均包含故事、生词、发现、挑战、印象与盖章。已完成 $completed / 5。', style: TextStyle(color: Colors.white.withValues(alpha: .86), height: 1.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: completed / 5,
              minHeight: 9,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD879)),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyTile extends StatelessWidget {
  const _JourneyTile({required this.journey, required this.number, required this.completed, required this.reward, required this.onTap});
  final _Journey journey;
  final int number;
  final bool completed;
  final String? reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .9),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: journey.colors),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(journey.icon, color: Colors.white, size: 29),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('旅程 $number · ${journey.location}', style: const TextStyle(color: PhoenixTheme.red, fontSize: 12, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(journey.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(journey.subtitle, style: const TextStyle(color: Colors.black54, height: 1.35, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(completed ? Icons.verified_rounded : Icons.chevron_right_rounded, color: completed ? const Color(0xFFB8860B) : Colors.black38),
                  if (reward != null) Text(reward!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyFlowScreen extends StatefulWidget {
  const _JourneyFlowScreen({required this.journey});
  final _Journey journey;

  @override
  State<_JourneyFlowScreen> createState() => _JourneyFlowScreenState();
}

class _JourneyFlowScreenState extends State<_JourneyFlowScreen> {
  int _step = 0;
  int _attempts = 0;
  int? _answer;
  int? _impression;
  String? _feedback;
  bool _resolved = false;

  _Journey get journey => widget.journey;
  String get reward => _attempts <= 1 ? '金币' : _attempts == 2 ? '银币' : '铜币';

  void _next() {
    if (_step == 5) {
      Navigator.of(context).pop(_JourneyResult(reward));
      return;
    }
    setState(() {
      _step += 1;
      _feedback = null;
    });
  }

  void _check() {
    if (_resolved || _answer == null) return;
    final attempt = _attempts + 1;
    final correct = _answer == journey.correctAnswer;
    final exhausted = !correct && attempt >= 3;
    setState(() {
      _attempts = attempt;
      if (correct) {
        _resolved = true;
        _feedback = '回答正确。${journey.explanation}';
      } else if (exhausted) {
        _resolved = true;
        _answer = journey.correctAnswer;
        _feedback = '三次机会已用完，正确答案已标出。${journey.explanation}';
      } else {
        _answer = null;
        _feedback = journey.hint;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const labels = <String>['故事', '生词', '发现', '挑战', '印象', '盖章'];
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: Text(journey.title)),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.white.withValues(alpha: .78),
              child: Row(
                children: [
                  for (var index = 0; index < labels.length; index++)
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: index <= _step ? PhoenixTheme.red : const Color(0xFFE4DCD2),
                            child: Text('${index + 1}', style: TextStyle(color: index <= _step ? Colors.white : Colors.black38, fontSize: 10, fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 3),
                          Text(labels[index], style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: index == _step ? PhoenixTheme.red : Colors.black45)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                child: _buildStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Card(title: journey.title, eyebrow: journey.location, icon: journey.icon, children: [
          Text(journey.story, style: const TextStyle(fontSize: 16, height: 1.85, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          _Button(label: '进入生词', onPressed: _next),
        ]);
      case 1:
        return _Card(title: '旅程词袋', eyebrow: '生词', icon: Icons.translate_rounded, children: [
          for (final word in journey.vocabulary) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFFFBF3), borderRadius: BorderRadius.circular(16)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Text(word.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                Expanded(flex: 2, child: Text('${word.part} · ${word.english}\n${word.meaning}', style: const TextStyle(height: 1.45))),
              ]),
            ),
            const SizedBox(height: 10),
          ],
          _Button(label: '继续发现', onPressed: _next),
        ]);
      case 2:
        return _Card(title: journey.discoveryTitle, eyebrow: '旅途发现', icon: Icons.travel_explore_rounded, children: [
          Text(journey.discovery, style: const TextStyle(fontSize: 16, height: 1.75, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFEFCB), borderRadius: BorderRadius.circular(16)), child: Text(journey.hiddenDiscovery, style: const TextStyle(height: 1.45, fontWeight: FontWeight.w800))),
          const SizedBox(height: 20),
          _Button(label: '接受挑战', onPressed: _next),
        ]);
      case 3:
        return _Card(title: '三次机会', eyebrow: '挑战', icon: Icons.bolt_rounded, children: [
          Text(journey.question, style: const TextStyle(fontSize: 17, height: 1.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          for (var index = 0; index < journey.options.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: RadioListTile<int>(
                value: index,
                groupValue: _answer,
                onChanged: _resolved ? null : (value) => setState(() => _answer = value),
                title: Text(journey.options[index]),
                tileColor: _answer == index ? const Color(0xFFFFE7BE) : Colors.white.withValues(alpha: .86),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          if (_feedback != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(_feedback!, style: const TextStyle(height: 1.45, fontWeight: FontWeight.w700))),
          _Button(label: _resolved ? '留下印象' : '提交答案 · 第 ${_attempts + 1} 次', onPressed: _resolved ? _next : (_answer == null ? null : _check)),
        ]);
      case 4:
        return _Card(title: '你会带走什么？', eyebrow: '留下印象', icon: Icons.bookmark_rounded, children: [
          for (var index = 0; index < journey.impressions.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: ChoiceChip(
                label: SizedBox(width: double.infinity, child: Text(journey.impressions[index], textAlign: TextAlign.left)),
                selected: _impression == index,
                onSelected: (_) => setState(() => _impression = index),
              ),
            ),
          const SizedBox(height: 12),
          _Button(label: '去盖章', onPressed: _impression == null ? null : _next),
        ]);
      default:
        return _Card(title: journey.stamp, eyebrow: '旅程完成', icon: Icons.workspace_premium_rounded, children: [
          Center(
            child: Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: PhoenixTheme.red, width: 7), color: PhoenixTheme.red.withValues(alpha: .06)),
              child: Padding(padding: const EdgeInsets.all(18), child: Text(journey.stamp, textAlign: TextAlign.center, style: const TextStyle(color: PhoenixTheme.red, fontSize: 22, fontWeight: FontWeight.w900))),
            ),
          ),
          const SizedBox(height: 18),
          Text('获得 $reward · ${journey.finalMessage}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          _Button(label: '收进护照', onPressed: _next),
        ]);
    }
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.eyebrow, required this.icon, required this.children});
  final String title;
  final String eyebrow;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [Icon(icon, color: PhoenixTheme.red), const SizedBox(width: 9), Text(eyebrow, style: const TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        ...children,
      ]),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: FilledButton(onPressed: onPressed, child: Text(label)));
  }
}

class _JourneyResult {
  const _JourneyResult(this.reward);
  final String reward;
}

class _Word {
  const _Word(this.word, this.part, this.english, this.meaning);
  final String word;
  final String part;
  final String english;
  final String meaning;
}

class _Journey {
  const _Journey({
    required this.id,
    required this.location,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.story,
    required this.vocabulary,
    required this.discoveryTitle,
    required this.discovery,
    required this.hiddenDiscovery,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.hint,
    required this.explanation,
    required this.impressions,
    required this.stamp,
    required this.finalMessage,
  });

  final String id;
  final String location;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final String story;
  final List<_Word> vocabulary;
  final String discoveryTitle;
  final String discovery;
  final String hiddenDiscovery;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String hint;
  final String explanation;
  final List<String> impressions;
  final String stamp;
  final String finalMessage;
}

const fiveMoreJourneys = <_Journey>[
  _Journey(
    id: 'quanzhou-sea-letter',
    location: '泉州',
    title: '海风送来的番客信',
    subtitle: '沿着古港、石桥和香料气息，寻找一封跨海百年的回信。',
    icon: Icons.sailing_rounded,
    colors: [Color(0xFF155E75), Color(0xFFD97706)],
    story: '清晨的洛阳桥还带着潮气。少年阿澜在桥洞边捡到一只旧木匣，匣中藏着一封没有寄出的番客信。信里只写着一句：“当刺桐再次开花，请替我告诉故乡，我平安抵达。”阿澜循着香料铺、古寺钟声与港口石阶，终于找到信中那户人家的后代。老人没有哭，只把一枝刺桐花放进木匣，说海上的路从来不只运货，也运送等待。',
    vocabulary: [_Word('番客', '名词', 'foreign merchant', '古代来到中国港口经商的海外客商'), _Word('舶来品', '名词', 'imported goods', '从海外经船舶运来的物品'), _Word('抵达', '动词', 'arrive', '到达目的地')],
    discoveryTitle: '海丝古港为什么如此繁忙',
    discovery: '泉州曾是重要的海上贸易港口。不同语言、宗教和商品在这里相遇，使城市形成开放而多元的生活面貌。桥梁、码头、寺庙和商铺共同记录了远洋贸易留下的痕迹。',
    hiddenDiscovery: '隐藏发现：刺桐曾是泉州极具代表性的城市意象，古代航海者常借花木和钟声辨认故乡。',
    question: '故事中，老人把刺桐花放进木匣，主要表达了什么？',
    options: ['拒绝承认那封旧信', '回应跨越时间的等待', '准备出售木匣换钱', '提醒少年不要出海'],
    correctAnswer: 1,
    hint: '想想花被放进“装信的木匣”这一动作，与信中的约定有什么关系。',
    explanation: '刺桐花完成了信中未完成的约定，也让跨越百年的等待得到回应。',
    impressions: ['港口连接的不只是地方，也是人的牵挂。', '一封旧信也能让历史重新发声。', '开放的城市会留下多种文化的纹理。'],
    stamp: '泉州 · 海丝回信章',
    finalMessage: '海风把远方带来，也把故乡送回远方。',
  ),
  _Journey(
    id: 'jingdezhen-blue-fire',
    location: '景德镇',
    title: '窑火里醒来的青花',
    subtitle: '守候一炉瓷器，从泥土、画笔到火焰，见证颜色诞生。',
    icon: Icons.local_fire_department_rounded,
    colors: [Color(0xFF1E3A8A), Color(0xFFF5E6C8)],
    story: '学徒小瓷第一次独自守窑。入窑前，她在白坯上画了一只逆风而飞的燕子，却担心钴料经过烈火会变得模糊。师傅只说：“窑门关上以后，谁也不能替火做决定。”一夜过去，窑温缓缓下降。开窑时，那只燕子从乳白瓷面上显出深浅不同的蓝，翅尖还留着一抹意外的晕染。小瓷这才明白，手艺并不是控制每一种变化，而是在变化中守住想表达的东西。',
    vocabulary: [_Word('白坯', '名词', 'unfired porcelain body', '尚未烧制和上釉的瓷器坯体'), _Word('钴料', '名词', 'cobalt pigment', '青花瓷绘画常用的蓝色矿物颜料'), _Word('晕染', '动词', 'bleed softly', '颜色向周围自然扩散形成层次')],
    discoveryTitle: '青花为什么要经过火才显色',
    discovery: '青花纹样通常先绘在瓷坯上，再罩透明釉并高温烧制。钴料在窑火中发生变化，最终透过釉层呈现蓝色。泥、釉、颜料、温度与时间共同决定成品效果。',
    hiddenDiscovery: '隐藏发现：一件瓷器常要经过多道工序，任何细微变化都可能留下独一无二的火痕。',
    question: '师傅说“谁也不能替火做决定”，最接近哪层意思？',
    options: ['烧窑完全不需要经验', '制作中存在无法完全控制的变化', '只要火大瓷器就一定成功', '学徒不应该画燕子'],
    correctAnswer: 1,
    hint: '结合最后小瓷对“变化”的理解来判断。',
    explanation: '制瓷需要经验，但窑内仍有复杂变化；真正的手艺是在不确定中保持判断与表达。',
    impressions: ['火焰会改变作品，也会检验创作者。', '手艺来自精准，也来自接受不确定。', '一抹意外的颜色可能成为作品的生命。'],
    stamp: '景德镇 · 青花窑火章',
    finalMessage: '泥土经过火，才把沉默的颜色说出来。',
  ),
  _Journey(
    id: 'dunhuang-flying-color',
    location: '敦煌',
    title: '沙海深处的失色飞天',
    subtitle: '跟随壁画修复者，在微光中寻找消失的颜色。',
    icon: Icons.auto_awesome_rounded,
    colors: [Color(0xFF9A3412), Color(0xFFEAB308)],
    story: '沙尘停下后的清晨，修复学员遥遥在洞窟角落发现一片几乎看不见的绿色。老师没有立刻补色，而是让她记录颜料边缘、裂纹走向和旧照片中的差异。几天后，遥遥确认那不是衣带，而是一朵被烟尘遮住的莲叶。老师说：“修复不是把今天喜欢的颜色画上去，而是让过去留下的证据继续存在。”当微光再次扫过墙面，那片浅绿仍不鲜艳，却终于有了自己的位置。',
    vocabulary: [_Word('洞窟', '名词', 'grotto', '开凿在岩壁中的洞室'), _Word('裂纹', '名词', 'crack', '材料表面产生的细小开裂痕迹'), _Word('修复', '动词', 'restore', '在尊重原貌的基础上保护和处理损坏部分')],
    discoveryTitle: '为什么文物修复不能追求“像新的一样”',
    discovery: '文物包含材料、工艺和历史变化留下的信息。修复工作强调识别原作、控制干预范围，并记录处理过程。目标不是把旧物变新，而是延缓损坏并保留真实证据。',
    hiddenDiscovery: '隐藏发现：一些壁画颜色会因光线、空气、颜料成分和时间而改变，今天看到的色彩未必等同于最初。',
    question: '老师为什么不让遥遥立刻补上绿色？',
    options: ['因为绿色颜料已经用完', '因为需要先确认原有图像证据', '因为洞窟里不允许出现莲叶', '因为旧照片完全不可信'],
    correctAnswer: 1,
    hint: '注意她先记录了边缘、裂纹和旧照片。',
    explanation: '修复必须先依据材料和历史记录判断原貌，避免用现代想象覆盖真实信息。',
    impressions: ['保护历史，有时意味着克制自己的创造。', '微弱的痕迹也可能是重要证据。', '不鲜艳不代表没有价值。'],
    stamp: '敦煌 · 守色飞天章',
    finalMessage: '真正被守护的，不只是颜色，还有时间留下的诚实。',
  ),
  _Journey(
    id: 'guilin-bamboo-lamp',
    location: '桂林',
    title: '漓江晨雾中的竹筏灯',
    subtitle: '在山水倒影之间，寻找一盏没有熄灭的归航灯。',
    icon: Icons.water_rounded,
    colors: [Color(0xFF166534), Color(0xFF38BDF8)],
    story: '天还没亮，阿木就撑着竹筏去找爷爷遗落的旧船灯。晨雾把山峰和水面连成一片，远处每个倒影都像另一条河。阿木听见岸边传来三声竹哨，那是爷爷教他的归航信号。他循声绕过浅滩，在一块半露的青石旁找到船灯。灯芯早已熄灭，可玻璃罩里夹着一张纸条：“认路不只靠眼睛，也要记住水声、风向和岸上的人。”',
    vocabulary: [_Word('竹筏', '名词', 'bamboo raft', '用竹子扎成的水上交通工具'), _Word('浅滩', '名词', 'shoal', '水较浅、容易搁浅的河段'), _Word('归航', '动词', 'return from a voyage', '结束航行并返回出发地')],
    discoveryTitle: '山水中的方向从哪里来',
    discovery: '在雾气、弯曲河道和相似山形中，传统行舟者会综合水流、风向、岸边地标、声音和经验判断位置。自然景观既美丽，也是一套需要长期学习的空间语言。',
    hiddenDiscovery: '隐藏发现：倒影会制造视觉错觉，所以熟悉水域的人不会只依赖眼睛辨路。',
    question: '爷爷纸条中的核心提醒是什么？',
    options: ['只要看见山峰就不会迷路', '辨认方向需要多种线索和经验', '船灯永远比竹哨更可靠', '晨雾中不应该出航'],
    correctAnswer: 1,
    hint: '纸条列出了水声、风向和岸上的人。',
    explanation: '归航依赖视觉之外的多种信息，也依赖人与环境长期建立的熟悉感。',
    impressions: ['风景也是一种可以学习的语言。', '熟悉来自长期观察，而不是一次记忆。', '回家的方向常由人与环境共同指引。'],
    stamp: '桂林 · 漓江归航章',
    finalMessage: '雾会遮住山，却遮不住被认真记住的方向。',
  ),
  _Journey(
    id: 'lhasa-prayer-roof',
    location: '拉萨',
    title: '雪域屋顶上的金色经幡',
    subtitle: '穿过高原晨光，把一条旧经幡送回它等待的屋顶。',
    icon: Icons.landscape_rounded,
    colors: [Color(0xFF7C3AED), Color(0xFFF59E0B)],
    story: '卓玛在旧书摊得到一条褪色经幡，边角缝着一个小小的太阳图案。摊主说，它来自城北一座多年无人居住的老屋。卓玛带着经幡穿过清晨街巷，终于在屋顶找到同样的太阳纹木梁。邻居老人认出那是她姐姐年轻时缝的，便把经幡重新系在屋顶。风吹起布角时，没有人说话。老人只是抬头看了很久，仿佛许多没有说完的话，终于找到能够继续飘动的地方。',
    vocabulary: [_Word('经幡', '名词', 'prayer flag', '常悬挂于高原地区、带有文字或图案的布幡'), _Word('褪色', '动词', 'fade', '颜色因时间和环境逐渐变淡'), _Word('木梁', '名词', 'wooden beam', '建筑中承重或连接结构的木构件')],
    discoveryTitle: '高原屋顶为什么承载那么多记忆',
    discovery: '屋顶、门窗、木构和悬挂物不仅具有实用功能，也会保存家庭习惯、地方工艺和个人记忆。风、日照和高原环境让材料逐渐变化，而这些变化本身也成为时间的记录。',
    hiddenDiscovery: '隐藏发现：经幡的颜色会慢慢褪去，但人们常把这种变化理解为愿望随风不断传向远方。',
    question: '老人为什么“抬头看了很久”？',
    options: ['她不喜欢卓玛带来的经幡', '经幡唤起了与姐姐有关的记忆', '她正在判断天气是否下雪', '她想把木梁拆下来出售'],
    correctAnswer: 1,
    hint: '注意太阳图案是谁缝的，以及经幡被重新系回哪里。',
    explanation: '旧经幡重新连接了姐姐、老屋与过去的生活，让沉默的记忆再次有了位置。',
    impressions: ['物件会褪色，但关系留下的意义不会轻易消失。', '有些告别不是结束，而是换一种方式继续。', '一座屋顶也能保存一家人的时间。'],
    stamp: '拉萨 · 风中金幡章',
    finalMessage: '风带走颜色，也让记忆继续远行。',
  ),
];
