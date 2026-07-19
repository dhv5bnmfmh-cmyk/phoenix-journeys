import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/phoenix_theme.dart';

class JourneyShareCopy {
  const JourneyShareCopy._();

  static const productionUrl =
      'https://phoenix-journeys-alpha.7hn5tyrjgh.workers.dev/';

  static String title({
    required bool traditional,
    required String city,
    required String place,
  }) {
    return 'Phoenix Journeys · $city$place';
  }

  static String message({
    required bool traditional,
    required String city,
    required String place,
  }) {
    if (traditional) {
      return '我在 Phoenix Journeys 完成了「$city・$place」中文旅程，點亮$city並獲得了城市印章 🔥\n\n'
          '一起從一門語言出發，探索世界：\n$productionUrl';
    }
    return '我在 Phoenix Journeys 完成了「$city·$place」中文旅程，点亮$city并获得了城市印章 🔥\n\n'
        '一起从一门语言出发，探索世界：\n$productionUrl';
  }
}

class JourneyShareButton extends StatefulWidget {
  const JourneyShareButton({
    super.key,
    required this.isTraditional,
    this.city = '北京',
    this.place = '紫禁城',
    this.compact = false,
    this.filled = true,
    this.label,
  });

  final bool isTraditional;
  final String city;
  final String place;
  final bool compact;
  final bool filled;
  final String? label;

  @override
  State<JourneyShareButton> createState() => _JourneyShareButtonState();
}

class _JourneyShareButtonState extends State<JourneyShareButton> {
  bool _sharing = false;

  Rect _shareOrigin() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize && box.size.width > 0 && box.size.height > 0) {
      return box.localToGlobal(Offset.zero) & box.size;
    }
    final size = MediaQuery.sizeOf(context);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 1,
      height: 1,
    );
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    try {
      await SharePlus.instance.share(
        ShareParams(
          title: JourneyShareCopy.title(
            traditional: widget.isTraditional,
            city: widget.city,
            place: widget.place,
          ),
          subject: JourneyShareCopy.title(
            traditional: widget.isTraditional,
            city: widget.city,
            place: widget.place,
          ),
          text: JourneyShareCopy.message(
            traditional: widget.isTraditional,
            city: widget.city,
            place: widget.place,
          ),
          sharePositionOrigin: _shareOrigin(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              widget.isTraditional
                  ? '暫時無法開啟分享面板，請稍後再試。'
                  : '暂时无法打开分享面板，请稍后再试。',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? '分享旅程';
    final icon = _sharing
        ? SizedBox(
            width: widget.compact ? 14 : 16,
            height: widget.compact ? 14 : 16,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(Icons.ios_share_rounded, size: widget.compact ? 16 : 18);

    final style = widget.filled
        ? FilledButton.styleFrom(
            backgroundColor: PhoenixTheme.red,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 8 : 12,
            ),
          )
        : OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 8 : 12,
            ),
          );

    if (widget.filled) {
      return FilledButton.icon(
        key: const ValueKey('share-beijing-journey'),
        onPressed: _sharing ? null : _share,
        style: style,
        icon: icon,
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: widget.compact ? 10.5 : 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      key: const ValueKey('share-beijing-journey'),
      onPressed: _sharing ? null : _share,
      style: style,
      icon: icon,
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: widget.compact ? 10.5 : 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
