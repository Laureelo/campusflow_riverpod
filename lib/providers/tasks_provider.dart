import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';
import '../models/task.dart';

class TasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => buildSampleTasks();

  void add({
    required String title,
    required DateTime dueDate,
    required int courseId,
  }) {
    final lastId = state.fold<int>(0, (max, task) => task.id > max ? task.id : max);
    final task = Task(
      id: lastId + 1,
      title: title,
      dueDate: dueDate,
      courseId: courseId,
    );
    state = [...state, task];
  }

  void toggle(int id) {
    state = [
      for (final task in state)
        task.id == id ? task.copyWith(done: !task.done) : task,
    ];
  }

  void markDone(int id) {
    state = [
      for (final task in state)
        task.id == id ? task.copyWith(done: true) : task,
    ];
  }
}

final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);
