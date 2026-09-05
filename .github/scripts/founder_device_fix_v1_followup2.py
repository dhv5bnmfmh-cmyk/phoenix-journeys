from pathlib import Path

p = Path('app/lib/screens/me_screen.dart')
text = p.read_text()
old = "      OutlinedButton.icon(key: const ValueKey('memory-detail-add-photo'), onPressed: () async { final picked = await pickJourneyMemoryPhotos(); for (final bytes in picked) { await widget.state.addJourneyMemoryPhoto(entry, bytes); entry = widget.state.journeyMemories.firstWhere((item) => item.id == entry.id); } if (mounted) setState(() {}); }, icon: const Icon(Icons.add_photo_alternate_outlined), label: const Text('添加照片')),\n"
new = "      OutlinedButton.icon(key: const ValueKey('memory-detail-add-photo'), onPressed: () async { final bytes = await pickJourneyMemoryPhoto(); if (bytes == null) return; await widget.state.replaceJourneyMemoryPhoto(entry, bytes); entry = widget.state.journeyMemories.firstWhere((item) => item.id == entry.id); if (mounted) setState(() {}); }, icon: const Icon(Icons.add_photo_alternate_outlined), label: Text(entry.photoRefs.isEmpty ? '添加照片' : '更换照片')),\n"
if text.count(old) != 1:
    raise SystemExit(f'me_screen photo button anchor count: {text.count(old)}')
p.write_text(text.replace(old, new, 1))
