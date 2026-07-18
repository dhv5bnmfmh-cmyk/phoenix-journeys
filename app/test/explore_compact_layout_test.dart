import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/screens/explore_screen.dart';

void main() {
  test('uses a compact map height for short phone viewports', () {
    expect(compactExploreMapHeight(680), 160);
    expect(compactExploreMapHeight(760), 174);
  });

  test('switches to the regular compact height at the phone boundary', () {
    expect(compactExploreMapHeight(819), 174);
    expect(compactExploreMapHeight(820), 188);
  });

  test('caps the regular phone map at a one-screen-friendly height', () {
    expect(compactExploreMapHeight(850), 188);
  });
}
