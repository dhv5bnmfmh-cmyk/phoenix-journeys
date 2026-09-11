import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';

QuestionDesignSignature _signature(String id) => QuestionDesignSignature(
      journeyId: 'beijing-forbidden-city',
      sessionLevel: 2,
      mode: StoryChallengeMode.scenarioDecision,
      sourceParagraphIndex: 0,
      sourceSentenceIndex: 0,
      sourceHash: id,
      syntaxPattern: 'scenario-decision',
      operationType: 'choose',
      errorFamily: null,
      gapType: null,
      answerShape: 'choice',
      distractorStrategy: 'contrast',
      templateSignature: id,
      semanticSignature: id,
    );

StoryChallengeQuestion _question({
  required String id,
  required String prompt,
  required String narration,
  required String answer,
  required List<String> options,
  required List<String> rationales,
  required String whyCorrect,
}) =>
    StoryChallengeQuestion(
      id: id,
      mode: StoryChallengeMode.scenarioDecision,
      sourceSentence: prompt,
      prompt: prompt,
      answer: answer,
      options: options,
      signature: _signature(id),
      narrationText: narration,
      distractorRationales: rationales,
      whyCorrect: whyCorrect,
      learningObjective: 'device regression',
      difficulty: 'Lv2',
    );

class _ChallengeHost extends StatefulWidget {
  const _ChallengeHost({
    required this.questionAudio,
    required this.feedbackAudio,
    required this.onResetAudio,
  });

  final List<String> questionAudio;
  final List<String> feedbackAudio;
  final VoidCallback onResetAudio;

  @override
  State<_ChallengeHost> createState() => _ChallengeHostState();
}

class _ChallengeHostState extends State<_ChallengeHost> {
  bool resolved = false;

  late final StoryChallengeSet challenge = StoryChallengeSet(
    journeyId: 'beijing-forbidden-city',
    sessionLevel: 2,
    questions: <StoryChallengeQuestion>[
      _question(
        id: 'q1',
        prompt: '第一题',
        narration: '题目音频一',
        answer: '正确答案一',
        options: const ['错误选项一', '正确答案一', '干扰二', '干扰三'],
        rationales: const ['错误选项一忽略了路线条件', '', '', ''],
        whyCorrect: '正确答案一保留了完整条件',
      ),
      _question(
        id: 'q2',
        prompt: '第二题',
        narration: '题目音频二',
        answer: '正确答案二',
        options: const ['干扰一', '正确答案二', '干扰二', '干扰三'],
        rationales: const ['', '', '', ''],
        whyCorrect: '正确答案二符合当前情境',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: HskStoryChallenge(
                challenge: challenge,
                displayText: (value) => value,
                onNarrate: (questionId, text) async {
                  widget.questionAudio.add('$questionId:$text');
                },
                onFeedbackAudio: (questionId, text) async {
                  widget.feedbackAudio.add('$questionId:$text');
                },
                onQuestionChanged: widget.onResetAudio,
                onCompleted: () async {
                  setState(() => resolved = true);
                },
              ),
            ),
            if (resolved)
              SafeArea(
                top: false,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        key: const ValueKey('outer-stage-back'),
                        onPressed: () {},
                        child: const Text('上一步'),
                      ),
                    ),
                    Expanded(
                      child: FilledButton(
                        key: const ValueKey('outer-stage-continue'),
                        onPressed: () {},
                        child: const Text('继续留下回忆'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
    'Founder device challenge navigation and feedback audio remain isolated',
    (tester) async {
      final questionAudio = <String>[];
      final feedbackAudio = <String>[];
      var resetCount = 0;

      await tester.pumpWidget(
        _ChallengeHost(
          questionAudio: questionAudio,
          feedbackAudio: feedbackAudio,
          onResetAudio: () => resetCount += 1,
        ),
      );

      expect(
        find.byKey(const ValueKey('challenge-feedback-speaker-q1')),
        findsNothing,
      );
      expect(find.byKey(const ValueKey('outer-stage-continue')), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('challenge-question-speaker-q1')),
      );
      await tester.pump();
      expect(questionAudio, ['q1:题目音频一']);

      await tester.tap(find.byKey(const ValueKey('challenge-option-0')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('challenge-feedback-speaker-q1')),
        findsOneWidget,
      );
      expect(feedbackAudio, hasLength(1));
      expect(feedbackAudio.last, contains('正确答案：正确答案一'));
      expect(feedbackAudio.last, contains('错误原因：错误选项一忽略了路线条件'));
      expect(feedbackAudio.last, contains('解释：正确答案一保留了完整条件'));
      expect(feedbackAudio.last, isNot(contains('题目音频一')));

      await tester.tap(
        find.byKey(const ValueKey('challenge-feedback-speaker-q1')),
      );
      await tester.pump();
      expect(feedbackAudio, hasLength(2));
      expect(feedbackAudio.last, contains('正确答案：正确答案一'));

      await tester.tap(find.byKey(const ValueKey('challenge-next')));
      await tester.pumpAndSettle();
      expect(resetCount, 1);
      expect(
        find.byKey(const ValueKey('challenge-feedback-speaker-q1')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('challenge-feedback-speaker-q2')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('challenge-question-speaker-q2')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('outer-stage-continue')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('challenge-option-1')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('challenge-submit')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('challenge-feedback-speaker-q2')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('challenge-next')), findsOneWidget);
      expect(find.byKey(const ValueKey('outer-stage-continue')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('challenge-next')));
      await tester.pumpAndSettle();

      expect(resetCount, 2);
      expect(find.byKey(const ValueKey('challenge-next')), findsNothing);
      expect(find.byKey(const ValueKey('challenge-back')), findsNothing);
      expect(find.byKey(const ValueKey('outer-stage-back')), findsOneWidget);
      expect(
          find.byKey(const ValueKey('outer-stage-continue')), findsOneWidget);
    },
  );
}
