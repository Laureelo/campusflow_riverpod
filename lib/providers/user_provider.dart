import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';
import '../models/user.dart';

final userProvider = Provider<User>((ref) => sampleUser);
