import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/courses_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/format.dart';

class TaskDetailView extends ConsumerWidget {
  final int taskId;

  const TaskDetailView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref
        .watch(tasksProvider)
        .where((task) => task.id == taskId)
        .firstOrNull;

    if (task == null) {
      return const Center(child: Text('Task not found'));
    }

    final course = ref
        .watch(coursesProvider)
        .where((course) => course.id == task.courseId)
        .firstOrNull;
    final overdue = task.isOverdue(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text('Course: ${course?.name ?? 'Unknown course'}'),
                  Text('Teacher: ${course?.teacher ?? '-'}'),
                  Text('Due date: ${formatDate(task.dueDate)}'),
                  Text(
                    'Status: ${task.done ? 'Done' : overdue ? 'Overdue' : 'To do'}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: task.done
                ? null
                : () => ref.read(tasksProvider.notifier).markDone(task.id),
            child: const Text('Mark as done'),
          ),
        ],
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deadline')),
      body: TaskDetailView(taskId: taskId),
    );
  }
}
