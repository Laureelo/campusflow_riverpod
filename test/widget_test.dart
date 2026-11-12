import 'package:campusflow_riverpod/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildApp() => const ProviderScope(child: CampusFlowApp());

void main() {
  testWidgets('shows the deadlines list with the navigation bar', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Submit the Flutter assignment'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text('Overdue')),
      findsOneWidget,
    );

    await tester.tap(find.text('Courses'));
    await tester.pump();

    expect(find.text('Mobile Programming'), findsOneWidget);
  });

  testWidgets('a checkbox toggles the task everywhere', (tester) async {
    await tester.pumpWidget(buildApp());

    final first = find.byType(Checkbox).first;
    expect(tester.widget<Checkbox>(first).value, isFalse);

    await tester.tap(first);
    await tester.pump();

    expect(tester.widget<Checkbox>(first).value, isTrue);
  });

  testWidgets('the detail screen marks the task as done in the list too',
      (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Submit the Flutter assignment'));
    await tester.pumpAndSettle();

    expect(find.text('Status: To do'), findsOneWidget);

    await tester.tap(find.text('Mark as done'));
    await tester.pumpAndSettle();

    expect(find.text('Status: Done'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isTrue);
  });

  testWidgets('shows the list and the detail side by side on a wide screen',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());

    expect(find.text('Select a deadline'), findsOneWidget);

    await tester.tap(find.text('Submit the Flutter assignment'));
    await tester.pumpAndSettle();

    expect(find.text('Mark as done'), findsOneWidget);
    expect(find.text('Submit the Flutter assignment'), findsNWidgets(2));
  });

  testWidgets('the form validates then adds a deadline', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Pick a due date'), findsOneWidget);
    expect(find.text('Pick a course'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Write the report');

    await tester.tap(find.byType(TextFormField).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Databases').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Write the report'), findsOneWidget);
    expect(find.text('Deadline added'), findsOneWidget);
  });
}
