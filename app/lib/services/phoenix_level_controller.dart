import 'package:flutter/foundation.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';

class PhoenixLevelController extends ValueNotifier<int> {
  PhoenixLevelController._() : super(defaultLevel);

  static const int minimumLevel = 1;
  static const int maximumLevel = 10;
  static const int defaultLevel = 5;
  static final PhoenixLevelController instance = PhoenixLevelController._();
  static const PhoenixLanguageLevelAgent _agent = PhoenixLanguageLevelAgent();

  int get level => value;
  ChineseProficiencyProfile get profile => _agent.profileForPhoenixLevel(value);
  bool get canDecrease => value > minimumLevel;
  bool get canIncrease => value < maximumLevel;

  int setLevel(int level) {
    final safeLevel = level.clamp(minimumLevel, maximumLevel).toInt();
    if (safeLevel != value) value = safeLevel;
    return value;
  }

  int adjust(int delta) => setLevel(value + delta);
}
