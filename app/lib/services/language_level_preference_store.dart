import 'package:shared_preferences/shared_preferences.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';

class LanguageLevelPreferenceStore {
  const LanguageLevelPreferenceStore();

  static const String _profileKey = 'phoenix.languageProficiency';
  static const String _promptSeenKey =
      'phoenix.languageProficiencyPromptSeen';

  Future<ChineseProficiencyProfile?> load() async {
    final preferences = await SharedPreferences.getInstance();
    return const PhoenixLanguageLevelAgent().profileFromStorage(
      preferences.getString(_profileKey),
    );
  }

  Future<bool> shouldShowJourneyPrompt() async {
    final preferences = await SharedPreferences.getInstance();
    final hasProfile = preferences.getString(_profileKey)?.isNotEmpty ?? false;
    final promptSeen = preferences.getBool(_promptSeenKey) ?? false;
    return !hasProfile && !promptSeen;
  }

  Future<void> markJourneyPromptSeen() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_promptSeenKey, true);
  }

  Future<void> save(ChineseProficiencyProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileKey, profile.storageValue);
    await preferences.setBool(_promptSeenKey, true);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_profileKey);
    await preferences.remove(_promptSeenKey);
  }
}
