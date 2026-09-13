import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_startup_metadata.dart';

void main() {
  test('Forbidden City startup copy separates shared space from route choice', () {
    final description =
        requireJourneyStartupMetadata('beijing-forbidden-city').description;

    expect(description, contains('相同的宫殿空间条件'));
    expect(description, contains('不同任务'));
    expect(description, contains('路线选择'));
    expect(description, isNot(contains('宫殿空间怎样因身份与目的而改变')));
  });
}
