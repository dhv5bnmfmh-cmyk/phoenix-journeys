import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_data.dart';
import 'package:phoenix_journeys/widgets/annotated_reading_card.dart';

void main() {
  testWidgets('tiny note button reveals pinyin native language and English',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnnotatedReadingCard(
            id: 'sample',
            mainText: Text('清晨，北京的天空刚刚泛白。'),
            pinyin: 'Qīngchén, Běijīng de tiānkōng gānggāng fànbái.',
            nativeLabel: '探索者母语 · 越南语',
            nativeText: 'Sáng sớm, bầu trời Bắc Kinh vừa hửng sáng.',
            english: 'At dawn, the sky over Beijing begins to brighten.',
          ),
        ),
      ),
    );

    expect(find.text('注'), findsOneWidget);
    expect(find.text('拼音'), findsNothing);
    expect(find.text('English'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('annotation-toggle-sample')));
    await tester.pumpAndSettle();

    expect(find.text('收'), findsOneWidget);
    expect(find.text('拼音'), findsOneWidget);
    expect(find.text('探索者母语 · 越南语'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.textContaining('Qīngchén'), findsOneWidget);
  });

  test('all Beijing words include word class English and three examples', () {
    for (final word in words) {
      expect(word.partOfSpeech.trim(), isNotEmpty, reason: word.word);
      expect(word.englishDefinition.trim(), isNotEmpty, reason: word.word);
      expect(word.studyExamples, hasLength(3), reason: word.word);
      for (final example in word.studyExamples) {
        expect(example.chinese.trim(), isNotEmpty, reason: word.word);
        expect(example.pinyin.trim(), isNotEmpty, reason: word.word);
        expect(example.vietnamese.trim(), isNotEmpty, reason: word.word);
        expect(example.english.trim(), isNotEmpty, reason: word.word);
      }
    }
  });

  test('every story paragraph has a complete hidden annotation', () {
    expect(storyAnnotations, hasLength(storyParagraphs.length));

    for (final annotation in storyAnnotations) {
      expect(annotation.pinyin.trim(), isNotEmpty);
      expect(annotation.vietnamese.trim(), isNotEmpty);
      expect(annotation.english.trim(), isNotEmpty);
    }
  });
}
