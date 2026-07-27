import 'package:flutter/material.dart';

import '../data/daily_journey_catalog.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

@immutable
class JourneyMemoryEntry {
  const JourneyMemoryEntry({
    required this.raw,
    required this.title,
    required this.memory,
    required this.sequence,
    required this.journey,
  });

  factory JourneyMemoryEntry.parse({
    required String raw,
    required int sequence,
  }) {
    final separator = raw.indexOf('｜');
    final storedTitle = separator >= 0
        ? raw.substring(0, separator).trim()
        : '旅程回忆';
    final memory = separator >= 0
        ? raw.substring(separator + 1).trim()
        : raw.trim();

    DailyJourneyExperience? matchedJourney;
    for (final candidate in allJourneyExperiences) {
      if (candidate.stampTitle == storedTitle ||
          candidate.appBarTitle == storedTitle) {
        matchedJourney = candidate;
        break;
      }
    }

    return JourneyMemoryEntry(
      raw: raw,
      title: storedTitle,
      memory: memory,
      sequence: sequence,
      journey: matchedJourney,
    );
  }

  final String raw;
  final String title;
  final String memory;
  final int sequence;
  final DailyJourneyExperience? journey;

  String get displayTitle => journey?.appBarTitle ?? title;

  String get locationLabel {
    final matched = journey;
    return matched == null ? title : '${matched.city} · ${matched.place}';
  }

  String get stampSymbol => journey?.stampSymbol ?? '记';
}

class JourneyMemoryTimeline extends StatelessWidget {
  const JourneyMemoryTimeline({required this.state, super.key});

  final AppState state;

  List<JourneyMemoryEntry> get _entries {
    final total = state.memories.length;
    return state.memories
        .asMap()
        .entries
        .map(
          (entry) => JourneyMemoryEntry.parse(
            raw: entry.value,
            sequence: total - entry.key,
          ),
        )
        .toList(growable: false);
  }

  Future<void> _showDetail(
    BuildContext context,
    JourneyMemoryEntry entry,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _JourneyMemoryDetailSheet(state: state, entry: entry),
    );
  }

  Future<void> _showAll(
    BuildContext context,
    List<JourneyMemoryEntry> entries,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: .82,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.displayText('旅程回忆收藏册'),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.displayText('每一段回忆都回到它真正所属的旅程。'),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _MemoryCountBadge(state: state, count: entries.length),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 7),
                itemBuilder: (_, index) {
                  final entry = entries[index];
                  return _JourneyMemoryTile(
                    key: ValueKey('journey-memory-list-$index'),
                    state: state,
                    entry: entry,
                    compact: false,
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _showDetail(context, entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    if (entries.isEmpty) return const SizedBox.shrink();
    final preview = entries.take(4).toList(growable: false);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: preview.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (_, index) {
              final entry = preview[index];
              return _JourneyMemoryTile(
                key: ValueKey('journey-memory-card-$index'),
                state: state,
                entry: entry,
                compact: true,
                onTap: () => _showDetail(context, entry),
              );
            },
          ),
        ),
        if (entries.length > preview.length) ...[
          const SizedBox(height: 5),
          SizedBox(
            height: 32,
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('journey-memory-show-all'),
              onPressed: () => _showAll(context, entries),
              icon: const Icon(Icons.collections_bookmark_rounded, size: 16),
              label: Text(
                state.displayText('查看全部 ${entries.length} 条回忆'),
                style: const TextStyle(fontSize: 10.5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _JourneyMemoryTile extends StatelessWidget {
  const _JourneyMemoryTile({
    required this.state,
    required this.entry,
    required this.compact,
    required this.onTap,
    super.key,
  });

  final AppState state;
  final JourneyMemoryEntry entry;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .94),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: compact ? 7 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: PhoenixTheme.gold.withValues(alpha: .28),
            ),
          ),
          child: Row(
            children: [
              _MemoryStamp(symbol: state.displayText(entry.stampSymbol)),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.displayText(entry.displayTitle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: compact ? 11.5 : 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.displayText('第 ${entry.sequence} 段'),
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.displayText(entry.memory),
                      maxLines: compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: compact ? 10 : 10.5,
                        height: 1.2,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 3),
                      Text(
                        state.displayText(entry.locationLabel),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyMemoryDetailSheet extends StatelessWidget {
  const _JourneyMemoryDetailSheet({
    required this.state,
    required this.entry,
  });

  final AppState state;
  final JourneyMemoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      key: const ValueKey('journey-memory-detail'),
      heightFactor: .66,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _MemoryStamp(
                  symbol: state.displayText(entry.stampSymbol),
                  size: 52,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.displayText(entry.displayTitle),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.displayText(
                          '第 ${entry.sequence} 段收藏 · ${entry.locationLabel}',
                        ),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PhoenixTheme.gold.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    state.displayText('永久收藏'),
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              state.displayText('我的回忆'),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: .5,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFBF3), Color(0xFFF7E7CE)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: PhoenixTheme.gold.withValues(alpha: .38),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    state.displayText(entry.memory),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: PhoenixTheme.red.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: PhoenixTheme.red,
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      state.displayText('这段文字已经归档到 ${entry.displayTitle}。'),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryStamp extends StatelessWidget {
  const _MemoryStamp({required this.symbol, this.size = 38});

  final String symbol;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: PhoenixTheme.red.withValues(alpha: .08),
        border: Border.all(
          color: PhoenixTheme.red.withValues(alpha: .45),
          width: 1.4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18A62828),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        symbol,
        style: TextStyle(
          color: PhoenixTheme.red,
          fontSize: size * .36,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MemoryCountBadge extends StatelessWidget {
  const _MemoryCountBadge({required this.state, required this.count});

  final AppState state;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: PhoenixTheme.red.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        state.displayText('$count 段'),
        style: const TextStyle(
          color: PhoenixTheme.red,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
