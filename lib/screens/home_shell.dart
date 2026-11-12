import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/course.dart';
import '../models/task.dart';
import 'courses_list.dart';
import 'deadlines_list.dart';
import 'task_detail.dart';
import 'task_form.dart';

const double wideBreakpoint = 840;

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final List<Task> _tasks = buildSampleTasks();
  int _selectedIndex = 0;
  int? _selectedTaskId;

  Course? _courseOf(Task task) {
    return sampleCourses
        .where((course) => course.id == task.courseId)
        .firstOrNull;
  }

  void _markDone(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    setState(() => _tasks[index] = task.copyWith(done: true));
  }

  void _openDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          course: _courseOf(task),
          onMarkDone: () {
            _markDone(task);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openForm() async {
    final task = await Navigator.of(context).push<Task>(
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(
          courses: sampleCourses,
          nextId: _tasks.length + 1,
        ),
      ),
    );
    if (task == null || !mounted) return;

    setState(() => _tasks.add(task));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deadline added')),
    );
  }

  Widget _buildWideLayout() {
    final selected =
        _tasks.where((task) => task.id == _selectedTaskId).firstOrNull;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DeadlinesList(
            tasks: _tasks,
            courses: sampleCourses,
            selectedId: _selectedTaskId,
            onTaskTap: (task) => setState(() => _selectedTaskId = task.id),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: selected == null
              ? const Center(child: Text('Select a deadline'))
              : TaskDetailView(
                  task: selected,
                  course: _courseOf(selected),
                  onMarkDone: () => _markDone(selected),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final onDeadlines = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text(onDeadlines ? 'Deadlines' : 'Courses')),
      body: onDeadlines
          ? LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < wideBreakpoint) {
                  return DeadlinesList(
                    tasks: _tasks,
                    courses: sampleCourses,
                    onTaskTap: _openDetail,
                  );
                }
                return _buildWideLayout();
              },
            )
          : const CoursesList(courses: sampleCourses),
      floatingActionButton: onDeadlines
          ? FloatingActionButton(
              onPressed: _openForm,
              tooltip: 'Add a deadline',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Deadlines'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Courses'),
        ],
      ),
    );
  }
}
