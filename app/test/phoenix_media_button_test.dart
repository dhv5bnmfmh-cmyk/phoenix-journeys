import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/phoenix_media_button.dart';

void main() {
  testWidgets('shows play and pause states and handles taps', (tester) async {
    var tapCount = 0;

    Future<void> pumpButton(bool isPlaying) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PhoenixMediaButton(
                isPlaying: isPlaying,
                tooltip: isPlaying ? '暂停朗读' : '开始朗读',
                onPressed: () => tapCount += 1,
              ),
            ),
          ),
        ),
      );
    }

    await pumpButton(false);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byTooltip('开始朗读'), findsOneWidget);
    await tester.tap(find.byType(PhoenixMediaButton));
    expect(tapCount, 1);

    await pumpButton(true);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.byTooltip('暂停朗读'), findsOneWidget);
  });
}
