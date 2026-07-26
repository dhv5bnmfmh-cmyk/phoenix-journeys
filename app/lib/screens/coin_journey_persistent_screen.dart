import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _grammarModel = '通过游览长廊，游客可以看到不同的风景。';

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

  static const _challengeOrder = <String>[
    '短文复原',
    '语病修复',
    '补回句子',
  ];

  final TextEditingController _grammarController = TextEditingController();
  final List<_Piece> _paragraphAnswer = <_Piece>[];
  final List<_Piece> _fragmentAnswer = <_Piece>[];
  final List<_Piece> _nightAnswer = <_Piece>[];
  final Map<String, _CoinKind> _coins = <String, _CoinKind>{};

  _Stage _stage = _Stage.intro;
  _CoinKind? _currentCoin;
  String? _feedback;
  String? _specialEnding;
  int _paragraphAttempts = 0;
  int _grammarAttempts = 0;
  int _fragmentAttempts = 0;
  int _nightAttempts = 0;
  bool _resolved = false;
  bool _rareCoin = false;
  bool _loadingRewards = true;

  String t(String value) => widget.text(value);

  @override
  void initState() {
    super.initState();
    _grammarController.text = t(_wrongGrammar);
    _loadRewards();
  }

  @override
  void dispose() {
    _grammarController.dispose();
    super.dispose();
  }

  int get _journeyPoints => _coins.values.fold<int>(
        0,
        (total, kind) => total + kind.points,
      );

  bool get _allGold =>
      _challengeOrder.every((challenge) => _coins[challenge] == _CoinKind.gold);

  Future<void> _loadRewards() async {
    if (!widget.persistRewards) {
      if (mounted) setState(() => _loadingRewards = false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_rewardKey) ?? const <String>[];
    final restored = <String, _CoinKind>{};
    for (final record in stored) {
      final divider = record.lastIndexOf('|');
      if (divider <= 0 || divider == record.length - 1) continue;
      final challenge = record.substring(0, divider);
      final kind = _CoinKind.fromStorage(record.substring(divider + 1));
      if (kind != null) restored[challenge] = kind;
    }

    if (!mounted) return;
    setState(() {
      _coins
        ..clear()
        ..addAll(restored);
      _rareCoin = prefs.getBool(_rareKey) ?? false;
      _loadingRewards = false;
    });
  }

  Future<void> _persistRewards() async {
    if (!widget.persistRewards) return;
    final prefs = await SharedPreferences.getInstance();
    final records = _coins.entries
        .map((entry) => '${entry.key}|${entry.value.storageValue}')
        .toList()
      ..sort();
    await Future.wait([
      prefs.setStringList(_rewardKey, records),
      prefs.setBool(_rareKey, _rareCoin),
    ]);
  }

  _CoinKind _kindForAttempt(int attempt) {
    if (attempt <= 1) return _CoinKind.gold;
    if (attempt == 2) return _CoinKind.silver;
    return _CoinKind.bronze;
  }

  Future<void> _award(String challenge, int attempt) async {
    final earned = _kindForAttempt(attempt);
    final previous = _coins[challenge];
    setState(() {
      if (previous == null || earned.rank > previous.rank) {
        _coins[challenge] = earned;
      }
      _currentCoin = earned;
      _resolved = true;
      if (_allGold) _rareCoin = true;
    });
    await _persistRewards();
  }

  bool _sameOrder(List<_Piece> answer, List<_Piece> solution) {
    if (answer.length != solution.length) return false;
    for (var index = 0; index < answer.length; index++) {
      if (answer[index].id != solution[index].id) return false;
    }
    return true;
  }

  void _selectPiece(List<_Piece> answer, _Piece piece) {
    if (_resolved || answer.any((item) => item.id == piece.id)) return;
    setState(() {
      answer.add(piece);
      _feedback = null;
    });
  }

  void _undoPiece(List<_Piece> answer) {
    if (_resolved || answer.isEmpty) return;
    setState(() {
      answer.removeLast();
      _feedback = null;
    });
  }

  Future<void> _checkParagraph() async {
    if (_resolved) return;
    final attempt = _paragraphAttempts + 1;
    final correct = _sameOrder(_paragraphAnswer, _paragraphSolution);
    setState(() {
      _paragraphAttempts = attempt;
      _feedback = correct
          ? '段落已经恢复。先介绍整体位置，再写游人的行动，最后补充廊窗与借景细节。'
          : '先找介绍长廊整体位置的句子，再安排游人的行动，最后放观察细节。';
      if (!correct) _paragraphAnswer.clear();
    });
    if (correct) await _award('短文复原', attempt);
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

  Future<void> _checkGrammar() async {
    if (_resolved) return;
    final attempt = _grammarAttempts + 1;
    final answer = _grammarController.text.trim();
    final correct = _acceptedGrammar(answer);
    setState(() {
      _grammarAttempts = attempt;
      if (correct) {
        _feedback = null;
      } else if (answer.isEmpty) {
        _feedback = '先修改句子。重点检查“通过……”和“使……”同时出现后，谁是句子的主语。';
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
    final attempt = _fragmentAttempts + 1;
    final correct = _sameOrder(_fragmentAnswer, _fragmentSolution);
    setState(() {
      _fragmentAttempts = attempt;
      _feedback = correct
          ? '“每走一段”承接移动，“都会发生变化”说明反复出现的结果。'
          : '先说时间或条件，再说变化的对象，最后说明结果。';
      if (!correct) _fragmentAnswer.clear();
    });
    if (correct) await _award('补回句子', attempt);
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

  void _checkNightOrder() {
    final attempt = _nightAttempts + 1;
    final correct = _sameOrder(_nightAnswer, _nightSolution);
    setState(() {
      _nightAttempts = attempt;
      if (correct) {
        _stage = _Stage.specialDecision;
        _feedback = null;
      } else {
        _feedback = '敲门应最早发生，鸡鸣和枯叶属于天亮后的结果。';
        _nightAnswer.clear();
      }
    });
  }

  void _restartSession() {
    setState(() {
      _stage = _Stage.intro;
      _currentCoin = null;
      _feedback = null;
      _specialEnding = null;
      _paragraphAttempts = 0;
      _grammarAttempts = 0;
      _fragmentAttempts = 0;
      _nightAttempts = 0;
      _resolved = false;
      _paragraphAnswer.clear();
      _fragmentAnswer.clear();
      _nightAnswer.clear();
      _grammarController.text = t(_wrongGrammar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: switch (_stage) {
        _Stage.intro => _buildIntro(),
        _Stage.paragraph => _buildParagraph(),
        _Stage.grammar => _buildGrammar(),
        _Stage.fragments => _buildFragments(),
        _Stage.summary => _buildSummary(),
        _Stage.specialIntro => _buildSpecialIntro(),
        _Stage.specialOrder => _buildSpecialOrder(),
        _Stage.specialDecision => _buildSpecialDecision(),
        _Stage.specialEnding => _buildSpecialEnding(),
      },
    );
  }

  Widget _buildIntro() {
    final unlocked = _journeyPoints >= 3;
    return _Page(
      key: const ValueKey('coin-journey-intro'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          const Icon(
            Icons.monetization_on_rounded,
            size: 68,
            color: Color(0xFFFFD166),
          ),
          const SizedBox(height: 9),
          _Title(t('学习闯关 · 钱币收藏 · 异境解锁')),
          const SizedBox(height: 8),
          _BodyText(
            t('完成中文挑战，根据答对次数获得金币、银币或铜币。收集旅程值，就能打开神话与志怪世界。'),
            centered: true,
          ),
          const SizedBox(height: 14),
          if (_loadingRewards)
            const Center(child: CircularProgressIndicator())
          else
            _CollectionStatus(
              count: _coins.length + (_rareCoin ? 1 : 0),
              points: _journeyPoints,
              text: widget.text,
            ),
          const SizedBox(height: 13),
          _RewardRules(text: widget.text),
          const SizedBox(height: 13),
          _JourneyCard(
            title: t('普通挑战：颐和园'),
            subtitle: t('短文复原、语病修复、补回句子'),
            icon: Icons.account_balance_rounded,
          ),
          const SizedBox(height: 9),
          _JourneyCard(
            title: t('隐藏旅程：聊斋夜客'),
            subtitle: unlocked ? t('已经解锁，可以直接进入') : t('收集至少 3 点旅程值'),
            icon: Icons.nightlight_round,
            locked: !unlocked,
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            key: const ValueKey('coin-start-challenges'),
            label: t('开始三关挑战'),
            icon: Icons.play_arrow_rounded,
            onPressed: _loadingRewards
                ? null
                : () => setState(() => _stage = _Stage.paragraph),
          ),
          if (unlocked) ...[
            const SizedBox(height: 9),
            OutlinedButton.icon(
              key: const ValueKey('enter-persisted-special'),
              onPressed: () => setState(() => _stage = _Stage.specialIntro),
              icon: const Icon(Icons.lock_open_rounded),
              label: Text(t('进入已解锁的聊斋夜客')),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParagraph() {
    return _ChallengePage(
      key: const ValueKey('coin-paragraph-challenge'),
      step: t('第 1 关 / 3'),
      title: t('短文复原'),
      instruction: t('按照合理顺序点击句子，把它们拼回一段完整短文。'),
      attempts: _paragraphAttempts,
      answer: _AnswerBox(
        key: const ValueKey('paragraph-answer'),
        pieces: _paragraphAnswer,
        placeholder: t('依次点击下方句子'),
        text: widget.text,
      ),
      choices: _ChoiceGrid(
        pieces: _paragraphChoices,
        selected: _paragraphAnswer,
        keyPrefix: 'paragraph-choice',
        text: widget.text,
        onSelected: (piece) => _selectPiece(_paragraphAnswer, piece),
      ),
      onUndo: _paragraphAnswer.isEmpty ? null : () => _undoPiece(_paragraphAnswer),
      onSubmit: _resolved ? null : _checkParagraph,
      feedback: _feedback == null ? null : t(_feedback!),
      reward: _currentCoin,
      explanation: _resolved
          ? t('正确逻辑是“整体位置 → 游人行动 → 廊窗细节 → 借景效果”。读者先知道长廊在哪里，再跟随游人移动。')
          : null,
      continueLabel: t('进入语病修复'),
      onContinue: _resolved ? () => _continueTo(_Stage.grammar) : null,
      text: widget.text,
    );
  }

  Widget _buildGrammar() {
    return _ChallengePage(
      key: const ValueKey('coin-grammar-challenge'),
      step: t('第 2 关 / 3'),
      title: t('找出并修改语病'),
      instruction: t('直接编辑病句。改对后会说明病句类型、错误原因、修改原则和记忆方法。'),
      attempts: _grammarAttempts,
      answer: Column(
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
          if (_resolved) ...[
            const SizedBox(height: 11),
            _GrammarExplanation(
              original: t(_wrongGrammar),
              corrected: _grammarController.text.trim(),
              text: widget.text,
            ),
          ],
        ],
      ),
      onSubmit: _resolved ? null : _checkGrammar,
      feedback: _feedback == null ? null : t(_feedback!),
      reward: _currentCoin,
      continueLabel: t('进入补句挑战'),
      onContinue: _resolved ? () => _continueTo(_Stage.fragments) : null,
      text: widget.text,
    );
  }

  Widget _buildFragments() {
    return _ChallengePage(
      key: const ValueKey('coin-fragment-challenge'),
      step: t('第 3 关 / 3'),
      title: t('补回失落句子'),
      instruction: t('碎片已经被打乱。按照正确语序点击，补回能够连接前后文的句子。'),
      attempts: _fragmentAttempts,
      answer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t('游客沿着长廊慢慢前进。')),
          const SizedBox(height: 7),
          _AnswerBox(
            key: const ValueKey('fragment-answer'),
            pieces: _fragmentAnswer,
            placeholder: t('依次点击下方句子碎片'),
            text: widget.text,
            inline: true,
          ),
          const SizedBox(height: 7),
          Text(t('因此，长廊不仅是通道，也是一条不断变化的观景路线。')),
        ],
      ),
      choices: _ChoiceGrid(
        pieces: _fragmentChoices,
        selected: _fragmentAnswer,
        keyPrefix: 'fragment-choice',
        text: widget.text,
        onSelected: (piece) => _selectPiece(_fragmentAnswer, piece),
      ),
      onUndo: _fragmentAnswer.isEmpty ? null : () => _undoPiece(_fragmentAnswer),
      onSubmit: _resolved ? null : _checkFragments,
      feedback: _feedback == null ? null : t(_feedback!),
      reward: _currentCoin,
      explanation: _resolved
          ? t('完整句子是：“每走一段，窗外的景色都会发生变化。”它承接“沿着长廊前进”，也解释为什么观景路线不断变化。')
          : null,
      continueLabel: t('查看钱币与异境'),
      onContinue: _resolved ? () => _continueTo(_Stage.summary) : null,
      text: widget.text,
    );
  }

  Widget _buildSummary() {
    return _Page(
      key: const ValueKey('coin-summary'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFD166),
            size: 60,
          ),
          const SizedBox(height: 8),
          _Title(t('颐和园挑战完成')),
          const SizedBox(height: 6),
          _BodyText(
            t('系统保留每一关取得过的最高品质钱币。再次练习不会把金币降成银币或铜币。'),
            centered: true,
          ),
          const SizedBox(height: 13),
          for (final challenge in _challengeOrder)
            if (_coins[challenge] case final kind?) ...[
              _CoinTile(challenge: t(challenge), kind: kind, text: widget.text),
              const SizedBox(height: 8),
            ],
          if (_rareCoin) ...[
            const SizedBox(height: 3),
            _RareCoin(text: widget.text),
          ],
          const SizedBox(height: 13),
          _CollectionStatus(
            count: _coins.length + (_rareCoin ? 1 : 0),
            points: _journeyPoints,
            text: widget.text,
          ),
          const SizedBox(height: 13),
          _UnlockCard(
            points: _journeyPoints,
            text: widget.text,
            onEnter: () => setState(() => _stage = _Stage.specialIntro),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialIntro() {
    return _Page(
      key: const ValueKey('special-journey-intro'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
        children: [
          const Icon(Icons.nightlight_round, color: Color(0xFFB9C7FF), size: 64),
          const SizedBox(height: 8),
          _Title(t('异境录 · 聊斋夜客'), pale: true),
          const SizedBox(height: 10),
          _NightStory(
            text: t('子夜，一名没有影子的旅客走进湖边客栈。他把一枚湿漉漉的铜钱放在柜台上，只说：“天亮前，别让镜子照见我。”第二天，掌柜留下的夜记却被风吹乱了。'),
          ),
          const SizedBox(height: 13),
          _BodyText(
            t('这不是普通景点介绍。你要拼回一段志怪夜记，并决定掌柜是否守住承诺。'),
            centered: true,
          ),
          const SizedBox(height: 16),
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

  Widget _buildSpecialOrder() {
    return _Page(
      key: const ValueKey('special-order-challenge'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _Title(t('拼回失落的夜记'), pale: true),
          const SizedBox(height: 6),
          _BodyText(t('按照发生顺序点击四段记录。')),
          const SizedBox(height: 12),
          _AnswerBox(
            key: const ValueKey('night-answer'),
            pieces: _nightAnswer,
            placeholder: t('依次点击下方夜记'),
            text: widget.text,
            dark: true,
          ),
          const SizedBox(height: 11),
          _ChoiceGrid(
            pieces: _nightChoices,
            selected: _nightAnswer,
            keyPrefix: 'night-choice',
            text: widget.text,
            dark: true,
            onSelected: (piece) => _selectPiece(_nightAnswer, piece),
          ),
          const SizedBox(height: 9),
          OutlinedButton.icon(
            onPressed: _nightAnswer.isEmpty ? null : () => _undoPiece(_nightAnswer),
            icon: const Icon(Icons.undo_rounded),
            label: Text(t('撤回最后一段')),
          ),
          if (_feedback != null) ...[
            const SizedBox(height: 9),
            _Feedback(text: t(_feedback!), positive: false),
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

  Widget _buildSpecialDecision() {
    return _Page(
      key: const ValueKey('special-decision'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
        children: [
          const Icon(
            Icons.door_front_door_rounded,
            color: Color(0xFFCEC8FF),
            size: 62,
          ),
          const SizedBox(height: 8),
          _Title(t('鸡鸣之前，门外响起第三次敲门声'), pale: true),
          const SizedBox(height: 8),
          _BodyText(
            t('夜客要求掌柜不要开门，可是门缝下正慢慢渗进一串湿脚印。'),
            centered: true,
          ),
          const SizedBox(height: 17),
          _DecisionCard(
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
          _DecisionCard(
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

  Widget _buildSpecialEnding() {
    final kept = _specialEnding == 'keep';
    return _Page(
      key: const ValueKey('special-ending'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
        children: [
          Icon(
            kept ? Icons.local_activity_rounded : Icons.directions_walk_rounded,
            color: const Color(0xFFCFCAFF),
            size: 68,
          ),
          const SizedBox(height: 9),
          _Title(t(kept ? '结局：灯票守夜人' : '结局：墙中脚印'), pale: true),
          const SizedBox(height: 10),
          _NightStory(
            text: t(
              kept
                  ? '掌柜整夜没有开门。天亮后，铜钱化成一张黑底银字的灯票，背面写着：“月末子时，鬼市只为守信之人开门。”'
                  : '掌柜推门追出，只见湿脚印一路延伸到客栈外墙，然后笔直地走进砖缝。墙内传来一句很轻的声音：“你不该替镜子开门。”',
            ),
          ),
          const SizedBox(height: 13),
          _Collectible(
            name: t(kept ? '鬼市灯票' : '墙缝湿印拓片'),
            text: widget.text,
          ),
          const SizedBox(height: 15),
          _PrimaryButton(
            key: const ValueKey('coin-prototype-restart'),
            label: t('返回钱币收藏'),
            icon: Icons.replay_rounded,
            onPressed: _restartSession,
          ),
        ],
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

enum _CoinKind {
  bronze,
  silver,
  gold;

  static _CoinKind? fromStorage(String value) {
    for (final kind in values) {
      if (kind.storageValue == value) return kind;
    }
    return null;
  }

  String get storageValue => name;
  int get rank => index + 1;
  int get points => switch (this) {
        bronze => 1,
        silver => 2,
        gold => 3,
      };

  String get label => switch (this) {
        bronze => '铜币',
        silver => '银币',
        gold => '金币',
      };

  String get mark => switch (this) {
        bronze => '铜',
        silver => '银',
        gold => '金',
      };

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

class _Title extends StatelessWidget {
  const _Title(this.text, {this.pale = false});

  final String text;
  final bool pale;

  @override
  Widget build(BuildContext context) {
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
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text, {this.centered = false});

  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: centered ? TextAlign.center : TextAlign.start,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12.5,
        height: 1.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ChallengePage extends StatelessWidget {
  const _ChallengePage({
    super.key,
    required this.step,
    required this.title,
    required this.instruction,
    required this.attempts,
    required this.answer,
    required this.onSubmit,
    required this.continueLabel,
    required this.onContinue,
    required this.text,
    this.choices,
    this.onUndo,
    this.feedback,
    this.reward,
    this.explanation,
  });

  final String step;
  final String title;
  final String instruction;
  final int attempts;
  final Widget answer;
  final Widget? choices;
  final VoidCallback? onUndo;
  final Future<void> Function()? onSubmit;
  final String? feedback;
  final _CoinKind? reward;
  final String? explanation;
  final String continueLabel;
  final VoidCallback? onContinue;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return _Page(
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
          _BodyText(instruction),
          if (attempts > 0 && reward == null) ...[
            const SizedBox(height: 5),
            Text(
              text('已尝试 $attempts 次'),
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 13),
          answer,
          if (choices != null) ...[
            const SizedBox(height: 11),
            choices!,
          ],
          if (onUndo != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onUndo,
              icon: const Icon(Icons.undo_rounded),
              label: Text(text('撤回最后一个')),
            ),
          ],
          if (onSubmit != null) ...[
            const SizedBox(height: 9),
            _PrimaryButton(
              key: ValueKey<String>('${title.hashCode}-submit'),
              label: text('提交答案'),
              icon: Icons.check_circle_rounded,
              onPressed: onSubmit,
            ),
          ],
          if (feedback != null) ...[
            const SizedBox(height: 9),
            _Feedback(text: feedback!, positive: reward != null),
          ],
          if (reward != null) ...[
            const SizedBox(height: 9),
            _CoinReward(kind: reward!, text: text),
          ],
          if (explanation != null) ...[
            const SizedBox(height: 9),
            _LearningCard(explanation!),
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
}

class _AnswerBox extends StatelessWidget {
  const _AnswerBox({
    super.key,
    required this.pieces,
    required this.placeholder,
    required this.text,
    this.inline = false,
    this.dark = false,
  });

  final List<_Piece> pieces;
  final String placeholder;
  final String Function(String) text;
  final bool inline;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final content = pieces.isEmpty
        ? placeholder
        : inline
            ? pieces.map((piece) => text(piece.text)).join()
            : pieces
                .asMap()
                .entries
                .map((entry) => '${entry.key + 1}. ${text(entry.value.text)}')
                .join('\n');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF25213A) : const Color(0xFFF4E5C6),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: dark ? const Color(0xFF57527B) : const Color(0xFFD2AA69),
        ),
      ),
      child: Text(
        content,
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
}

class _ChoiceGrid extends StatelessWidget {
  const _ChoiceGrid({
    required this.pieces,
    required this.selected,
    required this.keyPrefix,
    required this.text,
    required this.onSelected,
    this.dark = false,
  });

  final List<_Piece> pieces;
  final List<_Piece> selected;
  final String keyPrefix;
  final String Function(String) text;
  final ValueChanged<_Piece> onSelected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < pieces.length; index++) ...[
          _ChoiceCard(
            key: ValueKey<String>('$keyPrefix-${pieces[index].id}'),
            positionKey: ValueKey<String>('$keyPrefix-position-$index'),
            text: text(pieces[index].text),
            selected: selected.any((item) => item.id == pieces[index].id),
            dark: dark,
            onTap: () => onSelected(pieces[index]),
          ),
          if (index != pieces.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    super.key,
    required this.positionKey,
    required this.text,
    required this.selected,
    required this.dark,
    required this.onTap,
  });

  final Key positionKey;
  final String text;
  final bool selected;
  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: positionKey,
      color: dark ? const Color(0xFF2A263D) : const Color(0xFFF4E5C6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.add_circle_outline,
                color: dark ? const Color(0xFFCCC7F5) : const Color(0xFF9C3A30),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
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
    );
  }
}

class _GrammarExplanation extends StatelessWidget {
  const _GrammarExplanation({
    required this.original,
    required this.corrected,
    required this.text,
  });

  final String original;
  final String corrected;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
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
            text('为什么这样改？'),
            style: const TextStyle(
              color: Color(0xFF315B32),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          _ExplanationLine(label: text('病句类型'), value: text('成分残缺：主语缺失')),
          _ExplanationLine(label: text('原句'), value: original),
          _ExplanationLine(label: text('修改后'), value: corrected),
          _ExplanationLine(
            label: text('错误原因'),
            value: text('“通过……”把“游览长廊”变成介词结构；“使……”又引出结果。两个结构叠在一起后，整句话没有明确主语。'),
          ),
          _ExplanationLine(
            label: text('修改原则'),
            value: text('删除“使”，让“游客”直接成为主语。也可以把开头改成“游览长廊时”。'),
          ),
          _ExplanationLine(
            label: text('记忆方法'),
            value: text('看到“通过……使……”时，要检查句子里是否还剩下明确主语。'),
          ),
        ],
      ),
    );
  }
}

class _ExplanationLine extends StatelessWidget {
  const _ExplanationLine({required this.label, required this.value});

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

class _Feedback extends StatelessWidget {
  const _Feedback({required this.text, required this.positive});

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

class _LearningCard extends StatelessWidget {
  const _LearningCard(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
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
}

class _RewardRules extends StatelessWidget {
  const _RewardRules({required this.text});

  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1DFB8),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _Rule(kind: _CoinKind.gold, text: text),
          const Divider(height: 18),
          _Rule(kind: _CoinKind.silver, text: text),
          const Divider(height: 18),
          _Rule(kind: _CoinKind.bronze, text: text),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.kind, required this.text});

  final _CoinKind kind;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CoinDisc(kind: kind, size: 31, text: text),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text('${kind.reason} · ${kind.points} 点'),
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

class _CoinDisc extends StatelessWidget {
  const _CoinDisc({required this.kind, required this.size, required this.text});

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

class _CoinReward extends StatelessWidget {
  const _CoinReward({required this.kind, required this.text});

  final _CoinKind kind;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>('coin-reward-${kind.storageValue}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2B1E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kind.color),
      ),
      child: Row(
        children: [
          _CoinDisc(kind: kind, size: 47, text: text),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text('获得${kind.label}\n${kind.reason} · ${kind.points} 点旅程值'),
              style: TextStyle(
                color: kind.color,
                height: 1.4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinTile extends StatelessWidget {
  const _CoinTile({required this.challenge, required this.kind, required this.text});

  final String challenge;
  final _CoinKind kind;
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
          _CoinDisc(kind: kind, size: 42, text: text),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$challenge\n${text('${kind.label} · ${kind.points} 点 · ${kind.reason}')}',
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RareCoin extends StatelessWidget {
  const _RareCoin({required this.text});

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
      child: Text(
        text('额外获得：瑞银币\n三关全部第一次答对的稀有收藏币'),
        style: const TextStyle(
          color: Color(0xFF30384F),
          height: 1.4,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CollectionStatus extends StatelessWidget {
  const _CollectionStatus({required this.count, required this.points, required this.text});

  final int count;
  final int points;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('coin-collection-status'),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF1DFB8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text('已收藏 $count 枚钱币 · $points 点旅程值'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF6F2925),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.locked = false,
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: locked ? const Color(0xFFC8C3F0) : const Color(0xFFFFD166)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600),
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

class _UnlockCard extends StatelessWidget {
  const _UnlockCard({required this.points, required this.text, required this.onEnter});

  final int points;
  final String Function(String) text;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
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
          Text(
            text('异境录 · 聊斋夜客\n解锁需要 3 点 · 当前 $points 点'),
            style: const TextStyle(
              color: Color(0xFFE9E7FF),
              height: 1.45,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            key: const ValueKey('unlock-special-journey'),
            onPressed: points >= 3 ? onEnter : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6E5CA5),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.lock_open_rounded),
            label: Text(text('用旅程值进入')),
          ),
        ],
      ),
    );
  }
}

class _NightStory extends StatelessWidget {
  const _NightStory({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
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
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
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
                    Text(title, style: const TextStyle(color: Color(0xFFE9E7FF), fontWeight: FontWeight.w900)),
                    Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
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

class _Collectible extends StatelessWidget {
  const _Collectible({required this.name, required this.text});

  final String name;
  final String Function(String) text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5DFC7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(text('异境收藏品'), style: const TextStyle(color: Color(0xFF6C2E2A), fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(color: Color(0xFF2F281F), fontSize: 19, fontWeight: FontWeight.w900)),
        ],
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
  final Future<void> Function()? onPressed;

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
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
