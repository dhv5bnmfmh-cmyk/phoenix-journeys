import 'package:flutter/material.dart';

import 'screens/learning_playground_screen.dart';
import 'theme/phoenix_theme.dart';
import 'widgets/startup_gate.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prototype = Uri.base.queryParameters['prototype'];
    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.light,
      home: prototype == 'learning-lab'
          ? const LearningPlaygroundScreen()
          : const StartupGate(),
    );
  }
}
