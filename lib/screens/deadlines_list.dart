import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/courses_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/format.dart';

class DeadlinesList extends ConsumerWidget {
  final ValueChanged<Task> onTaskTap;
  final int? selectedId;

  const DeadlinesList({super.key, required this.onTaskTap, this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final courses = ref.watch(coursesProvider);
    final now = DateTime.now();

    String courseName(int courseId) {
      return courses
              .where((course) => course.id == courseId)
              .map((course) => course.name)
              .firstOrNull ??
          'Unknown course';
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return ListTile(
          leading: Checkbox(
            value: task.done,
            onChanged: (_) => ref.read(tasksProvider.notifier).toggle(task.id),
          ),
          title: Text(
            task.title,
            style: task.done
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(
            '${courseName(task.courseId)} • ${formatDate(task.dueDate)}',
          ),
          selected: task.id == selectedId,
          onTap: () => onTaskTap(task),
          trailing: task.isOverdue(now)
              ? Text(
                  'Overdue',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        );
      },
    );
  }
}
