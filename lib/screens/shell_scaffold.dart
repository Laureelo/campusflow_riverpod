import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const List<String> _paths = ['/tasks', '/courses', '/profile'];
const List<String> _titles = ['Deadlines', 'Courses', 'Profile'];

class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  int _indexOf(String location) {
    final index = _paths.indexWhere((path) => location.startsWith(path));
    return index == -1 ? 0 : index;
  }

  Future<void> _addTask(BuildContext context) async {
    final added = await context.push<bool>('/tasks/new');
    if (added != true || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deadline added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexOf(location);

    return Scaffold(
      appBar: AppBar(title: Text(_titles[index])),
      body: child,
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () => _addTask(context),
              tooltip: 'Add a deadline',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_paths[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Deadlines'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
