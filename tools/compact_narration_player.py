from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLAYER = ROOT / 'app/lib/widgets/narration_player_card.dart'
RULE = ROOT / 'worker/compact_narration_player_rule.test.mjs'


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


text = PLAYER.read_text(encoding='utf-8')

text = replace_once(
    text,
    """            padding: EdgeInsets.fromLTRB(
              compact ? 7 : 10,
              compact ? 4 : 8,
              compact ? 6 : 8,
              compact ? 4 : 7,
            ),
            decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
              borderRadius: BorderRadius.circular(compact ? 13 : 17),
            ),
""",
    """            padding: EdgeInsets.fromLTRB(
              compact ? 6 : 10,
              compact ? 3 : 8,
              compact ? 5 : 8,
              compact ? 3 : 7,
            ),
            decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
              borderRadius: BorderRadius.circular(compact ? 11 : 17),
            ),
""",
    'compact card padding',
)

text = replace_once(
    text,
    """                    Container(
                      width: compact ? 24 : 30,
                      height: compact ? 24 : 30,
""",
    """                    Container(
                      width: compact ? 20 : 30,
                      height: compact ? 20 : 30,
""",
    'compact leading icon box',
)
text = replace_once(
    text,
    """                        size: compact ? 14 : 17,
                      ),
                    ),
                    const SizedBox(width: 9),
""",
    """                        size: compact ? 12 : 17,
                      ),
                    ),
                    SizedBox(width: compact ? 6 : 9),
""",
    'compact leading icon spacing',
)
text = replace_once(
    text,
    """                            style: PhoenixTheme.journeyTitleStyle.copyWith(
                              fontSize: 12,
                            ),
""",
    """                            style: PhoenixTheme.journeyTitleStyle.copyWith(
                              fontSize: compact ? 11 : 12,
                            ),
""",
    'compact title size',
)
text = replace_once(
    text,
    """                              style: PhoenixTheme.journeyMetaStyle.copyWith(
                                fontSize: 9,
                              ),
""",
    """                              style: PhoenixTheme.journeyMetaStyle.copyWith(
                                fontSize: compact ? 8.2 : 9,
                              ),
""",
    'compact subtitle size',
)

text = replace_once(
    text,
    """                    PhoenixMediaButton(
                      key: const ValueKey('narration-main-control'),
                      isPlaying: isPlaying,
                      tooltip: _mainButtonTooltip(status),
                      size: compact ? 36 : 44,
                      onPressed: _handleMainPressed,
                    ),
                    const SizedBox(width: 8),
                    NarrationSpeedStepper(
""",
    """                    PhoenixMediaButton(
                      key: const ValueKey('narration-main-control'),
                      isPlaying: isPlaying,
                      tooltip: _mainButtonTooltip(status),
                      size: compact ? 32 : 44,
                      onPressed: _handleMainPressed,
                    ),
                    if (compact) ...[
                      const SizedBox(width: 2),
                      _MiniIconButton(
                        tooltip: '重新播放',
                        icon: Icons.replay_rounded,
                        compact: true,
                        onPressed: canControl
                            ? () => unawaited(_restartSession())
                            : null,
                      ),
                    ],
                    SizedBox(width: compact ? 4 : 8),
                    NarrationSpeedStepper(
""",
    'compact primary controls',
)

old_progress = """                SizedBox(height: compact ? 3 : 7),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: compact ? 5 : 7,
                              backgroundColor: Colors.white24,
                              color: const Color(0xFFFFD879),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                currentItem == null || itemCount == 0
                                    ? '尚未开始'
                                    : '第 ${currentItem + 1} / $itemCount 段',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.5,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$percent%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    _MiniIconButton(
                      tooltip: '重新播放',
                      icon: Icons.replay_rounded,
                      onPressed: canControl
                          ? () => unawaited(_restartSession())
                          : null,
                    ),
                  ],
                ),
"""
new_progress = """                if (compact) ...[
                  const SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      key: const ValueKey('narration-compact-progress'),
                      value: progress,
                      minHeight: 3,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFFFFD879),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                backgroundColor: Colors.white24,
                                color: const Color(0xFFFFD879),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  currentItem == null || itemCount == 0
                                      ? '尚未开始'
                                      : '第 ${currentItem + 1} / $itemCount 段',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9.5,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '$percent%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    fontFeatures: [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      _MiniIconButton(
                        tooltip: '重新播放',
                        icon: Icons.replay_rounded,
                        onPressed: canControl
                            ? () => unawaited(_restartSession())
                            : null,
                      ),
                    ],
                  ),
                ],
"""
text = replace_once(text, old_progress, new_progress, 'compact progress layout')

text = replace_once(
    text,
    """  const _MiniIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
""",
    """  const _MiniIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.compact = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;
""",
    'mini replay compact option',
)
text = replace_once(
    text,
    """      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      icon: Icon(icon, size: 17),
""",
    """      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.all(compact ? 2 : 4),
      constraints: BoxConstraints.tightFor(
        width: compact ? 26 : 30,
        height: compact ? 26 : 30,
      ),
      icon: Icon(icon, size: compact ? 15 : 17),
""",
    'mini replay dimensions',
)

PLAYER.write_text(text, encoding='utf-8')

RULE.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('compact narration player preserves controls in a shorter layout', () => {
  assert.match(player, /compact \? 6 : 10/);
  assert.match(player, /compact \? 3 : 8/);
  assert.match(player, /size: compact \? 32 : 44/);
  assert.match(player, /key: const ValueKey\('narration-compact-progress'\)/);
  assert.match(player, /minHeight: 3/);
  assert.match(player, /compact: true/);
  assert.match(player, /width: compact \? 26 : 30/);
  assert.match(player, /height: compact \? 26 : 30/);
});

test('full narration player keeps detailed segment and percent labels', () => {
  assert.match(player, /第 \$\{currentItem \+ 1\} \/ \$itemCount 段/);
  assert.match(player, /FontFeature\.tabularFigures/);
});
""",
    encoding='utf-8',
)
