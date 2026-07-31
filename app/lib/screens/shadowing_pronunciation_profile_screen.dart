import 'package:flutter/material.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import 'shadowing_profile_screen.dart';

class ShadowingPronunciationProfileScreen extends StatelessWidget {
  const ShadowingPronunciationProfileScreen({
    super.key,
    required this.history,
    required this.weaknesses,
    required this.onStartWeaknessTraining,
  });

  final ShadowingTrainingHistory history;
  final ShadowingWeaknessLibrary weaknesses;
  final Future<void> Function() onStartWeaknessTraining;

  @override
  Widget build(BuildContext context) {
    return ShadowingProfileScreen(
      history: history,
      weaknesses: weaknesses,
      onStartTraining: onStartWeaknessTraining,
      onOpenWeakness: onStartWeaknessTraining,
    );
  }
}
