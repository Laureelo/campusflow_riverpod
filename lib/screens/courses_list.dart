import 'package:flutter/material.dart';

import '../models/course.dart';

class CoursesList extends StatelessWidget {
  final List<Course> courses;

  const CoursesList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
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
