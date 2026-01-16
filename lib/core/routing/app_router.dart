import 'package:go_router/go_router.dart';
import 'package:doc_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/home';

  final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Placeholder for other routes
    ],
  );
}
