import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/task.dart';
import '../utils/format.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;
  final Course? course;
  final VoidCallback onMarkDone;

  const TaskDetailView({
    super.key,
    required this.task,
    required this.course,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: task.done ? null : onMarkDone,
            child: const Text('Mark as done'),
          ),
        ],
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final Course? course;
  final VoidCallback onMarkDone;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.course,
    required this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deadline')),
      body: TaskDetailView(task: task, course: course, onMarkDone: onMarkDone),
    );
  }
}
