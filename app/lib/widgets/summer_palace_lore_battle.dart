import 'package:flutter/material.dart';

import 'summer_palace_journey_arsenal.dart';

class SummerPalaceLoreBattle extends StatelessWidget {
  const SummerPalaceLoreBattle({
    super.key,
    required this.onCompleted,
    this.completed = false,
    this.encounterSeed,
  });

  final VoidCallback onCompleted;
  final bool completed;
  final int? encounterSeed;

  @override
  Widget build(BuildContext context) {
    return SummerPalaceJourneyArsenal(
      completed: completed,
      encounterSeed: encounterSeed,
      onCompleted: onCompleted,
    );
  }
}
