import 'package:flutter/material.dart';

import '../services/background_motion_preference.dart';

class PhoenixMotionToggleButton extends StatelessWidget {
  const PhoenixMotionToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final preference = BackgroundMotionPreference.instance;
    return ListenableBuilder(
      listenable: preference,
      builder: (context, _) {
        final reduced = preference.reduceMotion;
        final label = reduced ? '开启动态背景' : '减少动态效果';
        return Semantics(
          button: true,
          label: label,
          toggled: reduced,
          child: Material(
            color: Colors.black.withValues(alpha: .22),
            shape: const CircleBorder(),
            child: IconButton(
              key: const ValueKey('phoenix-motion-toggle'),
              onPressed: () => preference.setReduceMotion(!reduced),
              icon: Icon(
                reduced
                    ? Icons.motion_photos_off_rounded
                    : Icons.motion_photos_auto_rounded,
                color: Colors.white,
                size: 19,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }
}
