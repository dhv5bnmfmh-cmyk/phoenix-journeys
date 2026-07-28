import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/language_level_preference_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const store = LanguageLevelPreferenceStore();
  const agent = PhoenixLanguageLevelAgent();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('first journey prompt appears once when no profile exists', () async {
    expect(await store.shouldShowJourneyPrompt(), isTrue);

    await store.markJourneyPromptSeen();

    expect(await store.shouldShowJourneyPrompt(), isFalse);
  });

  test('saving a profile also suppresses the first journey prompt', () async {
    final profile = agent.profilesFor(ChineseExamTrack.hsk).first;

    await store.save(profile);

    expect(await store.load(), profile);
    expect(await store.shouldShowJourneyPrompt(), isFalse);
  });

  test('clearing preferences restores the first journey prompt', () async {
    final profile = agent.profilesFor(ChineseExamTrack.tocfl).first;
    await store.save(profile);

    await store.clear();

    expect(await store.load(), isNull);
    expect(await store.shouldShowJourneyPrompt(), isTrue);
  });
}
