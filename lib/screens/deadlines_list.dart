import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/task.dart';
import '../utils/format.dart';

class DeadlinesList extends StatelessWidget {
  final List<Task> tasks;
  final List<Course> courses;
  final ValueChanged<Task> onTaskTap;
  final int? selectedId;

  const DeadlinesList({
    super.key,
    required this.tasks,
    required this.courses,
    required this.onTaskTap,
    this.selectedId,
  });

  String _courseName(int courseId) {
    return courses
            .where((course) => course.id == courseId)
            .map((course) => course.name)
            .firstOrNull ??
        'Unknown course';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final overdue = task.isOverdue(now);

        return ListTile(
          leading: Icon(
            task.done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.done ? Colors.green : null,
          ),
          title: Text(
            task.title,
            style: task.done
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(
            '${_courseName(task.courseId)} • ${formatDate(task.dueDate)}',
          ),
          selected: task.id == selectedId,
          onTap: () => onTaskTap(task),
          trailing: overdue
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
