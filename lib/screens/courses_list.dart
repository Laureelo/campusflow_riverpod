import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/courses_provider.dart';

class CoursesList extends ConsumerWidget {
  const CoursesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return ListTile(
          leading: const Icon(Icons.menu_book),
          title: Text(course.name),
          subtitle: Text(course.teacher),
        );
      },
    );
  }
}
