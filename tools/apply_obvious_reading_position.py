from pathlib import Path


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if new in text:
        return text
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, got {count}')
    return text.replace(old, new, 1)


journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()

story_player = '''          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 2),
          Expanded(
'''
story_player_new = '''          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'story',
            totalItems: _journeyContent.storyParagraphs.length,
          ),
          const SizedBox(height: 2),
          Expanded(
'''
journey = replace_once(journey, story_player, story_player_new, 'story now-reading strip')

discovery_player = '''          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery',
            subtitle: '中文朗读 · ${discoveries.length} 段',
            compact: true,
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 4),
          const _InlineTip(
            icon: Icons.notes_rounded,
            text: '四段发现同屏显示；点“注”查看拼音、探索者母语和 English。',
          ),
          const SizedBox(height: 4),
          Expanded(
'''
discovery_player_new = '''          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery',
            subtitle: '中文朗读 · ${discoveries.length} 段',
            compact: true,
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'discovery',
            totalItems: discoveries.length,
          ),
          const SizedBox(height: 3),
          Expanded(
'''
journey = replace_once(
    journey,
    discovery_player,
    discovery_player_new,
    'discovery now-reading strip',
)

marker = '''class _CompactTextBlock extends StatelessWidget {
'''
now_reading = '''class _NowReadingStrip extends StatelessWidget {
  const _NowReadingStrip({
    required this.controller,
    required this.contentId,
    required this.totalItems,
  });

  final NarrationController controller;
  final String contentId;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final snapshot = controller.highlightSnapshot;
        final isCurrent = snapshot?.contentId == contentId;
        final status = controller.status;
        final isPlaying = isCurrent && status == NarrationStatus.playing;
        final isPaused = isCurrent && status == NarrationStatus.paused;
        final label = isPlaying
            ? '正在朗读'
            : isPaused
            ? '暂停在'
            : '朗读位置';
        final icon = isPlaying
            ? Icons.graphic_eq_rounded
            : isPaused
            ? Icons.pause_rounded
            : Icons.my_location_rounded;
        final itemNumber = isCurrent ? snapshot!.itemIndex + 1 : null;
        final word = isCurrent
            ? snapshot.itemText.substring(
                snapshot.start.clamp(0, snapshot.itemText.length),
                snapshot.end.clamp(0, snapshot.itemText.length),
              )
            : '';

        return AnimatedContainer(
          key: ValueKey('now-reading-$contentId'),
          duration: const Duration(milliseconds: 160),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrent
                ? const Color(0xFFFFE39B)
                : Colors.white.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCurrent
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .30),
              width: isCurrent ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isCurrent ? PhoenixTheme.red : Colors.black45,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isCurrent ? PhoenixTheme.red : Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              if (isCurrent) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: PhoenixTheme.red,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '第 $itemNumber/$totalItems 段',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '当前：$word',
                    key: ValueKey('now-reading-word-$contentId'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF65130F),
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ] else
                const Expanded(
                  child: Text(
                    '按播放后，这里会显示当前段落和词语',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 9.5,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompactTextBlock extends StatelessWidget {
'''
journey = replace_once(journey, marker, now_reading, 'now-reading widget')

journey = replace_once(
    journey,
    '''      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.fromLTRB(3, 1, 1, 1),
      decoration: BoxDecoration(
        color: active
            ? PhoenixTheme.gold.withValues(alpha: .18)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? PhoenixTheme.gold
              : PhoenixTheme.gold.withValues(alpha: .22),
        ),
      ),
''',
    '''      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFE7A8)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? PhoenixTheme.red
              : PhoenixTheme.gold.withValues(alpha: .22),
          width: active ? 1.5 : 1,
        ),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x24781E18),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
''',
    'strong active paragraph card',
)
journey_path.write_text(journey)

interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
old_style = '''        style: (segmentStyle ?? baseStyle ?? const TextStyle()).copyWith(
          color: const Color(0xFF781E18),
          backgroundColor: const Color(0xFFFFD05A),
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.none,
          shadows: const [Shadow(color: Color(0x22FFFFFF), blurRadius: 1)],
        ),
'''
new_style = '''        style: (segmentStyle ?? baseStyle ?? const TextStyle()).copyWith(
          color: const Color(0xFF65130F),
          backgroundColor: const Color(0xFFFFC928),
          fontSize:
              ((segmentStyle ?? baseStyle)?.fontSize ?? 11) + 1.4,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF781E18),
          decorationThickness: 2.1,
          shadows: const [Shadow(color: Color(0x55FFFFFF), blurRadius: 1)],
        ),
'''
interactive = replace_once(
    interactive,
    old_style,
    new_style,
    'strong current-word style',
)
interactive_path.write_text(interactive)

Path('worker/reading_position_visibility.test.mjs').write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery always expose an obvious live reading position', () => {
  assert.equal((journey.match(/_NowReadingStrip\(/g) ?? []).length, 3);
  assert.match(journey, /ValueKey\('now-reading-\$contentId'\)/);
  assert.match(journey, /ValueKey\('now-reading-word-\$contentId'\)/);
  assert.match(journey, /当前：\$word/);
});

test('active paragraph and current word use strong visual contrast', () => {
  assert.match(journey, /const Color\(0xFFFFE7A8\)/);
  assert.match(journey, /color: active[\s\S]*PhoenixTheme\.red/);
  assert.match(interactive, /backgroundColor: const Color\(0xFFFFC928\)/);
  assert.match(interactive, /decorationThickness: 2\.1/);
});
''')
