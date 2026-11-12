import '../models/course.dart';
import '../models/task.dart';

const List<Course> sampleCourses = [
  Course(id: 10, name: 'Mobile Programming', teacher: 'Mr. Moctar'),
  Course(id: 11, name: 'Databases', teacher: 'Mrs. Diallo'),
  Course(id: 12, name: 'Networks', teacher: 'Mr. Traore'),
];

List<Task> buildSampleTasks() {
  final now = DateTime.now();
  return [
    Task(
      id: 1,
      title: 'Submit the Flutter assignment',
      dueDate: now.add(const Duration(days: 3)),
      courseId: 10,
    ),
    Task(
      id: 2,
      title: 'Review the SQL joins',
      dueDate: now.subtract(const Duration(days: 2)),
      courseId: 11,
    ),
    Task(
      id: 3,
      title: 'Prepare the networks quiz',
      dueDate: now.add(const Duration(days: 7)),
      courseId: 12,
    ),
    Task(
      id: 4,
      title: 'Read chapter 4',
      dueDate: now.subtract(const Duration(days: 5)),
      done: true,
      courseId: 10,
    ),
  ];
}
