import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/phoenix_media_button.dart';

void main() {
  testWidgets('shows play and pause states', (tester) async {
    Future<void> pumpButton(bool isPlaying) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhoenixMediaButton(
              isPlaying: isPlaying,
              tooltip: isPlaying ? '暂停朗读' : '开始朗读',
              onPressed: () {},
            ),
          ),
        ),
      );
    }

    await pumpButton(false);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

    await pumpButton(true);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
  });
}
