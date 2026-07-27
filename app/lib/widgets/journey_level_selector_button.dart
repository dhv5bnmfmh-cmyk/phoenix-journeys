import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../services/language_level_preference_store.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class JourneyLevelSelectorButton extends StatefulWidget {
  const JourneyLevelSelectorButton({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  State<JourneyLevelSelectorButton> createState() =>
      _JourneyLevelSelectorButtonState();
}

class _JourneyLevelSelectorButtonState
    extends State<JourneyLevelSelectorButton> {
  static const _agent = PhoenixLanguageLevelAgent();
  static const _store = LanguageLevelPreferenceStore();

  ChineseProficiencyProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final profile = await _store.load();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _openSelector() async {
    final state = context.read<AppState>();
    final track = await showModalBottomSheet<ChineseExamTrack>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.displayText('选择中文考试路线'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              state.displayText('这个等级会应用到所有普通旅程与特殊旅程。'),
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
            const SizedBox(height: 10),
            for (final item in ChineseExamTrack.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: PhoenixTheme.red.withValues(alpha: .12),
                  child: Text(
                    item == ChineseExamTrack.hsk ? '汉' : '华',
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                title: Text(
                  item.label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  state.displayText(
                    item == ChineseExamTrack.hsk
                        ? 'HSK 1 至 HSK 7–9'
                        : '准备级至 TOCFL Level 6',
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(sheetContext).pop(item),
              ),
          ],
        ),
      ),
    );
    if (!mounted || track == null) return;

    final selected = await showModalBottomSheet<ChineseProficiencyProfile>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: .78,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          children: [
            Text(
              state.displayText('选择 ${track.label} 等级'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              state.displayText('故事、发现、重点单词与写作问题会一起调整。'),
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
            const SizedBox(height: 8),
            for (final profile in _agent.profilesFor(track))
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  profile.displayLabel,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  state.displayText(
                    '${profile.band.label} · '
                    '${_agent.planFor(profile).targetVocabularyCount} 个重点单词',
                  ),
                ),
                trailing: _profile?.storageValue == profile.storageValue
                    ? const Icon(Icons.check_rounded, color: PhoenixTheme.red)
                    : const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(sheetContext).pop(profile),
              ),
          ],
        ),
      ),
    );
    if (selected == null) return;

    await _store.save(selected);
    if (!mounted) return;
    setState(() => _profile = selected);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final label = _loading
        ? '…'
        : _profile?.displayLabel ?? state.displayText('选择等级');

    return OutlinedButton.icon(
      key: const ValueKey('global-journey-level-selector'),
      onPressed: _loading ? null : () => unawaited(_openSelector()),
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 7 : 10,
          vertical: widget.compact ? 4 : 7,
        ),
        minimumSize: Size.zero,
        side: BorderSide(color: PhoenixTheme.gold.withValues(alpha: .65)),
        shape: const StadiumBorder(),
      ),
      icon: Icon(
        Icons.tune_rounded,
        size: widget.compact ? 13 : 16,
        color: PhoenixTheme.red,
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: PhoenixTheme.red,
          fontSize: widget.compact ? 9 : 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
