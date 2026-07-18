import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class CompactPager extends StatefulWidget {
  const CompactPager({
    required this.pages,
    this.semanticLabel = '内容分页',
    this.initialPage = 0,
    super.key,
  });

  final List<Widget> pages;
  final String semanticLabel;
  final int initialPage;

  @override
  State<CompactPager> createState() => _CompactPagerState();
}

class _CompactPagerState extends State<CompactPager> {
  late final PageController _controller;
  late int _page;

  @override
  void initState() {
    super.initState();
    final maxIndex = widget.pages.isEmpty ? 0 : widget.pages.length - 1;
    _page = widget.initialPage.clamp(0, maxIndex).toInt();
    _controller = PageController(initialPage: _page);
  }

  @override
  void didUpdateWidget(covariant CompactPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_page >= widget.pages.length && widget.pages.isNotEmpty) {
      _page = widget.pages.length - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) _controller.jumpToPage(_page);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _move(int target) {
    if (widget.pages.isEmpty) return;
    final safe = target.clamp(0, widget.pages.length - 1).toInt();
    _controller.animateToPage(
      safe,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pages.isEmpty) return const SizedBox.shrink();

    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (value) => setState(() => _page = value),
              children: widget.pages,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: '上一页',
                  onPressed: _page > 0 ? () => _move(_page - 1) : null,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 34,
                    height: 30,
                  ),
                  icon: const Icon(Icons.chevron_left_rounded, size: 21),
                ),
                const SizedBox(width: 4),
                ...List.generate(
                  widget.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: index == _page ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index == _page
                          ? PhoenixTheme.red
                          : PhoenixTheme.gold.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: '下一页',
                  onPressed: _page < widget.pages.length - 1
                      ? () => _move(_page + 1)
                      : null,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 34,
                    height: 30,
                  ),
                  icon: const Icon(Icons.chevron_right_rounded, size: 21),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<List<T>> compactChunks<T>(List<T> values, int size) {
  assert(size > 0);
  if (values.isEmpty) return <List<T>>[];
  return [
    for (var start = 0; start < values.length; start += size)
      values.sublist(
        start,
        (start + size).clamp(0, values.length).toInt(),
      ),
  ];
}
