import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/app_state.dart';

class CoinJourneyPrototypeScreen extends StatelessWidget {
  const CoinJourneyPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) => Scaffold(
        backgroundColor: const Color(0xFF17130F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF241A13),
          foregroundColor: const Color(0xFFFFE7B0),
          title: Text(
            state.displayText('Phoenix · 钱币异境'),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: CoinJourneyGame(text: state.displayText),
        ),
      ),
    );
  }
}

class CoinJourneyGame extends StatefulWidget {
  const CoinJourneyGame({
    super.key,
    required this.text,
    this.persistRewards = true,
  });

  final String Function(String) text;
  final bool persistRewards;

  @override
  State<CoinJourneyGame> createState() => _CoinJourneyGameState();
}

class _CoinJourneyGameState extends State<CoinJourneyGame> {
  static const _rewardKey = 'phoenix.coinJourney.rewards.v1';
  static const _rareKey = 'phoenix.coinJourney.rare.v1';
  static const _wrongGrammar = '通过游览长廊，使游客可以看到不同的风景。';
  static const _correctGrammar = '通过游览长廊，游客可以看到不同的风景。';

  static const _paragraphSolution = <_Piece>[
    _Piece('overview', '颐和园长廊连接着湖边的多个景点。'),
    _Piece('walk', '游人沿着长廊前进，可以不断看到新的景色。'),
    _Piece('windows', '长廊上的廊窗形状各不相同。'),
    _Piece('borrow', '有些廊窗还把远山纳入眼前的画面。'),
  ];
  static const _paragraphChoices = <_Piece>[
    _Piece('windows', '长廊上的廊窗形状各不相同。'),
    _Piece('borrow', '有些廊窗还把远山纳入眼前的画面。'),
    _Piece('overview', '颐和园长廊连接着湖边的多个景点。'),
    _Piece('walk', '游人沿着长廊前进，可以不断看到新的景色。'),
  ];
  static const _fragmentSolution = <_Piece>[
    _Piece('time', '每走一段，'),
    _Piece('subject', '窗外的景色'),
    _Piece('result', '都会发生变化。'),
  ];
  static const _fragmentChoices = <_Piece>[
    _Piece('result', '都会发生变化。'),
    _Piece('time', '每走一段，'),
    _Piece('subject', '窗外的景色'),
  ];
  static const _nightSolution = <_Piece>[
    _Piece('knock', '子夜，一名没有影子的客人敲响客栈木门。'),
    _Piece('mirror', '掌柜点亮油灯，铜镜里却空无一人。'),
    _Piece('promise', '客人留下铜钱，请掌柜天亮前不要开门。'),
    _Piece('leaf', '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
  ];
  static const _nightChoices = <_Piece>[
    _Piece('leaf', '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
    _Piece('mirror', '掌柜点亮油灯，铜镜里却空无一人。'),
    _Piece('knock', '子夜，一名没有影子的客人敲响客栈木门。'),
    _Piece('promise', '客人留下铜钱，请掌柜天亮前不要开门。'),
  ];
  static const _challenges = <String>['短文复原', '语病修复', '补回句子'];

  final _grammarController = TextEditingController();
  final _paragraphAnswer = <_Piece>[];
  final _fragmentAnswer = <_Piece>[];
  final _nightAnswer = <_Piece>[];
  final _coins = <String, _CoinKind>{};

  _Stage _stage = _Stage.intro;
  _CoinKind? _currentCoin;
  String? _feedback;
  String? _ending;
  bool _rareCoin = false;
  bool _loading = true;
  bool _resolved = false;
  int _paragraphAttempts = 0;
  int _grammarAttempts = 0;
  int _fragmentAttempts = 0;
  int _nightAttempts = 0;

  String t(String value) => widget.text(value);

  @override
  void initState() {
    super.initState();
    _grammarController.text = t(_wrongGrammar);
    _restoreRewards();
  }

  @override
  void dispose() {
    _grammarController.dispose();
    super.dispose();
  }

  int get _points => _coins.values.fold(0, (sum, coin) => sum + coin.points);
  bool get _allGold => _challenges.every((name) => _coins[name] == _CoinKind.gold);

  Future<void> _restoreRewards() async {
    if (!widget.persistRewards) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final restored = <String, _CoinKind>{};
    for (final record in prefs.getStringList(_rewardKey) ?? const <String>[]) {
      final divider = record.lastIndexOf('|');
      if (divider < 1) continue;
      final kind = _CoinKind.parse(record.substring(divider + 1));
      if (kind != null) restored[record.substring(0, divider)] = kind;
    }
    if (!mounted) return;
    setState(() {
      _coins
        ..clear()
        ..addAll(restored);
      _rareCoin = prefs.getBool(_rareKey) ?? false;
      _loading = false;
    });
  }

  Future<void> _saveRewards() async {
    if (!widget.persistRewards) return;
    final prefs = await SharedPreferences.getInstance();
    final records = _coins.entries
        .map((entry) => '${entry.key}|${entry.value.name}')
        .toList()
      ..sort();
    await Future.wait([
      prefs.setStringList(_rewardKey, records),
      prefs.setBool(_rareKey, _rareCoin),
    ]);
  }

  _CoinKind _coinFor(int attempts) {
    if (attempts <= 1) return _CoinKind.gold;
    if (attempts == 2) return _CoinKind.silver;
    return _CoinKind.bronze;
  }

  Future<void> _award(String challenge, int attempts) async {
    final earned = _coinFor(attempts);
    final previous = _coins[challenge];
    setState(() {
      if (previous == null || earned.rank > previous.rank) {
        _coins[challenge] = earned;
      }
      _currentCoin = earned;
      _resolved = true;
      if (_allGold) _rareCoin = true;
    });
    await _saveRewards();
  }

  bool _matches(List<_Piece> answer, List<_Piece> solution) {
    if (answer.length != solution.length) return false;
    for (var index = 0; index < answer.length; index++) {
      if (answer[index].id != solution[index].id) return false;
    }
    return true;
  }

  void _choose(List<_Piece> answer, _Piece piece) {
    if (_resolved || answer.any((item) => item.id == piece.id)) return;
    setState(() {
      answer.add(piece);
      _feedback = null;
    });
  }

  void _undo(List<_Piece> answer) {
    if (_resolved || answer.isEmpty) return;
    setState(() {
      answer.removeLast();
      _feedback = null;
    });
  }

  Future<void> _checkParagraph() async {
    if (_resolved) return;
    final attempt = ++_paragraphAttempts;
    final correct = _matches(_paragraphAnswer, _paragraphSolution);
    setState(() {
      _feedback = correct
          ? '段落已经恢复。先介绍整体位置，再写游人的行动，最后补充廊窗与借景细节。'
          : '先找介绍长廊整体位置的句子，再安排游人的行动，最后放观察细节。';
      if (!correct) _paragraphAnswer.clear();
    });
    if (correct) await _award('短文复原', attempt);
  }

  String _normalize(String value) =>
      value.replaceAll(RegExp(r'[\s，。！？、；：“”‘’]'), '').trim();

  bool _grammarAccepted(String answer) {
    const accepted = <String>{
      _correctGrammar,
      '游览长廊时，游客可以看到不同的风景。',
      '游客通过游览长廊，可以看到不同的风景。',
      '游客游览长廊时，可以看到不同的风景。',
    };
    final normalized = _normalize(answer);
    return accepted.expand((item) => <String>{item, t(item)}).any(
          (item) => _normalize(item) == normalized,
        );
  }

  Future<void> _checkGrammar() async {
    if (_resolved) return;
    final attempt = ++_grammarAttempts;
    final answer = _grammarController.text.trim();
    final correct = _grammarAccepted(answer);
    setState(() {
      if (correct) {
        _feedback = null;
      } else if (_normalize(answer).contains(_normalize('通过游览长廊使'))) {
        _feedback = '“通过……”和“使……”仍然同时存在，句子还是没有明确主语。';
      } else {
        _feedback = '请让“游客”成为明确主语，并保留“看到不同风景”的原意。';
      }
    });
    if (correct) await _award('语病修复', attempt);
  }

  Future<void> _checkFragments() async {
    if (_resolved) return;
    final attempt = ++_fragmentAttempts;
    final correct = _matches(_fragmentAnswer, _fragmentSolution);
    setState(() {
      _feedback = correct
          ? '“每走一段”承接移动，“都会发生变化”说明反复出现的结果。'
          : '先说时间或条件，再说变化的对象，最后说明结果。';
      if (!correct) _fragmentAnswer.clear();
    });
    if (correct) await _award('补回句子', attempt);
  }

  void _go(_Stage next) {
    setState(() {
      _stage = next;
      _resolved = false;
      _currentCoin = null;
      _feedback = null;
      if (next == _Stage.grammar) _grammarController.text = t(_wrongGrammar);
    });
  }

  void _checkNight() {
    final correct = _matches(_nightAnswer, _nightSolution);
    setState(() {
      _nightAttempts += 1;
      if (correct) {
        _stage = _Stage.specialDecision;
        _feedback = null;
      } else {
        _feedback = '敲门应最早发生，鸡鸣和枯叶属于天亮后的结果。';
        _nightAnswer.clear();
      }
    });
  }

  void _returnToCollection() {
    setState(() {
      _stage = _Stage.intro;
      _ending = null;
      _feedback = null;
      _currentCoin = null;
      _resolved = false;
      _paragraphAnswer.clear();
      _fragmentAnswer.clear();
      _nightAnswer.clear();
      _paragraphAttempts = 0;
      _grammarAttempts = 0;
      _fragmentAttempts = 0;
      _nightAttempts = 0;
      _grammarController.text = t(_wrongGrammar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: switch (_stage) {
        _Stage.intro => _intro(),
        _Stage.paragraph => _paragraph(),
        _Stage.grammar => _grammar(),
        _Stage.fragments => _fragments(),
        _Stage.summary => _summary(),
        _Stage.specialIntro => _specialIntro(),
        _Stage.specialOrder => _specialOrder(),
        _Stage.specialDecision => _specialDecision(),
        _Stage.specialEnding => _specialEnding(),
      },
    );
  }

  Widget _page(Key key, List<Widget> children) {
    return Container(
      key: key,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF17130F), Color(0xFF2A1D16)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _title(String value, {bool pale = false}) => Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: pale ? const Color(0xFFE7E9FF) : const Color(0xFFFFE8B6),
          fontSize: 25,
          height: 1.25,
          fontWeight: FontWeight.w900,
        ),
      );

  Widget _body(String value, {bool centered = false}) => Text(
        value,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12.5,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _primary({
    Key? key,
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        key: key,
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFB94635),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _intro() {
    final unlocked = _points >= 3;
    return _page(const ValueKey('coin-journey-intro'), [
      const Icon(Icons.monetization_on_rounded, size: 68, color: Color(0xFFFFD166)),
      const SizedBox(height: 9),
      _title(t('学习闯关 · 钱币收藏 · 异境解锁')),
      const SizedBox(height: 8),
      _body(
        t('完成中文挑战，根据答对次数获得金币、银币或铜币。收集旅程值，就能打开神话与志怪世界。'),
        centered: true,
      ),
      const SizedBox(height: 14),
      if (_loading)
        const Center(child: CircularProgressIndicator())
      else
        _collectionStatus(),
      const SizedBox(height: 13),
      _rewardRules(),
      const SizedBox(height: 13),
      _journeyCard(
        title: t('普通挑战：颐和园'),
        subtitle: t('短文复原、语病修复、补回句子'),
        icon: Icons.account_balance_rounded,
      ),
      const SizedBox(height: 9),
      _journeyCard(
        title: t('隐藏旅程：聊斋夜客'),
        subtitle: unlocked ? t('已经解锁，可以直接进入') : t('收集至少 3 点旅程值'),
        icon: Icons.nightlight_round,
        locked: !unlocked,
      ),
      const SizedBox(height: 16),
      _primary(
        key: const ValueKey('coin-start-challenges'),
        label: t('开始三关挑战'),
        icon: Icons.play_arrow_rounded,
        onPressed: _loading ? null : () => _go(_Stage.paragraph),
      ),
      if (unlocked) ...[
        const SizedBox(height: 9),
        OutlinedButton.icon(
          key: const ValueKey('enter-persisted-special'),
          onPressed: () => _go(_Stage.specialIntro),
          icon: const Icon(Icons.lock_open_rounded),
          label: Text(t('进入已解锁的聊斋夜客')),
        ),
      ],
    ]);
  }

  Widget _challengeHeader(String step, String title, String instruction, int attempts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(step, style: const TextStyle(color: Color(0xFFFFC86B), fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(title, style: const TextStyle(color: Color(0xFFFFE8B6), fontSize: 25, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        _body(instruction),
        if (attempts > 0 && !_resolved) ...[
          const SizedBox(height: 4),
          Text(t('已尝试 $attempts 次'), style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ],
    );
  }

  Widget _paragraph() => _page(const ValueKey('coin-paragraph-challenge'), [
        _challengeHeader(t('第 1 关 / 3'), t('短文复原'), t('按照合理顺序点击句子，把它们拼回一段完整短文。'), _paragraphAttempts),
        const SizedBox(height: 13),
        _answerBox(_paragraphAnswer, t('依次点击下方句子')),
        const SizedBox(height: 11),
        _choices(_paragraphChoices, _paragraphAnswer, 'paragraph-choice', (piece) => _choose(_paragraphAnswer, piece)),
        const SizedBox(height: 8),
        _undoButton(_paragraphAnswer, () => _undo(_paragraphAnswer)),
        if (!_resolved) ...[
          const SizedBox(height: 9),
          _primary(label: t('提交答案'), icon: Icons.check_circle_rounded, onPressed: _checkParagraph),
        ],
        ..._resultWidgets(
          explanation: t('正确逻辑是“整体位置 → 游人行动 → 廊窗细节 → 借景效果”。读者先知道长廊在哪里，再跟随游人移动。'),
          continueLabel: t('进入语病修复'),
          onContinue: () => _go(_Stage.grammar),
        ),
      ]);

  Widget _grammar() => _page(const ValueKey('coin-grammar-challenge'), [
        _challengeHeader(t('第 2 关 / 3'), t('找出并修改语病'), t('直接编辑病句。改对后会说明病句类型、错误原因、修改原则和记忆方法。'), _grammarAttempts),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF5A2420), borderRadius: BorderRadius.circular(14)),
          child: Text(t('病句：$_wrongGrammar'), style: const TextStyle(color: Color(0xFFFFD7C9), height: 1.45, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey('grammar-input'),
          controller: _grammarController,
          enabled: !_resolved,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: t('修改后的句子'),
            filled: true,
            fillColor: const Color(0xFFF7ECD5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        if (!_resolved) ...[
          const SizedBox(height: 9),
          _primary(label: t('提交答案'), icon: Icons.check_circle_rounded, onPressed: _checkGrammar),
        ],
        if (_resolved) ...[
          const SizedBox(height: 11),
          _grammarExplanation(),
        ],
        ..._resultWidgets(
          continueLabel: t('进入补句挑战'),
          onContinue: () => _go(_Stage.fragments),
        ),
      ]);

  Widget _fragments() => _page(const ValueKey('coin-fragment-challenge'), [
        _challengeHeader(t('第 3 关 / 3'), t('补回失落句子'), t('碎片已经被打乱。按照正确语序点击，补回能够连接前后文的句子。'), _fragmentAttempts),
        const SizedBox(height: 13),
        Text(t('游客沿着长廊慢慢前进。'), style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 7),
        _answerBox(_fragmentAnswer, t('依次点击下方句子碎片'), inline: true, key: const ValueKey('fragment-answer')),
        const SizedBox(height: 7),
        Text(t('因此，长廊不仅是通道，也是一条不断变化的观景路线。'), style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 11),
        _choices(_fragmentChoices, _fragmentAnswer, 'fragment-choice', (piece) => _choose(_fragmentAnswer, piece), positionKeys: true),
        const SizedBox(height: 8),
        _undoButton(_fragmentAnswer, () => _undo(_fragmentAnswer)),
        if (!_resolved) ...[
          const SizedBox(height: 9),
          _primary(label: t('提交答案'), icon: Icons.check_circle_rounded, onPressed: _checkFragments),
        ],
        ..._resultWidgets(
          explanation: t('完整句子是：“每走一段，窗外的景色都会发生变化。”它承接“沿着长廊前进”，也解释为什么观景路线不断变化。'),
          continueLabel: t('查看钱币与异境'),
          onContinue: () => _go(_Stage.summary),
        ),
      ]);

  List<Widget> _resultWidgets({String? explanation, required String continueLabel, required VoidCallback onContinue}) {
    return [
      if (_feedback != null) ...[
        const SizedBox(height: 9),
        _feedbackCard(t(_feedback!), _resolved),
      ],
      if (_currentCoin != null) ...[
        const SizedBox(height: 9),
        _coinReward(_currentCoin!),
      ],
      if (_resolved && explanation != null) ...[
        const SizedBox(height: 9),
        _learningCard(explanation),
      ],
      if (_resolved) ...[
        const SizedBox(height: 11),
        _primary(label: continueLabel, icon: Icons.arrow_forward_rounded, onPressed: onContinue),
      ],
    ];
  }

  Widget _answerBox(List<_Piece> pieces, String placeholder, {bool inline = false, Key? key, bool dark = false}) {
    final value = pieces.isEmpty
        ? placeholder
        : inline
            ? pieces.map((piece) => t(piece.text)).join()
            : pieces.asMap().entries.map((entry) => '${entry.key + 1}. ${t(entry.value.text)}').join('\n');
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF25213A) : const Color(0xFFF4E5C6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: dark ? const Color(0xFF57527B) : const Color(0xFFD2AA69)),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: pieces.isEmpty
              ? (dark ? Colors.white38 : const Color(0xFF9A8068))
              : (dark ? const Color(0xFFE5E2F5) : const Color(0xFF34291F)),
          height: 1.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _choices(
    List<_Piece> choices,
    List<_Piece> selected,
    String prefix,
    ValueChanged<_Piece> onSelected, {
    bool dark = false,
    bool positionKeys = false,
  }) {
    return Column(
      children: [
        for (var index = 0; index < choices.length; index++) ...[
          KeyedSubtree(
            key: positionKeys ? ValueKey('$prefix-position-$index') : null,
            child: Material(
              key: ValueKey('$prefix-${choices[index].id}'),
              color: dark ? const Color(0xFF2A263D) : const Color(0xFFF4E5C6),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: selected.any((item) => item.id == choices[index].id)
                    ? null
                    : () => onSelected(choices[index]),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        selected.any((item) => item.id == choices[index].id)
                            ? Icons.check_circle_rounded
                            : Icons.add_circle_outline,
                        color: dark ? const Color(0xFFCCC7F5) : const Color(0xFF9C3A30),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          t(choices[index].text),
                          style: TextStyle(
                            color: dark ? const Color(0xFFE5E2F5) : const Color(0xFF34291F),
                            height: 1.4,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (index != choices.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _undoButton(List<_Piece> answer, VoidCallback action) => OutlinedButton.icon(
        onPressed: _resolved || answer.isEmpty ? null : action,
        icon: const Icon(Icons.undo_rounded),
        label: Text(t('撤回最后一个')),
      );

  Widget _grammarExplanation() => Container(
        key: const ValueKey('grammar-explanation'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F0DF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF9EB98A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('为什么这样改？'), style: const TextStyle(color: Color(0xFF315B32), fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 9),
            _explanationLine(t('病句类型'), t('成分残缺：主语缺失')),
            _explanationLine(t('原句'), t(_wrongGrammar)),
            _explanationLine(t('修改后'), _grammarController.text.trim()),
            _explanationLine(t('错误原因'), t('“通过……”把“游览长廊”变成介词结构；“使……”又引出结果。两个结构叠在一起后，整句话没有明确主语。')),
            _explanationLine(t('修改原则'), t('删除“使”，让“游客”直接成为主语。也可以把开头改成“游览长廊时”。')),
            _explanationLine(t('记忆方法'), t('看到“通过……使……”时，要检查句子里是否还剩下明确主语。')),
          ],
        ),
      );

  Widget _explanationLine(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF537A4F), fontSize: 11, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Color(0xFF263B27), height: 1.45, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _feedbackCard(String text, bool positive) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: positive ? const Color(0xFF284235) : const Color(0xFF5D2924),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(positive ? Icons.check_circle_rounded : Icons.lightbulb_rounded, color: positive ? const Color(0xFFB8E1C1) : const Color(0xFFFFCF9C)),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.w700))),
          ],
        ),
      );

  Widget _learningCard(String text) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF253B31), borderRadius: BorderRadius.circular(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.school_rounded, color: Color(0xFFAED8B9)),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFDFF3E4), height: 1.5, fontWeight: FontWeight.w700))),
          ],
        ),
      );

  Widget _rewardRules() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF1DFB8), borderRadius: BorderRadius.circular(17)),
        child: Column(
          children: [
            _rule(_CoinKind.gold),
            const Divider(height: 18),
            _rule(_CoinKind.silver),
            const Divider(height: 18),
            _rule(_CoinKind.bronze),
          ],
        ),
      );

  Widget _rule(_CoinKind coin) => Row(
        children: [
          _coinDisc(coin, 31),
          const SizedBox(width: 10),
          Expanded(child: Text(t('${coin.reason} · ${coin.points} 点'), style: const TextStyle(color: Color(0xFF4E3C2D), fontWeight: FontWeight.w800))),
        ],
      );

  Widget _coinDisc(_CoinKind coin, double size) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: coin.color,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF7E5A26), width: 2),
        ),
        child: Text(t(coin.mark), style: const TextStyle(color: Color(0xFF5F3A17), fontWeight: FontWeight.w900)),
      );

  Widget _coinReward(_CoinKind coin) => Container(
        key: ValueKey('coin-reward-${coin.name}'),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF3B2B1E), borderRadius: BorderRadius.circular(15), border: Border.all(color: coin.color)),
        child: Row(
          children: [
            _coinDisc(coin, 47),
            const SizedBox(width: 11),
            Expanded(child: Text(t('获得${coin.label}\n${coin.reason} · ${coin.points} 点旅程值'), style: TextStyle(color: coin.color, height: 1.4, fontWeight: FontWeight.w900))),
          ],
        ),
      );

  Widget _collectionStatus() => Container(
        key: const ValueKey('coin-collection-status'),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFF1DFB8), borderRadius: BorderRadius.circular(16)),
        child: Text(
          t('已收藏 ${_coins.length + (_rareCoin ? 1 : 0)} 枚钱币 · $_points 点旅程值'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF6F2925), fontSize: 16, fontWeight: FontWeight.w900),
        ),
      );

  Widget _journeyCard({required String title, required String subtitle, required IconData icon, bool locked = false}) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: locked ? const Color(0xFF28233A) : const Color(0xFF34261D), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: locked ? const Color(0xFFC8C3F0) : const Color(0xFFFFD166)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600)),
            ])),
            if (locked) const Icon(Icons.lock_rounded, color: Colors.white38),
          ],
        ),
      );

  Widget _summary() => _page(const ValueKey('coin-summary'), [
        const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD166), size: 60),
        const SizedBox(height: 8),
        _title(t('颐和园挑战完成')),
        const SizedBox(height: 6),
        _body(t('系统保留每一关取得过的最高品质钱币。再次练习不会把金币降成银币或铜币。'), centered: true),
        const SizedBox(height: 13),
        for (final challenge in _challenges)
          if (_coins[challenge] case final coin?) ...[
            _coinTile(t(challenge), coin),
            const SizedBox(height: 8),
          ],
        if (_rareCoin) ...[
          const SizedBox(height: 3),
          _rareCoinCard(),
        ],
        const SizedBox(height: 13),
        _collectionStatus(),
        const SizedBox(height: 13),
        _unlockCard(),
      ]);

  Widget _coinTile(String challenge, _CoinKind coin) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF34261D), borderRadius: BorderRadius.circular(15)),
        child: Row(children: [
          _coinDisc(coin, 42),
          const SizedBox(width: 10),
          Expanded(child: Text('$challenge\n${t('${coin.label} · ${coin.points} 点 · ${coin.reason}')}', style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.w800))),
        ]),
      );

  Widget _rareCoinCard() => Container(
        key: const ValueKey('rare-rui-silver-coin'),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFE8E9F4), Color(0xFFAEBAD0)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(t('额外获得：瑞银币\n三关全部第一次答对的稀有收藏币'), style: const TextStyle(color: Color(0xFF30384F), height: 1.4, fontWeight: FontWeight.w900)),
      );

  Widget _unlockCard() => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFF25213A), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF57527B))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t('异境录 · 聊斋夜客\n解锁需要 3 点 · 当前 $_points 点'), style: const TextStyle(color: Color(0xFFE9E7FF), height: 1.45, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          FilledButton.icon(
            key: const ValueKey('unlock-special-journey'),
            onPressed: _points >= 3 ? () => _go(_Stage.specialIntro) : null,
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6E5CA5), foregroundColor: Colors.white),
            icon: const Icon(Icons.lock_open_rounded),
            label: Text(t('用旅程值进入')),
          ),
        ]),
      );

  Widget _specialIntro() => _page(const ValueKey('special-journey-intro'), [
        const Icon(Icons.nightlight_round, color: Color(0xFFB9C7FF), size: 64),
        const SizedBox(height: 8),
        _title(t('异境录 · 聊斋夜客'), pale: true),
        const SizedBox(height: 10),
        _nightStory(t('子夜，一名没有影子的旅客走进湖边客栈。他把一枚湿漉漉的铜钱放在柜台上，只说：“天亮前，别让镜子照见我。”第二天，掌柜留下的夜记却被风吹乱了。')),
        const SizedBox(height: 13),
        _body(t('这不是普通景点介绍。你要拼回一段志怪夜记，并决定掌柜是否守住承诺。'), centered: true),
        const SizedBox(height: 16),
        _primary(key: const ValueKey('special-start'), label: t('进入午夜客栈'), icon: Icons.door_front_door_rounded, onPressed: () => _go(_Stage.specialOrder)),
      ]);

  Widget _specialOrder() => _page(const ValueKey('special-order-challenge'), [
        _title(t('拼回失落的夜记'), pale: true),
        const SizedBox(height: 6),
        _body(t('按照发生顺序点击四段记录。')),
        const SizedBox(height: 12),
        _answerBox(_nightAnswer, t('依次点击下方夜记'), dark: true, key: const ValueKey('night-answer')),
        const SizedBox(height: 11),
        _choices(_nightChoices, _nightAnswer, 'night-choice', (piece) => _choose(_nightAnswer, piece), dark: true),
        const SizedBox(height: 8),
        _undoButton(_nightAnswer, () => _undo(_nightAnswer)),
        if (_feedback != null) ...[
          const SizedBox(height: 9),
          _feedbackCard(t(_feedback!), false),
        ],
        const SizedBox(height: 10),
        _primary(key: const ValueKey('night-submit'), label: t('检查夜记'), icon: Icons.menu_book_rounded, onPressed: _checkNight),
      ]);

  Widget _specialDecision() => _page(const ValueKey('special-decision'), [
        const Icon(Icons.door_front_door_rounded, color: Color(0xFFCEC8FF), size: 62),
        const SizedBox(height: 8),
        _title(t('鸡鸣之前，门外响起第三次敲门声'), pale: true),
        const SizedBox(height: 8),
        _body(t('夜客要求掌柜不要开门，可是门缝下正慢慢渗进一串湿脚印。'), centered: true),
        const SizedBox(height: 17),
        _decision(key: const ValueKey('special-choice-keep'), icon: Icons.lock_rounded, title: t('守住承诺，不开门'), subtitle: t('相信夜客留下的警告'), ending: 'keep'),
        const SizedBox(height: 10),
        _decision(key: const ValueKey('special-choice-chase'), icon: Icons.directions_run_rounded, title: t('推门追出去'), subtitle: t('看看脚印究竟通向哪里'), ending: 'chase'),
      ]);

  Widget _decision({required Key key, required IconData icon, required String title, required String subtitle, required String ending}) => Material(
        key: key,
        color: const Color(0xFF29253D),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => setState(() {
            _ending = ending;
            _stage = _Stage.specialEnding;
          }),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Icon(icon, color: const Color(0xFFCFCAFF), size: 32),
              const SizedBox(width: 11),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Color(0xFFE9E7FF), fontWeight: FontWeight.w900)),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
              ])),
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ]),
          ),
        ),
      );

  Widget _specialEnding() {
    final kept = _ending == 'keep';
    return _page(const ValueKey('special-ending'), [
      Icon(kept ? Icons.local_activity_rounded : Icons.directions_walk_rounded, color: const Color(0xFFCFCAFF), size: 68),
      const SizedBox(height: 9),
      _title(t(kept ? '结局：灯票守夜人' : '结局：墙中脚印'), pale: true),
      const SizedBox(height: 10),
      _nightStory(t(kept
          ? '掌柜整夜没有开门。天亮后，铜钱化成一张黑底银字的灯票，背面写着：“月末子时，鬼市只为守信之人开门。”'
          : '掌柜推门追出，只见湿脚印一路延伸到客栈外墙，然后笔直地走进砖缝。墙内传来一句很轻的声音：“你不该替镜子开门。”')),
      const SizedBox(height: 13),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFE5DFC7), borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(t('异境收藏品'), style: const TextStyle(color: Color(0xFF6C2E2A), fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(t(kept ? '鬼市灯票' : '墙缝湿印拓片'), style: const TextStyle(color: Color(0xFF2F281F), fontSize: 19, fontWeight: FontWeight.w900)),
        ]),
      ),
      const SizedBox(height: 15),
      _primary(key: const ValueKey('coin-prototype-restart'), label: t('返回钱币收藏'), icon: Icons.replay_rounded, onPressed: _returnToCollection),
    ]);
  }

  Widget _nightStory(String text) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF25213A), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF57527B))),
        child: Text(text, style: const TextStyle(color: Color(0xFFE4E1F6), fontSize: 14, height: 1.65, fontWeight: FontWeight.w700)),
      );
}

enum _Stage { intro, paragraph, grammar, fragments, summary, specialIntro, specialOrder, specialDecision, specialEnding }

enum _CoinKind {
  bronze,
  silver,
  gold;

  static _CoinKind? parse(String value) {
    for (final kind in values) {
      if (kind.name == value) return kind;
    }
    return null;
  }

  int get rank => index + 1;
  int get points => switch (this) { bronze => 1, silver => 2, gold => 3 };
  String get label => switch (this) { bronze => '铜币', silver => '银币', gold => '金币' };
  String get mark => switch (this) { bronze => '铜', silver => '银', gold => '金' };
  String get reason => switch (this) {
        bronze => '第三次或练习后答对',
        silver => '第二次答对',
        gold => '第一次答对',
      };
  Color get color => switch (this) {
        bronze => const Color(0xFFC8834A),
        silver => const Color(0xFFD7DCE5),
        gold => const Color(0xFFFFD166),
      };
}

class _Piece {
  const _Piece(this.id, this.text);
  final String id;
  final String text;
}
