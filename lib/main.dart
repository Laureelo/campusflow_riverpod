import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: CampusFlowApp()));
}

class CampusFlowApp extends StatefulWidget {
  const CampusFlowApp({super.key});

  @override
  State<CampusFlowApp> createState() => _CampusFlowAppState();
}

class _CampusFlowAppState extends State<CampusFlowApp> {
  final GoRouter _router = buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: _router,
    );
  }
}
