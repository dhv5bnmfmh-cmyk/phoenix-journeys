import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/services/phoenix_ai_service.dart';
import 'package:phoenix_journeys/widgets/phoenix_agent_cards.dart';

void main() {
  testWidgets('guide card identifies PhoenixGuideAgent as online',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PhoenixGuideReplyCard(
            feedback: PhoenixGuideFeedback(
              reply: '红墙是一个很好的观察入口。',
              isOfflineFallback: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('PhoenixGuideAgent'), findsOneWidget);
    expect(find.text('AI 在线'), findsOneWidget);
    expect(find.textContaining('红墙'), findsOneWidget);
  });

  testWidgets('guide fallback is clearly marked as local', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PhoenixGuideReplyCard(
            feedback: PhoenixGuideFeedback(
              reply: '本地建议：请补充一个具体细节。',
              isOfflineFallback: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('本地建议'), findsOneWidget);
    expect(find.text('AI 在线'), findsNothing);
  });

  testWidgets('writing card separates correction and natural expression',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PhoenixWritingFeedbackCard(
              feedback: PhoenixWritingFeedback(
                corrected: '我最想参观太和殿，因为它很壮观。',
                explanation: '原因分句前需要逗号。',
                natural: '我最想去看看雄伟的太和殿。',
                encouragement: '你的重点很清楚。',
                isOfflineFallback: false,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('PhoenixWritingAgent'), findsOneWidget);
    expect(find.text('修改后'), findsOneWidget);
    expect(find.text('为什么这样改'), findsOneWidget);
    expect(find.text('更自然的表达'), findsOneWidget);
    expect(find.text('给你的回应'), findsOneWidget);
  });
}
