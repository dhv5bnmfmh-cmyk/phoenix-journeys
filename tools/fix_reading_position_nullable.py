from pathlib import Path

path = Path('app/lib/screens/journey_screen.dart')
source = path.read_text()
old = '''        final snapshot = controller.highlightSnapshot;
        final isCurrent = snapshot?.contentId == contentId;
        final status = controller.status;
        final isPlaying = isCurrent && status == NarrationStatus.playing;
        final isPaused = isCurrent && status == NarrationStatus.paused;
'''
new = '''        final snapshot = controller.highlightSnapshot;
        final currentSnapshot =
            snapshot != null && snapshot.contentId == contentId ? snapshot : null;
        final isCurrent = currentSnapshot != null;
        final status = controller.status;
        final isPlaying = isCurrent && status == NarrationStatus.playing;
        final isPaused = isCurrent && status == NarrationStatus.paused;
'''
if old not in source:
    raise SystemExit('reading-position snapshot block not found')
source = source.replace(old, new, 1)
old_word = '''        final itemNumber = isCurrent ? snapshot!.itemIndex + 1 : null;
        final word = isCurrent
            ? snapshot.itemText.substring(
                snapshot.start.clamp(0, snapshot.itemText.length),
                snapshot.end.clamp(0, snapshot.itemText.length),
              )
            : '';
'''
new_word = '''        final itemNumber = currentSnapshot?.itemIndex == null
            ? null
            : currentSnapshot!.itemIndex + 1;
        final word = currentSnapshot == null
            ? ''
            : currentSnapshot.itemText.substring(
                currentSnapshot.start.clamp(0, currentSnapshot.itemText.length),
                currentSnapshot.end.clamp(0, currentSnapshot.itemText.length),
              );
'''
if old_word not in source:
    raise SystemExit('reading-position word block not found')
source = source.replace(old_word, new_word, 1)
path.write_text(source)
