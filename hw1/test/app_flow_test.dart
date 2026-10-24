import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';

Future<void> startApp(
  WidgetTester tester, {
  Size size = const Size(430, 932),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  // Use the shipped font, rather than the deliberately wide test-only Ahem.
  for (final entry in {
    400: 'Regular',
    600: 'SemiBold',
    700: 'Bold',
    800: 'ExtraBold',
  }.entries) {
    final loader = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope-${entry.value}.ttf'));
    await loader.load();
  }
  await tester.pumpWidget(const CampusApp());
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'shared filters and favorite state work across tabs and details',
    (tester) async {
      await startApp(tester);
      await tester.enterText(
        find.byKey(const ValueKey('event-search')),
        '  FLUTTER  ',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'filter-Technology');
      expect(find.text('1 event'), findsOneWidget);
      await tapKey(tester, 'favorite-tech-01');
      await tester.tap(find.text('Favorites (1)'));
      await tester.pumpAndSettle();
      expect(find.text('1 event'), findsOneWidget);
      expect(find.widgetWithText(TextField, '  FLUTTER  '), findsOneWidget);
      await tapKey(tester, 'details-tech-01');
      await tapKey(tester, 'details-favorite');
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('No events found'), findsOneWidget);
      await tapKey(tester, 'empty-action');
      expect(find.text('Your next favorite is out there.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'last place: No and dismiss preserve seats, Yes joins, cancel restores',
    (tester) async {
      await startApp(tester);
      await tester.enterText(
        find.byKey(const ValueKey('event-search')),
        'tennis',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'details-sports-01');
      expect(find.text('1 of 16 places available'), findsOneWidget);
      await tapKey(tester, 'participation-button');
      expect(find.text('Friday, Oct 30, 2026 · 16:30'), findsOneWidget);
      await tapKey(tester, 'confirm-no');
      expect(find.text('1 of 16 places available'), findsOneWidget);
      await tapKey(tester, 'participation-button');
      await tester.tapAt(const Offset(8, 80));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('1 of 16 places available'), findsOneWidget);
      await tapKey(tester, 'participation-button');
      await tapKey(tester, 'confirm-yes');
      expect(find.text('0 of 16 places available'), findsOneWidget);
      expect(find.text('Cancel participation'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Events (1)'));
      await tester.pumpAndSettle();
      expect(find.text('1 event'), findsOneWidget);
      await tapKey(tester, 'details-sports-01');
      await tapKey(tester, 'participation-button');
      expect(find.text('Cancel participation?'), findsOneWidget);
      await tapKey(tester, 'confirm-no');
      expect(find.text('0 of 16 places available'), findsOneWidget);
      await tapKey(tester, 'participation-button');
      await tapKey(tester, 'confirm-yes');
      expect(find.text('1 of 16 places available'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('No events found'), findsOneWidget);
      expect(find.text('My Events (0)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'full event is disabled and image viewer has normal Back navigation',
    (tester) async {
      await startApp(tester);
      await tester.enterText(
        find.byKey(const ValueKey('event-search')),
        'AI Ideas',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'details-tech-02');
      expect(
        tester
            .widget<FilledButton>(
              find.byKey(const ValueKey('participation-button')),
            )
            .onPressed,
        isNull,
      );
      final image = find.byKey(const ValueKey('details-image'));
      await tester.tap(image);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tap(image);
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('The details'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('1 event'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'empty search can be cleared and narrow phone layout has no overflow',
    (tester) async {
      await startApp(tester, size: const Size(360, 800));
      await tester.enterText(
        find.byKey(const ValueKey('event-search')),
        'nothing-matches',
      );
      await tester.pumpAndSettle();
      expect(find.text('No events found'), findsOneWidget);
      await tapKey(tester, 'clear-search');
      expect(find.text('6 events'), findsOneWidget);
      await tapKey(tester, 'details-tech-01');
      expect(tester.takeException(), isNull);
    },
  );
}
