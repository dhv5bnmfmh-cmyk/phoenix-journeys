import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';

void main() {
  testWidgets(
    'correct Grammar location plus wrong repair shows 修改错误 without 错误位置',
    (tester) async {
      const correct = '因为紫禁城沿中轴展开，所以层次清楚。';
      const broken = '虽然紫禁城沿中轴展开，所以层次清楚。';
      const challenge = StoryChallengeSet(
        journeyId: 'beijing-forbidden-city',
        sessionLevel: 1,
        questions: <StoryChallengeQuestion>[
          StoryChallengeQuestion(
            id: 'grammar-1',
            mode: StoryChallengeMode.grammarRepair,
            sourceSentence: correct,
            prompt: broken,
            answer: correct,
            options: <String>[
              '虽然紫禁城沿中轴展开，但是层次清楚。',
              correct,
              '不但紫禁城沿中轴展开，所以层次清楚。',
              '由于紫禁城沿中轴展开，但是层次清楚。',
            ],
            errorSegments: <String>[
              '虽然',
              '紫禁城沿中轴展开，',
              '所以',
              '层次清楚。',
            ],
            errorSegmentIndex: 0,
            grammarFamily: '关联词错误',
            grammarWhyWrong: '这里表达因果关系，应使用“因为……所以……”。',
            grammarRevisionRule: '关联词应与句子的逻辑关系一致。',
            grammarOptionExplanations: <String>[
              '错。这里不是转折关系。',
              '对。因果关系正确。',
              '错。关联词不配对。',
              '错。因果与转折混用。',
            ],
            narrationText: broken,
            signature: QuestionDesignSignature(
              journeyId: 'beijing-forbidden-city',
              sessionLevel: 1,
              mode: StoryChallengeMode.grammarRepair,
              sourceParagraphIndex: 0,
              sourceSentenceIndex: 0,
              sourceHash: 'grammar-feedback-marker',
              syntaxPattern: '因果结构',
              operationType: '完整病句→定位错误→选择完整修正',
              errorFamily: '关联词错误',
              gapType: null,
              answerShape: '完整修正句',
              distractorStrategy: '关联词配对误项 / Band 1',
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 390,
              height: 760,
              child: HskStoryChallenge(
                challenge: challenge,
                displayText: (value) => value,
                onCompleted: () async {},
                onNarrate: (_, __) async {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('A  虽然'));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
      expect(find.text('位置正确'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();
      expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);

      await tester.tap(
        find.text('A  虽然紫禁城沿中轴展开，但是层次清楚。'),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('grammar-repair-feedback')),
        findsOneWidget,
      );
      expect(find.text('修改错误'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('grammar-error-location')),
        findsNothing,
      );
      expect(find.textContaining('为什么不对：'), findsOneWidget);
      expect(find.textContaining('正确答案：$correct'), findsOneWidget);
    },
  );
}
