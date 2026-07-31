import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class JourneyExpeditionScreen extends StatefulWidget {
  const JourneyExpeditionScreen({super.key});

  @override
  State<JourneyExpeditionScreen> createState() => _JourneyExpeditionScreenState();
}

class _JourneyExpeditionScreenState extends State<JourneyExpeditionScreen> {
  static const _progressKey = 'phoenix.expedition.progress.v1';
  static const _secretKey = 'phoenix.expedition.secrets.v1';
  static const _stampKey = 'phoenix.expedition.stamps.v1';

  Map<String, int> _progress = <String, int>{};
  Set<String> _secrets = <String>{};
  Set<String> _stamps = <String>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final progress = <String, int>{};
    for (final item in prefs.getStringList(_progressKey) ?? const <String>[]) {
      final parts = item.split('|');
      if (parts.length == 2) progress[parts.first] = int.tryParse(parts.last) ?? 0;
    }
    if (!mounted) return;
    setState(() {
      _progress = progress;
      _secrets = (prefs.getStringList(_secretKey) ?? const <String>[]).toSet();
      _stamps = (prefs.getStringList(_stampKey) ?? const <String>[]).toSet();
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setStringList(_progressKey, _progress.entries.map((e) => '${e.key}|${e.value}').toList()),
      prefs.setStringList(_secretKey, _secrets.toList()..sort()),
      prefs.setStringList(_stampKey, _stamps.toList()..sort()),
    ]);
  }

  Future<void> _open(_Expedition journey) async {
    final result = await Navigator.of(context).push<_ExpeditionResult>(
      MaterialPageRoute(
        builder: (_) => _ExpeditionMapScreen(
          journey: journey,
          initialNode: _progress[journey.id] ?? 0,
          secretFound: _secrets.contains(journey.id),
        ),
      ),
    );
    if (result == null) return;
    setState(() {
      _progress[journey.id] = result.node;
      if (result.secretFound) _secrets.add(journey.id);
      if (result.completed) _stamps.add(journey.id);
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('Phoenix · 五城远征'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
              children: [
                _OverviewCard(
                  completed: _stamps.length,
                  secrets: _secrets.length,
                  explored: _progress.values.fold(0, (a, b) => a + b),
                ),
                const SizedBox(height: 18),
                for (final journey in expeditions) ...[
                  _ExpeditionCard(
                    journey: journey,
                    progress: _progress[journey.id] ?? 0,
                    stamped: _stamps.contains(journey.id),
                    secretFound: _secrets.contains(journey.id),
                    onTap: () => _open(journey),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.completed, required this.secrets, required this.explored});
  final int completed;
  final int secrets;
  final int explored;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF5E1717), Color(0xFFB74A31)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('五城远征地图', style: TextStyle(color: Color(0xFFFFD879), fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('每座城，都藏着不止一条路', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Text('已探索 $explored 个节点 · 发现 $secrets / 5 个隐藏线索 · 获得 $completed / 5 枚印章', style: TextStyle(color: Colors.white.withValues(alpha: .85), height: 1.5, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _ExpeditionCard extends StatelessWidget {
  const _ExpeditionCard({required this.journey, required this.progress, required this.stamped, required this.secretFound, required this.onTap});
  final _Expedition journey;
  final int progress;
  final bool stamped;
  final bool secretFound;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ratio = progress / journey.nodes.length;
    return Material(
      color: Colors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 58, height: 58, decoration: BoxDecoration(gradient: LinearGradient(colors: journey.colors), borderRadius: BorderRadius.circular(18)), child: Icon(journey.icon, color: Colors.white, size: 30)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(journey.location, style: const TextStyle(color: PhoenixTheme.red, fontSize: 12, fontWeight: FontWeight.w900)),
                Text(journey.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                Text(journey.subtitle, style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black54, fontWeight: FontWeight.w600)),
              ])),
              Icon(stamped ? Icons.verified_rounded : Icons.chevron_right_rounded, color: stamped ? const Color(0xFFB8860B) : Colors.black38),
            ]),
            const SizedBox(height: 14),
            ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: ratio.clamp(0, 1), minHeight: 8, backgroundColor: const Color(0xFFEAE2D8))),
            const SizedBox(height: 8),
            Row(children: [
              Text('$progress / ${journey.nodes.length} 节点', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(secretFound ? '隐藏发现已找到' : '隐藏发现未找到', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: secretFound ? PhoenixTheme.red : Colors.black45)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _ExpeditionMapScreen extends StatefulWidget {
  const _ExpeditionMapScreen({required this.journey, required this.initialNode, required this.secretFound});
  final _Expedition journey;
  final int initialNode;
  final bool secretFound;

  @override
  State<_ExpeditionMapScreen> createState() => _ExpeditionMapScreenState();
}

class _ExpeditionMapScreenState extends State<_ExpeditionMapScreen> {
  late int _unlocked;
  late bool _secretFound;

  @override
  void initState() {
    super.initState();
    _unlocked = widget.initialNode;
    _secretFound = widget.secretFound;
  }

  Future<void> _openNode(int index) async {
    if (index > _unlocked) return;
    final node = widget.journey.nodes[index];
    final result = await Navigator.of(context).push<_NodeResult>(
      MaterialPageRoute(builder: (_) => _NodeScreen(journey: widget.journey, node: node, index: index)),
    );
    if (result == null) return;
    setState(() {
      if (result.completed && index == _unlocked) _unlocked = (_unlocked + 1).clamp(0, widget.journey.nodes.length);
      if (result.secretFound) _secretFound = true;
    });
  }

  void _leave() {
    Navigator.of(context).pop(_ExpeditionResult(node: _unlocked, secretFound: _secretFound, completed: _unlocked >= widget.journey.nodes.length));
  }

  @override
  Widget build(BuildContext context) {
    final complete = _unlocked >= widget.journey.nodes.length;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _leave(),
      child: Scaffold(
        backgroundColor: PhoenixTheme.paper,
        appBar: AppBar(leading: IconButton(onPressed: _leave, icon: const Icon(Icons.arrow_back_rounded)), title: Text(widget.journey.title)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(colors: widget.journey.colors), borderRadius: BorderRadius.circular(26)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.journey.location, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(widget.journey.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(widget.journey.mission, style: TextStyle(color: Colors.white.withValues(alpha: .9), height: 1.5, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 18),
            for (var i = 0; i < widget.journey.nodes.length; i++) ...[
              _NodeTile(node: widget.journey.nodes[i], index: i, unlocked: i <= _unlocked, completed: i < _unlocked, onTap: () => _openNode(i)),
              if (i != widget.journey.nodes.length - 1) const _MapConnector(),
            ],
            const SizedBox(height: 18),
            if (complete)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xFFFFF1CE), borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  const Icon(Icons.workspace_premium_rounded, color: PhoenixTheme.red, size: 42),
                  const SizedBox(height: 8),
                  Text(widget.journey.summary, textAlign: TextAlign.center, style: const TextStyle(height: 1.55, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(_secretFound ? '隐藏发现：${widget.journey.secret}' : '还有一个隐藏发现留在旅途中', style: const TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900)),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

class _NodeTile extends StatelessWidget {
  const _NodeTile({required this.node, required this.index, required this.unlocked, required this.completed, required this.onTap});
  final _Node node;
  final int index;
  final bool unlocked;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: unlocked ? Colors.white : const Color(0xFFE8E1D8),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: unlocked ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(radius: 23, backgroundColor: completed ? PhoenixTheme.red : unlocked ? const Color(0xFFFFE4A8) : Colors.black12, child: Icon(completed ? Icons.check_rounded : unlocked ? node.icon : Icons.lock_rounded, color: completed ? Colors.white : Colors.black54)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('节点 ${index + 1} · ${node.type}', style: const TextStyle(fontSize: 11, color: PhoenixTheme.red, fontWeight: FontWeight.w900)),
              Text(node.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              Text(node.subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4, fontWeight: FontWeight.w600)),
            ])),
            Icon(unlocked ? Icons.chevron_right_rounded : Icons.lock_outline_rounded, color: Colors.black38),
          ]),
        ),
      ),
    );
  }
}

class _MapConnector extends StatelessWidget {
  const _MapConnector();
  @override
  Widget build(BuildContext context) => Container(width: 3, height: 18, margin: const EdgeInsets.only(left: 42), color: const Color(0xFFD3C5B5));
}

class _NodeScreen extends StatefulWidget {
  const _NodeScreen({required this.journey, required this.node, required this.index});
  final _Expedition journey;
  final _Node node;
  final int index;

  @override
  State<_NodeScreen> createState() => _NodeScreenState();
}

class _NodeScreenState extends State<_NodeScreen> {
  int? _selected;
  int _attempts = 0;
  bool _resolved = false;
  bool _secretFound = false;
  String? _feedback;

  void _check() {
    if (_selected == null || _resolved) return;
    final attempt = _attempts + 1;
    final correct = _selected == widget.node.correct;
    final exhausted = attempt >= 3;
    setState(() {
      _attempts = attempt;
      if (correct || exhausted) {
        _resolved = true;
        if (exhausted && !correct) _selected = widget.node.correct;
        _feedback = correct ? '答对了。${widget.node.explanation}' : '三次机会结束。${widget.node.explanation}';
      } else {
        _selected = null;
        _feedback = widget.node.hint;
      }
    });
  }

  void _finish() {
    Navigator.of(context).pop(_NodeResult(completed: true, secretFound: _secretFound));
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: Text(node.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(node.icon, color: PhoenixTheme.red, size: 34),
              const SizedBox(height: 10),
              Text(node.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(node.story, style: const TextStyle(fontSize: 16, height: 1.8, fontWeight: FontWeight.w600)),
              if (node.secretClue != null) ...[
                const SizedBox(height: 16),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() { _secretFound = true; _feedback = '你发现了隐藏线索：${node.secretClue}'; }),
                  child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFFFF0D1), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.auto_awesome_rounded, color: PhoenixTheme.red), SizedBox(width: 10), Expanded(child: Text('轻触查看角落里的异常细节', style: TextStyle(fontWeight: FontWeight.w900)))])),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 16),
          Text(node.question, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          for (var i = 0; i < node.options.length; i++) ...[
            ChoiceChip(label: SizedBox(width: double.infinity, child: Text(node.options[i])), selected: _selected == i, onSelected: _resolved ? null : (_) => setState(() => _selected = i)),
            const SizedBox(height: 8),
          ],
          if (_feedback != null) ...[
            const SizedBox(height: 10),
            Text(_feedback!, style: const TextStyle(color: PhoenixTheme.red, height: 1.5, fontWeight: FontWeight.w800)),
          ],
          const SizedBox(height: 18),
          FilledButton(onPressed: _resolved ? _finish : _check, child: Text(_resolved ? '完成节点' : '确认答案 · 第 ${_attempts + 1} 次')),
        ],
      ),
    );
  }
}

class _ExpeditionResult {
  const _ExpeditionResult({required this.node, required this.secretFound, required this.completed});
  final int node;
  final bool secretFound;
  final bool completed;
}

class _NodeResult {
  const _NodeResult({required this.completed, required this.secretFound});
  final bool completed;
  final bool secretFound;
}

class _Expedition {
  const _Expedition({required this.id, required this.location, required this.title, required this.subtitle, required this.mission, required this.summary, required this.secret, required this.icon, required this.colors, required this.nodes});
  final String id;
  final String location;
  final String title;
  final String subtitle;
  final String mission;
  final String summary;
  final String secret;
  final IconData icon;
  final List<Color> colors;
  final List<_Node> nodes;
}

class _Node {
  const _Node({required this.type, required this.title, required this.subtitle, required this.story, required this.question, required this.options, required this.correct, required this.hint, required this.explanation, required this.icon, this.secretClue});
  final String type;
  final String title;
  final String subtitle;
  final String story;
  final String question;
  final List<String> options;
  final int correct;
  final String hint;
  final String explanation;
  final IconData icon;
  final String? secretClue;
}

const expeditions = <_Expedition>[
  _Expedition(id: 'haiphong', location: '海防', title: '港口晨雾里的红花', subtitle: '沿着码头、老街与凤凰花路寻找失落的船信', mission: '一封没有署名的船信被晨雾打湿。你要沿港口留下的线索，找出它真正要送给谁。', summary: '你读懂了港口的方向，也读懂了等待与归来。海风把最后一句话留在了凤凰花下。', secret: '旧船票背面写着“归来不是终点，是重新出发”。', icon: Icons.sailing_rounded, colors: [Color(0xFF164E63), Color(0xFFEA580C)], nodes: [
    _Node(type: '故事', title: '雾中的汽笛', subtitle: '第一声汽笛从看不见的海面传来', story: '清晨五点，港口还裹在乳白色的雾里。一个修船老人把湿透的信交给你，只说：“它等了三十年。”', question: '老人为什么把信交给你？', options: ['因为你认识收信人', '因为信已经等了很久', '因为港口马上关闭', '因为信里有地图', '因为老人要离开'], correct: 1, hint: '注意老人说的那句话。', explanation: '“等了三十年”说明这封信最重要的不是速度，而是终于有人愿意继续送下去。', icon: Icons.foggy),
    _Node(type: '生词', title: '码头方向牌', subtitle: '从方向词判断下一站', story: '方向牌上只剩“顺岸而行，见红则停”八个字。岸线向东延伸，凤凰花开在旧仓库旁。', question: '“顺岸而行”最接近哪个意思？', options: ['沿着岸边走', '穿过仓库走', '逆着海风走', '坐船离开', '回到原地'], correct: 0, hint: '“顺”表示沿着既有方向。', explanation: '“顺岸而行”就是沿着岸边前进。', icon: Icons.signpost_rounded),
    _Node(type: '发现', title: '凤凰花路', subtitle: '红色花瓣盖住了一串脚印', story: '花瓣下面有两种脚印：一串走向仓库，一串走向海边。海边脚印旁落着新鲜的机油。', question: '哪条线索更可能属于修船工？', options: ['仓库方向的干脚印', '海边带机油的脚印', '花瓣最密的地方', '没有脚印的石阶', '远处的车辙'], correct: 1, hint: '修船工作常接触什么？', explanation: '机油与修船工作直接相关。', icon: Icons.local_florist_rounded, secretClue: '一张褪色船票藏在花坛边缘。'),
    _Node(type: '挑战', title: '旧仓库的回声', subtitle: '重新排列船信最后一句', story: '墙上写着五句话，其中只有一句保持了原信的意思。', question: '哪一句最自然？', options: ['虽然海很远，所以我会回来', '即使海很远，我也会回来', '因为海很远，但是我会回来', '海很远，而且我不回来', '如果海很远，所以我回来'], correct: 1, hint: '寻找正确的让步关系。', explanation: '“即使……也……”表达让步，逻辑完整。', icon: Icons.extension_rounded),
    _Node(type: '盖章', title: '归港灯塔', subtitle: '把信放进灯塔下的铜盒', story: '铜盒打开后，里面没有地址，只有一句：“交给仍在等的人。”你把信放回原处，灯塔亮了。', question: '这段旅程最核心的主题是什么？', options: ['速度', '等待与归来', '财富', '竞争', '遗忘'], correct: 1, hint: '回想“三十年”和灯塔。', explanation: '等待与归来贯穿整段旅程。', icon: Icons.emoji_events_rounded),
  ]),
  _Expedition(id: 'suzhou', location: '苏州', title: '雨巷里会移动的窗', subtitle: '在园林、石桥与雨巷之间追踪一扇不在原位的窗', mission: '一扇园林漏窗每逢雨夜就会改变位置。你要找出它移动的规律。', summary: '窗没有真的移动，移动的是人的视角。你学会了从不同位置重新理解同一件事。', secret: '窗框背面刻着“景不动，心先行”。', icon: Icons.window_rounded, colors: [Color(0xFF166534), Color(0xFF0F766E)], nodes: [
    _Node(type: '故事', title: '雨落平江路', subtitle: '第一扇窗出现在桥影里', story: '雨水把青石路洗得发亮。你在桥下水面的倒影里，看见一扇本不该存在的圆窗。', question: '圆窗最先出现在哪里？', options: ['屋顶', '桥下倒影', '茶馆墙上', '石路尽头', '船舱里'], correct: 1, hint: '注意“水面的倒影”。', explanation: '圆窗首先出现在桥下水面的倒影中。', icon: Icons.water_rounded),
    _Node(type: '生词', title: '借景', subtitle: '园林把远处景色纳入眼前', story: '园主说：“窗不是墙上的洞，它是借来远山的一只眼睛。”', question: '“借景”是什么意思？', options: ['借别人的画', '把远处景色纳入构图', '暂时关闭窗户', '复制一座园林', '把景色带回家'], correct: 1, hint: '思考窗与远山的关系。', explanation: '借景是园林设计中把外部景物引入当前视野。', icon: Icons.landscape_rounded),
    _Node(type: '发现', title: '回廊转角', subtitle: '同一座塔在三扇窗中位置不同', story: '你每走十步，远塔就在窗框中移动一点。窗没有变化，变化的是你站立的位置。', question: '塔为什么看起来在移动？', options: ['塔真的移动了', '窗框在旋转', '观察者位置改变', '雨水折断了光线', '有人推了窗'], correct: 2, hint: '谁一直在走？', explanation: '观察者的位置改变，使同一景物在窗框中的相对位置变化。', icon: Icons.rotate_90_degrees_ccw_rounded, secretClue: '第三扇窗的木框背面刻着一句小字。'),
    _Node(type: '挑战', title: '三窗一景', subtitle: '选择最准确的观察结论', story: '你记录了三次观察：塔在左、塔居中、塔在右。', question: '哪句话概括最准确？', options: ['塔的位置不断变化', '窗的位置不断变化', '观察角度改变了画面', '天气改变了园林', '三座塔依次出现'], correct: 2, hint: '区分真实位置与画面位置。', explanation: '真实景物未动，是观察角度改变了构图。', icon: Icons.quiz_rounded),
    _Node(type: '盖章', title: '留园月洞门', subtitle: '在最后一扇窗前留下印象', story: '雨停后，圆窗回到最初的位置。你却知道，它从未离开。', question: '旅程带来的核心理解是什么？', options: ['景物会消失', '角度会改变理解', '雨夜不能出门', '窗越多越好', '园林没有规律'], correct: 1, hint: '回想你一路改变的位置。', explanation: '不同角度会改变人对同一景物的理解。', icon: Icons.verified_rounded),
  ]),
  _Expedition(id: 'xian', location: '西安', title: '城墙下最后一盏灯', subtitle: '沿城门、砖缝与鼓楼追踪一盏逆风不灭的灯', mission: '城墙封门前，一盏旧灯从南门传到北门。你要判断谁在传递它，以及为什么。', summary: '灯火从来不只属于一个人。它被一双双手保护，才穿过漫长夜色。', secret: '砖缝里藏着历代守夜人的姓名。', icon: Icons.account_balance_rounded, colors: [Color(0xFF7C2D12), Color(0xFFB45309)], nodes: [
    _Node(type: '故事', title: '永宁门闭', subtitle: '城门将关，灯却向北移动', story: '暮鼓响起时，守门人看见城墙根下有一盏灯逆着人流向北。', question: '灯的移动方向有什么特别？', options: ['顺着人流', '逆着人流', '停在原地', '飞向城楼', '沉入护城河'], correct: 1, hint: '原文直接描述了方向。', explanation: '灯逆着人流向北移动。', icon: Icons.door_front_door_rounded),
    _Node(type: '生词', title: '暮鼓', subtitle: '鼓声标记城门关闭时刻', story: '古城以钟鼓报时，晨钟开城，暮鼓闭门。', question: '“暮鼓”通常与什么时间有关？', options: ['清晨', '正午', '傍晚', '午夜以后', '任何时间'], correct: 2, hint: '“暮”表示一天将晚。', explanation: '暮鼓在傍晚响起，提醒城门将闭。', icon: Icons.notifications_active_rounded),
    _Node(type: '发现', title: '砖缝里的名字', subtitle: '每隔百步就出现一个刻痕', story: '灯经过的砖缝旁，都刻着一个不同的名字。名字年代不同，笔迹也不同。', question: '这些名字最可能说明什么？', options: ['同一个人反复刻写', '历代守夜人留下记录', '游客随意涂写', '商铺招牌', '军队编号'], correct: 1, hint: '注意“年代不同”。', explanation: '不同年代的名字暗示灯火由历代守夜人接力守护。', icon: Icons.history_edu_rounded, secretClue: '最深的一道砖缝中藏着一列完整姓名。'),
    _Node(type: '挑战', title: '逆风传灯', subtitle: '判断谁是灯的主人', story: '每一段城墙都有人接过灯，再交给下一人。', question: '谁是这盏灯真正的主人？', options: ['第一个守门人', '最后一个守夜人', '所有接力守护它的人', '城墙本身', '没有人'], correct: 2, hint: '灯一直在被传递。', explanation: '灯火象征共同守护，不属于某一个人。', icon: Icons.local_fire_department_rounded),
    _Node(type: '盖章', title: '鼓楼灯影', subtitle: '最后一盏灯抵达鼓楼', story: '午夜前，灯被放在鼓楼窗前。整座城没有因此更亮，但每个守夜人都看见了它。', question: '旅程最重要的主题是什么？', options: ['占有', '共同守护', '独自胜利', '逃离古城', '寻找宝物'], correct: 1, hint: '回想接力传灯。', explanation: '共同守护让微小灯火穿过漫长时间。', icon: Icons.workspace_premium_rounded),
  ]),
  _Expedition(id: 'dali', location: '大理', title: '风把云送回了山', subtitle: '从洱海岸到苍山雪线追踪一片逆风而行的云', mission: '一片云总在黄昏离开洱海，又在清晨回到苍山。你要理解它的路线。', summary: '风不是把云吹走，而是在完成一场循环。离开与返回，本来就是同一条路。', secret: '石碑上的云纹其实是一幅古老风向图。', icon: Icons.cloud_rounded, colors: [Color(0xFF0369A1), Color(0xFF4F46E5)], nodes: [
    _Node(type: '故事', title: '洱海晚风', subtitle: '一片云逆着湖面波纹移动', story: '黄昏时，湖面波纹向东，云影却向西，像是在寻找苍山。', question: '云影与波纹的方向关系是什么？', options: ['相同', '相反', '垂直', '完全静止', '无法判断'], correct: 1, hint: '文中分别写了向东和向西。', explanation: '波纹向东，云影向西，方向相反。', icon: Icons.air_rounded),
    _Node(type: '生词', title: '风向', subtitle: '风从哪里来，而不是往哪里去', story: '当地老人提醒你：“西风，是从西边来的风。”', question: '“西风”表示什么？', options: ['吹向西边的风', '从西边吹来的风', '只在西边出现的风', '夜里的风', '山顶的风'], correct: 1, hint: '风向按来源命名。', explanation: '西风表示从西边吹来的风。', icon: Icons.explore_rounded),
    _Node(type: '发现', title: '云纹石碑', subtitle: '石碑纹路与山谷方向一致', story: '石碑上的云纹不是装饰，而是一圈圈连接湖岸与山谷的箭头。', question: '石碑最可能是什么？', options: ['装饰图案', '古老风向图', '家族徽章', '藏宝路线', '水位记录'], correct: 1, hint: '箭头连接了湖岸与山谷。', explanation: '云纹记录了当地风的循环路线。', icon: Icons.map_rounded, secretClue: '石碑最下方刻着一条几乎被苔藓盖住的回流箭头。'),
    _Node(type: '挑战', title: '山谷回流', subtitle: '判断云为何清晨回山', story: '夜间山地降温，气流沿山谷下沉；日出后，暖空气重新上升。', question: '云清晨回到山上的主要原因是什么？', options: ['云记得路线', '暖空气上升形成回流', '湖水停止流动', '山顶有人牵引', '风完全消失'], correct: 1, hint: '注意日出后的空气变化。', explanation: '日出后暖空气上升，推动水汽重新向山地聚集。', icon: Icons.science_rounded),
    _Node(type: '盖章', title: '苍山晨云', subtitle: '在雪线下看见完整循环', story: '清晨，昨天离开的云重新挂在苍山腰间。你终于明白，离开并不等于消失。', question: '旅程的核心理解是什么？', options: ['所有离开都会结束', '自然在循环中完成返回', '风只会吹散云', '山比海更重要', '天气无法理解'], correct: 1, hint: '回想云的往返路线。', explanation: '离开与返回共同组成自然循环。', icon: Icons.verified_rounded),
  ]),
  _Expedition(id: 'harbin', location: '哈尔滨', title: '雪夜里没有熄灭的星火', subtitle: '穿过中央大街、冰灯与旧车站寻找一簇微小火光', mission: '暴雪停电后，一簇火光在城市中不断出现。你要追踪它如何被传下去。', summary: '真正没有熄灭的不是火，而是人们把温暖递给陌生人的习惯。', secret: '旧火柴盒内侧写着第一位点灯人的日期。', icon: Icons.ac_unit_rounded, colors: [Color(0xFF1D4ED8), Color(0xFF4338CA)], nodes: [
    _Node(type: '故事', title: '中央大街停电', subtitle: '整条街黑下去后，一扇窗先亮了', story: '暴雪压断电线，街道陷入黑暗。面包店老板点燃一支蜡烛，放在窗边。', question: '第一束光来自哪里？', options: ['车站', '面包店窗边', '冰灯广场', '路灯', '教堂塔顶'], correct: 1, hint: '注意老板的动作。', explanation: '面包店老板把蜡烛放在窗边，成为第一束光。', icon: Icons.bakery_dining_rounded),
    _Node(type: '生词', title: '星火', subtitle: '微小却能继续传递的火光', story: '邻居说：“一支蜡烛不亮，但一条街可以借它点灯。”', question: '这里的“星火”强调什么？', options: ['火焰很大', '微小但能传播', '只在夜空出现', '危险即将发生', '冰雪正在融化'], correct: 1, hint: '注意“借它点灯”。', explanation: '星火虽小，却能点燃更多灯火。', icon: Icons.auto_awesome_rounded),
    _Node(type: '发现', title: '旧火柴盒', subtitle: '每个接过火的人都写下日期', story: '火柴盒从面包店传到车站，盒内写满了不同年份的日期。', question: '这些日期说明什么？', options: ['火柴生产批次', '温暖曾多次被传递', '商店营业时间', '列车时刻表', '天气记录'], correct: 1, hint: '日期来自不同年份。', explanation: '这簇火光不是第一次出现，而是城市长期传递温暖的习惯。', icon: Icons.inventory_2_rounded, secretClue: '火柴盒夹层里藏着最早的一行日期。'),
    _Node(type: '挑战', title: '冰灯接力', subtitle: '判断火光为何没有熄灭', story: '每个人只守火十分钟，再交给下一个人。', question: '火光能持续的真正原因是什么？', options: ['蜡烛永远烧不完', '有人不断接力守护', '暴雪突然停止', '冰灯自己发热', '风向改变'], correct: 1, hint: '谁在接过火？', explanation: '持续来自人与人之间的接力，而不是火焰本身。', icon: Icons.people_alt_rounded),
    _Node(type: '盖章', title: '旧车站星火', subtitle: '最后一簇火照亮候车室', story: '电力恢复时，人们没有立刻吹灭蜡烛，而是让它多亮了一分钟。', question: '旅程的核心主题是什么？', options: ['能源技术', '陌生人之间的温暖传递', '冬季旅游', '火焰收藏', '城市竞争'], correct: 1, hint: '回想火光如何一路来到车站。', explanation: '真正延续的是人与人之间主动传递的温暖。', icon: Icons.verified_rounded),
  ]),
];
