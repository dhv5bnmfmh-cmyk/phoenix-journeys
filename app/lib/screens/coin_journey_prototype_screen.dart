import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class CoinJourneyPrototypeScreen extends StatelessWidget {
  const CoinJourneyPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
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
        );
      },
    );
  }
}

class CoinJourneyGame extends StatefulWidget {
  const CoinJourneyGame({super.key, required this.text});

  final String Function(String) text;

  @override
  State<CoinJourneyGame> createState() => _CoinJourneyGameState();
}

class _CoinJourneyGameState extends State<CoinJourneyGame> {
  static const _wrongGrammar = '通过游览长廊，使游客可以看到不同的风景。';
  static const _grammarModel = '通过游览长廊，游客可以看到不同的风景。';

  static const _paragraphSolution = <_OrderSentence>[
    _OrderSentence('overview', '颐和园长廊连接着湖边的多个景点。'),
    _OrderSentence('walk', '游人沿着长廊前进，可以不断看到新的景色。'),
    _OrderSentence('windows', '长廊上的廊窗形状各不相同。'),
    _OrderSentence('borrow', '有些廊窗还把远山纳入眼前的画面。'),
  ];

  static const _paragraphInitial = <_OrderSentence>[
    _OrderSentence('windows', '长廊上的廊窗形状各不相同。'),
    _OrderSentence('borrow', '有些廊窗还把远山纳入眼前的画面。'),
    _OrderSentence('overview', '颐和园长廊连接着湖边的多个景点。'),
    _OrderSentence('walk', '游人沿着长廊前进，可以不断看到新的景色。'),
  ];

  static const _fragments = <String>[
    '每走一段，',
    '窗外的景色',
    '都会发生变化。',
  ];

  static const _nightSolution = <_NightEvent>[
    _NightEvent('knock', '子夜，一名没有影子的客人敲响客栈木门。'),
    _NightEvent('mirror', '掌柜点亮油灯，铜镜里却空无一人。'),
    _NightEvent('promise', '客人留下铜钱，请掌柜天亮前不要开门。'),
    _NightEvent('leaf', '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
  ];

  static const _nightInitial = <_NightEvent>[
    _NightEvent('leaf', '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
    _NightEvent('mirror', '掌柜点亮油灯，铜镜里却空无一人。'),
    _NightEvent('knock', '子夜，一名没有影子的客人敲响客栈木门。'),
    _NightEvent('promise', '客人留下铜钱，请掌柜天亮前不要开门。'),
  ];

  final TextEditingController _grammarController = TextEditingController();
  final List<String> _assembledFragments = <String>[];
  final List<_EarnedCoin> _coins = <_EarnedCoin>[];

  late List<_OrderSentence> _paragraphOrder;
  late List<_NightEvent> _nightOrder;
  _Stage _stage = _Stage.intro;
  int _paragraphAttempts = 0;
  int _grammarAttempts = 0;
  int _fragmentAttempts = 0;
  int _nightAttempts = 0;
  bool _resolved = false;
  _CoinKind? _currentCoin;
  String? _feedback;
  String? _specialEnding;

  String t(String value) => widget.text(value);

  @override
  void initState() {
    super.initState();
    _paragraphOrder = List<_OrderSentence>.of(_paragraphInitial);
    _nightOrder = List<_NightEvent>.of(_nightInitial);
    _grammarController.text = t(_wrongGrammar);
  }

  @override
  void dispose() {
    _grammarController.dispose();
    super.dispose();
  }

  int get _journeyPoints => _coins.fold<int>(
        0,
        (total, coin) => total + coin.kind.points,
      );

  bool get _allGold =>
      _coins.length == 3 && _coins.every((coin) => coin.kind == _CoinKind.gold);

  _CoinKind _kindFor(int attempt) {
    if (attempt <= 1) return _CoinKind.gold;
    if (attempt == 2) return _CoinKind.silver;
    return _CoinKind.bronze;
  }

  void _award(String challenge, int attempt) {
    final kind = _kindFor(attempt);
    _coins.add(_EarnedCoin(challenge, kind));
    _currentCoin = kind;
    _resolved = true;
  }

  bool _sameOrder(Iterable<String> left, Iterable<String> right) {
    final a = left.toList(growable: false);
    final b = right.toList(growable: false);
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  void _reorderParagraph(int oldIndex, int newIndex) {
    if (_resolved) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _paragraphOrder.removeAt(oldIndex);
      _paragraphOrder.insert(newIndex, item);
      _feedback = null;
    });
  }

  void _moveParagraph(int index, int delta) {
    final target = index + delta;
    if (_resolved || target < 0 || target >= _paragraphOrder.length) return;
    setState(() {
      final item = _paragraphOrder.removeAt(index);
      _paragraphOrder.insert(target, item);
      _feedback = null;
    });
  }

  void _checkParagraph() {
    if (_resolved) return;
    final attempt = _paragraphAttempts + 1;
    final correct = _sameOrder(
      _paragraphOrder.map((item) => item.id),
      _paragraphSolution.map((item) => item.id),
    );
    setState(() {
      _paragraphAttempts = attempt;
      if (correct) {
        _award('短文复原', attempt);
        _feedback = '段落已经恢复。先介绍整体位置，再写游人的行动，最后补充廊窗与借景细节。';
      } else {
        _feedback = '先找介绍长廊整体位置的句子，再安排游人的行动，最后放观察细节。';
      }
    });
  }

  String _normalize(String value) => value
      .replaceAll(RegExp(r'[\s，。！？、；：“”‘’]'), '')
      .trim();

  bool _acceptedGrammar(String answer) {
    const accepted = <String>{
      _grammarModel,
      '游览长廊时，游客可以看到不同的风景。',
      '游客通过游览长廊，可以看到不同的风景。',
      '游客游览长廊时，可以看到不同的风景。',
    };
    final normalized = _normalize(answer);
    return accepted.expand((value) => <String>{value, t(value)}).any(
          (value) => _normalize(value) == normalized,
        );
  }

  void _checkGrammar() {
    if (_resolved) return;
    final attempt = _grammarAttempts + 1;
    final answer = _grammarController.text.trim();
    setState(() {
      _grammarAttempts = attempt;
      if (_acceptedGrammar(answer)) {
        _award('语病修复', attempt);
        _feedback = null;
      } else if (answer.isEmpty) {
        _feedback = '先修改句子。重点检查“通过……”和“使……”同时出现后，谁是句子的主语。';
      } else if (_normalize(answer).contains(_normalize('通过游览长廊使'))) {
        _feedback = '“通过……”和“使……”仍然同时存在，句子还是没有明确主语。';
      } else {
        _feedback = '请让“游客”成为明确主语，并保留“看到不同风景”的原意。';
      }
    });
  }

  void _addFragment(String fragment) {
    if (_resolved || _assembledFragments.contains(fragment)) return;
    setState(() {
      _assembledFragments.add(fragment);
      _feedback = null;
    });
  }

  void _checkFragments() {
    if (_resolved) return;
    final attempt = _fragmentAttempts + 1;
    final correct = _sameOrder(_assembledFragments, _fragments);
    setState(() {
      _fragmentAttempts = attempt;
      if (correct) {
        _award('补回句子', attempt);
        _feedback = '“每走一段”承接移动，“都会发生变化”说明反复出现的结果。';
      } else {
        _feedback = '先说时间或条件，再说变化的对象，最后说明结果。';
      }
    });
  }

  void _continueTo(_Stage next) {
    setState(() {
      _stage = next;
      _resolved = false;
      _currentCoin = null;
      _feedback = null;
      if (next == _Stage.grammar) {
        _grammarController.text = t(_wrongGrammar);
      }
    });
  }

  void _reorderNight(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _nightOrder.removeAt(oldIndex);
      _nightOrder.insert(newIndex, item);
      _feedback = null;
    });
  }

  void _moveNight(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _nightOrder.length) return;
    setState(() {
      final item = _nightOrder.removeAt(index);
      _nightOrder.insert(target, item);
      _feedback = null;
    });
  }

  void _checkNightOrder() {
    final attempt = _nightAttempts + 1;
    final correct = _sameOrder(
      _nightOrder.map((item) => item.id),
      _nightSolution.map((item) => item.id),
    );
    setState(() {
      _nightAttempts = attempt;
      if (correct) {
        _stage = _Stage.specialDecision;
        _feedback = null;
      } else {
        _feedback = '敲门应最早发生，鸡鸣和枯叶属于天亮后的结果。';
      }
    });
  }

  void _restart() {
    setState(() {
      _paragraphOrder = List<_OrderSentence>.of(_paragraphInitial);
      _nightOrder = List<_NightEvent>.of(_nightInitial);
      _assembledFragments.clear();
      _coins.clear();
      _stage = _Stage.intro;
      _paragraphAttempts = 0;
      _grammarAttempts = 0;
      _fragmentAttempts = 0;
      _nightAttempts = 0;
      _resolved = false;
      _currentCoin = null;
      _feedback = null;
      _specialEnding = null;
      _grammarController.text = t(_wrongGrammar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: switch (_stage) {
        _Stage.intro => _intro(),
        _Stage.paragraph => _paragraphChallenge(),
        _Stage.grammar => _grammarChallenge(),
        _Stage.fragments => _fragmentChallenge(),
        _Stage.summary => _summary(),
        _Stage.specialIntro => _specialIntro(),
        _Stage.specialOrder => _specialOrder(),
        _Stage.specialDecision => _specialDecision(),
        _Stage.specialEnding => _specialEndingPage(),
      },
    );
  }

  Widget _intro() {
    return _Page(
      key: const ValueKey('coin-journey-intro'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          const Icon(
            Icons.monetization_on_rounded,
            size: 70,
            color: Color(0xFFFFD166),
          ),
          const SizedBox(height: 10),
          _title(t('学习闯关 · 钱币收藏 · 异境解锁')),
          const SizedBox(height: 8),
          _body(
            t('完成三种中文挑战，根据答对次数获得金币、银币或铜币。收集旅程值，就能打开神话与志怪世界。'),
            center: true,
          ),
          const SizedBox(height: 16),
          _rewardRules(),
          const SizedBox(height: 14),
          _journeyCard(
            title: t('普通挑战：颐和园'),
            subtitle: t('短文复原、语病修复、补回句子'),
            icon: Icons.account_balance_rounded,
          ),
          const SizedBox(height: 9),
          _journeyCard(
            title: t('隐藏旅程：聊斋夜客'),
            subtitle: t('完成三关并收集至少 3 点旅程值'),
            icon: Icons.nightlight_round,
            locked: true,
          ),
          const SizedBox(height: 18),
          _PrimaryButton(
            key: const ValueKey('coin-start-challenges'),
            label: t('开始三关挑战'),
            icon: Icons.play_arrow_rounded,
            onPressed: () => setState(() => _stage = _Stage.paragraph),
          ),
        ],
      ),
    );
  }

  Widget _paragraphChallenge() {
    return _challengePage(
      key: const ValueKey('coin-paragraph-challenge'),
      step: t('第 1 关 / 3'),
      title: t('短文复原'),
      instruction: t('拖动句子恢复自然段落，也可以用箭头调整顺序。'),
      attempts: _paragraphAttempts,
      explanation: _resolved
          ? t('正确逻辑是“整体位置 → 游人行动 → 廊窗细节 → 借景效果”。读者先知道长廊在哪里，再跟随游人移动。')
          : null,
      continueLabel: t('进入语病修复'),
      onContinue: _resolved ? () => _continueTo(_Stage.grammar) : null,
      child: Column(
        children: [
          ReorderableListView.builder(
            key: const ValueKey('paragraph-reorder-list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paragraphOrder.length,
            onReorder: _reorderParagraph,
            itemBuilder: (context, index) {
              final item = _paragraphOrder[index];
              return _ReorderCard(
                key: ValueKey<String>('paragraph-${item.id}'),
                index: index,
                text: t(item.text),
                onUp: () => _moveParagraph(index, -1),
                onDown: () => _moveParagraph(index, 1),
                dark: false,
              );
            },
          ),
          if (!_resolved) ...[
            const SizedBox(height: 8),
            _PrimaryButton(
              key: const ValueKey('paragraph-submit'),
              label: t('检查段落顺序'),
              icon: Icons.check_circle_rounded,
              onPressed: _checkParagraph,
            ),
          ],
        ],
      ),
    );
  }

  Widget _grammarChallenge() {
    return _challengePage(
      key: const ValueKey('coin-grammar-challenge'),
      step: t('第 2 关 / 3'),
      title: t('找出并修改语病'),
      instruction: t('直接编辑病句。改对后会说明病句类型、错误原因、修改原则和记忆方法。'),
      attempts: _grammarAttempts,
      continueLabel: t('进入补句挑战'),
      onContinue: _resolved ? () => _continueTo(_Stage.fragments) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5A2420),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              t('病句：$_wrongGrammar'),
              style: const TextStyle(
                color: Color(0xFFFFD7C9),
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (!_resolved) ...[
            const SizedBox(height: 10),
            _PrimaryButton(
              key: const ValueKey('grammar-submit'),
              label: t('提交修改'),
              icon: Icons.edit_note_rounded,
              onPressed: _checkGrammar,
            ),
          ],
          if (_resolved) ...[
            const SizedBox(height: 12),
            _grammarExplanation(),
          ],
        ],
      ),
    );
  }

  Widget _fragmentChallenge() {
    final assembled = _assembledFragments.map(t).join();
    return _challengePage(
      key: const ValueKey('coin-fragment-challenge'),
      step: t('第 3 关 / 3'),
      title: t('补回失落句子'),
      instruction: t('依次点击三个碎片，拼出能连接前后文的一句话。'),
      attempts: _fragmentAttempts,
      explanation: _resolved
          ? t('完整句子是：“每走一段，窗外的景色都会发生变化。”它承接“沿着长廊前进”，也解释为什么观景路线不断变化。')
          : null,
      continueLabel: t('查看钱币与异境'),
      onContinue: _resolved ? () => _continueTo(_Stage.summary) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4E5C6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('游客沿着长廊慢慢前进。')),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E9),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: const Color(0xFFC9864C)),
                  ),
                  child: Text(
                    assembled.isEmpty ? t('点击下方碎片补回句子') : assembled,
                    key: const ValueKey('fragment-assembled-text'),
                    style: const TextStyle(
                      color: Color(0xFF8B3B31),
                      height: 1.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(t('因此，长廊不仅是通道，也是一条不断变化的观景路线。')),
              ],
            ),
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _fragments.length; index++)
                ActionChip(
                  key: ValueKey<String>('fragment-$index'),
                  onPressed: _resolved ||
                          _assembledFragments.contains(_fragments[index])
                      ? null
                      : () => _addFragment(_fragments[index]),
                  avatar: Icon(
                    _assembledFragments.contains(_fragments[index])
                        ? Icons.check_rounded
                        : Icons.add_rounded,
                    size: 18,
                  ),
                  label: Text(t(_fragments[index])),
                ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const ValueKey('fragment-undo'),
            onPressed: _resolved || _assembledFragments.isEmpty
                ? null
                : () => setState(() {
                      _assembledFragments.removeLast();
                      _feedback = null;
                    }),
            icon: const Icon(Icons.undo_rounded),
            label: Text(t('撤回一个碎片')),
          ),
          if (!_resolved) ...[
            const SizedBox(height: 8),
            _PrimaryButton(
              key: const ValueKey('fragment-submit'),
              label: t('检查补句'),
              icon: Icons.check_circle_rounded,
              onPressed: _checkFragments,
            ),
          ],
        ],
      ),
    );
  }

  Widget _challengePage({
    required Key key,
    required String step,
    required String title,
    required String instruction,
    required int attempts,
    required Widget child,
    required String continueLabel,
    required VoidCallback? onContinue,
    String? explanation,
  }) {
    return _Page(
      key: key,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 28),
        children: [
          Text(
            step,
            style: const TextStyle(
              color: Color(0xFFFFC86B),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFE8B6),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          _body(instruction),
          if (attempts > 0 && !_resolved) ...[
            const SizedBox(height: 5),
            Text(
              t('已尝试 $attempts 次'),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 13),
          child,
          if (_feedback != null) ...[
            const SizedBox(height: 9),
            _message(t(_feedback!), positive: _resolved),
          ],
          if (_currentCoin != null) ...[
            const SizedBox(height: 9),
            _coinReward(_currentCoin!),
          ],
          if (explanation != null) ...[
            const SizedBox(height: 9),
            _learningCard(explanation),
          ],
          if (onContinue != null) ...[
            const SizedBox(height: 11),
            _PrimaryButton(
              label: continueLabel,
              icon: Icons.arrow_forward_rounded,
              onPressed: onContinue,
            ),
          ],
        ],
      ),
    );
  }

  Widget _grammarExplanation() {
    return Container(
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
          Text(
            t('为什么这样改？'),
            style: const TextStyle(
              color: Color(0xFF315B32),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _explanationRow(t('病句类型'), t('成分残缺：主语缺失')),
          _explanationRow(t('原句'), t(_wrongGrammar)),
          _explanationRow(t('修改后'), _grammarController.text.trim()),
          _explanationRow(
            t('错误原因'),
            t('“通过……”把“游览长廊”变成介词结构；“使……”又引出结果。两个结构叠在一起后，整句话没有明确主语。'),
          ),
          _explanationRow(
            t('修改原则'),
            t('删除“使”，让“游客”直接成为主语。也可以把开头改成“游览长廊时”。'),
          ),
          _explanationRow(
            t('记忆方法'),
            t('看到“通过……使……”时，要检查句子里是否还剩下明确主语。'),
          ),
        ],
      ),
    );
  }

  Widget _explanationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF537A4F),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF263B27),
              fontSize: 12.5,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    return _Page(
      key: const ValueKey('coin-summary'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFD166),
            size: 62,
          ),
          const SizedBox(height: 8),
          _title(t('颐和园挑战完成')),
          const SizedBox(height: 6),
          _body(
            t('钱币记录掌握程度，但不会把练习次数变成惩罚。持续学习的人同样能打开异境。'),
            center: true,
          ),
          const SizedBox(height: 14),
          for (final coin in _coins) ...[
            _coinTile(coin),
            const SizedBox(height: 8),
          ],
          if (_allGold) ...[
            const SizedBox(height: 3),
            _rareCoin(),
          ],
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1DFB8),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              t('旅程值：$_journeyPoints 点\n金币 3 点 · 银币 2 点 · 铜币 1 点'),
              style: const TextStyle(
                color: Color(0xFF6F2925),
                height: 1.45,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 13),
          _unlockCard(),
        ],
      ),
    );
  }

  Widget _unlockCard() {
    final canUnlock = _journeyPoints >= 3;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF25213A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF57527B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.nightlight_round,
                color: Color(0xFFC9C4FA),
                size: 34,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('异境录 · 聊斋夜客'),
                      style: const TextStyle(
                        color: Color(0xFFE9E7FF),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      t('解锁需要 3 点 · 当前 $_journeyPoints 点'),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _body(t('钱币保留在收藏册，旅程值负责打开隐藏世界。完成三关后一定可以进入本次体验。')),
          const SizedBox(height: 10),
          FilledButton.icon(
            key: const ValueKey('unlock-special-journey'),
            onPressed: canUnlock
                ? () => setState(() => _stage = _Stage.specialIntro)
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6E5CA5),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.lock_open_rounded),
            label: Text(
              t('用旅程值解锁'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialIntro() {
    return _Page(
      key: const ValueKey('special-journey-intro'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
        children: [
          const Icon(
            Icons.nightlight_round,
            color: Color(0xFFB9C7FF),
            size: 65,
          ),
          const SizedBox(height: 8),
          _title(t('异境录 · 聊斋夜客'), pale: true),
          const SizedBox(height: 10),
          _nightStory(
            t('子夜，一名没有影子的旅客走进湖边客栈。他把一枚湿漉漉的铜钱放在柜台上，只说：“天亮前，别让镜子照见我。”第二天，掌柜留下的夜记却被风吹乱了。'),
          ),
          const SizedBox(height: 13),
          _body(
            t('这不是普通景点介绍。你要拼回一段志怪夜记，并决定掌柜是否守住承诺。'),
            center: true,
          ),
          const SizedBox(height: 17),
          _PrimaryButton(
            key: const ValueKey('special-start'),
            label: t('进入午夜客栈'),
            icon: Icons.door_front_door_rounded,
            onPressed: () => setState(() => _stage = _Stage.specialOrder),
          ),
        ],
      ),
    );
  }

  Widget _specialOrder() {
    return _Page(
      key: const ValueKey('special-order-challenge'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _title(t('拼回失落的夜记'), pale: true),
          const SizedBox(height: 5),
          _body(t('拖动四段记录，恢复事情发生的先后顺序。')),
          const SizedBox(height: 12),
          ReorderableListView.builder(
            key: const ValueKey('night-reorder-list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _nightOrder.length,
            onReorder: _reorderNight,
            itemBuilder: (context, index) {
              final item = _nightOrder[index];
              return _ReorderCard(
                key: ValueKey<String>('night-${item.id}'),
                index: index,
                text: t(item.text),
                onUp: () => _moveNight(index, -1),
                onDown: () => _moveNight(index, 1),
                dark: true,
              );
            },
          ),
          if (_feedback != null) ...[
            const SizedBox(height: 8),
            _message(t(_feedback!), positive: false),
          ],
          const SizedBox(height: 10),
          _PrimaryButton(
            key: const ValueKey('night-submit'),
            label: t('检查夜记'),
            icon: Icons.menu_book_rounded,
            onPressed: _checkNightOrder,
          ),
        ],
      ),
    );
  }

  Widget _specialDecision() {
    return _Page(
      key: const ValueKey('special-decision'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
        children: [
          const Icon(
            Icons.door_front_door_rounded,
            color: Color(0xFFCEC8FF),
            size: 64,
          ),
          const SizedBox(height: 8),
          _title(t('鸡鸣之前，门外响起第三次敲门声'), pale: true),
          const SizedBox(height: 8),
          _body(
            t('夜客要求掌柜不要开门，可是门缝下正慢慢渗进一串湿脚印。'),
            center: true,
          ),
          const SizedBox(height: 17),
          _decision(
            key: const ValueKey('special-choice-keep'),
            icon: Icons.lock_rounded,
            title: t('守住承诺，不开门'),
            subtitle: t('相信夜客留下的警告'),
            onTap: () => setState(() {
              _specialEnding = 'keep';
              _stage = _Stage.specialEnding;
            }),
          ),
          const SizedBox(height: 10),
          _decision(
            key: const ValueKey('special-choice-chase'),
            icon: Icons.directions_run_rounded,
            title: t('推门追出去'),
            subtitle: t('看看脚印究竟通向哪里'),
            onTap: () => setState(() {
              _specialEnding = 'chase';
              _stage = _Stage.specialEnding;
            }),
          ),
        ],
      ),
    );
  }

  Widget _specialEndingPage() {
    final kept = _specialEnding == 'keep';
    return _Page(
      key: const ValueKey('special-ending'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
        children: [
          Icon(
            kept ? Icons.local_activity_rounded : Icons.directions_walk_rounded,
            color: const Color(0xFFCFCAFF),
            size: 70,
          ),
          const SizedBox(height: 9),
          _title(
            t(kept ? '结局：灯票守夜人' : '结局：墙中脚印'),
            pale: true,
          ),
          const SizedBox(height: 10),
          _nightStory(
            t(
              kept
                  ? '掌柜整夜没有开门。天亮后，铜钱化成一张黑底银字的灯票，背面写着：“月末子时，鬼市只为守信之人开门。”'
                  : '掌柜推门追出，只见湿脚印一路延伸到客栈外墙，然后笔直地走进砖缝。墙内传来一句很轻的声音：“你不该替镜子开门。”',
            ),
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE5DFC7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  t('异境收藏品'),
                  style: const TextStyle(
                    color: Color(0xFF6C2E2A),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t(kept ? '鬼市灯票' : '墙缝湿印拓片'),
                  style: const TextStyle(
                    color: Color(0xFF2F281F),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _PrimaryButton(
            key: const ValueKey('coin-prototype-restart'),
            label: t('重新体验完整流程'),
            icon: Icons.replay_rounded,
            onPressed: _restart,
          ),
        ],
      ),
    );
  }

  Widget _rewardRules() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1DFB8),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _rule(_CoinKind.gold, t('第一次答对 · 3 点')),
          const Divider(height: 18),
          _rule(_CoinKind.silver, t('第二次答对 · 2 点')),
          const Divider(height: 18),
          _rule(_CoinKind.bronze, t('第三次或练习后答对 · 1 点')),
        ],
      ),
    );
  }

  Widget _rule(_CoinKind kind, String text) {
    return Row(
      children: [
        _CoinDisc(kind: kind, size: 31, text: widget.text),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4E3C2D),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _journeyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    bool locked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: locked ? const Color(0xFF28233A) : const Color(0xFF34261D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: locked ? const Color(0xFFC8C3F0) : const Color(0xFFFFD166),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (locked) const Icon(Icons.lock_rounded, color: Colors.white38),
        ],
      ),
    );
  }

  Widget _coinReward(_CoinKind kind) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kind.color),
      ),
      child: Row(
        children: [
          _CoinDisc(kind: kind, size: 48, text: widget.text),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('获得${kind.label}'),
                  style: TextStyle(
                    color: kind.color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  t('${kind.reason} · ${kind.points} 点旅程值'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coinTile(_EarnedCoin coin) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF34261D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _CoinDisc(kind: coin.kind, size: 43, text: widget.text),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(coin.challenge),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  t('${coin.kind.label} · ${coin.kind.points} 点 · ${coin.kind.reason}'),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rareCoin() {
    return Container(
      key: const ValueKey('rare-rui-silver-coin'),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8E9F4), Color(0xFFAEBAD0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFF4B5573),
            size: 35,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t('额外获得：瑞银币\n三关全部第一次答对的稀有收藏币'),
              style: const TextStyle(
                color: Color(0xFF30384F),
                height: 1.4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _message(String text, {required bool positive}) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: positive ? const Color(0xFF284235) : const Color(0xFF5D2924),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            positive ? Icons.check_circle_rounded : Icons.lightbulb_rounded,
            color: positive ? const Color(0xFFB8E1C1) : const Color(0xFFFFCF9C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningCard(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF253B31),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Color(0xFFAED8B9)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFDFF3E4),
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nightStory(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF25213A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF57527B)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE4E1F6),
          fontSize: 14,
          height: 1.65,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _decision({
    required Key key,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      key: key,
      color: const Color(0xFF29253D),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFCFCAFF), size: 32),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE9E7FF),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text, {bool pale = false}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: pale ? const Color(0xFFE7E9FF) : const Color(0xFFFFE8B6),
        fontSize: 25,
        height: 1.25,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _body(String text, {bool center = false}) {
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12.5,
        height: 1.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

enum _Stage {
  intro,
  paragraph,
  grammar,
  fragments,
  summary,
  specialIntro,
  specialOrder,
  specialDecision,
  specialEnding,
}

enum _CoinKind { gold, silver, bronze }

extension _CoinKindDetails on _CoinKind {
  int get points => switch (this) {
        _CoinKind.gold => 3,
        _CoinKind.silver => 2,
        _CoinKind.bronze => 1,
      };

  String get label => switch (this) {
        _CoinKind.gold => '金币',
        _CoinKind.silver => '银币',
        _CoinKind.bronze => '铜币',
      };

  String get mark => switch (this) {
        _CoinKind.gold => '金',
        _CoinKind.silver => '银',
        _CoinKind.bronze => '铜',
      };

  String get reason => switch (this) {
        _CoinKind.gold => '第一次答对',
        _CoinKind.silver => '第二次答对',
        _CoinKind.bronze => '练习后答对',
      };

  Color get color => switch (this) {
        _CoinKind.gold => const Color(0xFFFFD166),
        _CoinKind.silver => const Color(0xFFD7DCE5),
        _CoinKind.bronze => const Color(0xFFC8834A),
      };
}

class _EarnedCoin {
  const _EarnedCoin(this.challenge, this.kind);

  final String challenge;
  final _CoinKind kind;
}

class _OrderSentence {
  const _OrderSentence(this.id, this.text);

  final String id;
  final String text;
}

class _NightEvent {
  const _NightEvent(this.id, this.text);

  final String id;
  final String text;
}

class _Page extends StatelessWidget {
  const _Page({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
          child: child,
        ),
      ),
    );
  }
}

class _ReorderCard extends StatelessWidget {
  const _ReorderCard({
    super.key,
    required this.index,
    required this.text,
    required this.onUp,
    required this.onDown,
    required this.dark,
  });

  final int index;
  final String text;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? const Color(0xFFE5E2F5) : const Color(0xFF34291F);
    final background = dark ? const Color(0xFF2A263D) : const Color(0xFFF4E5C6);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(11, 8, 5, 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor:
                dark ? const Color(0xFF625B91) : const Color(0xFF9C3A30),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: foreground,
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: index > 0 ? onUp : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
                color: foreground,
              ),
              IconButton(
                onPressed: onDown,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                color: foreground,
              ),
            ],
          ),
          Icon(Icons.drag_handle_rounded, color: foreground.withValues(alpha: .55)),
        ],
      ),
    );
  }
}

class _CoinDisc extends StatelessWidget {
  const _CoinDisc({
    required this.kind,
    required this.size,
    required this.text,
  });

  final _CoinKind kind;
  final double size;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kind.color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF7E5A26), width: 2),
      ),
      child: Text(
        text(kind.mark),
        style: const TextStyle(
          color: Color(0xFF5F3A17),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFB94635),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
