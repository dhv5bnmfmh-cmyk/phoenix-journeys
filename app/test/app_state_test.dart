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

  test('removes a saved word when toggled again', () async {
    final state = AppState();
    await state.load();

    await state.toggleSavedWord('故宫');
    await state.toggleSavedWord('故宫');

    expect(state.isWordSaved('故宫'), isFalse);
  });
}
