import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/shadowing_passage_catalog.dart';
import '../services/shadowing_training_history.dart';
import '../theme/phoenix_theme.dart';

class ShadowingCollectionScreen extends StatefulWidget {
  const ShadowingCollectionScreen({
    super.key,
    required this.history,
    required this.onStartTraining,
  });

  final ShadowingTrainingHistory history;
  final Future<void> Function() onStartTraining;

  @override
  State<ShadowingCollectionScreen> createState() =>
      _ShadowingCollectionScreenState();
}

class _ShadowingCollectionScreenState extends State<ShadowingCollectionScreen> {
  static const _favoriteKey = 'phoenix.shadowing.favoritePassages';
  static const _laterKey = 'phoenix.shadowing.practiceLaterPassages';

  final Set<String> _favorites = <String>{};
  final Set<String> _practiceLater = <String>{};
  String _query = '';
  int _tab = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites
      ..clear()
      ..addAll(prefs.getStringList(_favoriteKey) ?? const <String>[]);
    _practiceLater
      ..clear()
      ..addAll(prefs.getStringList(_laterKey) ?? const <String>[]);
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteKey, _favorites.toList(growable: false));
    await prefs.setStringList(
      _laterKey,
      _practiceLater.toList(growable: false),
    );
  }

  Future<void> _toggleFavorite(String id) async {
    setState(() {
      if (!_favorites.add(id)) _favorites.remove(id);
    });
    await _save();
  }

  Future<void> _toggleLater(String id) async {
    setState(() {
      if (!_practiceLater.add(id)) _practiceLater.remove(id);
    });
    await _save();
  }

  List<ShadowingPassage> get _recent {
    final ids = <String>[];
    for (final session in widget.history.recentSessions) {
      if (!ids.contains(session.passageId)) ids.add(session.passageId);
    }
    return ids
        .map((id) => shadowingPassages.where((item) => item.id == id))
        .where((items) => items.isNotEmpty)
        .map((items) => items.first)
        .take(8)
        .toList(growable: false);
  }

  List<ShadowingPassage> get _visible {
    final source = switch (_tab) {
      0 => shadowingPassages.where((item) => _favorites.contains(item.id)),
      1 => shadowingPassages.where((item) => _practiceLater.contains(item.id)),
      _ => _recent,
    };
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) return source.toList(growable: false);
    return source
        .where((item) =>
            item.title.toLowerCase().contains(normalized) ||
            item.theme.toLowerCase().contains(normalized) ||
            item.text.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(title: const Text('收藏与稍后练')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                children: [
                  _SummaryHero(
                    favorites: _favorites.length,
                    later: _practiceLater.length,
                    recent: _recent.length,
                    onStart: widget.onStartTraining,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: '搜索标题、主题或内容',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: .86),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        icon: Icon(Icons.favorite_rounded),
                        label: Text('收藏'),
                      ),
                      ButtonSegment(
                        value: 1,
                        icon: Icon(Icons.bookmark_added_rounded),
                        label: Text('稍后练'),
                      ),
                      ButtonSegment(
                        value: 2,
                        icon: Icon(Icons.history_rounded),
                        label: Text('最近'),
                      ),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (value) =>
                        setState(() => _tab = value.first),
                  ),
                  const SizedBox(height: 16),
                  if (_visible.isEmpty)
                    _EmptyState(
                      tab: _tab,
                      hasQuery: _query.trim().isNotEmpty,
                    )
                  else
                    ..._visible.map(
                      (passage) => _PassageCard(
                        passage: passage,
                        favorite: _favorites.contains(passage.id),
                        practiceLater: _practiceLater.contains(passage.id),
                        bestScore: _bestScoreFor(passage.id),
                        onFavorite: () => _toggleFavorite(passage.id),
                        onLater: () => _toggleLater(passage.id),
                        onStart: widget.onStartTraining,
                      ),
                    ),
                  const SizedBox(height: 18),
                  _DiscoveryCard(
                    total: shadowingPassages.length,
                    saved: {..._favorites, ..._practiceLater}.length,
                  ),
                ],
              ),
      ),
    );
  }

  int _bestScoreFor(String passageId) {
    var best = 0;
    for (final session in widget.history.recentSessions) {
      if (session.passageId == passageId && session.score > best) {
        best = session.score;
      }
    }
    return best;
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({
    required this.favorites,
    required this.later,
    required this.recent,
    required this.onStart,
  });

  final int favorites;
  final int later;
  final int recent;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F1D1D), Color(0xFFB23A2A)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.collections_bookmark_rounded,
              color: Color(0xFFFFD879), size: 40),
          const SizedBox(height: 12),
          const Text(
            '你的跟读书架',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '收藏 $favorites · 稍后练 $later · 最近浏览 $recent',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .86),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFD879),
                foregroundColor: const Color(0xFF542010),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('快速开始训练',
                  style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassageCard extends StatelessWidget {
  const _PassageCard({
    required this.passage,
    required this.favorite,
    required this.practiceLater,
    required this.bestScore,
    required this.onFavorite,
    required this.onLater,
    required this.onStart,
  });

  final ShadowingPassage passage;
  final bool favorite;
  final bool practiceLater;
  final int bestScore;
  final VoidCallback onFavorite;
  final VoidCallback onLater;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: .86),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7BE),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('L${passage.level}',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontWeight: FontWeight.w900,
                      )),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(passage.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      )),
                ),
                IconButton(
                  tooltip: favorite ? '取消收藏' : '收藏',
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: favorite ? PhoenixTheme.red : Colors.black38,
                  ),
                ),
              ],
            ),
            Text(
              '${passage.theme} · ${passage.sentences.length} 句 · 约 ${passage.estimatedMinutes} 分钟',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 9),
            Text(
              passage.sentences.first,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.45),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (bestScore > 0)
                  Text('最佳 $bestScore 分',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontWeight: FontWeight.w800,
                      ))
                else
                  const Text('尚未完成',
                      style: TextStyle(color: Colors.black45)),
                const Spacer(),
                TextButton.icon(
                  onPressed: onLater,
                  icon: Icon(practiceLater
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_outlined),
                  label: Text(practiceLater ? '已加入' : '稍后练'),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: onStart,
                  child: const Text('开始'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tab, required this.hasQuery});

  final int tab;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final title = hasQuery
        ? '没有找到匹配内容'
        : switch (tab) {
            0 => '还没有收藏短文',
            1 => '稍后练清单还是空的',
            _ => '还没有最近训练记录',
          };
    final subtitle = hasQuery
        ? '换一个关键词，或清空搜索后再看看。'
        : switch (tab) {
            0 => '在这里保存喜欢的主题，慢慢建立自己的跟读书架。',
            1 => '看到想练的材料时，可以先加入稍后练。',
            _ => '完成一次训练后，最近浏览会自动出现在这里。',
          };
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_stories_rounded,
              color: PhoenixTheme.red, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.45)),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.total, required this.saved});

  final int total;
  final int saved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.explore_rounded, color: PhoenixTheme.red, size: 34),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              '素材库共有 $total 篇短文，你已经保存 $saved 篇。继续探索不同等级和主题，书架会越来越有你的味道。',
              style: const TextStyle(height: 1.45, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
