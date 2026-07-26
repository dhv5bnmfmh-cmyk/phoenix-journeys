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
  const CoinJourneyGame({
    super.key,
    required this.text,
  });

  final String Function(String) text;

  @override
  State<CoinJourneyGame> createState() => _CoinJourneyGameState();
}

class _CoinJourneyGameState extends State<CoinJourneyGame> {
  static const _wrongGrammar = '通过游览长廊，使游客可以看到不同的风景。';
  static const _grammarModel = '通过游览长廊，游客可以看到不同的风景。';

  final TextEditingController _grammarController = TextEditingController();
  _PrototypeStage _stage = _PrototypeStage.intro;

  List<_OrderSentence> _paragraphOrder = List<_OrderSentence>.from(
    _paragraphInitial,
  );
  List<_NightEvent> _nightOrder = List<_NightEvent>.from(_nightInitial);
  final List<String> _assembledFragments = <String>[];
  final List<_EarnedCoin> _earnedCoins = <_EarnedCoin>[];

  int _paragraphAttempts = 0;
  int _grammarAttempts = 0;
  int _fragmentAttempts = 0;
  int _nightAttempts = 0;
  String? _feedback;
  _CoinKind? _currentCoin;
  bool _challengeResolved = false;
  bool _specialUnlocked = false;
  String? _specialEnding;

  static const List<_OrderSentence> _paragraphSolution = [
    _OrderSentence(
      id: 'overview',
      text: '颐和园长廊连接着湖边的多个景点。',
    ),
    _OrderSentence(
      id: 'walk',
      text: '游人沿着长廊前进，可以不断看到新的景色。',
    ),
    _OrderSentence(
      id: 'windows',
      text: '长廊上的廊窗形状各不相同。',
    ),
    _OrderSentence(
      id: 'borrow',
      text: '有些廊窗还把远山纳入眼前的画面。',
    ),
  ];

  static const List<_OrderSentence> _paragraphInitial = [
    _OrderSentence(
      id: 'windows',
      text: '长廊上的廊窗形状各不相同。',
    ),
    _OrderSentence(
      id: 'borrow',
      text: '有些廊窗还把远山纳入眼前的画面。',
    ),
    _OrderSentence(
      id: 'overview',
      text: '颐和园长廊连接着湖边的多个景点。',
    ),
    _OrderSentence(
      id: 'walk',
      text: '游人沿着长廊前进，可以不断看到新的景色。',
    ),
  ];

  static const List<String> _fragments = [
    '每走一段，',
    '窗外的景色',
    '都会发生变化。',
  ];

  static const List<_NightEvent> _nightSolution = [
    _NightEvent(id: 'knock', text: '子夜，一名没有影子的客人敲响客栈木门。'),
    _NightEvent(id: 'mirror', text: '掌柜点亮油灯，铜镜里却空无一人。'),
    _NightEvent(id: 'promise', text: '客人留下铜钱，请掌柜天亮前不要开门。'),
    _NightEvent(id: 'leaf', text: '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
  ];

  static const List<_NightEvent> _nightInitial = [
    _NightEvent(id: 'leaf', text: '鸡鸣时，铜钱变成了一片湿漉漉的枯叶。'),
    _NightEvent(id: 'mirror', text: '掌柜点亮油灯，铜镜里却空无一人。'),
    _NightEvent(id: 'knock', text: '子夜，一名没有影子的客人敲响客栈木门。'),
    _NightEvent(id: 'promise', text: '客人留下铜钱，请掌柜天亮前不要开门。'),
  ];

  String t(String value) => widget.text(value);

  @override
  void initState() {
    super.initState();
    _grammarController.text = t(_wrongGrammar);
  }

  @override
  void dispose() {
    _grammarController.dispose();
    super.dispose();
  }

  int get _journeyPoints => _earnedCoins.fold<int>(
        0,
        (total, coin) => total + coin.kind.points,
      );

  bool get _allGold =>
      _earnedCoins.length == 3 &&
      _earnedCoins.every((coin) => coin.kind == _CoinKind.gold);

  _CoinKind _coinForAttempt(int attempt) {
    if (attempt <= 1) return _CoinKind.gold;
    if (attempt == 2) return _CoinKind.silver;
    return _CoinKind.bronze;
  }

  void _recordCoin(String challenge, int attempt) {
    final kind = _coinForAttempt(attempt);
    _earnedCoins.add(_EarnedCoin(challenge: challenge, kind: kind));
    _currentCoin = kind;
    _challengeResolved = true;
  }

  void _moveParagraph(int index, int delta) {
    final next = index + delta;
    if (next < 0 || next >= _paragraphOrder.length || _challengeResolved) return;
    setState(() {
      final item = _paragraphOrder.removeAt(index);
      _paragraphOrder.insert(next, item);
      _feedback = null;
    });
  }

  void _reorderParagraph(int oldIndex, int newIndex) {
    if (_challengeResolved) return;
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _paragraphOrder.removeAt(oldIndex);
      _paragraphOrder.insert(newIndex, item);
      _feedback = null;
    });
  }

  void _checkParagraph() {
    if (_challengeResolved) return;
    final attempt = _paragraphAttempts + 1;
    final correct = _sameIds(
      _paragraphOrder.map((item) => item.id),
      _paragraphSolution.map((item) => item.id),
    );
    setState(() {
      _paragraphAttempts = attempt;
      if (correct) {
        _recordCoin('短文复原', attempt);
        _feedback = '段落已经恢复。先介绍长廊的整体位置，再写游人的行动，最后补充廊窗与借景细节，阅读会更自然。';
      } else {
        _feedback = '还差一点。先找能够介绍“整体位置”的句子，再安排游人的行动，最后放入观察细节。';
      }
    });
  }

  String _normalize(String value) => value
      .replaceAll(RegExp(r'[\s，。！？、；：“”‘’]'), '')
      .trim();

  bool _isAcceptedGrammar(String answer) {
    final accepted = <String>{
      _grammarModel,
      '游览长廊时，游客可以看到不同的风景。',
      '游客通过游览长廊，可以看到不同的风景。',
      '游客游览长廊时，可以看到不同的风景。',
    };
    final normalizedAnswer = _normalize(answer);
    return accepted.expand((value) => <String>{value, t(value)}).any(
          (value) => _normalize(value) == normalizedAnswer,
        );
  }

  void _checkGrammar() {
    if (_challengeResolved) return;
    final attempt = _grammarAttempts + 1;
    final answer = _grammarController.text.trim();
    setState(() {
      _grammarAttempts = attempt;
      if (_isAcceptedGrammar(answer)) {
        _recordCoin('语病修复', attempt);
        _feedback = null;
      } else if (answer.isEmpty) {
        _feedback = '先修改句子。重点检查“通过……”和“使……”放在一起后，谁是句子的主语。';
      } else if (_normalize(answer).contains(_normalize('通过游览长廊使'))) {
        _feedback = '“通过……”和“使……”仍然同时存在，句子还是没有明确主语。试着删掉其中一个。';
      } else {
        _feedback = '方向接近了。请让“游客”成为明确主语，并保留“看到不同风景”的原意。';
      }
    });
  }

  void _addFragment(String fragment) {
    if (_challengeResolved || _assembledFragments.contains(fragment)) return;
    setState(() {
      _assembledFragments.add(fragment);
      _feedback = null;
    });
  }

  void _removeLastFragment() {
    if (_challengeResolved || _assembledFragments.isEmpty) return;
    setState(() {
      _assembledFragments.removeLast();
      _feedback = null;
    });
  }

  void _checkFragments() {
    if (_challengeResolved) return;
    final attempt = _fragmentAttempts + 1;
    final correct = _sameIds(_assembledFragments, _fragments);
    setState(() {
      _fragmentAttempts = attempt;
      if (correct) {
        _recordCoin('补回句子', attempt);
        _feedback = '“每走一段”承接游人的移动，“都会发生变化”说明重复出现的结果，因此能自然连接前后文。';
      } else {
        _feedback = '先说时间或条件，再说发生变化的对象，最后说明结果。';
      }
    });
  }

  void _continueFromChallenge(_PrototypeStage next) {
    setState(() {
      _stage = next;
      _feedback = null;
      _currentCoin = null;
      _challengeResolved = false;
      if (next == _PrototypeStage.grammar) {
        _grammarController.text = t(_wrongGrammar);
      }
    });
  }

  void _unlockSpecialJourney() {
    if (_journeyPoints < 3) return;
    setState(() {
      _specialUnlocked = true;
      _stage = _PrototypeStage.specialIntro;
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
    final next = index + delta;
    if (next < 0 || next >= _nightOrder.length) return;
    setState(() {
      final item = _nightOrder.removeAt(index);
      _nightOrder.insert(next, item);
      _feedback = null;
    });
  }

  void _checkNightOrder() {
    final attempt = _nightAttempts + 1;
    final correct = _sameIds(
      _nightOrder.map((item) => item.id),
      _nightSolution.map((item) => item.id),
    );
    setState(() {
      _nightAttempts = attempt;
      if (correct) {
        _stage = _PrototypeStage.specialDecision;
        _feedback = null;
      } else {
        _feedback = '夜记仍然前后颠倒。敲门应当最早发生，鸡鸣和枯叶则属于天亮后的结果。';
      }
    });
  }

  void _chooseSpecialEnding(String ending) {
    setState(() {
      _specialEnding = ending;
      _stage = _PrototypeStage.specialEnding;
    });
  }

  void _restart() {
    setState(() {
      _stage = _PrototypeStage.intro;
      _paragraphOrder = List<_OrderSentence>.from(_paragraphInitial);
      _nightOrder = List<_NightEvent>.from(_nightInitial);
      _assembledFragments.clear();
      _earnedCoins.clear();
      _paragraphAttempts = 0;
      _grammarAttempts = 0;
      _fragmentAttempts = 0;
      _nightAttempts = 0;
      _feedback = null;
      _currentCoin = null;
      _challengeResolved = false;
      _specialUnlocked = false;
      _specialEnding = null;
      _grammarController.text = t(_wrongGrammar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: switch (_stage) {
        _PrototypeStage.intro => _buildIntro(),
        _PrototypeStage.paragraph => _buildParagraphChallenge(),
        _PrototypeStage.grammar => _buildGrammarChallenge(),
        _PrototypeStage.fragments => _buildFragmentChallenge(),
        _PrototypeStage.summary => _buildSummary(),
        _PrototypeStage.specialIntro => _buildSpecialIntro(),
        _PrototypeStage.specialOrder => _buildSpecialOrder(),
        _PrototypeStage.specialDecision => _buildSpecialDecision(),
        _PrototypeStage.specialEnding => _buildSpecialEnding(),
      },
    );
  }

  Widget _buildIntro() {
    return _PageShell(
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
          Text(
            t('学习闯关 · 钱币收藏 · 异境解锁'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFE8B6),
              fontSize: 25,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t('完成三种中文挑战，根据答对次数获得金币、银币或铜币。收集到足够旅程点，就能打开普通景点之外的神话与志怪世界。'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          const _RewardRuleCard(),
          const SizedBox(height: 16),
          _JourneyPreviewCard(
            title: t('普通挑战：颐和园'),
            subtitle: t('短文复原、语病修复、补回句子'),
            icon: Icons.account_balance_rounded,
            locked: false,
          ),
          const SizedBox(height: 10),
          _JourneyPreviewCard(
            title: t('隐藏旅程：聊斋夜客'),
            subtitle: t('收集至少 3 点旅程值后开启'),
            icon: Icons.nightlight_round,
            locked: true,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            key: const ValueKey('coin-start-challenges'),
            onPressed: () => setState(() => _stage = _PrototypeStage.paragraph),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB94635),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              t('开始三关挑战'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraphChallenge() {
    return _ChallengeShell(
      key: const ValueKey('coin-paragraph-challenge'),
      step: t('第 1 关 / 3'),
      title: t('短文复原'),
      instruction: t('拖动句子，恢复一段自然、连贯的短文。也可以使用右侧箭头微调顺序。'),
      attempts: _paragraphAttempts,
      coin: _currentCoin,
      feedback: _feedback == null ? null : t(_feedback!),
      explanation: _challengeResolved
          ? t('这段文字采用“整体位置 → 游人行动 → 廊窗细节 → 借景效果”的顺序。读者先知道长廊在哪里，再跟随游人移动，最后理解廊窗如何把远山带入画面。')
          : null,
      continueLabel: t('进入语病修复'),
      onContinue: _challengeResolved
          ? () => _continueFromChallenge(_PrototypeStage.grammar)
          : null,
      child: Column(
        children: [
          ReorderableListView.builder(
            key: const ValueKey('paragraph-reorder-list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paragraphOrder.length,
            onReorder: _reorderParagraph,
            itemBuilder: (context, index) {
              final sentence = _paragraphOrder[index];
              return _SentenceTile(
                key: ValueKey<String>('paragraph-${sentence.id}'),
                index: index,
                text: t(sentence.text),
                enabled: !_challengeResolved,
                onUp: () => _moveParagraph(index, -1),
                onDown: () => _moveParagraph(index, 1),
              );
            },
          ),
          if (!_challengeResolved) ...[
            const SizedBox(height: 10),
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

  Widget _buildGrammarChallenge() {
    return _ChallengeShell(
      key: const ValueKey('coin-grammar-challenge'),
      step: t('第 2 关 / 3'),
      title: t('找出并修改语病'),
      instruction: t('直接编辑下面的病句。修改正确后，会解释错误位置、病因与修改原则。'),
      attempts: _grammarAttempts,
      coin: _currentCoin,
      feedback: _feedback == null ? null : t(_feedback!),
      continueLabel: t('进入补句挑战'),
      onContinue: _challengeResolved
          ? () => _continueFromChallenge(_PrototypeStage.fragments)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5A2420),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC96B5C)),
            ),
            child: Text(
              t('病句：$_wrongGrammar'),
              style: const TextStyle(
                color: Color(0xFFFFD7C9),
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 11),
          TextField(
            key: const ValueKey('grammar-input'),
            controller: _grammarController,
            enabled: !_challengeResolved,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: t('修改后的句子'),
              hintText: t('请直接改写整句'),
              filled: true,
              fillColor: const Color(0xFFF7ECD5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (!_challengeResolved) ...[
            const SizedBox(height: 10),
            _PrimaryButton(
              key: const ValueKey('grammar-submit'),
              label: t('提交修改'),
              icon: Icons.edit_note_rounded,
              onPressed: _checkGrammar,
            ),
          ],
          if (_challengeResolved) ...[
            const SizedBox(height: 12),
            _GrammarExplanationCard(
              text: widget.text,
              original: _wrongGrammar,
              corrected: _grammarController.text.trim().isEmpty
                  ? t(_grammarModel)
                  : _grammarController.text.trim(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFragmentChallenge() {
    final assembled = _assembledFragments.map(t).join();
    return _ChallengeShell(
      key: const ValueKey('coin-fragment-challenge'),
      step: t('第 3 关 / 3'),
      title: t('补回失落句子'),
      instruction: t('点击三个句子碎片，拼出能够连接前后文的一句话。'),
      attempts: _fragmentAttempts,
      coin: _currentCoin,
      feedback: _feedback == null ? null : t(_feedback!),
      explanation: _challengeResolved
          ? t('完整句子是：“每走一段，窗外的景色都会发生变化。”它承接“沿着长廊前进”，并解释为什么长廊是一条不断变化的观景路线。')
          : null,
      continueLabel: t('查看钱币与异境'),
      onContinue: _challengeResolved
          ? () => _continueFromChallenge(_PrototypeStage.summary)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ParagraphContextCard(
            before: t('游客沿着长廊慢慢前进。'),
            blank: assembled.isEmpty ? t('点击下方碎片补回句子') : assembled,
            after: t('因此，长廊不仅是通道，也是一条不断变化的观景路线。'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < _fragments.length; index++)
                ActionChip(
                  key: ValueKey<String>('fragment-$index'),
                  onPressed: _assembledFragments.contains(_fragments[index]) ||
                          _challengeResolved
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
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('fragment-undo'),
                  onPressed: _assembledFragments.isEmpty || _challengeResolved
                      ? null
                      : _removeLastFragment,
                  icon: const Icon(Icons.undo_rounded),
                  label: Text(t('撤回一个碎片')),
                ),
              ),
            ],
          ),
          if (!_challengeResolved) ...[
            const SizedBox(height: 10),
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

  Widget _buildSummary() {
    return _PageShell(
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
          Text(
            t('颐和园挑战完成'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFE8B6),
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            t('你的钱币记录了掌握程度，而不是把失败写进成绩单。持续练习的人同样能够打开异境。'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          for (final coin in _earnedCoins) ...[
            _EarnedCoinTile(coin: coin, text: widget.text),
            const SizedBox(height: 8),
          ],
          if (_allGold) ...[
            const SizedBox(height: 4),
            _RareCoinCard(text: widget.text),
          ],
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF1DFB8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF8F342D),
                  size: 31,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('旅程值：$_journeyPoints 点'),
                        style: const TextStyle(
                          color: Color(0xFF6F2925),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        t('金币 3 点 · 银币 2 点 · 铜币 1 点'),
                        style: const TextStyle(
                          color: Color(0xFF5D4937),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _UnlockCard(
            text: widget.text,
            points: _journeyPoints,
            unlocked: _specialUnlocked,
            onUnlock: _unlockSpecialJourney,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialIntro() {
    return _PageShell(
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
          Text(
            t('异境录 · 聊斋夜客'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE7E9FF),
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFF25213A),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFF57527B)),
            ),
            child: Text(
              t('子夜，一名没有影子的旅客走进湖边客栈。他把一枚湿漉漉的铜钱放在柜台上，只说：“天亮前，别让镜子照见我。”第二天，掌柜留下的夜记却被风吹乱了。'),
              style: const TextStyle(
                color: Color(0xFFE4E1F6),
                fontSize: 14,
                height: 1.65,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            t('这不是普通景点介绍。你将拼回一段志怪夜记，并决定掌柜是否守住承诺。'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          _PrimaryButton(
            key: const ValueKey('special-start'),
            label: t('进入午夜客栈'),
            icon: Icons.door_front_door_rounded,
            onPressed: () => setState(
              () => _stage = _PrototypeStage.specialOrder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOrder() {
    return _PageShell(
      key: const ValueKey('special-order-challenge'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Text(
            t('拼回失落的夜记'),
            style: const TextStyle(
              color: Color(0xFFE7E9FF),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            t('拖动四段记录，恢复事情发生的先后顺序。'),
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 13),
          ReorderableListView.builder(
            key: const ValueKey('night-reorder-list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _nightOrder.length,
            onReorder: _reorderNight,
            itemBuilder: (context, index) {
              final event = _nightOrder[index];
              return _NightEventTile(
                key: ValueKey<String>('night-${event.id}'),
                index: index,
                text: t(event.text),
                onUp: () => _moveNight(index, -1),
                onDown: () => _moveNight(index, 1),
              );
            },
          ),
          if (_feedback != null) ...[
            const SizedBox(height: 8),
            _FeedbackCard(text: t(_feedback!), positive: false),
          ],
          const SizedBox(height: 11),
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

  Widget _buildSpecialDecision() {
    return _PageShell(
      key: const ValueKey('special-decision'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
        children: [
          const Icon(
            Icons.door_sliding_rounded,
            color: Color(0xFFCEC8FF),
            size: 64,
          ),
          const SizedBox(height: 9),
          Text(
            t('鸡鸣之前，门外响起第三次敲门声'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE7E9FF),
              fontSize: 23,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t('夜客曾要求掌柜不要开门。可是门缝下正慢慢渗进一串湿脚印。'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          _DecisionButton(
            key: const ValueKey('special-choice-keep'),
            icon: Icons.lock_rounded,
            title: t('守住承诺，不开门'),
            subtitle: t('相信夜客留下的警告'),
            onPressed: () => _chooseSpecialEnding('keep'),
          ),
          const SizedBox(height: 10),
          _DecisionButton(
            key: const ValueKey('special-choice-chase'),
            icon: Icons.directions_run_rounded,
            title: t('推门追出去'),
            subtitle: t('看看脚印究竟通向哪里'),
            onPressed: () => _chooseSpecialEnding('chase'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialEnding() {
    final keptPromise = _specialEnding == 'keep';
    return _PageShell(
      key: const ValueKey('special-ending'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
        children: [
          Icon(
            keptPromise ? Icons.local_activity_rounded : Icons.footprint_rounded,
            color: const Color(0xFFCFCAFF),
            size: 70,
          ),
          const SizedBox(height: 10),
          Text(
            t(keptPromise ? '结局：灯票守夜人' : '结局：墙中脚印'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE7E9FF),
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFF25213A),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFF57527B)),
            ),
            child: Text(
              t(
                keptPromise
                    ? '掌柜整夜没有开门。天亮后，铜钱化成一张黑底银字的灯票，背面写着：“月末子时，鬼市只为守信之人开门。”'
                    : '掌柜推门追出，只见湿脚印一路延伸到客栈外墙，然后笔直地走进砖缝。墙内传来一句很轻的声音：“你不该替镜子开门。”',
              ),
              style: const TextStyle(
                color: Color(0xFFE4E1F6),
                fontSize: 14,
                height: 1.65,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE5DFC7),
              borderRadius: BorderRadius.circular(17),
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
                const SizedBox(height: 5),
                Text(
                  t(keptPromise ? '鬼市灯票' : '墙缝湿印拓片'),
                  style: const TextStyle(
                    color: Color(0xFF2F281F),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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

  bool _sameIds(Iterable<String> left, Iterable<String> right) {
    final a = left.toList(growable: false);
    final b = right.toList(growable: false);
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

enum _PrototypeStage {
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

extension on _CoinKind {
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

  Color get color => switch (this) {
        _CoinKind.gold => const Color(0xFFFFD166),
        _CoinKind.silver => const Color(0xFFD7DCE5),
        _CoinKind.bronze => const Color(0xFFC8834A),
      };

  String get reason => switch (this) {
        _CoinKind.gold => '第一次答对',
        _CoinKind.silver => '第二次答对',
        _CoinKind.bronze => '练习后答对',
      };
}

class _EarnedCoin {
  const _EarnedCoin({required this.challenge, required this.kind});

  final String challenge;
  final _CoinKind kind;
}

class _OrderSentence {
  const _OrderSentence({required this.id, required this.text});

  final String id;
  final String text;
}

class _NightEvent {
  const _NightEvent({required this.id, required this.text});

  final String id;
  final String text;
}

class _PageShell extends StatelessWidget {
  const _PageShell({super.key, required this.child});

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

class _ChallengeShell extends StatelessWidget {
  const _ChallengeShell({
    super.key,
    required this.step,
    required this.title,
    required this.instruction,
    required this.attempts,
    required this.coin,
    required this.feedback,
    required this.child,
    required this.continueLabel,
    required this.onContinue,
    this.explanation,
  });

  final String step;
  final String title;
  final String instruction;
  final int attempts;
  final _CoinKind? coin;
  final String? feedback;
  final String? explanation;
  final Widget child;
  final String continueLabel;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return _PageShell(
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
          Text(
            instruction,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (attempts > 0 && coin == null) ...[
            const SizedBox(height: 6),
            Text(
              '已尝试 $attempts 次',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
          if (feedback != null) ...[
            const SizedBox(height: 10),
            _FeedbackCard(text: feedback!, positive: coin != null),
          ],
          if (coin != null) ...[
            const SizedBox(height: 11),
            _CoinRewardCard(kind: coin!),
          ],
          if (explanation != null) ...[
            const SizedBox(height: 10),
            _LearningExplanationCard(text: explanation!),
          ],
          if (onContinue != null) ...[
            const SizedBox(height: 12),
            _PrimaryButton(
              label: continueLabel,
              icon: Icons.arrow_forward_rounded,
              onPressed: onContinue!,
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardRuleCard extends StatelessWidget {
  const _RewardRuleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1DFB8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          _RewardRuleRow(kind: _CoinKind.gold, text: '第一次答对 · 3 点'),
          Divider(height: 18),
          _RewardRuleRow(kind: _CoinKind.silver, text: '第二次答对 · 2 点'),
          Divider(height: 18),
          _RewardRuleRow(kind: _CoinKind.bronze, text: '第三次或练习后答对 · 1 点'),
        ],
      ),
    );
  }
}

class _RewardRuleRow extends StatelessWidget {
  const _RewardRuleRow({required this.kind, required this.text});

  final _CoinKind kind;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CoinDisc(kind: kind, size: 31),
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
}

class _JourneyPreviewCard extends StatelessWidget {
  const _JourneyPreviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.locked,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: locked ? const Color(0xFF28233A) : const Color(0xFF34261D),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: locked ? const Color(0xFF57527B) : const Color(0xFF76543A),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: locked ? const Color(0xFFC8C3F0) : const Color(0xFFFFD166)),
          const SizedBox(width: 11),
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
                const SizedBox(height: 3),
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
}

class _SentenceTile extends StatelessWidget {
  const _SentenceTile({
    super.key,
    required this.index,
    required this.text,
    required this.enabled,
    required this.onUp,
    required this.onDown,
  });

  final int index;
  final String text;
  final bool enabled;
  final VoidCallback onUp;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(11, 9, 6, 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5C6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD2AA69)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xFF9C3A30),
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
              style: const TextStyle(
                color: Color(0xFF34291F),
                height: 1.35,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                key: ValueKey<String>('paragraph-up-$index'),
                onPressed: enabled && index > 0 ? onUp : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              IconButton(
                key: ValueKey<String>('paragraph-down-$index'),
                onPressed: enabled ? onDown : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
          const Icon(Icons.drag_handle_rounded, color: Color(0xFF78634F)),
        ],
      ),
    );
  }
}

class _GrammarExplanationCard extends StatelessWidget {
  const _GrammarExplanationCard({
    required this.text,
    required this.original,
    required this.corrected,
  });

  final String Function(String) text;
  final String original;
  final String corrected;

  @override
  Widget build(BuildContext context) {
    String t(String value) => text(value);
    return Container(
      key: const ValueKey('grammar-explanation'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0DF),
        borderRadius: BorderRadius.circular(17),
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
          _ExplanationRow(label: t('病句类型'), value: t('成分残缺：主语缺失')),
          _ExplanationRow(label: t('原句'), value: t(original)),
          _ExplanationRow(label: t('修改后'), value: corrected),
          _ExplanationRow(
            label: t('错误原因'),
            value: t('“通过……”把“游览长廊”变成介词结构；“使……”又引出结果。两个结构叠在一起后，整句话没有一个明确主语。'),
          ),
          _ExplanationRow(
            label: t('修改原则'),
            value: t('删除“使”，让“游客”直接成为主语。也可以把开头改成“游览长廊时”，再由“游客”完成动作。'),
          ),
          _ExplanationRow(
            label: t('记忆方法'),
            value: t('看到“通过……使……”时，要检查句子里是否还剩下明确主语。'),
          ),
        ],
      ),
    );
  }
}

class _ExplanationRow extends StatelessWidget {
  const _ExplanationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
}

class _ParagraphContextCard extends StatelessWidget {
  const _ParagraphContextCard({
    required this.before,
    required this.blank,
    required this.after,
  });

  final String before;
  final String blank;
  final String after;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5C6),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFD2AA69)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(before, style: const TextStyle(height: 1.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC9864C)),
            ),
            child: Text(
              blank,
              key: const ValueKey('fragment-assembled-text'),
              style: const TextStyle(
                color: Color(0xFF8B3B31),
                height: 1.4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(after, style: const TextStyle(height: 1.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _CoinRewardCard extends StatelessWidget {
  const _CoinRewardCard({required this.kind});

  final _CoinKind kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kind.color.withValues(alpha: .7)),
      ),
      child: Row(
        children: [
          _CoinDisc(kind: kind, size: 49),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '获得${kind.label}',
                  style: TextStyle(
                    color: kind.color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${kind.reason} · ${kind.points} 点旅程值',
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
}

class _CoinDisc extends StatelessWidget {
  const _CoinDisc({required this.kind, required this.size});

  final _CoinKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: kind.color,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF7E5A26), width: 2),
        boxShadow: [
          BoxShadow(
            color: kind.color.withValues(alpha: .28),
            blurRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        switch (kind) {
          _CoinKind.gold => '金',
          _CoinKind.silver => '银',
          _CoinKind.bronze => '铜',
        },
        style: const TextStyle(
          color: Color(0xFF5F3A17),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _LearningExplanationCard extends StatelessWidget {
  const _LearningExplanationCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF253B31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF547864)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Color(0xFFAED8B9)),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFDFF3E4),
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.text, required this.positive});

  final String text;
  final bool positive;

  @override
  Widget build(BuildContext context) {
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
}

class _EarnedCoinTile extends StatelessWidget {
  const _EarnedCoinTile({required this.coin, required this.text});

  final _EarnedCoin coin;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF34261D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _CoinDisc(kind: coin.kind, size: 43),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text(coin.challenge),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text('${coin.kind.label} · ${coin.kind.points} 点 · ${coin.kind.reason}'),
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
}

class _RareCoinCard extends StatelessWidget {
  const _RareCoinCard({required this.text});

  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
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
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFF4B5573), size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text('额外获得：瑞银币'),
                  style: const TextStyle(
                    color: Color(0xFF30384F),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text('三关全部第一次答对的稀有收藏币'),
                  style: const TextStyle(
                    color: Color(0xFF505B77),
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
}

class _UnlockCard extends StatelessWidget {
  const _UnlockCard({
    required this.text,
    required this.points,
    required this.unlocked,
    required this.onUnlock,
  });

  final String Function(String) text;
  final int points;
  final bool unlocked;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final canUnlock = points >= 3;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF25213A),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFF57527B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight_round, color: Color(0xFFC9C4FA), size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text('异境录 · 聊斋夜客'),
                      style: const TextStyle(
                        color: Color(0xFFE9E7FF),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text('解锁需要 3 点 · 当前 $points 点'),
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
          const SizedBox(height: 10),
          Text(
            text('钱币会保留在收藏册中，旅程值负责打开隐藏世界。这个原型完成三关后一定能够进入体验。'),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11.5,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 11),
          FilledButton.icon(
            key: const ValueKey('unlock-special-journey'),
            onPressed: canUnlock ? onUnlock : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6E5CA5),
              foregroundColor: Colors.white,
            ),
            icon: Icon(unlocked ? Icons.lock_open_rounded : Icons.lock_rounded),
            label: Text(
              text(unlocked ? '进入聊斋夜客' : '用旅程值解锁'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _NightEventTile extends StatelessWidget {
  const _NightEventTile({
    super.key,
    required this.index,
    required this.text,
    required this.onUp,
    required this.onDown,
  });

  final int index;
  final String text;
  final VoidCallback onUp;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(11, 9, 6, 9),
      decoration: BoxDecoration(
        color: const Color(0xFF2A263D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF59547C)),
      ),
      child: Row(
        children: [
          Text(
            '${index + 1}',
            style: const TextStyle(
              color: Color(0xFFCCC7F5),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE5E2F5),
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                key: ValueKey<String>('night-up-$index'),
                onPressed: index > 0 ? onUp : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
                color: const Color(0xFFCCC7F5),
              ),
              IconButton(
                key: ValueKey<String>('night-down-$index'),
                onPressed: onDown,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                color: const Color(0xFFCCC7F5),
              ),
            ],
          ),
          const Icon(Icons.drag_handle_rounded, color: Color(0xFF8580A8)),
        ],
      ),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF29253D),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFCFCAFF), size: 33),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE9E7FF),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
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
