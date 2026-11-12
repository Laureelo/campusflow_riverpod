import 'package:campusflow_riverpod/providers/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('starts with the sample tasks', () {
    expect(container.read(tasksProvider), hasLength(4));
  });

  test('add gives the new task the next id', () {
    final before = container.read(tasksProvider);

    container.read(tasksProvider.notifier).add(
          title: 'Write the report',
          dueDate: DateTime(2026, 12, 1),
          courseId: 10,
        );

    final after = container.read(tasksProvider);
    expect(after, hasLength(before.length + 1));
    expect(after.last.id, 5);
    expect(after.last.done, isFalse);
  });

  test('toggle flips only the chosen task and replaces the list', () {
    final before = container.read(tasksProvider);

    container.read(tasksProvider.notifier).toggle(1);

    final after = container.read(tasksProvider);
    expect(identical(before, after), isFalse);
    expect(after.firstWhere((t) => t.id == 1).done, isTrue);
    expect(after.firstWhere((t) => t.id == 2).done, isFalse);
    expect(before.firstWhere((t) => t.id == 1).done, isFalse);
  });

  test('markDone keeps a done task done', () {
    container.read(tasksProvider.notifier).markDone(4);

    expect(container.read(tasksProvider).firstWhere((t) => t.id == 4).done, isTrue);
  });
}
