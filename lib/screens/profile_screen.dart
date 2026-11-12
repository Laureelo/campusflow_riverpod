import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              user.name.substring(0, 1),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(user.email),
          Text('${user.age} years old'),
        ],
      ),
    );
  }
}
