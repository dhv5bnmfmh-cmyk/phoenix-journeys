import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/missing_dynamic_background_styles.dart';

void main() {
  test('all remaining journeys have cinematic background styles', () {
    expect(
      missingJourneyCinematicStyles.keys,
      containsAll(<String>[
        'harbin-central-street',
        'kaifeng-song-capital',
        'huangshan-cloud-peaks',
        'zhangjiajie-wulingyuan',
        'dali-cangshan-erhai',
      ]),
    );
    expect(missingJourneyCinematicStyles.length, 5);
  });

  test('water destinations enable water light', () {
    expect(missingJourneyCinematicStyles['kaifeng-song-capital']!.waterLight, isTrue);
    expect(missingJourneyCinematicStyles['dali-cangshan-erhai']!.waterLight, isTrue);
  });
}
