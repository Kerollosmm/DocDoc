import 'package:doc_app/core/routing/routes.dart';
import 'package:doc_app/features/attendance/presentation/attendance_history_screen.dart';
import 'package:doc_app/features/attendance/presentation/attendance_screen.dart';
import 'package:doc_app/features/dashboard/presentation/servant_dashboard_screen.dart';
import 'package:doc_app/features/dashboard/presentation/student_dashboard_screen.dart';
import 'package:doc_app/features/login/ui/login_screen.dart';
import 'package:doc_app/features/onboarding/onboarding_screen.dart';
import 'package:doc_app/features/results/presentation/results_screen.dart';
import 'package:doc_app/features/role_gate/presentation/role_gate_screen.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/presentation/student_profile_screen.dart';
import 'package:doc_app/features/students/presentation/students_list_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.roleGateScreen:
        return MaterialPageRoute(builder: (_) => const RoleGateScreen());
      case Routes.servantDashboard:
        return MaterialPageRoute(builder: (_) => const ServantDashboardScreen());
      case Routes.studentDashboard:
        return MaterialPageRoute(builder: (_) => const StudentDashboardScreen());
      case Routes.studentsListScreen:
        return MaterialPageRoute(builder: (_) => const StudentsListScreen());
      case Routes.studentProfileScreen:
        final student = settings.arguments as StudentEntity? ??
            const StudentEntity(id: 'S1001', name: 'Sara Ali', grade: 'Grade 10', group: 'A');
        return MaterialPageRoute(builder: (_) => StudentProfileScreen(student: student));
      case Routes.attendanceScreen:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case Routes.attendanceHistoryScreen:
        return MaterialPageRoute(builder: (_) => const AttendanceHistoryScreen());
      case Routes.resultsScreen:
        return MaterialPageRoute(builder: (_) => const ResultsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No Route Found for ${settings.name}')),
          ),
        );
    }
  }
}
