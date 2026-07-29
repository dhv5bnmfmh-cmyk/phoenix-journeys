import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/phoenix_level_controller.dart';

void main() {
  final controller = PhoenixLevelController.instance;

  setUp(() {
    controller.setLevel(PhoenixLevelController.defaultLevel);
  });

  test('adjusts between one and ten', () {
    expect(controller.level, 5);
    expect(controller.adjust(1), 6);
    expect(controller.profile.displayLabel, 'Lv.6');
    expect(controller.adjust(-2), 4);
    expect(controller.profile.storageValue, 'phoenix:4');
  });

  test('clamps at both boundaries', () {
    expect(controller.setLevel(-100), 1);
    expect(controller.canDecrease, isFalse);
    expect(controller.setLevel(100), 10);
    expect(controller.canIncrease, isFalse);
  });
}
