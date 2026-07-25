import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'summer_palace_journey_arsenal.dart' as arsenal;

class SummerPalaceLoreBattle extends StatelessWidget {
  const SummerPalaceLoreBattle({
    super.key,
    required this.onCompleted,
    this.completed = false,
    this.scenarioSeed,
    this.ruleSeed,
    this.learnedWords = const <String>{},
  });

  final VoidCallback onCompleted;
  final bool completed;
  final int? scenarioSeed;
  final int? ruleSeed;
  final Set<String> learnedWords;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState?>(context, listen: false);
    final availableKnowledge = <String>{
      ...?appState?.savedWords,
      ...learnedWords,
    };

    return arsenal.SummerPalaceLoreBattle(
      completed: completed,
      scenarioSeed: scenarioSeed,
      ruleSeed: ruleSeed,
      learnedWords: availableKnowledge,
      onCompleted: onCompleted,
    );
  }
}
