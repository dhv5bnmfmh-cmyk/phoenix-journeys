import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and restores vocabulary selections', () async {
    final state = AppState();
    await state.load();

    await state.toggleSavedWord('故宫');

    expect(state.isWordSaved('故宫'), isTrue);

    final restoredState = AppState();
    await restoredState.load();

    expect(restoredState.isWordSaved('故宫'), isTrue);
  });


  test('latest narration persistence wins across queued clear and save', () async {
    final state = AppState();
    await state.load();

    final oldSave = state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'old-signature',
      offset: 12,
    );
    final delayedClear = state.clearJourneyNarrationPosition();
    final latestSave = state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'latest-signature',
      offset: 34,
    );

    await Future.wait([oldSave, delayedClear, latestSave]);

    expect(state.journeyNarrationContentId, 'story');
    expect(state.journeyNarrationContentSignature, 'latest-signature');
    expect(state.journeyNarrationOffset, 34);
    expect(state.journeyNarrationSignatureFor('story'), 'latest-signature');
    expect(state.journeyNarrationOffsetFor('story'), 34);

    final preferences = await SharedPreferences.getInstance();
    final contentIdKey = preferences
        .getKeys()
        .singleWhere((key) => key.endsWith('.narrationContentId'));
    final signatureKey = preferences
        .getKeys()
        .singleWhere((key) => key.endsWith('.narrationContentSignature'));
    final offsetKey = preferences
        .getKeys()
        .singleWhere((key) => key.endsWith('.narrationOffset'));
    expect(preferences.getString(contentIdKey), 'story');
    expect(preferences.getString(signatureKey), 'latest-signature');
    expect(preferences.getInt(offsetKey), 34);
  });

  test('removes a saved word when toggled again', () async {
    final state = AppState();
    await state.load();

    await state.toggleSavedWord('故宫');
    await state.toggleSavedWord('故宫');

    expect(state.isWordSaved('故宫'), isFalse);
  });
}
