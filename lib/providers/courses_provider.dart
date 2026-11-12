import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';
import '../models/course.dart';

final coursesProvider = Provider<List<Course>>((ref) => sampleCourses);
