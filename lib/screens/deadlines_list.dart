import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/courses_provider.dart';
import '../providers/filter_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/format.dart';

const Map<TaskFilter, String> _filterLabels = {
  TaskFilter.all: 'All',
  TaskFilter.todo: 'To do',
  TaskFilter.done: 'Done',
  TaskFilter.overdue: 'Overdue',
};

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(filterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          for (final filter in TaskFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_filterLabels[filter]!),
                selected: filter == selected,
                onSelected: (_) =>
                    ref.read(filterProvider.notifier).select(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class DeadlinesList extends ConsumerWidget {
  final ValueChanged<Task> onTaskTap;
  final int? selectedId;

  const DeadlinesList({super.key, required this.onTaskTap, this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final courses = ref.watch(coursesProvider);
    final now = DateTime.now();

    String courseName(int courseId) {
      return courses
              .where((course) => course.id == courseId)
              .map((course) => course.name)
              .firstOrNull ??
          'Unknown course';
    }

    return Column(
      children: [
        const FilterBar(),
        Expanded(
          child: tasks.isEmpty
              ? const Center(child: Text('No tasks for this filter'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      leading: Checkbox(
                        value: task.done,
                        onChanged: (_) =>
                            ref.read(tasksProvider.notifier).toggle(task.id),
                      ),
                      title: Text(
                        task.title,
                        style: task.done
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              )
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
                ),
        ),
      ],
    );
  }
}
