import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/language_level_preference_store.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await const LanguageLevelPreferenceStore().initializePhoenixLevel();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: const PhoenixApp(),
    ),
  );
}
