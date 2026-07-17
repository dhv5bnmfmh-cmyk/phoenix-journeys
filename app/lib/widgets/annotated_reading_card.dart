import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class AnnotatedReadingCard extends StatefulWidget {
  const AnnotatedReadingCard({
    required this.id,
    required this.mainText,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
    this.leading,
    this.isActive = false,
    this.elevated = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    super.key,
  });

  final String id;
  final Widget mainText;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;
  final Widget? leading;
  final bool isActive;
  final bool elevated;
  final EdgeInsets padding;

  @override
  State<AnnotatedReadingCard> createState() => _AnnotatedReadingCardState();
}

class _AnnotatedReadingCardState extends State<AnnotatedReadingCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  void _toggle() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      margin: EdgeInsets.only(bottom: widget.elevated ? 12 : 4),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.isActive
            ? PhoenixTheme.gold.withValues(alpha: .16)
            : widget.elevated
                ? Colors.white
                : Colors.transparent,
        borderRadius: BorderRadius.circular(widget.elevated ? 18 : 13),
        border: Border.all(
          color: widget.isActive
              ? PhoenixTheme.gold
              : widget.elevated
                  ? PhoenixTheme.gold.withValues(alpha: .17)
                  : Colors.transparent,
        ),
        boxShadow: widget.elevated
            ? const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 6),
                  color: Color(0x0E000000),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 10),
              ],
              Expanded(child: widget.mainText),
              const SizedBox(width: 5),
              SizedBox(
                width: 30,
                height: 25,
                child: TextButton(
                  key: ValueKey('annotation-toggle-${widget.id}'),
                  onPressed: _toggle,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(30, 25),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    foregroundColor: PhoenixTheme.red,
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  child: Text(_expanded ? '收' : '注'),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: _expanded
                ? Padding(
                    key: ValueKey('annotation-panel-${widget.id}'),
                    padding: const EdgeInsets.only(top: 11),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
                      decoration: BoxDecoration(
                        color: PhoenixTheme.translation.withValues(alpha: .055),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: PhoenixTheme.translation.withValues(alpha: .12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AnnotationLine(
                            label: '拼音',
                            text: widget.pinyin,
                            color: PhoenixTheme.red,
                          ),
                          const SizedBox(height: 9),
                          _AnnotationLine(
                            label: widget.nativeLabel,
                            text: widget.nativeText,
                            color: PhoenixTheme.translation,
                          ),
                          const SizedBox(height: 9),
                          _AnnotationLine(
                            label: 'English',
                            text: widget.english,
                            color: PhoenixTheme.ai,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _AnnotationLine extends StatelessWidget {
  const _AnnotationLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: .15,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            height: 1.48,
          ),
        ),
      ],
    );
  }
}
