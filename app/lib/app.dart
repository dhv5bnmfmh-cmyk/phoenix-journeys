import 'package:flutter/material.dart';

import 'screens/learning_playground_screen.dart';
import 'theme/phoenix_theme.dart';
import 'widgets/startup_gate.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final prototype = uri.queryParameters['prototype'];
    final isLearningLab = prototype == 'learning-lab' ||
        (prototype == null &&
            uri.host == 'phoenix-journeys-pr-115.7hn5tyrjgh.workers.dev');
    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.light,
      home: isLearningLab
          ? const LearningPlaygroundScreen()
          : const StartupGate(),
    );
  }
}
