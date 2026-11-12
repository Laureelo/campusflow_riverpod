import 'package:campusflow_riverpod/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<GoRouter> pumpRouter(WidgetTester tester) async {
  final router = buildRouter();
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(child: MaterialApp.router(routerConfig: router)),
  );
  return router;
}

String currentPath(GoRouter router) {
  return router.routeInformationProvider.value.uri.path;
}

void main() {
  testWidgets('starts on the deadlines list', (tester) async {
    final router = await pumpRouter(tester);

    expect(currentPath(router), '/tasks');
    expect(find.text('Submit the Flutter assignment'), findsOneWidget);
  });

  testWidgets('the id in the path opens the matching task', (tester) async {
    final router = await pumpRouter(tester);

    router.go('/tasks/2');
    await tester.pumpAndSettle();

    expect(find.text('Review the SQL joins'), findsOneWidget);
    expect(find.text('Status: Overdue'), findsOneWidget);
  });

  testWidgets('an unknown id shows a not found message', (tester) async {
    final router = await pumpRouter(tester);

    router.go('/tasks/999');
    await tester.pumpAndSettle();
    expect(find.text('Task not found'), findsOneWidget);

    router.go('/tasks/abc');
    await tester.pumpAndSettle();
    expect(find.text('Task not found'), findsOneWidget);
  });

  testWidgets('/tasks/new opens the form and is not read as an id',
      (tester) async {
    final router = await pumpRouter(tester);

    router.go('/tasks/new');
    await tester.pumpAndSettle();

    expect(find.text('New deadline'), findsOneWidget);
    expect(find.text('Task not found'), findsNothing);
  });

  testWidgets('the navigation bar switches between the three destinations',
      (tester) async {
    final router = await pumpRouter(tester);

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/courses');
    expect(find.text('Mobile Programming'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/profile');
    expect(find.text('awa@campus.test'), findsOneWidget);

    await tester.tap(find.text('Deadlines'));
    await tester.pumpAndSettle();
    expect(currentPath(router), '/tasks');
  });
}
