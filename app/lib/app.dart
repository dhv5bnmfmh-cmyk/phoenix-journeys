import 'package:flutter/material.dart';

import 'theme/phoenix_theme.dart';
import 'screens/home_shell.dart';

class PhoenixApp extends StatelessWidget {
  const PhoenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phoenix Journeys',
      debugShowCheckedModeBanner: false,
      theme: PhoenixTheme.light,
      home: const HomeShell(),
    );
  }
}
