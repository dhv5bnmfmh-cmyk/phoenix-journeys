import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/language_level_preference_store.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const store = LanguageLevelPreferenceStore();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    PhoenixLevelController.instance.setLevel(
      PhoenixLevelController.defaultLevel,
    );
  });

  test('new explorers start at Phoenix level five', () async {
    expect(await store.initializePhoenixLevel(), 5);
    expect((await store.load())?.displayLabel, 'Lv.5');
    expect(await store.shouldShowJourneyPrompt(), isFalse);
  });

  test('saving a Phoenix level persists the unified profile', () async {
    await store.savePhoenixLevel(8);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('phoenix.level'), 8);
    expect(preferences.getString('phoenix.languageProficiency'), 'phoenix:8');
    expect((await store.load())?.displayLabel, 'Lv.8');
  });

  test('legacy HSK and TOCFL settings migrate to nearby Phoenix levels', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.languageProficiency': 'hsk:6',
    });
    expect(await store.initializePhoenixLevel(), 8);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'phoenix.languageProficiency': 'tocfl:4',
    });
    expect(await store.initializePhoenixLevel(), 7);
  });

  test('levels clamp between one and ten', () async {
    await store.savePhoenixLevel(-4);
    expect(PhoenixLevelController.instance.level, 1);

    await store.savePhoenixLevel(99);
    expect(PhoenixLevelController.instance.level, 10);
  });

  test('clearing preferences returns to the default level', () async {
    await store.savePhoenixLevel(9);
    await store.clear();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('phoenix.level'), isNull);
    expect(PhoenixLevelController.instance.level, 5);
  });
}
