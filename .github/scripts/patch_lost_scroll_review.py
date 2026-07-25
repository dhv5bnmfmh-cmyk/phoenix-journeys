from pathlib import Path

SCREEN = Path('app/lib/screens/lost_scroll_prototype_screen.dart')
ANALYSIS = Path('app/analysis_options.yaml')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


text = SCREEN.read_text(encoding='utf-8')

text = replace_once(
    text,
    "import '../theme/phoenix_theme.dart';\n\nclass LostScrollPrototypeScreen",
    "import '../theme/phoenix_theme.dart';\n\nString _identityText(String text) => text;\n\nclass LostScrollPrototypeScreen",
    'identity translator',
)

text = replace_once(
    text,
    """            title: const Text(
              'Phoenix · 失落画卷',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),""",
    """            title: Text(
              state.displayText('Phoenix · 失落画卷'),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),""",
    'app bar translation',
)

text = replace_once(
    text,
    "child: LostScrollGame(learnedWords: state.savedWords),",
    """child: LostScrollGame(
              learnedWords: state.savedWords,
              displayText: state.displayText,
            ),""",
    'game translator wiring',
)

text = replace_once(
    text,
    """    this.learnedWords = const <String>{},
    this.completed = false,
    this.onCompleted,""",
    """    this.learnedWords = const <String>{},
    this.completed = false,
    this.onCompleted,
    this.displayText = _identityText,""",
    'constructor translator',
)

text = replace_once(
    text,
    """  final bool completed;
  final VoidCallback? onCompleted;""",
    """  final bool completed;
  final VoidCallback? onCompleted;
  final String Function(String) displayText;""",
    'translator field',
)

text = replace_once(
    text,
    """  bool get _isFinished => !_replaying && (widget.completed || _finished);
  _ScrollScene get _scene => _scenes[_sceneIndex];""",
    """  bool get _isFinished => !_replaying && (widget.completed || _finished);
  _ScrollScene get _scene => _scenes[_sceneIndex];
  String _t(String text) => widget.displayText(text);""",
    'translator helper',
)

text = replace_once(
    text,
    """  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: CustomPaint(painter: _SilkBackdropPainter())),
        AnimatedBuilder(
          animation: Listenable.merge([
            _ambientController,
            _revealController,
          ]),
          builder: (context, _) {
            return _isFinished
                ? _buildFinished(context)
                : _buildGame(context);
          },
        ),
      ],
    );
  }""",
    """  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: CustomPaint(painter: _SilkBackdropPainter()),
        ),
        _isFinished ? _buildFinished(context) : _buildGame(context),
      ],
    );
  }""",
    'top-level animation rebuild',
)

text = replace_once(
    text,
    """              Text(
                '修复失落画卷',""",
    """              Text(
                _t('修复失落画卷'),""",
    'game title translation',
)

text = replace_once(
    text,
    """              const Text(
                '看缺口，选一个已学知识，小凰会立刻把它写回画卷。',
                textAlign: TextAlign.center,
                style: TextStyle(""",
    """              Text(
                _t('看缺口，选一个已学知识，小凰会立刻把它写回画卷。'),
                textAlign: TextAlign.center,
                style: const TextStyle(""",
    'game subtitle translation',
)

text = replace_once(
    text,
    """              SizedBox(
                height: compact ? 190 : 225,
                child: CustomPaint(
                  painter: _LostScrollPainter(
                    restoredCount: _restoredCount,
                    activeReveal: _revealController.value,
                    ambient: _ambientController.value,
                  ),
                ),
              ),""",
    """              SizedBox(
                height: compact ? 190 : 225,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _ambientController,
                    _revealController,
                  ]),
                  builder: (context, _) => CustomPaint(
                    painter: _LostScrollPainter(
                      restoredCount: _restoredCount,
                      activeReveal: _revealController.value,
                      ambient: _ambientController.value,
                    ),
                  ),
                ),
              ),""",
    'game painter animation scope',
)

text = replace_once(
    text,
    """                    : _HintCard(
                        key: ValueKey<String>('hint-$_sceneIndex'),
                        text: _scene.hint,
                      ),""",
    """                    : _HintCard(
                        key: ValueKey<String>('hint-$_sceneIndex'),
                        text: _t('小凰提示：${_scene.hint}'),
                      ),""",
    'hint translation',
)

text = replace_once(
    text,
    """          SizedBox.square(
            dimension: compact ? 54 : 62,
            child: CustomPaint(
              painter: _PhoenixPainter(progress: _ambientController.value),
            ),
          ),""",
    """          SizedBox.square(
            dimension: compact ? 54 : 62,
            child: AnimatedBuilder(
              animation: _ambientController,
              builder: (context, _) => CustomPaint(
                painter: _PhoenixPainter(progress: _ambientController.value),
              ),
            ),
          ),""",
    'guide phoenix animation scope',
)

text = replace_once(
    text,
    """          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '小凰画师',
                  style: TextStyle(
                    color: Color(0xFFFFE7B7),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '“别背规则。找到能修好眼前缺口的知识就行。”',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),""",
    """          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('小凰画师'),
                  style: const TextStyle(
                    color: Color(0xFFFFE7B7),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _t('“别背规则。找到能修好眼前缺口的知识就行。”'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),""",
    'guide copy translation',
)

text = replace_once(
    text,
    """        Text(
          '已修复 $_restoredCount / ${_scenes.length}',""",
    """        Text(
          _t('已修复 $_restoredCount / ${_scenes.length}'),""",
    'progress translation',
)

text = replace_once(
    text,
    """          Text(
            '画卷缺口 ${_sceneIndex + 1} · ${_scene.title}',""",
    """          Text(
            _t('画卷缺口 ${_sceneIndex + 1} · ${_scene.title}'),""",
    'problem title translation',
)
text = replace_once(text, "            _scene.problem,", "            _t(_scene.problem),", 'problem translation')
text = replace_once(text, "            _scene.question,", "            _t(_scene.question),", 'question translation')
text = replace_once(text, "                              choice.label,", "                              _t(choice.label),", 'choice label translation')
text = replace_once(
    text,
    """                            const _SmallBadge(text: '旧游印记'),""",
    """                            _SmallBadge(text: _t('旧游印记')),""",
    'old memory translation',
)
text = replace_once(
    text,
    """                        '${choice.source} · ${choice.explanation}',""",
    """                        _t('${choice.source} · ${choice.explanation}'),""",
    'choice detail translation',
)

text = replace_once(
    text,
    """              SizedBox.square(
                dimension: compact ? 72 : 88,
                child: CustomPaint(
                  painter: _PhoenixPainter(
                    progress: _ambientController.value,
                    celebrating: true,
                  ),
                ),
              ),""",
    """              SizedBox.square(
                dimension: compact ? 72 : 88,
                child: AnimatedBuilder(
                  animation: _ambientController,
                  builder: (context, _) => CustomPaint(
                    painter: _PhoenixPainter(
                      progress: _ambientController.value,
                      celebrating: true,
                    ),
                  ),
                ),
              ),""",
    'finished phoenix animation scope',
)

text = replace_once(
    text,
    """              const Text(
                '画卷已复原',
                style: TextStyle(""",
    """              Text(
                _t('画卷已复原'),
                style: const TextStyle(""",
    'finished title translation',
)
text = replace_once(
    text,
    """              const Text(
                '你用故事、生词和文化发现，让颐和园重新流动起来。',
                textAlign: TextAlign.center,
                style: TextStyle(""",
    """              Text(
                _t('你用故事、生词和文化发现，让颐和园重新流动起来。'),
                textAlign: TextAlign.center,
                style: const TextStyle(""",
    'finished subtitle translation',
)

text = replace_once(
    text,
    """              SizedBox(
                height: compact ? 235 : 280,
                child: CustomPaint(
                  painter: _LostScrollPainter(
                    restoredCount: _scenes.length,
                    activeReveal: 0,
                    ambient: _ambientController.value,
                    completed: true,
                  ),
                ),
              ),""",
    """              SizedBox(
                height: compact ? 235 : 280,
                child: AnimatedBuilder(
                  animation: _ambientController,
                  builder: (context, _) => CustomPaint(
                    painter: _LostScrollPainter(
                      restoredCount: _scenes.length,
                      activeReveal: 0,
                      ambient: _ambientController.value,
                      completed: true,
                    ),
                  ),
                ),
              ),""",
    'finished scroll animation scope',
)

text = replace_once(
    text,
    """                child: const Column(
                  children: [
                    _SmallBadge(text: '体验纪念'),
                    SizedBox(height: 7),
                    Text(
                      '颐和园 · 借景长卷',
                      style: TextStyle(
                        color: Color(0xFF7F2D28),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '借景 · 层次 · 移步换景',
                      style: TextStyle(
                        color: Color(0xFF5D4937),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),""",
    """                child: Column(
                  children: [
                    _SmallBadge(text: _t('体验纪念')),
                    const SizedBox(height: 7),
                    Text(
                      _t('颐和园 · 借景长卷'),
                      style: const TextStyle(
                        color: Color(0xFF7F2D28),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _t('借景 · 层次 · 移步换景'),
                      style: const TextStyle(
                        color: Color(0xFF5D4937),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),""",
    'souvenir translation',
)

text = replace_once(
    text,
    """                  label: const Text(
                    '再修复一次',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),""",
    """                  label: Text(
                    _t('再修复一次'),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),""",
    'restart translation',
)

text = replace_once(
    text,
    """            child: Text(
              '小凰提示：$text',""",
    """            child: Text(
              text,""",
    'hint prefix moved to caller',
)

text = replace_once(
    text,
    "    final gray = const Color(0xFF686D65);",
    "    const gray = Color(0xFF686D65);",
    'const lint',
)

SCREEN.write_text(text, encoding='utf-8')

analysis = ANALYSIS.read_text(encoding='utf-8')
analysis = analysis.replace('    prefer_const_declarations: false\n', '')
ANALYSIS.write_text(analysis, encoding='utf-8')
