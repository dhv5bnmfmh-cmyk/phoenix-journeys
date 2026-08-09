import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/screens/city_passport_screen.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Passport drills from continent to country and one city', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState(clock: () => DateTime(2026, 7, 22));
    await state.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(body: CityPassportScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('探索护照'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('passport-hd-atlas-image')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-pinch-zoom-map')),
      findsOneWidget,
    );
    expect(find.text('双指缩放查看地图'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('passport-continent-asia')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-country-china')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsNothing,
    );
    expect(find.text('北京收藏册'), findsNothing);
    expect(find.text('紫禁城'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('passport-country-china')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('passport-province-beijing')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(const ValueKey('passport-province-beijing')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('passport-city-option-beijing')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('passport-city-beijing')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'passport-place-option-beijing-forbidden-city',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'passport-place-option-beijing-summer-palace',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('passport-place-back')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('passport-city-beijing')));
    await tester.pumpAndSettle();

    expect(find.text('北京 · 选择旅程'), findsOneWidget);
    expect(
      find.byKey(
        const ValueKey('passport-destination-beijing-forbidden-city'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('passport-destination-beijing-summer-palace'),
      ),
      findsOneWidget,
    );
    expect(find.text('紫禁城'), findsNWidgets(2));
    expect(find.text('颐和园'), findsNWidgets(2));
  });

  testWidgets('map locks base position and bounds zoomed panning', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState(clock: () => DateTime(2026, 7, 22));
    await state.load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(body: CityPassportScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final viewport = find.byKey(const ValueKey('passport-map-viewport'));
    final viewerFinder = find.byKey(
      const ValueKey('passport-pinch-zoom-map'),
    );
    final initialViewport = tester.getRect(viewport);
    final initialContent = tester.getSize(
      find.byKey(const ValueKey('passport-map-content')),
    );
    final viewer = tester.widget<InteractiveViewer>(viewerFinder);

    expect(viewer.panEnabled, isTrue);
    expect(viewer.scaleEnabled, isTrue);
    expect(viewer.minScale, 1);
    expect(viewer.boundaryMargin, EdgeInsets.zero);
    expect(viewer.transformationController, isNotNull);

    await tester.drag(viewerFinder, const Offset(90, 70));
    await tester.pumpAndSettle();

    expect(viewer.transformationController!.value, Matrix4.identity());
    expect(tester.getRect(viewport), initialViewport);
    expect(
      tester.getSize(find.byKey(const ValueKey('passport-map-content'))),
      initialContent,
    );

    final center = tester.getCenter(viewerFinder);
    final firstFinger = await tester.startGesture(
      center - const Offset(30, 0),
      pointer: 1,
    );
    final secondFinger = await tester.startGesture(
      center + const Offset(30, 0),
      pointer: 2,
    );
    await firstFinger.moveTo(center - const Offset(70, 0));
    await secondFinger.moveTo(center + const Offset(70, 0));
    await tester.pump();
    await firstFinger.up();
    await secondFinger.up();
    await tester.pumpAndSettle();

    await tester.drag(viewerFinder, const Offset(500, 500));
    await tester.pumpAndSettle();

    final zoomedTransform = viewer.transformationController!.value;
    final scale = zoomedTransform.getMaxScaleOnAxis();
    final translationX = zoomedTransform.storage[12];
    final translationY = zoomedTransform.storage[13];
    expect(scale, greaterThan(1));
    expect(
      translationX,
      inInclusiveRange(initialViewport.width * (1 - scale), 0),
    );
    expect(
      translationY,
      inInclusiveRange(initialViewport.height * (1 - scale), 0),
    );
    expect(tester.getRect(viewport), initialViewport);

    viewer.transformationController!.value = Matrix4.identity()
      ..translateByDouble(24, 18, 0, 1);
    viewer.onInteractionEnd!(ScaleEndDetails());
    await tester.pump();
    expect(viewer.transformationController!.value, Matrix4.identity());

    final clip = tester.widget<ClipRRect>(
      find.descendant(of: viewport, matching: find.byType(ClipRRect)).first,
    );
    expect(clip.clipBehavior, Clip.hardEdge);
    expect(clip.borderRadius, BorderRadius.circular(18));
    expect(tester.takeException(), isNull);
  });

  testWidgets('map-level changes reset zoom and translation', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = AppState(clock: () => DateTime(2026, 7, 22));
    await state.load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(
          home: Scaffold(body: CityPassportScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final viewport = find.byKey(const ValueKey('passport-map-viewport'));
    final initialViewport = tester.getRect(viewport);
    final viewer = tester.widget<InteractiveViewer>(
      find.byKey(const ValueKey('passport-pinch-zoom-map')),
    );
    final controller = viewer.transformationController!;

    void setZoomedTransform() {
      controller.value = Matrix4.identity()
        ..translateByDouble(-30, -40, 0, 1)
        ..scaleByDouble(2, 2, 1, 1);
    }

    setZoomedTransform();
    await tester.tap(find.byKey(const ValueKey('passport-country-china')));
    await tester.pumpAndSettle();
    expect(controller.value, Matrix4.identity());
    expect(tester.getRect(viewport), initialViewport);

    setZoomedTransform();
    await tester.tap(
      find.byKey(const ValueKey('passport-province-heilongjiang')),
    );
    await tester.pumpAndSettle();
    expect(controller.value, Matrix4.identity());
    expect(tester.getRect(viewport), initialViewport);

    setZoomedTransform();
    await tester.tap(
      find.byKey(const ValueKey('passport-city-option-harbin')),
    );
    await tester.pumpAndSettle();
    expect(controller.value, Matrix4.identity());
    expect(tester.getRect(viewport), initialViewport);
    expect(
      find.byKey(const ValueKey('passport-city-harbin')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final size in const <Size>[
    Size(320, 667),
    Size(390, 844),
    Size(430, 932),
    Size(412, 915),
  ]) {
    testWidgets('Passport viewport fits mobile ${size.width}x${size.height}', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final state = AppState(clock: () => DateTime(2026, 7, 22));
      await state.load();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: state,
          child: const MaterialApp(
            home: Scaffold(body: CityPassportScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final viewportRect = tester.getRect(
        find.byKey(const ValueKey('passport-map-viewport')),
      );
      expect(viewportRect.width, greaterThanOrEqualTo(198));
      expect(viewportRect.height, greaterThan(0));
      expect(viewportRect.left, greaterThanOrEqualTo(0));
      expect(viewportRect.right, lessThanOrEqualTo(size.width));
      expect(viewportRect.bottom, lessThanOrEqualTo(size.height));
      expect(tester.takeException(), isNull);
    });
  }
}
