import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'deadlines_list.dart';
import 'task_detail.dart';

const double wideBreakpoint = 840;

class DeadlinesScreen extends StatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  State<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends State<DeadlinesScreen> {
  int? _selectedTaskId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < wideBreakpoint) {
          return DeadlinesList(
            onTaskTap: (task) => context.push('/tasks/${task.id}'),
          );
        }

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
      },
    );
  }
}
