import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/journey_picker_sheet.dart';

void main() {
  testWidgets('traveler selects a city before opening its destination', (
    tester,
  ) async {
    final state = AppState(clock: () => DateTime(2026, 7, 22));
    String? selectedJourneyId;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  selectedJourneyId = await showJourneyPickerSheet(
                    context: context,
                    state: state,
                  );
                },
                child: const Text('open picker'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open picker'));
    await tester.pumpAndSettle();

    expect(find.text('选择城市与地点'), findsOneWidget);
    expect(find.byKey(const ValueKey('journey-city-beijing')), findsOneWidget);
    expect(find.byKey(const ValueKey('journey-city-shanghai')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('journey-city-shanghai')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('journey-destination-shanghai-bund')),
      findsOneWidget,
    );
    expect(find.text('上海的地点'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('journey-destination-shanghai-bund')),
    );
    await tester.pumpAndSettle();

    expect(selectedJourneyId, 'shanghai-bund');
  });
}
