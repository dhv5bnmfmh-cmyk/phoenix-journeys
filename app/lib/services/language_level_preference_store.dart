import 'package:shared_preferences/shared_preferences.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';

class LanguageLevelPreferenceStore {
  const LanguageLevelPreferenceStore();

  static const String _profileKey = 'phoenix.languageProficiency';

  Future<ChineseProficiencyProfile?> load() async {
    final preferences = await SharedPreferences.getInstance();
    return const PhoenixLanguageLevelAgent().profileFromStorage(
      preferences.getString(_profileKey),
    );
  }

  Future<void> save(ChineseProficiencyProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileKey, profile.storageValue);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_profileKey);
  }
}
