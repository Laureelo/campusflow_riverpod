import 'package:go_router/go_router.dart';

import '../screens/courses_list.dart';
import '../screens/deadlines_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shell_scaffold.dart';
import '../screens/task_detail.dart';
import '../screens/task_form.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/tasks',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const DeadlinesScreen(),
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) => const CoursesList(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/tasks/new',
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
          return TaskDetailScreen(taskId: id);
        },
      ),
    ],
  );
}
