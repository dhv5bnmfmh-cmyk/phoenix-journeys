import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/language_level_preference_store.dart';
import 'state/access_controlled_app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await const LanguageLevelPreferenceStore().initializePhoenixLevel();

  final runtimeUri = Uri.base;
  final unlockAllJourneys =
      runtimeUri.queryParameters['unlock'] == 'all' &&
      runtimeUri.queryParameters['prototype'] == 'journeys';

  runZonedGuarded(
    () {
      runApp(
        ChangeNotifierProvider<AppState>(
          create: (_) => AccessControlledAppState(
            runtimeUri: runtimeUri,
            debugBuild: unlockAllJourneys ? true : null,
          )..load(),
          child: const PhoenixApp(),
        ),
      );
    },
    (error, stackTrace) {
      if (error is JourneyAccessDeniedException) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PhoenixApp.scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text(error.userMessage)),
          );
        });
        return;
      }
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Phoenix Journeys runtime',
        ),
      );
    },
  );
}
