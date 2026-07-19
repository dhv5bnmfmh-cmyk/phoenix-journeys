import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_share_button.dart';

void main() {
  test('simplified share copy contains journey, stamp, and production URL', () {
    final message = JourneyShareCopy.message(traditional: false);

    expect(message, contains('北京·紫禁城'));
    expect(message, contains('城市印章'));
    expect(message, contains(JourneyShareCopy.productionUrl));
  });

  test('traditional share copy uses traditional characters', () {
    final message = JourneyShareCopy.message(traditional: true);

    expect(message, contains('點亮北京'));
    expect(message, contains('獲得了城市印章'));
    expect(message, contains(JourneyShareCopy.productionUrl));
  });
}
