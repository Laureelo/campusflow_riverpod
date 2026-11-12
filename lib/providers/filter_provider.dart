import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import 'tasks_provider.dart';

enum TaskFilter { all, todo, done, overdue }

class FilterNotifier extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.all;

  void select(TaskFilter filter) => state = filter;
}

final filterProvider = NotifierProvider<FilterNotifier, TaskFilter>(
  FilterNotifier.new,
);

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(filterProvider);
  final now = DateTime.now();

  return switch (filter) {
    TaskFilter.all => tasks,
    TaskFilter.todo => tasks.where((task) => !task.done).toList(),
    TaskFilter.done => tasks.where((task) => task.done).toList(),
    TaskFilter.overdue => tasks.where((task) => task.isOverdue(now)).toList(),
  };
});
