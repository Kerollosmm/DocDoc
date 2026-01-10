import 'package:csms/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csms/features/auth/presentation/pages/login_page.dart';
import 'package:csms/features/attendance/presentation/pages/attendance_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggingIn = state.uri.toString() == '/login';

      if (authState is AuthAuthenticated) {
        if (isLoggingIn) return '/attendance';
      } else if (authState is AuthUnauthenticated || authState is AuthInitial) {
         // If initially loading, we might want to stay on splash or login.
         // Assuming CheckUserEvent runs early.
         if (!isLoggingIn) return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/attendance',
        builder: (context, state) => const AttendancePage(),
      ),
    ],
  );
}
