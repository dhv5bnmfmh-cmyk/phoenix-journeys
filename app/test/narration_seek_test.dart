import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/narration_seek.dart';
import 'package:phoenix_journeys/widgets/narration_seek_rail.dart';

void main() {
  test('seek offset clamps progress to the available narration text', () {
    expect(narrationSeekOffset(progress: -.4, totalCharacters: 101), 0);
    expect(narrationSeekOffset(progress: .5, totalCharacters: 101), 50);
    expect(narrationSeekOffset(progress: 1.4, totalCharacters: 101), 100);
    expect(narrationSeekOffset(progress: .8, totalCharacters: 0), 0);
  });

  testWidgets('seek rail reports the final drag position', (tester) async {
    double? started;
    double? updated;
    double? ended;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: NarrationSeekRail(
                value: .2,
                minHeight: 4,
                onSeekStart: (value) => started = value,
                onSeekUpdate: (value) => updated = value,
                onSeekEnd: (value) => ended = value,
              ),
            ),
          ),
        ),
      ),
    );

    final rail = find.byType(NarrationSeekRail);
    final topLeft = tester.getTopLeft(rail);
    final centerY = tester.getCenter(rail).dy;
    final gesture = await tester.startGesture(Offset(topLeft.dx + 40, centerY));
    await gesture.moveTo(Offset(topLeft.dx + 160, centerY));
    await gesture.up();
    await tester.pump();

    // Flutter reports drag start after the pointer crosses the gesture slop,
    // so the exact starting percentage can vary slightly by test runner.
    expect(started, isNotNull);
    expect(started!, inInclusiveRange(.15, .40));
    expect(updated, closeTo(.8, .03));
    expect(ended, closeTo(.8, .03));
  });

  testWidgets('disabled seek rail ignores gestures', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: NarrationSeekRail(
              value: .4,
              minHeight: 4,
              enabled: false,
              onSeekStart: (_) => calls += 1,
              onSeekEnd: (_) => calls += 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(NarrationSeekRail));
    await tester.pump();
    expect(calls, 0);
  });
}
