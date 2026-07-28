import 'package:shared_preferences/shared_preferences.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import 'phoenix_level_controller.dart';

class LanguageLevelPreferenceStore {
  const LanguageLevelPreferenceStore();

  static const String _profileKey = 'phoenix.languageProficiency';
  static const String _phoenixLevelKey = 'phoenix.level';
  static const String _promptSeenKey =
      'phoenix.languageProficiencyPromptSeen';
  static const PhoenixLanguageLevelAgent _agent = PhoenixLanguageLevelAgent();

  Future<int> initializePhoenixLevel() async {
    final preferences = await SharedPreferences.getInstance();
    final storedLevel = preferences.getInt(_phoenixLevelKey);
    final migratedLevel = _agent.phoenixLevelFromStorage(
      preferences.getString(_profileKey),
    );
    final level = PhoenixLevelController.instance.setLevel(
      storedLevel ?? migratedLevel ?? PhoenixLevelController.defaultLevel,
    );
    await Future.wait([
      preferences.setInt(_phoenixLevelKey, level),
      preferences.setString(
        _profileKey,
        _agent.profileForPhoenixLevel(level).storageValue,
      ),
      preferences.setBool(_promptSeenKey, true),
    ]);
    return level;
  }

  Future<ChineseProficiencyProfile?> load() async {
    await initializePhoenixLevel();
    return PhoenixLevelController.instance.profile;
  }

  Future<bool> shouldShowJourneyPrompt() async => false;

  Future<void> markJourneyPromptSeen() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_promptSeenKey, true);
  }

  Future<void> save(ChineseProficiencyProfile profile) async {
    final level = profile.isPhoenix
        ? profile.phoenixLevel!
        : _agent.phoenixLevelFromStorage(profile.storageValue) ??
            PhoenixLevelController.defaultLevel;
    await savePhoenixLevel(level);
  }

  Future<void> savePhoenixLevel(int level) async {
    final safeLevel = PhoenixLevelController.instance.setLevel(level);
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setInt(_phoenixLevelKey, safeLevel),
      preferences.setString(
        _profileKey,
        _agent.profileForPhoenixLevel(safeLevel).storageValue,
      ),
      preferences.setBool(_promptSeenKey, true),
    ]);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.remove(_profileKey),
      preferences.remove(_phoenixLevelKey),
      preferences.remove(_promptSeenKey),
    ]);
    PhoenixLevelController.instance.setLevel(
      PhoenixLevelController.defaultLevel,
    );
  }
}
