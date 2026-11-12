import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;
  int? _selectedTaskId;

  void _openDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    );
  }

  Future<void> _openForm() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const TaskFormScreen()),
    );
    if (added != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deadline added')),
    );
  }

  Widget _buildWideLayout() {
    final selectedId = _selectedTaskId;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DeadlinesList(
            selectedId: selectedId,
            onTaskTap: (task) => setState(() => _selectedTaskId = task.id),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: selectedId == null
              ? const Center(child: Text('Select a deadline'))
              : TaskDetailView(taskId: selectedId),
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
                  return DeadlinesList(onTaskTap: _openDetail);
                }
                return _buildWideLayout();
              },
            )
          : const CoursesList(),
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
