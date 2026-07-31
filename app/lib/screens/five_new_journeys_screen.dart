import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class FiveNewJourneysScreen extends StatefulWidget {
  const FiveNewJourneysScreen({super.key});

  @override
  State<FiveNewJourneysScreen> createState() => _FiveNewJourneysScreenState();
}

class _FiveNewJourneysScreenState extends State<FiveNewJourneysScreen> {
  static const _key = 'phoenix.fiveNewJourneys.completed.v1';
  Set<String> completed = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      completed = (prefs.getStringList(_key) ?? const <String>[]).toSet();
      loading = false;
    });
  }

  Future<void> _open(JourneyData journey) async {
    final done = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => JourneyFlow(journey: journey)),
    );
    if (done != true) return;
    final next = {...completed, journey.id};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList()..sort());
    if (mounted) setState(() => completed = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('Phoenix · 万里风华'), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4A1D1F), Color(0xFFB36A35)]),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('第三卷 · 万里风华', style: TextStyle(color: Color(0xFFFFD879), fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('从草原星河，走到江南雨巷', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Text('5 个新旅程，已完成 ${completed.length} / 5。', style: const TextStyle(color: Colors.white70)),
                  ]),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < journeys.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      tileColor: Colors.white.withValues(alpha: .9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      leading: CircleAvatar(
                        backgroundColor: journeys[i].color,
                        child: Icon(journeys[i].icon, color: Colors.white),
                      ),
                      title: Text(journeys[i].title, style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text('${journeys[i].location} · ${journeys[i].subtitle}'),
                      trailing: Icon(completed.contains(journeys[i].id) ? Icons.verified_rounded : Icons.chevron_right_rounded),
                      onTap: () => _open(journeys[i]),
                    ),
                  ),
              ],
            ),
    );
  }
}

class JourneyFlow extends StatefulWidget {
  const JourneyFlow({super.key, required this.journey});
  final JourneyData journey;

  @override
  State<JourneyFlow> createState() => _JourneyFlowState();
}

class _JourneyFlowState extends State<JourneyFlow> {
  int step = 0;
  int attempts = 0;
  int? answer;
  int? impression;
  bool resolved = false;
  String? feedback;

  void next() {
    if (step == 5) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => step++);
  }

  void check() {
    if (answer == null || resolved) return;
    final nextAttempt = attempts + 1;
    final correct = answer == widget.journey.correct;
    setState(() {
      attempts = nextAttempt;
      if (correct || nextAttempt >= 3) {
        resolved = true;
        answer = widget.journey.correct;
        feedback = correct ? widget.journey.explanation : '正确答案已标出。${widget.journey.explanation}';
      } else {
        answer = null;
        feedback = widget.journey.hint;
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
          child: Row(children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(child: Column(children: [
                CircleAvatar(radius: 11, backgroundColor: i <= step ? PhoenixTheme.red : Colors.black12, child: Text('${i + 1}', style: const TextStyle(fontSize: 9, color: Colors.white))),
                Text(labels[i], style: const TextStyle(fontSize: 9)),
              ])),
          ]),
        ),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: _content())),
      ]),
    );
  }

  Widget _content() {
    final j = widget.journey;
    if (step == 0) return card('故事', j.story, '进入生词');
    if (step == 1) return card('生词', j.words.map((w) => '${w.word} · ${w.part} · ${w.english}\n${w.meaning}').join('\n\n'), '继续发现');
    if (step == 2) return card(j.discoveryTitle, '${j.discovery}\n\n隐藏发现：${j.hidden}', '接受挑战');
    if (step == 3) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('挑战', style: TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(j.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (var i = 0; i < j.options.length; i++)
            RadioListTile<int>(value: i, groupValue: answer, onChanged: resolved ? null : (v) => setState(() => answer = v), title: Text(j.options[i])),
          if (feedback != null) Text(feedback!, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          FilledButton(onPressed: resolved ? next : (answer == null ? null : check), child: Text(resolved ? '留下印象' : '提交答案 · 第 ${attempts + 1} 次')),
        ]),
      );
    }
    if (step == 4) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('留下印象', style: TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (var i = 0; i < j.impressions.length; i++)
            ChoiceChip(label: SizedBox(width: double.infinity, child: Text(j.impressions[i])), selected: impression == i, onSelected: (_) => setState(() => impression = i)),
          const SizedBox(height: 14),
          FilledButton(onPressed: impression == null ? null : next, child: const Text('去盖章')),
        ]),
      );
    }
    final reward = attempts <= 1 ? '金币' : attempts == 2 ? '银币' : '铜币';
    return card(j.stamp, '获得 $reward\n\n${j.finalMessage}', '收进护照');
  }

  Widget card(String title, String text, String button) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Text(text, style: const TextStyle(fontSize: 16, height: 1.75)),
          const SizedBox(height: 20),
          FilledButton(onPressed: next, child: Text(button)),
        ]),
      );
}

class WordData {
  const WordData(this.word, this.part, this.english, this.meaning);
  final String word;
  final String part;
  final String english;
  final String meaning;
}

class JourneyData {
  const JourneyData({required this.id, required this.location, required this.title, required this.subtitle, required this.icon, required this.color, required this.story, required this.words, required this.discoveryTitle, required this.discovery, required this.hidden, required this.question, required this.options, required this.correct, required this.hint, required this.explanation, required this.impressions, required this.stamp, required this.finalMessage});
  final String id, location, title, subtitle, story, discoveryTitle, discovery, hidden, question, hint, explanation, stamp, finalMessage;
  final IconData icon;
  final Color color;
  final List<WordData> words;
  final List<String> options, impressions;
  final int correct;
}

const journeys = <JourneyData>[
  JourneyData(id: 'hohhot-star-song', location: '呼和浩特', title: '草原星河里的长调', subtitle: '循着歌声寻找迷路的小马', icon: Icons.nightlight_round, color: Color(0xFF356859), story: '夜幕落在草原上，少年苏和发现一匹小马没有回圈。他没有急着追赶，而是站在风口唱起祖母教他的长调。悠长的歌声越过低坡，远处传来马铃回应。苏和顺着声音找到小马，也明白长调不只是歌，更是人与草原彼此辨认的方式。', words: [WordData('长调', '名词', 'long song', '蒙古族传统民歌形式'), WordData('马铃', '名词', 'horse bell', '系在马身上的铃铛'), WordData('回应', '动词', 'respond', '对声音或行动作出反应')], discoveryTitle: '声音如何成为草原坐标', discovery: '开阔草原缺少高大遮挡，声音可以传播很远。牧民会结合风向、地形、牲畜铃声和经验判断位置。', hidden: '长调旋律舒展，常与草原空间感和游牧生活经验相连。', question: '苏和为什么唱起长调？', options: ['为了参加比赛', '为了让小马听见熟悉的声音', '为了驱赶所有马群', '为了提醒天快亮了'], correct: 1, hint: '注意远处传来的马铃回应。', explanation: '熟悉的歌声成为寻找与回应的信号。', impressions: ['声音也能成为方向。', '传统来自真实生活。', '人与动物会建立共同记忆。'], stamp: '呼和浩特 · 星河长调章', finalMessage: '风把歌声送远，也把归路带回。'),
  JourneyData(id: 'suzhou-rain-window', location: '苏州', title: '雨巷尽头的花窗', subtitle: '在园林曲径中寻找一扇失落的窗样', icon: Icons.grid_view_rounded, color: Color(0xFF3C7A89), story: '细雨落在园林石径上，学徒阿绫带着一张残缺花窗图寻找原型。她绕过假山和回廊，发现每一扇窗都把远处景物裁成不同画面。最后，她在一堵不起眼的白墙上找到相同纹样。师傅说，花窗不是墙上的装饰，而是教人换一个角度看世界。', words: [WordData('花窗', '名词', 'decorative lattice window', '带有图案的窗格'), WordData('回廊', '名词', 'covered corridor', '有顶的长廊'), WordData('取景', '动词', 'frame a view', '选择并组织眼前景物')], discoveryTitle: '园林为什么处处讲究“框景”', discovery: '园林会利用门洞、花窗、廊架和植物，把景物组织成层层变化的画面。人在行走中不断获得新的观看关系。', hidden: '同一座山石从不同花窗看，会产生完全不同的空间感。', question: '师傅认为花窗最重要的作用是什么？', options: ['遮住所有景物', '帮助人换角度观看', '让房间完全黑暗', '显示窗户价格'], correct: 1, hint: '结合“裁成不同画面”判断。', explanation: '花窗通过框景改变观看方式。', impressions: ['角度会改变理解。', '空间也能讲故事。', '美常藏在行走的过程里。'], stamp: '苏州 · 雨巷花窗章', finalMessage: '一扇小窗，打开了许多种世界。'),
  JourneyData(id: 'harbin-ice-letter', location: '哈尔滨', title: '冰城灯影里的冬日信', subtitle: '守护一封即将融化的冰信', icon: Icons.ac_unit_rounded, color: Color(0xFF2563A7), story: '冬夜里，小满在冰灯展旁发现一块刻着文字的薄冰。天气转暖，字迹正在变浅。她没有把冰带进屋，而是抄下文字，又拍下每一道裂纹。第二天冰信融化了，但那句“春天到了也别忘记冬夜的光”被保存下来。', words: [WordData('冰灯', '名词', 'ice lantern', '用冰制成并置入光源的灯饰'), WordData('裂纹', '名词', 'crack', '物体表面的细小开裂'), WordData('保存', '动词', 'preserve', '使内容继续保留')], discoveryTitle: '短暂的冰为什么值得记录', discovery: '冰雪艺术受温度影响，会自然变化甚至消失。记录尺寸、纹理、光线和过程，是保存短暂艺术经验的重要方式。', hidden: '冰的透明度和气泡会影响灯光呈现。', question: '小满为什么不把冰信带进屋？', options: ['屋里没有桌子', '温暖会让冰更快融化', '她不喜欢那句话', '冰灯只能放在白天'], correct: 1, hint: '注意天气转暖和“融化”。', explanation: '她选择记录而不是加速冰的消失。', impressions: ['短暂并不等于不重要。', '记录也是一种守护。', '消失的东西仍能留下意义。'], stamp: '哈尔滨 · 冬光冰信章', finalMessage: '冰会融化，认真看过的光不会。'),
  JourneyData(id: 'kunming-flower-clock', location: '昆明', title: '花市清晨的季节钟', subtitle: '从一束花读懂城市的时间', icon: Icons.local_florist_rounded, color: Color(0xFF4F8A5B), story: '天刚亮，阿禾跟着外婆走进花市。外婆只看花瓣湿度、叶片方向和摊位位置，就知道昨夜下过小雨。她说花市每天都不一样，花期、温度和运输路线共同决定今天会出现什么。阿禾第一次发现，季节不只写在日历上，也写在一束花里。', words: [WordData('花期', '名词', 'flowering season', '植物开花的时期'), WordData('湿度', '名词', 'humidity', '空气或物体含水程度'), WordData('运输', '动词', 'transport', '把物品从一处运到另一处')], discoveryTitle: '花市如何记录季节变化', discovery: '花卉种类、开放程度和价格会受到气候、产地和物流影响。长期观察花市，可以看见自然与城市供应系统的共同变化。', hidden: '同一种花在不同海拔和温度条件下，花期可能不同。', question: '外婆如何判断昨夜下过雨？', options: ['只看手机天气', '观察花瓣和叶片状态', '询问所有顾客', '计算摊位数量'], correct: 1, hint: '故事直接列出了她观察的细节。', explanation: '她依靠长期积累的现场观察。', impressions: ['季节藏在细节里。', '经验来自持续观察。', '城市生活也与自然相连。'], stamp: '昆明 · 花市季节章', finalMessage: '日历翻页无声，花朵却把时间开给你看。'),
  JourneyData(id: 'wuhan-river-whistle', location: '武汉', title: '江汉关前的汽笛回声', subtitle: '沿着两江寻找一段旧时声音', icon: Icons.directions_boat_rounded, color: Color(0xFF7B3F61), story: '傍晚，江边传来一声低沉汽笛。小川想起祖父说过，过去船工会用不同长短的笛声传递信息。他沿江寻找声音来源，最后发现是一艘修复后的老轮船在试航。老船长让他听第二声：“声音会变，但城市记住了它从哪里来。”', words: [WordData('汽笛', '名词', 'steam whistle', '船舶发出的响亮信号'), WordData('试航', '动词', 'trial voyage', '正式使用前进行航行测试'), WordData('传递', '动词', 'transmit', '把信息送到另一处')], discoveryTitle: '江河城市为什么有自己的声音地图', discovery: '码头、轮船、桥梁和市场共同塑造江河城市的声景。汽笛曾承担警示、联络和识别功能，也成为城市记忆的一部分。', hidden: '不同水域和天气会影响声音传播距离。', question: '老船长的话表达了什么？', options: ['旧声音毫无价值', '城市会保留声音背后的历史记忆', '所有船都必须使用同一种汽笛', '试航只为了吸引游客'], correct: 1, hint: '注意“城市记住了它从哪里来”。', explanation: '声音变化了，但它承载的历史来源仍被记住。', impressions: ['城市也有自己的声音档案。', '交通工具会塑造地方记忆。', '历史常藏在日常听觉里。'], stamp: '武汉 · 两江汽笛章', finalMessage: '一声汽笛越过江面，也越过许多年的时间。'),
];