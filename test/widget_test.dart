import 'package:campusflow_riverpod/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the deadlines list with the navigation bar', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));

    expect(find.text('Submit the Flutter assignment'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);

    await tester.tap(find.text('Courses'));
    await tester.pump();

    expect(find.text('Mobile Programming'), findsOneWidget);
  });

  testWidgets('opens the detail screen and marks a task as done', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));

    await tester.tap(find.text('Submit the Flutter assignment'));
    await tester.pumpAndSettle();

    expect(find.text('Mark as done'), findsOneWidget);
    expect(find.text('Status: To do'), findsOneWidget);

    await tester.tap(find.text('Mark as done'));
    await tester.pumpAndSettle();

    expect(find.text('Mark as done'), findsNothing);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
  });

  testWidgets('shows the list and the detail side by side on a wide screen',
      (tester) async {
    tester.view.physicalSize = const Size(1000, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));

    expect(find.text('Select a deadline'), findsOneWidget);

    await tester.tap(find.text('Submit the Flutter assignment'));
    await tester.pumpAndSettle();

    expect(find.text('Mark as done'), findsOneWidget);
    expect(find.text('Submit the Flutter assignment'), findsNWidgets(2));

    await tester.tap(find.text('Mark as done'));
    await tester.pumpAndSettle();

    expect(find.text('Status: Done'), findsOneWidget);
  });

  testWidgets('keeps a single column on a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));

    expect(find.text('Select a deadline'), findsNothing);
  });

  testWidgets('the form validates then adds a deadline', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));

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
