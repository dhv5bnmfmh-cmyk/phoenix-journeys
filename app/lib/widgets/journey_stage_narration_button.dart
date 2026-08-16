import 'package:flutter/material.dart';

import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

String journeyStageNarrationLanguageCode(bool isTraditional) =>
    isTraditional ? 'zh-TW' : 'zh-CN';

List<NarrationItem> buildJourneyStageNarrationItems({
  required String stage,
  required List<String> displayedLines,
}) {
  final cleanLines = displayedLines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);
  return [
    for (var index = 0; index < cleanLines.length; index++)
      NarrationItem(
        id: '$stage-$index',
        text: cleanLines[index],
        label: '${stage == 'memory' ? '回忆' : '完成'} ${index + 1}',
      ),
  ];
}

class JourneyStageNarrationButton extends StatelessWidget {
  const JourneyStageNarrationButton({
    super.key,
    required this.stage,
    required this.isPlaying,
    required this.onPressed,
  });

  final String stage;
  final bool isPlaying;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = isPlaying ? '停止朗读' : '播放朗读';
    return Semantics(
      button: true,
      label: label,
      value: isPlaying ? '正在朗读' : '未播放',
      child: ExcludeSemantics(
        child: SizedBox(
          key: ValueKey('$stage-narration-touch-target'),
          width: 44,
          height: 44,
          child: IconButton(
            tooltip: label,
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              foregroundColor: PhoenixTheme.red,
              backgroundColor: Colors.white.withValues(alpha: .72),
              side: BorderSide(color: PhoenixTheme.gold.withValues(alpha: .34)),
            ),
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
              key: ValueKey('$stage-narration-${isPlaying ? 'stop' : 'play'}'),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
